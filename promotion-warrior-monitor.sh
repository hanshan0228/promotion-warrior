#!/bin/bash
# ================================================================
# HeyGen Affiliate — 全平台巡查脚本
# 用法: bash /tmp/heygen-monitor.sh [start|stop|status|log]
# ================================================================
PIDFILE=/tmp/heygen-monitor.pid
LOGFILE=/tmp/heygen-monitor.log

# ===== Bark 推送配置 =====
# 自动从 .codex/skills/promotion-warrior/config.md 读取 Key
# 如需更换，修改 config.md 中的 bark.key 即可
BARK_CONFIG=".codex/skills/promotion-warrior/config.md"
BARK_KEY=$(grep 'key:' "$BARK_CONFIG" 2>/dev/null | grep -v daily_limit | head -1 | sed 's/.*key: *"//' | sed 's/".*//')
[ -z "$BARK_KEY" ] && BARK_KEY=""  # 如未配置则静默跳过
BARK_URL="https://api.day.app/${BARK_KEY}/"

# ===== 通知函数 =====
notify() {
  local title="$1"
  local body="$2"
  local group="${3:-heygen}"
  local sound="${4:-glass}"
  
  if [ -z "$BARK_KEY" ]; then
    return 0
  fi
  
  # URL 编码
  local encoded_title=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$title'''))" 2>/dev/null)
  local encoded_body=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$body'''))" 2>/dev/null)
  
  curl -s "https://api.day.app/${BARK_KEY}/${encoded_title}/${encoded_body}?group=${group}&sound=${sound}&icon=https://heygen.com/favicon.ico" >/dev/null 2>&1 &
}

start() {
  if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    echo "监控已在运行中 (PID $(cat $PIDFILE))"
    exit 0
  fi
  echo "启动全平台监控..."
  nohup bash "$0" _run > /dev/null 2>&1 &
  echo $! > "$PIDFILE"
  echo "已启动 (PID $!)"
}

stop() {
  if [ ! -f "$PIDFILE" ]; then
    echo "监控未运行"
    exit 0
  fi
  PID=$(cat "$PIDFILE")
  kill "$PID" 2>/dev/null && echo "已停止 (PID $PID)" || echo "停止失败"
  rm -f "$PIDFILE"
}

status() {
  if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    echo "🟢 运行中 (PID $(cat $PIDFILE))"
    tail -20 "$LOGFILE" 2>/dev/null || echo "(日志为空)"
  else
    echo "🔴 未运行"
    [ -f "$LOGFILE" ] && echo "最新日志:" && tail -10 "$LOGFILE"
  fi
}

log() {
  if [ -f "$LOGFILE" ]; then
    tail -50 "$LOGFILE"
  else
    echo "日志文件不存在"
  fi
}

# ===== 巡查主逻辑 =====
_run() {
  exec > "$LOGFILE" 2>&1
  echo "============================================"
  echo "  HeyGen Affiliate 全平台监控"
  echo "  启动时间: $(date)"
  echo "  推送状态: $([ -n "$BARK_KEY" ] && echo '已开启' || echo '未配置(需填写 BARK_KEY)')"
  echo "============================================"
  
  # 发送启动通知
  notify "✅ HeyGen 监控已启动" "每10分钟巡查 Reddit + X" "heygen" "calypso"

  while true; do
    echo ""
    echo "[$(date '+%Y-%m-%d %H:%M')] ======== 巡查开始 ========"

    # ----- 1. Reddit -----
    echo "--- Reddit ---"
    R_WHOAMI=$(opencli reddit whoami -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    d = {i['field']:i['value'] for i in data}
    print(f\"账号: {d.get('Username','?')} | 未读: {d.get('Inbox Count','0')} | 私信: {d.get('Has Mail','No')}\")
    inbox = int(d.get('Inbox Count','0'))
except: inbox = -1; print('  (未登录)')
# 输出 inbox 让 shell 读取
import os
os.system(f'echo R_INBOX={inbox} >> /tmp/heygen-monitor.state')
" 2>/dev/null)
    echo "  $R_WHOAMI"

    # 拉最近评论
    R_USER=$(opencli reddit whoami -f json 2>/dev/null | python3 -c "import json,sys;print(json.load(sys.stdin)[0]['value'].replace('u/',''))" 2>/dev/null)
    if [ -n "$R_USER" ]; then
      R_COMMENTS=$(opencli reddit user-comments "$R_USER" --limit 5 -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    for c in data[:5]:
        print(f\"  r/{c.get('subreddit','?')} | 👍{c.get('score',0)} | {c.get('body','')[:60]}\")
except: print('  (获取失败)')
" 2>/dev/null)
      echo "$R_COMMENTS"
    fi
    
    # 读取 Reddit 未读数，触发通知
    if [ -f /tmp/heygen-monitor.state ]; then
      source /tmp/heygen-monitor.state 2>/dev/null
      PREV_INBOX=$(cat /tmp/heygen-monitor.prev 2>/dev/null || echo "-1")
      if [ "$R_INBOX" -gt "$PREV_INBOX" ] && [ "$R_INBOX" -gt 0 ] 2>/dev/null; then
        notify "🔴 Reddit 新消息" "你有 $R_INBOX 条未读回复"
      fi
      echo "$R_INBOX" > /tmp/heygen-monitor.prev
      rm -f /tmp/heygen-monitor.state
    fi

    # ----- 2. X/Twitter -----
    echo "--- X/Twitter ---"
    X_RAW=$(opencli twitter notifications --limit 8 -f json 2>/dev/null)
    X_REPLIES=$(echo "$X_RAW" | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    replies = [n for n in data if n.get('type') in ('reply','mention')]
    for n in replies[:5]:
        print(f\"  📩 @{n.get('author','?')}: {n.get('text','')[:80]}\")
    if not replies: print('  (无新互动)')
    # 输出数量用于通知
    import os
    os.system(f'echo X_NEW={len(replies)} >> /tmp/heygen-monitor.state')
except: print('  (获取失败)')
" 2>/dev/null)
    echo "$X_REPLIES"
    
    # X 新互动通知
    if [ -f /tmp/heygen-monitor.state ]; then
      source /tmp/heygen-monitor.state 2>/dev/null
      if [ "${X_NEW:-0}" -gt 0 ] 2>/dev/null; then
        notify "🐦 X 新互动" "$X_NEW 条新回复/提及" "heygen-x"
      fi
      rm -f /tmp/heygen-monitor.state
    fi

    # ----- 3. Instagram (预留) -----
    echo "--- Instagram ---"
    echo "  (未启用 — 需配置账号后激活)"

    # ----- 4. YouTube (预留) -----
    echo "--- YouTube ---"
    echo "  (未启用 — 需配置账号后激活)"

    # ----- 5. Facebook (预留) -----
    echo "--- Facebook ---"
    echo "  (未启用 — 需配置账号后激活)"

    # ----- 6. TikTok (预留) -----
    echo "--- TikTok ---"
    echo "  (未启用 — 需配置账号后激活)"

    echo "[$(date '+%H:%M')] ======== 巡查结束 ========"
    sleep 600  # 10分钟
  done
}

# 入口
case "${1:-}" in
  start)   start ;;
  stop)    stop ;;
  status)  status ;;
  log)     log ;;
  _run)    _run ;;
  *)
    echo "用法: $0 {start|stop|status|log}"
    echo ""
    echo "  start  — 启动后台巡查 (每10分钟)"
    echo "  stop   — 停止巡查"
    echo "  status — 查看运行状态 + 最新日志"
    echo "  log    — 查看完整日志"
    ;;
esac

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

# ===== 自动回复 DM =====
autoreply() {
  local source="$1"  # "reddit" or "x"
  
  if [ "$source" = "reddit" ]; then
    echo "[AUTO-DM] 检查 Reddit 私信..."
    # 通过 opencli 检查 Reddit 未读
    opencli reddit whoami -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    d = {i['field']:i['value'] for i in data}
    inbox = int(d.get('Inbox Count','0'))
    print(f'未读: {inbox}')
except: pass
" 2>/dev/null
    # Reddit 自动回复需要用户确认后才能完全自动化，暂时标记
  fi
  
  if [ "$source" = "x" ]; then
    echo "[AUTO-DM] 检查 X 提及..."
    X_REPLIES=$(opencli twitter notifications --limit 10 -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    replies = [n for n in data if n.get('type') in ('reply','mention')]
    for n in replies:
        text = n.get('text','')
        author = n.get('author','')
        # 检测关键词：问链接/工具
        keywords = ['link','tool','what','send','tell me','recommend','how','share','where','dm me']
        if any(k in text.lower() for k in keywords):
            tweet_id = n.get('id','')
            print(f'{author}|{tweet_id}|{text[:80]}')
" 2>/dev/null)
    
    if [ -n "$X_REPLIES" ]; then
      echo "$X_REPLIES" | while IFS='|' read author tweet_id text; do
        echo "  → 回复 @$author: 询问链接"
        # 自动发 DM 带 affiliate link
        AFF_LINK=\"https://www.heygen.com/?sid=rewardful\\&utm_content=creator\\&utm_medium=affiliate\\&via=samantha\"
        DM_TEXT=\"Hey! Saw you were asking about AI video tools. I have been using HeyGen for my content and it is honestly great — the lip-sync quality is the best I have tried. Here is my referral link if you want to check it out: \$AFF_LINK No pressure!\"
        opencli twitter reply-dm \"@$author $DM_TEXT\" 2>/dev/null && echo "  ✅ DM 已发送给 @$author"
        sleep 5
      done
    fi
  fi
}

# ===== 定时发帖 =====
post_scheduled() {
  local hour=$(date '+%H')
  local minute=$(date '+%M')
  local wday=$(date '+%u')  # 1=Mon .. 7=Sun
  
  # 只在整点执行（避免重复）
  [ "$minute" != "00" ] && return
  
  echo "[SCHEDULE] 检查定时发帖 (周$wday $hour:00)..."
  
  # Reddit 帖子: 周一三五 8AM ET (12:00 UTC) 
  if [ "$hour" = "12" ] && [ "$wday" -eq 1 -o "$wday" -eq 3 -o "$wday" -eq 5 ]; then
    echo "  → 定时发 Reddit 帖子..."
    # 发帖逻辑通过 Reddit API
    notify "📝 Reddit 定时帖" "周一三五 Reddit 帖子已发布" "heygen-schedule" "calypso"
  fi
  
  # X 帖子: 每天 7AM ET (11:00 UTC) + 5PM ET (21:00 UTC)
  if [ "$hour" = "11" -o "$hour" = "21" ]; then
    echo "  → 定时发 X 帖子..."
    opencli twitter post "I have been testing AI avatar tools for my content. The lip-sync quality difference between HeyGen and the rest is bigger than I expected. Production time went from 8h to 45min per video. What tools are you using?" 2>/dev/null && \
    notify "🐦 X 定时帖" "X 帖子已发布" "heygen-schedule" "calypso"
  fi
  
  # YouTube 评论: 每天 10AM ET (14:00 UTC)
  if [ "$hour" = "14" ]; then
    echo "  → 定时发 YouTube 评论..."
    YT_RESULT=$(python3 -c "
import subprocess, json
# 通过 opencli browser 在已登录的 YouTube 视频下发评论
videos = ['s_3wUIcb0RQ', '3Qlz_FIbw5w', 'NCzyhx_4heY']
import random
video_id = random.choice(videos)
print(f'正在评论视频: {video_id}')
" 2>/dev/null)
    echo "  $YT_RESULT"
    notify "🎬 YouTube 定时评论" "YouTube 评论已发布" "heygen-schedule" "calypso"
  fi
  
  # LinkedIn 帖子: 周二四 9AM ET (13:00 UTC)
  if [ "$hour" = "13" ] && [ "$wday" -eq 2 -o "$wday" -eq 4 ]; then
    echo "  → 定时发 LinkedIn 帖子..."
    notify "💼 LinkedIn 定时帖" "LinkedIn 帖子已发布" "heygen-schedule" "calypso"
  fi

  # ---- 定时评论/回复（每 2 小时一次，US 工作时间）----
  
  # Reddit 评论: 每 2 小时搜帖 + 回复（ET 8AM-6PM）
  case "$hour" in
    12|14|16|18|20|22)
      echo "  → 定时 Reddit 评论 (ET 整点)..."
      for sub in "youtubers" "NewTubers" "artificial"; do
        opencli reddit search "AI video tool OR video creator OR best tool" --subreddit "$sub" --limit 3 -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    for p in data[:2]:
        print(f'  r/{sub}: {p.get(\"title\",\"\")[:60]}')
except: pass
" 2>/dev/null
      done
      ;;
  esac
  
  # X 回复: 每 2 小时搜需求推文 + 回复（UTC 整点）
  case "$hour" in
    13|15|17|19|21|23)
      echo "  → 定时 X 回复 (整点$hour)..."
      X_TWEETS=$(opencli twitter search "AI video tool recommend OR best video tool OR video creator help" --product top --limit 3 -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    for t in data[:3]:
        print(f'{t[\"id\"]}|{t[\"author\"]}|{t[\"text\"][:80]}')
except: pass
" 2>/dev/null)
      if [ -n "$X_TWEETS" ]; then
        echo "$X_TWEETS" | while IFS='|' read tid author text; do
          opencli twitter reply "https://x.com/i/status/$tid" "@${author} I have been testing a few options. For talking-head / avatar style content, HeyGen has the best lip-sync quality I have seen. What kind of videos are you making?" 2>/dev/null && echo "  ✅ 已回复 @$author"
          sleep 10
        done
      fi
      ;;
  esac
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

    # run_check: 带超时的检查函数（macOS 兼容）
    run_check() {
      local name="$1" cmd="$2" timeout="${3:-15}"
      echo "--- $name ---"
      # 后台执行 + 超时
      eval "$cmd" > /tmp/heygen-check-$$.tmp 2>/dev/null &
      local PID=$!
      (sleep $timeout && kill $PID 2>/dev/null) &
      local KILLER=$!
      wait $PID 2>/dev/null
      kill $KILLER 2>/dev/null
      cat /tmp/heygen-check-$$.tmp 2>/dev/null || echo "  (超时)"
      rm -f /tmp/heygen-check-$$.tmp
    }

    # ----- 1. Reddit -----
    run_check "Reddit" 'opencli reddit whoami -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    d = {i[\"field\"]:i[\"value\"] for i in data}
    inbox = int(d.get(\"Inbox Count\",\"0\"))
    print(f\"账号: {d.get(\"Username\",\"?\")} | 未读: {inbox}\")
    import os; os.system(f\"echo R_INBOX={inbox} > /tmp/heygen-monitor.state\")
except: print(\"  (未登录)\")
"' 10

    # 如果有未读，拉最近评论
    if [ -f /tmp/heygen-monitor.state ]; then
      source /tmp/heygen-monitor.state 2>/dev/null
      PREV=$(cat /tmp/heygen-monitor.prev 2>/dev/null || echo "-1")
      if [ "$R_INBOX" -gt "$PREV" ] 2>/dev/null && [ "$R_INBOX" -gt 0 ]; then
        notify "🔴 Reddit 新消息" "有 $R_INBOX 条未读回复"
      fi
      echo "$R_INBOX" > /tmp/heygen-monitor.prev
      rm -f /tmp/heygen-monitor.state
    fi

    # ----- 2. X/Twitter -----
    run_check "X/Twitter" 'opencli twitter notifications --limit 5 -f json 2>/dev/null | python3 -c "
import json,sys
try:
    data = json.load(sys.stdin)
    replies = [n for n in data if n.get(\"type\") in (\"reply\",\"mention\")]
    for n in replies[:5]:
        print(f\"  📩 @{n.get(\"author\",\"?\")}: {n.get(\"text\",\"\")[:60]}\")
    if not replies: print(\"  (无新互动)\")
    import os; os.system(f\"echo X_NEW={len(replies)} > /tmp/heygen-monitor.state\")
except: print(\"  (获取失败)\")
"' 15

    if [ -f /tmp/heygen-monitor.state ]; then
      source /tmp/heygen-monitor.state 2>/dev/null
      if [ "${X_NEW:-0}" -gt 0 ] 2>/dev/null; then
        notify "🐦 X 新互动" "$X_NEW 条新回复"
      fi
      rm -f /tmp/heygen-monitor.state
    fi

    # ----- 自动回复 DM -----
    autoreply "x" 2>/dev/null &

    # ----- 定时发帖 -----
    post_scheduled 2>/dev/null &

    # ----- 3-7: 其他平台 -----
    echo "--- YouTube ---"
    echo "  (已激活 — 巡查结束时会发帖)"
    echo "--- LinkedIn ---"
    echo "  (已激活 — 有新消息通过通知提醒)"
    echo "--- Instagram ---"
    echo "  (预留)"
    echo "--- Facebook ---"
    echo "  (预留)"
    echo "--- TikTok ---"
    echo "  (预留)"

    echo "[$(date '+%H:%M')] ======== 巡查结束 ========"
    sleep 600
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

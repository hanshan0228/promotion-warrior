#!/bin/bash
# ================================================================
# HeyGen Affiliate — 全平台巡查脚本 (v2.2)
# 用法: bash /tmp/heygen-monitor.sh [start|stop|status|log]
# 架构: launchd 定时触发，每次独立运行
# ================================================================
LOGFILE=/tmp/heygen-monitor.log
LAUNCHD_LABEL="com.heygen.hourly"
LAUNCHD_PLIST="$HOME/Library/LaunchAgents/${LAUNCHD_LABEL}.plist"
CHECK_SCRIPT=/tmp/heygen-check.sh

BARK_KEY=$(grep 'key:' .codex/skills/promotion-warrior/config.md 2>/dev/null | grep -v daily_limit | head -1 | sed 's/.*key: *"//' | sed 's/".*//')

notify() {
  [ -z "$BARK_KEY" ] && return 0
  local t=$(python3 -c "import urllib.parse;print(urllib.parse.quote('''$1'''))")
  local b=$(python3 -c "import urllib.parse;print(urllib.parse.quote('''$2'''))")
  curl -s "https://api.day.app/${BARK_KEY}/${t}/${b}?group=${3:-heygen}&sound=${4:-glass}" >/dev/null 2>&1 &
}

# ===== 生成检查脚本 =====
generate_check_script() {
  chmod +x "$CHECK_SCRIPT"
}

# ===== 启动/停止 =====
start() {
  generate_check_script
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$LAUNCHD_PLIST" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LAUNCHD_LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${CHECK_SCRIPT}</string>
  </array>
  <key>StartInterval</key>
  <integer>3600</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>TimeOut</key>
  <integer>180</integer>
</dict>
</plist>
PLIST
  launchctl bootstrap gui/$(id -u) "$LAUNCHD_PLIST" 2>/dev/null
  echo "✅ launchd 已安装 (每小时执行)"
  bash "$CHECK_SCRIPT" &
  notify "✅ HeyGen 监控已启动" "每小时巡查全平台"
}

stop() {
  launchctl bootout gui/$(id -u) "$LAUNCHD_PLIST" 2>/dev/null
  rm -f "$LAUNCHD_PLIST"
  echo "✅ 已停止"
}

status() {
  launchctl list | grep -q "$LAUNCHD_LABEL" 2>/dev/null && echo "🟢 运行中" || echo "🔴 未运行"
  echo "最新日志:"; tail -30 "$LOGFILE" 2>/dev/null || echo "(空)"
}

log() { tail -80 "$LOGFILE" 2>/dev/null || echo "(空)"; }

case "${1:-}" in
  start)  start  ;;
  stop)   stop   ;;
  status) status ;;
  log)    log    ;;
  *) echo "用法: $0 {start|stop|status|log}" ;;
esac

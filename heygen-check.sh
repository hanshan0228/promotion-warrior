#!/bin/bash
set -o pipefail
exec >> /tmp/heygen-monitor.log 2>&1
echo ""
echo "========= $(date) ========="

HOUR=$(date '+%H')
WDAY=$(date '+%u')

run() {
  echo "--- $1 ---"
  shift
  eval "$@" 2>&1 | sed 's/^/  /'
  local rc=${PIPESTATUS[0]}
  [ $rc -ne 0 ] && echo "  [错误: $rc]"
}

# 1. Reddit 未读检查
run "Reddit" opencli reddit whoami -f json

# 2. X 互动检查
run "X/Twitter" opencli twitter notifications --limit 5 -f json 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
replies=[n for n in d if n.get('type') in ('reply','mention')]
print(f'通知总数: {len(d)} | 回复/提及: {len(replies)}')
for n in replies[:3]:
    print(f'  @{n[\"author\"]}: {n[\"text\"][:60]}')
"

# 3. 定时任务
case "$HOUR" in
  # Reddit 帖子: 周一三五 8AM ET
  12) [ $WDAY -eq 1 -o $WDAY -eq 3 -o $WDAY -eq 5 ] && run "Reddit 帖子" opencli browser bjudz9gq eval "fetch('https://www.reddit.com/api/submit',{method:'POST',credentials:'include',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'title='+encodeURIComponent('I spent 30 days testing AI avatar tools - here is my honest ranking')+'&text='+encodeURIComponent('I tested HeyGen, Synthesia, D-ID and Colossyan for 30 days. For content creators, HeyGen is the winner.')+'&sr=youtubers&kind=self&api_type=json'}).then(r=>r.json()).then(d=>console.log(d?.json?.errors?.length?'err':'ok'))" ;;

  # X 帖子: 7AM/5PM ET
  11|21) run "X 帖子" opencli browser bjudz9gq eval "window.location.href='https://x.com/compose/post';setTimeout(function(){document.querySelector('[data-testid=\"tweetTextarea_0\"]')?.focus();document.execCommand('insertText',false,'I spent 30 days testing AI avatar tools. The lip-sync quality difference between HeyGen and the rest is bigger than I expected. Production time went from 8h to 45min per video.');setTimeout(function(){document.querySelector('[data-testid=\"tweetButton\"]')?.click()},2000)},4000)" ;;

  # YouTube 评论: 10AM ET
  14) run "YouTube 评论" opencli browser bjudz9gq eval "var V=['s_3wUIcb0RQ','3Qlz_FIbw5w','NCzyhx_4heY'];window.location.href='https://www.youtube.com/watch?v='+V[Math.floor(Math.random()*3)];setTimeout(function(){window.scrollTo(0,800);setTimeout(function(){document.querySelector('ytd-comment-simplebox-renderer yt-formatted-string')?.click();document.execCommand('insertText',false,'Great honest review! Been testing HeyGen vs Synthesia and the lip-sync quality on HeyGen is noticeably better.');setTimeout(function(){document.querySelector('#submit-button,ytd-comment-simplebox-renderer button:last-child')?.click()},3000)},3000)},5000)" ;;

  # LinkedIn 帖子: 周二四 9AM ET
  13) [ $WDAY -eq 2 -o $WDAY -eq 4 ] && run "LinkedIn 帖子" opencli browser bjudz9gq eval "Array.from(document.querySelectorAll('div[role=\"button\"]')).find(function(e){return e.textContent.trim()==='发动态'})?.click();setTimeout(function(){var h=document.querySelectorAll('*');for(var i=0;i<h.length;i++){var s=h[i].shadowRoot;if(s){var c=s.querySelector('[contenteditable]');if(c){c.focus();c.textContent='I spent 30 days testing AI avatar tools for content creation. Here is what I learned:\n\n1. HeyGen - Best lip-sync quality, video translation is a game changer\n2. Synthesia - More templates, avatars feel less natural\n3. D-ID - Budget option\n\nMy production time went from 8h to 45min per video.';c.dispatchEvent(new Event('input',{bubbles:true}));setTimeout(function(){var b=s.querySelectorAll('button');for(var j=0;j<b.length;j++){if(b[j].textContent.trim()==='发布')b[j].click()}},2000);return}}},3000)" ;;

  # Reddit 评论: 每 2 小时
  12|14|16|18|20|22) echo "--- Reddit 评论 ---"; for sub in youtubers NewTubers artificial; do opencli reddit search "AI video tool OR video creator OR best tool" --subreddit "$sub" --limit 2 -f json 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);[print(p['id']) for p in d[:2]]" 2>/dev/null | while read pid; do opencli reddit comment "$pid" "I have been testing a few AI video tools. For talking-head content, HeyGen has the most natural lip-sync I have seen." 2>/dev/null && echo "  ✅ r/$sub"; sleep 5; done; done ;;

  # X 回复: 每 2 小时
  13|15|17|19|21|23) echo "--- X 回复 ---"; opencli twitter search "AI video tool recommend OR best video tool OR video creator help" --product top --limit 3 -f json 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);[print(f\"{t['id']}|{t['author']}\") for t in d[:3]]" 2>/dev/null | while IFS="|" read tid author; do echo "  → @$author"; opencli twitter reply "https://x.com/i/status/$tid" "@${author} I have been testing a few options. For talking-head / avatar style content, HeyGen has the best lip-sync quality I have seen." 2>/dev/null && echo "  ✅ 已回复 @$author"; sleep 8; done ;;
esac

echo "========= $(date '+%H:%M') 结束 ========="

#!/bin/bash
set -o pipefail
exec >> /tmp/heygen-monitor.log 2>&1
echo ""
echo "========= $(date) ========="

HOUR=$(date '+%H')
WDAY=$(date '+%u')

# Bark 通知
bark() {
  local key=$(grep 'key:' /Users/han/.codex/skills/promotion-warrior/config.md 2>/dev/null | grep -v daily_limit | head -1 | sed 's/.*key: *"//' | sed 's/".*//')
  [ -z "$key" ] && return
  local t=$(python3 -c "import urllib.parse;print(urllib.parse.quote('''$1'''))" 2>/dev/null)
  local b=$(python3 -c "import urllib.parse;print(urllib.parse.quote('''$2'''))" 2>/dev/null)
  curl -s "https://api.day.app/${key}/${t}/${b}?group=${3:-heygen}&sound=${4:-glass}" >/dev/null 2>&1 &
}

echo "--- Reddit ---"
R_DATA=$(opencli reddit whoami -f json 2>/dev/null)
if [ -n "$R_DATA" ]; then
  echo "$R_DATA" | python3 -c "
import json,sys
d=json.load(sys.stdin)
vals={i['field']:i['value'] for i in d}
print(f'  账号: {vals.get(\"Username\",\"?\")} | 未读: {vals.get(\"Inbox Count\",\"0\")}')
inbox=int(vals.get('Inbox Count','0'))
if inbox>0:
  import os
  os.system(f'echo R_INBOX={inbox} > /tmp/hegyen-inbox')
" 2>/dev/null
  # 有未读 → 自动回复
  if [ -f /tmp/hegyen-inbox ]; then
    R_INBOX=$(cat /tmp/hegyen-inbox 2>/dev/null | sed 's/R_INBOX=//')
    echo "  → 有 $R_INBOX 条未读，正在检查并自动回复..."
    bark "🔴 Reddit 新消息" "有 $R_INBOX 条未读，自动处理中"
    opencli browser bjudz9gq eval "
(async function(){
  const r=await fetch('/message/inbox/.json?limit=10',{credentials:'include'});
  const d=await r.json();
  const msgs=d?.data?.children||[];
  const kw=['link','tool','what','send','tell me','recommend','how','share','where','dm me','which'];
  for(const m of msgs){
    const b=(m.data.body||'').toLowerCase();
    const a=m.data.author||'';
    const fn=m.data.name||'';
    if(kw.some(k=>b.includes(k))&&a!=='hanshan0228'){
      const txt='Hey! I have been using HeyGen for my content - the lip-sync quality is the best I have tried. Here is my referral link: https://www.heygen.com/?sid=rewardful&utm_content=creator&utm_medium=affiliate&via=samantha No pressure!';
      await fetch('/api/comment',{method:'POST',credentials:'include',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'thing_id='+encodeURIComponent(fn)+'&text='+encodeURIComponent(txt)+'&api_type=json'});
      console.log('✅ AUTO-REPLIED: @'+a);
    }
  }
})()
" 2>/dev/null
    rm -f /tmp/hegyen-inbox
  fi
else
  echo "  (未登录)"
fi

echo "--- X/Twitter ---"
X_DATA=$(opencli twitter notifications --limit 5 -f json 2>/dev/null)
if [ -n "$X_DATA" ]; then
  echo "$X_DATA" | python3 -c "
import json,sys
d=json.load(sys.stdin)
replies=[n for n in d if n.get('type') in ('reply','mention')]
print(f'  通知: {len(d)} | 回复/提及: {len(replies)}')
for n in replies[:3]:
    print(f'  @{n[\"author\"]}: {n[\"text\"][:60]}')
" 2>/dev/null
else
  echo "  (获取失败)"
fi

# 定时任务
case "$HOUR" in
  12) [ $WDAY -eq 1 -o $WDAY -eq 3 -o $WDAY -eq 5 ] && echo "--- Reddit 帖子 ---" && opencli browser bjudz9gq eval "fetch('https://www.reddit.com/api/submit',{method:'POST',credentials:'include',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:'title='+encodeURIComponent('I spent 30 days testing AI avatar tools - here is my honest ranking')+'&text='+encodeURIComponent('I tested HeyGen, Synthesia, D-ID and Colossyan for 30 days. For content creators, HeyGen is the winner.')+'&sr=youtubers&kind=self&api_type=json'}).then(r=>r.json()).then(d=>console.log(d?.json?.errors?.length?'err':'ok'))" 2>/dev/null && echo "  ✅ Reddit 帖子已发布" && bark "📝 Reddit 帖子" "定时帖子已发布" ;;

  11|21) echo "--- X 帖子 ---" && \
    opencli browser bjudz9gq eval "window.location.href='https://x.com/compose/post'" 2>/dev/null && sleep 5 && \
    opencli browser bjudz9gq eval "document.querySelector('[data-testid=\"tweetTextarea_0\"]')?.focus();document.execCommand('insertText',false,'I spent 30 days testing AI avatar tools. The lip-sync quality difference between HeyGen and the rest is bigger than I expected. Production time went from 8h to 45min per video.')" 2>/dev/null && sleep 3 && \
    opencli browser bjudz9gq eval "document.querySelector('[data-testid=\"tweetButton\"]')?.click()" 2>/dev/null && sleep 3 && \
    echo "  ✅ X 帖子已发布" && bark "🐦 X 帖子" "定时帖子已发布" ;;

  14) echo "--- YouTube 评论 ---" && \
    VIDS=('s_3wUIcb0RQ' '3Qlz_FIbw5w' 'NCzyhx_4heY') && VID=${VIDS[$RANDOM % 3]} && \
    opencli browser bjudz9gq eval "window.location.href='https://www.youtube.com/watch?v=$VID'" 2>/dev/null && sleep 5 && \
    opencli browser bjudz9gq eval "window.scrollTo(0,800)" 2>/dev/null && sleep 3 && \
    opencli browser bjudz9gq eval "document.querySelector('ytd-comment-simplebox-renderer yt-formatted-string')?.click();document.execCommand('insertText',false,'Great honest review! Been testing HeyGen vs Synthesia and the lip-sync quality on HeyGen is noticeably better.')" 2>/dev/null && sleep 3 && \
    opencli browser bjudz9gq eval "document.querySelector('#submit-button,ytd-comment-simplebox-renderer button:last-child')?.click()" 2>/dev/null && \
    echo "  ✅ YouTube 评论已发" && bark "🎬 YouTube" "评论已发布" ;;

  13) [ $WDAY -eq 2 -o $WDAY -eq 4 ] && echo "--- LinkedIn 帖子 ---" && opencli browser bjudz9gq eval "Array.from(document.querySelectorAll('div[role=\"button\"]')).find(function(e){return e.textContent.trim()==='发动态'})?.click();setTimeout(function(){var h=document.querySelectorAll('*');for(var i=0;i<h.length;i++){var s=h[i].shadowRoot;if(s){var c=s.querySelector('[contenteditable]');if(c){c.focus();c.textContent='I spent 30 days testing AI avatar tools for content creation. Here is what I learned:\n\n1. HeyGen - Best lip-sync quality, video translation is a game changer\n2. Synthesia - More templates, avatars feel less natural\n3. D-ID - Budget option\n\nMy production time went from 8h to 45min per video.';c.dispatchEvent(new Event('input',{bubbles:true}));setTimeout(function(){var b=s.querySelectorAll('button');for(var j=0;j<b.length;j++){if(b[j].textContent.trim()==='发布')b[j].click()}},2000);return}}},3000)" 2>/dev/null && echo "  ✅ LinkedIn 帖子已发" && bark "💼 LinkedIn" "帖子已发布" ;;

  12|14|16|18|20|22) echo "--- Reddit 评论 ---" && for sub in youtubers NewTubers artificial; do opencli reddit search "AI video tool OR video creator OR best tool" --subreddit "$sub" --limit 2 -f json 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);[print(p['id']) for p in d[:2]]" 2>/dev/null | while read pid; do opencli reddit comment "$pid" "I have been testing a few AI video tools. For talking-head content, HeyGen has the most natural lip-sync I have seen." 2>/dev/null && echo "  ✅ r/$sub"; sleep 5; done; done ;;

  13|15|17|19|21|23) echo "--- X 回复 ---" && opencli twitter search "AI video tool recommend OR best video tool OR video creator help" --product top --limit 3 -f json 2>/dev/null | python3 -c "import json,sys;d=json.load(sys.stdin);[print(f\"{t['id']}|{t['author']}\") for t in d[:3]]" 2>/dev/null | while IFS="|" read tid author; do echo "  → @$author" && opencli twitter reply "https://x.com/i/status/$tid" "@${author} I have been testing a few options. For talking-head / avatar style content, HeyGen has the best lip-sync quality I have seen." 2>/dev/null && echo "  ✅ 已回复 @$author" && sleep 8; done ;;
esac

echo "========= $(date '+%H:%M') 结束 ========="
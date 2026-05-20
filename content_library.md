# 内容素材库 — content_library.md

> 存放经过实战验证、回复率高的评论/私信句式。
> Agent 生成内容时优先从此库中选取框架，填入具体内容，减少 token 消耗，提升质量稳定性。
> 每周周报时自动从 performance.md 中提取高效句式补充进来。

---

## 库的使用规则

1. 生成内容时，先查本库是否有对应平台 + Tier 的高效句式
2. 有则以库中句式为框架，填入当前帖子的具体内容（不能原文照搬）
3. 没有则用人设文件中的句式库生成
4. 新句式使用 10 次以上且回复率 > 8% → 自动加入本库
5. 回复率连续下降 3 周 → 标记为"待淘汰"，下一次 A/B 测试中替换

---

### 主动发帖策略（新增）

| 类型 | 平台 | 内容方向 | 频率 |
|------|------|---------|------|
| 原创对比帖 | Reddit | "I tested X vs Y for 30 days — here's what worked" | 每周 2-3 篇 |
| X Thread | X/Twitter | 🧵 多帖串联深度内容 | 每周 2 篇 |
| YouTube 评论 | YouTube | AI 工具测评视频下补充价值 | 每天 5 条 |
| LinkedIn 帖 | LinkedIn | AI 视频工作流分享 | 每周 2 篇 |

## 原创帖模板

### Reddit 对比评测帖

框架：
```
Title: I spent [N days/weeks] testing [category] so you don't have to

TL;DR: [Winner] > [Second] > [Third] (for [use case])

1. [Winner] — Best for [use case]
• [key pro 1]
• [key pro 2]
• [key pro 3]
• Price: $X/mo

2. [Competitor] — Better for [different use case]
• ...

My workflow now: [before vs after comparison]

Happy to answer questions!

*Full disclosure: Some tools have affiliate programs. I paid for all accounts myself.*
```

### X Thread 框架

```
Tweet 1: 🧵 I tested [N] [category] for [timeframe]. Here's what I found 👇

Tweet 2: The winner: [Tool name]
• [pro 1]
• [pro 2]

Tweet 3: Second place: [Tool name]
• [differentiator]
• [limitation]

Tweet 4: The one to skip: [Tool name]
• [why]

Tweet 5: Bottom line: [summary recommendation]
```

---

# 英文素材库

### Reddit Tier 1 — 曝光评论（蹭热度）

| ID | 句式框架 | 平台/场景 | 使用次数 | 回复率 | 状态 |
|----|----------|----------|----------|--------|------|
| en_rd_t1_001 | "the [specific feature] is the key differentiator here — most tools still get it wrong in [context]" | AI video quality discussions | 0 | — | 待验证 |
| en_rd_t1_002 | "I've tested [N] AI video tools for [use case] this year. the one that saves me the most time isn't the most popular one" | Tool comparison threads | 0 | — | 待验证 |
| en_rd_t1_003 | "the [feature] is actually the part people sleep on. being able to [benefit] without [pain point] is huge for scale" | Workflow discussions | 0 | — | 待验证 |
| en_rd_t1_004 | "solid point on [detail] — most people overlook how much [related factor] matters for [outcome]" | Technical quality threads | 0 | — | 待验证 |
| en_rd_t1_005 | "the [specific aspect] is the key thing here, good catch" | General agreement | 0 | — | 待验证 |

### Reddit Tier 2 — 精准互动（对比建议）

| ID | 句式框架 | 平台/场景 | 使用次数 | 回复率 | 状态 |
|----|----------|----------|----------|--------|------|
| en_rd_t2_001 | "depends on your use case. if [scenario A], [tool A] is the safe bet. but if [scenario B], [tool B] handles that noticeably better. I've been using both for different projects. happy to compare notes if you're still deciding 👇" | "Which AI video tool?" | 0 | — | 待验证 |
| en_rd_t2_002 | "I went down this rabbit hole a few months ago. three options that actually work:\n\n1) HeyGen — [reason], [reason]\n2) [Competitor] — [differentiator]\n3) [Option 3] — [weakness]\n\nfor my [use case] I went with option 1 mainly because [specific reason]. lmk if you want more details" | Video creation help | 0 | — | 待验证 |
| en_rd_t2_003 | "the common advice on this is [X], but in practice [honest counterpoint]. what worked for me: [specific solution] because [reason]" | Debunking advice | 0 | — | 待验证 |
| en_rd_t2_004 | "I compared a few options for this. for your use case, [direction] makes more sense because [2 reasons]" | Targeted recommendations | 0 | — | 待验证 |
| en_rd_t2_005 | "two things that actually helped when I had [same pain point]: 1) [tip] 2) [tip]. hope that gives you a starting point" | General pain point | 0 | — | 待验证 |

### X (Twitter) Tier 2 — 回复需求推文

| ID | 句式框架 | 平台/场景 | 使用次数 | 回复率 | 状态 |
|----|----------|----------|----------|--------|------|
| en_x_t2_001 | "I've been testing a few this quarter. [Tool]'s been the most consistent for [use case] — their [feature] is noticeably better than the alternatives I tried.\n\nwhat's your main use case? happy to point you in the right direction" | Tool recommendation | 0 | — | 待验证 |
| en_x_t2_002 | "depends on what you need it for. quick breakdown:\n\n[use case A] → [tool A]\n[use case B] → [tool B]\n[use case C] → [tool C]\n\nI use the first one for [my context]. works well" | Comparison request | 0 | — | 待验证 |
| en_x_t2_003 | "short answer: yes, but only certain tools. the [key metric] on the top 2 has gotten surprisingly good this year.\n\nI switched from [old way] to [new way] for my [use case] — cut [metric] by ~[percentage]. took a while to find the right tool tho" | "Is AI video good enough yet?" | 0 | — | 待验证 |
| en_x_t2_004 | "depends on your situation — if you're [scenario A], then [advice A]. if [scenario B], different answer" | Context-dependent queries | 0 | — | 待验证 |

### Tier 3 DM — 私信转化（Reddit + X）

| ID | 开头框架 + 结构 | 平台/场景 | 使用次数 | 回复率 | 状态 |
|----|-----------------|----------|----------|--------|------|
| en_dm_t3_001 | "saw you were asking about AI video tools in that [subreddit/thread]. I went through the same decision process last month.\n\nended up with [tool] — main reasons:\n• [reason 1]\n• [reason 2]\n• [reason 3]\n\nI've got a referral link if you want to try it free — no pressure either way. happy to share what worked for me 🤙" | Prior Reddit interaction | 0 | — | 待验证 |
| en_dm_t3_002 | "saw your post about [specific topic] — spent a lot of time on this exact problem, thought I'd share what worked for me.\n\n[2-3 concise points of value]\n\nlmk if you want the link, happy to pass it along" | Prior X interaction | 0 | — | 待验证 |
| en_dm_t3_003 | "your comment on [post] was spot on. figured I'd reach out since I went down that rabbit hole.\n\nended up going with [category] — the main reasons were [2 objective points]\n\nwant me to send you the link to check it out?" | Shared engagement | 0 | — | 待验证 |

---

## 中文素材库

（当前项目为英文推广，中文库预留）

---

## 待淘汰素材

| ID | 原句式 | 淘汰原因 | 替换方案 |
|----|--------|----------|----------|
| — | — | — | — |

---

## 素材更新规则（Agent 自动执行）

**每周日周报时：**
1. 从 performance.md 提取本周回复率前 5 的句式
2. 如果回复率 > 8% 且使用次数 > 10，加入对应平台库
3. 如果某句式回复率连续 3 周 < 2%，移入"待淘汰"
4. 在 ab_test.md 中为待淘汰句式创建新的 A/B 测试

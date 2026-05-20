# Promotion Warrior — 用户配置文件 v5

> Agent 每次启动必须先读取此文件。

---

## 🎯 推广主题

```yaml
niche: "AI Video Generation Tools (HeyGen Affiliate)"
timezone: "America/New_York"
```

---

## 👥 目标用户

```yaml
target_audience:
  pain_points:
    - "Hate being on camera but need talking-head videos"
    - "Video production is too expensive / time-consuming"
    - "Need multilingual video content without re-shooting"
    - "Want personalized video outreach at scale"
    - "Course / YouTube videos look unprofessional"
    - "Spending hours recording and re-recording takes"
    - "Need AI avatars for internal training videos"

  intent_signals:
    en:
      - "recommend"
      - "worth it"
      - "anyone tried"
      - "best AI video"
      - "instead of Synthesia"
      - "text to video"
      - "AI avatar tool"
      - "talking head video"
      - "vs "
      - "which one"
      - "honest review"
      - "actually good"
      - "digital human"
      - "AI presenter"
      - "video translation tool"
```

---

## 🔑 搜索关键词

```yaml
keywords:
  en:
    - "AI video generator"
    - "text to video AI"
    - "AI avatar"
    - "Synthesia alternative"
    - "digital avatar video"
    - "video creation tool"
    - "AI presenter"
    - "talking head video"
    - "AI video translation"
    - "HeyGen"
    - "best AI video tool"

platform_keywords:
  twitter_x:
    - "AI video generator recommendation"
    - "best text to video tool"
    - "AI avatar tool review"
    - "Synthesia vs OR HeyGen vs"
    - "video tool for content creators"
    - "AI video is actually good now"
    - "need a video tool that"
    - "anyone using AI for videos"

reddit_subreddits:
  - "artificial"
  - "AIToolsVideo"
  - "youtubers"
  - "NewTubers"
  - "videomarketing"
  - "content_marketing"
  - "digital_marketing"
  - "entrepreneur"
  - "SaaS"
  - "startups"
  - "marketing"
  - "PartneredYoutube"
  - "VideoEditing"
  - "edtech"
  - "elearning"
  - "smallbusiness"
  - "sales"
  - "coldemail"

# Subreddits where search terms are applied
reddit_search_queries:
  - "AI video generator"
  - "text to video"
  - "Synthesia"
  - "AI avatar"
  - "talking head"
  - "video tool"
  - "content creation tool"
  - "best AI tool"
  - "anyone tried AI video"
  - "automate video"
```

---

## 🤖 模型配置

```yaml
models:
  l2_comment: "deepseek-chat"         # Tier 1 评论
  l3_comment: "deepseek-chat"         # Tier 2 评论
  l4_trending: "deepseek-chat"        # 热点快速响应
  l5_dm_first: "deepseek-chat"        # 首次私信
  l6_dm_followup: "deepseek-chat"     # 对话跟进
  l7_analysis: "deepseek-chat"        # 分析周报

  fallback:
    tier1: "deepseek-chat"
    tier2: "deepseek-chat"
    tier3: "deepseek-chat"

api_keys:
  deepseek:
    - "sk-13dbb367f60841d6981b0e2ce24fd722"

  daily_limit_per_key:
    deepseek: 1000

  call_interval_sec: [3, 8]
```

---

## 💬 转化配置

```yaml
conversion:
  goal: "Free trial signup via affiliate link"

  # Primary CTA — used in DMs and Tier 2 when user shows strong interest
  cta_en: >-
    I actually use HeyGen for this — been happy with it.
    If you're curious, I can share my referral link and you can try it free.
    No pressure either way!

  # Subtle CTA — used in Tier 2 when user is casually interested
  cta_en_soft: >-
    Happy to share what I've been using if you want to compare notes.
    Just DM me!

  forbidden_words_en:
    - "buy now"
    - "click here"
    - "affiliate"
    - "sponsored"
    - "promo code"
    - "discount code"
    - "commission"
    - "sign up here"

  # Affiliate link — only shared in DMs, never in public comments
  affiliate_link: "https://www.heygen.com/?sid=rewardful&utm_content=creator&utm_medium=affiliate&via=samantha"

  # === 转化追踪配置 ===
  tracking:
    enabled: true
    # 每个渠道用不同的 utm_content 追踪来源
    sources:
      reddit_comment: "reddit-comment"
      reddit_post: "reddit-post"
      x_reply: "x-reply"
      x_post: "x-post"
      youtube_comment: "youtube-comment"
      linkedin_post: "linkedin-post"
    
    # 发 DM 时自动替换 utm_content 到对应来源
    # 示例: DM 来自 Reddit 评论回复 → link?utm_content=reddit-comment
    auto_tag: true
```

> ⚠️ Affiliate 链接投放规则：
> - 绝不在 Tier 1 或 Tier 2 公开评论中发送链接
> - 只有在 Tier 3 私信中，用户明确表示感兴趣后才分享
> - 私信中也不直接发链接，用"let me send you the link"自然引导

---

## 📱 平台开关

```yaml
platforms:
  xiaohongshu: true
  weibo: false
  douyin: false
  instagram: true
  twitter_x: true
  facebook: true
  reddit: true
  tiktok: true
```

---

## ⚙️ 执行参数

```yaml
per_session:
  tier1_count: 8         # Reddit 评论可以多一些
  tier2_count: 5         # 精准互动回复
  tier3_count: 3         # 私信跟进（Reddit 私信 + X DM）
  action_interval_sec: [120, 360]  # Reddit/X 操作间隔要更大
  max_continuous_minutes: 60

review_mode: false         # 用户已确认内容风格，改为自动执行

---

## 📲 Bark 推送配置

> 自动推送到 iPhone，无需登录 Dashboard
> 使用 `bash /tmp/heygen-monitor.sh start` 启动巡查

```yaml
bark:
  key: "x23x7UumVP3ZZgENJGZ6M8"
  # https://api.day.app/{key}/  — 从 Bark App 获取
  enabled: true
  notify_on:
    reddit_reply: true          # Reddit 有回复时推送
    x_interaction: true         # X 有互动时推送
    monitor_start: true         # 监控启动时推送
```
competitor_first: true    # true=每次先扫竞品评论区再搜关键词

# 刻意降质开关（Reddit 用户对 AI 内容敏感，必须开启）
humanize:
  enabled: true
  typo_rate: 0.05         # Reddit 上错别字概率降低（更注重内容质量）
  punctuation_drop: 0.40  # 句尾不打句号概率
  truncate_rate: 0.15     # 最后一句截断概率
  # Reddit 评论不做严重错别字，重点放在语气自然
  # X/Twitter 回复可适当用缩写（u/ur/bc）

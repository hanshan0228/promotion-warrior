# 竞品账号监控 — competitors.md

> 蹲守竞品评论区是获取精准用户最高效的方式。
> 在此添加竞品/同类博主账号，Agent 每次执行时优先扫描这些账号的最新内容。

---

## 监控策略

**为什么蹲竞品评论区：**
- 竞品的粉丝 = 对 AI 视频工具有兴趣的精准用户
- 评论区问问题的人 = 高意向用户，直接进入 Tier 2
- 比搜关键词效率高 3-5 倍

**执行逻辑：**
1. 每次启动先扫描监控列表中的账号，获取近 24h 新发内容
2. 进入每条新内容的评论区
3. 找出含 intent_signals 的评论用户 → 直接 Tier 2
4. 其他评论 → Tier 1（蹭热度）
5. 记录已处理的帖子 ID，避免重复扫描

---

## Reddit 监控列表

| Subreddit | 成员数 | 优先级 | 备注 |
|-----------|--------|--------|------|
| r/artificial | 2.7M+ | P0 | AI 综合讨论，频繁出现 AI 视频工具话题 |
| r/AIToolsVideo | growing | P0 | 专为 AI 视频工具讨论 |
| r/youtubers | 3M+ | P0 | YouTuber 频繁讨论视频制作工具 |
| r/NewTubers | 900k+ | P0 | 新手 YouTuber 有大量制作相关问题 |
| r/videomarketing | 1M+ | P1 | 视频营销从业者 |
| r/content_marketing | 300k+ | P1 | 内容营销人员 |
| r/digital_marketing | 600k+ | P1 | 数字营销人员 |
| r/entrepreneur | 5M+ | P1 | 创业者讨论生产工具 |
| r/SaaS | 300k+ | P1 | SaaS 创业者，产品视频需求大 |
| r/startups | 5M+ | P1 | 同上 |
| r/marketing | 500k+ | P1 | 营销讨论 |
| r/PartneredYoutube | 400k+ | P2 | 成熟 YouTuber 讨论工具 |
| r/edtech | 100k+ | P2 | 教育科技 |
| r/elearning | 200k+ | P2 | 在线学习，课程视频需求 |
| r/smallbusiness | 2M+ | P2 | 小企业主，可用于视频营销 |
| r/videography | 600k+ | P2 | 视频制作专业讨论 |

---

## X (Twitter) 监控列表

| 账号名 | 粉丝量级 | 内容类型 | 优先级 | 备注 |
|--------|----------|----------|--------|------|
| @HeyGen_Official | 20k+ | 官方发布 | P0 | 评论区全是潜在用户 |
| @SynthesiaIO | 50k+ | 竞品官方 | P0 | 用户反复对比 HeyGen vs Synthesia |
| @elevenlabsio | 100k+ | 相关领域 | P0 | AI 语音+视频，目标用户重叠 |
| @runwayml | 80k+ | 相关领域 | P1 | AI 视频生成，用户可能也需要 HeyGen |
| @d_id_ai | 30k+ | 竞品 | P1 | D-ID 竞品评论区 |
| @invideo_io | 40k+ | 相关领域 | P1 | AI 视频编辑，目标用户重叠 |
| @pidro_video | 20k+ | 竞品 | P1 | HeyGen 的直接竞品 |
| @nickfloats | 50k+ | AI 测评 KOL | P0 | AI 工具推荐大V，评论区精准 |
| @ai_explained_vid | 100k+ | AI 测评 KOL | P0 | 测评视频评论区 |
| @mattvidpro | 200k+ | AI 测评 KOL | P0 | AI 工具深度测评 |
| @rowancheung | 200k+ | AI 资讯 KOL | P1 | AI 工具讨论密集 |
| @thealexfinn | 50k+ | AI 工具推荐 | P1 | AI 工具推荐达人 |

---

## 已扫描记录（Agent 自动维护）

> 格式：平台:帖子ID → 扫描时间
> 避免重复扫描同一帖子

```
Reddit: {}
X: {}
```

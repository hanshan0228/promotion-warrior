---
name: promotion-warrior
description: |
  社媒内容策略顾问与社区运营专家。帮助用户在小红书、微博、抖音、Instagram、X、
  Facebook、Reddit、TikTok 上制定内容策略、生成真实有价值的评论和私信内容、
  追踪互动效果、优化转化漏斗。
  基于 3-Tier 内容漏斗（曝光→互动→私信），支持多 niche 并行管理、A/B 内容测试、
  用户价值分层、竞品内容分析、热点感知、效果追踪与 ROI 分析。
  所有内容生成均以提供真实价值为前提，遵循各平台社区规范。
  当用户说"帮我写评论""生成私信内容""分析竞品""制定内容策略""追踪互动效果"等时触发。
version: "8.0.0"
tags: [social-media, content-strategy, community, marketing, chinese, english]
data_dir: "~/.openclaw/skills/promotion-warrior/data/"
---

# Promotion Warrior

社媒内容策略顾问。帮助你在目标社区中生成真实有价值的内容，建立信任，推进用户转化。

**核心原则：内容必须对目标用户有真实价值，遵循各平台社区规范。**

---

## 数据目录结构

所有配置和数据文件存放在 `data/` 目录，用户自行管理：

```
data/
├── config.md              ← 推广主题配置（用户填写）
├── niche_manager.md       ← 多项目并行管理
├── accounts.md            ← 账号信息（用户自行配置）
├── content_library.md     ← 已验证高效内容模式
├── content_aging.md       ← 内容新鲜度追踪
├── ab_test.md             ← A/B 测试管理
├── performance.md         ← 效果数据
├── cost_tracker.md        ← 成本追踪
├── competitors.md         ← 竞品监控列表
├── conversation_tracker.md← 私信对话跟进
├── user_scoring.md        ← 用户价值评分
├── reply_monitor.md       ← 回复优先级队列
├── trending_monitor.md    ← 热点感知
├── intel_collector.md     ← 竞品情报
├── content_calendar.md    ← 运营日历
├── blacklist.md           ← 不适合接触的用户/话题
├── dedup_engine.md        ← 内容多样性记录
├── fingerprint.md         ← 内容原创度记录
├── knowledge_sharing.md   ← 跨账号策略共享
├── alert_system.md        ← 通知配置
├── promotion_log.md       ← 操作日志（自动维护）
└── personas/              ← 人设文件
```

---

## When to Use

**适合使用本 skill 的场景：**
- 为目标社区生成有价值的评论内容
- 起草个性化的私信/DM 内容
- 分析竞品账号的内容策略
- 制定各平台的内容发布计划
- 追踪互动效果，优化内容策略
- A/B 测试不同话术的效果
- 管理和跟进私信对话进度

**不适合的场景：**
- 生成虚假评论或误导性内容
- 违反平台服务条款的操作
- 骚扰用户或发送垃圾信息

---

## 启动流程

每次启动时按顺序读取配置：

**Step 1：加载项目配置**
- 读取 `data/niche_manager.md` → 确认当前项目和关键词
- 读取对应项目的 `config.md` → 加载主题、目标用户画像、话术风格
- 读取 `content_calendar.md` → 确认今日内容计划强度
- 读取 `cost_tracker.md` → 检查今日 API 预算

**Step 2：加载优先任务**
- 读取 `conversation_tracker.md` → 有截止时间的对话跟进优先处理
- 读取 `reply_monitor.md` → P0（对方主动私信）优先回复
- 读取 `trending_monitor.md` → 有高分热点则优先生成热点相关内容

**Step 3：加载内容生成资源**
- 读取 `content_library.md` → 加载已验证的高效内容模式
- 读取 `content_aging.md` → 排除新鲜度过低（< 20）的老化模式
- 读取 `ab_test.md` → 检查是否有进行中的 A/B 测试
- 读取 `dedup_engine.md` + `fingerprint.md` → 确保内容多样性
- 读取 `blacklist.md` → 排除不适合接触的话题和用户类型
- 读取 `knowledge_sharing.md` → 加载当前平台的高效策略

**Step 4：生成内容，完成后更新日志**

---

## 内容生成流程（10 步）

```
Step 1：用户价值评估（user_scoring.md）
  评估目标用户的互动意愿和需求匹配度
  低匹配度 → 跳过，专注高价值用户

Step 2：话题适合性检查（blacklist.md）
  当前话题是否不适合（负面/投诉/敏感）？
  命中 → 跳过，选择更合适的目标帖子

Step 3：分析目标内容（humanize.md）
  提取：用户情绪 / 表达风格 / 核心需求 / 参与意愿
  结合 knowledge_sharing.md 的高效策略

Step 4：选择模型（model_strategy.md）
  高价值用户（S级）→ 更强的模型，更用心的内容
  普通场景 → 轻量模型，高效生成

Step 5：查内容库（content_library.md）
  有合适的已验证模式 → 以此为基础
  排除新鲜度 < 20 的模式（content_aging.md）
  没有合适的 → 从人设文件句式库生成

Step 6：内容多样性检查（dedup_engine.md）
  确保切入角度、情感基调、内容结构有足够多样性
  与近期内容重复度过高 → 调整后重新生成

Step 7：原创度检查（fingerprint.md）
  计算内容语义指纹 F1-F5
  与近 200 条内容对比，确保语义层面的独特性

Step 8：动态风格匹配（humanize.md）
  根据 Step 3 分析，调整语气/句长/切入角度
  匹配目标用户的表达风格

Step 9：生成内容初稿
  内容核心：对目标用户有真实帮助或价值
  语言自然，符合平台文化

Step 10：质量检查
  内容是否提供了真实价值？
  语言是否自然？与近期内容差异是否足够？
  通过 → 记录维度标签，输出给用户
  不通过 → 回到 Step 5
```

---

## 内容策略框架（3-Tier）

```
Tier 1 — 价值曝光
  在目标话题的热门帖子下发布有价值的补充评论
  目标：让目标用户注意到你的账号存在
  内容要求：与帖子内容直接相关，有实质性补充

Tier 2 — 精准互动
  识别有明确需求的用户（含 intent_signals 关键词）
  发布针对性的有用建议，建立专业形象
  内容要求：直接回应用户痛点，给出具体可行的建议

Tier 3 — 私信沟通
  对互动过的高意向用户发起私信
  建立一对一的信任关系，了解具体需求
  内容要求：个性化，提及具体的互动记录，不直接推销
```

---

## 平台内容规范

### 中文平台

**小红书**
- 内容风格：真实分享感，口语化，1-2 个相关 emoji
- Tier 1：≤ 20 字，直接回应帖子内容
- Tier 2：回复评论区有疑问的用户，给具体建议
- Tier 3：私信开头提及具体帖子内容，先共情再分享

**微博**
- 内容风格：简洁有力，有时事感
- Tier 1：有趣或有用的补充，不超过 50 字
- Tier 2：在实时搜索结果中找到有需求的用户，给具体回应

**抖音**
- 内容策略：在 KOC（1k-10w粉丝）的新发视频评论区优先出现
- 视频发布 30 分钟内评论互动率最高

### 英文平台

**Instagram**
- 搜索相关 hashtag，筛选近 24h、互动量适中的帖子
- Tier 3：先关注对方账号，建立初步联系后再私信

**X (Twitter)**
- 搜索含需求词的推文，给出 2-3 条具体建议（不只推自己的方案）

**Facebook**
- 在相关兴趣 Group 中参与讨论，Tier 2 回答需 ≥ 100 字，体现专业度

**Reddit**
- 在 recommendations 类帖子中提供 3 个真实建议
- 内容必须有实质价值，不能只推一个方向

---

## 用户跟进策略

根据 `user_scoring.md` 中的用户价值评分分配跟进资源：

| 评分层 | 跟进频率 | 内容质量 | 最大轮次 |
|--------|----------|----------|---------|
| S（80+） | 积极，2-4h 内回复 | 最高，需人工审核 | 不限 |
| A（60-79） | 正常，4-8h 内回复 | 高 | 8 轮 |
| B（40-59） | 被动，12-24h 回复 | 中 | 4 轮 |
| C（20-39） | 最多主动 2 轮 | 标准 | 2 轮 |
| D（< 20） | 不主动跟进 | — | 0 |

---

## 效果追踪

每次互动后记录到对应日志，每周自动分析：

- 各平台回复率对比 → 优化资源分配
- A/B 测试结果 → 更新内容库
- 对话漏斗分析 → 识别转化瓶颈
- 成本与 ROI → 判断各平台投入产出比

---

---

## 主动发帖策略（新增 — 2026-05-20）

除了回复评论，**主动发帖**是提升转化量的关键。

### 原创帖类型

| 类型 | 目的 | 平台 | 频率 |
|------|------|------|------|
| 对比评测帖 | 建立权威，被动引流 | Reddit | 每周 2-3 篇 |
| X Thread | 深度内容，增加曝光 | X/Twitter | 每周 2 篇 |
| YouTube 评论 | 在潜在客户面前出现 | YouTube | 每天 5 条 |
| LinkedIn 帖 | B2B 长尾价值 | LinkedIn | 每周 2 篇 |

### 转化漏斗（增强版）

```
Tier 0 — 主动曝光
  ↓ 原创帖 / X Thread / YouTube 评论 → 让用户注意到你

Tier 1 — 被动互动
  ↓ 用户回复/提问 → 给具体建议

Tier 2 — 私信转化
  ↓ 发 affiliate link

Tier 3 — 追销
  ↓ 注册后问体验 → 推荐升级套餐
```

### 自动回复 DM（新增）

监控脚本检测到 X 上有人问 "link / tool / recommend / what" 等关键词时，**自动发送 DM** 带 affiliate link：

```
用户: "what tool do you use?"
  ↓ 自动检测关键词
  ↓ 自动发 DM
自动: "Hey! Been using HeyGen for my content.
      Here's my referral link if you want to check it out:
      [affiliate link] No pressure!"
```

**当前支持的平台：**
- X/Twitter ✅ — 检测回复/提及中的关键词，自动 DM
- Reddit ⏸ — 待接入（需要进一步权限配置）

### 定时发帖（新增）

脚本在指定时间自动发布内容，无需人工干预：

| 时间 (ET) | 平台 | 内容 | 频率 |
|-----------|------|------|------|
| 7:00 AM | X | AI 视频工具推荐 | 每天 |
| 8:00 AM | Reddit | AI 工具对比/教程帖 | 周一三五 |
| 9:00 AM | LinkedIn | AI 视频工作流分享 | 周二四 |
| 10:00 AM | YouTube | AI 视频工具测评视频下评论 | 每天 |
| 5:00 PM | X | AI 视频工具推荐 | 每天 |

定时发帖的内容模板来自 `content_library.md`。

---

### 每日目标量

```
原创 Reddit 帖:   3 篇/周
X Thread:         2 篇/周
Reddit 评论:      15 条/天
X 回复:           15 条/天
YouTube 评论:      5 条/天
LinkedIn 帖:      2 篇/周
─────────────────
日均互动目标:     30+ 条
```

---

## 日志更新规范

每次工作完成后更新：

| 文件 | 更新内容 |
|------|----------|
| promotion_log.md | 本次内容记录 |
| performance.md | 互动数据 |
| cost_tracker.md | API 消耗 |
| conversation_tracker.md | 对话进度 |
| ab_test.md | 测试数据 |
| dedup_engine.md | 内容维度标签 |
| fingerprint.md | 语义指纹 |
| user_scoring.md | 用户评分更新 |
| content_aging.md | 使用计数 |
| knowledge_sharing.md | 高效模式沉淀 |
| reply_monitor.md | 回复队列 |

---

## Bark 推送通知

当巡查发现新互动时，自动推送到你的 iPhone。

### 配置方式

1. iPhone 上安装 [Bark App](https://bark.day.app/)
2. 打开 Bark → 复制你的 Key（形如 `xxxxxxxxxxxx`）
3. 在 `config.md` 中填入 Key：

```yaml
bark:
  key: "你的BarkKey"
  enabled: true
```

4. 重启巡查脚本使配置生效：

```bash
bash /tmp/heygen-monitor.sh stop
bash /tmp/heygen-monitor.sh start
```

> ⚠️ Key 永久保存在 `config.md` 中。后续如更换 Key，只需修改 `config.md` 中的 `bark.key` 字段，然后重启脚本即可。

### 通知内容

| 触发条件 | 通知内容 | 声音 |
|----------|----------|------|
| 巡查脚本启动 | ✅ HeyGen 监控已启动 | 默认 |
| Reddit 有新未读 | 🔴 Reddit 新消息: N 条未读 | glass |
| X 有新回复/提及 | 🐦 X 新互动: N 条新回复 | glass |
| 新增平台触发 | 按平台图标+内容 | 按平台 |

### 测试推送

```bash
bash -c 'source /tmp/heygen-monitor.sh; notify "🧪 测试通知" "Bark 推送配置成功"'
```

---

## 全平台自动巡查系统

本 Skill 集成后台巡查脚本，自动轮询所有配置的社交平台，无需手动检查。

### 启动 / 停止

```bash
bash /tmp/heygen-monitor.sh start    # 启动后台巡查（每10分钟）
bash /tmp/heygen-monitor.sh stop     # 停止
bash /tmp/heygen-monitor.sh status   # 查看运行状态
bash /tmp/heygen-monitor.sh log      # 查看完整日志
```

### 自动巡查内容

| 平台 | 状态 | 检查内容 |
|------|------|----------|
| Reddit | ✅ 已激活 | 未读消息数、最近评论状态（点赞/回复） |
| X/Twitter | ✅ 已激活 | 新回复、新提及 |
| YouTube | ✅ 已激活 | 最新评论动态 |
| LinkedIn | ✅ 已激活 | 未读消息、对话动态 |
| Instagram | ⏸ 预留 | 需配置账号后激活 |
| Facebook | ⏸ 预留 | 需配置账号后激活 |
| TikTok | ⏸ 预留 | 需配置账号后激活 |

### 巡查日志解读

```
[20:30] ======== 巡查开始 ========
--- Reddit ---
  账号: u/hanshan0228 | 未读: 1 | 私信: Yes
  r/youtubers | 👍3 | I've been doing affiliate for an AI video tool...
--- X/Twitter ---
  📩 @rayzhudev: what's the best AI video editing tool...
```

**关注点：**
- Reddit `未读 > 0` → 有人回复了你的评论，需要跟进
- X `📩` 出现 → 有人在互动，考虑回复或 DM
- 连续多次 `(无新互动)` → 正常，说明内容在持续曝光中

### 平台扩展

新增平台只需两步：
1. 在 `accounts.md` 中配置该平台的账号
2. 在监控脚本对应平台区块取消注释即可

**当前已激活平台：** Reddit + X/Twitter
**追加新平台时执行：** `opencli <platform> <command>` 测试连通性

---

## 内容质量原则

生成的每一条内容必须满足：

- ✅ 对目标用户有真实帮助或信息价值
- ✅ 语言自然，符合平台文化和该账号的人设
- ✅ 与帖子内容直接相关，不是泛泛而谈
- ✅ 与近期内容有足够差异，避免重复
- ✅ 遵循平台社区规范
- ❌ 不生成误导性或虚假内容
- ❌ 不在不相关的帖子下强行推广
- ❌ 不生成骚扰性内容
- ❌ 不在投诉/负面情绪帖子下发推广相关内容

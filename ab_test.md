# A/B 测试管理 — ab_test.md

> Agent 生成内容时，如当前有进行中的测试，必须按测试分组分配话术。
> 每周日周报时自动统计结果，胜出组写入 content_library.md，落败组标记淘汰。

---

## 测试原则

- 每次只测试**一个变量**（开头句式 / 结尾 CTA / 语气风格 / 切入角度）

---

## 当前进行中的测试

### Test 001 — HeyGen 话术风格（2026-05-20 启动）

| 项目 | 说明 |
|------|------|
| **变量** | 评论切入角度：对比型 vs 实用型 |
| **A组（对比型）** | "I tested X vs Y vs Z — here's why I went with HeyGen" |
| **B组（实用型）** | "If you're struggling with [pain point], here's what worked for me" |
| **目标平台** | Reddit + X |
| **每组样本量** | 各 15 条 |
| **启动日期** | 2026-05-20 |
| **统计日期** | 2026-05-27 |
| **胜出标准** | 回复率 > 8% 且明显高于另一组 |

### 分配规则（Agent 执行）

```
当前 Test 001 进行中：
  • 评论 id 末尾数字 0-4 → A 组（对比型）
  • 评论 id 末尾数字 5-9 → B 组（实用型）
  • 性能数据记录到 performance.md
```
- 每组至少积累 **30 条**操作数据再判断胜负
- 同一平台同一 Tier 的操作才能对比，跨平台不对比
- 胜出标准：回复率高于对照组 **20%** 以上

---

## 进行中的测试

### 测试 001
```yaml
id: "test_001"
platform: "小红书"
tier: "Tier 2"
variable: "切入角度"
start_date: "填入开始日期"
status: "进行中"

group_a:
  label: "共情切入"
  template: "看到你说[痛点]，我之前也是！后来发现[建议]，你可以试试"
  count: 0
  replies: 0
  reply_rate: 0%

group_b:
  label: "专家切入"
  template: "这个我研究过，[具体分析]，你的情况应该更适合[方向]"
  count: 0
  replies: 0
  reply_rate: 0%

winner: "待定"
```

### 测试 002
```yaml
id: "test_002"
platform: "Instagram"
tier: "Tier 3 DM"
variable: "开头方式"
start_date: "填入开始日期"
status: "进行中"

group_a:
  label: "直接引用帖子"
  template: "saw your post about [specific content] — I went through the same thing"
  count: 0
  replies: 0
  reply_rate: 0%

group_b:
  label: "问题开头"
  template: "quick question — are you still looking for [solution to pain point]?"
  count: 0
  replies: 0
  reply_rate: 0%

winner: "待定"
```

---

## 测试分配规则（Agent 执行）

生成内容时：
1. 检查当前平台 + Tier 是否有进行中的测试
2. 如果有，按 A/B 交替分配（单数次用 A，双数次用 B）
3. 将分配结果记录在 promotion_log.md 的 `ab_group` 字段
4. 收到回复时，在此文件对应 group 的 `replies` +1

---

## 已完成测试存档

| 测试ID | 平台 | Tier | 测试变量 | 胜出组 | 胜出回复率 | 落败回复率 | 结论 |
|--------|------|------|----------|--------|------------|------------|------|
| — | — | — | — | — | — | — | — |

---

## 新增测试模板

```yaml
id: "test_00X"
platform: "平台名"
tier: "Tier X"
variable: "测试的变量名"
start_date: "YYYY-MM-DD"
status: "进行中"

group_a:
  label: "方案A名称"
  template: "话术模板"
  count: 0
  replies: 0
  reply_rate: 0%

group_b:
  label: "方案B名称"
  template: "话术模板"
  count: 0
  replies: 0
  reply_rate: 0%

winner: "待定"
```

# 多 Niche 并行管理 — niche_manager.md

> 支持同时运营多个 affiliate 项目，数据完全隔离，账号组独立分配。
> Agent 每次启动时先读取本文件，确认当前激活的 niche 和账号组。

---

## Niche 列表

```yaml
niches:

  - id: "heygen_affiliate"
    name: "HeyGen AI Video Generator"
    status: "active"
    priority: 1
    account_group: "group_heygen"
    config_file: "config.md"
    budget_daily_usd: 0.00
    start_date: "2026-04-28"
    notes: "主力 affiliate 项目 — Reddit + X/Twitter 英文推广"
```

---

## 账号组分配规则

```yaml
account_groups:
  group_heygen:
    platforms: ["reddit", "twitter_x"]
    accounts:
      reddit: ["u/Last_Ad_9446"]
      twitter_x: ["@hanshan0228"]
```

**账号组隔离原则：**
- 同一账号不能同时属于两个 niche 的账号组
- 账号组之间不做协同操作（避免跨 niche 暴露）
- 各 niche 的 promotion_log、performance、cost_tracker 数据完全分开存储

---

## 数据隔离结构

每个 niche 有独立的数据目录：

```
promotion-warrior/
├── niches/
│   └── heygen_affiliate/
│       ├── config.md (symlink → ../../config.md)
│       ├── promotion_log.md
│       ├── performance.md
│       ├── conversation_tracker.md
│       └── cost_tracker.md
└── shared/
    ├── accounts.md
    ├── proxy_manager.md
    ├── session_manager.md
    ├── blacklist.md
    └── cross_platform_users.md
```

---

## 每日预算分配

```yaml
total_daily_budget: 0.00
# 纯有机推广，无 API 调用成本（DeepSeek 低成本）
# 仅需时间投入
```

---

## 执行调度规则

```
同一时间只运行一个 niche 的操作（避免账号行为异常）

调度顺序：
  1. 先处理回复监控（reply_monitor）
  2. 再按 priority 顺序执行主动操作
```

---

## Niche 效果追踪

| Niche | 本周花费 | 本周线索 | 本周转化 | CPA | ROI |
|-------|---------|----------|---------|-----|-----|
| HeyGen Affiliate | $0 | 0 | 0 | — | — |

---
name: picasso-dev
description: Use when Picasso 项目需要统一推进新需求、需求变更、Bug 修复或 UI 优化，并希望按标准流程生成需求、方案、UI、任务、自测、审查、验收等产物后再进入开发。
---

# Picasso Dev

## 定位

`picasso-dev` 是 Picasso 项目的统一入口 skill。

它默认承担四件事：

1. 识别当前任务属于哪条开发链路
2. 创建或接管 `workspace/requests/<request-key>/` 目录
3. 组织完整交付物链路，而不是直接跳进写代码
4. 在合适阶段调用 `picasso-dev-task`、`picasso-dev-ui`、`picasso-dev-config`

## 什么时候使用

出现以下任一情况，优先从本 skill 进入：

- 开始一个 Picasso 新需求
- 对已有需求做变更迭代
- 修复 Picasso 现有功能问题
- 优化 PC / 小程序 / App 页面体验
- 需要统一收口需求、方案、UI、任务、测试和验收产物

## 必须先读取

1. `../../profiles/picasso/profile.yaml`
2. `../../profiles/picasso/repo-map.md`
3. `../../profiles/picasso/execution-modes.md`
4. `../../shared/references/naming.md`
5. `../../shared/references/artifact-standard.md`
6. `../../shared/references/requirements/README.md`
7. `../../shared/references/requirements/Codex CLI 标准执行输入.md`
8. `../../shared/references/task/README.md`
9. 根据任务类型读取对应工作流：
   - 新需求：`../../shared/workflow/new-feature.md`
   - 需求变更：`../../shared/workflow/change-request.md`
   - Bug 修复：`../../shared/workflow/bugfix.md`
   - UI 优化：`../../shared/workflow/ui-optimization.md`

若 `workspace/requests/<request-key>/` 已存在，还必须继续读取：

- `manifest.json`
- `00-需求总览.md`
- `*-需求文档.md`
- `*-技术方案.md`（如存在）
- `*-UI交互设计规范.md`（如存在）
- `stage-status.json`

## 路由原则

### 第一步：先识别需求类型

只允许落到以下四类之一：

1. `new-feature`
2. `change-request`
3. `bugfix`
4. `ui-optimization`

若用户输入不足以判断，先输出：

- 当前候选类型
- 判断依据
- 缺失信息
- 建议补充项

不要在类型不清楚时直接宣称进入开发。

### 第二步：再识别平台范围

在需求类型确定后，再识别涉及的平台：

- `backend`
- `pc`
- `miniapp`
- `mobile_app`
- `config`

平台范围要写入 `manifest.json`，并在产物中保持一致。

## 标准产物目录

统一使用：

```text
workspace/requests/<request-key>/
├── assets/
├── 00-需求总览.md
├── manifest.json
├── <功能名称>-需求文档.md
├── <功能名称>-任务分解.md
├── <功能名称>-技术方案.md
├── <功能名称>-UI交互设计规范.md
├── <功能名称>-测试用例.md
├── <功能名称>-实现控制总表.md
├── <功能名称>-页面接口验收总表.md
├── <功能名称>-开发放行报告.md
├── <功能名称>-代码审查报告.md
├── <功能名称>-冒烟测试脚本.sh
├── <功能名称>-冒烟测试报告.md
├── <功能名称>-QA与产品验收报告.md
├── logs/
└── stage-status.json
```

## 标准推进顺序

### 新需求

`需求分析 → 技术方案 → UI设计 → 任务拆解 → 编码开发 → 开发自测 → 代码审查 → 冒烟测试 → QA验收 → 部署`

### 需求变更

`差异确认 → 影响分析 → 技术调整 → UI调整（如涉及）→ 任务拆解 → 开发 → 回归验证 → 验收`

### Bug 修复

`问题复现 → 根因定位 → 影响分析 → 修复方案 → 修复实现 → 回归验证 → 验收`

### UI 优化

`现状评估 → UI规范 → 页面优化 → 验收回归`

## Companion Skills 触发规则

### 调用 `picasso-dev-task`

当任务涉及以下任一场景时调用：

- 服务端接口、表结构、业务规则实现
- OpenSpec / 服务端任务推进
- 编码规则、删除策略、状态流转、接口设计

### 调用 `picasso-dev-ui`

当任务涉及以下任一场景时调用：

- 进入 UI 设计阶段
- 涉及原型还原、页面优化、视觉提升
- 涉及 PC / 小程序 / App 任一端的界面与交互

### 调用 `picasso-dev-config`

当任务涉及以下任一场景时调用：

- 菜单、字典、SQL、环境配置
- 联调、自测、测试所需初始化数据
- 配置项不完整导致页面或接口不可用

## 阶段卡点

默认不允许跳过下列关键卡点：

1. 需求基线未确认，不进入技术方案
2. 技术方案未确认，不进入正式编码
3. UI 影响明显但无 `*-UI交互设计规范.md`，不进入前端 / 端侧实现
4. 无开发自测报告，不宣称可提测
5. 无代码审查结论，不宣称质量通过
6. 无冒烟结果，不宣称可验收

## 安全与边界

1. 不使用日期作为需求目录主键
2. 不把运行产物写入 `governance/`
3. 不把 skill 包维护记录写入 `workspace/`
4. 不默认操作生产数据库或生产服务器
5. 不在缺少需求基线时直接写业务代码
6. 涉及公共能力时，必须显式引用 `shared/references/requirements/` 下对应规则

## 快速动作

### 创建新需求骨架

优先使用：

```bash
python3 shared/scripts/init-request.py --key <request-key> --title "<中文标题>" --type new-feature --workspace "${PICASSO_WORKSPACE_DIR:-workspace}"
```

### 校验当前需求产物

```bash
python3 shared/scripts/validate-artifacts.py --request workspace/requests/<request-key> --type <request-type>
```

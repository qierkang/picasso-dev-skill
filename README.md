# 毕加索 Picasso Dev Skill

---

<div align="center">
  <strong>毕加索项目标准化开发技能包 · 单入口调度 · 多 Agent 协作 · Claude + Codex 联动</strong>
  <br>
  <br>
  <p>面向 Picasso 项目的可复刻开发技能包，覆盖需求分析、技术方案、UI设计、编码、自测、审查、测试、验收与部署</p>
  <p>支持 PC Web、微信小程序、移动端 App，多环境快速配置，适合团队复制到新机器直接使用</p>
</div>

---

<font face="微软雅黑" size=2 color=#A9A9A9>版权声明：内容供技术友人学习使用，请勿外传！转载请附上作者信息</font>

## 📋 项目概述

Picasso Dev Skill 是一套面向毕加索项目的标准化开发技能包，不是单一 skill，而是一个可分发、可复刻、可协作的研发工作流工具集。

它提供统一入口 `picasso-dev`，并通过 companion skills 覆盖后端任务、三端 UI、配置协同、技能维护等场景，适用于 Claude、Codex、GLM、DeepSeek、MiniMax 等模型的单模型或协作式开发流程。

## 🎯 核心特色

- **统一入口**：所有 Picasso 需求统一从 `picasso-dev` 进入
- **多 Agent 协作**：支持总控、PM、架构、UI、前端、后端、移动端、小程序、QA、Review、Ops 协作
- **多端支持**：覆盖 PC Web、微信小程序、移动端 App
- **配置即运行**：复制仓库、填写 `.env`、执行 `setup / doctor / sync` 后即可进入标准开发流程
- **运行数据分离**：技能包规则和需求运行产物分层管理
- **维护记录可追溯**：所有规则调整统一记录到 `governance/`
- **执行模式灵活**：默认单模型可独立跑，也支持 Claude + Codex 增强协作

## 📁 目录结构

```text
picasso-dev-skill/
├── SKILL.md        # 根级技能入口索引
├── install/       # 初始化、体检、同步、升级脚本
├── skills/        # 核心技能入口
├── profiles/      # 项目画像（当前为 Picasso）
├── shared/        # 模板、提示词、参考资料、通用脚本
├── workspace/     # 需求运行产物（默认不提交）
├── governance/    # 技能包维护记录（需要提交）
└── examples/      # 示例需求与标准样例
```

### 目录说明

| 目录 | 用途 |
|------|------|
| `install/` | 新环境初始化、环境检查、技能同步 |
| `SKILL.md` | 根目录总入口索引，兼容只识别根级 skill 的平台 |
| `skills/` | `picasso-dev` 及其 companion skills |
| `profiles/` | Picasso 项目画像、仓库映射、技术栈、环境说明 |
| `shared/` | 工作流定义、中文模板、Prompt、脚本、公共规则 |
| `workspace/` | 运行中的需求目录、归档目录、缓存和临时数据 |
| `governance/` | CHANGELOG、更新记录、决策文件、维护说明 |
| `examples/` | 真实改造过的示例需求目录 |

## 🧩 Skills 组成

### 统一入口

- `picasso-dev-skill`
  - 仓库根目录技能入口索引
  - 用于兼容只识别根级 `SKILL.md` 的平台
  - 实际会继续路由到 `picasso-dev`
- `picasso-dev`
  - Picasso 项目统一入口
  - 负责识别需求类型、路由执行链路、创建标准产物目录

### Companion Skills

- `picasso-dev-task`
  - 后端任务推进、设计、OpenSpec 和服务端开发协同
- `picasso-dev-ui`
  - PC / 小程序 / App 的 UI 设计与页面优化
- `picasso-dev-config`
  - 菜单、字典、SQL、环境配置协同
- `picasso-dev-maintainer`
  - skill 包维护、规则变更记录、Changelog 沉淀

## 📚 模板与公共规则

### 中文模板入口

当前主模板统一放在 `shared/templates/` 顶层，优先看这些中文文件：

- `需求总览模板.md`
- `manifest模板.json`
- `需求文档模板.md`
- `服务端任务模板.md`
- `任务分解模板.md`
- `技术方案模板.md`
- `UI交互设计模板.md`
- `测试用例模板.md`
- `实现控制总表模板.md`
- `页面接口验收总表模板.md`
- `开发放行报告模板.md`
- `覆盖率报告模板.md`
- `前端关键流程覆盖清单模板.md`
- `代码审查报告模板.md`
- `冒烟测试脚本模板.sh`
- `冒烟测试报告模板.md`
- `QA与产品验收报告模板.md`

### 公共规则入口

跨需求复用的公共规则统一放在 `shared/references/requirements/`：

- `异步导入导出开发规范.md`
- `动态规则编码生成.md`
- `内部编码生成.md`
- `枚举类创建规范.md`
- `Codex CLI 标准执行输入.md`

服务端任务推进的 Picasso 专属规则统一放在 `shared/references/task/`：

- `服务端任务输入模板.md`
- `服务端任务路径布局.md`
- `服务端任务门槛校验.md`
- `服务端设计约束.md`
- `服务端 Codex 协作规范.md`
- `子产品与模块映射.md`

质量卡点公共规则统一放在 `shared/references/quality/`：

- `前端开发自测清单.md`
- `两关制冒烟测试说明.md`

## 🛠️ 环境要求

### 必备工具

- `git`
- `python3`
- `claude` 或其他主模型 CLI
- `codex`（如需 Codex 执行编码）

### 按需工具

- `node`
- `pnpm`
- `psql`
- `flutter`
- 小程序开发工具
- `ssh`

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone <your-gitlab>/picasso-dev-skill.git
cd picasso-dev-skill
```

### 2. 初始化本地配置

```bash
cp .env.example .env
vim .env
```

### 3. 初始化目录与运行环境

```bash
bash install/setup.sh
```

### 4. 执行环境体检

```bash
bash install/doctor.sh
```

### 5. 同步技能到本地 AI 环境

```bash
bash install/sync.sh
```

### 6. 开始使用

```text
使用 picasso-dev 开始开发 maintenance-plan
```

## 🔧 安装脚本说明

### `setup.sh`

- 自动创建 `.env`
- 初始化 `workspace/`、`governance/`、`examples/` 的基础目录
- 为新环境准备最小可运行结构

### `doctor.sh`

- 检查 `git`、`python3`、`claude`、`codex`
- 检查 Picasso 各源码路径、任务目录、`workspace/` 可写性
- 检查 OpenClaw / Claude / Codex 的技能目录配置

### `sync.sh`

- 把 `skills/` 里的 `picasso-dev*` 同步到配置好的目标技能目录
- 当前支持：
  - `OPENCLAW_SKILLS_DIR`
  - `CLAUDE_SKILLS_DIR`
  - `CODEX_SKILLS_DIR`

### `upgrade.sh`

- 顺序执行 `setup.sh`、`doctor.sh`、`sync.sh`
- 适合技能包升级后快速刷新本地环境

## ⚙️ 配置说明

`.env` 中至少需要配置以下内容：

```env
PICASSO_SERVER_CODE_DIR=
PICASSO_FRONT_CODE_DIR=
PICASSO_MINIAPP_CODE_DIR=
PICASSO_MOBILE_APP_CODE_DIR=
PICASSO_SERVER_TASK_DIR=./workspace/server-tasks
PICASSO_DEFAULT_BRANCH=master
PICASSO_WORKSPACE_DIR=./workspace
OPENCLAW_SKILLS_DIR=
CLAUDE_SKILLS_DIR=
CODEX_SKILLS_DIR=
```

### 配置项说明

| 配置项 | 说明 |
|--------|------|
| `PICASSO_SERVER_CODE_DIR` | 后端源码目录 |
| `PICASSO_FRONT_CODE_DIR` | PC 前端源码目录 |
| `PICASSO_MINIAPP_CODE_DIR` | 小程序源码目录 |
| `PICASSO_MOBILE_APP_CODE_DIR` | 移动端源码目录 |
| `PICASSO_SERVER_TASK_DIR` | 服务端任务管理目录 |
| `PICASSO_DEFAULT_BRANCH` | 默认开发基线分支 |
| `PICASSO_WORKSPACE_DIR` | 运行产物目录 |
| `OPENCLAW_SKILLS_DIR` | OpenClaw 技能同步目录 |
| `CLAUDE_SKILLS_DIR` | Claude 技能同步目录 |
| `CODEX_SKILLS_DIR` | Codex 技能同步目录 |

### 新同事只需要改哪些

默认只需要修改 `.env`，重点看：

- 必改：
  - `PICASSO_SERVER_CODE_DIR`
  - `PICASSO_FRONT_CODE_DIR`
  - `PICASSO_SERVER_TASK_DIR`
  - `PICASSO_WORKSPACE_DIR`
- 按需：
  - `PICASSO_MINIAPP_CODE_DIR`
  - `PICASSO_MOBILE_APP_CODE_DIR`
  - `OPENCLAW_SKILLS_DIR`
  - `CLAUDE_SKILLS_DIR`
  - `CODEX_SKILLS_DIR`

更详细的入口说明见：

- `profiles/picasso/配置入口说明.md`

## 🧭 使用流程

### 新需求开发

```text
使用 picasso-dev 开始开发 maintenance-plan
原型：
- /path/to/list.html
- /path/to/detail.html
```

### 需求变更

```text
使用 picasso-dev 处理 maintenance-plan 的需求变更
```

### Bug 修复

```text
使用 picasso-dev 修复 maintenance-plan 的删除校验问题
```

### 页面优化

```text
使用 picasso-dev 优化 maintenance-plan 的小程序页面
UI 阶段调用 picasso-dev-ui
```

## 🔄 标准开发流程

`需求分析 → 技术方案 → UI设计 → 任务拆解 → 编码开发 → 开发自测 → 代码审查 → 冒烟测试 → QA验收 → 部署上线`

### 强制 Gate

- `任务分解卡点`：没有 `任务分解.md` 不进入真实开发
- `开发自测卡点`：没有 `开发放行报告.md` 不进入 review
- `覆盖率卡点`：没有 `覆盖率报告.md` 和 `前端关键流程覆盖清单.md` 不进入 review
- `代码审查卡点`：有 `P0 / 阻塞` 不进入 smoke
- `冒烟测试卡点`：未达到 `100% 通过` 不进入 QA
- `QA / 产品验收卡点`：默认结论为 `NEEDS_WORK`

## 📂 workspace 说明

`workspace/` 用于存放实际需求运行产物，默认不提交。

### 目录示例

```text
workspace/
└── requests/
    └── maintenance-plan/
        ├── assets/
        ├── 00-需求总览.md
        ├── manifest.json
        ├── 保养方案-需求文档.md
        ├── 保养方案-任务分解.md
        ├── 保养方案-技术方案.md
        ├── 保养方案-UI交互设计规范.md
        ├── 保养方案-测试用例.md
        ├── 保养方案-实现控制总表.md
        ├── 保养方案-页面接口验收总表.md
        ├── 保养方案-开发放行报告.md
        ├── 保养方案-代码审查报告.md
        ├── 保养方案-冒烟测试脚本.sh
        ├── 保养方案-冒烟测试报告.md
        ├── 保养方案-QA与产品验收报告.md
        ├── logs/
        └── stage-status.json
```

同时建议在 `workspace/server-tasks/` 下维护服务端任务协同资料。

### 命名规则

- 需求目录统一使用英文代号，如：
  - `maintenance-plan`
  - `equipment-maintenance-order`
- `attendance-mobile`
- 不使用日期作为主目录名
- 日期仅保留在 `manifest.json` 元信息中

## 📝 governance 说明

`governance/` 用于记录 skill 包自身变更，需要提交到仓库。

### 目录示例

```text
governance/
├── CHANGELOG.md
├── INDEX.md
├── maintainers.md
├── updates/
└── decisions/
```

### 使用规则

- 修改任一 skill、模板、共享规则时，必须补一条更新记录
- 更新记录使用 `chg-xxxx-*.md` 编号命名
- 重要结构调整需补决策记录

## 🤝 多 Agent 协作说明

| 角色 | 主要职责 |
|------|----------|
| `picasso-dev` | 总入口、流程路由、交付物组织 |
| `picasso-dev-task` | 后端任务与服务端推进 |
| `picasso-dev-ui` | UI 设计、交互规范、页面优化 |
| `picasso-dev-config` | 配置协同、菜单字典 SQL |
| `picasso-dev-maintainer` | 规则维护与更新记录 |

## 🧪 示例目录

当前内置示例：

- `examples/maintenance-plan`
  - 真实“保养方案”原型整理示例，按完整主产物链组织
- `examples/attendance-mobile`
  - 预留给移动端 / 小程序双端案例
- `examples/recruitment-manage`
  - 预留给变更需求 / Bug 修复案例

## ❓ 常见问题

### 为什么不用日期做需求目录名？

因为需求周期可能跨多天，日期命名不利于长期续写、回查和交接。统一使用英文代号更稳定。

### 为什么 `workspace/` 放仓库里但不提交？

因为这样最容易找，也最适合多人协作；同时通过 `.gitignore` 避免把真实运行产物带入仓库历史。

### 没有安装 `codex-plugin-cc` 能用吗？

可以。插件是可选增强项，不是必需依赖。

### 哪些文件可以改路径，哪些不要改？

新环境只改 `.env`。`profile.yaml`、`repo-map.md`、`README.md` 里保留的是规则和变量入口，不应该回写个人电脑绝对路径。

### 如何查看 skill 有哪些调整？

查看 `governance/CHANGELOG.md` 和 `governance/updates/`。

## 📄 许可证

本项目用于内部研发协作，请按团队规范使用。

---

<div align="center">
  <strong>Picasso Dev Skill · 标准化 · 可复刻 · 可协作</strong>
</div>

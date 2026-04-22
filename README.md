# 毕加索 Picasso Dev Skill

---

<div align="center">
  <strong>毕加索项目标准化开发技能包 · 单入口调度 · 多 Agent 协作 · 模型无关 · 多运行端兼容</strong>
  <br>
  <br>
  <p>面向 Picasso 项目的可复刻开发技能包，覆盖需求分析、技术方案、UI设计、编码、自测、审查、测试、验收与部署</p>
  <p>支持 PC Web、微信小程序、移动端 App，采用单一源目录管理，适合团队围绕同一仓库直接使用</p>
</div>

---

<font face="微软雅黑" size=2 color=#A9A9A9>版权声明：内容供技术友人学习使用，请勿外传！转载请附上作者信息</font>

第一次接手这个仓库，先看 [START-HERE.md](/Users/qierkang/.codex/codex-workspace/picasso-dev-skill/START-HERE.md)。

## 🗺️ 架构图

这张图把 `picasso-dev-skill` 的入口层、主流程层、方法层、支撑层和产出层放在一张图里，适合先看整体，再进细节。

![picasso-dev-skill workflow architecture](./assets/architecture/workflow-architecture.png)

## 📋 项目概述

Picasso Dev Skill 是一套面向毕加索项目的标准化开发技能包，不是单一 skill，而是一个可分发、可复刻、可协作的研发工作流工具集。
当前分发口径已收紧为：只保留当前仓库这一份 canonical skill 源目录。

它提供统一入口 `picasso-dev`，并通过 companion skills 覆盖后端任务、三端 UI、配置协同、技能维护等场景。它本质上是“流程标准包”，不绑定某一个具体模型；只要运行端能识别并执行这套 skill，就可以单独使用，也可以多运行端协作使用。

## 🎯 核心特色

- **统一入口**：所有 Picasso 需求统一从 `picasso-dev` 进入
- **多 Agent 协作**：支持总控、PM、架构、UI、前端、后端、移动端、小程序、QA、Review、Ops 协作
- **多端支持**：覆盖 PC Web、微信小程序、移动端 App
- **单一源目录**：只保留当前仓库这一份 canonical 技能包，不再向其他平台目录复制副本
- **配置即运行**：复制仓库、填写 `.env`、执行 `setup / doctor` 后即可进入标准开发流程
- **设计能力可插拔**：UI 阶段如运行端已安装 `ui-ux-pro-max`，优先协同外部设计 skill；未安装时自动回退到仓库内置设计底座
- **运行数据分离**：技能包规则和需求运行产物分层管理
- **维护记录可追溯**：所有规则调整统一记录到 `governance/`
- **执行模式灵活**：支持单运行端独立执行，也兼容 Claude Code + Codex 协作开发

## 📁 目录结构

```text
picasso-dev-skill/
├── .claude-plugin/ # Claude Code 适配层
├── .codex/         # Codex 适配层
├── .opencode/      # OpenCode 适配层
├── .openclaw/      # OpenClaw 适配层
├── SKILL.md        # 根级技能入口索引
├── install/        # 初始化、体检、同步、升级脚本
├── skills/         # 核心技能入口
├── profiles/       # 项目画像（当前为 Picasso）
├── shared/         # 模板、提示词、参考资料、通用脚本
├── vendor/         # 外部 skill / 规则镜像预留区
├── workspace/      # 需求运行产物（默认不提交）
├── governance/     # 技能包维护记录（需要提交）
└── examples/       # 示例需求与标准样例
```

### 目录说明

| 目录 | 用途 |
|------|------|
| `.claude-plugin/` | Claude Code 接入说明与适配约定 |
| `.codex/` | Codex 接入说明与适配约定 |
| `.opencode/` | OpenCode 接入说明与适配约定 |
| `.openclaw/` | OpenClaw 总控接入说明与适配约定 |
| `install/` | 新环境初始化、环境检查、技能同步 |
| `SKILL.md` | 根目录总入口索引，兼容只识别根级 skill 的平台 |
| `skills/` | `picasso-dev` 及其 companion skills |
| `profiles/` | Picasso 项目画像、仓库映射、技术栈、环境说明 |
| `shared/` | 工作流定义、中文模板、Prompt、脚本、公共规则 |
| `vendor/` | 外部来源收编预留区，不作为宿主机依赖跳板 |
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
- `picasso-dev-design-system`
  - 设计风格、token、组件层级、动效和可访问性基线
- `picasso-dev-ui-review`
  - 页面实现后的 UI 审查、交互审查和差异回流
- `picasso-dev-config`
  - 菜单、字典、SQL、环境配置协同
- `picasso-dev-methods`
  - 规划、TDD、系统化排障、完成前验证、代码审查处理、并行与隔离方法
- `picasso-dev-maintainer`
  - skill 包维护、规则变更记录、Changelog 沉淀

## 🧱 方法层与适配层

当前结构采用“主流程层 + 方法层 + 适配层”的收敛方式：

- 主流程层：`skills/picasso-dev/`
  - 统一负责需求识别、产物链路、阶段推进和执行路由
- 方法层：`skills/picasso-dev-methods/`
  - 统一内化 planning、TDD、debugging、verification、review、parallel/isolation
- 适配层：`.claude-plugin/`、`.codex/`、`.opencode/`、`.openclaw/`
  - 只维护各运行端如何接入，不复制第二套主流程

这样做的目的有两个：

1. 目录更容易理解，接近 `Superpowers` 那种“规则层 + 适配层”的表达方式
2. 保证整包迁移时不依赖宿主机已有 skill

## 🧭 Harness Engineering 思路参考

当前技能包在结构设计上参考了 Harness Engineering 中“把上下文、约束、反馈回路和执行入口收进仓库”的标准化思路，重点体现在：

- 用统一入口和目录分层收口主流程，而不是把规则散落在多处
- 用模板、画像、公共规则和治理记录作为长期可复用的上下文载体
- 用 `doctor.sh`、`stage-gate.py`、运行编排脚本把关键约束尽量落成可执行检查
- 用显式适配层兼容不同运行端，同时保持主流程和质量口径一致

因此，阅读和使用 `picasso-dev-skill` 时，可以把它理解为一套“参考 Harness Engineering 思路做标准化收敛”的 Picasso 项目研发技能包。

## 🔌 运行端兼容口径

当前 skill 包是“模型无关、运行端兼容”的设计：

- 可以只接 OpenClaw 使用
- 可以只接 Claude Code 使用
- 可以只接 Codex 使用
- 也可以让 Claude Code + Codex 按同一套 skill 协作开发

换句话说：

1. `picasso-dev-skill` 不依赖某个具体模型才成立
2. Claude Code、Codex、OpenClaw 只是可选执行端
3. 多运行端协作是增强方式，不是前置依赖

## 🎨 外部设计 skill 协同

当前推荐在 UI 设计和 UI 审查阶段优先协同 `ui-ux-pro-max`，但它不是强依赖。

规则如下：

1. 若运行端可识别 `ui-ux-pro-max`
   - 先让它给出风格方向、token、组件策略、动效、可访问性基线
   - 再由 `picasso-dev-ui` 把这些内容落成项目可执行的 UI 文档和验收口径
2. 若运行端不可识别 `ui-ux-pro-max`
   - 自动回退到 `shared/references/design/`
   - 继续按 Picasso 的模板、Gate 与验收流程推进
3. 即使运行端还能识别 `frontend-design` 等通用设计 skill，也不得把它们当成默认回退路径

## 📦 Vendor 策略

`vendor/` 不是“把外部 skill 直接依赖进来”，而是一个可控的收编缓冲区。

当前策略见 `governance/vendor-skills.yaml`，核心原则是：

- `internalize-first`
- `runtime_dependency: forbidden`

也就是：

1. 优先把外部 skill 的高价值方法内化到 `picasso-dev-methods`
2. 只有确实需要保留外部完整副本时，才写入 `vendor/skills/`
3. 不允许主流程依赖宿主机 `~/.agents/skills` 一类外部路径

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
- `QA验收报告模板.md`
- `UI验收报告模板.md`
- `产品验收报告模板.md`
- `发布记录模板.md`

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
- `服务端任务状态管理.md`
- `服务端任务归档恢复与撤销.md`
- `服务端需求变更流程.md`
- `服务端快捷触发语义.md`
- `服务端 Codex 协作规范.md`
- `子产品与模块映射.md`

质量卡点公共规则统一放在 `shared/references/quality/`：

- `前端开发自测清单.md`
- `两关制冒烟测试说明.md`

设计底座与平台专项规则统一放在 `shared/references/design/`：

- `设计风格方向库.md`
- `设计Token基线.md`
- `Web页面模式.md`
- `iOS-SwiftUI规范.md`
- `Android-Material3规范.md`
- `微信小程序交互规范.md`
- `动效与反馈规范.md`
- `可访问性与响应式规范.md`

README 生成与开源发布规范统一放在 `shared/references/readme/`：

- `README.md`
- `spec-open-source-readme-master-prompt.md`
- `spec-open-source-readme-style-reference.md`
- `spec-open-source-readme-template.md`

README 产出工作流统一放在 `shared/workflow/open-source-readme.md`，门禁脚本统一放在 `shared/scripts/readme-gate.py`。

## 🛠️ 环境要求

### 基础能力

- `git`
- `python3`
- 任一可用运行端或模型 CLI 即可开始
- `claude`、`codex`、`openclaw` 等按你实际使用情况选配

### 后端开发能力

- `java` 21+
- `maven` 或仓库内 `mvnw`

### 前端 / 小程序开发能力

- `node` 20+
- `pnpm`

### 本地数据库能力

- `psql`（需要做本地 SQL / 数据查询时）

### 移动端能力

- `flutter`
- 小程序开发工具（按需）

## 🔒 环境边界

当前 skill 固定为 `local-only` 模式：

- 允许：`local`、`dev`
- 禁止：`test`、`uat`、`prod`

也就是说：

- 开发、自测、SQL、冒烟、发布准备都只允许在 `local / dev`
- 不能尝试连接测试、UAT、生产数据库
- 不能尝试连接测试、UAT、生产服务器部署
- 如果服务端仓库存在 `application-test.yaml`、`application-uat.yaml`、`application-prod.yaml`，它们只用于识别边界，不代表允许访问

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
bash install/doctor.sh --capability dev
```

### 5. 如需清理历史外部副本

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

- 支持按能力体检：`docs / dev / db / deploy / all`
- `docs` 只校验文档产出所需的最小运行条件
- 开发前检查 `java / maven / node / pnpm / flutter` 等工具链
- 会校验 Picasso 前端仓库声明的 `node / pnpm` 最低版本，以及 Java 21 基线
- 查询数据库前检查 `psql` 和本地数据库 Host 是否仍是 `127.0.0.1 / localhost`
- 自动识别 `application-local.yaml / application-dev.yaml / application-test.yaml / application-uat.yaml / application-prod.yaml`
- 明确把 `test / uat / prod` 识别为受限环境
- 当前能力没通过时，默认先修环境，再继续真实开发
- `deploy` 能力会额外校验自动联调入口：后端 / 前端启动命令、就绪地址、自动登录配置

常用命令：

```bash
bash install/doctor.sh --capability docs
bash install/doctor.sh --capability dev
bash install/doctor.sh --capability db
bash install/doctor.sh --capability deploy
```

## 自动联调与自动冒烟

当前 skill 的目标不是“把流程写出来”，而是把本地闭环真正跑起来。

只要 `.env` 已补齐以下入口，进入 `deploy` 能力后就默认按自动链路执行：

- `PICASSO_BACKEND_START_WORKDIR`
- `PICASSO_BACKEND_START_CMD`
- `PICASSO_BACKEND_BASE_URL`
- `PICASSO_BACKEND_HEALTH_URL`
- `PICASSO_FRONTEND_START_WORKDIR`
- `PICASSO_FRONTEND_START_CMD`
- `PICASSO_FRONTEND_READY_URL`
- `PICASSO_AUTO_START_LOCAL_SERVICES`
- `PICASSO_AUTO_STOP_LOCAL_SERVICES`
- `PICASSO_AUTO_FETCH_ACCESS_TOKEN`
- `PICASSO_LOGIN_URL`
- `PICASSO_LOGIN_REQUEST_BODY_TEMPLATE`
- `PICASSO_LOGIN_TOKEN_PATH`

默认行为：

- `doctor deploy` 先检查运行编排变量是否完整
- 冒烟脚本自动 source `shared/scripts/runtime-lib.sh`
- 自动启动后端、等待健康检查
- 自动启动前端、等待页面 ready
- 按需自动登录拿 token
- 自动执行两关制冒烟
- 脚本结束后自动停止本次拉起的本地服务
- `python3 shared/scripts/stage-gate.py smoke ...` 默认真实执行脚本，不再只读报告文本

### `sync.sh`

- 不再向任何外部平台目录复制 skill 副本
- 只负责清理历史外部副本，确保当前仓库成为唯一 canonical skill 源目录
- 若宿主机已有历史独立目录或旧根包副本：
  - `picasso-dev-skill`
  - `picasso-dev`
  - `picasso-dev-task`
  - `picasso-dev-ui`
  - `picasso-dev-config`
  - `picasso-dev-maintainer`
  - `zzpms-dev-ui`
  会自动移动到当前用户回收站
- 默认清理目录：
  - `~/.openclaw/skills`
  - `~/.claude/skills`
  - `~/.codex/skills`
  - `~/.opencode/skills`

### `upgrade.sh`

- 顺序执行 `setup.sh`、`doctor.sh`、`sync.sh`
- 适合技能包升级后快速刷新本地环境

## ⚙️ 配置说明

## 🧭 使用前的默认规则

进入任意真实开发线程前，默认按下面顺序执行：

1. 先判断当前只需要 `docs`、还是已经进入 `dev / db / deploy`
2. 先跑对应能力的 `doctor.sh`
3. `doctor` 失败时先修环境，再重跑同一能力
4. 只有当前能力无 `FAIL`，才进入真实开发动作
5. 环境通过后默认自主推进，不反复询问“要不要继续”

`.env` 中至少需要配置以下内容：

```env
PICASSO_ENV_BOUNDARY_MODE=local-only
PICASSO_ALLOWED_RUNTIME_PROFILES=local,dev
PICASSO_FORBIDDEN_RUNTIME_PROFILES=test,uat,prod
PICASSO_SERVER_CODE_DIR=
PICASSO_FRONT_CODE_DIR=
PICASSO_MINIAPP_CODE_DIR=
PICASSO_MOBILE_APP_CODE_DIR=
PICASSO_SERVER_TASK_DIR=./workspace/server-tasks
PICASSO_DEFAULT_BRANCH=master
PICASSO_WORKSPACE_DIR=./workspace
PICASSO_LOCAL_DB_HOST=127.0.0.1
PICASSO_LOCAL_DB_PORT=5432
PICASSO_LOCAL_DB_NAME=ruoyi-vue-pro
PICASSO_REQUIRE_LOCAL_DB_CLI=true
PICASSO_SKILL_ROOT_DIR=.
# 以下旧变量已废弃，仅用于清理历史副本，不再用于分发
OPENCLAW_SKILLS_DIR=
CLAUDE_SKILLS_DIR=
CODEX_SKILLS_DIR=
OPENCODE_SKILLS_DIR=
```

### 配置项说明

| 配置项 | 说明 |
|--------|------|
| `PICASSO_ENV_BOUNDARY_MODE` | 当前必须固定为 `local-only` |
| `PICASSO_ALLOWED_RUNTIME_PROFILES` | 允许操作的 profile，固定 `local,dev` |
| `PICASSO_FORBIDDEN_RUNTIME_PROFILES` | 禁止操作的 profile，固定 `test,uat,prod` |
| `PICASSO_SERVER_CODE_DIR` | 后端源码目录 |
| `PICASSO_FRONT_CODE_DIR` | PC 前端源码目录 |
| `PICASSO_MINIAPP_CODE_DIR` | 小程序源码目录 |
| `PICASSO_MOBILE_APP_CODE_DIR` | 移动端源码目录 |
| `PICASSO_SERVER_TASK_DIR` | 服务端任务管理目录 |
| `PICASSO_DEFAULT_BRANCH` | 默认开发基线分支 |
| `PICASSO_WORKSPACE_DIR` | 运行产物目录 |
| `PICASSO_LOCAL_DB_HOST/PORT/NAME` | 本地数据库连接 |
| `PICASSO_REQUIRE_LOCAL_DB_CLI` | 查询本地库时是否强制要求 `psql` |
| `PICASSO_SKILL_ROOT_DIR` | 当前 canonical skill 源目录 |

## 🧪 使用前的默认规则

1. 纯文档任务：
   - 可以只跑 `bash install/doctor.sh --capability docs`
   - 不强依赖完整开发工具链
2. 进入编码前：
   - 先跑 `bash install/doctor.sh --capability dev`
3. 进入 SQL / 数据查询前：
   - 先跑 `bash install/doctor.sh --capability db`
4. 进入本地启动 / 冒烟 / 发布准备前：
   - 先跑 `bash install/doctor.sh --capability deploy`
5. 未通过对应能力体检前，不进入下一步真实开发

## 🤖 执行风格

这套 skill 的目标不是每一步都问使用者“要不要继续”，而是：

- 在规则明确的前提下默认自主执行
- 先自检环境，再推进开发
- 发现缺失时，先自动修 skill 自身问题
- 遇到外部环境缺失时，再一步步引导安装
- 最终尽量只向使用者交付访问地址、账号密码、验证路径和结果

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
  - `PICASSO_SKILL_ROOT_DIR`

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

`需求分析 → 技术方案 → UI设计 → 任务拆解 → 编码开发 → 开发自测 → 代码审查 → 冒烟测试 → QA验证 → UI验收 → 产品验收 → 部署上线`

### 强制 Gate

- `任务分解卡点`：没有 `任务分解.md` 不进入真实开发
- `开发自测卡点`：没有 `开发放行报告.md` 不进入 review
- `覆盖率卡点`：没有 `覆盖率报告.md` 和 `前端关键流程覆盖清单.md` 不进入 review
- `代码审查卡点`：有 `P0 / 阻塞` 不进入 smoke
- `冒烟测试卡点`：未达到 `100% 通过` 不进入 QA
- `QA 验证卡点`：未通过不进入 UI 验收
- `UI 验收卡点`：未通过不进入产品验收
- `产品验收卡点`：默认结论为 `NEEDS_WORK`

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
        ├── 保养方案-QA验收报告.md
        ├── 保养方案-UI验收报告.md
        ├── 保养方案-产品验收报告.md
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
| `picasso-dev-methods` | 规划、TDD、排障、验证、审查、并行方法 |
| `picasso-dev-maintainer` | 规则维护与更新记录 |

说明：

- 上表是 skill 内部分工，不等于必须同时启用多个模型
- 单独一个运行端也能走完整流程
- 如你希望 Claude Code 和 Codex 协作，它们共享的仍然是这套 Picasso skill 规则，而不是各跑一套独立流程

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

### 没有 Claude 或 Codex，只有 OpenClaw 能用吗？

可以。只要 OpenClaw 运行时能读取当前仓库路径即可，不再要求复制到 `~/.openclaw/skills`。

### Claude Code 和 Codex 一起协作时兼容吗？

兼容。它们可以按同一套 `picasso-dev` / `picasso-dev-methods` 规则协作推进，但这是一种可选增强，不是 skill 包的前置依赖。

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

# CHANGELOG

## Unreleased

- 按 `platform-project-skill` existing route 补齐中英文开源 README、双语架构图、social preview、资产 manifest、MIT、贡献指南、Issue 模板和 CI。
- 新增双语 README gate 与老项目 AI 能力升级报告。

## v0.1.0

- 初始化 `picasso-dev-skill` 仓库结构
- 建立统一入口 `picasso-dev`
- 建立 `workspace/` 运行区与 `governance/` 维护区
- 补齐 5 个核心 skill、Picasso profile、模板、脚本和示例结构

## v0.2.0

- 迁移旧版 `zzpms-dev` 的强质量卡点
- 新增 `覆盖率报告模板.md` 与 `前端关键流程覆盖清单模板.md`
- `stage-gate.py` 升级为带阶段状态回写的硬 Gate 校验脚本
- `maintenance-plan` 示例补齐质量 Gate 相关产物

## v0.2.1

- 新增仓库根目录 `SKILL.md`，作为 `picasso-dev-skill` 的总入口索引
- 兼容只识别根级 `SKILL.md` 的平台，同时保留 `skills/picasso-dev` 作为实际主流程入口

## v0.3.0

- 补齐旧 `picasso-task` 的任务生命周期规则：状态管理、归档恢复、变更流程、快捷触发
- 发布流程升级为六步法，并新增 `发布记录模板.md`
- 两关制冒烟脚本模板升级，补强第 2 关的文件、路由、Controller 校验项
- `sync.sh` 现在会同步根级 `picasso-dev-skill` 包和独立子 skill

## v0.3.1

- 将原先合并的 `QA与产品验收` 正式拆分为 `QA验证`、`UI验收`、`产品验收` 三个独立卡点
- 新增 `QA验收报告模板.md`、`UI验收报告模板.md`、`产品验收报告模板.md`
- `stage-gate.py` 现在要求按 `qa -> ui_acceptance -> product_acceptance -> release` 顺序推进
- `maintenance-plan` 示例已同步改成三份独立验收报告，便于真实模拟与教学演示

## v0.3.2

- 新增按能力划分的环境预检闭环：`docs / dev / db / deploy / all`
- `doctor.sh` 现在会校验 `local-only` 边界、Java 21、前端仓库声明的 `node / pnpm` 最低版本，以及本地 `psql`
- 主 skill、workflow、manifest、Codex CLI 标准执行输入统一要求：先通过 `doctor.sh`，再进入真实开发
- 当前 skill 的默认执行风格收紧为“环境通过后自主推进 routine 动作，只在真实阻塞时升级给使用者”

## v0.3.3

- 新增 `shared/scripts/runtime-lib.sh`，把本地启动、等待 ready、自动登录、自动收尾统一收口到脚本库
- `stage-gate.py smoke` 现在默认真实执行冒烟脚本，并把输出落到 `logs/stage-gate-smoke.log`
- `deploy doctor` 现在会校验运行编排入口：后端 / 前端启动命令、ready 地址、自动登录配置
- 冒烟脚本模板与 `maintenance-plan` 示例已切换到可执行运行编排口径
- 已用 mock 前后端完成一次真实模拟，验证“自动启动 → 自动联调 → 自动冒烟 → 自动收尾”闭环可跑通

## v0.3.4

- 新增 `skills/picasso-dev-methods`，把 planning、TDD、systematic debugging、verification、review、parallel/isolation 方法内化进包内
- 新增 `vendor/` 与 `governance/vendor-skills.yaml`，明确“internalize-first + 禁止运行时外部依赖”的策略
- 新增 `.claude-plugin/`、`.codex/`、`.opencode/`、`.openclaw/` 适配层目录，提升多运行端目录可理解性
- `README.md`、主入口 skill、维护规则与同步脚本已同步更新，保证方法层与适配层可以一起分发

## v0.3.5

- 收敛 README 与适配层文案，明确 `picasso-dev-skill` 是“模型无关、运行端兼容”的流程标准包
- 明确 OpenClaw 可独立使用，Claude Code + Codex 协作是兼容增强方案，不是前置依赖

## v0.3.6

- 新增根目录 `START-HERE.md`，作为新环境与首次接手场景的统一入口
- `README.md`、根级 `SKILL.md`、`sync.sh` 已同步接入 `START-HERE.md`
- `START-HERE.md` 已单独补充“Claude Code + Codex + codex-plugin-cc”协作入口说明，四个适配层入口也已统一指向 `START-HERE.md`

## v0.3.7

- `shared/templates/需求文档模板.md` 已改为“产品经理版页面拆解骨架 + AI 版结构化补充 + 当前 skill 系统级强约束”融合版
- 新模板默认支持按模块拆成列表页、详情页、系统字段、按钮行为、业务规则来填写
- 同时补入 `范围说明`、`数据联动与回写`、`审批流与特殊分支` 等更适合 AI 生成和后续开发映射的结构块

## v0.3.8

- `README.md` 已补充 `Harness Engineering 思路参考` 章节
- 当前对外定位明确为“参考 Harness Engineering 的标准化思路做结构收敛”，不把仓库表述成独立框架实现

## v0.3.9

- 新增设计底座目录 `shared/references/design/`，补齐风格方向、token、Web、iOS、Android、小程序、动效、可访问性规则
- 新增 `picasso-dev-design-system`、`picasso-dev-ui-review` 以及 `picasso-dev-ui-web / ios / android / miniapp` 专项 skill
- `picasso-dev-ui` 升级为 UI 设计路由入口，支持先补设计底座再按平台补专项
- `UI交互设计模板.md` 与 `UI验收报告模板.md` 已补风格、token、动效、可访问性相关结构
- `README.md`、根级 `SKILL.md`、模板说明与 vendor 采用记录已同步更新

## v0.3.10

- 真实 Claude 隔离回归后，已将 UI fallback 规则加硬为“`ui-ux-pro-max` 缺失时只允许回退到仓库内置 `shared/references/design/`”
- `AGENTS.md`、根级入口、主入口 skill、UI skill、设计底座索引、Claude/Codex 适配层已显式禁止把 `frontend-design` 之类通用设计 skill 当成默认兜底
- 新增根级 `CLAUDE.md`，把 UI 路由硬约束直接前置给 Claude 运行端

## v0.3.11

- `sync.sh` 已收口为“只同步一个 `picasso-dev-skill` 根包”，不再把 companion skills 拆成宿主机顶层独立目录
- `sync.sh` 会在同步前自动归档历史独立目录 `picasso-dev* / zzpms-dev-ui` 到当前用户回收站
- `README.md` 已同步改成“单技能包目录”口径，避免新环境继续产生重复 skill 目录

## v0.3.12

- 进一步收紧为“只保留当前仓库这一份 canonical skill 源目录”，不再向 `~/.claude/skills`、`~/.codex/skills`、`~/.openclaw/skills` 生成任何副本
- `sync.sh` 现已改为“外部副本清理脚本”，仅负责回收历史副本，不再分发
- `.env.example`、`doctor.sh`、`profile.yaml`、`README.md`、`START-HERE.md`、`配置入口说明.md`、`execution-modes.md`、`repo-map.md` 已统一改成单一源目录口径

## v0.3.13

- 新增 `shared/references/readme/`，将 GitHub 开源 README 的主提示词、风格参考和结构模板内化到 skill 包内
- 新增 `shared/workflow/open-source-readme.md`，把 README 生成、改写与校验串成标准工作流
- 新增 `shared/scripts/readme-gate.py`，用于校验 README 章节完整性与占位符残留
- `README.md`、`skills/picasso-dev/SKILL.md`、`skills/picasso-dev-maintainer/SKILL.md` 已同步接入新的 README 路由

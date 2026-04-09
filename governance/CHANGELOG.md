# CHANGELOG

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

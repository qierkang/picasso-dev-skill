# Codex 适配层

这里放 Codex 侧的接入说明与约定。

第一次接手当前仓库，先看 `../START-HERE.md`。

## 当前约定

1. Codex 使用根级 `SKILL.md` 或直接进入 `skills/picasso-dev/SKILL.md`
2. 若任务涉及方法论增强、外部 skill 对照、并行与隔离策略，补读 `skills/picasso-dev-methods/SKILL.md`
3. Codex 侧只负责执行，不单独维护第二套 Picasso 规则
4. Codex 是可选运行端，不是本 skill 包的必需依赖

## UI 设计协同

若 Codex 当前环境可识别 `ui-ux-pro-max`，进入 UI 设计与 UI 审查阶段时优先协同它。

若不可识别，则自动回退到：

- `shared/references/design/README.md`

即使当前环境还能识别 `frontend-design` 等通用设计 skill，也不得把它们当成默认回退路径。

## 与其他运行端协作

- Codex 可以单独执行这套 skill
- 也可以和 Claude Code 共用同一套 Picasso 规则协作开发
- 协作时共享的是 skill 包规则，不是各自维护独立流程

## 重点边界

- 编码、SQL、启动、冒烟前，遵守 `doctor.sh`
- 仅允许 `local / dev`
- 最终状态仍以 `stage-gate.py` 与需求目录产物为准

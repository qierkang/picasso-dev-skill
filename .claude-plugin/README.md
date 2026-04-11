# Claude Code 适配层

这里放 Claude Code 侧的接入说明与必要配置约定。

第一次接手当前仓库，先看 `../START-HERE.md`。

## 职责

- 说明 Claude Code 如何发现 `picasso-dev-skill`
- 说明 Claude 侧应优先进入的 skill 与边界
- 如未来需要插件配置文件，也统一放在本目录

## 当前约定

1. 主入口仍然是 `../skills/picasso-dev/SKILL.md`
2. 方法增强统一来自 `../skills/picasso-dev-methods/SKILL.md`
3. 不能在 Claude 侧额外复制一套独立主流程
4. Claude Code 是可选运行端，不是本 skill 包的必需依赖

## 与其他运行端协作

- Claude Code 可以单独执行这套 skill
- 也可以和 Codex 共用同一套 Picasso 规则协作开发
- 协作时共享的是 skill 包规则，不是各自维护独立流程

## 建议读取顺序

1. `../SKILL.md`
2. `../README.md`
3. `../skills/picasso-dev/SKILL.md`
4. `../skills/picasso-dev-methods/SKILL.md`

## UI 设计协同

若 Claude Code 当前环境可识别 `ui-ux-pro-max`，进入 UI 设计或 UI 审查阶段时优先协同它。

若当前环境不可识别该外部 skill，则自动回退到：

- `../shared/references/design/README.md`

即使当前环境还能识别 `frontend-design` 等通用设计 skill，也不得把它们当成默认回退路径。

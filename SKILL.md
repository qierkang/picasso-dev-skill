---
name: picasso-dev-skill
description: Use when the user wants to use the Picasso development skill package as a whole, needs a standard root-level skill entry for Picasso project work, or needs help choosing the correct Picasso companion skill for requirement analysis, design, coding, testing, UI, config, or maintenance work.
---

# Picasso Dev Skill

## 定位

这个文件是 `picasso-dev-skill` 仓库根目录的总入口索引。

它的作用不是重复定义整套流程，而是让任何只识别“根目录是否有 `SKILL.md`”的平台，也能正确进入 Picasso 技能包。

如果是第一次接手当前仓库，先读：

- `START-HERE.md`

## 使用原则

1. 遇到 Picasso 项目开发任务，默认先转到 `skills/picasso-dev/SKILL.md`
2. 不在根级 `SKILL.md` 里重复维护需求、方案、UI、测试、验收细节
3. 实际规则以子 skill 和 `shared/`、`profiles/` 中的文件为准

## 路由入口

### 主入口

优先读取：

- `skills/picasso-dev/SKILL.md`

适用场景：

- 新需求开发
- 需求变更
- Bug 修复
- UI 优化
- 需要统一推进需求、方案、UI、任务、测试、验收和部署

### Companion Skills

按任务需要继续读取：

- `skills/picasso-dev-task/SKILL.md`
  - 服务端任务、接口、表结构、公共依赖、OpenSpec、后端推进
- `skills/picasso-dev-ui/SKILL.md`
  - PC / 小程序 / App 的 UI 设计、页面优化、原型还原
- `skills/picasso-dev-design-system/SKILL.md`
  - 风格方向、token、组件层级、动效、可访问性基线
- `skills/picasso-dev-ui-review/SKILL.md`
  - UI 还原审查、交互审查、差异清单与回流建议
- `skills/picasso-dev-config/SKILL.md`
  - 菜单、字典、SQL、环境配置和联调依赖
- `skills/picasso-dev-methods/SKILL.md`
  - 规划、TDD、系统化排障、完成前验证、审查处理、多代理并行与隔离
- `skills/picasso-dev-maintainer/SKILL.md`
  - 技能包自身维护、治理记录、Changelog、迁移说明

若当前运行端可识别 `ui-ux-pro-max`，UI 阶段优先协同它；若不可识别，则自动回退到 `shared/references/design/`。

即使当前运行端还能识别 `frontend-design` 等通用设计 skill，也不得把它们当成 `ui-ux-pro-max` 缺失时的默认兜底。

## 必须先读的仓库级文件

若当前平台只从根目录进入，请至少先读取：

1. `README.md`
2. `START-HERE.md`
3. `profiles/picasso/profile.yaml`
4. `profiles/picasso/execution-modes.md`
5. `shared/references/requirements/README.md`
6. `shared/references/task/README.md`

然后再进入对应子 skill。

## 标准理解

这个仓库是“技能包仓库”，不是“单文件 skill 仓库”。

所以标准入口是：

- 根目录 `SKILL.md` 负责发现与分发
- `skills/picasso-dev/SKILL.md` 负责主流程
- 其他 `skills/picasso-dev-*` 负责专项能力

## 产物与维护位置

- 运行中的需求产物：`workspace/`
- 技能包维护记录：`governance/`
- 示例需求：`examples/`

不要把业务需求运行产物写进 `governance/`。

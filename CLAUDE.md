# Picasso Dev Skill Claude Rules

1. 本仓库默认遵守 `AGENTS.md`、`SKILL.md`、`skills/picasso-dev/SKILL.md`、`skills/picasso-dev-ui/SKILL.md`、`skills/picasso-dev-design-system/SKILL.md`。
2. 进入 UI 设计、页面优化或 UI 审查阶段时：
   - 若当前运行端可识别 `ui-ux-pro-max`，优先使用它补风格方向、token、组件策略、动效与可访问性。
   - 若当前运行端不可识别 `ui-ux-pro-max`，唯一允许的回退路径是 `shared/references/design/`。
3. 即使当前运行端还能识别 `frontend-design` 或其他通用设计 skill，也不得把它们当成 `ui-ux-pro-max` 缺失时的默认兜底。
4. 最终必须回到 Picasso 包内模板、设计底座和 Gate，不允许因宿主机有别的通用设计 skill 就改走其他设计流程。

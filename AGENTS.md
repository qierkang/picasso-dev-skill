# Picasso Dev Skill 约定

1. 所有回复优先使用中文简体。
2. 统一从 `skills/picasso-dev/SKILL.md` 作为主入口进入。
3. 需求运行产物默认写入 `workspace/requests/<request-key>/`。
4. skill 包规则变更默认写入 `governance/updates/` 与 `governance/CHANGELOG.md`。
5. 不使用日期作为需求目录主键，统一使用英文代号。
6. 默认工作流是：需求分析 → 技术方案 → UI设计 → 任务拆解 → 编码开发 → 开发自测 → 审查 → 冒烟 → QA → 验收 → 部署。
7. 对 Picasso 项目默认支持：
   - 后端
   - PC Web
   - 微信小程序
   - 移动端 App
8. `workspace/` 为运行区，默认不提交；`governance/` 为维护区，需要提交。
9. 进入真实开发前，先按能力执行 `doctor.sh`；`docs / dev / db / deploy` 以实际任务为准。
10. 当前 skill 固定 `local-only`：只允许 `local / dev`，禁止连接、查询、部署 `test / uat / prod`。
11. `.env` 如已配置运行编排入口，默认自动执行：启动后端 → 启动前端 → 自动联调 → 自动冒烟 → 自动收尾。
12. 方法论增强统一由 `skills/picasso-dev-methods/SKILL.md` 提供，不依赖宿主机外部 skill 路径。
13. `.claude-plugin/`、`.codex/`、`.opencode/`、`.openclaw/` 为运行端适配层；主流程与共享规则仍以 `skills/`、`shared/`、`profiles/`、`governance/` 为准。
14. `vendor/` 是外部 skill 镜像预留区；是否内化、镜像或拒绝引入，以 `governance/vendor-skills.yaml` 为准。
15. 涉及 UI 设计、页面优化、交互改版、设计系统输出时：
   - 若当前运行端可识别 `ui-ux-pro-max`，优先借助它补风格方向、token、组件策略、动效、可访问性；
   - 若当前运行端不可识别该外部 skill，自动回退到仓库内置的 `shared/references/design/`，不得因此中断主流程；
   - 回退时默认不得改用 `frontend-design` 或其他通用设计 skill 充当兜底。

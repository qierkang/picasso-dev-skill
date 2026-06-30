# 变更记录：新增开源 README 工作流

- 提交人：qierkang+codex
- 日期：2026-04-21
- 影响范围：`shared/references/readme/`、`shared/workflow/open-source-readme.md`、`shared/scripts/readme-gate.py`、`README.md`、`SKILL.md`
- 变更原因：把 GitHub 开源 README 的主提示词、风格参考和结构模板内化到 skill 包内，并补齐生成与校验工作流，避免继续依赖仓库外部路径
- 本次修改：
  - 新增 README 三件套的 skill 内引用副本
  - 新增 README 生成工作流
  - 新增 README 结构门禁脚本
  - 更新根 README 与主入口索引，明确新的文档路由
- 对使用者的影响：
  - 现在可以直接在 skill 包内生成和校验开源 README
  - 模板可随 skill 包整体迁移，不再强依赖 `docs/documents/` 上层路径
- 后续建议：
  - 未来若继续迭代 README 规范，优先同步 `docs/documents/` 与 `shared/references/readme/`
  - 新增 README 任务时，默认先走 `shared/workflow/open-source-readme.md`

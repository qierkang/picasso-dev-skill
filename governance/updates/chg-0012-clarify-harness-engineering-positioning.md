# chg-0012 README 补充 Harness Engineering 思路参考定位

- 提交人：qierkang+codex
- 日期：2026-04-09
- 影响范围：
  - `README.md`
- 变更原因：
  - 当前 `picasso-dev-skill` 已具备明显的标准化研发 harness 特征，但对外说明需要更克制
  - 用户希望 README 强调“参考 Harness Engineering 思路做标准化收敛”，而不是给阅读者造成“特意按该框架搭建”的印象
- 本次修改：
  - 在 `README.md` 中新增 `Harness Engineering 思路参考` 章节
  - 说明当前结构参考的是“上下文、约束、反馈回路和执行入口收进仓库”的标准化思路
  - 明确文案口径为“参考思路做标准化收敛”，不使用过度框架化表述
- 对使用者的影响：
  - 新接手者更容易理解该 skill 包的设计哲学
  - 不会误判当前仓库是对外宣称的独立 Harness 框架实现
- 后续建议：
  - 后续如继续增强仓库级 CI、结构校验、文档熵治理和可观测入口，可继续沿这一定位补充说明

# chg-0005 拆分 QA、UI 与产品验收卡点

## 基本信息

- 提交人：qierkang+codex
- 日期：2026-04-08
- 影响范围：
  - `shared/workflow/`
  - `shared/templates/`
  - `shared/scripts/`
  - `skills/picasso-dev/`
  - `skills/picasso-dev-ui/`
  - `examples/maintenance-plan/`
  - `README.md`

## 变更原因

- 旧口径把 `QA`、`UI 验收`、`产品验收` 混在一份报告里，脚本和流程都不够清晰
- 页面高还原度需求里，`功能验证通过` 不代表 `页面与交互已通过`
- 用户明确要求在 `QA` 之后增加独立的 `UI 验收` 与 `产品验收` 环节

## 本次修改

- 将主流程统一改为 `... 冒烟测试 → QA验证 → UI验收 → 产品验收 → 发布`
- 删除合并口径的 `QA与产品验收报告模板.md`
- 新增 `QA验收报告模板.md`、`UI验收报告模板.md`、`产品验收报告模板.md`
- 升级 `stage-gate.py`，拆成 `qa`、`ui_acceptance`、`product_acceptance` 三个独立 Gate
- 将 `maintenance-plan` 示例同步改成三份独立验收报告和新的 stage docs 映射

## 对使用者的影响

- 以后不能在 `QA` 通过后直接宣称可以发布，必须继续过 `UI 验收` 和 `产品验收`
- 页面型需求的还原度、交互符合度现在有单独卡点，不再被业务验收结论掩盖
- Claude / Codex / 单模型模式都可以更清楚地判断当前卡在“功能”、“页面”还是“业务口径”

## 后续建议

- 下一步用 `maintenance-plan` 再做一次完整流程模拟，验证三段验收卡点的体验是否足够顺
- 后续如补小程序 / App 示例，也按同一套三段验收口径继续推进

# chg-0002 强化质量卡点与阶段放行机制

## 基本信息

- 提交人：qierkang+codex
- 日期：2026-04-08
- 影响范围：
  - `skills/picasso-dev/SKILL.md`
  - `shared/workflow/`
  - `shared/templates/`
  - `shared/scripts/stage-gate.py`
  - `examples/maintenance-plan/`

## 变更原因

- 旧版 `zzpms-dev` 在任务分解、自测、覆盖率、代码审查、冒烟测试、默认 `NEEDS_WORK` 等方面更硬
- 新版 `picasso-dev-skill` 之前更偏“结构清晰”，但卡点执行力还不够
- 需要把旧版强卡点迁入新 skill，避免真实开发阶段跑偏

## 本次修改

- 新增覆盖率与前端关键流程覆盖模板
- 将阶段 Gate 升级为 `dev / review / smoke / qa / acceptance`
- 在 `stage-status.json` 中记录 checks / history / next_action / release_decision
- 把两关制冒烟和前端自测规则沉淀为公共质量参考
- 同步更新 `maintenance-plan` 示例产物

## 对使用者的影响

- 新需求初始化后会多出 2 份质量 Gate 文档
- 进入 review 前，必须补齐：
  - `开发放行报告`
  - `覆盖率报告`
  - `前端关键流程覆盖清单`
- 默认放行结论继续保持 `NEEDS_WORK`

## 后续建议

- 继续把旧版的高频问题库和项目专项脚本按模块迁入新 skill
- 为真实需求补一轮从编码到 Gate 的回放样例

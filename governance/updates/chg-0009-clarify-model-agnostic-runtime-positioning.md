# CHG-0009 收敛“模型无关、运行端兼容”口径

## 提交人

qierkang+codex

## 日期

2026-04-09

## 影响范围

- `README.md`
- `skills/picasso-dev/SKILL.md`
- `skills/picasso-dev-methods/SKILL.md`
- `.claude-plugin/`
- `.codex/`
- `.openclaw/`

## 变更原因

此前文案里出现过 `Claude + Codex 联动` 等表述，容易让使用者误解为本 skill 包依赖特定模型或必须多模型同时存在。

## 本次修改

1. 明确 `picasso-dev-skill` 是流程标准包，不绑定具体模型
2. 明确 OpenClaw 可独立使用
3. 明确 Claude Code + Codex 协作是兼容方案，不是前置依赖
4. 同步收敛适配层说明文案

## 对使用者的影响

- 新接手者更容易理解：模型是执行端，skill 包是规则层
- 单端和多端协作两种模式都更清晰

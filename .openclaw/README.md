# OpenClaw 适配层

这里放 OpenClaw 总控侧的接入说明。

第一次接手当前仓库，先看 `../START-HERE.md`。

## 当前约定

1. OpenClaw 总控调度 Picasso 需求时，统一调用 `picasso-dev`
2. 若要判断工程方法是否齐备，可查 `skills/picasso-dev-methods/`
3. 适配层只做调度和识别说明，不复制主流程模板
4. 即使没有 Claude Code 或 Codex，OpenClaw 也可以独立使用这套 skill

## 总控识别建议

- 主流程：`skills/picasso-dev/`
- 方法层：`skills/picasso-dev-methods/`
- 专项能力：`skills/picasso-dev-task/`、`skills/picasso-dev-ui/`、`skills/picasso-dev-config/`
- 维护治理：`skills/picasso-dev-maintainer/`、`governance/`

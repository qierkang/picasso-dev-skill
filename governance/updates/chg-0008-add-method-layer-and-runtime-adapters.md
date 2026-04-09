# CHG-0008 新增方法层、自包含 vendor 策略与运行端适配层

## 提交人

qierkang+codex

## 日期

2026-04-09

## 影响范围

- `skills/`
- `vendor/`
- `governance/`
- `README.md`
- `AGENTS.md`
- `install/sync.sh`
- 根目录适配层目录

## 变更原因

为吸收外部文章中的高价值工程方法，同时满足跨机器可迁移、一体包分发和多运行端可理解的要求，需要把方法层和适配层从现有目录中显式抽出来。

## 本次修改

1. 新增 `skills/picasso-dev-methods/`，内化规划、TDD、系统化排障、完成前验证、审查处理、并行与隔离方法
2. 新增 `vendor/` 与 `governance/vendor-skills.yaml`
3. 新增 `.claude-plugin/`、`.codex/`、`.opencode/`、`.openclaw/` 适配层目录
4. 更新入口与文档，明确方法层和适配层的职责边界
5. 补一份文章 skill 对照文档，说明当前具备度

## 对使用者的影响

- 仍然只需要从 `picasso-dev` 进入主流程
- 如需看方法或跨端接入方式，有了稳定入口
- 不再需要依赖宿主机外部 skill 才能理解或执行 Picasso 标准流程

## 后续建议

1. 后续如吸收新的外部 skill，继续优先内化，不要直接加宿主机依赖
2. 如某运行端需要真实配置文件，再在对应适配目录增量补齐，不要复制整套规则

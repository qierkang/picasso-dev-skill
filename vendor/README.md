# Vendor 说明

`vendor/` 是外部 skill、规则片段、参考实现的镜像预留区。

## 目的

1. 允许把外部方法“收编”到包内，保证跨机器可迁移
2. 避免运行时依赖宿主机 `~/.agents/skills` 或其他外部路径
3. 为未来确实需要镜像的第三方 skill 预留稳定位置

## 当前策略

当前默认不直接 vendoring 外部 skill 全量副本，而是优先采用：

1. 先在 `governance/vendor-skills.yaml` 登记来源与采用策略
2. 将真正需要的规则内化到 `skills/picasso-dev-methods/` 或 `shared/`
3. 只有当外部内容必须完整保留且许可证允许时，才把副本放进 `vendor/skills/`

## 硬规则

- 禁止把 `vendor/` 当作运行时动态依赖跳板
- 禁止在主流程里直接要求宿主机存在某个外部 skill
- 如镜像外部内容，必须补来源、版本、范围和迁移说明

---
name: picasso-dev-design-system
description: Use when Picasso 需求需要明确设计风格、色板、字体、token、组件层级、动效或可访问性基线，避免 UI 文档只停留在字段和页面分区。
---

# Picasso Dev Design System

## 定位

`picasso-dev-design-system` 负责回答“页面应该怎么设计得更像成品”，而不是只回答“页面有哪些字段和按钮”。

它用于：

- 明确风格方向
- 给出 token 基线
- 约束组件语义
- 给出动效与反馈规则
- 补充可访问性和响应式要求

## 必须先读取

若当前运行端可识别 `ui-ux-pro-max`，优先借助它做外部设计协同。

若不可识别，则只允许继续读取 Picasso 包内 `shared/references/design/`；默认不得改用 `frontend-design` 或其他通用设计 skill 当兜底。

随后仍需读取：

1. `../../shared/references/design/README.md`
2. `../../shared/references/design/设计风格方向库.md`
3. `../../shared/references/design/设计Token基线.md`
4. `../../shared/references/design/动效与反馈规范.md`
5. `../../shared/references/design/可访问性与响应式规范.md`

## 输出要求

给 UI 文档补齐以下内容：

1. 风格方向
2. 色彩与字体方向
3. 组件层级策略
4. 主次按钮语义
5. 动效与反馈规则
6. 可访问性与响应式要求

## 使用边界

1. 不替代 `picasso-dev-ui`
2. 不直接产出业务需求文档
3. 平台专项差异由 `picasso-dev-ui-web / ios / android / miniapp` 继续补齐

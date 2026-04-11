---
name: picasso-dev-ui-review
description: Use when Picasso 页面已经有 UI 文档、实现页面、截图或本地页面地址，需要做 UI 还原审查、交互审查、端差异审查并形成回流清单。
---

# Picasso Dev UI Review

## 定位

`picasso-dev-ui-review` 负责在“UI 文档已经存在”之后做设计与体验层的审查。

## 必须先读取

1. `../../shared/templates/UI验收报告模板.md`
2. `../../shared/references/design/设计Token基线.md`
3. `../../shared/references/design/动效与反馈规范.md`
4. `../../shared/references/design/可访问性与响应式规范.md`
5. 当前需求目录中的：
   - `*-UI交互设计规范.md`
   - `*-UI验收报告.md`（如存在）

## 审查重点

- 风格方向是否跑偏
- 组件映射是否一致
- 主次按钮语义是否一致
- 动效和反馈是否缺失
- 空态 / 加载态 / 错误态是否真实可用
- 响应式、触控热区、可访问性是否达标

## 默认输出

- 回填 `*-UI验收报告.md`
- 列出差异清单和回流建议

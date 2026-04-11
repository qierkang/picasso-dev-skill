# 设计Token基线

## 目标

避免“每个需求自己发明一套颜色、圆角、间距、阴影”。

## 色彩层级

- `brand-primary`：主品牌色，只用于主 CTA、关键状态、重点强调
- `brand-secondary`：辅助强调色，用于标签、轻提示、信息补充
- `surface-base`：主背景
- `surface-card`：卡片、面板、弹层
- `text-primary`：主文本
- `text-secondary`：次文本
- `text-tertiary`：弱提示
- `border-subtle`：弱边框
- `border-strong`：强分隔
- `success / warning / danger / info`：系统状态色

## 间距基线

推荐 4pt 栅格：

- `4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48`

建议：

- 组件内部优先 `8 / 12 / 16`
- 区块之间优先 `16 / 24 / 32`
- 页面级留白优先 `24 / 32 / 40`

## 圆角基线

- `xs: 4`
- `sm: 8`
- `md: 12`
- `lg: 16`
- `xl: 20`

建议：

- 输入框、按钮：`8-12`
- 卡片：`12-16`
- 全屏弹层：顶部 `16-20`

## 阴影基线

- `shadow-1`：悬浮按钮、轻浮层
- `shadow-2`：卡片 Hover、下拉面板
- `shadow-3`：Modal、Drawer

规则：

- B 端管理台阴影要克制
- C 端结果页可适度增强层次

## 字体层级

- 页面标题：`24-32 / semibold-bold`
- 区块标题：`18-24 / semibold`
- 正文：`14-16 / regular`
- 辅助信息：`12-14 / regular`
- 关键指标：允许更大字号，但必须控制数量

## 控件高度建议

- PC 输入框 / 按钮：`32 / 36 / 40`
- 移动端输入框 / 按钮：`44 / 48 / 52`

## 状态基线

每个关键控件至少明确：

- default
- hover
- active
- focus
- disabled
- loading
- error

## 输出要求

UI 文档里不要求输出完整 token 表，但至少要给：

- 色彩方向
- 字体方向
- 圆角与阴影方向
- 主要组件尺寸层级
- 危险 / 成功 / 警告状态色口径

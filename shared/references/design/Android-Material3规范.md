# Android / Material 3 规范

## 定位

本文件用于补齐 Android 端设计与实现时的 Material 3 基线。

## 设计原则

1. 组件优先遵守 Material 3 语义
2. 使用系统化层级，不拼凑“像 Android 的网页”
3. 触控热区优先大于视觉尺寸

## 页面布局

- 列表页优先 Top App Bar + 筛选 + 列表
- 主操作明确时可使用 FAB，但不要滥用
- 大量录入场景优先分组卡片或 step form

## 反馈方式

- 轻提示优先 Snackbar
- 强阻断优先 Dialog / Fullscreen
- 长任务优先显式 loading + 状态文案

## Material 3 组件建议

- 过滤和分类优先 chips
- 多态表单优先 segmented buttons / tabs / bottom sheet
- 危险操作颜色与文案双提示

## Android 专项提醒

- 注意返回键与页面状态一致
- 注意深浅色主题兼容
- 注意折叠屏、不同密度屏幕下的间距稳定性
- 不要把 iOS 的层级和手势硬搬到 Android

## 审查要点

- 是否符合 Material 3 主次层级
- 是否存在点击热区不足
- 是否存在返回路径不清
- 是否存在底部操作被系统导航遮挡

# iOS / SwiftUI 规范

## 定位

本文件用于补齐 iOS 页面设计与 SwiftUI 实现时最容易遗漏的系统约束。

它承接的是：

- iOS Human Interface Guidelines
- SwiftUI 页面组织
- Dynamic Type / VoiceOver / Safe Area / Motion 等专项要求

## 设计原则

1. 尊重系统导航和手势
2. 优先单列信息流，不做 PC 式多栏堆叠
3. 重要操作靠近拇指热区
4. 页面层级宁可深一点，也不要一屏塞满

## 导航规则

- 主列表进入详情，优先使用系统导航栈
- 临时任务优先 sheet / fullScreenCover
- 危险操作确认优先 alert 或明确确认页

## SwiftUI 实现提醒

- 避免一个 `View` 承载所有状态和布局
- 拆分为页面壳层、模块区块、原子组件
- 状态加载、空态、错误态要做成显式分支

## iOS 页面约束

- 顶部导航不堆过多操作
- 底部主按钮保持固定可达
- 表单优先分段展示
- 输入时注意键盘抬升与滚动避让

## 可访问性

- 必须考虑 Dynamic Type 放大后的换行
- 核心操作提供清晰的 VoiceOver label
- 颜色不能成为唯一状态信号
- 动画需兼容 Reduce Motion

## 审查要点

- 是否符合 iOS 导航语义
- 是否遵守安全区
- 是否考虑系统字体缩放
- 是否存在点击热区过小
- 是否把 Web 组件硬搬到 iOS

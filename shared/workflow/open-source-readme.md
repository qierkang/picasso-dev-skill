# Open Source README 工作流

## 目标

把项目 README 产出为一份可直接放到 GitHub 仓库首页的开源文档，并保证结构、风格、协作入口和验证口径统一。

## 适用场景

- 新项目首次生成 README
- 现有 README 改写为开源版本
- 将内部交付型 README 升级为 GitHub 首页版本
- 需要把 README 模板移植到其他 skill 包

## 标准输入

1. 项目信息
2. 目标仓库的 README 草稿或现有 README
3. 是否需要补 Demo、Docs、截图、License、贡献入口

## 标准参考

按顺序读取：

1. `../../shared/references/readme/spec-open-source-readme-master-prompt.md`
2. `../../shared/references/readme/spec-open-source-readme-style-reference.md`
3. `../../shared/references/readme/spec-open-source-readme-template.md`

## 标准流程

1. 先确认 README 的目标用途是“GitHub 开源首页”
2. 以 master prompt 约束生成目标和输出方式
3. 以 style reference 统一语气、层次和信息密度
4. 以 template 校验章节完整性和字段覆盖面
5. 生成 README 到目标仓库根目录
6. 用 `shared/scripts/readme-gate.py` 校验章节、占位符和结构
7. 如果 README 对应的是 skill 包自身，按 `picasso-dev-maintainer` 规则同步 `governance/`

## 门禁规则

- 不接受只有安装命令、没有项目概述的 README
- 不接受保留大量 `{{占位符}}` 的 README
- 不接受伪造 Demo、CI、License 或贡献文档
- 不接受没有“快速开始 / 技术栈 / 系统架构 / 贡献与协作 / 安全说明 / 许可证”的 README

## 输出标准

- 直接可提交到 GitHub
- 不依赖本地特殊环境路径
- 可被其他模型直接复用为 README 生成模板

# chg-0001 初始化技能包结构

## 基本信息

- 提交人：Codex
- 日期：2026-04-08
- 范围：
  - 仓库结构
  - README
  - workspace / governance 基础文件

## 变更原因

- 需要把现有 Picasso / ZZPMS 开发规则收敛为一套可复制的技能包
- 需要支持单模型、Claude + Codex、多平台适配

## 本次变更

- 建立 `picasso-dev-skill` 基础目录结构
- 建立统一入口与 companion skill 的承载目录
- 建立 `workspace/` 运行区
- 建立 `governance/` 维护区
- 补齐 5 个核心 skill 与 Picasso profile
- 补齐共享模板、安装脚本和 `maintenance-plan` 示例

## 后续计划

- 做一次 `maintenance-plan` 模拟跑通
- 根据试跑结果继续收敛 README 和执行细节

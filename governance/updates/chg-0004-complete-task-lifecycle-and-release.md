# chg-0004 补齐任务生命周期与发布流转

## 基本信息

- 提交人：qierkang+codex
- 日期：2026-04-08
- 影响范围：
  - `shared/references/task/`
  - `shared/workflow/`
  - `shared/templates/`
  - `shared/scripts/`
  - `skills/picasso-dev/SKILL.md`
  - `skills/picasso-dev-task/SKILL.md`
  - `install/sync.sh`
  - `README.md`

## 变更原因

- 旧 `picasso-task` 的任务状态、归档、恢复、变更治理还未完整迁入新仓库
- 旧 `zzpms-dev` 的发布上线与两关制冒烟，在新仓库中仍偏轻
- 当前新 skill 已能覆盖主流程，但还不够“长周期任务可控、上线链路可复盘”

## 本次修改

- 新增服务端任务状态管理、归档恢复与撤销、需求变更流程、快捷触发语义
- 补强 `picasso-dev-task` 与主入口 `picasso-dev` 的生命周期和发布规则
- 新增 `发布记录模板.md` 并扩展 manifest / init-request / stage-gate
- 升级冒烟脚本模板，强化第 2 关的路由、文件、Controller 路径校验
- `sync.sh` 现在会同时同步根包与独立子 skill

## 对使用者的影响

- 新需求和服务端任务不只是能启动，还能更稳定地管理变更、归档和恢复
- 发布上线现在有单独记录文件和更明确的前后检查
- 冒烟脚本不再只是空壳模板，需要按两关制真正替换为真实检查项

## 后续建议

- 继续补真实 `attendance-mobile` 示例，验证小程序 / App 双端链路
- 如需更强发布自动化，可再补项目级 deploy / rollback 辅助脚本

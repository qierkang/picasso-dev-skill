# chg-0006 增加 local-only 环境预检与自主执行闭环

## 基本信息

- 提交人：qierkang+codex
- 日期：2026-04-09
- 影响范围：
  - `install/`
  - `profiles/picasso/`
  - `shared/workflow/`
  - `shared/references/requirements/`
  - `shared/templates/`
  - `skills/picasso-dev/`
  - `examples/maintenance-plan/`
  - `README.md`

## 变更原因

- 用户在真实使用中暴露出一个缺口：新机器 / 虚拟机进入开发前，没有先把环境检查和安装引导做成强制链路
- 旧 `doctor.sh` 只能做轻量校验，容易出现“命令装了但版本不够”或“只想查库却被整套开发链路阻塞”的问题
- 用户明确要求 Picasso skill 只允许 `local / dev` 作为可操作边界，且环境通过后默认自主推进，不要反复询问

## 本次修改

- 将环境预检正式拆成 `docs / dev / db / deploy / all` 五种能力模式
- `doctor.sh` 新增：
  - `local-only` 边界校验
  - Java 21 版本校验
  - Picasso 前端 / 小程序仓库 `node / pnpm` 最低版本校验
  - 本地数据库 `psql` 与 host 约束校验
- 将 `workflow`、`manifest`、`Codex CLI 标准执行输入`、安装指引统一改成“先 `doctor`、后开发”的闭环
- 将执行风格统一改成：
  - 环境未通过先修环境
  - 环境通过后默认自主推进 routine 动作
  - 只有真实阻塞才升级给使用者

## 对使用者的影响

- 新同事或新机器第一次接入时，会先明确自己缺的是哪类能力，而不是开发到一半才发现工具或版本不够
- 文档 / PM 场景不会再被完整开发工具链误阻塞
- SQL、启动、冒烟、发布准备会被严格限制在 `local / dev` 边界内
- Claude / Codex / GLM / 单模型模式都更容易复现同一套“先预检、再执行”的动作顺序

## 后续建议

- 后续如果再补小程序 / App 真实示例，继续沿用同一套能力预检与 local-only 边界
- 如需进一步自动化，可在后续版本补“环境自动修复脚本”，但仍必须保留显式边界检查

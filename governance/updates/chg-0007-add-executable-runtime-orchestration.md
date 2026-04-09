# chg-0007 增加可执行的本地运行编排闭环

## 基本信息

- 提交人：qierkang+codex
- 日期：2026-04-09
- 影响范围：
  - `AGENTS.md`
  - `install/`
  - `profiles/picasso/`
  - `shared/scripts/`
  - `shared/workflow/`
  - `shared/references/quality/`
  - `shared/references/requirements/`
  - `shared/templates/`
  - `skills/picasso-dev/`
  - `examples/maintenance-plan/`
  - `README.md`

## 变更原因

- 用户在真实分析中明确指出：当前 skill 虽然写了“环境通过后自主推进”，但还没有把“自动启动后端、自动启动前端、自动联调、自动冒烟、自动收尾”真正落到脚本上
- 原有 `stage-gate.py smoke` 只检查脚本和报告文本，无法证明冒烟真的执行过
- 新机器和多模型环境下，如果这些动作只是写在说明里而不是脚本里，最终仍会卡在人工作业和理解偏差上

## 本次修改

- 新增 `shared/scripts/runtime-lib.sh`
  - 统一加载 `.env`
  - 支持运行时变量覆盖
  - 自动拉起后端和前端
  - 自动等待健康检查和前端 ready
  - 自动登录获取 token
  - 自动回收本次拉起的本地进程
- `stage-gate.py smoke` 升级为默认真实执行冒烟脚本
  - 增加执行日志落盘到 `logs/stage-gate-smoke.log`
  - 增加 `--skip-smoke-exec` 作为显式降级开关
  - 修复编码输出和执行结果采集的边界问题
- `.env.example`、本地 `.env`、`profile.yaml`、`manifest模板.json` 增加运行编排入口
- `install/doctor.sh --capability deploy` 新增运行编排校验
  - 后端 / 前端启动目录
  - 启动命令
  - 基础地址 / 健康检查地址 / ready 地址
  - 自动登录配置
  - 自动收尾配置
- 冒烟脚本模板与 `maintenance-plan` 示例脚本切换到 runtime-lib 口径
- README、workflow、质量说明、Codex CLI 标准执行输入、AGENTS 同步改成“可执行闭环”口径

## 对使用者的影响

- 只要 `.env` 已配置完运行编排入口，模型不再需要自己“理解应该怎么启动”，而是直接按脚本启动、联调、冒烟、收尾
- `deploy doctor` 会在真正进入联调前提前暴露缺失入口，减少开发中途卡住
- `stage-gate.py smoke` 现在给出的通过结论带有执行日志证据，不再只是文本检查

## 后续建议

- 真实 Picasso 需求进入编码阶段后，优先用同一套 runtime-lib 跑一次真实 `smoke gate`
- 后续可继续补浏览器级页面验证，但前提仍是沿用当前“先自动启动、再自动执行”的运行编排基线

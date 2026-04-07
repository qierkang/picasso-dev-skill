# Picasso 仓库映射

> 路径来源统一以仓库根目录 `.env` 为准。新环境只需要改 `.env`，不要直接改本文件里的规则说明。

## 核心仓库

| 类型 | 配置项 | 说明 |
|------|--------|------|
| 服务端 | `PICASSO_SERVER_CODE_DIR` | Java + Spring Boot 服务端主仓 |
| PC 前端 | `PICASSO_FRONT_CODE_DIR` | Vue3 + Element Plus 的 PC 管理端 |
| 微信小程序 | `PICASSO_MINIAPP_CODE_DIR` | uni-app / Vue3 小程序端 |
| 移动端 App | `PICASSO_MOBILE_APP_CODE_DIR` | Flutter 移动端，覆盖 Android / iOS |

## 任务与文档目录

| 类型 | 配置项 / 固定目录 | 说明 |
|------|-------------------|------|
| 服务端任务根目录 | `PICASSO_SERVER_TASK_DIR` | 服务端任务推进、归档与协同承载 |
| 技能包运行目录 | `PICASSO_WORKSPACE_DIR` | 当前仓库内的需求运行区 |
| 技能包维护目录 | `governance/` | 当前仓库内的维护记录区 |
| 技能同步目录 | `OPENCLAW_SKILLS_DIR` / `CLAUDE_SKILLS_DIR` / `CODEX_SKILLS_DIR` | 只配置你实际使用的平台 |

## 使用原则

1. Picasso 项目默认以这四个源码仓库为开发边界。
2. 业务需求的运行产物一律写入 `workspace/requests/<request-key>/`。
3. 不把业务需求产物写回 skill 包规则目录。
4. 新机器接手时，优先修改 `.env`，再执行 `bash install/doctor.sh` 校验。

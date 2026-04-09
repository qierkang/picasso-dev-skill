# Picasso 环境说明

> 环境地址的真实值统一以 `.env` 为准。本文件只定义“哪些环境允许碰、哪些环境绝不能碰”。

## 当前边界

- `local`
- `dev`

以上两个 profile 统一视为本地开发边界，可以做：

1. 本地启动
2. 本地联调
3. 本地数据库查询
4. 本地 SQL 校验
5. 本地冒烟
6. 本地发布准备

## 明确禁止

以下 profile 在 `picasso-dev-skill` 中只用于识别边界，不允许连接、查询、部署：

- `test`
- `uat`
- `prod`

## Picasso 服务端 profile 识别文件

默认从服务端仓库的资源目录识别：

- `application-local.yaml`
- `application-dev.yaml`
- `application-test.yaml`
- `application-uat.yaml`
- `application-prod.yaml`

常见资源目录位置：

- `<PICASSO_SERVER_CODE_DIR>/picasso-server/src/main/resources/`
- `<PICASSO_SERVER_CODE_DIR>/src/main/resources/`

## 本地数据库约束

- 数据库来源：
  - `PICASSO_LOCAL_DB_HOST`
  - `PICASSO_LOCAL_DB_PORT`
  - `PICASSO_LOCAL_DB_NAME`
- `PICASSO_LOCAL_DB_HOST` 必须是：
  - `127.0.0.1`
  - `localhost`
  - `::1`

## 生产与非本地红线

以下行为默认禁止：

1. 连接 `test / uat / prod` 数据库执行 SQL
2. 连接 `test / uat / prod` 服务器发布代码
3. 直接登录非本地服务器修改配置
4. 未通过产品验收直接发布

## 操作原则

1. 默认只在 `local / dev` 范围内开发和验证
2. 不因为追求速度越过边界去连测试、UAT、生产
3. 涉及 SQL、菜单、字典、初始化数据时，默认目标就是本地环境
4. 如当前任务只是文档、方案、UI 设计，可跳过开发环境体检
5. 一旦进入编码、SQL、部署，必须先通过对应能力的 `doctor.sh`

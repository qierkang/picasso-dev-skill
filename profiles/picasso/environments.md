# Picasso 环境说明

> 环境地址的真实值统一以 `.env` 为准。本文件只说明环境分类和操作原则。

## 本地环境

- 数据库来源：
  - `PICASSO_LOCAL_DB_HOST`
  - `PICASSO_LOCAL_DB_PORT`
  - `PICASSO_LOCAL_DB_NAME`
- 默认允许自由验证和调试

## 测试环境

- 数据库来源：
  - `PICASSO_TEST_DB_HOST`
  - `PICASSO_TEST_DB_PORT`
  - `PICASSO_TEST_DB_NAME`
- 使用前需要确认风险和目标

## 生产环境红线

以下行为默认禁止：

1. 连接生产数据库执行 SQL
2. 直接登录生产服务器改配置
3. 未确认情况下修改生产环境文件
4. 未通过验收直接发布代码

## 环境操作原则

1. 默认先本地验证，再测试环境验证
2. 涉及 SQL、菜单、字典、初始化数据时，必须明确目标环境
3. 不因追求速度跳过环境确认和风险记录

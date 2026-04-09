# Codex CLI 标准执行输入

## 1. 目的

用于约束 Claude / Codex / 其他模型在进入 Picasso 实际开发前的最小必传上下文，避免：

- 只读了需求文档，没读规则文档
- 不清楚允许改哪些仓库、哪些模块
- 只改代码，不做质量验证
- 没做环境预检就直接开始编码或执行 SQL
- 不清楚当前只能操作 `local / dev` 边界

## 2. 标准输入模板

```markdown
你现在执行的是 Picasso 项目的本地开发任务。

【任务目标】
- task_name:
- target_module:
- task_type: 开发 / 修复 / 文档同步 / 测试 / 审查
- capability_mode: docs / dev / db / deploy
- doctor_command:
- install_guide_doc:

【需求目录】
- requirements_dir:
- manifest_doc:
- overview_doc:
- requirement_doc:
- tech_doc:
- ui_doc:
- test_doc:
- task_breakdown_doc:
- traceability_bundle_doc:
- acceptance_bundle_doc:
- dev_gate_doc:
- coverage_report_doc:
- fe_checklist_doc:
- qa_acceptance_doc:
- ui_acceptance_doc:
- product_acceptance_doc:

【环境边界】
- environment_boundary: local-only
- allowed_runtime_profiles: local,dev
- forbidden_runtime_profiles: test,uat,prod

【必须阅读的规则文档】
- shared/references/requirements/README.md
- shared/references/requirements/异步导入导出开发规范.md
- shared/references/requirements/动态规则编码生成.md
- shared/references/requirements/内部编码生成.md
- shared/references/requirements/枚举类创建规范.md
- shared/references/requirements/Codex CLI 标准执行输入.md

【仓库范围】
- front_repo:
- back_repo:
- allowed_scope:
- forbidden_scope:

【执行要求】
- 开始前先执行 `doctor_command`，未通过不进入真实开发
- 只允许操作 `local / dev`，禁止连接、查询、部署 `test / uat / prod`
- 只在 allowed_scope 内修改
- 修改前先理解当前系统框架
- 修改完成后必须执行验证命令
- 环境通过后默认自主推进 routine 动作，不反复询问是否继续

【输出物要求】
- 代码修改
- 需求目录文档回写
- 开发放行报告更新
- 覆盖率报告更新
- 前端关键流程覆盖清单更新
- 代码审查报告更新
- 冒烟测试报告更新
```

## 3. 必读顺序

1. `manifest.json`
2. `00-需求总览.md`
3. `Codex CLI 标准执行输入.md`
4. 公共规则文档
5. 根据 `capability_mode` 先执行对应 `doctor.sh`
6. `需求文档`
7. `技术方案`
8. `UI交互设计规范`
9. `测试用例`

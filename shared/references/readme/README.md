# README 生成参考索引

本目录收口 GitHub 开源 README 的三件套，供 `picasso-dev-skill` 在文档生成、模板改写和开源发布场景中统一复用。

## 使用顺序

1. 先读 `spec-open-source-readme-master-prompt.md`
2. 再读 `spec-open-source-readme-style-reference.md`
3. 最后读 `spec-open-source-readme-template.md`
4. 生成后的 README 交给 `shared/scripts/readme-gate.py` 做结构校验

## 文件职责

| 文件 | 职责 |
|---|---|
| `spec-open-source-readme-master-prompt.md` | 主提示词，定义生成目标、约束和输出方式 |
| `spec-open-source-readme-style-reference.md` | 风格参考，定义 README 的信息密度和排版语气 |
| `spec-open-source-readme-template.md` | 结构模板，定义章节覆盖面和字段槽位 |

## 工作流约定

- 这是 skill 包内的本地参考副本，不依赖 `docs/documents/` 的上层路径
- 如果模板被迁移到别的 skill 或别的仓库，优先连同本目录一起迁移
- 如果 README 任务涉及 skill 包维护，按 `picasso-dev-maintainer` 的要求补 `governance/` 记录

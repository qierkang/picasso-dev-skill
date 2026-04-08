# chg-0003 增加根目录 SKILL 入口

## 基本信息

- 提交人：qierkang+codex
- 日期：2026-04-08
- 影响范围：
  - `SKILL.md`
  - `README.md`
  - `governance/CHANGELOG.md`

## 变更原因

- 当前仓库是“技能包仓库”，根目录没有 `SKILL.md`
- 对 Git 仓库本身没有问题，但对只识别“根目录是否存在 `SKILL.md`”的平台不够直观
- 需要一个标准根入口，让平台和新接手的人一眼知道该从哪里进入

## 本次修改

- 在仓库根目录新增 `SKILL.md`
- 将根级 `SKILL.md` 定位为总入口索引，不重复维护主流程
- 明确根入口会继续路由到 `skills/picasso-dev/SKILL.md`

## 对使用者的影响

- 现在 `picasso-dev-skill/` 目录本身也具备标准 skill 入口外观
- 即使平台只读根目录，也能正确找到 Picasso 主入口和 companion skills

## 后续建议

- 若未来需要把整仓库直接挂到某个平台，可优先使用根级 `SKILL.md`
- 主流程规则仍应继续维护在 `skills/picasso-dev/SKILL.md`

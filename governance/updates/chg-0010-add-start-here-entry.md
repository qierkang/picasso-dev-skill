# CHG-0010 新增根目录 START-HERE 新手入口

## 提交人

qierkang+codex

## 日期

2026-04-09

## 影响范围

- `START-HERE.md`
- `README.md`
- `SKILL.md`
- `install/sync.sh`

## 变更原因

现有入口虽然完整，但对第一次接手 skill 包的新环境使用者来说，仍然偏分散，不够“一眼看懂”。

## 本次修改

1. 在仓库根目录新增 `START-HERE.md`
2. 统一说明：
   - skill 包是什么
   - 主流程怎么走
   - 新环境怎么配置
   - OpenClaw / Claude Code / Codex / 协作模式分别怎么进入
3. `README.md` 与根级 `SKILL.md` 增加对 `START-HERE.md` 的指引
4. `sync.sh` 同步根包时一并带上 `START-HERE.md`
5. 在 `START-HERE.md` 中单独补“Claude Code + Codex + codex-plugin-cc”协作入口说明
6. `.openclaw/`、`.claude-plugin/`、`.codex/`、`.opencode/` 都补充“先看 START-HERE.md”

## 对使用者的影响

- 新环境第一次接手时，入口更清晰
- 运行端差异更容易理解
- 不必先在 README、SKILL、profile 之间来回跳找入口

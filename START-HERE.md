# START HERE

第一次接手 `picasso-dev-skill`，先看这份文档。

它只回答四个问题：

1. 这个 skill 包是干什么的
2. 它会按什么流程做事
3. 新环境第一次要怎么配置
4. 你用 OpenClaw、Claude Code、Codex 时，分别从哪里进入

## 1. 这是什么

`picasso-dev-skill` 不是单一 skill，而是一套面向 Picasso 项目的标准化开发流程包。

它的目标是把下面这些动作收敛成固定套路：

- 需求分析
- 技术方案
- UI 设计
- 任务拆解
- 编码开发
- 开发自测
- 代码审查
- 冒烟测试
- QA 验证
- UI 验收
- 产品验收
- 发布准备

你可以把它理解成：

- `skill 包` = 流程规则层
- `OpenClaw / Claude Code / Codex` = 可选执行端
- `Picasso 项目仓库` = 实际开发对象

## 2. 它不会直接乱写代码

这套 skill 的默认逻辑不是“看到需求就直接开写”，而是先走完整主流程。

标准顺序是：

`需求分析 → 技术方案 → UI设计 → 任务拆解 → 编码开发 → 开发自测 → 代码审查 → 冒烟测试 → QA验证 → UI验收 → 产品验收 → 部署`

并且有三条硬规则：

1. 编码、SQL、启动、冒烟前，先跑 `doctor.sh`
2. 只允许 `local / dev`，禁止碰 `test / uat / prod`
3. 没有验证证据，不算完成

## 3. 根目录里先看哪些文件

建议第一次按这个顺序看：

1. `START-HERE.md`
2. `README.md`
3. `SKILL.md`
4. `skills/picasso-dev/SKILL.md`
5. `profiles/picasso/配置入口说明.md`
6. `profiles/picasso/execution-modes.md`

如果你想继续看细一点：

- 方法怎么收敛：`skills/picasso-dev-methods/SKILL.md`
- OpenClaw 怎么接：`.openclaw/README.md`
- Claude Code 怎么接：`.claude-plugin/README.md`
- Codex 怎么接：`.codex/README.md`

## 4. 这个包的主入口是谁

真正的主入口只有一个：

- `skills/picasso-dev/SKILL.md`

根目录 `SKILL.md` 的作用只是：

- 兼容只识别根级 skill 的运行端
- 把你继续路由到 `picasso-dev`

所以无论你从 OpenClaw、Claude Code 还是 Codex 进来，最后都应该收口到：

- `picasso-dev`

## 5. 它支持哪些运行方式

### 方式 A：只有 OpenClaw

可以。

这种情况下：

- 只配置 `OPENCLAW_SKILLS_DIR`
- 同步后由 OpenClaw 识别 skill
- 主流程仍然是 `picasso-dev`

### 方式 B：只有 Claude Code

可以。

这种情况下：

- 只配置 `CLAUDE_SKILLS_DIR`
- Claude Code 按 `picasso-dev` 推流程

### 方式 C：只有 Codex

也可以。

这种情况下：

- 只配置 `CODEX_SKILLS_DIR`
- Codex 单独按同一套规则推进

### 方式 D：Claude Code + Codex 协作

兼容，而且这是推荐增强模式之一。

建议分工：

- Claude Code：负责需求、方案、任务拆解、流程调度、阶段把关
- Codex：负责代码实现、编译、测试、修复、验证辅助

重点是：

- 两边共享同一套 `picasso-dev` 规则
- 不是 Claude 一套流程、Codex 另一套流程
- `codex-plugin-cc` 属于增强插件，不是 skill 包前置依赖

## 5.1 Claude Code + Codex 标准协作入口

如果你的实际用法是：

- 在 Claude Code 里发起需求
- 按 `picasso-dev` 走主流程
- 到编码阶段再通过 `codex-plugin-cc` 调 Codex 去实现

那么推荐按这个顺序执行：

1. Claude Code 先读取：
   - `START-HERE.md`
   - `README.md`
   - `skills/picasso-dev/SKILL.md`
2. Claude Code 先完成：
   - 需求识别
   - 技术方案
   - 任务拆解
   - `doctor` 预检
3. 进入编码阶段后，再把实现任务委托给 Codex
4. Codex 负责：
   - 代码实现
   - 编译验证
   - 测试执行
   - 修复回归问题
5. Codex 返回后，Claude Code 再继续：
   - 回填主流程文档
   - 推进阶段 gate
   - 组织冒烟、QA、UI、产品验收

建议分工边界：

- Claude Code 不直接绕过主流程文档和阶段卡点
- Codex 不直接定稿流程性文档，也不直接推进阶段状态
- 两边共享同一个 `workspace/requests/<request-key>/` 目录和同一套规则

如果你安装了 `codex-plugin-cc`，可以把它理解成：

- `picasso-dev-skill` 负责“流程规则”
- `codex-plugin-cc` 负责“Claude 调 Codex 的执行桥”

这两者是兼容关系，不是替代关系。

## 6. 新环境第一次怎么配

第一次接手，默认只改 `.env`。

最小步骤：

```bash
cp .env.example .env
vim .env
bash install/setup.sh
bash install/doctor.sh --capability docs
bash install/sync.sh
```

如果你要进入真实开发，至少再跑：

```bash
bash install/doctor.sh --capability dev
```

如果要做本地启动、联调、冒烟，再跑：

```bash
bash install/doctor.sh --capability deploy
```

关键配置说明看：

- `profiles/picasso/配置入口说明.md`

## 7. 新需求通常怎么开始

你在新的终端里，准备开发一个新需求时，标准起手式是：

```text
使用 picasso-dev 开始开发 <request-key>
```

例如：

```text
使用 picasso-dev 开始开发 recruitment-manage
```

如果有原型、需求文档、接口说明，最好一起给：

```text
使用 picasso-dev 开始开发 recruitment-manage
原型：
- /path/to/list.png
- /path/to/detail.png
参考文档：
- /path/to/prd.md
```

## 8. 它会产出什么

默认产物会写到：

- `workspace/requests/<request-key>/`

里面会逐步形成：

- `00-需求总览.md`
- `manifest.json`
- `*-需求文档.md`
- `*-技术方案.md`
- `*-任务分解.md`
- `*-UI交互设计规范.md`
- `*-测试用例.md`
- `*-开发放行报告.md`
- `*-代码审查报告.md`
- `*-冒烟测试报告.md`
- `*-QA验收报告.md`
- `*-UI验收报告.md`
- `*-产品验收报告.md`

## 9. 方法层是什么

如果你看到：

- `picasso-dev-methods`

它的作用不是替代主流程，而是补强这些方法：

- planning
- TDD
- systematic debugging
- verification before completion
- review handling
- parallel / isolation

也就是说：

- `picasso-dev` 决定“流程怎么走”
- `picasso-dev-methods` 决定“每一步怎么做得更稳”

## 10. 适配层是什么

根目录这些目录：

- `.openclaw/`
- `.claude-plugin/`
- `.codex/`
- `.opencode/`

只是不同运行端的接入说明层。

它们不维护第二套规则，不应该各自复制一份主流程。

## 11. 什么时候算真的完成

不是代码写完就算完成。

默认至少要满足：

1. 关键文档已回填
2. 开发自测通过
3. 覆盖率和关键流程清单补齐
4. 代码审查无阻塞
5. 冒烟测试通过
6. QA / UI / 产品验收都通过

默认放行结论先是：

- `NEEDS_WORK`

只有证据齐全，才会升级为：

- `READY`

## 12. 你现在下一步该看什么

如果你是第一次接手这个包，下一步直接按下面选：

- 想理解整体：看 `README.md`
- 想知道主流程：看 `skills/picasso-dev/SKILL.md`
- 想配置新环境：看 `profiles/picasso/配置入口说明.md`
- 想用 OpenClaw：看 `.openclaw/README.md`
- 想让 Claude Code + Codex 协作：看 `profiles/picasso/execution-modes.md`

如果你现在就要开始做新需求，直接进入：

- `skills/picasso-dev/SKILL.md`

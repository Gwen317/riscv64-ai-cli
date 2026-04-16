# 基于 Crush 持续尝试实现 `riscv64 Linux` AI CLI 的工作说明

## 目标

在 `Crush` 的基础上，尝试实现一个可在 `riscv64 Linux` 上运行的本地 CLI AI 编程助手。

本项目的目标不是在本地运行大模型，而是采用：

- 本地 CLI Runtime
- 远程模型 API
- 本地文件读写 / 搜索 / patch / shell 执行
- 会话管理与安全控制

优先实现一个稳定、可裁剪、可验证的 MVP。

## 背景判断

`opencode` 已归档并迁移到 `Crush`，因此后续工作以 `Crush` 为主更合理。

`Crush` 的价值在于：

- Go 实现，适合单二进制分发
- 已具备 AI coding agent 所需的大部分核心能力
- 有 provider、session、tool、LSP、MCP 等结构基础
- 比从零实现更适合快速验证 `riscv64 Linux` 可行性

但当前工作重点不是“完整移植全部能力”，而是：

1. 先判断 `Crush` 在 `linux/riscv64` 下是否可编译
2. 再确认最小可用子集是否能工作
3. 最后决定是继续 fork 精简，还是参考其结构重写轻量版本

## 当前策略

采用“先编译、后裁剪、再增强”的路径。

不追求第一阶段就具备完整 Claude Code 体验。
第一阶段只关心：

- 能否在 `riscv64 Linux` 编译
- 能否启动 CLI
- 能否调用远程模型
- 能否读取项目文件
- 能否执行搜索
- 能否生成并应用 patch
- 能否执行受控 shell 命令

## 第一阶段范围

### 保留的核心能力

- CLI 启动入口
- provider 抽象
- OpenAI-compatible / Anthropic-compatible 远程调用
- session 持久化
- 文件读取与写入
- 文本搜索 / 文件搜索
- diff / patch
- shell tool
- 基本权限控制

### 暂时降级或延后

- 复杂 TUI 体验
- 高级多 agent 协调
- 完整 MCP 生态接入
- 深度 LSP 功能
- 平台特化优化
- 本地模型支持

## 关键风险

### 1. `riscv64` 编译兼容性

重点排查：

- 是否存在仅支持 `amd64` / `arm64` 的依赖
- 是否依赖某些预编译原生库
- terminal UI 组件在 `riscv64` 上是否稳定
- SQLite、文件监控、系统调用相关依赖是否跨架构正常

### 2. 运行时工具依赖

需要确认目标环境是否具备：

- `git`
- `rg`
- `bash` 或兼容 shell
- `diff` / patch 相关工具
- 目标发行版的最小运行库

### 3. 交互复杂度过高

如果 `Crush` 的 TUI 或交互层对架构兼容造成阻碍，应优先保住核心 runtime，必要时接受：

- 先以简化 CLI 运行
- 暂时关闭部分交互式功能
- 保留 agent runtime，替换重交互前端

## 执行步骤

### 步骤 1：获取源码并识别依赖

目标：

- 克隆 `Crush`
- 查看 `go.mod`
- 列出核心依赖
- 标记疑似 `riscv64` 风险依赖

重点输出：

- 编译风险清单
- 可裁剪模块清单
- 必须保留模块清单

### 步骤 2：尝试 `linux/riscv64` 编译

目标：

- 本地交叉编译或在 `riscv64 Linux` 环境实机编译
- 记录失败点
- 分类失败原因

输出格式建议：

- 依赖不兼容
- CGO/系统库问题
- 代码中的架构假设
- 运行时工具缺失

### 步骤 3：定义 MVP 子集

如果完整编译困难，则裁剪成最小可用版本：

- `chat`
- `edit`
- `diff`
- `apply`
- `run`

优先保证：

- 能调用远程模型
- 能读改代码
- 能做最小 agent loop

### 步骤 4：最小修复与适配

包括但不限于：

- 替换不兼容依赖
- 关闭非关键模块
- 增加 build tags
- 对 shell / path / terminal 行为做 Linux 定向适配
- 将复杂 UI 降级为简单输出

### 步骤 5：在 `riscv64 Linux` 验证

最低验收标准：

1. 程序可启动
2. 可加载配置
3. 可发起一次远程模型请求
4. 可读取工作目录文件
5. 可执行搜索
6. 可展示 diff
7. 可在确认后写回文件
8. 可执行受限 shell 命令并返回结果

## 建议目录结构

如果新建一个工作目录，建议结构如下：

```text
crush-riscv64/
├─ README.md
├─ CRUSH_RISCV64_PLAN.md
├─ notes/
│  ├─ dependency-audit.md
│  ├─ build-log.md
│  ├─ runtime-test.md
│  └─ decisions.md
├─ scripts/
│  ├─ build-riscv64.sh
│  ├─ test-smoke.sh
│  └─ env-example.sh
├─ forks/
│  └─ crush/
└─ patches/
```

## 建议记录的文档

### `notes/dependency-audit.md`

记录：

- Go 依赖列表
- 风险依赖
- 替代方案
- 是否需要裁剪

### `notes/build-log.md`

记录每次构建：

- 日期
- commit hash
- 编译命令
- 环境
- 失败信息
- 当前结论

### `notes/runtime-test.md`

记录运行验证结果：

- 启动是否成功
- 配置是否生效
- 模型请求是否成功
- 文件工具是否正常
- shell 工具是否正常
- 已知缺陷

### `notes/decisions.md`

记录关键技术决策，例如：

- 为什么保留 / 移除某模块
- 为什么临时关闭 TUI
- 为什么替换某依赖
- 为什么改用轻量输出

## 建议的第一轮任务

新开的 AI 助手窗口可以直接按下面顺序推进：

1. 克隆 `Crush` 仓库并阅读 `README`、`go.mod`、主入口、tool/provider/session 相关目录
2. 输出一份依赖与模块审计报告
3. 尝试执行 `GOOS=linux GOARCH=riscv64 go build ./...`
4. 汇总构建失败点
5. 判断哪些模块必须裁掉或替换
6. 给出一版最小 MVP 改造方案

## 给新 AI 助手的建议提示词

可以把下面这段直接发给新的 AI 助手窗口：

请基于 `Crush` 仓库，继续推进一个可运行于 `linux/riscv64` 的本地 AI coding CLI 适配工作。目标是远程模型 + 本地 CLI runtime，不做本地模型。请先完成以下任务：
1. 审计 `Crush` 的 Go 依赖与核心模块，识别 `riscv64` 风险点
2. 尝试 `GOOS=linux GOARCH=riscv64 go build ./...`
3. 汇总所有编译失败点并分类
4. 给出一版最小可运行 MVP 的裁剪方案
5. 优先保留 provider、session、文件工具、搜索、diff、patch、shell，暂时弱化复杂 TUI/LSP/MCP
6. 所有结论写成文档，便于后续持续迭代

## 成功标准

本轮工作不是“把 Crush 完整移植完”，而是达到以下任一结果都算成功：

- 成功编译并基本运行在 `riscv64 Linux`
- 明确指出阻塞点并给出可执行替代方案
- 得出“应 fork 精简”还是“应参考重写”的清晰结论

## 工作原则

- 先验证，再判断
- 先保核心 runtime，再保体验
- 先做可运行 MVP，再做完整 agent
- 能删就删，避免一开始背完整复杂度
- 所有失败都要沉淀为文档，不重复踩坑

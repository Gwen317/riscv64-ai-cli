# riscv64-ai-cli

`riscv64-ai-cli` is a working repository for adapting `Crush` into a usable AI
coding CLI on `riscv64 Linux`.

`riscv64-ai-cli` 是一个面向 `riscv64 Linux` 的 AI 编程 CLI 适配仓库，当前以
`Crush` 为基础持续推进。

## Overview

This repository currently has two delivery lanes:

- `headless`: the primary stable lane for build, package, verification, and release workflows
- `interactive`: the secondary lane for terminal chat development and TUI recovery

当前仓库主要有两条交付线：

- `headless`：当前主交付线，已经可以构建、打包、验证和发布
- `interactive`：次级交付线，主要用于终端聊天开发和 TUI 恢复

## What This Repo Is

This is both:

- an adaptation workspace
- a deliverable packaging repo

It records the practical work needed to make `Crush` usable on `riscv64 Linux`,
while also shipping scripts and docs that reproduce the current validated flow.

这个仓库同时承担两种角色：

- 适配研发工作区
- 当前阶段可交付物仓库

它既记录 `Crush` 在 `riscv64 Linux` 上的适配过程，也保存当前已经验证通过的构建、
打包、发布、验证流程。

## Current Status

- Native `riscv64 Linux` builds are validated on the K1 MUSE Pi Pro target
- `headless` can build on-device, package into bundles, emit checksums and manifests, and pass scripted smoke tests
- `interactive` can build on-device, enter a real TTY session, and complete a minimal prompt/response loop

当前状态：

- 已在 K1 MUSE Pi Pro 上验证原生 `riscv64 Linux` 构建
- `headless` 已具备板端构建、打包、校验和清单生成、自动 smoke 验证能力
- `interactive` 已具备板端构建、真实 TTY 启动，以及最小聊天回路验证能力

## Repository Layout

- [`forks/crush/`](./forks/crush) : active upstream-derived source tree under adaptation
- [`scripts/`](./scripts) : build, package, verify, release, and pipeline wrappers
- [`docs/plans/`](./docs/plans) : plans and scope documents
- [`docs/guides/`](./docs/guides) : deployment, release, and interaction guides
- [`docs/notes/`](./docs/notes) : evidence, decisions, and validation records

仓库结构：

- [`forks/crush/`](./forks/crush)：当前正在适配的主体源码树
- [`scripts/`](./scripts)：构建、打包、验证、发布、流水线脚本
- [`docs/plans/`](./docs/plans)：计划与范围文档
- [`docs/guides/`](./docs/guides)：部署、发布、交互说明
- [`docs/notes/`](./docs/notes)：验证证据、决策记录、运行结论

## Quick Start

### Headless

- Build:
  [`build-headless-riscv64.sh`](./scripts/build-headless-riscv64.sh)
- Package:
  [`package-headless-riscv64.sh`](./scripts/package-headless-riscv64.sh)
- Verify:
  [`verify-headless-riscv64.sh`](./scripts/verify-headless-riscv64.sh)
- Pipeline:
  [`run-headless-pipeline.sh`](./scripts/run-headless-pipeline.sh)

### Interactive

- Build:
  [`build-interactive-riscv64.sh`](./scripts/build-interactive-riscv64.sh)
- Run:
  [`run-interactive-riscv64.sh`](./scripts/run-interactive-riscv64.sh)
- Verify:
  [`verify-interactive-riscv64.sh`](./scripts/verify-interactive-riscv64.sh)
- Shell helpers:
  [`interactive-shell-functions.sh`](./scripts/interactive-shell-functions.sh)
- Full dual-lane pipeline:
  [`run-full-riscv64-pipeline.sh`](./scripts/run-full-riscv64-pipeline.sh)

快速入口：

### Headless

- 构建：
  [`build-headless-riscv64.sh`](./scripts/build-headless-riscv64.sh)
- 打包：
  [`package-headless-riscv64.sh`](./scripts/package-headless-riscv64.sh)
- 一键验证：
  [`verify-headless-riscv64.sh`](./scripts/verify-headless-riscv64.sh)
- 板端流水线：
  [`run-headless-pipeline.sh`](./scripts/run-headless-pipeline.sh)

### Interactive

- 构建：
  [`build-interactive-riscv64.sh`](./scripts/build-interactive-riscv64.sh)
- 启动：
  [`run-interactive-riscv64.sh`](./scripts/run-interactive-riscv64.sh)
- 一键验证：
  [`verify-interactive-riscv64.sh`](./scripts/verify-interactive-riscv64.sh)
- Shell 快捷函数：
  [`interactive-shell-functions.sh`](./scripts/interactive-shell-functions.sh)
- 双线流水线：
  [`run-full-riscv64-pipeline.sh`](./scripts/run-full-riscv64-pipeline.sh)

## Core Documents

- Primary plan: [CRUSH_RISCV64_PLAN.md](./docs/plans/CRUSH_RISCV64_PLAN.md)
- Dependency audit: [dependency-audit.md](./docs/notes/dependency-audit.md)
- Build log: [build-log.md](./docs/notes/build-log.md)
- Runtime test: [runtime-test.md](./docs/notes/runtime-test.md)
- Decisions: [decisions.md](./docs/notes/decisions.md)
- Headless deploy guide: [HEADLESS_DEPLOY.md](./docs/guides/HEADLESS_DEPLOY.md)
- Headless release guide: [HEADLESS_RELEASE.md](./docs/guides/HEADLESS_RELEASE.md)
- Release notes template: [HEADLESS_RELEASE_NOTES_TEMPLATE.md](./docs/guides/HEADLESS_RELEASE_NOTES_TEMPLATE.md)
- Interactive notes: [INTERACTIVE_TUI_NOTES.md](./docs/guides/INTERACTIVE_TUI_NOTES.md)
- Contributing guide: [CONTRIBUTING.md](./CONTRIBUTING.md)
- Roadmap: [ROADMAP.md](./ROADMAP.md)

核心文档：

- 总体计划：[CRUSH_RISCV64_PLAN.md](./docs/plans/CRUSH_RISCV64_PLAN.md)
- 依赖审计：[dependency-audit.md](./docs/notes/dependency-audit.md)
- 构建日志：[build-log.md](./docs/notes/build-log.md)
- 运行验证：[runtime-test.md](./docs/notes/runtime-test.md)
- 决策记录：[decisions.md](./docs/notes/decisions.md)
- Headless 部署说明：[HEADLESS_DEPLOY.md](./docs/guides/HEADLESS_DEPLOY.md)
- Headless 发布说明：[HEADLESS_RELEASE.md](./docs/guides/HEADLESS_RELEASE.md)
- Release Notes 模板：[HEADLESS_RELEASE_NOTES_TEMPLATE.md](./docs/guides/HEADLESS_RELEASE_NOTES_TEMPLATE.md)
- Interactive 说明：[INTERACTIVE_TUI_NOTES.md](./docs/guides/INTERACTIVE_TUI_NOTES.md)

## Notes

- The primary validated target is the K1 MUSE Pi Pro board.
- The top-level repository now includes the active adapted `Crush` source tree under `forks/crush/`.
- The project is currently strongest on the `headless` release path, while the `interactive` lane is proven viable and still being improved.

补充说明：

- 当前主要验证目标板为 K1 MUSE Pi Pro。
- 顶层仓库现已纳入 `forks/crush/` 主体源码树。
- 项目当前最成熟的是 `headless` 发布线，`interactive` 已被证明可行并在持续打磨中。

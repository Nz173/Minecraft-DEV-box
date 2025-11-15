# Project Context

## Purpose
**Minecraft DEV box (mcdev)** 是一个面向中国 Minecraft 模组和插件开发者的在线开发工具平台。核心功能是提供项目模板生成器，支持所有主流的 Minecraft 模组加载器（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper 等），帮助开发者快速启动 Minecraft 开发项目。

## Tech Stack
- **前端框架**: Vue 3.5.22 (Composition API with `<script setup>`)
- **构建工具**: Vite 7.1.11
- **包管理器**: pnpm
- **数据库**: Supabase (PostgreSQL + 实时订阅 + 认证)
- **部署平台**: Vercel (前端) + Supabase (后端服务)
- **代码托管**: GitHub
- **开发工具**: Vite DevTools, Vue DevTools
- **Node.js 版本**: ^20.19.0 || >=22.12.0

## Project Conventions

### Code Style
- 使用 Vue 3 Composition API 和 `<script setup>` 语法
- 组件文件使用 `.vue` 单文件组件格式
- 使用 ES Modules (`type: "module"`)
- 路径别名: `@` 指向 `src` 目录
- 中文为主要界面语言和文档语言

### Architecture Patterns
- 单页应用 (SPA) 架构
- 组件化开发模式
- Supabase 作为 BaaS (Backend as a Service)
- 前后端分离：前端部署在 Vercel，后端服务由 Supabase 提供
- 使用 Supabase JS Client 进行数据库操作和认证

### Testing Strategy
- [待定义 - 建议添加 Vitest + Vue Test Utils]

### Git Workflow
- 主分支：`main` 用于生产部署
- 功能分支：`feature/[功能名]`
- 提交信息使用中文或英文，保持简洁明确
- PR 合并前需要通过 CI 检查

## Domain Context

### Minecraft 模组开发生态
- **Fabric**: 轻量级模组加载器，使用 Yarn 映射
- **Forge**: 传统模组加载器，使用 MCP/SRG 映射
- **NeoForge**: Forge 的现代化分支
- **Bukkit/Spigot/Paper**: 服务端插件开发平台
- **模组版本**: 需要支持多个 Minecraft 版本（1.20.x, 1.21.x 等）

### 目标用户
- 中国 Minecraft 模组开发者
- 服务端插件开发者
- 希望快速开始项目的新手开发者

### 核心价值
- 简化项目初始化流程
- 提供标准化的项目结构
- 支持多种模组加载器和版本
- 中文友好的界面和文档

## Important Constraints
- 必须支持 Node.js 20.19.0+ 或 22.12.0+
- 使用 pnpm 作为唯一的包管理器
- Vercel 部署需要符合 Serverless 限制
- Supabase 免费层限制：500MB 数据库，50MB 文件存储，50,000 月活用户
- 界面和内容以中文为主

## External Dependencies
- **Supabase**: 数据库、认证、存储服务
- **Vercel**: 前端托管和部署
- **GitHub**: 代码仓库和版本控制
- **Minecraft 官方**: 版本信息和映射数据
- **模组加载器官方网站**: 各加载器的文档和最新版本信息

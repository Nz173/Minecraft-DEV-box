# 技术设计文档

## Context
项目模板生成器是 Minecraft DEV box 的核心功能。需要支持多种模组加载器，每种加载器有不同的项目结构、构建配置和依赖管理方式。系统需要灵活、可扩展，并且对新手友好。

## Goals / Non-Goals

### Goals
- 支持所有主流 Minecraft 模组加载器（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper）
- 支持多个 Minecraft 版本（1.20.x, 1.21.x 及未来版本）
- 提供简单直观的 UI，3 步完成项目生成
- 模板可通过 Supabase 动态更新，无需重新部署前端
- 生成的项目可直接导入 IDE 并运行

### Non-Goals
- 不提供在线代码编辑器
- 不提供项目托管服务
- 不集成完整的 IDE 功能
- 第一版不支持自定义模板上传（后续版本考虑）

## Decisions

### 决策 1: 使用 Supabase 存储模板数据
**原因:**
- 模板可以动态更新，无需重新部署前端
- 支持版本控制和回滚
- 提供认证和权限管理（未来可添加用户贡献模板）
- PostgreSQL 适合结构化数据存储

**替代方案:**
- 硬编码在前端 - 不灵活，每次更新需要重新部署
- GitHub 仓库 - 需要额外的 API 调用，速度慢

### 决策 2: 前端生成 ZIP 文件
**原因:**
- Vercel Serverless 有执行时间限制（10 秒免费层）
- 前端生成避免后端复杂性
- JSZip 库成熟稳定，支持浏览器环境
- 减少服务器成本

**替代方案:**
- 后端生成 - 需要 Serverless Functions 或单独的后端服务，增加复杂度

### 决策 3: 数据库表结构
```sql
-- 加载器类型表
CREATE TABLE loader_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,  -- fabric, forge, neoforge, bukkit, spigot, paper
  display_name TEXT NOT NULL,  -- 显示名称（中文）
  description TEXT,
  icon_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 模板表
CREATE TABLE templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  loader_type_id UUID REFERENCES loader_types(id),
  minecraft_version TEXT NOT NULL,  -- 1.20.1, 1.21, etc.
  name TEXT NOT NULL,
  description TEXT,
  template_data JSONB NOT NULL,  -- 模板文件结构
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(loader_type_id, minecraft_version)
);

-- 模板版本表（用于历史记录和回滚）
CREATE TABLE template_versions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  template_id UUID REFERENCES templates(id),
  version TEXT NOT NULL,
  template_data JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 决策 4: 模板数据格式
使用 JSONB 存储模板文件结构：
```json
{
  "files": [
    {
      "path": "src/main/java/com/example/mod/ExampleMod.java",
      "content": "package {{package_name}};\n...",
      "variables": ["package_name", "mod_id", "author"]
    },
    {
      "path": "build.gradle",
      "content": "...",
      "variables": ["minecraft_version", "mod_version"]
    }
  ],
  "variables": {
    "package_name": {
      "type": "string",
      "default": "com.example.mod",
      "validation": "^[a-z][a-z0-9_]*(\\.[a-z][a-z0-9_]*)*$"
    },
    "mod_id": {
      "type": "string",
      "default": "examplemod",
      "validation": "^[a-z][a-z0-9_]*$"
    }
  }
}
```

## Risks / Trade-offs

### 风险 1: 浏览器内存限制
- **风险**: 大型模板可能超出浏览器内存限制
- **缓解**: 限制单个模板大小不超过 10MB，使用流式生成

### 风险 2: 模板过时
- **风险**: Minecraft 和加载器更新频繁，模板可能快速过时
- **缓解**: 建立模板版本管理系统，提供社区更新机制（后续版本）

### 风险 3: Supabase 免费层限制
- **风险**: 50,000 月活用户可能不够
- **缓解**: 实施请求缓存，优化查询，必要时升级到付费计划

## Migration Plan

### 第一阶段（MVP）
1. 实现 Fabric 和 Forge 模板（最流行的两种）
2. 支持最新的 Minecraft 版本（1.21.x）
3. 基础 UI 和核心生成功能

### 第二阶段
1. 添加 NeoForge, Bukkit, Spigot, Paper 支持
2. 支持更多历史版本
3. 添加模板预览和说明文档

### 第三阶段
1. 用户账号系统
2. 自定义模板上传
3. 模板分享和评分系统

### 回滚计划
- 所有模板数据存储在 Supabase，可以快速回滚到之前的版本
- 前端部署在 Vercel，支持秒级回滚
- 数据库变更使用 Supabase Migrations，可追踪和还原

## Open Questions
1. 是否需要支持多语言（英文）？ -> 第一版专注中文
2. 是否需要支持插件混合模板（Fabric + Bukkit）？ -> 后续版本考虑
3. 生成的项目是否需要包含示例代码？ -> 是，提供最小可运行示例

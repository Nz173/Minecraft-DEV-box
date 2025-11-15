# Change: 添加 Minecraft 项目模板生成器

## Why
中国 Minecraft 模组和插件开发者在启动新项目时，需要手动配置复杂的构建系统、依赖关系和项目结构。不同的模组加载器（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper）有不同的配置方式，对新手不友好。我们需要一个统一的项目模板生成器来简化这个流程。

## What Changes
- 添加项目模板生成器核心功能，支持所有主流 Minecraft 模组加载器
- 创建模板选择界面，允许用户选择加载器类型和 Minecraft 版本
- 实现模板数据存储和管理（使用 Supabase）
- 提供项目配置定制选项（项目名称、包名、作者信息等）
- 生成可下载的项目文件（ZIP 格式）
- 添加模板预览和说明文档

## Impact
- **新增能力**: `template-generator` - 项目模板生成器核心功能
- **影响文件**: 
  - `src/components/` - 新增 UI 组件
  - `src/composables/` - 新增业务逻辑 composables
  - `src/api/` - 新增 Supabase API 调用
  - `package.json` - 添加新依赖（@supabase/supabase-js, jszip 等）
- **数据库变更**: 需要在 Supabase 创建 `templates` 和 `template_versions` 表

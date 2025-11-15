# Supabase 数据库设置指南

## 步骤 1: 创建 Supabase 项目

1. 访问 [Supabase](https://supabase.com/)
2. 创建新项目或使用现有项目
3. 记录项目的 URL 和 anon key

## 步骤 2: 配置环境变量

将项目 URL 和 anon key 复制到 `.env` 文件：

```bash
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## 步骤 3: 执行数据库迁移

在 Supabase Dashboard 的 SQL Editor 中，依次执行以下文件：

### 3.1 创建表结构

复制并执行 `migrations/20251115_create_templates.sql`

这将创建：
- `loader_types` - 加载器类型表
- `templates` - 模板表
- `template_versions` - 模板版本表
- 相关索引和触发器
- Row Level Security (RLS) 策略

### 3.2 插入初始数据

复制并执行 `migrations/20251115_seed_initial_data.sql`

这将插入：
- 6 种加载器类型（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper）
- Fabric 1.21 基础模板
- Forge 1.21 基础模板

## 步骤 4: 验证设置

在 Supabase Dashboard 的 Table Editor 中检查：

1. **loader_types** 表应该有 6 条记录
2. **templates** 表应该有 2 条记录（Fabric 1.21 和 Forge 1.21）

## 数据库架构

### loader_types
- `id` - UUID 主键
- `name` - 加载器标识符（fabric, forge 等）
- `display_name` - 显示名称
- `description` - 描述
- `icon_url` - 图标 URL（可选）
- `sort_order` - 排序顺序

### templates
- `id` - UUID 主键
- `loader_type_id` - 关联的加载器类型
- `minecraft_version` - Minecraft 版本（如 1.21）
- `name` - 模板名称
- `description` - 模板描述
- `template_data` - JSONB 格式的模板数据（文件结构和变量定义）
- `is_active` - 是否激活

### template_versions
- `id` - UUID 主键
- `template_id` - 关联的模板
- `version` - 版本号
- `template_data` - 该版本的模板数据

## 安全策略

已启用 Row Level Security (RLS)：
- 所有用户可以读取 `loader_types`
- 所有用户可以读取活跃的 `templates`（`is_active = true`）
- 所有用户可以读取 `template_versions`

未来可以添加写入权限给管理员用户。

## 添加新模板

在 SQL Editor 中执行类似以下的 SQL：

```sql
INSERT INTO templates (loader_type_id, minecraft_version, name, description, template_data)
SELECT 
    id,
    '1.20.1',
    'Fabric 1.20.1 基础模板',
    '适合 Minecraft 1.20.1 的 Fabric 模组基础模板',
    '{"files": [...], "variables": {...}}'::jsonb
FROM loader_types
WHERE name = 'fabric';
```

## 故障排除

### 连接失败
- 检查 `.env` 文件中的 URL 和 key 是否正确
- 确保 Supabase 项目处于活跃状态

### RLS 策略问题
- 确保已执行 RLS 策略创建语句
- 检查 Supabase Dashboard 的 Authentication > Policies

### 查询超时
- 检查数据库索引是否正确创建
- 考虑优化查询或升级 Supabase 计划

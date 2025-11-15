# 实施任务清单

## 1. 依赖和配置
- [x] 1.1 安装 Supabase JS Client (`@supabase/supabase-js`)
- [x] 1.2 安装 JSZip 库用于生成 ZIP 文件
- [x] 1.3 配置 Supabase 环境变量（`.env` 文件）
- [x] 1.4 创建 Supabase 客户端初始化文件

## 2. 数据库设计和实施
- [x] 2.1 设计数据库表结构（`templates`, `template_versions`, `loader_types`）
- [x] 2.2 在 Supabase 创建数据库表和关系
- [x] 2.3 配置 Row Level Security (RLS) 策略
- [x] 2.4 准备初始模板数据（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper）

## 3. API 和业务逻辑
- [x] 3.1 创建 `src/api/supabase.js` - Supabase 客户端配置
- [x] 3.2 创建 `src/api/templates.js` - 模板相关 API 调用
- [x] 3.3 创建 `src/composables/useTemplates.js` - 模板管理逻辑
- [x] 3.4 创建 `src/composables/useProjectGenerator.js` - 项目生成逻辑

## 4. UI 组件开发
- [x] 4.1 创建 `LoaderSelector.vue` - 模组加载器选择器
- [x] 4.2 创建 `VersionSelector.vue` - Minecraft 版本选择器
- [x] 4.3 创建 `ProjectConfigForm.vue` - 项目配置表单
- [x] 4.4 创建 `TemplatePreview.vue` - 模板预览组件
- [x] 4.5 创建 `TemplateGenerator.vue` - 主生成器页面

## 5. 项目生成功能
- [x] 5.1 实现模板文件生成逻辑
- [x] 5.2 实现变量替换功能（项目名、包名等）
- [x] 5.3 实现 ZIP 文件打包和下载
- [x] 5.4 添加生成进度反馈

## 6. 样式和用户体验
- [x] 6.1 设计响应式布局（支持移动端）
- [x] 6.2 添加 Loading 状态和错误处理
- [x] 6.3 优化表单验证和用户提示
- [x] 6.4 添加使用说明和帮助文档

## 7. Vercel 部署配置
- [x] 7.1 创建 `vercel.json` 配置文件
- [x] 7.2 配置环境变量
- [x] 7.3 测试生产环境部署

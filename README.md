# Minecraft DEV box

> 为中国 Minecraft 模组和插件开发者打造的在线项目模板生成器

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/your-username/mcdevbox)

## 简介

Minecraft DEV box (mcdev) 是一个专为中国 Minecraft 开发者设计的在线工具，帮助快速生成规范的模组和插件项目模板。

### 核心功能

- ✨ 支持所有主流模组加载器（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper）
- 🚀 三步快速生成：选择加载器 → 选择版本 → 配置项目
- 📦 一键下载完整项目 ZIP 文件
- 🎨 现代化 UI，支持桌面和移动端
- 🔄 模板动态更新，无需重新部署
- 🇨🇳 完全中文化界面和文档

### 技术栈

- **前端**: Vue 3 + Vite
- **数据库**: Supabase (PostgreSQL)
- **部署**: Vercel
- **核心库**: JSZip, @supabase/supabase-js

## 快速开始

### 本地开发

1. **克隆仓库**

```bash
git clone https://github.com/your-username/mcdevbox.git
cd mcdevbox
```

2. **安装依赖**

```bash
pnpm install
```

3. **配置环境变量**

复制 `.env.example` 为 `.env` 并填写 Supabase 配置：

```bash
cp .env.example .env
```

编辑 `.env`：
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

4. **设置数据库**

参考 `supabase/README.md` 完成数据库初始化。

5. **启动开发服务器**

```bash
pnpm dev
```

访问 http://localhost:5173

### 构建生产版本

```bash
pnpm build
pnpm preview
```

## 部署

详细部署指南请参考 [DEPLOYMENT.md](./DEPLOYMENT.md)

### 快速部署到 Vercel

1. Fork 本仓库
2. 在 Vercel 导入项目
3. 配置环境变量
4. 点击 Deploy

## 项目结构

```
mcdevbox/
├── src/
│   ├── api/                 # API 调用
│   │   ├── supabase.js      # Supabase 客户端
│   │   └── templates.js     # 模板 API
│   ├── components/          # Vue 组件
│   │   ├── LoaderSelector.vue
│   │   ├── VersionSelector.vue
│   │   ├── ProjectConfigForm.vue
│   │   ├── TemplatePreview.vue
│   │   └── TemplateGenerator.vue
│   ├── composables/         # 组合式函数
│   │   ├── useTemplates.js
│   │   └── useProjectGenerator.js
│   ├── App.vue
│   └── main.js
├── supabase/
│   ├── migrations/          # 数据库迁移
│   └── README.md
├── openspec/                # OpenSpec 规格文档
│   ├── project.md
│   ├── AGENTS.md
│   └── changes/
└── public/
```

## 开发指南

### 添加新的加载器类型

1. 在 Supabase 的 `loader_types` 表中添加新记录
2. 创建对应的模板数据（JSONB 格式）
3. 插入到 `templates` 表

### 添加新的 Minecraft 版本

为现有加载器添加新版本的模板数据即可，系统会自动识别。

### 修改模板结构

编辑 `templates` 表中的 `template_data` JSONB 字段：

```json
{
  "files": [
    {
      "path": "文件路径",
      "content": "文件内容，支持 {{变量}} 占位符"
    }
  ],
  "variables": {
    "变量名": {
      "label": "显示标签",
      "type": "string",
      "default": "默认值",
      "validation": "正则表达式",
      "description": "说明"
    }
  }
}
```

## OpenSpec 工作流

本项目使用 OpenSpec 进行规格驱动开发。详情请参考：

- [项目上下文](./openspec/project.md)
- [OpenSpec 指南](./openspec/AGENTS.md)
- [当前变更](./openspec/changes/)

## 贡献指南

欢迎贡献！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 许可证

MIT License - 详见 [LICENSE](./LICENSE) 文件

## 致谢

- [Fabric](https://fabricmc.net/)
- [Forge](https://minecraftforge.net/)
- [Supabase](https://supabase.com/)
- [Vercel](https://vercel.com/)
- [Vue.js](https://vuejs.org/)

## 联系方式

- 项目链接: [https://github.com/your-username/mcdevbox](https://github.com/your-username/mcdevbox)
- 问题反馈: [Issues](https://github.com/your-username/mcdevbox/issues)

---

**为中国 Minecraft 开发者社区而生 ❤️**

# 部署指南

本文档说明如何将 Minecraft DEV box 部署到 Vercel 和配置 Supabase。

## 前置准备

### 1. Supabase 设置

1. 访问 [Supabase](https://supabase.com/) 并创建新项目
2. 在 SQL Editor 中执行数据库迁移：
   - 复制并运行 `supabase/migrations/20251115_create_templates.sql`
   - 复制并运行 `supabase/migrations/20251115_seed_initial_data.sql`
3. 在项目设置中获取：
   - **Project URL**（格式：https://your-project.supabase.co）
   - **Anon Key**（公开密钥，可在前端使用）

详细步骤请参考 `supabase/README.md`

### 2. GitHub 仓库

1. 创建新的 GitHub 仓库
2. 推送代码到仓库：

```bash
git init
git add .
git commit -m "Initial commit: Minecraft DEV box"
git branch -M main
git remote add origin https://github.com/your-username/mcdevbox.git
git push -u origin main
```

## 部署到 Vercel

### 方法 1: 通过 Vercel Dashboard（推荐）

1. 访问 [Vercel](https://vercel.com/)
2. 点击 "New Project"
3. 导入你的 GitHub 仓库
4. 配置项目：
   - **Framework Preset**: Vite
   - **Root Directory**: `./`（默认）
   - **Build Command**: `pnpm build`（已在 vercel.json 中配置）
   - **Output Directory**: `dist`（已在 vercel.json 中配置）

5. 添加环境变量：
   - 点击 "Environment Variables"
   - 添加以下变量：
     ```
     VITE_SUPABASE_URL = https://your-project.supabase.co
     VITE_SUPABASE_ANON_KEY = your-anon-key-here
     ```

6. 点击 "Deploy"

### 方法 2: 使用 Vercel CLI

```bash
# 安装 Vercel CLI
npm i -g vercel

# 登录
vercel login

# 首次部署
vercel

# 设置环境变量
vercel env add VITE_SUPABASE_URL
vercel env add VITE_SUPABASE_ANON_KEY

# 生产部署
vercel --prod
```

## 环境变量配置

在 Vercel Dashboard 的项目设置中，确保配置以下环境变量：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `VITE_SUPABASE_URL` | https://xxx.supabase.co | Supabase 项目 URL |
| `VITE_SUPABASE_ANON_KEY` | eyJxxx... | Supabase 匿名密钥 |

**注意**：
- 所有 Vite 环境变量必须以 `VITE_` 开头
- 这些是公开的客户端变量，会打包到前端代码中
- 不要在这里使用 Service Role Key（服务端密钥）

## 自定义域名（可选）

1. 在 Vercel 项目设置中点击 "Domains"
2. 添加你的自定义域名
3. 按照提示配置 DNS 记录
4. 等待 DNS 传播（通常几分钟到几小时）

## 验证部署

部署完成后，访问 Vercel 提供的 URL（如 `https://mcdevbox.vercel.app`）：

### 检查清单

- [ ] 页面正常加载，显示"Minecraft DEV box"标题
- [ ] 加载器选择器显示 6 种加载器（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper）
- [ ] 选择 Fabric 后可以看到版本列表
- [ ] 选择版本后可以填写项目配置
- [ ] 点击"生成项目"可以下载 ZIP 文件
- [ ] 浏览器控制台无错误（按 F12 查看）

### 常见问题排查

#### 1. 页面空白或加载失败
- 检查浏览器控制台错误
- 确认环境变量配置正确
- 检查 Vercel 构建日志是否有错误

#### 2. 无法连接 Supabase
- 确认 `VITE_SUPABASE_URL` 和 `VITE_SUPABASE_ANON_KEY` 设置正确
- 在浏览器控制台运行：
  ```javascript
  console.log(import.meta.env.VITE_SUPABASE_URL)
  ```
  确认变量已正确注入

#### 3. 加载器列表为空
- 确认已在 Supabase 执行初始化 SQL
- 检查 Supabase 的 Table Editor，确认 `loader_types` 表有数据
- 检查 RLS 策略是否正确设置（允许公开读取）

#### 4. 生成项目失败
- 检查浏览器控制台的详细错误信息
- 确认模板数据格式正确
- 检查 JSZip 库是否正确加载

## 持续部署

Vercel 已自动配置 CI/CD：

- **main 分支**：推送后自动部署到生产环境
- **其他分支**：推送后创建预览部署

每次推送代码，Vercel 会：
1. 检测到更改
2. 自动构建
3. 运行测试（如果配置）
4. 部署到对应环境

## 监控和日志

### Vercel Dashboard
- 访问项目的 Deployments 页面查看所有部署记录
- 点击任一部署查看详细日志和运行时日志
- 在 Analytics 页面查看访问统计

### Supabase Dashboard
- 在 Logs 页面查看数据库查询日志
- 在 API 页面查看 API 调用统计
- 设置告警规则监控异常

## 回滚部署

如果新部署有问题：

1. 在 Vercel Dashboard 的 Deployments 页面
2. 找到之前工作正常的部署
3. 点击右侧菜单选择 "Promote to Production"
4. 确认回滚

或使用 CLI：
```bash
vercel rollback
```

## 成本估算

### Vercel 免费层限制
- 100 GB 带宽/月
- 无限部署
- 自动 HTTPS
- 全球 CDN

超出后按使用量计费，详见 [Vercel 定价](https://vercel.com/pricing)

### Supabase 免费层限制
- 500 MB 数据库空间
- 50 MB 文件存储
- 50,000 月活用户
- 2 GB 出站流量

超出后需升级，详见 [Supabase 定价](https://supabase.com/pricing)

## 下一步

- [ ] 配置自定义域名
- [ ] 设置 Google Analytics 或其他分析工具
- [ ] 添加更多模板和版本
- [ ] 考虑添加用户认证系统
- [ ] 优化性能和 SEO

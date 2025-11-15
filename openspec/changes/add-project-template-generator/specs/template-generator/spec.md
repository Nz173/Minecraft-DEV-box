# 项目模板生成器规格

## ADDED Requirements

### Requirement: 加载器类型选择
The system MUST allow users to select target Minecraft mod loader type. 系统必须允许用户选择目标 Minecraft 模组加载器类型。

#### Scenario: 用户选择 Fabric 加载器
- **WHEN** 用户在加载器选择界面选择 Fabric
- **THEN** 系统显示 Fabric 支持的 Minecraft 版本列表
- **AND** 显示 Fabric 模组开发的简要说明

#### Scenario: 用户选择 Forge 加载器
- **WHEN** 用户在加载器选择界面选择 Forge
- **THEN** 系统显示 Forge 支持的 Minecraft 版本列表
- **AND** 显示 Forge 模组开发的简要说明

#### Scenario: 显示所有支持的加载器
- **WHEN** 用户访问模板生成器页面
- **THEN** 系统显示所有支持的加载器列表（Fabric, Forge, NeoForge, Bukkit, Spigot, Paper）
- **AND** 每个加载器显示图标、名称和简短描述

### Requirement: Minecraft 版本选择
The system MUST provide a list of Minecraft versions compatible with the selected loader. 系统必须提供与所选加载器兼容的 Minecraft 版本列表。

#### Scenario: 显示兼容版本
- **WHEN** 用户选择了加载器类型
- **THEN** 系统从 Supabase 获取该加载器支持的 Minecraft 版本列表
- **AND** 版本按照从新到旧排序
- **AND** 标注推荐版本（最新稳定版）

#### Scenario: 无可用版本
- **WHEN** 所选加载器没有可用的模板版本
- **THEN** 系统显示友好的提示信息
- **AND** 提供回到加载器选择的按钮

### Requirement: 项目配置定制
The system MUST allow users to customize basic project information. 系统必须允许用户定制项目基本信息。

#### Scenario: 填写项目信息
- **WHEN** 用户在配置表单中输入项目信息
- **THEN** 系统验证以下字段：
  - 项目名称（必填，字母数字下划线，2-50 字符）
  - 模组 ID / 插件名（必填，小写字母数字下划线，3-32 字符）
  - 包名（必填，符合 Java 包名规范）
  - 作者名称（必填，1-50 字符）
  - 描述（可选，最多 200 字符）
- **AND** 实时显示验证错误提示

#### Scenario: 使用默认值
- **WHEN** 用户不填写某些可选字段
- **THEN** 系统使用合理的默认值
- **AND** 默认值基于已填写的必填字段生成（如从项目名称生成包名）

### Requirement: 模板预览
The system MUST provide template preview functionality before generation. 系统必须提供生成前的模板预览功能。

#### Scenario: 查看模板文件结构
- **WHEN** 用户点击"预览模板"按钮
- **THEN** 系统显示将要生成的文件列表
- **AND** 显示项目目录树结构
- **AND** 允许用户查看关键文件的内容预览（带变量替换）

#### Scenario: 查看模板说明
- **WHEN** 用户查看模板详情
- **THEN** 系统显示该模板的使用说明
- **AND** 显示所需的开发环境要求
- **AND** 提供快速开始指南链接

### Requirement: 项目生成和下载
The system MUST be able to generate complete project files and provide download. 系统必须能够生成完整的项目文件并提供下载。

#### Scenario: 成功生成项目
- **WHEN** 用户点击"生成项目"按钮且所有配置有效
- **THEN** 系统从 Supabase 获取模板数据
- **AND** 使用用户配置替换模板变量
- **AND** 使用 JSZip 打包所有文件为 ZIP 格式
- **AND** 自动触发浏览器下载，文件名为 `{项目名称}-{加载器}-{版本}.zip`
- **AND** 显示生成成功提示

#### Scenario: 生成过程中显示进度
- **WHEN** 系统正在生成项目
- **THEN** 显示加载动画和当前步骤
- **AND** 显示进度百分比（获取模板 25% -> 处理文件 50% -> 打包 75% -> 完成 100%）

#### Scenario: 生成失败处理
- **WHEN** 生成过程中发生错误（网络错误、模板数据损坏等）
- **THEN** 系统显示友好的错误信息
- **AND** 提供重试按钮
- **AND** 记录错误日志（不影响用户体验）

### Requirement: 模板数据管理
The system MUST dynamically load template data from Supabase. 系统必须从 Supabase 动态加载模板数据。

#### Scenario: 获取模板列表
- **WHEN** 用户选择加载器和版本
- **THEN** 系统通过 Supabase JS Client 查询 templates 表
- **AND** 使用查询缓存减少重复请求
- **AND** 处理查询超时（超过 5 秒显示错误）

#### Scenario: 模板数据缓存
- **WHEN** 系统首次获取某个模板数据
- **THEN** 将数据缓存在浏览器 localStorage
- **AND** 设置缓存过期时间（24 小时）
- **AND** 下次访问时优先使用缓存，异步更新最新数据

### Requirement: 响应式设计
The system interface MUST support desktop and mobile devices. 系统界面必须支持桌面和移动设备。

#### Scenario: 桌面浏览器访问
- **WHEN** 用户在桌面浏览器（>1024px）访问
- **THEN** 显示完整的多列布局
- **AND** 左侧显示加载器列表，右侧显示配置表单

#### Scenario: 移动设备访问
- **WHEN** 用户在移动设备（<768px）访问
- **THEN** 显示单列垂直布局
- **AND** 使用可折叠的步骤导航
- **AND** 表单元素适应触摸操作（按钮大小 >= 44px）

### Requirement: 错误处理和用户反馈
The system MUST provide clear error handling and user feedback. 系统必须提供清晰的错误处理和用户反馈。

#### Scenario: 网络错误处理
- **WHEN** Supabase 连接失败或超时
- **THEN** 显示中文错误提示"网络连接失败，请检查您的网络设置"
- **AND** 提供重试按钮
- **AND** 不阻塞用户的其他操作

#### Scenario: 表单验证反馈
- **WHEN** 用户输入无效数据
- **THEN** 在对应字段下方显示红色错误提示
- **AND** 禁用"生成项目"按钮
- **AND** 提供输入建议（如包名格式示例）

#### Scenario: 成功操作反馈
- **WHEN** 项目生成成功
- **THEN** 显示绿色成功提示
- **AND** 自动隐藏（3 秒后）
- **AND** 提供"再生成一个"快捷操作

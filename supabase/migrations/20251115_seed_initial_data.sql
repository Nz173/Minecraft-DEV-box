-- 插入加载器类型数据
INSERT INTO loader_types (name, display_name, description, sort_order) VALUES
('fabric', 'Fabric', '轻量级的现代化模组加载器，使用 Yarn 映射，适合快速开发和模组兼容', 1),
('forge', 'Forge', '经典的模组加载器，拥有最大的模组生态系统，使用 MCP/SRG 映射', 2),
('neoforge', 'NeoForge', 'Forge 的现代化分支，提供更好的性能和开发体验', 3),
('bukkit', 'Bukkit', '经典的服务端插件 API，为服务器插件开发提供基础', 4),
('spigot', 'Spigot', '高性能的 Bukkit 分支，包含性能优化和额外 API', 5),
('paper', 'Paper', '基于 Spigot 的高性能服务端，提供更多优化和现代化 API', 6)
ON CONFLICT (name) DO NOTHING;

-- 插入 Fabric 1.21 模板（最小示例）
INSERT INTO templates (loader_type_id, minecraft_version, name, description, template_data)
SELECT 
    id,
    '1.21',
    'Fabric 1.21 基础模板',
    '适合 Minecraft 1.21 的 Fabric 模组基础模板，包含最小可运行示例',
    '{
      "files": [
        {
          "path": "gradle.properties",
          "content": "# Fabric Properties\\nminecraft_version=1.21\\nloader_version=0.16.9\\nfabric_version=0.109.0+1.21\\n\\n# Mod Properties\\nmod_version={{mod_version}}\\nmaven_group={{maven_group}}\\narchives_base_name={{mod_id}}\\n\\n# Dependencies\\nfabric_api_version=0.109.0+1.21"
        },
        {
          "path": "build.gradle",
          "content": "plugins {\\n\\tid ''fabric-loom'' version ''1.9-SNAPSHOT''\\n\\tid ''maven-publish''\\n}\\n\\nversion = project.mod_version\\ngroup = project.maven_group\\n\\nrepositories {\\n\\tmavenCentral()\\n}\\n\\ndependencies {\\n\\tminecraft \"com.mojang:minecraft:${project.minecraft_version}\"\\n\\tmappings \"net.fabricmc:yarn:${project.minecraft_version}+build.9:v2\"\\n\\tmodImplementation \"net.fabricmc:fabric-loader:${project.loader_version}\"\\n\\tmodImplementation \"net.fabricmc.fabric-api:fabric-api:${project.fabric_api_version}\"\\n}\\n\\nprocessResources {\\n\\tinputs.property \"version\", project.version\\n\\tfilteringCharset \"UTF-8\"\\n\\tfromSource {\\n\\t\\texpand \"version\": project.version\\n\\t}\\n}\\n\\ntasks.withType(JavaCompile).configureEach {\\n\\toptions.encoding = \"UTF-8\"\\n\\toptions.release = 21\\n}"
        },
        {
          "path": "settings.gradle",
          "content": "pluginManagement {\\n\\trepositories {\\n\\t\\tmavenCentral()\\n\\t\\tgradlePluginPortal()\\n\\t\\tmaven { url ''https://maven.fabricmc.net/'' }\\n\\t}\\n}\\n\\nrootProject.name = ''{{mod_id}}''"
        },
        {
          "path": "src/main/resources/fabric.mod.json",
          "content": "{\\n  \"schemaVersion\": 1,\\n  \"id\": \"{{mod_id}}\",\\n  \"version\": \"{{mod_version}}\",\\n  \"name\": \"{{mod_name}}\",\\n  \"description\": \"{{description}}\",\\n  \"authors\": [\"{{author}}\"],\\n  \"contact\": {},\\n  \"license\": \"MIT\",\\n  \"icon\": \"assets/{{mod_id}}/icon.png\",\\n  \"environment\": \"*\",\\n  \"entrypoints\": {\\n    \"main\": [\"{{package_name}}.{{mod_class}}\"]\\n  },\\n  \"mixins\": [],\\n  \"depends\": {\\n    \"fabricloader\": \">=0.16.0\",\\n    \"minecraft\": \"~1.21\",\\n    \"java\": \">=21\",\\n    \"fabric-api\": \"*\"\\n  }\\n}"
        },
        {
          "path": "src/main/java/{{package_path}}/{{mod_class}}.java",
          "content": "package {{package_name}};\\n\\nimport net.fabricmc.api.ModInitializer;\\nimport org.slf4j.Logger;\\nimport org.slf4j.LoggerFactory;\\n\\npublic class {{mod_class}} implements ModInitializer {\\n\\tpublic static final String MOD_ID = \"{{mod_id}}\";\\n\\tpublic static final Logger LOGGER = LoggerFactory.getLogger(MOD_ID);\\n\\n\\t@Override\\n\\tpublic void onInitialize() {\\n\\t\\tLOGGER.info(\"Hello from {{mod_name}}!\");\\n\\t}\\n}"
        },
        {
          "path": "README.md",
          "content": "# {{mod_name}}\\n\\n{{description}}\\n\\n## 构建\\n\\n```bash\\n./gradlew build\\n```\\n\\n## 作者\\n\\n{{author}}"
        }
      ],
      "variables": {
        "mod_id": {
          "label": "模组 ID",
          "type": "string",
          "default": "examplemod",
          "validation": "^[a-z][a-z0-9_]*$",
          "description": "模组的唯一标识符，只能包含小写字母、数字和下划线"
        },
        "mod_name": {
          "label": "模组名称",
          "type": "string",
          "default": "Example Mod",
          "validation": "^[A-Za-z0-9 ]{2,50}$",
          "description": "模组的显示名称"
        },
        "mod_version": {
          "label": "模组版本",
          "type": "string",
          "default": "1.0.0",
          "validation": "^[0-9]+\\.[0-9]+\\.[0-9]+$",
          "description": "模组版本号，格式如 1.0.0"
        },
        "maven_group": {
          "label": "Maven 组名",
          "type": "string",
          "default": "com.example",
          "validation": "^[a-z][a-z0-9_]*(\\.[a-z][a-z0-9_]*)*$",
          "description": "Maven 组名，遵循 Java 包名规范"
        },
        "package_name": {
          "label": "Java 包名",
          "type": "string",
          "default": "com.example.examplemod",
          "validation": "^[a-z][a-z0-9_]*(\\.[a-z][a-z0-9_]*)*$",
          "description": "Java 包名，通常是 maven_group.mod_id"
        },
        "package_path": {
          "label": "包路径",
          "type": "computed",
          "compute": "package_name.replace(''.'', ''/'')",
          "description": "自动从 package_name 计算"
        },
        "mod_class": {
          "label": "主类名",
          "type": "string",
          "default": "ExampleMod",
          "validation": "^[A-Z][A-Za-z0-9]*$",
          "description": "模组主类名，使用大驼峰命名"
        },
        "author": {
          "label": "作者",
          "type": "string",
          "default": "Your Name",
          "validation": "^.{1,50}$",
          "description": "模组作者名称"
        },
        "description": {
          "label": "描述",
          "type": "string",
          "default": "这是一个 Fabric 模组示例",
          "validation": "^.{0,200}$",
          "description": "模组简短描述"
        }
      }
    }'::jsonb
FROM loader_types
WHERE name = 'fabric'
ON CONFLICT (loader_type_id, minecraft_version) DO NOTHING;

-- 插入 Forge 1.21 模板（最小示例）
INSERT INTO templates (loader_type_id, minecraft_version, name, description, template_data)
SELECT 
    id,
    '1.21',
    'Forge 1.21 基础模板',
    '适合 Minecraft 1.21 的 Forge 模组基础模板，包含最小可运行示例',
    '{
      "files": [
        {
          "path": "gradle.properties",
          "content": "# Forge Properties\\nminecraft_version=1.21\\nforge_version=51.0.33\\n\\n# Mod Properties\\nmod_id={{mod_id}}\\nmod_name={{mod_name}}\\nmod_version={{mod_version}}\\nmod_group_id={{maven_group}}\\nmod_author={{author}}\\nmod_description={{description}}"
        },
        {
          "path": "build.gradle",
          "content": "plugins {\\n\\tid ''net.minecraftforge.gradle'' version ''[6.0.24,6.2)''\\n\\tid ''org.parchmentmc.librarian.forgegradle'' version ''1.+''\\n}\\n\\ngroup = mod_group_id\\nversion = mod_version\\n\\nrepositories {\\n\\tmavenCentral()\\n\\tmaven { url ''https://maven.parchmentmc.org'' }\\n}\\n\\nminecraft {\\n\\tmappings channel: ''parchment'', version: ''2024.07.28-1.21''\\n}\\n\\ndependencies {\\n\\tminecraft \"net.minecraftforge:forge:${minecraft_version}-${forge_version}\"\\n}\\n\\ntasks.named(''jar'', Jar).configure {\\n\\tmanifest {\\n\\t\\tattributes([\\n\\t\\t\\t''Specification-Title''     : mod_id,\\n\\t\\t\\t''Specification-Vendor''    : mod_author,\\n\\t\\t\\t''Specification-Version''   : ''1'',\\n\\t\\t\\t''Implementation-Title''    : project.name,\\n\\t\\t\\t''Implementation-Version''  : project.version,\\n\\t\\t\\t''Implementation-Vendor''   : mod_author\\n\\t\\t])\\n\\t}\\n}"
        },
        {
          "path": "settings.gradle",
          "content": "pluginManagement {\\n\\trepositories {\\n\\t\\tmavenCentral()\\n\\t\\tgradlePluginPortal()\\n\\t\\tmaven { url ''https://maven.minecraftforge.net/'' }\\n\\t\\tmaven { url ''https://maven.parchmentmc.org'' }\\n\\t}\\n}\\n\\nrootProject.name = ''{{mod_id}}''"
        },
        {
          "path": "src/main/resources/META-INF/mods.toml",
          "content": "modLoader=\\\"javafml\\\"\\nloaderVersion=\\\"[51,)\\\"\\nlicense=\\\"MIT\\\"\\n\\n[[mods]]\\nmodId=\\\"{{mod_id}}\\\"\\nversion=\\\"{{mod_version}}\\\"\\ndisplayName=\\\"{{mod_name}}\\\"\\nauthors=\\\"{{author}}\\\"\\ndescription=\\\"{{description}}\\\"\\n\\n[[dependencies.{{mod_id}}]]\\n    modId=\\\"forge\\\"\\n    mandatory=true\\n    versionRange=\\\"[51,)\\\"\\n    ordering=\\\"NONE\\\"\\n    side=\\\"BOTH\\\"\\n\\n[[dependencies.{{mod_id}}]]\\n    modId=\\\"minecraft\\\"\\n    mandatory=true\\n    versionRange=\\\"[1.21,1.22)\\\"\\n    ordering=\\\"NONE\\\"\\n    side=\\\"BOTH\\\""
        },
        {
          "path": "src/main/java/{{package_path}}/{{mod_class}}.java",
          "content": "package {{package_name}};\\n\\nimport com.mojang.logging.LogUtils;\\nimport net.minecraftforge.common.MinecraftForge;\\nimport net.minecraftforge.fml.common.Mod;\\nimport org.slf4j.Logger;\\n\\n@Mod({{mod_class}}.MOD_ID)\\npublic class {{mod_class}} {\\n\\tpublic static final String MOD_ID = \\\"{{mod_id}}\\\";\\n\\tprivate static final Logger LOGGER = LogUtils.getLogger();\\n\\n\\tpublic {{mod_class}}() {\\n\\t\\tMinecraftForge.EVENT_BUS.register(this);\\n\\t\\tLOGGER.info(\\\"Hello from {{mod_name}}!\\\");\\n\\t}\\n}"
        },
        {
          "path": "README.md",
          "content": "# {{mod_name}}\\n\\n{{description}}\\n\\n## 构建\\n\\n```bash\\n./gradlew build\\n```\\n\\n## 作者\\n\\n{{author}}"
        }
      ],
      "variables": {
        "mod_id": {
          "label": "模组 ID",
          "type": "string",
          "default": "examplemod",
          "validation": "^[a-z][a-z0-9_]*$",
          "description": "模组的唯一标识符，只能包含小写字母、数字和下划线"
        },
        "mod_name": {
          "label": "模组名称",
          "type": "string",
          "default": "Example Mod",
          "validation": "^[A-Za-z0-9 ]{2,50}$",
          "description": "模组的显示名称"
        },
        "mod_version": {
          "label": "模组版本",
          "type": "string",
          "default": "1.0.0",
          "validation": "^[0-9]+\\.[0-9]+\\.[0-9]+$",
          "description": "模组版本号，格式如 1.0.0"
        },
        "maven_group": {
          "label": "Maven 组名",
          "type": "string",
          "default": "com.example",
          "validation": "^[a-z][a-z0-9_]*(\\.[a-z][a-z0-9_]*)*$",
          "description": "Maven 组名，遵循 Java 包名规范"
        },
        "package_name": {
          "label": "Java 包名",
          "type": "string",
          "default": "com.example.examplemod",
          "validation": "^[a-z][a-z0-9_]*(\\.[a-z][a-z0-9_]*)*$",
          "description": "Java 包名，通常是 maven_group.mod_id"
        },
        "package_path": {
          "label": "包路径",
          "type": "computed",
          "compute": "package_name.replace(''.'', ''/'')",
          "description": "自动从 package_name 计算"
        },
        "mod_class": {
          "label": "主类名",
          "type": "string",
          "default": "ExampleMod",
          "validation": "^[A-Z][A-Za-z0-9]*$",
          "description": "模组主类名，使用大驼峰命名"
        },
        "author": {
          "label": "作者",
          "type": "string",
          "default": "Your Name",
          "validation": "^.{1,50}$",
          "description": "模组作者名称"
        },
        "description": {
          "label": "描述",
          "type": "string",
          "default": "这是一个 Forge 模组示例",
          "validation": "^.{0,200}$",
          "description": "模组简短描述"
        }
      }
    }'::jsonb
FROM loader_types
WHERE name = 'forge'
ON CONFLICT (loader_type_id, minecraft_version) DO NOTHING;

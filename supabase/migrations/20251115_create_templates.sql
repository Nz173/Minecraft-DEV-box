-- 创建加载器类型表
CREATE TABLE IF NOT EXISTS loader_types (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  description TEXT,
  icon_url TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建模板表
CREATE TABLE IF NOT EXISTS templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  loader_type_id UUID REFERENCES loader_types(id) ON DELETE CASCADE,
  minecraft_version TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  template_data JSONB NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(loader_type_id, minecraft_version)
);

-- 创建模板版本表（用于历史记录和回滚）
CREATE TABLE IF NOT EXISTS template_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID REFERENCES templates(id) ON DELETE CASCADE,
  version TEXT NOT NULL,
  template_data JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_templates_loader_type ON templates(loader_type_id);
CREATE INDEX IF NOT EXISTS idx_templates_minecraft_version ON templates(minecraft_version);
CREATE INDEX IF NOT EXISTS idx_templates_active ON templates(is_active);
CREATE INDEX IF NOT EXISTS idx_template_versions_template ON template_versions(template_id);

-- 创建更新时间自动更新触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_templates_updated_at
    BEFORE UPDATE ON templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 配置 Row Level Security (RLS)
ALTER TABLE loader_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE template_versions ENABLE ROW LEVEL SECURITY;

-- 允许所有人读取数据（公开访问）
CREATE POLICY "允许所有人读取加载器类型" ON loader_types
    FOR SELECT USING (true);

CREATE POLICY "允许所有人读取活跃模板" ON templates
    FOR SELECT USING (is_active = true);

CREATE POLICY "允许所有人读取模板版本" ON template_versions
    FOR SELECT USING (true);

-- 注释
COMMENT ON TABLE loader_types IS 'Minecraft 模组加载器类型';
COMMENT ON TABLE templates IS 'Minecraft 项目模板';
COMMENT ON TABLE template_versions IS '模板历史版本';

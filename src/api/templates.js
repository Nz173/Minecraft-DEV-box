import { supabase } from './supabase'

/**
 * 获取所有加载器类型
 * @returns {Promise<{data: Array, error: any}>}
 */
export async function getLoaderTypes() {
  try {
    const { data, error } = await supabase
      .from('loader_types')
      .select('*')
      .order('sort_order', { ascending: true })
    
    if (error) throw error
    return { data, error: null }
  } catch (error) {
    console.error('获取加载器类型失败:', error)
    return { data: null, error }
  }
}

/**
 * 根据加载器类型获取可用的 Minecraft 版本列表
 * @param {string} loaderTypeName - 加载器类型名称
 * @returns {Promise<{data: Array<string>, error: any}>}
 */
export async function getMinecraftVersions(loaderTypeName) {
  try {
    const { data, error } = await supabase
      .from('templates')
      .select('minecraft_version')
      .eq('loader_types.name', loaderTypeName)
      .eq('is_active', true)
      .order('minecraft_version', { ascending: false })
    
    if (error) throw error
    
    // 提取唯一的版本号
    const versions = [...new Set(data?.map(item => item.minecraft_version) || [])]
    return { data: versions, error: null }
  } catch (error) {
    console.error('获取 Minecraft 版本失败:', error)
    return { data: null, error }
  }
}

/**
 * 获取特定模板数据
 * @param {string} loaderTypeId - 加载器类型 ID
 * @param {string} minecraftVersion - Minecraft 版本
 * @returns {Promise<{data: Object, error: any}>}
 */
export async function getTemplate(loaderTypeId, minecraftVersion) {
  try {
    const { data, error } = await supabase
      .from('templates')
      .select('*')
      .eq('loader_type_id', loaderTypeId)
      .eq('minecraft_version', minecraftVersion)
      .eq('is_active', true)
      .single()
    
    if (error) throw error
    return { data, error: null }
  } catch (error) {
    console.error('获取模板失败:', error)
    return { data: null, error }
  }
}

/**
 * 获取所有活跃模板（用于预加载）
 * @returns {Promise<{data: Array, error: any}>}
 */
export async function getAllTemplates() {
  try {
    const { data, error } = await supabase
      .from('templates')
      .select(`
        *,
        loader_types (
          name,
          display_name
        )
      `)
      .eq('is_active', true)
      .order('minecraft_version', { ascending: false })
    
    if (error) throw error
    return { data, error: null }
  } catch (error) {
    console.error('获取所有模板失败:', error)
    return { data: null, error }
  }
}

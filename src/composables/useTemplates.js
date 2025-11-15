import { ref, computed } from 'vue'
import { getLoaderTypes, getMinecraftVersions, getTemplate } from '@/api/templates'

// 全局状态缓存
const loaderTypesCache = ref(null)
const versionsCache = ref({})
const templateCache = ref({})

export function useTemplates() {
  const loaderTypes = ref([])
  const minecraftVersions = ref([])
  const currentTemplate = ref(null)
  const loading = ref(false)
  const error = ref(null)

  // 选中的加载器和版本
  const selectedLoader = ref(null)
  const selectedVersion = ref(null)

  /**
   * 加载所有加载器类型
   */
  async function loadLoaderTypes() {
    // 使用缓存
    if (loaderTypesCache.value) {
      loaderTypes.value = loaderTypesCache.value
      return
    }

    loading.value = true
    error.value = null

    try {
      const { data, error: err } = await getLoaderTypes()
      if (err) throw err

      loaderTypes.value = data
      loaderTypesCache.value = data
    } catch (err) {
      error.value = '加载加载器类型失败: ' + err.message
      console.error(err)
    } finally {
      loading.value = false
    }
  }

  /**
   * 加载指定加载器的 Minecraft 版本
   * @param {string} loaderTypeId - 加载器类型 ID
   */
  async function loadMinecraftVersions(loaderTypeId) {
    if (!loaderTypeId) return

    // 使用缓存
    const cacheKey = loaderTypeId
    if (versionsCache.value[cacheKey]) {
      minecraftVersions.value = versionsCache.value[cacheKey]
      return
    }

    loading.value = true
    error.value = null

    try {
      // 通过 ID 查找加载器名称
      const loader = loaderTypes.value.find(l => l.id === loaderTypeId)
      if (!loader) throw new Error('找不到指定的加载器')

      const { data, error: err } = await getMinecraftVersions(loader.name)
      if (err) throw err

      minecraftVersions.value = data
      versionsCache.value[cacheKey] = data
    } catch (err) {
      error.value = '加载 Minecraft 版本失败: ' + err.message
      console.error(err)
    } finally {
      loading.value = false
    }
  }

  /**
   * 加载指定模板
   * @param {string} loaderTypeId - 加载器类型 ID
   * @param {string} minecraftVersion - Minecraft 版本
   */
  async function loadTemplate(loaderTypeId, minecraftVersion) {
    if (!loaderTypeId || !minecraftVersion) return

    // 使用缓存
    const cacheKey = `${loaderTypeId}_${minecraftVersion}`
    if (templateCache.value[cacheKey]) {
      currentTemplate.value = templateCache.value[cacheKey]
      return
    }

    loading.value = true
    error.value = null

    try {
      const { data, error: err } = await getTemplate(loaderTypeId, minecraftVersion)
      if (err) throw err

      currentTemplate.value = data
      templateCache.value[cacheKey] = data
    } catch (err) {
      error.value = '加载模板失败: ' + err.message
      console.error(err)
    } finally {
      loading.value = false
    }
  }

  /**
   * 选择加载器
   * @param {Object} loader - 加载器对象
   */
  function selectLoader(loader) {
    selectedLoader.value = loader
    selectedVersion.value = null
    minecraftVersions.value = []
    currentTemplate.value = null
    
    if (loader) {
      loadMinecraftVersions(loader.id)
    }
  }

  /**
   * 选择版本
   * @param {string} version - Minecraft 版本
   */
  function selectVersion(version) {
    selectedVersion.value = version
    
    if (selectedLoader.value && version) {
      loadTemplate(selectedLoader.value.id, version)
    }
  }

  /**
   * 重置所有选择
   */
  function resetSelection() {
    selectedLoader.value = null
    selectedVersion.value = null
    minecraftVersions.value = []
    currentTemplate.value = null
    error.value = null
  }

  // 计算属性
  const hasSelection = computed(() => 
    selectedLoader.value && selectedVersion.value && currentTemplate.value
  )

  const templateVariables = computed(() => 
    currentTemplate.value?.template_data?.variables || {}
  )

  const templateFiles = computed(() => 
    currentTemplate.value?.template_data?.files || []
  )

  return {
    // 状态
    loaderTypes,
    minecraftVersions,
    currentTemplate,
    loading,
    error,
    selectedLoader,
    selectedVersion,

    // 计算属性
    hasSelection,
    templateVariables,
    templateFiles,

    // 方法
    loadLoaderTypes,
    loadMinecraftVersions,
    loadTemplate,
    selectLoader,
    selectVersion,
    resetSelection
  }
}

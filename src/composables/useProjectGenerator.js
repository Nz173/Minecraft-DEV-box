import { ref } from 'vue'
import JSZip from 'jszip'

export function useProjectGenerator() {
  const generating = ref(false)
  const progress = ref(0)
  const currentStep = ref('')
  const error = ref(null)

  /**
   * 替换模板变量
   * @param {string} content - 模板内容
   * @param {Object} variables - 变量键值对
   * @returns {string} 替换后的内容
   */
  function replaceVariables(content, variables) {
    let result = content

    // 替换所有 {{variable_name}} 格式的变量
    Object.entries(variables).forEach(([key, value]) => {
      const regex = new RegExp(`{{${key}}}`, 'g')
      result = result.replace(regex, value)
    })

    return result
  }

  /**
   * 计算派生变量
   * @param {Object} variables - 变量配置
   * @param {Object} values - 用户输入的值
   * @returns {Object} 包含计算值的完整变量对象
   */
  function computeVariables(variables, values) {
    const computed = { ...values }

    Object.entries(variables).forEach(([key, config]) => {
      if (config.type === 'computed' && config.compute) {
        try {
          // 简单的计算实现：package_name.replace('.', '/')
          if (config.compute.includes('replace')) {
            const match = config.compute.match(/(\w+)\.replace\(['"](.)['"]\s*,\s*['"](.)['"]/)
            if (match) {
              const [, sourceVar, searchChar, replaceChar] = match
              if (computed[sourceVar]) {
                computed[key] = computed[sourceVar].replaceAll(searchChar, replaceChar)
              }
            }
          }
        } catch (err) {
          console.warn(`计算变量 ${key} 失败:`, err)
        }
      }
    })

    return computed
  }

  /**
   * 验证变量值
   * @param {Object} variables - 变量配置
   * @param {Object} values - 用户输入的值
   * @returns {Object} {valid: boolean, errors: Object}
   */
  function validateVariables(variables, values) {
    const errors = {}

    Object.entries(variables).forEach(([key, config]) => {
      const value = values[key]

      // 跳过计算变量
      if (config.type === 'computed') return

      // 检查必填
      if (!value || value.trim() === '') {
        errors[key] = `${config.label} 不能为空`
        return
      }

      // 正则验证
      if (config.validation) {
        const regex = new RegExp(config.validation)
        if (!regex.test(value)) {
          errors[key] = `${config.label} 格式不正确`
        }
      }
    })

    return {
      valid: Object.keys(errors).length === 0,
      errors
    }
  }

  /**
   * 生成项目 ZIP 文件
   * @param {Object} template - 模板数据
   * @param {Object} userConfig - 用户配置
   * @returns {Promise<Blob>} ZIP 文件 Blob
   */
  async function generateProject(template, userConfig) {
    generating.value = true
    progress.value = 0
    error.value = null

    try {
      // 步骤 1: 验证配置 (10%)
      currentStep.value = '验证配置...'
      const variables = template.template_data.variables
      const validation = validateVariables(variables, userConfig)
      
      if (!validation.valid) {
        throw new Error('配置验证失败: ' + JSON.stringify(validation.errors))
      }
      progress.value = 10

      // 步骤 2: 计算派生变量 (20%)
      currentStep.value = '准备变量...'
      const computedVars = computeVariables(variables, userConfig)
      progress.value = 20

      // 步骤 3: 创建 ZIP 对象 (30%)
      currentStep.value = '创建项目结构...'
      const zip = new JSZip()
      progress.value = 30

      // 步骤 4: 处理所有文件 (30% - 80%)
      const files = template.template_data.files
      const fileStep = 50 / files.length

      for (let i = 0; i < files.length; i++) {
        const file = files[i]
        currentStep.value = `生成文件: ${file.path}`

        // 替换路径中的变量
        let filePath = replaceVariables(file.path, computedVars)
        
        // 替换内容中的变量
        let fileContent = replaceVariables(file.content, computedVars)

        // 添加到 ZIP
        zip.file(filePath, fileContent)

        progress.value = 30 + ((i + 1) * fileStep)
      }

      // 步骤 5: 生成 ZIP 文件 (80% - 100%)
      currentStep.value = '打包项目文件...'
      progress.value = 80

      const blob = await zip.generateAsync({
        type: 'blob',
        compression: 'DEFLATE',
        compressionOptions: { level: 6 }
      })

      progress.value = 100
      currentStep.value = '完成！'

      return blob
    } catch (err) {
      error.value = err.message
      console.error('生成项目失败:', err)
      throw err
    } finally {
      setTimeout(() => {
        generating.value = false
        if (!error.value) {
          progress.value = 0
          currentStep.value = ''
        }
      }, 1000)
    }
  }

  /**
   * 下载生成的项目
   * @param {Blob} blob - ZIP 文件 Blob
   * @param {string} fileName - 文件名
   */
  function downloadProject(blob, fileName) {
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = fileName
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    URL.revokeObjectURL(url)
  }

  /**
   * 生成默认配置
   * @param {Object} variables - 变量配置
   * @returns {Object} 默认配置对象
   */
  function getDefaultConfig(variables) {
    const config = {}
    
    Object.entries(variables).forEach(([key, varConfig]) => {
      if (varConfig.type !== 'computed' && varConfig.default) {
        config[key] = varConfig.default
      }
    })

    return config
  }

  return {
    // 状态
    generating,
    progress,
    currentStep,
    error,

    // 方法
    generateProject,
    downloadProject,
    validateVariables,
    getDefaultConfig
  }
}

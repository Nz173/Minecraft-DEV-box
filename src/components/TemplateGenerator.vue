<template>
  <div class="template-generator">
    <header class="generator-header">
      <h1>Minecraft DEV box</h1>
      <p class="subtitle">快速生成 Minecraft 模组和插件项目模板</p>
    </header>
    
    <!-- 进度指示器 -->
    <div class="progress-steps">
      <div :class="['step', { active: currentStep >= 1, completed: currentStep > 1 }]">
        <span class="step-number">1</span>
        <span class="step-label">选择加载器</span>
      </div>
      <div class="step-divider"></div>
      <div :class="['step', { active: currentStep >= 2, completed: currentStep > 2 }]">
        <span class="step-number">2</span>
        <span class="step-label">选择版本</span>
      </div>
      <div class="step-divider"></div>
      <div :class="['step', { active: currentStep >= 3, completed: currentStep > 3 }]">
        <span class="step-number">3</span>
        <span class="step-label">配置项目</span>
      </div>
    </div>
    
    <!-- 主内容区 -->
    <main class="generator-content">
      <!-- 步骤 1: 选择加载器 -->
      <section class="generator-section">
        <LoaderSelector
          :loaders="loaderTypes"
          :selected-loader="selectedLoader"
          :loading="loading"
          :error="error"
          @select="handleSelectLoader"
          @reload="loadLoaderTypes"
        />
      </section>
      
      <!-- 步骤 2: 选择版本 -->
      <section v-if="currentStep >= 2" class="generator-section">
        <VersionSelector
          :versions="minecraftVersions"
          :selected-version="selectedVersion"
          :loader-selected="!!selectedLoader"
          :loading="loading"
          :error="error"
          @select="handleSelectVersion"
        />
      </section>
      
      <!-- 步骤 3: 配置项目 -->
      <section v-if="currentStep >= 3" class="generator-section">
        <ProjectConfigForm
          :variables="templateVariables"
          :template-selected="hasSelection"
          @submit="handleGenerate"
          @preview="showPreview = true"
        />
      </section>
    </main>
    
    <!-- 生成进度弹窗 -->
    <div v-if="generating" class="progress-modal">
      <div class="progress-content">
        <h3>正在生成项目...</h3>
        <div class="progress-bar">
          <div class="progress-fill" :style="{ width: progress + '%' }"></div>
        </div>
        <p class="progress-text">{{ currentStepText }} ({{ progress }}%)</p>
      </div>
    </div>
    
    <!-- 模板预览弹窗 -->
    <TemplatePreview
      :show="showPreview"
      :files="templateFiles"
      :variables="templateVariables"
      :user-config="userConfig"
      @close="showPreview = false"
    />
    
    <!-- 成功提示 -->
    <div v-if="showSuccess" class="success-toast">
      <p>✓ 项目生成成功！正在下载...</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import LoaderSelector from './LoaderSelector.vue'
import VersionSelector from './VersionSelector.vue'
import ProjectConfigForm from './ProjectConfigForm.vue'
import TemplatePreview from './TemplatePreview.vue'
import { useTemplates } from '@/composables/useTemplates'
import { useProjectGenerator } from '@/composables/useProjectGenerator'

// 使用 composables
const {
  loaderTypes,
  minecraftVersions,
  currentTemplate,
  loading,
  error,
  selectedLoader,
  selectedVersion,
  hasSelection,
  templateVariables,
  templateFiles,
  loadLoaderTypes,
  selectLoader,
  selectVersion
} = useTemplates()

const {
  generating,
  progress,
  currentStep: currentStepText,
  generateProject,
  downloadProject
} = useProjectGenerator()

// 本地状态
const showPreview = ref(false)
const showSuccess = ref(false)
const userConfig = ref({})

// 当前步骤
const currentStep = computed(() => {
  if (!selectedLoader.value) return 1
  if (!selectedVersion.value) return 2
  return 3
})

// 处理选择加载器
function handleSelectLoader(loader) {
  selectLoader(loader)
}

// 处理选择版本
function handleSelectVersion(version) {
  selectVersion(version)
}

// 处理生成项目
async function handleGenerate(config) {
  userConfig.value = config
  
  try {
    const blob = await generateProject(currentTemplate.value, config)
    
    // 生成文件名
    const fileName = `${config.mod_id || config.mod_name || 'minecraft-project'}-${selectedLoader.value.name}-${selectedVersion.value}.zip`
    
    // 下载文件
    downloadProject(blob, fileName)
    
    // 显示成功提示
    showSuccess.value = true
    setTimeout(() => {
      showSuccess.value = false
    }, 3000)
  } catch (err) {
    console.error('生成项目失败:', err)
  }
}

// 初始化
onMounted(() => {
  loadLoaderTypes()
})
</script>

<style scoped>
.template-generator {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 2rem;
}

.generator-header {
  text-align: center;
  color: white;
  margin-bottom: 3rem;
}

.generator-header h1 {
  font-size: 3rem;
  margin-bottom: 0.5rem;
  font-weight: 700;
}

.subtitle {
  font-size: 1.2rem;
  opacity: 0.9;
}

.progress-steps {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 3rem;
  padding: 2rem;
  background-color: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  backdrop-filter: blur(10px);
}

.step {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  opacity: 0.5;
  transition: opacity 0.3s ease;
}

.step.active {
  opacity: 1;
}

.step.completed .step-number {
  background-color: #27ae60;
}

.step-number {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.3);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 1.2rem;
}

.step.active .step-number {
  background-color: white;
  color: #667eea;
}

.step-label {
  color: white;
  font-size: 0.9rem;
  font-weight: 600;
}

.step-divider {
  width: 60px;
  height: 2px;
  background-color: rgba(255, 255, 255, 0.3);
  margin: 0 1rem;
}

.generator-content {
  max-width: 1200px;
  margin: 0 auto;
}

.generator-section {
  background-color: white;
  border-radius: 12px;
  padding: 2rem;
  margin-bottom: 2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.progress-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.progress-content {
  background-color: white;
  border-radius: 12px;
  padding: 2rem;
  min-width: 400px;
  text-align: center;
}

.progress-content h3 {
  margin-bottom: 1.5rem;
  color: #2c3e50;
}

.progress-bar {
  width: 100%;
  height: 30px;
  background-color: #ecf0f1;
  border-radius: 15px;
  overflow: hidden;
  margin-bottom: 1rem;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
  transition: width 0.3s ease;
}

.progress-text {
  color: #666;
  font-size: 0.9rem;
}

.success-toast {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  background-color: #27ae60;
  color: white;
  padding: 1rem 2rem;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  animation: slideIn 0.3s ease;
  z-index: 3000;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

@media (max-width: 768px) {
  .generator-header h1 {
    font-size: 2rem;
  }
  
  .subtitle {
    font-size: 1rem;
  }
  
  .progress-steps {
    flex-direction: column;
  }
  
  .step-divider {
    width: 2px;
    height: 30px;
    margin: 0.5rem 0;
  }
  
  .progress-content {
    min-width: auto;
    width: 90%;
  }
}
</style>

<template>
  <div class="project-config-form">
    <h2 class="section-title">配置项目信息</h2>
    
    <div v-if="!templateSelected" class="placeholder">
      <p>请先选择加载器和版本</p>
    </div>
    
    <form v-else @submit.prevent="handleSubmit" class="config-form">
      <div
        v-for="(config, key) in editableVariables"
        :key="key"
        class="form-group"
      >
        <label :for="key" class="form-label">
          {{ config.label }}
          <span v-if="config.description" class="label-hint" :title="config.description">?</span>
        </label>
        
        <input
          :id="key"
          v-model="formData[key]"
          :type="config.type === 'number' ? 'number' : 'text'"
          :placeholder="config.default"
          class="form-input"
          :class="{ error: errors[key] }"
          @input="clearError(key)"
        />
        
        <p v-if="errors[key]" class="error-message">{{ errors[key] }}</p>
        <p v-else-if="config.description" class="field-description">
          {{ config.description }}
        </p>
      </div>
      
      <div class="form-actions">
        <button
          type="button"
          @click="fillDefaults"
          class="btn btn-secondary"
        >
          使用默认值
        </button>
        
        <button
          type="button"
          @click="$emit('preview')"
          class="btn btn-secondary"
          :disabled="!isValid"
        >
          预览模板
        </button>
        
        <button
          type="submit"
          class="btn btn-primary"
          :disabled="!isValid"
        >
          生成项目
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  variables: {
    type: Object,
    default: () => ({})
  },
  templateSelected: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['submit', 'preview'])

const formData = ref({})
const errors = ref({})

// 过滤出可编辑的变量（排除计算变量）
const editableVariables = computed(() => {
  const result = {}
  Object.entries(props.variables).forEach(([key, config]) => {
    if (config.type !== 'computed') {
      result[key] = config
    }
  })
  return result
})

// 验证表单
const isValid = computed(() => {
  return Object.keys(errors.value).length === 0 && 
         Object.keys(formData.value).length > 0
})

// 监听 variables 变化，初始化表单数据
watch(
  () => props.variables,
  (newVars) => {
    if (Object.keys(newVars).length > 0) {
      fillDefaults()
    }
  },
  { immediate: true }
)

// 填充默认值
function fillDefaults() {
  formData.value = {}
  Object.entries(editableVariables.value).forEach(([key, config]) => {
    formData.value[key] = config.default || ''
  })
  errors.value = {}
}

// 清除特定字段错误
function clearError(key) {
  delete errors.value[key]
}

// 验证单个字段
function validateField(key, value, config) {
  if (!value || value.trim() === '') {
    return `${config.label} 不能为空`
  }
  
  if (config.validation) {
    const regex = new RegExp(config.validation)
    if (!regex.test(value)) {
      return `${config.label} 格式不正确`
    }
  }
  
  return null
}

// 提交表单
function handleSubmit() {
  errors.value = {}
  
  // 验证所有字段
  Object.entries(editableVariables.value).forEach(([key, config]) => {
    const error = validateField(key, formData.value[key], config)
    if (error) {
      errors.value[key] = error
    }
  })
  
  if (Object.keys(errors.value).length === 0) {
    emit('submit', formData.value)
  }
}
</script>

<style scoped>
.project-config-form {
  width: 100%;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  color: #2c3e50;
}

.placeholder {
  padding: 2rem;
  text-align: center;
  color: #666;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.config-form {
  background-color: white;
  padding: 2rem;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: block;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 0.5rem;
  font-size: 0.95rem;
}

.label-hint {
  display: inline-block;
  width: 18px;
  height: 18px;
  background-color: #3498db;
  color: white;
  border-radius: 50%;
  text-align: center;
  line-height: 18px;
  font-size: 0.8rem;
  margin-left: 0.5rem;
  cursor: help;
}

.form-input {
  width: 100%;
  padding: 0.75rem;
  border: 2px solid #e0e0e0;
  border-radius: 4px;
  font-size: 1rem;
  transition: border-color 0.3s ease;
}

.form-input:focus {
  outline: none;
  border-color: #3498db;
}

.form-input.error {
  border-color: #e74c3c;
}

.error-message {
  color: #e74c3c;
  font-size: 0.85rem;
  margin-top: 0.5rem;
}

.field-description {
  color: #666;
  font-size: 0.85rem;
  margin-top: 0.5rem;
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid #e0e0e0;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-primary {
  background-color: #3498db;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background-color: #2980b9;
}

.btn-secondary {
  background-color: #95a5a6;
  color: white;
}

.btn-secondary:hover:not(:disabled) {
  background-color: #7f8c8d;
}

@media (max-width: 768px) {
  .form-actions {
    flex-direction: column;
  }
  
  .btn {
    width: 100%;
  }
}
</style>

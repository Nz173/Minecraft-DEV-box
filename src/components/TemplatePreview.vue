<template>
  <div v-if="show" class="template-preview-modal" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>模板预览</h2>
        <button @click="$emit('close')" class="close-btn">&times;</button>
      </div>
      
      <div class="modal-body">
        <div class="preview-section">
          <h3>文件结构</h3>
          <div class="file-tree">
            <div
              v-for="file in files"
              :key="file.path"
              :class="['file-item', { active: selectedFile === file.path }]"
              @click="selectFile(file.path)"
            >
              <span class="file-icon">📄</span>
              <span class="file-path">{{ file.path }}</span>
            </div>
          </div>
        </div>
        
        <div v-if="selectedFileContent" class="preview-section">
          <h3>文件内容: {{ selectedFile }}</h3>
          <pre class="file-content">{{ selectedFileContent }}</pre>
        </div>
        
        <div class="preview-section">
          <h3>变量配置</h3>
          <table class="variables-table">
            <thead>
              <tr>
                <th>变量名</th>
                <th>说明</th>
                <th>当前值</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(config, key) in variables" :key="key">
                <td><code>{{ key }}</code></td>
                <td>{{ config.label || config.description }}</td>
                <td><strong>{{ config.value || config.default }}</strong></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      
      <div class="modal-footer">
        <button @click="$emit('close')" class="btn btn-secondary">关闭</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  files: {
    type: Array,
    default: () => []
  },
  variables: {
    type: Object,
    default: () => ({})
  },
  userConfig: {
    type: Object,
    default: () => ({})
  }
})

defineEmits(['close'])

const selectedFile = ref(null)

// 替换变量的简单实现
function replaceVars(content) {
  let result = content
  Object.entries(props.userConfig).forEach(([key, value]) => {
    result = result.replaceAll(`{{${key}}}`, value || `{{${key}}}`)
  })
  return result
}

const selectedFileContent = computed(() => {
  if (!selectedFile.value) return null
  const file = props.files.find(f => f.path === selectedFile.value)
  if (!file) return null
  return replaceVars(file.content)
})

function selectFile(path) {
  selectedFile.value = path
}
</script>

<style scoped>
.template-preview-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 1rem;
}

.modal-content {
  background-color: white;
  border-radius: 8px;
  width: 100%;
  max-width: 1200px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e0e0e0;
}

.modal-header h2 {
  margin: 0;
  font-size: 1.5rem;
  color: #2c3e50;
}

.close-btn {
  background: none;
  border: none;
  font-size: 2rem;
  color: #666;
  cursor: pointer;
  line-height: 1;
  padding: 0;
  width: 32px;
  height: 32px;
}

.close-btn:hover {
  color: #e74c3c;
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
}

.preview-section {
  margin-bottom: 2rem;
}

.preview-section h3 {
  font-size: 1.2rem;
  margin-bottom: 1rem;
  color: #2c3e50;
}

.file-tree {
  background-color: #f8f9fa;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  padding: 1rem;
  max-height: 300px;
  overflow-y: auto;
}

.file-item {
  padding: 0.5rem;
  cursor: pointer;
  border-radius: 4px;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.file-item:hover {
  background-color: #e3f2fd;
}

.file-item.active {
  background-color: #3498db;
  color: white;
}

.file-icon {
  flex-shrink: 0;
}

.file-path {
  font-family: 'Courier New', monospace;
  font-size: 0.9rem;
}

.file-content {
  background-color: #2c3e50;
  color: #ecf0f1;
  padding: 1rem;
  border-radius: 4px;
  overflow-x: auto;
  font-size: 0.9rem;
  line-height: 1.5;
  max-height: 400px;
}

.variables-table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
}

.variables-table th,
.variables-table td {
  padding: 0.75rem;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
}

.variables-table th {
  background-color: #f8f9fa;
  font-weight: 600;
  color: #2c3e50;
}

.variables-table code {
  background-color: #f8f9fa;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
  color: #e74c3c;
}

.modal-footer {
  padding: 1.5rem;
  border-top: 1px solid #e0e0e0;
  display: flex;
  justify-content: flex-end;
}

.btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
}

.btn-secondary {
  background-color: #95a5a6;
  color: white;
}

.btn-secondary:hover {
  background-color: #7f8c8d;
}

@media (max-width: 768px) {
  .modal-content {
    max-height: 95vh;
  }
}
</style>

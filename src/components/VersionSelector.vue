<template>
  <div class="version-selector">
    <h2 class="section-title">选择 Minecraft 版本</h2>
    
    <div v-if="!loaderSelected" class="placeholder">
      <p>请先选择模组加载器</p>
    </div>
    
    <div v-else-if="loading" class="loading">
      <p>加载版本列表中...</p>
    </div>
    
    <div v-else-if="error" class="error">
      <p>{{ error }}</p>
    </div>
    
    <div v-else-if="versions.length === 0" class="empty">
      <p>暂无可用版本</p>
    </div>
    
    <div v-else class="version-list">
      <div
        v-for="version in versions"
        :key="version"
        :class="['version-item', { selected: isSelected(version) }]"
        @click="$emit('select', version)"
      >
        <span class="version-number">{{ version }}</span>
        <span v-if="isRecommended(version)" class="badge-recommended">推荐</span>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  versions: {
    type: Array,
    default: () => []
  },
  selectedVersion: {
    type: String,
    default: null
  },
  loaderSelected: {
    type: Boolean,
    default: false
  },
  loading: {
    type: Boolean,
    default: false
  },
  error: {
    type: String,
    default: null
  }
})

defineEmits(['select'])

const isSelected = (version) => {
  return props.selectedVersion === version
}

const isRecommended = (version) => {
  // 第一个版本（最新）为推荐版本
  return props.versions.indexOf(version) === 0
}
</script>

<style scoped>
.version-selector {
  width: 100%;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  color: #2c3e50;
}

.placeholder,
.loading,
.error,
.empty {
  padding: 2rem;
  text-align: center;
  color: #666;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.error {
  background-color: #fff5f5;
  color: #e74c3c;
}

.version-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
}

.version-item {
  padding: 1rem;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  background-color: white;
  text-align: center;
  position: relative;
}

.version-item:hover {
  border-color: #3498db;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.version-item.selected {
  border-color: #3498db;
  background-color: #e3f2fd;
}

.version-number {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2c3e50;
}

.badge-recommended {
  position: absolute;
  top: -8px;
  right: -8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-size: 0.7rem;
  padding: 0.25rem 0.5rem;
  border-radius: 12px;
  font-weight: 600;
}

@media (max-width: 768px) {
  .version-list {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>

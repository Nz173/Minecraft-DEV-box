<template>
  <div class="loader-selector">
    <h2 class="section-title">选择模组加载器</h2>
    
    <div v-if="loading" class="loading">
      <p>加载中...</p>
    </div>
    
    <div v-else-if="error" class="error">
      <p>{{ error }}</p>
      <button @click="$emit('reload')" class="btn-retry">重试</button>
    </div>
    
    <div v-else class="loader-grid">
      <div
        v-for="loader in loaders"
        :key="loader.id"
        :class="['loader-card', { selected: isSelected(loader) }]"
        @click="$emit('select', loader)"
      >
        <div class="loader-icon">
          <img v-if="loader.icon_url" :src="loader.icon_url" :alt="loader.display_name" />
          <div v-else class="loader-icon-placeholder">
            {{ loader.display_name[0] }}
          </div>
        </div>
        <h3 class="loader-name">{{ loader.display_name }}</h3>
        <p class="loader-description">{{ loader.description }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  loaders: {
    type: Array,
    default: () => []
  },
  selectedLoader: {
    type: Object,
    default: null
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

defineEmits(['select', 'reload'])

const isSelected = (loader) => {
  return props.selectedLoader?.id === loader.id
}
</script>

<style scoped>
.loader-selector {
  width: 100%;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  color: #2c3e50;
}

.loading,
.error {
  padding: 2rem;
  text-align: center;
  color: #666;
}

.error {
  color: #e74c3c;
}

.btn-retry {
  margin-top: 1rem;
  padding: 0.5rem 1.5rem;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.btn-retry:hover {
  background-color: #2980b9;
}

.loader-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1rem;
}

.loader-card {
  padding: 1.5rem;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  background-color: white;
}

.loader-card:hover {
  border-color: #3498db;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.loader-card.selected {
  border-color: #3498db;
  background-color: #e3f2fd;
}

.loader-icon {
  width: 60px;
  height: 60px;
  margin: 0 auto 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.loader-icon img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.loader-icon-placeholder {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 2rem;
  font-weight: bold;
}

.loader-name {
  font-size: 1.2rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: #2c3e50;
  text-align: center;
}

.loader-description {
  font-size: 0.9rem;
  color: #666;
  line-height: 1.4;
  text-align: center;
}

@media (max-width: 768px) {
  .loader-grid {
    grid-template-columns: 1fr;
  }
}
</style>

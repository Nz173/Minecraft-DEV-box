<template>
  <div class="home-page">
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-content">
        <h1 class="hero-title">
          <span class="gradient-text">Minecraft DEV box</span>
        </h1>
        <p class="hero-subtitle">
          为中国 Minecraft 开发者打造的一站式开发工具平台
        </p>
        <p class="hero-description">
          快速生成项目模板，探索开发资源，加入活跃的开发者社区
        </p>
        <div class="hero-actions">
          <router-link to="/generator" class="btn btn-primary">
            <span class="btn-icon">🚀</span>
            生成模板
          </router-link>
          <a href="https://github.com/Nz173/Minecraft-DEV-box" target="_blank" class="btn btn-secondary">
            <span class="btn-icon">⭐</span>
            GitHub
          </a>
        </div>
      </div>
      <div class="hero-illustration">
        <div class="floating-card card-1">
          <div class="card-icon">📦</div>
          <div class="card-label">Fabric</div>
        </div>
        <div class="floating-card card-2">
          <div class="card-icon">🔧</div>
          <div class="card-label">Forge</div>
        </div>
        <div class="floating-card card-3">
          <div class="card-icon">⚡</div>
          <div class="card-label">NeoForge</div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="features">
      <h2 class="section-title">核心功能</h2>
      <div class="features-grid">
        <div class="feature-card">
          <div class="feature-icon">🎯</div>
          <h3>项目模板生成器</h3>
          <p>支持所有主流模组加载器，三步快速生成规范的项目结构</p>
          <router-link to="/generator" class="feature-link">开始使用 →</router-link>
        </div>
        
        <div class="feature-card">
          <div class="feature-icon">📚</div>
          <h3>开发文档</h3>
          <p>完整的中文开发文档，从入门到进阶，助你快速上手</p>
          <a href="#docs" class="feature-link">查看文档 →</a>
        </div>
        
        <div class="feature-card">
          <div class="feature-icon">💬</div>
          <h3>社区支持</h3>
          <p>活跃的开发者社区，随时获得帮助和分享经验</p>
          <a href="#community" class="feature-link">加入社区 →</a>
        </div>
        
        <div class="feature-card">
          <div class="feature-icon">🔄</div>
          <h3>持续更新</h3>
          <p>跟随 Minecraft 版本更新，模板实时同步最新特性</p>
          <a href="#updates" class="feature-link">更新日志 →</a>
        </div>
      </div>
    </section>

    <!-- Supported Loaders -->
    <section class="loaders">
      <h2 class="section-title">支持的加载器</h2>
      <p class="section-subtitle">覆盖所有主流 Minecraft 模组和插件开发平台</p>
      <div class="loaders-grid">
        <div class="loader-badge">
          <span class="loader-icon">📦</span>
          <span class="loader-name">Fabric</span>
        </div>
        <div class="loader-badge">
          <span class="loader-icon">🔧</span>
          <span class="loader-name">Forge</span>
        </div>
        <div class="loader-badge">
          <span class="loader-icon">⚡</span>
          <span class="loader-name">NeoForge</span>
        </div>
        <div class="loader-badge">
          <span class="loader-icon">🧱</span>
          <span class="loader-name">Bukkit</span>
        </div>
        <div class="loader-badge">
          <span class="loader-icon">💨</span>
          <span class="loader-name">Spigot</span>
        </div>
        <div class="loader-badge">
          <span class="loader-icon">📄</span>
          <span class="loader-name">Paper</span>
        </div>
      </div>
    </section>

    <!-- Stats Section -->
    <section class="stats">
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-number">6+</div>
          <div class="stat-label">支持的加载器</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">100%</div>
          <div class="stat-label">开源免费</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">24/7</div>
          <div class="stat-label">在线可用</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">∞</div>
          <div class="stat-label">生成次数</div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="cta">
      <h2>准备开始你的 Minecraft 模组之旅了吗？</h2>
      <p>立即使用模板生成器，快速启动你的项目</p>
      <router-link to="/generator" class="btn btn-large btn-primary">
        开始生成项目
      </router-link>
    </section>
  </div>
</template>

<script setup>
</script>

<style scoped>
.home-page {
  min-height: 100vh;
}

/* Hero Section */
.hero {
  position: relative;
  min-height: 90vh;
  background: linear-gradient(135deg, #1db954 0%, #1ed760 50%, #1db954 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  overflow: hidden;
}

.hero-content {
  max-width: 800px;
  text-align: center;
  z-index: 10;
  animation: fadeInUp 0.8s ease;
}

.hero-title {
  font-size: 4rem;
  font-weight: 800;
  margin-bottom: 1.5rem;
  color: white;
  line-height: 1.2;
}

.gradient-text {
  background: linear-gradient(45deg, #fff, #f0f0f0);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-subtitle {
  font-size: 1.8rem;
  color: rgba(255, 255, 255, 0.95);
  margin-bottom: 1rem;
  font-weight: 600;
}

.hero-description {
  font-size: 1.2rem;
  color: rgba(255, 255, 255, 0.85);
  margin-bottom: 3rem;
  line-height: 1.6;
}

.hero-actions {
  display: flex;
  gap: 1.5rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 2.5rem;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  cursor: pointer;
}

.btn-icon {
  font-size: 1.3rem;
}

.btn-primary {
  background-color: white;
  color: #1db954;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 30px rgba(0, 0, 0, 0.2);
}

.btn-secondary {
  background-color: rgba(255, 255, 255, 0.2);
  color: white;
  backdrop-filter: blur(10px);
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.btn-secondary:hover {
  background-color: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

.hero-illustration {
  position: absolute;
  right: 10%;
  top: 50%;
  transform: translateY(-50%);
  display: none;
}

@media (min-width: 1200px) {
  .hero-illustration {
    display: block;
  }
}

.floating-card {
  position: absolute;
  background: white;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  animation: float 3s ease-in-out infinite;
}

.card-1 {
  top: -100px;
  right: 0;
  animation-delay: 0s;
}

.card-2 {
  top: 50px;
  right: -100px;
  animation-delay: 0.5s;
}

.card-3 {
  top: 200px;
  right: 50px;
  animation-delay: 1s;
}

.card-icon {
  font-size: 3rem;
  margin-bottom: 0.5rem;
}

.card-label {
  font-weight: 600;
  color: #1db954;
  font-size: 1.2rem;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Features Section */
.features {
  padding: 6rem 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
  color: #2c3e50;
}

.section-subtitle {
  text-align: center;
  font-size: 1.2rem;
  color: #666;
  margin-bottom: 3rem;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  margin-top: 3rem;
}

.feature-card {
  background: white;
  border-radius: 16px;
  padding: 2.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(29, 185, 84, 0.15);
}

.feature-icon {
  font-size: 3.5rem;
  margin-bottom: 1.5rem;
}

.feature-card h3 {
  font-size: 1.5rem;
  margin-bottom: 1rem;
  color: #2c3e50;
}

.feature-card p {
  color: #666;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.feature-link {
  color: #1db954;
  font-weight: 600;
  text-decoration: none;
  transition: gap 0.3s ease;
  display: inline-flex;
  align-items: center;
}

.feature-link:hover {
  gap: 8px;
}

/* Loaders Section */
.loaders {
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  padding: 6rem 2rem;
}

.loaders-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 1.5rem;
  margin-top: 3rem;
  max-width: 1000px;
  margin-left: auto;
  margin-right: auto;
}

.loader-badge {
  background: white;
  padding: 1.5rem 2.5rem;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 1rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.loader-badge:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(29, 185, 84, 0.15);
}

.loader-icon {
  font-size: 2rem;
}

.loader-name {
  font-size: 1.2rem;
  font-weight: 600;
  color: #2c3e50;
}

/* Stats Section */
.stats {
  padding: 6rem 2rem;
  background: white;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 3rem;
  max-width: 1000px;
  margin: 0 auto;
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 3.5rem;
  font-weight: 800;
  color: #1db954;
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 1.1rem;
  color: #666;
  font-weight: 500;
}

/* CTA Section */
.cta {
  background: linear-gradient(135deg, #1db954 0%, #1ed760 100%);
  padding: 6rem 2rem;
  text-align: center;
  color: white;
}

.cta h2 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  font-weight: 700;
}

.cta p {
  font-size: 1.3rem;
  margin-bottom: 2.5rem;
  opacity: 0.95;
}

.btn-large {
  padding: 1.2rem 3rem;
  font-size: 1.2rem;
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 2.5rem;
  }
  
  .hero-subtitle {
    font-size: 1.3rem;
  }
  
  .hero-description {
    font-size: 1rem;
  }
  
  .section-title {
    font-size: 2rem;
  }
  
  .cta h2 {
    font-size: 1.8rem;
  }
}
</style>

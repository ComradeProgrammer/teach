<template>
  <div class="navbar clearFloat">
    <el-menu
      :default-active="activeIndex"
      mode="horizontal"
      @select="handleSelect">
      <el-menu-item index="1">
        请登陆
      </el-menu-item>

      <el-menu-item index="2">
        GitLab
        <i class="el-icon-link"></i>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        activeIndex: '1',
        gitlabHost: ''
      }
    },
    mounted() {
      this.gitlabHost = document.getElementById('navbar').dataset.gitlabhost;
    },
    methods: {
      handleSelect(key) {
        if (key === '1') {
          // do nothing
        }
        else if (key === '2') {
          window.location.href = this.gitlabHost;
        }
      }
    }
  }
</script>

<style scoped>

</style>
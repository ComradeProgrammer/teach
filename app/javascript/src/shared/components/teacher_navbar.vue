<template>
  <div class="navbar clearFloat">
    <el-menu
      :default-active="activeIndex"
      mode="horizontal"
      @select="handleSelect">
      <el-menu-item index="1">
        班级
      </el-menu-item>
      
      <el-submenu index="3">
        <template slot="title">广播</template>
        <el-menu-item index="3-1">
          发送广播
        </el-menu-item>
        <el-menu-item index="3-2">
          收到的广播
        </el-menu-item>
      </el-submenu>

      <el-menu-item index="2">
        GitLab
        <i class="el-icon-link"></i>
      </el-menu-item>


      <el-menu-item index="4" style="float: right">
        注销平台
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
          window.location.href = '/classrooms';
        }
        else if (key === '2') {
          window.location.href = this.gitlabHost;
        }
        else if (key.startsWith('3-')) {
          if (key === '3-1') {
            window.location.href = '/broadcasts/new';
          } else if (key === '3-2') {
            window.location.href = '/broadcasts';
          }
        } else if (key === '4') {
          window.location.href = '/logout'
        }
      }
    }
  }
</script>
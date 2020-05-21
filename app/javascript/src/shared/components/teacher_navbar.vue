<template>
  <div class="navbar clearFloat">
    <el-menu
      :default-active="activeIndex"
      mode="horizontal"
      @select="handleSelect">
      <el-menu-item index="1">
        班级
      </el-menu-item>

      <el-submenu index="6">
        <template slot="title">班级管理</template>
        <el-menu-item index="6-1">
          批量添加学生账户
        </el-menu-item>
        <el-submenu index="6-4">
          <template slot="title">教学进度管理</template>
          <el-menu-item v-for="classroomId in classroomIdList" :index="'6-4-' + classroomId">
            {{classroomNameList[classroomIdList.indexOf(classroomId)]}}
          </el-menu-item>
        </el-submenu>
        <el-menu-item index="6-2">
          学生学习情况监视
        </el-menu-item>
        <el-menu-item index="6-3">
          学生成绩管理
        </el-menu-item>
      </el-submenu>

      <el-submenu index="7">
        <template slot="title">系统管理</template>
        <el-menu-item index="7-1">
          评测节点管理
        </el-menu-item>
        <el-menu-item index="7-2">
          系统运行状态监视
        </el-menu-item>
        <el-menu-item index="7-3">
          系统设置
        </el-menu-item>
      </el-submenu>

      <el-submenu index="5" v-if="admin === 'admin'">
        <template slot="title">组织</template>
        <el-menu-item index="5-1">
          新建组织
        </el-menu-item>
        <el-menu-item index="5-2">
          管理组织
        </el-menu-item>
      </el-submenu>

      <el-submenu index="3">
        <template slot="title">广播</template>
        <el-menu-item index="3-1">
          发送广播
        </el-menu-item>
        <el-menu-item index="3-2">
          收到的广播
          <el-badge v-if="broadcast_num > 0" class="mark" :value=broadcast_num />
        </el-menu-item>
      </el-submenu>

      <el-submenu index="8">
         <template slot="title">博客</template>
          <el-menu-item v-for="classroomId in classroomIdList" :index="'8-' + classroomId">
             {{classroomNameList[classroomIdList.indexOf(classroomId)]}}
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
    props: ['admin', 'broadcast_num'],
    data() {
      return {
        activeIndex: '1',
        gitlabHost: '',
        classroomIdList: [],
        classroomNameList: []
      }
    },
    mounted() {
      this.gitlabHost = document.getElementById('navbar').dataset.gitlabhost;
      // console.log(document.getElementById('navbar').dataset);
      // console.log(document.getElementById('navbar').dataset.classroomid);
      // console.log(document.getElementById('navbar').dataset.classroomname);
      this.classroomIdList = JSON.parse(
        document.getElementById('navbar').dataset.classroomid);
      this.classroomNameList = JSON.parse(
        document.getElementById('navbar').dataset.classroomname);
    },
    methods: {
      handleSelect(key) {
        if (key === '1') {
          window.location.href = '/classrooms';
        } else if (key === '2') {
          window.location.href = this.gitlabHost;
        } else if (key.startsWith('3-')) {
          if (key === '3-1') {
            window.location.href = '/broadcasts/new';
          } else if (key === '3-2') {
            window.location.href = '/broadcasts';
          }
        } else if (key === '4') {
          window.location.href = '/logout';
        } else if (key.startsWith('5-')) {
          if (key === '5-1') {
            window.location.assign('/organizations/new');
          } else if (key === '5-2') {
            window.location.assign('/organizations');
          }
        } else if (key.startsWith('6-')) {
          if (key === '6-1') {
            window.location.assign('/members/new');
          } else if (key.startsWith('6-4-')) {
            let classroomIdTmp = key.split("6-4-")[1];
            window.location.assign(`/classrooms/${classroomIdTmp}/teaching_progress_index`);
          }
        } else if (key.startsWith('7-')) {
          if (key === '7-1') {
            window.location.assign('/runners');
          }
        } else if (key.startsWith('8-')){
          let classroomIdTmp = key.split("8-")[1];
          window.location.assign(`/classrooms/${classroomIdTmp}/blogs`);
        }
      }
    }
  }
</script>

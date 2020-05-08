<template>
  <el-tabs type="border-card">
    <el-tab-pane label="学生登陆">
      <ul class="ul-content">
        <li>平台使用GitLab账号进行登陆</li>
        <li>
          如果您还没有注册GitLab账号，点击下方的学生按钮，
          我们会引导您进入GitLab页面注册，注册后自动登陆平台
        </li>
        <li>
          学生注册不需要额外的审核
        </li>
      </ul>
      <br/>
      <br/>
      <a :href="student_href">
        <el-button>
          学生登陆
        </el-button>
      </a>
    </el-tab-pane>
    <el-tab-pane label="教师登陆">
      <a :href="teacher_href">
        <el-button>
          教师登陆
        </el-button>
      </a>
    </el-tab-pane>
    <el-tab-pane label="管理员登陆">
      <div class="ul-content">
        <ul>
          <li>
            管理员登陆使用二次验证
          </li>
          <li>
            要继续，请先输入管理员一级密码
          </li>
        </ul>
        <el-input v-model="admin_password" placeholder="请输入管理员一级密码" show-password></el-input>
      </div>
      <br/>
      <br/>
      <a :href="admin_href" :disabled="admin_disabled">
        <el-button :disabled="admin_disabled">
          管理员登陆
        </el-button>
      </a>
    </el-tab-pane>
  </el-tabs>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';

  Vue.use(ElementUI);

  export default {
    props: ['student_href', 'teacher_href', 'admin_href'],
    data() {
      return {
        admin_password: '',
        admin_disabled: true,
      }
    },
    watch: {
      admin_password: function (val, oldVal) {
        this.admin_disabled = val !== 'agiles4ever';
      }
    }
  }
</script>

<style scoped>
  .ul-content {
    text-align: left;
  }
</style>
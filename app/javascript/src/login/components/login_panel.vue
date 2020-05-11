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
      <div class="ul-content">
        <ul>
          <li>
            教师登陆需要首先通过组织验证
          </li>
          <li>
            如果您不知道您的组织信息，请咨询您所在的备课组的负责人
          </li>
          <li>
            如果您需要创建新的组织，请将您的组织名（2～20字之间）、组织描述（可选）
            以及组织证明（即证明这是一个真实存在的组织的资料，比如有课程组老师签字或是加盖了学院公章的证明书）
            发送至平台管理员邮箱：jim_9827@icloud.com，我们会及时提供您组织编号以及口令
          </li>
          <li>
            要继续，请输入组织编号和口令
          </li>
        </ul>
        <div>
          组织编号
          <el-input v-model="teacher_code" placeholder="请输入组织编号"></el-input>
        </div>
        <div>您的组织是：{{ teacher_msg }}</div>
        <br />
        <div>
          组织口令
          <el-input v-model="teacher_token" placeholder="请输入组织口令" show-password></el-input>
        </div>
      </div>
      <br/>
      <br/>
      <div v-if="teacher_disabled">
        <el-button :disabled="teacher_disabled">
          教师登陆
        </el-button>
      </div>
      <div v-else>
        <a :href="teacher_href" :disabled="teacher_disabled">
          <el-button :disabled="teacher_disabled">
            教师登陆
          </el-button>
        </a>
      </div>
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
        <div>
          管理员密码
          <el-input v-model="admin_password" placeholder="请输入管理员一级密码" show-password></el-input>
        </div>
      </div>
      <br/>
      <br/>
      <div v-if="admin_disabled">
        <el-button :disabled="admin_disabled">
          管理员登陆
        </el-button>
      </div>
      <div v-else>
        <a :href="admin_href">
          <el-button :disabled="admin_disabled">
            管理员登陆
          </el-button>
        </a>
      </div>

    </el-tab-pane>
  </el-tabs>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import axios from 'axios/index';

  Vue.use(ElementUI);

  export default {
    props: ['student_href', 'teacher_href', 'admin_href'],
    data() {
      return {
        teacher_code: '',
        teacher_token: '',
        teacher_msg: '',
        teacher_disabled: true,
        admin_password: '',
        admin_disabled: true,
        all_org_info: []
      }
    },
    mounted() {
      this.teacher_msg = '等待您输入组织编号';
      this.getAllOrgInfo().then((result) => {
        let resultData = result.data;
        for (let i = 0; i < resultData.length; ++i) {
          // console.log(`${userData[i].name}(${userData[i].role}, GitLab ID: ${userData[i].gitlab_id})`);
          console.log(resultData)
          this.all_org_info.push({
            name: resultData[i].name,
            code: resultData[i].code,
            token: resultData[i].token
          });
        }
      });
      console.log(this.all_org_info);
    },
    watch: {
      admin_password: function (val, oldVal) {
        this.admin_disabled = val !== 'agiles4ever';
      },
      teacher_code: function (val, oldVal) {
        let valid_code = false;
        for (let i = 0; i < this.all_org_info.length; ++i) {
          if (val === this.all_org_info[i].code) {
            valid_code = true;
            this.teacher_msg = this.all_org_info[i].name;
          }
        }
        if (valid_code === false) {
          this.teacher_msg = '未找到相关组织'
        }
        this.teacher_token = '';
        this.teacher_disabled = true;
      },
      teacher_token: function (val, oldVal) {
        let valid_token = false;
        for (let i = 0; i < this.all_org_info.length; ++i) {
          if (this.all_org_info[i].code === this.teacher_code &&
            this.all_org_info[i].token === val) {
            valid_token = true;
            this.teacher_disabled = false;
          }
        }
        if (valid_token === false) {
          this.teacher_disabled = true;
        }
      }
    },
    methods: {
      getAllOrgInfo: function () {
        return axios.get('/organizations/get_all_info');
      }
    }
  }
</script>

<style scoped>
  .ul-content {
    text-align: left;
  }
</style>
<template>
  <el-form :model="teamForm" :rules="rules" ref="teamForm" :action="action" method="post">
    <csrf></csrf>
    <p>请输入团队的名字和学生的username(学号)，按每组一行进行输入，不同组员用空格' '隔开</p>
    <p>格式：[team_name]: [username] [username] ... 例如：</p>
    <p>    team1: 17370001 17370002 17370003</p>
    <p>    team2: 17370004 17370012 17374003</p>
    <el-input
      type="textarea"
      :rows="10"
      placeholder="请输入内容"
      v-model="teamForm.text" name='teamForm[text]'>
    </el-input>
    <el-form-item>
      <el-button type="primary" @click="submitForm('teamForm')">创建仓库</el-button>
    </el-form-item>
  </el-form>
</template>

<script>

  import Vue from 'vue/dist/vue.esm'
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import csrf from '../../shared/components/csrf.vue';

  Vue.use(ElementUI);

  export default {
    props: ['action'],
    data() {
      return {
        teamForm: {
          text: ''
        },
        rules: {
          text: [
            {required: true, message: '请输入学号', trigger: 'blur'}
          ]
        }
      }
    },
    components: {
      csrf,
    },
    methods: {
      submitForm: function (formName) {
        this.$refs[formName].validate((valid) => {
          if (valid) {
            //alert('submit!');
            this.$refs[formName].$el.submit();
          } else {
            console.log('error submit!!');
            return false;
          }
        })
      }
    }
  }
</script>

<style scoped>

</style>

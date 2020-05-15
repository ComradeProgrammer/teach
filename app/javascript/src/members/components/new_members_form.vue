<template>
  <el-form :model="memberForm" :rules="rules" ref="memberForm" :action="action" method="post">
    <csrf></csrf>
    <li v-for="error in errors">
      {{ error }}
    </li>
    <p>请按照"姓名,学号,密码,邮箱"的顺序输入信息，信息之间以逗号分隔，每个学生的信息占一行</p>
    <el-form-item label="学生信息" prop="description">
      <el-input v-model="memberForm.description" :rows="10" name='member[description]' type="textarea"></el-input>
    </el-form-item>
    <el-form-item>
      <el-button @click="resetForm('memberForm')">重置</el-button>
      <el-button type="primary" @click="submitForm('memberForm')">创建用户</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
  import Vue from 'vue/dist/vue.esm'
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import csrf from '../../shared/components/csrf.vue';
  import axios from 'axios/index';

  Vue.use(ElementUI);

  export default {
    props: ['action', 'errors'],
    data() {
      let regDes = /.*,[0-9]{8},.*,([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}(\s.*,[0-9]{8},.*,([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3})*(\s)?$/i;
      let description = (rule, value, callback) => {
        if (!value) {
          callback(new Error('学生信息不能为空'));
        } else if (!regDes.test(value)) {
          callback(new Error('学生信息格式不正确'));
        } else {
          callback();
        }
      };
      return {
        memberForm: {
          description: ''
        },
        rules: {
          description: [
            {validator: description, trigger: 'blur'}
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
      },
      resetForm: function (formName) {
        this.$refs[formName].resetFields();
      }
    }
  }
</script>

<style scoped>

</style>

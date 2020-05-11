<template>
  <el-form :model="memberForm" :rules="rules" ref="memberForm" :action="action" method="post">
    <csrf></csrf>
    <el-form-item label="学生信息" prop="description">
          <li>
            请按照’姓名,学号,密码,邮箱‘的顺序输入信息，信息之间以逗号分隔，每个学生的信息占一行
          </li>
          <el-input v-model="memberForm.description" name='member[description]' type="textarea"></el-input>
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
    props: ['action'],
    data() {
      return {
        memberForm: {
          description: ''
        },
        rules: {
          description: [
                      {required: true, message: '请输入学生信息', trigger: 'blur'},
                      {min: 8, message: '学生信息不能为空', trigger: 'blur'}
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

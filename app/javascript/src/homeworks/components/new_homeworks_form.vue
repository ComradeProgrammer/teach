<template>
  <el-form :model="homeworkForm" :rules="rules" ref="homeworkForm" :action="action" method="post">
    <csrf></csrf>
    <el-form-item label="博客作业名称" prop="name">
      <el-input v-model="homeworkForm.name" name='homework[name]'></el-input>
    </el-form-item>

    <el-form-item label="作业描述" prop="description">
      <el-input v-model="homeworkForm.description" name='homework[description]' type="textarea"></el-input>
    </el-form-item>
    <el-form-item>
      <el-button @click="resetForm('homeworkForm')">重置</el-button>
      <el-button type="primary" @click="submitForm('homeworkForm')">创建博客作业</el-button>
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
        homeworkForm: {
          name: '',
          description: ''
        },
        rules: {
          name: [
            {required: true, message: '请输入博客作业名称', trigger: 'blur'},
            {min: 2, max: 20, message: '必须为2到20字符', trigger: 'blur'}
          ],
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
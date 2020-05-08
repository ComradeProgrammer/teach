<template>
  <el-form :model="orgForm" :rules="rules" ref="orgForm" :action="action" method="post">
    <csrf></csrf>
    <el-form-item label="组织名称" prop="name">
      <el-input v-model="orgForm.name" name='org[name]'></el-input>
    </el-form-item>
    <el-form-item label="组织代号" prop="code">
      <el-input v-model="orgForm.code" name='org[code]'></el-input>
    </el-form-item>
    <el-form-item label="组织令牌" prop="token">
      <el-input v-model="orgForm.token" name='org[token]'></el-input>
    </el-form-item>
    <el-form-item label="组织描述" prop="description">
      <el-input v-model="orgForm.description" name='org[description]' type="textarea"></el-input>
    </el-form-item>
    <el-form-item>
      <el-button @click="resetForm('orgForm')">重置</el-button>
      <el-button type="primary" @click="submitForm('orgForm')">创建组织</el-button>
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
        orgForm: {
          name: '',
          code: '',
          token: '',
          description: ''
        },
        rules: {
          name: [
            {required: true, message: '请输入组织名称', trigger: 'blur'},
            {min: 2, max: 20, message: '组织名称长度必须为2到20字符', trigger: 'blur'}
          ],
          code: [
            {required: true, message: '请输入组织代号', trigger: 'blur'},
            {min: 5, max: 5, message: '组织代号必须5个字符', trigger: 'blur'}
          ],
          token: [
            {required: true, message: '请输入组织令牌', trigger: 'blur'},
            {min: 6, max: 16, message: '组织令牌必须为6到16个字符', trigger: 'blur'}
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
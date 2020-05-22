<template>
  <el-form :model="scoreForm" :rules="rules" ref="scoreForm" :action="action" method="post">
    <csrf></csrf>
    <p>评分需为整数</p>
    <el-form-item label="评分项一" prop="score1">
      <el-input v-model="scoreForm.score1"  name='score[score1]'></el-input>
    </el-form-item>
    <el-form-item label="评分项二" prop="score2">
          <el-input v-model="scoreForm.score2"  name='score[score2]'></el-input>
        </el-form-item>
    <el-form-item>
      <el-button @click="resetForm('memberForm')">重置</el-button>
      <el-button type="primary" @click="submitForm('scoreForm')">提交评分</el-button>
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
        scoreForm: {
          score1: '',
          score2: ''
        },
        rules: {
          score1: [
            {required: true, message: '请输入score1的评分', trigger: 'blur'},
                        {min: 1, max: 2, message: '评分为1-99', trigger: 'blur'}
          ],
          score2: [
                      {required: true, message: '请输入score2的评分', trigger: 'blur'},
                                  {min: 1, max: 2, message: '评分为1-99', trigger: 'blur'}
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

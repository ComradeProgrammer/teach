<template>
  <div>
    <el-button type="text" @click="dialogVisible = true">创建教学时间节点</el-button>

    <el-dialog
      title="创建教学时间节点"
      :visible.sync="dialogVisible"
      width="60%">
      <el-form :model="stepForm" :rules="rules" ref="stepForm" method="post" :action="createstephref">
        <el-form-item label="教学阶段ID">
          <el-input v-model="stepForm.task_period_id" readonly name="step[task_period_id]">
          </el-input>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="stepForm.title" placeholder="请输入标题" name="step[title]"></el-input>
        </el-form-item>

        <el-form-item label="时间点" prop="step">
          <el-date-picker
            v-model="stepForm.period"
            type="datetime"
            placeholder="选择日期时间"
            :picker-options="pickerOptions"
            name="step[step]">
          </el-date-picker>
        </el-form-item>

        <el-form-item label="描述" prop="description">
          <el-input v-model="stepForm.description" name="step[description]" type="textarea"></el-input>
        </el-form-item>

        <el-form-item>
          <el-button @click="resetForm('stepForm')">重置</el-button>
          <el-button type="primary" @click="submitForm('stepForm')">创建</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';

  Vue.use(ElementUI);

  export default {
    props: ['taskperiodid', 'createstephref'],
    data() {
      return {
        pickerOptions: {
          shortcuts: [{
            text: '最近一周',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近一个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近三个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit('pick', [start, end]);
            }
          }]
        },
        dialogVisible: false,
        stepForm: {
          task_period_id: '',
          step: '',
          title: '',
          description: '',
        },
        rules: {
          step: [
            {required: true, message: '请选择时间节点', trigger: 'blur'}
          ],
          title: [
            {required: true, message: '请输入标题', trigger: 'blur'},
            {min: 1, max: 10, message: '标题长度在1到10个字符', trigger: 'blur'}
          ],
          description: [
            {max: 10, message: '描述长度不得超过50个字符', trigger: 'blur'}
          ],
        }
      }
    },
    mounted() {
      this.stepForm.task_period_id = this.taskperiodid;
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
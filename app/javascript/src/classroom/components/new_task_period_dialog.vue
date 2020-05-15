<template>
  <div>
    <el-button type="text" @click="dialogVisible = true">创建教学阶段</el-button>

    <el-dialog
      title="创建教学阶段"
      :visible.sync="dialogVisible"
      width="60%">
      <el-form :model="periodForm" :rules="rules" ref="periodForm" method="post" :action="createperiodhref">
        <el-form-item label="班级ID">
          <el-input v-model="periodForm.classroom_id" readonly name="period[classroom_id]">
          </el-input>
        </el-form-item>
        <el-form-item label="标题" prop="title">
          <el-input v-model="periodForm.title" placeholder="请输入标题" name="period[title]"></el-input>
        </el-form-item>

        <el-form-item label="时间段" prop="period">
          <el-date-picker
            v-model="periodForm.period"
            type="datetimerange"
            :picker-options="pickerOptions"
            range-separator="至"
            value-format="yyyy-MM-dd HH:mm:ss"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            name="ft">
          </el-date-picker>
        </el-form-item>

        <el-form-item label="描述" prop="description">
          <el-input v-model="periodForm.description" name="period[description]" type="textarea"></el-input>
        </el-form-item>

        <el-form-item>
          <el-button @click="resetForm('periodForm')">重置</el-button>
          <el-button type="primary" @click="submitForm('periodForm')">创建</el-button>
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
    props: ['classroomid', 'createperiodhref'],
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
        periodForm: {
          classroom_id: '',
          period: '',
          title: '',
          description: '',
        },
        rules: {
          period: [
            {required: true, message: '请选择时间段', trigger: 'blur'}
          ],
          title: [
            {required: true, message: '请输入标题', trigger: 'blur'},
            {min: 1, max: 10, message: '标题长度在1到10个字符', trigger: 'blur'}
          ],
          description: [
            {max: 50, message: '描述长度不得超过50个字符', trigger: 'blur'}
          ],
        }
      }
    },
    mounted() {
      this.periodForm.classroom_id = this.classroomid;
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
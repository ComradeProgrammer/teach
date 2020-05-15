<template>
  <div>
    <div v-if="role === 'teacher' || role === 'admin'">
      <new_task_step_dialog>
      </new_task_step_dialog>
      <new_task_period_dialog>
      </new_task_period_dialog>
    </div>
    <div v-if="taskInfoParsed.length > 0">
      <el-collapse v-model="activeNames">
        <el-collapse-item v-for="item in taskInfoParsed" :title="item.title" :name="item.id">
          <p>{{item.description}}</p>
          <el-steps :active="1" finish-status="success">
            <el-step
              v-for="subItem in item.tasksteps"
              :title="subItem.title"
              :description="subItem.description">
            </el-step>
          </el-steps>
        </el-collapse-item>
      </el-collapse>
    </div>
    <div v-else>
      <div v-if="role === 'teacher' || role === 'admin'">
        <el-card>
          <p>当前还没有任何教学任务，您可以首先创建教学任务区间，然后在对应的教学任务区间下创建教学任务时间点</p>
        </el-card>
      </div>
      <div v-else>
        <el-card>
          <p>当前还没有任何教学任务，请等待您所在班级的老师创建教学任务</p>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import new_task_period_dialog from "./new_task_period_dialog";
  import new_task_step_dialog from "./new_task_step_dialog";

  Vue.use(ElementUI);

  export default {
    props: ['taskinfo', 'role'],
    data() {
      return {
        taskInfoParsed: [],
        activeNames: [],
      }
    },
    components: {
      new_task_period_dialog,
      new_task_step_dialog,
    },
    mounted() {
      this.taskInfoParsed = JSON.parse(this.taskinfo);
    }
  }
</script>

<style scoped>

</style>
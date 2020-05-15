<template>
  <div>
    <div v-if="role === 'teacher' || role === 'admin'">
      <new_task_period_dialog
        :classroomid="classroomid"
        :createperiodhref="`/classrooms/${classroomid}/create_task_period`">
      </new_task_period_dialog>
      <br>
    </div>
    <div v-if="taskInfoParsed.length > 0">
      <el-collapse v-model="activeNames">
        <el-collapse-item v-for="item in taskInfoParsed" :title="item.title" :name="item.id">
          <p>{{item.description}}</p>
          <el-steps :active="stepActivateIndex[taskInfoParsed.indexOf(item)]" finish-status="success">
            <el-step
              v-for="subItem in item.tasksteps"
              :title="subItem.title"
              :description="subItem.description">
            </el-step>
          </el-steps>
          <new_task_step_dialog
            :taskperiodid="item.id"
            :createstephref="`/classrooms/${classroomid}/create_task_step`">
          </new_task_step_dialog>
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
    props: [
      'taskinfo',
      'role',
      'classroomid'
    ],
    data() {
      return {
        taskInfoParsed: [],
        activeNames: [],
        stepActivateIndex: []
      }
    },
    components: {
      new_task_period_dialog,
      new_task_step_dialog,
    },
    mounted() {
      this.taskInfoParsed = JSON.parse(this.taskinfo);
      for (let i = 0; i < this.taskInfoParsed.length; ++i) {
        if (this.taskInfoParsed[i]["selected"] === "true") {
          this.activeNames.push(this.taskInfoParsed[i]["id"])
        }
        if (this.taskInfoParsed[i]["sub_use_minus_one"] === true) {
          this.stepActivateIndex.push(-1);
        } else if (this.taskInfoParsed[i]["sub_use_max_plus_one"] === true) {
          this.stepActivateIndex.push(this.taskInfoParsed[i]["tasksteps"].length);
        } else {
          for (let j = 0; j < this.taskInfoParsed[i]["tasksteps"].length; ++j) {
            if (this.taskInfoParsed[i]["tasksteps"][j]["selected"] === "true") {
              this.stepActivateIndex.push(j);
            }
          }
        }
      }
    }
  }
</script>

<style scoped>

</style>
<template>
  <div class="navbar clearFloat">
    <el-menu
      :default-active="kanban"
      mode="horizontal"
      @select="handleSelect">
      <el-submenu index="1">
        <template slot="title">项目看板</template>
        <el-menu-item v-for="(project, index) in projects" :key="index" :index="'1-' + project.id">
          {{ project.name_with_namespace }}
        </el-menu-item>
      </el-submenu>

      <el-submenu index="2">
        <template slot="title">冲刺</template>
        <el-submenu
          v-for="(milestone, index) in milestones"
          :key="index"
          :index="'2-' + index">
          <template slot="title">{{ milestone.title }}</template>
          <el-menu-item
            :index="'2-' + milestone.project_id + '-' + milestone.id + '-kanban'">
            看板
          </el-menu-item>
          <el-menu-item
            :index="'2-' + milestone.project_id + '-' + milestone.id + '-burndown'">
            冲刺详情
          </el-menu-item>
        </el-submenu>
        <el-submenu index="2-new" v-if="this.projects.length">
          <template slot="title">新建冲刺</template>
          <el-menu-item v-for="(project, index) in projects" :key="index" :index="'2-new-' + project.id">
            {{ "班级 " + project.class_name + ": " + project.name }}
          </el-menu-item>
        </el-submenu>
      </el-submenu>

      <el-menu-item index="3">
        问题
      </el-menu-item>

      <el-menu-item index="4">
        班级
      </el-menu-item>

      <el-menu-item index="10">
        教学进度
      </el-menu-item>

      <el-menu-item index="7">
        广播消息
        <el-badge v-if="broadcast_num > 0" class="mark" :value=broadcast_num />
      </el-menu-item>

      <el-submenu index="11">
      <template slot="title">博客</template>
        <el-menu-item v-for="classroomId in classroomIdList" :index="'11-' + classroomId">
        {{classroomNameList[classroomIdList.indexOf(classroomId)]}}
       </el-menu-item>
      </el-submenu>
      <el-menu-item index="5">
        GitLab
        <i class="el-icon-link"></i>
      </el-menu-item>

      <el-menu-item index="8" style="float: right">
        注销平台
      </el-menu-item>

      <el-submenu index="6" style="float: right">
        <template slot="title">新建问题</template>
        <el-menu-item v-for="(project, index) in projects" :key="index" :index="'6-' + project.id">
          {{ project.name_with_namespace }}
        </el-menu-item>
      </el-submenu>


      <el-submenu index="9" style="float: right">
        <template slot="title">新建标签</template>
        <el-menu-item v-for="(project, index) in projects" :key="index" :index="'9-' + project.id">
          {{ project.name_with_namespace }}
        </el-menu-item>
      </el-submenu>

    </el-menu>

    <el-dialog v-if="flag"
               title="新建问题"
               top="50px"
               :visible.sync="dialogVisible"
               v-loading="loading"
               element-loading-text="创建中"
               width="80%">
      <new-issue ref="newIssue" :issue="newIssue"></new-issue>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addIssue('newIssueForm')">确 定</el-button>
      </span>
    </el-dialog>

    <el-dialog v-else="flag"
               title="新建标签"
               top="50px"
               :visible.sync="dialogVisible"
               v-loading="loading"
               element-loading-text="创建中"
               width="80%">
      <new-label ref="newLabel" :label="newLabel"></new-label>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addLabel('newLabelForm')">确 定</el-button>
      </span>
    </el-dialog>

  </div>
</template>
<script>
  import NewLabel from './new_label.vue'
  import NewIssue from './new_issue.vue'
  import Label from '../../issues/models/label'
  import Issue from '../../issues/models/issue'
  import IssuesService from "../../issues/services/issues_service";
  import AlertMixin from '../../shared/components/mixins/alert'
  import axios from "axios";

  export default {
    props: ['broadcast_num'],
    mixins: [AlertMixin],
    components: {
      NewIssue,
      NewLabel,
    },
    data() {
      return {
        kanban: '1',
        issues: '2',
        gitlab: '3',
        projects: [],
        classroomId: '',
        milestones: [],
        gitlabHost: '',
        dialogVisible: false,
        flag: true,
        newLabel: new Label(),
        newIssue: new Issue(),
        // 创建 Issue 时的 loading
        loading: false,
        classroomIdList: [],
        classroomNameList: []
      };
    },
    mounted() {
      this.classroomIdList = JSON.parse(
      document.getElementById('navbar').dataset.classroomid);
      this.classroomNameList = JSON.parse(
      document.getElementById('navbar').dataset.classroomname);
      //console.log(document.getElementById('navbar').dataset);
      //console.log(this.classroomIdList);
      //console.log(this.classroomNameList);
      const navbar = document.getElementById('navbar');
      this.gitlabHost = navbar.dataset.gitlabhost;
      const projects = JSON.parse(navbar.dataset.projects);
      this.classroomId = JSON.parse(navbar.dataset.classroomid)[0];
      for (let project of projects) {
        let milestones = project.milestones;
        for (let milestone of milestones) {
          this.milestones.push(milestone);
        }
        this.projects.push({
          id: project.id,
          name: project.name,
          name_with_namespace: project.name_with_namespace,
          webUrl: project.web_url,
          class_name: project.class_name
        });
      }
      setInterval(this.getLatestBroadcast, 2000);
    },
    updated() {
      if (this.dialogVisible) {
        const $dialog = document.getElementsByClassName('el-dialog')[0];
        const navHeight = document.getElementById('navbar').clientHeight;
        const total = document.documentElement.clientHeight;
        $dialog.style.maxHeight = (total - 100) + 'px';
        $dialog.style.overflowY = 'auto';
      }
    },
    methods: {
      handleSelect(key, keyPath) {
        if (key.startsWith('1-')) {
          let project_id = key.substr(2);
          window.location.href = `/projects/${project_id}/kanban`;
        }
        // 新建冲刺
        else if (key.startsWith('2-new')) {
          let list = key.split('-');
          let projectId = parseInt(list[list.length - 1]);
          let webUrl = this.projects.find((p) => p.id === projectId).webUrl;
          window.open(`${webUrl}/milestones/new`);
        } else if (key.startsWith('2-')) {
          let list = key.substr(2).split('-');
          if (list.length === 3) {
            let milestone_id = list[1];
            let route = list[2];
            window.location.href = `/milestones/${milestone_id}/${route}`;
          }
        } else if (key === '3') {
          window.location.href = '/issues';
        } else if (key === '4') {
          window.location.href = "/classrooms";
        } else if (key === '5') {
          window.location.href = this.gitlabHost;
        } else if (key.startsWith('6-')) {
          this.newIssue.projectId = parseInt(key.substr(2));
          this.dialogVisible = true;
          this.flag = true;
        } else if (key === '7') {
          window.location.href = "/broadcasts";
        } else if (key === '8') {
          window.location.href = "/logout";
        } else if (key.startsWith('9-')) {
          this.newLabel.projectId = parseInt(key.substr(2));
          this.dialogVisible = true;
          this.flag = false;
        } else if (key === '10') {
          window.location.assign(`/classrooms/${this.classroomId}/teaching_progress_index`)
        } else if (key.startsWith('11-')){
          let classroomIdTmp = key.split("11-")[1];
          window.location.assign(`/classrooms/${classroomIdTmp}/blogs`);
        }
      },
      handleClose(done) {
        this.$confirm('确认关闭？')
          .then(_ => {
            done();
          })
          .catch(_ => {
          });
      },
      addLabel(formName) {
        this.$refs['newLabel'].$refs[formName].validate((valid) => {
          if (valid) {
            this.addNewLabel(this.newLabel);
            this.newLabel = new Label();
          } else {
            return false;
          }
        })
      },
      addNewLabel(label) {
        this.loading = true;
        const navbar = document.getElementById('navbar');
        const issuesService = new IssuesService({
          issuesEndpoint: navbar.dataset.issuesEndpoint
        });

        issuesService
          .newLabel(label.toObj())
          .then(res => res.data)
          .then((data) => {
            let label = Label.valueOf(data);
            this.success('创建成功');
            this.loading = false;
            this.dialogVisible = false;
          })
          .catch(e => {
            this.alert('创建失败');
            this.loading = false;
            this.dialogVisible = false;
          })
      },
      addIssue(formName) {
        this.$refs['newIssue'].$refs[formName].validate((valid) => {
          if (valid) {
            this.newIssue.state = 'opened';
            if (window.eventhub) {
              // issues 和 boards 中创建
              this.dialogVisible = false;
              window.eventhub.$emit('addNewIssue', this.newIssue);
            } else {
              // 其他页面通过导航栏创建
              this.addNewIssue(this.newIssue);
            }
            this.newIssue = new Issue();
          } else {
            return false;
          }
        })
      },
      addNewIssue(issue) {
        this.loading = true;
        const navbar = document.getElementById('navbar');
        const issuesService = new IssuesService({
          issuesEndpoint: navbar.dataset.issuesEndpoint
        });
        issuesService
          .newIssue(issue.toObj())
          .then(res => res.data)
          .then((data) => {
            let issue = Issue.valueOf(data);
            this.success('创建成功');
            this.loading = false;
            this.dialogVisible = false;
          })
          .catch(e => {
            this.alert('创建失败');
            this.loading = false;
            this.dialogVisible = false;
          })
      },
      getLatestBroadcast() {
        axios.get('/broadcasts/get_latest_broadcast').then((response) => {
          if (response.data['broadcast_num'] > this.broadcast_num) {
            this.broadcast_num = response.data['broadcast_num'];
            this.$notify({
              title: '新广播',
              message: response.data['latest_broadcast']['content']
            });
          }
        });
      }
    }
  }
</script>
<style scoped>
  .navbar a {
    text-decoration: none;
  }

  .navbar i {
    font-size: 14px;
  }
</style>

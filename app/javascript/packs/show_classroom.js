import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import ClassroomStudentService from "../src/classroom/services/classroom_student_service";
import AlertMixin from '../src/shared/components/mixins/alert';
import axios from 'axios/index';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#show-classroom-app',
    data() {
      return {
        isCreatingProjects: false,
        creatingProjectsProgress: 0,
        students: null,
        teachers: null,
        btnTeacherLoadings: null,
        btnStudentLoadings: null
      }
    },
    mixins: [AlertMixin],
    mounted() {
      this.getPersonalProjectStatus().then((result) => {
        let status = result.data;
        console.log(status);
        this.isCreatingProjects = status.is_creating;
        this.creatingProjectsProgress = status.progress;
      });
      this.students = JSON.parse(this.$el.dataset.students);
      this.teachers = JSON.parse(this.$el.dataset.teachers);
      this.btnTeacherLoadings = [];
      this.btnStudentLoadings = [];
      for (let i = 0;i < this.students.length;i++) {
        this.btnStudentLoadings.push(false);
      }
      for (let i = 0;i < this.teachers.length;i++) {
        this.btnTeacherLoadings.push(false);
      }
      const endpoint = this.$el.dataset.endpoint;
      this.classroomStudentsService = new ClassroomStudentService({
        classroomStudentsEndpoint: endpoint
      })
    },
    methods: {
      getPersonalProjectStatus() {
        return axios.get('/auto_test_projects/get_personal_project_status');
      },
      deleteStudent(index, user_id) {
        this.deleteUser(index, user_id, 'student');
      },
      deleteTeacher(index, user_id) {
        this.deleteUser(index, user_id, 'teacher');
      },
      deleteUser(index, user_id, type) {
        this.$confirm('确认移出班级？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if (type === 'student') {
            this.btnStudentLoadings.splice(index, 0, true);
          }
          else {
            this.btnTeacherLoadings.splice(index, 0, true);
          }
          this.classroomStudentsService.deleteUser(user_id, type)
            .then(res => res.data)
            .then(data => {
              if (type === 'student') {
                this.students.splice(index, 1);
                this.btnStudentLoadings.splice(index, 0, false);
              }
              else {
                this.teachers.splice(index, 1);
                this.btnTeacherLoadings.splice(index, 0, false);
              }
            })
            .catch(e => {
              this.alert('移出失败');
            })
        })
      }
    }
  })
})
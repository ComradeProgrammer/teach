import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue';
import select_runner from '../src/auto_tests/components/runner_input.vue';
import axios from 'axios/index';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-private-personal-project-app',
    data() {
      return {
        form: {
          scope: '',
          user_id: '',
        },
        studentList: [],
        classroom_id: '',
        path: ''
      }
    },
    computed: {
      scope: function () {
        return this.form.scope;
      }
    },
    components: {
      csrf,
      select_runner
    },
    mounted() {
      this.classroom_id = this.$el.dataset.classroomId;
      let studentDataGet = this.getAllStudentIdAndName();
      studentDataGet.then((result) => {
        let studentData = result.data;
        for (let i = 0; i < studentData.length; ++i) {
          this.studentList.push({
            label: `${studentData[i].name}(${studentData[i].role}, GitLab ID: ${studentData[i].gitlab_id})`,
            value: studentData[i].id
          });
        }
      });

    },
    methods: {
      submitForm() {
        axios.post('/classrooms/auto_test_projects/create_private_personal_project', {
          type: this.form.scope,
          class_id: this.classroom_id,
          user_id: this.form.user_id,
          path: this.path
        });
        window.location.assign('/classrooms');
      },
      getAllStudentIdAndName() {
        return axios.get('/classrooms/get_all_student_id_and_name', {
          params: {
            classroom_id: this.classroom_id
          }
        });
      },
    }
  });
});
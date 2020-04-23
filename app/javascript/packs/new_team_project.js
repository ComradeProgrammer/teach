import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue';
import axios from 'axios/index';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-project-app',
    data() {
      return {
        project: {
          members: [],
          name: '',
          path: '',
          description: '',
          initialize_with_readme: true,
          submit_path: ''
        },
        rules: {
          name: [
            {required: true, message: '请输入团队项目名称', trigger: 'blur'}
          ],
          path: [
            {required: true, message: '请输入团队项目地址', trigger: 'blur'}
          ]
        },
        userList: [],
        is_loading: false
      }
    },
    components: {
      csrf
    },
    mounted() {
      // this.project = JSON.parse(this.$el.dataset.project)
      // this.project['members'] = []
      this.project.submit_path = this.$el.dataset.submitpath;
      this.is_loading = false;
      this.getClassroomUserIdAndName().then((result) => {
        let userData = result.data;
        // console.log(userData);
        for (let i = 0; i < userData.length; ++i) {
          // console.log(`${userData[i].name}(${userData[i].role}, GitLab ID: ${userData[i].gitlab_id})`);
          this.userList.push({
            label: `${userData[i].name}(${userData[i].role}, GitLab ID: ${userData[i].gitlab_id})`,
            value: userData[i].id
          });
        }
      });
      // console.log('>>>>>>>>>>');
      // console.log(this.userList);
      this.$watch('project.name', (newVal, oldVal) => {
        this.project.path = newVal.toLowerCase().trim().replace(/\s+/g, '-');
        // console.log(this.project)
      })
    },
    methods: {
      submitForm() {
        this.$refs.project.validate((valid) => {
          if (valid) {
            this.$refs.project.$el.submit();
          } else {
            return false;
          }
        });
      },
      axiosSubmitForm() {
        this.is_loading = true
        axios.post(this.project.submit_path, {
          team_project: {
            name: this.project.name,
            path: this.project.path,
            description: this.project.description,
            initialize_with_readme: this.project.initialize_with_readme,
            members: this.project.members
          }
        }).then(() => {
          // this.is_loading = false
          window.location.assign(`/classrooms/${this.$el.dataset.classroomid}`)
        })
      },
      getClassroomUserIdAndName() {
        // console.log(`!!!!!!! ${this.$el.dataset.classroomid}`)
        return axios.get('/users/get_classroom_user_id_and_name', {
          params: {
            classroom_id: this.$el.dataset.classroomid
          }
        });
      }
    }
  })
})
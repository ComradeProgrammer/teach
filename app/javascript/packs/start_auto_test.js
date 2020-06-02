import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'
import axios from 'axios/index'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#start-auto-test-app',
    data() {
      return {
        form: {
          project_id: '',
          use_text_file: 'true',
          use_text_output: 'true',
          compile_command: '',
          exec_command: '',
          runner_uid: ''
        },
        runners: []
      }
    },
    components: {
      csrf
    },
    mounted() {
      this.form.project_id = this.$el.dataset.gitlabid;
      this.runners = JSON.parse(this.$el.dataset.runners);
      console.log("####################")
      console.log(this.runners)
      for (let i = 0; i < this.runners.length; i++)
      {
        this.runners[0] = JSON.parse(this.runners[0])
      }
      console.log(this.runners[0])
    },
    methods: {
      submitFormAxios() {
        axios.post(
          '/classrooms/' + this.$el.dataset.classroomId + '/auto_test_projects/start_auto_test',
          {
            project_id: this.form.project_id,
            use_text_file: this.form.use_text_file,
            use_text_output: this.form.use_text_output,
            compile_command: this.form.compile_command,
            exec_command: this.form.exec_command,
            runner_uid: this.runner_uid
        });
        window.location.assign('/classrooms/' + this.$el.dataset.classroomId);
      }
    }
  })
});
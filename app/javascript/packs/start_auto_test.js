import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router/dist/vue-router.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'
import axios from 'axios/index'

Vue.use(ElementUI);
Vue.use(VueRouter);

const router = new VueRouter();

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    router: router,
    el: '#start-auto-test-app',
    data() {
      return {
        form: {
          project_id: '',
          use_text_file: 'true',
          use_text_output: 'true',
          compile_command: '',
          exec_command: ''
        }
      }
    },
    components: {
      csrf
    },
    mounted() {
      this.form.project_id = this.$el.dataset.gitlabid;
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
            exec_command: this.form.exec_command
        });
        window.location.assign('/classrooms/' + this.$el.dataset.classroomId);
      }
    }
  })
});
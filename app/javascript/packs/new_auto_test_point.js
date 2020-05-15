import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-auto-test-point-app',
    data() {
      return {
        form: {
          project_id: '',
          input: '',
          expected_output: ''
        },
        rules: {
          input: [
            {required: true, message: '不能为空', trigger: 'blur'}
          ],
          expected_output: [
            {required: true, message: '不能为空', trigger: 'blur'}
          ]
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
      submitForm() {
        this.$refs.new_auto_test_point.validate((valid) => {
          if (valid) {
            this.$refs.new_auto_test_point.$el.submit();
          } else {
            return false;
          }
        });
      }
    }
  })
});
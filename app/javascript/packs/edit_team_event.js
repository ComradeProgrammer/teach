import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'
import MonacoEditor from 'vue-monaco'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#edit-team-event-app',
    data() {
      return {
        event: {},
        rules: {
          name: [
            {required: true, message: '请输入团队事件名称', trigger: 'blur'}
          ],
          description: [
            {required: true, message: '请填写团队事件描述来更好的区分事件', trigger: 'blur'}
          ],
          code: [
            {required: true, message: '请输入事件定义代码', trigger: 'blur'}
          ]
        },
        vscodeOptions: {
          automaticLayout: true
        },
        illustrateUrl: 'https://note.youdao.com/ynoteshare1/index.html?id=181dcd24c2add9473d0bc145e7ddeafa&type=note'
      }
    },
    components: {
      csrf,
      MonacoEditor
    },
    mounted() {
      this.event = JSON.parse(this.$el.dataset.event)
    },
    methods: {
      submitForm() {
        this.$refs.event.validate((valid) => {
          if (valid) {
            this.$refs.event.$el.submit();
          } else {
            return false;
          }
        });
      },
    }
  })
});
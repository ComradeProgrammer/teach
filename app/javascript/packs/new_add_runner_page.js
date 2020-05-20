import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import add_runner_page_content from '../src/runners/components/add_runner_page_content.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#add-runner-app',
    components: {
      add_runner_page_content
    }
  })
})
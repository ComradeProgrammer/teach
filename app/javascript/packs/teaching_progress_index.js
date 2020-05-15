import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import teaching_progress_index_main from "../src/classroom/components/teaching_progress_index_main";

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#teaching-progress-index',
    components: {
      teaching_progress_index_main
    }
  })
})
import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import TestPoints from '../src/auto_tests/components/test_points.vue'

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const autoTestProjects = new Vue({
    el: '#test-points',
    components: {
        TestPoints
    }
  })
})
import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import homework_form from '../src/homeworks/components/new_homeworks_form.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-homework-app',
    components: {
      homework_form,
    }
  })
})
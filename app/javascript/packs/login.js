import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import login_panel from "../src/login/components/login_panel.vue";

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#login',
    data() {
      return {
        
      }
    },
    components: {
      login_panel
    },
    mounted() {
    },
    methods: {
    }
  });
});
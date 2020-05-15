import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import runners_index_table from "../src/runners/components/runners_index_table";

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#runners-index-app',
    components: {
      runners_index_table
    }
  })
})
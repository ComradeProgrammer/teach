import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import org_index from '../src/organizations/components/index_organizations_text.vue';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#index-organization-app',
    components: {
      org_index,
    }
  })
})

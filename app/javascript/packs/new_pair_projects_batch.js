import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import new_pair_projects_batch_form from "../src/auto_tests/components/new_pair_projects_batch_form";

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#new-pair-projects-batch-app',
        components: {
            new_pair_projects_batch_form,
        }
    })
})
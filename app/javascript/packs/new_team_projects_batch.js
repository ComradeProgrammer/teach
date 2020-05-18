import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import new_team_projects_batch_form from "../src/team_project/components/new_team_projects_batch_form";

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#new-team-projects-batch-app',
        components: {
            new_team_projects_batch_form,
        }
    })
})
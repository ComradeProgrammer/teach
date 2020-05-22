import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import score_form from '../src/scores/components/new_scores_form.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-score-app',
    components: {
      score_form,
    }
  })
})

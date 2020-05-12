import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import tp from '../src/auto_tests/components/test_points.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#test-points-app',
    data() {
      return {
        points: []
      }
    },
    components: {
        tp
    },

    mounted() {
      this.points = JSON.parse(this.$el.dataset.points);
      console.log('>>>>>>>>>>>>>>>>');
      console.log(this.points);
    }
  })
})
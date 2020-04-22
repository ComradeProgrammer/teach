import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#show-auto-test-results-app',
        data() {
        	return {
        		tableData: []
        	}
        },
        components: {
      		csrf
    	},
    	mounted() {
    		this.tableData = JSON.parse(this.$el.dataset.results);
    		console.log('>>>>>>>>>>>>>>')
    		console.log(this.tableData);
    	}
    })
});
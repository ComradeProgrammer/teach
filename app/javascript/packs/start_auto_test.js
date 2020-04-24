import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#start-auto-test-app',
        data() {
            return {
                form: {
                    project_id: '',
                    use_text_file: 'true',
                    use_text_output: 'true',
                    compile_command: '',
                    exec_command: ''
                },
                is_loading: false
            }
        },
        components: {
            csrf
        },
        mounted() {
            this.form.project_id = this.$el.dataset.gitlabid;
        },
        methods: {
            submitForm() {
                this.is_loading = true
                this.$refs.start_auto_test.$el.submit();
            }
        }
    })
});
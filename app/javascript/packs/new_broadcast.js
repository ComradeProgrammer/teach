import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#new-broadcast-app',
        data() {
            return {
                broadcast: {},
                rules: {
                    to_id: [
                        {required: true, message: '请输入接受方ID', trigger: 'blur'}
                    ],
                    content: [
                        {required: true, message: '请输入广播内容', trigger: 'blur'}
                    ]
                }
            }
        },
        components: {
            csrf
        },
        mounted() {
            this.broadcast = JSON.parse(this.$el.dataset.broadcast);
        },
        methods: {
            submitForm() {
                this.$refs.broadcast.validate((valid) => {
                    if (valid) {
                        this.$refs.broadcast.$el.submit();
                    } else {
                        return false;
                    }
                });
            }
        }
    });
});
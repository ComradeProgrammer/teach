import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#new-auto-test-project-app',
        data() {
            return {
                auto_test_project: {},
                rules: {
                    name: [
                        {required: true, message: '请输入项目名称', trigger: 'blur'}
                    ],
                    test_type: [
                        {required: true, message: '请输入类型名称', trigger: 'blur'}
                    ],
                    path: [
                        {required: true, message: '请输入项目地址', trigger: 'blur'}
                    ]
                }
            }
        },
        components: {
            csrf
        },
        mounted() {
            // attention: here use `autoTestProject` not `auto_test_project`
            // see: https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dataset
            this.auto_test_project = JSON.parse(this.$el.dataset.autoTestProject);
            // console.log(this.auto_test_project);
            // this.auto_test_project.type = 'personal';
            this.$watch('auto_test_project.name', (newVal, oldVal) => {
                this.auto_test_project.path = newVal.toLowerCase().trim().replace(/\s+/g, '-');
            })
        },
        methods: {
            submitForm() {
                this.$refs.auto_test_project.validate((valid) => {
                    if (valid) {
                        this.$refs.auto_test_project.$el.submit();
                    } else {
                        return false;
                    }
                });
            },

            cancel() {
                // TODO: Featch location
                // window.location.replace('/')
            }
        }
    })
});
import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue';
import axios from 'axios/index';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#new-auto-test-project-app',
        data() {
            return {
                auto_test_project: {
                    name: '',
                    path: '',
                    description: '',
                    test_type: '',
                    pair1_id: '',
                    pair2_id: ''
                },
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
                },
                userList: []
            }
        },
        components: {
            csrf
        },
        mounted() {
            // attention: here use `autoTestProject` not `auto_test_project`
            // see: https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dataset
            // this.auto_test_project = JSON.parse(this.$el.dataset.autoTestProject);
            // console.log(this.auto_test_project);
            // this.auto_test_project.type = 'personal';
            this.auto_test_project.test_type = this.$el.dataset.type;
            console.log(this.$el.dataset.ispublic);
            if (this.$el.dataset.type === 'pair' && this.$el.dataset.ispublic === 'yes') {
                this.auto_test_project.test_type += '-public'
            }

            if (this.$el.dataset.type === 'pair') {
                console.log('>>> pair')
                this.$watch('auto_test_project.pair1_id', (newVal, oldVal) => {
                    // console.log('>>> pair1')
                    this.auto_test_project.name = 'student_pair_project_' + newVal + '_' + this.auto_test_project.pair2_id;
                })
                this.$watch('auto_test_project.pair2_id', (newVal, oldVal) => {
                    // console.log('>>> pair2')
                    this.auto_test_project.name = 'student_pair_project_' + this.auto_test_project.pair1_id + '_' + newVal;
                })
            }
            this.getClassroomUserIdAndName().then((result) => {
                let userData = result.data;
                // console.log(userData);
                    for (let i = 0; i < userData.length; ++i) {
                        // console.log(`${userData[i].name}(${userData[i].role}, GitLab ID: ${userData[i].gitlab_id})`);
                        this.userList.push({
                        label: `${userData[i].name}(${userData[i].role}, GitLab ID: ${userData[i].gitlab_id})`,
                        value: userData[i].id
                    });
                }
            });
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
            getClassroomUserIdAndName() {
                // console.log(`!!!!!!! ${this.$el.dataset.classroomid}`)
                return axios.get('/users/get_classroom_user_id_and_name', {
                    params: {
                        classroom_id: this.$el.dataset.classroomid
                    }
                });
            }
        }
    })
});
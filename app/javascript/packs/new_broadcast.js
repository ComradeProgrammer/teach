import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue';
import axios from 'axios/index';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#new-broadcast-app',
        data() {
            return {
                broadcast: {},
                form: {
                    scope: '',
                    class_id: '',
                    user_id: '',
                    content: '',
                },
                classList: [],
                userList: [],
                rules: {
                    scope: [
                        {required: true, message: '请选择范围', trigger: 'blur'}
                    ],
                    class_id: [
                        {required: true, message: '请选择班级', trigger: 'blur'}
                    ],
                    user_id: [
                        {required: true, message: '请选择成员', trigger: 'blur'}
                    ],
                    content: [
                        {required: true, message: '不能为空', trigger: 'blur'}
                    ]
                }
            }
        },
        computed: {
            scope: function () {
                return this.broadcast.scope;
            }
        },
        components: {
            csrf
        },
        mounted() {
            let classDataGet = this.getAllClassIdAndName();
            classDataGet.then((result) => {
                let classData = result.data;
                for (let i = 0; i < classData.length; ++i) {
                    this.classList.push({
                        label: `${classData[i].name}(GitLab Group ID: ${classData[i].gitlab_group_id})`,
                        value: classData[i].id
                    })
                }
            });
            let userDataGet = this.getAllUserIdAndName();
            userDataGet.then((result) => {
                let userData = result.data;
                for (let i = 0; i < userData.length; ++i) {
                    this.userList.push({
                        label: `${userData[i].name}(${userData[i].role}, GitLab ID: ${userData[i].gitlab_id})`,
                        value: userData[i].id
                    });
                }
            });
            // this.broadcast = JSON.parse(this.$el.dataset.broadcast);
        },
        methods: {
            submitForm() {
                this.$refs.broadcast.validate((valid) => {
                    if (valid) {
                        axios.post('/broadcasts', {
                            type: this.broadcast.scope,
                            class_id: this.broadcast.class_id,
                            user_id: this.broadcast.user_id,
                            content: this.broadcast.content
                        });
                        window.location.href = '/classrooms';
                    } else {
                        return false;
                    }
                });
            },
            getAllClassIdAndName() {
                return axios.get('/classrooms/get_all_classroom_id_and_name');
            },
            getAllUserIdAndName() {
                return axios.get('/users/get_all_user_id_and_name')
            }
        }
    });
});
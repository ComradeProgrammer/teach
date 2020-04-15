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
                    // todo: add more rules
                    //content: [
                    //    {required: true, message: '请输入广播内容', trigger: 'blur'}
                    //]
                }
            }
        },
        computed: {
            scope: function () {
                return this.form.scope;
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
                // todo: add validation
                axios.post('/broadcasts', {
                    type: this.form.scope,
                    class_id: this.form.class_id,
                    user_id: this.form.user_id,
                    content: this.form.content
                });
                window.location.href = '/classrooms';
                /*
                this.$refs.broadcast.validate((valid) => {
                    if (valid) {
                        axios.post('/broadcasts', {
                            type: this.form.scope,
                            class_id: this.form.class_id,
                            user_id: this.form.user_id,
                            content: this.form.content
                        });
                        window.location.href = '/classrooms';
                    } else {
                        return false;
                    }
                });
                 */
            },
            cancel() {
                window.location.replace('/classrooms');
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
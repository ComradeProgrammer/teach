import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue';
import axios from 'axios/index';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#edit-classroom-app',
        data() {
            return {
                classroom: {},
                classroom_id: ''
            }
        },
        components: {
            csrf
        },
        mounted() {
            this.classroom = JSON.parse(this.$el.dataset.classroom);
            this.classroom_id = this.$el.dataset.classroomId;
            // console.log(this.$el);
            // console.log(this.classroom_id);
            this.$watch('classroom.name', (newVal, oldVal) => {
                this.classroom.path = newVal.toLowerCase().trim().replace(/\s+/g, '-');
            })
        },
        methods: {
            submitForm() {
                /*
                console.log('/classrooms/' + this.classroom_id);
                console.log(this.classroom);
                axios.put('/classrooms/' + this.classroom_id, this.classroom).then(
                    window.location.replace('/classrooms')
                )
                */
                // this.$refs.classroom.$el.submit();
            
                this.$refs.classroom.validate((valid) => {
                if (valid) {
                    this.$refs.classroom.$el.submit();
                } else {
                    return false;
                }
                });
            }
        }
    })
});
import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import csrf from '../src/shared/components/csrf.vue'

Vue.use(ElementUI)

document.addEventListener('DOMContentloaded', () => {
    new Vue({
        el: '#edit-classroom-app',
        data() {
            return {
                classroom: {},
            }
        },
        components: {
            csrf
        },
        mounted() {
            this.classroom = JSON.parse(this.$el.dataset.classroom);
            this.$watch('classroom.name', (newVal, oldVal) => {
                this.classroom.path = newVal.toLowerCase().trim().replace(/\s+/g, '-');
            })
        },
        mehtods: {
            submitForm() {
                this.$refs.classroom.validate((valid) => {
                    if (valid) {
                        this.$refs.classroom.$el.submit();
                    } else{
                        return false;
                    }
                });
            }
        }
    });
});
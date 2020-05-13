<template>
    <el-form :model="pairForm" :rules="rules" ref="pairForm" :action="action" method="post">
        <csrf></csrf>
        <el-input v-model="input" placeholder="请输入内容"></el-input>
    </el-form>
</template>

<script>

    import Vue from 'vue/dist/vue.esm'
    import ElementUI from 'element-ui';
    import 'element-ui/lib/theme-chalk/index.css';
    import csrf from '../../shared/components/csrf.vue';

    Vue.use(ElementUI);

    export default {
        props: ['action'],
        data() {
            return {
                input: ''
            }
        },
        components: {
            csrf,
        },
        methods: {
            submitForm: function (formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        //alert('submit!');
                        this.$refs[formName].$el.submit();
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                })
            },
            resetForm: function (formName) {
                this.$refs[formName].resetFields();
            }
        }
    }
</script>

<style scoped>

</style>
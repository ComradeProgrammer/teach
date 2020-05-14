<template>
    <el-form :model="pairForm" :rules="rules" ref="pairForm" :action="action" method="post">
        <csrf></csrf>
        <p>请输入结对学生的学号，按每2人一行进行输入，用英文逗号','隔开</p>
        <el-input
                type="textarea"
                :rows="10"
                placeholder="请输入内容"
                v-model="pairForm.text" name='pairForm[text]'>
        </el-input>
        <el-form-item>
            <el-button type="primary" @click="submitForm('pairForm')">创建仓库</el-button>
        </el-form-item>
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
                pairForm: {
                    text: ''
                },
                rules: {
                    text: [
                        {required: true, message: '请输入学号', trigger: 'blur'}
                    ]
                }
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
            }
        }
    }
</script>

<style scoped>

</style>
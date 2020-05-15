<template>
    <div>
        <div v-if="needDetail">
            <el-button type="primary" @click="table = true">测试数据详情</el-button>
            <el-dialog
            :visible.sync="table"
            direction="rtl"
            width="40%">
                <h2 class="title">测试点{{index}}-测试数据详情</h2>
                <br><br>
                <el-collapse class="func-card">
                    <el-collapse-item title="输入" name="1">
                        <p class="multi-line-text">
                            {{input}}
                        </p>
                    </el-collapse-item>

                    <el-collapse-item title="期望输出" name="2">
                        <p class="multi-line-text">
                            {{expected_output}}
                        </p>
                    </el-collapse-item>
                </el-collapse>
            </el-dialog>
        </div>
        <div v-else>
            <h4>
                输入：
            </h4>
            <p>
                {{input}}
            </p>
            <h4>
                期望输出：
            </h4>
            <p>
                {{expected_output}}
            </p>
        </div>
    </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';

  Vue.use(ElementUI);

  export default {
    props: ['index', 'input', 'expected_output'],

    data() {
      return {
        table: false,
        needDetail: false
      };
    },

    mounted() {
        console.log('###################');
        console.log(this.input);
        console.log(this.expected_output);
        if ((this.input.length > 20) || (this.input.indexOf('\n') > -1) || (this.expected_output.length > 20) || (this.expected_output.indexOf('\n') > -1) ) 
        {
            this.needDetail = true;
        }
    }
  }
</script>

<style scoped>
  .multi-line-text {
      white-space: pre-line;
  }

  .title {
    width: 80%;
    margin: 0 auto;
  }

  .func-card {
    margin: 0 auto;
  }
</style>
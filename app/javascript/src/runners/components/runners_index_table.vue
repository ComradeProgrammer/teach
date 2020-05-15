<template>
  <div>
    <div>
      <a :href="newrunnerhref">
        <el-button type="text">
          添加评测节点
        </el-button>
      </a>
    </div>
    <div>
      <div v-if="all_runners_info.length > 0">
        <div v-for="runner in all_runners_info" :key="runner.id">
          <el-card>
            <div slot="header">
              <span>{{runner.name}}</span>
              <el-button style="float: right; padding: 3px 0" type="text">查看详情</el-button>
            </div>
            <ul>
              <li>地址</li>
              <li>系统信息</li>
            </ul>
          </el-card>
        </div>
      </div>
      <div v-else>
        <el-card>
          <p>当前暂无评测节点，您可以在您的服务器上配置评测Runner，然后在此页面添加评测节点</p>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm'
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';

  Vue.use(ElementUI);

  export default {
    props: [
      'newrunnerhref',
      'allrunners',
    ],
    data() {
      return {
        all_runners_info: [],
      }
    },
    mounted() {
      this.all_runners_info = JSON.parse(this.allrunners);
      // console.log(this.allrunners);
    }
  }
</script>

<style scoped>

</style>
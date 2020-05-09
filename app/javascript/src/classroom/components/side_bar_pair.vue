<template>
  <div>
    <el-button type="primary" @click="table = true">结对项目管理面板</el-button>
    <el-drawer
      :visible.sync="table"
      direction="rtl"
      size="40%"
      style="">
      <h2 class="title">结对项目控制面板</h2>
      <br><br>
      <div v-if="haspublicrepo === 'true'" class="func-card">
        <a :href="testpointhref">
          <el-button>
            创建结对项目评测点
          </el-button>
        </a>
      </div>
      <div v-else class="func-card">
        <p>当您创建公共发布区后，您才能够创建评测点</p>
        <a :href="createpublichref">
          <el-button>
            创建结对项目公共发布区
          </el-button>
        </a>
      </div>
      <el-divider></el-divider>
      <div class="func-card">
        <a :href="repohref">
          <el-button>
            分配结对项目学生仓库
          </el-button>
        </a>
      </div>
      <el-divider></el-divider>
      <div v-if="haspublicrepo === 'true'" class="func-card">
        <a :href="starttesthref">
          <el-button>
            提交评测任务
          </el-button>
        </a>
      </div>
      <div v-else class="func-card">
        <p>当您创建公共发布区后，您才能够提交评测任务</p>
        <el-button :disabled="true">
          提交评测任务
        </el-button>
      </div>
      <el-divider></el-divider>
      <div v-if="haspublicrepo === 'true'" class="func-card">
        <a :href="getresulthref">
          <el-button>
            获取评测结果
          </el-button>
        </a>
      </div>
      <div v-else class="func-card">
        <p>当您创建公共发布区后，您才能够获取评测结果</p>
        <el-button :disabled="true">
          获取评测结果
        </el-button>
      </div>
    </el-drawer>
  </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';

  Vue.use(ElementUI);

  export default {
    props: [
      'haspublicrepo',
      'testpointhref',
      'createpublichref',
      'repohref',
      'starttesthref',
      'getresulthref'
    ],
    data() {
      return {
        table: false,
      };
    },
  }
</script>

<style scoped>
  .title {
    width: 80%;
    margin: 0 auto;
  }

  .func-card {
    width: 80%;
    margin: 0 auto;
  }
</style>
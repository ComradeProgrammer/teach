<template>
  <div>
    <el-button type="primary" @click="table = true">结对项目管理面板</el-button>
    <el-dialog
      :visible.sync="table"
      direction="rtl"
      width="40%">
      <h2 class="title">结对项目控制面板</h2>
      <br><br>
      <el-collapse class="func-card">
        <el-collapse-item title="仓库管理" name="1">
          <div v-if="haspublicrepo === 'true'">
            <el-button type="text" :disabled="true">
              创建结对项目公共发布区
            </el-button>
          </div>
          <div v-else>
            <a :href="createpublichref">
              <el-button type="text">
                创建结对项目公共发布区
              </el-button>
            </a>
          </div>
          <div>
            <a :href="repohref">
              <el-button type="text">
                分配结对项目学生仓库
              </el-button>
            </a>
          </div>
        </el-collapse-item>

        <el-collapse-item title="评测管理" name="2">
          <div v-if="haspublicrepo === 'true'">
            <a :href="testpointhref">
              <el-button type="text">
                管理结对项目评测点
              </el-button>
            </a>
          </div>
          <div v-else>
            <el-button type="text" :disabled="true">
              管理结对项目评测点
            </el-button>
          </div>

          <div v-if="haspublicrepo === 'true'">
            <a :href="starttesthref">
              <el-button type="text">
                提交评测任务
              </el-button>
            </a>
          </div>
          <div v-else>
            <el-button type="text" :disabled="true">
              提交评测任务
            </el-button>
          </div>

          <div v-if="haspublicrepo === 'true'">
            <a :href="getresulthref">
              <el-button type="text">
                获取评测结果
              </el-button>
            </a>
          </div>
          <div v-else>
            <el-button type="text" :disabled="true">
              获取评测结果
            </el-button>
          </div>

        </el-collapse-item>
      </el-collapse>
    </el-dialog>
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
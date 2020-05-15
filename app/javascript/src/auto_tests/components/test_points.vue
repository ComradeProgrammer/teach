<template>
  <div>
    <a :href="createtestpointhref">
      <el-button type="primary">
        创建{{selfscribe}}项目评测点
      </el-button>
    </a>
    <el-table
      :data="selfpoints"
      stripe
      style="width: 100%">
      <el-table-column
        prop="index"
        label="测试点ID" class="index-col">
      </el-table-column>
      <el-table-column
        prop="input"
        label="输入数据">
      </el-table-column>
      <el-table-column
        prop="expected_output"
        label="期望输出">
      </el-table-column>
      <el-table-column prop="index" label="操作">
        <template slot-scope="scope">
          <a :href="'remove_auto_test_point?test_type=' + testtype + '&point_id=' + selfpoints[scope.$index].index">
            <el-button type="text">
              删除
            </el-button>
          </a>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import selfft from "../../text_component/fold_unfold_text.vue";

  Vue.use(ElementUI);

  export default {
    props: ['points', 'testtype', 'createtestpointhref'],

    data() {
      return {
        has_points: false,
        selfpoints: [],
        selfscribe: ''
      }
    },

    components: {
      selfft
    },

    mounted() {
      this.selfpoints = JSON.parse(this.points);
      // console.log(this.selfpoints);
      // console.log(this.testtype);
      if (this.testtype === 'personal') {
        this.selfscribe = '个人';
      } else if (this.testtype === 'pair') {
        this.selfscribe = '结对';
      }
      // console.log(this.selfscribe);
    }
  }

</script>
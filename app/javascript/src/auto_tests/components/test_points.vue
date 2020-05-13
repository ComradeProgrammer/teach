<template>
  <div class="test-points">
      <div class="page-title-holder">
          <div class="page-title">
              评测点列表
          </div>
      </div>
      <el-card v-for="point in points" :key="point" class="point-card">
          <div slot="header" class="point-card-header">
              <h3>测试点{{point["index"]}}</h3>
          </div>
          <div class="point-card-body">
              <h4>输入</h4>
              <selfft :text="point['input']"></selfft>
              <h4>期望输出</h4>
              <selfft :text="point['expected_output']"></selfft>
          </div>
  </div>
</template>

<script>
import Vue from 'vue/dist/vue.esm';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import selfft from "../../text_component/fold_unfold_text.vue";

export default {
    props : ['points'],

    data: function() {
        return {
            has_points: false
        }
    },

    components: {
        selfft
    },

    mounted() {
        if (this.points.length > 0)
        {
            this.has_points = true;
        }
    }
}

</script>
<template>
  <div class="test-points small-container">
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
              <fold-text text="point['input']"></fold-text>
              <h4>期望输出</h4>
              <fold-text text="point['expected_output']"></fold-text>
          </div>
  </div>
</template>

<script>
import FoldText from "../../text_component/fold_unfold_test.vue";

export default {
    data() {
        return {
            points: [],
            has_points: false
        }
    },

    components() {
        FoldText
    },

    mounted() {
        const point_list = JSON.parse(this.$el.dataset.points);
        if (point_list.length > 0)
        {
            for (var index in point_list)
            {
                this.points.append({
                    index: index,
                    input:  point_list[index]["input"],
                    expected_output: point_list[index]["expected_output"]
                    })
            }
            this.has_points = true;
        }
    }
}

</script>
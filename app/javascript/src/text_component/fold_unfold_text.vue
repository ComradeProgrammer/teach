<template>
  <div class="text-content">
    <p v-if="!need_unfold">
      {{text}}
    </p>
    <template v-if="need_unfold">
      <template v-if="fold">
        <p>{{text.slice(0, 40) + "..."}}</p>
      </template>
      <template v-else="">
        <p>{{text}}</p>
      </template>
      <el-button type="text" @click="change_state">{{fold?'展开':'收起'}}</el-button>
    </template>
  </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm';
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';

  export default {
    props: {
      text: {
        type: String,
        required: true
      }
    },

    data() {
      return {
        need_unfold: false,
        fold: true
      }
    },

    mounted() {
      if (this.text.length > 40) {
        this.need_unfold = true;
      }
    },

    methods: {
      change_state() {
        this.fold = !this.fold;
      }
    }
  }
</script>
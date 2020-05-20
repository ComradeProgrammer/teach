<template>
  <div>
    <csrf></csrf>
    <el-input
      placeholder="请输入评测机的名字（不作为评测机的唯一标识，非空且长度不超过40个字符且不含特殊字符）"
      v-model="runner.name"
      @change="nameChange"
      @blur="nameCheck"
      clearable>
    </el-input>
    <div v-if="name_show === true">
      <div v-if="name_available === true">
        <i 
          class="el-icon-check" 
          style="float: left; padding: 3px 0; background: #67C23A" 
          type="text">
        </i>
      </div>
      <div v-else>
        <i 
          class="el-icon-close" 
          style="float: left; padding: 3px 0; background: #F56C6C" 
          type="text">
        </i>
      </div>
    </div>
    <runner-input
      @available="availableRunner"
      @change="changeRunner">
    </runner-input>
    <div v-if="name_available === true && runner_available === true">
      <el-button type="primary" @click="submitForm">添加评测机</el-button>
    </div>
    <div v-else>
      <el-button type="primary" disabled>添加评测机</el-button>
    </div>
  </div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm'
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import axios from 'axios/'
  import csrf from '../../shared/components/csrf.vue';
  import runner_input from './runner_input.vue';

  export default {
    data: function() {
      return {
        runner: {
          name: '',
          uid: '',
          os: ''
        },
        name_available: false,
        name_show: false,
        runner_available: false
      }
    },

    components: {
      csrf,
      'runner-input': runner_input
    },

    methods: {
      nameChange: function() {
        this.name_show = false;
        this.name_available = false;
      },

      nameCheck: function() {
        if (this.runner.name.length <= 40 && this.runner.name.length > 0) {
          this.name_available = true;
        }
        this.name_show = true;
      },

      availableRunner: function(runner) {
        //console.log('#########');
        //console.log(runner);
        this.runner.uid = runner.uid;
        this.runner.os = runner.os;
        this.runner_available = true;
      },

      changeRunner: function() {
        this.runner_available = false;
      },

      submitForm: function() {
        axios.post('http://' + window.location.host + '/runners/add_runner', this.runner);
        window.location.assign('http://' + window.location.host + '/classrooms');
      }
    }
  }
</script>
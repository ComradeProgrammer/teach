<template>
  <div>
    <el-input
      placeholder="请输入评测机的网络地址(IP地址或域名+端口)"
      v-model="path"
      @change="inputValueChange"
      @blur="checkThePath"
      clearable>
      <template slot="prepend">Http://</template>
    </el-input>
    <div v-if="show_check === true">
      <div v-if="runner_state.state === 1">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <i 
              class="el-icon-check" 
              style="float: left; padding: 3px 0; background: #67C23A" 
              type="text">
            </i>
            <span>查询评测机成功</span>
          </div>
          <p>评测机ID: {{runner_state.id}}</p>
          <p>评测机操作系统: {{runner_state.os}}</p>
        </el-card>
      </div>
      <div v-else>
        <el-tag type="danger">查询评测机失败</el-tag>
      </div>
    </div>
  </div>    
</template>

<script>

  import Vue from 'vue/dist/vue.esm'
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import axios from 'axios/'

  Vue.use(ElementUI);

  export default {
    data() {
      return {
        path: '',
        show_check: false,
        runner_state: {
          state: 0,
          id: '',
          os: ''
        }
      }
    },

    methods: {
      inputValueChange: function() {
        this.show_check = false;
        this.runner_state.state = 0;
        this.runner_state.id = "";
        this.runner_state.os = "";
        this.$emit('change');
      },

      checkThePath: function() {
        // console.log('http://' + window.location.host + '/classrooms/auto_test_projects/validate_runner');
        axios.get('http://' + window.location.host + '/classrooms/auto_test_projects/validate_runner', {
          params: {
            path: this.path
          }
        }).then((res) => {
            let data = res.data;
            // console.log(data);
            if (data.key === 'agile soft engineering') {
              console.log('arrive init runner state');
              this.runner_state.state = 1;
              this.runner_state.id = data.id;
              this.runner_state.os = data.os;
              this.$emit('available', {
                uid: this.runner_state.id,
                os: this.runner_state.os,
                path: this.path
              });
            }
          }
        ).catch((err) => {
            console.log('Error: happen in checking runner.');
            console.log(err);
          });
        this.show_check = true;
      }
    }
  }
</script>
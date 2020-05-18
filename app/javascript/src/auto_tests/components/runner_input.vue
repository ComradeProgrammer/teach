<template>
  <div>
    <el-input
      placeholder="请输入评测机的网络地址(IP地址或域名+端口)"
      v-model="input_value"
      @change="inputValueChange"
      @blur="checkThePath"
      clearable>
      <template slot="prepend">Http://</template>
    </el-input>
  </div>    
</template>

<script>

  import Vue from 'vue/dist/vue.esm'
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  import axios from 'axios/'

  Vue.use(ElementUI);

  export default {
    props : {
      value: String
    },

    model: {
      prop: 'value',
      event: 'input'
    },

    data() {
      return {
        input_value: '',
        check_path: false
      }
    },

    methods: {
      inputValueChange: function() {
        this.$emit('input', this.input_value);
      },

      checkThePath: function() {
        console.log('^^^^^^^');
        console.log('http://' + window.location.host + '/classrooms/auto_test_projects/validate_runner');
        axios.get('http://' + window.location.host + '/classrooms/auto_test_projects/validate_runner', {
          params: {
            path: this.value
          }
        }).then(
          function(res) {
            console.log('###########');
            console.log(res);
            console.log(res.data);
          }
        ).catch(
          function(err)
          {
            console.log('$$$$$$$$$$$');
            console.log(err);
          }
        )
      }
    }
  }
</script>
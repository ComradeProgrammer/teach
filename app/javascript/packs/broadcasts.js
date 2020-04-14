import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
    new Vue({
        el: '#broadcasts-app',
    })
});

Vue.component('broadcast-content', {
    props: {
        content :{
            type: String,
            default: ""
        }
    },

    data: function () {
        return {
            abstract : true
        }
    },

    template: `
        <div class="broadcast-content">
            <h4 v-if="content.length < 40">
                {{content}}
            </h4>
            <template v-if="content.length > 40">
                <template v-if="abstract">
                    <h4>{{content.slice(0, 40) + "..."}}</h4>
                </template>
                <template v-else="">
                    <h4>{{content}}</h4>
                </template>
                <el-button type="text" @click="abstract = !abstract">{{abstract?'展开':'收起'}}</el-button>
            </template>
        </div>
    `
})
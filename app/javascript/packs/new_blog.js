import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import ECharts from 'vue-echarts';
import 'echarts/lib/chart/line';
import 'echarts/lib/component/tooltip';
import 'echarts/lib/component/title';
import 'echarts/lib/component/toolbox';
import 'echarts/lib/component/legend';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import mdWrapper from '../src/shared/components/md_wrapper.vue'
import EchartsOption from '../src/shared/components/mixins/burnEchartsOption'
import Blog from '../src/blogs/models/blog'
import BlogsService from "../src/blogs/services/blogs_service";
import UploadService from "../src/shared/services/upload_service";
import csrf from '../src/shared/components/csrf.vue'
import AlertMixin from "../src/shared/components/mixins/alert";
import IssuesService from "../src/issues/services/issues_service";


Vue.use(ElementUI);
Vue.use(MavonEditor);
Vue.component('v-chart', ECharts);

document.addEventListener('DOMContentLoaded', () => {
  const newBlogApp = new Vue({
    el: '#new-blog-app',
    mixins: [EchartsOption, AlertMixin],
    components: {
      mdWrapper,
      csrf
    },
    data() {
      return {
        loading: false,
        isChartButtonLoading: false,
        chartVisible: false,
        type: '',
        str_hw: '请选择作业',
        homeworks: [],
        containers: [],
        containers1:[],
        containerId: null,
        hwId: null,
        blog: null,
        rules: {
          project_id: [
            {required: true, message: '请选择', trigger: 'blur'}
          ],
          title: [
            {required: true, message: '请输入标题', trigger: 'blur'}
          ],
          code: [
            {required: true, message: '请输入内容', trigger: 'blur'}
          ]
        }
      }
    },
    computed: {
      blogContainerName() {
        if (this.type === 'blog') {
          return '项目';
        }
        return '冲刺';
      },
      blogContainerPlaceholder() {
        if (this.type === 'blog') {
          return '请选择项目';
        }
        return '请选择冲刺';
      },
      mdPlaceholder() {
        if (!this.containerId) {
          return `选择${this.blogContainerName}后开始编辑`;
        }
        return '开始编辑';
      }
    },
    mounted() {
      const $app = this.$el;
      console.log($app.dataset.homeworks);
      this.homeworks = JSON.parse($app.dataset.homeworks);
      console.log(this.homeworks);

      this.type = $app.dataset.blogsType;
      this.blogsService = new BlogsService({
        blogsEndpoint: $app.dataset.blogsEndpoint
      });
      const navbar = document.getElementById('navbar');
      this.issuesService = new IssuesService({
        issuesEndpoint: navbar.dataset.issuesEndpoint
      });
      this.blog = new Blog(this.type);
      const $navbar = document.getElementById('navbar');
      let projects = JSON.parse($navbar.dataset.projects);
      for (let project of projects) {
        if (this.type === 'blog') {
          this.containers.push({
            id: project.id,
            name: project.name,
          });
        } else {
          let milestones = project.milestones;
          for (let milestone of milestones) {
            this.containers.push({
              id: `${project.id}-${milestone.id}`,
              name: milestone.title
            });
          }
        }
      }
      for (let homework of homeworks) {
        this.containers1.push({
          id: homework.id,
          name: homework.name,
        });
      }
    },
    methods: {
      createBlog() {
        this.$refs.newBlogForm.validate((valid) => {
          if (valid) {
            this.$refs.newBlogForm.$el.submit();
          }
        })
      },
      createBlogWithBurndown() {
        if (!this.isValid()) {
          return;
        }
        if (!this.milestone.start_date || !this.milestone.due_date) {
          this.alert('冲刺未设置开始日期或截止日期，无法生成燃尽图');
          return;
        }
        const params = {
          milestone: this.milestone.title,
          project: this.milestone.project_id
        };

        this.isChartButtonLoading = true;
        this.issuesService
          .all(params)
          .then(res => res.data)
          .then(data => {
            this.issues = data.issues;
            this.updateEchartsOption();
            this.burnOption.toolbox = {};
            this.chartVisible = true;
            this.isChartButtonLoading = false;
          })
      },
      createChart() {
        this.chartVisible = false;
        const base64 = this.$refs['burnChart'].getDataURL();
        const list = base64.split(',');
        const mime = list[0].match(/:(.+?);/)[1];
        let bstr = atob(list[1]), n = bstr.length, ia = new Uint8Array(n);
        while (n--) {
          ia[n] = bstr.charCodeAt(n);
        }
        const blob = new Blob([ia], {type: mime});
        this.uploadImage(blob);
      },
      uploadImage(blob) {
        let formData = new FormData();
        formData.append('image', blob);
        UploadService.upload(this.getProjectId(), formData)
          .then(res => res.data)
          .then((data) => {
            this.blog.code += `\n# 燃尽图\n![燃尽图](${data.url})`;
            this.$nextTick(() => {
              this.createBlog();
            })
          })
          .catch((e) => {
            this.alert('上传失败');
          });
      },
      isValid() {
        let res = null;
        this.$refs['newBlogForm'].validate((valid) => {
          res = !!valid;
        });
        return res;
      },
      choosehomework(containers1){
        this.blog.hw_id = containers1;
      },
      chooseContainer(container) {
        if (this.type === 'blog') {
          this.blog.project_id = container;
        }
        else {
          this.blog.project_id = parseInt(container.split('-')[0]);
          const milestoneId = parseInt(container.split('-')[1]);
          const $navbar = document.getElementById('navbar');
          const projects = JSON.parse($navbar.dataset.projects);
          let milestone = null;
          for (let project of projects) {
            milestone = project.milestones.find(
              (m) => m.id === milestoneId
            );
            if (milestone) {
              break;
            }
          }
          this.milestone = milestone;
        }
      },
      getProjectId() {
        return this.blog.project_id;
      }
    }
  });
});
<template>
  <div class="new-label">
    <el-form ref="newLabelForm" :model="label" :rules="rules" label-width="80px">
      <el-form-item label="项目" prop="projectId">
        <el-select v-model="label.projectId" placeholder="选择项目">
          <el-option v-for="(project, index) in projects"
                     :key="index" :label="project.name_with_namespace"
                     :value="project.id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="标题" prop="title">
        <el-input v-model="label.title"></el-input>
      </el-form-item>

      <el-form-item label="描述" prop="description">
	<md-wrapper v-model="label.description"
		:border="false" :box-shadow="false"
		:project-id="label.projectId"
		func="mini"
		:cant-save="true">
	</md-wrapper>
      </el-form-item>


    </el-form>
  </div>
</template>

<script>
  import Label from '../../issues/models/label'
  import Issue from '../../issues/models/issue'
  import DateMixin from './mixins/date_support'
  import AlertMixin from './mixins/alert'
  import mdWrapper from './md_wrapper.vue'
  import IssuesService from "../../issues/services/issues_service";

  export default {
    mixins: [DateMixin, AlertMixin],
    components: {
      mdWrapper
    },
    data() {
      return {
        projects: [],
        rules: {
          projectId: [
            {required: true, message: '请选择项目', trigger: 'change'}
          ],
          title: [
            {required: true, message: '请输入label', trigger: 'blur'}
          ],
        },
      }
    },
    props: {
      label: Label,
      issue: Issue,
    },
    mounted() {
      const $navbar = document.getElementById('navbar');
      const projects = JSON.parse($navbar.dataset.projects);

      for (let project of projects) {
        this.projects.push({
          id: project.id,
          name: project.name,
          name_with_namespace: project.name_with_namespace,
        });
      }
      const navbar = document.getElementById('navbar');
      this.issuesService = new IssuesService({
        issuesEndpoint: navbar.dataset.issuesEndpoint
      });
    },
    methods: {
    }
  }
</script>
<style>
  .new-label .el-date-editor.el-input {
    width: 100%;
  }
</style>
<style scoped>
  .new-label {
    min-width: 400px;
  }

  .full-width {
    width: 100%;
  }
</style>

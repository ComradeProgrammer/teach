<template>
	<div>
		<el-table
				:data="items"
				style="width: 100%">
			<el-table-column
					prop="name"
					label="组织名称"
					width="180">
			</el-table-column>
			<el-table-column
					prop="code"
					label="组织代号"
					width="180">
			</el-table-column>
			<el-table-column
					prop="token"
					label="组织令牌">
			</el-table-column>
			<el-table-column
					prop="description"
					label="组织简介">
			</el-table-column>
			<el-table-column label="操作">
				<template slot-scope="scope">
					<el-button
							size="mini"
							@click="handleEdit(scope.$index, scope.row)">编辑</el-button>
					<el-button
							size="mini"
							type="danger"
							@click="handleDelete(scope.$index, scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<el-dialog title="修改组织信息" :visible.sync="dialogFormVisible">
			<el-form :model="orgForm" :rules="rules" ref="orgForm" :action="dialogAction" method="post">
				<csrf></csrf>
				<el-form-item label="组织名称" prop="name">
					<el-input v-model="orgForm.name" name='org[name]' :placeholder="dialogOrg.name"></el-input>
				</el-form-item>
				<el-form-item label="组织代号" prop="code">
					<el-input v-model="orgForm.code" name='org[code]' :placeholder="dialogOrg.code"></el-input>
				</el-form-item>
				<el-form-item label="组织令牌" prop="token">
					<el-input v-model="orgForm.token" name='org[token]' :placeholder="dialogOrg.token"></el-input>
				</el-form-item>
				<el-form-item label="组织描述" prop="description">
					<el-input v-model="orgForm.description" name='org[description]' type="textarea" :placeholder="dialogOrg.description"></el-input>
				</el-form-item>
				<el-form-item>
					<el-button @click="resetForm('orgForm')">重置</el-button>
					<el-button type="primary" @click="submitForm('orgForm')">提交</el-button>
				</el-form-item>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click="dialogFormVisible=false">取消</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script>
	import Vue from 'vue/dist/vue.esm'
	import ElementUI from 'element-ui';
	import 'element-ui/lib/theme-chalk/index.css';
	import axios from 'axios/index';
	import csrf from '../../shared/components/csrf.vue';
	
	Vue.use(ElementUI);
	
	export default{
		//name: 'org_index',
		props:['org','action'],
		data(){
			return{
				items:[],
				dialogFormVisible:false,
				dialogOrg: {},
				dialogAction:"",
				orgForm: {
					name: '',
					code: '',
					token: '',
					description: ''
				},
				rules: {
					name: [
						{message: '请输入组织名称', trigger: 'blur'},
						{min: 2, max: 20, message: '组织名称长度必须为2到20字符', trigger: 'blur'}
					],
					code: [
						{message: '请输入组织代号', trigger: 'blur'},
						{min: 5, max: 5, message: '组织代号必须5个字符', trigger: 'blur'}
					],
					token: [
						{message: '请输入组织令牌', trigger: 'blur'},
						{min: 6, max: 16, message: '组织令牌必须为6到16个字符', trigger: 'blur'}
					]
				}
			}
		},
		components: {
			csrf,
		},
		mounted(){
			this.items=JSON.parse(this.org);
		},
		methods:{
            handleDelete:function(index,row){
            	axios.post('/organizations/'+row.id+'/destroy',{id:row.id});
				alert('删除成功！');
				window.location.assign(this.action);
                console.log(index, row.id);
            },
			handleEdit:function(index,row) {
				this.dialogOrg=row;
				this.dialogFormVisible=true;
				this.dialogAction=this.action+'/'+row.id;
			},
			submitForm: function (formName) {
				this.$refs[formName].validate((valid) => {
					if (valid) {
						console.log(this.dialogOrg);
						console.log(this.dialogAction);
						this.$refs[formName].$el.submit();
						alert('提交成功!');
						this.dialogFormVisible=false;
						window.location.assign(this.action);
					} else {
						console.log('error submit!!');
						alert('提交失败，请检查信息格式。');
						return false;
					}
				});
			},
			resetForm: function (formName) {
				this.$refs[formName].resetFields();
			}
        }
	}
</script>

<style>
</style>


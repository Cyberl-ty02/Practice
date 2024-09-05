<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>部门信息管理</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var operation;       // 操作变量类型（add还是edit）
        var deptcode;       // 记录被选中要编辑部门的编码，在点编辑按钮时使用
        //------------$(function ())开始--------------//
        $(function () {
            
	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    		$.post("SystemTestService?caozuo=add",
		    			$("#fm").serialize(),                        
		                function (data) {	                	
		                    var value=eval("("+data+")")
			            	if (value.ret == "0") {
			                	$.messager.alert("提示", "添加操作成功！", 'info');
			                    initdepartmentinfo();	                        
			                    return;
			                }else {
			                    $.messager.alert("提示",value.reason, 'info');
			                    return;
			                }             
		                });
	    	});	
	    	//编辑操作,弹出对话框
	    	$("#edit").click(function () {
	    	    var row=$('#departmentinfo').datagrid('getSelected');
	    	    if(row){
	    	        deptcode=row.deptcode;
	    	        $('#fm').form('clear');
	    	    	operation="edit";	    		    	    	    
	    			$('#dlgdepartmentinfo').dialog('open').dialog('center').dialog('setTitle','编辑部门信息');
	    			$("#deptcode").val(row.deptcode);
	    			$("#deptname").val(row.deptname);
	    			$("#phone").val(row.phone);
	    			$("#dutypeople").val(row.dutypeople);
	    			$("#dutyphone").val(row.dutyphone);
	    			$("#demo").val(row.demo);
	    	    }else{
	    	    	$.messager.alert("提示", "请选择要编辑的部门信息！", 'info');   
		            return;
	    	    }    		
	    	});	
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    	    if($("#deptcode").val()==""){
	    	    	$.messager.alert("提示", "部门编码不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#deptname").val()==""){
	    	    	$.messager.alert("提示", "部门名称不能为空！", 'info');
	              	return;
	    	    }	    	    
	    		if(operation=="add"){
	    			$.post("SystemTestService?caozuo=add",
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "添加操作成功！", 'info');
		                    initdepartmentinfo();	                        
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }             
	                });
	    		}else if(operation=="edit"){
	    			$.post("SystemDepartmentService?caozuo=edit&olddeptcode="+deptcode,
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "修改操作成功！", 'info');
		                    initdepartmentinfo();	                        
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }             
	                });
	    		}
	    	});
	    	//删除操作
	    	$("#delete").click(function(){
	    	    var row=$('#departmentinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的部门信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("SystemDepartmentService?caozuo=delete&deptcode=" +row.deptcode,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initdepartmentinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});
	    	
	    	//查询操作
	    	$("#query").click(function(){
	    		initdepartmentinfo();
	    	});    	
	    });
	    //-----------$(function ())结束------------//
	    
	    
	    //-----------自定义函数结束------------//
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:96%;">
     <div style="height:98%;">
         <!-- 标题部分开始   -->
	     <form id="frmDepartmentInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">部门信息</td>       
		                        <td>&nbsp;</td>
	                            <td align="right">&nbsp;</td>
	                            <td width="3">
	                                <img src="<%=basePath%>images/general/m_mpr.gif"  width="3" height="33" alt="" />
	                            </td>
		                    </tr> 	                                       
		                </table>
		        	</td>
		        </tr>
		     </table>
		 </form>
	     <!-- 标题部分结束 -->	
	                
	     <!-- 明细及工具栏信息开始 -->	 
	 	 <table id="departmentinfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>   			
	    			<th data-options="field:'deptcode',width:100,align:'center'">部门编码</th>								
					<th data-options="field:'deptname',width:250,align:'center'">部门名称</th>
					<th data-options="field:'phone',width:150,align:'center'">部门电话</th>
					<th data-options="field:'dutypeople',width:150,align:'center'">负责人</th>
					<th data-options="field:'dutyphone',width:150,align:'center'">负责人电话</th>					
					<th data-options="field:'demo',width:200,align:'center'">备注</th>			
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:5px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
				<a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>	
				<a id="edit" class="easyui-linkbutton" iconCls="icon-edit"  plain="true" >编 辑</a>						
				<a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>
			</div>
			<!-- 查询部分 -->
			<div>				
				&nbsp;部门编码: <input class="easyui-textbox"  id="qdeptcode" style="width:150px"></input>
			    &nbsp;&nbsp;部门名称: <input class="easyui-textbox" id="qdeptname" style="width:200px"></input>
			    &nbsp;&nbsp;负责人名称: <input class="easyui-textbox" id="qdutypeople" style="width:200px"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div>               	             
		        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlgdepartmentinfo" class="easyui-dialog" style="width:360px;height:310px;padding:10px 15px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">部门信息</div>
    	<form id="fm" method="post" novalidate>
	        <div class="fitem">
	            <label>部门编码:</label>
	            <input id="deptcode" name="deptcode"></input>
	        </div>
	        <div class="fitem">
	            <label>部门名称:</label>
	            <input id="deptname"  name="deptname"></input>
	        </div>
	        <div class="fitem">
	        	<label>部门电话:</label>
	        	<input id="phone" name="phone"/>
	        </div>
	        <div class="fitem">
	        	<label>负责人:</label>
	        	<input id="dutypeople" name="dutypeople"/>
	        </div>
	        <div class="fitem">
	        	<label>负责人电话:</label>
	        	<input id="dutyphone" name="dutyphone"/>
	        </div>
	        <div class="fitem">
	        	<label>备  注:</label>
	        	<input id="demo" name="demo"/>
	        </div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgdepartmentinfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
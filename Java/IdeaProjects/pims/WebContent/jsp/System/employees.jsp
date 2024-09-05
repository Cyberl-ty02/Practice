<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
session=request.getSession();
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>员工信息管理</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">        
        var operation; // 操作变量类型（add还是edit）
        var eno;       // 记录被选中要编辑模块的编码，在点编辑按钮时使用
        //------------$(function ())开始--------------//
        $(function () {
            $("#dtype").combobox({
            	url: 'SystemEmployeeService?caozuo=inittype',
            	valueField:'name',
            	textField:'name',
            	panelHeight:'auto',
            	onChange:function(){
                    var type=$("#dtype").combobox("getValue");                    
                    $("#ddepartment").combobox({
	           	        url: "SystemEmployeeService?caozuo=initdepartment&type="+type
                    });
                }
            });
            //初始化Combobox控件:上级模块（弹出对话框中的）
            $("#ddepartment").combobox({
            	url: 'SystemEmployeeService?caozuo=initdepartment',
                valueField: 'departmentid',
                textField: 'departmentname',
                panelHeight: 'auto'
            });
            //初始化Combobox控件:上级模块（弹出对话框中的）
            $("#department").combobox({
            	url: 'SystemEmployeeService?caozuo=initdepartment',
                valueField: 'departmentid',
                textField: 'departmentname',
                panelHeight: 'auto'
            });
            
            
            //初始化Combobox控件:职务（弹出对话框中的）
            $("#dduty").combobox({
            	url: 'SystemEmployeeService?caozuo=initcombobox&code=020',
                valueField: 'name',
                textField: 'name',
                panelHeight: 'auto'
            });
        
            //初始化Combobox控件:涉密等级（弹出对话框中的）
            $("#demployeessecretlevel").combobox({
            	url: 'SystemEmployeeService?caozuo=initcombobox&code=018',
                valueField: 'name',
                textField: 'name',
                panelHeight: 'auto'
            });
            //初始化DataGrid控件信息
            $("#employeeinfo").datagrid({
            	loadMsg: "数据加载中，请等待...",
            	iconCls: 'icon-issue',
                nowrap: false,                
                striped: true,
                collapsible: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                autoRowHeight: true,
                fitColumns: false,
                pageSize: 10,
                pageList: [10, 20, 30, 40],
                url: 'SystemEmployeeService?caozuo=init&con='+getQueryCondition()                        	
            });	
            
	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    	    operation="add";	    		    	    	    
	    		$('#dlgemployeeinfo').dialog('open').dialog('center').dialog('setTitle','添加员工信息');
	    		$('#fm').form('clear');
	    	});	
	    	//编辑操作,弹出对话框
	    	$("#edit").click(function () {
	    	    var row=$('#employeeinfo').datagrid('getSelected');
	    	    if(row){
	    	        eno=row.eno;
	    	        $('#fm').form('clear');
	    	    	operation="edit";	    		    	    	    
	    			$('#dlgemployeeinfo').dialog('open').dialog('center').dialog('setTitle','编辑员工信息');
	    			$("#deno").val(row.eno);
	    			$("#dename").val(row.ename);
	    			$("#dtype").combobox("setValue",row.type);
	    			$("#ddepartment").combobox("setValue",row.departmentid);
	    			$("#dduty").combobox("setValue",row.duty);
	    			
	    			$("#demployeessecretlevel").combobox("setValue",row.secretlevel);
	    			$("#demo").val(row.demo);
	    	    }else{
	    	    	$.messager.alert("提示", "请选择要编辑的员工信息！", 'info');   
		            return;
	    	    }    		
	    	});	
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    	    if($("#deno").val()==""){
	    	    	$.messager.alert("提示", "员工编码不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#dename").val()==""){
	    	    	$.messager.alert("提示", "员工名称不能为空！", 'info');
	              	return;
	    	    }	
	    	    
	    		if(operation=="add"){
	    			$.post("SystemEmployeeService?caozuo=add",
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "添加操作成功！", 'info');
		                    initinfo();	                        
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }             
	                });
	    		}else if(operation=="edit"){
	    			$.post("SystemEmployeeService?caozuo=edit&oldeno="+eno,
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "修改操作成功！", 'info');
		                    initinfo();	                        
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
	    	    var row=$('#employeeinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的员工信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("SystemEmployeeService?caozuo=del&eno=" +row.eno,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});
	    	
	    	//查询操作
	    	$("#query").click(function(){
	    		initemployeeinfo();
	    	});    	
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getQueryCondition(){
	        var condition="";
	        
	        if($("#ename").val()!=""){	        	
	        	condition="ename like '%"+$("#ename").val()+"%'";	        	
	        }
	        if($("#department").combobox('getValue')!=""){
		        var departmentid=$("#department").combobox('getValue');	        
		        if(departmentid!=""){
		           if(condition!=""){
		        		condition=condition+" and departmentid='"+departmentid+"'"
		        	}else{
		        		condition="departmentid='"+departmentid+"'";
		        	}
		        }	
	        } 	       
	    	return encodeURI(condition);
	    }
	    
	    function initinfo(){
	    	$("#employeeinfo").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'SystemEmployeeService?caozuo=init&con='+getQueryCondition()
            });
	    }
	    
	    //-----------自定义函数结束------------//
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:96%;">
     <div style="height:98%;">
         <!-- 标题部分开始   -->
	     <form id="frmModuleInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">员工信息</td>       
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
	 	 <table id="employeeinfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>   			
	    			<th data-options="field:'eno',width:100,align:'center'">员工编码</th>								
					<th data-options="field:'ename',width:150,align:'center'">员工名称</th>
					<th data-options="field:'departmentid',width:0,align:'center'">所属单位编码</th>
					<th data-options="field:'departmentname',width:180,align:'center'">所属单位</th>
					<th data-options="field:'duty',width:110,align:'center'">职务</th>
					<th data-options="field:'secretlevel',width:120,align:'center'">涉密等级</th>	
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
			    &nbsp;&nbsp;员工名称: <input class="easyui-textbox" id="ename" style="width:220px"></input>
			    &nbsp;&nbsp;所属单位: <input class="easyui-combobox" id="department" style="width:200px"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div>               	             
		        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlgemployeeinfo" class="easyui-dialog" style="width:360px;height:400px;padding:10px 10px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">员工信息</div>
    	<form id="fm" method="post" novalidate>
    	
	        <div class="fitem">
	            <label>员工编码:</label>
	            <input id="deno" name="deno"></input>
	        </div>
	        <div class="fitem">
	            <label>员工名称:</label>
	            <input id="dename"  name="dename"></input>
	        </div>
	        <div class="fitem">
	        	<label>单位类型:</label>
	        	<input id="dtype" name="dtype"/>
	        </div>
	        <div class="fitem">
	        	<label>所属单位:</label>
	        	<input id="ddepartment" name="ddepartment"/>
	        </div>
	        <div class="fitem">
	        	<label>职  务:</label>
	        	<input id="dduty" name="dduty"/>
	        </div>
	        <div class="fitem">
	        	<label>涉密等级:</label>
	        	<input id="demployeessecretlevel" name="demployeessecretlevel"/>
	        </div>
	        <div class="fitem">
	        	<label>备  注:</label>
	        	<input id="demo" name="demo"/>
	        </div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgemployeeinfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
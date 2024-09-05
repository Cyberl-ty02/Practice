<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>用户信息管理</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var operation; // 操作变量类型（add还是edit）
        var username;       // 记录被选中要编辑用户名称，在点编辑按钮时使用
        //------------$(function ())开始--------------//
        $(function () {
        	$("#dtype").combobox({
            	url: 'SystemEmployeeService?caozuo=inittype',
            	valueField:'name',
            	textField:'name',
            	panelHeight:'auto',
            	onChange:function(){
                    var type=$("#dtype").combobox("getValue");                    
                    $("#dunit").combobox({
	           	        url: "SystemUserService?caozuo=initunit&type="+type
                    });
                }
            });
            //初始化Combobox控件:分公司（查询条件中的）
            $("#unit").combobox({
            	url: 'SystemUserService?caozuo=initunit',
                valueField: 'departmentid',
                textField: 'departmentname',
                panelHeight: 'auto'
            });
            //初始化Combobox控件:单位（弹出对话框中的）
            $("#dunit").combobox({
            	url: 'SystemUserService?caozuo=initunit',
                valueField: 'departmentid',
                textField: 'departmentname',
                panelHeight: 'auto',
                onChange:function(){
                    var unitid=$("#dunit").combobox("getValue");
                	$("#demployee").combobox({
            	        url: 'SystemUserService?caozuo=initemployee&unitid='+unitid
            	    });
                }      
            });            
            
            //初始化Combobox控件:员工（弹出对话框中的）
            $("#demployee").combobox({
            	url: 'SystemUserService?caozuo=initemployee',
                valueField: 'ecode',
                textField: 'ename',
                //panelHeight: 'auto',
                onChange:function(){                    
                    var eno=$("#demployee").combobox("getValue");
                    if(eno!="00000000")
                       $("#dusername").val(eno);
                }
            });
            //初始化Combobox控件:角色（查询条件中）
            $("#role").combobox({
            	url: 'SystemUserService?caozuo=initrole',
                valueField: 'rolename',
                textField: 'rolename',
                panelHeight: 'auto'
            });
            //初始化Combobox控件:角色（弹出对话框中的）
            $("#drole").combobox({
            	url: 'SystemUserService?caozuo=initrole',
                valueField: 'rolename',
                textField: 'rolename',
                panelHeight: 'auto'
            });
            //初始化DataGrid控件信息
            $("#Usersinfo").datagrid({
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
                url: 'SystemUserService?caozuo=init&con='+getQueryCondition()                           	
            });	
            
	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    	    operation="add";	    		    	    	    
	    		$('#dlguserinfo').dialog('open').dialog('center').dialog('setTitle','添加用户信息');
	    		$('#fm').form('clear');
	    	});	
	    	//编辑操作,弹出对话框
	    	$("#edit").click(function () {
	    	    var row=$('#Usersinfo').datagrid('getSelected');
	    	    if(row){
	    	        username=row.username;
	    	        $('#fm').form('clear');
	    	    	operation="edit";	    		    	    	    
	    			$('#dlguserinfo').dialog('open').dialog('center').dialog('setTitle','编辑用户信息');	    			
	    			//$("#dusername").val(row.username);
	    			$("#dunit").combobox("setValue",row.unitid);
	    			$("#demployee").combobox("setValue",row.eno);
	    			
	    			$("#drole").combobox("setValue",row.rolename);
	    			$("#dusername").val(row.username);
	    			$("#demo").val(row.demo);
	    	    }else{
	    	    	$.messager.alert("提示", "请选择要编辑的员工信息！", 'info');   
		            return;
	    	    }    		
	    	});	
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    	    if($("#dusername").val()==""){
	    	    	$.messager.alert("提示", "用户名称不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#demployee").combobox("getText")==""){
	    	    	$.messager.alert("提示", "员工信息不能为空！", 'info');
	              	return;
	    	    }
	    	    /*
	    	    if($("#drole").combobox("getText")==""){
	    	    	$.messager.alert("提示", "所属角色不能为空！", 'info');
	              	return;
	    	    }  */  	    
	    		if(operation=="add"){
	    			$.post("SystemUserService?caozuo=add",
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "添加操作成功！", 'info');
		                    initUserinfo();	                        
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }             
	                });
	    		}else if(operation=="edit"){
	    			$.post("SystemUserService?caozuo=edit&oldusername="+username,
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "修改操作成功！", 'info');
		                    initUserinfo();	                        
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
	    	    var row=$('#Usersinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的员工信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("SystemUserService?caozuo=del&username=" +row.username,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initUserinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});
	    	//密码重置操作
	    	$("#reset").click(function(){
	    	    var row=$('#Usersinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要密码重置的员工！", 'info');   
		            return;
	    		}	    		
         	    $.post("SystemUserService?caozuo=resetpassword&username=" +row.username,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initUserinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});
	    	//密码重置操作
	    	$("#unlock").click(function(){
	    	    var row=$('#Usersinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要解锁的员工！", 'info');   
		            return;
	    		}	    		
         	    $.post("SystemUserService?caozuo=unlock&username=" +row.username,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initUserinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});
	    	
	    	//查询操作
	    	$("#query").click(function(){
	    		initUserinfo();
	    	});    	
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getQueryCondition(){
	        var condition="";
	        if($("#unit").combobox('getText')!=""){
	        	condition="unitname='"+$("#unit").combobox("getText")+"'";
	        }
	        
	        if($("#employee").val()!=""){
		        var ename=$("#employee").val();	        
		        if(ename!=""){
		           if(condition!=""){
		        		condition=condition+" and ename like '%"+ename+"%'"
		        	}else{
		        		condition="ename like '%"+ename+"%'"
		        	}
		        }	
	        }
	        if($("#role").combobox('getText')!=""){
		        var role=$("#role").combobox('getValue');	        
		        if(role!=""){
		           if(condition!=""){
		        		condition=condition+" and rolename='"+role+"'"
		        	}else{
		        		condition="rolename='"+role+"'";
		        	}
		        }	
	        }	               	               
	    	return encodeURI(condition);
	    }
	    
	    function initUserinfo(){	        
	    	$("#Usersinfo").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'SystemUserService?caozuo=init&con='+getQueryCondition()
            });
	    }
	    
	    //-----------自定义函数结束------------//
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:96%;">
     <div style="height:98%;">
         <!-- 标题部分开始   -->
	     <form id="frmUserInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">用户信息</td>       
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
	 	 <table id="Usersinfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>	    		    			
	    			<th data-options="field:'username',width:100,align:'center'">用户名</th>
	    			<th data-options="field:'unitid',width:200,align:'center'">所属部门ID</th>
	    			<th data-options="field:'unitname',width:200,align:'center'">所属部门</th>
	    			<th data-options="field:'eno',width:180,align:'center',hidden:'true'">员工编码</th>							
					<th data-options="field:'ename',width:150,align:'center'">员工姓名</th>
					<th data-options="field:'type',width:100,align:'center'">用户类型</th>
					<th data-options="field:'rolename',width:150,align:'center',hidden:'true'">所属角色</th>
					<th data-options="field:'status',width:100,align:'center'">状态</th>
					<th data-options="field:'demo',width:150,align:'center'">备注</th>						
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:5px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
				<a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>	
				<a id="edit" class="easyui-linkbutton" iconCls="icon-edit"  plain="true" >编 辑</a>						
				<a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>
				<a id="reset" class="easyui-linkbutton" iconCls="icon-password" plain="true">密码重置</a>
				<a id="unlock" class="easyui-linkbutton" iconCls="icon-password" plain="true">解锁用户</a>
			</div>
			<!-- 查询部分 -->
			<div>
			    &nbsp;所属部门: <input class="easyui-textbox"  id="unit" style="width:180px"></input>			    
			   
			    &nbsp;&nbsp;员工名称: <input class="easyui-textbox" id="employee" style="width:160px"></input>
			    &nbsp;&nbsp;所属角色: <input class="easyui-combobox" id="role" style="width:160px"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div>               	             
		        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlguserinfo" class="easyui-dialog" style="width:380px;height:320px;padding:10px 10px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">用户信息</div>
    	<form id="fm" method="post" novalidate>
    		<div class="fitem">
	            <label>单位类型:</label>
	            <input id="dtype"  name="dtype"></input>
	        </div>
	        <div class="fitem">
	            <label>所属部门:</label>
	            <input id="dunit"  name="dunit"></input>
	        </div>
	        <div class="fitem">
	            <label>员工名称:</label>
	            <input id="demployee"  name="demployee"></input>
	        </div>
	        <div class="fitem">
	            <label>用户名称:</label>
	            <input id="dusername" name="dusername"></input>
	        </div>
	        <!-- 
	        <div class="fitem">
	        	<label>所属角色:</label>
	        	<input id="drole" name="drole"/>
	        </div>
	        -->
	        
	        <div class="fitem">
	        	<label>备  注:</label>
	        	<input id="demo" name="demo"/>
	        </div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlguserinfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>" />
    <title>合同经费拨付情况</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var uid;
    	$(function(){
    		
    		//初始化DataGrid控件信息
            $("#info").datagrid({
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
                url: "ProjectContractFundsBoFuService?caozuo=init&con="+""
            });
            //合同项目信息
        	$("#dcontractno").combogrid({
        		panelWidth:610,	               
                idField:"contractno",
                textField:"contractprojectname",
                url:"ProjectContractFundsBoFuService?caozuo=initcontract",
                mode:'remote',
                fitColumns:false,
                multiple:false,
                panelHeight:'auto',
                columns:[[
               		{field:'contractno',title:'合同编码',width:200,align:'center'},
               		{field:'contractprojectname',title:'合同项目名称',width:300,align:'center'},
               		{field:'department',title:'承研单位',width:200,align:'center'}
                ]]
        	});
	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    	    operation="add";	    		    	    	    
	    		$('#dlginfo').dialog('open').dialog('center').dialog('setTitle','添加拨付信息');
	    		$('#fm').form('clear');
	    	});	
	    	//编辑操作,弹出对话框
	    	$("#edit").click(function () {
	    	    var row=$('#info').datagrid('getSelected');
	    	    if(row){
	    	        uid=row.uid;
	    	        $('#fm').form('clear');
	    	    	operation="edit";	    		    	    	    
	    			$('#dlginfo').dialog('open').dialog('center').dialog('setTitle','编辑拨付信息');
	    			$("#dcontractno").combogrid("setValue",row.contractno);
	    			//$("#dcontractprojectname").textbox("setValue",row.contractprojectname);
	    			$("#ddate").datebox("setValue",row.date);
	    			$("#dvalue").textbox("setValue",row.value);
	    	    }else{
	    	    	$.messager.alert("提示", "请选择要编辑的拨付信息！", 'info');   
		            return;
	    	    }    		
	    	});	
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    	    if($("#dcontractno").val()==""){
	    	    	$.messager.alert("提示", "合同编码不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#ddate").val()==""){
	    	    	$.messager.alert("提示", "所属年度不能为空！", 'info');
	              	return;
	    	    }	    	    
	    		if(operation=="add"){
	    			$.post("ProjectContractFundsBoFuService?caozuo=add",
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
	    			$.post("ProjectContractFundsBoFuService?caozuo=edit&uid="+uid,
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
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的模块信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("ProjectContractFundsBoFuService?caozuo=del&uid=" +row.uid,                        
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
	    		initinfo();
	    	});    	
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getcon(){
	        var condition="";
	        if($("#contractprojectname").val()!=""){
	        	condition="contractprojectname like '%"+$("#contractprojectname").textbox("getValue")+"%'";
	        }
	                
	    	return encodeURI(condition);
	    }
	    
	    function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'ProjectContractFundsBoFuService?caozuo=init&con='+getcon()
            });
	    }
	    
	    //-----------自定义函数结束------------//
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:96%;">
     <div style="height:98%;">
         <!-- 标题部分开始   -->
	     <form id="frmInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">合同经费拨付信息</td>       
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
	 	 <table id="info" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>
	    			<th data-options="field:'uid',width:150,align:'center',hidden:'true'">uid</th>
	    			<th data-options="field:'contractno',width:250,align:'center'">合同编码</th>								
					<th data-options="field:'contractprojectname',width:350,align:'center'">合同项目名称</th>
					<th data-options="field:'date',width:150,align:'center'">拨付日期</th>
					<th data-options="field:'value',width:200,align:'center'">拨付经费金额（万元）</th>
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
				&nbsp;合同项目名称: <input class="easyui-textbox"  id="contractprojectname" style="width:250px"></input>
			   
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div>               	             
		        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlginfo" class="easyui-dialog" style="width:650px;height:300px;padding:10px 10px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">经费拨付信息</div>
    	<form id="fm" method="post" novalidate>
	        <div class="fitem1">
	            <label>合同项目:</label>
	            <input class="easyui-combogrid" id="dcontractno"  name="dcontractno"></input>
	        </div>
	        <!-- 
	        <div class="fitem1">
	            <label>合同项目名称:</label>
	            <input class="easyui-textbox" id="contractprojectname"  name="contractprojectname"></input>
	        </div>
	        -->
	        <div class="fitem1">
	            <label>拨付时间:</label>
	            <input class="easyui-datebox" id="ddate"  name="ddate"></input>
	        </div> 
	        <div class="fitem1">
	            <label>拨付经费（万元）:</label>
	            <input class="easyui-textbox" id="dvalue"  name="dvalue"></input>
	        </div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
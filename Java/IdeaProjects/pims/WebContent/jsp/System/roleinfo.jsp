<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>" />   
    <title>角色权限</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var uid;
        var oldname;
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
                url: "SystemRoleInfoService?caozuo=init&con="+getQueryCondition(),
                onClickRow: function (rowIndex, rowData) {
                    var row = $("#info").datagrid("getSelected");                   
                    name = row.rolename;
                    oldname=name;                   
                    $("#rolename").textbox('setText',name);
                    $("#demo").textbox('setText',row.demo);
                }                       	
            });
            //对话框中的保存按钮操作:完成添加操作
	    	$("#add").click(function(){
	    	    if($("#rolename").textbox("getText")==""){
	    	    	$.messager.alert("提示", "角色名称不能为空！", 'info');
	              	return;
	    	    }
	    	    	    
	   			$.post("SystemRoleInfoService?caozuo=add&rolename="+encodeURI($("#rolename").textbox("getText"))+"&demo="+$("#demo").textbox("getText"),	   			                        
                function (data) {	                	
		            var value=eval("("+data+")")
		        	if (value.ret == "0") {
		            	$.messager.alert("提示", "添加操作成功！", 'info');
		            	refresh();
		                initinfo();	                        
		                return;
		            }else {
		                $.messager.alert("提示",value.reason, 'info');
		                return;
		            }             
	            });	    		
	    	});
	    	//删除操作
	    	$("#delete").click(function(){
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("SystemRoleInfoService?caozuo=del&rolename="+row.rolename,
	            function (data) {
         	    	var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                	refresh();
	                    initinfo();	                        
	                    return;
	                }else {
	                	$.messager.alert("提示", "本次操作失败！原因："+value.reason, 'info');
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
	    function getQueryCondition(){
	        var condition="";
	        if($("#rolename").textbox("getText")!=""){
	        	condition="rolename like '%"+$("#rolename").textbox("getText")+"%'";
	        }	        	        
	    	return encodeURI(condition);
	    }
	    
    	function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: "SystemRoleInfoService?caozuo=init&con="+getQueryCondition()
            });
	    }
	    
	    function refresh(){	    	
	    	$("#rolename").textbox("setText","");
	    	$("#demo").textbox("setText","");
	    }
    </script>    
  </head>  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:98%;">
     <div style="height:100%;">
     <div style="height:100%;">
         <!-- 标题部分开始   -->
	     <form id="frmModuleInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">角色管理</td>       
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
	    		    <th data-options="field:'rolename',width:250,align:'center'">角色名称</th> 	
	    		    <th data-options="field:'demo',width:250,align:'center'">角色说明</th>	
	    			
	    		</tr>
	    	</thead>
	    </table>	 
	    <div id="tb" style="padding:5px;height:auto">	        
			<!-- 查询部分 -->
			<div style="margin-top:10px;margin-bottom:5px">	
			    &nbsp;&nbsp;&nbsp;角色名称: <input class="easyui-textbox"  id="rolename" style="width:200px"></input>	
			    &nbsp;&nbsp;&nbsp;角色说明: <input class="easyui-textbox"  id="demo" style="width:200px"></input>		
			</div>
			<!-- 按钮部分 -->
			<div style="margin-bottom:5px">
				<a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>					
				<a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>	
				<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>			
			</div>
		 </div>
	 </div>   
  </body>
</html>

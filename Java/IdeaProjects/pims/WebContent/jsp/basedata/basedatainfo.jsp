<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>" />   
    <title>基础数据类别</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var oldcode;
    	$(function(){
    		$("#validation").combobox({
    			panelHeight:'auto'
    		});
    		
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
                url: "BaseDataInfoService?caozuo=init&con="+"",
                onClickRow: function (rowIndex, rowData) {
                    var row = $("#info").datagrid("getSelected");
                    code=row.code;
                    name = row.name;
                    oldcode=code; 
                    $("#code").textbox('setText',code);
                    $("#name").textbox('setText',name);
                }                       	
            });
            //对话框中的保存按钮操作:完成添加操作
	    	$("#add").click(function(){
	    	    if($("#name").val()==""){
	    	    	$.messager.alert("提示", "名称不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#code").val()==""){
	    	    	$.messager.alert("提示", "编码不能为空！", 'info');
	              	return;
	    	    }	    	    
	   			$.post("BaseDataInfoService?caozuo=add&name="+$("#name").val()+"&code="+$("#code").val(),	   			                        
                function (data) {	                	
		            var value=eval("("+data+")")
		        	if (value.ret == "0") {
		            	$.messager.alert("提示", "添加操作成功！", 'info');
		            	refresh();
		                initbasedatainfo();	                        
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
         	    $.post("BaseDataInfoService?caozuo=del&code=" +row.code,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                	refresh();
	                    initbasedatainfo();	                        
	                    return;
	                }else {
	                	$.messager.alert("提示", "本次操作失败！原因："+value.reason, 'info');
	                    return;
	                }             
	             });
	    	});
	    	//编辑操作
	    	$("#edit").click(function(){
	    		if($("#code").textbox('getText')==""){
	    	    	$.messager.alert("提示", "编码不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#name").textbox('getText')==""){
	    	    	$.messager.alert("提示", type+"名称不能为空！", 'info');
	              	return;
	    	    } 		
         	    $.post("BaseDataInfoService?oldcode="+oldcode+"&caozuo=edit&name="+$("#name").textbox('getText')+"&code="+$("#code").textbox("getText"),                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                	refresh();
	                    initbasedatainfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！原因："+value.reason, 'info');
	                    return;
	                }             
	             });
	    	});	 
	    	//查询操作
	    	$("#query").click(function(){
	    		initbasedatainfo();
	    	});   	
    	});
    	//-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getQueryCondition(){
	        var condition="";
	        if($("#name").textbox("getText")!=""){
	        	condition="name like '%"+$("#name").textbox("getText")+"%'";
	        }
	        if($("#code").textbox("getText")!=""){
	        	if(condition!=""){
	        		condition=condition+" and code='"+$("#code").textbox("getText")+"'"
	        	}else{
	        		condition="code='"+$("#code").textbox("getText")+"'";
	        	}
	        }
	    	return encodeURI(condition);
	    }
	    
    	function initbasedatainfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: "BaseDataInfoService?caozuo=init&con="+getQueryCondition()
            });
	    }
	    
	    function refresh(){
	    	$("#code").textbox("setText","");
	    	$("#name").textbox("setText","");
	    }
    </script>    
  </head>  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:98%;">
     <div style="height:100%;"> 	
    	<!-- 明细及工具栏信息开始 -->	 
	 	<table id="info" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>   	
	    		    <th data-options="field:'code',width:250,align:'center'">类别编码</th>			
	    			<th data-options="field:'name',width:250,align:'center'">类别名称</th>						
	    		</tr>
	    	</thead>
	    </table>	 
	    <div id="tb" style="padding:5px;height:auto">	        
			<!-- 查询部分 -->
			<div style="margin-top:10px;margin-bottom:5px">	
			    &nbsp;&nbsp;&nbsp;类别编码: <input class="easyui-textbox"  id="code" style="width:200px"></input>			
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;类别名称: <input class="easyui-textbox"  id="name" style="width:200px"></input>		    											
			</div>
			<!-- 按钮部分 -->
			<div style="margin-bottom:5px">
				<a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>	
				<a id="edit" class="easyui-linkbutton" iconCls="icon-edit"  plain="true" >编 辑</a>						
				<a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>	
				<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>			
			</div>
		 </div>
	 </div>   
  </body>
</html>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>" />   
    <title>基础数据信息</title>
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
    		//初始化Combobox控件:所属类别
            $("#type").combobox({
            	url: 'BaseDataService?caozuo=inittype',
                valueField: 'code',
                textField: 'name',
                panelHeight: 'auto',
                editable:true
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
                url: "BaseDataService?caozuo=init&con="+"",
                onClickRow: function (rowIndex, rowData) {
                    var row = $("#info").datagrid("getSelected");
                    uid=row.uid;
                    name = row.name;
                    oldname=name;
                    code=row.code;
                    oldcode=code; 
                    $("#name").textbox('setText',name);
                    $("#type").combobox('setValue',code);
                }                       	
            });
            //对话框中的保存按钮操作:完成添加操作
	    	$("#add").click(function(){
	    	    if($("#name").val()==""){
	    	    	$.messager.alert("提示", "名称不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#type").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "类别不能为空！", 'info');
	              	return;
	    	    }	    	    
	   			$.post("BaseDataService?caozuo=add&validation="+encodeURI($("#validation").combobox("getText"))+"&name="+encodeURI($("#name").val())+"&code="+$("#type").combobox("getValue"),	   			                        
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
         	    $.post("BaseDataService?caozuo=del&uid=" +row.uid,                        
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
	    		if($("#type").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "类别不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#name").textbox('getText')==""){
	    	    	$.messager.alert("提示", "名称不能为空！", 'info');
	              	return;
	    	    }
         	    $.post("BaseDataService?oldname="+oldname+"&validation="+encodeURI($("#validation").combobox("getText"))+"&caozuo=edit&uid="+uid+"&name="+encodeURI($("#name").textbox('getText'))+"&code="+$("#type").combobox("getValue"),                        
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
	        var code=$("#type").combobox("getValue");
	        if(code!=""){
	        	if(condition!=""){
	        		condition=condition+" and code='"+code+"'"
	        	}else{
	        		condition="code='"+code+"'";
	        	}
	        }
	    	return encodeURI(condition);
	    }
	    
    	function initbasedatainfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: "BaseDataService?caozuo=init&con="+getQueryCondition()
            });
	    }
	    
	    function refresh(){	    	
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
	    		    <th data-options="field:'uid',width:250,align:'center',hidden:'true'">uid</th>
	    		    <th data-options="field:'name',width:250,align:'center'">数据名称</th> 	
	    		    <th data-options="field:'code',width:250,align:'center',hidden:'true'">类别编码</th>	
	    		    <th data-options="field:'type',width:250,align:'center'">所属类别</th>	
	    		    <th data-options="field:'validation',width:150,align:'center'">是否有效</th>	
	    		    				
	    		</tr>
	    	</thead>
	    </table>	 
	    <div id="tb" style="padding:5px;height:auto">	        
			<!-- 查询部分 -->
			<div style="margin-top:10px;margin-bottom:5px">	
			    &nbsp;&nbsp;&nbsp;数据名称: <input class="easyui-textbox"  id="name" style="width:200px"></input>			
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;所属类别: <input class="easyui-combobox"  id="type" style="width:200px"></input>
				&nbsp;&nbsp;是否有效: 
			    <select class="easyui-combobox" id="validation" style="width:160px;">
			        <option value="是">是</option>
			        <option value="否">否</option>
			    </select>		    											
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

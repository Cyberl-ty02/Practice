<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>数据管理</title>
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
            
            //初始化DataGrid控件信息
            $("#tableinfo").datagrid({
            	loadMsg: "数据加载中，请等待...",
            	iconCls: 'icon-issue',
                nowrap: false,                
                striped: true,
                collapsible: true,
                rownumbers: true,
               
                singleSelect: false,
                autoRowHeight: true,
                fitColumns: false,
               
                url: 'SystemDataService?caozuo=init'                        	
            });
            //删除操作
	    	$("#delete").click(function(){
	    	    var rows=$("#tableinfo").datagrid("getSelections");	    	    
	    		if(rows=="" || rows==null){
	    			$.messager.alert("提示", "请选择要删除的数据的表信息！", 'info');   
		            return;
	    		}  		
         	    $.post("SystemDataService?caozuo=delete&data=" +encodeURI(JSON.stringify(rows)),                        
	            
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initdatainfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});	
            
	    	//查询操作
	    	$("#query").click(function(){
	    		initdatainfo();
	    	});    	
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    function initdatainfo(){
	    	$("#tableinfo").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'SystemDataService?caozuo=init'
            });
	    }
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
		                        <td id="title_id" class="place" align="left">系统数据</td>       
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
	 	 <table id="tableinfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:false,toolbar:'#tb'">
	    	<thead>
	    		<tr>
	    		    <th data-options="field:'ck',checkbox:true"></th>  			
	    			<th data-options="field:'tablename',width:200,align:'center'">表 名</th>
	    			<th data-options="field:'count',width:200,align:'center'">记录数量</th>				
					<th data-options="field:'demo',width:200,align:'center'">备注</th>			
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:5px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">					
				<a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除数据</a>
			</div>
			<!-- 查询部分 -->
			<div>				
				&nbsp;样品编码: <input class="easyui-textbox"  id="sampleid" style="width:150px"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div>               	             
	
  </body>
</html>
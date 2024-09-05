<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>日志信息</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        
        //------------$(function ())开始--------------//
        $(function () {            
            //初始化DataGrid控件信息
            $("#loginfo").datagrid({
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
                url: "LogService?caozuo=init"                       	
            });
            //查询操作
	    	$("#query").click(function(){
	    		initloginfo();
	    	});
	    	//下载资料操作，弹出对话框
	    	$("#print").click(function () {	    		
	    		$("#fm").attr("action","LogService?caozuo=print&con="+getQueryCondition());
    			$("#fm").submit();
	    	});
	    	//下载文件成功提示
	    	$('#fm').form({
                success:function(data){                   
                   var value=eval("("+data+")")
		           if (value.ret == "0") {           
                       $.messager.alert("提示", "操作成功！", 'info');
                       return;
                   }else{
                	   var reason=value.reason;
                       $.messager.alert("提示", "操作失败,原因:"+reason, 'info');
                       return;
                   }
                }
            });
         }) 
         //获得查询条件
	     function getQueryCondition(){
	        var condition="";
	        var condition="";
	       
	        strBeginDate=$("#begindate").datebox('getText');
            strEndDate=$("#enddate").datebox('getText');
            if(strBeginDate!="" && strEndDate!=""){
                if(condition==""){
                    condition = "logindate>='" + strBeginDate+"' and logindate<='"+strEndDate+"'";
                }
                else {
                    condition = condition + "  and (logindate>='" + strBeginDate + "' and logindate<='"+strEndDate+"')";
                }
            }                  	               
	    	return encodeURI(condition);
	     }
	    
	     function initloginfo(){
	    	$("#loginfo").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'LogService?caozuo=init&con='+getQueryCondition()
            });
	     } 
                   
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:96%;">
     <div style="height:98%;">
         <!-- 标题部分开始   -->
	     <form id="frmEnstoreInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">日志信息</td>       
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
	     <div style="height:10px;"></div>          
	     <!-- 明细及工具栏信息开始 -->	 
	 	 <table id="loginfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr> 
	    		    <th data-options="field:'uid',width:90,align:'center',hidden:'true'">uid</th>  			
	    			<th data-options="field:'logindate',width:150,align:'center'">日 期</th>
	    			<th data-options="field:'logintime',width:150,align:'center'">时 间</th>	
	    			<th data-options="field:'username',width:150,align:'center'">用户名</th>
	    			<th data-options="field:'ename',width:150,align:'center'">员工名称</th>					
					<th data-options="field:'ip',width:160,align:'center'">IP地址</th>
					<th data-options="field:'operation',width:220,align:'center'">操作</th>
					<th data-options="field:'successflag',width:120,align:'center'">是否成功</th>
										
	    		</tr>
	    	</thead>
	     </table>	
	     <div id="tb" style="padding:5px;height:auto">
	       
			<!-- 查询部分 -->
			<div>			  
			    &nbsp;日期从: <input class="easyui-datebox" id="begindate" style="width:150px"></input>
			    &nbsp;至: <input class="easyui-datebox" id="enddate" style="width:150px"></input>
				&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>
				&nbsp;<a id="print" class="easyui-linkbutton" iconCls="icon-print" plain="true">输 出</a>							
			</div>
		 </div>     
	</div>   	             
	<form id="fm" action="" method="post">
	</form>
  </body>
</html>
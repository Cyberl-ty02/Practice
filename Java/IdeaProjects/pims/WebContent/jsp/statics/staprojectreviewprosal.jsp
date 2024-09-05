<%@page import="com.tjut.util.WebUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String projectcode=WebUtil.getRequestParam(request, "projectcode");
	String unitid=WebUtil.getRequestParam(request, "unitid");
%>
<!DOCTYPE html>
<html>
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>项目建议书</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var operation; // 操作变量类型（add还是edit）
        var uid;       // 记录被选中要编辑模块的编码，在点编辑按钮时使用
        var subtype;
        var projectcode;
        var unitid;
        //------------$(function ())开始--------------//
        $(function () {
        	projectcode="<%=projectcode%>";
        	unitid="<%=unitid%>";
        	
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
                url: 'ProjectProposalService?caozuo=init&con='+getcon()
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
	    	//查询操作
	    	$("#query").click(function(){
	    		initinfo();
	    	}); 
	    	
	    	//下载资料操作，弹出对话框
	    	$("#worddownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=word&uid="+row.uid);
    			$("#fm1").submit();
	    	});
	    	$("#pdfdownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=pdf&uid="+row.uid);
    			$("#fm1").submit();
	    	});
	    	$("#expertopiniondownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=expertopinion&uid="+row.uid);
    			$("#fm1").submit();
	    	});
	    	//下载文件成功提示
	    	$('#fm1').form({
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
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getcon(){
	    	
	        var condition="";
	        var temp="";	       
	        var con="projectcode='"+projectcode+"' and unitid='"+unitid+"'";	     
	    	return encodeURI(con);
	    }
	    
	    function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'ProjectProposalService?caozuo=init&con='+getcon()
            });
	    }
	    
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:99%;">
     <div style="height:96%;">
         
	     <!-- 明细及工具栏信息开始 -->
	 	 <table id="info" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>
	    			<th data-options="field:'uid',width:120,align:'center',hidden:'true'">uid</th>
	    			<th data-options="field:'edition',width:120,align:'center'">版 本</th>	
	    			<th data-options="field:'prosalname',width:250,align:'center'">建议书名称</th>			
					<th data-options="field:'unitid',width:120,align:'center',hidden:'true'">单位编码</th>	
					<th data-options="field:'unitname',width:250,align:'center'">单位名称</th>	
					<th data-options="field:'projectcode',width:120,align:'center'">项目编码</th>	
					<th data-options="field:'projectname',width:250,align:'center'">项目名称</th>
					<th data-options="field:'researchtarget',width:300,align:'left',hidden:'true'">研究目标</th>	    			
					<th data-options="field:'researchcontent',width:300,align:'left',hidden:'true'">研究内容</th>
					<th data-options="field:'technicalindex',width:300,align:'left',hidden:'true'">技术指标</th>	    			
					<th data-options="field:'projectachievment',width:300,align:'left',hidden:'true'">项目成果</th>	
					<th data-options="field:'funds',width:100,align:'center'">经 费（万元）</th>
					<th data-options="field:'wordfilename',width:250,align:'center'">word文档</th>	
					<th data-options="field:'pdffilename',width:250,align:'center'">pdf文档</th>
					<th data-options="field:'reviewdate',width:90,align:'center'">评审时间</th>
					<th data-options="field:'expertopinionfilename',width:250,align:'center'">专家意见文档</th>
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:10px;height:auto">
	     	<div style="margin-bottom:5px">
			   <form id="fm1" action="" method="post">				 
				 &nbsp;&nbsp;<a id="worddownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载word版</a>
				 &nbsp;&nbsp;<a id="pdfdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载pdf版</a>
				 &nbsp;&nbsp;<a id="expertopiniondownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载专家意见书</a>										
			   </form>
			</div>			
		 </div>
	</div>               	             
	
  </body>
</html>
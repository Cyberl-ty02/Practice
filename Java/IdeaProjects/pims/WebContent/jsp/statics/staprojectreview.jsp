<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
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
        	$("#projectreviewinfo").tabs({
		        onSelect: function () {
		            openTab(projectcode,unitid);
		        }
		    });        	
        	$("#qunit").combobox({
        		url: 'ProjectProposalService?caozuo=initunit',
                valueField: 'unitid',
                textField: 'unitname',
                panelHeight: 'auto',
                editable:true
        	});	
        	$("#qproject").combobox({
        		url: 'ProjectProposalService?caozuo=initproject',
                valueField: 'projectcode',
                textField: 'projectname',
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
                url: 'ProjectContractService?caozuo=init&con='+getcon()
            });	
            
	        //立项评审操作，弹出对话框
	    	$("#queryinfo").click(function () {	 
	    		var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要查看的合同立项评审信息！", 'info');   
		            return;
	    		}
	    		var contractno=row.contractno;
	    		var contractname=row.contractname;
	    		unitid=row.unitid;
	    		var unitnamename=row.unitname;
	    		projectcode=row.projectcode;
	    		var projectname=row.projectname;
	    		$('#dlginfo').dialog('open').dialog('center').dialog('setTitle','合同立项评审情况');
	    		
	    		$("#projectreviewinfo").tabs('select',1);
	    		$("#projectreviewinfo").tabs('select',0);	    		
	    		openTab(projectcode,unitid);	    		
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
	        	        
	        if($("#qunit").combobox("getValue")!=""){
	        	temp=$("#qunit").combobox("getValue");
		        if(condition!=""){
	        		condition=condition+" and unitid='"+temp+"'";
	            }else{
	        		condition="unitid='"+temp+"'";
	            }
	        }
	        if($("#qproject").combobox("getValue")!=""){
	        	temp=$("#qproject").combobox("getValue");
		        if(condition!=""){
	        		condition=condition+" and projectcode='"+temp+"'";
	            }else{
	        		condition="projectcode='"+temp+"'";
	            }	
	        }	       
	    	return encodeURI(condition);
	    }
	    
	    function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'ProjectContractService?caozuo=init&con='+getcon()
            });
	    }
	    
	    function openTab(projectcode,unitid) {
		    var tab = $("#projectreviewinfo").tabs('getSelected');
		    var tbId = tab.attr("id");
		    var tbIframe = $("#" + tbId + " iframe:first-child");
		    tbIframe.attr("src", "<%=basePath%>jsp/statics/"+tbId+".jsp?projectcode="+projectcode+"&unitid="+unitid);          
		}
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:99%;">
     <div style="height:96%;">
         <!-- 标题部分开始   -->
         
	     <form id="frmModuleInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">项目建议书</td>       
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
	    			<th data-options="field:'uid',width:120,align:'center',hidden:'true'">uid</th>
	    			<th data-options="field:'contractno',width:120,align:'center'">合同编号</th>	
	    			<th data-options="field:'contractname',width:250,align:'center'">合同名称</th>			
					<th data-options="field:'unitid',width:120,align:'center',hidden:'true'">单位编码</th>	
					<th data-options="field:'unitname',width:250,align:'center'">承研单位名称</th>	
					<th data-options="field:'projectcode',width:120,align:'center'">项目编码</th>	
					<th data-options="field:'projectname',width:250,align:'center'">项目名称</th>					
					<th data-options="field:'reviewdate',width:120,align:'center'">签订时间</th>
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:10px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
			   <form id="fm1" action="" method="post">
				 <a id="queryinfo" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >查看立项评审</a>						
							
			   </form>
			</div>
			<!-- 查询部分 -->
			<div>			   
			    &nbsp;&nbsp;项目名称&nbsp;&nbsp;<input class="easyui-combobox" id="qproject" style="width:200px"></input>
				&nbsp;&nbsp;承研单位&nbsp;&nbsp;<input class="easyui-combobox" id="qunit" style="width:200px"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div> 
	<form action="" id="fm1"></form>
	<div id="dialog" class="easyui-dialog" closed="true"></div>	        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlginfo" class="easyui-dialog" style="width:830px;height:420px;padding:0px 0px" closed="true" buttons="#dlg-buttons">
    	<div id="projectreviewinfo" class="easyui-tabs" data-options="tabWidth:112" style="width:100%;height:100%;">
        <div title="项目建议书" id="staprojectreviewprosal" style="padding:0px">
            <iframe frameborder="0" style="width:100%;height:100%"></iframe> 
        </div>
        <div title="经费概算书" id="b" style="padding:0px">
            <iframe frameborder="0" style="width:100%;height:100%"></iframe>
        </div>
        <div title="开题论证报告" id="" style="padding:10px">
            <p>开题论证报告.</p>
        </div>
        <div title="项目合同" id="" style="padding:10px">
            <p>项目合同.</p>
        </div>
        <div title="年度计划与预算" style="padding:10px">
            <p>年度计划与预算.</p>
        </div>
        
    </div>    
	<div id="dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
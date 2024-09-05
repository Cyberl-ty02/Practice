<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>项目合同里程碑节点完成情况</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/datagrid-detailview.js"></script>
    
    <script type="text/javascript">
        var operation; // 操作变量类型（add还是edit）
        var uid;       // 记录被选中要编辑模块的编码，在点编辑按钮时使用
        var subtype;
        var operation0;
        var lcbuid;
        //------------$(function ())开始--------------//
        $(function () {
        	
        	$("#qunit").combobox({
        		url: 'ProjectContractService?caozuo=initunit',
                valueField: 'unitid',
                textField: 'unitname',
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
                url: 'ProjectContractExcuteService?caozuo=init&con='+getcon()			                        
                
            });
           
            //项目合同综合信息
	    	$("#print").click(function () {
	    		var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要输出的合同信息！", 'info');   
		            return;
	    		}
	    		$("#fm").attr("action","ProjectContractExcuteService?caozuo=printexcuteinfo&uid="+row.uid);
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
	    		$("#fm1").attr("action","ProjectContractExcuteService?caozuo=download&type=word&uid="+row.uid);
    			$("#fm1").submit();
	    	});
	    	$("#pdfdownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectContractExcuteService?caozuo=download&type=pdf&uid="+row.uid);
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
	        if($("#qproject").textbox("getValue")!=""){
	        	temp=$("#qproject").textbox("getValue");
		        if(condition!=""){
	        		condition=condition+" and contractprojectname like '%"+temp+"%'";
	            }else{
	        		condition="contractprojectname like '%"+temp+"%'";
	            }	
	        }	      
        	temp="上交版";
	        if(condition!=""){
        		condition=condition+" and edition like '%"+temp+"%'";
            }else{
        		condition="edition like '%"+temp+"%'";
            }	
	    	return encodeURI(condition);
	    }
	    
	    function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'ProjectContractExcuteService?caozuo=init&con='+getcon(),
	             detailFormatter:function(index,row){
                    return '<div style="padding:2px"><table id="ddv-' + index + '"></table></div>';
                 },
                 onExpandRow: function(index,row){
                   $('#ddv-'+index).datagrid({
                     url:'ProjectContractExcuteService?caozuo=initcontractinfo&uid='+row.uid,
                     fitColumns:false,
                     singleSelect:true,
                     rownumbers:true,
                     loadMsg:'',
                     height:'auto',
                     columns:[[
                    	 {field:'uid',title:'uid',width:150,align:'center',hidden:'true'},
                         {field:'name',title:'里程碑节点名称',width:150,align:'center'},
                         {field:'completedate',title:'完成时间',width:150,align:'center'},                        
                         {field:'aim',title:'研究目标',width:280,align:'left'},                        
                         {field:'content',title:'研究内容',width:280,align:'left'},                        
                         {field:'index',title:'技术指标',width:280,align:'left'},
                         {field:'completeinfo',title:'完成信息',width:350,align:'left'},                      
                         {field:'completeflag',title:'是否完成',width:100,align:'center'}
                         
                    ]],
                    onResize:function(){
                        $("#info").datagrid('fixDetailRowHeight',index);
                    },
                    onLoadSuccess:function(){
                        setTimeout(function(){
                          $("#info").datagrid('fixDetailRowHeight',index);
                        },0);			                           
                    }			                        
                 });
               }
            });
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
		                        <td id="title_id" class="place" align="left">项目合同书</td>       
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
	    			<th data-options="field:'edition',width:120,align:'center',hidden:'true'">版 本</th>
	    			<th data-options="field:'contractno',width:200,align:'center'">合同编号</th>			
					<th data-options="field:'contractprojectcode',width:150,align:'center'">合同项目编码</th>	
					<th data-options="field:'contractprojectname',width:200,align:'center'">合同项目名称</th>
	    			<th data-options="field:'unitcode',width:120,align:'center',hidden:'true'">单位编码</th>	
					<th data-options="field:'unitname',width:200,align:'center'">单位名称</th>	
					<th data-options="field:'projectcode',width:120,align:'center'">项目编码</th>	
					<th data-options="field:'projectname',width:200,align:'center'">项目名称</th>
					
					<th data-options="field:'contractunitname',width:200,align:'center'">合同承研单位</th>	
					<th data-options="field:'beginenddate',width:120,align:'center'">起止时间</th>
					<th data-options="field:'unitinfo',width:250,align:'center'",hidden:'true'>承研单位具体信息</th>
					
					<th data-options="field:'researchtotalaim',width:400,align:'left'">研究总目标</th>	    			
					<th data-options="field:'researchcontent',width:400,align:'left'">研究内容</th>
					
					<th data-options="field:'keytechnology',width:300,align:'left',hidden:'true'">关键技术</th>
					<th data-options="field:'technologyindex',width:300,align:'left'">技术指标</th>
					<th data-options="field:'price',width:100,align:'center'">价款（万元）</th>
					<th data-options="field:'wordfilename',width:150,align:'center',hidden:'true'">word文档</th>	
					<th data-options="field:'pdffilename',width:150,align:'center',hidden:'true'">pdf文档</th>
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:10px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
			   <form id="fm" action="" method="post">
				
				 <a id="print" class="easyui-linkbutton" iconCls="icon-print"  plain="true" >合同完成情况</a>
				 &nbsp;&nbsp;<a id="worddownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载合同word版</a>
				 &nbsp;&nbsp;<a id="pdfdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载合同pdf版</a>				
			   </form>
			</div>
			<!-- 查询部分 -->
			<div>			   
			    &nbsp;&nbsp;项目名称&nbsp;&nbsp;<input class="easyui-textbox" id="qproject" style="width:200px"></input>
				&nbsp;&nbsp;承研单位&nbsp;&nbsp;<input class="easyui-combobox" id="qunit" style="width:200px"></input>
				
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div> 
	<form action="" id="fm1"></form>              	             
	<div id="dialog" class="easyui-dialog" closed="true"></div>	        
    
  </body>
</html>
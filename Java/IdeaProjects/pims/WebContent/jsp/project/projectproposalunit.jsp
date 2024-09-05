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
       
        //------------$(function ())开始--------------//
        $(function () {
        	
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
        	$("#qedition").combobox({
        		url: 'ProjectProposalService?caozuo=initedition',
                valueField: 'name',
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
                url: 'ProjectProposalService?caozuo=init&con='+getcon()
            });	
            
	    	 //项目合同综合信息
	    	$("#print").click(function () {	    		
	    		$("#fm").attr("action","ProjectProposalService?caozuo=print&con="+getcon());
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
	    	$("#expertopinionadoptdownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=expertopinionadopt&uid="+row.uid);
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
	        if($("#qedition").combobox("getValue")!=""){
	        	temp=$("#qedition").combobox("getValue");
		        if(condition!=""){
	        		condition=condition+" and edition='"+temp+"'";
	            }else{
	        		condition="edition='"+temp+"'";
	            }	
	        }	
	    	return encodeURI(condition);
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
	    			<th data-options="field:'edition',width:120,align:'center'">版 本</th>	
	    			<th data-options="field:'prosalname',width:250,align:'center'">建议书名称</th>			
					<th data-options="field:'unitid',width:120,align:'center',hidden:'true'">单位编码</th>	
					<th data-options="field:'unitname',width:250,align:'center'">单位名称</th>	
					<th data-options="field:'projectcode',width:120,align:'center'">项目编码</th>	
					<th data-options="field:'projectname',width:250,align:'center'">项目名称</th>
					<th data-options="field:'researchtarget',width:300,align:'left'">研究目标</th>	    			
					<th data-options="field:'researchcontent',width:300,align:'left'">研究内容</th>
					<th data-options="field:'technicalindex',width:300,align:'left'">技术指标</th>	    			
					<th data-options="field:'projectachievment',width:300,align:'left'">项目成果</th>	
					<th data-options="field:'funds',width:100,align:'center'">经 费（万元）</th>
					<th data-options="field:'wordfilename',width:150,align:'center'">word文档</th>	
					<th data-options="field:'pdffilename',width:150,align:'center'">pdf文档</th>
					<th data-options="field:'reviewdate',width:120,align:'center'">评审时间</th>
					<th data-options="field:'score',width:120,align:'center'">评审得分</th>
					<th data-options="field:'expertopinionfilename',width:150,align:'center'">专家意见文档</th>
					<th data-options="field:'expertopinionadoptfilename',width:150,align:'center'">专家意见采纳文档</th>
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:10px;height:auto">
	     	<div style="margin-bottom:5px">
			   <form id="fm1" action="" method="post">				 
				 &nbsp;&nbsp;<a id="worddownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载word版</a>
				 &nbsp;&nbsp;<a id="pdfdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载pdf版</a>
				 &nbsp;&nbsp;<a id="expertopiniondownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载专家意见书</a>
				 &nbsp;&nbsp;<a id="expertopinionadoptdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载专家意见采纳表</a>						
			   </form>
			</div>
				<!-- 查询部分 -->
			<div>			   
			    &nbsp;&nbsp;项目名称: <input class="easyui-combobox" id="qproject" style="width:200px"></input>
				&nbsp;&nbsp;承研单位: <input class="easyui-combobox" id="qunit" style="width:200px"></input>
				&nbsp;&nbsp;版 本&nbsp;&nbsp;<input class="easyui-combobox" id="qedition"  name="qedition"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			    &nbsp;&nbsp;<a id="print" class="easyui-linkbutton" iconCls="icon-print" plain="true">输出项目建议书</a>							
			</div>
			</div>
		 </div>
	</div>               	             
	<div id="dialog" class="easyui-dialog" closed="true"></div>	        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlginfo" class="easyui-dialog" style="width:630px;height:300px;padding:0px 0px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">项目建议书信息</div>
    	<form id="fm" method="post" action="" novalidate enctype="multipart/form-data">
	        
	        <div class="fitem1">
	            <label>承研单位:</label>
	            <input class="easyui-combobox" id="unit"  name="unit"></input>
	        </div>
	        <div class="fitem1">
	            <label>承研项目:</label>
	            <input class="easyui-combobox" id="project"  name="project"></input>
	        </div>	        
	        <div class="fitem1">
	        	<label>建议书文档:</label>
	        	<input class="easyui-filebox" id="document" name="document" buttonText="选择文件" value="选择文件"/>
	        </div>	       
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">上 传</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
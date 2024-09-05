<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>项目合同书</title>
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
        var operation0;
        //------------$(function ())开始--------------//
        $(function () {
        	//$("#experttitle").hide();
        	$("#unit").combobox({
        		url: 'ProjectContractService?caozuo=initunit',
                valueField: 'unitid',
                textField: 'unitname',
                panelHeight: 'auto',
                editable:true,
                onChange:function(){
                    var unitid=$("#unit").combobox("getValue");                    
                    $("#project").combobox({
	           	        url: "ProjectContractService?caozuo=initproject&unitid="+unitid
                    });
                }
        	});	
        	
        	$("#secretlevel").combobox({
        		url: 'ProjectContractService?caozuo=initcombobox&code=014',
                valueField: 'name',
                textField: 'name',
                panelHeight: 'auto'
        	});	
        	
        	$("#project").combobox({
        		url: 'ProjectContractService?caozuo=initproject',
                valueField: 'projectcode',
                textField: 'projectname',
                panelHeight: 'auto',
                editable:true
        	});
        	$("#qunit").combobox({
        		url: 'ProjectContractService?caozuo=initunit',
                valueField: 'unitid',
                textField: 'unitname',
                panelHeight: 'auto',
                editable:true
        	});	
        	$("#qproject").combobox({
        		url: 'ProjectContractService?caozuo=initproject',
                valueField: 'projectcode',
                textField: 'projectname',
                panelHeight: 'auto',
                editable:true
        	});
        	$("#edition").combobox({
        		url: 'ProjectContractService?caozuo=initedition',
                valueField: 'name',
                textField: 'name',
                panelHeight: 'auto'
        	});
        	$("#qedition").combobox({
        		url: 'ProjectContractService?caozuo=initedition',
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
                url: 'ProjectContractService?caozuo=init&con='+getcon()
            });
            //初始化DataGrid控件信息
            $("#contractinfo").datagrid({
            	loadMsg: "数据加载中，请等待...",
            	iconCls: 'icon-issue',
                nowrap: false,                
                striped: true,
                collapsible: true,
                rownumbers: true,
                
                singleSelect: true,
                autoRowHeight: true,
                fitColumns: false
            });
	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    	    operation="add";	    		    	    	    
	    		$('#dlginfo').dialog('open').dialog('center').dialog('setTitle','项目合同书');
	    		$('#fm').form('clear');
	    	});	
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    	    if($("#unit").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "承研单位不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#project").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "承研项目不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#edition").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "版本不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#document").filebox("getValue")==""){
	    	    	$.messager.alert("提示", "上传文档不能为空！", 'info');
	              	return;
	    	    }	    	    
	    	    if(operation=="add"){
		    	    $("#fm").attr("action","ProjectContractService?caozuo=add"); 	   
	    			$("#fm").submit();
	    	    }else{	    	    	
	    	    	$("#fm").attr("action","ProjectContractService?caozuo=edit&uid="+uid);
	    			$("#fm").submit();
	    	    }
	    	});
	    	//上传依据文档文件成功提示
	    	$('#fm').form({
                success:function(data){
                   var value=eval("("+data+")")
		           if (value.ret == "0") {
		        	   initinfo();		               
                       $.messager.alert("提示", "操作成功！", 'info');
                       return;
                   }else{
                	   var reason=value.reason;
                       $.messager.alert("提示", "操作失败,原因:"+reason, 'info');
                       return;
                   }  
                }
            });
	    	
	    	//删除操作
	    	$("#delete").click(function(){
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的项目合同书信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("ProjectContractService?caozuo=del&uid="+row.uid,                        
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
	    	
	    	
	    	
	    	//下载资料操作，弹出对话框
	    	$("#worddownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectContractService?caozuo=download&type=word&uid="+row.uid);
    			$("#fm1").submit();
	    	});
	    	$("#pdfdownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectContractService?caozuo=download&type=pdf&uid="+row.uid);
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
	    	
	    	$("#queryinfo").click(function(){
	    		var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要查看的合同详细信息！", 'info');   
		            return;
	    		}
	    		$('#dlgcontractinfo').dialog('open').dialog('center').dialog('setTitle','项目合同详细信息');
	    		$("#contractinfo").datagrid({
		             loadMsg: "数据加载中，请等待...",                
		             url: 'ProjectContractService?caozuo=initcontractinfo&uid='+row.uid
	            });
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
	             url: 'ProjectContractService?caozuo=init&con='+getcon()
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
	    			<th data-options="field:'edition',width:120,align:'center'">版 本</th>
	    			<th data-options="field:'unitcode',width:120,align:'center',hidden:'true'">单位编码</th>	
					<th data-options="field:'unitname',width:200,align:'center'">单位名称</th>	
					<th data-options="field:'projectcode',width:120,align:'center'">项目编码</th>	
					<th data-options="field:'projectname',width:200,align:'center'">项目名称</th>
						
	    			<th data-options="field:'contractno',width:200,align:'center'">合同编号</th>			
					<th data-options="field:'contractprojectcode',width:150,align:'center'">合同项目编码</th>	
					<th data-options="field:'contractprojectname',width:200,align:'center'">合同项目名称</th>	
					<th data-options="field:'contractunitname',width:200,align:'center'">合同承研单位</th>	
					<th data-options="field:'beginenddate',width:120,align:'center'">起止时间</th>
					<th data-options="field:'unitinfo',width:250,align:'center'">承研单位具体信息</th>
					
					<th data-options="field:'researchtotalaim',width:400,align:'left'">研究总目标</th>	    			
					<th data-options="field:'researchcontent',width:400,align:'left'">研究内容</th>
					
					<th data-options="field:'keytechnology',width:300,align:'left'">关键技术</th>
					<th data-options="field:'technologyindex',width:300,align:'left'">技术指标</th>
					<th data-options="field:'price',width:100,align:'center'">价款（万元）</th>
					<th data-options="field:'wordfilename',width:150,align:'center'">word文档</th>	
					<th data-options="field:'pdffilename',width:150,align:'center'">pdf文档</th>
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:10px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
			   <form id="fm1" action="" method="post">
				 <a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>						
				 <a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>
				 <a id="queryinfo" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >查看详细信息</a>
				 &nbsp;&nbsp;<a id="worddownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载word版</a>
				 &nbsp;&nbsp;<a id="pdfdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载pdf版</a>				
			   </form>
			</div>
			<!-- 查询部分 -->
			<div>			   
			    &nbsp;&nbsp;项目名称&nbsp;&nbsp;<input class="easyui-combobox" id="qproject" style="width:200px"></input>
				&nbsp;&nbsp;承研单位&nbsp;&nbsp;<input class="easyui-combobox" id="qunit" style="width:200px"></input>
				&nbsp;&nbsp;版 本&nbsp;&nbsp;<input class="easyui-combobox" id="qedition"  name="qedition"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div> 
	<form action="" id="fm1"></form>              	             
	<div id="dialog" class="easyui-dialog" closed="true"></div>	        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlginfo" class="easyui-dialog" style="width:750px;height:400px;padding:0px 0px" closed="true" buttons="#dlg-buttons">    	
    	<div title="项目合同信息" class="ftitle">
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
		            <label>合同版本:</label>
		            <input class="easyui-combobox" id="edition"  name="edition"></input>
		        </div> 
		        <div class="fitem1">
		            <label>文档密级:</label>
		            <input class="easyui-combobox" id="secretlevel"  name="secretlevel"></input>
		        </div>       
		        <div class="fitem1">
		        	<label>建议书WORD版:</label>
		        	<input class="easyui-filebox" id="document" name="document" buttonText="选择文件" value="选择文件"/>
		        </div>
		        <div class="fitem1">
		        	<label>建议书PDF版:</label>
		        	<input class="easyui-filebox" id="pdfdocument" name="pdfdocument" buttonText="选择文件" value="选择文件"/>
		        </div>		        
			</form>
		</div>		
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>		
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<div id="dlgcontractinfo" class="easyui-dialog" style="width:950px;height:450px;padding:0px 0px" closed="true" buttons="#dlg-buttons0">    	
    	<div><h3>&nbsp;&nbsp;里程碑节点信息</h3></div>
    	<table id="contractinfo" class="easyui-datagrid" width="100%" style="height:85%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true">
	    	<thead>
	    		<tr>
	    			<th data-options="field:'uid',width:120,align:'center',hidden:'true'">uid</th>
	    			<th data-options="field:'name',width:220,align:'center'">里程碑节点名称</th>
	    			<th data-options="field:'completedate',width:120,align:'center'">完成时间</th>	
					<th data-options="field:'aim',width:350,align:'center'">研究目标</th>	
					<th data-options="field:'content',width:350,align:'center'">研究内容</th>	
					<th data-options="field:'index',width:350,align:'center'">技术指标</th>
	    		</tr>
	    	</thead>
	     </table>	
	</div>
	<div id="dlg-buttons0">
		
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgcontractinfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
		
  </body>
</html>
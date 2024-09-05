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
        var operation0;
        //------------$(function ())开始--------------//
        $(function () {
        	//$("#experttitle").hide();
        	$("#unit").combobox({
        		url: 'ProjectProposalService?caozuo=initunit', //初始化单位下拉框
                valueField: 'unitid',
                textField: 'unitname',
                panelHeight: 'auto',
                editable:true,
                onChange:function(){
                    var unitid=$("#unit").combobox("getValue"); //获得单位编码                    
                    $("#project").combobox({
	           	        url: "ProjectProposalService?caozuo=initproject&unitid="+unitid //根据单位编码初始化项目下拉框
                    });
                }
        	});	
        	
        	$("#secretlevel").combobox({
        		url: 'ProjectProposalService?caozuo=initcombobox&code=014', //初始化文档密级下拉框
                valueField: 'name',
                textField: 'name',
                panelHeight: 'auto'
        	});	
        	
        	$("#project").combobox({
        		url: 'ProjectProposalService?caozuo=initproject', //初始化项目下拉框	
                valueField: 'projectcode',
                textField: 'projectname',
                panelHeight: 'auto',
                editable:true
        	});
        	$("#qunit").combobox({
        		url: 'ProjectProposalService?caozuo=initunit', //初始化单位下拉框
                valueField: 'unitid',
                textField: 'unitname',
                panelHeight: 'auto',
                editable:true
        	});	
        	$("#qproject").combobox({
        		url: 'ProjectProposalService?caozuo=initproject', //初始化项目下拉框
                valueField: 'projectcode',
                textField: 'projectname',
                panelHeight: 'auto',
                editable:true
        	});
        	$("#edition").combobox({
        		url: 'ProjectProposalService?caozuo=initedition', //初始化版本下拉框
                valueField: 'name',
                textField: 'name',
                panelHeight: 'auto'
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
                url: 'ProjectProposalService?caozuo=init&con='+getcon() //初始化项目建议书信息
            });
            //初始化DataGrid控件信息
            $("#scoreinfo").datagrid({
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
	    		$('#dlginfo').dialog('open').dialog('center').dialog('setTitle','项目建议书');
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
		    	    $("#fm").attr("action","ProjectProposalService?caozuo=add"); 	   
	    			$("#fm").submit();
	    	    }else{	    	    	
	    	    	$("#fm").attr("action","ProjectProposalService?caozuo=edit&uid="+uid);
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
	    			$.messager.alert("提示", "请选择要删除的项目建议书信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("ProjectProposalService?caozuo=del&uid="+row.uid,                        
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
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=word&uid="+row.uid); //下载word文档
    			$("#fm1").submit();
	    	});
	    	$("#pdfdownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=pdf&uid="+row.uid); //下载pdf文档
	    	});
	    	$("#expertopiniondownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=expertopinion&uid="+row.uid); //下载专家意见文档
    			$("#fm1").submit();
	    	});
	    	$("#expertopinionadoptdownload").click(function () {	    		
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载资料的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=download&type=expertopinionadopt&uid="+row.uid); //下载专家意见采纳文档
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
	    	
	    	//专家评分部分"addexpertscore"
	    	//专家评分操作，弹出对话框
	    	$("#addexpertscore").click(function(){
	    		var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要添加专家评分的信息！", 'info');   
		            return;
	    		}
	    		if(row.edition.indexOf("终评版")<0){
	    			//不是终评版
	                $.messager.alert("提示", "该项目建议书不是终评版！", 'info');   
                    return;
	    			$.messager.alert("提示", "该项目建议书不是终评版！", 'info');   
		            return;
	    		}
	    		uid=row.uid;
	    		
	    		$('#dlginfo0').dialog('open').dialog('center').dialog('setTitle','专家评分信息'); //弹出专家评分对话框
	    		$('#fm').form('clear');
	    		initscoreinfo(uid);	    		
	    	});
	    	
	    	$("#add0").click(function(){	    		
	    		operation0="scoreadd"
	    		$('#dlgscoreinfo').dialog('open').dialog('center').dialog('setTitle','专家评分表'); //弹出专家评分表对话框
	    		$('#fm').form('clear');
	    		console.log("add0:"+operation0);
	    	});
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save0").click(function(){
	    	    if($("#expertname").textbox("getValue")==""){
	    	    	$.messager.alert("提示", "专家名称不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#score").textbox("getValue")==""){
	    	    	$.messager.alert("提示", "专家评分不能为空！", 'info');
	              	return;
	    	    }	    	    
	    	    if($("#scoredocument").filebox("getValue")==""){
	    	    	$.messager.alert("提示", "上传的专家评分文档不能为空！", 'info');
	              	return;
	    	    }	    	    
	    	    if(operation0=="scoreadd"){
		    	    $("#fmscore").attr("action","ProjectProposalService?caozuo=scoreadd&puid="+uid); //添加专家评分	   
	    			$("#fmscore").submit();
	    	    }else{	    	    	
	    	    	$("#fmscore").attr("action","ProjectProposalService?caozuo=scoredel&uid="+uid); //删除专家评分
	    			$("#fmscore").submit();
	    	    }
	    	});
	    	//删除操作
	    	$("#delete0").click(function(){
	    	    var row=$('#scoreinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的专家评分表信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("ProjectProposalService?caozuo=scoredel&uid="+row.uid,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initinfo();	
	                    initscoreinfo();
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});
	    	//上传依据文档文件成功提示
	    	$('#fmscore').form({
                success:function(data){
                   var value=eval("("+data+")")
		           if (value.ret == "0") {
		        	   initinfo();	
		        	   initscoreinfo();
                       $.messager.alert("提示", "操作成功！", 'info');
                       return;
                   }else{
                	   var reason=value.reason;
                       $.messager.alert("提示", "操作失败,原因:"+reason, 'info');
                       return;
                   }  
                }
            });
	    	$("#expertscoredownload").click(function () {	    		
	    	    var row=$('#scoreinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要下载评分表的信息！", 'info');   
		            return;
	    		}
	    		$("#fm1").attr("action","ProjectProposalService?caozuo=downloadscore&uid="+row.uid);
    			$("#fm1").submit();
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
	    //评分表信息
	    function initscoreinfo(puid){
	    	$("#scoreinfo").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'ProjectProposalService?caozuo=initscoreinfo&puid='+uid
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
	    			<th data-options="field:'prosalname',width:200,align:'center'">建议书名称</th>			
					<th data-options="field:'unitid',width:120,align:'center',hidden:'true'">单位编码</th>	
					<th data-options="field:'unitname',width:200,align:'center'">单位名称</th>	
					<th data-options="field:'projectcode',width:120,align:'center'">项目编码</th>	
					<th data-options="field:'projectname',width:200,align:'center'">项目名称</th>
					<th data-options="field:'researchtarget',width:400,align:'left'">研究目标</th>	    			
					<th data-options="field:'researchcontent',width:400,align:'left'">研究内容</th>
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
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
			   <form id="fm1" action="" method="post">
				 <a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>						
				 <a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>
				 <a id="addexpertscore" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >专家评分</a>
				 &nbsp;&nbsp;<a id="worddownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载word版</a>
				 &nbsp;&nbsp;<a id="pdfdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载pdf版</a>
				 &nbsp;&nbsp;<a id="expertopiniondownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载专家意见书</a>
				 &nbsp;&nbsp;<a id="expertopinionadoptdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载专家意见采纳表</a>						
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
    <div id="dlginfo" class="easyui-dialog" style="width:750px;height:500px;padding:0px 0px" closed="true" buttons="#dlg-buttons">
    	
    	<div title="项目建议书信息" class="ftitle">
	    	<form id="fm" method="post" action="" novalidate enctype="multipart/form-data">
		        <div class="fitem1">
		            <label>建议书名称:</label>
		            <input class="easyui-textbox" id="prosalname"  name="prosalname"></input>
		        </div>
		        <div class="fitem1">
		            <label>承研单位:</label>
		            <input class="easyui-combobox" id="unit"  name="unit"></input>
		        </div>
		        <div class="fitem1">
		            <label>承研项目:</label>
		            <input class="easyui-combobox" id="project"  name="project"></input>
		        </div>	
		        <div class="fitem1">
		            <label>建议书版本:</label>
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
		        <div class="fitem1">
		            <label>评审时间:</label>
		            <input class="easyui-datebox" id="reviewdate"  name="reviewdate"></input>
		        </div>
		        <div class="fitem1">
		        	<label>评审专家意见:</label>
		        	<input class="easyui-filebox" id="expertopinion" name="expertopinion" buttonText="选择文件" value="选择文件"/>
		        </div>
		        <div class="fitem1">
		        	<label style="width:200">专家意见采纳情况:</label>
		        	<input class="easyui-filebox" id="expertopinionadopt" name="expertopinionadopt" buttonText="选择文件" value="选择文件"/>
		        </div>
			</form>
		</div>		
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>		
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<div>
	    <div id="dlginfo0" class="easyui-dialog" style="width:750px;height:450px;padding:0px 0px" closed="true" buttons="#dlg-buttons0">
		
		<table id="scoreinfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb0'">
	    	<thead>
	    		<tr>
	    			<th data-options="field:'uid',width:120,align:'center',hidden:'true'">uid</th>
	    			<th data-options="field:'expertname',width:120,align:'center'">专家姓名</th>	
	    			<th data-options="field:'score',width:120,align:'center'">专家评分</th>
					<th data-options="field:'expertscorefilename',width:250,align:'center'">评分表附件名称</th>							
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb0" style="padding:10px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
			   <form id="fm1" action="" method="post">
				 <a id="add0" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>						
				 <a id="delete0" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>
				 <a id="expertscoredownload" class="easyui-linkbutton" iconCls="icon-download" plain="true">下载评分表</a>
				 						
			   </form>
			</div>			
	     </div>
	</div>
	<div id="dlg-buttons0">		
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo0').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
	<div id="dlgscoreinfo" class="easyui-dialog" style="width:550px;height:250px;padding:0px 0px" closed="true" buttons="#dlg-buttons00">
    	
    	<div>
	    	<form id="fmscore" method="post" action="" novalidate enctype="multipart/form-data">
		        <div class="fitem">
		            <label>专家名称:</label>
		            <input class="easyui-textbox" style="width:400px;" id="expertname"  name="expertname"></input>
		        </div>
		        <div class="fitem">
		            <label>专家评分:</label>
		            <input class="easyui-textbox" style="width:400px;" id="score"  name="score"></input>
		        </div>
		        <div class="fitem">
		        	<label>专家评分表:</label>
		        	<input class="easyui-filebox" style="width:400px;" id="scoredocument" name="scoredocument" buttonText="选择文件" value="选择文件"/>
		        </div>
			</form>
		</div>
		<div id="dlg-buttons00">
		    <a href="javascript:void(0)"  id="save0" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>		
			<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgscoreinfo').dialog('close')" style="width:90px">关 闭</a>
	    </div>
	</div>
  </body>
</html>
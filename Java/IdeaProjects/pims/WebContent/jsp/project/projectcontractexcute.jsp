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
        	/*
        	$("#qproject").combobox({
        		url: 'ProjectContractService?caozuo=initproject',
                valueField: 'projectcode',
                textField: 'projectname',
                panelHeight: 'auto',
                editable:true
        	});*/
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
                view: detailview,
                autoRowHeight: true,
                fitColumns: false,
                pageSize: 10,
                pageList: [10, 20, 30, 40],
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
	    		var row=$('#contractinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要设置的里程碑节点信息！", 'info');   
		            return;
	    		}
	    	    operation="add";	    	    
	    		$('#dlginfo').dialog('open').dialog('center').dialog('setTitle', '设置项目里程碑节点完成情况');
	    		$('#fm').form('clear');
	    		lcbuid=row.uid;
	    	    $("#name").textbox("setValue",row.name);
	    	    $("#completedate").textbox("setValue",row.completedate);
	    	    $("#completeinfo").textbox("setValue",row.completeinfo);
	    	    $("#completeflag").combobox("setValue",row.completeflag);
	    	});
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    		var row0=$('#info').datagrid('getSelected');	    	    
	    		if(row0=="" || row0==null){
	    			$.messager.alert("提示", "请选择要查看的合同详细信息！", 'info');   
		            return;
	    		}
	    		    	    
	    		if(lcbuid==""){
	    			$.messager.alert("提示", "请重新选择要设置的里程碑节点信息！", 'info');   
		            return;
	    		}
	    		
	    	    if($("#completeinfo").textbox("getValue")==""){
	    	    	$.messager.alert("提示", "节点完成情况不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#completeflag").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "节点是否完成不能为空！", 'info');
	              	return;
	    	    }
	    	    var uid=row0.uid;	    	   
	    	    if(operation=="add"){
		    	    $("#fm").attr("action","ProjectContractExcuteService?caozuo=add&uid="+uid+"&lcbuid="+lcbuid); 	   
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
		        	  
		        	   initlcbinfo();
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
	    	
	    	$("#queryinfo").click(function(){
	    		var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要查看的合同详细信息！", 'info');   
		            return;
	    		}
	    		$('#dlgcontractinfo').dialog('open').dialog('center').dialog('setTitle','项目里程碑节点信息');
	    		$("#contractinfo").datagrid({
		             loadMsg: "数据加载中，请等待...",                
		             url: 'ProjectContractExcuteService?caozuo=initcontractinfo&uid='+row.uid
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
	    
	    function initlcbinfo(){
	    	var row=$('#info').datagrid('getSelected');
	    	$("#contractinfo").datagrid({
	            loadMsg: "数据加载中，请等待...",                
	            url: 'ProjectContractExcuteService?caozuo=initcontractinfo&uid='+row.uid
           });
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
			   <form id="fm1" action="" method="post">
				
				 <a id="queryinfo" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >里程碑节点完成情况</a>
				 &nbsp;&nbsp;<a id="worddownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载word版</a>
				 &nbsp;&nbsp;<a id="pdfdownload" class="easyui-linkbutton" iconCls="icon-download"  plain="true" >下载pdf版</a>				
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
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlginfo" class="easyui-dialog" style="width:650px;height:300px;padding:0px 0px" closed="true" buttons="#dlg-buttons">    	
    	<div title="项目合同里程碑节点信息" class="ftitle">
	    	<form id="fm" method="post" action="" novalidate enctype="multipart/form-data">		        
		        <div class="fitem1">
		            <label>节点名称:</label>
		            <input class="easyui-textbox" id="name"  name="name"></input>
		            <input type="hidden" id="uid"  name="uid"></input>
		        </div>
		        <div class="fitem1">
		            <label>完成时间:</label>
		            <input class="easyui-textbox" id="completedate"  name="completedate"></input>
		        </div>	
		        <div class="fitem1">
		            <label>完成情况:</label>
		            <input class="easyui-textbox" id="completeinfo"  name="completeinfo"></input>
		        </div> 
		        <div class="fitem1">
		            <label>是否完成:</label>
		            
		            <select class="easyui-combobox" name="completeflag" id="completeflag" data-options="panelHeight:'auto'" style="width:450px">
				       <option value="是" selected>是</option>
				       <option value="否">否</option>	
				    </select>
		        </div>
			</form>
		</div>		
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>		
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<div id="dlgcontractinfo" class="easyui-dialog" style="width:950px;height:450px;padding:0px 0px" closed="true" buttons="#dlg-buttons0">    	
    	<!-- <div><h3>&nbsp;&nbsp;里程碑节点信息</h3></div>-->
    	<table id="contractinfo" class="easyui-datagrid" width="100%" style="height:85%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb0'">
	    	<thead>
	    		<tr>
	    			<th data-options="field:'uid',width:120,align:'center',hidden:'true'">uid</th>
	    			<th data-options="field:'name',width:220,align:'center'">里程碑节点名称</th>
	    			<th data-options="field:'completedate',width:120,align:'center'">完成时间</th>	
					<th data-options="field:'aim',width:300,align:'left'">研究目标</th>	
					<th data-options="field:'content',width:300,align:'left'">研究内容</th>	
					<th data-options="field:'index',width:300,align:'left'">技术指标</th>
					<th data-options="field:'completeinfo',width:300,align:'left'">完成情况</th>	
					<th data-options="field:'completeflag',width:100,align:'center'">是否完成</th>
					
	    		</tr>
	    	</thead>
	     </table>	
	</div>
	<div id="tb0" style="padding:10px;height:auto">
        <!-- 按钮部分 -->
		<div style="margin-bottom:5px">
		   <form id="fm1" action="" method="post">
			 <a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>						
			 <a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>			
		   </form>
		</div>
		
	 </div>
	<div id="dlg-buttons0">
		
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgcontractinfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
		
  </body>
</html>
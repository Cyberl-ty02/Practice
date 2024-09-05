<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>受检单位</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var operation;       // 操作变量类型（add还是edit）
        var checkedunitid;   // 记录被选中要编辑受检单位的编码，在点编辑按钮时使用
        //------------$(function ())开始--------------//
        $(function () {
            //初始化Combobox控件:受检单位（查询）
            $("#branchcompany").combobox({
            	url: 'BasedataCheckedunitService?caozuo=initbranchcompany',
                valueField: 'branchid',
                textField: 'branchname',
                panelHeight: 'auto',
                editable:true         
            });
            $("#dbranchcompany").combobox({
            	url: 'BasedataCheckedunitService?caozuo=initbranchcompany',
                valueField: 'branchid',
                textField: 'branchname',
                panelHeight: 'auto',
                editable:false         
            });
            //初始化DataGrid控件信息
            $("#checkedunitinfo").datagrid({
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
                url: 'BasedataCheckedunitService?caozuo=init&con='+getQueryCondition()                        	
            });	
            
	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    	    operation="add";	    		    	    	    
	    		$('#dlgcheckedunitinfo').dialog('open').dialog('center').dialog('setTitle','添加受检单位信息');
	    		$('#fm').form('clear');
	    	});	
	    	//编辑操作,弹出对话框
	    	$("#edit").click(function () {
	    	    var row=$('#checkedunitinfo').datagrid('getSelected');
	    	    if(row){
	    	        checkedunitid=row.unitid;
	    	        $('#fm').form('clear');
	    	    	operation="edit";	    		    	    	    
	    			$('#dlgcheckedunitinfo').dialog('open').dialog('center').dialog('setTitle','编辑受检单位信息');
	    			$("#dunitid").val(row.unitid);
	    			$("#dunitname").val(row.unitname);
	    			$("#dbranchcompany").combobox("setValue",row.bid);
	    			$("#dlinkperson").val(row.linkperson);
	    			$("#dphone").val(row.phone);
	    			$("#daddress").val(row.address);	    			
	    			$("#demo").val(row.demo);
	    	    }else{
	    	    	$.messager.alert("提示", "请选择要编辑的受检单位信息！", 'info');   
		            return;
	    	    }    		
	    	});	
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    	    if($("#dunitid").val()==""){
	    	    	$.messager.alert("提示", "受检单位编码不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#dunitname").val()==""){
	    	    	$.messager.alert("提示", "受检单位名称不能为空！", 'info');
	              	return;
	    	    }	
	    	    if($("#dbranchcompany").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "所属分公司不能为空！", 'info');
	              	return;
	    	    }    	    
	    		if(operation=="add"){
	    			$.post("BasedataCheckedunitService?caozuo=add",
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "添加操作成功！", 'info');
		                    initcheckedunitinfo();	                        
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }             
	                });
	    		}else if(operation=="edit"){
	    			$.post("BasedataCheckedunitService?caozuo=edit&oldcheckedunitid="+checkedunitid,
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "修改操作成功！", 'info');
		                    initcheckedunitinfo();	                        
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }             
	                });
	    		}
	    	});
	    	//删除操作
	    	$("#delete").click(function(){
	    	    var row=$('#checkedunitinfo').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的受检单位信息！", 'info');   
		            return;
	    		}	    		
         	    $.post("BasedataCheckedunitService?caozuo=delete&unitid=" +row.unitid,                        
	            function (data) {
	                var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initcheckedunitinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }             
	             });
	    	});
	    	
	    	//查询操作
	    	$("#query").click(function(){
	    		initcheckedunitinfo();
	    	});    	
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getQueryCondition(){
	        var condition="";
	        if($("#checkedunitid").val()!=""){
	        	condition="unitid='"+$("#checkedunitid").val()+"'";
	        }
	        if($("#checkedunitname").val()!=""){
	        	if(condition!=""){
	        		condition=condition+" and unitname like '%"+$("#checkedunitname").val()+"%'"
	        	}else{
	        		condition="unitname like '%"+$("#checkedunitname").val()+"%'";
	        	}
	        }
	        if($("#branchcompany").combobox("getValue")!=""){
	        	if(condition!=""){
	        		condition=condition+" and bid='"+$("#branchcompany").combobox("getValue")+"'"
	        	}else{
	        		condition="bid='"+$("#branchcompany").combobox("getValue")+"'"
	        	}
	        }
	                      
	    	return encodeURI(condition);
	    }
	    
	    function initcheckedunitinfo(){
	    	$("#checkedunitinfo").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'BasedataCheckedunitService?caozuo=init&con='+getQueryCondition()
            });
	    }
	    
	    //-----------自定义函数结束------------//
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
		                        <td id="title_id" class="place" align="left">受检单位信息</td>       
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
	 	 <table id="checkedunitinfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>   			
	    			<th data-options="field:'unitid',width:80,align:'center'">单位编码</th>								
					<th data-options="field:'unitname',width:200,align:'center'">单位名称</th>
					<th data-options="field:'bid',width:150,align:'center',hidden:'true'">分公司ID</th>
					<th data-options="field:'branchname',width:200,align:'center'">所属分公司</th>					
					<th data-options="field:'linkperson',width:100,align:'center'">负责人</th>
					<th data-options="field:'phone',width:100,align:'center'">负责人电话</th>
					<th data-options="field:'address',width:200,align:'center'">地 址</th>					
					<th data-options="field:'demo',width:100,align:'center'">备注</th>			
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:5px;height:auto">
	        <!-- 按钮部分 -->
			<div style="margin-bottom:5px">
				<a id="add" class="easyui-linkbutton" iconCls="icon-add"  plain="true" >增 加</a>	
				<a id="edit" class="easyui-linkbutton" iconCls="icon-edit"  plain="true" >编 辑</a>						
				<a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>
			</div>
			<!-- 查询部分 -->
			<div>				
				&nbsp;单位编码: <input class="easyui-textbox"  id="checkedunitid" style="width:150px"></input>
			    &nbsp;&nbsp;单位名称: <input class="easyui-textbox" id="checkedunitname" style="width:200px"></input>
			    &nbsp;&nbsp;所属分公司: <input class="easyui-combobox"  id="branchcompany" style="width:150px"></input>			    
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div>               	             
		        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlgcheckedunitinfo" class="easyui-dialog" style="width:360px;height:340px;padding:10px 15px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">受检单位信息</div>
    	<form id="fm" method="post" novalidate>
	        <div class="fitem">
	            <label>单位编码:</label>
	            <input id="dunitid" name="dunitid"></input>
	        </div>
	        <div class="fitem">
	            <label>单位名称:</label>
	            <input id="dunitname"  name="dunitname"></input>
	        </div>
	        <div class="fitem">
	            <label>所属分公司:</label>
	            <input id="dbranchcompany"  name="dbranchcompany"></input>
	        </div>
	        <div class="fitem">
	        	<label>负 责 人:</label>
	        	<input id="dlinkperson" name="dlinkperson"/>
	        </div>
	        <div class="fitem">
	        	<label>负责人电话:</label>
	        	<input id="dphone" name="dphone"/>
	        </div>
	        <div class="fitem">
	        	<label>地   址:</label>
	        	<input id="daddress" name="daddress"/>
	        </div>
	        <div class="fitem">
	        	<label>备   注:</label>
	        	<input id="demo" name="demo"/>
	        </div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgcheckedunitinfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
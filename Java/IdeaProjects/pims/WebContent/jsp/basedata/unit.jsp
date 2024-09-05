<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>承研单位管理</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
    <script type="text/javascript">
        var operation;       // 操作变量类型（add还是edit）
        var code;       // 记录被选中要编辑部门的编码，在点编辑按钮时使用
        //------------$(function ())开始--------------//
        $(function () {
            
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
                url: 'BasedataUnitService?caozuo=init&con='+getcon()                        	
            });	
            
	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    	    operation="add";	    		    	    	    
	    		$('#dlginfo').dialog('open').dialog('center').dialog('setTitle','添加承研单位信息');
	    		$('#fm').form('clear');
	    		$("#jituanflag").combobox("setValue","否");
    			$("#state").combobox("setValue","是");
	    	});	
	    	//编辑操作,弹出对话框
	    	$("#edit").click(function () {
	    	    var row=$('#info').datagrid('getSelected');
	    	    if(row){
	    	        code=row.code;
	    	        $('#fm').form('clear');
	    	    	operation="edit";	    		    	    	    
	    			$('#dlginfo').dialog('open').dialog('center').dialog('setTitle','编辑承研单位信息');
	    			$("#code").textbox("setValue",row.code);
	    			$("#name").textbox("setValue",row.name);
	    			$("#legalperson").textbox("setValue",row.legalperson);
	    			$("#linkperson").textbox("setValue",row.linkperson);
	    			$("#linkphone").textbox("setValue",row.linkphone);
	    			$("#address").textbox("setValue",row.address);
	    			
	    			$("#accountname").textbox("setValue",row.accountname);
	    			$("#depositbank").textbox("setValue",row.depositbank);
	    			$("#account").textbox("setValue",row.account);
	    			$("#jituanflag").combobox("setValue",row.jituanflag);
	    			$("#state").combobox("setValue",row.state);
	    	    }else{
	    	    	$.messager.alert("提示", "请选择要编辑的承研单位信息！", 'info');   
		            return;
	    	    }
	    	});	
	    	
	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    	    if($("#code").textbox("getText")==""){
	    	    	$.messager.alert("提示", "编码不能为空！", 'info');
	              	return;
	    	    }
	    	    if($("#name").textbox("getText")==""){
	    	    	$.messager.alert("提示", "名称不能为空！", 'info');
	              	return;
	    	    }	
	    	    if($("#jituanflag").textbox("getValue")==""){
	    	    	$.messager.alert("提示", "是否集团单位不能为空！", 'info');
	              	return;
	    	    }
	    		if(operation=="add"){
	    			$.post("BasedataUnitService?caozuo=add",
	    			$("#fm").serialize(),                        
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "添加操作成功！", 'info');
		                    initinfo();	                        
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }             
	                });
	    		}else if(operation=="edit"){
	    		    console.log("edit");
	    			$.post("BasedataUnitService?caozuo=edit&oldcode="+code,
	    			$("#fm").serialize(),
	                function (data) {	                	
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "修改操作成功！", 'info');
		                    initinfo();
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
	    	    
	    	    var row=$('#info').datagrid('getSelected');	    	    
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的单位信息！", 'info');   
		            return;
	    		}	    		    		
         	    $.post("BasedataUnitService?caozuo=del&code=" +row.code,                        
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
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getcon(){
	        var condition="";
	        var temp="";
	        if($("#qcode").val()!=""){
	        	condition="code='"+$("#qcode").val()+"'";
	        }
	        if($("#qname").val()!=""){
	        	if(condition!=""){
	        		condition=condition+" and name like '%"+$("#qname").val()+"%'"
	        	}else{
	        		condition="name like '%"+$("#qname").val()+"%'";
	        	}
	        }
	        if($("#qstate").combobox("getValue")!=""){
	        	temp=$("#qstate").combobox("getValue")=="是"?"1":"0";
	        	if(condition!=""){
	        		condition=condition+" and state='"+temp+"'";
	        	}else{
	        		condition="state='"+temp+"'";
	        	}
	        }
	    	return encodeURI(condition);
	    }
	    
	    function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'BasedataUnitService?caozuo=init&con='+getcon()
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
		                        <td id="title_id" class="place" align="left">承研单位信息</td>       
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
	    			<th data-options="field:'code',width:200,align:'center'">编 码</th>								
					<th data-options="field:'name',width:250,align:'left'">名 称</th>	
					<th data-options="field:'legalperson',width:150,align:'center'">法定代表人</th>									
					<th data-options="field:'linkperson',width:150,align:'center'">联系人</th>
					<th data-options="field:'linkphone',width:150,align:'center'">联系电话</th>
					
					<th data-options="field:'address',width:250,align:'center'">地 址</th>
					<th data-options="field:'accountname',width:150,align:'center'">账户名称</th>
					<th data-options="field:'depositbank',width:150,align:'center'">开户银行</th>
					<th data-options="field:'account',width:150,align:'center'">账 号</th>
					<th data-options="field:'jituanflag',width:150,align:'center'">是否集团单位</th>
					<th data-options="field:'state',width:150,align:'center'">是否有效</th>		
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
				&nbsp;单位编码: <input class="easyui-textbox"  id="qcode" style="width:150px"></input>
			    &nbsp;&nbsp;单位名称: <input class="easyui-textbox" id="qname" style="width:200px"></input>
			     &nbsp;&nbsp;是否有效: <select class="easyui-combobox" id="qstate" data-options="panelHeight:'auto'" style="width:200px;">
			        <option value="是" selected>是</option>
			        <option value="否">否</option>
			    </select>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			</div>
		 </div>
	</div>               	             
		        
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlginfo" class="easyui-dialog" style="width:620px;height:570px;padding:5px 5px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">部门信息</div>
    	<form id="fm" method="post" novalidate>
	        <div class="fitem1">
	            <label>单位编码:</label>
	            <input class="easyui-textbox" id="code" name="code"></input>
	        </div>
	        <div class="fitem1">
	            <label>单位名称:</label>
	            <input class="easyui-textbox" id="name"  name="name"></input>
	        </div>
	        <div class="fitem1">
	        	<label>法定代表人:</label>
	        	<input class="easyui-textbox" id="legalperson" name="legalperson"/>
	        </div>
	        <div class="fitem1">
	        	<label>联系人:</label>
	        	<input class="easyui-textbox" id="linkperson" name="linkperson"/>
	        </div>
	        <div class="fitem1">
	        	<label>联系电话:</label>
	        	<input class="easyui-textbox" id="linkphone" name="linkphone"/>
	        </div>
	        <div class="fitem1">
	        	<label>地   址:</label>
	        	<input class="easyui-textbox" id="address" name="address"/>
	        </div>
	        <div class="fitem1">
	        	<label>账户名称:</label>
	        	<input class="easyui-textbox" id="accountname" name="accountname"/>
	        </div>
	        <div class="fitem1">
	        	<label>开户银行:</label>
	        	<input class="easyui-textbox" id="depositbank" name="depositbank"/>
	        </div>
	        <div class="fitem1">
	        	<label>账  号:</label>
	        	<input class="easyui-textbox" id="account" name="account"/>
	        </div>
	        <div class="fitem1">
	        	<label>是否集团内单位:</label>
	        	<select class="easyui-combobox" id="jituanflag" name="jituanflag" data-options="panelHeight:'auto'" style="width:450px;">
			        <option value="是">是</option>
			        <option value="否" selected>否</option>
			    </select>
	        </div>
	        <div class="fitem1">
	        	<label>是否有效:</label>
	        	<select class="easyui-combobox" id="state" name="state" data-options="panelHeight:'auto'" style="width:450px;">
			        <option value="是" selected>是</option>
			        <option value="否">否</option>
			    </select>
	        </div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlginfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
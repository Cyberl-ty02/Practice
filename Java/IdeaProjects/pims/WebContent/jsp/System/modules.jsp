<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
//设置页面不缓存
String path = request.getContextPath();
//获取basePath
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>
    <title>系统模块信息管理</title>
    <!--引入easyui的css和js文件 -->
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" />

    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>

    <script type="text/javascript">
        var operation; // 操作变量类型（add还是edit）
        var mno;       // 记录被选中要编辑模块的编码，在点编辑按钮时使用
        //------------$(function ())开始--------------//
        $(function () {
            //初始化Combobox控件:上级模块（查询条件中的,弹出对话框）
            $("#pmname").combobox({
            	url: 'SystemModuleService?caozuo=initpname',
                valueField: 'mno',
                textField: 'mname',
                panelHeight: 'auto'
            });
            //初始化Combobox控件:上级模块（弹出对话框中的）
            $("#dpmname").combobox({
            	url: 'SystemModuleService?caozuo=initpname',
                valueField: 'mno',
                textField: 'mname',
                panelHeight: 'auto'
            });
            //初始化DataGrid控件信息
            $("#modulesinfo").datagrid({
            	//表格属性
            	loadMsg: "数据加载中，请等待...",
            	iconCls: 'icon-issue',
                nowrap: true,
                striped: true,
                collapsible: true,
                rownumbers: true,
                pagination: true,
                singleSelect: true,
                autoRowHeight: true,
                fitColumns: false,
                pageSize: 10,
                pageList: [10, 20, 30, 40],
                //列属性
                url: 'SystemModuleService?caozuo=init&con='+getQueryCondition()
            });

	        //添加操作，弹出对话框
	    	$("#add").click(function () {
	    	    operation="add";
	    	    //打开对话框
	    		$('#dlgmoduldeinfo').dialog('open').dialog('center').dialog('setTitle','添加模块信息');
	    	    //清空对话框中的内容
	    		$('#fm').form('clear');
	    	});
	    	//编辑操作,弹出对话框
	    	$("#edit").click(function () {
	    	    var row=$('#modulesinfo').datagrid('getSelected');
	    	    //判断是否选中一行
	    	    if(row){
	    	    	//记录要编辑的模块编码
	    	        mno=row.mno;
	    	        $('#fm').form('clear');
	    	    	operation="edit";
	    	    	//打开对话框
	    			$('#dlgmoduldeinfo').dialog('open').dialog('center').dialog('setTitle','编辑模块信息');
	    			$("#dmno").val(row.mno);
	    			$("#dmname").val(row.mname);
	    			$("#dpmname").combobox("setValue",row.pmno);
	    			$("#dicon").val(row.image);
	    			$("#durl").val(row.url);
	    			$("#dcode").val(row.code);
	    			$("#demo").val(row.demo);
	    	    }else{
	    	    	//没有选中行时，提示
	    	    	$.messager.alert("提示", "请选择要编辑的模块信息！", 'info');
		            return;
	    	    }
	    	});

	    	//对话框中的保存按钮操作:完成添加和编辑操作
	    	$("#save").click(function(){
	    		//判断模块编码和模块名称是否为空
	    	    if($("#dmno").val()==""){
	    	    	$.messager.alert("提示", "模块编码不能为空！", 'info');
	              	return;
	    	    }
	    		//判断模块名称是否为空
	    	    if($("#dmname").val()==""){
	    	    	$.messager.alert("提示", "模块名称不能为空！", 'info');
	              	return;
	    	    }
	    		//判断上级模块是否为空
        	    if($("#dpmname").combobox('getValue')==""){
        	    	$.messager.alert("提示", "上级模块不能为空！", 'info');
                  	return;
        	    }
	    		if(operation=="add"){
	    			//添加操作
	    			$.post("SystemModuleService?caozuo=add",
	    			$("#fm").serialize(),
	                function (data) {
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "添加操作成功！", 'info');
		                    initmoduleinfo();
		                    return;
		                }else {
		                    $.messager.alert("提示",value.reason, 'info');
		                    return;
		                }
	                });
	    		}
	    		//编辑操作
	    		else if(operation=="edit"){
	    			$.post("SystemModuleService?caozuo=edit&oldmno="+mno,
	    			$("#fm").serialize(),
	                function (data) {
	                    var value=eval("("+data+")")
		            	if (value.ret == "0") {
		                	$.messager.alert("提示", "修改操作成功！", 'info');
		                    initmoduleinfo();
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
	    	    var row=$('#modulesinfo').datagrid('getSelected');
	    		if(row=="" || row==null){
	    			$.messager.alert("提示", "请选择要删除的模块信息！", 'info');
		            return;
	    		}
         	    $.post("SystemModuleService?caozuo=delete&mno=" +row.mno,
	            function (data) {
	                var value=eval("("+data+")")
	                //判断是否删除成功
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "此操作成功！", 'info');
	                    initmoduleinfo();
	                    return;
	                }else {
	                    $.messager.alert("提示", "本次操作失败！", 'info');
	                    return;
	                }
	             });
	    	});

	    	//查询操作
	    	$("#query").click(function(){
	    		initmoduleinfo();
	    	});
	    });
	    //-----------$(function ())结束------------//

	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getQueryCondition(){
	        var condition="";
	        //模块编码
	        if($("#mno").val()!=""){
	        	condition="mno='"+$("#mno").val()+"'";
	        }
	        //模块名称
	        if($("#mname").val()!=""){	
	        	//判断是否有模块编码条件
	        	if(condition!=""){
	        		condition=condition+" and mname like '%"+$("#mname").val()+"%'"  //模糊查询
	        	}else{
	        		condition="mname like '%"+$("#mname").val()+"%'";
	        	}
	        }
	        if($("#pmname").combobox('getText')!=""){
	        	//上级模块名称
		        var pmno=$("#pmname").combobox('getValue');
	        	//判断是否有模块编码条件
		        if(pmno!=""){
		           if(condition!=""){
		        	   //有条件时，加上and
		        		condition=condition+" and pmno='"+pmno+"'" //精确查询
		        	}else{
		        		condition="pmno='"+pmno+"'";
		        	}
		        }
	        }
	    	return encodeURI(condition);
	    }
		//初始化模块信息
	    function initmoduleinfo(){
	    	$("#modulesinfo").datagrid({
	             loadMsg: "数据加载中，请等待...",
	             url: 'SystemModuleService?caozuo=init&con='+getQueryCondition()
            });
	    }

	    //-----------自定义函数结束------------//
    </script>
  </head>

  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:96%;">
     <div style="height:98%;">
         <!-- 标题部分开始   -->
	     <form id="frmModuleInfo" >
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">模块信息</td>
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
	 	 <table id="modulesinfo" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0"
	        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
	    	<thead>
	    		<tr>
					<!-- 表头信息 -->
	    			<th data-options="field:'mno',width:100,align:'center'">模块编码</th>
					<th data-options="field:'mname',width:180,align:'center'">模块名称</th>
					<th data-options="field:'pmno',width:100,align:'center'">上级模块编码</th>
					<th data-options="field:'pmname',width:180,align:'center'">上级模块名称</th>
					<th data-options="field:'image',width:150,align:'left'">图标</th>
					<th data-options="field:'url',width:200,align:'left'">模块地址</th>
					<th data-options="field:'code',width:100,align:'center'">模块简码</th>
					<th data-options="field:'demo',width:130,align:'center'">备注</th>
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
				&nbsp;模块编码: <input class="easyui-textbox"  id="mno" style="width:120px"></input>
			    &nbsp;&nbsp;模块名称: <input class="easyui-textbox" id="mname" style="width:120px"></input>
			    &nbsp;&nbsp;上级模块名称: <input class="easyui-combobox" id="pmname" style="width:150px"></input>
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>
			</div>
		 </div>
	</div>

    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlgmoduldeinfo" class="easyui-dialog" style="width:400px;height:370px;padding:10px 10px" closed="true" buttons="#dlg-buttons">
    	<div class="ftitle">系统模块信息</div>
    	<form id="fm" method="post" novalidate>
	        <div class="fitem">
	            <label>模块编码:</label>
	            <input id="dmno" name="dmno"></input>
	        </div>
	        <div class="fitem">
	            <label>模块名称:</label>
	            <input id="dmname"  name="dmname"></input>
	        </div>
	        <div class="fitem">
	        	<label>上级模块:</label>
	        	<input id="dpmname" name="dpmname"/>
	        </div>
	        <div class="fitem">
	        	<label>模块图标:</label>
	        	<input id="dicon" name="dicon"/>
	        </div>
	        <div class="fitem">
	        	<label>模块链接:</label>
	        	<input id="durl" name="durl"/>
	        </div>
	        <div class="fitem">
	        	<label>模块简码:</label>
	        	<input id="dcode" name="dcode"/>
	        </div>
	        <div class="fitem">
	        	<label>备  注:</label>
	        	<input id="demo" name="demo"/>
	        </div>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="save" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">保 存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgmoduldeinfo').dialog('close')" style="width:90px">关 闭</a>
	</div>
	<!-- 点击增加按钮弹出的对话框结束 -->
  </body>
</html>
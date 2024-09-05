<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>角色权限</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="Stylesheet" href="<%=basePath %>css/zTreeStyle.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.ztree.excheck-3.5.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/CommonAll.js"></script>
    
    <script type="text/javascript">
    	var setting = {            
            check:{
                enable:true
                },
            view:{
                txtSelectedEnable: false
            },
            data: {
                simpleData: {
                    enable: true
                }
            }
        };       
        var zNodes;         
        $(function () {
            //初始化树                     
            createTree("");
            //初始化DataGrid
            $('#roles').datagrid({               
                iconCls: 'icon-role',
                loadMsg: "数据加载中，请等待...",
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
                url: 'SystemRoleService?caozuo=init&con='+getQueryCon(),
                //datagrid的单击事件
                onClickRow: function (rowIndex, rowData) {
                    var row = $("#roles").datagrid("getSelected");
                    var rolename = row.rolename;
                    var roledemo = row.demo;
                    $("#rolename").textbox("setValue",rolename);
                    $("#demo").textbox("setValue",roledemo);                  
                    createTree(rolename);
                }
            });
           
            // 查询操作
            $("#query").click(function () {
                $("#roles").datagrid({
                    loadMsg: "数据加载中，请等待...",
                    url: 'SystemRoleService?caozuo=init&con='+getQueryCon()
                });
                createTree($("#rolename").val());
            });
            // 确定操作
            $("#save").click(function () {

                var rolename = $("#rolename").val();
                var roledemo = $("#demo").val();
                if (rolename == "") {
                    $.messager.alert("提示", "角色名称不能为空！", 'info');
                    return;
                }
                $.post("SystemRoleService?caozuo=add&rolename=" + encodeURI(rolename) + "&demo=" + encodeURI(roledemo) + "&nodes=" + getCheckedNodesId(),
                function (data) {
                    var value=eval("("+data+")");
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "修改操作成功！", 'info');
	                    initroleinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示",value.reason, 'info');
	                    return;
	                }
                });
            });

            //删除操作
            $("#delete").click(function () {
                if ($("#rolename").val() == "admin") {
                    $.messager.alert("提示", "admin为管理员角色，不允许删除操作！", 'info');
                    return;
                }
                var rolename=$("#rolename").val();
                $.post("SystemRoleService?caozuo=delete&rolename=" +encodeURI(rolename),
                function (data) {
                    var value=eval("("+data+")");
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "操作成功！", 'info');
	                    initroleinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示",value.reason, 'info');
	                    return;
	                }
                });
            });
            //刷新操作
            $("#refresh").click(function(){
            	initroleinfo();
            });            
        });
        // 获得选择的树的节点编码
        function getCheckedNodesId() {
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var strNodesId="";
            var nodes = zTree.getCheckedNodes(true);
            for (var i = 0; i < nodes.length; i++) {
                strNodesId = strNodesId + nodes[i].id;
                if (i < nodes.length - 1)
                    strNodesId = strNodesId + ";";
            }
            return strNodesId;
        }
        // 获得查询条件
        function getQueryCon() {
            var strQueryCon = "";
            if ($("#rolename").val() != "")
                strQueryCon = "rolename='" + $("#rolename").val() + "'";
            if ($("#demo").val() != "") {
                if (strQueryCon == "") {
                    strQueryCon = "demo like'%" + $("#demo").val() + "%'";
                }
                else {
                    strQueryCon = strQueryCon + " and demo like '%" + $("#demo").val() + "%'";
                }
            }            
            return encodeURI(strQueryCon);
        }
        function createTree(rolename) {
            //初始化树           
            $.ajax({
                type: "POST", 			 //使用POST方法访问后台
                dataType: "json",             //返回json格式的数据
                url: "SystemRoleService?caozuo=inittree&rolename=" + encodeURI(rolename),                     
                complete: function () {
                    $("#load").hide(3000);
                },
                success: function (msg) {	//msg为返回s的数据，在这里做数据绑定
                    removeWaiting();
                    zNodes = msg;                        
                    $.fn.zTree.init($("#tree"), setting, zNodes);
                }
            });
        }
        function initroleinfo() {
            $("#rolename").textbox("setValue","");
            $("#demo").textbox("setValue","");
            $("#roles").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'SystemRoleService?caozuo=init&con='+""
            });
            createTree("");
        }    
    </script>
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:90%;">
     <div style="height:100%;">
         <!-- 标题部分开始   -->
	     <form id="frmModuleInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">角色权限</td>       
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
	     <table style="height:100%;width:100%;margin-top:20px;">
	     	<tr style="width:100%;">
	     		<td valign="top">
	     			<ul id="tree" class="ztree" 
                    	style="border: 1pt dashed #f7b7f7; width:200px; height:98%; overflow:auto; margin-left:10px; margin-right:0;margin-top:0px;">
                	</ul>
	     		</td>
	     		<td style="width:15px"></td>
	     		<td style="width:100%">
		     		<div style="height:100%;"> 
					 	 <table id="roles" class="easyui-datagrid" width="100%" style="height:100%;" border="0" cellpadding="0" cellspacing="0" 
					        data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
					    	<thead>
					    		<tr>   			
					    			<th data-options="field:'rolename',width:250,align:'center'">角色名称</th>								
									<th data-options="field:'demo',width:250,align:'center'">角色说明</th>						
					    		</tr>
					    	</thead>
					     </table>
				     </div>	 
				     <div id="tb" style="padding:0px;height:auto">	        
						<div>				
							&nbsp;角色名称: <input class="easyui-textbox"  id="rolename" style="width:200px"></input>
						    &nbsp;&nbsp;角色说明: <input class="easyui-textbox" id="demo" style="width:300px"></input>			   										
						</div>			
						<div style="margin-bottom:5px;margin-top:5px">
							<a id="save" class="easyui-linkbutton" iconCls="icon-save"  plain="true" >保 存</a>									
							<a id="delete" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删 除</a>
							<a id="refresh" class="easyui-linkbutton" iconCls="icon-reload" plain="true">刷 新</a>
							<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>
						</div>			
					 </div>
				 </td>
			  </tr>
		 </table>
	 </div>
  </body>
</html>
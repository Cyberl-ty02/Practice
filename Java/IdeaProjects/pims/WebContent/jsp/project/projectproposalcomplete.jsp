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
        	$("#qproject").combobox({
        		url: 'ProjectProposalService?caozuo=initcompleteinfoproject',
                valueField: 'projectcode',
                textField: 'projectname',
                panelHeight: 'auto',
                editable:true
        	});
        	$("#edition").combobox({
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
                pageList: [10, 20, 30, 40]
            });	
            
	    	//查询操作
	    	$("#query").click(function(){
	    		if($("#edition").combobox("getValue")==""){
	    	    	$.messager.alert("提示", "版本不能为空！", 'info');
	              	return;
	    	    }
	    		initinfo();
	    	}); 
	    	
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    //获得查询条件
	    function getcon(){
	        var condition="";
	        var temp="";
	        
	        if($("#qproject").combobox("getValue")!=""){
	        	temp=$("#qproject").combobox("getValue");
		        if(condition!=""){
	        		condition=condition+" and code='"+temp+"'";
	            }else{
	        		condition="code='"+temp+"'";
	            }	
	        }	       
	    	return encodeURI(condition);
	    }
	    
	    function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'ProjectProposalService?caozuo=initcomplete&edition='+$("#edition").combobox("getValue")+'&con='+getcon()
            });
	    }
	    
    </script>    
  </head>
  
  <body style="margin-top: 0px; margin-left: 4px; margin-right: 0px;height:99%;">
     <div style="height:96%;">
         <!-- 标题部分开始   -->
         
	     <form id="frmInfo" >
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">建议书提交情况</td>       
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
					<th data-options="field:'code',width:120,align:'center'">项目编码</th>	
					<th data-options="field:'name',width:250,align:'center'">项目名称</th>
					<th data-options="field:'publishmode',width:120,align:'center'">发布方式</th>		
					<th data-options="field:'unit',width:250,align:'center'">拟发布单位</th>
					<th data-options="field:'edition',width:120,align:'center'">版 本</th>			
					<th data-options="field:'completeunit',width:250,align:'center'">建议书已提交单位</th>	
					<th data-options="field:'nocompleteunit',width:250,align:'center'">建议书未提交单位</th>
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:10px;height:auto">	     	
				<!-- 查询部分 -->
			<div>	
			    &nbsp;&nbsp;版 本&nbsp;&nbsp;<input class="easyui-combobox" id="edition"  name="edition"></input>		   
			    &nbsp;&nbsp;项目名称: <input class="easyui-combobox" id="qproject" style="width:300px"></input>
				
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>							
			   
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
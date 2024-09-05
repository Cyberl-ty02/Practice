<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN">
<html style="height:100%;">
  <head>
    <base href="<%=basePath%>"></base>  
    <title>单位项目指南管理</title>
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
        var showflag=false;
        //------------$(function ())开始--------------//
        $(function () {
        	hideshow();	  
        	$("#unit").combobox({
            	url: 'ProjectGuideService?caozuo=initunit',
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
                url: 'ProjectGuideService?caozuo=init&con='+getcon(),
                onLoadSuccess:function(){
                	MergeCells('info','firstcode,firstname,secondcode,secondname');
                }
            });	
             //项目合同综合信息
	    	$("#print").click(function () {	    		
	    		$("#fm").attr("action","ProjectGuideService?caozuo=print&con="+getcon());
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
	    	//显示/隐藏列操作
	    	$("#hideshow").click(function(){
	    		hideshow();
	    	});
	    	
	    });
	    //-----------$(function ())结束------------//
	    
	    //-----------自定义函数开始-----------------//
	    function hideshow(){
	    	if(showflag){
    			$('#info').datagrid('showColumn','firstcode');
    			$('#info').datagrid('showColumn','firstname');
    			$('#info').datagrid('showColumn','secondcode');
    			$('#info').datagrid('showColumn','secondname');
    			$('#info').datagrid('showColumn','thirdcode');
    			$('#info').datagrid('showColumn','thirdname');
    			$('#info').datagrid('showColumn','year');
    			showflag=false;
    		}else{
    			$('#info').datagrid('hideColumn','firstcode');
    			$('#info').datagrid('hideColumn','firstname');
    			$('#info').datagrid('hideColumn','secondcode');
    			$('#info').datagrid('hideColumn','secondname');
    			$('#info').datagrid('hideColumn','thirdcode');
    			$('#info').datagrid('hideColumn','thirdname');
    			$('#info').datagrid('hideColumn','year');
    			showflag=true;
    		}
	    }
	    //获得查询条件
	    function getcon(){
	        var condition="";
	        var temp="";
	        if($("#qyear").textbox("getText")!=""){
	        	condition="year='"+$("#year").textbox("getText")+"'";
	        }
	        
	        if($("#name").textbox("getText")!=""){
	        	temp=$("#name").textbox("getText");
		        if(condition!=""){
	        		condition=condition+" and name like '%"+temp+"%'";
	            }else{
	        		condition="name like '%"+temp+"%'";
	            }	
	        }
	        if($("#unit").combobox("getValue")!=""){
	        	temp=$("#unit").combobox("getValue");
		        if(condition!=""){
	        		condition=condition+" and unit like '%"+temp+"%'";
	            }else{
	        		condition="unit like '%"+temp+"%'";
	            }	
	        }
	        console.log(condition);
	    	return encodeURI(condition);
	    }
	    
	    function initinfo(){
	    	$("#info").datagrid({                
	             loadMsg: "数据加载中，请等待...",                
	             url: 'ProjectGuideService?caozuo=init&con='+getcon()
            });
	    }
	    //合并单元格方法
        /**
        * EasyUI DataGrid根据字段动态合并单元格
        * @param fldList 要合并table的id, 此例子中是dg
        * @param fldList 要合并的列,多个列用逗号分隔(例如："tempParam,flowCode,queryParam");
        */
        function MergeCells(tableID, fldList) {
            var Arr = fldList.split(",");
            var dg = $('#' + tableID);
            var fldName;
            var RowCount = dg.datagrid("getRows").length;
            var span;
            var PerValue = "";
            var CurValue = "";
            var length = Arr.length - 1;
            for (i = length; i >= 0; i--) {
                fldName = Arr[i];
                PerValue = "";
                span = 1;
                for (row = 0; row <= RowCount; row++) {
                    if (row == RowCount) {
                        CurValue = "";
                    }else {
                        CurValue = dg.datagrid("getRows")[row][fldName];
                    }
                    if (PerValue == CurValue) {
                        span += 1;
                    }else {
                        var index = row - span;
                        dg.datagrid('mergeCells', {
                            index: index,
                            field: fldName,
                            rowspan: span,
                            colspan: null
                        });
                        span = 1;
                        PerValue = CurValue;
                    }
                }
            }
        }
	    //-----------自定义函数结束------------//
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
		                        <td id="title_id" class="place" align="left">项目指南</td>       
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
	    			<th data-options="field:'uid',width:100,align:'center',hidden:'true'">uid</th>			
					
					<th data-options="field:'firstcode',width:120,align:'center'">领域编码</th>	
					<th data-options="field:'firstname',width:250,align:'center'">领域名称</th>
					<th data-options="field:'secondcode',width:120,align:'center'">课题编码</th>	
					<th data-options="field:'secondname',width:250,align:'center'">课题名称</th>
					<th data-options="field:'thirdcode',width:120,align:'center'">专题编码</th>	
					<th data-options="field:'thirdname',width:250,align:'center'">专题名称</th>
					<th data-options="field:'year',width:80,align:'center'">年 度</th>	    			
					<th data-options="field:'code',width:120,align:'center'">条目编码</th>	
					<th data-options="field:'name',width:250,align:'center'">条目名称</th>
					<th data-options="field:'targetandcontent',width:300,align:'left'">研究目标及主要内容</th>	    			
					<th data-options="field:'maintarget',width:300,align:'left'">主要指标</th>	
					<th data-options="field:'fund',width:100,align:'center'">经 费（万元）</th>
					<th data-options="field:'period',width:150,align:'center'">研究周期</th>	
					<th data-options="field:'publishmode',width:150,align:'center'">发布方式</th>
					<th data-options="field:'unit',width:250,align:'center'">拟发布单位</th>
					<th data-options="field:'demo',width:150,align:'center'">备注</th>
	    		</tr>
	    	</thead>
	     </table>	 
	     <div id="tb" style="padding:10px;height:auto">	        
			<!-- 查询部分 -->
			<div>
			    &nbsp;&nbsp;年 度: <input class="easyui-textbox" id="qyear" style="width:120px"></input>
			    &nbsp;&nbsp;条目名称: <input class="easyui-textbox" id="name" style="width:200px"></input>
				&nbsp;&nbsp;承研单位: <input class="easyui-combobox" id="unit" style="width:200px"></input>				
				&nbsp;&nbsp;<a id="query" class="easyui-linkbutton" iconCls="icon-search" plain="true">查 询</a>
				&nbsp;&nbsp;<a id="print" class="easyui-linkbutton" iconCls="icon-print" plain="true">输出项目指南</a>							
				&nbsp;&nbsp;<a id="hideshow" class="easyui-linkbutton" iconCls="icon-back" plain="true">隐藏/显示列</a>							
			</div>
			</div>
		 </div>
	</div>               	             
	<form id="fm" action="" method="post">
	</form>
  </body>
</html>
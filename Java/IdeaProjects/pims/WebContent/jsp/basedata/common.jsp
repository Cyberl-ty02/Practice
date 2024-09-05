<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	    <base href="<%=basePath%>">    
	    <title>通用数据管理</title>
	    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
	    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" />       
	    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
	    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
	           
	    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
	    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
	    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
	    
		<script type="text/javascript">
			var h =parent.document.body.clientHeight-135;       
			$(function () {
			    $("div").height(h);
			    $("#BaseDataTab").tabs({
			        onSelect: function () {
			            openTab();
			        }
			    });
			});
			function openTab() {
			    var tab = $("#BaseDataTab").tabs('getSelected');
			    var tbId = tab.attr("id");
			    var tbIframe = $("#" + tbId + " iframe:first-child");
			    tbIframe.attr("src", "<%=basePath%>jsp/basedata/"+tbId+".jsp");          
			}
		</script>
	</head>
	<body  style="overflow:hidden;margin-top: 0px; margin-left: 0px; margin-right: 0px;">

    <!-- 标题部分   -->
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td>
                <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath%>images/general/m_mpbg.gif)">
                    <tr>
                        <td id="title_id" class="place" align="left">通用数据管理</td>
                        <td>&nbsp;</td>
                        <td align="right">&nbsp;</td>
                        <td width="3">
                            <img src="<%=basePath%>images/general/m_mpr.gif" width="3" height="32" alt="" />
                        </td>
                    </tr>                    
                 </table>
             </td>
        </tr>        
    </table> 
       
    <div id="BaseDataTab"  style="vertical-align:top; margin-left:0px;margin-bottom:0px">
        <div title="基础数据类别" id="basedatainfo"  style="padding:1px" > 
            <iframe frameborder="0"  style="width:99%;height:99%"></iframe>                       
        </div>
        <div title="基础数据" id="basedata"  style="padding:1px" > 
            <iframe frameborder="0"  style="width:99%;height:99%"></iframe>                       
        </div>
        <div title="密级管理" id="secretlevel"  style="padding:1px" > 
            <iframe frameborder="0" style="width:99%;height:99%"></iframe>                       
        </div>
    </div> 
  </body>
</html>
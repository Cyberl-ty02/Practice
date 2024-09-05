<%@ page language="java" import="java.util.*,com.tjut.util.Common" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
HttpSession mySession = request.getSession();
String session_username=mySession.getAttribute("username").toString();
String session_employee=mySession.getAttribute("ename").toString();
/* String session_pflag=mySession.getAttribute("pflag").toString(); */
String info=Common.getDate();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta name="renderer" content="webkit">
    <base href="<%=basePath%>">
    <title>项目过程管理系统 V1.0.0</title>
    
    <link rel="stylesheet" type="text/css" href="css/easyui.css" />
    <link rel="stylesheet" type="text/css" href="css/icon.css" />   
    <link rel="stylesheet" type="text/css" href="css/default.css" />
    
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="js/left.js"> </script>
    
    <script type="text/javascript">
        var username="<%=session_username%>";
        <%-- var pflag="<%=session_pflag%>"; --%>       
        setInterval("heartbeat()",20*60*1000);//心跳保持session--15分钟
       
    </script>    
  </head>  
  <body class="easyui-layout" style="overflow-y: hidden" scroll="no">
	<noscript>
		<div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;">
		    <img src="images/noscript.gif" alt='抱歉，请开启脚本支持！' />
		</div>
	</noscript>
    <div region="north" split="true" border="false" style="overflow: hidden; height: 50px;
        background: url(images/left/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        line-height: 40px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
        <span style="float:right; padding-right:20px; " class="head" id="head1">您好，<%=session_employee %><%=info %>  <a href="#" id="loginOut">退 出</a></span>
        <span style="padding-left:20px; font-size: 20px;float:left; "><img src="images/logo1.png" style="vertical-align:middle;" width="40" height="40" align="left" />&nbsp;&nbsp;项目过程管理系统</span>
    </div>
    
    <div region="west" hide="true" split="true" title="导航菜单" style="width:250px;" id="west">
        <div id="nav" class="easyui-accordion" fit="true" border="false">
		<!--  导航内容 -->				
		</div>
    </div>
    <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
        <div id="tabs" class="easyui-tabs"  fit="true" border="false" >
        	<div title="我的工作台" style="padding:0px;overflow:hidden;  " >
				<iframe src="${pageContext.request.contextPath}/page/index.html" style="width:100%;height:100%"></iframe>
			</div>
		</div>
    </div>  
    <!--  点击增加按钮弹出的对话框开始  -->
    <div id="dlgpassword" class="easyui-dialog"  data-options="modal:true" style="width:360px;height:210px;padding:10px 15px" closed="true" closable="false" buttons="#dlg-buttons">
    	
    	<form id="fm" method="post" novalidate>
    	    <div class="fitem">
	                    密码规则：<br>
	                     密码应包括大写字母、小写字母和数字；长度不小于8。
	        </div><br>
	        <div class="fitem">
	            <label>输入密码:</label>
	            <input type="password" id="firstpassword" name="firstpassword"></input>
	        </div>
	        <br>
	        <div class="fitem">
	            <label>再次输入:</label>
	            <input type="password" id="secondpassword"  name="secondpassword"></input>
	        </div>
	        
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:void(0)"  id="savepassword" class="easyui-linkbutton"  iconCls="icon-ok" style="width:90px">修 改</a>
		<!-- <a href="javascript:void(0)" class="easyui-linkbutton"  iconCls="icon-cancel" onclick="javascript:$('#dlgpassword').dialog('close')" style="width:90px">关 闭</a> -->
	</div>	
  </body>
</html>
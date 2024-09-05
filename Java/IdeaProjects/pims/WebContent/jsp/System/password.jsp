<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
HttpSession mySession = request.getSession();
String username=mySession.getAttribute("username").toString();
String employeename=mySession.getAttribute("employeename").toString();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">    
    <title>密码修改</title>
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/dlgform.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/general.css" /> 
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/icon.css" />
    <link type="text/css" rel="stylesheet" href="<%=basePath %>css/easyui.css" /> 
           
    <script type="text/javascript" src="<%=basePath %>js/jquery.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath %>js/easyui-lang-zh_CN.js"></script>
    
	<script type="text/javascript">
		var username = "<%=username%>";
		var employeename="<%=employeename%>";
		$(function () {
		    $("#employeename").textbox("setValue",employeename);
		    $("#username").textbox("setValue",username);
		    $("#employeename").textbox('readonly',true);
		    $("#username").textbox('readonly',true);
		    $("#oldpassword").textbox("setValue","");
		   
		    $("#confirm").click(function(){
		        updatePassword();
		    });	    
		});
		// 按钮单击处理
		function updatePassword() {	
		    var oldpassword = $("#oldpassword").val();
		    var newpassword = $("#newpassword").val();
		    var confirmpassword = $("#confirmpassword").val();
		    if (newpassword != confirmpassword) {
		        $.messager.alert("提示", "两次密码输入不一致，请重新输入！", 'error');
		        $("#newpassword").textbox("setValue","");
		        $("#confirmpassword").textbox("setValue","");     
		        return;
		    }
		    var pattern ="^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*).{8,}$";
		    if(!newpassword.match(pattern)){
				$.messager.alert("提示", "输入的密码和规则不一致，请重新输入！", 'info');   
            	return;
			}
		    $.post("SystemPasswordService",{username:"<%= username%>","oldpassword":oldpassword,"confirmpassword":confirmpassword},
		        function (data) {
		            var value=eval("("+data+")")
	            	if (value.ret == "0") {
	                	$.messager.alert("提示", "重置密码操作成功！", 'info');
	                    initUserinfo();	                        
	                    return;
	                }else {
	                    $.messager.alert("提示",value.reason, 'info');
	                    return;
	                }
		        });           
		}
</script>    

</head>
<body style="text-align:enter;margin-top: 0px; margin-left: 0px; margin-right: 0px;">
  <center>
    <form id="frmChangePassword" >
    <div style="height:98%;margin:0 auto;">
        <!-- 标题部分开始   -->
	    <form id="frmModuleInfo" >		              
		     <table width="100%" cellpadding="0" cellspacing="0" border="0">
		        <tr>
		        	<td>
		        		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background:url(<%=basePath %>images/general/m_mpbg.gif)">
		                    <tr>
		                        <td id="title_id" class="place" align="left">密码修改</td>       
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
	    <!-- 标题部分   --> 
	          
	    <div class="easyui-panel" style="background:#f7f7f7;width:100%;height:96%;max-width:100%;padding:0px 30%;">
	        <div style="margin:20px 0;"></div>
	        <div style="margin-bottom:10px;">
                              用 户 名：<input class="easyui-textbox" id="username" style="width:260px;height:30px;padding:12px" data-options="prompt:'Username',iconCls:'icon-man',iconWidth:38">
            </div>
            <div style="margin-bottom:10px;">
                              员工姓名：<input class="easyui-textbox" id="employeename" style="width:260px;height:30px;padding:12px" data-options="prompt:'Username',iconCls:'icon-man',iconWidth:38">
            </div>
	        <div style="margin-bottom:10px">
	                     原 密 码：<input class="easyui-textbox" type="password" id="oldpassword" style="width:260px;height:30px;padding:12px" data-options="prompt:'请输入原密码...',iconCls:'icon-lock',iconWidth:38">
	        </div>
	        <div style="margin-bottom:10px">
	                    新 密 码：<input class="easyui-textbox" type="password" id="newpassword"  style="width:260px;height:30px;padding:12px" data-options="prompt:'请输入新密码...',iconCls:'icon-password',iconWidth:38"> 密码应包括大写字母、小写字母和数字；长度不小于8
	        </div>
	        <div style="margin-bottom:10px">
	                     确认密码：<input class="easyui-textbox" type="password" id="confirmpassword"  style="width:260px;height:30px;padding:12px" data-options="prompt:'请再输入一次新密码...',iconCls:'icon-password',iconWidth:38"> 密码应包括大写字母、小写字母和数字；长度不小于8
	        </div>
	        <div>
	            <a class="easyui-linkbutton" id="confirm" data-options="iconCls:'icon-ok'" style="padding:5px 0px;width:320px;height:30px;">
	                <span style="font-size:14px;">确 定</span>
	            </a>	            
            </div>
	    </div>	    
	  </div>
    </form>
    </center>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String projectno=request.getParameter("projectno");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

</head>
<body>
<script type="text/javascript">
	$(function(){		
		$.post("YearProjectFundsAssign?caozuo=getinfo&projectcode="+<%=projectno%>,
		function (data) {
	          var value=eval("("+data+")");
	          if (value!=null) {
	        	 $("#dprojectcode").val(value.projectno);
				 $("#dprojectname").val(value.projectname);
	             $("#dbegindate").val(value.begindate);
	             $("#denddate").val(value.enddate);
	             $("#dperiod").val(value.period);
	          }				           
		});
	});
</script>
    <form id="fm" method="post" action="" novalidate enctype="multipart/form-data">
   	    <div class="ftitle">项目基本信息</div>
   	    <table>    	    	
    	    <tr>	    
		        <td>
 	       		    <div class="fitem" align="right">
	            		<label align="right">项目编码</label>
	            		<input id="dprojectcode"  name="dprojectcode"></input>
		            </div>
  	       		 </td>
  	       		 <td colspan="2">
  	       		    <div class="fitem" align="right">
			        	<label align="right">项目名称</label>				       
			        	<input align="left" id="dprojectname" name="dprojectname" style="width:500px;"></input>
		            </div>
  	       		 </td>   	       		  
	        </tr>		       
            <tr>
	            <td>
			        <div class="fitem">
			        	<label align="right">开始时间</label>
			        	<input id="dbegindate" name="dbegindate"/>
			        </div>
			    </td>
			    <td>
			        <div class="fitem">
			        	<label align="right">结束时间</label>
			        	<input id="denddate" name="denddate"/>
			        </div>
			    </td>
			    <td>
			        <div class="fitem">
			        	<label align="right">研制周期</label>
			        	<input id="dperiod" align="left" name="dperiod"></input>				        	
			        </div>
		        </td>
            </tr>
        </table>
    </form>
    <div class="ftitle">项目经费构成(万元)&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <div style="margin:20px 0;"></div>
    <div class="easyui-tabs" style="width:700px;height:auto">
    	<div title="My Documents" style="padding:10px">
            sdfdsf
        </div>
        <div title="Help" style="padding:10px">
            This is the help content.
        </div>
    </div>
    
</body>
</html>
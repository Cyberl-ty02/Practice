package com.tjut.system;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBRecord;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.tjut.util.WebUtil;

@WebServlet("/SystemEmployeeService")
public class SystemEmployeeService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public SystemEmployeeService() {
        super();        
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){	
		case "inittype":
			result=gettype();			
			WebUtil.handleResponse(response, result);
			break;
		case "initdepartment":
			result=getDepartmentName(request);			
			WebUtil.handleResponse(response, result);
			break;
		case "initcombobox":
			String code=WebUtil.getRequestParam(request, "code");
			result=WebUtil.getComboData("basedata", "name", "name", "code",code);			
			WebUtil.handleResponse(response, result);
			break;
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getInfo(con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		case "add":			
			addinfo(request,response);
			break;
		case "edit":
			editinfo(request,response);
			break;
		case "del":						
			deleteEmployeeInfo(request,response);			
			break;
		}		
	}
    //获得部门信息
  	private String gettype(){  		
  		String result="";
  		DBTable dt=null;  		
  		try{
  			String sql="select name from basedata where code='003'";
  			dt=DBUtil.getDataSetInfo(sql);
  			result=JSON.toJSONString(dt);
  		}catch(Exception ex){
  			ex.printStackTrace();
  		}
  		return result;
  	}
	//获得部门信息
	private String getDepartmentName(HttpServletRequest request){
		String sql="";
		String result="";
		DBTable dt=null;
		
		try{
			String type=WebUtil.getRequestParam(request, "type");
			if(type.equals("承研单位")) {
				sql="select code as departmentid,name as departmentname from unit";
			}else {				
				sql="select branchid as departmentid,branchname as departmentname from branchcompany";
			}
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	
	//根据条件获得满足条件员工信息,带分页信息
	private String getInfo(String con,String page,String row){
		String result="";
		String type="";
		DBTable finalData=new DBTable();
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		DBRecord record=null;
		String departmentname="";
		String sql;
		int rows=0;	
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
		    /*
			if(con.equals("")) {
		    	con="ename!='系统管理员' and ename!='安全管理员' and ename!='安全审计员'";
		    }else {
		    	con=con+" and (ename!='系统管理员' and ename!='安全管理员' and ename!='安全审计员')";
		    }*/
			if(con.equals(""))
				sql="select * from employees order by departmentid,eno";
			else
				sql="select * from employees where "+con+" order by departmentid,eno";
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);
			for(int i=0;i<dt.size();i++){
				record=dt.get(i);
				type=record.get("type");
				if(type.equals("承研单位")) {
					departmentname=DBUtil.getFieldInfo("select name from unit where code='"+record.get("departmentid")+"'", "name");
					record.put("departmentname", departmentname);					
				}else {
					departmentname=DBUtil.getFieldInfo("select branchname from branchcompany where branchid='"+record.get("departmentid")+"'", "branchname");
					record.put("departmentname", departmentname);
				}
				finalData.add(record);
			}
			rows=DBUtil.getRowCount(sql);
			map.put("total", rows);
			map.put("rows", finalData);
			result=JSON.toJSONString(map);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;		
	}
	//添加员工信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String eno=WebUtil.getRequestParam(request, "deno");
			String ename=WebUtil.getRequestParam(request, "dename");
			String departmentid=WebUtil.getRequestParam(request, "ddepartment");
			String duty=WebUtil.getRequestParam(request, "dduty");
			String secretlevel=WebUtil.getRequestParam(request, "demployeessecretlevel"); //密级
			String demo=WebUtil.getRequestParam(request, "demo");
			String type=WebUtil.getRequestParam(request, "dtype");
			
			if(DBUtil.existvalue("employees", "eno", eno)){				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "员工编码重复！");
				return;
			}			
			String sql="insert into employees(eno,ename,departmentid,duty,secretlevel,type,demo) values(?,?,?,?,?,?,?)";
			Object[] args= {eno,ename,departmentid,duty,secretlevel,type,demo};
			boolean flag=DBUtil.executeUpdate(sql,args);			
			if(flag){
				WebUtil.respondSuccess(response);				
			}else{
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
			}			
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
    //编辑模块信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String oldeno=WebUtil.getRequestParam(request, "oldeno"); //原来的员工编码
			String eno=WebUtil.getRequestParam(request, "deno"); //新的员工编码
			String ename=WebUtil.getRequestParam(request, "dename"); //员工姓名
			String departmentid=WebUtil.getRequestParam(request, "ddepartment"); //部门
			String duty=WebUtil.getRequestParam(request, "dduty"); //职务
			String secretlevel=WebUtil.getRequestParam(request, "demployeessecretlevel"); //密级
			String demo=WebUtil.getRequestParam(request, "demo"); //备注
			String type=WebUtil.getRequestParam(request, "dtype"); //类型
			
			if(!oldeno.equals(eno)){
				if(DBUtil.existvalue("employees", "eno", eno)){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "员工编码重复！");
					return;
				}
			}			
			String sql="update employees set eno=?,ename=?,departmentid=?,duty=?,secretlevel=?,type=?,demo=? where eno=?";
			Object[] args= {eno,ename,departmentid,duty,secretlevel,type,demo,oldeno};
			boolean flag=DBUtil.executeUpdate(sql,args);			
			if(flag){
				WebUtil.respondSuccess(response);				
			}else{
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
			}			
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
    //删除模块信息操作
	private void deleteEmployeeInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String eno=WebUtil.getRequestParam(request,"eno");
			String sql="delete from employees where eno=?";
			Object[] args= {eno};
			DBUtil.executeUpdate(sql,args);
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}
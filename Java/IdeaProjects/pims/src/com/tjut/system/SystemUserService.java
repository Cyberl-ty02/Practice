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
import com.tjut.util.MD5;
import com.tjut.util.Uuid;
import com.tjut.util.WebUtil;

@WebServlet("/SystemUserService")
public class SystemUserService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public SystemUserService() {
        super();
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";	
		String unitid="";
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){
		//获得单位信息
		case "initunit":
			result=getunit(request);			
			WebUtil.handleResponse(response, result);
			break;
		//获得员工信息
		case "initemployee":
			unitid=WebUtil.getRequestParam(request, "unitid");
			result=getEmployeeInfo(unitid);			
			WebUtil.handleResponse(response, result);
			break;
		//获得角色信息
		case "initrole":
			result=getRoleInfo();			
			WebUtil.handleResponse(response, result);
			break;
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getUserInfo(con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		case "add":			
			addinfo(request,response);
			break;
		case "edit":
			editinfo(request,response);
			break;
		case "del":						
			deleteUserInfo(request,response);			
			break;
		//密码重置
		case "resetpassword":
			resetPassword(request,response);
			break;
		case "unlock":
			unlock(request,response);
			break;
		}		
	}
    private String getunit(HttpServletRequest request){
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
        
	//获得员工信息
	private String getEmployeeInfo(String unitid){
		String result="";
		String sql="";
		DBTable dt=null;		
		try{
			if(!unitid.equals("")){
				sql="select eno as ecode,ename from employees where departmentid=?";
				String[] args= {unitid};
				dt=DBUtil.executeQuery(sql,args);
				result=JSON.toJSONString(dt);
		    }
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//获得角色信息
	private String getRoleInfo(){
		String result="";
		DBTable dt=null;
		
		try{
			String sql="select rolename from roles where (rolename!='admin' and rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员')";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//根据条件获得满足条件用户信息,带分页信息
	private String getUserInfo(String con,String page,String row){
		String result="";
		DBTable finalData=new DBTable();
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		DBRecord record=null;
		String status="";
		String sql,tempsql;
		int rows=0;	
		String type;
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			/*
			if(con.equals(""))
				con="username!='admin' and username!='系统管理员' and username!='安全管理员' and username!='安全审计员'";
			else
			    con=con+" and (username!='admin' and username!='系统管理员' and username!='安全管理员' and username!='安全审计员')";
			*/
			if(con.equals(""))
				sql="select * from users order by unitid,eno";
			else
				sql="select * from users where "+con+" order by unitid,eno";
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);
			for(int i=0;i<dt.size();i++){				
				record=dt.get(i);
				
				status=record.get("status").equals("0")?"正常":"锁住";
				record.put("status", status);
				type=record.get("type");
				if(type.equals("承研单位")) {
					tempsql="select name as unitname from unit where code='"+record.get("unitid")+"'";
				}else {
					tempsql="select branchname as unitname from branchcompany where branchid='"+record.get("unitid")+"'";
				}
				String unitname=DBUtil.getFieldInfo(tempsql, "unitname");
				record.put("unitname", unitname);
				tempsql="select ename from employees where eno='"+record.get("eno")+"'";
				String ename=DBUtil.getFieldInfo(tempsql, "ename");
				record.put("ename", ename);
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
	//添加用户信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String uuid=Uuid.get();
			String username=WebUtil.getRequestParam(request, "dusername");
			String eno=WebUtil.getRequestParam(request, "demployee");
			String sql="select * from employees where eno='"+eno+"'";
			String departmentid=DBUtil.getFieldInfo(sql, "departmentid");
			String rolename=WebUtil.getRequestParam(request, "drole");			
			String demo=WebUtil.getRequestParam(request, "demo");
			String type=WebUtil.getRequestParam(request, "dtype");
			
			if(DBUtil.existvalue("users", "username", username)){				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "用户名重复！");
				return;
			}
			
			sql="insert into users(ssid,username,password,eno,unitid,rolename,type,demo) values(?,?,?,?,?,?,?,?)";
			String[] args= {uuid,username,MD5.encryp(username),eno,departmentid,rolename,type,demo};
			
			boolean ret=DBUtil.executeUpdate(sql,args);
			
			if(ret){				
				WebUtil.respondSuccess(response);				
			}else{
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
			}			
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
    //编辑用户信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String oldusername=WebUtil.getRequestParam(request, "oldusername");
			String username=WebUtil.getRequestParam(request, "dusername");		
			String eno=WebUtil.getRequestParam(request, "demployee");
			String sql="select * from employees where eno='"+eno+"'";
			String unitid=DBUtil.getFieldInfo(sql, "departmentid");
			String rolename=WebUtil.getRequestParam(request, "drole");
			String demo=WebUtil.getRequestParam(request, "demo");
			String type=WebUtil.getRequestParam(request, "dtype");
			
			if(!oldusername.equals(username)){
				if(DBUtil.existvalue("users", "username", username)){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "用户名重复！");
					return;
				}
			}
			//sql="select * from users where username='"+oldusername+"'";
			//String password=MD5.encryp(eno);
			sql="update users set username=?,unitid=?,eno=?,rolename=?,type=?,demo=?";			
			sql=sql+" where username=?";
			String[] args= {username,unitid,eno,rolename,type,demo,oldusername};
			boolean ret=DBUtil.executeUpdate(sql,args);			
			if(ret){				
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
	private void deleteUserInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String username=WebUtil.getRequestParam(request,"username");
			String sql="delete from users where username=?";
			String[] args= {username};
			DBUtil.executeUpdate(sql,args);			
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
	//密码重置操作
	private void resetPassword(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String username=WebUtil.getRequestParam(request,"username");			
			String password=MD5.encryp(username);
			String sql="update users set password=? where username=?";
			String[] args= {password,username};
			DBUtil.executeUpdate(sql,args);
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
	//解锁用户操作
	private void unlock(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String username=WebUtil.getRequestParam(request,"username");			
			String sql="update users set status=?,count=? where username=?";
			String[] args= {"0","0",username};
			DBUtil.executeUpdate(sql,args);
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}
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

@WebServlet("/SystemUserRoleService")
public class SystemUserRoleService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public SystemUserRoleService() {
        super();        
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){
		case "initunit": //获得部门信息
			result=getunit();			
			WebUtil.handleResponse(response, result);
			break;
		case "initrole": //获得角色信息
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
		case "edit":
			editinfo(request,response);
			break;
		case "delete":						
			deleteUserInfo(request,response);			
			break;		
		}		
	}
    private String getunit(){
    	/*
    	String result="";
		DBTable dt=null;		
		try{
			String sql="select branchid as unitid,branchname as unitname from branchcompany";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}*/
		return WebUtil.getdepartment();
    }        
	
	//获得角色信息
	private String getRoleInfo(){
		String result="";
		DBTable dt=null;
		
		try{
			String sql="select rolename from roles";
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
		
		String sql;
		int rows=0;	
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			/*
			if(con.equals(""))
				sql="select * from vwuserinfo where (rolename!='admin' and rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员') order by unitid,eno";
			else
				sql="select * from vwuserinfo where "+con+" and (rolename!='admin' and rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员') order by unitid,eno";
			*/
			if(con.equals(""))
				sql="select * from vwuserinfo order by unitid,eno";
			else
				sql="select * from vwuserinfo where "+con+" order by unitid,eno";
			
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);
			for(int i=0;i<dt.size();i++){
				record=dt.get(i);
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
	
    //编辑用户信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql="";
		try{
			
			String username=WebUtil.getRequestParam(request, "dusername");
			String rolename=WebUtil.getRequestParam(request, "drole");
			String demo=WebUtil.getRequestParam(request, "demo");
			
			sql="update users set rolename=?,demo=? where username=?"; //更新用户信息
			String[] args= {rolename,demo,username};
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
		String sql="";
		try{
			String username=WebUtil.getRequestParam(request,"username");
			sql="update users set rolename='',demo='' where username=?";
			String[] args= {username};
			DBUtil.executeUpdate(sql,args);
			
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}	
}
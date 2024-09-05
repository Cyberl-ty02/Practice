package com.tjut.system;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.tjut.util.WebUtil;

@WebServlet("/SystemRoleInfoService")
public class SystemRoleInfoService extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
    public SystemRoleInfoService() {
        super();        
    }
	//处理POST请求
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){		
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getRolesInfo(con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		case "add":			
			addinfo(request,response);
			break;		
		case "del":
			delinfo(request,response);
			break;			
		}
	}
	//根据条件获得满足条件角色信息,带分页信息
	private String getRolesInfo(String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;		
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
				con="rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员'";
			}else {
				con=con+ " and (rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员')";
			}*/
			if(con.equals(""))
				sql="select * from roles";// where rolename<>'admin'";
			else
				sql="select * from roles where "+con;
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);			
			rows=DBUtil.getRowCount(sql);
			map.put("total", rows);
			map.put("rows", dt);
			result=JSON.toJSONString(map);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;		
	}
	
	//添加角色信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		String sql=null;		
		try{
			String rolename=WebUtil.getRequestParam(request, "rolename");
			String roledemo=WebUtil.getRequestParam(request, "demo");
					
			if(DBUtil.existvalue("roles", "rolename", rolename)){
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "该角色信息已经存在！");
				return;
			}
			sql="insert into roles(rolename,demo) values(?,?)";
			Object args[]= {rolename,roledemo};
			boolean flag=DBUtil.executeUpdate(sql, args);	
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
	
	//删除角色信息操作
	private void delinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		ArrayList<String> list=new ArrayList<String>();		
		try{
			String rolename=WebUtil.getRequestParam(request,"rolename");
			String sql="delete from roleinfo where rolename='"+rolename+"'";
			list.add(sql);
			sql="delete from roles where rolename='"+rolename+"'";
			list.add(sql);
			boolean flag=DBUtil.executeBatch(list);
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
}

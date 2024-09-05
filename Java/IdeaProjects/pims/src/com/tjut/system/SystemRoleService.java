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
import com.tjut.dao.DBRecord;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.tjut.util.WebUtil;

@WebServlet("/SystemRoleService")
public class SystemRoleService extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
    public SystemRoleService() {
        super();        
    }
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){		
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			String username=request.getSession().getAttribute("username").toString();
			result=getRolesInfo(con,page,row,username);
			WebUtil.handleResponse(response, result);
			break;
		case "inittree": //根据角色名返回权限树信息
		    result=getTree(request);
		    WebUtil.handleResponse(response, result);
			break;
		case "add":			
			addinfo(request,response);
			break;
		case "delete":
			delinfo(request,response);
			break;			
		}
	}
	//根据条件获得满足条件角色信息,带分页信息
	private String getRolesInfo(String con,String page,String row,String username){
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
			
			if(username.equals("admin")) {
				sql="select * from roles";
			}else {
				if(con.equals(""))
					sql="select * from roles where (rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员')";
					//sql="select * from roles where (rolename!='admin' and rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员')";
				else
					sql="select * from roles where "+con+" and (rolename!='系统管理员' and rolename!='安全管理员' and rolename!='安全审计员')";
			}
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
	//根据用户名返回权限树信息
	public String getTree(HttpServletRequest request){
		ArrayList<String> datalist=new ArrayList<String>();
		DBRecord record=new DBRecord();
		DBTable finalData=new DBTable();
		String result="";		
		try{
			String rolename=WebUtil.getRequestParam(request,"rolename");
			String strSql="select mno from roleinfo where rolename='"+rolename+"'";
			datalist=DBUtil.getDataSet(strSql);
			
			//不能将基础数据和系统管理模块授权2022-08-27
			//String con="mno!='0100' and pmno!='0100' and mno!='0200' and pmno!='0200'";
			//修改2023-05-08
			
			strSql="select mno as id,pmno as pId,mname as name,url as target,image as icon from modules  order by mno";			
			DBTable data=new DBTable();			
			data=DBUtil.getDataSetInfo(strSql);
			for(int i=0;i<data.size();i++){
				record=data.get(i);	
				if(record.get("icon")!=null && !record.get("icon").equals("")){					
					record.put("icon","./images/micon/"+record.get("icon").substring(5)+".png");
				}
				record.put("open","true");
				if(datalist!=null && datalist.size()>0 && datalist.contains(record.get("id").toString())){
					record.put("checked","true");
				}else{
					record.put("checked","false");
				}
				finalData.add(record);
			}
			
		    result=JSON.toJSONString(finalData).replace("pid", "pId");
		    
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	
	//添加角色信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		ArrayList<String> list=new ArrayList<String>();
		String[] mnodes=null;
		String sql=null;
		
		try{
			String rolename=WebUtil.getRequestParam(request, "rolename");
			String roledemo=WebUtil.getRequestParam(request, "demo");
			String nodes=WebUtil.getRequestParam(request, "nodes");	
			
			if(DBUtil.existvalue("roles", "rolename", rolename)){
				sql="delete from roles where rolename='"+rolename+"'";
				list.add(sql);
			}
			sql="insert into roles(rolename,demo) values('"+rolename+"','"+roledemo+"')";
			list.add(sql);
			if(DBUtil.existvalue("roleinfo", "rolename", rolename)){				
				sql="delete from roleinfo where rolename='"+rolename+"'";
				list.add(sql);
			}
			mnodes=nodes.split(";");
			for(int i=0;i<mnodes.length;i++){
				sql="insert into roleinfo(rolename,mno) values('"+rolename+"','"+mnodes[i]+"')";
				list.add(sql);
			}			
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
	//删除角色信息操作
	private void delinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		ArrayList<String> list=new ArrayList<String>();
		
		try{
			String rolename=WebUtil.getRequestParam(request,"rolename");
			if(rolename.equals("系统管理员") || rolename.equals("安全审计员") || rolename.equals("安全管理员")) {
				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "不能对该角色进行授权修改操作！");
			    return;
			}
			
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

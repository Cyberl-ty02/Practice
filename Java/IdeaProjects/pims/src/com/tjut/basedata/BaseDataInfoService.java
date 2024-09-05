package com.tjut.basedata;

import java.io.IOException;
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

@WebServlet("/BaseDataInfoService")
public class BaseDataInfoService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public BaseDataInfoService() {
        super();        
    }
	//处理get请求
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){		
		case "init":			
			String con=WebUtil.getRequestParam(request,"con");			
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getBaseDataInfo(con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		case "add":			
			addinfo(request,response);
			break;
		case "edit":
			editinfo(request,response);
			break;
		case "del":						
			deleteInfo(request,response);			
			break;
		}		
	}
	//根据条件获得满足条件的信息,带分页信息
	private String getBaseDataInfo(String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		String sql;
		int rows=0;	
		Object args[]=null;
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			if(con.equals("")) {
				sql="select * from basedatainfo order by code";
			}else {
				sql="select * from basedatainfo where "+con+" order by code";				
			}
			dt=DBUtil.executeQuery(sql, args, r, p);
			rows=DBUtil.getRowCount(sql,args); 
			map.put("total", rows);
			map.put("rows", dt);
			result=JSON.toJSONString(map);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;		
	}
	//添加信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql;
		try{
			String code=WebUtil.getRequestParam(request, "code");
			String name=WebUtil.getRequestParam(request, "name");
			String[] para= {code,name};
			
			sql="select * from basedatainfo where code=? or name=?";
			String args[]= {code,name};
			if(DBUtil.getRowCount(sql,args)>0){				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "编码或名称重复！");
				return;
			}			
			sql="insert into basedatainfo(code,name) values(?,?)";			
			boolean flag=DBUtil.executeUpdate(sql, para);			
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
    //编辑信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String sql;
		try{
			String oldcode=WebUtil.getRequestParam(request, "oldcode");
			String code=WebUtil.getRequestParam(request, "code");
			String name=WebUtil.getRequestParam(request, "name");
			if(!oldcode.equals(code)){
				sql="select * from basedatainfo where code=? or name=?";
				String[] args= {code,name};
				if(DBUtil.getRowCount(sql,args)>0){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "编码或名称重复！");
					return;
				}
			}		
			sql="update basedatainfo set code=?,name=? where code=?";
			String[] args= {code,name,oldcode};
			DBUtil.executeUpdate(sql,args);			
			WebUtil.respondSuccess(response);					
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
    //删除信息操作
	private void deleteInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String code=WebUtil.getRequestParam(request,"code");
			String sql="delete from basedatainfo where code=?";
			String[] args= {code};
			boolean ret=DBUtil.executeUpdate(sql,args);
			if(ret){
				WebUtil.respondSuccess(response);				
			}else{
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
			}
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}
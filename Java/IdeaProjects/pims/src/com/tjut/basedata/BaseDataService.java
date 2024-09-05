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
import com.tjut.dao.DBRecord;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.tjut.util.Uuid;
import com.tjut.util.WebUtil;

@WebServlet("/BaseDataService")
public class BaseDataService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public BaseDataService() {
        super();        
    }
    	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){	
		//根据操作类型进行操作
		case "inittype":
			result=getTypeInfo();			
			WebUtil.handleResponse(response, result);
			break;
		//获带分页信息
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
			deleteInfo(request,response);			
			break;
		}		
	}
	//获得类别信息
	private String getTypeInfo(){
		String result="";
		DBTable dt=null;
		
		try{
			String sql="select code,name from basedatainfo order by code";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//根据条件获得满足条件的信息,带分页信息
	private String getInfo(String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		String sql;
		int rows=0;	
		Object args[]=null;
		DBRecord record=null;
		DBTable finalData=new DBTable();
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			if(con.equals("")) {
				sql="select * from basedata order by code";
			}else {
				sql="select * from basedata where "+con+" order by code";				
			}
			dt=DBUtil.executeQuery(sql, args, r, p);
			for(int i=0;i<dt.size();i++){
				record=dt.get(i);
				String type=DBUtil.getFieldInfo("select name from basedatainfo where code='"+record.get("code")+"'", "name");
				record.put("type", type);
				finalData.add(record);
			}
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
			String uid=Uuid.get();
			String name=WebUtil.getRequestParam(request, "name");
			String code=WebUtil.getRequestParam(request, "code");
			String validation=WebUtil.getRequestParam(request, "validation");
			
			sql="select * from basedata where name=? and code=?";
			String args[]= {name,code};
			if(DBUtil.getRowCount(sql,args)>0){		
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "名称重复！");
				return;
			}
			
			sql="insert into basedata(uid,name,code,validation) values(?,?,?,?)";
			String argsdata[]= {uid,name,code,validation};
			boolean flag=DBUtil.executeUpdate(sql, argsdata);			
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
			String uid=WebUtil.getRequestParam(request, "uid");
			String oldname=WebUtil.getRequestParam(request, "oldname");
			String name=WebUtil.getRequestParam(request, "name");
			String code=WebUtil.getRequestParam(request, "code");
			String validation=WebUtil.getRequestParam(request, "validation");
				
			if(!oldname.equals(name)){
				sql="select * from basedata where name=? and code=?";
				String[] args= {name,code};
				if(DBUtil.getRowCount(sql,args)>0){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE,"名称重复！");
					return;
				}
			}		
			sql="update basedata set name=?,validation=?,code=? where uid=?";
			String[] args= {name,validation,code,uid};
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
			String uid=WebUtil.getRequestParam(request,"uid");
			//删除信息
			String sql="delete from basedata where uid=?";
			String[] args= {uid};
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
package com.tjut.project;

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

@WebServlet("/ProjectContractFundsBoFuService")
public class ProjectContractFundsBoFuService extends HttpServlet {
	private static final long serialVersionUID = 1L;      
    public ProjectContractFundsBoFuService() {
        super();
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){
		case "initcontract":
			result=getContractInfo();			
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
			deleteInfo(request,response);			
			break;
		}		
	}
	//获得上级模块节点信息:url为空时
	private String getContractInfo(){
		String result="";
		DBTable dt=null;
		
		try{
			String sql="select distinct contractno,contractprojectname,contractunitname as department from projectcontract order by contractno";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//根据条件获得满足条件模块信息,带分页信息
	private String getInfo(String con,String page,String row){
		String result="";
		DBTable finalData=new DBTable();
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		DBRecord record=null;
		String contractprojectname="";
		String sql;
		int rows=0;	
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			if(con.equals(""))
				sql="select * from projectcontractfundsbofu order by contractno,date";
			else
				sql="select * from projectcontractfundsbofu where "+con+" order by contractno,date";
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);
			for(int i=0;i<dt.size();i++){
				record=dt.get(i);
				contractprojectname=DBUtil.getFieldInfo("select contractprojectname from projectcontract where contractno='"+record.get("contractno")+"'", "contractprojectname");
				record.put("contractprojectname", contractprojectname);
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
	//添加模块信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String uid=Uuid.get();
			String contractno=WebUtil.getRequestParam(request, "dcontractno");
			String contractprojectname=DBUtil.getFieldInfo("select contractprojectname from projectcontract where contractno='"+contractno+"'", "contractprojectname");
			
			String date=WebUtil.getRequestParam(request, "ddate");
			String value=WebUtil.getRequestParam(request, "dvalue");
			//插入数据库操作
			String sql="insert into projectcontractfundsbofu(uid,contractno,contractprojectname,date,value) values(?,?,?,?,?)";			
			Object[] args= {uid,contractno,contractprojectname,date,value};
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
    //编辑模块信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String uid=WebUtil.getRequestParam(request, "uid");
			String contractno=WebUtil.getRequestParam(request, "dcontractno");
			String date=WebUtil.getRequestParam(request, "ddate");
			String value=WebUtil.getRequestParam(request, "dvalue");
				
			String sql="update projectcontractfundsbofu set date=?,value=? where uid=?";			
			Object[] args= {date,value,uid};
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
	private void deleteInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String uid=WebUtil.getRequestParam(request,"uid");
			String sql="delete from projectcontractfundsbofu where uid=?";
			Object[] args= {uid};
			DBUtil.executeUpdate(sql,args);
			
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}

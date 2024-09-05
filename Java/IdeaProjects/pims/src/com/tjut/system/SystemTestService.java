package com.tjut.system;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.tjut.util.WebUtil;

@WebServlet("/SystemTestService")
public class SystemTestService extends HttpServlet {
	private static final long serialVersionUID = 1L;     
    public SystemTestService() {
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
			result=getDepartmentInfo(con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		case "add":			
			addinfo(request,response);
			break;
		case "edit":
			editinfo(request,response);
			break;
		case "delete":						
			deleteModuleInfo(request,response);			
			break;
		}		
	}
	
	//根据条件获得满足条件部门信息,带分页信息
	private String getDepartmentInfo(String con,String page,String row){
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
			if(con.equals(""))
				sql="select * from department";
			else
				sql="select * from department where "+con;
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
	//添加部门信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException, ServletException{
		System.out.println("asd");
		ServletRequest resReques=request;
		resReques.getRequestDispatcher("http://localhost:8080/kygl/index.jsp").forward(request, response);
		
		//response.sendRedirect("http://localhost:8080/kygl/index.jsp");
		
	}
    //编辑模块信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String olddeptcode=WebUtil.getRequestParam(request, "olddeptcode");
			String deptcode=WebUtil.getRequestParam(request, "deptcode");
			String deptname=WebUtil.getRequestParam(request, "deptname");
			String phone=WebUtil.getRequestParam(request, "phone");
			String dutypeople=WebUtil.getRequestParam(request, "dutypeople");
			String dutyphone=WebUtil.getRequestParam(request, "dutyphone");
			String demo=WebUtil.getRequestParam(request, "demo");			
			if(!olddeptcode.equals(deptcode)){
				if(DBUtil.existvalue("department", "deptcode", deptcode)){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "部门编码重复！");
					return;
				}
			}			
			String sql="update department set deptcode='";
			sql=sql+deptcode+"',deptname='";
			sql=sql+deptname+"',phone='";
			sql=sql+phone+"',dutypeople='";
			sql=sql+dutypeople+"',dutyphone='";
			sql=sql+dutyphone+"',demo='";
			sql=sql+demo+"' where deptcode='"+olddeptcode+"'";			
			int ret=DBUtil.executeUpdate(sql);			
			if(ret==1){
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
	private void deleteModuleInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String deptcode=WebUtil.getRequestParam(request,"deptcode");
			String sql="delete from department where deptcode='"+deptcode+"'";
			DBUtil.executeUpdate(sql);
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}

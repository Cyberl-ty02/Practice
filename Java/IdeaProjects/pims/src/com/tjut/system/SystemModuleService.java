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

@WebServlet("/SystemModuleService")
// 系统模块服务
public class SystemModuleService extends HttpServlet {
	private static final long serialVersionUID = 1L;      
    public SystemModuleService() {
        super();
    }
    //处理POST请求
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		//操作类型
		String caozuo=WebUtil.getRequestParam(request,"caozuo");	
		//根据操作类型进行处理
		switch(caozuo){
		//获得上级模块节点信息
		case "initpname":
			result=getModuleName();			
			WebUtil.handleResponse(response, result);
			break;
			//获得模块信息
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getModuleInfo(con,page,row);
			WebUtil.handleResponse(response, result);
			break;
			//添加模块信息
		case "add":			
			addinfo(request,response);
			break;
			//编辑模块信息
		case "edit":
			editinfo(request,response);
			break;
			//删除模块信息
		case "delete":						
			deleteModuleInfo(request,response);			
			break;
		}		
	}
	//获得上级模块节点信息:url为空时
	private String getModuleName(){
		String result="";
		DBTable dt=null;
		// SQL检索模块信息
		try{
			String sql="select mno,mname from modules where url='' or url is null order by mno";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//根据条件获得满足条件模块信息,带分页信息
	private String getModuleInfo(String con,String page,String row){
		String result="";
		DBTable finalData=new DBTable();
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		DBRecord record=null;
		String modelname="";
		String sql;
		int rows=0;
		
		// 无条件时
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		// 分页信息
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			if(con.equals(""))
				// SQL检索模块信息
				sql="select * from modules order by mno";
			else
				sql="select * from modules where "+con+" order by mno";
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);
			for(int i=0;i<dt.size();i++){
				record=dt.get(i);
				// 相关的SQL语句
				modelname=DBUtil.getFieldInfo("select mname from modules where mno='"+record.get("pmno")+"'", "mname");
				record.put("pmname", modelname);
				finalData.add(record);
			}
			// 返回的数据
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
		
		//获取请求参数
		try{
			String mno=WebUtil.getRequestParam(request, "dmno");
			String mname=WebUtil.getRequestParam(request, "dmname");
			String pmno=WebUtil.getRequestParam(request, "dpmname");
			String icon=WebUtil.getRequestParam(request, "dicon");
			String url=WebUtil.getRequestParam(request, "durl");
			String code=WebUtil.getRequestParam(request, "dcode");
			String demo=WebUtil.getRequestParam(request, "demo");
			//判断是否重复？
			if(DBUtil.existvalue("modules", "mno", mno)){				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "模块编码重复！");
				return;
			}
			
			//数据库相关事宜
			String sql="insert into modules(mno,mname,pmno,image,url,code,demo) values(?,?,?,?,?,?,?)";			
			Object[] args= {mno,mname,pmno,icon,url,code,demo};
			boolean ret=DBUtil.executeUpdate(sql,args);	
			//返回成功
			if(ret){
				
				WebUtil.respondSuccess(response);
			//返回失败
			}else{
				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
			}
			//返回失败
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
    //编辑模块信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		//获取请求参数
		try{
			String oldmno=WebUtil.getRequestParam(request, "oldmno");
			String mno=WebUtil.getRequestParam(request, "dmno");
			String mname=WebUtil.getRequestParam(request, "dmname");
			String pmno=WebUtil.getRequestParam(request, "dpmname");
			String icon=WebUtil.getRequestParam(request, "dicon");
			String url=WebUtil.getRequestParam(request, "durl");
			String code=WebUtil.getRequestParam(request, "dcode");
			String demo=WebUtil.getRequestParam(request, "demo");
			
			//判断是否重复？
			if(!oldmno.equals(mno)){
				if(DBUtil.existvalue("modules", "mno", mno)){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "模块编码重复！");
					return;
				}
			}
			//数据库相关事宜
			String sql="update modules set mno=?,mname=?,pmno=?,image=?,url=?,code=?,demo=? where mno=?";			
			Object[] args= {mno,mname,pmno,icon,url,code,demo,oldmno};
			boolean ret=DBUtil.executeUpdate(sql,args);	
			//返回成功
			if(ret){
				
				WebUtil.respondSuccess(response);	
			//返回失败
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
			String mno=WebUtil.getRequestParam(request,"mno");
			// SQL检索模块id是否存在
			String sql="delete from modules where mno=?";
			Object[] args= {mno};
			DBUtil.executeUpdate(sql,args);
			// 返回成功
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			// 返回失败
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}

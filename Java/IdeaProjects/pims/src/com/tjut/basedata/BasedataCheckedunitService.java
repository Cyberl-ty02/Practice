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

@WebServlet("/BasedataCheckedunitService")
public class BasedataCheckedunitService extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    public BasedataCheckedunitService() {
        super();        
    }
    //处理get请求
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";		
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){	
		//初始化分公司信息
		case "initbranchcompany":
			result=getBrandCompany();			
			WebUtil.handleResponse(response, result);
			break;
		//初始化信息
		case "init":
			String con=WebUtil.getRequestParam(request,"con");
			String row=WebUtil.getRequestParam(request,"rows");
			String page=WebUtil.getRequestParam(request,"page");
			result=getBranchcompanyInfo(con,page,row);
			WebUtil.handleResponse(response, result);
			break;
		//添加信息
		case "add":			
			addinfo(request,response);
			break;
		//编辑信息
		case "edit":
			editinfo(request,response);
			break;
		//删除信息
		case "delete":						
			delInfo(request,response);			
			break;
		}		
	}
	//获得分公司信息
	private String getBrandCompany(){
		String result="";
		DBTable dt=null;
		
		try{
			//获得分公司信息
			String sql="select branchid,branchname from branchcompany";
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	//根据条件获得满足条件分公司信息,带分页信息
	private String getBranchcompanyInfo(String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		String sql,sql1;
		int rows=0;	
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			if(con.equals(""))
				//获得分公司信息
				sql="select * from checkedunit";
			else
				sql="select * from checkedunit where "+con;
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);
			if(dt.size()>0){
				for(int i=0;i<dt.size();i++){
					//获得分公司名称
					sql1="select branchname from branchcompany where branchid='"+dt.get(i).get("bid")+"'";
				    String branchname=DBUtil.getFieldInfo(sql1, "branchname");
				    dt.get(i).put("branchname", branchname);
				}
			}
			rows=DBUtil.getRowCount(sql);
			map.put("total", rows);
			map.put("rows", dt);
			result=JSON.toJSONString(map);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;		
	}
	//添加分公司信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String unitid=WebUtil.getRequestParam(request, "dunitid"); //单位编码
			String unitname=WebUtil.getRequestParam(request, "dunitname"); //单位名称
			String bid=WebUtil.getRequestParam(request, "dbranchcompany"); //分公司编码
			
			String linkperson=WebUtil.getRequestParam(request, "dlinkperson"); //联系人
			String phone=WebUtil.getRequestParam(request, "dphone"); //电话
			String address=WebUtil.getRequestParam(request, "daddress"); //地址
			String demo=WebUtil.getRequestParam(request, "demo"); //备注
			if(DBUtil.existvalue("checkedunit", "unitid", unitid)){	
				//返回单位编码重复信息
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "单位编码重复！");
				return;
			}
			if(DBUtil.existvalue("checkedunit", "unitname", unitname)){
				//返回单位名称重复信息
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "单位名称重复！");
				return;
			}
			String sql="insert into checkedunit(unitid,unitname,bid,linkperson,phone,address,demo) values(?,?,?,?,?,?,?)";
			Object[] args= {unitid,unitname,bid,linkperson,phone,address,demo};			
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
			String oldcheckedunitid=WebUtil.getRequestParam(request, "oldcheckedunitid");//原单位编码
			String unitid=WebUtil.getRequestParam(request, "dunitid"); //新单位编码
			String unitname=WebUtil.getRequestParam(request, "dunitname"); //单位名称
			String bid=WebUtil.getRequestParam(request, "dbranchcompany"); //分公司编码
			String linkperson=WebUtil.getRequestParam(request, "dlinkperson"); //联系人
			String phone=WebUtil.getRequestParam(request, "dphone"); //电话
			String address=WebUtil.getRequestParam(request, "daddress"); //地址
			String demo=WebUtil.getRequestParam(request, "demo");		//备注
			if(!oldcheckedunitid.equals(unitid)){
				if(DBUtil.existvalue("checkedunit", "unitid", unitid)){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "单位编码重复！");
					return;
				}
			}			
			String sql="update checkedunit set unitid=?,unitid=?,unitname=?,unitname=?,bid=?,";
			sql=sql+"linkperson=?,phone=?,address=?,demo=? where unitid=?";
			Object args[]= {unitid,unitid,unitname,unitname,bid,linkperson,phone,address,demo, oldcheckedunitid};
			
			
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
    //删除信息操作
	private void delInfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String unitid=WebUtil.getRequestParam(request,"unitid");
			String sql="delete from checkedunit where unitid=?";
			Object[] args= {unitid};
			DBUtil.executeUpdate(sql,args);
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}
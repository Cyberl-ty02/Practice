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
import com.tjut.util.WebUtil;

@WebServlet("/BasedataUnitService")
public class BasedataUnitService extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
    public BasedataUnitService() {
        super();        
    }
    //处理get请求
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String result="";	
		//获取操作类型
		String caozuo=WebUtil.getRequestParam(request,"caozuo");		
		switch(caozuo){
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
			delInfo(request,response);			
			break;
		}		
	}
	
	//根据条件获得满足条件分公司信息,带分页信息
	private String getInfo(String con,String page,String row){
		String result="";
		Map<String,Object> map=new HashMap<String,Object>();
		DBTable dt=null;
		String sql;
		int rows=0;	
		DBRecord record=null;
		DBTable finalData=new DBTable();
		String state="";
		
		if(con==null)con="";
		if(row==null)row="0";
		if(page==null)page="0";
		try{
			int r=Integer.parseInt(row);
			int p=Integer.parseInt(page);
			if(con.equals(""))
				sql="select * from unit order by code";
			else
				sql="select * from unit where "+con+" order by code";
			dt=DBUtil.getDataSetInfoByCon(sql, r, p);
			if(dt!=null) {
				for(int i=0;i<dt.size();i++){
					record=dt.get(i);
					state=record.get("state").equals("1")?"是":"否";
					record.put("state", state);				
					finalData.add(record);
				}
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
	//添加分公司信息操作
	private void addinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String code=WebUtil.getRequestParam(request, "code"); 
			String name=WebUtil.getRequestParam(request, "name"); //承研单位名称
			String legalperson=WebUtil.getRequestParam(request, "legalperson"); //法人
			String linkperson=WebUtil.getRequestParam(request, "linkperson"); //联系人
			String linkphone=WebUtil.getRequestParam(request, "linkphone"); //联系电话
			String address=WebUtil.getRequestParam(request, "address"); //地址
			String accountname=WebUtil.getRequestParam(request, "accountname"); //开户名
			String depositbank=WebUtil.getRequestParam(request, "depositbank"); //开户银行
			String account=WebUtil.getRequestParam(request, "account"); //账号
			String jituanflag=WebUtil.getRequestParam(request, "jituanflag"); //是否集团
			String state=WebUtil.getRequestParam(request, "state");
			state=state.equals("是")?"1":"0";
			if(DBUtil.existvalue("unit", "code", code)){				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "承研单位编码重复！");
				return;
			}
			if(DBUtil.existvalue("unit", "name", name)){
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "承研单位名称重复！");
				return;
			}
			Object args[]= {code,name,legalperson,linkperson,linkphone,address,accountname,depositbank,account,jituanflag,state};
			//插入数据
			String sql="insert into unit(code,name,legalperson,linkperson,linkphone,address,accountname,depositbank,account,jituanflag,state) values(?,?,?,?,?,?,?,?,?,?,?)";
				
			boolean flag=DBUtil.executeUpdate(sql,args);			
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
    //编辑模块信息操作
	private void editinfo(HttpServletRequest request,HttpServletResponse response) throws IOException{
		
		try{
			String oldcode=WebUtil.getRequestParam(request, "oldcode"); //原承研单位编码
			String code=WebUtil.getRequestParam(request, "code");
			String name=WebUtil.getRequestParam(request, "name");
			String legalperson=WebUtil.getRequestParam(request, "legalperson");
			String linkperson=WebUtil.getRequestParam(request, "linkperson");
			String linkphone=WebUtil.getRequestParam(request, "linkphone");
			String address=WebUtil.getRequestParam(request, "address");
			String accountname=WebUtil.getRequestParam(request, "accountname"); //开户名
			String depositbank=WebUtil.getRequestParam(request, "depositbank"); //开户银行
			String account=WebUtil.getRequestParam(request, "account");
			String jituanflag=WebUtil.getRequestParam(request, "jituanflag"); //是否集团
			String state=WebUtil.getRequestParam(request, "state");
			state=state.equals("是")?"1":"0";
			if(!oldcode.equals(code)){
				if(DBUtil.existvalue("unit", "code", code)){				
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DUPLICATE, "承研单位编码重复！");
					return;
				}
			}
			Object args[]= {code,name,legalperson,linkperson,linkphone,address,accountname,depositbank,account,jituanflag,state,oldcode};
			String sql="update unit set code=?,name=?,legalperson=?,linkperson=?,linkphone=?,address=?,accountname=?,depositbank=?,account=?,jituanflag=?,state=? where code=?";			
			
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
			String code=WebUtil.getRequestParam(request,"code");
			Object args[]= {code};
			String sql="delete from unit where code=?";
			DBUtil.executeUpdate(sql,args);
			
			WebUtil.respondSuccess(response);
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}		
	}
}
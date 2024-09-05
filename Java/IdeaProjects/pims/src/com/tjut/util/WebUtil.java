package com.tjut.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tjut.dao.DBTable;
import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.alibaba.fastjson.JSON;

import org.apache.commons.lang3.StringUtils;

public class WebUtil {
	//static String checkkey[]={"insert","delete","update","select","revoke","grant","create","alter","drop","script"};
	//返回前端信息处理
	public static void handleResponse(HttpServletResponse response,String result) throws IOException{
		//返回信息
		response.setCharacterEncoding("UTF-8");
		PrintWriter out=response.getWriter();		
		out.print(result);
		out.flush();
		out.close();		
	}
	//操作成功处理
	public static void respondSuccess(HttpServletResponse response) throws IOException {
		//返回成功信息
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("ret", Constant.RESPONSE_CODE_SUCCESS);
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(JSON.toJSONString(map));
		out.flush();
		out.close();
	}
	//操作成功处理
	public static void respondSuccess(HttpServletResponse response,String result) throws IOException {
		Map<String, Object> map=new HashMap<String,Object>();
		map.put("ret", Constant.RESPONSE_CODE_SUCCESS);
		map.put("file", result);
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(JSON.toJSONString(map));
		out.flush();
		out.close();
	}
	//操作失败的处理
	public static void respondFailure(HttpServletResponse response, String failureCode, String reason) throws IOException {
		Map<String, String> map = new HashMap<String, String>();
		map.put("ret", failureCode);
		map.put("reason", reason);
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(JSON.toJSONString(map));
		out.flush();
		out.close();
	}
	
	
	//获得Request数据处理:值为null返回“”,增加特殊字符过滤功能
	public static String getRequestParam(HttpServletRequest request,String param) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8");
		String value=request.getParameter(param);		
		value=(value==null?"":value.trim());
		return value;
	}
	//获得Request数据(数组)处理:值为null返回“”
	public static String getRequestParams(HttpServletRequest request,String param,String separator) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8");
		String value[]=request.getParameterValues(param);
	    String val=StringUtils.join(value,separator);
		return value==null?"":val;
	}
	//防SQL注入，特殊字符过滤2021-8-20
	public static String ReplaceUserInput(String userInput){	
	  //String checkkey[]={"insert","select","revoke","grant","create","alter","drop","script"};
	  String checkkey[]={"insert","select","revoke","grant","alter","drop","script"};
	  String userInput1=userInput.toLowerCase();
	  for(String data:checkkey){
		  if(userInput1.indexOf(data)>=0){
			  userInput="";
		  }
	  }
	  return userInput;
	}
	
	//获得下拉列表的值
	public static String getComboData(String tablename,String value,String name,String confield,String convalue){
		String result="";
		DBTable dt=null;
		try{
			//SQL查找公司、部门等的id编号和名字
			String sql="select "+name+","+value+" from "+tablename+" where "+confield+"='"+convalue+"'";
			dt=DBUtil.getDataSetInfo(sql);
			//返回的数据
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}	
	
	//获得单位信息
	public static String getdepartment(){
		//返回的数据
		String result="";
		//数据库操作
		DBTable dt=null;
		
		try{
			//String sql="select branchid as departmentid,branchname as departmentname from branchcompany where parentcode='01G02' or branchid='01G124' order by branchid";
			//SQL查找公司、部门等的id编号和名字
			String sql="select branchid as departmentid,branchname as departmentname from branchcompany where state='1' order by branchid";
			//执行SQL
			dt=DBUtil.getDataSetInfo(sql);
			result=JSON.toJSONString(dt);			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	
	//将字符串类型参数转换成float类型，若为""则设置为0
	public static float getFloatValue(String data) {
		float temp=0;
		//异常处理
		try {
			//若data为空则设置为0
			if(data.equals("")) {
				temp=0;
			}else {
				temp=Float.parseFloat(data);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return temp;
	}
}

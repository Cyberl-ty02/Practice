package com.tjut.system;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.alibaba.fastjson.JSON;
import com.tjut.dao.DBRecord;
import com.tjut.dao.DBUtil;
import com.tjut.util.MD5;

@WebServlet("/LoginService")
public class LoginService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public LoginService() {
        super();       
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setCharacterEncoding("UTF-8");
		PrintWriter out=response.getWriter();
		HttpSession session=request.getSession();
		String username=request.getParameter("username"); //用户名
		String password=request.getParameter("password"); //密码
		
		password=new String(Base64.getUrlDecoder().decode(password));
		String result=handleLogin(request,username,password,session);
		
        //response.setCharacterEncoding("UTF-8");
		//PrintWriter out=response.getWriter();
		out.print(result);
		out.flush();
		out.close();
	}
	
	private String handleLogin(HttpServletRequest request,String username,String password,HttpSession session){
		String ret="0";
		String reason="";
		String name="";
		String unitid="";
		
		Map<String,String> map = new HashMap<String,String>();
		String sql="";
		try{
			
			
			//2022-08-28
			sql="select eno from users where username=?"; //获取用户编号
			Object[] args= {username};
			String eno=DBUtil.getFieldInfo(sql,args,"eno");
			//String type=DBUtil.getFieldInfo("select type from users where username='"+username+"'", "type");
			sql="select ename from employees where eno=?";
			args= new Object[]{eno};
			name=DBUtil.getFieldInfo(sql,args,"ename");
			String strSql="select * from users where username='"+username+"'";			
			DBRecord result=null;
			result=DBUtil.getDataInfo(strSql);
			if(getPassWordFlag(password)){
				session.setAttribute("pflag", "true");
			}else{
				session.setAttribute("pflag", "false");
			}
			if(result!=null){
				password=MD5.encryp(password);
				if(result.get("password").toString().equals(password)){
					ret="0";					
					unitid=result.get("unitid");
					session.setAttribute("username",username);
					String rolename=result.get("rolename");
					session.setAttribute("rolename", rolename);
					session.setAttribute("ename",name);
					session.setAttribute("unitid", unitid);
					String departmentname=DBUtil.getFieldInfo("select branchname from branchcompany where branchid='"+unitid+"'", "branchname");
					session.setAttribute("departmentid", unitid);
					session.setAttribute("departmentname", departmentname);
					session.setAttribute("eno", eno);				
					
				}else{
					ret="2";
					reason="用户名或密码输入错误，请重新输入！";
				}
			}else{
				ret="1";
				reason="所输入的用户名或密码错误，请重新输入！";
			}			
		}catch(Exception e){
			ret="-1";
			reason="程序出现异常！";
		}
			
		map.put("ret",ret);
		map.put("reason", reason);		
		return JSON.toJSONString(map);
	}
	private boolean getPassWordFlag(String password){
		String retxtpwd ="^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*).{8,}$";
		boolean flag=password.matches(retxtpwd);
		return flag;
	}
	
}

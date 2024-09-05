package com.tjut.system;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tjut.dao.DBUtil;
import com.tjut.util.Constant;
import com.tjut.util.MD5;
import com.tjut.util.WebUtil;

@WebServlet("/PassWordCheckService")
public class PassWordCheckService extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
    public PassWordCheckService() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try{
			String username=WebUtil.getRequestParam(request, "username");
			String password=MD5.encryp(WebUtil.getRequestParam(request,"password"));
			String sql="update users set password='"+password+"' where username='"+username+"'";
			if(DBUtil.executeUpdate(sql)>0){
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

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

@WebServlet("/SystemPasswordService")
public class SystemPasswordService extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    public SystemPasswordService() {
        super();        
    }
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try{
			String username=WebUtil.getRequestParam(request, "username");
			String oldpassword=MD5.encryp(WebUtil.getRequestParam(request,"oldpassword"));			
			
			String sql="select * from users where username='"+username+"' and password='"+oldpassword+"'";
			if(DBUtil.getRowCount(sql)>0){
				sql="update users set password=? where username=?";				
				if(DBUtil.executeUpdate(sql)>0){					
					WebUtil.respondSuccess(response);
				}else{
					WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
				}
			}else{				
				WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "原密码输入错误，请重新输入！");
			}
		}catch(Exception ex){
			ex.printStackTrace();
			WebUtil.respondFailure(response, Constant.RESPONSE_CODE_DB_FAILURE, "数据库访问失败，请与系统管理员联系");
		}	
	}
}

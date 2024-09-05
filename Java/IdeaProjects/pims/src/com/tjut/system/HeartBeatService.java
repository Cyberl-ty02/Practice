package com.tjut.system;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tjut.util.Common;

@WebServlet("/HeartBeatService")
public class HeartBeatService extends HttpServlet {
	private static final long serialVersionUID = 1L;
     
    public HeartBeatService() {
        super();        
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("utf-8");
		String date=Common.getDate("yyyy-MM-dd HH:mm:ss");
		PrintWriter out=response.getWriter();
		out.print(date);
		out.close();
		
	}

}

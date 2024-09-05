package com.tjut.dao;

import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.apache.commons.dbcp2.BasicDataSource;

import com.tjut.util.CryptAES;

public class DBFactory {

	private static Connection conn = null;
	private static BasicDataSource dataSource = new BasicDataSource();
	// private static DataSource dataSource;
	//
	static {
		Context ctx;
		try {
			ctx = new InitialContext();
			//连接池
			dataSource = (BasicDataSource) ctx.lookup("java:comp/env/jdbc/DBPool");
			// dataSource = (DataSource) ctx.lookup("jdbc/DBPool");
			String username = CryptAES.AES_Decrypt(dataSource.getUsername());
			String password = CryptAES.AES_Decrypt(dataSource.getPassword());			
			dataSource.setUsername(username);
			dataSource.setPassword(password);
		} catch (NamingException ex) {
			ex.printStackTrace();
		}
	}

	//获取数据库连接
	public static Connection getConnection() {
		try {
			// Context ctx = new InitialContext();
			// DataSource ds=(DataSource) ctx.lookup("java:comp/env/jdbc/DBPool");
			conn = dataSource.getConnection();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		//返回数据库连接
		return conn;
	}
}
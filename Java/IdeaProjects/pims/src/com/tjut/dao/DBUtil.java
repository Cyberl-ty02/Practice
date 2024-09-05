package com.tjut.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class DBUtil {
	
	// 返回某个字段值
	public static String getFieldInfo(String sql,String fieldname){
		Statement st=null;
		ResultSet rs=null;	
		Connection conn=null;
		String strResult="";
		try{
			//获取数据库连接
			conn=DBFactory.getConnection();
			st=conn.createStatement();
			rs=st.executeQuery(sql);	
			//获取字段值
			if(rs.next()){
				strResult=rs.getString(fieldname);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return strResult;		
	}
	
	/**
	*@ 函数名称: getDataInfo
	*@ 功能描述：根据查询条件返回一条数据。
	*@ 传入参数：用于查询的SQL语句
	*@ 返回类型：DBRecord (HashMap<String,Object>)
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2015-08-01
	*@ 版本编号：1.00
	*/
	public static DBRecord getDataInfo(String sql){
		Connection conn=null;
		DBRecord result=null;
		Statement st=null;
		ResultSet rs=null;
		ResultSetMetaData rsmd=null;
		//异常处理
		try{
			conn=DBFactory.getConnection();
			st=conn.createStatement();
			rs=st.executeQuery(sql);
			rsmd=rs.getMetaData();
			if(rs.next()){
				//获取字段数
				int columnCount=rsmd.getColumnCount();
				result=new DBRecord();
				//获取字段名和字段值
				for(int i=1;i<=columnCount;i++){
					result.put(rsmd.getColumnName(i),rs.getString(i));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return result;		
	}
	
	/**
	*@ 函数名称: getDataSetInfo
	*@ 功能描述：根据查询条件返回多条数据。
	*@ 传入参数：用于查询的SQL语句
	*@ 返回类型：DBTable (ArrayList<HashMap<String,Object>>)
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2015-08-01
	*@ 版本编号：1.00
	*/
	public static DBTable getDataSetInfo(String sql){
		Connection conn=null;
		DBTable result=null;
		Statement st=null;
		ResultSet rs=null;
		ResultSetMetaData rsmd=null;
		
		try{
			conn=DBFactory.getConnection();
			st=conn.createStatement();
			rs=st.executeQuery(sql);
			rsmd=rs.getMetaData();
			result=new DBTable();
			
			while(rs.next()){		
				int columnCount=rsmd.getColumnCount();
				DBRecord record=new DBRecord();				
				for(int i=1;i<=columnCount;i++){
					record.put(rsmd.getColumnName(i),rs.getString(i));
				}
				result.add(record);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return result;		
	}
	
	/**
	*@ 函数名称: getDataSetInfoByCon
	*@ 功能描述：根据查询SQL语句、页码及页数返回部分多条记录。
	*@ 传入参数：用于查询的SQL语句、页码、页数
	*@ 返回类型：DBTable (ArrayList<HashMap<String,Object>>)
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2015-08-12
	*@ 版本编号：1.00
	*/
	public static DBTable getDataSetInfoByCon(String sql,int rowCount,int page){
		Connection conn=null;
		DBTable result=null;
		Statement st=null;
		ResultSet rs=null;
		ResultSetMetaData rsmd=null;
		int count=0;
		try{
			conn=DBFactory.getConnection();		
			//创建Statement对象
			st=conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			//if(rowCount>0)
			     //st.setMaxRows(page*rowCount);
			//执行查询
			rs=st.executeQuery(sql);
			//移动到指定的行
			if(page>=0 && rowCount>0)
				rs.absolute((page-1)*rowCount);
			rsmd=rs.getMetaData();
			result=new DBTable();
			
			while(rs.next()){
				int columnCount=rsmd.getColumnCount();
				DBRecord record=new DBRecord();				
				for(int i=1;i<=columnCount;i++){
					record.put(rsmd.getColumnName(i),rs.getString(i));
				}
				result.add(record);
				count++;
				if(count>=rowCount)
					break;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return result;		
	}
	/**
	*@ 函数名称: executeUpdate
	*@ 功能描述：执行SQL语句：insert into、update和delete。(插入、更改和删除)
	*@ 传入参数：用于的SQL语句
	*@ 返回类型：int(受影响的行数)
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2015-08-01
	*@ 版本编号：1.00
	*/	
	
	//执行SQL语句：insert into、update和delete。(插入、更改和删除)
	public static int executeUpdate(String sql){
		Connection conn=null;
		int result=-1;
		Statement st=null;
		try{
			if(conn==null || conn.isClosed() || conn.isReadOnly()){
				conn=DBFactory.getConnection();				
			}
			st=conn.createStatement();
			result=st.executeUpdate(sql);			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,null);
		}
		return result;
	}
	/**************************************************************************************
	*@ 函数名称: executeBatch                                                                                        
	*@ 功能描述：执行多条并支持事物的SQL语句：insert into、update和delete。
	*@ 传入参数：用于的SQL语句
	*@ 返回类型：boolean(true:成功，false: 失败)
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2015-08-20
	*@ 版本编号：1.00
	***************************************************************************************/	
	public static boolean executeBatch(ArrayList<String> listSql){
		Connection conn=null;
		boolean blnFlag=true;		
		Statement st=null;
		//异常处理
		try{
			if(conn==null || conn.isClosed() || conn.isReadOnly()){
				conn=DBFactory.getConnection();				
			}
			conn.setAutoCommit(false);
			//创建Statement对象
			st=conn.createStatement();		
            for (int i = 0; i < listSql.size(); i++) {
                st.addBatch(listSql.get(i));
            }
            //执行批处理
            st.executeBatch();
            conn.commit();
            conn.setAutoCommit(true);
        } catch(Exception e){
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {				
				e1.printStackTrace();
			}
			blnFlag=false;
		}finally{
			finallyHandle(conn,st,null);
		}
		return blnFlag;
	}
	/**
	*@ 函数名称: getRowCount
	*@ 功能描述：获得结果集的行数。
	*@ 传入参数：SQL语句
	*@ 返回类型：行数
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2015-08-12
	*@ 版本编号：1.00
	*/	
	public static int getRowCount(String sql){	
		Connection conn=null;
		Statement st=null;
		ResultSet rs=null;	
		int length=0;
		try{
			conn=DBFactory.getConnection();			
			st=conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);		
			rs=st.executeQuery(sql);
			rs.last();
			length=rs.getRow();			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return length;
	}
	/**
	*@ 函数名称: finallyHandle
	*@ 功能描述：释放用到的对象。
	*@ 传入参数：释放对象
	*@ 返回类型：void
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2015-08-01
	*@ 版本编号：1.00
	*/	
	private static void finallyHandle(Connection conn,Statement st,ResultSet rs){
		try{
			if(rs!=null){
				rs.close();
				rs=null;
			}
			if(st!=null){
				st.close();
				st=null;				
			}
			if(conn!=null){
				conn.close();
				conn=null;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	// 获得某个字段所有值的集合
	public static ArrayList<String> getDataSet(String sql){
		Connection conn=null;
		ArrayList<String> data=new ArrayList<String>();		
		Statement st=null;
		ResultSet rs=null;
	
		try{
			conn=DBFactory.getConnection();
			st=conn.createStatement();
			rs=st.executeQuery(sql);			
			while(rs.next()){				
				data.add(rs.getString(1));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return data;		
	}
	// 判断某个字段的值在某个表中是否存在：存在--true,不存在--false
	public static boolean existvalue(String table,String field,String value){
		boolean flag=false;
		try{
			String sql="select * from "+table+" where "+field+"='"+value+"'";
			int ret=DBUtil.getRowCount(sql);
			if(ret>0){
				flag=true;
			}			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return flag;
	}
	//根据条件判断是否存在该记录：存在--true,不存在--false
	public static boolean existvalue(String table,String condition){
		boolean flag=false;
		try{
			String sql="select * from "+table+" where "+condition;
			int ret=DBUtil.getRowCount(sql);
			if(ret>0){
				flag=true;
			}			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return flag;
	}
	
	/**
	 * 新增函数existvalue()：by chenhongtao
	 * 
	 * @param table  表名
	 * @param field  第一个字段名
	 * @param value  第一个字段名变量
	 * @param field1 第二个字段名
	 * @param value1 第二个字段名变量
	 * @return 判断两个字段为主键时，在某个表中是否存在：存在--true,不存在--false
	 */
	// 判断两个字段为主键时，在某个表中是否存在：存在--true,不存在--false
	public static boolean existvalue(String table, String field, String value, String field1, String value1) {
		boolean flag = false;
		try {
			String sql = "select * from " + table + " where " + field + "='" + value + "' and " + field1 + "='" + value1
					+ "'";
			int ret = DBUtil.getRowCount(sql);
			if (ret > 0) {
				flag = true;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return flag;
	}
	/************************************************************************************
	 *********************    以下是支持预编译的方法        ****************************************
	*************************************************************************************/
	
	/**
	*@ 函数名称: executeQuery
	*@ 功能描述：根据查询预编译SQL语句、参数值、页码及页数返回部分多条记录。
	*@ 传入参数：用于查询的预编译SQL语句、参数、页码、页数
	*@ 返回类型：DBTable (ArrayList<HashMap<String,Object>>)
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2021-10-24
	*@ 版本编号：1.00
	*/
	
	//根据查询预编译SQL语句、参数值、页码及页数返回部分多条记录。
	public static DBTable executeQuery(String sql,Object args[],int rowCount,int page){
		Connection conn=null;
		DBTable result=null;
		Statement st=null;
		ResultSet rs=null;
		ResultSetMetaData rsmd=null;
		PreparedStatement ps = null;
		int count=0;
		
		try{
			conn=DBFactory.getConnection();	
			ps=conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			if (args != null && args.length > 0) {  
                for (int i = 0; i < args.length; i++) {  
                   ps.setObject(i + 1, args[i]);  
                }  
	        }
			//if(rowCount>0)
			    // ps.setMaxRows(page*rowCount);   // page=2,rowcount=10
			rs=ps.executeQuery();
			if(page>=0 && rowCount>0)
				//移动到指定的行
				rs.absolute((page-1)*rowCount);   //page=2;rowcount=10
			rsmd=rs.getMetaData();
			result=new DBTable();
			
			while(rs.next()){
				int columnCount=rsmd.getColumnCount();
				DBRecord record=new DBRecord();				
				for(int i=1;i<=columnCount;i++){
					//获取字段名和字段值
					record.put(rsmd.getColumnName(i),rs.getString(i));
				}
				result.add(record);
				count++;
				if(count>=rowCount)
					break;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return result;		
	}
	//一条预编译的查询语句，args为参数数组
	//返回值：DBTable
	public static DBTable executeQuery(String sql,Object args[]){  
		DBTable list=null;
		DBRecord hash=null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd=null;
        try 
        { 
        	// 获取数据库连接
           conn = DBFactory.getConnection();
           ps = conn.prepareStatement(sql);    
           // 设置参数  
           if (args != null && args.length > 0) {  
               for (int i = 0; i < args.length; i++) {  
                   ps.setObject(i + 1, args[i]);  
               }  
           }             
           // 执行查询
           rs = ps.executeQuery();
           rsmd=rs.getMetaData();
           list=new DBTable();
           while(rs.next()) {
        	   int columnCount=rsmd.getColumnCount();
        	   hash=new DBRecord();
        	   for(int i=1;i<=columnCount;i++) {
        		   hash.put(rsmd.getColumnName(i), rs.getString(i));
        	   }
        	   list.add(hash);
           }
           return list;
        }
        catch(Exception e)
        {
            e.printStackTrace();        
        } 
        finally {
        	finallyHandle(conn,ps,rs);
        }
        return null;
	}

	//一条预编译的更新语句，boolean，args为参数数组,成功返回true,失败返回false
	public static boolean executeUpdate(String sql, Object[] args)
    {  
		boolean flag=false;
        Connection conn = null;
        PreparedStatement ps = null;
        //异常处理
        try
        {
            conn = DBFactory.getConnection();              
            ps = conn.prepareStatement(sql);    
            // 设置参数  
            if (args != null && args.length > 0) {  
               for (int i = 0; i < args.length; i++) {  
                   ps.setObject(i + 1, args[i]);  
               }  
            }             
            int result = ps.executeUpdate();    //返回受影响的行数        
            if(result > 0)
               flag=true;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        } 
        finally {
        	finallyHandle(conn,ps,null);
        }
        return flag;
    }	    

    //批处理+事务，多条预编译语句（增删改）
	public static boolean executeBatch(String sql,Object args[][]) {
		Connection conn=null;
		boolean blnFlag=true;		
		PreparedStatement ps=null;
		try{
			if(conn==null || conn.isClosed() || conn.isReadOnly()){
				conn=DBFactory.getConnection();				
			}
			conn.setAutoCommit(false);
			ps=conn.prepareStatement(sql);
			
            for (int i = 0; i < args.length; i++) {
            	for(int j=0;j<args[i].length;j++) {
            		ps.setObject(j + 1, args[i][j]);
            	}
            	ps.addBatch();
            }
            ps.executeBatch();            
            conn.commit();
            conn.setAutoCommit(true);
        } catch(Exception e){
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {				
				e1.printStackTrace();
			}
			blnFlag=false;
		}finally{
			finallyHandle(conn,ps,null);
		}
		return blnFlag;
	}
	/**
	*@ 函数名称: getRowCount
	*@ 功能描述：获得结果集的行数。
	*@ 传入参数：SQL语句
	*@ 返回类型：行数
	*@ 文件作者：tjut.yangwenjun
	*@ 创建时间：2021-10-24
	*@ 版本编号：1.00
	*/	
	public static int getRowCount(String sql,Object[] args){	
		Connection conn=null;
		Statement st=null;
		ResultSet rs=null;	
		PreparedStatement ps=null;
		
		int length=0;
		try{
			conn=DBFactory.getConnection();	
			//创建Statement对象
			ps=conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			if (args != null && args.length > 0) {  
	               for (int i = 0; i < args.length; i++) {  
	                   ps.setObject(i + 1, args[i]);  
	               }  
	        }
			rs=ps.executeQuery();
			rs.last();
			length=rs.getRow();			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return length;
	}
	// 返回某个字段值
	public static String getFieldInfo(String sql,Object[] args,String fieldname){		
		Connection conn=null;
		Statement st=null;
		ResultSet rs=null;	
		PreparedStatement ps=null;
		String result="";
		try{
			conn=DBFactory.getConnection();			
			ps=conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			if (args != null && args.length > 0) {  
	               for (int i = 0; i < args.length; i++) {
	                   ps.setObject(i + 1, args[i]);  
	               }  
	        }
			rs=ps.executeQuery();			
			if(rs.next()){
				result=rs.getString(fieldname);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			finallyHandle(conn,st,rs);
		}
		return result;		
	}
		
}

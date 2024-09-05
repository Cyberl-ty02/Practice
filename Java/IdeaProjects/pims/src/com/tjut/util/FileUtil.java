package com.tjut.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

public class FileUtil {
	 /****     方法doZip   ******	
	 * @param  list:url:文件的路径及名称；name:下载后显示的名字
	 * @param  displayfilename:显示给用户的文件名
	 * @throws IOException：抛出的异常，由调用者处理
	 */	
    public void downloadmultifiles(HttpServletResponse response,String displayfilename,List<HashMap<String, String>> list) throws IOException {
    	ZipOutputStream zos=new ZipOutputStream(response.getOutputStream());
    	try {
    		response.setCharacterEncoding("utf-8");
    		response.setContentType("application/x-msdownload");
    		response.setHeader("Content-disposition", "attachment;filename="+java.net.URLEncoder.encode(displayfilename,"UTF-8"));
    		
	    	if(list.size()>0) {
	    		for(Map<String, String> map:list) {
	    			File file=new File(map.get("url"));
			    	if (file.isFile() && file.exists()) {
						zos.putNextEntry(new ZipEntry(map.get("name")));
						FileInputStream fis = new FileInputStream(file);
						byte[] buffer = new byte[1024];
						int r = 0;
						while ((r = fis.read(buffer)) != -1) {
							zos.write(buffer, 0, r);
						}
						zos.flush();				
						fis.close();
					}
	    	    }
	    	}
    	    zos.close();
    	}catch(Exception ex) {    		
    		throw ex;
    	}
    	zos.close();
    }
    
    public void downloadsinglefile(HttpServletResponse response,String displayfilename,String url) throws IOException {
    	
    	try {
    		response.setCharacterEncoding("utf-8");
    		response.setContentType("application/x-msdownload");
    		
    		response.setHeader("Content-disposition","attachment;filename="+java.net.URLEncoder.encode(displayfilename,"UTF-8"));
    		File file=new File(url);
    		
			if (file.isFile() && file.exists()) {						
				FileInputStream fis = new FileInputStream(file);
				ServletOutputStream out=response.getOutputStream();
				byte[] buffer = new byte[1024];
				int r = 0;
				while ((r = fis.read(buffer)) != -1) {
					out.write(buffer, 0, r);
				}
				out.flush();				
				fis.close();
				out.close();
	    	}
    	}catch(Exception ex) {
    		throw ex;
    	}
    }
    //文件加密/解密操作
    public static final byte CRYPTO_SECRET_KEY = (byte) 10011001;
  	public static void cryptoFile(File srcFile, File encFile) throws Exception {
  		InputStream inputStream = new FileInputStream(srcFile);
  	    OutputStream outputStream = new FileOutputStream(encFile);
  	    byte data[]=new byte[1024];
  	    int len=0;
  	    while((len=inputStream.read(data))>-1) {
  	    	for(int i=0;i<len;i++) {
  	    		data[i]=(byte) (data[i]^CRYPTO_SECRET_KEY);
  	    	}
  	    	outputStream.write(data, 0, len);
  	    }	     
  	    inputStream.close();
  	    outputStream.flush();
  	    outputStream.close();
  	}
}

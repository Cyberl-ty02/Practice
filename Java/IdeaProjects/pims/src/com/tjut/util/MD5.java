package com.tjut.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5 {
	/**利用MD5进行加密
     * @param str  待加密的字符串
     * @return  加密后的字符串
     * @throws NoSuchAlgorithmException  没有这种产生消息摘要的算法
     * @throws UnsupportedEncodingException  
     */
    public static String encryp(String message) throws NoSuchAlgorithmException, UnsupportedEncodingException{
        //确定计算方法
        MessageDigest md5=MessageDigest.getInstance("MD5");  
        byte[] msgBytes=message.getBytes("utf-8");
        md5.update(msgBytes);
        byte[] digest=md5.digest();
        return bytesToHexString(digest);       
    }
    
    private static String bytesToHexString(byte[] bytes){
    	StringBuffer hexValue=new StringBuffer();
    	int val=0;
    	for(int i=0;i<bytes.length;i++){
    		val=((int)bytes[i]) & 0xff;
    		if(val<16){
    			hexValue.append("0");
    		}
    		hexValue.append(Integer.toHexString(val));
    	}
    	return hexValue.toString();
    }
    
    public static void main(String a[]){    	
    	try {
			//String sql="select * from users";
			//DBTable dt=DBUtil.getDataSetInfo(sql);
			//if(dt!=null){
				//for(int i=0;i<dt.size();i++){
					//System.out.println(dt.get(0).get("admin"));
					System.out.println(MD5.encryp("Admin020318"));
				//}
			//}
			
			
		} catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}

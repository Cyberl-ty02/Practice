package com.tjut.util;

import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class CryptAES {

	private static final String keyStr = "Tian17ZHONG567IM";
	private static final String AESTYPE = "AES/ECB/PKCS5Padding";

	public static String AES_Encrypt(String plainText) {
		return AES_Encrypt(keyStr, plainText);
	}

	public static String AES_Decrypt(String encryptData) {
		return AES_Decrypt(keyStr, encryptData);
	}

	// private static String AES_Encrypt(String keyStr, String plainText)
	private static String AES_Encrypt(String keyStr, String plainText) {
		byte[] encrypt = null;
		try {
			Key key = generateKey(keyStr);
			Cipher cipher = Cipher.getInstance(AESTYPE);
			cipher.init(Cipher.ENCRYPT_MODE, key);
			encrypt = cipher.doFinal(plainText.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new String(Base64.encodeBase64(encrypt));
	}

	// private static String AES_Decrypt(String keyStr, String encryptData)
	private static String AES_Decrypt(String keyStr, String encryptData) {
		byte[] decrypt = null;
		try {
			Key key = generateKey(keyStr);
			Cipher cipher = Cipher.getInstance(AESTYPE);
			cipher.init(Cipher.DECRYPT_MODE, key);
			decrypt = cipher.doFinal(Base64.decodeBase64(encryptData));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new String(decrypt).trim();
	}

	private static Key generateKey(String key) throws Exception {
		try {
			SecretKeySpec keySpec = new SecretKeySpec(key.getBytes(), "AES");
			return keySpec;
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	public static void main(String[] args) {

		// String plainText = "tjut215";
		String plainText = "Lty8761351"; // 数据库密码
		String encText = AES_Encrypt(plainText);
		String decString = AES_Decrypt("lijaJPuZuPEYOalJKeEJIw==");

		System.out.println(encText);
		System.out.println(decString);

	}
}
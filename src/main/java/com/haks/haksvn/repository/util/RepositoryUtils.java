package com.haks.haksvn.repository.util;

import com.haks.haksvn.common.code.util.CodeUtils;
import com.haks.haksvn.common.crypto.MD5Crypt;

public class RepositoryUtils {
	
	public static String encryptPasswd(String passwd, String passwdType){
		if( CodeUtils.isMD5ApacheEncrytion(passwdType) ) return MD5Crypt.apacheCrypt(passwd);
		return passwd;
	}

	public static String getPasswdFileDelimeter(String passwdType ) {
		if( CodeUtils.isMD5ApacheEncrytion(passwdType) ) return ":";
		return "=";
	}
	
	public static String getFormattedAuthzTemplate(String template){
		return template.replaceAll("\r\n", "%n").replaceAll("\n","%n");
	}
}
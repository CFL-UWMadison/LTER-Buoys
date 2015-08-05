package edu.wisc.limnology.lter.utils;

import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Properties;

public class DbUtil {
	  public static Connection getConnection() {
		Connection dbConnection = null;
	     
	          try {
	              InputStream inputStream = DbUtil.class.getClassLoader()
	                      .getResourceAsStream("db.properties");
	              Properties properties = new Properties();
	              if (properties != null) {
	                  properties.load(inputStream);

	                  String dbDriver = properties.getProperty("dbDriver");
	                  String connectionUrl = properties
	                          .getProperty("connectionUrl");
	                  String userName = properties.getProperty("userName");
	                  String password = properties.getProperty("password");

	                  Class.forName(dbDriver).newInstance();
	                  dbConnection = DriverManager.getConnection(connectionUrl,
	                          userName, password);
	              }
	          } catch (Exception e) {
	              e.printStackTrace();
	          }
	          return dbConnection;
	      }
	  
	  public static Double toDouble(BigDecimal value) {
		  return (value != null) ? value.doubleValue() : null;
	  }
	  
	  public static Date toDate(Timestamp value) {
		  return (value != null) ? new Date(value.getTime()) : null;
	  }
	  public static String trim(String value) {
		  System.out.println("Lake Id" + value);
		  return (value.trim());
	  }
}



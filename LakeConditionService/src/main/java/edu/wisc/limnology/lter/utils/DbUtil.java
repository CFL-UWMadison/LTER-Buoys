package edu.wisc.limnology.lter.utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
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
	  }

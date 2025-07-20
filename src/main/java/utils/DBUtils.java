package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtils {

    private static final String JDBC_URL = "jdbc:derby://localhost:1527/keretaGo;create=true";
    private static final String JDBC_USER = "keretaGo";
    private static final String JDBC_PASSWORD = "keretago";

    static {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
}

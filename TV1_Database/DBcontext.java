package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    public static Connection getConnection() throws Exception {
        // Thay đổi thông tin kết nối cho khớp với máy của bạn
        String url = "jdbc:sqlserver://localhost:1433;databaseName=ExpenseManagement;encrypt=true;trustServerCertificate=true;";
        String user = "sa"; 
        String password = "123456"; // Sửa lại password SQL của bạn
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, user, password);
    }
}

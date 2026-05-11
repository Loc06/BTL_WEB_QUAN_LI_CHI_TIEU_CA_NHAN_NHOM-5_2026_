package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

public class ReportDAO {

    // Tính Tổng Thu hoặc Tổng Chi trong 1 tháng
    public double getTotalByType(int userId, int month, int year, String type) {
        double total = 0;
        String sql = "SELECT SUM(t.amount) FROM Transactions t "
                   + "WHERE t.user_id = ? AND t.type = ? "
                   + "AND MONTH(t.transaction_date) = ? AND YEAR(t.transaction_date) = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setNString(2, type);
            ps.setInt(3, month);
            ps.setInt(4, year);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // Lấy dữ liệu Biểu đồ tròn
    public Map<String, Double> getExpensePieChart(int userId, int month, int year) {
        Map<String, Double> dataMap = new LinkedHashMap<>();
        String sql = "SELECT c.category_name, SUM(t.amount) as total FROM Transactions t "
                   + "JOIN Categories c ON t.category_id = c.category_id "
                   + "WHERE t.user_id = ? AND t.type = N'Chi' "
                   + "AND MONTH(t.transaction_date) = ? AND YEAR(t.transaction_date) = ? "
                   + "GROUP BY c.category_name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, month);
            ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                dataMap.put(rs.getString("category_name"), rs.getDouble("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dataMap;
    }

    // Lấy dữ liệu Biểu đồ cột (Tổng Thu/Chi theo từng tháng trong năm)
    public Map<String, double[]> getMonthlyBarChart(int userId, int year) {
        // Key = "labels", "thu", "chi" → Value = mảng double theo từng tháng
        Map<String, double[]> result = new LinkedHashMap<>();

        // Mảng tạm lưu dữ liệu 12 tháng (index 0 = tháng 1, index 11 = tháng 12)
        double[] thuArray = new double[12];
        double[] chiArray = new double[12];

        // SQL đã sửa: dùng t.type thay vì c.type (khớp DB mới của Hiếu)
        String sql = "SELECT MONTH(t.transaction_date) AS thang, "
                   + "SUM(CASE WHEN t.type = N'Thu' THEN t.amount ELSE 0 END) AS tongThu, "
                   + "SUM(CASE WHEN t.type = N'Chi' THEN t.amount ELSE 0 END) AS tongChi "
                   + "FROM Transactions t "
                   + "WHERE t.user_id = ? AND YEAR(t.transaction_date) = ? "
                   + "GROUP BY MONTH(t.transaction_date) "
                   + "ORDER BY thang ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int thang = rs.getInt("thang"); // 1-12
                thuArray[thang - 1] = rs.getDouble("tongThu");
                chiArray[thang - 1] = rs.getDouble("tongChi");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        result.put("thu", thuArray);
        result.put("chi", chiArray);
        return result;
    }
}

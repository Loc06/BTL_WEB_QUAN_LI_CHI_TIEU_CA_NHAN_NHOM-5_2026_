package servlet;

import dao.DBContext;
import dao.ReportDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ExportServlet", urlPatterns = {"/thong-ke"})
public class ExportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Object sessionUser = session.getAttribute("userId");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = Integer.parseInt(sessionUser.toString());

        // Kiểm tra action
        String action = request.getParameter("action");

        if ("exportCSV".equals(action)) {
            // Nếu action = exportCSV → Tải file CSV về máy
            exportCSV(request, response, userId);
        } else {
            // Mặc định → Hiển thị trang thống kê
            showStatistic(request, response, userId);
        }
    }

    // ===================================================================
    // CHỨC NĂNG 1: HIỂN THỊ TRANG THỐNG KÊ (Logic cũ từ StatisticServlet)
    // ===================================================================
    private void showStatistic(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Lấy tháng/năm từ URL, mặc định = tháng hiện tại
        Calendar cal = Calendar.getInstance();
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");
        int month = (monthStr != null) ? Integer.parseInt(monthStr) : (cal.get(Calendar.MONTH) + 1);
        int year = (yearStr != null) ? Integer.parseInt(yearStr) : cal.get(Calendar.YEAR);

        // Tính tổng thu, tổng chi, số dư
        ReportDAO dao = new ReportDAO();
        Gson gson = new Gson();

        double tongThu = dao.getTotalByType(userId, month, year, "Thu");
        double tongChi = dao.getTotalByType(userId, month, year, "Chi");
        double soDu = tongThu - tongChi;

        request.setAttribute("tongThu", tongThu);
        request.setAttribute("tongChi", tongChi);
        request.setAttribute("soDu", soDu);

        // Dữ liệu biểu đồ tròn
        Map<String, Double> pieDataMap = dao.getExpensePieChart(userId, month, year);
        List<String> pieLabels = new ArrayList<>(pieDataMap.keySet());
        List<Double> pieData = new ArrayList<>(pieDataMap.values());

        request.setAttribute("pieLabels", gson.toJson(pieLabels));
        request.setAttribute("pieData", gson.toJson(pieData));
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);

        // ===== DỮ LIỆU BIỂU ĐỒ CỘT (3 biến mới theo yêu cầu Frontend) =====
        Map<String, double[]> barData = dao.getMonthlyBarChart(userId, year);
        double[] thuArr = barData.get("thu");
        double[] chiArr = barData.get("chi");

        // Tạo mảng labels: ["Tháng 1", "Tháng 2", ..., "Tháng 12"]
        List<String> barLabelsList = new ArrayList<>();
        List<Double> barThuList = new ArrayList<>();
        List<Double> barChiList = new ArrayList<>();
        for (int i = 0; i < 12; i++) {
            barLabelsList.add("Tháng " + (i + 1));
            barThuList.add(thuArr[i]);
            barChiList.add(chiArr[i]);
        }

        request.setAttribute("barLabels", gson.toJson(barLabelsList));
        request.setAttribute("barThu", gson.toJson(barThuList));
        request.setAttribute("barChi", gson.toJson(barChiList));

        // Chuyển sang trang JSP để hiển thị
        request.getRequestDispatcher("thong-ke.jsp").forward(request, response);
    }

    // ===================================================================
    // CHỨC NĂNG 2: XUẤT BÁO CÁO RA FILE CSV
    // ===================================================================
    private void exportCSV(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        // Lấy tháng/năm
        Calendar cal = Calendar.getInstance();
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");
        int month = (monthStr != null) ? Integer.parseInt(monthStr) : (cal.get(Calendar.MONTH) + 1);
        int year = (yearStr != null) ? Integer.parseInt(yearStr) : cal.get(Calendar.YEAR);

        // Thiết lập header để trình duyệt hiểu đây là file CSV cần tải về
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"BaoCao_Thang" + month + "_" + year + ".csv\"");

        try (PrintWriter out = response.getWriter()) {

            // Ghi BOM UTF-8 để Excel mở file không bị lỗi font tiếng Việt
            out.write('\uFEFF');

            // Dòng tiêu đề cột
            out.println("Ngày,Danh mục,Loại,Số tiền,Ghi chú");

            // Truy vấn chi tiết giao dịch trong tháng
            String sql = "SELECT t.transaction_date, c.category_name, t.type, t.amount, t.note "
                       + "FROM Transactions t "
                       + "JOIN Categories c ON t.category_id = c.category_id "
                       + "WHERE t.user_id = ? AND MONTH(t.transaction_date) = ? AND YEAR(t.transaction_date) = ? "
                       + "ORDER BY t.transaction_date ASC";

            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, userId);
                ps.setInt(2, month);
                ps.setInt(3, year);
                ResultSet rs = ps.executeQuery();

                // Ghi từng dòng giao dịch vào file CSV
                while (rs.next()) {
                    String date = rs.getString("transaction_date");
                    String catName = rs.getString("category_name");
                    String type = rs.getString("type");
                    double amount = rs.getDouble("amount");
                    String note = rs.getString("note");

                    // Xử lý note: nếu null thì để trống, bọc ngoặc kép tránh lỗi dấu phẩy
                    if (note == null) note = "";
                    note = "\"" + note.replace("\"", "\"\"") + "\"";

                    out.println(date + "," + catName + "," + type + "," + amount + "," + note);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            // Dòng tổng kết ở cuối file CSV
            ReportDAO dao = new ReportDAO();
            double tongThu = dao.getTotalByType(userId, month, year, "Thu");
            double tongChi = dao.getTotalByType(userId, month, year, "Chi");

            out.println();
            out.println(",,,Tổng Thu," + tongThu);
            out.println(",,,Tổng Chi," + tongChi);
            out.println(",,,Số Dư," + (tongThu - tongChi));
        }
    }
}

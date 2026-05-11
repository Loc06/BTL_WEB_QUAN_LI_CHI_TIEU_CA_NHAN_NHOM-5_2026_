package servlet;

import dao.DBContext;
import dao.TransactionDAO;
import model.Transaction;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "TransactionServlet", urlPatterns = {"/TransactionServlet"})
public class TransactionServlet extends HttpServlet {

    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
        Object sessionUser = session.getAttribute("userId");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = Integer.parseInt(sessionUser.toString());
        String action = request.getParameter("action");
        if (action == null) { action = "list"; }

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                transactionDAO.delete(id); 
                session.setAttribute("thongBao", "🗑️ Đã XÓA giao dịch thành công!");
                response.sendRedirect("TransactionServlet?action=list");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("tranEdit", transactionDAO.getById(id));
                request.getRequestDispatcher("edit.jsp").forward(request, response);
            } else {
                request.setAttribute("listTransaction", transactionDAO.getByUserId(userId));

                List<String[]> listCat = new ArrayList<>();
                // ĐÃ SỬA: Xóa chữ 'type' khỏi câu SQL vì bảng Categories không còn cột này nữa
                String sql = "SELECT category_id, category_name FROM Categories"; 
                try (Connection conn = new DBContext().getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        // ĐÃ SỬA: Chỉ lấy 2 cột là ID và Tên
                        listCat.add(new String[]{rs.getString(1), rs.getString(2)});
                    }
                }
                request.setAttribute("listCategories", listCat);
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Object sessionUser = session.getAttribute("userId");
        if (sessionUser == null) { response.sendRedirect("login.jsp"); return; }
        int userId = Integer.parseInt(sessionUser.toString());

        String action = request.getParameter("action");
        try {
            String amountStr = request.getParameter("amount"); 
            String categoryStr = request.getParameter("categoryId"); 
            String dateStr = request.getParameter("transactionDate");
            String note = request.getParameter("note");
            
            // ĐÃ THÊM: Hứng dữ liệu Loại giao dịch (Thu/Chi) từ web gửi xuống
            String type = request.getParameter("type"); 

            if (amountStr != null && categoryStr != null && dateStr != null) {
                double amount = Double.parseDouble(amountStr);
                int categoryId = Integer.parseInt(categoryStr);
                Date date = Date.valueOf(dateStr); 

                if ("add".equals(action)) {
                    // ĐÃ SỬA: Truyền thêm 'type' vào Constructor của giao dịch
                    transactionDAO.insert(new Transaction(0, userId, categoryId, amount, date, note, type)); 
                    session.setAttribute("thongBao", "✅ Đã THÊM MỚI giao dịch!");
                } else if ("update".equals(action)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    // ĐÃ SỬA: Truyền thêm 'type' vào
                    transactionDAO.update(new Transaction(id, userId, categoryId, amount, date, note, type)); 
                    session.setAttribute("thongBao", "✅ Đã CẬP NHẬT thành công!");
                }
            }
            response.sendRedirect("TransactionServlet?action=list");
        } catch (Exception e) { e.printStackTrace(); }
    }
}
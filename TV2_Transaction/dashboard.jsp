<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Transaction"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Quản Lý Chi Tiêu</title>
</head>
<body>
    <%
        String thongBao = (String) session.getAttribute("thongBao");
        if (thongBao != null) {
    %>
        <script>
            alert('<%= thongBao %>');
        </script>
    <%
            session.removeAttribute("thongBao"); // Xóa đi để F5 không bị hiện lại
        }
    %>

    <h1>Chào mừng bạn đã đăng nhập thành công!</h1>
    <p>User: ${sessionScope.user}</p>
    <a href="login.jsp">Đăng xuất</a>

    <hr style="margin-top: 20px; margin-bottom: 20px;">

    <h2>DANH SÁCH GIAO DỊCH CÁ NHÂN</h2>
    <table border="1" cellpadding="5" cellspacing="0" width="80%">
        <tr style="background:#ddd;">
            <th>Ngày</th><th>Số tiền</th><th>Loại</th><th>Ghi chú</th><th>Hành động</th>
        </tr>
        <%
            List<Transaction> list = (List<Transaction>) request.getAttribute("listTransaction");
            if (list != null && !list.isEmpty()) {
                for (Transaction t : list) {
        %>
        <tr>
            <td><%= t.getTransactionDate() %></td>
            <td><%= String.format("%,.0f", t.getAmount()) %> VNĐ</td>
            <td><b><%= t.getType() %></b></td>
            <td><%= t.getNote() != null ? t.getNote() : "" %></td>
            <td>
                <a href="TransactionServlet?action=edit&id=<%= t.getId() %>">Sửa</a> | 
                
                <a href="TransactionServlet?action=delete&id=<%= t.getId() %>" 
                   onclick="return confirm('⚠️ CẢNH BÁO: Bạn có chắc chắn muốn XÓA giao dịch này không?');" 
                   style="color: red; text-decoration: none; font-weight: bold;">
                   ❌ Xóa
                </a>
            </td>
        </tr>
        <% 
                } 
            } else { 
        %>
        <tr><td colspan="5" style="color:red;">Chưa có dữ liệu giao dịch nào. Hãy thêm mới ở bên dưới!</td></tr>
        <% 
            } 
        %>
    </table>

    <br>
    
    <form action="TransactionServlet" method="POST" style="border:1px solid #ccc; padding: 15px; width: fit-content;">
        <h3>THÊM GIAO DỊCH MỚI</h3>
        <input type="hidden" name="action" value="add">
        Số tiền: <input type="number" name="amount" required> <br><br>
        Danh mục: 
        <select name="categoryId">
            <option value="1">Lương (Thu)</option>
            <option value="2">Thưởng (Thu)</option>
            <option value="4">Ăn uống (Chi)</option>
            <option value="5">Tiền điện nước (Chi)</option>
            <option value="6">Tiền nhà (Chi)</option>
            <option value="7">Xăng xe (Chi)</option>
        </select><br><br>
        Ngày: <input type="date" name="transactionDate" required> <br><br>
        Ghi chú: <input type="text" name="note"> <br><br>
        <button type="submit" style="font-weight: bold;">➕ LƯU VÀO DATABASE</button>
    </form>

</body>
</html>

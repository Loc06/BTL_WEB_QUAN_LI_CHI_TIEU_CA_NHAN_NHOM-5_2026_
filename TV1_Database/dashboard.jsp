<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Transaction"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Wallet Dashboard - Quản Lý Chi Tiêu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<%
    // LẤY DỮ LIỆU TỪ SERVLET
    List<Transaction> list = (List<Transaction>) request.getAttribute("listTransaction");
    List<String[]> listCat = (List<String[]>) request.getAttribute("listCategories");
    
    // TÍNH TOÁN SỐ LIỆU TỔNG QUAN
    double tongThu = 0;
    double tongChi = 0;
    if (list != null) {
        for (Transaction t : list) {
            if ("Thu".equalsIgnoreCase(t.getType())) tongThu += t.getAmount();
            else tongChi += t.getAmount();
        }
    }
    double soDu = tongThu - tongChi;
%>
<body>
    <div class="app-container">
        <aside class="sidebar">
            <div class="logo"><i class="fas fa-wallet"></i> <span>Wallet</span></div>
            <nav class="menu">
                <div class="menu-item" onclick="switchTab('tong-quan', this)">
                    <i class="fas fa-th-large"></i> Tổng quan
                </div>
                <div class="menu-item active" onclick="switchTab('ghi-chep', this)">
                    <i class="fas fa-list-ul"></i> Ghi chép
                </div>
                <div class="menu-item" onclick="switchTab('tai-khoan', this)">
                    <i class="fas fa-university"></i> Tài khoản
                </div>
                <div class="menu-item" onclick="switchTab('phan-tich', this)">
                    <i class="fas fa-chart-line"></i> Phân tích
                </div>
            </nav>
            <div class="user-bottom">
                <div class="avatar"><i class="fas fa-user-circle"></i></div>
                <div class="user-name">${sessionScope.user}</div>
                <a href="login.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i></a>
            </div>
        </aside>

        <main class="main-content">
            <header class="top-header">
                <div class="breadcrumb">Giao diện / <b id="current-tab-title">Ghi chép</b></div>
                <button class="btn-add" onclick="openModal('addModal')">
                    <i class="fas fa-plus-circle"></i> Thêm giao dịch
                </button>
            </header>

            <section class="stats-grid">
                <div class="stat-card">
                    <span class="label">Số dư hiện tại</span>
                    <div class="value blue"><%= String.format("%,.0f", soDu) %> đ</div>
                </div>
                <div class="stat-card">
                    <span class="label">Tổng Thu nhập</span>
                    <div class="value green">+ <%= String.format("%,.0f", tongThu) %> đ</div>
                </div>
                <div class="stat-card">
                    <span class="label">Tổng Chi phí</span>
                    <div class="value red">- <%= String.format("%,.0f", tongChi) %> đ</div>
                </div>
                <div class="stat-card">
                    <span class="label">Trạng thái</span>
                    <div class="value"><%= soDu >= 0 ? "Ổn định" : "Cảnh báo" %></div>
                </div>
            </section>

            <div id="section-tong-quan" class="tab-content" style="display:none;">
                <div class="card-table">
                    <h3>Biểu đồ phân tích số dư</h3>
                    <p style="color: #888; padding: 20px;">Dữ liệu thống kê đang được xử lý...</p>
                </div>
            </div>

            <div id="section-ghi-chep" class="tab-content">
                <div class="card-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Danh mục</th>
                                <th>Ghi chú</th>
                                <th>Loại</th>
                                <th>Số tiền</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (list != null && !list.isEmpty()) { 
                                for (Transaction t : list) { %>
                            <tr>
                                <td><%= t.getTransactionDate() %></td>
                                <td><span class="cat-tag"><%= t.getCategoryName() %></span></td>
                                <td><%= t.getNote() != null ? t.getNote() : "" %></td>
                                <td><span class="type-badge <%= t.getType().equals("Thu") ? "type-thu" : "type-chi" %>"><%= t.getType() %></span></td>
                                <td class="amount-cell <%= t.getType().equals("Thu") ? "green" : "red" %>">
                                    <%= String.format("%,.0f", t.getAmount()) %> đ
                                </td>
                                <td>
                                    <button class="btn-icon edit" onclick="openEditModal('<%= t.getId() %>', '<%= t.getAmount() %>', '<%= t.getCategoryId() %>', '<%= t.getTransactionDate() %>', '<%= t.getNote() %>', '<%= t.getType() %>')">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <a href="TransactionServlet?action=delete&id=<%= t.getId() %>" class="btn-icon delete" onclick="return confirm('Bạn có chắc muốn xóa?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="section-tai-khoan" class="tab-content" style="display:none;">
                <div class="card-table">
                    <h3>Thông tin tài khoản</h3>
                    <div style="padding: 20px;">
                        <p>Người dùng: <b>${sessionScope.user}</b></p>
                        <p>Ví hiện tại: Tiền mặt</p>
                    </div>
                </div>
            </div>
            
            <div id="section-phan-tich" class="tab-content" style="display:none;">
                <div class="card-table">
                    <h3>Phân tích chi tiêu</h3>
                    <p style="color: #888; padding: 20px;">Tính năng này sẽ sớm ra mắt.</p>
                </div>
            </div>
        </main>
    </div>

    <div id="addModal" class="modal">
        <div class="modal-content">
            <h3>Thêm giao dịch mới</h3>
            <form action="TransactionServlet?action=add" method="POST">
                <input type="text" name="amount" placeholder="Số tiền (đ)" 
                       oninput="this.value = this.value.replace(/[^0-9]/g, '');" required>
                <select name="categoryId">
                    <% if (listCat != null) { for (String[] c : listCat) { %>
                        <option value="<%= c[0] %>"><%= c[1] %></option>
                    <% } } %>
                </select>
                <input type="date" name="transactionDate" required>
                <select name="type">
                    <option value="Chi">Khoản Chi</option>
                    <option value="Thu">Khoản Thu</option>
                </select>
                <textarea name="note" placeholder="Ghi chú..."></textarea>
                <div class="modal-btns">
                    <button type="submit" class="btn-save">Lưu lại</button>
                    <button type="button" class="btn-close" onclick="closeModal('addModal')">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <h3>Cập nhật giao dịch</h3>
            <form action="TransactionServlet?action=update" method="POST">
                <input type="hidden" name="id" id="edit-id">
                <input type="text" name="amount" id="edit-amount" 
                       oninput="this.value = this.value.replace(/[^0-9]/g, '');" required>
                <select name="categoryId" id="edit-category">
                    <% if (listCat != null) { for (String[] c : listCat) { %>
                        <option value="<%= c[0] %>"><%= c[1] %></option>
                    <% } } %>
                </select>
                <input type="date" name="transactionDate" id="edit-date" required>
                <select name="type" id="edit-type">
                    <option value="Chi">Khoản Chi</option>
                    <option value="Thu">Khoản Thu</option>
                </select>
                <textarea name="note" id="edit-note"></textarea>
                <div class="modal-btns">
                    <button type="submit" class="btn-save">Cập nhật</button>
                    <button type="button" class="btn-close" onclick="closeModal('editModal')">Hủy</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/asset/js/dashboard.js"></script>
</body>
</html>
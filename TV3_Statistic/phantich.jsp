<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phân tích chi tiêu | Wallet</title>
    <link rel="stylesheet" href="css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; margin: 0; display: flex; }
        .sidebar { width: 250px; height: 100vh; background: #fff; border-right: 1px solid #eee; position: fixed; }
        .main-content { margin-left: 250px; flex: 1; padding: 30px; }
        .card-stats { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); transition: 0.3s; }
        .card-stats:hover { transform: translateY(-5px); }
        .chart-box { background: #fff; border-radius: 15px; padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .status-badge { padding: 5px 15px; border-radius: 20px; font-size: 14px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 style="color: #2ecc71; padding: 20px;"><i class="fas fa-wallet"></i> Wallet</h2>
        <a href="thong-ke?type=dashboard" style="display:block; padding:15px; text-decoration:none; color:#333;">Tổng quan</a>
        <a href="thong-ke?type=analysis" style="display:block; padding:15px; text-decoration:none; color:#2ecc71; background:#f0fff4; font-weight:bold;">Phân tích</a>
    </div>

    <div class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h3 style="margin:0;">Giao diện / <strong>Phân tích</strong></h3>
            <div><i class="fas fa-user-circle"></i> ${sessionScope.user}</div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px;">
            <div class="card-stats">
                <small style="color:#888;">SỐ DƯ HIỆN TẠI</small>
                <h3 style="color:#2980b9;"><fmt:formatNumber value="${tongThu - tongChi}" pattern="#,###"/> ₫</h3>
            </div>
            <div class="card-stats">
                <small style="color:#888;">TỔNG THU NHẬP</small>
                <h3 style="color:#27ae60;">+ <fmt:formatNumber value="${tongThu}" pattern="#,###"/> ₫</h3>
            </div>
            <div class="card-stats">
                <small style="color:#888;">TỔNG CHI PHÍ</small>
                <h3 style="color:#e74c3c;">- <fmt:formatNumber value="${tongChi}" pattern="#,###"/> ₫</h3>
            </div>
            <div class="card-stats text-center">
                <small style="color:#888;">TRẠNG THÁI</small><br>
                <span class="status-badge ${tongThu >= tongChi ? 'bg-success' : 'bg-danger'}" 
                      style="background: ${tongThu >= tongChi ? '#d4edda' : '#f8d7da'}; 
                             color: ${tongThu >= tongChi ? '#155724' : '#721c24'};">
                    ${tongThu >= tongChi ? 'Ổn định' : 'Cảnh báo'}
                </span>
            </div>
        </div>

        <div class="chart-box">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h4 style="margin: 0;">Phân tích chi tiêu theo danh mục</h4>
        
        <a href="thong-ke?action=exportCSV&month=${selectedMonth}&year=${selectedYear}" 
           class="btn-export" 
           title="Tải về chi tiết giao dịch (.csv)"
           style="background: #27ae60; color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 5px;">
            <i class="fas fa-file-download"></i> Xuất CSV
        </a>
    </div>

    <div style="height: 300px; position: relative;">
        <canvas id="pieChartAnalysis"></canvas>
    </div>

    <p style="color: #999; font-size: 11px; margin-top: 15px; text-align: right; font-style: italic;">
        * Dữ liệu được thống kê theo từng danh mục trong tháng ${selectedMonth}/${selectedYear}
    </p>
</div>

            <div class="chart-box">
            <h4>Ghi chú hệ thống</h4>
            <div id="text-analysis-msg" style="padding: 10px; border-left: 4px solid #2ecc71; background: #f9f9f9;">
                    <c:choose>
                        <c:when test="${tongThu > 0}">
                            <p>Tỷ lệ tiết kiệm: <strong><fmt:formatNumber value="${((tongThu - tongChi) / tongThu) * 100}" maxFractionDigits="1"/>%</strong></p>
                            <p style="font-size: 14px; color: #666;">Dữ liệu dựa trên báo cáo tháng hiện tại.</p>
                        </c:when>
                        <c:otherwise>
                            <p>Chưa có dữ liệu thu nhập để tính toán tỷ lệ tiết kiệm.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
                
<script>
    // CHÈN THÊM: Sử dụng fetch để lấy dữ liệu JSON, đảm bảo giữ khung của Thành viên 5
    function loadPieChart() {
        // Sửa ID ở đây cho khớp với HTML: pieChartAnalysis
        const canvasElement = document.getElementById('pieChartAnalysis');
        
        if (canvasElement) {
            const ctx = canvasElement.getContext('2d');
            
            // Gọi đến API dữ liệu biểu đồ
            fetch('ChartDataServlet')
                .then(response => response.json())
                .then(data => {
                    // Nhận dữ liệu JSON từ Servlet
                    const pieLabels = data.pieLabels;
                    const pieData = data.pieData;

                    if (!pieLabels || pieLabels.length === 0) {
                        ctx.font = "16px 'Segoe UI'";
                        ctx.textAlign = "center";
                        ctx.fillText("Chưa có dữ liệu chi tiêu", canvasElement.width/2, canvasElement.height/2);
                    } else {
                        // Giữ nguyên khung cấu hình Chart.js của bạn, chỉ thay đổi dữ liệu
                        new Chart(ctx, {
                            type: 'doughnut', // Dạng vòng khuyết giống ảnh 1
                            data: {
                                labels: pieLabels,
                                datasets: [{
                                    data: pieData,
                                    // Chèn bộ màu sắc chuyên nghiệp hơn để giống ảnh 1
                                    backgroundColor: ['#2ecc71', '#e74c3c', '#3498db', '#f1c40f', '#9b59b6', '#34495e'],
                                    borderWidth: 2
                                }]
                            },
                            options: {
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        position: 'right', // Đưa chú thích sang phải giống ảnh 1
                                        labels: {
                                            boxWidth: 12,
                                            padding: 20
                                        }
                                    }
                                },
                                cutout: '70%' // Làm vòng tròn mỏng lại cho sang trọng
                            }
                        });
                    }
                })
                .catch(err => {
                    console.error("Lỗi vẽ biểu đồ tròn:", err);
                    ctx.font = "14px Arial";
                    ctx.fillText("Lỗi tải dữ liệu", 10, 50);
                });
        }
    }

    // Đảm bảo DOM load xong mới chạy
    window.onload = loadPieChart;
</script>

</body>
</html>
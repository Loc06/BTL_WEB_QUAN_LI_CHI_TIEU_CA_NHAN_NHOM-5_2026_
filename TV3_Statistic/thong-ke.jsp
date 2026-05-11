HTML
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bảng Điều Khiển - Thống Kê</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
       .container { display: flex; justify-content: space-around; margin-top: 20px; }
       .summary { font-size: 18px; font-weight: bold; font-family: Arial, sans-serif;}
       .chart-box { width: 400px; height: 400px; }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Báo Cáo Thu Chi Cá Nhân</h2>
    
    <div class="container">
        <div class="summary">
            <p style="color: green;">Tổng Thu: ${tongThu} VNĐ</p>
            <p style="color: red;">Tổng Chi: ${tongChi} VNĐ</p>
            <p style="color: blue;">Số Dư: ${soDu} VNĐ</p>
        </div>

        <div class="chart-box">
            <canvas id="myPieChart"></canvas>
        </div>
    </div>

    <script>
        // 1. Hứng dữ liệu mảng JSON từ Servlet của TV3
        const labelsData = ${pieLabels};
        const amountsData = ${pieData};

        // 2. Cấu hình và vẽ Chart.js
        const ctx = document.getElementById('myPieChart').getContext('2d');
        new Chart(ctx, {
            type: 'pie', // Biểu đồ tròn
            data: {
                labels: labelsData,
                datasets:
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                    },
                    title: {
                        display: true,
                        text: 'Tỷ Trọng Chi Tiêu Theo Danh Mục',
                        font: { size: 16 }
                    }
                }
            }
        });
    </script>
</body>
</html>

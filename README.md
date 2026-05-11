**Ứng dụng web quản lý chi tiêu cá nhân dành cho sinh viên** – cho phép theo dõi thu chi, phân tích số liệu và trực quan hóa bằng biểu đồ.

## 🎯 Công dụng

- Ghi lại các khoản **thu nhập** (lương, trợ cấp, tiền làm thêm…) và **chi tiêu** (ăn uống, học tập, giải trí…).
- Phân loại giao dịch theo danh mục (thực phẩm, di chuyển, hóa đơn, sức khỏe, v.v.).
- Tự động **tính toán số dư**, tổng thu chi theo ngày/tuần/tháng.
- **Thống kê trực quan** bằng biểu đồ cột, tròn hoặc đường (sử dụng Chart.js).
- Hỗ trợ **tìm kiếm**, lọc giao dịch theo thời gian hoặc danh mục.
- Giao diện thân thiện, tối ưu cho sinh viên sử dụng trên máy tính và thiết bị di động.

## 🛠️ Công nghệ sử dụng

| Thành phần | Công nghệ |
|-----------|------------|
| Backend | Java (Servlet/JSP hoặc Spring MVC) |
| Frontend | HTML5, CSS3, JavaScript |
| Biểu đồ | Chart.js |
| Cơ sở dữ liệu | MySQL / MariaDB |
| Server | Apache Tomcat (hoặc tương thích) |

## 📁 Cấu trúc thư mục dự án
├── TV1_Database # Script SQL tạo database và bảng
├── TV2_Transaction # Xử lý nghiệp vụ thêm/sửa/xóa giao dịch
├── TV3_Statistic # Logic thống kê và tổng hợp số liệu
├── TV4_Frontend # Giao diện người dùng (CSS, HTML, images)
├── TV5_JS_Chart # Mã JavaScript vẽ biểu đồ (thong-ke-chart.js)
└── README.md # Hướng dẫn này
📖 Cách sử dụng cơ bản
Đăng nhập / Đăng ký (nếu có module người dùng) hoặc sử dụng mặc định.

Thêm giao dịch:

Chọn loại: Thu / Chi.

Nhập số tiền, danh mục, ngày, ghi chú.

Xem danh sách giao dịch – hiển thị trong bảng, có thể sửa/xóa.

Xem thống kê:

Chọn mốc thời gian (ngày/tuần/tháng).

Biểu đồ hiển thị tổng thu, chi, số dư.

Xuất báo cáo (nếu được tích hợp).

👥 Tác giả
Nhóm 5 – Sinh viên lớp [FINTECH 01]
Thành viên đóng góp chính:

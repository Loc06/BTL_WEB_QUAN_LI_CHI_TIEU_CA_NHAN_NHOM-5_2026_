// ==========================================
// 1. QUẢN LÝ CHUYỂN TAB (DASHBOARD NAVIGATION)
// ==========================================

/**
 * Hàm switchTab: Chuyển đổi nội dung giữa các màn hình
 * @param {string} tabId - ID của tab (tong-quan, ghi-chep, tai-khoan, phan-tich)
 * @param {HTMLElement} element - Phần tử menu được click
 */
function switchTab(tabId, element) {
    // Ẩn tất cả các vùng nội dung (các thẻ div có class tab-content)
    const contents = document.querySelectorAll('.tab-content');
    contents.forEach(content => {
        content.style.display = 'none';
    });

    // Hiện vùng nội dung tương ứng với section-tabId
    const targetSection = document.getElementById('section-' + tabId);
    if (targetSection) {
        targetSection.style.display = 'block';
    }

    // Xóa class 'active' ở tất cả các menu-item để reset màu sắc
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        item.classList.remove('active');
    });
    
    // Thêm class 'active' vào menu vừa được chọn
    element.classList.add('active');

    // Cập nhật tiêu đề trên thanh Breadcrumb (Giao diện / ...)
    const breadTitle = document.getElementById('current-tab-title');
    if (breadTitle) {
        breadTitle.innerText = element.innerText.trim();
    }

    console.log("Đã chuyển sang tab: " + tabId);
}


// ==========================================
// 2. QUẢN LÝ MODAL (ĐÓNG/MỞ)
// ==========================================

/**
 * Mở Modal bằng ID
 */
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = "block";
    }
}

/**
 * Đóng Modal bằng ID
 */
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = "none";
    }
}

/**
 * Hàm mở Modal Sửa và tự động điền dữ liệu (Mapping dữ liệu từ bảng vào form)
 */
function openEditModal(id, amount, catId, date, note, type) {
    // 1. Mở modal edit
    openModal('editModal');
    
    // 2. Điền dữ liệu vào các input (Dùng ID đã đặt trong JSP)
    if(document.getElementById('edit-id')) document.getElementById('edit-id').value = id;
    if(document.getElementById('edit-amount')) document.getElementById('edit-amount').value = amount;
    if(document.getElementById('edit-category')) document.getElementById('edit-category').value = catId;
    if(document.getElementById('edit-date')) document.getElementById('edit-date').value = date;
    if(document.getElementById('edit-type')) document.getElementById('edit-type').value = type;
    
    // Xử lý ghi chú: nếu dữ liệu từ DB về là chuỗi "null" hoặc undefined thì để trắng ô nhập
    const noteInput = document.getElementById('edit-note');
    if(noteInput) {
        noteInput.value = (note === 'null' || note === undefined) ? '' : note;
    }
}

/**
 * Đóng modal khi người dùng click ra vùng bên ngoài (vùng xám)
 */
window.onclick = function(event) {
    // Kiểm tra nếu click trúng vào phần tử có class là 'modal'
    if (event.target.classList.contains('modal')) {
        event.target.style.display = "none";
    }
}


// ==========================================
// 3. XỬ LÝ NHẬP LIỆU (VALIDATION)
// ==========================================

/**
 * Hàm chặn nhập chữ: Chỉ cho phép số từ 0-9
 * (Hàm này được gọi từ thuộc tính onkeypress trong JSP)
 */
function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    // Nếu mã phím không nằm trong khoảng 48-57 (số 0-9) và không phải phím điều khiển (mã < 31)
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        console.warn("Chỉ được nhập số!");
        return false;
    }
    return true;
}

/**
 * Tự động xóa ký tự không phải số nếu người dùng cố tình dán (paste) hoặc dùng cách khác
 * Áp dụng cho tất cả các input có name="amount"
 */
document.addEventListener('DOMContentLoaded', function() {
    const amountInputs = document.querySelectorAll('input[name="amount"]');
    amountInputs.forEach(input => {
        input.addEventListener('input', function() {
            // Dùng regex để xóa tất cả ký tự KHÔNG PHẢI SỐ ngay lập tức
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    });
});
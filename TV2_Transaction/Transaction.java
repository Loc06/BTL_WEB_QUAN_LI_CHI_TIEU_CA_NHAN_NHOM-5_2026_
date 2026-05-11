package model;

import java.sql.Date;

public class Transaction {
    private int id;
    private int userId;
    private int categoryId;
    private double amount;
    private Date transactionDate;
    private String note;
    private String type; // Loại Thu/Chi lấy từ bảng Categories
    
    // THÊM MỚI: Biến để lưu Tên Danh Mục
    private String categoryName; 

    public Transaction() {}

    // Constructor cũ (7 tham số) - GIỮ NGUYÊN
    public Transaction(int id, int userId, int categoryId, double amount, Date transactionDate, String note, String type) {
        this.id = id; this.userId = userId; this.categoryId = categoryId;
        this.amount = amount; this.transactionDate = transactionDate;
        this.note = note; this.type = type;
    }

    // Constructor cũ (6 tham số) - GIỮ NGUYÊN
    public Transaction(int id, int userId, int categoryId, double amount, Date transactionDate, String note) {
        this.id = id; this.userId = userId; this.categoryId = categoryId;
        this.amount = amount; this.transactionDate = transactionDate; this.note = note;
    }

    // THÊM MỚI: Constructor 8 tham số (có chứa categoryName) để lấy full dữ liệu từ bảng lên
    public Transaction(int id, int userId, int categoryId, double amount, Date transactionDate, String note, String type, String categoryName) {
        this.id = id; this.userId = userId; this.categoryId = categoryId;
        this.amount = amount; this.transactionDate = transactionDate;
        this.note = note; this.type = type; 
        this.categoryName = categoryName;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public Date getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Date transactionDate) { this.transactionDate = transactionDate; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    // THÊM MỚI: Getter và Setter cho Danh mục
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}
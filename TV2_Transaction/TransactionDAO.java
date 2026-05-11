package dao;



import java.sql.*;

import java.util.ArrayList;

import java.util.List;

import model.Transaction;



public class TransactionDAO {



    public List<Transaction> getByUserId(int userId) {

        List<Transaction> list = new ArrayList<>();

        // ĐÃ SỬA: Đổi c.type thành t.type

        String sql = "SELECT t.transaction_id, t.user_id, t.category_id, t.amount, t.transaction_date, t.note, t.type, c.category_name " +

                     "FROM Transactions t JOIN Categories c ON t.category_id = c.category_id " +

                     "WHERE t.user_id = ? ORDER BY t.transaction_date DESC";

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                list.add(new Transaction(

                    rs.getInt("transaction_id"), rs.getInt("user_id"), rs.getInt("category_id"), 

                    rs.getDouble("amount"), rs.getDate("transaction_date"), rs.getString("note"), 

                    rs.getString("type"), rs.getString("category_name")

                ));

            }

        } catch (Exception e) { e.printStackTrace(); }

        return list;

    }



    public Transaction getById(int id) {

        // ĐÃ SỬA: Đổi c.type thành t.type

        String sql = "SELECT t.transaction_id, t.user_id, t.category_id, t.amount, t.transaction_date, t.note, t.type, c.category_name " +

                     "FROM Transactions t JOIN Categories c ON t.category_id = c.category_id WHERE t.transaction_id = ?";

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) return new Transaction(

                rs.getInt("transaction_id"), rs.getInt("user_id"), rs.getInt("category_id"), 

                rs.getDouble("amount"), rs.getDate("transaction_date"), rs.getString("note"), 

                rs.getString("type"), rs.getString("category_name")

            );

        } catch (Exception e) { e.printStackTrace(); }

        return null;

    }



    public void insert(Transaction t) {

        // ĐÃ SỬA: Thêm cột type vào lệnh INSERT

        String sql = "INSERT INTO Transactions (user_id, category_id, amount, transaction_date, note, type) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, t.getUserId()); 

            ps.setInt(2, t.getCategoryId()); 

            ps.setDouble(3, t.getAmount());

            ps.setDate(4, t.getTransactionDate()); 

            ps.setString(5, t.getNote());

            ps.setString(6, t.getType()); // Nạp giá trị Thu/Chi vào DB

            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }

    }



    public void update(Transaction t) {

        // ĐÃ SỬA: Thêm cột type vào lệnh UPDATE

        String sql = "UPDATE Transactions SET category_id=?, amount=?, transaction_date=?, note=?, type=? WHERE transaction_id=?";

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, t.getCategoryId()); 

            ps.setDouble(2, t.getAmount()); 

            ps.setDate(3, t.getTransactionDate());

            ps.setString(4, t.getNote()); 

            ps.setString(5, t.getType()); // Nạp giá trị Thu/Chi vào DB

            ps.setInt(6, t.getId());

            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }

    }



    public void delete(int id) {

        String sql = "DELETE FROM Transactions WHERE transaction_id=?";

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id); ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }

    }

}


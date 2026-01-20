package dao;

import model.PaymentModel;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PaymentDAO {
    
    /**
     * Create initial payment record when booking is made
     */
    public boolean createPayment(int bookingId, double totalPrice) {
        String sql = "INSERT INTO payment (bookingid, paidamount, remamount, paystatus) VALUES (?, 0, ?, 'pending')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ps.setDouble(2, totalPrice);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Create initial payment with deposit
     */
    public boolean createInitialPayment(int bookingId, double depositAmount, double remainingAmount) {
        String sql = "INSERT INTO payment (bookingid, paidamount, remamount, paystatus) VALUES (?, 0, ?, 'pending')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ps.setDouble(2, depositAmount + remainingAmount);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get payment by booking ID
     */
    public PaymentModel getByBookingId(int bookingId) {
        String sql = "SELECT * FROM payment WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all pending payments
     */
    public List<PaymentModel> getPendingPayments() {
        List<PaymentModel> list = new ArrayList<>();
        String sql = "SELECT p.*, b.clid, c.clname, c.clemail FROM payment p " +
                     "JOIN booking b ON p.bookingid = b.bookingid " +
                     "JOIN client c ON b.clid = c.clid " +
                     "WHERE p.paystatus = 'pending' OR p.paystatus = 'partial' " +
                     "ORDER BY p.payid DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get all payments
     */
    public List<PaymentModel> getAll() {
        List<PaymentModel> list = new ArrayList<>();
        String sql = "SELECT * FROM payment ORDER BY payid DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Record deposit payment
     */
    public boolean recordDeposit(int payId, String reference, double amount) {
        String sql = "UPDATE payment SET depopref = ?, depopdate = CURRENT_TIMESTAMP, " +
                     "paidamount = paidamount + ?, remamount = remamount - ?, " +
                     "paystatus = CASE WHEN remamount - ? <= 0 THEN 'paid' ELSE 'partial' END " +
                     "WHERE payid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reference);
            ps.setDouble(2, amount);
            ps.setDouble(3, amount);
            ps.setDouble(4, amount);
            ps.setInt(5, payId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Record full payment
     */
    public boolean recordFullPayment(int payId, String reference, double amount) {
        String sql = "UPDATE payment SET fullpref = ?, fullpdate = CURRENT_TIMESTAMP, " +
                     "paidamount = paidamount + ?, remamount = remamount - ?, " +
                     "paystatus = CASE WHEN remamount - ? <= 0 THEN 'paid' ELSE 'partial' END " +
                     "WHERE payid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reference);
            ps.setDouble(2, amount);
            ps.setDouble(3, amount);
            ps.setDouble(4, amount);
            ps.setInt(5, payId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Client submits payment proof
     */
    public boolean submitPaymentProof(int bookingId, String reference, double amount, String receiptPath) {
        String sql = "UPDATE payment SET depopref = ?, paidamount = ?, receipts = ?, paystatus = 'submitted' " +
                     "WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reference);
            ps.setDouble(2, amount);
            ps.setString(3, receiptPath);
            ps.setInt(4, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Client submits deposit payment - updates DEPOPREF column
     */
    public boolean submitDepositPayment(int bookingId, String reference, double amount, String receiptPath) {
        String sql = "UPDATE payment SET depopref = ?, depopdate = CURRENT_TIMESTAMP, deporeceipt = ?, paystatus = 'submitted' " +
                     "WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reference);
            ps.setString(2, receiptPath);
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Client submits full/remaining payment - updates FULLPREF column
     */
    public boolean submitFullPayment(int bookingId, String reference, double amount, String receiptPath) {
        String sql = "UPDATE payment SET fullpref = ?, fullpdate = CURRENT_TIMESTAMP, fullreceipt = ?, paystatus = 'submitted' " +
                     "WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reference);
            ps.setString(2, receiptPath);
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Verify payment by admin - decreases remaining amount when deposit is verified
     */
    public boolean verifyPayment(int payId, int verifiedBy) {
        // First get the current payment to check deposit amount
        String selectSql = "SELECT bookingid, remamount FROM payment WHERE payid = ?";
        String updateSql = "UPDATE payment SET paystatus = 'verified', verifiedby = ?, verifieddate = CURRENT_TIMESTAMP " +
                          "WHERE payid = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Just update status to verified
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, verifiedBy);
                ps.setInt(2, payId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Verify deposit payment - updates paid amount and decreases remaining
     */
    public boolean verifyDepositPayment(int payId, double depositAmount, int verifiedBy) {
        String sql = "UPDATE payment SET paidamount = paidamount + ?, remamount = remamount - ?, " +
                     "paystatus = CASE WHEN remamount - ? <= 0 THEN 'verified' ELSE 'partial' END, " +
                     "verifiedby = ?, verifieddate = CURRENT_TIMESTAMP " +
                     "WHERE payid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, depositAmount);
            ps.setDouble(2, depositAmount);
            ps.setDouble(3, depositAmount);
            ps.setInt(4, verifiedBy);
            ps.setInt(5, payId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Verify full payment - marks as fully verified
     */
    public boolean verifyFullPayment(int payId, double fullAmount, int verifiedBy) {
        String sql = "UPDATE payment SET paidamount = paidamount + ?, remamount = remamount - ?, " +
                     "paystatus = 'verified', verifiedby = ?, verifieddate = CURRENT_TIMESTAMP " +
                     "WHERE payid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setDouble(1, fullAmount);
            ps.setDouble(2, fullAmount);
            ps.setInt(3, verifiedBy);
            ps.setInt(4, payId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Reject payment
     */
    public boolean rejectPayment(int payId, int verifiedBy) {
        String sql = "UPDATE payment SET paystatus = 'rejected', verifiedby = ?, verifieddate = CURRENT_TIMESTAMP " +
                     "WHERE payid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, verifiedBy);
            ps.setInt(2, payId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if payment is verified
     */
    public boolean isPaymentVerified(int bookingId) {
        String sql = "SELECT paystatus FROM payment WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("paystatus");
                return "verified".equals(status);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update receipt path
     */
    public boolean updateReceipt(int payId, String receiptPath) {
        String sql = "UPDATE payment SET receipts = ? WHERE payid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, receiptPath);
            ps.setInt(2, payId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Count payments by status
     */
    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM payment WHERE paystatus = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Get payments by status with full booking/client details
     */
    public List<Map<String, Object>> getPaymentsByStatusList(String status) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.*, b.bookingid, b.bookdate, b.totalprice, " +
                     "c.clname AS clientname, c.clemail AS clientemail, c.clph AS clientphone, " +
                     "pkg.pkgname AS packagename, pkg.pkgcateg AS packagecateg " +
                     "FROM payment p " +
                     "JOIN booking b ON p.bookingid = b.bookingid " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package pkg ON b.pkgid = pkg.pkgid " +
                     "WHERE p.paystatus = ? " +
                     "ORDER BY p.payid DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("payId", rs.getInt("payid"));
                row.put("bookingId", rs.getInt("bookingid"));
                row.put("bookDate", rs.getDate("bookdate"));
                row.put("totalPrice", rs.getDouble("totalprice"));
                row.put("paidAmount", rs.getDouble("paidamount"));
                row.put("remAmount", rs.getDouble("remamount"));
                row.put("depoRef", rs.getString("depopref"));
                row.put("depoDate", rs.getDate("depopdate"));
                row.put("fullRef", rs.getString("fullpref"));
                row.put("fullDate", rs.getDate("fullpdate"));
                row.put("payStatus", rs.getString("paystatus"));
                row.put("clientName", rs.getString("clientname"));
                row.put("clientEmail", rs.getString("clientemail"));
                row.put("clientPhone", rs.getString("clientphone"));
                row.put("packageName", rs.getString("packagename"));
                row.put("packageCateg", rs.getString("packagecateg"));
                row.put("verifiedDate", rs.getDate("verifieddate"));
                
                // Get receipt paths
                try {
                    row.put("depoReceipt", rs.getString("deporeceipt"));
                    row.put("fullReceipt", rs.getString("fullreceipt"));
                } catch (SQLException e) {
                    row.put("depoReceipt", null);
                    row.put("fullReceipt", null);
                }
                
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get confirm history - all payments with verifiedDate or that have been processed
     */
    public List<Map<String, Object>> getConfirmHistory() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.*, b.bookingid, b.totalprice, " +
                     "c.clname AS clientname, " +
                     "pg.pgname AS verifiername " +
                     "FROM payment p " +
                     "JOIN booking b ON p.bookingid = b.bookingid " +
                     "JOIN client c ON b.clid = c.clid " +
                     "LEFT JOIN photographer pg ON p.verifiedby = pg.pgid " +
                     "WHERE p.paystatus IN ('verified', 'partial', 'rejected') " +
                     "ORDER BY p.verifieddate DESC NULLS LAST, p.payid DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("payId", rs.getInt("payid"));
                row.put("bookingId", rs.getInt("bookingid"));
                row.put("totalPrice", rs.getDouble("totalprice"));
                row.put("paidAmount", rs.getDouble("paidamount"));
                row.put("remAmount", rs.getDouble("remamount"));
                row.put("payStatus", rs.getString("paystatus"));
                row.put("clientName", rs.getString("clientname"));
                row.put("verifierName", rs.getString("verifiername"));
                row.put("verifiedDate", rs.getDate("verifieddate"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    private PaymentModel mapResultSet(ResultSet rs) throws SQLException {
        PaymentModel p = new PaymentModel();
        p.setPayId(rs.getInt("payid"));
        p.setBookingId(rs.getInt("bookingid"));
        p.setDepoRef(rs.getString("depopref"));
        p.setDepoDate(rs.getDate("depopdate"));
        p.setFullRef(rs.getString("fullpref"));
        p.setFullDate(rs.getDate("fullpdate"));
        p.setPaidAmount(rs.getDouble("paidamount"));
        p.setRemAmount(rs.getDouble("remamount"));
        p.setReceipts(rs.getString("receipts"));
        p.setPayStatus(rs.getString("paystatus"));
        
        try {
            p.setDepoReceipt(rs.getString("deporeceipt"));
            p.setFullReceipt(rs.getString("fullreceipt"));
        } catch (SQLException e) {
            // Columns may not exist in all queries
        }
        
        try {
            p.setVerifiedBy(rs.getInt("verifiedby"));
            p.setVerifiedDate(rs.getDate("verifieddate"));
        } catch (SQLException e) {
            // Columns may not exist in all queries
        }
        
        return p;
    }
}

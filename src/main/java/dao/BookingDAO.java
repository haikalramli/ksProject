package dao;

import model.BookingModel;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookingDAO {
    
    /**
     * Create new booking with TIMESTAMP
     */
    public boolean saveBooking(BookingModel booking) {
        String sql = "INSERT INTO booking (clid, pkgid, bookdate, bookstarttime, bookendtime, bookpax, booklocation, totalprice, bookstatus, booknotes) " +
                     "VALUES (?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, booking.getClId());
            ps.setInt(2, booking.getPkgId());
            ps.setString(3, booking.getBookDate());
            ps.setTimestamp(4, booking.getBookStartTime());
            ps.setTimestamp(5, booking.getBookEndTime());
            ps.setInt(6, booking.getBookPax());
            ps.setString(7, booking.getBookLocation());
            ps.setDouble(8, booking.getTotalPrice());
            ps.setString(9, booking.getBookStatus() != null ? booking.getBookStatus() : "Pending");
            ps.setString(10, booking.getBookNotes());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get all bookings for calendar
     */
    public List<BookingModel> getAllBookings() {
        List<BookingModel> list = new ArrayList<>();
        String sql = "SELECT b.*, c.clname, c.clph AS clientphone, c.clemail AS clientemail, " +
                     "p.pkgname, p.pkgcateg, p.pkgprice, p.pkgduration, pg.pgname AS photographername " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN photographer pg ON b.pgid = pg.pgid " +
                     "WHERE b.bookstatus != 'Cancelled' " +
                     "ORDER BY b.bookdate DESC, b.bookstarttime DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapFullResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get all bookings for photo upload (all bookings, not just confirmed)
     */
    public List<BookingModel> getBookingsForPhotoUpload() {
        List<BookingModel> list = new ArrayList<>();
        String sql = "SELECT b.*, c.clname, c.clph AS clientphone, c.clemail AS clientemail, " +
                     "p.pkgname, p.pkgcateg, p.pkgprice, p.pkgduration, pg.pgname AS photographername " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN photographer pg ON b.pgid = pg.pgid " +
                     "WHERE b.bookstatus IN ('Confirmed', 'Completed', 'Pending') " +
                     "ORDER BY b.bookdate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapFullResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get bookings by date
     */
    public List<BookingModel> getBookingsByDate(String date) {
        List<BookingModel> list = new ArrayList<>();
        String sql = "SELECT b.*, c.clname, c.clph AS clientphone, c.clemail AS clientemail, " +
                     "p.pkgname, p.pkgcateg, p.pkgprice, p.pkgduration, pg.pgname AS photographername " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN photographer pg ON b.pgid = pg.pgid " +
                     "WHERE TO_CHAR(b.bookdate, 'YYYY-MM-DD') = ? AND b.bookstatus != 'Cancelled' " +
                     "ORDER BY b.bookstarttime";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, date);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapFullResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get bookings by month (for calendar) with category
     */
    public List<Map<String, Object>> getBookingsByMonth(int year, int month) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.bookingid, TO_CHAR(b.bookdate, 'YYYY-MM-DD') AS datestr, " +
                     "b.bookstarttime, b.bookendtime, b.bookstatus, " +
                     "p.pkgname, p.pkgcateg, c.clname " +
                     "FROM booking b " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "JOIN client c ON b.clid = c.clid " +
                     "WHERE EXTRACT(YEAR FROM b.bookdate) = ? AND EXTRACT(MONTH FROM b.bookdate) = ? " +
                     "AND b.bookstatus != 'Cancelled' " +
                     "ORDER BY b.bookdate, b.bookstarttime";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, year);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("bookingId", rs.getInt("bookingid"));
                row.put("date", rs.getString("datestr"));
                row.put("startTime", rs.getTimestamp("bookstarttime"));
                row.put("endTime", rs.getTimestamp("bookendtime"));
                row.put("status", rs.getString("bookstatus"));
                row.put("packageName", rs.getString("pkgname"));
                row.put("category", rs.getString("pkgcateg"));
                row.put("clientName", rs.getString("clname"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get bookings by client ID
     */
    public List<BookingModel> getBookingsByClientId(int clientId) {
        List<BookingModel> list = new ArrayList<>();
        String sql = "SELECT b.*, c.clname, c.clph AS clientphone, c.clemail AS clientemail, " +
                     "p.pkgname, p.pkgcateg, p.pkgprice, p.pkgduration, pg.pgname AS photographername " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN photographer pg ON b.pgid = pg.pgid " +
                     "WHERE b.clid = ? " +
                     "ORDER BY b.bookdate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapFullResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get booking by ID
     */
    public BookingModel getById(int bookingId) {
        String sql = "SELECT b.*, c.clname, c.clph AS clientphone, c.clemail AS clientemail, " +
                     "p.pkgname, p.pkgcateg, p.pkgprice, p.pkgduration, pg.pgname AS photographername " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN photographer pg ON b.pgid = pg.pgid " +
                     "WHERE b.bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapFullResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Update booking status
     */
    public boolean updateStatus(int bookingId, String status) {
        String sql = "UPDATE booking SET bookstatus = ? WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Assign photographer to booking
     */
    public boolean assignPhotographer(int bookingId, int photographerId) {
        String sql = "UPDATE booking SET pgid = ? WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, photographerId);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get last booking by client
     */
    public BookingModel getLastBookingByClient(int clientId) {
        String sql = "SELECT b.*, c.clname, c.clph AS clientphone, c.clemail AS clientemail, " +
                     "p.pkgname, p.pkgcateg, p.pkgprice, p.pkgduration, pg.pgname AS photographername " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN photographer pg ON b.pgid = pg.pgid " +
                     "WHERE b.clid = ? ORDER BY b.bookingid DESC FETCH FIRST 1 ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapFullResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get booking count by status
     */
    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM booking WHERE bookstatus = ?";
        
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
     * Link photo folder to booking
     */
    public boolean linkPhotoToBooking(int bookingId, int folderId) {
        String sql = "UPDATE booking SET folderid = ? WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, folderId);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get bookings by status
     */
    public List<BookingModel> getBookingsByStatus(String status) {
        List<BookingModel> list = new ArrayList<>();
        String sql = "SELECT b.*, c.clname, c.clph AS clientphone, c.clemail AS clientemail, " +
                     "p.pkgname, p.pkgcateg, p.pkgprice, p.pkgduration, pg.pgname AS photographername " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN photographer pg ON b.pgid = pg.pgid " +
                     "WHERE b.bookstatus = ? " +
                     "ORDER BY b.bookdate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapFullResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get bookings with payment info for verify payment page
     */
    public List<Map<String, Object>> getBookingsWithPaymentInfo() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.bookingid, b.bookdate, b.bookstarttime, b.bookendtime, b.totalprice, b.bookstatus, " +
                     "c.clid, c.clname, c.clemail, c.clph, " +
                     "p.pkgname, p.pkgcateg, " +
                     "pay.payid, pay.depopref, pay.depopdate, pay.fullpref, pay.fullpdate, " +
                     "pay.paidamount, pay.remamount, pay.paystatus, pay.receipts " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "LEFT JOIN payment pay ON b.bookingid = pay.bookingid " +
                     "ORDER BY b.bookcreated DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("bookingId", rs.getInt("bookingid"));
                row.put("bookDate", rs.getDate("bookdate"));
                row.put("bookStartTime", rs.getTimestamp("bookstarttime"));
                row.put("bookEndTime", rs.getTimestamp("bookendtime"));
                row.put("totalPrice", rs.getDouble("totalprice"));
                row.put("bookStatus", rs.getString("bookstatus"));
                row.put("clientId", rs.getInt("clid"));
                row.put("clientName", rs.getString("clname"));
                row.put("clientEmail", rs.getString("clemail"));
                row.put("clientPhone", rs.getString("clph"));
                row.put("packageName", rs.getString("pkgname"));
                row.put("packageCateg", rs.getString("pkgcateg"));
                row.put("payId", rs.getInt("payid"));
                row.put("depoRef", rs.getString("depopref"));
                row.put("depoDate", rs.getDate("depopdate"));
                row.put("fullRef", rs.getString("fullpref"));
                row.put("fullDate", rs.getDate("fullpdate"));
                row.put("paidAmount", rs.getDouble("paidamount"));
                row.put("remAmount", rs.getDouble("remamount"));
                row.put("payStatus", rs.getString("paystatus"));
                row.put("receipts", rs.getString("receipts"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Check if a time slot is already booked on a specific date
     */
    public boolean isTimeSlotBooked(String bookDate, java.sql.Timestamp startTime) {
        String sql = "SELECT COUNT(*) FROM booking " +
                     "WHERE TO_CHAR(bookdate, 'YYYY-MM-DD') = ? " +
                     "AND bookstarttime = ? " +
                     "AND bookstatus NOT IN ('Cancelled')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, bookDate);
            ps.setTimestamp(2, startTime);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get booked time slots for a specific date
     */
    public List<String> getBookedTimeSlots(String bookDate) {
        List<String> bookedTimes = new ArrayList<>();
        String sql = "SELECT bookstarttime FROM booking " +
                     "WHERE TO_CHAR(bookdate, 'YYYY-MM-DD') = ? " +
                     "AND bookstatus NOT IN ('Cancelled')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, bookDate);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Timestamp ts = rs.getTimestamp("bookstarttime");
                if (ts != null) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm");
                    bookedTimes.add(sdf.format(ts));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedTimes;
    }
    
    private BookingModel mapFullResultSet(ResultSet rs) throws SQLException {
        BookingModel b = new BookingModel();
        b.setBookingId(rs.getInt("bookingid"));
        b.setClId(rs.getInt("clid"));
        int pgid = rs.getInt("pgid");
        b.setPgId(rs.wasNull() ? null : pgid);
        b.setPkgId(rs.getInt("pkgid"));
        int folderId = rs.getInt("folderid");
        b.setFolderId(rs.wasNull() ? null : folderId);
        b.setBookDate(rs.getString("bookdate"));
        b.setBookStartTime(rs.getTimestamp("bookstarttime"));
        b.setBookEndTime(rs.getTimestamp("bookendtime"));
        b.setBookPax(rs.getInt("bookpax"));
        b.setBookLocation(rs.getString("booklocation"));
        b.setTotalPrice(rs.getDouble("totalprice"));
        b.setBookStatus(rs.getString("bookstatus"));
        b.setBookNotes(rs.getString("booknotes"));
        b.setBookCreated(rs.getDate("bookcreated"));
        
        b.setClientName(rs.getString("clname"));
        b.setClientPhone(rs.getString("clientphone"));
        b.setClientEmail(rs.getString("clientemail"));
        b.setPackageName(rs.getString("pkgname"));
        b.setPackageCateg(rs.getString("pkgcateg"));
        b.setPackagePrice(rs.getDouble("pkgprice"));
        
        try {
            b.setPackageDuration(rs.getDouble("pkgduration"));
        } catch (SQLException e) {
            // Column might not exist in some queries
        }
        
        b.setPhotographerName(rs.getString("photographername"));
        
        return b;
    }
    
    /**
     * Get bookings with verified payment but no photo uploaded (Pending Upload)
     */
    public List<Map<String, Object>> getBookingsWithVerifiedPaymentNoPhoto() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.bookingid, b.bookdate, b.bookstarttime, b.bookendtime, " +
                     "c.clname, c.clemail, c.clph, " +
                     "p.pkgname, p.pkgcateg, " +
                     "pay.paystatus, pay.paidamount, pay.remamount " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "JOIN payment pay ON b.bookingid = pay.bookingid " +
                     "WHERE pay.paystatus = 'verified' AND b.folderid IS NULL " +
                     "ORDER BY b.bookdate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("bookingId", rs.getInt("bookingid"));
                row.put("bookDate", rs.getDate("bookdate"));
                row.put("bookStartTime", rs.getTimestamp("bookstarttime"));
                row.put("bookEndTime", rs.getTimestamp("bookendtime"));
                row.put("clientName", rs.getString("clname"));
                row.put("clientEmail", rs.getString("clemail"));
                row.put("clientPhone", rs.getString("clph"));
                row.put("packageName", rs.getString("pkgname"));
                row.put("packageCateg", rs.getString("pkgcateg"));
                row.put("payStatus", rs.getString("paystatus"));
                row.put("paidAmount", rs.getDouble("paidamount"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get bookings with verified payment AND photo uploaded (Completed Upload)
     */
    public List<Map<String, Object>> getBookingsWithVerifiedPaymentAndPhoto() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.bookingid, b.bookdate, b.bookstarttime, b.bookendtime, " +
                     "c.clname, c.clemail, c.clph, " +
                     "p.pkgname, p.pkgcateg, " +
                     "pay.paystatus, pay.paidamount, " +
                     "ph.folderid, ph.foldername, ph.folderlink, ph.folderdupload, pg.pgname AS uploadedby " +
                     "FROM booking b " +
                     "JOIN client c ON b.clid = c.clid " +
                     "JOIN package p ON b.pkgid = p.pkgid " +
                     "JOIN payment pay ON b.bookingid = pay.bookingid " +
                     "JOIN photo ph ON b.folderid = ph.folderid " +
                     "LEFT JOIN photographer pg ON ph.uploadedby = pg.pgid " +
                     "WHERE pay.paystatus = 'verified' " +
                     "ORDER BY ph.folderdupload DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("bookingId", rs.getInt("bookingid"));
                row.put("bookDate", rs.getDate("bookdate"));
                row.put("bookStartTime", rs.getTimestamp("bookstarttime"));
                row.put("bookEndTime", rs.getTimestamp("bookendtime"));
                row.put("clientName", rs.getString("clname"));
                row.put("clientEmail", rs.getString("clemail"));
                row.put("clientPhone", rs.getString("clph"));
                row.put("packageName", rs.getString("pkgname"));
                row.put("packageCateg", rs.getString("pkgcateg"));
                row.put("payStatus", rs.getString("paystatus"));
                row.put("paidAmount", rs.getDouble("paidamount"));
                row.put("folderId", rs.getInt("folderid"));
                row.put("folderName", rs.getString("foldername"));
                row.put("folderLink", rs.getString("folderlink"));
                row.put("uploadDate", rs.getDate("folderdupload"));
                row.put("uploadedBy", rs.getString("uploadedby"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Update booking date and time
     */
    public boolean updateDateTime(int bookingId, String bookDate, Timestamp startTime, Timestamp endTime) {
        String sql = "UPDATE booking SET bookdate = TO_DATE(?, 'YYYY-MM-DD'), " +
                     "bookstarttime = ?, bookendtime = ? WHERE bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, bookDate);
            ps.setTimestamp(2, startTime);
            ps.setTimestamp(3, endTime);
            ps.setInt(4, bookingId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if time slot is booked (excluding a specific booking ID)
     */
    public boolean isTimeSlotBookedExcept(String bookDate, java.sql.Timestamp startTime, int excludeBookingId) {
        String sql = "SELECT COUNT(*) FROM booking " +
                     "WHERE TO_CHAR(bookdate, 'YYYY-MM-DD') = ? " +
                     "AND bookstarttime = ? " +
                     "AND bookingid != ? " +
                     "AND bookstatus NOT IN ('Cancelled')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, bookDate);
            ps.setTimestamp(2, startTime);
            ps.setInt(3, excludeBookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

package dao;

import model.PackageModel;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PackageDAO - Handles packages for both Photographer and Client
 * Packages created by photographers are viewed by clients
 */
public class PackageDAO {
    
    /**
     * Get all active packages (for Client to browse)
     */
    public List<PackageModel> findAll() {
        List<PackageModel> list = new ArrayList<>();
        String sql = "SELECT p.*, i.numofpax, i.backgtype, o.distance, o.distancepriceperkm, o.location " +
                     "FROM package p " +
                     "LEFT JOIN indoor i ON p.pkgid = i.pkgid " +
                     "LEFT JOIN outdoor o ON p.pkgid = o.pkgid " +
                     "WHERE p.pkgstatus = 'active' ORDER BY p.pkgid";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get packages by category (Indoor/Outdoor)
     */
    public List<PackageModel> findByCategory(String category) {
        List<PackageModel> list = new ArrayList<>();
        String sql = "SELECT p.*, i.numofpax, i.backgtype, o.distance, o.distancepriceperkm, o.location " +
                     "FROM package p " +
                     "LEFT JOIN indoor i ON p.pkgid = i.pkgid " +
                     "LEFT JOIN outdoor o ON p.pkgid = o.pkgid " +
                     "WHERE p.pkgcateg = ? AND p.pkgstatus = 'active' ORDER BY p.pkgid";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get package by ID
     */
    public PackageModel getById(int pkgId) {
        String sql = "SELECT p.*, i.numofpax, i.backgtype, o.distance, o.distancepriceperkm, o.location " +
                     "FROM package p " +
                     "LEFT JOIN indoor i ON p.pkgid = i.pkgid " +
                     "LEFT JOIN outdoor o ON p.pkgid = o.pkgid " +
                     "WHERE p.pkgid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pkgId);
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
     * Create new indoor package (by Photographer)
     */
    public boolean createIndoorPackage(PackageModel pkg) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Insert into package table
            String sql1 = "INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby) " +
                         "VALUES (?, ?, 'Indoor', ?, ?, ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, pkg.getPkgName());
            ps1.setDouble(2, pkg.getPkgPrice());
            ps1.setDouble(3, pkg.getPkgDuration());
            ps1.setString(4, pkg.getEventType());
            ps1.setString(5, pkg.getPkgDesc());
            ps1.setInt(6, pkg.getCreatedBy());
            ps1.executeUpdate();
            
            // Get generated ID
            ResultSet rs = ps1.getGeneratedKeys();
            int pkgId = 0;
            if (rs.next()) {
                pkgId = rs.getInt(1);
            }
            
            // Insert into indoor table
            String sql2 = "INSERT INTO indoor (pkgid, numofpax, backgtype) VALUES (?, ?, ?)";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, pkgId);
            ps2.setInt(2, pkg.getNumOfPax());
            ps2.setString(3, pkg.getBackgType());
            ps2.executeUpdate();
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
    
    /**
     * Create new outdoor package (by Photographer)
     */
    public boolean createOutdoorPackage(PackageModel pkg) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Insert into package table
            String sql1 = "INSERT INTO package (pkgname, pkgprice, pkgcateg, pkgduration, eventtype, pkgdesc, createdby) " +
                         "VALUES (?, ?, 'Outdoor', ?, ?, ?, ?)";
            PreparedStatement ps1 = conn.prepareStatement(sql1, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, pkg.getPkgName());
            ps1.setDouble(2, pkg.getPkgPrice());
            ps1.setDouble(3, pkg.getPkgDuration());
            ps1.setString(4, pkg.getEventType());
            ps1.setString(5, pkg.getPkgDesc());
            ps1.setInt(6, pkg.getCreatedBy());
            ps1.executeUpdate();
            
            // Get generated ID
            ResultSet rs = ps1.getGeneratedKeys();
            int pkgId = 0;
            if (rs.next()) {
                pkgId = rs.getInt(1);
            }
            
            // Insert into outdoor table
            String sql2 = "INSERT INTO outdoor (pkgid, distance, distancepriceperkm, location) VALUES (?, ?, ?, ?)";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, pkgId);
            ps2.setDouble(2, pkg.getDistance());
            ps2.setDouble(3, pkg.getDistancePricePerKm());
            ps2.setString(4, pkg.getLocation());
            ps2.executeUpdate();
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
    
    /**
     * Update indoor package
     */
    public boolean updateIndoorPackage(PackageModel pkg) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String sql1 = "UPDATE package SET pkgname = ?, pkgprice = ?, pkgduration = ?, eventtype = ?, pkgdesc = ?, pkgstatus = ? WHERE pkgid = ?";
            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setString(1, pkg.getPkgName());
            ps1.setDouble(2, pkg.getPkgPrice());
            ps1.setDouble(3, pkg.getPkgDuration());
            ps1.setString(4, pkg.getEventType());
            ps1.setString(5, pkg.getPkgDesc());
            ps1.setString(6, pkg.getPkgStatus());
            ps1.setInt(7, pkg.getPkgId());
            ps1.executeUpdate();
            
            String sql2 = "UPDATE indoor SET numofpax = ?, backgtype = ? WHERE pkgid = ?";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, pkg.getNumOfPax());
            ps2.setString(2, pkg.getBackgType());
            ps2.setInt(3, pkg.getPkgId());
            ps2.executeUpdate();
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
    
    /**
     * Update outdoor package
     */
    public boolean updateOutdoorPackage(PackageModel pkg) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String sql1 = "UPDATE package SET pkgname = ?, pkgprice = ?, pkgduration = ?, eventtype = ?, pkgdesc = ?, pkgstatus = ? WHERE pkgid = ?";
            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setString(1, pkg.getPkgName());
            ps1.setDouble(2, pkg.getPkgPrice());
            ps1.setDouble(3, pkg.getPkgDuration());
            ps1.setString(4, pkg.getEventType());
            ps1.setString(5, pkg.getPkgDesc());
            ps1.setString(6, pkg.getPkgStatus());
            ps1.setInt(7, pkg.getPkgId());
            ps1.executeUpdate();
            
            String sql2 = "UPDATE outdoor SET distance = ?, distancepriceperkm = ?, location = ? WHERE pkgid = ?";
            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setDouble(1, pkg.getDistance());
            ps2.setDouble(2, pkg.getDistancePricePerKm());
            ps2.setString(3, pkg.getLocation());
            ps2.setInt(4, pkg.getPkgId());
            ps2.executeUpdate();
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
    
    /**
     * Hard delete package from database
     * Deletes from indoor/outdoor table first, then from package table
     */
    public boolean delete(int pkgId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // First get the package to determine if it's indoor or outdoor
            PackageModel pkg = getById(pkgId);
            if (pkg == null) {
                return false;
            }
            
            // Check if there are any bookings using this package
            String sqlCheckBookings = "SELECT COUNT(*) FROM booking WHERE pkgid = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheckBookings);
            psCheck.setInt(1, pkgId);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                // There are bookings using this package - set package reference to NULL in bookings
                String sqlUpdateBookings = "UPDATE booking SET pkgid = NULL WHERE pkgid = ?";
                PreparedStatement psBookings = conn.prepareStatement(sqlUpdateBookings);
                psBookings.setInt(1, pkgId);
                psBookings.executeUpdate();
                psBookings.close();
            }
            psCheck.close();
            
            // Delete from indoor table if exists
            String sqlDeleteIndoor = "DELETE FROM indoor WHERE pkgid = ?";
            PreparedStatement psIndoor = conn.prepareStatement(sqlDeleteIndoor);
            psIndoor.setInt(1, pkgId);
            psIndoor.executeUpdate();
            psIndoor.close();
            
            // Delete from outdoor table if exists
            String sqlDeleteOutdoor = "DELETE FROM outdoor WHERE pkgid = ?";
            PreparedStatement psOutdoor = conn.prepareStatement(sqlDeleteOutdoor);
            psOutdoor.setInt(1, pkgId);
            psOutdoor.executeUpdate();
            psOutdoor.close();
            
            // Now delete from package table
            String sqlDeletePackage = "DELETE FROM package WHERE pkgid = ?";
            PreparedStatement psPackage = conn.prepareStatement(sqlDeletePackage);
            psPackage.setInt(1, pkgId);
            int result = psPackage.executeUpdate();
            psPackage.close();
            
            conn.commit();
            return result > 0;
            
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { 
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
    
    /**
     * Get package counts
     */
    public int getCountByCategory(String category) {
        String sql = "SELECT COUNT(*) FROM package WHERE pkgcateg = ? AND pkgstatus = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private PackageModel mapResultSet(ResultSet rs) throws SQLException {
        PackageModel p = new PackageModel();
        p.setPkgId(rs.getInt("pkgid"));
        p.setPkgName(rs.getString("pkgname"));
        p.setPkgPrice(rs.getDouble("pkgprice"));
        p.setPkgCateg(rs.getString("pkgcateg"));
        p.setPkgDuration(rs.getDouble("pkgduration"));
        p.setEventType(rs.getString("eventtype"));
        p.setPkgDesc(rs.getString("pkgdesc"));
        p.setPkgStatus(rs.getString("pkgstatus"));
        p.setCreatedBy(rs.getInt("createdby"));
        p.setCreatedDate(rs.getDate("createddate"));
        
        // Indoor fields
        p.setNumOfPax(rs.getInt("numofpax"));
        p.setBackgType(rs.getString("backgtype"));
        
        // Outdoor fields
        p.setDistance(rs.getDouble("distance"));
        p.setDistancePricePerKm(rs.getDouble("distancepriceperkm"));
        p.setLocation(rs.getString("location"));
        
        return p;
    }
}

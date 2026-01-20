package dao;

import model.Client;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDAO {
    
    /**
     * Login validation for client
     */
    public Client login(String email, String password) {
        String sql = "SELECT * FROM client WHERE clemail = ? AND clpass = ? AND clstatus = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
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
     * Register new client
     */
    public boolean register(Client client) {
        String sql = "INSERT INTO client (clname, clph, clemail, clpass, claddress, clstatus) VALUES (?, ?, ?, ?, ?, 'active')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, client.getClName());
            ps.setString(2, client.getClPh());
            ps.setString(3, client.getClEmail());
            ps.setString(4, client.getClPass());
            ps.setString(5, client.getClAddress());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error registering client: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get client by ID
     */
    public Client getById(int clId) {
        String sql = "SELECT * FROM client WHERE clid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, clId);
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
     * Get client by email
     */
    public Client getByEmail(String email) {
        String sql = "SELECT * FROM client WHERE clemail = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
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
     * Check if email exists
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM client WHERE clemail = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
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
     * Update client profile
     */
    public boolean update(Client client) {
        String sql = "UPDATE client SET clname = ?, clemail = ?, clph = ?, claddress = ? WHERE clid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, client.getClName());
            ps.setString(2, client.getClEmail());
            ps.setString(3, client.getClPh());
            ps.setString(4, client.getClAddress());
            ps.setInt(5, client.getClId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update password
     */
    public boolean updatePassword(int clId, String newPassword) {
        String sql = "UPDATE client SET clpass = ? WHERE clid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newPassword);
            ps.setInt(2, clId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get all clients
     */
    public List<Client> getAll() {
        List<Client> list = new ArrayList<>();
        String sql = "SELECT * FROM client WHERE clstatus = 'active' ORDER BY clcreated DESC";
        
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
    
    private Client mapResultSet(ResultSet rs) throws SQLException {
        Client c = new Client();
        c.setClId(rs.getInt("clid"));
        c.setClName(rs.getString("clname"));
        c.setClPh(rs.getString("clph"));
        c.setClEmail(rs.getString("clemail"));
        c.setClPass(rs.getString("clpass"));
        c.setClAddress(rs.getString("claddress"));
        c.setClStatus(rs.getString("clstatus"));
        c.setClCreated(rs.getDate("clcreated"));
        return c;
    }
}

package dao;

import model.Photo;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PhotoDAO {
    
    public int create(Photo photo) {
        String sql = "INSERT INTO photo (folderlink, foldername, folderdupload, uploadedby, notesforclient) " +
                     "VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, photo.getFolderLink());
            stmt.setString(2, photo.getFolderName());
            stmt.setInt(3, photo.getUploadedBy());
            stmt.setString(4, photo.getNotesForClient() != null ? photo.getNotesForClient() : "");
            
            int rows = stmt.executeUpdate();
            
            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    public Photo getById(int folderId) {
        String sql = "SELECT p.*, pg.pgname as photographername " +
                     "FROM photo p " +
                     "LEFT JOIN photographer pg ON p.uploadedby = pg.pgid " +
                     "WHERE p.folderid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, folderId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPhoto(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Photo> getAll() {
        List<Photo> photos = new ArrayList<>();
        String sql = "SELECT p.*, pg.pgname as photographername, " +
                     "b.bookingid, c.clname as clientname " +
                     "FROM photo p " +
                     "LEFT JOIN photographer pg ON p.uploadedby = pg.pgid " +
                     "LEFT JOIN booking b ON p.folderid = b.folderid " +
                     "LEFT JOIN client c ON b.clid = c.clid " +
                     "ORDER BY p.folderdupload DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Photo photo = mapResultSetToPhoto(rs);
                photo.setBookingId(rs.getInt("bookingid"));
                photo.setClientName(rs.getString("clientname"));
                photos.add(photo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return photos;
    }
    
    public Photo getByBookingId(int bookingId) {
        String sql = "SELECT p.*, pg.pgname as photographername " +
                     "FROM photo p " +
                     "LEFT JOIN photographer pg ON p.uploadedby = pg.pgid " +
                     "JOIN booking b ON p.folderid = b.folderid " +
                     "WHERE b.bookingid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToPhoto(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateNotes(int folderId, String notes) {
        String sql = "UPDATE photo SET notesforclient = ? WHERE folderid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, notes != null ? notes : "");
            stmt.setInt(2, folderId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateLink(int folderId, String link) {
        String sql = "UPDATE photo SET folderlink = ? WHERE folderid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, link);
            stmt.setInt(2, folderId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean delete(int folderId) {
        // First unlink from any bookings
        String unlinkSql = "UPDATE booking SET folderid = NULL WHERE folderid = ?";
        String deleteSql = "DELETE FROM photo WHERE folderid = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Unlink
            try (PreparedStatement stmt = conn.prepareStatement(unlinkSql)) {
                stmt.setInt(1, folderId);
                stmt.executeUpdate();
            }
            
            // Delete
            try (PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
                stmt.setInt(1, folderId);
                return stmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Photo mapResultSetToPhoto(ResultSet rs) throws SQLException {
        Photo photo = new Photo();
        photo.setFolderId(rs.getInt("folderid"));
        photo.setFolderLink(rs.getString("folderlink"));
        photo.setFolderName(rs.getString("foldername"));
        photo.setFolderUpload(rs.getDate("folderdupload"));
        photo.setUploadedBy(rs.getInt("uploadedby"));
        photo.setNotesForClient(rs.getString("notesforclient"));
        
        try {
            photo.setPhotographerName(rs.getString("photographername"));
        } catch (SQLException e) {
            // Column not in result set
        }
        
        return photo;
    }
}

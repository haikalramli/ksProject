package model;

import java.util.Date;

public class Photo {
    private int folderId;
    private String folderLink;
    private String folderName;
    private Date folderUpload;
    private int uploadedBy;
    private String notesForClient;
    
    // Related data for display
    private String photographerName;
    private int bookingId;
    private String clientName;
    
    // Constructors
    public Photo() {}
    
    public Photo(int folderId, String folderLink, String folderName) {
        this.folderId = folderId;
        this.folderLink = folderLink;
        this.folderName = folderName;
    }
    
    // Getters and Setters
    public int getFolderId() { return folderId; }
    public void setFolderId(int folderId) { this.folderId = folderId; }
    
    public String getFolderLink() { return folderLink; }
    public void setFolderLink(String folderLink) { this.folderLink = folderLink; }
    
    public String getFolderName() { return folderName; }
    public void setFolderName(String folderName) { this.folderName = folderName; }
    
    public Date getFolderUpload() { return folderUpload; }
    public void setFolderUpload(Date folderUpload) { this.folderUpload = folderUpload; }
    
    public int getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(int uploadedBy) { this.uploadedBy = uploadedBy; }
    
    public String getNotesForClient() { return notesForClient; }
    public void setNotesForClient(String notesForClient) { this.notesForClient = notesForClient; }
    
    public String getPhotographerName() { return photographerName; }
    public void setPhotographerName(String photographerName) { this.photographerName = photographerName; }
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
}

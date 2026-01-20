package model;

import java.sql.Timestamp;
import java.util.Date;

public class BookingModel {
    private int bookingId;
    private int clId;
    private Integer pgId;
    private int pkgId;
    private Integer folderId;
    private String bookDate;
    private Timestamp bookStartTime;
    private Timestamp bookEndTime;
    private int bookPax;
    private String bookLocation;
    private double totalPrice;
    private String bookStatus;
    private String bookNotes;
    private Date bookCreated;
    
    // Related data (from joins)
    private String clientName;
    private String clientPhone;
    private String clientEmail;
    private String packageName;
    private String packageCateg;
    private double packagePrice;
    private double packageDuration;
    private String photographerName;
    
    // Constructors
    public BookingModel() {}
    
    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public int getClId() { return clId; }
    public void setClId(int clId) { this.clId = clId; }
    
    public Integer getPgId() { return pgId; }
    public void setPgId(Integer pgId) { this.pgId = pgId; }
    
    public int getPkgId() { return pkgId; }
    public void setPkgId(int pkgId) { this.pkgId = pkgId; }
    
    public Integer getFolderId() { return folderId; }
    public void setFolderId(Integer folderId) { this.folderId = folderId; }
    
    public String getBookDate() { return bookDate; }
    public void setBookDate(String bookDate) { this.bookDate = bookDate; }
    
    public Timestamp getBookStartTime() { return bookStartTime; }
    public void setBookStartTime(Timestamp bookStartTime) { this.bookStartTime = bookStartTime; }
    
    public Timestamp getBookEndTime() { return bookEndTime; }
    public void setBookEndTime(Timestamp bookEndTime) { this.bookEndTime = bookEndTime; }
    
    // For backward compatibility - formatted time string
    public String getBookTime() {
        if (bookStartTime != null && bookEndTime != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm");
            return sdf.format(bookStartTime) + " - " + sdf.format(bookEndTime);
        } else if (bookStartTime != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm");
            return sdf.format(bookStartTime);
        }
        return "";
    }
    
    public int getBookPax() { return bookPax; }
    public void setBookPax(int bookPax) { this.bookPax = bookPax; }
    
    public String getBookLocation() { return bookLocation; }
    public void setBookLocation(String bookLocation) { this.bookLocation = bookLocation; }
    
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    
    public String getBookStatus() { return bookStatus; }
    public void setBookStatus(String bookStatus) { this.bookStatus = bookStatus; }
    
    public String getBookNotes() { return bookNotes; }
    public void setBookNotes(String bookNotes) { this.bookNotes = bookNotes; }
    
    public Date getBookCreated() { return bookCreated; }
    public void setBookCreated(Date bookCreated) { this.bookCreated = bookCreated; }
    
    // Related data
    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }
    
    public String getClientPhone() { return clientPhone; }
    public void setClientPhone(String clientPhone) { this.clientPhone = clientPhone; }
    
    public String getClientEmail() { return clientEmail; }
    public void setClientEmail(String clientEmail) { this.clientEmail = clientEmail; }
    
    public String getPackageName() { return packageName; }
    public void setPackageName(String packageName) { this.packageName = packageName; }
    
    public String getPackageCateg() { return packageCateg; }
    public void setPackageCateg(String packageCateg) { this.packageCateg = packageCateg; }
    
    public double getPackagePrice() { return packagePrice; }
    public void setPackagePrice(double packagePrice) { this.packagePrice = packagePrice; }
    
    public double getPackageDuration() { return packageDuration; }
    public void setPackageDuration(double packageDuration) { this.packageDuration = packageDuration; }
    
    public String getPhotographerName() { return photographerName; }
    public void setPhotographerName(String photographerName) { this.photographerName = photographerName; }
    
    // Helper methods
    public boolean isPending() { return "Pending".equalsIgnoreCase(bookStatus); }
    public boolean isConfirmed() { return "Confirmed".equalsIgnoreCase(bookStatus); }
    public boolean isCompleted() { return "Completed".equalsIgnoreCase(bookStatus); }
    public boolean isCancelled() { return "Cancelled".equalsIgnoreCase(bookStatus); }
    public boolean isIndoor() { return "Indoor".equalsIgnoreCase(packageCateg); }
    public boolean isOutdoor() { return "Outdoor".equalsIgnoreCase(packageCateg); }
}

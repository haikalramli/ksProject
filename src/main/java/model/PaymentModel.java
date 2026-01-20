package model;

import java.util.Date;

public class PaymentModel {
    private int payId;
    private int bookingId;
    private String depoRef;
    private Date depoDate;
    private String depoReceipt;
    private String fullRef;
    private Date fullDate;
    private String fullReceipt;
    private double paidAmount;
    private double remAmount;
    private String receipts;
    private String payStatus;
    private Integer verifiedBy;
    private Date verifiedDate;
    
    // Constructors
    public PaymentModel() {}
    
    // Getters and Setters
    public int getPayId() { return payId; }
    public void setPayId(int payId) { this.payId = payId; }
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public String getDepoRef() { return depoRef; }
    public void setDepoRef(String depoRef) { this.depoRef = depoRef; }
    
    public Date getDepoDate() { return depoDate; }
    public void setDepoDate(Date depoDate) { this.depoDate = depoDate; }
    
    public String getDepoReceipt() { return depoReceipt; }
    public void setDepoReceipt(String depoReceipt) { this.depoReceipt = depoReceipt; }
    
    public String getFullRef() { return fullRef; }
    public void setFullRef(String fullRef) { this.fullRef = fullRef; }
    
    public Date getFullDate() { return fullDate; }
    public void setFullDate(Date fullDate) { this.fullDate = fullDate; }
    
    public String getFullReceipt() { return fullReceipt; }
    public void setFullReceipt(String fullReceipt) { this.fullReceipt = fullReceipt; }
    
    public double getPaidAmount() { return paidAmount; }
    public void setPaidAmount(double paidAmount) { this.paidAmount = paidAmount; }
    
    public double getRemAmount() { return remAmount; }
    public void setRemAmount(double remAmount) { this.remAmount = remAmount; }
    
    public String getReceipts() { return receipts; }
    public void setReceipts(String receipts) { this.receipts = receipts; }
    
    public String getPayStatus() { return payStatus; }
    public void setPayStatus(String payStatus) { this.payStatus = payStatus; }
    
    public Integer getVerifiedBy() { return verifiedBy; }
    public void setVerifiedBy(Integer verifiedBy) { this.verifiedBy = verifiedBy; }
    
    public Date getVerifiedDate() { return verifiedDate; }
    public void setVerifiedDate(Date verifiedDate) { this.verifiedDate = verifiedDate; }
    
    // Helper methods
    public boolean isPending() { return "pending".equalsIgnoreCase(payStatus); }
    public boolean isSubmitted() { return "submitted".equalsIgnoreCase(payStatus); }
    public boolean isPartial() { return "partial".equalsIgnoreCase(payStatus); }
    public boolean isVerified() { return "verified".equalsIgnoreCase(payStatus); }
    public boolean isFullyPaid() { return remAmount <= 0; }
    public boolean hasDeposit() { return depoRef != null && !depoRef.isEmpty(); }
    public boolean hasFullPayment() { return fullRef != null && !fullRef.isEmpty(); }
}

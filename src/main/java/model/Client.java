package model;

import java.util.Date;

public class Client {
    private int clId;
    private String clName;
    private String clPh;
    private String clEmail;
    private String clPass;
    private String clAddress;
    private String clStatus;
    private Date clCreated;
    
    // Constructors
    public Client() {}
    
    // Getters and Setters
    public int getClId() { return clId; }
    public void setClId(int clId) { this.clId = clId; }
    
    public String getClName() { return clName; }
    public void setClName(String clName) { this.clName = clName; }
    
    public String getClPh() { return clPh; }
    public void setClPh(String clPh) { this.clPh = clPh; }
    
    public String getClEmail() { return clEmail; }
    public void setClEmail(String clEmail) { this.clEmail = clEmail; }
    
    public String getClPass() { return clPass; }
    public void setClPass(String clPass) { this.clPass = clPass; }
    
    public String getClAddress() { return clAddress; }
    public void setClAddress(String clAddress) { this.clAddress = clAddress; }
    
    public String getClStatus() { return clStatus; }
    public void setClStatus(String clStatus) { this.clStatus = clStatus; }
    
    public Date getClCreated() { return clCreated; }
    public void setClCreated(Date clCreated) { this.clCreated = clCreated; }
    
    // Helper methods
    public String getFirstName() {
        if (clName != null && !clName.isEmpty()) {
            return clName.split(" ")[0];
        }
        return "";
    }
    
    public boolean isActive() { return "active".equalsIgnoreCase(clStatus); }
}

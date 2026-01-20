package model;

import java.util.Date;

public class PackageModel {
    private int pkgId;
    private String pkgName;
    private double pkgPrice;
    private String pkgCateg;  // Indoor or Outdoor
    private double pkgDuration;
    private String eventType;
    private String pkgDesc;
    private String pkgStatus;
    private int createdBy;
    private Date createdDate;
    
    // Indoor specific
    private int numOfPax;
    private String backgType;
    
    // Outdoor specific
    private double distance;
    private double distancePricePerKm;
    private String location;
    
    // Constructors
    public PackageModel() {}
    
    // Getters and Setters
    public int getPkgId() { return pkgId; }
    public void setPkgId(int pkgId) { this.pkgId = pkgId; }
    
    public String getPkgName() { return pkgName; }
    public void setPkgName(String pkgName) { this.pkgName = pkgName; }
    
    public double getPkgPrice() { return pkgPrice; }
    public void setPkgPrice(double pkgPrice) { this.pkgPrice = pkgPrice; }
    
    public String getPkgCateg() { return pkgCateg; }
    public void setPkgCateg(String pkgCateg) { this.pkgCateg = pkgCateg; }
    
    public double getPkgDuration() { return pkgDuration; }
    public void setPkgDuration(double pkgDuration) { this.pkgDuration = pkgDuration; }
    
    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }
    
    public String getPkgDesc() { return pkgDesc; }
    public void setPkgDesc(String pkgDesc) { this.pkgDesc = pkgDesc; }
    
    public String getPkgStatus() { return pkgStatus; }
    public void setPkgStatus(String pkgStatus) { this.pkgStatus = pkgStatus; }
    
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    
    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }
    
    // Indoor
    public int getNumOfPax() { return numOfPax; }
    public void setNumOfPax(int numOfPax) { this.numOfPax = numOfPax; }
    
    public String getBackgType() { return backgType; }
    public void setBackgType(String backgType) { this.backgType = backgType; }
    
    // Outdoor
    public double getDistance() { return distance; }
    public void setDistance(double distance) { this.distance = distance; }
    
    public double getDistancePricePerKm() { return distancePricePerKm; }
    public void setDistancePricePerKm(double distancePricePerKm) { this.distancePricePerKm = distancePricePerKm; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    // Helper methods
    public boolean isIndoor() { return "Indoor".equalsIgnoreCase(pkgCateg); }
    public boolean isOutdoor() { return "Outdoor".equalsIgnoreCase(pkgCateg); }
    public boolean isActive() { return "active".equalsIgnoreCase(pkgStatus); }
    
    public String getDurationDisplay() {
        if (pkgDuration < 1) {
            return (int)(pkgDuration * 60) + " mins";
        } else if (pkgDuration == 1) {
            return "1 hour";
        } else {
            return pkgDuration + " hours";
        }
    }
}

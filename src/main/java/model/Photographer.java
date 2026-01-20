package model;

import java.util.Date;

public class Photographer {
    private int pgId;
    private Integer pgSnr;
    private String pgName;
    private String pgPh;
    private String pgEmail;
    private String pgPass;
    private String pgRole;
    private String pgStatus;
    private Date pgCreated;
    
    // Constructors
    public Photographer() {}
    
    // Getters and Setters
    public int getPgId() { return pgId; }
    public void setPgId(int pgId) { this.pgId = pgId; }
    
    public Integer getPgSnr() { return pgSnr; }
    public void setPgSnr(Integer pgSnr) { this.pgSnr = pgSnr; }
    
    public String getPgName() { return pgName; }
    public void setPgName(String pgName) { this.pgName = pgName; }
    
    public String getPgPh() { return pgPh; }
    public void setPgPh(String pgPh) { this.pgPh = pgPh; }
    
    public String getPgEmail() { return pgEmail; }
    public void setPgEmail(String pgEmail) { this.pgEmail = pgEmail; }
    
    public String getPgPass() { return pgPass; }
    public void setPgPass(String pgPass) { this.pgPass = pgPass; }
    
    public String getPgRole() { return pgRole; }
    public void setPgRole(String pgRole) { this.pgRole = pgRole; }
    
    public String getPgStatus() { return pgStatus; }
    public void setPgStatus(String pgStatus) { this.pgStatus = pgStatus; }
    
    public Date getPgCreated() { return pgCreated; }
    public void setPgCreated(Date pgCreated) { this.pgCreated = pgCreated; }
    
    // Helper methods
    public boolean isSenior() { return "senior".equalsIgnoreCase(pgRole); }
    public boolean isActive() { return "active".equalsIgnoreCase(pgStatus); }
    
    public String getFirstName() {
        if (pgName != null && !pgName.isEmpty()) {
            return pgName.split(" ")[0];
        }
        return "";
    }
}

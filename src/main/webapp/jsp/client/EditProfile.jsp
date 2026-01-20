<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    if (session.getAttribute("clientID") == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }
%>

<jsp:include page="Header.jsp" />

<section class="section light-background" style="padding-top: 100px; min-height: 80vh;">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <span class="description-title">My Account</span>
            <h2>Edit Profile</h2>
        </div>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Edit Profile Details -->
                <div class="card shadow-sm mb-4" style="border-radius: 15px;">
                    <div class="card-header" style="background: linear-gradient(135deg, #2f5d50, #1a3a32); border-radius: 15px 15px 0 0;">
                        <h5 class="mb-0 text-white"><i class="bi bi-person-gear"></i> Edit Profile Details</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/ClientProfileController" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Full Name</label>
                                <input type="text" name="name" class="form-control form-control-lg" 
                                       value="${client.clName}" required style="border-radius: 10px;">
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Email Address</label>
                                <input type="email" name="email" class="form-control form-control-lg" 
                                       value="${client.clEmail}" required style="border-radius: 10px;">
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Phone Number</label>
                                <input type="tel" name="phone" class="form-control form-control-lg" 
                                       value="${client.clPh}" style="border-radius: 10px;">
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Address</label>
                                <textarea name="address" class="form-control" rows="3" 
                                          style="border-radius: 10px;">${client.clAddress}</textarea>
                            </div>
                            
                            <div class="d-flex gap-3">
                                <button type="submit" class="btn btn-primary btn-lg px-4" style="border-radius: 10px;">
                                    <i class="bi bi-check-lg"></i> Update Profile
                                </button>
                                <a href="${pageContext.request.contextPath}/jsp/client/ViewAccount.jsp" class="btn btn-secondary btn-lg px-4" style="border-radius: 10px;">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Change Password -->
                <div class="card shadow-sm" style="border-radius: 15px;">
                    <div class="card-header" style="background: linear-gradient(135deg, #dc3545, #c82333); border-radius: 15px 15px 0 0;">
                        <h5 class="mb-0 text-white"><i class="bi bi-key"></i> Change Password</h5>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/ClientProfileController" method="post" id="passwordForm">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Current Password *</label>
                                <input type="password" name="currentPassword" id="currentPassword" 
                                       class="form-control form-control-lg" required style="border-radius: 10px;">
                            </div>
                            
                            <div class="row mb-4">
                                <div class="col-md-6 mb-3 mb-md-0">
                                    <label class="form-label fw-bold">New Password *</label>
                                    <input type="password" name="newPassword" id="newPassword" 
                                           class="form-control form-control-lg" minlength="6" required style="border-radius: 10px;">
                                    <small class="text-muted">Minimum 6 characters</small>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Confirm New Password *</label>
                                    <input type="password" name="confirmPassword" id="confirmPassword" 
                                           class="form-control form-control-lg" minlength="6" required style="border-radius: 10px;">
                                </div>
                            </div>
                            
                            <button type="button" class="btn btn-warning btn-lg px-4" style="border-radius: 10px;" onclick="confirmPasswordChange()">
                                <i class="bi bi-key"></i> Change Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Password Change Confirmation Modal -->
<div class="modal fade" id="confirmPasswordModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header bg-warning">
                <h5 class="modal-title"><i class="bi bi-exclamation-triangle"></i> Confirm Password Change</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center py-4">
                <i class="bi bi-shield-lock text-warning" style="font-size: 4rem;"></i>
                <h5 class="mt-3">Are you sure you want to change your password?</h5>
                <p class="text-muted">You will need to use your new password to login next time.</p>
            </div>
            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-secondary btn-lg px-4" data-bs-dismiss="modal">
                    <i class="bi bi-x-lg"></i> Cancel
                </button>
                <button type="button" class="btn btn-warning btn-lg px-4" onclick="submitPasswordForm()">
                    <i class="bi bi-check-lg"></i> Yes, Change Password
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function confirmPasswordChange() {
    const newPass = document.getElementById('newPassword').value;
    const confirmPass = document.getElementById('confirmPassword').value;
    const currentPass = document.getElementById('currentPassword').value;
    
    if (!currentPass || !newPass || !confirmPass) {
        alert('Please fill in all password fields.');
        return;
    }
    
    if (newPass.length < 6) {
        alert('New password must be at least 6 characters.');
        return;
    }
    
    if (newPass !== confirmPass) {
        alert('New passwords do not match!');
        return;
    }
    
    new bootstrap.Modal(document.getElementById('confirmPasswordModal')).show();
}

function submitPasswordForm() {
    document.getElementById('passwordForm').submit();
}
</script>

<jsp:include page="Footer.jsp" />

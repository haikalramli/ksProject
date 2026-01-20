<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Settings - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/photographer-style.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-header">
                <h1 class="page-title">Account Settings</h1>
            </header>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show">${error}</div>
            </c:if>
            
            <div class="row">
                <!-- Profile Card -->
                <div class="col-lg-4 mb-4">
                    <div class="card text-center">
                        <div class="card-body py-5">
                            <div class="profile-avatar mb-4" style="width: 120px; height: 120px; background: linear-gradient(135deg, #6f42c1, #d63384); border-radius: 50%; margin: 0 auto; display: flex; align-items: center; justify-content: center;">
                                <i class="bi bi-person-fill text-white" style="font-size: 3rem;"></i>
                            </div>
                            <h4 class="mt-3">${photographer.pgName}</h4>
                            <p class="text-muted">${photographer.pgEmail}</p>
                            <span class="badge ${photographer.pgRole == 'senior' ? 'bg-danger' : (photographer.pgRole == 'junior' ? 'bg-primary' : 'bg-success')} fs-6">
                                ${photographer.pgRole == 'senior' ? 'Senior (Admin)' : (photographer.pgRole == 'junior' ? 'Junior' : 'Intern')}
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- Edit Profile -->
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h3><i class="bi bi-person-gear"></i> Edit Profile</h3>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/settings" method="post">
                                <input type="hidden" name="action" value="updateProfile">
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Full Name *</label>
                                        <input type="text" name="name" class="form-control" value="${photographer.pgName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Email *</label>
                                        <input type="email" name="email" class="form-control" value="${photographer.pgEmail}" required>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Phone Number</label>
                                        <input type="tel" name="phone" class="form-control" value="${photographer.pgPh}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Role</label>
                                        <input type="text" class="form-control" value="${photographer.pgRole == 'senior' ? 'Senior (Admin)' : (photographer.pgRole == 'junior' ? 'Junior' : 'Intern')}" disabled>
                                        <small class="text-muted">Role cannot be changed here</small>
                                    </div>
                                </div>
                                
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-lg"></i> Save Changes
                                </button>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Change Password -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="bi bi-key"></i> Change Password</h3>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/settings" method="post" id="passwordForm">
                                <input type="hidden" name="action" value="changePassword">
                                
                                <div class="mb-3">
                                    <label class="form-label">Current Password *</label>
                                    <input type="password" name="currentPassword" id="currentPassword" class="form-control" required>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">New Password *</label>
                                        <input type="password" name="newPassword" id="newPassword" class="form-control" minlength="6" required>
                                        <small class="text-muted">Minimum 6 characters</small>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Confirm New Password *</label>
                                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" minlength="6" required>
                                    </div>
                                </div>
                                
                                <button type="button" class="btn btn-warning" onclick="confirmPasswordChange()">
                                    <i class="bi bi-key"></i> Change Password
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Password Change Confirmation Modal -->
    <div class="modal fade" id="confirmPasswordModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px;">
                <div class="modal-header" style="background: linear-gradient(135deg, #f59e0b, #d97706); color: #fff; border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title"><i class="bi bi-shield-exclamation"></i> Confirm Password Change</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <i class="bi bi-key-fill text-warning" style="font-size: 4rem;"></i>
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
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmPasswordChange() {
            var currentPass = document.getElementById('currentPassword').value;
            var newPass = document.getElementById('newPassword').value;
            var confirmPass = document.getElementById('confirmPassword').value;
            
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
</body>
</html>

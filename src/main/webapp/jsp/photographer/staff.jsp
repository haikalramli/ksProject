<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/photographer-style.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <c:set var="currentPage" value="staff" scope="request"/>
        <jsp:include page="sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-header">
                <h1 class="page-title"><i class="bi bi-people"></i> Staff Management</h1>
                <div class="header-actions">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                        <i class="bi bi-person-plus"></i> Add New Staff
                    </button>
                </div>
            </header>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show">${error}</div>
            </c:if>
            
            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #ff6b6b, #ee5a5a);"><i class="bi bi-shield-check"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Senior (Admin)</span>
                        <span class="stat-value">${seniorCount}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #0d6efd, #0a58ca);"><i class="bi bi-camera-reels"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Junior</span>
                        <span class="stat-value">${juniorCount}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #ffd93d, #ffcd00);"><i class="bi bi-person-badge"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Intern</span>
                        <span class="stat-value">${internCount}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #6f42c1, #5a32a3);"><i class="bi bi-people-fill"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Total Staff</span>
                        <span class="stat-value">${totalCount}</span>
                    </div>
                </div>
            </div>
            
            <!-- Staff List -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="bi bi-person-lines-fill"></i> Photographer List</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pg" items="${photographers}">
                                <tr>
                                    <td>#${pg.pgId}</td>
                                    <td><strong>${pg.pgName}</strong></td>
                                    <td>${pg.pgEmail}</td>
                                    <td>${pg.pgPh != null ? pg.pgPh : '-'}</td>
                                    <td>
                                        <span class="badge ${pg.pgRole == 'senior' ? 'bg-danger' : (pg.pgRole == 'junior' ? 'bg-primary' : 'bg-warning text-dark')}">
                                            ${pg.pgRole == 'senior' ? 'Senior (Admin)' : (pg.pgRole == 'junior' ? 'Junior' : 'Intern')}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${pg.pgStatus == 'active' ? 'bg-success' : 'bg-secondary'}">
                                            ${pg.pgStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${pg.pgId != sessionScope.photographerId}">
                                            <button class="btn btn-sm btn-outline-primary" onclick="editStaff(${pg.pgId}, '${pg.pgName}', '${pg.pgEmail}', '${pg.pgPh}', '${pg.pgRole}', '${pg.pgStatus}')" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" onclick="deleteStaff(${pg.pgId})" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </c:if>
                                        <c:if test="${pg.pgId == sessionScope.photographerId}">
                                            <span class="text-muted small">(You)</span>
                                        </c:if>
                                    </td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Add Staff Modal -->
    <div class="modal fade" id="addStaffModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-person-plus"></i> Add New Photographer</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/staff" method="post">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Role *</label>
                            <select name="role" class="form-select" required>
                                <option value="junior" selected>Junior</option>
                                <option value="intern">Intern</option>
                                <option value="senior">Senior (Admin)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Full Name *</label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email *</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="tel" name="phone" class="form-control">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Password *</label>
                                <input type="password" name="password" class="form-control" minlength="6" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Confirm Password *</label>
                                <input type="password" name="confirmPassword" class="form-control" minlength="6" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary"><i class="bi bi-plus-lg"></i> Add Staff</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Staff Modal -->
    <div class="modal fade" id="editStaffModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title"><i class="bi bi-pencil"></i> Edit Photographer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/staff" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="pgId" id="editPgId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Role *</label>
                            <select name="role" id="editRole" class="form-select" required>
                                <option value="junior">Junior</option>
                                <option value="intern">Intern</option>
                                <option value="senior">Senior (Admin)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Full Name *</label>
                            <input type="text" name="name" id="editName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email *</label>
                            <input type="email" name="email" id="editEmail" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="tel" name="phone" id="editPhone" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select name="status" id="editStatus" class="form-select">
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning"><i class="bi bi-check-lg"></i> Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        function editStaff(id, name, email, phone, role, status) {
            document.getElementById('editPgId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone || '';
            document.getElementById('editRole').value = role;
            document.getElementById('editStatus').value = status;
            new bootstrap.Modal(document.getElementById('editStaffModal')).show();
        }
        
        function deleteStaff(id) {
            if (confirm('Delete this photographer?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/staff';
                form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="pgId" value="' + id + '">';
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Photo - KS.Studio</title>
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
                <h1 class="page-title">Upload Photo</h1>
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
                    <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);"><i class="bi bi-hourglass-split"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Pending Upload</span>
                        <span class="stat-value">${pendingUpload.size()}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #22c55e, #16a34a);"><i class="bi bi-check-circle"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Completed Upload</span>
                        <span class="stat-value">${completedUpload.size()}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);"><i class="bi bi-folder"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Total Uploads</span>
                        <span class="stat-value">${uploadHistory.size()}</span>
                    </div>
                </div>
            </div>
            
            <!-- Info Card -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-info-circle-fill text-primary me-3" style="font-size: 2rem;"></i>
                        <div>
                            <h5 class="mb-1">How Photo Upload Works</h5>
                            <p class="text-muted mb-0">
                                Upload Google Drive or cloud links for clients whose <strong>payment has been fully verified</strong>.
                                Only clients with verified payments will appear in the Pending Upload list.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- PENDING UPLOAD SECTION -->
            <div class="card mb-4">
                <div class="card-header" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                    <h3 class="text-white mb-0"><i class="bi bi-hourglass-split"></i> Pending Uploaded Photo</h3>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3">Clients with verified payment waiting for photo upload:</p>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Client Name</th>
                                    <th>Contact</th>
                                    <th>Package</th>
                                    <th>Booking Date</th>
                                    <th>Paid Amount</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${pendingUpload}">
                                <tr>
                                    <td><strong>B${item.bookingId}</strong></td>
                                    <td>${item.clientName}</td>
                                    <td>
                                        <small>${item.clientEmail}</small><br>
                                        <small class="text-muted">${item.clientPhone}</small>
                                    </td>
                                    <td>
                                        ${item.packageName}<br>
                                        <span class="badge ${item.packageCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${item.packageCateg}</span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${item.bookDate}" pattern="dd MMM yyyy"/><br>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${item.bookStartTime}" pattern="hh:mm a"/>
                                        </small>
                                    </td>
                                    <td class="text-success fw-bold">
                                        RM <fmt:formatNumber value="${item.paidAmount}" pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" 
                                                onclick="openUploadModal(${item.bookingId}, '${item.clientName}', '${item.packageName}')">
                                            <i class="bi bi-cloud-upload"></i> Upload Link
                                        </button>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty pendingUpload}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        <i class="bi bi-check-circle display-4 text-success"></i>
                                        <p class="mt-2">All verified bookings have photos uploaded!</p>
                                    </td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- COMPLETED UPLOAD SECTION -->
            <div class="card mb-4">
                <div class="card-header" style="background: linear-gradient(135deg, #22c55e, #16a34a);">
                    <h3 class="text-white mb-0"><i class="bi bi-check-circle"></i> Completed Uploaded Photo</h3>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3">Clients with verified payment and photos already uploaded:</p>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Client Name</th>
                                    <th>Package</th>
                                    <th>Folder Name</th>
                                    <th>Photo Link</th>
                                    <th>Upload Date</th>
                                    <th>Uploaded By</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${completedUpload}">
                                <tr>
                                    <td><strong>B${item.bookingId}</strong></td>
                                    <td>
                                        ${item.clientName}<br>
                                        <small class="text-muted">${item.clientEmail}</small>
                                    </td>
                                    <td>
                                        ${item.packageName}<br>
                                        <span class="badge ${item.packageCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${item.packageCateg}</span>
                                    </td>
                                    <td>${item.folderName}</td>
                                    <td>
                                        <a href="${item.folderLink}" target="_blank" class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-folder2-open"></i> View Photos
                                        </a>
                                    </td>
                                    <td><fmt:formatDate value="${item.uploadDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${item.uploadedBy}</td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty completedUpload}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        <i class="bi bi-folder-x display-4"></i>
                                        <p class="mt-2">No completed uploads yet.</p>
                                    </td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- UPLOAD HISTORY -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="bi bi-clock-history"></i> Upload History</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Folder ID</th>
                                    <th>Booking ID</th>
                                    <th>Client Name</th>
                                    <th>Folder Name</th>
                                    <th>Photo Link</th>
                                    <th>Upload Date</th>
                                    <th>Uploaded By</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="photo" items="${uploadHistory}">
                                <tr>
                                    <td><strong>F${String.format("%04d", photo.folderId)}</strong></td>
                                    <td>
                                        <c:if test="${photo.bookingId > 0}">
                                            <span class="badge bg-primary">B${photo.bookingId}</span>
                                        </c:if>
                                        <c:if test="${photo.bookingId <= 0}">
                                            <span class="text-muted">-</span>
                                        </c:if>
                                    </td>
                                    <td>${not empty photo.clientName ? photo.clientName : '-'}</td>
                                    <td>${photo.folderName}</td>
                                    <td>
                                        <a href="${photo.folderLink}" target="_blank" class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-folder2-open"></i> View
                                        </a>
                                    </td>
                                    <td><fmt:formatDate value="${photo.folderUpload}" pattern="dd/MM/yyyy"/></td>
                                    <td>${photo.photographerName}</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-warning" onclick="editPhoto(${photo.folderId}, '${photo.folderName}', '${photo.folderLink}', '${photo.notesForClient}')" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" onclick="deletePhoto(${photo.folderId})" title="Delete">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty uploadHistory}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">
                                        <i class="bi bi-cloud-upload display-4"></i>
                                        <p class="mt-2">No upload history yet.</p>
                                    </td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Upload Modal -->
    <div class="modal fade" id="uploadModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-cloud-upload"></i> Upload Photo Link</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/upload" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="upload">
                        <input type="hidden" name="bookingId" id="uploadBookingId">
                        
                        <div class="alert alert-info">
                            <strong>Client:</strong> <span id="uploadClientName"></span><br>
                            <strong>Package:</strong> <span id="uploadPackageName"></span>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Folder Name *</label>
                            <input type="text" name="folderName" id="uploadFolderName" class="form-control" required 
                                   placeholder="e.g., Ahmad_Family_Jan2026">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Google Drive / Cloud Link *</label>
                            <input type="url" name="folderLink" class="form-control" required 
                                   placeholder="https://drive.google.com/drive/folders/...">
                            <small class="text-muted">Enter the shareable link to the photo folder</small>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Notes for Client (Optional)</label>
                            <textarea name="notesForClient" class="form-control" rows="3" 
                                      placeholder="e.g., Photos available for 30 days. Please download and save."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-cloud-upload"></i> Upload Link
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-pencil"></i> Edit Photo Link</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/upload" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="updateNotes">
                        <input type="hidden" name="folderId" id="editFolderId">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Folder Name</label>
                            <input type="text" id="editFolderName" class="form-control" disabled>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Google Drive / Cloud Link</label>
                            <input type="url" id="editFolderLink" class="form-control" disabled>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Notes for Client</label>
                            <textarea name="notesForClient" id="editNotesText" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px;">
                <div class="modal-header" style="background: linear-gradient(135deg, #ef4444, #dc2626); color: #fff; border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title"><i class="bi bi-exclamation-triangle"></i> Confirm Delete</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <i class="bi bi-trash text-danger" style="font-size: 4rem;"></i>
                    <h5 class="mt-3">Are you sure you want to delete this photo folder?</h5>
                    <p class="text-muted">This action cannot be undone. Client will lose access to photos.</p>
                </div>
                <form action="${pageContext.request.contextPath}/upload" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="folderId" id="deleteFolderId">
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary btn-lg px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger btn-lg px-4">
                            <i class="bi bi-trash"></i> Yes, Delete
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        function openUploadModal(bookingId, clientName, packageName) {
            document.getElementById('uploadBookingId').value = bookingId;
            document.getElementById('uploadClientName').textContent = clientName;
            document.getElementById('uploadPackageName').textContent = packageName;
            document.getElementById('uploadFolderName').value = clientName.replace(/\s+/g, '_') + '_' + new Date().toISOString().slice(0,7).replace('-', '');
            new bootstrap.Modal(document.getElementById('uploadModal')).show();
        }
        
        function editPhoto(folderId, folderName, folderLink, notes) {
            document.getElementById('editFolderId').value = folderId;
            document.getElementById('editFolderName').value = folderName;
            document.getElementById('editFolderLink').value = folderLink;
            document.getElementById('editNotesText').value = notes || '';
            new bootstrap.Modal(document.getElementById('editModal')).show();
        }
        
        function deletePhoto(folderId) {
            document.getElementById('deleteFolderId').value = folderId;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }
    </script>
</body>
</html>

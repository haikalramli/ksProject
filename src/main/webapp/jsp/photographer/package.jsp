<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Package Management - KS.Studio</title>
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
                <h1 class="page-title">Package Management</h1>
                <div class="header-actions">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createIndoorModal">
                        <i class="bi bi-plus-circle"></i> Add Indoor Package
                    </button>
                    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createOutdoorModal">
                        <i class="bi bi-plus-circle"></i> Add Outdoor Package
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
                    <div class="stat-icon indoor"><i class="bi bi-house"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Indoor Packages</span>
                        <span class="stat-value">${indoorCount}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon outdoor"><i class="bi bi-tree"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Outdoor Packages</span>
                        <span class="stat-value">${outdoorCount}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon total"><i class="bi bi-box-seam"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Total Packages</span>
                        <span class="stat-value">${indoorCount + outdoorCount}</span>
                    </div>
                </div>
            </div>
            
            <!-- Filter -->
            <div class="card mb-4">
                <div class="card-body">
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/package" class="btn ${empty selectedCategory ? 'btn-primary' : 'btn-outline-secondary'}">All</a>
                        <a href="${pageContext.request.contextPath}/package?category=Indoor" class="btn ${selectedCategory == 'Indoor' ? 'btn-primary' : 'btn-outline-secondary'}">Indoor</a>
                        <a href="${pageContext.request.contextPath}/package?category=Outdoor" class="btn ${selectedCategory == 'Outdoor' ? 'btn-primary' : 'btn-outline-secondary'}">Outdoor</a>
                    </div>
                </div>
            </div>
            
            <!-- Package List -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="bi bi-box-seam"></i> Package List</h3>
                    <p class="text-muted">Packages created here will be visible to clients for booking</p>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Duration</th>
                                    <th>Event Type</th>
                                    <th>Details</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pkg" items="${packages}">
                                <tr>
                                    <td>#${pkg.pkgId}</td>
                                    <td><strong>${pkg.pkgName}</strong></td>
                                    <td>
                                        <span class="badge ${pkg.pkgCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${pkg.pkgCateg}</span>
                                    </td>
                                    <td>RM <fmt:formatNumber value="${pkg.pkgPrice}" pattern="#,##0.00"/></td>
                                    <td>${pkg.pkgDuration} hrs</td>
                                    <td>${pkg.eventType}</td>
                                    <td>
                                        <c:if test="${pkg.pkgCateg == 'Indoor'}">
                                            <small>Pax: ${pkg.numOfPax}<br>Background: ${pkg.backgType}</small>
                                        </c:if>
                                        <c:if test="${pkg.pkgCateg == 'Outdoor'}">
                                            <small>Distance: ${pkg.distance} km<br>RM ${pkg.distancePricePerKm}/km</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${pkg.pkgStatus}">${pkg.pkgStatus}</span>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-primary" onclick="editPackage(${pkg.pkgId})" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-outline-danger" onclick="deletePackage(${pkg.pkgId})" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty packages}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">
                                        <i class="bi bi-inbox display-4"></i>
                                        <p class="mt-2">No packages yet. Create your first package!</p>
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
    
    <!-- Create Indoor Package Modal -->
    <div class="modal fade" id="createIndoorModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-house"></i> Create Indoor Package</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/package" method="post">
                    <input type="hidden" name="action" value="createIndoor">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Package Name *</label>
                                <input type="text" name="pkgName" class="form-control" required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Price (RM) *</label>
                                <input type="number" name="pkgPrice" class="form-control" step="0.01" min="0" required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Duration (hours) *</label>
                                <input type="number" name="pkgDuration" class="form-control" step="0.5" min="0.5" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Event Type *</label>
                                <select name="eventType" class="form-select" required>
                                    <option value="Portrait">Portrait</option>
                                    <option value="Birthday">Birthday</option>
                                    <option value="Corporate">Corporate</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Max Pax *</label>
                                <input type="number" name="numOfPax" class="form-control" min="1" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Background Type *</label>
                                <select name="backgType" class="form-select" required>
                                    <option value="White">White</option>
                                    <option value="Black">Black</option>
                                    <option value="Green Screen">Green Screen</option>
                                    <option value="Custom">Custom</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="pkgDesc" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Package</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Create Outdoor Package Modal -->
    <div class="modal fade" id="createOutdoorModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-tree"></i> Create Outdoor Package</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/package" method="post">
                    <input type="hidden" name="action" value="createOutdoor">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Package Name *</label>
                                <input type="text" name="pkgName" class="form-control" required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Base Price (RM) *</label>
                                <input type="number" name="pkgPrice" class="form-control" step="0.01" min="0" required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Duration (hours) *</label>
                                <input type="number" name="pkgDuration" class="form-control" step="0.5" min="0.5" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Event Type *</label>
                                <select name="eventType" class="form-select" required>
                                    <option value="Wedding">Wedding</option>
                                    <option value="Corporate">Corporate</option>
                                    <option value="Birthday">Birthday</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Max Distance (km) *</label>
                                <input type="number" name="distance" class="form-control" step="0.1" min="0" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Price per KM (RM) *</label>
                                <input type="number" name="pricePerKm" class="form-control" step="0.1" min="0" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Default Location</label>
                            <input type="text" name="location" class="form-control" placeholder="e.g., Kuala Lumpur">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="pkgDesc" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Create Package</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        function deletePackage(id) {
            if (confirm('Are you sure you want to delete this package?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/package';
                form.innerHTML = '<input type="hidden" name="action" value="delete"><input type="hidden" name="pkgId" value="' + id + '">';
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function editPackage(id) {
            // Fetch package data and show edit modal
            fetch('${pageContext.request.contextPath}/package?action=get&pkgId=' + id)
                .then(response => response.json())
                .then(pkg => {
                    document.getElementById('editPkgId').value = pkg.pkgId;
                    document.getElementById('editPkgName').value = pkg.pkgName;
                    document.getElementById('editPkgPrice').value = pkg.pkgPrice;
                    document.getElementById('editPkgDuration').value = pkg.pkgDuration;
                    document.getElementById('editPkgDesc').value = pkg.pkgDesc || '';
                    document.getElementById('editPkgStatus').value = pkg.pkgStatus;
                    document.getElementById('editEventType').value = pkg.eventType || '';
                    document.getElementById('editPkgCateg').value = pkg.pkgCateg;
                    
                    // Show/hide category-specific fields
                    if (pkg.pkgCateg === 'Indoor') {
                        document.getElementById('editIndoorFields').style.display = 'block';
                        document.getElementById('editOutdoorFields').style.display = 'none';
                        document.getElementById('editNumOfPax').value = pkg.numOfPax || 1;
                        document.getElementById('editBackgType').value = pkg.backgType || '';
                    } else {
                        document.getElementById('editIndoorFields').style.display = 'none';
                        document.getElementById('editOutdoorFields').style.display = 'block';
                        document.getElementById('editLocation').value = pkg.location || '';
                        document.getElementById('editDistance').value = pkg.distance || 0;
                        document.getElementById('editPricePerKm').value = pkg.distancePricePerKm || 0;
                    }
                    
                    new bootstrap.Modal(document.getElementById('editModal')).show();
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to load package data. Please try again.');
                });
        }
    </script>
    
    <!-- Edit Package Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #667eea, #764ba2); color: white;">
                    <h5 class="modal-title"><i class="bi bi-pencil"></i> Edit Package</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/package" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="pkgId" id="editPkgId">
                    <input type="hidden" name="pkgCateg" id="editPkgCateg">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Package Name *</label>
                                <input type="text" name="pkgName" id="editPkgName" class="form-control" required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Price (RM) *</label>
                                <input type="number" name="pkgPrice" id="editPkgPrice" class="form-control" step="0.01" min="0" required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Duration (hours) *</label>
                                <input type="number" name="pkgDuration" id="editPkgDuration" class="form-control" step="0.5" min="0.5" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Event Type</label>
                                <select name="eventType" id="editEventType" class="form-select">
                                    <option value="">Select...</option>
                                    <option value="Portrait">Portrait</option>
                                    <option value="Wedding">Wedding</option>
                                    <option value="Pre-Wedding">Pre-Wedding</option>
                                    <option value="Birthday">Birthday</option>
                                    <option value="Corporate">Corporate</option>
                                    <option value="Convocation">Convocation</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Status *</label>
                                <select name="pkgStatus" id="editPkgStatus" class="form-select" required>
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Indoor-specific fields -->
                        <div id="editIndoorFields">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Max Pax</label>
                                    <input type="number" name="numOfPax" id="editNumOfPax" class="form-control" min="1" value="1">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Background Type</label>
                                    <select name="backgType" id="editBackgType" class="form-select">
                                        <option value="">Select...</option>
                                        <option value="Plain White">Plain White</option>
                                        <option value="Colored">Colored</option>
                                        <option value="Studio Set">Studio Set</option>
                                        <option value="Green Screen">Green Screen</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Outdoor-specific fields -->
                        <div id="editOutdoorFields" style="display: none;">
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Location</label>
                                    <input type="text" name="location" id="editLocation" class="form-control">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Max Distance (km)</label>
                                    <input type="number" name="distance" id="editDistance" class="form-control" step="0.1" min="0">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Price per KM (RM)</label>
                                    <input type="number" name="pricePerKm" id="editPricePerKm" class="form-control" step="0.1" min="0">
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="pkgDesc" id="editPkgDesc" class="form-control" rows="3"></textarea>
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
</body>
</html>

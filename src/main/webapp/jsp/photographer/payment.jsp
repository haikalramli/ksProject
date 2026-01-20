<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Payment - KS.Studio</title>
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
                <h1 class="page-title">Verify Payment</h1>
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
                    <div class="stat-icon" style="background: linear-gradient(135deg, #ffc107, #ff9800);"><i class="bi bi-hourglass-split"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Pending Confirm</span>
                        <span class="stat-value">${pendingPayments.size()}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #28a745, #20c997);"><i class="bi bi-check-circle"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Completed</span>
                        <span class="stat-value">${completedPayments.size()}</span>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #6366f1, #8b5cf6);"><i class="bi bi-clock-history"></i></div>
                    <div class="stat-info">
                        <span class="stat-label">Total History</span>
                        <span class="stat-value">${confirmHistory.size()}</span>
                    </div>
                </div>
            </div>
            
            <!-- SECTION 1: PENDING CONFIRM PAYMENT -->
            <div class="card mb-4">
                <div class="card-header" style="background: linear-gradient(135deg, #ffc107, #ff9800);">
                    <h3 class="text-white mb-0"><i class="bi bi-hourglass-split"></i> Pending Confirm Payment</h3>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3">Payments submitted by clients awaiting verification:</p>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Booking</th>
                                    <th>Client</th>
                                    <th>Package</th>
                                    <th>Total</th>
                                    <th>Payment Type</th>
                                    <th>Reference</th>
                                    <th>Receipt</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${pendingPayments}">
                                <tr>
                                    <td>
                                        <strong>#${item.bookingId}</strong><br>
                                        <small><fmt:formatDate value="${item.bookDate}" pattern="dd MMM yyyy"/></small>
                                    </td>
                                    <td>
                                        <strong>${item.clientName}</strong><br>
                                        <small>${item.clientEmail}</small>
                                    </td>
                                    <td>
                                        ${item.packageName}<br>
                                        <span class="badge ${item.packageCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${item.packageCateg}</span>
                                    </td>
                                    <td>RM <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></td>
                                    <td>
                                        <c:if test="${not empty item.depoRef && (item.payStatus == 'submitted' || item.payStatus == 'pending')}">
                                            <span class="badge bg-warning text-dark">Deposit</span>
                                        </c:if>
                                        <c:if test="${not empty item.fullRef && item.payStatus == 'submitted'}">
                                            <span class="badge bg-success">Full Payment</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty item.depoRef}">
                                            <small><strong>Depo:</strong> ${item.depoRef}</small><br>
                                        </c:if>
                                        <c:if test="${not empty item.fullRef}">
                                            <small><strong>Full:</strong> ${item.fullRef}</small>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty item.depoReceipt}">
                                            <button class="btn btn-sm btn-outline-info mb-1" onclick="viewReceipt('${item.depoReceipt}', 'Deposit Receipt')">
                                                <i class="bi bi-receipt"></i> Deposit
                                            </button>
                                        </c:if>
                                        <c:if test="${not empty item.fullReceipt}">
                                            <button class="btn btn-sm btn-outline-info" onclick="viewReceipt('${item.fullReceipt}', 'Full Payment Receipt')">
                                                <i class="bi bi-receipt"></i> Full
                                            </button>
                                        </c:if>
                                        <c:if test="${empty item.depoReceipt && empty item.fullReceipt}">
                                            <span class="text-muted">-</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-success" 
                                                onclick="showVerifyModal(${item.payId}, ${item.bookingId}, ${item.totalPrice}, ${item.remAmount}, '${item.depoRef}', '${item.fullRef}')">
                                            <i class="bi bi-check-lg"></i> Verify
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" onclick="showRejectModal(${item.payId})">
                                            <i class="bi bi-x-lg"></i>
                                        </button>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty pendingPayments}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">
                                        <i class="bi bi-check-circle display-4 text-success"></i>
                                        <p class="mt-2">No pending payments to verify!</p>
                                    </td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- SECTION 2: COMPLETE CONFIRM PAYMENT -->
            <div class="card mb-4">
                <div class="card-header" style="background: linear-gradient(135deg, #28a745, #20c997);">
                    <h3 class="text-white mb-0"><i class="bi bi-check-circle"></i> Complete Confirm Payment</h3>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3">Payments that have been fully verified:</p>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Booking</th>
                                    <th>Client</th>
                                    <th>Package</th>
                                    <th>Total</th>
                                    <th>Paid</th>
                                    <th>Deposit Ref</th>
                                    <th>Full Ref</th>
                                    <th>Verified Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${completedPayments}">
                                <tr>
                                    <td>
                                        <strong>#${item.bookingId}</strong><br>
                                        <small><fmt:formatDate value="${item.bookDate}" pattern="dd MMM yyyy"/></small>
                                    </td>
                                    <td>
                                        <strong>${item.clientName}</strong><br>
                                        <small>${item.clientEmail}</small>
                                    </td>
                                    <td>
                                        ${item.packageName}<br>
                                        <span class="badge ${item.packageCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${item.packageCateg}</span>
                                    </td>
                                    <td>RM <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></td>
                                    <td class="text-success fw-bold">RM <fmt:formatNumber value="${item.paidAmount}" pattern="#,##0.00"/></td>
                                    <td>
                                        <c:if test="${not empty item.depoRef}">
                                            <span class="badge bg-success">${item.depoRef}</span>
                                        </c:if>
                                        <c:if test="${empty item.depoRef}">-</c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty item.fullRef}">
                                            <span class="badge bg-success">${item.fullRef}</span>
                                        </c:if>
                                        <c:if test="${empty item.fullRef}">-</c:if>
                                    </td>
                                    <td>
                                        <c:if test="${item.verifiedDate != null}">
                                            <fmt:formatDate value="${item.verifiedDate}" pattern="dd/MM/yyyy"/>
                                        </c:if>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty completedPayments}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">
                                        <i class="bi bi-folder-x display-4"></i>
                                        <p class="mt-2">No completed payments yet.</p>
                                    </td>
                                </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <!-- SECTION 3: CONFIRM HISTORY -->
            <div class="card">
                <div class="card-header">
                    <h3><i class="bi bi-clock-history"></i> Confirm History</h3>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3">All payment verification history:</p>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Pay ID</th>
                                    <th>Booking</th>
                                    <th>Client</th>
                                    <th>Total</th>
                                    <th>Paid</th>
                                    <th>Remaining</th>
                                    <th>Status</th>
                                    <th>Verified By</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${confirmHistory}">
                                <tr>
                                    <td><strong>P${item.payId}</strong></td>
                                    <td><strong>#${item.bookingId}</strong></td>
                                    <td>${item.clientName}</td>
                                    <td>RM <fmt:formatNumber value="${item.totalPrice}" pattern="#,##0.00"/></td>
                                    <td class="text-success">RM <fmt:formatNumber value="${item.paidAmount}" pattern="#,##0.00"/></td>
                                    <td class="${item.remAmount > 0 ? 'text-danger' : 'text-success'}">
                                        RM <fmt:formatNumber value="${item.remAmount}" pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.payStatus == 'verified'}">
                                                <span class="badge bg-success">Verified</span>
                                            </c:when>
                                            <c:when test="${item.payStatus == 'partial'}">
                                                <span class="badge bg-info">Partial</span>
                                            </c:when>
                                            <c:when test="${item.payStatus == 'rejected'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${item.payStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${item.verifierName}</td>
                                    <td>
                                        <c:if test="${item.verifiedDate != null}">
                                            <fmt:formatDate value="${item.verifiedDate}" pattern="dd/MM/yyyy"/>
                                        </c:if>
                                    </td>
                                </tr>
                                </c:forEach>
                                <c:if test="${empty confirmHistory}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">
                                        <i class="bi bi-clock-history display-4"></i>
                                        <p class="mt-2">No verification history yet.</p>
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
    
    <!-- Verify Modal -->
    <div class="modal fade" id="verifyModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #28a745, #20c997); color: white;">
                    <h5 class="modal-title"><i class="bi bi-check-circle"></i> Verify Payment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/payment" method="post" id="verifyForm">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="verify">
                        <input type="hidden" name="payId" id="verifyPayId">
                        <input type="hidden" name="bookingId" id="verifyBookingId">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Payment Type to Verify *</label>
                            <select name="verifyType" id="verifyType" class="form-select" required onchange="updateVerifyAmount()">
                                <option value="">-- Select --</option>
                                <option value="deposit" id="depositOption">Deposit (30%)</option>
                                <option value="full" id="fullOption">Full/Remaining Payment</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Amount to Verify (RM) *</label>
                            <input type="number" name="verifyAmount" id="verifyAmount" class="form-control" step="0.01" required>
                            <small class="text-muted">This amount will be added to Paid Amount</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-success" onclick="showVerifyConfirmation()">
                            <i class="bi bi-check-lg"></i> Verify Payment
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Verify Confirmation Modal -->
    <div class="modal fade" id="confirmVerifyModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px;">
                <div class="modal-header" style="background: linear-gradient(135deg, #22c55e, #16a34a); color: #fff; border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title"><i class="bi bi-shield-check"></i> Confirm Verification</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <i class="bi bi-check-circle text-success" style="font-size: 4rem;"></i>
                    <h5 class="mt-3">Are you sure you want to verify this payment?</h5>
                    <p class="text-muted mb-0" id="confirmVerifyDetails"></p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-secondary btn-lg px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success btn-lg px-4" onclick="submitVerifyForm()">
                        <i class="bi bi-check-lg"></i> Yes, Verify
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px;">
                <div class="modal-header" style="background: linear-gradient(135deg, #dc3545, #e91e63); color: #fff; border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title"><i class="bi bi-x-circle"></i> Reject Payment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/payment" method="post">
                    <div class="modal-body text-center py-4">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="payId" id="rejectPayId">
                        <i class="bi bi-x-circle text-danger" style="font-size: 4rem;"></i>
                        <h5 class="mt-3">Are you sure you want to reject this payment?</h5>
                        <p class="text-muted">The client will be notified to resubmit.</p>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary btn-lg px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger btn-lg px-4">
                            <i class="bi bi-x-lg"></i> Yes, Reject
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- View Receipt Modal -->
    <div class="modal fade" id="receiptModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title" id="receiptModalTitle"><i class="bi bi-receipt"></i> View Receipt</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center p-4">
                    <img id="receiptImage" src="" class="img-fluid rounded shadow" style="max-height: 500px;" alt="Receipt">
                    <p id="receiptError" class="text-muted d-none">
                        <i class="bi bi-image display-4"></i><br>
                        No receipt image available.
                    </p>
                </div>
                <div class="modal-footer">
                    <a id="receiptDownload" href="" target="_blank" class="btn btn-primary">
                        <i class="bi bi-download"></i> Open Full Size
                    </a>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        var currentTotalPrice = 0;
        var currentRemAmount = 0;
        
        function showVerifyModal(payId, bookingId, totalPrice, remAmount, depoRef, fullRef) {
            document.getElementById('verifyPayId').value = payId;
            document.getElementById('verifyBookingId').value = bookingId;
            currentTotalPrice = totalPrice;
            currentRemAmount = remAmount;
            
            var depositOption = document.getElementById('depositOption');
            var fullOption = document.getElementById('fullOption');
            var verifyType = document.getElementById('verifyType');
            
            depositOption.disabled = false;
            fullOption.disabled = false;
            verifyType.value = '';
            
            if (depoRef && depoRef !== 'null' && depoRef !== '') {
                depositOption.disabled = false;
                depositOption.text = 'Deposit - Ref: ' + depoRef;
            } else {
                depositOption.disabled = true;
                depositOption.text = 'Deposit (Not submitted)';
            }
            
            if (fullRef && fullRef !== 'null' && fullRef !== '') {
                fullOption.disabled = false;
                fullOption.text = 'Full Payment - Ref: ' + fullRef;
            } else {
                fullOption.disabled = true;
                fullOption.text = 'Full Payment (Not submitted)';
            }
            
            if (!depositOption.disabled && fullOption.disabled) {
                verifyType.value = 'deposit';
                updateVerifyAmount();
            } else if (depositOption.disabled && !fullOption.disabled) {
                verifyType.value = 'full';
                updateVerifyAmount();
            }
            
            new bootstrap.Modal(document.getElementById('verifyModal')).show();
        }
        
        function updateVerifyAmount() {
            var type = document.getElementById('verifyType').value;
            var amountField = document.getElementById('verifyAmount');
            
            if (type === 'deposit') {
                amountField.value = (currentTotalPrice * 0.3).toFixed(2);
            } else if (type === 'full') {
                amountField.value = currentRemAmount.toFixed(2);
            } else {
                amountField.value = '';
            }
        }
        
        function showVerifyConfirmation() {
            var type = document.getElementById('verifyType').value;
            var amount = document.getElementById('verifyAmount').value;
            
            if (!type) {
                alert('Please select payment type to verify.');
                return;
            }
            
            if (!amount || parseFloat(amount) <= 0) {
                alert('Please enter a valid amount.');
                return;
            }
            
            var typeText = type === 'deposit' ? 'Deposit' : 'Full/Remaining Payment';
            document.getElementById('confirmVerifyDetails').innerHTML = 
                '<strong>Payment Type:</strong> ' + typeText + '<br>' +
                '<strong>Amount:</strong> RM ' + parseFloat(amount).toFixed(2);
            
            bootstrap.Modal.getInstance(document.getElementById('verifyModal')).hide();
            new bootstrap.Modal(document.getElementById('confirmVerifyModal')).show();
        }
        
        function submitVerifyForm() {
            document.getElementById('verifyForm').submit();
        }
        
        function showRejectModal(payId) {
            document.getElementById('rejectPayId').value = payId;
            new bootstrap.Modal(document.getElementById('rejectModal')).show();
        }
        
        function viewReceipt(receiptPath, title) {
            document.getElementById('receiptModalTitle').innerHTML = '<i class="bi bi-receipt"></i> ' + title;
            var imgElement = document.getElementById('receiptImage');
            var errorElement = document.getElementById('receiptError');
            var downloadLink = document.getElementById('receiptDownload');
            
            if (receiptPath && receiptPath !== 'null') {
                var fullPath = '${pageContext.request.contextPath}/' + receiptPath;
                imgElement.src = fullPath;
                imgElement.classList.remove('d-none');
                errorElement.classList.add('d-none');
                downloadLink.href = fullPath;
                downloadLink.classList.remove('d-none');
            } else {
                imgElement.classList.add('d-none');
                errorElement.classList.remove('d-none');
                downloadLink.classList.add('d-none');
            }
            
            new bootstrap.Modal(document.getElementById('receiptModal')).show();
        }
    </script>
</body>
</html>

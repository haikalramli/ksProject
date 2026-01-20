<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    if (session.getAttribute("clientID") == null) {
        response.sendRedirect("SignIn.jsp");
        return;
    }
%>

<jsp:include page="Header.jsp" />

<section class="section light-background" style="padding-top: 100px;">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <span class="description-title">Payment</span>
            <h2>Make Payment</h2>
            <p>Submit your payment for booking #${booking.bookingId}</p>
        </div>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Booking Summary -->
                <div class="card shadow-sm mb-4" style="border-radius: 15px;">
                    <div class="card-header bg-primary text-white" style="border-radius: 15px 15px 0 0;">
                        <h5 class="mb-0"><i class="bi bi-calendar-check"></i> Booking Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Booking ID:</strong> #${booking.bookingId}</p>
                                <p><strong>Package:</strong> ${booking.packageName}</p>
                                <p><strong>Category:</strong> 
                                    <span class="badge ${booking.packageCateg == 'Indoor' ? 'bg-info' : 'bg-success'}">${booking.packageCateg}</span>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Date:</strong> ${booking.bookDate}</p>
                                <p><strong>Time:</strong> ${booking.bookTime}</p>
                                <p><strong>Status:</strong> 
                                    <span class="badge bg-warning text-dark">${booking.bookStatus}</span>
                                </p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <h6 class="text-muted">Total Amount</h6>
                                <h4 class="text-primary">RM <fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></h4>
                            </div>
                            <div class="col-md-4 text-center">
                                <h6 class="text-muted">Paid Amount</h6>
                                <h4 class="text-success">RM <fmt:formatNumber value="${payment != null ? payment.paidAmount : 0}" pattern="#,##0.00"/></h4>
                            </div>
                            <div class="col-md-4 text-center">
                                <h6 class="text-muted">Remaining</h6>
                                <h4 class="text-danger">RM <fmt:formatNumber value="${payment != null ? payment.remAmount : booking.totalPrice}" pattern="#,##0.00"/></h4>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Payment History -->
                <c:if test="${payment != null && (not empty payment.depoRef || not empty payment.fullRef)}">
                <div class="card shadow-sm mb-4" style="border-radius: 15px;">
                    <div class="card-header" style="border-radius: 15px 15px 0 0; background: #f8f9fa;">
                        <h5 class="mb-0"><i class="bi bi-clock-history"></i> Payment History</h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty payment.depoRef}">
                        <div class="d-flex justify-content-between align-items-center mb-3 p-3 bg-light rounded">
                            <div>
                                <strong><i class="bi bi-cash-coin text-warning"></i> Deposit Payment</strong><br>
                                <small class="text-muted">Ref: ${payment.depoRef}</small>
                                <c:if test="${payment.depoDate != null}">
                                    <br><small class="text-muted">Date: <fmt:formatDate value="${payment.depoDate}" pattern="dd MMM yyyy"/></small>
                                </c:if>
                            </div>
                            <span class="badge ${payment.payStatus == 'verified' || payment.payStatus == 'partial' ? 'bg-success' : 'bg-warning'}">
                                ${payment.payStatus == 'verified' || payment.payStatus == 'partial' ? 'Verified' : 'Pending'}
                            </span>
                        </div>
                        </c:if>
                        
                        <c:if test="${not empty payment.fullRef}">
                        <div class="d-flex justify-content-between align-items-center p-3 bg-light rounded">
                            <div>
                                <strong><i class="bi bi-cash-stack text-success"></i> Full Payment</strong><br>
                                <small class="text-muted">Ref: ${payment.fullRef}</small>
                                <c:if test="${payment.fullDate != null}">
                                    <br><small class="text-muted">Date: <fmt:formatDate value="${payment.fullDate}" pattern="dd MMM yyyy"/></small>
                                </c:if>
                            </div>
                            <span class="badge ${payment.payStatus == 'verified' ? 'bg-success' : 'bg-warning'}">
                                ${payment.payStatus == 'verified' ? 'Verified' : 'Pending'}
                            </span>
                        </div>
                        </c:if>
                    </div>
                </div>
                </c:if>
                
                <!-- Payment Status Messages -->
                <c:if test="${payment != null && payment.payStatus == 'verified' && payment.remAmount <= 0}">
                    <div class="alert alert-success">
                        <h5><i class="bi bi-check-circle-fill"></i> Payment Complete!</h5>
                        <p class="mb-0">Your payment has been fully verified. You can now access your photos.</p>
                        <a href="${pageContext.request.contextPath}/BookingController?action=photos&bookingId=${booking.bookingId}" class="btn btn-success mt-2">
                            <i class="bi bi-images"></i> View My Photos
                        </a>
                    </div>
                </c:if>
                
                <c:if test="${payment != null && payment.payStatus == 'submitted'}">
                    <div class="alert alert-info">
                        <h5><i class="bi bi-hourglass-split"></i> Payment Submitted</h5>
                        <p class="mb-0">Your payment is awaiting verification by admin.</p>
                    </div>
                </c:if>
                
                <!-- Payment Form -->
                <c:if test="${payment == null || payment.remAmount > 0}">
                <div class="card shadow-sm" style="border-radius: 15px;">
                    <div class="card-header" style="border-radius: 15px 15px 0 0; background: linear-gradient(135deg, #2f5d50, #1a3a32);">
                        <h5 class="mb-0 text-white"><i class="bi bi-credit-card"></i> Submit Payment</h5>
                    </div>
                    <div class="card-body">
                        <!-- Bank Info -->
                        <div class="alert alert-light border mb-4">
                            <h6><i class="bi bi-bank"></i> Bank Transfer Details</h6>
                            <p class="mb-1"><strong>Bank:</strong> Maybank</p>
                            <p class="mb-1"><strong>Account Name:</strong> KS Studio Sdn Bhd</p>
                            <p class="mb-1"><strong>Account Number:</strong> 1234 5678 9012</p>
                        </div>
                        
                        <!-- Payment Type Selection -->
                        <div class="mb-4">
                            <label class="form-label fw-bold">Select Payment Type *</label>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-check payment-option p-3 border rounded" style="cursor: pointer;" onclick="selectPaymentType('deposit')">
                                        <input class="form-check-input" type="radio" name="paymentType" id="depositOption" value="deposit" 
                                               <c:if test="${empty payment.depoRef}">checked</c:if>
                                               <c:if test="${not empty payment.depoRef}">disabled</c:if>>
                                        <label class="form-check-label w-100" for="depositOption">
                                            <strong><i class="bi bi-cash-coin text-warning"></i> Deposit (30%)</strong><br>
                                            <span class="text-muted">RM <fmt:formatNumber value="${booking.totalPrice * 0.3}" pattern="#,##0.00"/></span>
                                            <c:if test="${not empty payment.depoRef}">
                                                <br><span class="badge bg-success mt-1">Already Paid</span>
                                            </c:if>
                                        </label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check payment-option p-3 border rounded" style="cursor: pointer;" onclick="selectPaymentType('full')">
                                        <input class="form-check-input" type="radio" name="paymentType" id="fullOption" value="full"
                                               <c:if test="${not empty payment.depoRef}">checked</c:if>>
                                        <label class="form-check-label w-100" for="fullOption">
                                            <strong><i class="bi bi-cash-stack text-success"></i> 
                                                <c:choose>
                                                    <c:when test="${not empty payment.depoRef}">Remaining Balance</c:when>
                                                    <c:otherwise>Full Payment</c:otherwise>
                                                </c:choose>
                                            </strong><br>
                                            <span class="text-muted">RM <fmt:formatNumber value="${payment != null ? payment.remAmount : booking.totalPrice}" pattern="#,##0.00"/></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/ClientPaymentController" method="post" 
                              id="paymentForm" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="submit">
                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                            <input type="hidden" name="paymentType" id="selectedPaymentType" value="${empty payment.depoRef ? 'deposit' : 'full'}">
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Payment Reference Number *</label>
                                <input type="text" name="reference" class="form-control" 
                                       placeholder="e.g., TRF123456789" required>
                                <small class="text-muted">Enter your bank transfer reference number</small>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-bold">Amount Paid (RM) *</label>
                                <input type="number" name="amount" id="paymentAmount" class="form-control" 
                                       step="0.01" min="0.01" 
                                       value="<fmt:formatNumber value="${empty payment.depoRef ? booking.totalPrice * 0.3 : (payment != null ? payment.remAmount : booking.totalPrice)}" pattern="#0.00"/>" required>
                                <small class="text-muted">Minimum: RM 0.01</small>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label fw-bold">Upload Receipt (Optional)</label>
                                <input type="file" name="receiptFile" class="form-control" 
                                       accept="image/png,image/jpeg,image/jpg,image/gif">
                                <small class="text-muted">Upload your payment receipt image (PNG, JPG, GIF - Max 10MB)</small>
                            </div>
                            
                            <button type="button" class="btn btn-primary btn-lg w-100" onclick="confirmPayment()">
                                <i class="bi bi-send"></i> Submit Payment
                            </button>
                        </form>
                    </div>
                </div>
                </c:if>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/BookingController?action=list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Back to My Bookings
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Payment Confirmation Modal -->
<div class="modal fade" id="confirmPaymentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-credit-card"></i> Confirm Payment</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center py-4">
                <i class="bi bi-question-circle text-primary" style="font-size: 4rem;"></i>
                <h5 class="mt-3">Confirm Payment Submission?</h5>
                <p class="text-muted" id="confirmMessage">Are you sure you want to submit this payment?</p>
            </div>
            <div class="modal-footer justify-content-center">
                <button type="button" class="btn btn-secondary btn-lg px-4" data-bs-dismiss="modal">
                    <i class="bi bi-x-lg"></i> Cancel
                </button>
                <button type="button" class="btn btn-primary btn-lg px-4" onclick="document.getElementById('paymentForm').submit();">
                    <i class="bi bi-check-lg"></i> Yes, Submit
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function selectPaymentType(type) {
    document.getElementById('selectedPaymentType').value = type;
    if (type === 'deposit') {
        document.getElementById('depositOption').checked = true;
        document.getElementById('paymentAmount').value = '${empty payment.depoRef ? String.format("%.2f", booking.totalPrice * 0.3) : "0.00"}';
    } else {
        document.getElementById('fullOption').checked = true;
        document.getElementById('paymentAmount').value = '${payment != null ? String.format("%.2f", payment.remAmount) : String.format("%.2f", booking.totalPrice)}';
    }
}

function confirmPayment() {
    const type = document.getElementById('selectedPaymentType').value;
    const amount = parseFloat(document.getElementById('paymentAmount').value);
    const ref = document.querySelector('input[name="reference"]').value;
    
    if (!ref) {
        alert('Please enter payment reference number.');
        return;
    }
    
    if (!amount || amount <= 0) {
        alert('Payment amount must be greater than RM 0.00.');
        return;
    }
    
    const typeText = type === 'deposit' ? 'Deposit' : 'Full/Remaining';
    document.getElementById('confirmMessage').innerHTML = 
        'Payment Type: <strong>' + typeText + '</strong><br>Amount: <strong>RM ' + amount.toFixed(2) + '</strong>';
    
    new bootstrap.Modal(document.getElementById('confirmPaymentModal')).show();
}

// Highlight selected payment option
document.querySelectorAll('.payment-option').forEach(function(option) {
    option.addEventListener('click', function() {
        document.querySelectorAll('.payment-option').forEach(function(o) {
            o.classList.remove('border-primary', 'bg-light');
        });
        this.classList.add('border-primary', 'bg-light');
    });
});
</script>

<style>
.payment-option {
    transition: all 0.3s ease;
}
.payment-option:hover {
    border-color: #2f5d50 !important;
    background: #f8f9fa;
}
.payment-option.border-primary {
    border-color: #2f5d50 !important;
    border-width: 2px !important;
}
</style>

<jsp:include page="Footer.jsp" />

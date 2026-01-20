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
    <div class="container section-title" data-aos="fade-up">
        <span class="description-title">Indoor Packages</span>
        <h2>Indoor Photography Packages</h2>
        <p>Choose from our professional indoor studio packages. Perfect for portraits, corporate photos, and celebrations.</p>
    </div>

    <div class="container">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="pkg" items="${packages}">
                <div class="col-lg-4 col-md-6" data-aos="fade-up">
                    <div class="card h-100 shadow-sm">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">${pkg.pkgName}</h5>
                        </div>
                        <div class="card-body">
                            <h3 class="text-primary mb-3">RM <fmt:formatNumber value="${pkg.pkgPrice}" pattern="#,##0.00"/></h3>
                            <ul class="list-unstyled">
                                <li><i class="bi bi-clock text-muted"></i> Duration: ${pkg.pkgDuration} hours</li>
                                <li><i class="bi bi-people text-muted"></i> Max Pax: ${pkg.numOfPax}</li>
                                <li><i class="bi bi-image text-muted"></i> Background: ${pkg.backgType}</li>
                                <li><i class="bi bi-tag text-muted"></i> Event Type: ${pkg.eventType}</li>
                            </ul>
                            <p class="text-muted small">${pkg.pkgDesc}</p>
                        </div>
                        <div class="card-footer bg-white border-0">
                            <button class="btn btn-primary w-100" onclick="openBookingModal(${pkg.pkgId}, '${pkg.pkgName}', ${pkg.pkgPrice}, ${pkg.numOfPax})">
                                <i class="bi bi-calendar-check"></i> Book Now
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty packages}">
                <div class="col-12 text-center py-5">
                    <i class="bi bi-camera" style="font-size: 4rem; color: #ccc;"></i>
                    <p class="mt-3 text-muted">No indoor packages available at the moment.</p>
                </div>
            </c:if>
        </div>
    </div>
</section>

<!-- Booking Modal -->
<div class="modal fade" id="bookingModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title"><i class="bi bi-calendar-check"></i> Book Package</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/BookingController" method="post">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="pkgId" id="modalPkgId">
                <div class="modal-body">
                    <h4 id="modalPkgName" class="mb-3"></h4>
                    <p class="text-muted">Price: <strong id="modalPkgPrice"></strong></p>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Select Date * <small class="text-muted">(Select date first)</small></label>
                            <input type="date" class="form-control" name="bookDate" id="bookDateInput" required min="" onchange="loadAvailableTimes()">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Select Time *</label>
                            <select class="form-select" name="bookTime" id="bookTimeSelect" required disabled>
                                <option value="">-- Select date first --</option>
                            </select>
                            <small class="text-muted" id="timeHelpText">Please select a date to see available times</small>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Number of People *</label>
                        <input type="number" class="form-control" name="bookPax" id="modalBookPax" min="1" required>
                        <small class="text-muted">Maximum: <span id="maxPax"></span> people</small>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Location</label>
                        <input type="text" class="form-control" name="location" value="KS Studio" readonly>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Special Notes</label>
                        <textarea class="form-control" name="notes" rows="3" placeholder="Any special requests or notes..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Confirm Booking</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// All available time slots
const allTimeSlots = [
    {value: '09:00 AM', label: '09:00 AM'},
    {value: '10:00 AM', label: '10:00 AM'},
    {value: '11:00 AM', label: '11:00 AM'},
    {value: '12:00 PM', label: '12:00 PM'},
    {value: '02:00 PM', label: '02:00 PM'},
    {value: '03:00 PM', label: '03:00 PM'},
    {value: '04:00 PM', label: '04:00 PM'},
    {value: '05:00 PM', label: '05:00 PM'}
];

function openBookingModal(pkgId, pkgName, pkgPrice, maxPax) {
    document.getElementById('modalPkgId').value = pkgId;
    document.getElementById('modalPkgName').textContent = pkgName;
    document.getElementById('modalPkgPrice').textContent = 'RM ' + pkgPrice.toFixed(2);
    document.getElementById('modalBookPax').max = maxPax;
    document.getElementById('modalBookPax').value = 1;
    document.getElementById('maxPax').textContent = maxPax;
    
    // Reset time select
    const timeSelect = document.getElementById('bookTimeSelect');
    timeSelect.innerHTML = '<option value="">-- Select date first --</option>';
    timeSelect.disabled = true;
    document.getElementById('timeHelpText').textContent = 'Please select a date to see available times';
    document.getElementById('bookDateInput').value = '';
    
    // Set min date to tomorrow
    var tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById('bookDateInput').min = tomorrow.toISOString().split('T')[0];
    
    new bootstrap.Modal(document.getElementById('bookingModal')).show();
}

function loadAvailableTimes() {
    const dateInput = document.getElementById('bookDateInput');
    const timeSelect = document.getElementById('bookTimeSelect');
    const helpText = document.getElementById('timeHelpText');
    const selectedDate = dateInput.value;
    
    if (!selectedDate) {
        timeSelect.innerHTML = '<option value="">-- Select date first --</option>';
        timeSelect.disabled = true;
        helpText.textContent = 'Please select a date to see available times';
        return;
    }
    
    // Show loading
    timeSelect.innerHTML = '<option value="">Loading available times...</option>';
    timeSelect.disabled = true;
    helpText.textContent = 'Checking availability...';
    
    // Fetch booked times from server
    fetch('${pageContext.request.contextPath}/BookingController?action=getBookedTimes&date=' + selectedDate)
        .then(response => response.json())
        .then(bookedTimes => {
            timeSelect.innerHTML = '<option value="">Choose time...</option>';
            
            let availableCount = 0;
            allTimeSlots.forEach(slot => {
                const option = document.createElement('option');
                option.value = slot.value;
                
                // Convert slot time to 24h format for comparison
                const slotTime24 = convertTo24Hour(slot.value);
                
                if (bookedTimes.includes(slotTime24)) {
                    option.textContent = slot.label + ' (Booked)';
                    option.disabled = true;
                    option.style.color = '#999';
                } else {
                    option.textContent = slot.label;
                    availableCount++;
                }
                timeSelect.appendChild(option);
            });
            
            timeSelect.disabled = false;
            
            if (availableCount === 0) {
                helpText.textContent = 'No available times on this date. Please choose another date.';
                helpText.style.color = '#dc3545';
            } else {
                helpText.textContent = availableCount + ' time slot(s) available';
                helpText.style.color = '#198754';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            // If error, show all times as available
            timeSelect.innerHTML = '<option value="">Choose time...</option>';
            allTimeSlots.forEach(slot => {
                const option = document.createElement('option');
                option.value = slot.value;
                option.textContent = slot.label;
                timeSelect.appendChild(option);
            });
            timeSelect.disabled = false;
            helpText.textContent = 'Select your preferred time';
            helpText.style.color = '#6c757d';
        });
}

function convertTo24Hour(time12h) {
    const [time, modifier] = time12h.split(' ');
    let [hours, minutes] = time.split(':');
    
    if (hours === '12') {
        hours = modifier === 'AM' ? '00' : '12';
    } else if (modifier === 'PM') {
        hours = parseInt(hours, 10) + 12;
    }
    
    return hours.toString().padStart(2, '0') + ':' + minutes;
}
</script>

<jsp:include page="Footer.jsp" />

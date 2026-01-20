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
        <span class="description-title">Outdoor Packages</span>
        <h2>Outdoor Photography Packages</h2>
        <p>Capture your special moments in beautiful outdoor locations. Perfect for weddings, pre-weddings, and events.</p>
    </div>

    <div class="container">
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="pkg" items="${packages}">
                <div class="col-lg-4 col-md-6" data-aos="fade-up">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-header" style="background: linear-gradient(135deg, #2f5d50, #1a3a32); color: white;">
                            <h5 class="mb-0">${pkg.pkgName}</h5>
                        </div>
                        <div class="card-body">
                            <h3 class="mb-3" style="color: #2f5d50;">RM <fmt:formatNumber value="${pkg.pkgPrice}" pattern="#,##0.00"/></h3>
                            <ul class="list-unstyled">
                                <li class="mb-2"><i class="bi bi-clock text-muted me-2"></i> Duration: ${pkg.pkgDuration} hours</li>
                                <li class="mb-2"><i class="bi bi-geo-alt text-muted me-2"></i> Location: ${pkg.location}</li>
                                <li class="mb-2"><i class="bi bi-car-front text-muted me-2"></i> Max Distance: ${pkg.distance} km</li>
                                <li class="mb-2"><i class="bi bi-currency-dollar text-muted me-2"></i> Extra: RM ${pkg.distancePricePerKm}/km</li>
                                <li class="mb-2"><i class="bi bi-tag text-muted me-2"></i> Event: ${pkg.eventType}</li>
                            </ul>
                            <p class="text-muted small">${pkg.pkgDesc}</p>
                        </div>
                        <div class="card-footer bg-white border-0 pt-0">
                            <button class="btn w-100" style="background: #2f5d50; color: white;" 
                                    onclick="openOutdoorModal(${pkg.pkgId}, '${pkg.pkgName}', ${pkg.pkgPrice}, '${pkg.location}', ${pkg.distance}, ${pkg.distancePricePerKm})">
                                <i class="bi bi-calendar-check"></i> Book Now
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty packages}">
                <div class="col-12 text-center py-5">
                    <i class="bi bi-camera" style="font-size: 4rem; color: #ccc;"></i>
                    <p class="mt-3 text-muted">No outdoor packages available at the moment.</p>
                </div>
            </c:if>
        </div>
    </div>
</section>

<!-- Booking Modal for Outdoor -->
<div class="modal fade" id="outdoorModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #2f5d50, #1a3a32); color: white;">
                <h5 class="modal-title"><i class="bi bi-calendar-check"></i> Book Outdoor Package</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/BookingController" method="post">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="pkgId" id="outPkgId">
                <div class="modal-body">
                    <h4 id="outPkgName" class="mb-2"></h4>
                    <p class="text-muted mb-3">Base Price: <strong id="outPkgPrice"></strong></p>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Event Date * <small class="text-muted">(Select date first)</small></label>
                            <input type="date" class="form-control" name="bookDate" id="outBookDateInput" required min="" onchange="loadOutdoorAvailableTimes()">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Start Time *</label>
                            <select class="form-select" name="bookTime" id="outBookTimeSelect" required disabled>
                                <option value="">-- Select date first --</option>
                            </select>
                            <small class="text-muted" id="outTimeHelpText">Please select a date to see available times</small>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Number of People *</label>
                            <input type="number" class="form-control" name="bookPax" min="1" value="2" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Distance from KL (km)</label>
                            <input type="number" class="form-control" name="distance" id="outDistance" min="0" value="0" onchange="calculateTotal()">
                            <small class="text-muted">Extra charge: RM <span id="perKmRate">0</span>/km</small>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Event Location *</label>
                        <input type="text" class="form-control" name="location" id="outLocation" required placeholder="Enter venue address">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Special Notes</label>
                        <textarea class="form-control" name="notes" rows="3" placeholder="Wedding theme, special requests, etc."></textarea>
                    </div>
                    
                    <div class="alert alert-info">
                        <strong>Estimated Total: RM <span id="totalPrice">0.00</span></strong>
                        <br><small>Base price + distance charge (if applicable)</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn" style="background: #2f5d50; color: white;">Confirm Booking</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
var basePrice = 0;
var pricePerKm = 0;

// All available time slots for outdoor
const outdoorTimeSlots = [
    {value: '07:00 AM', label: '07:00 AM'},
    {value: '08:00 AM', label: '08:00 AM'},
    {value: '09:00 AM', label: '09:00 AM'},
    {value: '10:00 AM', label: '10:00 AM'},
    {value: '02:00 PM', label: '02:00 PM'},
    {value: '03:00 PM', label: '03:00 PM'},
    {value: '04:00 PM', label: '04:00 PM'}
];

function openOutdoorModal(pkgId, pkgName, pkgPrice, location, maxDist, perKm) {
    document.getElementById('outPkgId').value = pkgId;
    document.getElementById('outPkgName').textContent = pkgName;
    document.getElementById('outPkgPrice').textContent = 'RM ' + pkgPrice.toFixed(2);
    document.getElementById('outLocation').value = location;
    document.getElementById('perKmRate').textContent = perKm.toFixed(2);
    
    basePrice = pkgPrice;
    pricePerKm = perKm;
    
    // Reset time select
    const timeSelect = document.getElementById('outBookTimeSelect');
    timeSelect.innerHTML = '<option value="">-- Select date first --</option>';
    timeSelect.disabled = true;
    document.getElementById('outTimeHelpText').textContent = 'Please select a date to see available times';
    document.getElementById('outBookDateInput').value = '';
    
    calculateTotal();
    
    // Set min date to tomorrow
    var tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById('outBookDateInput').min = tomorrow.toISOString().split('T')[0];
    
    new bootstrap.Modal(document.getElementById('outdoorModal')).show();
}

function loadOutdoorAvailableTimes() {
    const dateInput = document.getElementById('outBookDateInput');
    const timeSelect = document.getElementById('outBookTimeSelect');
    const helpText = document.getElementById('outTimeHelpText');
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
            outdoorTimeSlots.forEach(slot => {
                const option = document.createElement('option');
                option.value = slot.value;
                
                // Convert slot time to 24h format for comparison
                const slotTime24 = convertTo24HourOut(slot.value);
                
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
            timeSelect.innerHTML = '<option value="">Choose time...</option>';
            outdoorTimeSlots.forEach(slot => {
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

function convertTo24HourOut(time12h) {
    const [time, modifier] = time12h.split(' ');
    let [hours, minutes] = time.split(':');
    
    if (hours === '12') {
        hours = modifier === 'AM' ? '00' : '12';
    } else if (modifier === 'PM') {
        hours = parseInt(hours, 10) + 12;
    }
    
    return hours.toString().padStart(2, '0') + ':' + minutes;
}

function calculateTotal() {
    var distance = parseFloat(document.getElementById('outDistance').value) || 0;
    var total = basePrice + (distance * pricePerKm);
    document.getElementById('totalPrice').textContent = total.toFixed(2);
}
</script>

<jsp:include page="Footer.jsp" />

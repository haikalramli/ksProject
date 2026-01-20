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

<section class="section" style="padding-top: 100px; min-height: 80vh;">
    <div class="container">
        <div class="section-title" data-aos="fade-up">
            <span class="description-title">Edit Booking</span>
            <h2>Reschedule Your Booking!</h2>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-pencil-square"></i> Edit Booking #${booking.bookingId}</h5>
                    </div>
                    <div class="card-body">
                        <!-- Current Booking Info -->
                        <div class="alert alert-info mb-4">
                            <h6><strong>Current Booking Details:</strong></h6>
                            <p class="mb-1"><strong>Package:</strong> ${booking.packageName} (${booking.packageCateg})</p>
                            <p class="mb-1"><strong>Current Date:</strong> 
                                <fmt:parseDate value="${booking.bookDate}" pattern="yyyy-MM-dd" var="currentDate" type="date"/>
                                <fmt:formatDate value="${currentDate}" pattern="dd MMM yyyy"/>
                            </p>
                            <p class="mb-0"><strong>Current Time:</strong> 
                                <fmt:formatDate value="${booking.bookStartTime}" pattern="hh:mm a"/> - 
                                <fmt:formatDate value="${booking.bookEndTime}" pattern="hh:mm a"/>
                            </p>
                        </div>

                        <!-- Edit Form -->
                        <form action="${pageContext.request.contextPath}/BookingController" method="post" id="editBookingForm">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">New Date *</label>
                                    <input type="date" class="form-control" name="bookDate" 
                                           id="newDateInput" required min="" 
                                           value="${booking.bookDate}"
                                           onchange="loadAvailableTimes()">
                                    <small class="text-muted">Select new date for your booking</small>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">New Time *</label>
                                    <select class="form-select" name="bookTime" id="newTimeSelect" required>
                                        <option value="">-- Select date first --</option>
                                    </select>
                                    <small class="text-muted" id="timeHelpText">Please select a date to see available times</small>
                                </div>
                            </div>

                            <div class="alert alert-warning">
                                <i class="bi bi-exclamation-triangle"></i>
                                <strong>Note:</strong> You can only change the date and time. All other booking details remain the same.
                            </div>

                            <div class="d-flex justify-content-between mt-4">
                                <a href="${pageContext.request.contextPath}/BookingController?action=list" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-arrow-left"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-check-circle"></i> Update Booking
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title"><i class="bi bi-check-circle"></i> Confirm Changes</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p><strong>Are you sure you want to reschedule this booking?</strong></p>
                <p class="mb-1">New Date: <span id="confirmDate" class="text-primary"></span></p>
                <p class="mb-0">New Time: <span id="confirmTime" class="text-primary"></span></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-success" onclick="submitForm()">
                    <i class="bi bi-check-circle"></i> Confirm Update
                </button>
            </div>
        </div>
    </div>
</div>

<script>
// Time slots based on package category
const indoorTimeSlots = [
    {value: '09:00 AM', label: '09:00 AM'},
    {value: '10:00 AM', label: '10:00 AM'},
    {value: '11:00 AM', label: '11:00 AM'},
    {value: '12:00 PM', label: '12:00 PM'},
    {value: '02:00 PM', label: '02:00 PM'},
    {value: '03:00 PM', label: '03:00 PM'},
    {value: '04:00 PM', label: '04:00 PM'},
    {value: '05:00 PM', label: '05:00 PM'}
];

const outdoorTimeSlots = [
    {value: '07:00 AM', label: '07:00 AM'},
    {value: '08:00 AM', label: '08:00 AM'},
    {value: '09:00 AM', label: '09:00 AM'},
    {value: '10:00 AM', label: '10:00 AM'},
    {value: '02:00 PM', label: '02:00 PM'},
    {value: '03:00 PM', label: '03:00 PM'},
    {value: '04:00 PM', label: '04:00 PM'}
];

const isIndoor = '${booking.packageCateg}' === 'Indoor';
const timeSlots = isIndoor ? indoorTimeSlots : outdoorTimeSlots;

// Set minimum date to tomorrow
window.addEventListener('DOMContentLoaded', function() {
    var tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    document.getElementById('newDateInput').min = tomorrow.toISOString().split('T')[0];
});

// Form submission with confirmation
document.getElementById('editBookingForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const dateInput = document.getElementById('newDateInput');
    const timeSelect = document.getElementById('newTimeSelect');
    
    if (!dateInput.value || !timeSelect.value) {
        alert('Please select both date and time');
        return;
    }
    
    // Format date for display
    const dateObj = new Date(dateInput.value);
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    const formattedDate = dateObj.toLocaleDateString('en-MY', options);
    
    document.getElementById('confirmDate').textContent = formattedDate;
    document.getElementById('confirmTime').textContent = timeSelect.value;
    
    new bootstrap.Modal(document.getElementById('confirmModal')).show();
});

function submitForm() {
    document.getElementById('editBookingForm').submit();
}

function loadAvailableTimes() {
    const dateInput = document.getElementById('newDateInput');
    const timeSelect = document.getElementById('newTimeSelect');
    const helpText = document.getElementById('timeHelpText');
    const selectedDate = dateInput.value;
    
    if (!selectedDate) {
        timeSelect.innerHTML = '<option value="">-- Select date first --</option>';
        timeSelect.disabled = true;
        helpText.textContent = 'Please select a date to see available times';
        return;
    }
    
    timeSelect.innerHTML = '<option value="">Loading available times...</option>';
    timeSelect.disabled = true;
    helpText.textContent = 'Checking availability...';
    
    fetch('${pageContext.request.contextPath}/BookingController?action=getBookedTimes&date=' + selectedDate)
        .then(response => response.json())
        .then(bookedTimes => {
            timeSelect.innerHTML = '<option value="">Choose time...</option>';
            
            let availableCount = 0;
            timeSlots.forEach(slot => {
                const option = document.createElement('option');
                option.value = slot.value;
                
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
            timeSelect.innerHTML = '<option value="">Choose time...</option>';
            timeSlots.forEach(slot => {
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

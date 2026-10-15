<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Confirm Booking</title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/general.css" rel="stylesheet">
</head>
<body>
<div class="body-wrapper">
    <%@ include file="/WEB-INF/include/header.jsp" %>

    <main class="container py-5">
        <div class="mx-auto" style="max-width: 760px;">
            <h2 class="text-center mb-4">Confirm Your Booking</h2>

            <c:if test="${param.error == 'already-booked'}">
                <div class="alert alert-danger text-center">The room is no longer available for the selected dates.</div>
            </c:if>
            <c:if test="${param.error == 'invalid-payment-option'}">
                <div class="alert alert-danger text-center">Please choose a valid initial payment option: 10%, 20%, or 100%.</div>
            </c:if>
            <c:if test="${param.error == 'invalid-guests'}">
                <div class="alert alert-danger text-center">Please enter a valid number of guests.</div>
            </c:if>
            <c:if test="${param.error == 'create-failed'}">
                <div class="alert alert-danger text-center">The booking could not be created. Please search again and retry.</div>
            </c:if>

            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-body p-4">
                    <h5 class="mb-3">Room #${room.roomNumber} - ${room.roomType.name}</h5>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6"><strong>Check-in:</strong> ${checkInDate}</div>
                        <div class="col-md-6"><strong>Check-out:</strong> ${checkOutDate}</div>
                        <div class="col-md-6"><strong>Price/night:</strong> $<span id="pricePerNight">${room.roomType.pricePerNight}</span></div>
                        <div class="col-md-6"><strong>Capacity:</strong> ${room.roomType.capacity}</div>
                    </div>

                    <form action="${pageContext.request.contextPath}/booking" method="post">
                        <input type="hidden" name="room-number" value="${room.roomNumber}">

                        <div class="mb-3">
                            <label for="guest-count" class="form-label fw-semibold">Guests</label>
                            <input id="guest-count" name="guest-count" type="number" min="1" max="${room.roomType.capacity}" value="1" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label for="special-request" class="form-label fw-semibold">Special Request <span class="text-muted">(optional)</span></label>
                            <textarea id="special-request" name="special-request" class="form-control" rows="3" maxlength="1000"></textarea>
                        </div>

                        <div class="mb-4">
                            <label for="prepayment-percent" class="form-label fw-semibold">Initial Payment</label>
                            <select id="prepayment-percent" name="prepayment-percent" class="form-select" required>
                                <option value="10">Pay 10% now</option>
                                <option value="20">Pay 20% now</option>
                                <option value="100">Pay 100% now</option>
                            </select>
                            <div class="form-text">After a 10% or 20% payment, you can pay the remaining balance from Booking History.</div>
                        </div>

                        <div class="border rounded-3 p-3 mb-4 bg-light">
                            <div class="d-flex justify-content-between"><span>Total:</span><strong>$<span id="totalAmount">0.00</span></strong></div>
                            <div class="d-flex justify-content-between"><span>Pay now:</span><strong class="text-success">$<span id="payNowAmount">0.00</span></strong></div>
                            <div class="d-flex justify-content-between"><span>Remaining after payment:</span><strong>$<span id="remainingAmount">0.00</span></strong></div>
                        </div>

                        <button type="submit" class="btn btn-lg w-100 text-white" style="background-color:#b29575;">Create Booking & Continue to Payment</button>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/include/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    const checkIn = new Date('${checkInDate}T00:00:00');
    const checkOut = new Date('${checkOutDate}T00:00:00');
    const price = Number('${room.roomType.pricePerNight}');
    const select = document.getElementById('prepayment-percent');
    const nights = Math.max(0, Math.round((checkOut - checkIn) / 86400000));
    const total = Number.isFinite(price) ? price * nights : 0;

    function money(value) { return Number(value).toFixed(2); }
    function refresh() {
        const percent = Number(select.value);
        const payNow = total * percent / 100;
        document.getElementById('totalAmount').textContent = money(total);
        document.getElementById('payNowAmount').textContent = money(payNow);
        document.getElementById('remainingAmount').textContent = money(Math.max(0, total - payNow));
    }
    select.addEventListener('change', refresh);
    refresh();
})();
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Payment</title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/general.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="body-wrapper">
    <%@ include file="/WEB-INF/include/header.jsp" %>
    <main class="d-flex justify-content-center py-5" style="min-height:90vh;">
        <div class="bg-white shadow rounded-4 p-4 p-md-5" style="width:100%;max-width:760px;">
            <h2 class="text-center mb-4">Confirm Your Payment</h2>

            <c:if test="${param.error == 'invalid-discount'}"><div class="alert alert-danger text-center">The promotion code is invalid, unavailable, or can only be used on the first payment.</div></c:if>
            <c:if test="${param.error == 'invalid-method'}"><div class="alert alert-danger text-center">Please select a valid payment method.</div></c:if>
            <c:if test="${param.error == 'invalid-payment-percent'}"><div class="alert alert-danger text-center">Please select 10%, 20%, or 100% for the first payment.</div></c:if>
            <c:if test="${param.error == 'payment-failed'}"><div class="alert alert-danger text-center">Payment could not be completed. Please try again.</div></c:if>

            <div class="border rounded-3 p-3 mb-4">
                <h5>Booking #${booking.id}</h5>
                <p class="mb-1"><strong>Status:</strong> ${booking.status}</p>
                <p class="mb-1"><strong>Booking total:</strong> $${booking.totalPrice}</p>
                <p class="mb-1"><strong>Already paid:</strong> $${paidAmount}</p>
                <p class="mb-0"><strong>Remaining:</strong> <span class="text-danger fw-bold">$${remainingAmount}</span></p>
            </div>

            <c:forEach var="detail" items="${booking.details}">
                <div class="border rounded-3 p-3 mb-3">
                    <div class="row g-2">
                        <div class="col-md-6"><strong>Room:</strong> #${detail.roomNumber}</div>
                        <div class="col-md-6"><strong>Guests:</strong> ${detail.guestCount}</div>
                        <div class="col-md-6"><strong>Check-in:</strong> ${detail.checkInDate}</div>
                        <div class="col-md-6"><strong>Check-out:</strong> ${detail.checkOutDate}</div>
                    </div>
                </div>
            </c:forEach>

            <form action="${pageContext.request.contextPath}/payment" method="post">
                <input type="hidden" name="bookingId" value="${booking.id}">

                <c:if test="${firstPayment}">
                    <div class="mb-4">
                        <label for="payment-percent" class="form-label fw-semibold">Initial payment percentage</label>
                        <select id="payment-percent" name="payment-percent" class="form-select form-select-lg" required>
                            <option value="10" ${selectedPercent == 10 ? 'selected' : ''}>10%</option>
                            <option value="20" ${selectedPercent == 20 ? 'selected' : ''}>20%</option>
                            <option value="100" ${selectedPercent == 100 ? 'selected' : ''}>100%</option>
                        </select>
                        <div class="form-text">This is the first payment for the booking.</div>
                    </div>
                </c:if>

                <c:if test="${!firstPayment}">
                    <div class="alert alert-info">This payment will settle the full remaining balance of <strong>$${remainingAmount}</strong>.</div>
                </c:if>

                <div class="mb-4">
                    <label for="payment-method" class="form-label fw-semibold">Payment Method</label>
                    <select id="payment-method" name="payment-method" class="form-select form-select-lg" required>
                        <option value="">-- Select payment method --</option>
                        <option value="cash">Cash</option>
                        <option value="bank_transfer">Bank Transfer</option>
                        <option value="credit_card">Credit Card</option>
                        <option value="e_wallet">E-Wallet</option>
                    </select>
                </div>

                <c:if test="${firstPayment}">
                    <div class="mb-4">
                        <label for="discount-code" class="form-label fw-semibold">Promotion Code <span class="text-muted">(optional)</span></label>
                        <input type="text" id="discount-code" name="discount-code" class="form-control form-control-lg" maxlength="50" placeholder="Enter promotion code">
                    </div>

                    <c:if test="${not empty promotions}">
                        <div class="border rounded-3 p-3 mb-4">
                            <h6 class="fw-bold mb-3">Available Promotions</h6>
                            <c:forEach var="promotion" items="${promotions}">
                                <div class="mb-2"><strong>${promotion.code}</strong> - ${promotion.saleOff}% off
                                    <c:if test="${promotion.minimumAmount != null}"> | Minimum: $${promotion.minimumAmount}</c:if>
                                    <c:if test="${promotion.maximumDiscount != null}"> | Max discount: $${promotion.maximumDiscount}</c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:if>

                <button type="submit" class="btn btn-lg w-100 text-white" style="background-color:#b29575;">
                    <c:choose><c:when test="${firstPayment}">Confirm Initial Payment</c:when><c:otherwise>Pay Remaining Balance</c:otherwise></c:choose>
                </button>
            </form>
        </div>
    </main>
    <%@ include file="/WEB-INF/include/footer.jsp" %>
</div>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>

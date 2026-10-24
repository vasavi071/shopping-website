<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Checkout" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<h3 class="mb-4"><i class="bi bi-credit-card"></i> Checkout</h3>
<div class="row g-4">
  <div class="col-lg-7">
    <div class="card shadow-sm">
      <div class="card-body">
        <h5 class="card-title">Delivery details</h5>
        <form method="post" action="${pageContext.request.contextPath}/checkout" class="needs-validation" novalidate>
          <div class="mb-3">
            <label class="form-label">Name</label>
            <input class="form-control" value="<c:out value='${sessionScope.user.name}'/>" disabled>
          </div>
          <div class="mb-3">
            <label for="address" class="form-label">Delivery address</label>
            <textarea id="address" name="address" class="form-control" rows="3" minlength="10" required
                      placeholder="House no, street, city, state, PIN"></textarea>
            <div class="invalid-feedback">Please enter a complete address (at least 10 characters).</div>
          </div>
          <div class="mb-3">
            <label class="form-label">Payment method</label>
            <div class="form-check"><input class="form-check-input" type="radio" checked id="cod"><label class="form-check-label" for="cod">Cash on Delivery</label></div>
          </div>
          <button class="btn btn-warning btn-lg w-100" type="submit">Place order</button>
        </form>
      </div>
    </div>
  </div>
  <div class="col-lg-5">
    <div class="card shadow-sm">
      <div class="card-body">
        <h5 class="card-title">Your items</h5>
        <ul class="list-group list-group-flush">
          <c:forEach var="entry" items="${sessionScope.cart}">
            <li class="list-group-item d-flex justify-content-between px-0">
              <span><c:out value="${entry.value.name}"/> <small class="text-muted">&times; ${entry.value.quantity}</small></span>
              <span><fmt:formatNumber value="${entry.value.subtotal}" type="currency" currencySymbol="₹" maxFractionDigits="0"/></span>
            </li>
          </c:forEach>
          <li class="list-group-item d-flex justify-content-between px-0 fw-bold fs-5">
            <span>Total</span>
            <span><fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₹" maxFractionDigits="0"/></span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

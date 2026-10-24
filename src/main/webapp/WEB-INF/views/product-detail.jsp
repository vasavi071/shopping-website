<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${product.name}" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Products</a></li>
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products?category=<c:out value='${product.category}'/>"><c:out value="${product.category}"/></a></li>
    <li class="breadcrumb-item active"><c:out value="${product.name}"/></li>
  </ol>
</nav>

<div class="row g-4">
  <div class="col-md-6">
    <img src="<c:out value='${product.imageUrl}'/>" class="img-fluid rounded shadow-sm w-100" alt="<c:out value='${product.name}'/>">
  </div>
  <div class="col-md-6">
    <h2><c:out value="${product.name}"/></h2>
    <p class="text-muted"><c:out value="${product.description}"/></p>
    <div class="display-6 text-success fw-bold mb-3">
      <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
    </div>
    <c:choose>
      <c:when test="${product.stock > 0}">
        <p><span class="badge text-bg-success">In stock</span>
           <c:if test="${product.stock <= 10}"><small class="text-danger ms-2">Only ${product.stock} left!</small></c:if></p>
        <form method="post" action="${pageContext.request.contextPath}/cart" class="d-flex gap-2 align-items-center">
          <input type="hidden" name="action" value="add">
          <input type="hidden" name="id" value="${product.id}">
          <input type="number" name="quantity" class="form-control qty-input" value="1" min="1" max="${product.stock}" style="max-width:100px">
          <button class="btn btn-warning btn-lg" type="submit"><i class="bi bi-cart-plus"></i> Add to cart</button>
        </form>
      </c:when>
      <c:otherwise><span class="badge text-bg-secondary fs-6">Out of stock</span></c:otherwise>
    </c:choose>
  </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Products" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="hero rounded-3 p-4 p-md-5 mb-4 text-white">
  <h1 class="display-6 fw-bold">Great deals, delivered to your door</h1>
  <p class="lead mb-0">Browse electronics, fashion, home essentials, sports gear and books.</p>
</div>

<div class="d-flex flex-wrap gap-2 mb-4">
  <a href="${pageContext.request.contextPath}/products?q=<c:out value='${q}'/>"
     class="btn btn-sm ${empty selectedCategory ? 'btn-dark' : 'btn-outline-dark'}">All</a>
  <c:forEach var="cat" items="${categories}">
    <a href="${pageContext.request.contextPath}/products?category=<c:out value='${cat}'/>&q=<c:out value='${q}'/>"
       class="btn btn-sm ${cat == selectedCategory ? 'btn-dark' : 'btn-outline-dark'}"><c:out value="${cat}"/></a>
  </c:forEach>
</div>

<c:if test="${empty products}">
  <div class="text-center text-muted py-5">
    <i class="bi bi-emoji-frown display-4"></i>
    <p class="mt-3">No products found. Try a different search.</p>
  </div>
</c:if>

<div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-4">
  <c:forEach var="p" items="${products}">
    <div class="col">
      <div class="card h-100 product-card shadow-sm">
        <a href="${pageContext.request.contextPath}/product?id=${p.id}">
          <img src="<c:out value='${p.imageUrl}'/>" class="card-img-top product-img" alt="<c:out value='${p.name}'/>">
        </a>
        <div class="card-body d-flex flex-column">
          <span class="badge text-bg-light align-self-start mb-2"><c:out value="${p.category}"/></span>
          <h6 class="card-title">
            <a class="text-decoration-none text-dark" href="${pageContext.request.contextPath}/product?id=${p.id}">
              <c:out value="${p.name}"/></a>
          </h6>
          <div class="mt-auto">
            <div class="fs-5 fw-bold text-success mb-2">
              <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
            </div>
            <c:choose>
              <c:when test="${p.stock > 0}">
                <form method="post" action="${pageContext.request.contextPath}/cart">
                  <input type="hidden" name="action" value="add">
                  <input type="hidden" name="id" value="${p.id}">
                  <button class="btn btn-warning w-100" type="submit"><i class="bi bi-cart-plus"></i> Add to cart</button>
                </form>
              </c:when>
              <c:otherwise><button class="btn btn-secondary w-100" disabled>Out of stock</button></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>
  </c:forEach>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Login" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>

<div class="row justify-content-center">
  <div class="col-md-6 col-lg-4">
    <div class="card shadow-sm">
      <div class="card-body p-4">
        <h4 class="mb-3 text-center">Login</h4>
        <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/></div></c:if>
        <form method="post" action="${pageContext.request.contextPath}/login" class="needs-validation" novalidate>
          <input type="hidden" name="next" value="<c:out value='${next}'/>">
          <div class="mb-3">
            <label class="form-label" for="email">Email</label>
            <input type="email" class="form-control" id="email" name="email" value="<c:out value='${email}'/>" required>
            <div class="invalid-feedback">Enter a valid email.</div>
          </div>
          <div class="mb-3">
            <label class="form-label" for="password">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
            <div class="invalid-feedback">Enter your password.</div>
          </div>
          <button class="btn btn-warning w-100" type="submit">Login</button>
        </form>
        <p class="text-center mt-3 mb-0">New here? <a href="${pageContext.request.contextPath}/register">Create an account</a></p>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

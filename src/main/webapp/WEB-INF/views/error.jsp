<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Error" scope="request"/>
<jsp:include page="/WEB-INF/views/includes/header.jsp"/>
<div class="text-center py-5">
  <i class="bi bi-exclamation-triangle display-3 text-warning"></i>
  <h3 class="mt-3">Oops, something went wrong</h3>
  <p class="text-muted">The page you requested could not be shown. Please check that MySQL is running and the database is set up.</p>
  <a href="${pageContext.request.contextPath}/products" class="btn btn-warning">Back to shop</a>
</div>
<jsp:include page="/WEB-INF/views/includes/footer.jsp"/>

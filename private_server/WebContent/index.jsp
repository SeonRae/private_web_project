<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
    
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	
    <%
	request.setCharacterEncoding("UTF-8");
	%>
	
	<%-- 세션값을 loginId 변수에 저장 --%>
	<c:set var="loginId" value="${sessionScope.loginId}"/>
	
	<%-- 회원 정보 수정 알림창 변수 --%>
	<c:set var="modifyInfo" value="${requestScope.modifyInfo}"></c:set>
	
<!DOCTYPE html>
<html>
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- CSS only -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
        
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"
        integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
    <!-- JavaScript Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW"
        crossorigin="anonymous"></script>
        
</head>
<body>

	<%-- 비밀번호 일치 알림창 --%>
	<c:if test="${modifyInfo == 'success'}">
		<script>
			alert("내 정보 수정 완료");
		</script>
	</c:if>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.html">Navbar</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="index.html">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Link</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            게시판
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="/board/boardList">자유 게시판</a></li>
                            <li><a class="dropdown-item" href="#">Another action</a></li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="#">Something else here</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
                    </li>
                </ul>
                
                <c:choose>
                	<%-- 비로그인 --%>
                	<c:when test="${loginId == null}">
		                <ul class=" navbar-nav d-flex">
		                    <li class="nav-item">
		                        <a class="nav-link" href="/member/register">회원가입</a>
		                    </li>
		                    <li class="nav-item">
								<a class="nav-link" href="/member/login">로그인</a>
		                    </li>
		                </ul>
	                </c:when>
	                
	                <%-- 로그인 --%>
	                <c:otherwise>
		                <ul class=" navbar-nav d-flex">
		                    <li class="nav-item">
		                        <a class="nav-link" href="/member/myinfo">내정보</a>
		                    </li>
		                    <li class="nav-item">
								<a class="nav-link" href="/member/logout">로그아웃</a>
		                    </li>
		                </ul>
	                </c:otherwise>
                </c:choose>
                
            </div>
        </div>
    </nav>

    <div class="container"></div>
    <h3>Basic Navbar Example</h3>
    <p>A navigation bar is a navigation header that is placed at the top of the page.</p>
    </div>


</body>
</html>
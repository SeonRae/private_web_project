<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	request.setCharacterEncoding("UTF-8");
%>

<c:set var="loginId" value="${sessionScope.loginId}"/>

<%-- 현재 페이지의 게시글 10개 --%>
<c:set var="articlesList" value="${articlesMap.articlesList}"/>

<%-- 전체글 수 --%>
<c:set var="totArticles" value="${articlesMap.totArticles}"/>

<%-- 현재 페이지 숫자 --%>
<c:set var="pageNum" value="${articlesMap.pageNum}"/>

<%-- 10페이지 단위 --%>
<c:set var="section" value="${articlesMap.section}"/>

<!DOCTYPE html>
<html>
<head>
<title>게시판</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- CSS only -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1"
	crossorigin="anonymous">
	
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"
		integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0="
		crossorigin="anonymous"></script>
	<!-- JavaScript Bundle with Popper -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW"
		crossorigin="anonymous"></script>

	<style>
	.cls1 {
		text-decoration: none;
	}
	
	.cls2 {
		text-align: center;
		font-size: 20px;
	}
	
	.cls3 {
		text-align: right;
		font-size: 20px;
	}
	
	.no-uline {
		text-decoration: none;
	}
	
	.sel-page {
		text-decoration: none;
		color: red;
	}
	</style>

</head>

<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="index.html">Navbar</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item"><a class="nav-link active"
						aria-current="page" href="index.html">Home</a></li>
					<li class="nav-item"><a class="nav-link" href="#">Link</a></li>
					<li class="nav-item dropdown"><a
						class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
						role="button" data-bs-toggle="dropdown" aria-expanded="false">
							게시판 </a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<li><a class="dropdown-item" href="board.html">자유 게시판</a></li>
							<li><a class="dropdown-item" href="#">Another action</a></li>
							<li>
								<hr class="dropdown-divider">
							</li>
							<li><a class="dropdown-item" href="#">Something else
									here</a></li>
						</ul></li>
					<li class="nav-item"><a class="nav-link disabled" href="#"
						tabindex="-1" aria-disabled="true">Disabled</a></li>
				</ul>

				<c:choose>
					<%-- 비로그인 --%>
					<c:when test="${loginId == null}">
						<ul class=" navbar-nav d-flex">
							<li class="nav-item"><a class="nav-link"
								href="/member/register">회원가입</a></li>
							<li class="nav-item"><a class="nav-link" href="/member/login">로그인</a>
							</li>
						</ul>
					</c:when>

					<%-- 로그인 --%>
					<c:otherwise>
						<ul class=" navbar-nav d-flex">
							<li class="nav-item"><a class="nav-link"
								href="/member/myinfo">내정보</a></li>
							<li class="nav-item"><a class="nav-link"
								href="/member/logout">로그아웃</a></li>
						</ul>
					</c:otherwise>
				</c:choose>

			</div>
		</div>
	</nav>

	<div class="container">
		<h1 class="mt-4 mb-4">자유 게시판</h1>
		<table class="table table-hover">
		
			<thead>
				<tr>
					<th scope="col" class="col-1">글번호</th>
					<th scope="col" class="col-1">말머리</th>
					<th scope="col" class="col-4">글제목</th>
					<th scope="col" class="col-1">작성자</th>
					<th scope="col" class="col-1">작성일</th>
					<th scope="col" class="col-1">조회수</th>
					<th scope="col" class="col-1">추천수</th>
				</tr>
			</thead>
			
			<tbody>
				<c:choose>
					<%-- 등록된 글이 없을때 --%>
					<c:when test="${articlesList==null}">
						<tr>
							<td colspan="4">
								<b>등록된 글이 없습니다</b>
							</td>
						</tr>
					</c:when>
					
					<%-- 등록된 글이 있을때 --%>
					<c:when test="${articlesList !=null }">
						<c:forEach var="article" items="${articlesList }">
							<tr>
								<th scope="row">${article.boardCode}</th>
								<td>${article.boardCategory}</td>
								<td>
									<a class='cls1' href="/board/viewArticle?boardCode=${article.boardCode}">${article.boardTitle}</a>
								</td>
								<td>${article.memNick}</td>
								<td><fmt:formatDate value="${article.boardWriteDate}" /></td>
								<td>${article.boardViews}</td>
								<td>추천수</td>
							</tr>
						</c:forEach>
					</c:when>
				</c:choose>
			</tbody>
			
		</table>
		
		<a class="cls1" href="/board/articleForm">
			<p class="cls3">글쓰기</p>
		</a>
		
		<hr>
		
		<div class="cls2">
			<c:if test="${totArticles != null }">
				<c:choose>
					<c:when test="${totArticles >100 }">
						<!-- 글 개수가 100 초과인경우 -->
						<c:forEach var="page" begin="1" end="10" step="1">
						
							<c:if test="${section >1 && page==1 }">
								<a class="no-uline"
									href="${contextPath }/board/boardList?section=${section-1}&pageNum=${(section-1)*10 +1 }">
									&nbsp;이전</a>
							</c:if>
							
							<a class="no-uline"
								href="${contextPath }/board/boardList?section=${section}&pageNum=${page}">${(section-1)*10 +page }
							</a>
							
							<c:if test="${page ==10 }">
								<a class="no-uline"
									href="${contextPath }/board/boardList?section=${section+1}&pageNum=${section*10+1}">
									&nbsp;다음</a>
							</c:if>
							
						</c:forEach>
						
					</c:when>
					
					<c:when test="${totArticles ==100 }">
						<%-- 등록된 글 개수가 100개인경우 --%>
						<c:forEach var="page" begin="1" end="10" step="1">
							<a class="no-uline" href="#">${page } </a>
						</c:forEach>
					</c:when>
	
					<c:when test="${totArticles< 100 }">
						<%-- 등록된 글 개수가 100개 미만인 경우 --%>
						
						<c:forEach var="page" begin="1" end="${totArticles/10 +1}" step="1">
							<c:choose>
							
								<c:when test="${page==pageNum }">
									<a class="sel-page"
										href="${contextPath }/board/lboardList?section=${section}&pageNum=${page}">${page }
									</a>
								</c:when>
								
								<c:otherwise>
									<a class="no-uline"
										href="${contextPath }/board/boardList?section=${section}&pageNum=${page}">${page }
									</a>
								</c:otherwise>
								
							</c:choose>
						</c:forEach>
						
					</c:when>
				</c:choose>
			</c:if>
		</div>
	</div>

</body>

</html>
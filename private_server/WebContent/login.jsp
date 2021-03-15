<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	request.setCharacterEncoding("UTF-8");
%>

<c:set var="loginFailed" value="${requestScope.loginFailed}" />
<c:set var="id" value="${requestScope.id}" />

<!DOCTYPE html>
<html>
<head>
<title>로그인창</title>
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
		.fontColorRed {
			color:red;
		}
	</style>

	<c:choose>
		<%-- 아이디 불일치 경고창 --%>
		<c:when test="${loginFailed == 'id'}">
			<script>
				$(document).ready(function() {
					$("#idHelp").text("존재하지 않는 아이디입니다");
					$("#idHelp").addClass("fontColorRed");
					$("#userId").focus();
				});
			</script>
		</c:when>
		
		<%-- 비밀번호 불일치 경고창 --%>
		<c:when test="${loginFailed == 'pw'}">
			<script>
				$(document).ready(function() {
					$("#pwHelp").text("비밀번호가 틀렸습니다");
					$("#pwHelp").addClass("fontColorRed");
					$("#userPw").focus();
				});
			</script>
		</c:when>
	</c:choose>
	
	<script>
		$(document).ready(function() {
			
			/* 공백 검사 */
			$("#loginForm").on("submit" ,function() {
				if($("#userId").val()==null || $("#userId").val()==""){
					$("#idHelp").text("아이디를 입력하세요");
					$("#idHelp").addClass("fontColorRed");
					$("#userId").focus();
					return false;
				}else if($("#userPw").val()==null || $("#userPw").val()==""){
					$("#pwHelp").text("비밀번호를 입력하세요");
					$("#pwHelp").addClass("fontColorRed");
					$("#userPw").focus();
					return false;
				}
			});
			
			/* input 값 변경 실시간 감지 */
			$("#userId").on("propertychange change keyup paste input", function() {
				$("#idHelp").text("");
				$("#idHelp").removeClass("fontColorRed");
			});
			$("#userPw").on("propertychange change keyup paste input", function() {
				$("#pwHelp").text("");
				$("#pwHelp").removeClass("fontColorRed");
			});
			
		});
	</script>

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

				<ul class=" navbar-nav d-flex">
					<li class="nav-item"><a class="nav-link"
						href="/member/register">회원가입</a></li>
					<li class="nav-item"><a class="nav-link" href="/member/login">로그인</a>
					</li>
				</ul>

			</div>
		</div>
	</nav>

	<div class="container">
		<h1 class="mt-4 mb-4">로그인</h1>
		<form id="loginForm" method="post" action="/member/loginRequest">
				<div class="row align-items-start">
					<div class="col-auto">
						<label for="userId" class="form-label">아이디&nbsp;:&nbsp;</label> 
					</div>
					<div class="col-auto">
						<input type="text" class="form-control" id="userId" name="userId" 
							autofocus="autofocus" value="${id}" aria-describedby="idHelp">
						<div id="idHelp" class="form-text"></div>
					</div>
				</div>

			<div class="mb-4">
				<div class="row align-items-start">
					<div class="col-auto">
						<label for="userPw" class="form-label">비밀번호&nbsp;:&nbsp;</label>
					</div>
					<div class="col-auto">
						<input type="password" class="form-control" id="userPw" name="userPw" aria-describedby="pwHelp">
						<div id="pwHelp" class="form-text"></div>
					</div>
				</div>
			</div>

			<hr>

			<div class="mb-4">
				<input type="submit" class="btn btn-primary" value="로그인" /> <input
					type="reset" class="btn btn-primary" value="다시입력" /> <input
					type="button" class="btn btn-primary" value="뒤로가기"
					onclick="history.go(-1);" />
			</div>
		</form>
	</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	request.setCharacterEncoding("UTF-8");
%>
	
<!DOCTYPE html>
<html>
<head>
<title>회원가입창</title>
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

	<script type="text/javascript">
		
		var idCheck = null;
		
		/* 아이디 중복체크 */
		function fnCheckId(){
			var userId = $("#userId").val();
			if (userId == "") {
				$("#idHelp").text("아이디를 입력하세요");
				$("#idHelp").addClass("text-danger");
				$("#userId").focus();
				return;
			}
			
			$.ajax({
				type : "post",
				async : false,
				url : "http://localhost:8085/checkId",	//서블릿 호출
				dataType : "text",
				data : {
					id : userId
				},
				success : function(data, textStatus) {
					if (data == "usable") {
						$("#idCheckHelp").text("사용 가능한 아이디");
						$("#idCheckHelp").removeClass("text-danger");
						$("#idCheckHelp").addClass("text-success");
						idCheck = true;
					} else {
						$("#idCheckHelp").text("이미 사용중인 아이디");
						$("#idCheckHelp").removeClass("text-success");
						$("#idCheckHelp").addClass("text-danger");
						$("#idCheckBtn").focus();
						idCheck = false;
					}
				}
			});
			
			$.ajaxSetup({
			    error: function(jqXHR, exception) {
			        if (jqXHR.status === 0) {
			            alert('Not connect.\n Verify Network.');
			        } 
			        else if (jqXHR.status == 400) {
			            alert('Server understood the request, but request content was invalid. [400]');
			        } 
			        else if (jqXHR.status == 401) {
			            alert('Unauthorized access. [401]');
			        } 
			        else if (jqXHR.status == 403) {
			            alert('Forbidden resource can not be accessed. [403]');
			        } 
			        else if (jqXHR.status == 404) {
			            alert('Requested page not found. [404]');
			        } 
			        else if (jqXHR.status == 500) {
			            alert('Internal server error. [500]');
			        } 
			        else if (jqXHR.status == 503) {
			            alert('Service unavailable. [503]');
			        } 
			        else if (exception === 'parsererror') {
			            alert('Requested JSON parse failed. [Failed]');
			        } 
			        else if (exception === 'timeout') {
			            alert('Time out error. [Timeout]');
			        } 
			        else if (exception === 'abort') {
			            alert('Ajax request aborted. [Aborted]');
			        } 
			        else {
			            alert('Uncaught Error.n' + jqXHR.responseText);
			        }
			    }
			});
		}
		
	</script>

	<script>
		$(document).ready(function() {
			
			/* 이메일 셀렉트 박스 이벤트 */
			$("#selectEmail").on("change", function() {
				if ($("#selectEmail option:selected").val() == "") {
					$("#userEmail2").val($("#selectEmail option:selected").val());
						$("#userEmail2").removeAttr('readonly');
						$("#userEmail2").focus();
				} else {
					$("#userEmail2").val($("#selectEmail option:selected").val());
					$("#userEmail2").attr('readonly','readonly');
				}
			});

			/* 폼태그 유효성 확인 */
			$("#regiForm").on("submit" ,function() {
				if($("#userId").val()==null || $("#userId").val()==""){
					$("#idHelp").text("아이디를 입력하세요");
					$("#idHelp").addClass("text-danger");
					$("#userId").focus();
					return false;
					
				}else if(idCheck == false || idCheck == null){
					$("#idCheckHelp").text("아이디 중복확인을 해주세요");
					$("#idCheckHelp").addClass("text-danger");
					$("#idCheckBtn").focus();
					return false;
					
				}else if($("#userPw1").val()==null || $("#userPw1").val()==""){
					$("#pw1Help").text("비밀번호를 입력하세요");
					$("#pw1Help").addClass("text-danger");
					$("#userPw1").focus();
					return false;
					
				}else if($("#userPw2").val()==null || $("#userPw2").val()==""){
					$("#pw2Help").text("비밀번호 확인을 입력하세요");
					$("#pw2Help").addClass("text-danger");
					$("#userPw2").focus();
					return false;
					
				}else if($("#userPw1").val()!=$("#userPw2").val()){
					$("#pw2Help").text("비밀번호가 서로 다릅니다");
					$("#pw2Help").addClass("text-danger");
					$("#userPw2").focus();
					return false;
					
				}else if($("#userNick").val()==null || $("#userNick").val()==""){
					$("#nickHelp").text("닉네임을 입력하세요");
					$("#nickHelp").addClass("text-danger");
					$("#userNick").focus();
					return false;
					
				}else if($("#userEmail1").val()==null || $("#userEmail1").val()==""){
					$("#email1Help").text("이메일을 입력하세요");
					$("#email1Help").addClass("text-danger");
					$("#userEmail1").focus();
					return false;
					
				}else if($("#userEmail2").val()==null || $("#userEmail2").val()==""){
					$("#email2Help").text("이메일을 입력하세요");
					$("#email2Help").addClass("text-danger");
					$("#userEmail2").focus();
					return false;
				}
			});
			
			/* input 값 변경 실시간 감지 */
			$("#userId").on("propertychange change keyup paste input", function() {
				$("#idHelp").text("영문+숫자 4~12글자, 첫문자 영어");
				$("#idHelp").removeClass("text-danger");
			});
			$("#userPw1").on("propertychange change keyup paste input", function() {
				$("#pw1Help").removeClass("text-danger");
				$("#pw1Help").text("영문+숫자 4~12글자");
			});
			$("#userPw2").on("propertychange change keyup paste input", function() {
				$("#pw2Help").text("");
				$("#pw2Help").removeClass("text-danger");
			});
			$("#userNick").on("propertychange change keyup paste input", function() {
				$("#nickHelp").text("");
				$("#nickHelp").removeClass("text-danger");
			});
			$("#userEmail1").on("propertychange change keyup paste input", function() {
				$("#email1Help").text("보유중인 이메일 아이디 입력");
				$("#email1Help").removeClass("text-danger");
			});
			$("#userEmail2").on("propertychange change keyup paste input", function() {
				$("#email2Help").text("");
				$("#email2Help").removeClass("text-danger");
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

		<h1 class="mt-4 mb-4">회원가입</h1>

		<form id="regiForm" method="post" action="/member/registerRequest">
			
			<%-- 아이디 영역 --%>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userId" class="form-label">아이디&nbsp;:&nbsp;</label>
				</div>
				
				<div class="col-auto">
					<input type="text" class="form-control" id="userId" name="userId" maxlength="12"
						autofocus="autofocus" aria-describedby="idHelp">
					<div id="idHelp" class="form-text">영문+숫자 4~12글자, 첫문자 영어</div>
				</div>
				&nbsp;
				<div class="col-auto">
					<%-- 버튼 클릭 시 함수(fnCheckId) 호출 --%>
					<input id="idCheckBtn" type="button" class="btn btn-primary" onclick="fnCheckId()" value="중복확인">
				</div>
				&nbsp;
				<div class="col-auto">
					<c:choose>
						<c:when test="${idCheck == true}" >
							<div id="idCheckHelp" class="form-text text-success">아이디 사용 가능</div>
						</c:when>
						<c:when test="${idCheck == false}" >
							<div id="idCheckHelp" class="form-text text-danger">이미 사용중인 아이디</div>
						</c:when>
						<c:otherwise>
							<div id="idCheckHelp" class="form-text"></div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			
			<br>
			<%-- 비밀번호 영역 --%>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userPw1" class="form-label">비밀번호&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="password" class="form-control" id="userPw1" name="userPw" maxlength="12"
						aria-describedby="pw1Help">
					<div id="pw1Help" class="form-text">영문+숫자 4~12글자</div>
				</div>
			</div>
	
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userPw2" class="form-label">비밀번호 확인&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="password" class="form-control" id="userPw2" maxlength="12" 
						aria-describedby="pw2Help">
					<div id="pw2Help" class="form-text"></div>
				</div>
			</div>

			<br>
			<%-- 닉네임 영역 --%>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userNick" class="form-label">닉네임&nbsp;:&nbsp;</label> 
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userNick" name="userNick"
						aria-describedby="nickHelp">
					<div id="nickHelp" class="form-text"></div>
				</div>
			</div>

			<br>
			<%-- 이메일 영역 --%>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userEmail1" class="form-label">이메일&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userEmail1"
						name="userEmail1" aria-describedby="email1Help">
					<div id="email1Help" class="form-text">보유중인 이메일 아이디 입력</div>
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userEmail2"
						name="userEmail2" aria-describedby="email2Help">
					<div id="email2Help" class="form-text"></div>
				</div>
				<div class="col-auto">
					<select class="form-select" id="selectEmail">
						<option value="">직접입력</option>
						<option value="google.com">구글</option>
						<option value="naver.com">네이버</option>
						<option value="daum.net">다음</option>
					</select>
				</div>
			</div>

			<br>
			<hr>
			<%-- 버튼 영역 --%>
			<div class="mb-4">
				<input type="submit" class="btn btn-primary" id="submit_btn" value="가입" /> <input
					type="reset" class="btn btn-primary" value="다시입력" /> <input
					type="button" class="btn btn-primary" value="뒤로가기"
					onclick="history.go(-1);" />
			</div>
		</form>
	</div>
</body>
</html>
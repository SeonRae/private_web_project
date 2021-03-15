<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	request.setCharacterEncoding("UTF-8");
%>
	<%-- 내 정보 받아옴 --%>
	<c:set var="myInfo" value="${requestScope.myInfo}"/>

	<%-- 회원 정보 수정 알림창 변수 --%>
	<c:set var="modifyInfo" value="${requestScope.modifyInfo}"></c:set>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보</title>
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
			$("#modiForm").on("submit" ,function() {
				if($("#userPw1").val()==null || $("#userPw1").val()==""){
					$("#pw1Help").text("비밀번호를 입력하세요");
					$("#pw1Help").addClass("text-danger");
					$("#userPw1").focus();
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
			$("#userPw1").on("propertychange change keyup paste input", function() {
				$("#pw1Help").removeClass("text-danger");
				$("#pw1Help").text("내 정보를 수정하기 위해선 비밀번호를 입력해야 합니다");
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

	<%-- 비밀번호 불일치 알림창 --%>
	<c:if test="${modifyInfo == 'fail'}">
		<script>
			alert("수정 실패\n비밀번호가 틀렸습니다");
		</script>
	</c:if>

	<div class="container">

		<h1 class="mt-4 mb-4">내 정보</h1>

		<form method="post" action="/member/modifyRequest" id="modiForm">
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userCode" class="form-label">회원번호&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
				
					<%-- disabled 속성은 form 전송시 데이터를 전달하지 않는다 --%>
					<input type="text" class="form-control" id="userCode" value="${myInfo.getCode()}" disabled="disabled">
				</div>
				&nbsp;
				<div class="col-auto">
					<label for="userDate" class="form-label">가입일&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userDate" value="${myInfo.getJoinDate()}" disabled="disabled">
				</div>
			</div>
			
			<br>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userId" class="form-label">아이디&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userId" name="userId" value="${myInfo.getId()}" readonly="readonly">
				</div>
			</div>
						
			<br>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userNick" class="form-label">닉네임&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userNick" name="userNick" value="${myInfo.getNick()}">
				</div>
			</div>
			<br>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userPw1" class="form-label">비밀번호&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="password" class="form-control" id="userPw1" name="userPw"
						maxlength="12" aria-describedby="pw1Help">
					<div id="pw1Help" class="form-text">내 정보를 수정하기 위해선 비밀번호를 입력해야 합니다</div>
				</div>
			</div>

			<br>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="userEmail1" class="form-label">이메일&nbsp;:&nbsp;</label>
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userEmail1"
						name="userEmail1" aria-describedby="email1Help" value="${myInfo.getEmail1()}">
					<div id="email1Help" class="form-text"></div>
				</div>
				<div class="col-auto">
					<input type="text" class="form-control" id="userEmail2"
						name="userEmail2" aria-describedby="email2Help" value="${myInfo.getEmail2()}">
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
			<div class="mb-4">
				<input type="submit" class="btn btn-primary" id="submit_btn" value="수정하기" /> <input
					type="reset" class="btn btn-primary" value="원래대로" /> <input
					type="button" class="btn btn-primary" value="뒤로가기"
					onclick="history.go(-1);" />
			</div>
		</form>
	</div>
</body>
</html>
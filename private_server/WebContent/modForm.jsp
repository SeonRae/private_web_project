<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  request.setCharacterEncoding("UTF-8");
%> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글수정</title>

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

	function backToList(obj){
		obj.action="/board/boardList";
		obj.submit();
	}
	
	 function fn_modify_article(obj){
 		 // 게시글 수정 서블릿 요청
		 obj.action="/board/modArticle";
		 obj.submit();
	 }
	
	function readURL(input) {
		if (input.files && input.files[0]) {
			var reader = new FileReader();
			reader.onload = function (e) {
				//이미지 태그에에 src 속성 추가
				$('#preview').attr('src', e.target.result);
			}
			reader.readAsDataURL(input.files[0]);
		}
	}
	
	$(document).ready(function() {
		switch("${article.boardCategory}"){
		case "[일반]":
			$("#Category1").attr("selected", "selected");
		break;
		
		case "[질문]":
			$("#Category2").attr("selected", "selected");
		break;
		
		case "[공략]":
			$("#Category3").attr("selected", "selected");
		break;
		}
	});
	
</script>

</head>
<body>
	<div class="container mt-4 mb-4">
		<form action="/board/modArticle" name="modArticle" method="post" enctype="multipart/form-data">
			<input type="hidden" name="boardCode" value="${article.boardCode}">
			<div class="row align-items-start">
				<div class="col-auto">
					[작성자]
				</div>
				<div class="col-auto bg-secondary text-white">
					${article.memNick}
				</div>
			</div>
			<br>

			<div class="row align-items-start">
				<div class="col-auto">
					[말머리]
				</div>
				<div class="col-auto">
					<select class="form-select" id="boardCategory" name="boardCategory">
						<option id="Category1">[일반]</option>
						<option id="Category2">[질문]</option>
						<option id="Category3">[공략]</option>
					</select>
				</div>
			</div>

			<div class="row align-items-start">
				<div class="col-auto">
					<label for="boardTitle" class="form-label">[글제목]</label>
					<textarea type="text" id="boardTitle" name="boardTitle" class="form-control" 
						cols="150" rows="2" maxlength="500">${article.boardTitle}</textarea>
				</div>
			</div>
			<br>
			<hr>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="boardContent" class="form-label">[글내용]</label>
					<textarea class="form-control" id="boardContent" name="boardContent" 
						cols="150" rows="20" maxlength="4000">${article.boardContent}</textarea>
				</div>
			</div>
			<br>
			<hr>
			
			<%-- 게시글에 파일이 첨부되어 있을때 --%>
			<c:if test="${not empty article.boardFileName && article.boardFileName!='null' }">
				
				<div class="row align-items-start">
					<div class="col-auto">
						<input type="hidden" name="originalFileName" value="${article.boardFileName }" />
						
						<%-- 이미지 파일 다운로드 서블릿 호출 --%>
						<img src="/download?boardFileName=${article.boardFileName}&boardCode=${article.boardCode }"
							id="preview" />
					</div>
				</div>
				
				<div class="row align-items-start">
					<div class="col-auto">
						<input type="file" name="boardFileName" id="boardFileName"  onchange="readURL(this);" />
					</div>
				</div>
			</c:if>
			<br>
			<hr>

			<div class="mb-4">
				<input type="submit" class="btn btn-primary" value="글수정" /> 
				<input type="button" class="btn btn-secondary" value="취소" onclick="backToList(this.form)" />
			</div>
		</form>
	</div>
</body>
</html>
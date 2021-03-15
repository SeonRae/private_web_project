<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  request.setCharacterEncoding("UTF-8");
%> 

	<c:set var="memNick" value="${requestScope.memNick}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글작성</title>

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
	
</script>

</head>
<body>
	<div class="container mt-4 mb-4">
		<form action="/board/addArticle" name="formArticle" method="post" enctype="multipart/form-data">
			<div class="row align-items-start">
				<div class="col-auto">
					[작성자]
				</div>
				<div class="col-auto bg-secondary text-white">
					${memNick}
				</div>
			</div>
			<br>

			<div class="row align-items-start">
				<div class="col-auto">
					[말머리]
				</div>
				<div class="col-auto">
					<select class="form-select" id="boardCategory" name="boardCategory">
						<option>[일반]</option>
						<option>[질문]</option>
						<option>[공략]</option>
					</select>
				</div>
			</div>

			<div class="row align-items-start">
				<div class="col-auto">
					<label for="boardTitle" class="form-label">[글제목]</label>
					<textarea type="text" id="boardTitle" name="boardTitle" class="form-control" 
						cols="150" rows="2" maxlength="500"></textarea>
				</div>
			</div>
			<br>
			<hr>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="boardContent" class="form-label">[글내용]</label>
					<textarea class="form-control" id="boardContent" name="boardContent" 
						cols="150" rows="20" maxlength="4000"></textarea>
				</div>
			</div>
			<br>
			<hr>
			
			<div class="row align-items-start">
				<div class="col-auto">
					이미지파일 첨부&nbsp;:&nbsp;
					<%-- onchange="readURL(this) : input 태그의 상태가 변화했을때 자기 자신을 전달하여 함수 호출 --%>
					<input type="file" name="boardFileName"  onchange="readURL(this);" />
					<img id="preview" src="#" width=200 height=200/>
				</div>
			</div>
			<br>
			<hr>

			<div class="mb-4">
				<input type="submit" class="btn btn-primary" value="글등록" /> 
				<input type="button" class="btn btn-primary" value="취소" onclick="backToList(this.form)" />
			</div>
		</form>
	</div>
</body>
</html>
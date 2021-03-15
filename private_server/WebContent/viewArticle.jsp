<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
	request.setCharacterEncoding("UTF-8");
%>

<c:set var="loginId" value="${sessionScope.loginId}"/>

<%-- 게시글 정보 --%>
<c:set var="article" value="${article}"/>

<%-- 댓글 정보 --%>
<c:set var="articleComment" value="${articleComment}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 조회</title>

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

<style type="text/css">

	.modCommentBtnDiv{
		display:block;
	}

	.modCommentDiv{
		display:none;
	}
	
</style>

<script type="text/javascript">

	function backToList(obj){
		obj.action="/board/boardList";
		obj.submit();
	}
	 
 	 // 게시글 수정 버튼 클릭
 	 function fn_modify_article(obj, boardCode){
 		 // 게시글 수정 페이지 서블릿 요청
		 obj.action="/board/modForm?boardCode="+boardCode;
		 obj.submit();
	 }
	 
	 // 게시글 삭제 버튼 클릭
 	function fn_remove_article(url, boardCode){
		 
 		if(confirm("글을 삭제하시겠습니까?")){
 	 		var form = document.createElement("form");
 			form.setAttribute("method", "post");
 			form.setAttribute("action", url);
 			 
 		    var boardCodeInput = document.createElement("input");
 		    boardCodeInput.setAttribute("type","hidden");
 		    boardCodeInput.setAttribute("name","boardCode");
 		    boardCodeInput.setAttribute("value", boardCode);
 		     
 		    form.appendChild(boardCodeInput);
 		    document.body.appendChild(form);
 		    form.submit();
 		}else {
 			return false;
 		}
	}
 	// 댓글 등록 버튼 클릭
	function fn_add_comment(loginId, boardCode, url){
 		
		var commContent = $("#commentContent").val();
 		
		$.ajax({
			type : "post",
			async : false,
			url : "http://localhost:8085/addComment",	//서블릿 호출
			dataType : "text",
			data : {
				id : loginId,
				bCode : boardCode,
				cContent : commContent
			},
			success : function(data, textStatus) {
				alert("댓글 등록 완료");
				window.location.href = url;
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
 	
 	// 댓글을 수정 가능한 상태로 변경
	function fn_modify_comment_btn(commCode){
		
 		var modCommDiv = document.getElementById("modCommentDiv" + commCode);
		modCommDiv.style.display = "block";

		var modCommBtnDiv = document.getElementById("modCommentBtnDiv" + commCode);
		modCommBtnDiv.style.display = "none";
		
		var comm =  document.getElementById("commentContent" + commCode);
		comm.disabled = false;
		
 	}

 	// 댓글 수정 취소 버튼 클릭
 	function fn_modify_comment_cancel(commCode) {
		
 		var modCommDiv = document.getElementById("modCommentDiv" + commCode);
		modCommDiv.style.display = "none";

		var modCommBtnDiv = document.getElementById("modCommentBtnDiv" + commCode);
		modCommBtnDiv.style.display = "block";
		
		var comm =  document.getElementById("commentContent" + commCode);
		comm.disabled = true;
		
	}
 	
 	// 댓글 수정 하기 버튼 클릭
	function fn_modify_comment(commCode, url){
		
		var commContentTextarea = document.getElementById("commentContent" + commCode);
		var commContent = commContentTextarea.value;	// 수정된 댓글 값을 가져옴
		
		$.ajax({
			type : "post",
			async : false,
			url : "http://localhost:8085/modComment",	//서블릿 호출
			dataType : "text",
			data : {
				cCode : commCode,
				cContent : commContent
			},
			success : function(data, textStatus) {
				alert("댓글 수정 완료");
				window.location.href = url;
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
 	
	 // 댓글 삭제 버튼 클릭
 	function fn_remove_comment(url,commCode){
		 
 		if(confirm("댓글을 삭제하시겠습니까?")){
		     
		    // 데이터베이스에서 댓글 레코드 삭제
		    $.ajax({
				type : "post",
				async : false,
				url : "http://localhost:8085/removeComment",	//서블릿 호출
				dataType : "text",
				data : {
					code : commCode
				},
				success : function(data, textStatus) {
					alert("댓글 삭제 완료");
					window.location.href = url;
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
 		}else {
 			return false;
 		}
	 }
	 
	 function readURL(input) {
	     if (input.files && input.files[0]) {
	         var reader = new FileReader();
	         reader.onload = function (e) {
	             $('#preview').attr('src', e.target.result);
	         }
	         reader.readAsDataURL(input.files[0]);
	     }
	 }
	function a(loginId){
		alert(loginId);
	}
</script>

</head>
<body>
	<div class="container mt-4 mb-4">
		<form name="formViewArticle" method="post" enctype="multipart/form-data">
			<div class="row align-items-start">
				<div class="col-auto">
					[글번호]
				</div>
				<div class="col-auto bg-secondary text-white">
					${article.boardCode}
				</div>
				<input type="hidden" name="boardCode" value="${article.boardCode}">
				
				<div class="col-auto">
					[조회수]
				</div>
				<div class="col-auto bg-secondary text-white">
					${article.boardViews}
				</div>
				
				<div class="col-auto">
					[작성자]
				</div>
				<div class="col-auto bg-secondary text-white">
					${article.memNick}
				</div>
				<input type="hidden" name="memNick" value="${article.memNick}">
			</div>
			<br>
			<hr>
			
			<div class="row align-items-start">
				<div class="col-auto">
					[말머리]
				</div>
				<div class="col-auto bg-secondary text-white">
					${article.boardCategory}
				</div>
				<input type="hidden" name="boardCategory" value="${article.boardCategory}">
			</div>
			<br>
			<hr>

			<div class="row align-items-start">
				<div class="col-auto">
					<label for="boardTitle" class="form-label">[글제목]</label>
					<textarea type="text" id="boardTitle" name="boardTitle" class="form-control" 
						cols="150" rows="2" maxlength="500" disabled>${article.boardTitle}</textarea>
				</div>
			</div>
			<br>
			<hr>
			<div class="row align-items-start">
				<div class="col-auto">
					<label for="boardContent" class="form-label">[글내용]</label>
					<textarea class="form-control" id="boardContent" name="boardContent" 
						cols="150" rows="20" maxlength="4000" disabled>${article.boardContent}</textarea>
				</div>
			</div>
			<br>
			
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
						<input type="file" name="boardFileName" id="boardFileName" disabled onchange="readURL(this);" />
					</div>
				</div>
			</c:if>
			<br>
			<hr>
			
			<div class="row align-items-start">
				<div class="col-auto">
					[추천수]
				</div>
				<div class="col-auto bg-secondary text-white">
					추천수
				</div>
				<div class="col-auto">
					<input type="button" class="btn btn-success" value="추천">
				</div>
			</div>
			<br>
			<hr>
			
			<div class="row align-items-start">
				<div class="col-auto">
					<textarea class="form-control" cols="150" rows="2" maxlength="4000" id="commentContent"></textarea>
				</div>
				<div class="col-auto">
					<input type="button" class="btn btn-primary" value="댓글달기"
						onClick="fn_add_comment('${loginId}', ${article.boardCode}, '/board/viewArticle?boardCode=${article.boardCode}')">
				</div>
			</div>
			<br>
			<hr>
			<div id="commentDiv">
				<c:forEach var="item" items="${articleComment}">
					<div class="row align-items-start" id="commentId${item.commCode}">
						<input type="hidden" value="${item.commCode}">
						<div class="col-auto">
							<div class="col-auto bg-secondary text-white">
								${item.commMemNick}
							</div>
						</div>
						<div class="col-auto">
							<textarea cols="100" id="commentContent${item.commCode}" disabled="disabled">${item.commContent}</textarea>
						</div>
						<div class="col-auto bg-secondary text-white">
							${item.commWriteDate}
						</div>
						
						<c:if test="${loginId == item.memId}">
							<div class="col-auto modCommentBtnDiv" id="modCommentBtnDiv${item.commCode}">
									<input type="button" class="btn btn-warning" value="댓글수정"
										onclick="fn_modify_comment_btn(${item.commCode})">
							</div>
						
							<div class="col-auto modCommentDiv" id="modCommentDiv${item.commCode}">
									<input type="button" class="btn btn-primary" value="수정하기"
										onclick="fn_modify_comment(${item.commCode}, '/board/viewArticle?boardCode=${article.boardCode}')">
									<input type="button" class="btn btn-secondary" value="취소"
										onclick="fn_modify_comment_cancel(${item.commCode})">
							</div>
						
							<div class="col-auto">
									<input type="button" class="btn btn-danger" value="댓글삭제"
										onClick="fn_remove_comment('/board/viewArticle?boardCode=${article.boardCode}', ${item.commCode})">
								
							</div>
						</c:if>
					</div>
				</c:forEach>
			</div>
			<br>
			<hr>
			
			<div class="mb-4">
				<input type="submit" class="btn btn-primary" id="submit_btn" value="등록" /> 
				<c:if test="${loginId == article.memId}">
					<input type=button class="btn btn-warning" value="수정하기" onClick="fn_modify_article(this.form ,${article.boardCode })">
					<input type=button class="btn btn-danger" value="삭제하기"
						onClick="fn_remove_article('/board/removeArticle', ${article.boardCode})">
				</c:if>
				<input type="button" class="btn btn-secondary" value="뒤로가기" onclick="backToList(this.form)" />
			</div>
		</form>
	</div>
</body>
</html>
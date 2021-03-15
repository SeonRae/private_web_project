package board;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/removeComment")
public class RemoveComment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public RemoveComment() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}
	
	// 아이디 중복체크 요청 처리
	private void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
        
        String commCode = request.getParameter("code");	// 파라미터 전달받음
        
        BoardDAO boardDAO = new BoardDAO();
        boardDAO.deleteComment(Integer.parseInt(commCode));	// 댓글 삭제
	}
}

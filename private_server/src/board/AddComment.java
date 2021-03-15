package board;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addComment")
public class AddComment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AddComment() {
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
		
		BoardDAO boardDAO = new BoardDAO();
		// 파라미터 전달받음
		
		String memId = request.getParameter("id");	// 댓글 작성자 id

        int memCode = boardDAO.selectMemCode(memId);	// id로 code조회
        int boardCode = Integer.parseInt(request.getParameter("bCode"));
        String commContent = request.getParameter("cContent");

        boardDAO.insertComment(memCode, boardCode, commContent);	// 댓글 추가
	}
}

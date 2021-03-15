package board;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/modComment")
public class ModComment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ModComment() {
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
        int commCode = Integer.parseInt(request.getParameter("cCode"));
        String commContent = request.getParameter("cContent");

        System.out.println();
        System.out.println(commCode);
        System.out.println(commContent);
        
        boardDAO.updateComment(commCode, commContent);	// 댓글 수정
	}
}

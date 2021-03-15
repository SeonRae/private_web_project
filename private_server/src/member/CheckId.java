package member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/checkId")
public class CheckId extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public CheckId() {
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
		
		PrintWriter writer = response.getWriter();
        
        String checkedId = request.getParameter("id");	//파라미터 전달받음
        
        System.out.println("id = " + checkedId);
        MemberDAO memberDAO = new MemberDAO();
        boolean memberCheckId = memberDAO.checkId(checkedId);	//아이디 중복 체크 메소드 호출

        System.out.println("memberCheckId = " + memberCheckId);

        //데이터 넘김
        if (memberCheckId == true ) {
            writer.print("not_usable");
        }else {
            writer.print("usable");
        }
	}
}

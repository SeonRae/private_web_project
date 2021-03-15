package member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/member/*")
public class MemberController extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private MemberDAO memberDAO = new MemberDAO();

	public MemberController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	private void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String nextPage = null;
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		HttpSession session = null;

		String action = request.getPathInfo();
		System.out.println("action:" + action);

		// 로그인 페이지 이동
		if (action.equals("/login")) {
			nextPage = "/login.jsp";
		
		// 메인 페이지 이동
		}else if(action.equals("/index")) {
			nextPage = "/index.jsp";
			
		// 로그인 요청 처리
		} else if (action.equals("/loginRequest")) {
			String id = request.getParameter("userId");
			String pw = request.getParameter("userPw");
			int memberLogin = memberDAO.memberLogin(id, pw);
			
			if(memberLogin == 0) {	// 로그인 성공
				session = request.getSession();	
				session.setAttribute("loginId", id);	// 로그인 상태 유지를 위한 세션 설정
				nextPage = "/member/index";
				
			}else if(memberLogin == 1){		// 로그인 실패 (아이디 불일치)
				request.setAttribute("loginFailed", "id");	// 아이디 불일치 정보 전달
				nextPage = "/member/login";
				
			}else if(memberLogin == 2) {	// 로그인 실패 (비밀번호 불일치)
				request.setAttribute("loginFailed", "pw");	// 비밀번호 불일치 정보 전달
				request.setAttribute("id", id);	// 입력했던 아이디 값 전달
				nextPage = "/member/login";
			}

		// 로그아웃 요청 처리
		}else if(action.equals("/logout")) {
			session = request.getSession();
			session.removeAttribute("loginId");
			nextPage = "/member/index";
			
		// 회원 가입 페이지 이동
		}else if(action.equals("/register")) {
			nextPage = "/register.jsp";

		// 회원가입 요청 처리
		}else if(action.equals("/registerRequest")) {
			String id = request.getParameter("userId");	// 아이디
			String pw = request.getParameter("userPw");	// 비밀번호
			String name = request.getParameter("userNick");	// 닉네임
			String email1 = request.getParameter("userEmail1");// 이메일 앞부분
			String email2 = request.getParameter("userEmail2");	// 이메일 뒷부분
			
			//이메일 형식으로 설정
			String email = email1 + "@" + email2;	// 이메일
			
			MemberVO memberVO = new MemberVO(id, pw, name, email);
			memberDAO.registMember(memberVO);	// 회원가입 페이지에서 받아온 값으로 회원 추가
			
			nextPage = "/member/index";
		
		// 내 정보 페이지 이동
		}else if(action.equals("/myinfo")) {
			MemberVO myInfo = new MemberVO();
			
			// 로그인 된 아이디의 정보를 조회함
			session = request.getSession();
			String loginId = session.getAttribute("loginId").toString();
			
			myInfo = memberDAO.memberInfo(loginId);	// 회원 정보 객체 반환
			
			// 내 정보 페이지에 전달
			request.setAttribute("myInfo", myInfo);
			nextPage = "/myinfo.jsp";
			
		// 내 정보 수정 요청 처리
		}else if(action.equals("/modifyRequest")) {
			// 비밀번호가 일치한지 조회하기 위해 세션에서 아이디 받아옴
			session = request.getSession();
			String loginId = session.getAttribute("loginId").toString();
			
			// 입력한 비밀번호 받아옴
			String pw = request.getParameter("userPw");
			
			// 수정될 정보 받아옴
			String nick = request.getParameter("userNick");
			String email1 = request.getParameter("userEmail1");
			String email2 = request.getParameter("userEmail2");
			String email = email1 + "@" + email2;
			
			int modifyMember = memberDAO.modifyMember(loginId, pw, nick, email);
			
			if(modifyMember == 0) {		// 회원 정보 수정 완료
				request.setAttribute("modifyInfo", "success");	// 알림창
				nextPage = "/member/index";	// 메인 페이지로 이동
			}
			if(modifyMember == 1) {		// 회원 정보 수정 실패
				request.setAttribute("modifyInfo", "fail");	// 알림창
				nextPage = "/member/myinfo";	// 내정보 페이지로 이동
			}
		}
		
		// 포워딩
		RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
		dispatch.forward(request, response); 
	}
}

package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MemberDAO {
	private DataSource dataFactory;
	private Connection conn;
	private PreparedStatement pstmt;
	
	public MemberDAO() {
		try {
			Context ctx = new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory = (DataSource) envContext.lookup("jdbc/orcl");
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 로그인
	public int memberLogin(String id, String pw){
		
		int loginState = 0;
		
		try {
			conn = dataFactory.getConnection();
			
			String query = "select mem_id, mem_pw from MEMBERS_TB";
			System.out.println(query);
			pstmt = conn.prepareStatement(query);
			
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String memId = rs.getString("MEM_ID");
				String memPw = rs.getString("MEM_PW");
				
				if(memId.equals(id)) {	// 아이디 일치
					if(memPw.equals(pw)) {	// 비밀번호 일치
						return 0;
					}else {		// 비밀번호 불일치
						return 2;
					}
				}
			}
			
			pstmt.close();
			dataFactory.getConnection().close();
			conn.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("loginState = " + loginState);
		return 1;	// 아이디 불일치
	}
	
	// 회원 가입 아이디 중복체크
	public boolean checkId(String id){
		boolean result = false;
		
		try {
			conn = dataFactory.getConnection();
			
			String query = "select decode(count(*),1,'true','false') as result"
					+ " from MEMBERS_TB"
					+ " where MEM_ID = ?";
			System.out.println(query);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, id);
			
			ResultSet rs = pstmt.executeQuery();
			
			rs.next();
			
			result = Boolean.parseBoolean(rs.getString("result"));
			
			rs.close();
			pstmt.close();
			conn.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return result;	// 사용 가능한 아이디
	}
	
	// 회원 가입
	public void registMember(MemberVO m) {
		try {
			conn = dataFactory.getConnection();
			
			String id = m.getId();
			String pw = m.getPw();
			String name = m.getNick();
			String email = m.getEmail();
			String query = "INSERT into MEMBERS_TB"
					+ " (mem_code, mem_id, mem_pw, mem_nick, mem_email)"
					+ " values(MEMBERS_TB_SQ.nextval, ?, ?, ?, ?)";
			System.out.println(query);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			pstmt.setString(3, name);
			pstmt.setString(4, email);
			pstmt.executeUpdate();

			conn.commit();
			pstmt.close();
			conn.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 내 정보 조회
	public MemberVO memberInfo(String loginId){
		MemberVO memberVO = null;	// 회원 정보를 저장하는 객체
		try {
			conn = dataFactory.getConnection();
			
			// 로그인된 아이디의 정보 조회
			String query = "select mem_code, mem_id, mem_nick, mem_email, mem_date"
					+ " from MEMBERS_TB where mem_id = ?";
			System.out.println(query);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, loginId);
			
			ResultSet rs = pstmt.executeQuery();
			rs.next();	// 포인터를 첫번째로 이동
			
			int code = rs.getInt("mem_code");
			String id = rs.getString("mem_id");
			String nick = rs.getString("mem_nick");
			String email = rs.getString("mem_email");
			Date joinDate = rs.getDate("mem_date");
			
			// 이메일을 '@' 기호를 기준으로 분할
			// '@'기호의 인덱스를 찾는다
	        int idx = email.indexOf("@");
	        // 앞부분 추출
	        String email1 = email.substring(0, idx);
	        // 뒷부분을 추출
	        String email2 = email.substring(idx + 1);
	        
			// 회원의 정보로 객체 생성
			memberVO = new MemberVO(code, id, nick, email1, email2, joinDate);

			rs.close();
			pstmt.close();
			conn.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return memberVO;
	}
	
	// 회원 정보 수정
	public int modifyMember(String id, String pw, String nick, String email) {
		try {
			conn = dataFactory.getConnection();
			
			// 비밀번호 일치 여부 확인
			String query = "select mem_pw from MEMBERS_TB where mem_id = ?";
			System.out.println(query);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, id);
			
			ResultSet rs = pstmt.executeQuery();
			rs.next();
			if(!(rs.getString("mem_pw").equals(pw))) {	// 비밀번호 불일치
				return 1;
			}
			
			// 회원 정보 수정 쿼리
			query = "update MEMBERS_TB"
					+ " set mem_nick = ?, mem_email = ?"
					+ " where mem_id = ?";
			System.out.println(query);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, nick);
			pstmt.setString(2, email);
			pstmt.setString(3, id);
			pstmt.executeUpdate();
			
			conn.commit();
			rs.close();
			pstmt.close();
			conn.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	// 회원 목록 조회
//	public List<MemberVO> membersList(){
//		List<MemberVO> membersList = new ArrayList<MemberVO>();
//		
//		try {
//			conn = dataFactory.getConnection();
//			
//			String query = "select * from MEMBERS_TB";
//			System.out.println(query);
//			pstmt = conn.prepareStatement(query);
//			
//			ResultSet rs = pstmt.executeQuery();
//			
//			while(rs.next()) {
//				String id = rs.getString("MEM_ID");
//				String pw = rs.getString("MEM_PW");
//				
//				MemberVO memberVO = new MemberVO(id, pw);
//				membersList.add(memberVO);
//			}
//			
//		}catch (Exception e) {
//			e.printStackTrace();
//		}
//		return membersList;
//	}
	

	
	// 회원 조회
//	public List<MemberVO> listMembers(){
//		List<MemberVO> membersList = new ArrayList();
//		
//		try {
//			conn = dataFactory.getConnection();
//			// 가입일 내림차순 정렬 조회
//			
//			String query = "select * from USERS_TB order by USER_DATE desc";
//			System.out.println(query);
//			pstmt = conn.prepareStatement(query);
//			
//			ResultSet rs = pstmt.executeQuery();
//			while(rs.next()) {
//				String id = rs.getString("USER_ID");
//				String pwd = rs.getString("USER_PASSWORD");
//				String name = rs.getString("user_name");
//				int resident = rs.getInt("user_resident");
//				int tel = rs.getInt("user_resident");
//				int post = rs.getInt("user_post");
//				String addr = rs.getString("user_address");
//				String email = rs.getString("USER_EMAIL");
//				Date joinDate = rs.getDate("USER_DATE");
//				MemberVO memberVO = new MemberVO(id, pwd, name, resident, tel, post, addr, email, joinDate);
//				membersList.add(memberVO);
//			}
//			rs.close();
//			pstmt.close();
//			conn.close();
//		}catch (Exception e) {
//			e.printStackTrace();
//		}
//		return membersList;
//	}
	

}
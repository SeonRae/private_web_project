package member;

import java.util.Date;

public class MemberVO {
	private int code;
	private String id;
	private String pw;
	private String nick;
	private String email;
	private String email1;
	private String email2;
	private Date joinDate;

	public MemberVO() {
	}
	
	// 회원 가입 생성자
	public MemberVO(String id, String pw, String nick, String email) {
		this.id = id;
		this.pw = pw;
		this.nick = nick;
		this.email = email;
	}
	
	// 로그인 요청 처리 생성자
	public MemberVO(String id, String pw) {
		this.id = id;
		this.pw = pw;
	}
	
	// 회원 정보 조회 생성자
	public MemberVO(int code, String id, String nick, String email1, String email2, Date joinDate) {
		this.code = code;
		this.id = id;
		this.nick = nick;
		this.email1 = email1;
		this.email2 = email2;
		this.joinDate = joinDate;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getNick() {
		return nick;
	}

	public void setNick(String nick) {
		this.nick = nick;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail1(String email1) {
		this.email1 = email1;
	}
	public String getEmail1() {
		return email1;
	}
	
	public void setEmail2(String email2) {
		this.email2 = email2;
	}
	public String getEmail2() {
		return email2;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}

	public Date getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(Date joinDate) {
		this.joinDate = joinDate;
	}
}
	


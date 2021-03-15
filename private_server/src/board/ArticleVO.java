package board;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;

public class ArticleVO {
	private int boardCode;
	private String boardCategory;
	private String boardTitle;
	private String boardContent;
	private String boardFileName;
	private String boardViews;
	private Date boardWriteDate;
	private int memCode;
	private String memId;
	private String memNick;
	private int commCode;
	private String commMemNick;
	private String commContent;
	private Date commWriteDate;

	public ArticleVO() {
	}

	// 게시글 조회 생성자
	public ArticleVO(int boardCode, String boardCategory, String boardTitle, String boardViews, String memNick, Date boardWriteDate) {
		this.boardCode = boardCode;
		this.boardCategory = boardCategory;
		this.boardTitle = boardTitle;
		this.boardViews = boardViews;
		this.memNick = memNick;
		this.boardWriteDate = boardWriteDate;
	}

	// 게시글 상세 조회 생성자
	public ArticleVO(int boardCode, String boardCategory, String boardTitle, String boardContent, String boardViews, String boardFileName, 
			int memCode, String memId, String memNick, Date boardWriteDate) {
		this.boardCode = boardCode;
		this.boardCategory = boardCategory;
		this.boardTitle = boardTitle;
		this.boardContent = boardContent;
		this.boardViews = boardViews;
		this.boardFileName = boardFileName;
		this.memCode = memCode;
		this.memId = memId;
		this.memNick = memNick;
		this.boardWriteDate = boardWriteDate;
	}
	
	// 댓글 조회 생성자
	public ArticleVO(int commCode, String memId, String commMemNick, String commContent, Date commWriteDate) {
		this.commCode = commCode;
		this.memId = memId;
		this.commMemNick = commMemNick;
		this.commContent = commContent;
		this.commWriteDate = commWriteDate;
	}

	// 게시글 수정 내용 조회 생성자
	public ArticleVO(int boardCode, String boardCategory, String boardTitle, String boardContent, String boardFileName, String memNick) {
		this.boardCode = boardCode;
		this.boardCategory = boardCategory;
		this.boardTitle = boardTitle;
		this.boardContent = boardContent;
		this.boardFileName = boardFileName;
		this.memNick = memNick;
	}

	public int getBoardCode() {
		return boardCode;
	}

	public void setBoardCode(int boardCode) {
		this.boardCode = boardCode;
	}

	public String getBoardCategory() {
		return boardCategory;
	}

	public void setBoardCategory(String boardCategory) {
		this.boardCategory = boardCategory;
	}

	public String getBoardTitle() {
		return boardTitle;
	}

	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}

	public String getBoardContent() {
		return boardContent;
	}

	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}

	public String getBoardFileName() {
		return boardFileName;
	}

	public void setBoardFileName(String boardFileName) {
		try {
			if (boardFileName != null && boardFileName.length() != 0) {
				// 특수문자 깨짐 방지를 위한 인코딩
				this.boardFileName = URLEncoder.encode(boardFileName, "UTF-8");
			}

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	public String getBoardViews() {
		return boardViews;
	}

	public void setBoardViews(String boardViews) {
		this.boardViews = boardViews;
	}

	public int getMemCode() {
		return memCode;
	}

	public void setMemCode(int memCode) {
		this.memCode = memCode;
	}

	public String getMemId() {
		return memId;
	}
	
	public void setMemId(String memId) {
		this.memId = memId;
	}
	
	public String getMemNick() {
		return memNick;
	}

	public void setMemNick(String memNick) {
		this.memNick = memNick;
	}

	public Date getBoardWriteDate() {
		return boardWriteDate;
	}

	public void setBoardWriteDate(Date boardWriteDate) {
		this.boardWriteDate = boardWriteDate;
	}	

	public int getCommCode() {
		return commCode;
	}

	public void setCommCode(int commCode) {
		this.commCode = commCode;
	}

	public String getCommMemNick() {
		return commMemNick;
	}

	public void setCommMemNick(String commMemNick) {
		this.commMemNick = commMemNick;
	}

	public void setCommContent(String commContent) {
		this.commContent = commContent;
	}
	
	public String getCommContent() {
		return commContent;
	}

	public Date getCommWriteDate() {
		return commWriteDate;
	}

	public void setCommWriteDate(Date commWriteDate) {
		this.commWriteDate = commWriteDate;
	}	
	
}

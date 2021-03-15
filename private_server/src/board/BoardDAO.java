package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {
	private DataSource dataFactory;
	Connection conn;
	PreparedStatement pstmt;

	//생성자 (db 연결)
	public BoardDAO() {
		try {
			Context ctx = new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory = (DataSource) envContext.lookup("jdbc/orcl");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
		
	// 페이징맵을 받아와서 게시글 조회
	public List<ArticleVO> selectAllArticles(Map pagingMap) {
		List articlesList = new ArrayList();
		int section = (Integer)pagingMap.get("section");
		int pageNum = (Integer)pagingMap.get("pageNum");
		
		try {
			conn = dataFactory.getConnection();
			
			// 페이징 쿼리
			String query = "SELECT * FROM " +
					" (SELECT ROWNUM as recNum, board_code, board_category, board_title, BOARD_VIEWS, mem_nick, board_date" + 
					" FROM (SELECT b.board_code, b.board_category, b.board_title, b.BOARD_VIEWS, m.mem_nick, b.board_date" + 
					" FROM BOARD_TB b " + 
					" JOIN members_tb m " + 
					" ON b.mem_code = m.mem_code ORDER BY b.board_code DESC)" + 
					" )" + 
					" WHERE recNum BETWEEN(?-1)*100+(?-1)*10+1 AND (?-1)*100+?*10";
			
			System.out.println(query);
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, section);
			pstmt.setInt(2, pageNum);
			pstmt.setInt(3, section);
			pstmt.setInt(4, pageNum);
			
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()) {
				int boardCode = rs.getInt("board_code");
				String boardCategory = rs.getString("board_category");
				String boardTitle = rs.getString("board_title");
				String boardViews = rs.getString("board_views");
				String memNick = rs.getString("mem_nick");
				Date boardWriteDate = rs.getDate("board_date");
				
				// 게시글 조회 객체 생성
				ArticleVO article = new ArticleVO(boardCode, boardCategory, boardTitle, boardViews, memNick, boardWriteDate);

				articlesList.add(article);
			}
			rs.close();
			pstmt.close();
			conn.close();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return articlesList;
	}
	
		// 전체 게시글 수 조회
		public int selectTotArticles() {
			try {
				conn = dataFactory.getConnection();
				
				String query = "select count(board_code) from BOARD_TB";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				
				ResultSet rs = pstmt.executeQuery();
				
				if(rs.next()) {
					// 첫번째 컬럼 반환
					return (rs.getInt(1));
				}
				
				rs.close();
				pstmt.close();
				conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
			return 0;
		}
		
		// 멤버 닉네임 반환
		public String selectMemNick(String memId) {
			String memNick = null;
			try {
				conn = dataFactory.getConnection();
				
				// 멤버 아이디로 멤버 닉네임 조회
				String query = "select mem_nick from members_tb where mem_id = ?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, memId);
				
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()) {
					memNick = rs.getString(1);
				}
				
				rs.close();
				pstmt.close();
				conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
			return memNick;
		}
		
		// 게시글 작성
		public String insertNewArticle(ArticleVO article) {
			
			int memCode = 0;
			String boardCode = "0";
			
			try {
				conn = dataFactory.getConnection();
				String memId = article.getMemId();
				String boardCategory = article.getBoardCategory();
				String boardTitle = article.getBoardTitle();
				String boardContent = article.getBoardContent();
				String boardFileName = article.getBoardFileName();
				
				// 멤버 아이디로 멤버 코드 조회
				String query = "select mem_code from members_tb where mem_id = ?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, memId);
				
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()) {
					memCode = rs.getInt(1);
				}
				
				// 각 컬럼에 대응하여 삽입
				query = "INSERT INTO board_tb (BOARD_CODE, BOARD_CATEGORY, BOARD_TITLE, BOARD_CONTENT, BOARD_FILENAME, MEM_CODE)"
						+ " values (BOARD_TB_SQ.nextval, ?, ?, ?, ?, ?)";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, boardCategory);
				pstmt.setString(2, boardTitle);
				pstmt.setString(3, boardContent);
				pstmt.setString(4, boardFileName);
				pstmt.setInt(5, memCode);
				pstmt.executeUpdate();
				
				// 게시글 번호 조회
				query = "select max(BOARD_CODE) from board_tb";
				System.out.println(query);

				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery(query);
				if(rs.next()) {
					boardCode = rs.getString(1);
				}
				
				conn.commit();
				rs.close();
				pstmt.close();
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}		
			return boardCode;
		}
		
		// 선택된 게시글 조회
		public ArticleVO selectArticle(int boardCode) {

			ArticleVO article = null;
			
			try {
				conn = dataFactory.getConnection();
				
				// 조회수 증가
				String query = "update board_tb" + 
						" set board_views = board_views + 1" + 
						" where board_code = ?";
				System.out.println(query);
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, boardCode);
				pstmt.executeUpdate();
				
				conn.commit();
				
				query = "select b.board_code,b.board_category, b.board_title, b.board_content, "
						+ "b.board_views, b.board_filename, m.mem_code, m.mem_id, m.mem_nick, b.board_date" + 
						" from BOARD_TB b" + 
						" join members_tb m" + 
						" on b.mem_code = m.mem_code" + 
						" where b.board_code = ?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, boardCode);
				
				// 게시글 조회
				ResultSet rs = pstmt.executeQuery();
				rs.next();
				int _boardCode = rs.getInt("board_code");
				String boardCategory = rs.getString("board_category");
				String boardTitle = rs.getString("board_title");
				String boardContent = rs.getString("board_content");
				String boardViews = rs.getString("board_views");
				String boardFileName = rs.getString("board_filename");
				int memCode = rs.getInt("mem_code");
				String memId = rs.getString("mem_id");
				String memNick = rs.getString("mem_nick");
				Date boardWriteDate = rs.getDate("board_date");
				
				// 게시글 정보 객체 생성
				article = new ArticleVO(_boardCode, boardCategory, boardTitle, boardContent, boardViews, boardFileName, 
						memCode, memId, memNick, boardWriteDate);
				
				rs.close();
				pstmt.close();
				conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}

			return article;
		}
		
		// 댓글 조회
		public List<ArticleVO> selectArticleComment(int boardCode) {
			
			// 댓글 정보 객체를 담는 리스트
			List<ArticleVO> articleCommentsList = new ArrayList<ArticleVO>();

			try {
				conn = dataFactory.getConnection();
				
				String query = "select c.comm_code, m.mem_id, m.mem_nick, c.comm_content, c.comm_date" +
						" from comment_tb c" + 
						" join members_tb m" + 
						" on c.mem_code = m.mem_code"
						+ " where c.board_code = ?"
						+ " order by c.comm_code";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, boardCode);
				
				// 댓글 조회
				ResultSet rs = pstmt.executeQuery();
				while(rs.next()) {
					int commCode = rs.getInt("comm_code");
					String memId = rs.getString("mem_id");
					String commMemNick = rs.getString("mem_nick");
					String commContent = rs.getString("comm_content");
					Date commWriteDate = rs.getDate("comm_date");

					// 댓글 정보 객체 생성
					ArticleVO articleComments = new ArticleVO(commCode, memId, commMemNick, commContent, commWriteDate);
					
					articleCommentsList.add(articleComments);	// 댓글 정보를 리스트에 저장
				}
				
				rs.close();
				pstmt.close();
				conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}

			return articleCommentsList;
		}
		
		// 게시글 수정 내용 조회
		public ArticleVO selectModArticle(int boardCode) {
			ArticleVO article = null;
			
			try {
				conn = dataFactory.getConnection();
				
				String query = "select b.board_code, b.board_category, b.board_title, b.board_content, b.board_filename, m.mem_nick" + 
						" from BOARD_TB b" + 
						" join members_tb m" + 
						" on b.mem_code = m.mem_code" + 
						" where b.board_code = ?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, boardCode);
				
				ResultSet rs = pstmt.executeQuery();
				rs.next();
				int _boardCode = rs.getInt("board_code");
				String boardCategory = rs.getString("board_category");
				String boardTitle = rs.getString("board_title");
				String boardContent = rs.getString("board_content");
				String boardFileName = rs.getString("board_filename");
				String memNick = rs.getString("mem_nick");
				
				// 게시글 수정 내용 조회 객체 생성
				article = new ArticleVO(_boardCode, boardCategory, boardTitle, boardContent, boardFileName, memNick);
				
				rs.close();
				pstmt.close();
				conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
			return article;
		}
		
		// 게시글 수정
		public void updateArticle(ArticleVO article) {
			int boardCode = article.getBoardCode();
			String boardCategory = article.getBoardCategory();
			String boardTitle = article.getBoardTitle();
			String boardContent = article.getBoardContent();
			String boardFileName = article.getBoardFileName();
			
			try {
				conn = dataFactory.getConnection();
				
				String query = "update BOARD_TB set BOARD_CATEGORY=?, BOARD_TITLE=?, BOARD_CONTENT=?";
				if(boardFileName != null && boardFileName.length() != 0) {
					query += ", BOARD_FILENAME=?";
				}
				
				query += " where BOARD_CODE=?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, boardCategory);
				pstmt.setString(2, boardTitle);
				pstmt.setString(3, boardContent);
				
				if(boardFileName != null && boardFileName.length() != 0) {
					pstmt.setString(4, boardFileName);
					pstmt.setInt(5, boardCode);
				}else {
					pstmt.setInt(4, boardCode);
				}
				pstmt.executeUpdate();
				
				pstmt.close();
				conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		// 선택된 게시글 삭제
		public void selectRemoveArticles(int boardCode){
			List<Integer> boardCodeList = new ArrayList<Integer>();
			
			try {
				conn = dataFactory.getConnection();
				
				String query = "delete from board_tb"
						+ " where board_code = ?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, boardCode);
				pstmt.executeUpdate();
				
				pstmt.close();
				conn.close();
				
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		// 멤버 코드 반환
		public int selectMemCode(String memId) {
			int memCode = 0;
			try {
				conn = dataFactory.getConnection();
				
				// 멤버 아이디로 멤버 코드 조회
				String query = "select mem_code from members_tb where mem_id = ?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, memId);
				
				ResultSet rs = pstmt.executeQuery();
				if(rs.next()) {
					memCode = rs.getInt(1);
				}
				
				rs.close();
				pstmt.close();
				conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
			return memCode;
		}
		
		// 댓글 추가
		public void insertComment(int memCode, int boardCode, String commContent){
			try {
				conn = dataFactory.getConnection();
				
				String query = "INSERT INTO comment_tb (COMM_CODE, BOARD_CODE, MEM_CODE, COMM_CONTENT)"
						+ " values (COMMENT_TB_SQ.nextval, ?, ?, ?)";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setInt(1, boardCode);
				pstmt.setInt(2, memCode);
				pstmt.setString(3, commContent);
				pstmt.executeUpdate();
				
				conn.commit();
				pstmt.close();
				conn.close();
				
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		// 댓글 수정
		public void updateComment(int commCode, String commContent){
			try {
				conn = dataFactory.getConnection();
				
				String query = "update comment_tb "
						+ "set comm_content = ? "
						+ "where comm_code = ?";
				System.out.println(query);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, commContent);
				pstmt.setInt(2, commCode);
				pstmt.executeUpdate();
				
				conn.commit();
				pstmt.close();
				conn.close();
				
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		// 선택된 댓글 삭제
		public void deleteComment(int commCode){
		
		try {
			conn = dataFactory.getConnection();
			
			String query = "delete from COMMENT_TB where comm_code = ?";
			System.out.println(query);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, commCode);
			pstmt.executeUpdate();
			
			conn.commit();
			pstmt.close();
			conn.close();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
}

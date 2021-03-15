package board;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BoardService {
	BoardDAO boardDAO;

	public BoardService() {
		boardDAO = new BoardDAO();
	}

	// 게시글 조회 메소드 (+페이징)
	public Map listArticles(Map<String, Integer> pagingMap) {				
		Map articlesMap = new HashMap();
		
		// 페이징맵에 따라 글 목록을 조회
		List<ArticleVO> articlesList = boardDAO.selectAllArticles(pagingMap);
		
		// 페이징 매핑을 위한 전체 게시글 수 조회
		int totArticles = boardDAO.selectTotArticles();
		
		// 페이징된 글목록과 전체 글목록을 매핑함
		articlesMap.put("articlesList", articlesList);
		articlesMap.put("totArticles", totArticles);
		
		return articlesMap;
	}
	
	// 게시글 추가 메소드
	public String addArticle(ArticleVO article){
		return boardDAO.insertNewArticle(article); // 메소드 실행 값을 반환
	}
	
	// 게시글 상세 조회 메소드
	public ArticleVO viewArticle(int boardCode) {
		return boardDAO.selectArticle(boardCode);
	}
	
	// 게시글 상세 조회 메소드
	public List<ArticleVO> viewArticleComment(int boardCode) {
		return boardDAO.selectArticleComment(boardCode);
	}
	
	// 게시글 수정 페이지 이동 메소드
	public ArticleVO modArticleForm(int boardCode) {
		ArticleVO article = null;
		article = boardDAO.selectModArticle(boardCode);
		return article;
	}
	
	// 게시글 수정 메소드
	public void modArticle(ArticleVO article) {
		boardDAO.updateArticle(article);
	}

	// 게시글 삭제 메소드
	public void removeArticle(int boardCode){
		boardDAO.selectRemoveArticles(boardCode);
	}
}

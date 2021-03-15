package board;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;

@WebServlet("/board/*")
public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	BoardService boardService;
	ArticleVO articleVO;
	BoardDAO boardDAO;
	private static String ARTICLE_IMAGE_REPO = "D:\\board\\article_image";
       
    public BoardController() {
        super();
    }
    
	public void init(ServletConfig config) throws ServletException {
		boardService = new BoardService();
		articleVO = new ArticleVO();
		boardDAO = new BoardDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doHandle(request, response);
	}

	private void doHandle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String nextPage = null;	// 이동할 페이지의 URL을 저장하는 변수
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String action = request.getPathInfo();	// 마지막 주소 가져옴
		HttpSession session;	// 세션 객체
		
		System.out.println("action : " + action);
		
		try {
			// 게시판 글목록
			if (action.equals("/boardList")) {
				System.out.println("boardList");
				
				// 섹션과 페이지를 받아옴
				String _section = request.getParameter("section");
				String _pageNum = request.getParameter("pageNum");
				
				// 파라미터가 없을때 섹션, 페이지를 1로 초기화
				int section = Integer.parseInt(((_section==null) ? "1" : _section));
				int pageNum = Integer.parseInt(((_pageNum==null) ? "1" : _pageNum));
				
				// 페이지 매핑
				Map<String, Integer> pagingMap = new HashMap<String, Integer>();
				pagingMap.put("section", section);
				pagingMap.put("pageNum", pageNum);
				
				// 페이징맵을 전달하여 해당 페이지의 글목록 가져옴
				Map articlesMap = boardService.listArticles(pagingMap);
				
				// 페이징된 글목록과 전체 글목록을 페이징맵으로 매핑
				articlesMap.put("section", section);
				articlesMap.put("pageNum", pageNum);
				request.setAttribute("articlesMap", articlesMap);
				
				nextPage = "/board.jsp";
				
			// 게시글 작성 페이지 이동
			}else if(action.equals("/articleForm")) {
				session = request.getSession();
				String memId = session.getAttribute("loginId").toString();
				String memNick = boardDAO.selectMemNick(memId);
				request.setAttribute("memNick", memNick);
				nextPage = "/articleForm.jsp";
				
			// 게시글 작성 요청 처리
			}else if(action.equals("/addArticle")) {
				String boardCode = "0";
				Map<String, String> articleMap = upload(request, response);
			
				// Map의 key로 value 가져옴
				String boardCategory = articleMap.get("boardCategory");
				String boardTitle = articleMap.get("boardTitle");
				String boardContent = articleMap.get("boardContent");
				String boardFileName = articleMap.get("boardFileName");
				
				session = request.getSession();
				String memId = session.getAttribute("loginId").toString();
				
				articleVO.setMemId(memId);
				articleVO.setBoardCategory(boardCategory);
				articleVO.setBoardTitle(boardTitle);
				articleVO.setBoardContent(boardContent);
				articleVO.setBoardFileName(boardFileName);
				boardCode = boardService.addArticle(articleVO);	// 게시글 작성 메소드
				
				// 파일이 있을때
				if(boardFileName !=null && boardFileName.length() !=0) {
					// temp에 있는 파일을 글 번호 디렉터리를 생성 후 이동
					File srcFile = new File(ARTICLE_IMAGE_REPO +"\\"+"temp"+"\\"+boardFileName);
					File destDir = new File(ARTICLE_IMAGE_REPO +"\\"+boardCode);
					destDir.mkdirs();
					FileUtils.moveFileToDirectory(srcFile, destDir, true);
				}
				PrintWriter pw = response.getWriter();
				pw.print("<script>" 
				         +"  alert('글을 등록했습니다.');" 
						 +" location.href='"+request.getContextPath()+"/board/boardList';"
				         +"</script>");

				return;
				
			// 글 상세 조회
			}else if(action.equals("/viewArticle")) {
				int boardCode = Integer.parseInt(request.getParameter("boardCode"));
				
				ArticleVO article = boardService.viewArticle(boardCode);
				List<ArticleVO> articleComment = boardService.viewArticleComment(boardCode);
				
				request.setAttribute("article", article);
				request.setAttribute("articleComment", articleComment);
				
				nextPage = "/viewArticle.jsp";
			
			// 글 수정 페이지 이동
			}else if(action.equals("/modForm")) {
				String boardCode = request.getParameter("boardCode");
				articleVO = boardService.modArticleForm(Integer.parseInt(boardCode));
				request.setAttribute("article", articleVO);
				nextPage = "/modForm.jsp";
				
			// 글 수정 요청 처리
			}else if(action.equals("/modArticle")) {
				Map<String, String> articleMap = upload(request, response);
				int boardCode = Integer.parseInt(articleMap.get("boardCode"));
				articleVO.setBoardCode(boardCode);
				
				String boardCategory = articleMap.get("boardCategory");
				String boardTitle = articleMap.get("boardTitle");
				String boardContent = articleMap.get("boardContent");
				String boardFileName = articleMap.get("boardFileName");
				
				articleVO.setBoardCategory(boardCategory);
				articleVO.setBoardTitle(boardTitle);
				articleVO.setBoardContent(boardContent);
				articleVO.setBoardFileName(boardFileName);
				boardService.modArticle(articleVO);
				
				if(boardFileName != null && boardFileName.length() != 0) {
					
					// 파일의 실제 이름을 가져온다
					String originalFileName = articleMap.get("originalFileName");
					
					File srcFile = new File(ARTICLE_IMAGE_REPO + "\\" + "temp" + "\\" + boardFileName);
					File destDir = new File(ARTICLE_IMAGE_REPO + "\\" + boardCode);
					destDir.mkdirs();
					FileUtils.moveFileToDirectory(srcFile, destDir, true);
					
					File oldFile = new File(ARTICLE_IMAGE_REPO + "\\" + boardCode + "\\" + originalFileName);
					oldFile.delete();	// 파일 삭제
				}
				PrintWriter pw = response.getWriter();
				pw.print("<script>" + " alert('글을 수정했습니다');" 
						+ " location.href='/board/viewArticle?boardCode="+boardCode+ "';" 
						+ "</script>");
				
				return;
			}else if(action.equals("/removeArticle")) {
				int boardCode = Integer.parseInt(request.getParameter("boardCode"));
				boardService.removeArticle(boardCode);
				
				File imgDir = new File(ARTICLE_IMAGE_REPO + "\\" + boardCode);
				if (imgDir.exists()) {
					FileUtils.deleteDirectory(imgDir);
				}

				PrintWriter pw = response.getWriter();
				pw.print("<script>" + "  alert('글을 삭제했습니다');"
						+ " location.href='/board/boardList';</script>");
				return;
			}
				
			// 포워딩
			RequestDispatcher dispatch = request.getRequestDispatcher(nextPage);
			dispatch.forward(request, response);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 맵 형식 파일 업로드 처리 메소드
		private Map<String, String> upload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			
			Map<String, String> articleMap = new HashMap<String, String>();
			String encoding = "utf-8";	// 인코딩 방식
			File currentDirPath = new File(ARTICLE_IMAGE_REPO);	// 파일이 저장될 디렉터리
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setRepository(currentDirPath);
			factory.setSizeThreshold(1024 * 1024);
			
			ServletFileUpload upload = new ServletFileUpload(factory);
			try {
				List items = upload.parseRequest(request);
				for (int i = 0; i < items.size(); i++) {
					FileItem fileItem = (FileItem) items.get(i);
					
					if (fileItem.isFormField()) {	// 파일이 아닐때
						System.out.println(fileItem.getFieldName() + "=" + fileItem.getString(encoding));
						articleMap.put(fileItem.getFieldName(), fileItem.getString(encoding));	// Map에 저장
					} else {	// 파일 일때
						System.out.println("파라미터명:" + fileItem.getFieldName());
						System.out.println("파일크기:" + fileItem.getSize() + "bytes");
						if (fileItem.getSize() > 0) {
							int idx = fileItem.getName().lastIndexOf("\\");
							if (idx == -1) {
								idx = fileItem.getName().lastIndexOf("/");
							}

							String fileName = fileItem.getName().substring(idx + 1);
							System.out.println("파일명:" + fileName);
							articleMap.put(fileItem.getFieldName(), fileName);	// Map에 파일명 저장
							File uploadFile = new File(currentDirPath + "\\temp\\" + fileName);	// temp(임시저장소)에 파일 저장
							fileItem.write(uploadFile);	// 파일 쓰기

						} // end if
					} // end if
				} // end for
			} catch (Exception e) {
				e.printStackTrace();
			}
			return articleMap;
		}
}
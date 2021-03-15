drop table MEMBERS_TB;
create table MEMBERS_TB(
    MEM_CODE NUMBER,
    MEM_ID varchar2(12) not null unique,
    MEM_PW varchar2(12) not null,
    MEM_NICK varchar2(20) not null,
    MEM_EMAIL varchar2(50) not null,
    MEM_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBERS_TB_PK PRIMARY KEY(MEM_CODE)
);

drop table BOARD_TB;
create table BOARD_TB(
    BOARD_CODE NUMBER,
    BOARD_CATEGORY varchar2(10) not null,
    BOARD_TITLE varchar2(500) not null,
    BOARD_CONTENT varchar2(4000) not null,
    BOARD_FILENAME VARCHAR2(4000),
    BOARD_VIEWS NUMBER DEFAULT 0,
    BOARD_DATE DATE DEFAULT SYSDATE,
    MEM_CODE NUMBER,
    CONSTRAINT BOARD_TB_PK PRIMARY KEY(BOARD_CODE),
    CONSTRAINT MEMBERS_TB_BOARD_TB_FK FOREIGN KEY(MEM_CODE)
    REFERENCES MEMBERS_TB(MEM_CODE) ON DELETE CASCADE
);

drop table COMMENT_TB;
create table COMMENT_TB(
    COMM_CODE NUMBER,
    BOARD_CODE NUMBER,
    MEM_CODE NUMBER,
    COMM_CONTENT VARCHAR2(4000) NOT NULL,
    COMM_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT COMMENT_TB PRIMARY KEY(COMM_CODE),
    CONSTRAINT COMMENT_TB_BOARD_TB_FK FOREIGN KEY(BOARD_CODE)
    REFERENCES BOARD_TB(BOARD_CODE) ON DELETE CASCADE,
    CONSTRAINT COMMENT_TB_MEMBERS_TB_FK FOREIGN KEY(MEM_CODE)
    REFERENCES MEMBERS_TB(MEM_CODE) ON DELETE CASCADE
);

drop SEQUENCE MEMBERS_TB_SQ;
drop SEQUENCE BOARD_TB_SQ;
drop SEQUENCE COMMENT_TB_SQ;

CREATE SEQUENCE MEMBERS_TB_SQ
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE BOARD_TB_SQ
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE COMMENT_TB_SQ
INCREMENT BY 1
START WITH 1;

INSERT into MEMBERS_TB (MEM_CODE, MEM_ID, MEM_PW, MEM_NICK, MEM_EMAIL)
values(MEMBERS_TB_SQ.nextval, 'seonrae2', '1234', '보라금풍뎅이', 'ksr5445@gmail.com');

INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목', '테스트글내용', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목2', '테스트글내용2', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목3', '테스트글내용3', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목4', '테스트글내용4', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목5', '테스트글내용5', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목', '테스트글내용', 2);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목', '테스트글내용', 3);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목', '테스트글내용', 4);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목6', '테스트글내용6', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목7', '테스트글내용7', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목8', '테스트글내용8', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목9', '테스트글내용9', 1);
INSERT into BOARD_TB (BOARD_CODE, BOARD_CATEGORY, board_title, board_content, MEM_CODE)
values(BOARD_TB_SQ.nextval, '[일반]', '테스트글제목10', '테스트글내용10', 1);

INSERT INTO comment_tb (COMM_CODE, BOARD_CODE, MEM_CODE, COMM_CONTENT)
VALUES (COMMENT_TB_SQ.nextval, 23, 1, '댓글입니다');
INSERT INTO comment_tb (COMM_CODE, BOARD_CODE, MEM_CODE, COMM_CONTENT)
VALUES (COMMENT_TB_SQ.nextval, 23, 1, '댓글입니다2');
INSERT INTO comment_tb (COMM_CODE, BOARD_CODE, MEM_CODE, COMM_CONTENT)
VALUES (COMMENT_TB_SQ.nextval, 23, 1, '댓글입니다3');
INSERT INTO comment_tb (COMM_CODE, BOARD_CODE, MEM_CODE, COMM_CONTENT)
VALUES (COMMENT_TB_SQ.nextval, 23, 2, '댓글입니다4');
INSERT INTO comment_tb (COMM_CODE, BOARD_CODE, MEM_CODE, COMM_CONTENT)
VALUES (COMMENT_TB_SQ.nextval, 23, 3, '댓글입니다5');
INSERT INTO comment_tb (COMM_CODE, BOARD_CODE, MEM_CODE, COMM_CONTENT)
VALUES (COMMENT_TB_SQ.nextval, 23, 4, '댓글입니다6');

delete from members_tb;

delete from members_tb
where mem_id = 'hankang';

select * from MEMBERS_TB;
select * from BOARD_TB;
select * from comment_tb;

SELECT * FROM (
    SELECT ROWNUM as recNum, board_code, board_title, board_content, mem_id, board_date
    FROM (SELECT b.board_code, b.board_title, b.board_content, m.mem_id, b.board_date
        FROM BOARD_TB b
        JOIN members_tb m
        ON b.mem_code = m.mem_code
        )
    order by recNum desc
	)
WHERE recNum BETWEEN(1-1)*100+(1-1)*10+1 AND (1-1)*100+1*10;

select b.board_code, b.board_title, b.board_content, b.board_filename, m.mem_id, b.board_date
from BOARD_TB b
join members_tb m
on b.mem_code = m.mem_code
where b.board_code = 1;

select max(BOARD_CODE) from board_tb;

select c.comm_code, m.mem_id, m.mem_nick, c.comm_content, c.comm_date
from comment_tb c
join members_tb m
on c.mem_code = m.mem_code
where c.board_code = 23
order by c.comm_code;

update MEMBERS_TB 
set mem_nick = '운영자1', mem_email = 'ksr5445@google.com' 
where mem_id = 'seonrae';

update board_tb
set board_views = board_views + 1
where board_code = 1;

commit;
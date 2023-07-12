/* ������� ������������� */
CREATE TABLE DEPT
(
  DEPTNO INT NOT NULL,
  DNAME  VARCHAR(14) NOT NULL,
  LOC    VARCHAR(13)
);

ALTER TABLE DEPT
  ADD CONSTRAINT DEPT_PK PRIMARY KEY (DEPTNO);
ALTER TABLE DEPT
  ADD CONSTRAINT DEPT_UK UNIQUE (DNAME);

/* ������� ����������� */
CREATE TABLE EMP
(
  EMPNO    INT NOT NULL,
  ENAME    VARCHAR(10) NOT NULL,
  JOB      VARCHAR(9),
  MGR      INT, --���������
  HIREDATE DATE,
  SAL      INT,
  COMM     INT,
  DEPTNO   INT
);

ALTER TABLE EMP
  ADD CONSTRAINT EMP_PK PRIMARY KEY (EMPNO);
ALTER TABLE EMP
  ADD CONSTRAINT EMP_UK UNIQUE (ENAME);
ALTER TABLE EMP
  ADD CONSTRAINT EMP_DEPT_FK FOREIGN KEY (DEPTNO)
  REFERENCES DEPT (DEPTNO);
ALTER TABLE EMP
  ADD CONSTRAINT EMP_MGR_FK FOREIGN KEY (MGR)
  REFERENCES EMP (EMPNO);

  
/* ������� ����� ������� */
CREATE TABLE SALGRADE (
 GRADE               INT NOT NULL,
 LOSAL               INT,
 HISAL               INT);

ALTER TABLE SALGRADE
  ADD CONSTRAINT SALGRADE_PK PRIMARY KEY (GRADE);

/* ������ �� �������������� */
--INSERT ��������� ������ � �������
INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');

/* ������ �� ����������� */
INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'2011-09-11',5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'2014-01-31',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'2013-02-21',2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'2017-09-19',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'2017-09-11',1250,400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'2017-09-11',1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'2017-03-22',1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'2016-11-11',950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'2015-07-17',1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'2017-03-11',3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'2012-09-17',800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'2017-01-11',3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'2018-07-13',1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'2018-03-12',1300,NULL,10);

/* ������ �� ������� ������� */
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

update dept set loc = 'BOSTON' 
where deptno = 40;

update emp set sal = sal+200
where ename = 'MILLER';

update SALGRADE set hisal = 10000;

delete SALGRADE where GRADE = 5;

delete 

--������ ������
select * from dept;

--������ ������
select * from emp;

--������ ������
select * from SALGRADE;


--drop table DEPT;

--�	���������� ������� �����������, �������� ������� >= 2000 � <=4000;
select ename, sal from emp
where sal >= 2000 and sal<=4000;
--�� 20 ������ �� >2000
select ename, sal from emp
where sal >= 2000 and DEPTNO=20;

--�	����� ������, ������� ��������� � �������;
select * from dept
where loc = 'DALLAS';

--�	���������� ������� ����������� �� ������ 20;
select * from emp
where DEPTNO=20;

--�	����� �����������, ���� ����������� �������� ��������� 7839;
select * from emp
where mgr = 7839;

--�	������������� ����������� �� ���� �����.
select * from emp
order by HIREDATE desc;
--asc - �� �������� � ��������
--desc - �� �������� � ��������





----������� ������� �� 3� ��������: �����, ����, �����
----�������� � ��� ������
----������� ������ ��� ������ select

--CREATE TABLE TAB
--(
--  TABNUM INT NOT NULL,
--  TABDATE DATE NOT NULL,
--  TABTEXT VARCHAR(50)
--);

--ALTER TABLE TAB
--  ADD CONSTRAINT TAB_PK PRIMARY KEY (TABNUM);
--ALTER TABLE TAB
--  ADD CONSTRAINT TAB_UK UNIQUE (TABDATE);

--INSERT INTO TAB VALUES (1,'2010-12-30','NEW YORK CITY');
--INSERT INTO TAB VALUES (2,'2005-01-01','DALLAS CLUB');
--INSERT INTO TAB VALUES (3,'2003-03-05','CHICAGO STATION');
--INSERT INTO TAB VALUES (4,'2019-10-28','BOSTON CUP');

--select * from TAB;
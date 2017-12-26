--创建存储过程 批量创建表
create or replace procedure proc_create_table_multi(tbName VARCHAR2, nNameNoStart INT, nNameNoEnd INT)
IS
  tbFullName    VARCHAR2(400);
  tbPKName    VARCHAR2(400);
  szSql1      VARCHAR2(2000);
  szSql2      VARCHAR2(2000);
  nNo       INT;
BEGIN
  dbms_output.put_line('proc_create_table_multi'||tbFullName);
  nNo := nNameNoStart;
  while nNo <= nNameNoEnd LOOP
  begin
        tbFullName := tbName||TO_CHAR(nNo);
        tbPKName := tbFullName||'_PK';
        szSql1 := 'create table '||tbFullName||'
            (
              TEST_ID   VARCHAR2(48) not null,
              TEST_NAME VARCHAR2(128),
              JOB_NAME  VARCHAR2(64)
            )
            tablespace BAS
              pctfree 10
              initrans 1
              maxtrans 255
              storage
              (
              initial 64K
              minextents 1
              maxextents unlimited
              )';
        szSql2 := 'alter table '||tbFullName||'
              add constraint '||tbPKName||' primary key (TEST_ID)
              using index 
              tablespace BAS
              pctfree 10
              initrans 2
              maxtrans 255
              storage
              (
              initial 64K
              minextents 1
              maxextents unlimited
              )';

        --dbms_output.put_line('proc_create_table_multi exec:'||szSql);
        EXECUTE IMMEDIATE szSql1;
        EXECUTE IMMEDIATE szSql2;
        dbms_output.put_line('proc_create_table_multi exec success:'||tbFullName);
        nNo := nNo+1;
  end;
  end LOOP;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
       ROLLBACK;
END;


--创建存储过程 批量修改表
create or replace procedure proc_modify_table_multi(tbName VARCHAR2, nNameNoStart INT, nNameNoEnd INT, sqlCommand VARCHAR2)
IS
  tbFullName    VARCHAR2(400);
  szSql			VARCHAR2(2000);
  nNo       INT;
BEGIN
  nNo := nNameNoStart;
  while nNo <= nNameNoEnd LOOP
  begin
        tbFullName := tbName||TO_CHAR(nNo);
        --修改表
        szSql := 'alter table '||tbFullName||' '||sqlCommand;

        --dbms_output.put_line('proc_insert_table_multi exec:'||szSql);
        EXECUTE IMMEDIATE szSql;
        dbms_output.put_line('proc_modify_table_multi exec success:'||tbFullName);
        nNo := nNo+1;
  end;
  end LOOP;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
       ROLLBACK;
END;


--创建存储过程 批量插入数据
create or replace procedure proc_insert_multi(tbName VARCHAR2, nNameNoStart INT, nNameNoEnd INT)
IS
  tbFullName    VARCHAR2(400);
  szSql			VARCHAR2(2000);
  nNo       INT;
BEGIN
  nNo := nNameNoStart;
  while nNo <= nNameNoEnd LOOP
  begin
        tbFullName := tbName||TO_CHAR(nNo);
        szSql := 'insert into '||tbFullName||'(TEST_ID, TEST_NAME)
              values(sys_guid(), to_char(sysdate, ''yyyy-mm-dd hh24:mi:ss''))';

        dbms_output.put_line('proc_insert_table_multi exec:'||szSql);
        EXECUTE IMMEDIATE szSql;
        dbms_output.put_line('proc_insert_table_multi exec success:'||tbFullName);
        nNo := nNo+1;
  end;
  end LOOP;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(SQLCODE||'---'||SQLERRM);
       ROLLBACK;
END;


--批量增加记录
begin
  proc_insert_multi('MY_TEST_',1,6);
end;

--批量修改表字段（删除字段）
begin
  proc_modify_table_multi('MY_TEST_',1,6,'drop (JOB_NAME)');
end;

--批量修改表字段（增加字段）
begin
  proc_modify_table_multi('MY_TEST_',1,6,'add (JOB_NAME varchar2(30) default ''未知'' not null,
                                              JOB_NO integer default 22 not null
                                              )');
end;

--批量修改表字段（修改字段）
begin
  proc_modify_table_multi('MY_TEST_',1,6,'modify (JOB_NAME varchar2(16) default ''unknown'')');
end;


--创建并运行job
declare
    jobid     number;
begin
        dbms_job.submit(jobid,'proc_insert_table_multi(''MY_TEST_'',1,6);',sysdate,'sysdate+1/24/60/12');
        dbms_job.run(jobid);
        dbms_output.put_line('job '||to_char(jobid)||' is running');
end;

--停止job
begin
   dbms_job.broken(25, true, sysdate);  --25就是job号
   commit;
end;

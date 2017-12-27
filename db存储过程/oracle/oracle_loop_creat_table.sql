-- oracle 数据库批量建表
begin
     declare 
	 i int;
	 tmpcount int;
	 tbname varchar2(50);
	 strsql varchar2(1000);
     begin
         i:=0;
         while i<10 loop --创建表数目
         begin
             tbname := cyberinfo'||to_char(i);   --表名称cyberinfo
             i := i+1;

             select count(1) into tmpcount from user_tables where table_name = Upper(tbname);
             if tmpcount>0 then
             begin
                 execute immediate 'drop table '||tbname;
             commit;
             end;
             end if;
             strsql := 'create table '||tbname||
             '(
                  employeeno      varchar2(10)  not null,         -- employee number 字段
                  employeeage     int           not null          -- employee age	字段
              )';
             execute immediate strsql;   
             strsql := 'begin 
                  execute immediate ''drop index idx1_'||tbname || ' '''
                  || ';exception when others then null;
                  end;';
             execute immediate strsql;

             execute immediate 'create unique index idx1_'||tbname||' on '||tbname||'(employeeno)';

         end;
         end loop;
     end;
end;
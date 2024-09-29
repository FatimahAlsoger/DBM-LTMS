--Create Users

drop user Renad;
drop user Beshayer;
drop user Fatima;
drop user Razan;
drop user Reem;
drop user Haya;


create user Haya identified by passw1;
create user Renad identified by passw2;
create user Beshayer identified by passw3;
create user Fatima identified by passw4;
create user Razan identified by passw5;
create user Reem identified by passw6;


grant Connect to Haya;
grant Connect to Renad;
grant Connect to Beshayer;
grant Connect to Fatima;
grant Connect to Razan;
grant Connect to Reem;


---------------------

-- all  PRIVILEGES 

-- Haya 
grant all privileges to Haya;

-- Renad
grant INSERT any table to Renad;
grant drop ANY TABLE to Renad;
grant SELECT any table to Renad;
grant comment any table to Renad;
grant UPDATE ANY TABLE to Renad;


-- Fatima
grant SELECT any table to Fatima;
grant comment any table to Fatima;
grant drop any table to Fatima;


-- Beshair
grant DELETE any table to Beshayer;
grant SELECT any table to Beshayer;
grant INSERT any table to Beshayer;
grant comment any table to Beshayer;


-- Razan
GRANT UPDATE ANY TABLE to Razan;
grant SELECT any table to Razan;
grant comment any table to Razan;

-- Reem
grant INSERT any table to Reem;
grant SELECT any table to Reem;
grant comment any table to Reem;

---------------------

-- to show all privileges 

SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in('Haya');
SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in('Renad');
SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in('Beshayer');
SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in('Fatima');
SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in('Razan');
SELECT * FROM DBA_SYS_PRIVS WHERE lower(GRANTEE) in('Reem');



----------------------------------------------------------------------

-- tablespace 

drop tablespace Project_table including contents and datafiles; 
drop tablespace Project_INDX including contents and datafiles;

create tablespace Project_Table datafile 'C:\Users\tabelA.dbf' size 150m;
create tablespace Project_INDX datafile 'C:\Users\tabelB.dbf' size 100m;

alter user Haya default tablespace Project_Table;
alter user Renad default tablespace Project_Table;
alter user Beshayer default tablespace Project_Table;
alter user Fatima default tablespace Project_Table;
alter user Razan default tablespace Project_Table;
alter user Reem default tablespace Project_Table;

--  to show tablespace with DATAFILES
select a.tablespace_name, b.file_name
from dba_tablespaces a join dba_data_files b
on (a.tablespace_name=b.tablespace_name);

-- to show DEFAULT TABLESPACE for each user
select username, default_tablespace from dba_users;

----------------------------------------------------------------------

-- Create tables

drop table Doctor cascade constraint;
drop table Recipient cascade constraint;
drop table Donor cascade constraint;
drop table Liver cascade constraint;
drop table Surgery cascade constraint;


create table Doctor ( 
doctor_id number(3) PRIMARY key ,
name varchar2(8));

INSERT into Doctor VALUES(1,'sara');
INSERT into Doctor VALUES(2,'mohammed');
INSERT into Doctor VALUES(3,'fahad');
INSERT into Doctor VALUES(4,'arwa');
INSERT into Doctor VALUES(5,'mona');
INSERT into Doctor VALUES(6,'ahmad');

---------------------

create table Recipient (
file_no NUMBER(3) PRIMARY key ,
name VARCHAR2(8),
DOB DATE,
blood_type VARCHAR2(2),
doctor_id number(3),
FOREIGN key (doctor_id) REFERENCES Doctor(doctor_id)on delete cascade);

  
INSERT into Recipient VALUES(1,'nada', '01-jan-2002','+O', 3);
INSERT into Recipient VALUES(2,'walled' , '20-jul-1995' , '+A', 2);
INSERT into Recipient VALUES(3,'Samar', '16-sep-1999' ,'+B',1);
INSERT into Recipient VALUES(4,'Amal', '01-apr-1980' ,'-B',6);
INSERT into Recipient VALUES(5,'Yazeed', '26-mar-1979' ,'-O',5);
INSERT into Recipient VALUES(6,'Hyaa', '10-jul-1970' ,'AB',4);

---------------------

create table Donor (
file_no NUMBER(3) PRIMARY key ,
name VARCHAR2(8),
DOB DATE,
blood_type VARCHAR2(2),
life_status VARCHAR2(8),
doctor_id number(3),
FOREIGN key (doctor_id) REFERENCES Doctor(doctor_id)on delete cascade); 

INSERT into Donor VALUES(1,'bashayer', '20-may-2002' ,'+O',' alive ' ,3);
INSERT into Donor VALUES(2,'razan','13-mar-1999'  ,'-A',' dead ' ,3);
INSERT into Donor VALUES(3,'haya', '23-apr-1980' ,'+A',' dead ' ,3);
INSERT into Donor VALUES(4,'ahmad', '17-apr-1996' ,'+A',' alive ' ,3);
INSERT into Donor VALUES(5,'fares', '08-mar-1977' ,'+O','  alive' ,3);
INSERT into Donor VALUES(6,'saad', '04-dec-2001' ,'+O','dead' ,3);

---------------------

create TABLE Liver (
liver_id number(3) PRIMARY key ,
sizee NUMBER(3),
rec_file_no NUMBER(3), 
don_file_no NUMBER(3),
FOREIGN key (rec_file_no) REFERENCES Recipient(file_no) on delete cascade,
FOREIGN key (don_file_no) REFERENCES Donor(file_no)on delete cascade );


INSERT into Liver VALUES(1,30,3,4);
INSERT into Liver VALUES(2,40,2,5);
INSERT into Liver VALUES(3,35,1,6);
INSERT into Liver VALUES(4,23,5,2);
INSERT into Liver VALUES(5,43,6,3);
INSERT into Liver VALUES(6,54,4,1);

---------------------

create table Surgery ( 
Surgery_no NUMBER(3) PRIMARY key ,
resultt VARCHAR2(8),
s_date DATE,
s_time varchar2(50),
locatoin VARCHAR2(8),
rec_file_no NUMBER(3),
don_file_no NUMBER(3),
FOREIGN key (rec_file_no) REFERENCES Recipient(file_no) on delete cascade,
FOREIGN key (don_file_no) REFERENCES Donor(file_no)on delete cascade );

insert into Surgery values (1,'+','01-nov-2023','12:00','RYADH',1,5);
insert into Surgery values (2,'-','20-sep-2023','15:00','RYADH',2,1);
insert into Surgery values (3,'+','04-nov-2023','13:00','RYADH',4,4);
insert into Surgery values (4,'+','09-jul-2023','18:00','RYADH',6,2);
insert into Surgery values (5,'-','10-oct-2023','07:00','RYADH',3,3);
insert into Surgery values (6,'+','02-aug-2023','14:00','RYADH',5,6);

----------------------------------------------------------------------

--CREATE INDEXS

create index REC_Name_index on Recipient(name )	tablespace Project_INDX ;
create index DON_STAT_index on Donor(life_status ) tablespace Project_INDX ;

----------------------------------------------------------------------

--CREATE FUNCTIONS

set serveroutput on;

--FUNCTION1 by Haya


create or replace Function Dlife_status (dfile_no in number) return VARCHAR2
  IS

  Dlife_status varchar2(50);
  BEGIN
  select Life_status into Dlife_status from Donor where File_no=dfile_no;
  if Dlife_status='Alive' THEN 
return 'ALIVE';

else 
return 'DEAD'; 
 end if;
  end;
  /

---------------------

--FUNCTION2 by Haya 


create or replace Function Surgery_status (FSurgery_no in number) return VARCHAR2
  IS

  FSurgery_status varchar2(50);
  BEGIN
  select resultt into FSurgery_status from Surgery where Surgery_no=FSurgery_no;
  if FSurgery_status='+' THEN 
return 'Successful';

else 
return 'Failed'; 
 end if;
  end;
  /
---------------------

-- FUNCTION3 by Reem

--Function to count total of Donors
create or replace FUNCTION T_Donor RETURN NUMBER
IS
Total_Donor NUMBER ;
BEGIN
SELECT count(*) into Total_Donor from Donor;
RETURN Total_Donor;
END ;
/

---------------------

--CALLING FUNCTION

-- call FUNCTION 1 
  BEGIN
  dbms_output.put_line(Dlife_status(2));
  end;
  /

-- call FUNCTION 2
  BEGIN
  dbms_output.put_line(Surgery_status(4));
  end;
  /

-- call FUNCTION 3
  set serveroutput on
  DECLARE
  TotalDonor NUMBER;
  BEGIN
  TotalDonor:=T_Donor;
  dbms_output.put_line('The total of Donors is: '|| TotalDonor);
  end;
  /
-------------------------------------------------------------------------------

--CREATE PROCEDURES

--Create PROCEDURE1 by RAZAN
SET serveroutput ON;
CREATE OR REPLACE PROCEDURE Liver2 (Liver_SIZE IN NUMBER)
 IS
 BEGIN
 if (Liver_SIZE <55) then
 dbms_output.put_line('Could you');
 else
 dbms_output.put_line('I can not');
 end if;
 end;
 /
 
 
 DECLARE
 LiverSIZE NUMBER;
 BEGIN
 LiverSIZE :=&LiverSIZE;
 Liver2(LiverSIZE);
 end;
 /



---------------------

--Create PROCEDURE2 by fatima
SET serveroutput ON;
CREATE OR REPLACE PROCEDURE doctorpatients (doctoridd IN number) 
IS countt number ;
Ccount number ;
 BEGIN
 select count(*) into countt 
 from Donor 
 where  doctor_id=doctoridd;
 select count(*) into Ccount 
 from  Recipient
 where  doctor_id=doctoridd;
If (countt+ccount > 2)  then
 dbms_output.put_line('Doctor has Reached the limit');
 else 
 dbms_output.put_line('Doctor has not Reached the limit ,more patients can be added');
 end if;
 end;
 /
 
 DECLARE
 DoctorID number;
 BEGIN
  DoctorID:=&DoctorID;
 doctorpatients(DoctorID);
 end;
 /
---------------------

 --Create PROCEDURE3 by fatima
 CREATE or Replace PROCEDURE IS_There_Is_Surgeries(serchdate IN date)
IS 
total number(3);
BEGIN
select COUNT(*) into total 
from Surgery 
WHERE s_date=serchdate;
if (total > 0) then 
dbms_output.put_line('There is '||total || ' Surgeries at the selected date');
else dbms_output.put_line('There is no Surgeries at the selected date ');
end if;
end;
/
DECLARE
 Selected_date date;
 BEGIN
  Selected_date:=&Selected_date;
 IS_There_Is_Surgeries(Selected_date);
 end;
 /

---------------------------------------------------------------------------------------
Create PROCEDURE4 by Bashayer


set serveroutput on;
create or REPLACE PROCEDURE IdName(i_file_no in number)
is 
d_name varchar2(20);
BEGIN
select name into d_name from Recipient where i_file_no =file_no;
dbms_output.put_line( 'name : ' ||d_name);

end
;
/

DECLARE
BEGIN
IdName(&i_file_no);

end;
/

--------------------------------------------------------------------------------------
Create PROCEDURE5 by Renad

SET serveroutput ON;
CREATE OR REPLACE PROCEDURE locatoin6 (re in varchar2)
 IS
num number;

 BEGIN
 select count(*) into num from Surgery where lower(locatoin)=lower(re);


dbms_output.put_line('the number of Surgery in '||re||'  is='|| num);

 end;
 /


DECLARE
 
 BEGIN
 locatoin6('RYADH');
 end;
/

--------------------------------------------------------------------------------------
-- Create TRIGGERS

--TRIGGER1 by Haya 
CREATE OR REPLACE TRIGGER Blood_Match

BEFORE INSERT OR UPDATE  ON Donor 
FOR EACH ROW
 
BEGIN
IF :NEW.blood_type NOT IN ('+O','+A','-O','-A','+B','+AB','-B','-AB') THEN 
raise_application_error(-20001, 'Not A Blood Type');
END IF;
END;
/

--TEST TRIGGER1

-- Error 
INSERT INTO Donor VALUES (11,'Manal', '04-jan-2002','+D',' alive ' ,3); 
-- Accepted
INSERT INTO Donor VALUES (8, 'Shaden','22-may-2012','+O',' dead ' ,5); 

---------------------

--TRIGGER2 by RAZAN
CREATE OR REPLACE TRIGGER name_v
BEFORE
insert or update on Doctor
for each row
BEGIN
if :new.name= ' ' then
raise_application_error(-20001,'the name is incorrect');
end if;
end;
/

--TEST TRIGGER2 
-- Erorr
INSERT into Doctor VALUES (9,' ');
-- Accepted
INSERT into Doctor VALUES (9,' sara ');

---------------------

--TRIGGER3 by Reem
 CREATE OR REPLACE TRIGGER Donor_age
 BEFORE insert OR UPDATE ON Donor
 for each row
 DECLARE
 BEGIN
 if
 (sysdate-:new.DOB )/365<18
 then
 raise_application_error(-20001,'Donor is under age and can not donate ');
 end if;
 END;
/


--TEST TRIGGER3
-- Error 
INSERT INTO Donor VALUES (09,'huda', '15-JAN-2015','+A',' alive ' ,3); 
-- Accepted
INSERT INTO Donor VALUES (09,'huda', '15-JAN-2002','+A',' dead ' ,3); 

---------------------

--TRIGGER4 by Fatima
  CREATE OR REPLACE TRIGGER Life_State_Change
  BEFORE
  UPDATE or update on Donor 
  FOR EACH ROW WHEN(old.life_status = 'dead')
  BEGIN
  if :new.life_status = 'alive' then
  raise_application_error(-20001,'Dead can not be Alive');
  end if;
  end;
  /

--TEST TRIGGER4 
-- Error  
UPDATE Donor SET life_status = 'alive' where file_no = 6;
-- Accepted
UPDATE Donor SET life_status = 'dead' where file_no = 1;


---------------------
--TRIGGER5 by Bashayer 

set serveroutput on  ;
create or REPLACE TRIGGER check_PostiveO
before 
insert or update on Donor
for each row 
BEGIN
if :new.blood_type!='+O'   then
RAISE_APPLICATION_ERROR(- 20001,'Donation is not possible');
end if;
end;
/


--TEST TRIGGER5
--EROOR 
INSERT into Donor VALUES(7,'razan','13-nov-1998'  ,'-A','dead ' ,3);
--Accepted
INSERT into Donor VALUES(7,'fares', '08-jan-1987' ,'+O','alive' ,3);

---------------------
--TRIGGER6 by Renad

CREATE OR REPLACE TRIGGER Surgery_conflict19
BEFORE INSERT OR UPDATE  ON Surgery
FOR EACH ROW 
declare
numm number;
BEGIN
SELECT COUNT(*) INTO numm FROM Surgery 
where s_time=:NEW.s_time and s_date=:NEW.s_date;
IF numm>=1 THEN
   raise_application_error(-20001, 'you can not');
END IF;
END;
/


--TEST TRIGGER5
--EROOR 
insert into Surgery values (11,'+','01-nov-2023','12:00','RYADH',1,5);
--Accepted
insert into Surgery values (12,'+','08-jan-2013','12:00','RYADH',1,5);








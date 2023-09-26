-- 1. Create new schema as alumni
USE alumni;
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 2. Import all .csv files into MySQL. 
SHOW TABLES;
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 3. Run SQL command to see the structure of six tables. 
DESC college_a_hs;
DESC college_a_sj;
DESC college_a_se;
DESC college_b_hs;
DESC college_b_sj;
DESC college_b_se;
# ---------------------------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 6. Perform data cleaning on table College_A_HS and store cleaned data in view College_A_HS_V, Remove null values. 
CREATE VIEW College_A_HS_V AS (SELECT * FROM college_a_hs WHERE 
                   RollNo IS NOT NULL AND 
                  LastUpdate IS NOT NULL AND 
                  Name IS NOT NULL AND 
                  FatherName IS NOT NULL AND 
                  MotherName IS NOT NULL AND 
                  Batch IS NOT NULL AND
                  Degree IS NOT NULL AND 
                  PresentStatus IS NOT NULL AND
                  HSDegree IS NOT NULL AND 
                  EntranceExam IS NOT NULL AND 
                  Institute IS NOT NULL AND 
                  Location IS NOT NULL );
SELECT * FROM College_A_HS_V;
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 7. Perform data cleaning on table College_A_SE and store cleaned data in view College_A_SE_V, Remove null values. 
CREATE VIEW College_A_SE_V AS (SELECT * FROM college_a_se WHERE 
                   RollNo IS NOT NULL AND 
                  LastUpdate IS NOT NULL AND 
                  Name IS NOT NULL AND 
                  FatherName IS NOT NULL AND 
                  MotherName IS NOT NULL AND 
                  Batch IS NOT NULL AND
                  Degree IS NOT NULL AND 
                  PresentStatus IS NOT NULL AND
                  Organization IS NOT NULL AND 
                  Location IS NOT NULL );
SELECT * FROM College_A_SE_V;
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 8. Perform data cleaning on table College_A_SJ and store cleaned data in view College_A_SJ_V, Remove null values.
CREATE VIEW College_A_SJ_V AS (SELECT * FROM college_a_sj WHERE 
                  Name IS NOT NULL AND 
                  FatherName IS NOT NULL AND 
                  MotherName IS NOT NULL AND 
                  Batch IS NOT NULL AND
                  Degree IS NOT NULL AND 
                  PresentStatus IS NOT NULL AND
                  Organization IS NOT NULL AND 
                  Designation IS NOT NULL AND 
                  Location IS NOT NULL );
SELECT * FROM College_A_SJ_V;
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 9. Perform data cleaning on table College_B_HS and store cleaned data in view College_B_HS_V, Remove null values. 
CREATE VIEW College_B_HS_V AS (SELECT * FROM college_b_hs WHERE
                  RollNo IS NOT NULL AND
                  lastUpdate IS NOT NULL AND 
                  Name IS NOT NULL AND 
                  FatherName IS NOT NULL AND 
                  MotherName IS NOT NULL AND
                  Branch IS NOT NULL AND 
                  Batch IS NOT NULL AND
                  Degree IS NOT NULL AND 
                  PresentStatus IS NOT NULL AND
                  HSDegree IS NOT NULL AND 
				  EntranceExam IS NOT NULL AND 
                  Institute IS NOT NULL AND 
                  Location IS NOT NULL );
SELECT * FROM College_B_HS_V; 
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 10. Perform data cleaning on table College_B_SE and store cleaned data in view College_B_SE_V, Remove null values. 
CREATE VIEW College_B_SE_V AS (SELECT * FROM college_b_se WHERE
                  RollNo IS NOT NULL AND
                  lastUpdate IS NOT NULL AND 
                  Name IS NOT NULL AND 
                  FatherName IS NOT NULL AND 
                  MotherName IS NOT NULL AND
                  Branch IS NOT NULL AND 
                  Batch IS NOT NULL AND
                  Degree IS NOT NULL AND 
                  PresentStatus IS NOT NULL AND
                  Organization IS NOT NULL AND 
                  Location IS NOT NULL );
SELECT * FROM College_B_SE_V;
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 11. Perform data cleaning on table College_B_SJ and store cleaned data in view College_B_SJ_V, Remove null values. 
CREATE VIEW College_B_SJ_V AS (SELECT * FROM college_b_sj WHERE
                  RollNo IS NOT NULL AND
                  lastUpdate IS NOT NULL AND 
                  Name IS NOT NULL AND 
                  FatherName IS NOT NULL AND 
                  MotherName IS NOT NULL AND
                  Branch IS NOT NULL AND 
                  Batch IS NOT NULL AND
                  Degree IS NOT NULL AND 
                  PresentStatus IS NOT NULL AND
				  Organization IS NOT NULL AND 
				  Designation IS NOT NULL AND 
                  Location IS NOT NULL );
SELECT * FROM College_B_SJ_V; 
# ---------------------------------------------------------------------------------------------------------------------------------------
-- 12. Make procedure to use string function/s for converting record of Name, FatherName, MotherName into lower case for views (College_A_HS_V, College_A_SE_V, 
-- College_A_SJ_V, College_B_HS_V, College_B_SE_V, College_B_SJ_V) 
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_A_HS_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_A_SJ_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_A_SE_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_B_HS_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_B_SJ_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_B_SE_V;
#-------------------------------------------------------------------------------------------------------------------------------------
-- 14.Write a query to create procedure get_name_collegeA using the cursor to fetch names of all students from college A. 
 
DELIMITER $$ 
CREATE PROCEDURE get_name_CollegeA (INOUT Name1 TEXT (40000) )
BEGIN 
   DECLARE done INT DEFAULT 0;
   DECLARE name_list VARCHAR (16000) DEFAULT "";
   
   DECLARE name_detail 
      CURSOR FOR 
      SELECT Name FROM college_a_hs UNION 
        SELECT Name FROM college_a_sj UNION 
          SELECT Name FROM college_a_se;
   DECLARE CONTINUE HANDLER 
      FOR NOT FOUND SET done = 1;
   OPEN name_detail;

get_name:
   LOOP 
    FETCH FROM name_detail INTO name_list;
    IF done = 1 THEN LEAVE get_name;
    END IF;
    SET Name1 = CONCAT (name_list," ; ",Name1);
END LOOP get_name;
CLOSE name_detail;
END $$
DELIMITER ;

SET @Name1 = "";
CALL get_name_CollegeA(@Name1);
SELECT @Name1 Name;
# -----------------------------------------------------------------------------------------------------------------------------------
-- 15. Write a query to create procedure get_name_collegeB using the cursor to fetch names of all students from college B. 
DELIMITER $$ 
CREATE PROCEDURE get_name_CollegeB (INOUT Name2 TEXT (40000) )
BEGIN 
   DECLARE done INT DEFAULT 0;
   DECLARE Namelist VARCHAR (16000) DEFAULT "";
   
   DECLARE Namedetail 
      CURSOR FOR 
      SELECT Name FROM college_b_hs UNION 
        SELECT Name FROM college_b_sj UNION 
          SELECT Name FROM college_b_se;
   DECLARE CONTINUE HANDLER 
      FOR NOT FOUND SET done = 1;
   OPEN Namedetail;

getname:
   LOOP 
    FETCH FROM Namedetail INTO Namelist;
    IF done = 1 THEN LEAVE getname;
    END IF;
    SET Name2 = CONCAT (Namelist," ; ",Name2);
END LOOP getname;
CLOSE Namedetail;
END $$
DELIMITER ;
SET @Name2 = "";
CALL get_name_CollegeB(@Name2);
SELECT @Name2 B_Name;
# -------------------------------------------------------------------------------------------------------------------------------------
-- 16. Calculate the percentage of career choice of College A and College B Alumni
-- (w.r.t Higher Studies, Self Employed and Service/Job) 
SELECT "Higher Studies" Present_status,(COUNT(college_a_hs.RollNo) /(college_a_hs.RollNo))*100 College_A_Percentage,
                (COUNT(college_b_hs.RollNo)/(college_b_hs.RollNo))*100 College_B_Percentage FROM college_a_hs 
                       CROSS JOIN college_b_hs 
		UNION 
SELECT "Self Empolyment" Present_status,(COUNT(college_a_se.RollNo) /(college_a_se.RollNo))*100 College_A_Percentage,
                 (COUNT(college_b_se.RollNo)/(college_b_se.RollNo))*100 College_B_Percentage FROM college_a_se 
					   CROSS JOIN college_b_se 
		UNION
SELECT "Service Job" Present_status,(COUNT(college_a_sj.RollNo) /(college_a_sj.RollNo))*100 College_A_Percentage, 
                 (COUNT(college_b_sj.RollNo)/(college_b_sj.RollNo))*100 College_B_Percentage FROM college_a_sj 
					   CROSS JOIN college_b_sj
                       


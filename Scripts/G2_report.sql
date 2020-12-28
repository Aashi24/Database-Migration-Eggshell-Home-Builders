REM Summarizes the sales record for each employee

REM INSERTING into EXPORT_TABLE
REM select s.staff_id, s.staff_name, s.title, sa.sale_id, sa.sale_date, sa.financing_method, sa.escrow_deposit,
REM Count(sa.sale_id) over(partition by s.staff_id) as Total_Sales
REM from staff s left outer join sales sa
REM on s.staff_id = sa.staff_id;

SET DEFINE OFF;
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (1,'Mill Seller','Sales',1,to_date('24-MAY-19','DD-MON-RR'),'20 year with 20%down',50000,2);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (1,'Mill Seller','Sales',2,to_date('24-JAN-19','DD-MON-RR'),'10 year with 15%down',80000,2);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (2,'Choice King','Choice Consulter',3,to_date('02-JUN-17','DD-MON-RR'),'10 year with 15%down',58000,2);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (2,'Choice King','Choice Consulter',5,to_date('23-AUG-20','DD-MON-RR'),'5 year with 8%down',65000,2);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (3,' Wanna Champion','Sales',6,to_date('10-DEC-19','DD-MON-RR'),'15 year with 18%down',850000,2);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (3,' Wanna Champion','Sales',4,to_date('04-FEB-18','DD-MON-RR'),'20 year with 20%down',75000,2);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (4,'Kuz Discount','Sales',7,to_date('08-MAY-20','DD-MON-RR'),'20 year with 20%down',45000,1);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (5,'Best Seal','Choice Consulter',8,to_date('30-AUG-19','DD-MON-RR'),'10 year with 15%down',50000,1);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (6,'Tax Love','Manager',9,to_date('28-MAY-18','DD-MON-RR'),'15 year with 18%down',60000,1);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (7,'Paul Butter','Supervisor',null,null,null,null,0);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (8,'Paul Wall','Construction Advisor',10,to_date('13-MAR-19','DD-MON-RR'),'10 year with 15%down',90000,1);
Insert into EXPORT_TABLE (STAFF_ID,STAFF_NAME,TITLE,SALE_ID,SALE_DATE,FINANCING_METHOD,ESCROW_DEPOSIT,TOTAL_SALES) values (9,'Stick Tan','Construction Advisor',null,null,null,null,0);



REM Summarizes the information of all lots in each subdivision

REM INSERTING into EXPORT_TABLE
REM select s.subdivision_id, s.school_district, s.subdivision_name, l.lot_id, l.street, l.city, count(l.lot_id) over(partition by s.subdivision_id) as Total_lots
REM from subdivision s left outer join lot l
REM on s.subdivision_id = l.subdivision_id

SET DEFINE OFF;
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (1,'Gaokao Town','Happy Garden',1,'1 Strawberry Rd.','Austin',2);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (1,'Gaokao Town','Happy Garden',3,'312 Boolean Rd.','Austin',2);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (2,'Kid Heaven Street','Care You',2,'32 Blue Rd.','Austin',2);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (2,'Kid Heaven Street','Care You',4,'12 Trevor Rd.','New York',2);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (3,'Gap Land','Must find a middle school elsewhere',5,'765 Sanford St.','New York',3);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (3,'Gap Land','Must find a middle school elsewhere',11,'90 Young Ave.','Pittsburgh',3);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (3,'Gap Land','Must find a middle school elsewhere',6,'39 Lake St.',' Pittsburgh',3);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (4,'Washington Town','One school with a 12-year education',22,'980 Yeager Ave.','San Diego',2);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (4,'Washington Town','One school with a 12-year education',12,'79 Liver St.','San Diego',2);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (5,'Hola Street','Church Schools',null,null,null,0);
Insert into EXPORT_TABLE (SUBDIVISION_ID,SCHOOL_DISTRICT,SUBDIVISION_NAME,LOT_ID,STREET,CITY,TOTAL_LOTS) values (6,'Chuff Town','Chuff do not care education',31,'430 Winter Ave.','San Diego',1);

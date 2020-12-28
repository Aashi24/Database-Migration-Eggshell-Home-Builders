REM Create tables

DROP TABLE bank CASCADE CONSTRAINTS;
DROP TABLE buyer CASCADE CONSTRAINTS;
DROP TABLE buyer_choice CASCADE CONSTRAINTS;
DROP TABLE construction CASCADE CONSTRAINTS;
DROP TABLE elevation CASCADE CONSTRAINTS;
DROP TABLE escrow_agent CASCADE CONSTRAINTS;
DROP TABLE lot CASCADE CONSTRAINTS;
DROP TABLE options CASCADE CONSTRAINTS;
DROP TABLE room CASCADE CONSTRAINTS;
DROP TABLE sales CASCADE CONSTRAINTS;
DROP TABLE staff CASCADE CONSTRAINTS;
DROP TABLE style CASCADE CONSTRAINTS;
DROP TABLE style_subdivision CASCADE CONSTRAINTS;
DROP TABLE subdivision CASCADE CONSTRAINTS;
DROP TABLE task CASCADE CONSTRAINTS;
DROP TABLE task_progress CASCADE CONSTRAINTS;

CREATE TABLE bank (
    bank_id     NUMBER(20) NOT NULL,
    bank_name   VARCHAR2(25) NOT NULL,
    phone       NUMBER(10) NOT NULL,
    fax         NUMBER(15),
    street      VARCHAR2(40) NOT NULL,
    city        VARCHAR2(25) NOT NULL,
    state       VARCHAR2(2) NOT NULL,
    zip         VARCHAR2(10) NOT NULL
);

ALTER TABLE bank ADD CONSTRAINT bank_pk PRIMARY KEY ( bank_id );

CREATE TABLE buyer (
    buyer_id   NUMBER(20) NOT NULL,
    fname      VARCHAR2(15) NOT NULL,
    lname      VARCHAR2(15) NOT NULL,
    street     VARCHAR2(40) NOT NULL,
    city       VARCHAR2(25) NOT NULL,
    state      VARCHAR2(2) NOT NULL,
    zip        VARCHAR2(10) NOT NULL
);

ALTER TABLE buyer ADD CONSTRAINT buyer_pk PRIMARY KEY ( buyer_id );

CREATE TABLE buyer_choice (
    choice_id           NUMBER(20) NOT NULL,
    choice_date         DATE NOT NULL,
    choice_category     VARCHAR2(20),
    room_id             NUMBER(20),
    option_id           NUMBER(10) NOT NULL,
    stage               NUMBER(1) NOT NULL,
    staff_id            NUMBER(15),
    position_details    VARCHAR2(100),
    brand_name          VARCHAR2(100),
    lot_id                   NUMBER(10) NOT NULL
);

ALTER TABLE buyer_choice ADD CONSTRAINT buyer_choice_pk PRIMARY KEY ( choice_id );

CREATE TABLE construction (
    progress_id      NUMBER(20) NOT NULL,
    stage            NUMBER(1) NOT NULL,
    progress_date    DATE,
    staff_id         NUMBER(15),
    lot_id           NUMBER(10) NOT NULL,
    CONSTRAINT CHK_cons_stage CHECK (stage in (1,4,7))
);

ALTER TABLE construction ADD CONSTRAINT construction_pk PRIMARY KEY ( progress_id );

CREATE TABLE elevation (
    elevation_type   VARCHAR2(5) NOT NULL,
    description      VARCHAR2(100) NOT NULL,
    cost_added       NUMBER(8, 2) NOT NULL
);

ALTER TABLE elevation ADD CONSTRAINT elevation_pk PRIMARY KEY ( elevation_type );

CREATE TABLE escrow_agent (
    agent_id   NUMBER(20) NOT NULL,
    fname      VARCHAR2(15) NOT NULL,
    lname      VARCHAR2(15) NOT NULL,
    street     VARCHAR2(40),
    city       VARCHAR2(25),
    state      VARCHAR2(2) NOT NULL,
    zip        VARCHAR2(10) NOT NULL
);

ALTER TABLE escrow_agent ADD CONSTRAINT escrow_agent_pk PRIMARY KEY ( agent_id );

CREATE TABLE lot (
    lot_id                       NUMBER(10) NOT NULL,
    elevation_type  			 VARCHAR2(5) NOT NULL,
    street                       VARCHAR2(40),
    city                         VARCHAR2(25),
    state                        VARCHAR2(2),
    zip_code                     VARCHAR2(10),
    latitiude                    NUMBER(3),
    longitude                    NUMBER(3),
    reversed                     CHAR(1),
    subdivision_id               NUMBER(10) NOT NULL,
    style_id                     NUMBER(2) NOT NULL
);

ALTER TABLE lot ADD CONSTRAINT lot_pk PRIMARY KEY ( lot_id );

CREATE TABLE options (
    option_id     NUMBER(10) NOT NULL,
    description   VARCHAR2(100) NOT NULL,
    category      VARCHAR2(20) NOT NULL,
    stage         NUMBER(1) NOT NULL,
    cost          NUMBER(10, 2) NOT NULL,
    CONSTRAINT CHK_option_stage CHECK (stage in (1,4,7))
);

ALTER TABLE options ADD CONSTRAINT options_pk PRIMARY KEY ( option_id,
                                                            stage );

CREATE TABLE room (
    room_id          NUMBER(20) NOT NULL,
    room_size        NUMBER(5, 2) NOT NULL,
    floor            NUMBER(2),
    comments         VARCHAR2(100),
    num_of_windows   NUMBER(2),
    ceiling          VARCHAR2(50),
    style_id           NUMBER(10) NOT NULL
);

ALTER TABLE room ADD CONSTRAINT room_pk PRIMARY KEY ( room_id );

CREATE TABLE sales (
    sale_id                  NUMBER(20) NOT NULL,
    sale_date                DATE NOT NULL,
    financing_method         VARCHAR2(50) NOT NULL,
    escrow_deposit           NUMBER(8, 2) NOT NULL,
    est_date_of_completion   DATE NOT NULL,
    bank_id                  NUMBER(20) NOT NULL,
    agent_id                 NUMBER(20) NOT NULL,
    buyer_id                 NUMBER(20) NOT NULL,
    staff_id                 NUMBER(15),
    lot_id                   NUMBER(10) NOT NULL
);


ALTER TABLE sales ADD CONSTRAINT sales_pk PRIMARY KEY ( sale_id );

CREATE TABLE staff (
    staff_id      NUMBER(15) NOT NULL,
    staff_name    VARCHAR2(25) NOT NULL,
    dob           DATE,
    title        VARCHAR2(20) NOT NULL,
    phone_num     NUMBER(10) NOT NULL,
    license_num   NUMBER(10) NOT NULL
)
LOGGING;

ALTER TABLE staff ADD CONSTRAINT staff_pk PRIMARY KEY ( staff_id );

CREATE TABLE style (
    style_id      NUMBER(2) NOT NULL,
    style_name    VARCHAR2(20) NOT NULL,
    description   VARCHAR2(100) NOT NULL,
    base_price    NUMBER(12, 2) NOT NULL,
    style_size    NUMBER(8, 2)
);

ALTER TABLE style ADD CONSTRAINT style_pk PRIMARY KEY ( style_id );

CREATE TABLE style_subdivision (
    subdivision_id         NUMBER(10) NOT NULL,
    style_id               NUMBER(2) NOT NULL
);

ALTER TABLE style_subdivision ADD CONSTRAINT style_subdivision_pk PRIMARY KEY ( subdivision_id,
                                                                                style_id );

CREATE TABLE subdivision (
    subdivision_id      NUMBER(10) NOT NULL,
    school_district     VARCHAR2(40) NOT NULL,
    elementary_school   VARCHAR2(40) NOT NULL,
    middle_school       VARCHAR2(40) NOT NULL,
    high_school         VARCHAR2(40) NOT NULL,
    subdivision_name    VARCHAR2(40) NOT NULL
);

ALTER TABLE subdivision ADD CONSTRAINT subdivision_pk PRIMARY KEY ( subdivision_id );

CREATE TABLE task (
    task_id       NUMBER(10) NOT NULL,
    description   VARCHAR2(100) NOT NULL
);

ALTER TABLE task ADD CONSTRAINT task_pk PRIMARY KEY ( task_id );

CREATE TABLE task_progress (
    percent_complete           NUMBER(3) NOT NULL,
    est_completion_date        DATE NOT NULL,
    task_id                    NUMBER(10) NOT NULL,
    progress_id            NUMBER(20) NOT NULL
);

ALTER TABLE task_progress ADD CONSTRAINT task_progress_pk PRIMARY KEY ( task_id,
                                                                        progress_id );


ALTER TABLE buyer_choice
    ADD CONSTRAINT buyer_choice_lot_fk FOREIGN KEY ( lot_id )
        REFERENCES lot ( lot_id );

ALTER TABLE buyer_choice
    ADD CONSTRAINT buyer_choice_options_fk FOREIGN KEY ( option_id, stage )
        REFERENCES options ( option_id, stage );

ALTER TABLE buyer_choice
    ADD CONSTRAINT buyer_choice_staff_fk FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );

ALTER TABLE construction
    ADD CONSTRAINT construction_lot_fk FOREIGN KEY ( lot_id )
        REFERENCES lot ( lot_id )
    NOT DEFERRABLE;

ALTER TABLE construction
    ADD CONSTRAINT construction_staff_fk FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );

ALTER TABLE lot
    ADD CONSTRAINT lot_elevation_fk FOREIGN KEY ( elevation_type )
        REFERENCES elevation ( elevation_type );

ALTER TABLE lot
    ADD CONSTRAINT lot_style_fk FOREIGN KEY ( style_id )
        REFERENCES style ( style_id );

ALTER TABLE lot
    ADD CONSTRAINT lot_subdivision_fk FOREIGN KEY ( subdivision_id )
        REFERENCES subdivision ( subdivision_id );

ALTER TABLE room
    ADD CONSTRAINT room_style_fk FOREIGN KEY ( style_id )
        REFERENCES style (style_id );

ALTER TABLE sales
    ADD CONSTRAINT sales_bank_fk FOREIGN KEY ( bank_id )
        REFERENCES bank ( bank_id );

ALTER TABLE sales
    ADD CONSTRAINT sales_buyer_fk FOREIGN KEY ( buyer_id )
        REFERENCES buyer ( buyer_id );

ALTER TABLE sales
    ADD CONSTRAINT sales_escrow_agent_fk FOREIGN KEY ( agent_id )
        REFERENCES escrow_agent ( agent_id );

ALTER TABLE sales
    ADD CONSTRAINT sales_lot_fk FOREIGN KEY ( lot_id )
        REFERENCES lot ( lot_id );

ALTER TABLE sales
    ADD CONSTRAINT sales_staff_fk FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );

ALTER TABLE style_subdivision
    ADD CONSTRAINT style_subdivision_style_fk FOREIGN KEY ( style_id )
        REFERENCES style ( style_id );

ALTER TABLE style_subdivision
    ADD CONSTRAINT style_subdivision_sub_fk FOREIGN KEY ( subdivision_id )
        REFERENCES subdivision ( subdivision_id );

ALTER TABLE task_progress
    ADD CONSTRAINT task_progress_construction_fk FOREIGN KEY ( progress_id )
        REFERENCES construction ( progress_id );

ALTER TABLE task_progress
    ADD CONSTRAINT task_progress_task_fk FOREIGN KEY ( task_id )
        REFERENCES task ( task_id );



REM Create sequences

DROP SEQUENCE subdivition_seq;
DROP SEQUENCE room_seq;
DROP SEQUENCE choice_seq;
DROP SEQUENCE sales_seq;
DROP SEQUENCE staff_seq;
DROP SEQUENCE buyer_seq;

CREATE SEQUENCE subdivition_seq
    START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE SEQUENCE room_seq
    START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE SEQUENCE choice_seq
    START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE SEQUENCE sales_seq
    START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE SEQUENCE staff_seq
    START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE SEQUENCE buyer_seq
    START WITH 1
INCREMENT BY 1
CACHE 10;



REM Insert data 
-- bank table
INSERT INTO bank VALUES
(001, 'City Bank', 1234567890, 0987654321, '2 Berger Rd.', 'Austin', 'TX', '78796');
INSERT INTO bank VALUES
(002, 'Bank of America', 1364578903, 0653438601, '45 Queen Rd.', 'New York', 'NY', '19986');
INSERT INTO bank VALUES
(003, 'PNC Bank', 4123476390, 0764234159, '5837 Centre Ave.', 'Pittsburgh', 'PA', '15213');
INSERT INTO bank VALUES
(004, 'Chase Bank', 4123468990, 0644198159, '87 Phillips Ave.', 'Pittsburgh', 'PA', '15217');
INSERT INTO bank VALUES
(005, 'Paris Bank', 5104687709, 0445134219, '621 King Rd.', 'San Diego', 'CA', '74217');
INSERT INTO bank VALUES
(035, 'ABC Bank', 796425069, 0517634207, '61 Prince Rd.', 'Los Angeles', 'CA', '56627');



-- staff table
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Mill Seller', '02-OCT-1983', 'Sales', 6677781245, 12345); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Choice King', '04-JAN-1978', 'Choice Consulter', 3258747333, 88888); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL,' Wanna Champion', '17-JAN-1990', 'Sales', 3378458183, 12356); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Kuz Discount', '24-SEP-1983', 'Sales', 6677743344, 12349); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Best Seal', '15-DEC-1979', 'Choice Consulter', 3258798800,88890); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Tax Love', '12-OCT-1983', 'Manager', 4536727990, 99000); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Paul Butter',' 22-OCT-1983', 'Supervisor', 3350996123, 99999); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Paul Wall',' 8-JUL-1963', 'Construction Advisor', 3613628673, 23596); 
INSERT INTO staff VALUES
(staff_seq.NEXTVAL, 'Stick Tan',' 22-OCT-1983', 'Construction Advisor', 3356783786, 23679); 


-- style table
INSERT INTO style VALUES
(1, 'China Town', 'A popular chinese style with American factors', 30000, 3062.3);
INSERT INTO style VALUES
(2, 'Renaissance', 'A replica of Donato Bramante style', 70000, 5054.5);
INSERT INTO style VALUES
(3, 'Roman', 'An elegant and imposing design with high ceiling and encourage by ancient civilization ', 60050, 4540);
INSERT INTO style VALUES
(4, 'American', 'A modern style which is a representative of American freedom ', 73100, 5340.87);



-- subdivision table
INSERT INTO subdivision VALUES
(subdivition_seq.NEXTVAL,'Gaokao Town', 'Dream Primary School','Dream Middle School', 'Dream High School', 'Happy Garden'); 
INSERT INTO subdivision VALUES
(subdivition_seq.NEXTVAL,'Kid Heaven Street','Happiness Private', 'Gaming Middle School','Homelike High School', 'Care You'); 
INSERT INTO subdivision VALUES
(subdivition_seq.NEXTVAL,'Gap Land','Sky Elementary School', 'None','Hardworking High School', 'Must find a middle school elsewhere'); 
INSERT INTO subdivision VALUES
(subdivition_seq.NEXTVAL,'Washington Town','Washington Private', 'Washington Private','Washington Private', 'One school with a 12-year education'); 
INSERT INTO subdivision VALUES
(subdivition_seq.NEXTVAL,'Hola Street','Hunter College Elementary School', 'St.Louis Middle','St.Angela High School', 'Church Schools'); 
INSERT INTO subdivision VALUES
(subdivition_seq.NEXTVAL,'Chuff Town', 'None','None','None', 'Chuff do not care education'); 



-- style_subdivision table
INSERT INTO style_subdivision VALUES
(1, 1);
INSERT INTO style_subdivision VALUES
(1, 2);
INSERT INTO style_subdivision VALUES
(1, 4);
INSERT INTO style_subdivision VALUES
(2, 2);
INSERT INTO style_subdivision VALUES
(2, 4);
INSERT INTO style_subdivision VALUES
(3, 1);
INSERT INTO style_subdivision VALUES
(3, 2);
INSERT INTO style_subdivision VALUES
(4, 3);
INSERT INTO style_subdivision VALUES
(4, 4);
INSERT INTO style_subdivision VALUES
(6, 4);



-- elevation table
INSERT INTO elevation VALUES
('A', 'Standard', 0);
INSERT INTO elevation VALUES
('B', 'Luxury', 12500);
INSERT INTO elevation VALUES
('C', 'Emperor', 30000);



-- buyer table
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'James',  'Johnson', '4 Frog Rd.', 'Austin', 'TX', '78769');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Amy',  'Dennis', '45 Fly Rd.', 'Austin', 'TX', '78239');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Bob',  'Young', '87 Amberson Ave.', 'Pittsburgh', 'PA', '15322');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Billy',  'Yang', '007 Amber Ave.', 'New York', 'NY', '57553');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Cathy',  'Hiller', '61 Abbey Ave.', 'New York', 'NY', '57153');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Don',  'Hugh', '43 Bolton Rd.', 'New York', 'NY', '53139');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Emma',  'Costa', '77 Craig St.', 'Austin', 'TX', '71349');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Frank',  'Snow', '887 River Rd.', 'Pittsburgh', 'PA', '32309');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Julia',  'Smith', '823 Piano St.', 'Philadelphia', 'PA', '13229');
INSERT INTO buyer VALUES
(buyer_seq.NEXTVAL, 'Ketty',  'Oyster', '7321 Centre St.', 'Philadelphia', 'PA', '12789');



-- escrow_agent table
INSERT INTO escrow_agent VALUES
(001, 'Bill',  'Anderson', '2 Berger Rd.', 'Austin', 'TX', '78796');
INSERT INTO escrow_agent VALUES
(024, 'Mike',  'Jordan', '233 Bell Rd.', 'Austin', 'TX', '79886');
INSERT INTO escrow_agent VALUES
(163, 'David',  'Miller', '533 Blake St.', 'Austin', 'TX', '75196');
INSERT INTO escrow_agent VALUES
(434, 'Watch',  'Swift', '4512 Nicholas Ave.', 'New York', 'NY', '38796');
INSERT INTO escrow_agent VALUES
(075, 'Cathy',  'Cao', '532 Dan Rd.',  'New York', 'NY', '35716');
INSERT INTO escrow_agent VALUES
(116, 'Junkum',  'Lee', '987 Dell Ave.', 'Pittsburgh', 'PA', '32309');




-- lot table
INSERT INTO lot VALUES
(1,'A','1 Strawberry Rd.', 'Austin', 'TX', '78012', 30, -97, 'N', 1, 1);
INSERT INTO lot VALUES
(2,'A','32 Blue Rd.', 'Austin', 'TX', '70922', 33, -93, 'Y', 2, 1); 
INSERT INTO lot VALUES
(3,'A','312 Boolean Rd.', 'Austin', 'TX', '72741', 23, -74, 'Y', 1, 1); 
INSERT INTO lot VALUES
(4,'B','12 Trevor Rd.', 'New York', 'NY', '37541', 43, -64, 'Y', 2, 1); 
INSERT INTO lot VALUES
(5,'B','765 Sanford St.', 'New York', 'NY', '32741', 58, -54, 'N', 3, 1); 
INSERT INTO lot VALUES
(6,'A','39 Lake St.',' Pittsburgh', 'PA', '31301', 53, -34, 'Y', 3, 1); 
INSERT INTO lot VALUES
(11,'C','90 Young Ave.', 'Pittsburgh', 'PA', '32509', 52, -47, 'N', 3, 2); 
INSERT INTO lot VALUES
(12,'B','79 Liver St.', 'San Diego', 'CA', '74217', 23, -94, 'Y', 4, 2); 
INSERT INTO lot VALUES
(22,'C','980 Yeager Ave.', 'San Diego', 'CA', '73427', 28, -87, 'N', 4, 3); 
INSERT INTO lot VALUES
(31,'C','430 Winter Ave.', 'San Diego', 'CA', '74247', 23, -65, 'Y', 6, 4); 




-- options table
INSERT INTO options VALUES
(1027, 'Wire for ceiling fan', 'Electrical', 4, 125);
INSERT INTO options VALUES
(1027, 'Wire for ceiling fan', 'Electrical', 7, 350);
INSERT INTO options VALUES
(2010, 'Sink in garage', 'Plumbing', 1, 450);
INSERT INTO options VALUES
(4114, 'Carpet-level 4', 'Interior', 7, 800);
INSERT INTO options VALUES
(4116, 'Carpet-level 6', 'Interior', 7, 1200);
INSERT INTO options VALUES
(4062, 'Fixture upgrade', 'Interior', 1, 225);
INSERT INTO options VALUES
(1022, 'Electrical outlet', 'Electrical', 4, 515);
INSERT INTO options VALUES
(1027, 'Wire for light', 'Electrical', 1, 425);
INSERT INTO options VALUES
(3402, 'Phone jack', 'Interior', 7, 225);
INSERT INTO options VALUES
(4062, 'Fixture upgrade', 'Interior', 4, 425);



-- room table
INSERT INTO room VALUES
(room_seq.NEXTVAL,374,2,'Master Room',1,'Classical Fans',1);
INSERT INTO room VALUES
(room_seq.NEXTVAL,461,3,'Bath Room',0,'Auto Air-con',1);
INSERT INTO room VALUES
(room_seq.NEXTVAL,597,3,'Game Room',1,'Auto Air-con and Chandelier',2);
INSERT INTO room VALUES
(room_seq.NEXTVAL,520,3,'Study',1,'Classical Fans',2);
INSERT INTO room VALUES
(room_seq.NEXTVAL,489,3,'Bath Room',0,'Classical Fans',3);
INSERT INTO room VALUES
(room_seq.NEXTVAL,334,1,'Kitchen',1,'Classical Fans',4);
INSERT INTO room VALUES
(room_seq.NEXTVAL,431,2,'Master Room',1,'Auto Air-con',4);
INSERT INTO room VALUES
(room_seq.NEXTVAL,393,2,'Game Room',2,'Classical Fans',3);
INSERT INTO room VALUES
(room_seq.NEXTVAL,575,2,'Master Room',2,'Auto Air-con and Chandelier',3);
INSERT INTO room VALUES
(room_seq.NEXTVAL,348,1,'Study',1,'Classical Fans',2);


-- buyer_choice table
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '26-MAY-2020',  'Electrical', 1, 1027, 4, 1, '', '', 1);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '02-MAY-2019',  'Electrical', 2, 1027, 7, 1, '', '', 1);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '02-OCT-2020',  'Plumbing', 3, 2010, 1, 1, 'Bedroom', 'Rome', 2);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '26-NOV-2019',  'Electrical', 4, 1027, 4, 3, '', '', 2);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '12-DEC-2019',  'Electrical', 5, 1027, 7, 3, '', 'Rome', 3);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '05-APR-2019',  'Interior', 6, 4116, 7, 4, 'Study room decoration', 'New world', 4);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '21-JUL-2020',  'Interior', 7, 4114, 7, 4, 'Kitchen furniture', 'Happy home', 5);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '04-SEP-2018',  'Electrical', 8, 1027, 7, 2, '', '', 11);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '19-MAY-2019',  'Plumbing', 9, 2010, 1, 2, 'Garage', 'Great wall', 11);
INSERT INTO buyer_choice VALUES
(choice_seq.NEXTVAL, '10-NOV-2020',  'Interior', 10, 3402, 7, 5, 'Ceiling decoration', 'Pretty it', 12);



INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '24-MAY-2019', '20 year with 20%down', 50000,'30-MAR-2020',001,001,1,1,1); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '24-JAN-2019', '10 year with 15%down', 80000,'30-MAY-2020',001,001,2,1,2); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '2-JUN-2017', '10 year with 15%down', 58000,'30-MAY-2018',002,024,3,2,3); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '4-FEB-2018', '20 year with 20%down', 75000,'30-MAY-2020',003,163,4,3,4); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '23-AUG-2020', '5 year with 8%down', 65000,'30-MAY-2021',002,024,5,2,5); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '10-DEC-2019', '15 year with 18%down', 850000,'30-SEP-2020',004,434,6,3,6); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '8-MAY-2020', '20 year with 20%down', 45000,'1-SEP-2021', 035,075,7,4,11); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '30-AUG-2019', '10 year with 15%down', 50000,'30-JUN-2020',035,075,8,5,12); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '28-MAY-2018', '15 year with 18%down', 60000,'30-MAY-2020',005,116,9,6,22); 
INSERT INTO sales VALUES
(sales_seq.NEXTVAL, '13-MAR-2019', '10 year with 15%down', 90000,'1-DEC-2022',002,024,10,8,31); 



-- construction table
INSERT INTO construction VALUES
(1,1,'24-SEP-2019',8,1);
INSERT INTO construction VALUES
(2,1,'1-SEP-2020',9,2);
INSERT INTO construction VALUES
(3,4,'2-OCT-2018',8,3);
INSERT INTO construction VALUES
(4,4,'2-SEP-2020',8,4);
INSERT INTO construction VALUES
(5,7,'20-OCT-2019',9,11);
INSERT INTO construction VALUES
(6,7,'24-sep-2020',9,12);




INSERT INTO task VALUES
(1, 'Pipes and Wires');
INSERT INTO task VALUES
(2, 'Sewer Lines and Vents');
INSERT INTO task VALUES
(3, 'Water Supply Lines');
INSERT INTO task VALUES
(4, 'Bathtubs, Shower Units');
INSERT INTO task VALUES
(5, 'HVAC Vent Pipes');
INSERT INTO task VALUES
(6, 'Insulation');
INSERT INTO task VALUES
(7, 'Exterior Walkways and Driveway');
INSERT INTO task VALUES
(8, 'Bathroom Features');



 -- task_progress table
INSERT INTO task_progress VALUES
(70,'24-SEP-2019',1,1);
INSERT INTO task_progress VALUES
(100,'1-SEP-2020',1,2);
INSERT INTO task_progress VALUES
(0,'12-SEP-2019',2,2);
INSERT INTO task_progress VALUES
(0,'2-OCT-2018',1,3);
INSERT INTO task_progress VALUES
(100,'2-SEP-2020',1,4);
INSERT INTO task_progress VALUES
(100,'4-SEP-2019',2,4);
INSERT INTO task_progress VALUES
(100,'10-SEP-2018',3,4);
INSERT INTO task_progress VALUES
(100,'22-AUG-2017',4,4);
INSERT INTO task_progress VALUES
(100,'8-JAN-2020',5,4);
INSERT INTO task_progress VALUES
(100,'25-FEB-2019',6,4);
INSERT INTO task_progress VALUES
(100,'6-MAR-2017',7,4);
INSERT INTO task_progress VALUES
(100,'19-MAR-2018',8,4);
INSERT INTO task_progress VALUES
(100,'20-OCT-2019',1,5);
INSERT INTO task_progress VALUES
(20,'1-NOV-2020',2,5);

COMMIT;




REM Create views

REM A view of sales record, restricting to specific columns due to buyer privacy 

CREATE OR REPLACE VIEW sales_view AS
SELECT sale_id, sale_date, buyer_id, staff_id, lot_id
FROM sales
ORDER BY sale_id;


REM A view of staff record for those who are managers
REM license_num will not be available to see due to privacy

CREATE OR REPLACE VIEW staff_view AS
SELECT staff_id, staff_name, title, phone_num
FROM staff
WHERE title = 'Manager'
ORDER BY staff_id;




REM Create triggers

REM It is a before insert or update trigger on the buyer_choice table.
REM It prints out the change of options for each buyer choice and
REM also calculate if the buyer should pay more or pay less ofr changing the option.


CREATE OR REPLACE TRIGGER print_option_change
BEFORE INSERT OR UPDATE
ON buyer_choice
FOR EACH ROW
WHEN (new.staff_id IS NOT NULL)

DECLARE
    cost_diff NUMBER;
    new_cost NUMBER;
    old_cost NUMBER;

BEGIN
    
    SELECT cost INTO old_cost FROM options 
        WHERE options.option_id = :old.option_id and options.stage = :old.stage;
    SELECT cost INTO new_cost FROM options 
        WHERE options.option_id = :new.option_id and options.stage = :new.stage;
    cost_diff :=  new_cost - old_cost;    

    DBMS_OUTPUT.PUT_LINE('Old option: option '|| :old.option_id || ' at stage ' || :old.stage);
    DBMS_OUTPUT.PUT_LINE('New option: option '|| :new.option_id || ' at stage ' || :new.stage);

    IF cost_diff > 0 THEN 
        DBMS_OUTPUT.PUT_LINE('The buyer should pay $'|| cost_diff || ' more for changing the option.');
    ELSIF cost_diff < 0 THEN 
        DBMS_OUTPUT.PUT_LINE('The buyer could pay $'|| -cost_diff || ' less for changing the option.');
    END IF;

END;
/





REM It is an after delete trigger on the staff table.
REM If one employee leaves, his record will be deleted from the staff table,
REM and all staff column in the related buyer_choice, sales, construction table will be set to null,
REM and print all these related records.


CREATE OR REPLACE TRIGGER staff_deleting
BEFORE DELETE
ON staff
FOR EACH ROW

DECLARE
    choice_record buyer_choice%ROWTYPE;
    sales_record sales%ROWTYPE;
    construction_record construction%ROWTYPE;
    CURSOR c1 is
    SELECT * FROM buyer_choice
    WHERE staff_id = :old.staff_id;
    CURSOR c2 is
    SELECT * FROM sales
    WHERE staff_id = :old.staff_id;
    CURSOR c3 is
    SELECT * FROM construction
    WHERE staff_id = :old.staff_id;


BEGIN

    DBMS_OUTPUT.PUT_LINE('The deleting staff has follow buyer_choice job:');
    DBMS_OUTPUT.PUT_LINE('CHOICE ID    '|| 'CHOICE DATE    ' || 'LOT ID');
    OPEN c1;
    LOOP
    FETCH c1 INTO choice_record;
    EXIT WHEN c1%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(choice_record.choice_id || '       ' || choice_record.choice_date || '       ' || choice_record.lot_id);
    END LOOP;
    CLOSE c1;
    DBMS_OUTPUT.PUT_LINE('The deleting staff has follow sales job:');
    DBMS_OUTPUT.PUT_LINE('SALES ID    '|| 'SALES DATE    ' || 'LOT ID');
    OPEN c2;
    LOOP
    FETCH c2 INTO sales_record;
    EXIT WHEN c2%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sales_record.sale_id || '       ' || sales_record.sale_date || '       ' || sales_record.lot_id);
    END LOOP;
    CLOSE c2;
    DBMS_OUTPUT.PUT_LINE('The deleting staff has follow construction job:');
    DBMS_OUTPUT.PUT_LINE('PROGRESS ID    '|| 'STAGE    ' || 'HOUSE ID');
    OPEN c3;
    LOOP
    FETCH c3 INTO construction_record;
    EXIT WHEN c3%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(construction_record.progress_id || '       ' || construction_record.stage || '       ' || construction_record.LOT_id);
    END LOOP;
    CLOSE c3;
    UPDATE buyer_choice SET staff_id = NULL
    WHERE staff_id = :old.staff_id;
    UPDATE sales SET staff_id = NULL
    WHERE staff_id = :old.staff_id;
    UPDATE construction SET staff_id = NULL
    WHERE staff_id = :old.staff_id;
END;
/




REM Create procedures

REM This procedure is used for inputting a pair of subdivision and style id,
REM then the details of this style, and all rooms info of this style will be returned.
REM It also shows the size percentage f all rooms in the style size. 

CREATE OR REPLACE PROCEDURE DISPLAY_HOUSE_STYLE(d_subdivision_id NUMBER,
                         d_style_id NUMBER) AS
    
    v_sub style_subdivision.subdivision_id%TYPE;
    v_style style_subdivision.style_id%TYPE;

    v_style_rec style%ROWTYPE;
    
    v_room_rec room%ROWTYPE;
    v_elv_rec elevation%ROWTYPE;
    v_selected_elv elevation.elevation_type%TYPE;
    
    v_room_pct NUMBER(3,2) := 0;
    
    CURSOR c1 IS SELECT room_id, room_size, floor, comments, num_of_windows, ceiling, style_id
                    FROM style_subdivision JOIN room r USING (style_id)
                    WHERE style_id = d_style_id;
    CURSOR c2 IS SELECT *
                    FROM elevation;

BEGIN
    
    SELECT * 
    INTO v_sub, v_style FROM style_subdivision
    WHERE subdivision_id = d_subdivision_id AND
                            style_id = d_style_id;
                            
    SELECT * 
    INTO v_style_rec
    FROM style
    WHERE  style_id = d_style_id;
    
    DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Subdivision_ID       Style_ID     ');
    DBMS_OUTPUT.PUT_LINE(v_sub ||'                    ' ||v_style);
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Style Name: ' ||v_style_rec.style_name);
    DBMS_OUTPUT.PUT_LINE('Base Price: ' ||v_style_rec.base_price);
    DBMS_OUTPUT.PUT_LINE('Style description: ' ||v_style_rec.description);
    DBMS_OUTPUT.PUT_LINE('Size: ' ||v_style_rec.style_size);
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Room   Size   Floor  Comments   No.Windows   Ceiling');
    OPEN c1; 
        LOOP
            FETCH c1 INTO v_room_rec;
            EXIT WHEN c1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_room_rec.room_id||'     ' || v_room_rec.room_size||'     ' 
                    || v_room_rec.floor||'     ' || v_room_rec.comments||'     ' 
                    || v_room_rec.num_of_windows||'     ' || v_room_rec.ceiling);
    END LOOP;
    CLOSE c1;
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Elevation   Description   Additional Cost Sketch' );
    OPEN c2; 
        LOOP
            FETCH c2 INTO v_elv_rec;
            EXIT WHEN c2%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_elv_rec.elevation_type||'      ' || 
                                    v_elv_rec.description||'              ' || 
                                    v_elv_rec.cost_added);
    END LOOP;
    CLOSE c2;
    
    
    SELECT distinct elevation_type 
    INTO v_selected_elv
    FROM style_subdivision JOIN lot
                            USING (subdivision_id, style_id)
                            JOIN style USING (style_id)
                            WHERE subdivision_id = d_subdivision_id AND
                            style_id = d_style_id;
                            
    DBMS_OUTPUT.PUT_LINE('Selected elevation: ' || v_selected_elv);
    
    v_room_pct := HOUSE_DETAILS.calc_pct(d_style_id);
    DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Room percentage of style: '|| v_room_pct);
 

 EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No record found.');
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Cannot divide by zero');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Returns more than one row.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('The PLSQL procedure executed by '|| USER||' returned and unhandled exception on '||SYSDATE);
 
 END;
 /





REM A Procedure to display Construction Progress.
REM Input a construction id, and returns all tasks information.

CREATE OR REPLACE
PROCEDURE CONSTRUCTION_PROGRESS (pgs_id IN construction.progress_id%TYPE)
AS
theLot lot.lot_id%TYPE;
theCity lot.city%TYPE;
theSub lot.subdivision_id%TYPE;
stfName staff.staff_name%TYPE;
dt construction.progress_date%TYPE;
stg construction.stage%TYPE;
totalpercent task_progress.percent_complete%TYPE;
estdate task_progress.est_completion_date%TYPE;
fetch_task task_progress%ROWTYPE;
des task.description%TYPE;

CURSOR c1 is
select * from task_progress
where progress_id = pgs_id;

BEGIN

    SELECT lot_id, city, subdivision_id
    INTO theLot, theCity, theSub FROM lot
    WHERE lot_id =
        (SELECT lot_id FROM construction
         WHERE progress_id = pgs_id);
    SELECT staff_name  INTO stfName FROM staff
    WHERE staff_id =
    (SELECT staff_id FROM construction
     WHERE progress_id = pgs_id);
     SELECT progress_date, stage INTO dt, stg
     FROM construction
     WHERE progress_id = pgs_id;
     SELECT SUM(percent_complete)/COUNT(*) INTO totalpercent
     FROM task_progress
     WHERE progress_id = pgs_id;
     SELECT est_completion_date INTO estdate FROM
     (SELECT est_completion_date FROM task_progress
     WHERE progress_id = pgs_id
     ORDER BY est_completion_date DESC)
     WHERE ROWNUM = 1;
     DBMS_OUTPUT.PUT_LINE('                   Construction Progress');
     DBMS_OUTPUT.PUT_LINE('City  ' || theCity);
     DBMS_OUTPUT.PUT_LINE('Subdivision  ' || theSub);
     DBMS_OUTPUT.PUT_LINE('Lot ID  ' || theLot || '  Construction Manager  ' || stfName);
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
     DBMS_OUTPUT.PUT_LINE('Date ' || dt ||' Stage ' || stg);
     DBMS_OUTPUT.PUT_LINE('Completed% ' || totalpercent || ' Est Completion ' || estdate);
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
     DBMS_OUTPUT.PUT_LINE('Task         Description       Percent_complete');
    OPEN c1;
    LOOP
    FETCH c1 INTO fetch_task;
    EXIT WHEN c1%NOTFOUND;
    SELECT description INTO des FROM task
    WHERE task_id = fetch_task.task_id;
    DBMS_OUTPUT.PUT_LINE(fetch_task.task_id ||'      ' || des || '     ' || fetch_task.percent_complete);
    END LOOP;
    CLOSE c1;

END;
/



REM A Procedure to display Sale Contract details, input a sals id.
REM Will return all related information of bank, agency, etc.

CREATE OR REPLACE
PROCEDURE Sale_Contract (sl_id IN sales.sale_id%TYPE)
AS
    saledetail sales%ROWTYPE;
    buyerdetail buyer%ROWTYPE;
    lotdetail lot%ROWTYPE;
    agentdetail escrow_agent%ROWTYPE;
    bankdetail bank%ROWTYPE;
    stf staff.staff_name%TYPE;
    stftitle staff.title%TYPE;
    stflicense staff.license_num%TYPE;
    dt sales.sale_date%TYPE;
    subname subdivision.subdivision_name%TYPE;
    subid subdivision.subdivision_id%TYPE;
    sz style.style_size%TYPE;
    bp style.base_price%TYPE;
    des style.description%TYPE;


BEGIN
    SELECT * INTO saledetail FROM sales WHERE sale_id = sl_id;
    SELECT * INTO buyerdetail FROM buyer WHERE buyer_id = saledetail.buyer_id;
    SELECT * INTO lotdetail FROM lot WHERE lot_id = saledetail.lot_id;
    SELECT * INTO agentdetail FROM escrow_agent WHERE agent_id = saledetail.agent_id;
    SELECT * INTO bankdetail FROM bank WHERE bank_id = saledetail.bank_id;

    SELECT sale_date INTO dt From
    (SELECT * FROM sales WHERE sale_id = sl_id);

    SELECT staff_name, title, license_num INTO stf, stftitle, stflicense
    FROM staff WHERE staff_id = saledetail.staff_id;

    SELECT subdivision_id, subdivision_name INTO subid, subname FROM subdivision WHERE subdivision_id =
    (SELECT subdivision_id FROM
      (SELECT * FROM lot WHERE lot_id = saledetail.lot_id));

    SELECT style_size, base_price, description INTO sz, bp, des
    FROM style WHERE style_id = lotdetail.style_id;


    DBMS_OUTPUT.PUT_LINE('                   SALE');
    DBMS_OUTPUT.PUT_LINE('Date:  ' || saledetail.sale_date);
    DBMS_OUTPUT.PUT_LINE('Customer Name:  ' || buyerdetail.fname || ' ' || buyerdetail.lname || '  Sales Representative:  ' || stf);
    DBMS_OUTPUT.PUT_LINE('Address:  ' || buyerdetail.street || '  Title:  ' || stftitle);
    DBMS_OUTPUT.PUT_LINE('City, State ZIP:  ' || buyerdetail.city || ', ' || buyerdetail.state || ' ' || buyerdetail.zip || '  License Number:  ' || stflicense);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Subdivision ID:  ' || subid);
    DBMS_OUTPUT.PUT_LINE('Subdivision Name:  ' || subname);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Lot ID:  ' || lotdetail.lot_id || '  Lot Size  ' || sz);
    DBMS_OUTPUT.PUT_LINE('Lot Address:  ' || lotdetail.street);
    DBMS_OUTPUT.PUT_LINE('City, State ZIP:  ' || lotdetail.city || ', ' || lotdetail.state || ' ' || lotdetail.zip_code);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('House Style:  ' || des || '  Base Price:  ' || bp);
    DBMS_OUTPUT.PUT_LINE('Elevation:  ' || lotdetail.elevation_type || '  Financing Method:  ' || saledetail.financing_method);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Escrow Deposit:  ' || saledetail.escrow_deposit || '  Escrow Agent  ' || agentdetail.fname || ' ' || agentdetail.lname);
    DBMS_OUTPUT.PUT_LINE('Address:  ' || agentdetail.street || '  City, State ZIP:  ' || agentdetail.city || ', ' || agentdetail.state || ' ' || agentdetail.zip);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Bank:  ' || bankdetail.bank_name);
    DBMS_OUTPUT.PUT_LINE('Contacrt Phone:  ' || bankdetail.phone || '  Fax:  ' || bankdetail.fax);
    DBMS_OUTPUT.PUT_LINE('Address:  ' || bankdetail.street || '  City, State ZIP  ' || bankdetail.city || ', ' || bankdetail.state || ' ' || bankdetail.zip);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Est. Completion Date:  ' || saledetail.est_date_of_completion);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Buyer receive copies of:');
    DBMS_OUTPUT.PUT_LINE('______ Subdivision Agreement');
    DBMS_OUTPUT.PUT_LINE('______ Disclosure Form');
    DBMS_OUTPUT.PUT_LINE('______ Contract');
    DBMS_OUTPUT.PUT_LINE('(more)');

END;
/


REM This procedure will tell whether a buyer can cancel his contract or not.
REM Meanwhile will also return some major details regarding the contract.

CREATE OR REPLACE PROCEDURE check_cancel( sale_num sales.sale_id%TYPE)
    IS 
    v_result NUMBER(1) := 0 ;
    v_sales_rec sales%ROWTYPE;


BEGIN
    
    SELECT *
    INTO v_sales_rec
    FROM sales WHERE sale_id = sale_num;

    v_result := IF_CAN_CANCEL(sale_num);
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    IF  v_result = 1 THEN
        DBMS_OUTPUT.PUT_LINE('The buyer CAN cancel the contract.');
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('The buyer CANNOT cancel the contract.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Sale details:');
    DBMS_OUTPUT.PUT_LINE('SALE_ID   BUYER_ID   SALE_DATE     COMPLETION_DATE  STAFF_ID   LOT_ID');
    DBMS_OUTPUT.PUT_LINE(v_sales_rec.SALE_ID || '         ' ||
                         v_sales_rec.BUYER_ID || '          ' ||    
                         v_sales_rec.SALE_DATE  || '       ' ||      
                         v_sales_rec.EST_DATE_OF_COMPLETION  || '          ' ||   
                         v_sales_rec.STAFF_ID  || '          ' || 
                         v_sales_rec.LOT_ID);
END;
/




REM Create functions

REM This function is used to calculate the percentage of total room sizes 
REM in one specific style compared to this style size.

CREATE OR REPLACE FUNCTION calc_pct( d_style_id NUMBER) RETURN NUMBER
    IS 
    room_pct NUMBER(3,2) := 0;
    v_room_size style.style_size%TYPE;
    v_style_size style.style_size%TYPE;

BEGIN
    
    SELECT SUM(room_size) 
    INTO v_room_size 
    FROM room WHERE style_id = d_style_id;
    
    SELECT style_size
    INTO v_style_size
    FROM style WHERE  style_id = d_style_id;
                              
    room_pct := v_room_size/v_style_size;
    RETURN room_pct;

END;
/


REM This function is used to determine whether a buyer can cancel the contract of not.
REM Return a binary value, 1 means can cancel and 0 means cannot.

CREATE OR REPLACE FUNCTION if_can_cancel( sale_num IN sales.sale_id%TYPE) RETURN NUMBER
    IS 
    v_result NUMBER(1) := 0 ;
    v_room_size style.style_size%TYPE;
    v_style_size style.style_size%TYPE;

BEGIN
    
    SELECT CASE WHEN MONTHS_BETWEEN(est_date_of_completion, sale_date)/12 <= 1 THEN 1 
                    ELSE 0 END 
    INTO v_result
    FROM sales WHERE sale_id = sale_num;

    RETURN v_result;

END;
/




REM Create package

REM This package contains functions and procedures
REM for calculating and displaying all details of a given pair
REM of subdivision and style.

CREATE OR REPLACE PACKAGE house_details 
AS 
FUNCTION calc_pct( d_style_id NUMBER) RETURN NUMBER; 
PROCEDURE display_details(d_subdivision_id NUMBER,
                         d_style_id NUMBER) ; 
END house_details ; 
/

REM The body follows
        
CREATE OR REPLACE PACKAGE BODY house_details 
AS

/*Function Follows*/
FUNCTION calc_pct( d_style_id NUMBER) RETURN NUMBER
    IS 
    room_pct NUMBER(3,2) := 0;
    v_room_size style.style_size%TYPE;
    v_style_size style.style_size%TYPE;

BEGIN
    
    SELECT SUM(room_size) 
    INTO v_room_size 
    FROM room 
    WHERE style_id = d_style_id;
    
    SELECT style_size
    INTO v_style_size
    FROM style WHERE  style_id = d_style_id;
                              
    room_pct := v_room_size/v_style_size;
    RETURN room_pct;

END calc_pct;

/*PROCEDURE FOLLOWS*/
PROCEDURE DISPLAY_DETAILS(d_subdivision_id NUMBER,
                         d_style_id NUMBER) AS
    
    v_sub style_subdivision.subdivision_id%TYPE;
    v_style style_subdivision.style_id%TYPE;

    v_style_rec style%ROWTYPE;
    
    v_room_rec room%ROWTYPE;
    v_elv_rec elevation%ROWTYPE;
    v_selected_elv elevation.elevation_type%TYPE;
    
    CURSOR c1 IS SELECT room_id, room_size, floor, comments, num_of_windows, ceiling, style_id
                    FROM style_subdivision JOIN room r USING (style_id)
                    WHERE style_id = d_style_id;
    CURSOR c2 IS SELECT *
                    FROM elevation;

BEGIN
    
    SELECT * 
    INTO v_sub, v_style FROM style_subdivision
    WHERE subdivision_id = d_subdivision_id AND
                            style_id = d_style_id;
                            
    SELECT * 
    INTO v_style_rec
    FROM style
    WHERE  style_id = d_style_id;
    
    DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Subdivision_ID       Style_ID     ');
    DBMS_OUTPUT.PUT_LINE(v_sub ||'                    ' ||v_style);
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Style Name: ' ||v_style_rec.style_name);
    DBMS_OUTPUT.PUT_LINE('Base Price: ' ||v_style_rec.base_price);
    DBMS_OUTPUT.PUT_LINE('Style description: ' ||v_style_rec.description);
    DBMS_OUTPUT.PUT_LINE('Size: ' ||v_style_rec.style_size);
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Room   Size   Floor  Comments   No.Windows   Ceiling');
    OPEN c1; 
        LOOP
            FETCH c1 INTO v_room_rec;
            EXIT WHEN c1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_room_rec.room_id||'     ' || v_room_rec.room_size||'     ' 
                    || v_room_rec.floor||'     ' || v_room_rec.comments||'     ' 
                    || v_room_rec.num_of_windows||'     ' || v_room_rec.ceiling);
    END LOOP;
    CLOSE c1;
     DBMS_OUTPUT.PUT_LINE('â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”â€”');
    DBMS_OUTPUT.PUT_LINE('Elevation   Description     Additional Cost Sketch' );
    OPEN c2; 
        LOOP
            FETCH c2 INTO v_elv_rec;
            EXIT WHEN c2%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_elv_rec.elevation_type||'     ' || v_elv_rec.description||'     ' 
                    || v_elv_rec.cost_added);
    END LOOP;
    CLOSE c2;
    
    
    SELECT distinct elevation_type 
    INTO v_selected_elv
    FROM style_subdivision JOIN lot
                            USING (subdivision_id, style_id)
                            JOIN style USING (style_id)
                            WHERE subdivision_id = d_subdivision_id AND
                            style_id = d_style_id;
                            
    DBMS_OUTPUT.PUT_LINE('Selected elevation: ' || v_selected_elv);
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No record found.');
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Cannot divide by zero');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Returns more than one row.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('The PLSQL procedure executed by '|| USER||' returned and unhandled exception on '||SYSDATE);
 
 END display_details;

END house_details ; 
/




REM Create indexes

CREATE INDEX index_sale_date
ON sales (sale_date);

CREATE INDEX index_lot_sub_style
ON lot (subdivision_id, style_id);

CREATE ROLE Lot_Buyer;

GRANT SELECT on LOT to Lot_Buyer; 
GRANT SELECT on SUBDIVISION to Lot_Buyer; 
GRANT SELECT on OPTIONS to Lot_Buyer; 
GRANT SELECT on ROOM to Lot_Buyer;

CREATE ROLE Sales_Staff;

GRANT SELECT, INSERT, UPDATE, DELETE ON SALES to Sales_Staff;
GRANT SELECT, INSERT, UPDATE, DELETE ON BUYER_CHOICE to Sales_Staff;
GRANT SELECT, INSERT, UPDATE, DELETE ON OPTIONS to Sales_Staff;

BEGIN
      DBMS_SCHEDULER.CREATE_JOB (
       job_name           =>  'View_Construction_Progress',
       job_type           =>  'PLSQL_BLOCK',
       job_action         =>  'SELECT * FROM CONSTRUCTION WHERE progress_date > SYSDATE-15',
       repeat_interval    =>  'FREQ=MINUTELY;INTERVAL=1',
       enabled         => false 
       );    
END;
/
-- =====================================================================
-- ERCAN AIRPORT MANAGEMENT INFORMATION SYSTEM
-- File: 02_DML.sql  (Data Manipulation Language — Sample Data)
-- Run AFTER 01_DDL.sql
-- =====================================================================

USE ercan_airport;

-- ---------- PLANE MODELS ----------
INSERT INTO PlaneModel (model_no, manufacturer, model_name, max_capacity, max_range_km, fuel_capacity_liters) VALUES
('B737-800',  'Boeing',  '737-800',        189, 5765,  26020),
('B777-300',  'Boeing',  '777-300ER',      396, 13649, 181283),
('A320-200',  'Airbus',  'A320-200',       180, 6150,  24210),
('A330-300',  'Airbus',  'A330-300',       277, 11750, 139090),
('A380-800',  'Airbus',  'A380-800',       555, 15200, 320000),
('E190',      'Embraer', 'E190',           114, 4537,  16153),
('B787-9',    'Boeing',  '787-9 Dreamliner', 296, 14140, 126206);  -- newly acquired, no expert yet

-- ---------- AIRPLANES ----------
INSERT INTO Airplane (plane_no, model_no, capacity, manufacture_date, registration_country, status) VALUES
('TC-AAA01', 'B737-800',  189, '2018-03-15', 'Turkey',  'ACTIVE'),
('TC-AAA02', 'B737-800',  189, '2019-07-22', 'Turkey',  'ACTIVE'),
('TC-AAA03', 'A320-200',  180, '2020-01-10', 'Turkey',  'ACTIVE'),
('TC-AAA04', 'A320-200',  180, '2017-11-05', 'Turkey',  'MAINTENANCE'),
('TC-AAA05', 'B777-300',  380, '2016-04-30', 'Turkey',  'ACTIVE'),
('TC-AAA06', 'A330-300',  277, '2015-09-12', 'Turkey',  'ACTIVE'),
('TC-AAA07', 'E190',      114, '2021-06-18', 'Turkey',  'ACTIVE'),
('TC-AAA08', 'B737-800',  189, '2014-02-25', 'Turkey',  'RETIRED'),
('TC-AAA09', 'A380-800',  555, '2019-12-01', 'Turkey',  'ACTIVE'),
('TC-AAA10', 'E190',      114, '2022-08-08', 'Turkey',  'ACTIVE'),
('TC-AAA11', 'B787-9',    296, '2025-11-15', 'Turkey',  'ACTIVE');   -- new acquisition

-- ---------- EMPLOYEES ----------
INSERT INTO Employee (ssn, first_name, last_name, union_membership_no, date_of_birth, hire_date, salary, phone, email, address, employee_type) VALUES
-- Technicians
('111-11-1111','Ahmed',   'Yilmaz',  'UN-001','1985-05-10','2015-06-01', 45000.00,'+905551111111','ahmed.yilmaz@ercan.com',  'Nicosia',  'TECHNICIAN'),
('111-11-1112','Fatma',   'Demir',   'UN-002','1990-08-22','2018-09-15', 42000.00,'+905551111112','fatma.demir@ercan.com',   'Famagusta','TECHNICIAN'),
('111-11-1113','Mustafa', 'Kaya',    'UN-003','1982-11-30','2010-03-20', 55000.00,'+905551111113','mustafa.kaya@ercan.com',  'Kyrenia',  'TECHNICIAN'),
('111-11-1114','Ayse',    'Celik',   'UN-004','1988-04-14','2016-07-05', 48000.00,'+905551111114','ayse.celik@ercan.com',    'Nicosia',  'TECHNICIAN'),
('111-11-1115','Ibrahim', 'Ozturk',  'UN-005','1979-01-25','2008-02-10', 62000.00,'+905551111115','ibrahim.ozturk@ercan.com','Nicosia',  'TECHNICIAN'),
-- Traffic Controllers
('222-22-2221','Mehmet',  'Aydin',   'UN-006','1986-09-03','2014-04-12', 58000.00,'+905552222221','mehmet.aydin@ercan.com',  'Nicosia',  'TRAFFIC_CONTROLLER'),
('222-22-2222','Zeynep',  'Sahin',   'UN-007','1992-12-18','2019-08-25', 52000.00,'+905552222222','zeynep.sahin@ercan.com',  'Kyrenia',  'TRAFFIC_CONTROLLER'),
('222-22-2223','Hasan',   'Polat',   'UN-008','1984-07-07','2012-11-15', 60000.00,'+905552222223','hasan.polat@ercan.com',   'Famagusta','TRAFFIC_CONTROLLER'),
('222-22-2224','Esra',    'Arslan',  'UN-009','1991-03-29','2020-01-08', 50000.00,'+905552222224','esra.arslan@ercan.com',   'Nicosia',  'TRAFFIC_CONTROLLER'),
-- General airport employees
('333-33-3331','Ali',     'Korkmaz', 'UN-010','1987-06-12','2017-05-20', 35000.00,'+905553333331','ali.korkmaz@ercan.com',   'Nicosia',  'GENERAL'),
('333-33-3332','Selin',   'Aslan',   'UN-011','1995-10-05','2021-03-15', 32000.00,'+905553333332','selin.aslan@ercan.com',   'Kyrenia',  'GENERAL'),
('333-33-3333','Burak',   'Erdem',   'UN-012','1989-02-28','2019-11-10', 38000.00,'+905553333333','burak.erdem@ercan.com',   'Famagusta','GENERAL'),
-- Recent hires (last 2 years) to showcase Q10
('333-33-3334','Deniz',   'Ucar',    'UN-013','1998-07-19','2024-09-01', 33000.00,'+905553333334','deniz.ucar@ercan.com',    'Nicosia',  'GENERAL'),
('333-33-3335','Berkay',  'Tan',     'UN-014','1996-04-22','2025-02-10', 34000.00,'+905553333335','berkay.tan@ercan.com',    'Kyrenia',  'GENERAL'),
('111-11-1116','Cem',     'Gunes',   'UN-015','1993-11-30','2024-06-15', 40000.00,'+905551111116','cem.gunes@ercan.com',     'Nicosia',  'TECHNICIAN'),
('222-22-2225','Aylin',   'Kara',    'UN-016','1994-08-14','2025-08-20', 51000.00,'+905552222225','aylin.kara@ercan.com',    'Famagusta','TRAFFIC_CONTROLLER');

-- ---------- TECHNICIANS (subtype) ----------
INSERT INTO Technician (ssn, certification_level, years_experience) VALUES
('111-11-1111','SENIOR', 10),
('111-11-1112','JUNIOR',  6),
('111-11-1113','MASTER',15),
('111-11-1114','SENIOR',  8),
('111-11-1115','LEAD',  17),
('111-11-1116','JUNIOR',  2);

-- ---------- TRAFFIC CONTROLLERS (subtype) ----------
INSERT INTO TrafficController (ssn, last_medical_exam_date, license_no, shift) VALUES
('222-22-2221','2025-09-15','TC-LIC-001','MORNING'),
('222-22-2222','2026-02-20','TC-LIC-002','AFTERNOON'),
('222-22-2223','2024-11-30','TC-LIC-003','NIGHT'),     -- overdue exam
('222-22-2224','2026-01-10','TC-LIC-004','MORNING'),
('222-22-2225','2026-03-05','TC-LIC-005','AFTERNOON');

-- ---------- TECHNICIAN EXPERTISE ----------
INSERT INTO TechnicianExpertise (ssn, model_no, certified_date) VALUES
('111-11-1111','B737-800','2016-01-15'),
('111-11-1111','A320-200','2018-06-10'),
('111-11-1112','B737-800','2019-03-20'),
('111-11-1113','B737-800','2011-04-05'),
('111-11-1113','B777-300','2013-08-22'),
('111-11-1113','A330-300','2015-02-14'),
('111-11-1113','A380-800','2020-05-30'),
('111-11-1114','A320-200','2017-09-12'),
('111-11-1114','E190',    '2022-01-08'),
('111-11-1115','B777-300','2009-07-19'),
('111-11-1115','A330-300','2011-10-25'),
('111-11-1115','A380-800','2020-03-15');

-- ---------- HANGARS ----------
INSERT INTO Hangar (hangar_no, location, capacity, hangar_type) VALUES
('H-01','North Apron, Sector A',3,'MAINTENANCE'),
('H-02','North Apron, Sector B',2,'STORAGE'),
('H-03','South Apron, Sector A',4,'BOTH'),
('H-04','South Apron, Sector B',2,'MAINTENANCE'),
('H-05','East Apron, Sector A', 5,'STORAGE');

-- ---------- HANGAR STAYS ----------
INSERT INTO HangarStay (plane_no, hangar_no, in_datetime, out_datetime) VALUES
('TC-AAA01','H-01','2026-01-05 08:00:00','2026-01-07 18:30:00'),
('TC-AAA02','H-02','2026-01-10 06:00:00','2026-01-11 22:00:00'),
('TC-AAA03','H-03','2026-02-14 09:30:00','2026-02-20 14:00:00'),
('TC-AAA04','H-01','2026-03-01 07:00:00', NULL),                    -- still in hangar
('TC-AAA05','H-04','2026-02-25 10:00:00','2026-03-02 16:00:00'),
('TC-AAA06','H-03','2026-04-10 08:30:00','2026-04-15 12:00:00'),
('TC-AAA07','H-05','2026-03-20 11:00:00','2026-03-21 09:00:00'),
('TC-AAA09','H-04','2026-01-20 06:00:00','2026-02-05 15:00:00'),
('TC-AAA10','H-02','2026-04-25 13:00:00','2026-04-26 18:00:00'),
('TC-AAA01','H-01','2026-05-01 07:00:00','2026-05-04 19:00:00');

-- ---------- TESTS ----------
INSERT INTO Test (test_name, max_score, description, frequency_months) VALUES
('Engine Pressure Test',         100,'Full engine compression and pressure inspection',6),
('Hydraulic System Test',        100,'Inspect hydraulic lines, pumps and pressure',   12),
('Avionics System Test',         100,'Verify all flight electronics and radios',      6),
('Landing Gear Inspection',      100,'Visual + functional landing gear check',        12),
('Fuel System Test',             100,'Fuel line integrity and pump check',            12),
('Cabin Pressurization Test',    100,'Test cabin sealing and pressurization',         6),
('Structural Integrity Test',    100,'Airframe fatigue and structural inspection',    24);

-- ---------- TEST EVENTS ----------
INSERT INTO TestEvent (plane_no, technician_ssn, test_id, test_date, hours_spent, score) VALUES
('TC-AAA01','111-11-1111',1,'2026-01-06', 4.5, 92),
('TC-AAA01','111-11-1111',3,'2026-01-06', 2.5, 88),
('TC-AAA02','111-11-1112',1,'2026-01-11', 5.0, 78),
('TC-AAA02','111-11-1113',4,'2026-01-11', 3.0, 95),
('TC-AAA03','111-11-1114',2,'2026-02-15', 6.0, 84),
('TC-AAA03','111-11-1111',5,'2026-02-16', 4.0, 90),
('TC-AAA04','111-11-1111',1,'2026-03-02', 5.5, 45),   -- failing score
('TC-AAA04','111-11-1114',6,'2026-03-02', 3.5, 50),   -- borderline
('TC-AAA05','111-11-1113',1,'2026-02-26', 7.0, 96),
('TC-AAA05','111-11-1115',7,'2026-02-27',10.0, 98),
('TC-AAA06','111-11-1115',2,'2026-04-11', 6.5, 89),
('TC-AAA06','111-11-1113',4,'2026-04-12', 4.5, 92),
('TC-AAA07','111-11-1114',3,'2026-03-20', 3.0, 86),
('TC-AAA09','111-11-1113',1,'2026-01-21', 8.0, 94),
('TC-AAA09','111-11-1115',7,'2026-01-22',12.0, 91),
('TC-AAA10','111-11-1114',6,'2026-04-26', 3.5, 87),
('TC-AAA01','111-11-1111',2,'2026-05-02', 4.0, 88),
('TC-AAA01','111-11-1112',4,'2026-05-03', 3.5, 91);

-- ---------- REPAIRS ----------
INSERT INTO Repair (plane_no, technician_ssn, repair_date, problem_description, parts_cost, labor_hours, status) VALUES
('TC-AAA04','111-11-1111','2026-03-03','Hydraulic pump failure on main landing gear',     12500.00, 18.0,'COMPLETED'),
('TC-AAA04','111-11-1114','2026-03-05','Avionics navigation display malfunction',          8200.00,  9.0,'COMPLETED'),
('TC-AAA01','111-11-1111','2026-02-10','Engine oil leak — left turbine',                   3500.00,  6.5,'COMPLETED'),
('TC-AAA02','111-11-1112','2026-01-12','Cabin pressure seal replacement',                  2100.00,  4.0,'COMPLETED'),
('TC-AAA05','111-11-1113','2026-02-28','APU starter motor replacement',                   15800.00, 22.0,'COMPLETED'),
('TC-AAA06','111-11-1115','2026-04-13','Tire & brake assembly replacement',                6900.00,  5.5,'COMPLETED'),
('TC-AAA09','111-11-1115','2026-01-25','Wing flap actuator overhaul',                     21300.00, 35.0,'COMPLETED'),
('TC-AAA08','111-11-1111','2026-05-01','Full structural inspection — pre-retirement',     45000.00, 80.0,'IN_PROGRESS');

-- ---------- GATES ----------
INSERT INTO Gate (gate_no, terminal, gate_type) VALUES
('G01','T1','DOMESTIC'),
('G02','T1','DOMESTIC'),
('G03','T1','INTERNATIONAL'),
('G04','T2','INTERNATIONAL'),
('G05','T2','INTERNATIONAL'),
('G06','T2','DOMESTIC');

-- ---------- FLIGHTS ----------
INSERT INTO Flight (flight_id, plane_no, controller_ssn, gate_no, origin, destination, departure_datetime, arrival_datetime, flight_status) VALUES
('KK-101','TC-AAA01','222-22-2221','G03','Ercan','Istanbul', '2026-04-15 06:00:00','2026-04-15 08:30:00','ARRIVED'),
('KK-102','TC-AAA02','222-22-2222','G04','Ercan','Ankara',   '2026-04-15 07:15:00','2026-04-15 09:45:00','ARRIVED'),
('KK-103','TC-AAA03','222-22-2221','G01','Ercan','Izmir',    '2026-04-15 10:00:00','2026-04-15 12:15:00','ARRIVED'),
('KK-104','TC-AAA05','222-22-2223','G05','Ercan','London',   '2026-04-15 22:00:00','2026-04-16 03:30:00','ARRIVED'),
('KK-105','TC-AAA06','222-22-2224','G04','Ercan','Dubai',    '2026-04-16 23:00:00','2026-04-17 05:00:00','ARRIVED'),
('KK-106','TC-AAA07','222-22-2222','G06','Ercan','Antalya',  '2026-05-10 08:00:00','2026-05-10 10:00:00','SCHEDULED'),
('KK-107','TC-AAA09','222-22-2223','G05','Ercan','New York', '2026-05-12 21:00:00','2026-05-13 05:00:00','SCHEDULED'),
('KK-108','TC-AAA10','222-22-2221','G02','Ercan','Bodrum',   '2026-05-14 12:00:00','2026-05-14 13:45:00','SCHEDULED'),
('KK-109','TC-AAA01','222-22-2224','G03','Ercan','Istanbul', '2026-05-15 06:00:00','2026-05-15 08:30:00','SCHEDULED'),
('KK-110','TC-AAA03','222-22-2222','G01','Ercan','Izmir',    '2026-05-15 11:00:00','2026-05-15 13:15:00','DELAYED');

-- ---------- MAINTENANCE LOGS ----------
INSERT INTO MaintenanceLog (plane_no, technician_ssn, maintenance_date, maintenance_type, notes, next_due_date) VALUES
('TC-AAA01','111-11-1111','2026-01-07','ROUTINE',   'Standard 6-month checkup',          '2026-07-07'),
('TC-AAA02','111-11-1112','2026-01-11','ROUTINE',   'Cabin & seat refurbishment',        '2026-07-11'),
('TC-AAA03','111-11-1114','2026-02-20','INSPECTION','Annual inspection passed',          '2027-02-20'),
('TC-AAA05','111-11-1113','2026-03-02','OVERHAUL',  'Engine overhaul completed',         '2029-03-02'),
('TC-AAA06','111-11-1115','2026-04-15','ROUTINE',   '12-month routine maintenance',      '2027-04-15'),
('TC-AAA09','111-11-1115','2026-02-05','OVERHAUL',  'Full systems overhaul, A-check',    '2027-02-05');

-- =====================================================================
-- END OF DML
-- =====================================================================

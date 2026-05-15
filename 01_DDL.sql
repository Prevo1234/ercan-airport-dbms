-- =====================================================================
-- ERCAN AIRPORT MANAGEMENT INFORMATION SYSTEM
-- File: 01_DDL.sql  (Data Definition Language)
-- DBMS: MySQL 8.0+   (portable to Oracle/PostgreSQL with minor edits)
-- Course: CMPE343 Database Management Systems and Programming I
-- =====================================================================

DROP DATABASE IF EXISTS ercan_airport;
CREATE DATABASE ercan_airport CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ercan_airport;

-- =====================================================================
-- 1. EMPLOYEE  (supertype — every worker is an Employee)
-- =====================================================================
CREATE TABLE Employee (
    ssn                 VARCHAR(11)  NOT NULL,
    first_name          VARCHAR(50)  NOT NULL,
    last_name           VARCHAR(50)  NOT NULL,
    union_membership_no VARCHAR(20)  NOT NULL,
    date_of_birth       DATE,
    hire_date           DATE         NOT NULL,
    salary              DECIMAL(10,2) NOT NULL,
    phone               VARCHAR(15),
    email               VARCHAR(100),
    address             VARCHAR(200),
    employee_type       ENUM('TECHNICIAN','TRAFFIC_CONTROLLER','GENERAL') NOT NULL,
    CONSTRAINT pk_employee          PRIMARY KEY (ssn),
    CONSTRAINT uq_employee_union    UNIQUE (union_membership_no),
    CONSTRAINT uq_employee_email    UNIQUE (email),
    CONSTRAINT chk_employee_salary  CHECK (salary > 0),
    CONSTRAINT chk_employee_hire    CHECK (hire_date >= date_of_birth)
);

-- =====================================================================
-- 2. TECHNICIAN  (IS-A Employee)
-- =====================================================================
CREATE TABLE Technician (
    ssn                  VARCHAR(11) NOT NULL,
    certification_level  ENUM('JUNIOR','SENIOR','LEAD','MASTER') NOT NULL,
    years_experience     INT NOT NULL,
    CONSTRAINT pk_technician   PRIMARY KEY (ssn),
    CONSTRAINT fk_technician_emp FOREIGN KEY (ssn) REFERENCES Employee(ssn)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_tech_exp    CHECK (years_experience >= 0)
);

-- =====================================================================
-- 3. TRAFFIC_CONTROLLER  (IS-A Employee)
-- =====================================================================
CREATE TABLE TrafficController (
    ssn                     VARCHAR(11) NOT NULL,
    last_medical_exam_date  DATE        NOT NULL,
    license_no              VARCHAR(20) NOT NULL,
    shift                   ENUM('MORNING','AFTERNOON','NIGHT') NOT NULL,
    CONSTRAINT pk_tc           PRIMARY KEY (ssn),
    CONSTRAINT uq_tc_license   UNIQUE (license_no),
    CONSTRAINT fk_tc_emp       FOREIGN KEY (ssn) REFERENCES Employee(ssn)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================================
-- 4. PLANE_MODEL  (a Boeing 737-800 is a model; many airplanes share it)
-- =====================================================================
CREATE TABLE PlaneModel (
    model_no             VARCHAR(20) NOT NULL,
    manufacturer         VARCHAR(50) NOT NULL,
    model_name           VARCHAR(50) NOT NULL,
    max_capacity         INT         NOT NULL,
    max_range_km         INT         NOT NULL,
    fuel_capacity_liters INT         NOT NULL,
    CONSTRAINT pk_plane_model      PRIMARY KEY (model_no),
    CONSTRAINT chk_pm_capacity     CHECK (max_capacity     > 0),
    CONSTRAINT chk_pm_range        CHECK (max_range_km     > 0),
    CONSTRAINT chk_pm_fuel         CHECK (fuel_capacity_liters > 0)
);

-- =====================================================================
-- 5. AIRPLANE  (one physical airframe)
-- =====================================================================
CREATE TABLE Airplane (
    plane_no             VARCHAR(10) NOT NULL,
    model_no             VARCHAR(20) NOT NULL,
    capacity             INT         NOT NULL,
    manufacture_date     DATE        NOT NULL,
    registration_country VARCHAR(50) NOT NULL,
    status               ENUM('ACTIVE','MAINTENANCE','RETIRED') NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT pk_airplane       PRIMARY KEY (plane_no),
    CONSTRAINT fk_airplane_model FOREIGN KEY (model_no) REFERENCES PlaneModel(model_no)
        ON UPDATE CASCADE,
    CONSTRAINT chk_ap_capacity   CHECK (capacity > 0)
);

-- =====================================================================
-- 6. TECHNICIAN_EXPERTISE  (M:N — technician ↔ model)
-- =====================================================================
CREATE TABLE TechnicianExpertise (
    ssn            VARCHAR(11) NOT NULL,
    model_no       VARCHAR(20) NOT NULL,
    certified_date DATE        NOT NULL,
    CONSTRAINT pk_expertise        PRIMARY KEY (ssn, model_no),
    CONSTRAINT fk_exp_tech         FOREIGN KEY (ssn)      REFERENCES Technician(ssn)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_exp_model        FOREIGN KEY (model_no) REFERENCES PlaneModel(model_no)
        ON UPDATE CASCADE
);

-- =====================================================================
-- 7. HANGAR
-- =====================================================================
CREATE TABLE Hangar (
    hangar_no    VARCHAR(10) NOT NULL,
    location     VARCHAR(100) NOT NULL,
    capacity     INT NOT NULL,
    hangar_type  ENUM('STORAGE','MAINTENANCE','BOTH') NOT NULL DEFAULT 'BOTH',
    CONSTRAINT pk_hangar         PRIMARY KEY (hangar_no),
    CONSTRAINT chk_hangar_cap    CHECK (capacity > 0)
);

-- =====================================================================
-- 8. HANGAR_STAY  (temporal — IN and OUT datetimes; surrogate PK)
-- =====================================================================
CREATE TABLE HangarStay (
    stay_id       INT         NOT NULL AUTO_INCREMENT,
    plane_no      VARCHAR(10) NOT NULL,
    hangar_no     VARCHAR(10) NOT NULL,
    in_datetime   DATETIME    NOT NULL,
    out_datetime  DATETIME,                       -- NULL = still in hangar
    CONSTRAINT pk_stay           PRIMARY KEY (stay_id),
    CONSTRAINT fk_stay_plane     FOREIGN KEY (plane_no)  REFERENCES Airplane(plane_no)
        ON UPDATE CASCADE,
    CONSTRAINT fk_stay_hangar    FOREIGN KEY (hangar_no) REFERENCES Hangar(hangar_no)
        ON UPDATE CASCADE,
    CONSTRAINT chk_stay_dates    CHECK (out_datetime IS NULL OR out_datetime > in_datetime),
    INDEX idx_stay_plane  (plane_no, in_datetime),
    INDEX idx_stay_hangar (hangar_no, in_datetime)
);

-- =====================================================================
-- 9. TEST  (catalog of airworthiness tests)
-- =====================================================================
CREATE TABLE Test (
    test_id           INT NOT NULL AUTO_INCREMENT,
    test_name         VARCHAR(100) NOT NULL,
    max_score         INT NOT NULL,
    description       TEXT,
    frequency_months  INT NOT NULL,            -- how often it must be re-run
    CONSTRAINT pk_test           PRIMARY KEY (test_id),
    CONSTRAINT uq_test_name      UNIQUE (test_name),
    CONSTRAINT chk_test_max      CHECK (max_score > 0),
    CONSTRAINT chk_test_freq     CHECK (frequency_months > 0)
);

-- =====================================================================
-- 10. TEST_EVENT  (4-way relationship: plane × technician × test × date)
-- =====================================================================
CREATE TABLE TestEvent (
    test_event_id   INT NOT NULL AUTO_INCREMENT,
    plane_no        VARCHAR(10) NOT NULL,
    technician_ssn  VARCHAR(11) NOT NULL,
    test_id         INT NOT NULL,
    test_date       DATE NOT NULL,
    hours_spent     DECIMAL(5,2) NOT NULL,
    score           INT NOT NULL,
    CONSTRAINT pk_test_event        PRIMARY KEY (test_event_id),
    CONSTRAINT uq_test_event_natural UNIQUE (plane_no, technician_ssn, test_id, test_date),
    CONSTRAINT fk_te_plane    FOREIGN KEY (plane_no)       REFERENCES Airplane(plane_no)
        ON UPDATE CASCADE,
    CONSTRAINT fk_te_tech     FOREIGN KEY (technician_ssn) REFERENCES Technician(ssn)
        ON UPDATE CASCADE,
    CONSTRAINT fk_te_test     FOREIGN KEY (test_id)        REFERENCES Test(test_id)
        ON UPDATE CASCADE,
    CONSTRAINT chk_te_hours   CHECK (hours_spent > 0),
    CONSTRAINT chk_te_score   CHECK (score >= 0)
);

-- =====================================================================
-- 11. REPAIR  (extension — spec mentions "testing and repairing")
-- =====================================================================
CREATE TABLE Repair (
    repair_id            INT NOT NULL AUTO_INCREMENT,
    plane_no             VARCHAR(10) NOT NULL,
    technician_ssn       VARCHAR(11) NOT NULL,
    repair_date          DATE NOT NULL,
    problem_description  TEXT NOT NULL,
    parts_cost           DECIMAL(10,2) NOT NULL,
    labor_hours          DECIMAL(5,2) NOT NULL,
    status               ENUM('PENDING','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'IN_PROGRESS',
    CONSTRAINT pk_repair         PRIMARY KEY (repair_id),
    CONSTRAINT fk_rep_plane      FOREIGN KEY (plane_no)       REFERENCES Airplane(plane_no)
        ON UPDATE CASCADE,
    CONSTRAINT fk_rep_tech       FOREIGN KEY (technician_ssn) REFERENCES Technician(ssn)
        ON UPDATE CASCADE,
    CONSTRAINT chk_rep_cost      CHECK (parts_cost  >= 0),
    CONSTRAINT chk_rep_hours     CHECK (labor_hours >  0)
);

-- =====================================================================
-- 12. GATE  (extension — boarding gate)
-- =====================================================================
CREATE TABLE Gate (
    gate_no    VARCHAR(10) NOT NULL,
    terminal   VARCHAR(10) NOT NULL,
    gate_type  ENUM('DOMESTIC','INTERNATIONAL') NOT NULL,
    CONSTRAINT pk_gate PRIMARY KEY (gate_no)
);

-- =====================================================================
-- 13. FLIGHT  (extension — couples airplane, controller and gate)
-- =====================================================================
CREATE TABLE Flight (
    flight_id           VARCHAR(10) NOT NULL,
    plane_no            VARCHAR(10) NOT NULL,
    controller_ssn      VARCHAR(11),
    gate_no             VARCHAR(10),
    origin              VARCHAR(50) NOT NULL,
    destination         VARCHAR(50) NOT NULL,
    departure_datetime  DATETIME NOT NULL,
    arrival_datetime    DATETIME NOT NULL,
    flight_status       ENUM('SCHEDULED','DEPARTED','ARRIVED','CANCELLED','DELAYED') NOT NULL DEFAULT 'SCHEDULED',
    CONSTRAINT pk_flight         PRIMARY KEY (flight_id),
    CONSTRAINT fk_fl_plane       FOREIGN KEY (plane_no)       REFERENCES Airplane(plane_no)
        ON UPDATE CASCADE,
    CONSTRAINT fk_fl_controller  FOREIGN KEY (controller_ssn) REFERENCES TrafficController(ssn)
        ON UPDATE CASCADE,
    CONSTRAINT fk_fl_gate        FOREIGN KEY (gate_no)        REFERENCES Gate(gate_no)
        ON UPDATE CASCADE,
    CONSTRAINT chk_fl_dates      CHECK (arrival_datetime > departure_datetime),
    CONSTRAINT chk_fl_route      CHECK (origin <> destination)
);

-- =====================================================================
-- 14. MAINTENANCE_LOG  (extension — preventive maintenance log)
-- =====================================================================
CREATE TABLE MaintenanceLog (
    log_id            INT NOT NULL AUTO_INCREMENT,
    plane_no          VARCHAR(10) NOT NULL,
    technician_ssn    VARCHAR(11) NOT NULL,
    maintenance_date  DATE NOT NULL,
    maintenance_type  ENUM('ROUTINE','INSPECTION','OVERHAUL') NOT NULL,
    notes             TEXT,
    next_due_date     DATE,
    CONSTRAINT pk_maint            PRIMARY KEY (log_id),
    CONSTRAINT fk_ml_plane         FOREIGN KEY (plane_no)       REFERENCES Airplane(plane_no)
        ON UPDATE CASCADE,
    CONSTRAINT fk_ml_tech          FOREIGN KEY (technician_ssn) REFERENCES Technician(ssn)
        ON UPDATE CASCADE,
    CONSTRAINT chk_ml_next         CHECK (next_due_date IS NULL OR next_due_date > maintenance_date)
);

-- =====================================================================
-- INDEXES for performance on common lookups
-- =====================================================================
CREATE INDEX idx_emp_type        ON Employee(employee_type);
CREATE INDEX idx_test_event_date ON TestEvent(test_date);
CREATE INDEX idx_repair_date     ON Repair(repair_date);
CREATE INDEX idx_flight_dep      ON Flight(departure_datetime);

-- =====================================================================
-- END OF DDL
-- =====================================================================

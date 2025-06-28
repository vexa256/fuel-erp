--
-- File generated with SQLiteStudio v3.4.17 on Thu Jun 26 01:40:00 2025
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Attendance
DROP TABLE IF EXISTS Attendance;

CREATE TABLE IF NOT EXISTS Attendance (
    AttendanceID   INTEGER PRIMARY KEY,
    StationID      INTEGER NOT NULL,
    UserID         INTEGER NOT NULL,
    AttendanceDate TEXT    NOT NULL,
    TimeIn         TEXT    NULL,
    TimeOut        TEXT    NULL,
    Status         TEXT    NOT NULL,
    Notes          TEXT    NULL,
    CreatedAt      TEXT    NULL
                           DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE RESTRICT,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE NO ACTION
                                    ON DELETE NO ACTION,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION
)
STRICT;

INSERT INTO Attendance (AttendanceID, StationID, UserID, AttendanceDate, TimeIn, TimeOut, Status, Notes, CreatedAt) VALUES (1, 511, 4782876, '2025-06-22', '2025-06-22T21:45:08.116Z', NULL, 'Present', NULL, '2025-06-22 21:45:08');

-- Table: AuditLogs
DROP TABLE IF EXISTS AuditLogs;

CREATE TABLE IF NOT EXISTS AuditLogs (
    LogID        INTEGER PRIMARY KEY,
    StationID    INTEGER NULL,
    UserID       INTEGER NULL,
    Action       TEXT    NOT NULL,
    TableName    TEXT    NOT NULL,
    RecordID     INTEGER NULL,
    Changes      TEXT    NULL,
    IPAddress    TEXT    NULL,
    LogTimestamp TEXT    NULL
                         DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE SET NULL,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE NO ACTION
                                    ON DELETE NO ACTION,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION
)
STRICT;

INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (1, 511, 4782876, 'Equipment Check', 'Equipment', NULL, '{"pumps":22,"tanks":14,"checkTime":"2025-06-22T21:42:13.251Z"}', NULL, '2025-06-22T21:42:13.251Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (2, 510, 4782876, 'POS Sale Completed', 'Transactions', NULL, '{"approvalId":null,"amount":566400,"items":1}', 'POS-Terminal', '2025-06-24T00:13:25.692Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (3, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Insufficient stock for LPG 13kg. Available: 1","context":{"cart":[{"product":{"ProductID":612,"ProductType":"Gas","Name":"LPG 13kg","Description":"Liquefied petroleum gas 13kg cylinder","UnitPrice":"120000","SellingPrice":null,"TaxRate":"18","ReorderLevel":"15","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":4,"unitPrice":120000,"total":480000}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T00:27:17.319Z"}', 'POS-Terminal', '2025-06-24T00:27:17.319Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (4, 510, 4782876, 'POS Sale Completed', 'Transactions', NULL, '{"amount":141600,"items":1}', 'POS-Terminal', '2025-06-24T00:27:29.805Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (5, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Insufficient stock for Diesel. Available: 0","context":{"cart":[{"product":{"ProductID":603,"ProductType":"Fuel","Name":"Diesel","Description":"Regular diesel fuel","UnitPrice":"4200","SellingPrice":null,"TaxRate":"18","ReorderLevel":"5000","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":8,"unitPrice":4200,"total":33600}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T00:29:28.615Z"}', 'POS-Terminal', '2025-06-24T00:29:28.615Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (6, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Insufficient stock for Diesel. Available: 0","context":{"cart":[{"product":{"ProductID":603,"ProductType":"Fuel","Name":"Diesel","Description":"Regular diesel fuel","UnitPrice":"4200","SellingPrice":null,"TaxRate":"18","ReorderLevel":"5000","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":8,"unitPrice":4200,"total":33600}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T00:29:31.917Z"}', 'POS-Terminal', '2025-06-24T00:29:31.917Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (7, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Insufficient stock for Diesel. Available: 0","context":{"cart":[{"product":{"ProductID":603,"ProductType":"Fuel","Name":"Diesel","Description":"Regular diesel fuel","UnitPrice":"4200","SellingPrice":null,"TaxRate":"18","ReorderLevel":"5000","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":8,"unitPrice":4200,"total":33600}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T00:29:33.653Z"}', 'POS-Terminal', '2025-06-24T00:29:33.654Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (8, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Insufficient stock for Diesel. Available: 0","context":{"cart":[{"product":{"ProductID":603,"ProductType":"Fuel","Name":"Diesel","Description":"Regular diesel fuel","UnitPrice":"4200","SellingPrice":null,"TaxRate":"18","ReorderLevel":"5000","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":8,"unitPrice":4200,"total":33600}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T00:29:36.327Z"}', 'POS-Terminal', '2025-06-24T00:29:36.327Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (9, 510, 4782876, 'POS Sale Completed', 'Transactions', NULL, '{"amount":49336980,"items":1,"fuelItems":1}', 'POS-Terminal', '2025-06-24T00:52:37.381Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (10, 510, 4782876, 'POS Sale Completed', 'Transactions', NULL, '{"amount":477900,"items":1,"fuelItems":1}', 'POS-Terminal', '2025-06-24T01:13:48.091Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (11, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Failed to get transaction ID from response","context":{"cart":[{"product":{"ProductID":603,"ProductType":"Fuel","Name":"Diesel","Description":"Regular diesel fuel","UnitPrice":"4200","SellingPrice":null,"TaxRate":"18","ReorderLevel":"5000","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":4,"unitPrice":4200,"total":16800,"tankInfo":{"TankID":713,"StationID":507,"ProductID":603,"TankName":"Diesel Tank 1","Capacity":"40000","CurrentLevel":"22045.00","Status":"Active","LastFilledDate":"2025-05-07 18:17:31","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-06-24T00:52:37.237Z"},"pumpInfo":{"PumpID":821,"StationID":507,"TankID":713,"PumpName":"Diesel Pump 2","MeterReading":"64276.09","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-06-24T00:52:37.285Z"},"isFuel":true}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T15:08:04.427Z"}', 'POS-Terminal', '2025-06-24T15:08:04.427Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (12, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Failed to get transaction ID from response","context":{"cart":[{"product":{"ProductID":603,"ProductType":"Fuel","Name":"Diesel","Description":"Regular diesel fuel","UnitPrice":"4200","SellingPrice":null,"TaxRate":"18","ReorderLevel":"5000","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":4,"unitPrice":4200,"total":16800,"tankInfo":{"TankID":713,"StationID":507,"ProductID":603,"TankName":"Diesel Tank 1","Capacity":"40000","CurrentLevel":"22045.00","Status":"Active","LastFilledDate":"2025-05-07 18:17:31","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-06-24T00:52:37.237Z"},"pumpInfo":{"PumpID":821,"StationID":507,"TankID":713,"PumpName":"Diesel Pump 2","MeterReading":"64276.09","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-06-24T00:52:37.285Z"},"isFuel":true}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T15:08:08.312Z"}', 'POS-Terminal', '2025-06-24T15:08:08.312Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (13, 510, 4782876, 'ERROR: POS Sale Failed', 'POS_System', NULL, '{"error":"Failed to get transaction ID from response","context":{"cart":[{"product":{"ProductID":603,"ProductType":"Fuel","Name":"Diesel","Description":"Regular diesel fuel","UnitPrice":"4200","SellingPrice":null,"TaxRate":"18","ReorderLevel":"5000","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-05-07 18:17:31"},"quantity":4,"unitPrice":4200,"total":16800,"tankInfo":{"TankID":713,"StationID":507,"ProductID":603,"TankName":"Diesel Tank 1","Capacity":"40000","CurrentLevel":"22045.00","Status":"Active","LastFilledDate":"2025-05-07 18:17:31","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-06-24T00:52:37.237Z"},"pumpInfo":{"PumpID":821,"StationID":507,"TankID":713,"PumpName":"Diesel Pump 2","MeterReading":"64276.09","Status":"Active","CreatedAt":"2025-05-07 18:17:31","UpdatedAt":"2025-06-24T00:52:37.285Z"},"isFuel":true}],"customer":null,"payment":"Cash"},"timestamp":"2025-06-24T15:08:10.626Z"}', 'POS-Terminal', '2025-06-24T15:08:10.626Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (14, 510, 4782876, 'POS Sale Completed', 'Transactions', 12, '{"transactionId":"12","amount":21240,"items":1,"fuelItems":1}', 'POS-Terminal', '2025-06-24T15:10:48.545Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (15, 510, 4782876, 'POS Sale Completed', 'Transactions', 13, '{"transactionId":"13","amount":31860,"items":1,"fuelItems":1}', 'POS-Terminal', '2025-06-24T15:11:24.068Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (16, 510, 4782876, 'POS Sale Completed', 'Transactions', 14, '{"transactionId":"14","amount":26550,"items":1,"fuelItems":1}', 'POS-Terminal', '2025-06-24T15:27:06.101Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (17, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned tanks not belonging to current station","data":null,"timestamp":"2025-06-24T15:28:26.969Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:28:26.969Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (18, 510, 4782876, 'SECURITY_EVENT: INVENTORY_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned inventory not belonging to current station","data":null,"timestamp":"2025-06-24T15:28:26.971Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:28:26.971Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (19, 510, 4782876, 'SECURITY_EVENT: CASH_DRAWER_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned cash drawers not belonging to current station","data":null,"timestamp":"2025-06-24T15:28:26.975Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:28:26.975Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (20, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned tanks not belonging to current station","data":null,"timestamp":"2025-06-24T15:28:45.501Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:28:45.501Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (21, 510, 4782876, 'SECURITY_EVENT: INVENTORY_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned inventory not belonging to current station","data":null,"timestamp":"2025-06-24T15:28:45.520Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:28:45.520Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (22, 510, 4782876, 'SECURITY_EVENT: CASH_DRAWER_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned cash drawers not belonging to current station","data":null,"timestamp":"2025-06-24T15:28:45.524Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:28:45.524Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (23, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned tanks not belonging to current station","data":null,"timestamp":"2025-06-24T15:46:00.870Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:46:00.870Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (24, 510, 4782876, 'SECURITY_EVENT: DEVTOOLS_DETECTED', 'Security_Events', NULL, '{"level":"FRAUD","details":"Developer tools opened","data":null,"timestamp":"2025-06-24T15:46:13.187Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T15:46:13.187Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (25, 510, 4782876, 'SECURITY_EVENT: INVENTORY_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned inventory not belonging to current station","data":null,"timestamp":"2025-06-24T16:04:39.270Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:04:39.270Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (26, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned tanks not belonging to current station","data":null,"timestamp":"2025-06-24T16:05:28.095Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:05:28.095Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (27, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned 14 tanks not belonging to station 510","data":{"expectedStation":"510","invalidTanks":[507,507,507,505,505,505,502,502,502,501,501,501,501,501]},"timestamp":"2025-06-24T16:06:02.878Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:06:02.878Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (28, 510, 4782876, 'SECURITY_EVENT: DEVTOOLS_DETECTED', 'Security_Events', NULL, '{"level":"FRAUD","details":"Developer tools opened","data":null,"timestamp":"2025-06-24T16:06:05.125Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:06:05.125Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (29, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned 14 tanks not belonging to station 510","data":{"expectedStation":"510","invalidTanks":[507,507,507,505,505,505,502,502,502,501,501,501,501,501]},"timestamp":"2025-06-24T16:09:10.428Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:09:10.428Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (30, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned 14 tanks not belonging to station 510","data":{"expectedStation":"510","invalidTanks":[507,507,507,505,505,505,502,502,502,501,501,501,501,501]},"timestamp":"2025-06-24T16:09:12.717Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:09:12.717Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (31, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned 14 tanks not belonging to station 510","data":{"expectedStation":"510","invalidTanks":[507,507,507,505,505,505,502,502,502,501,501,501,501,501]},"timestamp":"2025-06-24T16:09:18.565Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:09:18.565Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (32, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned 14 tanks not belonging to station 510","data":{"expectedStation":"510","invalidTanks":[507,507,507,505,505,505,502,502,502,501,501,501,501,501]},"timestamp":"2025-06-24T16:13:11.610Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:13:11.610Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (33, 510, 4782876, 'SECURITY_EVENT: INVENTORY_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned 7 inventory items not belonging to station 510","data":{"expectedStation":"510","invalidInventory":[501,505,505,504,505,508,503]},"timestamp":"2025-06-24T16:14:27.805Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:14:27.805Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (34, 510, 4782876, 'SECURITY_EVENT: TANK_OWNERSHIP_VIOLATION', 'Security_Events', NULL, '{"level":"FRAUD","details":"Server returned 14 tanks not belonging to station 510","data":{"expectedStation":"510","invalidTanks":[507,507,507,505,505,505,502,502,502,501,501,501,501,501]},"timestamp":"2025-06-24T16:34:38.655Z","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","ipAddress":"CLIENT_IP"}', 'CLIENT_IP', '2025-06-24T16:34:38.655Z');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (35, 510, 4782876, 'COMPONENT_INITIALIZED', 'DailyReadings', 716, '{"stationId":510,"tankCount":16,"initializationTime":380,"sessionData":{"totalInteractions":4,"sessionDuration":381,"inputChanges":0,"errorCount":0,"deviceInfo":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","platform":"Win32","language":"en-US","screen":"1280x800","timezone":"Africa/Dar_es_Salaam","connection":"3g"}},"userInteractions":[{"timestamp":1750797597286,"action":"date_selected","data":{"date":"2025-06-24"},"tankIndex":0,"sessionTime":17,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797597631,"action":"pumps_loaded","data":{"pumpCount":24},"tankIndex":0,"sessionTime":362,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797597637,"action":"readings_loaded","data":{"readingCount":6,"date":"2025-06-24"},"tankIndex":0,"sessionTime":368,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797597641,"action":"tanks_loaded","data":{"tankCount":16},"tankId":716,"tankIndex":0,"sessionTime":372,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"}]}', '197.250.225.251', '2025-06-24 20:39:58');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (36, 510, 4782876, 'COMPONENT_INITIALIZED', 'DailyReadings', 716, '{"stationId":510,"tankCount":16,"initializationTime":57,"sessionData":{"totalInteractions":4,"sessionDuration":57,"inputChanges":0,"errorCount":0,"deviceInfo":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","platform":"Win32","language":"en-US","screen":"1280x800","timezone":"Africa/Dar_es_Salaam","connection":"3g"}},"userInteractions":[{"timestamp":1750797599094,"action":"date_selected","data":{"date":"2025-06-24"},"tankIndex":0,"sessionTime":7,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797599135,"action":"readings_loaded","data":{"readingCount":6,"date":"2025-06-24"},"tankIndex":0,"sessionTime":48,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797599136,"action":"pumps_loaded","data":{"pumpCount":24},"tankIndex":0,"sessionTime":49,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797599137,"action":"tanks_loaded","data":{"tankCount":16},"tankId":716,"tankIndex":0,"sessionTime":50,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"}]}', '197.250.225.251', '2025-06-24 20:39:59');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (37, 510, 4782876, 'COMPONENT_INITIALIZED', 'DailyReadings', 716, '{"stationId":510,"tankCount":16,"initializationTime":115,"sessionData":{"totalInteractions":4,"sessionDuration":115,"inputChanges":0,"errorCount":0,"deviceInfo":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","platform":"Win32","language":"en-US","screen":"1280x800","timezone":"Africa/Dar_es_Salaam","connection":"3g"}},"userInteractions":[{"timestamp":1750797679387,"action":"date_selected","data":{"date":"2025-06-24"},"tankIndex":0,"sessionTime":3,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797679493,"action":"tanks_loaded","data":{"tankCount":16},"tankId":716,"tankIndex":0,"sessionTime":109,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797679497,"action":"pumps_loaded","data":{"pumpCount":24},"tankId":716,"tankIndex":0,"sessionTime":113,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"},{"timestamp":1750797679498,"action":"readings_loaded","data":{"readingCount":6,"date":"2025-06-24"},"tankId":716,"tankIndex":0,"sessionTime":114,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"3g"}]}', '197.250.225.251', '2025-06-24 20:41:20');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (38, 510, 4782876, 'SESSION_HEARTBEAT', 'DailyReadings', 704, '{"interactionCount":80,"sessionDuration":300466,"currentTank":"Premium Diesel Tank","sessionData":{"totalInteractions":80,"sessionDuration":300467,"inputChanges":0,"errorCount":0,"deviceInfo":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","platform":"Win32","language":"en-US","screen":"1280x800","timezone":"Africa/Dar_es_Salaam","connection":"3g"}},"userInteractions":[{"timestamp":1750797950839,"action":"tank_selected","data":{"tankIndex":8,"tankId":708},"tankId":708,"tankIndex":8,"sessionTime":271455,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797950839,"action":"tank_focused","data":{"tankId":708,"tankName":"Kerosene Tank"},"tankId":708,"tankIndex":8,"sessionTime":271455,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797951331,"action":"tank_selected","data":{"tankIndex":9,"tankId":707},"tankId":707,"tankIndex":9,"sessionTime":271947,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797951332,"action":"tank_focused","data":{"tankId":707,"tankName":"Diesel Tank 1"},"tankId":707,"tankIndex":9,"sessionTime":271948,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797951807,"action":"tank_selected","data":{"tankIndex":10,"tankId":706},"tankId":706,"tankIndex":10,"sessionTime":272423,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797951807,"action":"tank_focused","data":{"tankId":706,"tankName":"Petrol Tank 1"},"tankId":706,"tankIndex":10,"sessionTime":272423,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797952293,"action":"tank_selected","data":{"tankIndex":11,"tankId":705},"tankId":705,"tankIndex":11,"sessionTime":272909,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797952294,"action":"tank_focused","data":{"tankId":705,"tankName":"Kerosene Tank"},"tankId":705,"tankIndex":11,"sessionTime":272910,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797952761,"action":"tank_selected","data":{"tankIndex":12,"tankId":704},"tankId":704,"tankIndex":12,"sessionTime":273377,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750797952761,"action":"tank_focused","data":{"tankId":704,"tankName":"Premium Diesel Tank"},"tankId":704,"tankIndex":12,"sessionTime":273377,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"}]}', '197.250.225.251', '2025-06-24 20:46:20');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (39, 510, 4782876, 'TANKS_LOADED', 'DailyReadings', NULL, '{"tankCount":2,"timestamp":"2025-06-24T20:50:45.001Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:50:45');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (40, 510, 4782876, 'PUMPS_LOADED', 'DailyReadings', NULL, '{"pumpCount":2,"timestamp":"2025-06-24T20:50:45.015Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:50:45');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (41, 510, 4782876, 'READINGS_LOADED', 'DailyReadings', NULL, '{"readingCount":6,"date":"2025-06-24","timestamp":"2025-06-24T20:50:45.019Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:50:45');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (42, 510, 4782876, 'COMPONENT_INITIALIZED', 'DailyReadings', NULL, '{"stationId":510,"tankCount":2,"timestamp":"2025-06-24T20:50:45.024Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:50:45');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (43, 510, 4782876, 'READINGS_LOADED', 'DailyReadings', NULL, '{"readingCount":6,"date":"2025-06-24","timestamp":"2025-06-24T20:50:45.035Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:50:45');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (44, 510, 4782876, 'DATE_CHANGED', 'DailyReadings', NULL, '{"date":"2025-06-20","timestamp":"2025-06-24T20:50:59.908Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:51:00');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (45, 510, 4782876, 'READINGS_LOADED', 'DailyReadings', NULL, '{"readingCount":6,"date":"2025-06-20","timestamp":"2025-06-24T20:51:00.245Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:51:00');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (46, 510, 4782876, 'READINGS_LOADED', 'DailyReadings', NULL, '{"readingCount":6,"date":"2025-06-20","timestamp":"2025-06-24T20:51:00.249Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:51:00');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (47, 510, 4782876, 'TANK_MODAL_OPENED', 'DailyReadings', 715, '{"tankId":715,"timestamp":"2025-06-24T20:51:05.819Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:51:05');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (48, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"openingReading","timestamp":"2025-06-24T20:51:15.170Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:51:15');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (49, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"closingReading","timestamp":"2025-06-24T20:51:15.854Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:51:15');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (50, 510, 4782876, 'SESSION_HEARTBEAT', 'DailyReadings', 715, '{"interactionCount":104,"sessionDuration":599997,"currentTank":"PETRO","sessionData":{"totalInteractions":104,"sessionDuration":599997,"inputChanges":0,"errorCount":0,"deviceInfo":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","platform":"Win32","language":"en-US","screen":"1280x800","timezone":"Africa/Dar_es_Salaam","connection":"3g"}},"userInteractions":[{"timestamp":1750798213322,"action":"tank_selected","data":{"tankIndex":3,"tankId":713},"tankId":713,"tankIndex":3,"sessionTime":533938,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798213322,"action":"tank_focused","data":{"tankId":713,"tankName":"Diesel Tank 1"},"tankId":713,"tankIndex":3,"sessionTime":533938,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798213748,"action":"tank_selected","data":{"tankIndex":5,"tankId":711},"tankId":711,"tankIndex":5,"sessionTime":534364,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798213748,"action":"tank_focused","data":{"tankId":711,"tankName":"Kerosene Tank"},"tankId":711,"tankIndex":5,"sessionTime":534364,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798214840,"action":"tank_selected","data":{"tankIndex":4,"tankId":712},"tankId":712,"tankIndex":4,"sessionTime":535456,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798214840,"action":"tank_focused","data":{"tankId":712,"tankName":"Petrol Tank 1"},"tankId":712,"tankIndex":4,"sessionTime":535456,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798215315,"action":"tank_selected","data":{"tankIndex":3,"tankId":713},"tankId":713,"tankIndex":3,"sessionTime":535931,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798215316,"action":"tank_focused","data":{"tankId":713,"tankName":"Diesel Tank 1"},"tankId":713,"tankIndex":3,"sessionTime":535932,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798216246,"action":"tank_selected","data":{"tankIndex":1,"tankId":715},"tankId":715,"tankIndex":1,"sessionTime":536863,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798216247,"action":"tank_focused","data":{"tankId":715,"tankName":"PETRO"},"tankId":715,"tankIndex":1,"sessionTime":536863,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"}]}', '197.250.225.251', '2025-06-24 20:51:20');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (51, 510, 4782876, 'TANK_MODAL_CLOSED', 'DailyReadings', NULL, '{"timestamp":"2025-06-24T20:51:58.501Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:51:58');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (52, 510, 4782876, 'TANK_MODAL_OPENED', 'DailyReadings', 716, '{"tankId":716,"timestamp":"2025-06-24T20:52:42.117Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:52:42');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (53, 510, 4782876, 'TANK_MODAL_CLOSED', 'DailyReadings', NULL, '{"timestamp":"2025-06-24T20:52:45.569Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:52:45');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (54, 510, 4782876, 'TANK_MODAL_OPENED', 'DailyReadings', 715, '{"tankId":715,"timestamp":"2025-06-24T20:52:46.585Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:52:46');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (55, 510, 4782876, 'TANK_MODAL_CLOSED', 'DailyReadings', NULL, '{"timestamp":"2025-06-24T20:52:48.256Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:52:48');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (56, 510, 4782876, 'BULK_ENTRY_OPENED', 'DailyReadings', NULL, '{"timestamp":"2025-06-24T20:53:14.928Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:53:15');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (57, 510, 4782876, 'BULK_ENTRY_OPENED', 'DailyReadings', NULL, '{"timestamp":"2025-06-24T20:53:28.800Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:53:28');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (58, 510, 4782876, 'TANK_MODAL_OPENED', 'DailyReadings', 716, '{"tankId":716,"timestamp":"2025-06-24T20:53:39.385Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:53:39');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (59, 510, 4782876, 'SESSION_HEARTBEAT', 'DailyReadings', 715, '{"interactionCount":104,"sessionDuration":900519,"currentTank":"PETRO","sessionData":{"totalInteractions":104,"sessionDuration":900519,"inputChanges":0,"errorCount":0,"deviceInfo":{"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","platform":"Win32","language":"en-US","screen":"1280x800","timezone":"Africa/Dar_es_Salaam","connection":"3g"}},"userInteractions":[{"timestamp":1750798213322,"action":"tank_selected","data":{"tankIndex":3,"tankId":713},"tankId":713,"tankIndex":3,"sessionTime":533938,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798213322,"action":"tank_focused","data":{"tankId":713,"tankName":"Diesel Tank 1"},"tankId":713,"tankIndex":3,"sessionTime":533938,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798213748,"action":"tank_selected","data":{"tankIndex":5,"tankId":711},"tankId":711,"tankIndex":5,"sessionTime":534364,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798213748,"action":"tank_focused","data":{"tankId":711,"tankName":"Kerosene Tank"},"tankId":711,"tankIndex":5,"sessionTime":534364,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798214840,"action":"tank_selected","data":{"tankIndex":4,"tankId":712},"tankId":712,"tankIndex":4,"sessionTime":535456,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798214840,"action":"tank_focused","data":{"tankId":712,"tankName":"Petrol Tank 1"},"tankId":712,"tankIndex":4,"sessionTime":535456,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798215315,"action":"tank_selected","data":{"tankIndex":3,"tankId":713},"tankId":713,"tankIndex":3,"sessionTime":535931,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798215316,"action":"tank_focused","data":{"tankId":713,"tankName":"Diesel Tank 1"},"tankId":713,"tankIndex":3,"sessionTime":535932,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798216246,"action":"tank_selected","data":{"tankIndex":1,"tankId":715},"tankId":715,"tankIndex":1,"sessionTime":536863,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"},{"timestamp":1750798216247,"action":"tank_focused","data":{"tankId":715,"tankName":"PETRO"},"tankId":715,"tankIndex":1,"sessionTime":536863,"userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36","viewportSize":"1280x679","connectionType":"4g"}]}', '197.250.225.251', '2025-06-24 20:56:21');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (60, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"notes","timestamp":"2025-06-24T20:57:18.913Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:57:19');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (61, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"openingReading","timestamp":"2025-06-24T20:57:22.504Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:57:22');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (62, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"closingReading","timestamp":"2025-06-24T20:57:36.954Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:57:36');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (63, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"openingReading","timestamp":"2025-06-24T20:57:58.847Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:57:58');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (64, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"closingReading","timestamp":"2025-06-24T20:58:07.428Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:58:07');
INSERT INTO AuditLogs (LogID, StationID, UserID, Action, TableName, RecordID, Changes, IPAddress, LogTimestamp) VALUES (65, 510, 4782876, 'INPUT_FOCUS', 'DailyReadings', NULL, '{"field":"dipReading","timestamp":"2025-06-24T20:58:19.463Z","sessionId":"4782876-1750798244932","userAgent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"}', 'client_ip', '2025-06-24 20:58:19');

-- Table: CareerPaths
DROP TABLE IF EXISTS CareerPaths;

CREATE TABLE IF NOT EXISTS CareerPaths (
    PathID                 INTEGER PRIMARY KEY,
    FromPositionID         INTEGER NOT NULL,
    ToPositionID           INTEGER NOT NULL,
    PathType               TEXT    NOT NULL,
    MinTimeInPosition      TEXT    NULL,
    MinPerformanceRating   TEXT    NULL,
    RequiredTraining       TEXT    NULL,
    RequiredCertifications TEXT    NULL,
    Description            TEXT    NULL,
    IsActive               TEXT    NOT NULL
                                   DEFAULT '1',
    CreatedAt              TEXT    NULL
                                   DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt              TEXT    NULL
                                   DEFAULT 'CURRENT_TIMESTAMP',
    CreatedBy              TEXT    NULL,
    FOREIGN KEY (
        FromPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE CASCADE,
    FOREIGN KEY (
        ToPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE CASCADE,
    FOREIGN KEY (
        FromPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE NO ACTION
                                      ON DELETE NO ACTION,
    FOREIGN KEY (
        ToPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE NO ACTION
                                      ON DELETE NO ACTION
)
STRICT;


-- Table: CashDrawers
DROP TABLE IF EXISTS CashDrawers;

CREATE TABLE IF NOT EXISTS CashDrawers (
    DrawerID       INTEGER PRIMARY KEY,
    StationID      INTEGER NOT NULL,
    ShiftDate      TEXT    NOT NULL,
    ShiftType      TEXT    NOT NULL,
    AttendantID    INTEGER NOT NULL,
    OpeningBalance TEXT    NOT NULL
                           DEFAULT '0.00',
    ClosingBalance TEXT    NOT NULL
                           DEFAULT '0.00',
    ExpectedCash   TEXT    NOT NULL
                           DEFAULT '0.00',
    ActualCash     TEXT    NOT NULL
                           DEFAULT '0.00',
    Variance       TEXT    NOT NULL
                           DEFAULT '0.00',
    CashSales      TEXT    NOT NULL
                           DEFAULT '0.00',
    CashPayouts    TEXT    NOT NULL
                           DEFAULT '0.00',
    Status         TEXT    DEFAULT 'Open',
    OpenedBy       INTEGER NOT NULL,
    ClosedBy       INTEGER NULL,
    OpenedAt       TEXT    NOT NULL
                           DEFAULT CURRENT_TIMESTAMP,
    ClosedAt       TEXT    NULL,
    Notes          TEXT    NULL,
    CreatedAt      TEXT    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID),
    FOREIGN KEY (
        AttendantID
    )
    REFERENCES users (id),
    FOREIGN KEY (
        OpenedBy
    )
    REFERENCES users (id),
    FOREIGN KEY (
        ClosedBy
    )
    REFERENCES users (id) 
)
STRICT;

INSERT INTO CashDrawers (DrawerID, StationID, ShiftDate, ShiftType, AttendantID, OpeningBalance, ClosingBalance, ExpectedCash, ActualCash, Variance, CashSales, CashPayouts, Status, OpenedBy, ClosedBy, OpenedAt, ClosedAt, Notes, CreatedAt) VALUES (3, 511, '2025-06-22', 'Night', 4782876, '0', '0.00', '0', '0', '0', '0', '0', 'Closed', 4782876, 4782876, '2025-06-22T21:48:00.258Z', '2025-06-22T23:43:41.572Z', NULL, '2025-06-22 21:48:00');
INSERT INTO CashDrawers (DrawerID, StationID, ShiftDate, ShiftType, AttendantID, OpeningBalance, ClosingBalance, ExpectedCash, ActualCash, Variance, CashSales, CashPayouts, Status, OpenedBy, ClosedBy, OpenedAt, ClosedAt, Notes, CreatedAt) VALUES (4, 510, '2025-06-23', 'Afternoon', 4782876, '267267', '49604247.00', '49604247.00', '49604247.00', '0.00', '49336980.00', '0.00', 'Closed', 4782876, 4782876, '2025-06-23 20:33:36', '2025-06-24T01:04:11.294Z', 'hgshshsghs', '2025-06-23 20:33:36');
INSERT INTO CashDrawers (DrawerID, StationID, ShiftDate, ShiftType, AttendantID, OpeningBalance, ClosingBalance, ExpectedCash, ActualCash, Variance, CashSales, CashPayouts, Status, OpenedBy, ClosedBy, OpenedAt, ClosedAt, Notes, CreatedAt) VALUES (5, 510, '2025-06-24', 'Night', 4782876, '100000.00', '631000.00', '631000.00', '631000.00', '0.00', '531000.00', '0.00', 'Closed', 4782876, 4782876, '2025-06-24T01:04:18.814Z', '2025-06-24T15:13:31.321Z', NULL, '2025-06-24T01:04:18.814Z');
INSERT INTO CashDrawers (DrawerID, StationID, ShiftDate, ShiftType, AttendantID, OpeningBalance, ClosingBalance, ExpectedCash, ActualCash, Variance, CashSales, CashPayouts, Status, OpenedBy, ClosedBy, OpenedAt, ClosedAt, Notes, CreatedAt) VALUES (8, 510, '2025-06-24', 'Afternoon', 4782876, '100000.00', '0.00', '333640.00', '0.00', '0.00', '233640.00', '0.00', 'Open', 4782876, NULL, '2025-06-24T18:59:08.984Z', NULL, NULL, '2025-06-24T18:59:08.984Z');

-- Table: CustomerCreditAccounts
DROP TABLE IF EXISTS CustomerCreditAccounts;

CREATE TABLE IF NOT EXISTS CustomerCreditAccounts (
    CreditAccountID   INTEGER PRIMARY KEY,
    CustomerID        INTEGER NOT NULL
                              REFERENCES Customers (CustomerID),
    StationID         INTEGER NULL
                              REFERENCES Stations (StationID),-- NULL = Global account
    CreditLimit       TEXT    NOT NULL
                              DEFAULT '0.00',
    CurrentBalance    TEXT    NOT NULL
                              DEFAULT '0.00',-- What they owe us
    AvailableCredit   TEXT    NOT NULL
                              DEFAULT '0.00',-- CreditLimit - CurrentBalance
    PaymentTermsDays  TEXT    NOT NULL
                              DEFAULT '30',
    LastPurchaseDate  TEXT    NULL,
    LastPaymentDate   TEXT    NULL,
    LastPaymentAmount TEXT    DEFAULT '0.00',
    CreditScore       TEXT    DEFAULT '100',-- 0-100 scale based on payment history
    IsActive          TEXT    DEFAULT '1',
    ApprovedBy        INTEGER NOT NULL
                              REFERENCES users (id),
    ApprovedDate      TEXT    NOT NULL
                              DEFAULT CURRENT_TIMESTAMP,
    CreatedAt         TEXT    DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt         TEXT    DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (
        CustomerID,
        StationID
    )
)
STRICT;


-- Table: CustomerCreditPayments
DROP TABLE IF EXISTS CustomerCreditPayments;

CREATE TABLE IF NOT EXISTS CustomerCreditPayments (
    PaymentID               INTEGER PRIMARY KEY,
    CustomerID              INTEGER NOT NULL
                                    REFERENCES Customers (CustomerID),
    StationID               INTEGER NOT NULL
                                    REFERENCES Stations (StationID),
    PaymentReference        TEXT    NOT NULL
                                    UNIQUE,
    PaymentDate             TEXT    NOT NULL
                                    DEFAULT CURRENT_TIMESTAMP,
    PaymentAmount           TEXT    NOT NULL,
    PaymentMethod           TEXT    NOT NULL,-- Cash, Bank Transfer, Mobile Money, Card
    MobileMoneyReference    TEXT    NULL,
    BankReference           TEXT    NULL,
    AllocatedToTransactions TEXT    DEFAULT '[]',-- JSON array of TransactionIDs
    Notes                   TEXT    NULL,
    ReceivedBy              INTEGER NOT NULL
                                    REFERENCES users (id),
    VerifiedBy              INTEGER NULL
                                    REFERENCES users (id),
    Status                  TEXT    DEFAULT 'Completed',-- Pending, Completed, Failed
    CreatedAt               TEXT    DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt               TEXT    DEFAULT CURRENT_TIMESTAMP
)
STRICT;


-- Table: Customers
DROP TABLE IF EXISTS Customers;

CREATE TABLE IF NOT EXISTS Customers (
    CustomerID       INTEGER PRIMARY KEY,
    CustomerType     TEXT    NOT NULL
                             DEFAULT 'Individual',-- Individual, Corporate, Fleet
    CustomerCode     TEXT    NOT NULL
                             UNIQUE,
    FirstName        TEXT    NULL,
    LastName         TEXT    NULL,
    CompanyName      TEXT    NULL,
    PhoneNumber      TEXT    NOT NULL,
    Email            TEXT    NULL,
    NationalID       TEXT    NULL,
    TaxID            TEXT    NULL,
    Address          TEXT    NULL,
    PrimaryStationID INTEGER NULL
                             REFERENCES Stations (StationID),
    RegistrationDate TEXT    NOT NULL
                             DEFAULT CURRENT_TIMESTAMP,
    Status           TEXT    NOT NULL
                             DEFAULT 'Active',-- Active, Suspended, Blacklisted
    CreatedAt        TEXT    NOT NULL
                             DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt        TEXT    NOT NULL
                             DEFAULT CURRENT_TIMESTAMP
)
STRICT;


-- Refactored DailyReadings Table for Kigrama Fuel Station System
-- This table supports both meter readings and dip reconciliation workflows

DROP TABLE IF EXISTS DailyReadings;

CREATE TABLE IF NOT EXISTS DailyReadings (
    ReadingID       INTEGER PRIMARY KEY,
    StationID       INTEGER NOT NULL,
    ReadingDate     TEXT    NOT NULL,
    PumpID          INTEGER NULL,
    TankID          INTEGER NULL,
    OpeningReading  TEXT    NULL,
    ClosingReading  TEXT    NULL,
    DipReading      TEXT    NULL,
    CalculatedSales TEXT    NULL,
    Variance        TEXT    NULL,
    RecordedBy      TEXT    NULL,
    VerifiedBy      TEXT    NULL,
    Status          TEXT    NULL DEFAULT 'Pending',
    CreatedAt       TEXT    NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Additional columns for dip reading reconciliation (TEXT for consistency)
    Temperature     TEXT    NULL,
    WaterLevelCM    TEXT    NULL,
    WaterVolumeL    TEXT    NULL,
    
    -- Foreign Key Constraints (cleaned up duplicates)
    FOREIGN KEY (StationID) REFERENCES Stations (StationID) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (PumpID) REFERENCES Pumps (PumpID) 
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (TankID) REFERENCES Tanks (TankID) 
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (RecordedBy) REFERENCES users (id) 
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (VerifiedBy) REFERENCES users (id) 
        ON UPDATE CASCADE ON DELETE SET NULL
) STRICT;

-- Create indexes for performance optimization
CREATE INDEX IF NOT EXISTS idx_dailyreadings_station_date 
    ON DailyReadings(StationID, ReadingDate);
CREATE INDEX IF NOT EXISTS idx_dailyreadings_pump_date 
    ON DailyReadings(PumpID, ReadingDate);
CREATE INDEX IF NOT EXISTS idx_dailyreadings_tank_date 
    ON DailyReadings(TankID, ReadingDate);
CREATE INDEX IF NOT EXISTS idx_dailyreadings_status 
    ON DailyReadings(Status);
CREATE INDEX IF NOT EXISTS idx_dailyreadings_dip_null 
    ON DailyReadings(DipReading) WHERE DipReading IS NULL;


-- Table: Departments
DROP TABLE IF EXISTS Departments;

CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID       INTEGER PRIMARY KEY,
    DepartmentName     TEXT    NOT NULL,
    DepartmentCode     TEXT    NOT NULL,
    ParentDepartmentID INTEGER NULL,
    ManagerUserID      INTEGER NULL,
    Description        TEXT    NULL,
    IsActive           TEXT    NOT NULL
                               DEFAULT '1',
    CreatedAt          TEXT    NULL
                               DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt          TEXT    NULL
                               DEFAULT 'CURRENT_TIMESTAMP',
    CreatedBy          TEXT    NULL,
    UpdatedBy          TEXT    NULL,
    FOREIGN KEY (
        ParentDepartmentID
    )
    REFERENCES Departments (DepartmentID) ON UPDATE CASCADE
                                          ON DELETE SET NULL,
    FOREIGN KEY (
        ManagerUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        ManagerUserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        ParentDepartmentID
    )
    REFERENCES Departments (DepartmentID) ON UPDATE NO ACTION
                                          ON DELETE NO ACTION
)
STRICT;

INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (301, 'Executive Office', 'EXO', NULL, 2701, 'Executive leadership and strategic management', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (302, 'Operations', 'OPS', 301, 2702, 'Oversees all operational aspects of fuel stations', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (303, 'Finance', 'FIN', 301, 2703, 'Manages financial planning, accounting, and reporting', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (304, 'Human Resources', 'HR', 301, 2704, 'Manages recruitment, training, and employee relations', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (305, 'Health, Safety & Environment', 'HSE', 301, 2724, 'Ensures HSE compliance', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (306, 'Central Region', 'CEN', 302, 2704, 'Operations in the Central region', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (307, 'Eastern Region', 'EST', 302, 2705, 'Operations in the Eastern region', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (308, 'Western Region', 'WST', 302, 2706, 'Operations in the Western region', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (309, 'Retail Operations', 'RET', 302, 2702, 'Manages retail fuel sales and convenience stores', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (310, 'Maintenance', 'MNT', 302, 2721, 'Responsible for equipment maintenance and repairs', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (311, 'Quality Control', 'QC', 302, 2724, 'Ensures fuel quality standards', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (312, 'Supply Chain', 'SCM', 302, 2702, 'Manages fuel procurement and logistics', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (313, 'Accounting', 'ACC', 303, 2703, 'Handles day‑to‑day accounting and bookkeeping', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2703', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (314, 'Treasury', 'TRS', 303, 2703, 'Manages cash flow and banking relationships', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2703', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (315, 'Tax', 'TAX', 303, 2703, 'Ensures tax compliance and optimisation', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2703', NULL);
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (328, 'hjshhshhsh', 'hjshshh', 305, NULL, 'shhssh', '1', '2025-05-07 20:38:36', '2025-05-07 20:38:36', '5', '5');
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentCode, ParentDepartmentID, ManagerUserID, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (330, '3882288', '3882288', 302, NULL, 'jssjshhshshshs', '1', '2025-05-07 20:48:46', '2025-05-07 20:48:46', '5', '5');

-- Table: error_logs
DROP TABLE IF EXISTS error_logs;

CREATE TABLE IF NOT EXISTS error_logs (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    route         TEXT,
    method        TEXT,
    url           TEXT,
    body          TEXT,
    params        TEXT,
    user          TEXT,
    error_message TEXT,
    error_stack   TEXT,
    created_at    TEXT
);


-- Table: FraudDetectionLogs
DROP TABLE IF EXISTS FraudDetectionLogs;

CREATE TABLE IF NOT EXISTS FraudDetectionLogs (
    FraudLogID      INTEGER PRIMARY KEY,
    DetectionRuleID INTEGER NULL,
    TransactionID   INTEGER NULL,
    StationID       INTEGER NULL,
    UserID          INTEGER NULL,
    RiskScore       TEXT    NULL,
    Severity        TEXT    NOT NULL
                            DEFAULT 'Low',
    FraudType       TEXT    NULL,
    Description     TEXT    NULL,
    DetectedAt      TEXT    NULL
                            DEFAULT CURRENT_TIMESTAMP,
    Status          TEXT    NOT NULL
                            DEFAULT 'Open',
    ResolvedBy      TEXT    NULL,
    ResolvedAt      TEXT    NULL,
    Notes           TEXT    NULL,
    CreatedAt       TEXT    NULL
                            DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt       TEXT    NULL
                            DEFAULT 'CURRENT_TIMESTAMP'
)
STRICT;

INSERT INTO FraudDetectionLogs (FraudLogID, DetectionRuleID, TransactionID, StationID, UserID, RiskScore, Severity, FraudType, Description, DetectedAt, Status, ResolvedBy, ResolvedAt, Notes, CreatedAt, UpdatedAt) VALUES (1, NULL, NULL, 510, 4782876, '65', 'medium', 'POS Transaction', 'Transaction outside normal hours; User role not authorized for POS sales', '2025-06-24T00:12:21.514Z', 'Flagged', NULL, NULL, NULL, '2025-06-24 00:12:20', 'CURRENT_TIMESTAMP');
INSERT INTO FraudDetectionLogs (FraudLogID, DetectionRuleID, TransactionID, StationID, UserID, RiskScore, Severity, FraudType, Description, DetectedAt, Status, ResolvedBy, ResolvedAt, Notes, CreatedAt, UpdatedAt) VALUES (2, NULL, NULL, 510, 4782876, '65', 'medium', 'POS Transaction', 'Transaction outside normal hours; User role not authorized for POS sales', '2025-06-24T00:12:27.422Z', 'Flagged', NULL, NULL, NULL, '2025-06-24 00:12:26', 'CURRENT_TIMESTAMP');
INSERT INTO FraudDetectionLogs (FraudLogID, DetectionRuleID, TransactionID, StationID, UserID, RiskScore, Severity, FraudType, Description, DetectedAt, Status, ResolvedBy, ResolvedAt, Notes, CreatedAt, UpdatedAt) VALUES (3, NULL, NULL, 510, 4782876, '65', 'medium', 'POS Transaction', 'Transaction outside normal hours; User role not authorized for POS sales', '2025-06-24T00:12:32.683Z', 'Flagged', NULL, NULL, NULL, '2025-06-24 00:12:34', 'CURRENT_TIMESTAMP');
INSERT INTO FraudDetectionLogs (FraudLogID, DetectionRuleID, TransactionID, StationID, UserID, RiskScore, Severity, FraudType, Description, DetectedAt, Status, ResolvedBy, ResolvedAt, Notes, CreatedAt, UpdatedAt) VALUES (4, NULL, NULL, 510, 4782876, '65', 'medium', 'POS Transaction', 'Transaction outside normal hours; User role not authorized for POS sales', '2025-06-24T00:12:34.968Z', 'Flagged', NULL, NULL, NULL, '2025-06-24 00:12:36', 'CURRENT_TIMESTAMP');
INSERT INTO FraudDetectionLogs (FraudLogID, DetectionRuleID, TransactionID, StationID, UserID, RiskScore, Severity, FraudType, Description, DetectedAt, Status, ResolvedBy, ResolvedAt, Notes, CreatedAt, UpdatedAt) VALUES (5, NULL, NULL, 510, 4782876, '65', 'medium', 'POS Transaction', 'Transaction outside normal hours; User role not authorized for POS sales', '2025-06-24T00:12:36.591Z', 'Flagged', NULL, NULL, NULL, '2025-06-24 00:12:37', 'CURRENT_TIMESTAMP');
INSERT INTO FraudDetectionLogs (FraudLogID, DetectionRuleID, TransactionID, StationID, UserID, RiskScore, Severity, FraudType, Description, DetectedAt, Status, ResolvedBy, ResolvedAt, Notes, CreatedAt, UpdatedAt) VALUES (6, NULL, NULL, 510, 4782876, '40', 'low', 'POS Transaction', 'User role not authorized for POS sales', '2025-06-24T00:13:25.452Z', 'Cleared', NULL, NULL, NULL, '2025-06-24 00:13:24', 'CURRENT_TIMESTAMP');

-- Table: FraudDetectionRules
DROP TABLE IF EXISTS FraudDetectionRules;

CREATE TABLE IF NOT EXISTS FraudDetectionRules (
    DetectionRuleID INTEGER PRIMARY KEY,
    RuleName        TEXT    NOT NULL,
    Description     TEXT    NULL,
    Threshold       TEXT    NULL,
    Enabled         TEXT    NOT NULL
                            DEFAULT '1',
    CreatedAt       TEXT    NULL
                            DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt       TEXT    NULL
                            DEFAULT 'CURRENT_TIMESTAMP'
)
STRICT;


-- Table: InventoryHistory
DROP TABLE IF EXISTS InventoryHistory;

CREATE TABLE IF NOT EXISTS InventoryHistory (
    HistoryID            INTEGER PRIMARY KEY,
    StationID            INTEGER NOT NULL,
    ProductID            INTEGER NOT NULL,
    TankID               INTEGER NULL,
    PumpID               INTEGER NULL,
    TransactionID        INTEGER NULL,
    TransferID           INTEGER NULL,
    ChangeDate           TEXT    NOT NULL
                                 DEFAULT CURRENT_TIMESTAMP,
    ChangeType           TEXT    NOT NULL,
    PreviousQuantity     TEXT    NOT NULL,
    QuantityChange       TEXT    NOT NULL,
    NewQuantity          TEXT    NOT NULL,
    UnitPrice            TEXT    NULL,
    TotalValue           TEXT    NULL,
    ReasonForChange      TEXT    NULL,
    AdjustmentCategory   TEXT    NULL,
    BatchNumber          TEXT    NULL,
    ExpiryDate           TEXT    NULL,
    QualityCheck         TEXT    NULL
                                 DEFAULT 'N/A',
    MeasurementMethod    TEXT    NULL,
    MeasurementDetails   TEXT    NULL,
    AuthorizedBy         TEXT    NULL,
    RecordedBy           TEXT    NOT NULL,
    VerifiedBy           TEXT    NULL,
    Notes                TEXT    NULL,
    AdditionalProperties TEXT    NULL,
    CreatedAt            TEXT    NULL
                                 DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        AuthorizedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        ProductID
    )
    REFERENCES Products (ProductID) ON UPDATE CASCADE
                                    ON DELETE RESTRICT,
    FOREIGN KEY (
        PumpID
    )
    REFERENCES Pumps (PumpID) ON UPDATE CASCADE
                              ON DELETE SET NULL,
    FOREIGN KEY (
        RecordedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE RESTRICT,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        TankID
    )
    REFERENCES Tanks (TankID) ON UPDATE CASCADE
                              ON DELETE SET NULL,
    FOREIGN KEY (
        TransactionID
    )
    REFERENCES Transactions (TransactionID) ON UPDATE CASCADE
                                            ON DELETE SET NULL,
    FOREIGN KEY (
        TransferID
    )
    REFERENCES StationTransfers (TransferID) ON UPDATE CASCADE
                                             ON DELETE SET NULL,
    FOREIGN KEY (
        VerifiedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        AuthorizedBy
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        ProductID
    )
    REFERENCES Products (ProductID) ON UPDATE NO ACTION
                                    ON DELETE NO ACTION,
    FOREIGN KEY (
        PumpID
    )
    REFERENCES Pumps (PumpID) ON UPDATE NO ACTION
                              ON DELETE NO ACTION,
    FOREIGN KEY (
        RecordedBy
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE NO ACTION
                                    ON DELETE NO ACTION,
    FOREIGN KEY (
        TankID
    )
    REFERENCES Tanks (TankID) ON UPDATE NO ACTION
                              ON DELETE NO ACTION,
    FOREIGN KEY (
        TransactionID
    )
    REFERENCES Transactions (TransactionID) ON UPDATE NO ACTION
                                            ON DELETE NO ACTION,
    FOREIGN KEY (
        TransferID
    )
    REFERENCES StationTransfers (TransferID) ON UPDATE NO ACTION
                                             ON DELETE NO ACTION,
    FOREIGN KEY (
        VerifiedBy
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION
)
STRICT;

INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (1, 503, 610, NULL, NULL, NULL, NULL, '2025-05-10 23:21:52', 'Other', '0', '999', '999', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '5', NULL, 'Initial product assignment', NULL, '2025-05-11 02:21:52');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (2, 508, 614, NULL, NULL, NULL, NULL, '2025-05-10 23:25:39', 'Other', '0', '99', '99', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '5', NULL, 'Initial product assignment', NULL, '2025-05-11 02:25:39');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (3, 505, 606, NULL, NULL, NULL, NULL, '2025-05-10 23:35:30', 'Other', '0', '3', '3', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '5', NULL, 'Initial product assignment', NULL, '2025-05-11 02:35:30');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (4, 504, 610, NULL, NULL, NULL, NULL, '2025-05-10 23:38:41', 'Other', '0', '3', '3', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '5', NULL, 'Initial product assignment', NULL, '2025-05-11 02:38:41');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (5, 505, 612, NULL, NULL, NULL, NULL, '2025-05-10 23:39:27', 'Other', '0', '8', '8', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '5', NULL, 'Initial product assignment', NULL, '2025-05-11 02:39:27');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (6, 505, 603, NULL, NULL, NULL, NULL, '2025-05-10 23:43:06', 'Other', '0', '8', '8', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '5', NULL, 'Initial product assignment', NULL, '2025-05-11 02:43:06');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (7, 501, 606, NULL, NULL, NULL, NULL, '2025-05-11 00:19:08', 'Other', '0', '5', '5', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '5', NULL, 'Initial product assignment', NULL, '2025-05-11 03:19:08');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (8, 510, 612, NULL, NULL, NULL, NULL, '2025-06-24 00:27:30', 'Sale', '1', '-1', '0', '120000', '120000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T00:27:29.769Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (9, 510, 603, 713, 821, NULL, NULL, '2025-06-24 00:52:37', 'Fuel Sale', '0', '-9955', '0', '4200', '41811000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T00:52:37.331Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (10, 510, 601, 712, 818, NULL, NULL, '2025-06-24 01:13:47', 'Fuel Sale', '0', '-90', '0', '4500', '405000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T01:13:48.060Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (11, 510, 604, 704, 806, 12, NULL, '2025-06-24 15:10:48', 'Fuel Sale', '0', '-4', '0', '4500', '18000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T15:10:48.466Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (12, 510, 601, 712, 819, 13, NULL, '2025-06-24 15:11:24', 'Fuel Sale', '0', '-6', '0', '4500', '27000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T15:11:24.030Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (13, 510, 604, 704, 806, 14, NULL, '2025-06-24 15:27:06', 'Fuel Sale', '0', '-5', '0', '4500', '22500', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T15:27:06.062Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (14, 510, 604, 716, 823, 17, NULL, '2025-06-24 18:45:58', 'Fuel Sale', '0', '-500', '0', '4500', '2250000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T18:45:58.773Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (15, 510, 604, 715, 824, 18, NULL, '2025-06-24 18:59:21', 'Fuel Sale', '0', '-2', '0', '4500', '9000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T18:59:21.403Z');
INSERT INTO InventoryHistory (HistoryID, StationID, ProductID, TankID, PumpID, TransactionID, TransferID, ChangeDate, ChangeType, PreviousQuantity, QuantityChange, NewQuantity, UnitPrice, TotalValue, ReasonForChange, AdjustmentCategory, BatchNumber, ExpiryDate, QualityCheck, MeasurementMethod, MeasurementDetails, AuthorizedBy, RecordedBy, VerifiedBy, Notes, AdditionalProperties, CreatedAt) VALUES (16, 510, 604, 715, 824, 18, NULL, '2025-06-24 18:59:21', 'Fuel Sale', '0', '-42', '0', '4500', '189000', 'POS Sale', NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, '4782876', NULL, NULL, NULL, '2025-06-24T18:59:21.458Z');

-- Table: JobGrades
DROP TABLE IF EXISTS JobGrades;

CREATE TABLE IF NOT EXISTS JobGrades (
    GradeID     INTEGER PRIMARY KEY,
    GradeCode   TEXT    NOT NULL,
    GradeName   TEXT    NOT NULL,
    MinSalary   TEXT    NOT NULL,
    MidSalary   TEXT    NULL,
    MaxSalary   TEXT    NOT NULL,
    Level       TEXT    NOT NULL,
    Description TEXT    NULL,
    IsActive    TEXT    NOT NULL
                        DEFAULT '1',
    CreatedAt   TEXT    NULL
                        DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt   TEXT    NULL
                        DEFAULT 'CURRENT_TIMESTAMP',
    CreatedBy   TEXT    NULL,
    UpdatedBy   TEXT    NULL
)
STRICT;

INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (21, 'JG-01', 'Fuel Attendant', '350000', '425000', '500000', '1', 'Entry-level position responsible for dispensing fuel, basic customer service, and maintaining cleanliness of the forecourt area.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (22, 'JG-02', 'Cashier', '400000', '475000', '550000', '2', 'Responsible for processing payments, basic accounting, and customer service at the point of sale.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (23, 'JG-03', 'Maintenance Technician', '450000', '550000', '650000', '3', 'Responsible for basic maintenance of fuel equipment, pumps, and station facilities.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (24, 'JG-04', 'Shift Supervisor', '550000', '675000', '800000', '4', 'Supervises daily operations during assigned shifts, manages staff, and ensures compliance with safety procedures.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (25, 'JG-05', 'Forecourt Supervisor', '600000', '750000', '900000', '5', 'Oversees all forecourt operations, including fuel dispensing, equipment maintenance, and safety compliance.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (26, 'JG-06', 'Retail Supervisor', '650000', '800000', '950000', '6', 'Manages convenience store operations, inventory, merchandising, and retail staff.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (27, 'JG-07', 'Assistant Station Manager', '800000', '1000000', '1200000', '7', 'Assists in overall station management, staff supervision, and operational efficiency.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (28, 'JG-08', 'Station Manager', '1000000', '1250000', '1500000', '8', 'Responsible for complete management of a single station, including operations, staff, compliance, and financial performance.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (29, 'JG-09', 'Senior Station Manager', '1200000', '1500000', '1800000', '9', 'Manages larger or high-volume stations with additional responsibilities for business development and strategic planning.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (30, 'JG-10', 'Area Supervisor', '1500000', '1850000', '2200000', '10', 'Oversees multiple stations within a defined geographic area, ensuring operational standards and performance targets are met.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (31, 'JG-11', 'Regional Manager', '1800000', '2250000', '2700000', '11', 'Manages all operations within a region, including business development, compliance, and financial performance.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (32, 'JG-12', 'HSE Officer', '1000000', '1300000', '1600000', '8', 'Responsible for health, safety, and environmental compliance across stations.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (33, 'JG-13', 'Quality Assurance Specialist', '1100000', '1400000', '1700000', '9', 'Ensures fuel quality standards and testing protocols are maintained across all stations.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (34, 'JG-14', 'Maintenance Engineer', '1200000', '1500000', '1800000', '9', 'Specialized role for advanced technical maintenance of fuel systems, tanks, and dispensing equipment.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (35, 'JG-15', 'Operations Director', '2200000', '2750000', '3300000', '12', 'Directs all operational aspects of the fuel station network, including strategy, performance, and growth.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (36, 'JG-16', 'Finance Director', '2300000', '2900000', '3500000', '12', 'Oversees all financial aspects of the fuel station business, including budgeting, reporting, and financial strategy.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (37, 'JG-17', 'Commercial Director', '2400000', '3000000', '3600000', '12', 'Responsible for business development, partnerships, and commercial strategy for the fuel station network.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (38, 'JG-18', 'General Manager', '3000000', '3750000', '4500000', '13', 'Overall responsibility for the entire fuel station business, reporting to the board or ownership.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (39, 'JG-19', 'Managing Director', '3500000', '4500000', '5500000', '14', 'Executive leadership role with full P&L responsibility and strategic direction of the fuel station business.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (40, 'JG-20', 'Chief Executive Officer', '4500000', '6000000', '7500000', '15', 'Highest executive position with ultimate responsibility for company performance, strategy, and stakeholder relations.', '1', '2025-05-06 23:52:41', '2025-05-06 23:52:41', NULL, NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (101, 'JG-101', 'Junior Manager', '800000', '1000000', '1200000', '7', 'Entry-level management position with supervisory responsibilities', '1', '2025-05-07 16:58:37', '2025-05-07 16:58:37', '100', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (102, 'JG-102', 'Senior Technician', '600000', '750000', '900000', '5', 'Experienced technical position responsible for maintenance and operations', '1', '2025-05-07 16:58:37', '2025-05-07 16:58:37', '100', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (201, 'EX-01', 'Executive Director', '6000000', '7500000', '9000000', '15', 'Top executive positions including CEO, COO, and CFO', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (202, 'EX-02', 'Senior Director', '5000000', '6000000', '7000000', '14', 'Senior director positions reporting to executive directors', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (203, 'EX-03', 'Director', '4000000', '4500000', '5000000', '13', 'Director-level positions with strategic responsibilities', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (204, 'MG-01', 'Senior Manager', '3000000', '3500000', '4000000', '12', 'Senior management positions including regional managers', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (205, 'MG-02', 'Manager', '2500000', '3000000', '3500000', '11', 'Management positions including station managers', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (206, 'MG-03', 'Assistant Manager', '2000000', '2250000', '2500000', '10', 'Assistant management positions supporting station managers', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (207, 'SV-01', 'Senior Supervisor', '1800000', '2000000', '2200000', '9', 'Senior supervisory positions overseeing multiple shifts or areas', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (208, 'SV-02', 'Supervisor', '1500000', '1650000', '1800000', '8', 'Supervisory positions responsible for shift operations', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (209, 'SV-03', 'Junior Supervisor', '1200000', '1350000', '1500000', '7', 'Entry-level supervisory positions', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (210, 'TC-01', 'Senior Technician', '1500000', '1750000', '2000000', '8', 'Senior technical positions requiring specialised skills', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (211, 'TC-02', 'Technician', '1200000', '1350000', '1500000', '7', 'Technical positions requiring specialised training', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (212, 'TC-03', 'Junior Technician', '900000', '1050000', '1200000', '6', 'Entry-level technical positions', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (213, 'AD-01', 'Senior Administrator', '1200000', '1400000', '1600000', '7', 'Senior administrative positions with significant responsibility', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (214, 'AD-02', 'Administrator', '900000', '1050000', '1200000', '6', 'Administrative positions supporting operations', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (215, 'AD-03', 'Junior Administrator', '700000', '800000', '900000', '5', 'Entry-level administrative positions', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (216, 'OP-01', 'Senior Operator', '800000', '900000', '1000000', '5', 'Senior operational positions including senior cashiers and attendants', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (217, 'OP-02', 'Operator', '600000', '700000', '800000', '4', 'Operational positions including cashiers and attendants', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (218, 'OP-03', 'Junior Operator', '400000', '450000', '500000', '3', 'Entry-level operational positions', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (219, 'SP-01', 'Senior Support', '500000', '550000', '600000', '3', 'Senior support positions', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (220, 'SP-02', 'Support', '400000', '425000', '450000', '2', 'Support positions including cleaners and security', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (221, 'SP-03', 'Junior Support', '350000', '375000', '400000', '1', 'Entry-level support positions', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO JobGrades (GradeID, GradeCode, GradeName, MinSalary, MidSalary, MaxSalary, Level, Description, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (228, '32653', 'huahs', '323', '32333', '323345', '16', '4434', '1', '2025-05-07 21:40:34', '2025-05-07 21:40:34', '5', '5');

-- Table: LedgerEntries
DROP TABLE IF EXISTS LedgerEntries;

CREATE TABLE IF NOT EXISTS LedgerEntries (
    EntryID         INTEGER PRIMARY KEY,
    StationID       INTEGER NOT NULL,
    TransactionDate TEXT    NOT NULL
                            DEFAULT CURRENT_TIMESTAMP,
    AccountCode     TEXT    NOT NULL,
    TransactionType TEXT    NOT NULL,
    ReferenceID     INTEGER NULL,
    Description     TEXT    NOT NULL,
    DebitAmount     TEXT    NULL
                            DEFAULT '0.00',
    CreditAmount    TEXT    NULL
                            DEFAULT '0.00',
    RecordedBy      TEXT    NOT NULL,
    CreatedAt       TEXT    NULL
                            DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        RecordedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE RESTRICT,
    FOREIGN KEY (
        RecordedBy
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE NO ACTION
                                    ON DELETE NO ACTION
)
STRICT;

INSERT INTO LedgerEntries (EntryID, StationID, TransactionDate, AccountCode, TransactionType, ReferenceID, Description, DebitAmount, CreditAmount, RecordedBy, CreatedAt) VALUES (1, 510, '2025-06-24T00:13:25.655Z', '4000', 'Sale', NULL, 'POS Sale - Transaction #undefined', '0.00', '566400.00', '4782876', '2025-06-24T00:13:25.655Z');
INSERT INTO LedgerEntries (EntryID, StationID, TransactionDate, AccountCode, TransactionType, ReferenceID, Description, DebitAmount, CreditAmount, RecordedBy, CreatedAt) VALUES (2, 510, '2025-06-24T00:13:25.669Z', '1000', 'Sale', NULL, 'Cash Payment - Transaction #undefined', '566400.00', '0.00', '4782876', '2025-06-24T00:13:25.669Z');
INSERT INTO LedgerEntries (EntryID, StationID, TransactionDate, AccountCode, TransactionType, ReferenceID, Description, DebitAmount, CreditAmount, RecordedBy, CreatedAt) VALUES (3, 510, '2025-06-24T00:13:25.683Z', '2100', 'Tax', NULL, 'VAT on Sale - Transaction #undefined', '0.00', '86400.00', '4782876', '2025-06-24T00:13:25.683Z');

-- Table: Permissions
DROP TABLE IF EXISTS Permissions;

CREATE TABLE IF NOT EXISTS Permissions (
    PermissionID   INTEGER PRIMARY KEY,
    PermissionName TEXT    NOT NULL,
    Description    TEXT    NULL,
    Module         TEXT    NOT NULL,
    Action         TEXT    NOT NULL,
    CreatedAt      TEXT    NULL
                           DEFAULT CURRENT_TIMESTAMP
)
STRICT;


-- Table: PositionHistory
DROP TABLE IF EXISTS PositionHistory;

CREATE TABLE IF NOT EXISTS PositionHistory (
    HistoryID           INTEGER PRIMARY KEY,
    UserID              INTEGER NOT NULL,
    FromPositionID      INTEGER NULL,
    ToPositionID        INTEGER NOT NULL,
    FromDepartmentID    INTEGER NULL,
    ToDepartmentID      INTEGER NOT NULL,
    FromGradeID         INTEGER NULL,
    ToGradeID           INTEGER NOT NULL,
    FromStationID       INTEGER NULL,
    ToStationID         INTEGER NULL,
    ChangeType          TEXT    NOT NULL,
    EffectiveDate       TEXT    NOT NULL,
    PreviousSalary      TEXT    NULL,
    NewSalary           TEXT    NULL,
    SalaryChangePercent TEXT    NULL,
    Reason              TEXT    NULL,
    RequestID           INTEGER NULL,
    ApprovedBy          TEXT    NULL,
    ApprovalDate        TEXT    NULL,
    DocumentPath        TEXT    NULL,
    Notes               TEXT    NULL,
    CreatedAt           TEXT    NULL
                                DEFAULT CURRENT_TIMESTAMP,
    CreatedBy           TEXT    NULL,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE,
    FOREIGN KEY (
        FromPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE SET NULL,
    FOREIGN KEY (
        ToPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    FOREIGN KEY (
        FromDepartmentID
    )
    REFERENCES Departments (DepartmentID) ON UPDATE CASCADE
                                          ON DELETE SET NULL,
    FOREIGN KEY (
        ToDepartmentID
    )
    REFERENCES Departments (DepartmentID) ON UPDATE CASCADE
                                          ON DELETE RESTRICT,
    FOREIGN KEY (
        FromGradeID
    )
    REFERENCES JobGrades (GradeID) ON UPDATE CASCADE
                                   ON DELETE SET NULL,
    FOREIGN KEY (
        ToGradeID
    )
    REFERENCES JobGrades (GradeID) ON UPDATE CASCADE
                                   ON DELETE RESTRICT,
    FOREIGN KEY (
        FromStationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE SET NULL,
    FOREIGN KEY (
        ToStationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE SET NULL,
    FOREIGN KEY (
        ApprovedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        ApprovedBy
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        FromDepartmentID
    )
    REFERENCES Departments (DepartmentID) ON UPDATE NO ACTION
                                          ON DELETE NO ACTION,
    FOREIGN KEY (
        FromGradeID
    )
    REFERENCES JobGrades (GradeID) ON UPDATE NO ACTION
                                   ON DELETE NO ACTION,
    FOREIGN KEY (
        FromPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE NO ACTION
                                      ON DELETE NO ACTION,
    FOREIGN KEY (
        FromStationID
    )
    REFERENCES Stations (StationID) ON UPDATE NO ACTION
                                    ON DELETE NO ACTION,
    FOREIGN KEY (
        ToDepartmentID
    )
    REFERENCES Departments (DepartmentID) ON UPDATE NO ACTION
                                          ON DELETE NO ACTION,
    FOREIGN KEY (
        ToGradeID
    )
    REFERENCES JobGrades (GradeID) ON UPDATE NO ACTION
                                   ON DELETE NO ACTION,
    FOREIGN KEY (
        ToPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE NO ACTION
                                      ON DELETE NO ACTION,
    FOREIGN KEY (
        ToStationID
    )
    REFERENCES Stations (StationID) ON UPDATE NO ACTION
                                    ON DELETE NO ACTION,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION
)
STRICT;


-- Table: PositionRequirements
DROP TABLE IF EXISTS PositionRequirements;

CREATE TABLE IF NOT EXISTS PositionRequirements (
    RequirementID   INTEGER PRIMARY KEY,
    PositionID      INTEGER NOT NULL,
    RequirementType TEXT    NOT NULL,
    RequirementName TEXT    NOT NULL,
    Description     TEXT    NULL,
    IsMandatory     TEXT    NOT NULL
                            DEFAULT '1',
    CreatedAt       TEXT    NULL
                            DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt       TEXT    NULL
                            DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        PositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE CASCADE,
    FOREIGN KEY (
        PositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE NO ACTION
                                      ON DELETE NO ACTION
)
STRICT;


-- Table: Positions
DROP TABLE IF EXISTS Positions;

CREATE TABLE IF NOT EXISTS Positions (
    PositionID          INTEGER PRIMARY KEY,
    PositionCode        TEXT    NOT NULL,
    PositionTitle       TEXT    NOT NULL,
    DepartmentID        INTEGER NOT NULL,
    GradeID             INTEGER NOT NULL,
    ReportsToPositionID INTEGER NULL,
    MinExperience       TEXT    NULL,
    MinEducation        TEXT    NULL,
    PositionDescription TEXT    NULL,
    Responsibilities    TEXT    NULL,
    Qualifications      TEXT    NULL,
    Skills              TEXT    NULL,
    IsManagement        TEXT    NOT NULL
                                DEFAULT '0',
    HeadcountLimit      TEXT    NULL,
    CurrentHeadcount    TEXT    NOT NULL
                                DEFAULT '0',
    IsApprover          TEXT    NOT NULL
                                DEFAULT '0',
    ApprovalLevel       TEXT    NULL,
    IsActive            TEXT    NOT NULL
                                DEFAULT '1',
    CreatedAt           TEXT    NULL
                                DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt           TEXT    NULL
                                DEFAULT 'CURRENT_TIMESTAMP',
    CreatedBy           TEXT    NULL,
    UpdatedBy           TEXT    NULL,
    FOREIGN KEY (
        DepartmentID
    )
    REFERENCES Departments (DepartmentID) ON UPDATE CASCADE
                                          ON DELETE RESTRICT,
    FOREIGN KEY (
        GradeID
    )
    REFERENCES JobGrades (GradeID) ON UPDATE CASCADE
                                   ON DELETE RESTRICT,
    FOREIGN KEY (
        ReportsToPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE SET NULL
)
STRICT;

INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (101, 'POS-101', 'Operations Manager', 101, 101, NULL, '36', 'Bachelor', 'Oversees all operational activities across stations', NULL, NULL, NULL, '1', '1', '2', '1', '3', '1', '2025-05-07 16:58:37', '2025-05-07 16:58:37', '100', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (102, 'POS-102', 'Maintenance Supervisor', 102, 102, 101, '24', 'Diploma', 'Supervises maintenance team and ensures equipment reliability', NULL, NULL, NULL, '1', '3', '2', '1', '2', '1', '2025-05-07 16:58:37', '2025-05-07 16:58:37', '100', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (401, 'CEO', 'Chief Executive Officer', 301, 201, NULL, '120', 'Master', 'Overall responsibility for the entire organisation; reports to Board', NULL, NULL, NULL, '1', '1', '2', '1', '10', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (402, 'COO', 'Chief Operations Officer', 302, 201, 401, '96', 'Master', 'Responsible for all operational aspects of the business', NULL, NULL, NULL, '1', '1', '2', '1', '9', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (403, 'CFO', 'Chief Financial Officer', 303, 201, 401, '96', 'Master', 'Responsible for all financial aspects of the business', NULL, NULL, NULL, '1', '1', '2', '1', '9', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (404, 'RGM-CEN', 'Regional Manager – Central', 306, 204, 402, '72', 'Bachelor', 'Oversees all stations in the Central region', NULL, NULL, NULL, '1', '1', '2', '1', '8', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (405, 'RGM-EST', 'Regional Manager – Eastern', 307, 204, 402, '72', 'Bachelor', 'Oversees all stations in the Eastern region', NULL, NULL, NULL, '1', '1', '2', '1', '8', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (406, 'RGM-WST', 'Regional Manager – Western', 308, 204, 402, '72', 'Bachelor', 'Oversees all stations in the Western region', NULL, NULL, NULL, '1', '1', '2', '1', '8', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (407, 'STM-KLA', 'Station Manager – Kampala', 306, 205, 404, '60', 'Bachelor', 'Manages Kampala station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2704', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (408, 'STM-ENT', 'Station Manager – Entebbe Road', 306, 205, 404, '60', 'Bachelor', 'Manages Entebbe Road station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2704', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (409, 'STM-JIN', 'Station Manager – Jinja', 307, 205, 405, '60', 'Bachelor', 'Manages Jinja station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2705', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (410, 'STM-MBA', 'Station Manager – Mbarara', 308, 205, 406, '60', 'Bachelor', 'Manages Mbarara station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2706', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (411, 'SFT-KLA', 'Shift Supervisor – Kampala', 306, 208, 407, '36', 'Diploma', 'Supervises shift operations at Kampala station', NULL, NULL, NULL, '1', '3', '2', '1', '6', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (412, 'SFT-ENT', 'Shift Supervisor – Entebbe Road', 306, 208, 408, '36', 'Diploma', 'Supervises shift operations at Entebbe Road station', NULL, NULL, NULL, '1', '3', '2', '1', '6', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2708', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (413, 'SFT-JIN', 'Shift Supervisor – Jinja', 307, 208, 409, '36', 'Diploma', 'Supervises shift operations at Jinja station', NULL, NULL, NULL, '1', '3', '2', '1', '6', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2709', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (414, 'CSR-SNR', 'Senior Cashier', 309, 216, 411, '24', 'Diploma', 'Handles cash transactions and supervises junior cashiers', NULL, NULL, NULL, '0', '5', '2', '0', '0', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (415, 'CSR-JNR', 'Cashier', 309, 217, 414, '12', 'Secondary', 'Handles cash transactions and customer payments', NULL, NULL, NULL, '0', '10', '4', '0', '0', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (416, 'ATT-SNR', 'Senior Fuel Attendant', 309, 216, 411, '24', 'Secondary', 'Dispenses fuel and supervises junior attendants', NULL, NULL, NULL, '0', '5', '2', '0', '0', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (417, 'ATT-JNR', 'Fuel Attendant', 309, 217, 416, '6', 'Secondary', 'Dispenses fuel and provides customer service', NULL, NULL, NULL, '0', '20', '6', '0', '0', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (418, 'MNT-ENG', 'Maintenance Engineer', 310, 210, 402, '60', 'Bachelor', 'Oversees maintenance of all equipment across stations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (419, 'MNT-TEC', 'Maintenance Technician', 310, 211, 418, '36', 'Diploma', 'Performs maintenance and repairs on station equipment', NULL, NULL, NULL, '0', '5', '4', '0', '0', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2721', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (420, 'HSE-MGR', 'HSE Manager', 305, 204, 401, '72', 'Bachelor', 'Oversees health, safety and environmental compliance', NULL, NULL, NULL, '1', '1', '2', '1', '8', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (421, 'HSE-OFF', 'HSE Officer', 305, 210, 420, '48', 'Bachelor', 'Ensures HSE compliance at stations', NULL, NULL, NULL, '0', '3', '4', '1', '5', '1', '2025-05-07 18:17:31', '2025-05-07 21:00:15', '2724', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (422, 'STM-ENTT', 'Station Manager – Entebbe Town', 306, 205, 404, '60', 'Bachelor', 'Manages Entebbe Town station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2704', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (423, 'STM-MBL', 'Station Manager – Mbale', 307, 205, 405, '60', 'Bachelor', 'Manages Mbale station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2705', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (424, 'STM-FPT', 'Station Manager – Fort Portal', 308, 205, 406, '60', 'Bachelor', 'Manages Fort Portal station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2706', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (425, 'STM-MSK', 'Station Manager – Masaka', 308, 205, 406, '60', 'Bachelor', 'Manages Masaka station operations', NULL, NULL, NULL, '1', '1', '2', '1', '7', '1', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2706', NULL);
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (140288, '63663636', 'hshhsshjjss', 307, 30, 403, '43', 'Certificate', 'ddffff', 'dfff  sdhdhjhd sdhjdhdh  ddd  dddd', 'dfff  sdhdhjhd sdhjdhdh  ddd  dddd', 'dfff  sdhdhjhd sdhjdhdh  ddd  dddd', '1', '1', '0', '1', '1', '1', '2025-05-07 19:57:57', '2025-05-07 19:57:57', '5', '5');
INSERT INTO Positions (PositionID, PositionCode, PositionTitle, DepartmentID, GradeID, ReportsToPositionID, MinExperience, MinEducation, PositionDescription, Responsibilities, Qualifications, Skills, IsManagement, HeadcountLimit, CurrentHeadcount, IsApprover, ApprovalLevel, IsActive, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (140289, '3563563355633365335', 'mr65656', 313, 30, 420, '222', NULL, '2222', '3563563355633365335', '3563563355633365335', '3563563355633365335', '0', '22', '2', '0', '22', '0', '2025-05-07 20:02:07', '2025-05-13 22:39:59', '5', '5');

-- Table: Products
DROP TABLE IF EXISTS Products;

CREATE TABLE IF NOT EXISTS Products (
    ProductID    INTEGER PRIMARY KEY,
    ProductType  TEXT    NOT NULL,
    Name         TEXT    NOT NULL,
    Description  TEXT    NULL,
    UnitPrice    TEXT    NOT NULL,
    SellingPrice TEXT    NULL,
    TaxRate      TEXT    NULL
                         DEFAULT '0.00',
    ReorderLevel TEXT    NULL,
    Status       TEXT    NULL
                         DEFAULT 'Active',
    CreatedAt    TEXT    NULL
                         DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt    TEXT    NULL
                         DEFAULT 'CURRENT_TIMESTAMP'
)
STRICT;

INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (6, 'Fuel', 'Ayebare Timothy', '233', '3232', NULL, '2', '22.98', 'Active', '2025-04-30 16:19:57', '2025-04-30 16:19:57');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (7, 'Fuel', 'Vpower', NULL, '5000', NULL, '4', '50000', 'Active', '2025-05-01 15:09:58', '2025-05-01 15:09:58');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (601, 'Fuel', 'Petrol', 'Regular unleaded petrol', '4500', NULL, '18', '5000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (602, 'Fuel', 'Premium Petrol', 'High-octane premium unleaded petrol', '4800', NULL, '18', '3000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (603, 'Fuel', 'Diesel', 'Regular diesel fuel', '4200', NULL, '18', '5000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (604, 'Fuel', 'Premium Diesel', 'Low-sulfur premium diesel', '4500', NULL, '18', '3000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (605, 'Fuel', 'Kerosene', 'Kerosene for lighting and cooking', '3800', NULL, '18', '2000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (606, 'Lubricant', 'Engine Oil 5W-30', 'Synthetic engine oil for passenger vehicles', '35000', NULL, '18', '100', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (607, 'Lubricant', 'Engine Oil 10W-40', 'Semi-synthetic engine oil for commercial vehicles', '30000', NULL, '18', '100', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (608, 'Lubricant', 'Transmission Fluid', 'Automatic transmission fluid', '28000', NULL, '18', '50', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (609, 'Lubricant', 'Brake Fluid', 'DOT 4 brake fluid', '15000', NULL, '18', '50', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (610, 'Lubricant', 'Coolant', 'Engine coolant and antifreeze', '12000', NULL, '18', '50', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (611, 'Gas', 'LPG 6kg', 'Liquefied petroleum gas 6kg cylinder', '60000', NULL, '18', '20', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (612, 'Gas', 'LPG 13kg', 'Liquefied petroleum gas 13kg cylinder', '120000', NULL, '18', '15', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (613, 'Gas', 'LPG 45kg', 'Liquefied petroleum gas 45kg cylinder', '380000', NULL, '18', '10', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (614, 'Other', 'Car Wash', 'Full car wash service', '15000', NULL, '18', NULL, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (615, 'Other', 'Tire Inflation', 'Tire inflation service', '2000', NULL, '18', NULL, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Products (ProductID, ProductType, Name, Description, UnitPrice, SellingPrice, TaxRate, ReorderLevel, Status, CreatedAt, UpdatedAt) VALUES (616, 'Other', 'Battery Water', 'Distilled water for batteries', '5000', NULL, '18', '20', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');

-- Table: PromotionRequests
DROP TABLE IF EXISTS PromotionRequests;

CREATE TABLE IF NOT EXISTS PromotionRequests (
    RequestID                INTEGER PRIMARY KEY,
    UserID                   INTEGER NOT NULL,
    CurrentPositionID        INTEGER NOT NULL,
    RequestedPositionID      INTEGER NOT NULL,
    RequestDate              TEXT    NOT NULL,
    RequestReason            TEXT    NOT NULL,
    SupportingDocumentPath   TEXT    NULL,
    SupervisorUserID         INTEGER NULL,
    SupervisorRecommendation TEXT    NULL
                                     DEFAULT 'Pending',
    SupervisorComments       TEXT    NULL,
    SupervisorReviewDate     TEXT    NULL,
    HRUserID                 INTEGER NULL,
    HRRecommendation         TEXT    NULL
                                     DEFAULT 'Pending',
    HRComments               TEXT    NULL,
    HRReviewDate             TEXT    NULL,
    FinalApproverUserID      INTEGER NULL,
    FinalDecision            TEXT    NULL
                                     DEFAULT 'Pending',
    FinalComments            TEXT    NULL,
    FinalDecisionDate        TEXT    NULL,
    EffectiveDate            TEXT    NULL,
    Status                   TEXT    NOT NULL
                                     DEFAULT 'Draft',
    CreatedAt                TEXT    NULL
                                     DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt                TEXT    NULL
                                     DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE,
    FOREIGN KEY (
        CurrentPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    FOREIGN KEY (
        RequestedPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    FOREIGN KEY (
        SupervisorUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        HRUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        FinalApproverUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        CurrentPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE NO ACTION
                                      ON DELETE NO ACTION,
    FOREIGN KEY (
        FinalApproverUserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        HRUserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        RequestedPositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE NO ACTION
                                      ON DELETE NO ACTION,
    FOREIGN KEY (
        SupervisorUserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE NO ACTION
                          ON DELETE NO ACTION
)
STRICT;


-- Table: Pumps
DROP TABLE IF EXISTS Pumps;

CREATE TABLE IF NOT EXISTS Pumps (
    PumpID       INTEGER PRIMARY KEY,
    StationID    INTEGER NOT NULL,
    TankID       INTEGER NOT NULL,
    PumpName     TEXT    NOT NULL,
    MeterReading TEXT    NOT NULL
                         DEFAULT '0.00',
    Status       TEXT    NULL
                         DEFAULT 'Active',
    CreatedAt    TEXT    NULL
                         DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt    TEXT    NULL
                         DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        TankID
    )
    REFERENCES Tanks (TankID) ON UPDATE CASCADE
                              ON DELETE RESTRICT
)
STRICT;

INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (801, 501, 701, 'Petrol Pump 1', '125678.45', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (802, 501, 701, 'Petrol Pump 2', '98765.32', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (803, 501, 702, 'Premium Petrol Pump', '45678.9', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (804, 501, 703, 'Diesel Pump 1', '156789.23', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (805, 501, 703, 'Diesel Pump 2', '134567.87', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (806, 501, 704, 'Premium Diesel Pump', '34576.89', 'Active', '2025-05-07 18:17:31', '2025-06-24T15:27:06.031Z');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (807, 501, 705, 'Kerosene Pump', '23456.78', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (808, 502, 706, 'Petrol Pump 1', '87654.32', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (809, 502, 706, 'Petrol Pump 2', '76543.21', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (810, 502, 707, 'Diesel Pump 1', '98765.43', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (811, 502, 707, 'Diesel Pump 2', '87654.32', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (812, 502, 708, 'Kerosene Pump', '12345.67', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (813, 505, 709, 'Petrol Pump 1', '65432.1', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (814, 505, 709, 'Petrol Pump 2', '54321.09', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (815, 505, 710, 'Diesel Pump 1', '76543.21', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (816, 505, 710, 'Diesel Pump 2', '65432.1', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (817, 505, 711, 'Kerosene Pump', '9876.54', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (818, 507, 712, 'Petrol Pump 1', '54411.09', 'Active', '2025-05-07 18:17:31', '2025-06-24T01:13:48.030Z');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (819, 507, 712, 'Petrol Pump 2', '43216.98', 'Active', '2025-05-07 18:17:31', '2025-06-24T15:11:23.974Z');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (820, 507, 713, 'Diesel Pump 1', '65432.1', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (821, 507, 713, 'Diesel Pump 2', '64276.09', 'Active', '2025-05-07 18:17:31', '2025-06-24T00:52:37.285Z');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (822, 507, 714, 'Kerosene Pump', '8765.43', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (823, 510, 716, '45454545 -', '4445445945.00', 'Active', '2025-06-24 16:12:48', '2025-06-24T18:45:58.717Z');
INSERT INTO Pumps (PumpID, StationID, TankID, PumpName, MeterReading, Status, CreatedAt, UpdatedAt) VALUES (824, 510, 715, '56FGFG', '5445487.00', 'Active', '2025-06-24 16:13:00', '2025-06-24T18:59:21.429Z');

-- Table: RolePermissions
DROP TABLE IF EXISTS RolePermissions;

CREATE TABLE IF NOT EXISTS RolePermissions (
    RoleID       INTEGER PRIMARY KEY,
    PermissionID INTEGER NOT NULL,
    CreatedAt    TEXT    NULL
                         DEFAULT CURRENT_TIMESTAMP,
    CreatedBy    TEXT    NULL,
    FOREIGN KEY (
        RoleID
    )
    REFERENCES Roles (RoleID) ON UPDATE CASCADE
                              ON DELETE CASCADE,
    FOREIGN KEY (
        PermissionID
    )
    REFERENCES Permissions (PermissionID) ON UPDATE CASCADE
                                          ON DELETE CASCADE
)
STRICT;


-- Table: Roles
DROP TABLE IF EXISTS Roles;

CREATE TABLE IF NOT EXISTS Roles (
    RoleID      INTEGER PRIMARY KEY,
    RoleName    TEXT    NOT NULL,
    Description TEXT    NULL,
    IsSystem    TEXT    NOT NULL
                        DEFAULT '0',
    CreatedAt   TEXT    NULL
                        DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt   TEXT    NULL
                        DEFAULT 'CURRENT_TIMESTAMP',
    CreatedBy   TEXT    NULL
)
STRICT;

INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (1, 'System Administrator', 'Full system access with ability to manage all aspects of the system including users, roles, and configurations', '1', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (2, 'General Manager', 'Overall management of the entire fuel station network with access to all reports and dashboards', '1', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (3, 'Operations Manager', 'Manages day-to-day operations across all stations, including staff scheduling and operational issues', '0', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (4, 'Finance Manager', 'Oversees all financial aspects including sales, expenses, payroll, and financial reporting', '0', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (5, 'Station Manager', 'Manages a specific station including staff, inventory, and local operations', '0', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (6, 'Assistant Station Manager', 'Assists the station manager in daily operations and can act in their absence', '0', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (7, 'Shift Supervisor', 'Oversees operations during a specific shift, manages cashiers and attendants', '0', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (8, 'Fuel Attendant', 'Operates fuel pumps, assists customers with fueling, and basic customer service', '0', '2025-05-07 20:58:56', '2025-05-07 20:58:56', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (9, 'Cashier', 'Handles payments, operates POS system, and basic customer service', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (10, 'Customer Service Representative', 'Handles customer inquiries, complaints, and loyalty programs', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (11, 'Inventory Manager', 'Manages fuel and non-fuel inventory, orders, and stock levels', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (12, 'Maintenance Technician', 'Handles equipment maintenance, repairs, and facility upkeep', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (13, 'Quality Control Officer', 'Ensures fuel quality standards and compliance with regulations', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (14, 'Safety Officer', 'Oversees safety protocols, training, and emergency procedures', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (15, 'HR Manager', 'Manages human resources including hiring, training, and employee relations', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (16, 'Accountant', 'Handles bookkeeping, financial records, and tax compliance', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (17, 'Procurement Officer', 'Manages purchasing, vendor relationships, and supply chain', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (18, 'Marketing Coordinator', 'Handles promotions, advertising, and customer engagement strategies', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (19, 'IT Support', 'Provides technical support for systems, hardware, and software', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (20, 'Compliance Officer', 'Ensures adherence to regulatory requirements and industry standards', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (21, 'Internal Auditor', 'Conducts internal audits of operations, finances, and compliance', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (22, 'Environmental Compliance Officer', 'Monitors and ensures compliance with environmental regulations', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (23, 'Store Manager', 'Manages the convenience store operations, inventory, and staff', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (24, 'Store Clerk', 'Handles store sales, stocking, and customer service', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (25, 'Report Viewer', 'Read-only access to reports and dashboards', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);
INSERT INTO Roles (RoleID, RoleName, Description, IsSystem, CreatedAt, UpdatedAt, CreatedBy) VALUES (26, 'Auditor', 'External auditor with read-only access to financial and operational data', '0', '2025-05-07 20:58:57', '2025-05-07 20:58:57', NULL);

-- Table: StationInventory
DROP TABLE IF EXISTS StationInventory;

CREATE TABLE IF NOT EXISTS StationInventory (
    InventoryID  INTEGER PRIMARY KEY,
    StationID    INTEGER NOT NULL,
    ProductID    INTEGER NOT NULL,
    CurrentStock TEXT    NULL
                         DEFAULT '0.00',
    LastUpdated  TEXT    NULL
                         DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        ProductID
    )
    REFERENCES Products (ProductID) ON UPDATE CASCADE
                                    ON DELETE RESTRICT
)
STRICT;

INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (6, 503, 610, '999', '2025-05-10 23:21:52');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (7, 508, 614, '99', '2025-05-10 23:25:39');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (8, 505, 606, '3', '2025-05-10 23:35:30');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (9, 504, 610, '3', '2025-05-10 23:38:41');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (10, 505, 612, '8', '2025-05-10 23:39:27');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (11, 505, 603, '8', '2025-05-10 23:43:06');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (12, 501, 606, '0.00', '2025-06-24T15:27:06.048Z');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (13, 510, 616, '0', '2025-06-24T16:08:08.439Z');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (14, 510, 607, '0', '2025-06-24T16:08:30.179Z');
INSERT INTO StationInventory (InventoryID, StationID, ProductID, CurrentStock, LastUpdated) VALUES (15, 510, 613, '0.00', '2025-06-24T18:59:21.449Z');

-- Table: Stations
DROP TABLE IF EXISTS Stations;

CREATE TABLE IF NOT EXISTS Stations (
    StationID     INTEGER PRIMARY KEY,
    StationName   TEXT    NOT NULL,
    Location      TEXT    NOT NULL,
    ContactPhone  TEXT    NOT NULL,
    ManagerUserID INTEGER NULL,
    OpeningDate   TEXT    NOT NULL,
    Status        TEXT    NULL
                          DEFAULT 'Active',
    CreatedAt     TEXT    NULL
                          DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt     TEXT    NULL
                          DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        ManagerUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;

INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (4, 'Shell Ntugamo', 'Ntungamo', '256256565', 4, '2024-08-14', 'Active', '2025-05-01 17:55:16', '2025-05-01 17:55:16');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (101, 'Kigrama Central', 'Kampala Central', '+256700123456', 100, '2025-05-07', 'Active', '2025-05-07 16:58:37', '2025-05-07 16:58:37');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (501, 'Kigrama Kampala Central', 'Plot 123, Kampala Road, Kampala', '+256700555001', 2707, '2019-01-15', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (502, 'Kigrama Entebbe Road', 'Plot 45, Entebbe Road, Kampala', '+256700555002', 2708, '2019-03-20', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (503, 'Kigrama Entebbe Town', 'Plot 78, Main Street, Entebbe', '+256700555003', 2708, '2019-05-25', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (504, 'Kigrama Jinja Road', 'Plot 112, Jinja Road, Kampala', '+256700555004', 2709, '2019-07-10', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (505, 'Kigrama Jinja Town', 'Plot 34, Main Street, Jinja', '+256700555005', 2709, '2019-09-15', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (506, 'Kigrama Moroto', 'Plot 12, Moroto Road, Moroto', '+256700555010', 2709, '2019-10-01', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (507, 'Kigrama Mbarara', 'Plot 89, High Street, Mbarara', '+256700555007', 2710, '2020-01-25', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (508, 'Kigrama Fort Portal', 'Plot 23, Kasese Road, Fort Portal', '+256700555008', 2710, '2020-03-30', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (509, 'Kigrama Masaka', 'Plot 67, Kampala Road, Masaka', '+256700555009', 2710, '2020-06-05', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (510, 'Kigrama Mbale', 'Plot 56, Cathedral Avenue, Mbale', '+256700555006', 2709, '2019-11-20', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Stations (StationID, StationName, Location, ContactPhone, ManagerUserID, OpeningDate, Status, CreatedAt, UpdatedAt) VALUES (511, 'Shell Ntugamo3', 'Shell Ntugamo4', '545455544', 2713, '2025-05-11', 'Active', '2025-05-10 17:06:38', '2025-05-10 17:06:38');

-- Table: StationTransfers
DROP TABLE IF EXISTS StationTransfers;

CREATE TABLE IF NOT EXISTS StationTransfers (
    TransferID           INTEGER PRIMARY KEY,
    SourceStationID      INTEGER NOT NULL,
    DestinationStationID INTEGER NOT NULL,
    TransferDate         TEXT    NOT NULL
                                 DEFAULT CURRENT_TIMESTAMP,
    Status               TEXT    NULL
                                 DEFAULT 'Initiated',
    InitiatedBy          TEXT    NOT NULL,
    ApprovedBy           TEXT    NULL,
    ReceivedBy           TEXT    NULL,
    Notes                TEXT    NULL,
    CreatedAt            TEXT    NULL
                                 DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt            TEXT    NULL
                                 DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        SourceStationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        DestinationStationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        InitiatedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE RESTRICT,
    FOREIGN KEY (
        ApprovedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        ReceivedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;


-- Table: SuccessionPlans
DROP TABLE IF EXISTS SuccessionPlans;

CREATE TABLE IF NOT EXISTS SuccessionPlans (
    PlanID          INTEGER PRIMARY KEY,
    PositionID      INTEGER NOT NULL,
    CurrentUserID   INTEGER NULL,
    SuccessorUserID INTEGER NOT NULL,
    ReadinessLevel  TEXT    NOT NULL,
    DevelopmentPlan TEXT    NULL,
    Notes           TEXT    NULL,
    IsActive        TEXT    NOT NULL
                            DEFAULT '1',
    CreatedAt       TEXT    NULL
                            DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt       TEXT    NULL
                            DEFAULT 'CURRENT_TIMESTAMP',
    CreatedBy       TEXT    NULL,
    UpdatedBy       TEXT    NULL,
    FOREIGN KEY (
        PositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE CASCADE,
    FOREIGN KEY (
        CurrentUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL,
    FOREIGN KEY (
        SuccessorUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE
)
STRICT;


-- Table: SupplierCreditAccounts
DROP TABLE IF EXISTS SupplierCreditAccounts;

CREATE TABLE IF NOT EXISTS SupplierCreditAccounts (
    CreditAccountID   INTEGER PRIMARY KEY,
    SupplierID        INTEGER UNIQUE
                              NOT NULL
                              REFERENCES Suppliers (SupplierID),
    StationID         INTEGER UNIQUE
                              NULL
                              REFERENCES Stations (StationID),-- NULL = Global account
    CreditLimit       TEXT    NOT NULL
                              DEFAULT 0,
    CurrentBalance    TEXT    NOT NULL
                              DEFAULT 0,-- What we owe them
    AvailableCredit   TEXT    NOT NULL
                              DEFAULT 0,-- CreditLimit - CurrentBalance
    PaymentTermsDays  INTEGER NOT NULL
                              DEFAULT 30,
    LastPaymentDate   TEXT    NULL,
    LastPaymentAmount TEXT    DEFAULT 0,
    IsActive          TEXT    DEFAULT '1',
    CreatedAt         TEXT    DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt         TEXT    DEFAULT CURRENT_TIMESTAMP
)
STRICT;


-- Table: SupplierCreditTransactions
DROP TABLE IF EXISTS SupplierCreditTransactions;

CREATE TABLE IF NOT EXISTS SupplierCreditTransactions (
    TransactionID   INTEGER PRIMARY KEY,
    SupplierID      INTEGER NOT NULL
                            REFERENCES Suppliers (SupplierID),
    StationID       INTEGER NULL
                            REFERENCES Stations (StationID),
    TransactionType TEXT    NOT NULL,-- Invoice, Payment, Credit_Adjustment, Limit_Change
    ReferenceID     INTEGER NULL,-- InvoiceID or PaymentID
    Amount          TEXT    NOT NULL,
    PreviousBalance TEXT    NOT NULL,
    NewBalance      TEXT    NOT NULL,
    Description     TEXT,
    CreatedBy       INTEGER NOT NULL,
    CreatedAt       TEXT    DEFAULT CURRENT_TIMESTAMP
)
STRICT;


-- Table: SupplierInvoices
DROP TABLE IF EXISTS SupplierInvoices;

CREATE TABLE IF NOT EXISTS SupplierInvoices (
    InvoiceID         INTEGER PRIMARY KEY,
    SupplierID        INTEGER NOT NULL
                              REFERENCES Suppliers (SupplierID),
    StationID         INTEGER NOT NULL
                              REFERENCES Stations (StationID),
    InvoiceNumber     TEXT    NOT NULL,
    InvoiceDate       TEXT    NOT NULL,
    DueDate           TEXT    NOT NULL,
    TotalAmount       TEXT    NOT NULL,
    PaidAmount        TEXT    DEFAULT 0,
    OutstandingAmount TEXT    NOT NULL,-- TotalAmount - PaidAmount
    Status            TEXT    DEFAULT 'Outstanding',-- Outstanding, Paid, Overdue, Disputed
    Description       TEXT,
    ReceivedBy        INTEGER NOT NULL
                              REFERENCES users (id),
    CreatedAt         TEXT    DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt         TEXT    DEFAULT CURRENT_TIMESTAMP
)
STRICT;


-- Table: SupplierPaymentAllocations
DROP TABLE IF EXISTS SupplierPaymentAllocations;

CREATE TABLE IF NOT EXISTS SupplierPaymentAllocations (
    AllocationID    INTEGER PRIMARY KEY,
    PaymentID       INTEGER NOT NULL
                            REFERENCES SupplierPayments (PaymentID),
    InvoiceID       INTEGER NOT NULL
                            REFERENCES SupplierInvoices (InvoiceID),
    AllocatedAmount TEXT    NOT NULL,
    AllocationDate  TEXT    NOT NULL
                            DEFAULT CURRENT_DATE,
    CreatedAt       TEXT    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        PaymentID
    )
    REFERENCES SupplierPayments (PaymentID) ON DELETE CASCADE,
    FOREIGN KEY (
        InvoiceID
    )
    REFERENCES SupplierInvoices (InvoiceID) ON DELETE CASCADE
)
STRICT;


-- Table: SupplierPayments
DROP TABLE IF EXISTS SupplierPayments;

CREATE TABLE IF NOT EXISTS SupplierPayments (
    PaymentID        INTEGER PRIMARY KEY,
    SupplierID       INTEGER NOT NULL
                             REFERENCES Suppliers (SupplierID),
    StationID        INTEGER NULL
                             REFERENCES Stations (StationID),
    PaymentReference TEXT    NOT NULL
                             UNIQUE,
    PaymentDate      TEXT    NOT NULL,
    PaymentAmount    TEXT    NOT NULL,
    PaymentMethod    TEXT    NOT NULL,-- Bank Transfer, Check, Cash, Mobile Money
    BankReference    TEXT,
    Notes            TEXT,
    ProcessedBy      INTEGER NOT NULL
                             REFERENCES users (id),
    Status           TEXT    DEFAULT 'Completed',-- Pending, Completed, Failed, Cancelled
    CreatedAt        TEXT    DEFAULT CURRENT_TIMESTAMP
)
STRICT;

INSERT INTO SupplierPayments (PaymentID, SupplierID, StationID, PaymentReference, PaymentDate, PaymentAmount, PaymentMethod, BankReference, Notes, ProcessedBy, Status, CreatedAt) VALUES (1, 2, 507, 'SPP-1750618010042-U4782876-GGLMADMDWP-10450380', '2025-06-22', '3265763', 'Check', '2652562', '326635353  Aywba a hshs  ahahaa  ajaa', 4782876, 'Completed', '2025-06-22 18:47:22');

-- Table: Suppliers
DROP TABLE IF EXISTS Suppliers;

CREATE TABLE IF NOT EXISTS Suppliers (
    SupplierID              INTEGER PRIMARY KEY,
    Name                    TEXT    NOT NULL,
    ContactPerson           TEXT    NULL,
    Email                   TEXT    NULL,
    Phone                   TEXT    NOT NULL,
    Address                 TEXT    NULL,
    TaxIdentificationNumber TEXT    NULL,
    IsGlobal                TEXT    NULL
                                    DEFAULT '0',
    Status                  TEXT    NULL
                                    DEFAULT 'Active',
    CreatedAt               TEXT    NULL
                                    DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt               TEXT    NULL
                                    DEFAULT 'CURRENT_TIMESTAMP'
)
STRICT;

INSERT INTO Suppliers (SupplierID, Name, ContactPerson, Email, Phone, Address, TaxIdentificationNumber, IsGlobal, Status, CreatedAt, UpdatedAt) VALUES (1, 'Ayebare Timothy', 'Ayebare Timothy', 'vexa256@gmail.com', '0786190179', 'Kampala, Uganda', NULL, '0', 'Active', '2025-06-22 18:33:07', 'CURRENT_TIMESTAMP');
INSERT INTO Suppliers (SupplierID, Name, ContactPerson, Email, Phone, Address, TaxIdentificationNumber, IsGlobal, Status, CreatedAt, UpdatedAt) VALUES (2, 'ECSA HC', 'ECSA HC', 'cloud@ecsahc.org', '0742216821', 'Arusha', NULL, '0', 'Active', '2025-06-22 18:33:13', 'CURRENT_TIMESTAMP');
INSERT INTO Suppliers (SupplierID, Name, ContactPerson, Email, Phone, Address, TaxIdentificationNumber, IsGlobal, Status, CreatedAt, UpdatedAt) VALUES (3, 'shgshggh', 'hgshg', 'atimothy@ecsahc.org', '+255742216821', 'Njiro Opp , SDA Church Arusha', '', '1', '', '2025-06-22 18:45:46', 'CURRENT_TIMESTAMP');
INSERT INTO Suppliers (SupplierID, Name, ContactPerson, Email, Phone, Address, TaxIdentificationNumber, IsGlobal, Status, CreatedAt, UpdatedAt) VALUES (4, 'jh ahajah ahjajha  aaj', 'Ayebare Timothy', 'vexa256@gmail.com', '+256786190179', 'Kampala, Uganda', '3663263263', '0', 'Active', '2025-06-22 18:46:06', 'CURRENT_TIMESTAMP');

-- Table: SupplierStations
DROP TABLE IF EXISTS SupplierStations;

CREATE TABLE IF NOT EXISTS SupplierStations (
    SupplierID INTEGER PRIMARY KEY,
    StationID  INTEGER NOT NULL,
    FOREIGN KEY (
        SupplierID
    )
    REFERENCES Suppliers (SupplierID) ON UPDATE CASCADE
                                      ON DELETE CASCADE,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE
)
STRICT;

INSERT INTO SupplierStations (SupplierID, StationID) VALUES (1, 4);
INSERT INTO SupplierStations (SupplierID, StationID) VALUES (2, 4);
INSERT INTO SupplierStations (SupplierID, StationID) VALUES (4, 4);

-- Table: Tanks
DROP TABLE IF EXISTS Tanks;

CREATE TABLE IF NOT EXISTS Tanks (
    TankID         INTEGER PRIMARY KEY,
    StationID      INTEGER NOT NULL,
    ProductID      INTEGER NOT NULL,
    TankName       TEXT    NOT NULL,
    Capacity       TEXT    NOT NULL,
    CurrentLevel   TEXT    NOT NULL,
    Status         TEXT    NULL
                           DEFAULT 'Active',
    LastFilledDate TEXT    NULL,
    CreatedAt      TEXT    NULL
                           DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt      TEXT    NULL
                           DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        ProductID
    )
    REFERENCES Products (ProductID) ON UPDATE CASCADE
                                    ON DELETE RESTRICT
)
STRICT;

INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (701, 501, 601, 'Petrol Tank 1', '50000', '35000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-06-22T21:48:16.055Z');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (702, 501, 602, 'Premium Petrol Tank', '30000', '20000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (703, 501, 603, 'Diesel Tank 1', '50000', '40000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (704, 501, 604, 'Premium Diesel Tank', '30000', '24991.00', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-06-24T15:27:05.973Z');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (705, 501, 605, 'Kerosene Tank', '20000', '15000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (706, 502, 601, 'Petrol Tank 1', '40000', '30000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (707, 502, 603, 'Diesel Tank 1', '40000', '35000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (708, 502, 605, 'Kerosene Tank', '15000', '10000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (709, 505, 601, 'Petrol Tank 1', '40000', '25000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (710, 505, 603, 'Diesel Tank 1', '40000', '30000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (711, 505, 605, 'Kerosene Tank', '15000', '8000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (712, 507, 601, 'Petrol Tank 1', '40000', '27904.00', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-06-24T15:11:23.901Z');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (713, 507, 603, 'Diesel Tank 1', '40000', '22045.00', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-06-24T00:52:37.237Z');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (714, 507, 605, 'Kerosene Tank', '15000', '9000', 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2025-05-07 18:17:31');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (715, 510, 604, 'PETRO', '454445', '391.00', 'Active', '2025-06-24', '2025-06-24 16:11:19', '2025-06-24T18:59:21.414Z');
INSERT INTO Tanks (TankID, StationID, ProductID, TankName, Capacity, CurrentLevel, Status, LastFilledDate, CreatedAt, UpdatedAt) VALUES (716, 510, 604, 'DISEAL', '4333', '0.00', 'Active', '2025-06-24', '2025-06-24 16:11:46', '2025-06-24T18:45:58.652Z');

-- Table: TaxRecords
DROP TABLE IF EXISTS TaxRecords;

CREATE TABLE IF NOT EXISTS TaxRecords (
    TaxRecordID     INTEGER PRIMARY KEY,
    StationID       INTEGER NOT NULL,
    TaxPeriod       TEXT    NOT NULL,
    TaxType         TEXT    NOT NULL,
    TaxableAmount   TEXT    NOT NULL,
    TaxAmount       TEXT    NOT NULL,
    Status          TEXT    NULL
                            DEFAULT 'Pending',
    FilingDate      TEXT    NULL,
    PaymentDate     TEXT    NULL,
    ReferenceNumber TEXT    NULL,
    PreparedBy      TEXT    NOT NULL,
    ApprovedBy      TEXT    NULL,
    CreatedAt       TEXT    NULL
                            DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        PreparedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE RESTRICT,
    FOREIGN KEY (
        ApprovedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;


-- Table: TaxTypes
DROP TABLE IF EXISTS TaxTypes;

CREATE TABLE IF NOT EXISTS TaxTypes (
    TaxTypeID       INTEGER PRIMARY KEY,
    TaxCode         TEXT    NOT NULL,
    TaxName         TEXT    NOT NULL,
    TaxCategory     TEXT    NOT NULL,
    RateType        TEXT    NOT NULL,
    DefaultRate     TEXT    NOT NULL,
    RateUnit        TEXT    NULL,
    TaxAuthority    TEXT    NOT NULL
                            DEFAULT 'URA',
    Description     TEXT    NULL,
    FilingFrequency TEXT    NOT NULL,
    DueDays         TEXT    NULL,
    LegalReference  TEXT    NULL,
    EffectiveFrom   TEXT    NOT NULL,
    EffectiveTo     TEXT    NULL,
    IsActive        TEXT    NOT NULL
                            DEFAULT '1',
    CreatedAt       TEXT    NULL
                            DEFAULT 'CURRENT_TIMESTAMP',
    UpdatedAt       TEXT    NULL
                            DEFAULT 'CURRENT_TIMESTAMP'
)
STRICT;

INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (1, 'VAT-STD', 'Value Added Tax - Standard Rate', 'VAT', 'Percentage', '18', NULL, 'URA', 'Standard VAT rate applicable to most goods and services in Uganda', 'Monthly', '15', 'VAT Act Cap 349', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (2, 'VAT-ZERO', 'Value Added Tax - Zero Rated', 'VAT', 'Percentage', '0', NULL, 'URA', 'Zero-rated VAT items as specified in the VAT Act', 'Monthly', '15', 'VAT Act Cap 349', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (3, 'VAT-EXEMPT', 'Value Added Tax - Exempt', 'VAT', 'Percentage', '0', NULL, 'URA', 'VAT exempt items as specified in the VAT Act', 'Monthly', '15', 'VAT Act Cap 349', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (4, 'CIT', 'Corporate Income Tax', 'Income', 'Percentage', '30', NULL, 'URA', 'Standard corporate income tax for resident companies', 'Annual', '180', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (5, 'CIT-PROV', 'Corporate Income Tax - Provisional', 'Income', 'Percentage', '30', NULL, 'URA', 'Quarterly provisional corporate income tax payments', 'Quarterly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (6, 'WHT-DIV-RES', 'Withholding Tax - Dividends (Resident)', 'Withholding', 'Percentage', '15', NULL, 'URA', 'Withholding tax on dividend payments to residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (7, 'WHT-DIV-NRES', 'Withholding Tax - Dividends (Non-Resident)', 'Withholding', 'Percentage', '15', NULL, 'URA', 'Withholding tax on dividend payments to non-residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (8, 'WHT-INT-RES', 'Withholding Tax - Interest (Resident)', 'Withholding', 'Percentage', '15', NULL, 'URA', 'Withholding tax on interest payments to residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (9, 'WHT-INT-NRES', 'Withholding Tax - Interest (Non-Resident)', 'Withholding', 'Percentage', '15', NULL, 'URA', 'Withholding tax on interest payments to non-residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (10, 'WHT-SERV-RES', 'Withholding Tax - Services (Resident)', 'Withholding', 'Percentage', '6', NULL, 'URA', 'Withholding tax on payments for services to residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (11, 'WHT-SERV-NRES', 'Withholding Tax - Services (Non-Resident)', 'Withholding', 'Percentage', '15', NULL, 'URA', 'Withholding tax on payments for services to non-residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (12, 'WHT-RENT-RES', 'Withholding Tax - Rent (Resident)', 'Withholding', 'Percentage', '10', NULL, 'URA', 'Withholding tax on rental payments to residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (13, 'WHT-RENT-NRES', 'Withholding Tax - Rent (Non-Resident)', 'Withholding', 'Percentage', '15', NULL, 'URA', 'Withholding tax on rental payments to non-residents', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (14, 'WHT-MGMT', 'Withholding Tax - Management Fees', 'Withholding', 'Percentage', '15', NULL, 'URA', 'Withholding tax on management fees', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (15, 'PAYE-TIER1', 'PAYE - First Tier (0-235,000 UGX)', 'PAYE', 'Percentage', '0', NULL, 'URA', 'Pay As You Earn tax on monthly income up to UGX 235,000', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (16, 'PAYE-TIER2', 'PAYE - Second Tier (235,001-335,000 UGX)', 'PAYE', 'Percentage', '10', NULL, 'URA', 'Pay As You Earn tax on monthly income from UGX 235,001 to UGX 335,000', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (17, 'PAYE-TIER3', 'PAYE - Third Tier (335,001-410,000 UGX)', 'PAYE', 'Percentage', '20', NULL, 'URA', 'Pay As You Earn tax on monthly income from UGX 335,001 to UGX 410,000', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (18, 'PAYE-TIER4', 'PAYE - Fourth Tier (Above 410,000 UGX)', 'PAYE', 'Percentage', '30', NULL, 'URA', 'Pay As You Earn tax on monthly income above UGX 410,000', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (19, 'PAYE-TIER5', 'PAYE - Fifth Tier (Above 10,000,000 UGX)', 'PAYE', 'Percentage', '10', NULL, 'URA', 'Additional Pay As You Earn tax on monthly income above UGX 10,000,000', 'Monthly', '15', 'Income Tax Act Cap 340', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (20, 'NSSF-EMP', 'NSSF - Employer Contribution', 'Other', 'Percentage', '10', NULL, 'URA', 'National Social Security Fund employer contribution', 'Monthly', '15', 'NSSF Act Cap 222', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (21, 'NSSF-EE', 'NSSF - Employee Contribution', 'Other', 'Percentage', '5', NULL, 'URA', 'National Social Security Fund employee contribution', 'Monthly', '15', 'NSSF Act Cap 222', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (22, 'EXC-PETROL', 'Excise Duty - Petrol', 'Excise', 'Fixed Amount', '1350', 'Per Liter', 'URA', 'Excise duty on petrol (UGX per liter)', 'Monthly', '15', 'Excise Duty Act 2014', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (23, 'EXC-DIESEL', 'Excise Duty - Diesel', 'Excise', 'Fixed Amount', '1030', 'Per Liter', 'URA', 'Excise duty on diesel (UGX per liter)', 'Monthly', '15', 'Excise Duty Act 2014', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (24, 'EXC-KEROSENE', 'Excise Duty - Kerosene', 'Excise', 'Fixed Amount', '200', 'Per Liter', 'URA', 'Excise duty on kerosene (UGX per liter)', 'Monthly', '15', 'Excise Duty Act 2014', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (25, 'LST-TIER1', 'Local Service Tax - Tier 1 (Below 100,000 UGX)', 'Local', 'Fixed Amount', '5000', 'Per Month', 'Local Government', 'Local service tax for monthly income below UGX 100,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (26, 'LST-TIER2', 'Local Service Tax - Tier 2 (100,000-200,000 UGX)', 'Local', 'Fixed Amount', '10000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 100,000 to UGX 200,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (27, 'LST-TIER3', 'Local Service Tax - Tier 3 (200,000-300,000 UGX)', 'Local', 'Fixed Amount', '20000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 200,000 to UGX 300,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (28, 'LST-TIER4', 'Local Service Tax - Tier 4 (300,000-400,000 UGX)', 'Local', 'Fixed Amount', '30000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 300,000 to UGX 400,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (29, 'LST-TIER5', 'Local Service Tax - Tier 5 (400,000-500,000 UGX)', 'Local', 'Fixed Amount', '40000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 400,000 to UGX 500,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (30, 'LST-TIER6', 'Local Service Tax - Tier 6 (500,000-600,000 UGX)', 'Local', 'Fixed Amount', '60000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 500,000 to UGX 600,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (31, 'LST-TIER7', 'Local Service Tax - Tier 7 (600,000-700,000 UGX)', 'Local', 'Fixed Amount', '70000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 600,000 to UGX 700,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (32, 'LST-TIER8', 'Local Service Tax - Tier 8 (700,000-800,000 UGX)', 'Local', 'Fixed Amount', '80000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 700,000 to UGX 800,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (33, 'LST-TIER9', 'Local Service Tax - Tier 9 (800,000-900,000 UGX)', 'Local', 'Fixed Amount', '90000', 'Per Month', 'Local Government', 'Local service tax for monthly income from UGX 800,000 to UGX 900,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (34, 'LST-TIER10', 'Local Service Tax - Tier 10 (Above 900,000 UGX)', 'Local', 'Fixed Amount', '100000', 'Per Month', 'Local Government', 'Local service tax for monthly income above UGX 900,000', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (35, 'PROP-TAX', 'Property Tax', 'Property', 'Percentage', '0', NULL, 'Local Government', 'Property tax on business premises (rates vary by location)', 'Annual', '90', 'Local Governments Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (36, 'STAMP-DUTY', 'Stamp Duty', 'Other', 'Percentage', '1.5', NULL, 'URA', 'Stamp duty on legal documents and agreements', 'Other', NULL, 'Stamps Act Cap 342', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (37, 'CUST-DUTY', 'Customs Duty', 'Customs', 'Percentage', '0', NULL, 'URA', 'Import duty on goods (rates vary by product category)', 'Other', NULL, 'East African Community Customs Management Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (38, 'INFRA-LEVY', 'Infrastructure Levy', 'Excise', 'Fixed Amount', '100', 'Per Liter', 'URA', 'Levy on fuel for infrastructure development', 'Monthly', '15', 'Finance Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');
INSERT INTO TaxTypes (TaxTypeID, TaxCode, TaxName, TaxCategory, RateType, DefaultRate, RateUnit, TaxAuthority, Description, FilingFrequency, DueDays, LegalReference, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, UpdatedAt) VALUES (39, 'ENV-LEVY', 'Environmental Levy', 'Other', 'Percentage', '0.5', NULL, 'URA', 'Environmental levy on specific products', 'Monthly', '15', 'Finance Act', '2023-07-01', NULL, '1', '2025-05-04 21:21:27', '2025-05-04 21:21:27');

-- Table: TransactionItems
DROP TABLE IF EXISTS TransactionItems;

CREATE TABLE IF NOT EXISTS TransactionItems (
    ItemID        INTEGER PRIMARY KEY,
    TransactionID INTEGER NULL,
    ProductID     INTEGER NULL,
    Quantity      TEXT    NULL,
    UnitPrice     TEXT    NULL,
    SellingPrice  TEXT    NULL,
    TaxRate       TEXT    NULL,
    Subtotal      TEXT    NULL,
    PumpID        INTEGER NULL,
    TankID        INTEGER NULL,
    CreatedAt     TEXT    DEFAULT CURRENT_TIMESTAMP
                          NULL,
    FOREIGN KEY (
        TransactionID
    )
    REFERENCES Transactions (TransactionID) ON DELETE CASCADE
                                            ON UPDATE CASCADE,
    FOREIGN KEY (
        ProductID
    )
    REFERENCES Products (ProductID) ON DELETE RESTRICT
                                    ON UPDATE CASCADE,
    FOREIGN KEY (
        PumpID
    )
    REFERENCES Pumps (PumpID) ON DELETE SET NULL
                              ON UPDATE CASCADE,
    FOREIGN KEY (
        TankID
    )
    REFERENCES Tanks (TankID) ON DELETE SET NULL
                              ON UPDATE CASCADE
)
STRICT;

INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (1, NULL, 612, '4', '120000.00', '120000.00', '18', '480000.00', NULL, NULL, '2025-06-24T00:13:25.605Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (2, NULL, 612, '1', '120000.00', '120000.00', '18', '120000.00', NULL, NULL, '2025-06-24T00:27:29.731Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (3, NULL, 603, '9955', '4200.00', '4200.00', '18', '41811000.00', 821, 713, '2025-06-24T00:52:37.179Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (4, NULL, 601, '90', '4500.00', '4500.00', '18', '405000.00', 818, 712, '2025-06-24T01:13:47.983Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (5, 12, 604, '4', '4500.00', '4500.00', '18', '18000.00', 806, 704, '2025-06-24T15:10:48.329Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (6, 13, 601, '6', '4500.00', '4500.00', '18', '27000.00', 819, 712, '2025-06-24T15:11:23.856Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (7, 14, 604, '5', '4500.00', '4500.00', '18', '22500.00', 806, 704, '2025-06-24T15:27:05.935Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (8, 17, 604, '500', '4500.00', '4500.00', '18', '2250000.00', 823, 716, '2025-06-24T18:45:58.597Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (9, 18, 604, '2', '4500.00', '4500.00', '18', '9000.00', 824, 715, '2025-06-24T18:59:21.330Z');
INSERT INTO TransactionItems (ItemID, TransactionID, ProductID, Quantity, UnitPrice, SellingPrice, TaxRate, Subtotal, PumpID, TankID, CreatedAt) VALUES (10, 18, 604, '42', '4500.00', '4500.00', '18', '189000.00', 824, 715, '2025-06-24T18:59:21.343Z');

-- Table: Transactions
DROP TABLE IF EXISTS Transactions;

CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID     INTEGER PRIMARY KEY,
    StationID         INTEGER NOT NULL,
    TransactionDate   TEXT    NOT NULL
                              DEFAULT CURRENT_TIMESTAMP,
    TransactionType   TEXT    NOT NULL,
    ReferenceParty    TEXT    NULL,
    TotalAmount       TEXT    NOT NULL,
    TaxAmount         TEXT    NOT NULL,
    PaymentMethod     TEXT    NOT NULL,
    PaymentReference  TEXT    NULL,
    PaymentStatus     TEXT    NULL
                              DEFAULT 'Paid',
    InvoiceNumber     TEXT    NULL,
    Status            TEXT    NULL
                              DEFAULT 'Completed',
    HandledBy         TEXT    NOT NULL,
    ApprovedBy        TEXT    NULL,
    Notes             TEXT    NULL,
    CreatedAt         TEXT    NULL
                              DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt         TEXT    NULL
                              DEFAULT 'CURRENT_TIMESTAMP',
    CustomerID        INTEGER NULL
                              REFERENCES Customers (CustomerID),
    IsCreditSale      TEXT    DEFAULT '0',
    OutstandingAmount TEXT    DEFAULT '0.00',
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        HandledBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE RESTRICT,
    FOREIGN KEY (
        ApprovedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;

INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (1, 510, '2025-06-23 23:15:05', 'Sale', NULL, '708000.00', '108000.00', 'Cash', 'TXN-510-1750720505861', 'Paid', NULL, 'Completed', '4782876', NULL, 'POS Sale - Cash payment', '2025-06-23 23:15:05', 'CURRENT_TIMESTAMP', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (2, 510, '2025-06-23 23:15:32', 'Sale', NULL, '708000.00', '108000.00', 'Cash', 'TXN-510-1750720532504', 'Paid', NULL, 'Completed', '4782876', NULL, 'POS Sale - Cash payment', '2025-06-23 23:15:32', 'CURRENT_TIMESTAMP', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (3, 510, '2025-06-23 23:16:39', 'Sale', NULL, '708000.00', '108000.00', 'Cash', 'TXN-510-1750720599297', 'Paid', NULL, 'Completed', '4782876', NULL, 'POS Sale - Cash payment', '2025-06-23 23:16:39', 'CURRENT_TIMESTAMP', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (4, 510, '2025-06-23 23:16:41', 'Sale', NULL, '708000.00', '108000.00', 'Cash', 'TXN-510-1750720602173', 'Paid', NULL, 'Completed', '4782876', NULL, 'POS Sale - Cash payment', '2025-06-23 23:16:41', 'CURRENT_TIMESTAMP', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (5, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '566400.00', '86400.00', 'Cash', 'POS-1750724005529', 'Paid', 'INV-250624-005529', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T00:13:25.529Z', '2025-06-24T00:13:25.529Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (6, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '141600.00', '21600.00', 'Cash', 'POS-1750724849669', 'Paid', 'INV-250624-849669', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T00:27:29.669Z', '2025-06-24T00:27:29.669Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (7, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '49336980.00', '7525980.00', 'Cash', 'POS-1750726357094', 'Paid', 'INV-250624-357094', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T00:52:37.094Z', '2025-06-24T00:52:37.094Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (8, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '477900.00', '72900.00', 'Cash', 'POS-1750727627913', 'Paid', 'INV-250624-627913', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T01:13:47.913Z', '2025-06-24T01:13:47.913Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (9, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '19824.00', '3024.00', 'Cash', 'POS-1750777684247', 'Paid', 'INV-250624-684247', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T15:08:04.247Z', '2025-06-24T15:08:04.247Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (10, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '19824.00', '3024.00', 'Cash', 'POS-1750777688244', 'Paid', 'INV-250624-688244', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T15:08:08.244Z', '2025-06-24T15:08:08.244Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (11, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '19824.00', '3024.00', 'Cash', 'POS-1750777690567', 'Paid', 'INV-250624-690567', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T15:08:10.567Z', '2025-06-24T15:08:10.567Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (12, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '21240.00', '3240.00', 'Cash', 'POS-1750777848250', 'Paid', 'INV-250624-848250', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T15:10:48.250Z', '2025-06-24T15:10:48.250Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (13, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '31860.00', '4860.00', 'Cash', 'POS-1750777883781', 'Paid', 'INV-250624-883781', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T15:11:23.781Z', '2025-06-24T15:11:23.781Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (14, 510, '2025-06-24', 'Sale', 'Walk-in Customer', '26550.00', '4050.00', 'Cash', 'POS-1750778825870', 'Paid', 'INV-250624-825870', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T15:27:05.870Z', '2025-06-24T15:27:05.870Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (15, 510, '2025-06-24T17:16:02.112Z', 'Sale', 'Walk-in Customer', '233640.00', '35640.00', 'Cash', 'POS-1750785362112', 'Paid', 'INV-510-250624-362112', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T17:16:02.112Z', '2025-06-24T17:16:02.112Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (16, 510, '2025-06-24T17:16:08.876Z', 'Sale', 'Walk-in Customer', '233640.00', '35640.00', 'Cash', 'POS-1750785368876', 'Paid', 'INV-510-250624-368876', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T17:16:08.876Z', '2025-06-24T17:16:08.876Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (17, 510, '2025-06-24T18:45:58.130Z', 'Sale', 'Walk-in Customer', '2655000.00', '405000.00', 'Cash', 'POS-1750790758130', 'Paid', 'INV-510-250624-758130', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T18:45:58.130Z', '2025-06-24T18:45:58.130Z', NULL, '0', '0.00');
INSERT INTO Transactions (TransactionID, StationID, TransactionDate, TransactionType, ReferenceParty, TotalAmount, TaxAmount, PaymentMethod, PaymentReference, PaymentStatus, InvoiceNumber, Status, HandledBy, ApprovedBy, Notes, CreatedAt, UpdatedAt, CustomerID, IsCreditSale, OutstandingAmount) VALUES (18, 510, '2025-06-24T18:59:21.272Z', 'Sale', 'Walk-in Customer', '233640.00', '35640.00', 'Cash', 'POS-1750791561272', 'Paid', 'INV-510-250624-561272', 'Completed', '4782876', NULL, 'POS Sale - Cash', '2025-06-24T18:59:21.272Z', '2025-06-24T18:59:21.272Z', NULL, '0', '0.00');

-- Table: TransferItems
DROP TABLE IF EXISTS TransferItems;

CREATE TABLE IF NOT EXISTS TransferItems (
    TransferItemID INTEGER PRIMARY KEY,
    TransferID     INTEGER NOT NULL,
    ProductID      INTEGER NOT NULL,
    Quantity       TEXT    NOT NULL,
    UnitPrice      TEXT    NOT NULL,
    TotalValue     TEXT    NOT NULL,
    Notes          TEXT    NULL,
    CreatedAt      TEXT    NULL
                           DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (
        TransferID
    )
    REFERENCES StationTransfers (TransferID) ON UPDATE CASCADE
                                             ON DELETE CASCADE,
    FOREIGN KEY (
        ProductID
    )
    REFERENCES Products (ProductID) ON UPDATE CASCADE
                                    ON DELETE RESTRICT
)
STRICT;


-- Table: URAEFilingSubmissions
DROP TABLE IF EXISTS URAEFilingSubmissions;

CREATE TABLE IF NOT EXISTS URAEFilingSubmissions (
    SubmissionID        INTEGER PRIMARY KEY,
    TaxRecordID         INTEGER NOT NULL,
    SubmissionDate      TEXT    NOT NULL,
    SubmissionReference TEXT    NOT NULL,
    SubmissionStatus    TEXT    NOT NULL
                                DEFAULT 'Pending',
    ResponseCode        TEXT    NULL,
    ResponseMessage     TEXT    NULL,
    SubmissionData      TEXT    NULL,
    ResponseData        TEXT    NULL,
    SubmittedBy         TEXT    NOT NULL,
    CreatedAt           TEXT    NULL
                                DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt           TEXT    NULL
                                DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        TaxRecordID
    )
    REFERENCES TaxRecords (TaxRecordID) ON UPDATE CASCADE
                                        ON DELETE CASCADE,
    FOREIGN KEY (
        SubmittedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE RESTRICT
)
STRICT;


-- Table: UserCertifications
DROP TABLE IF EXISTS UserCertifications;

CREATE TABLE IF NOT EXISTS UserCertifications (
    CertificationID     INTEGER PRIMARY KEY,
    UserID              INTEGER NOT NULL,
    CertificationType   TEXT    NOT NULL,
    CertificationName   TEXT    NOT NULL,
    IssuingAuthority    TEXT    NOT NULL,
    CertificationNumber TEXT    NULL,
    IssueDate           TEXT    NOT NULL,
    ExpiryDate          TEXT    NULL,
    DocumentPath        TEXT    NULL,
    VerificationStatus  TEXT    NOT NULL
                                DEFAULT 'Pending',
    VerifiedBy          TEXT    NULL,
    VerifiedAt          TEXT    NULL,
    Notes               TEXT    NULL,
    CreatedAt           TEXT    NULL
                                DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt           TEXT    NULL
                                DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE,
    FOREIGN KEY (
        VerifiedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;


-- Table: UserLoginHistory
DROP TABLE IF EXISTS UserLoginHistory;

CREATE TABLE IF NOT EXISTS UserLoginHistory (
    LoginID         INTEGER PRIMARY KEY,
    UserID          INTEGER NOT NULL,
    LoginTimestamp  TEXT    NOT NULL
                            DEFAULT CURRENT_TIMESTAMP,
    LogoutTimestamp TEXT    NULL,
    IPAddress       TEXT    NULL,
    UserAgent       TEXT    NULL,
    DeviceInfo      TEXT    NULL,
    LoginStatus     TEXT    NOT NULL,
    FailureReason   TEXT    NULL,
    SessionID       TEXT    NULL,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE
)
STRICT;


-- Table: UserPositions
DROP TABLE IF EXISTS UserPositions;

CREATE TABLE IF NOT EXISTS UserPositions (
    UserID           INTEGER PRIMARY KEY,
    PositionID       INTEGER NOT NULL,
    StartDate        TEXT    NOT NULL,
    EndDate          TEXT    NULL,
    IsPrimary        TEXT    NOT NULL
                             DEFAULT '1',
    IsActing         TEXT    NOT NULL
                             DEFAULT '0',
    StationID        INTEGER NULL,
    SupervisorUserID INTEGER NULL,
    Status           TEXT    NOT NULL
                             DEFAULT 'Active',
    CreatedAt        TEXT    NULL
                             DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt        TEXT    NULL
                             DEFAULT 'CURRENT_TIMESTAMP',
    CreatedBy        TEXT    NULL,
    UpdatedBy        TEXT    NULL,
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE,
    FOREIGN KEY (
        PositionID
    )
    REFERENCES Positions (PositionID) ON UPDATE CASCADE
                                      ON DELETE RESTRICT,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE SET NULL,
    FOREIGN KEY (
        SupervisorUserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;

INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (100, 101, '2025-05-07', NULL, '1', '0', 101, NULL, 'Active', '2025-05-07 16:58:37', '2025-05-07 16:58:37', '101', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (101, 102, '2025-05-07', NULL, '1', '0', 101, 100, 'Active', '2025-05-07 16:58:37', '2025-05-07 16:58:37', '100', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2701, 401, '2018-01-15', NULL, '1', '0', NULL, NULL, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2702, 402, '2018-02-10', NULL, '1', '0', NULL, 2701, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2703, 403, '2018-03-01', NULL, '1', '0', NULL, 2701, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2704, 404, '2018-04-15', NULL, '1', '0', NULL, 2702, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2705, 405, '2018-05-20', NULL, '1', '0', NULL, 2702, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2706, 406, '2018-06-10', NULL, '1', '0', NULL, 2702, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2707, 407, '2019-01-27', NULL, '1', '0', 501, 2704, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2704', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2708, 408, '2019-02-15', NULL, '1', '0', 502, 2704, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2704', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2709, 409, '2019-03-20', NULL, '1', '0', 505, 2705, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2705', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2710, 410, '2019-04-25', NULL, '1', '0', 507, 2706, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2706', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2711, 411, '2019-05-15', NULL, '1', '0', 501, 2707, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2712, 412, '2019-06-20', NULL, '1', '0', 502, 2708, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2708', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2713, 413, '2019-07-25', NULL, '1', '0', 505, 2709, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2709', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2714, 414, '2020-01-27', NULL, '1', '0', 501, 2711, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2715, 415, '2020-02-15', NULL, '1', '0', 501, 2714, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2716, 415, '2020-03-20', NULL, '1', '0', 502, 2712, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2708', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2717, 416, '2020-04-25', NULL, '1', '0', 501, 2711, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2718, 417, '2020-05-15', NULL, '1', '0', 501, 2717, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2707', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2719, 417, '2020-06-20', NULL, '1', '0', 502, 2712, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2708', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2720, 417, '2020-07-25', NULL, '1', '0', 505, 2713, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2709', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2721, 418, '2019-08-27', NULL, '1', '0', NULL, 2702, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2702', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2722, 419, '2019-09-15', NULL, '1', '0', 501, 2721, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2721', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2723, 419, '2019-10-20', NULL, '1', '0', 502, 2721, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2721', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2724, 420, '2019-11-25', NULL, '1', '0', NULL, 2701, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2701', NULL);
INSERT INTO UserPositions (UserID, PositionID, StartDate, EndDate, IsPrimary, IsActing, StationID, SupervisorUserID, Status, CreatedAt, UpdatedAt, CreatedBy, UpdatedBy) VALUES (2725, 421, '2020-01-15', NULL, '1', '0', NULL, 2724, 'Active', '2025-05-07 18:17:31', '2025-05-07 18:17:31', '2724', NULL);

-- Table: UserRoles
DROP TABLE IF EXISTS UserRoles;

CREATE TABLE IF NOT EXISTS UserRoles (
    UserID       INTEGER PRIMARY KEY,
    RoleID       INTEGER NOT NULL,
    AssignedDate TEXT    NULL
                         DEFAULT CURRENT_TIMESTAMP,
    AssignedBy   TEXT    NULL,
    IsActive     TEXT    NOT NULL
                         DEFAULT '1',
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE,
    FOREIGN KEY (
        RoleID
    )
    REFERENCES Roles (RoleID) ON UPDATE CASCADE
                              ON DELETE CASCADE,
    FOREIGN KEY (
        AssignedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;

INSERT INTO UserRoles (UserID, RoleID, AssignedDate, AssignedBy, IsActive) VALUES (2701, 8, '2025-05-07 17:59:09', '5', '1');
INSERT INTO UserRoles (UserID, RoleID, AssignedDate, AssignedBy, IsActive) VALUES (2707, 20, '2025-05-07 19:53:57', '5', '1');
INSERT INTO UserRoles (UserID, RoleID, AssignedDate, AssignedBy, IsActive) VALUES (2715, 13, '2025-06-22T19:05:20.906Z', NULL, '1');

-- Table: users
DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users (
    id                             INTEGER PRIMARY KEY,
    name                           TEXT    NOT NULL,
    first_name                     TEXT    NULL,
    last_name                      TEXT    NULL,
    middle_name                    TEXT    NULL,
    display_name                   TEXT    NULL,
    profile_photo_path             TEXT    NULL,
    date_of_birth                  TEXT    NULL,
    gender                         TEXT    NULL,
    national_id                    TEXT    NULL,
    address                        TEXT    NULL,
    city                           TEXT    NULL,
    state                          TEXT    NULL,
    postal_code                    TEXT    NULL,
    country                        TEXT    NULL
                                           DEFAULT 'Uganda',
    email                          TEXT    NOT NULL,
    secondary_email                TEXT    NULL,
    preferred_contact_method       TEXT    NULL
                                           DEFAULT 'Email',
    email_verified_at              TEXT    NULL,
    password                       TEXT    NOT NULL,
    two_factor_enabled             TEXT    NULL
                                           DEFAULT '0',
    two_factor_secret              TEXT    NULL,
    two_factor_recovery_codes      TEXT    NULL,
    password_changed_at            TEXT    NULL,
    last_login_at                  TEXT    NULL,
    last_login_ip                  TEXT    NULL,
    failed_login_attempts          TEXT    NULL
                                           DEFAULT '0',
    locked_until                   TEXT    NULL,
    UserID                         TEXT    NULL,
    employee_id                    TEXT    NULL,
    employment_type                TEXT    NULL,
    Phone                          TEXT    NULL,
    secondary_phone                TEXT    NULL,
    work_phone                     TEXT    NULL,
    PrimaryStationID               INTEGER NULL,
    Role                           TEXT    NOT NULL,
    Position                       TEXT    NULL,
    job_title                      TEXT    NULL,
    supervisor_ID                  INTEGER NULL,
    work_schedule                  TEXT    NULL,
    shift_preference               TEXT    NULL,
    Department                     TEXT    NULL,
    HireDate                       TEXT    NULL,
    probation_end_date             TEXT    NULL,
    contract_end_date              TEXT    NULL,
    termination_date               TEXT    NULL,
    termination_reason             TEXT    NULL,
    rehire_eligibility             TEXT    NULL,
    Salary                         TEXT    NULL,
    salary_type                    TEXT    NULL
                                           DEFAULT 'Monthly',
    pay_grade                      TEXT    NULL,
    TaxIdentificationNumber        TEXT    NULL,
    tax_status                     TEXT    NULL,
    payment_method                 TEXT    NULL
                                           DEFAULT 'Bank Transfer',
    BankDetails                    TEXT    NULL,
    bank_name                      TEXT    NULL,
    bank_account_number            TEXT    NULL,
    bank_branch                    TEXT    NULL,
    bank_routing_number            TEXT    NULL,
    mobile_money_provider          TEXT    NULL,
    mobile_money_number            TEXT    NULL,
    EmergencyContact               TEXT    NULL,
    emergency_contact_name         TEXT    NULL,
    emergency_contact_relationship TEXT    NULL,
    emergency_contact_phone        TEXT    NULL,
    emergency_contact_email        TEXT    NULL,
    emergency_contact_address      TEXT    NULL,
    Status                         TEXT    NULL
                                           DEFAULT 'Active',
    annual_leave_balance           TEXT    NULL
                                           DEFAULT '0.00',
    sick_leave_balance             TEXT    NULL
                                           DEFAULT '0.00',
    personal_leave_balance         TEXT    NULL
                                           DEFAULT '0.00',
    leave_cycle_start_date         TEXT    NULL,
    leave_cycle_end_date           TEXT    NULL,
    last_performance_review_date   TEXT    NULL,
    next_performance_review_date   TEXT    NULL,
    performance_rating             TEXT    NULL,
    performance_notes              TEXT    NULL,
    remember_token                 TEXT    NULL,
    created_at                     TEXT    NULL,
    updated_at                     TEXT    NULL,
    last_active_at                 TEXT    NULL,
    deactivated_at                 TEXT    NULL,
    deactivated_by                 TEXT    NULL,
    created_by                     TEXT    NULL,
    updated_by                     TEXT    NULL,
    notes                          TEXT    NULL,
    preferences                    TEXT    NULL,
    FOREIGN KEY (
        PrimaryStationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE SET NULL,
    FOREIGN KEY (
        supervisor_id
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;

INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (4, 'Wycliffee Mutungi', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uganda', 'vexa257@gmail.com', NULL, 'Email', NULL, '$2y$12$rOw4SJmUlNngqq09dXeyWeohEURSx2Katv5PKHgvQieX5Qn57Dg.a', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, '1', NULL, NULL, '0786190179', NULL, NULL, NULL, 'Admin', 'Manager', NULL, NULL, NULL, NULL, 'Finace', '2024-04-17', NULL, NULL, NULL, NULL, NULL, '356356', 'Monthly', NULL, '5635', NULL, 'Bank Transfer', 'Wycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee Mutungi', NULL, NULL, NULL, NULL, NULL, NULL, 'Wycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee Mutungi', NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-01 14:52:24', '2025-05-01 14:52:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (5, 'Ayebare Timothy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uganda', 'a.vexa256@gmail.com', NULL, 'Email', NULL, '$2y$12$nB59ihuV2PEsmaUBuQkyBuntiA4feMglM7NLjKdGLOr6rNqo7qFUW', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Monthly', NULL, NULL, NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, 'JSoVjqQKU5er3Ae4zWPoMaSGhC28Hphn0CBrYWcwO4QvMDSMP0imjsmrxXw3', '2025-05-06 17:08:48', '2025-05-06 17:08:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (100, 'John Smith', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uganda', 'john.smith@kigrama.com', NULL, 'Email', NULL, '$2y$12$abcdefghijklmnopqrstuvwxyz123456789', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Monthly', NULL, NULL, NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 16:58:37', '2025-05-07 16:58:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (101, 'Jane Doe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uganda', 'jane.doe@kigrama.com', NULL, 'Email', NULL, '$2y$12$abcdefghijklmnopqrstuvwxyz987654321', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Monthly', NULL, NULL, NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 16:58:37', '2025-05-07 16:58:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2701, 'David Mukasa', 'David', 'Mukasa', NULL, NULL, NULL, '1975-06-15', 'Male', NULL, 'Plot 45, Nakasero Road', 'Kampala', NULL, NULL, 'Uganda', 'david.mukasa@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234001', NULL, NULL, NULL, 'Admin', NULL, 'Chief Executive Officer', NULL, NULL, NULL, NULL, '2018-01-15', NULL, NULL, NULL, NULL, NULL, '7500000', 'Monthly', NULL, 'TIN27012345', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2702, 'Sarah Namukwaya', 'Sarah', 'Namukwaya', NULL, NULL, NULL, '1978-03-22', 'Female', NULL, 'Plot 78, Kololo Hill Drive', 'Kampala', NULL, NULL, 'Uganda', 'sarah.namukwaya@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234002', NULL, NULL, NULL, 'Admin', NULL, 'Chief Operations Officer', NULL, NULL, NULL, NULL, '2018-02-10', NULL, NULL, NULL, NULL, NULL, '6500000', 'Monthly', NULL, 'TIN27012346', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2703, 'Robert Ochieng', 'Robert', 'Ochieng', NULL, NULL, NULL, '1980-11-05', 'Male', NULL, 'Plot 112, Bukoto Street', 'Kampala', NULL, NULL, 'Uganda', 'robert.ochieng@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234003', NULL, NULL, NULL, 'Admin', NULL, 'Chief Financial Officer', NULL, NULL, NULL, NULL, '2018-03-01', NULL, NULL, NULL, NULL, NULL, '6500000', 'Monthly', NULL, 'TIN27012347', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2704, 'Patricia Akello', 'Patricia', 'Akello', NULL, NULL, NULL, '1982-07-18', 'Female', NULL, 'Plot 34, Ntinda Road', 'Kampala', NULL, NULL, 'Uganda', 'patricia.akello@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234004', NULL, NULL, NULL, 'Manager', NULL, 'Regional Manager – Central', NULL, NULL, NULL, NULL, '2018-04-15', NULL, NULL, NULL, NULL, NULL, '4500000', 'Monthly', NULL, 'TIN27012348', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2705, 'Michael Tumusiime', 'Michael', 'Tumusiime', NULL, NULL, NULL, '1983-09-30', 'Male', NULL, 'Plot 56, Kira Road', 'Kampala', NULL, NULL, 'Uganda', 'michael.tumusiime@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234005', NULL, NULL, NULL, 'Manager', NULL, 'Regional Manager – Eastern', NULL, NULL, NULL, NULL, '2018-05-20', NULL, NULL, NULL, NULL, NULL, '4500000', 'Monthly', NULL, 'TIN27012349', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2706, 'Grace Nabukenya', 'Grace', 'Nabukenya', NULL, NULL, NULL, '1984-02-12', 'Female', NULL, 'Plot 23, Jinja Road', 'Jinja', NULL, NULL, 'Uganda', 'grace.nabukenya@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234006', NULL, NULL, NULL, 'Manager', NULL, 'Regional Manager – Western', NULL, NULL, NULL, NULL, '2018-06-10', NULL, NULL, NULL, NULL, NULL, '4500000', 'Monthly', NULL, 'TIN27012350', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2707, 'Daniel Okello', 'Daniel', 'Okello', NULL, NULL, NULL, '1985-05-25', 'Male', NULL, 'Plot 67, Main Street', 'Kampala', NULL, NULL, 'Uganda', 'daniel.okello@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234007', NULL, NULL, NULL, 'Manager', NULL, 'Station Manager', NULL, NULL, NULL, NULL, '2019-01-27', NULL, NULL, NULL, NULL, NULL, '3000000', 'Monthly', NULL, 'TIN27012351', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2708, 'Florence Nambi', 'Florence', 'Nambi', NULL, NULL, NULL, '1986-08-14', 'Female', NULL, 'Plot 89, Central Avenue', 'Entebbe', NULL, NULL, 'Uganda', 'florence.nambi@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234008', NULL, NULL, NULL, 'Manager', NULL, 'Station Manager', NULL, NULL, NULL, NULL, '2019-02-15', NULL, NULL, NULL, NULL, NULL, '3000000', 'Monthly', NULL, 'TIN27012352', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2709, 'Joseph Mugisha', 'Joseph', 'Mugisha', NULL, NULL, NULL, '1984-11-30', 'Male', NULL, 'Plot 45, Mbale Road', 'Mbale', NULL, NULL, 'Uganda', 'joseph.mugisha@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234009', NULL, NULL, NULL, 'Manager', NULL, 'Station Manager', NULL, NULL, NULL, NULL, '2019-03-20', NULL, NULL, NULL, NULL, NULL, '3000000', 'Monthly', NULL, 'TIN27012353', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2710, 'Esther Nakato', 'Esther', 'Nakato', NULL, NULL, NULL, '1987-04-17', 'Female', NULL, 'Plot 34, Mbarara Road', 'Mbarara', NULL, NULL, 'Uganda', 'esther.nakato@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234010', NULL, NULL, NULL, 'Manager', NULL, 'Station Manager', NULL, NULL, NULL, NULL, '2019-04-25', NULL, NULL, NULL, NULL, NULL, '3000000', 'Monthly', NULL, 'TIN27012354', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2711, 'Peter Wasswa', 'Peter', 'Wasswa', NULL, NULL, NULL, '1988-06-22', 'Male', NULL, 'Plot 12, Nsambya Road', 'Kampala', NULL, NULL, 'Uganda', 'peter.wasswa@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234011', NULL, NULL, NULL, 'Manager', NULL, 'Shift Supervisor', NULL, NULL, NULL, NULL, '2019-05-15', NULL, NULL, NULL, NULL, NULL, '1800000', 'Monthly', NULL, 'TIN27012355', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2712, 'Mary Nantongo', 'Mary', 'Nantongo', NULL, NULL, NULL, '1989-09-08', 'Female', NULL, 'Plot 56, Entebbe Road', 'Entebbe', NULL, NULL, 'Uganda', 'mary.nantongo@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234012', NULL, NULL, NULL, 'Manager', NULL, 'Shift Supervisor', NULL, NULL, NULL, NULL, '2019-06-20', NULL, NULL, NULL, NULL, NULL, '1800000', 'Monthly', NULL, 'TIN27012356', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2713, 'James Muwonge', 'James', 'Muwonge', NULL, NULL, NULL, '1990-01-14', 'Male', NULL, 'Plot 78, Jinja Road', 'Jinja', NULL, NULL, 'Uganda', 'james.muwonge@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234013', NULL, NULL, NULL, 'Manager', NULL, 'Shift Supervisor', NULL, NULL, NULL, NULL, '2019-07-25', NULL, NULL, NULL, NULL, NULL, '1800000', 'Monthly', NULL, 'TIN27012357', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2714, 'Ruth Namukasa', 'Ruth', 'Namukasa', NULL, NULL, NULL, '1991-03-28', 'Female', NULL, 'Plot 23, Bukoto Street', 'Kampala', NULL, NULL, 'Uganda', 'ruth.namukasa@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234014', NULL, NULL, NULL, 'Cashier', NULL, 'Senior Cashier', NULL, NULL, NULL, NULL, '2020-01-27', NULL, NULL, NULL, NULL, NULL, '800000', 'Monthly', NULL, 'TIN27012358', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2715, 'Samuel Kato', 'Samuel', 'Kato', NULL, NULL, NULL, '1992-05-17', 'Male', NULL, 'Plot 45, Main Street', 'Entebbe', NULL, NULL, 'Uganda', 'samuel.kato@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234015', NULL, NULL, NULL, 'Cashier', NULL, 'Cashier', NULL, NULL, NULL, NULL, '2020-02-15', NULL, NULL, NULL, NULL, NULL, '650000', 'Monthly', NULL, 'TIN27012359', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2716, 'Janet Nakimuli', 'Janet', 'Nakimuli', NULL, NULL, NULL, '1993-07-29', 'Female', NULL, 'Plot 67, Mbale Road', 'Mbale', NULL, NULL, 'Uganda', 'janet.nakimuli@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234016', NULL, NULL, NULL, 'Cashier', NULL, 'Cashier', NULL, NULL, NULL, NULL, '2020-03-20', NULL, NULL, NULL, NULL, NULL, '650000', 'Monthly', NULL, 'TIN27012360', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2717, 'George Ssemakula', 'George', 'Ssemakula', NULL, NULL, NULL, '1994-09-12', 'Male', NULL, 'Plot 89, Nsambya Road', 'Kampala', NULL, NULL, 'Uganda', 'george.ssemakula@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234017', NULL, NULL, NULL, 'Attendant', NULL, 'Senior Fuel Attendant', NULL, NULL, NULL, NULL, '2020-04-25', NULL, NULL, NULL, NULL, NULL, '600000', 'Monthly', NULL, 'TIN27012361', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2718, 'Agnes Nabbosa', 'Agnes', 'Nabbosa', NULL, NULL, NULL, '1995-11-24', 'Female', NULL, 'Plot 12, Entebbe Road', 'Entebbe', NULL, NULL, 'Uganda', 'agnes.nabbosa@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234018', NULL, NULL, NULL, 'Attendant', NULL, 'Fuel Attendant', NULL, NULL, NULL, NULL, '2020-05-15', NULL, NULL, NULL, NULL, NULL, '450000', 'Monthly', NULL, 'TIN27012362', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-06-22T15:23:00.280Z', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2719, 'Richard Mugume', 'Richard', 'Mugume', NULL, NULL, NULL, '1996-02-05', 'Male', NULL, 'Plot 34, Jinja Road', 'Jinja', NULL, NULL, 'Uganda', 'richard.mugume@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234019', NULL, NULL, NULL, 'Attendant', NULL, 'Fuel Attendant', NULL, NULL, NULL, NULL, '2020-06-20', NULL, NULL, NULL, NULL, NULL, '450000', 'Monthly', NULL, 'TIN27012363', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-06-22T15:23:05.792Z', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2720, 'Catherine Namanda', 'Catherine', 'Namanda', NULL, NULL, NULL, '1997-04-18', 'Female', NULL, 'Plot 56, Mbarara Road', 'Mbarara', NULL, NULL, 'Uganda', 'catherine.namanda@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234020', NULL, NULL, NULL, 'Attendant', NULL, 'Fuel Attendant', NULL, NULL, NULL, NULL, '2020-07-25', NULL, NULL, NULL, NULL, NULL, '450000', 'Monthly', NULL, 'TIN27012364', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2721, 'Paul Lubega', 'Paul', 'Lubega', NULL, NULL, NULL, '1988-06-30', 'Male', NULL, 'Plot 78, Bukoto Street', 'Kampala', NULL, NULL, 'Uganda', 'paul.lubega@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234021', NULL, NULL, NULL, 'Accountant', NULL, 'National Maintenance Engineer', NULL, NULL, NULL, NULL, '2019-08-27', NULL, NULL, NULL, NULL, NULL, '2200000', 'Monthly', NULL, 'TIN27012365', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2722, 'Irene Nakimuli', 'Irene', 'Nakimuli', NULL, NULL, NULL, '1989-08-12', 'Female', NULL, 'Plot 90, Main Street', 'Kampala', NULL, NULL, 'Uganda', 'irene.nakimuli@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234022', NULL, NULL, NULL, 'Accountant', NULL, 'National Maintenance Technician', NULL, NULL, NULL, NULL, '2019-09-15', NULL, NULL, NULL, NULL, NULL, '1500000', 'Monthly', NULL, 'TIN27012366', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2723, 'Mark Ssentongo', 'Mark', 'Ssentongo', NULL, NULL, NULL, '1990-07-24', 'Male', NULL, 'Plot 23, Ntinda Road', 'Kampala', NULL, NULL, 'Uganda', 'mark.ssentongo@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234023', NULL, NULL, NULL, 'Accountant', NULL, 'National Maintenance Technician', NULL, NULL, NULL, NULL, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '1500000', 'Monthly', NULL, 'TIN27012367', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2724, 'Diana Namuganza', 'Diana', 'Namuganza', NULL, NULL, NULL, '1985-12-05', 'Female', NULL, 'Plot 45, Kololo Hill Drive', 'Kampala', NULL, NULL, 'Uganda', 'diana.namuganza@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234024', NULL, NULL, NULL, 'Admin', NULL, 'HSE Manager', NULL, NULL, NULL, NULL, '2019-11-25', NULL, NULL, NULL, NULL, NULL, '2800000', 'Monthly', NULL, 'TIN27012368', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (2725, 'Timothy Kabuye', 'Timothy', 'Kabuye', NULL, NULL, NULL, '1986-02-17', 'Male', NULL, 'Plot 67, Bukoto Street', 'Kampala', NULL, NULL, 'Uganda', 'timothy.kabuye@kigrama.com', NULL, 'Email', NULL, '$2y$12$secure.hash.placeholder', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, '+256701234025', NULL, NULL, NULL, 'Admin', NULL, 'HSE Officer', NULL, NULL, NULL, NULL, '2020-01-15', NULL, NULL, NULL, NULL, NULL, '1800000', 'Monthly', NULL, 'TIN27012369', NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:17:31', '2025-05-07 18:17:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (4782873, 'Ayebare Timothy2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uganda', 'vexsa256@gmail.com', NULL, 'Email', NULL, '$2y$12$byoPYfN1DPIr9asWmTm0ee8DG4/Kiyk./8f42wik4RtemLwHRH0Tu', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Monthly', NULL, NULL, NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 18:00:15', '2025-05-07 18:00:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (4782874, 'Ayebare Timothy22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uganda', 'atimothy@ecsahc.org2', NULL, 'Email', NULL, '$2y$12$IWMpX5k7pJ5murciUaMdMusXagciTu/1g5jjWfSRAR4KAdDC189xy', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Monthly', NULL, NULL, NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-07 20:05:32', '2025-05-07 20:05:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (4782875, 'Ayebare Timothy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uganda', 'vexa256@gmail.com', NULL, 'Email', NULL, '$2y$12$98SXXJi0oqJF0np5V99DD..U4ckioEebuTz18Fq865q.K1aDMvNne', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Monthly', NULL, NULL, NULL, 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '0', '0', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-06-14 16:59:24', '2025-06-14 16:59:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO users (id, name, first_name, last_name, middle_name, display_name, profile_photo_path, date_of_birth, gender, national_id, address, city, state, postal_code, country, email, secondary_email, preferred_contact_method, email_verified_at, password, two_factor_enabled, two_factor_secret, two_factor_recovery_codes, password_changed_at, last_login_at, last_login_ip, failed_login_attempts, locked_until, UserID, employee_id, employment_type, Phone, secondary_phone, work_phone, PrimaryStationID, Role, Position, job_title, supervisor_ID, work_schedule, shift_preference, Department, HireDate, probation_end_date, contract_end_date, termination_date, termination_reason, rehire_eligibility, Salary, salary_type, pay_grade, TaxIdentificationNumber, tax_status, payment_method, BankDetails, bank_name, bank_account_number, bank_branch, bank_routing_number, mobile_money_provider, mobile_money_number, EmergencyContact, emergency_contact_name, emergency_contact_relationship, emergency_contact_phone, emergency_contact_email, emergency_contact_address, Status, annual_leave_balance, sick_leave_balance, personal_leave_balance, leave_cycle_start_date, leave_cycle_end_date, last_performance_review_date, next_performance_review_date, performance_rating, performance_notes, remember_token, created_at, updated_at, last_active_at, deactivated_at, deactivated_by, created_by, updated_by, notes, preferences) VALUES (4782876, 'Ayebare Timothy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Kampala', 'Central Region', NULL, 'Uganda', 'atimothy@ecsahc.org', NULL, 'Email', NULL, 'atimothy@ecsahc.org', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL, 'KIG25WESAY833', 'KIG25WESAY833', 'Full-time', '+256 786 190 179', NULL, NULL, 511, 'System Administrator', NULL, 'IT Technician', NULL, 'Day Shift (8:00 AM - 5:00 PM)', 'Day', 'Western Region', '2025-06-22', '2025-09-22', NULL, NULL, NULL, 'Yes', '2500000', 'Monthly', NULL, NULL, 'PAYE', 'Bank Transfer', NULL, NULL, NULL, NULL, NULL, 'MTN', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', '21.00', '7.00', '3.00', '2025-01-01', '2025-12-31', NULL, NULL, NULL, NULL, NULL, '2025-06-22T15:22:49.679Z', '2025-06-22T15:22:49.679Z', NULL, NULL, NULL, '1', '1', NULL, '{"theme":"light","language":"en","notifications":true,"currency":"UGX","timezone":"Africa/Kampala"}');

-- Table: UserStations
DROP TABLE IF EXISTS UserStations;

CREATE TABLE IF NOT EXISTS UserStations (
    UserID       INTEGER PRIMARY KEY
                         NOT NULL,
    StationID    INTEGER NOT NULL,
    IsPrimary    TEXT    NOT NULL
                         DEFAULT '0',
    AssignedDate TEXT    NOT NULL,
    EndDate      TEXT    NULL,
    AssignedBy   TEXT    NULL,
    Status       TEXT    NOT NULL
                         DEFAULT 'Active',
    Notes        TEXT    NULL,
    CreatedAt    TEXT    NULL
                         DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt    TEXT    NULL
                         DEFAULT 'CURRENT_TIMESTAMP',
    FOREIGN KEY (
        UserID
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE CASCADE,
    FOREIGN KEY (
        StationID
    )
    REFERENCES Stations (StationID) ON UPDATE CASCADE
                                    ON DELETE CASCADE,
    FOREIGN KEY (
        AssignedBy
    )
    REFERENCES users (id) ON UPDATE CASCADE
                          ON DELETE SET NULL
)
STRICT;

INSERT INTO UserStations (UserID, StationID, IsPrimary, AssignedDate, EndDate, AssignedBy, Status, Notes, CreatedAt, UpdatedAt) VALUES (2713, 505, '0', '2025-05-10', NULL, NULL, 'Active', NULL, '2025-05-10 17:54:43', '2025-05-10 17:54:43');
INSERT INTO UserStations (UserID, StationID, IsPrimary, AssignedDate, EndDate, AssignedBy, Status, Notes, CreatedAt, UpdatedAt) VALUES (2715, 503, '0', '2025-06-22', NULL, NULL, 'Active', NULL, '2025-06-22 19:05:23', 'CURRENT_TIMESTAMP');
INSERT INTO UserStations (UserID, StationID, IsPrimary, AssignedDate, EndDate, AssignedBy, Status, Notes, CreatedAt, UpdatedAt) VALUES (2724, 510, '0', '2025-05-13', NULL, NULL, 'Active', NULL, '2025-05-10 17:59:25', '2025-05-10 17:59:25');

-- Index: idx_cashdrawers_unique
DROP INDEX IF EXISTS idx_cashdrawers_unique;

CREATE UNIQUE INDEX IF NOT EXISTS idx_cashdrawers_unique ON CashDrawers (
    "StationID",
    "ShiftDate",
    "ShiftType"
);


-- Index: idx_error_logs_created_at
DROP INDEX IF EXISTS idx_error_logs_created_at;

CREATE INDEX IF NOT EXISTS idx_error_logs_created_at ON error_logs (
    created_at
);


-- Index: idx_transactions_credit
DROP INDEX IF EXISTS idx_transactions_credit;

CREATE INDEX IF NOT EXISTS idx_transactions_credit ON Transactions (
    "IsCreditSale",
    "OutstandingAmount"
);


-- Index: idx_transactions_customer
DROP INDEX IF EXISTS idx_transactions_customer;

CREATE INDEX IF NOT EXISTS idx_transactions_customer ON Transactions (
    "CustomerID"
);


-- View: CustomerCreditSummary
DROP VIEW IF EXISTS CustomerCreditSummary;
CREATE VIEW IF NOT EXISTS CustomerCreditSummary AS
    SELECT Customers.CustomerID,
           Customers.CustomerCode,
           COALESCE(Customers.CompanyName, Customers.FirstName || ' ' || Customers.LastName) AS CustomerName,
           Customers.PhoneNumber,
           Customers.Status AS CustomerStatus,
           Stations.StationName,
           CustomerCreditAccounts.CreditLimit,
           CustomerCreditAccounts.CurrentBalance,
           CustomerCreditAccounts.AvailableCredit,
           CustomerCreditAccounts.PaymentTermsDays,
           CustomerCreditAccounts.LastPurchaseDate,
           CustomerCreditAccounts.LastPaymentDate,
           CustomerCreditAccounts.CreditScore,
           (
               SELECT COUNT( * ) 
                 FROM Transactions
                WHERE Transactions.CustomerID = Customers.CustomerID AND
                      Transactions.IsCreditSale = '1'/* Compare TEXT with TEXT literal */ AND
                      CAST (Transactions.OutstandingAmount AS REAL) > 0-- CAST TEXT to REAL for comparison
           )
           AS OutstandingTransactions,
           CASE WHEN CAST (CustomerCreditAccounts.CurrentBalance AS REAL) > CAST (CustomerCreditAccounts.CreditLimit AS REAL) THEN 'Over Limit' WHEN CAST (CustomerCreditAccounts.AvailableCredit AS REAL) < (CAST (CustomerCreditAccounts.CreditLimit AS REAL) * 0.1) THEN 'Near Limit' ELSE 'Normal' END AS CreditStatus
      FROM Customers
           JOIN
           CustomerCreditAccounts USING (
               CustomerID
           )
           LEFT JOIN
           Stations USING (
               StationID
           );


-- View: CustomerOutstandingBalances
DROP VIEW IF EXISTS CustomerOutstandingBalances;
CREATE VIEW IF NOT EXISTS CustomerOutstandingBalances AS
    SELECT Transactions.TransactionID,
           Transactions.TransactionDate,
           Customers.CustomerCode,
           COALESCE(Customers.CompanyName, Customers.FirstName || ' ' || Customers.LastName) AS CustomerName,
           Stations.StationName,
           Transactions.TotalAmount,
           Transactions.OutstandingAmount,
           julianday('now') - julianday(Transactions.TransactionDate) AS DaysOutstanding,
           CASE WHEN (julianday('now') - julianday(Transactions.TransactionDate) ) <= 30 THEN 'Current' WHEN (julianday('now') - julianday(Transactions.TransactionDate) ) <= 60 THEN '31-60 Days' WHEN (julianday('now') - julianday(Transactions.TransactionDate) ) <= 90 THEN '61-90 Days' ELSE '90+ Days' END AS AgingBucket
      FROM Transactions
           JOIN
           Customers USING (
               CustomerID
           )
           JOIN
           Stations USING (
               StationID
           )
     WHERE Transactions.IsCreditSale = '1'/* Compare TEXT with TEXT literal */ AND
           CAST (Transactions.OutstandingAmount AS REAL) > 0;


-- View: SupplierCreditSummary
DROP VIEW IF EXISTS SupplierCreditSummary;
CREATE VIEW IF NOT EXISTS SupplierCreditSummary AS
    SELECT SupplierCreditAccounts.CreditAccountID,
           SupplierCreditAccounts.SupplierID,
           Suppliers.Name AS SupplierName,
           SupplierCreditAccounts.StationID,
           Stations.StationName,
           SupplierCreditAccounts.CreditLimit,
           SupplierCreditAccounts.CurrentBalance,
           SupplierCreditAccounts.AvailableCredit,
           SupplierCreditAccounts.PaymentTermsDays,
           SupplierCreditAccounts.LastPaymentDate,
           SupplierCreditAccounts.LastPaymentAmount,
           (
               SELECT COUNT( * ) 
                 FROM SupplierInvoices
                WHERE SupplierInvoices.SupplierID = SupplierCreditAccounts.SupplierID AND
                      SupplierInvoices.Status = 'Outstanding'
           )
           AS OutstandingInvoices,
           CASE WHEN CAST (SupplierCreditAccounts.CurrentBalance AS REAL) > CAST (SupplierCreditAccounts.CreditLimit AS REAL) THEN 'Over Limit' WHEN CAST (SupplierCreditAccounts.AvailableCredit AS REAL) < (CAST (SupplierCreditAccounts.CreditLimit AS REAL) * 0.1) THEN 'Near Limit' ELSE 'Normal' END AS CreditStatus
      FROM SupplierCreditAccounts
           JOIN
           Suppliers USING (
               SupplierID
           )
           LEFT JOIN
           Stations USING (
               StationID
           );


-- Trigger: update_balances_on_allocation
DROP TRIGGER IF EXISTS update_balances_on_allocation;
CREATE TRIGGER IF NOT EXISTS update_balances_on_allocation
                       AFTER INSERT
                          ON SupplierPaymentAllocations
BEGIN-- Update invoice outstanding amount
    UPDATE SupplierInvoices
       SET PaidAmount = PaidAmount + NEW.AllocatedAmount,
           OutstandingAmount = TotalAmount - (PaidAmount + NEW.AllocatedAmount),
           Status = CASE WHEN (PaidAmount + NEW.AllocatedAmount) >= TotalAmount THEN 'Paid' ELSE 'Outstanding' END,
           UpdatedAt = CURRENT_TIMESTAMP
     WHERE InvoiceID = NEW.InvoiceID;-- Update credit account balance
    UPDATE SupplierCreditAccounts
       SET CurrentBalance = CurrentBalance - NEW.AllocatedAmount,
           AvailableCredit = CreditLimit - (CurrentBalance - NEW.AllocatedAmount),
           LastPaymentDate = NEW.AllocationDate,
           LastPaymentAmount = NEW.AllocatedAmount,
           UpdatedAt = CURRENT_TIMESTAMP
     WHERE SupplierID = (
                            SELECT SupplierID
                              FROM SupplierInvoices
                             WHERE InvoiceID = NEW.InvoiceID
                        );
END;


-- Trigger: update_credit_on_invoice_insert
DROP TRIGGER IF EXISTS update_credit_on_invoice_insert;
CREATE TRIGGER IF NOT EXISTS update_credit_on_invoice_insert
                       AFTER INSERT
                          ON SupplierInvoices
BEGIN
    UPDATE SupplierCreditAccounts
       SET CurrentBalance = CurrentBalance + NEW.TotalAmount,
           AvailableCredit = CreditLimit - (CurrentBalance + NEW.TotalAmount),
           UpdatedAt = CURRENT_TIMESTAMP
     WHERE SupplierID = NEW.SupplierID AND
           (StationID = NEW.StationID OR
            StationID IS NULL);-- Log the transaction
    INSERT INTO SupplierCreditTransactions (
                                               SupplierID,
                                               StationID,
                                               TransactionType,
                                               ReferenceID,
                                               Amount,
                                               PreviousBalance,
                                               NewBalance,
                                               Description,
                                               CreatedBy
                                           )
                                           VALUES (
                                               NEW.SupplierID,
                                               NEW.StationID,
                                               'Invoice',
                                               NEW.InvoiceID,
                                               NEW.TotalAmount,
                                               (
                                                   SELECT CurrentBalance - NEW.TotalAmount
                                                     FROM SupplierCreditAccounts
                                                    WHERE SupplierID = NEW.SupplierID
                                               ),
                                               (
                                                   SELECT CurrentBalance
                                                     FROM SupplierCreditAccounts
                                                    WHERE SupplierID = NEW.SupplierID
                                               ),
                                               'Invoice created: ' || NEW.InvoiceNumber,
                                               NEW.ReceivedBy
                                           );
END;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;


-- ============================================================================
-- KIGRAMA FUEL STATION SYSTEM - UNIVERSAL EVENT LOG TABLE
-- SQLite 3 Strict Mode - TrailBase Compatible  
-- Based on ACTUAL Database Schema - No Phantom Tables
-- All Foreign Keys are NULLABLE to prevent insertion failures
-- ============================================================================

DROP TABLE IF EXISTS EventLog;

CREATE TABLE IF NOT EXISTS EventLog (
    EventID         INTEGER PRIMARY KEY,
    
    -- Event classification
    EventType       TEXT    NOT NULL CHECK (EventType IN (
        'FRAUD', 'SECURITY', 'INVENTORY', 'TRANSACTION', 'ACCESS', 
        'SYSTEM', 'COMPLIANCE', 'OPERATIONAL', 'THRESHOLD', 'SAFETY'
    )),
    
    EventSubType    TEXT    NULL CHECK (EventSubType IN (
        'CASH_SHORTAGE', 'FUEL_THEFT', 'PRICE_OVERRIDE', 'REFUND_ABUSE',
        'AFTER_HOURS_ACCESS', 'FAILED_LOGIN', 'DATA_BREACH',
        'STOCK_VARIANCE', 'TANK_LEAK', 'PUMP_ERROR', 'METER_ROLLBACK',
        'LARGE_TRANSACTION', 'VOID_TRANSACTION', 'PAYMENT_FAILURE',
        'ROLE_VIOLATION', 'UNAUTHORIZED_DISCOUNT', 'SYSTEM_ERROR',
        'READING_VARIANCE', 'TRANSFER_DISCREPANCY', 'CREDIT_BREACH'
    )),
    
    -- Event details
    Title           TEXT    NOT NULL,
    Description     TEXT    NOT NULL,
    Notes           TEXT    NULL,
    
    -- Risk assessment
    RiskLevel       TEXT    NOT NULL DEFAULT 'LOW' CHECK (RiskLevel IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    Severity        INTEGER NOT NULL DEFAULT 1 CHECK (Severity >= 1 AND Severity <= 10),
    
    -- Event lifecycle
    Status          TEXT    NOT NULL DEFAULT 'OPEN' CHECK (Status IN ('OPEN', 'INVESTIGATING', 'RESOLVED', 'CLOSED')),
    
    -- Core location and user context
    AffectedStationID INTEGER NULL REFERENCES Stations(StationID),
    AffectedUserID  INTEGER NULL REFERENCES users(id),
    DepartmentID    INTEGER NULL REFERENCES Departments(DepartmentID),
    
    -- ACTUAL TRANSACTION REFERENCES (from existing schema)
    TransactionID   INTEGER NULL REFERENCES Transactions(TransactionID),
    TransactionItemID INTEGER NULL REFERENCES TransactionItems(ItemID),
    
    -- ACTUAL INVENTORY REFERENCES (from existing schema)
    InventoryID     INTEGER NULL REFERENCES StationInventory(InventoryID),
    InventoryHistoryID INTEGER NULL REFERENCES InventoryHistory(HistoryID),
    DailyReadingID  INTEGER NULL REFERENCES DailyReadings(ReadingID),
    StationTransferID INTEGER NULL REFERENCES StationTransfers(TransferID),
    TransferItemID  INTEGER NULL REFERENCES TransferItems(TransferItemID),
    
    -- ACTUAL EQUIPMENT REFERENCES (from existing schema)
    PumpID          INTEGER NULL REFERENCES Pumps(PumpID),
    TankID          INTEGER NULL REFERENCES Tanks(TankID),
    CashDrawerID    INTEGER NULL REFERENCES CashDrawers(DrawerID),
    
    -- ACTUAL BUSINESS ENTITY REFERENCES (from existing schema)
    ProductID       INTEGER NULL REFERENCES Products(ProductID),
    SupplierID      INTEGER NULL REFERENCES Suppliers(SupplierID),
    CustomerID      INTEGER NULL REFERENCES Customers(CustomerID),
    
    -- ACTUAL SYSTEM REFERENCES (from existing schema)
    AuditLogID      INTEGER NULL REFERENCES AuditLogs(LogID),
    NotificationID  INTEGER NULL REFERENCES Notifications(NotificationID),
    FraudLogID      INTEGER NULL REFERENCES FraudDetectionLogs(FraudLogID),
    
    -- ACTUAL FINANCIAL REFERENCES (from existing schema)
    LedgerEntryID   INTEGER NULL REFERENCES LedgerEntries(EntryID),
    TaxRecordID     INTEGER NULL REFERENCES TaxRecords(TaxRecordID),
    SupplierInvoiceID INTEGER NULL REFERENCES SupplierInvoices(InvoiceID),
    SupplierPaymentID INTEGER NULL REFERENCES SupplierPayments(PaymentID),
    CustomerCreditAccountID INTEGER NULL REFERENCES CustomerCreditAccounts(CreditAccountID),
    
    -- Financial impact tracking
    EstimatedLoss   TEXT    NULL DEFAULT '0.00',
    ActualLoss      TEXT    NULL DEFAULT '0.00',
    RecoveredAmount TEXT    NULL DEFAULT '0.00',
    AffectedAmount  TEXT    NULL DEFAULT '0.00',
    
    -- Operational measurements (for readings, variances, etc.)
    PreviousValue   TEXT    NULL,
    CurrentValue    TEXT    NULL,
    ExpectedValue   TEXT    NULL,
    VarianceAmount  TEXT    NULL,
    
    -- Resolution tracking
    ResolvedByUserID INTEGER NULL REFERENCES users(id),
    ActionTaken     TEXT    NULL,
    ResolutionNotes TEXT    NULL,
    PreventiveMeasures TEXT NULL,
    
    -- Generic references for flexibility
    RelatedTableName TEXT   NULL,
    RelatedRecordID INTEGER NULL,
    EvidenceJSON    TEXT    NULL,
    MetadataJSON    TEXT    NULL,
    
    -- System forensics context
    IPAddress       TEXT    NULL,
    UserAgent       TEXT    NULL,
    SessionID       TEXT    NULL,
    DeviceInfo      TEXT    NULL,
    
    -- Business impact assessment
    OperationalImpact TEXT NULL CHECK (OperationalImpact IN ('NONE', 'LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    CustomerImpact  TEXT    NULL CHECK (CustomerImpact IN ('NONE', 'LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    RegulatoryImpact TEXT   NOT NULL DEFAULT 'NO' CHECK (RegulatoryImpact IN ('NO', 'YES')),
    
    -- Pattern detection and correlation
    IsRecurring     TEXT    NOT NULL DEFAULT 'NO' CHECK (IsRecurring IN ('NO', 'YES')),
    PatternID       TEXT    NULL,
    CorrelationID   TEXT    NULL,
    
    -- Notification and escalation
    NotificationsSent TEXT  NOT NULL DEFAULT 'NO' CHECK (NotificationsSent IN ('NO', 'YES')),
    EscalationLevel INTEGER NOT NULL DEFAULT 0 CHECK (EscalationLevel >= 0 AND EscalationLevel <= 5),
    
    -- Complete lifecycle timestamps
    CreatedAt       TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt       TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    InvestigationStartedAt TEXT NULL,
    ResolvedAt      TEXT    NULL,
    ClosedAt        TEXT    NULL
    
) STRICT;

-- ============================================================================
-- PERFORMANCE INDEXES FOR ACTUAL TABLE OPERATIONS
-- ============================================================================

-- Core operational indexes
CREATE INDEX IF NOT EXISTS idx_eventlog_station_status ON EventLog(AffectedStationID, Status);
CREATE INDEX IF NOT EXISTS idx_eventlog_risk_severity ON EventLog(RiskLevel, Severity DESC, CreatedAt DESC);
CREATE INDEX IF NOT EXISTS idx_eventlog_type_subtype ON EventLog(EventType, EventSubType);
CREATE INDEX IF NOT EXISTS idx_eventlog_open_events ON EventLog(Status, CreatedAt DESC) WHERE Status IN ('OPEN', 'INVESTIGATING');

-- Financial transaction indexes (actual tables)
CREATE INDEX IF NOT EXISTS idx_eventlog_transaction ON EventLog(TransactionID) WHERE TransactionID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_transaction_item ON EventLog(TransactionItemID) WHERE TransactionItemID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_financial_loss ON EventLog(EstimatedLoss, ActualLoss) WHERE EstimatedLoss != '0.00' OR ActualLoss != '0.00';

-- Inventory and operations indexes (actual tables)
CREATE INDEX IF NOT EXISTS idx_eventlog_inventory ON EventLog(InventoryID) WHERE InventoryID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_inventory_history ON EventLog(InventoryHistoryID) WHERE InventoryHistoryID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_daily_readings ON EventLog(DailyReadingID) WHERE DailyReadingID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_transfers ON EventLog(StationTransferID) WHERE StationTransferID IS NOT NULL;

-- Equipment indexes (actual tables)
CREATE INDEX IF NOT EXISTS idx_eventlog_pump ON EventLog(PumpID) WHERE PumpID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_tank ON EventLog(TankID) WHERE TankID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_cash_drawer ON EventLog(CashDrawerID) WHERE CashDrawerID IS NOT NULL;

-- Business entity indexes (actual tables)
CREATE INDEX IF NOT EXISTS idx_eventlog_product ON EventLog(ProductID) WHERE ProductID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_supplier ON EventLog(SupplierID) WHERE SupplierID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_customer ON EventLog(CustomerID) WHERE CustomerID IS NOT NULL;

-- System and audit indexes (actual tables)
CREATE INDEX IF NOT EXISTS idx_eventlog_audit_log ON EventLog(AuditLogID) WHERE AuditLogID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_fraud_log ON EventLog(FraudLogID) WHERE FraudLogID IS NOT NULL;

-- Financial record indexes (actual tables)
CREATE INDEX IF NOT EXISTS idx_eventlog_ledger ON EventLog(LedgerEntryID) WHERE LedgerEntryID IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_eventlog_supplier_invoice ON EventLog(SupplierInvoiceID) WHERE SupplierInvoiceID IS NOT NULL;

-- Pattern and correlation indexes
CREATE INDEX IF NOT EXISTS idx_eventlog_pattern ON EventLog(PatternID, IsRecurring) WHERE IsRecurring = 'YES';
CREATE INDEX IF NOT EXISTS idx_eventlog_correlation ON EventLog(CorrelationID) WHERE CorrelationID IS NOT NULL;

-- User impact indexes
CREATE INDEX IF NOT EXISTS idx_eventlog_user_impact ON EventLog(AffectedUserID, RiskLevel);
CREATE INDEX IF NOT EXISTS idx_eventlog_resolved_by ON EventLog(ResolvedByUserID) WHERE ResolvedByUserID IS NOT NULL;

-- ============================================================================
-- AUTOMATED WORKFLOW TRIGGERS
-- ============================================================================

-- Update timestamp on any change
CREATE TRIGGER IF NOT EXISTS trg_eventlog_update
AFTER UPDATE ON EventLog
FOR EACH ROW
BEGIN
    UPDATE EventLog SET UpdatedAt = CURRENT_TIMESTAMP WHERE EventID = NEW.EventID;
END;

-- Auto-set investigation start time
CREATE TRIGGER IF NOT EXISTS trg_eventlog_investigation_start
AFTER UPDATE ON EventLog
FOR EACH ROW
WHEN NEW.Status = 'INVESTIGATING' AND OLD.Status != 'INVESTIGATING'
BEGIN
    UPDATE EventLog SET InvestigationStartedAt = CURRENT_TIMESTAMP WHERE EventID = NEW.EventID;
END;

-- Auto-set resolved time and calculate variance
CREATE TRIGGER IF NOT EXISTS trg_eventlog_resolved
AFTER UPDATE ON EventLog
FOR EACH ROW
WHEN NEW.Status = 'RESOLVED' AND OLD.Status != 'RESOLVED'
BEGIN
    UPDATE EventLog SET 
        ResolvedAt = CURRENT_TIMESTAMP,
        ActualLoss = COALESCE(NEW.ActualLoss, NEW.EstimatedLoss)
    WHERE EventID = NEW.EventID;
END;

-- Auto-set closed time
CREATE TRIGGER IF NOT EXISTS trg_eventlog_closed
AFTER UPDATE ON EventLog
FOR EACH ROW
WHEN NEW.Status = 'CLOSED' AND OLD.Status != 'CLOSED'
BEGIN
    UPDATE EventLog SET ClosedAt = CURRENT_TIMESTAMP WHERE EventID = NEW.EventID;
END;

-- Auto-escalation for high-risk events
CREATE TRIGGER IF NOT EXISTS trg_eventlog_auto_escalate
AFTER INSERT ON EventLog
FOR EACH ROW
WHEN NEW.RiskLevel IN ('HIGH', 'CRITICAL') OR NEW.Severity >= 8
BEGIN
    UPDATE EventLog SET 
        EscalationLevel = CASE 
            WHEN NEW.RiskLevel = 'CRITICAL' OR NEW.Severity >= 9 THEN 3
            WHEN NEW.RiskLevel = 'HIGH' OR NEW.Severity >= 8 THEN 2
            ELSE 1
        END,
        NotificationsSent = 'YES'
    WHERE EventID = NEW.EventID;
END;

-- ============================================================================
-- REPORTING VIEWS FOR ACTUAL SYSTEM DATA
-- ============================================================================

-- Critical events requiring immediate attention
CREATE VIEW IF NOT EXISTS vw_critical_events AS
SELECT 
    EventID, EventType, EventSubType, Title, RiskLevel, Severity,
    AffectedStationID, EstimatedLoss, ActualLoss, EscalationLevel,
    CreatedAt, Status
FROM EventLog
WHERE (RiskLevel IN ('HIGH', 'CRITICAL') OR Severity >= 7)
    AND Status NOT IN ('RESOLVED', 'CLOSED')
ORDER BY Severity DESC, CreatedAt DESC;

-- Financial impact summary by station
CREATE VIEW IF NOT EXISTS vw_financial_impact_by_station AS
SELECT 
    AffectedStationID,
    EventType,
    COUNT(*) as EventCount,
    SUM(CAST(EstimatedLoss as DECIMAL)) as TotalEstimatedLoss,
    SUM(CAST(ActualLoss as DECIMAL)) as TotalActualLoss,
    SUM(CAST(RecoveredAmount as DECIMAL)) as TotalRecovered
FROM EventLog
WHERE AffectedStationID IS NOT NULL
    AND (EstimatedLoss != '0.00' OR ActualLoss != '0.00')
GROUP BY AffectedStationID, EventType;

-- Transaction-related events
CREATE VIEW IF NOT EXISTS vw_transaction_events AS
SELECT 
    EventID, EventType, EventSubType, Title, RiskLevel,
    TransactionID, TransactionItemID, AffectedAmount,
    CreatedAt, Status
FROM EventLog
WHERE TransactionID IS NOT NULL OR TransactionItemID IS NOT NULL
ORDER BY CreatedAt DESC;

-- Inventory-related events
CREATE VIEW IF NOT EXISTS vw_inventory_events AS
SELECT 
    EventID, EventType, EventSubType, Title, RiskLevel,
    InventoryID, InventoryHistoryID, ProductID, VarianceAmount,
    CreatedAt, Status
FROM EventLog
WHERE InventoryID IS NOT NULL 
    OR InventoryHistoryID IS NOT NULL 
    OR DailyReadingID IS NOT NULL
ORDER BY CreatedAt DESC;

-- Equipment-related events
CREATE VIEW IF NOT EXISTS vw_equipment_events AS
SELECT 
    EventID, EventType, EventSubType, Title, RiskLevel,
    PumpID, TankID, CashDrawerID, AffectedStationID,
    CreatedAt, Status
FROM EventLog
WHERE PumpID IS NOT NULL 
    OR TankID IS NOT NULL 
    OR CashDrawerID IS NOT NULL
ORDER BY CreatedAt DESC;
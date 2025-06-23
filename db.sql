----
-- phpLiteAdmin database dump (https://www.phpliteadmin.org/)
-- phpLiteAdmin version: 1.9.8.2
-- Exported: 7:01pm on June 15, 2025 (CAT)
-- database file: ./Kigrama.sqlite
----
BEGIN TRANSACTION;

----
-- Drop table for ApprovalActions
----
DROP TABLE IF EXISTS "ApprovalActions";

----
-- Table structure for ApprovalActions
----
CREATE TABLE "ApprovalActions" (
	"ActionID" INTEGER PRIMARY KEY,
	"ApprovalID"  INTEGER NOT NULL  ,
	"StepID"  INTEGER NULL  ,
	"UserID"  INTEGER NOT NULL  ,
	"ActionType" TEXT NOT NULL  ,
	"ActionDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"Comments" TEXT NULL  ,
	"IPAddress" TEXT NULL  ,
	"UserAgent" TEXT NULL,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("StepID") REFERENCES "ApprovalSteps" ("StepID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("StepID") REFERENCES "ApprovalSteps" ("StepID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for ApprovalAttachments
----
DROP TABLE IF EXISTS "ApprovalAttachments";

----
-- Table structure for ApprovalAttachments
----
CREATE TABLE "ApprovalAttachments" (
	"AttachmentID" INTEGER PRIMARY KEY,
	"ApprovalID"  INTEGER NOT NULL  ,
	"FileName" TEXT NOT NULL  ,
	"FilePath" TEXT NOT NULL  ,
	"FileType" TEXT NULL  ,
	"FileSize" TEXT NULL  ,
	"UploadedBy" TEXT NOT NULL  ,
	"UploadedAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"Description" TEXT NULL,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("UploadedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UploadedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for ApprovalNotifications
----
DROP TABLE IF EXISTS "ApprovalNotifications";

----
-- Table structure for ApprovalNotifications
----
CREATE TABLE "ApprovalNotifications" (
	"NotificationID" INTEGER PRIMARY KEY,
	"ApprovalID"  INTEGER NOT NULL  ,
	"UserID"  INTEGER NOT NULL  ,
	"NotificationType" TEXT NOT NULL  ,
	"Message" TEXT NOT NULL  ,
	"IsRead" TEXT NOT NULL DEFAULT '0' ,
	"ReadAt" TEXT NULL  ,
	"DeliveryChannel" TEXT NOT NULL DEFAULT 'InApp' ,
	"DeliveryStatus" TEXT NOT NULL DEFAULT 'Pending' ,
	"SentAt" TEXT NULL  ,
	"CreatedAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for ApprovalSteps
----
DROP TABLE IF EXISTS "ApprovalSteps";

----
-- Table structure for ApprovalSteps
----
CREATE TABLE "ApprovalSteps" (
	"StepID" INTEGER PRIMARY KEY,
	"ApprovalID"  INTEGER NOT NULL  ,
	"StepNumber" TEXT NOT NULL  ,
	"ApproverType" TEXT NOT NULL  ,
	"ApproverUserID"  INTEGER NULL  ,
	"ApproverRoleID"  INTEGER NULL  ,
	"ApproverPositionID"  INTEGER NULL  ,
	"MinApprovers" TEXT NOT NULL DEFAULT '1' ,
	"Status" TEXT NOT NULL DEFAULT 'Pending' ,
	"StartedAt" TEXT NULL  ,
	"CompletedAt" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ApproverUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ApprovalID") REFERENCES "Approvals" ("ApprovalID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ApproverUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for ApprovalTemplateSteps
----
DROP TABLE IF EXISTS "ApprovalTemplateSteps";

----
-- Table structure for ApprovalTemplateSteps
----
CREATE TABLE "ApprovalTemplateSteps" (
	"TemplateStepID" INTEGER PRIMARY KEY,
	"TemplateID"  INTEGER NOT NULL  ,
	"StepNumber" TEXT NOT NULL  ,
	"ApproverType" TEXT NOT NULL  ,
	"ApproverUserID"  INTEGER NULL  ,
	"ApproverRoleID"  INTEGER NULL  ,
	"ApproverPositionID"  INTEGER NULL  ,
	"MinApprovers" TEXT NOT NULL DEFAULT '1' ,
	"Description" TEXT NULL,
	FOREIGN KEY("TemplateID") REFERENCES "ApprovalTemplates" ("TemplateID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ApproverUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("TemplateID") REFERENCES "ApprovalTemplates" ("TemplateID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ApproverUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for ApprovalTemplates
----
DROP TABLE IF EXISTS "ApprovalTemplates";

----
-- Table structure for ApprovalTemplates
----
CREATE TABLE "ApprovalTemplates" (
	"TemplateID" INTEGER PRIMARY KEY,
	"TemplateName" TEXT NOT NULL  ,
	"RequestType" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedBy" TEXT NOT NULL  ,
	"CreatedAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for Approvals
----
DROP TABLE IF EXISTS "Approvals";

----
-- Table structure for Approvals
----
CREATE TABLE "Approvals" (
	"ApprovalID" INTEGER PRIMARY KEY,
	"RequestType" TEXT NOT NULL  ,
	"RequestTypeID"  INTEGER NOT NULL  ,
	"RequestTitle" TEXT NOT NULL  ,
	"RequestDetails" TEXT NULL  ,
	"RequestAmount" TEXT NULL  ,
	"RequestDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"RequesterUserID"  INTEGER NOT NULL  ,
	"RequesterStationID"  INTEGER NULL  ,
	"RequesterDepartmentID"  INTEGER NULL  ,
	"RequesterPositionID"  INTEGER NULL  ,
	"CurrentApprovalLevel" TEXT NOT NULL DEFAULT '1' ,
	"CurrentApproverUserID"  INTEGER NULL  ,
	"CurrentApproverRoleID"  INTEGER NULL  ,
	"CurrentApproverPositionID"  INTEGER NULL  ,
	"Status" TEXT NOT NULL DEFAULT 'Pending' ,
	"Priority" TEXT NOT NULL DEFAULT 'Normal' ,
	"DueDate" TEXT NULL  ,
	"NotifyRequester" TEXT NOT NULL DEFAULT '1' ,
	"NotifyApprovers" TEXT NOT NULL DEFAULT '1' ,
	"NotifyOnCompletion" TEXT NOT NULL DEFAULT '1' ,
	"LastNotificationSent" TEXT NULL  ,
	"ReminderCount" TEXT NOT NULL DEFAULT '0' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CompletedAt" TEXT NULL  ,
	"ExpiresAt" TEXT NULL,
	FOREIGN KEY("RequesterUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("CurrentApproverUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CurrentApproverUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("RequesterUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for Attendance
----
DROP TABLE IF EXISTS "Attendance";

----
-- Table structure for Attendance
----
CREATE TABLE "Attendance" (
	"AttendanceID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"UserID"  INTEGER NOT NULL  ,
	"AttendanceDate" TEXT NOT NULL  ,
	"TimeIn" TEXT NULL  ,
	"TimeOut" TEXT NULL  ,
	"Status" TEXT NOT NULL  ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for AuditLogs
----
DROP TABLE IF EXISTS "AuditLogs";

----
-- Table structure for AuditLogs
----
CREATE TABLE "AuditLogs" (
	"LogID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NULL  ,
	"UserID"  INTEGER NULL  ,
	"Action" TEXT NOT NULL  ,
	"TableName" TEXT NOT NULL  ,
	"RecordID"  INTEGER NULL  ,
	"Changes" TEXT NULL  ,
	"IPAddress" TEXT NULL  ,
	"LogTimestamp" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for CareerPaths
----
DROP TABLE IF EXISTS "CareerPaths";

----
-- Table structure for CareerPaths
----
CREATE TABLE "CareerPaths" (
	"PathID" INTEGER PRIMARY KEY,
	"FromPositionID"  INTEGER NOT NULL  ,
	"ToPositionID"  INTEGER NOT NULL  ,
	"PathType" TEXT NOT NULL  ,
	"MinTimeInPosition" TEXT NULL  ,
	"MinPerformanceRating" TEXT NULL  ,
	"RequiredTraining" TEXT NULL  ,
	"RequiredCertifications" TEXT NULL  ,
	"Description" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CreatedBy" TEXT NULL,
	FOREIGN KEY("FromPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ToPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("FromPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ToPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for DailyReadings
----
DROP TABLE IF EXISTS "DailyReadings";

----
-- Table structure for DailyReadings
----
CREATE TABLE "DailyReadings" (
	"ReadingID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"ReadingDate" TEXT NOT NULL  ,
	"PumpID"  INTEGER NULL  ,
	"TankID"  INTEGER NULL  ,
	"OpeningReading" TEXT NULL  ,
	"ClosingReading" TEXT NULL  ,
	"DipReading" TEXT NULL  ,
	"CalculatedSales" TEXT NULL  ,
	"Variance" TEXT NULL  ,
	"RecordedBy" TEXT NOT NULL  ,
	"VerifiedBy" TEXT NULL  ,
	"Status" TEXT NULL DEFAULT 'Pending' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("PumpID") REFERENCES "Pumps" ("PumpID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("TankID") REFERENCES "Tanks" ("TankID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("RecordedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("VerifiedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("PumpID") REFERENCES "Pumps" ("PumpID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("RecordedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("TankID") REFERENCES "Tanks" ("TankID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("VerifiedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for Departments
----
DROP TABLE IF EXISTS "Departments";

----
-- Table structure for Departments
----
CREATE TABLE "Departments" (
	"DepartmentID" INTEGER PRIMARY KEY,
	"DepartmentName" TEXT NOT NULL  ,
	"DepartmentCode" TEXT NOT NULL  ,
	"ParentDepartmentID"  INTEGER NULL  ,
	"ManagerUserID"  INTEGER NULL  ,
	"Description" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CreatedBy" TEXT NULL  ,
	"UpdatedBy" TEXT NULL,
	FOREIGN KEY("ParentDepartmentID") REFERENCES "Departments" ("DepartmentID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ManagerUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("UpdatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ManagerUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ParentDepartmentID") REFERENCES "Departments" ("DepartmentID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UpdatedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for FraudDetectionLogs
----
DROP TABLE IF EXISTS "FraudDetectionLogs";

----
-- Table structure for FraudDetectionLogs
----
CREATE TABLE "FraudDetectionLogs" (
	"FraudLogID" INTEGER PRIMARY KEY,
	"DetectionRuleID"  INTEGER NULL  ,
	"TransactionID"  INTEGER NULL  ,
	"StationID"  INTEGER NULL  ,
	"UserID"  INTEGER NULL  ,
	"RiskScore" TEXT NULL  ,
	"Severity" TEXT NOT NULL DEFAULT 'Low' ,
	"FraudType" TEXT NULL  ,
	"Description" TEXT NULL  ,
	"DetectedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"Status" TEXT NOT NULL DEFAULT 'Open' ,
	"ResolvedBy" TEXT NULL  ,
	"ResolvedAt" TEXT NULL  ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for FraudDetectionRules
----
DROP TABLE IF EXISTS "FraudDetectionRules";

----
-- Table structure for FraudDetectionRules
----
CREATE TABLE "FraudDetectionRules" (
	"DetectionRuleID" INTEGER PRIMARY KEY,
	"RuleName" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"Threshold" TEXT NULL  ,
	"Enabled" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for InventoryHistory
----
DROP TABLE IF EXISTS "InventoryHistory";

----
-- Table structure for InventoryHistory
----
CREATE TABLE "InventoryHistory" (
	"HistoryID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"ProductID"  INTEGER NOT NULL  ,
	"TankID"  INTEGER NULL  ,
	"PumpID"  INTEGER NULL  ,
	"TransactionID"  INTEGER NULL  ,
	"TransferID"  INTEGER NULL  ,
	"ChangeDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"ChangeType" TEXT NOT NULL  ,
	"PreviousQuantity" TEXT NOT NULL  ,
	"QuantityChange" TEXT NOT NULL  ,
	"NewQuantity" TEXT NOT NULL  ,
	"UnitPrice" TEXT NULL  ,
	"TotalValue" TEXT NULL  ,
	"ReasonForChange" TEXT NULL  ,
	"AdjustmentCategory" TEXT NULL  ,
	"BatchNumber" TEXT NULL  ,
	"ExpiryDate" TEXT NULL  ,
	"QualityCheck" TEXT NULL DEFAULT 'N/A' ,
	"MeasurementMethod" TEXT NULL  ,
	"MeasurementDetails" TEXT NULL  ,
	"AuthorizedBy" TEXT NULL  ,
	"RecordedBy" TEXT NOT NULL  ,
	"VerifiedBy" TEXT NULL  ,
	"Notes" TEXT NULL  ,
	"AdditionalProperties" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("AuthorizedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ProductID") REFERENCES "Products" ("ProductID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("PumpID") REFERENCES "Pumps" ("PumpID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("RecordedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("TankID") REFERENCES "Tanks" ("TankID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("TransactionID") REFERENCES "Transactions" ("TransactionID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("TransferID") REFERENCES "StationTransfers" ("TransferID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("VerifiedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("AuthorizedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ProductID") REFERENCES "Products" ("ProductID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("PumpID") REFERENCES "Pumps" ("PumpID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("RecordedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("TankID") REFERENCES "Tanks" ("TankID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("TransactionID") REFERENCES "Transactions" ("TransactionID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("TransferID") REFERENCES "StationTransfers" ("TransferID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("VerifiedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for JobGrades
----
DROP TABLE IF EXISTS "JobGrades";

----
-- Table structure for JobGrades
----
CREATE TABLE "JobGrades" (
	"GradeID" INTEGER PRIMARY KEY,
	"GradeCode" TEXT NOT NULL  ,
	"GradeName" TEXT NOT NULL  ,
	"MinSalary" TEXT NOT NULL  ,
	"MidSalary" TEXT NULL  ,
	"MaxSalary" TEXT NOT NULL  ,
	"Level" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CreatedBy" TEXT NULL  ,
	"UpdatedBy" TEXT NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("UpdatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UpdatedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for LedgerEntries
----
DROP TABLE IF EXISTS "LedgerEntries";

----
-- Table structure for LedgerEntries
----
CREATE TABLE "LedgerEntries" (
	"EntryID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"TransactionDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"AccountCode" TEXT NOT NULL  ,
	"TransactionType" TEXT NOT NULL  ,
	"ReferenceID"  INTEGER NULL  ,
	"Description" TEXT NOT NULL  ,
	"DebitAmount" TEXT NULL DEFAULT '0.00' ,
	"CreditAmount" TEXT NULL DEFAULT '0.00' ,
	"RecordedBy" TEXT NOT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("RecordedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("RecordedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for MyApprovalRequests
----
DROP TABLE IF EXISTS "MyApprovalRequests";

----
-- Table structure for MyApprovalRequests
----
CREATE TABLE "MyApprovalRequests" (
	"ApprovalID" INTEGER PRIMARY KEY ,
	"RequestType" TEXT NULL  ,
	"RequestTypeID"  INTEGER NULL  ,
	"RequestTitle" TEXT NULL  ,
	"RequestDate" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"Status" TEXT NULL DEFAULT 'Pending' ,
	"Priority" TEXT NULL DEFAULT 'Normal' ,
	"DueDate" TEXT NULL  ,
	"CurrentApprovalLevel" TEXT NULL DEFAULT '1' ,
	"TotalSteps" TEXT NULL  ,
	"CurrentApprover" TEXT NULL  ,
	"CompletedAt" TEXT NULL  ,
	"ProcessingDays" TEXT NULL
) STRICT ;

----
-- Drop table for NotificationPreferences
----
DROP TABLE IF EXISTS "NotificationPreferences";

----
-- Table structure for NotificationPreferences
----
CREATE TABLE "NotificationPreferences" (
	"PreferenceID" INTEGER PRIMARY KEY,
	"UserID"  INTEGER NOT NULL  ,
	"Channel" TEXT NOT NULL  ,
	"Enabled" TEXT NOT NULL DEFAULT '1' ,
	"Frequency" TEXT NOT NULL DEFAULT 'Immediate' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for NotificationTemplates
----
DROP TABLE IF EXISTS "NotificationTemplates";

----
-- Table structure for NotificationTemplates
----
CREATE TABLE "NotificationTemplates" (
	"TemplateID" INTEGER PRIMARY KEY,
	"Name" TEXT NOT NULL  ,
	"Channel" TEXT NOT NULL  ,
	"Subject" TEXT NULL  ,
	"Body" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for Notifications
----
DROP TABLE IF EXISTS "Notifications";

----
-- Table structure for Notifications
----
CREATE TABLE "Notifications" (
	"NotificationID" INTEGER PRIMARY KEY,
	"UserID"  INTEGER NULL  ,
	"StationID"  INTEGER NULL  ,
	"TemplateID"  INTEGER NULL  ,
	"Channel" TEXT NOT NULL  ,
	"Type" TEXT NOT NULL  ,
	"Title" TEXT NOT NULL  ,
	"Message" TEXT NULL  ,
	"Payload" TEXT NULL  ,
	"Status" TEXT NOT NULL DEFAULT 'Queued' ,
	"Attempts" TEXT NOT NULL DEFAULT '0' ,
	"ScheduledAt" TEXT NULL  ,
	"SentAt" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for PendingApprovalsByRole
----
DROP TABLE IF EXISTS "PendingApprovalsByRole";

----
-- Table structure for PendingApprovalsByRole
----
CREATE TABLE "PendingApprovalsByRole" (
	"ApprovalID" INTEGER PRIMARY KEY,
	"RequestType" TEXT NULL  ,
	"RequestTitle" TEXT NULL  ,
	"RequestDate" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"Status" TEXT NULL DEFAULT 'Pending' ,
	"Priority" TEXT NULL DEFAULT 'Normal' ,
	"DueDate" TEXT NULL  ,
	"RequesterUserID"  INTEGER NULL  ,
	"RequesterName" TEXT NOT NULL  ,
	"CurrentApproverRoleID"  INTEGER NULL  ,
	"CurrentApproverRoleName" TEXT NOT NULL  ,
	"CurrentApprovalLevel" TEXT NULL DEFAULT '1' ,
	"TotalSteps" TEXT NULL  ,
	"DaysOpen" TEXT NULL  ,
	"DaysUntilDue" TEXT NULL
) STRICT ;

----
-- Drop table for PendingApprovalsByUser
----
DROP TABLE IF EXISTS "PendingApprovalsByUser";

----
-- Table structure for PendingApprovalsByUser
----
CREATE TABLE "PendingApprovalsByUser" (
	"ApprovalID" INTEGER PRIMARY KEY ,
	"RequestType" TEXT NULL  ,
	"RequestTitle" TEXT NULL  ,
	"RequestDate" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"Status" TEXT NULL DEFAULT 'Pending' ,
	"Priority" TEXT NULL DEFAULT 'Normal' ,
	"DueDate" TEXT NULL  ,
	"RequesterUserID"  INTEGER NULL  ,
	"RequesterName" TEXT NOT NULL  ,
	"CurrentApproverUserID"  INTEGER NULL  ,
	"CurrentApproverName" TEXT NULL  ,
	"CurrentApprovalLevel" TEXT NULL DEFAULT '1' ,
	"TotalSteps" TEXT NULL  ,
	"ApprovalType" TEXT NOT NULL DEFAULT '' ,
	"DaysOpen" TEXT NULL  ,
	"DaysUntilDue" TEXT NULL
) STRICT ;

----
-- Drop table for Permissions
----
DROP TABLE IF EXISTS "Permissions";

----
-- Table structure for Permissions
----
CREATE TABLE "Permissions" (
	"PermissionID" INTEGER PRIMARY KEY,
	"PermissionName" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"Module" TEXT NOT NULL  ,
	"Action" TEXT NOT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT ;

----
-- Drop table for PositionHistory
----
DROP TABLE IF EXISTS "PositionHistory";

----
-- Table structure for PositionHistory
----
CREATE TABLE "PositionHistory" (
	"HistoryID" INTEGER PRIMARY KEY,
	"UserID"  INTEGER NOT NULL  ,
	"FromPositionID"  INTEGER NULL  ,
	"ToPositionID"  INTEGER NOT NULL  ,
	"FromDepartmentID"  INTEGER NULL  ,
	"ToDepartmentID"  INTEGER NOT NULL  ,
	"FromGradeID"  INTEGER NULL  ,
	"ToGradeID"  INTEGER NOT NULL  ,
	"FromStationID"  INTEGER NULL  ,
	"ToStationID"  INTEGER NULL  ,
	"ChangeType" TEXT NOT NULL  ,
	"EffectiveDate" TEXT NOT NULL  ,
	"PreviousSalary" TEXT NULL  ,
	"NewSalary" TEXT NULL  ,
	"SalaryChangePercent" TEXT NULL  ,
	"Reason" TEXT NULL  ,
	"RequestID"  INTEGER NULL  ,
	"ApprovedBy" TEXT NULL  ,
	"ApprovalDate" TEXT NULL  ,
	"DocumentPath" TEXT NULL  ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"CreatedBy" TEXT NULL,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("FromPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ToPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("FromDepartmentID") REFERENCES "Departments" ("DepartmentID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ToDepartmentID") REFERENCES "Departments" ("DepartmentID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("FromGradeID") REFERENCES "JobGrades" ("GradeID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ToGradeID") REFERENCES "JobGrades" ("GradeID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("FromStationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ToStationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ApprovedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ApprovedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("FromDepartmentID") REFERENCES "Departments" ("DepartmentID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("FromGradeID") REFERENCES "JobGrades" ("GradeID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("FromPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("FromStationID") REFERENCES "Stations" ("StationID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ToDepartmentID") REFERENCES "Departments" ("DepartmentID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ToGradeID") REFERENCES "JobGrades" ("GradeID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ToPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ToStationID") REFERENCES "Stations" ("StationID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for PositionRequirements
----
DROP TABLE IF EXISTS "PositionRequirements";

----
-- Table structure for PositionRequirements
----
CREATE TABLE "PositionRequirements" (
	"RequirementID" INTEGER PRIMARY KEY,
	"PositionID"  INTEGER NOT NULL  ,
	"RequirementType" TEXT NOT NULL  ,
	"RequirementName" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"IsMandatory" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("PositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("PositionID") REFERENCES "Positions" ("PositionID") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for Positions
----
DROP TABLE IF EXISTS "Positions";

----
-- Table structure for Positions
----
CREATE TABLE "Positions" (
	"PositionID" INTEGER PRIMARY KEY,
	"PositionCode" TEXT NOT NULL  ,
	"PositionTitle" TEXT NOT NULL  ,
	"DepartmentID"  INTEGER NOT NULL  ,
	"GradeID"  INTEGER NOT NULL  ,
	"ReportsToPositionID"  INTEGER NULL  ,
	"MinExperience" TEXT NULL  ,
	"MinEducation" TEXT NULL  ,
	"PositionDescription" TEXT NULL  ,
	"Responsibilities" TEXT NULL  ,
	"Qualifications" TEXT NULL  ,
	"Skills" TEXT NULL  ,
	"IsManagement" TEXT NOT NULL DEFAULT '0' ,
	"HeadcountLimit" TEXT NULL  ,
	"CurrentHeadcount" TEXT NOT NULL DEFAULT '0' ,
	"IsApprover" TEXT NOT NULL DEFAULT '0' ,
	"ApprovalLevel" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CreatedBy" TEXT NULL  ,
	"UpdatedBy" TEXT NULL,
	FOREIGN KEY("DepartmentID") REFERENCES "Departments" ("DepartmentID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("GradeID") REFERENCES "JobGrades" ("GradeID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("ReportsToPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("UpdatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for Products
----
DROP TABLE IF EXISTS "Products";

----
-- Table structure for Products
----
CREATE TABLE "Products" (
	"ProductID" INTEGER PRIMARY KEY,
	"ProductType" TEXT NOT NULL  ,
	"Name" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"UnitPrice" TEXT NOT NULL  ,
	"SellingPrice" TEXT NULL  ,
	"TaxRate" TEXT NULL DEFAULT '0.00' ,
	"ReorderLevel" TEXT NULL  ,
	"Status" TEXT NULL DEFAULT 'Active' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for PromotionRequests
----
DROP TABLE IF EXISTS "PromotionRequests";

----
-- Table structure for PromotionRequests
----
CREATE TABLE "PromotionRequests" (
	"RequestID" INTEGER PRIMARY KEY,
	"UserID"  INTEGER NOT NULL  ,
	"CurrentPositionID"  INTEGER NOT NULL  ,
	"RequestedPositionID"  INTEGER NOT NULL  ,
	"RequestDate" TEXT NOT NULL  ,
	"RequestReason" TEXT NOT NULL  ,
	"SupportingDocumentPath" TEXT NULL  ,
	"SupervisorUserID"  INTEGER NULL  ,
	"SupervisorRecommendation" TEXT NULL DEFAULT 'Pending' ,
	"SupervisorComments" TEXT NULL  ,
	"SupervisorReviewDate" TEXT NULL  ,
	"HRUserID"  INTEGER NULL  ,
	"HRRecommendation" TEXT NULL DEFAULT 'Pending' ,
	"HRComments" TEXT NULL  ,
	"HRReviewDate" TEXT NULL  ,
	"FinalApproverUserID"  INTEGER NULL  ,
	"FinalDecision" TEXT NULL DEFAULT 'Pending' ,
	"FinalComments" TEXT NULL  ,
	"FinalDecisionDate" TEXT NULL  ,
	"EffectiveDate" TEXT NULL  ,
	"Status" TEXT NOT NULL DEFAULT 'Draft' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("CurrentPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("RequestedPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("SupervisorUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("HRUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("FinalApproverUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CurrentPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("FinalApproverUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("HRUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("RequestedPositionID") REFERENCES "Positions" ("PositionID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("SupervisorUserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for Pumps
----
DROP TABLE IF EXISTS "Pumps";

----
-- Table structure for Pumps
----
CREATE TABLE "Pumps" (
	"PumpID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"TankID"  INTEGER NOT NULL  ,
	"PumpName" TEXT NOT NULL  ,
	"MeterReading" TEXT NOT NULL DEFAULT '0.00' ,
	"Status" TEXT NULL DEFAULT 'Active' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("TankID") REFERENCES "Tanks" ("TankID") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT ;

----
-- Drop table for RolePermissions
----
DROP TABLE IF EXISTS "RolePermissions";

----
-- Table structure for RolePermissions
----
CREATE TABLE "RolePermissions" (
	"RoleID" INTEGER PRIMARY KEY ,
	"PermissionID"  INTEGER NOT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"CreatedBy" TEXT NULL  ,
	
	FOREIGN KEY("RoleID") REFERENCES "Roles" ("RoleID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("PermissionID") REFERENCES "Permissions" ("PermissionID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for Roles
----
DROP TABLE IF EXISTS "Roles";

----
-- Table structure for Roles
----
CREATE TABLE "Roles" (
	"RoleID" INTEGER PRIMARY KEY,
	"RoleName" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"IsSystem" TEXT NOT NULL DEFAULT '0' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CreatedBy" TEXT NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for StationInventory
----
DROP TABLE IF EXISTS "StationInventory";

----
-- Table structure for StationInventory
----
CREATE TABLE "StationInventory" (
	"InventoryID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"ProductID"  INTEGER NOT NULL  ,
	"CurrentStock" TEXT NULL DEFAULT '0.00' ,
	"LastUpdated" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ProductID") REFERENCES "Products" ("ProductID") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT ;

----
-- Drop table for StationTransfers
----
DROP TABLE IF EXISTS "StationTransfers";

----
-- Table structure for StationTransfers
----
CREATE TABLE "StationTransfers" (
	"TransferID" INTEGER PRIMARY KEY,
	"SourceStationID"  INTEGER NOT NULL  ,
	"DestinationStationID"  INTEGER NOT NULL  ,
	"TransferDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"Status" TEXT NULL DEFAULT 'Initiated' ,
	"InitiatedBy" TEXT NOT NULL  ,
	"ApprovedBy" TEXT NULL  ,
	"ReceivedBy" TEXT NULL  ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("SourceStationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("DestinationStationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("InitiatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("ApprovedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("ReceivedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for Stations
----
DROP TABLE IF EXISTS "Stations";

----
-- Table structure for Stations
----
CREATE TABLE "Stations" (
	"StationID" INTEGER PRIMARY KEY,
	"StationName" TEXT NOT NULL  ,
	"Location" TEXT NOT NULL  ,
	"ContactPhone" TEXT NOT NULL  ,
	"ManagerUserID"  INTEGER NULL  ,
	"OpeningDate" TEXT NOT NULL  ,
	"Status" TEXT NULL DEFAULT 'Active' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("ManagerUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for SuccessionPlans
----
DROP TABLE IF EXISTS "SuccessionPlans";

----
-- Table structure for SuccessionPlans
----
CREATE TABLE "SuccessionPlans" (
	"PlanID" INTEGER PRIMARY KEY,
	"PositionID"  INTEGER NOT NULL  ,
	"CurrentUserID"  INTEGER NULL  ,
	"SuccessorUserID"  INTEGER NOT NULL  ,
	"ReadinessLevel" TEXT NOT NULL  ,
	"DevelopmentPlan" TEXT NULL  ,
	"Notes" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CreatedBy" TEXT NULL  ,
	"UpdatedBy" TEXT NULL,
	FOREIGN KEY("PositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("CurrentUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("SuccessorUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("UpdatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for SupplierStations
----
DROP TABLE IF EXISTS "SupplierStations";

----
-- Table structure for SupplierStations
----
CREATE TABLE "SupplierStations" (
	"SupplierID" INTEGER PRIMARY KEY  ,
	"StationID"  INTEGER NOT NULL  ,
	FOREIGN KEY("SupplierID") REFERENCES "Suppliers" ("SupplierID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE
) STRICT ;

----
-- Drop table for Suppliers
----
DROP TABLE IF EXISTS "Suppliers";

----
-- Table structure for Suppliers
----
CREATE TABLE "Suppliers" (
	"SupplierID" INTEGER PRIMARY KEY,
	"Name" TEXT NOT NULL  ,
	"ContactPerson" TEXT NULL  ,
	"Email" TEXT NULL  ,
	"Phone" TEXT NOT NULL  ,
	"Address" TEXT NULL  ,
	"TaxIdentificationNumber" TEXT NULL  ,
	"IsGlobal" TEXT NULL DEFAULT '0' ,
	"Status" TEXT NULL DEFAULT 'Active' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for Tanks
----
DROP TABLE IF EXISTS "Tanks";

----
-- Table structure for Tanks
----
CREATE TABLE "Tanks" (
	"TankID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"ProductID"  INTEGER NOT NULL  ,
	"TankName" TEXT NOT NULL  ,
	"Capacity" TEXT NOT NULL  ,
	"CurrentLevel" TEXT NOT NULL  ,
	"Status" TEXT NULL DEFAULT 'Active' ,
	"LastFilledDate" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ProductID") REFERENCES "Products" ("ProductID") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT ;

----
-- Drop table for TaxRecords
----
DROP TABLE IF EXISTS "TaxRecords";

----
-- Table structure for TaxRecords
----
CREATE TABLE "TaxRecords" (
	"TaxRecordID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"TaxPeriod" TEXT NOT NULL  ,
	"TaxType" TEXT NOT NULL  ,
	"TaxableAmount" TEXT NOT NULL  ,
	"TaxAmount" TEXT NOT NULL  ,
	"Status" TEXT NULL DEFAULT 'Pending' ,
	"FilingDate" TEXT NULL  ,
	"PaymentDate" TEXT NULL  ,
	"ReferenceNumber" TEXT NULL  ,
	"PreparedBy" TEXT NOT NULL  ,
	"ApprovedBy" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("PreparedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("ApprovedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for TaxTypes
----
DROP TABLE IF EXISTS "TaxTypes";

----
-- Table structure for TaxTypes
----
CREATE TABLE "TaxTypes" (
	"TaxTypeID" INTEGER PRIMARY KEY,
	"TaxCode" TEXT NOT NULL  ,
	"TaxName" TEXT NOT NULL  ,
	"TaxCategory" TEXT NOT NULL  ,
	"RateType" TEXT NOT NULL  ,
	"DefaultRate" TEXT NOT NULL  ,
	"RateUnit" TEXT NULL  ,
	"TaxAuthority" TEXT NOT NULL DEFAULT 'URA' ,
	"Description" TEXT NULL  ,
	"FilingFrequency" TEXT NOT NULL  ,
	"DueDays" TEXT NULL  ,
	"LegalReference" TEXT NULL  ,
	"EffectiveFrom" TEXT NOT NULL  ,
	"EffectiveTo" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP'
) STRICT ;

----
-- Drop table for TransactionItems
----
DROP TABLE IF EXISTS "TransactionItems";

----
-- Table structure for TransactionItems
----
CREATE TABLE "TransactionItems" (
	"ItemID" INTEGER PRIMARY KEY,
	"TransactionID"  INTEGER NOT NULL  ,
	"ProductID"  INTEGER NOT NULL  ,
	"Quantity" TEXT NOT NULL  ,
	"UnitPrice" TEXT NOT NULL  ,
	"SellingPrice" TEXT  NULL  ,
	"TaxRate" TEXT NOT NULL  ,
	"Subtotal" TEXT NOT NULL  ,
	"PumpID"  INTEGER NULL  ,
	"TankID"  INTEGER NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("TransactionID") REFERENCES "Transactions" ("TransactionID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ProductID") REFERENCES "Products" ("ProductID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("PumpID") REFERENCES "Pumps" ("PumpID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("TankID") REFERENCES "Tanks" ("TankID") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for Transactions
----
DROP TABLE IF EXISTS "Transactions";

----
-- Table structure for Transactions
----
CREATE TABLE "Transactions" (
	"TransactionID" INTEGER PRIMARY KEY,
	"StationID"  INTEGER NOT NULL  ,
	"TransactionDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"TransactionType" TEXT NOT NULL  ,
	"ReferenceParty" TEXT NULL  ,
	"TotalAmount" TEXT NOT NULL  ,
	"TaxAmount" TEXT NOT NULL  ,
	"PaymentMethod" TEXT NOT NULL  ,
	"PaymentReference" TEXT NULL  ,
	"PaymentStatus" TEXT NULL DEFAULT 'Paid' ,
	"InvoiceNumber" TEXT NULL  ,
	"Status" TEXT NULL DEFAULT 'Completed' ,
	"HandledBy" TEXT NOT NULL  ,
	"ApprovedBy" TEXT NULL  ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("HandledBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("ApprovedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for TransferItems
----
DROP TABLE IF EXISTS "TransferItems";

----
-- Table structure for TransferItems
----
CREATE TABLE "TransferItems" (
	"TransferItemID" INTEGER PRIMARY KEY,
	"TransferID"  INTEGER NOT NULL  ,
	"ProductID"  INTEGER NOT NULL  ,
	"Quantity" TEXT NOT NULL  ,
	"UnitPrice" TEXT NOT NULL  ,
	"TotalValue" TEXT NOT NULL  ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY("TransferID") REFERENCES "StationTransfers" ("TransferID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("ProductID") REFERENCES "Products" ("ProductID") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT ;

----
-- Drop table for URAEFilingSubmissions
----
DROP TABLE IF EXISTS "URAEFilingSubmissions";

----
-- Table structure for URAEFilingSubmissions
----
CREATE TABLE "URAEFilingSubmissions" (
	"SubmissionID" INTEGER PRIMARY KEY,
	"TaxRecordID"  INTEGER NOT NULL  ,
	"SubmissionDate" TEXT NOT NULL  ,
	"SubmissionReference" TEXT NOT NULL  ,
	"SubmissionStatus" TEXT NOT NULL DEFAULT 'Pending' ,
	"ResponseCode" TEXT NULL  ,
	"ResponseMessage" TEXT NULL  ,
	"SubmissionData" TEXT NULL  ,
	"ResponseData" TEXT NULL  ,
	"SubmittedBy" TEXT NOT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("TaxRecordID") REFERENCES "TaxRecords" ("TaxRecordID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("SubmittedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT ;

----
-- Drop table for UserCertifications
----
DROP TABLE IF EXISTS "UserCertifications";

----
-- Table structure for UserCertifications
----
CREATE TABLE "UserCertifications" (
	"CertificationID" INTEGER PRIMARY KEY,
	"UserID"  INTEGER NOT NULL  ,
	"CertificationType" TEXT NOT NULL  ,
	"CertificationName" TEXT NOT NULL  ,
	"IssuingAuthority" TEXT NOT NULL  ,
	"CertificationNumber" TEXT NULL  ,
	"IssueDate" TEXT NOT NULL  ,
	"ExpiryDate" TEXT NULL  ,
	"DocumentPath" TEXT NULL  ,
	"VerificationStatus" TEXT NOT NULL DEFAULT 'Pending' ,
	"VerifiedBy" TEXT NULL  ,
	"VerifiedAt" TEXT NULL  ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP',
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("VerifiedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for UserLoginHistory
----
DROP TABLE IF EXISTS "UserLoginHistory";

----
-- Table structure for UserLoginHistory
----
CREATE TABLE "UserLoginHistory" (
	"LoginID" INTEGER PRIMARY KEY,
	"UserID"  INTEGER NOT NULL  ,
	"LoginTimestamp" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	"LogoutTimestamp" TEXT NULL  ,
	"IPAddress" TEXT NULL  ,
	"UserAgent" TEXT NULL  ,
	"DeviceInfo" TEXT NULL  ,
	"LoginStatus" TEXT NOT NULL  ,
	"FailureReason" TEXT NULL  ,
	"SessionID" TEXT NULL,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE
) STRICT ;

----
-- Drop table for UserPositions
----
DROP TABLE IF EXISTS "UserPositions";

----
-- Table structure for UserPositions
----
CREATE TABLE "UserPositions" (
	"UserID" INTEGER PRIMARY KEY  ,
	"PositionID"  INTEGER NOT NULL  ,
	"StartDate" TEXT NOT NULL  ,
	"EndDate" TEXT NULL  ,
	"IsPrimary" TEXT NOT NULL DEFAULT '1' ,
	"IsActing" TEXT NOT NULL DEFAULT '0' ,
	"StationID"  INTEGER NULL  ,
	"SupervisorUserID"  INTEGER NULL  ,
	"Status" TEXT NOT NULL DEFAULT 'Active' ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,
	"CreatedBy" TEXT NULL  ,
	"UpdatedBy" TEXT NULL  ,
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("PositionID") REFERENCES "Positions" ("PositionID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("SupervisorUserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("CreatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("UpdatedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for UserRoles
----
DROP TABLE IF EXISTS "UserRoles";

----
-- Table structure for UserRoles
----
CREATE TABLE "UserRoles" (
	"UserID" INTEGER PRIMARY KEY  ,
	"RoleID"  INTEGER NOT NULL  ,
	"AssignedDate" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"AssignedBy" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	
	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("RoleID") REFERENCES "Roles" ("RoleID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("AssignedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;

----
-- Drop table for UserStations
----
DROP TABLE IF EXISTS "UserStations";

----
-- Table structure for UserStations
----
CREATE TABLE "UserStations" (
	"UserID"  INTEGER PRIMARY KEY NOT NULL  ,
	"StationID"  INTEGER NOT NULL  ,
	"IsPrimary" TEXT NOT NULL DEFAULT '0' ,
	"AssignedDate" TEXT NOT NULL  ,
	"EndDate" TEXT NULL  ,
	"AssignedBy" TEXT NULL  ,
	"Status" TEXT NOT NULL DEFAULT 'Active' ,
	"Notes" TEXT NULL  ,
	"CreatedAt" TEXT NULL DEFAULT CURRENT_TIMESTAMP ,
	"UpdatedAt" TEXT NULL DEFAULT 'CURRENT_TIMESTAMP' ,

	FOREIGN KEY("UserID") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("StationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY("AssignedBy") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;







----
-- Drop table for notification_categories
----
DROP TABLE IF EXISTS "notification_categories";

----
-- Table structure for notification_categories
----
CREATE TABLE "notification_categories" (
	"CategoryID" INTEGER PRIMARY KEY,
	"CategoryName" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"CreatedBy" TEXT NOT NULL  ,
	"CreatedAt" TEXT NOT NULL  ,
	"UpdatedBy" TEXT NULL  ,
	"UpdatedAt" TEXT NULL
) STRICT ;

----
-- Drop table for notification_channels
----
DROP TABLE IF EXISTS "notification_channels";

----
-- Table structure for notification_channels
----
CREATE TABLE "notification_channels" (
	"ChannelID" INTEGER PRIMARY KEY,
	"ChannelName" TEXT NOT NULL  ,
	"ChannelCode" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedBy" TEXT NOT NULL  ,
	"CreatedAt" TEXT NOT NULL  ,
	"UpdatedBy" TEXT NULL  ,
	"UpdatedAt" TEXT NULL
) STRICT ;

----
-- Drop table for notification_events
----
DROP TABLE IF EXISTS "notification_events";

----
-- Table structure for notification_events
----
CREATE TABLE "notification_events" (
	"EventID" INTEGER PRIMARY KEY,
	"EventName" TEXT NOT NULL  ,
	"EventCode" TEXT NOT NULL  ,
	"CategoryID"  INTEGER NOT NULL  ,
	"Description" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"CreatedBy" TEXT NOT NULL  ,
	"CreatedAt" TEXT NOT NULL  ,
	"UpdatedBy" TEXT NULL  ,
	"UpdatedAt" TEXT NULL,
	FOREIGN KEY("CategoryID") REFERENCES "notification_categories" ("CategoryID") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;

----
-- Drop table for notification_settings
----
DROP TABLE IF EXISTS "notification_settings";

----
-- Table structure for notification_settings
----
CREATE TABLE "notification_settings" (
	"SettingID" INTEGER PRIMARY KEY,
	"SettingName" TEXT NOT NULL  ,
	"SettingValue" TEXT NULL  ,
	"Description" TEXT NULL  ,
	"UpdatedBy" TEXT NULL  ,
	"UpdatedAt" TEXT NULL
) STRICT ;

----
-- Drop table for notification_templates
----
DROP TABLE IF EXISTS "notification_templates";

----
-- Table structure for notification_templates
----
CREATE TABLE "notification_templates" (
	"TemplateID" INTEGER PRIMARY KEY,
	"TemplateName" TEXT NOT NULL  ,
	"Subject" TEXT NULL  ,
	"EventID"  INTEGER NOT NULL  ,
	"ChannelID"  INTEGER NOT NULL  ,
	"TemplateContent" TEXT NOT NULL  ,
	"Description" TEXT NULL  ,
	"IsActive" TEXT NOT NULL DEFAULT '1' ,
	"UsageCount" TEXT NOT NULL DEFAULT '0' ,
	"CreatedBy" TEXT NOT NULL  ,
	"CreatedAt" TEXT NOT NULL  ,
	"UpdatedBy" TEXT NULL  ,
	"UpdatedAt" TEXT NULL,
	FOREIGN KEY("EventID") REFERENCES "notification_events" ("EventID") ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY("ChannelID") REFERENCES "notification_channels" ("ChannelID") ON UPDATE NO ACTION ON DELETE NO ACTION
) STRICT ;






----
-- Drop table for users
----
DROP TABLE IF EXISTS "users";

----
-- Table structure for users
----
CREATE TABLE "users" (
	"id" INTEGER PRIMARY KEY,
	"name" TEXT NOT NULL  ,
	"first_name" TEXT NULL  ,
	"last_name" TEXT NULL  ,
	"middle_name" TEXT NULL  ,
	"display_name" TEXT NULL  ,
	"profile_photo_path" TEXT NULL  ,
	"date_of_birth" TEXT NULL  ,
	"gender" TEXT NULL  ,
	"national_id" TEXT NULL  ,
	"address" TEXT NULL  ,
	"city" TEXT NULL  ,
	"state" TEXT NULL  ,
	"postal_code" TEXT NULL  ,
	"country" TEXT NULL DEFAULT 'Uganda' ,
	"email" TEXT NOT NULL  ,
	"secondary_email" TEXT NULL  ,
	"preferred_contact_method" TEXT NULL DEFAULT 'Email' ,
	"email_verified_at" TEXT NULL  ,
	"password" TEXT NOT NULL  ,
	"two_factor_enabled" TEXT NULL DEFAULT '0' ,
	"two_factor_secret" TEXT NULL  ,
	"two_factor_recovery_codes" TEXT NULL  ,
	"password_changed_at" TEXT NULL  ,
	"last_login_at" TEXT NULL  ,
	"last_login_ip" TEXT NULL  ,
	"failed_login_attempts" TEXT NULL DEFAULT '0' ,
	"locked_until" TEXT NULL  ,
	"UserID" TEXT NULL  ,
	"employee_id" TEXT NULL  ,
	"employment_type" TEXT NULL  ,
	"Phone" TEXT NULL  ,
	"secondary_phone" TEXT NULL  ,
	"work_phone" TEXT NULL  ,
	"PrimaryStationID"  INTEGER NULL  ,
	"Role" TEXT NOT NULL  ,
	"Position" TEXT NULL  ,
	"job_title" TEXT NULL  ,
	"supervisor_ID"  INTEGER NULL  ,
	"work_schedule" TEXT NULL  ,
	"shift_preference" TEXT NULL  ,
	"Department" TEXT NULL  ,
	"HireDate" TEXT NULL  ,
	"probation_end_date" TEXT NULL  ,
	"contract_end_date" TEXT NULL  ,
	"termination_date" TEXT NULL  ,
	"termination_reason" TEXT NULL  ,
	"rehire_eligibility" TEXT NULL  ,
	"Salary" TEXT NULL  ,
	"salary_type" TEXT NULL DEFAULT 'Monthly' ,
	"pay_grade" TEXT NULL  ,
	"TaxIdentificationNumber" TEXT NULL  ,
	"tax_status" TEXT NULL  ,
	"payment_method" TEXT NULL DEFAULT 'Bank Transfer' ,
	"BankDetails" TEXT NULL  ,
	"bank_name" TEXT NULL  ,
	"bank_account_number" TEXT NULL  ,
	"bank_branch" TEXT NULL  ,
	"bank_routing_number" TEXT NULL  ,
	"mobile_money_provider" TEXT NULL  ,
	"mobile_money_number" TEXT NULL  ,
	"EmergencyContact" TEXT NULL  ,
	"emergency_contact_name" TEXT NULL  ,
	"emergency_contact_relationship" TEXT NULL  ,
	"emergency_contact_phone" TEXT NULL  ,
	"emergency_contact_email" TEXT NULL  ,
	"emergency_contact_address" TEXT NULL  ,
	"Status" TEXT NULL DEFAULT 'Active' ,
	"annual_leave_balance" TEXT NULL DEFAULT '0.00' ,
	"sick_leave_balance" TEXT NULL DEFAULT '0.00' ,
	"personal_leave_balance" TEXT NULL DEFAULT '0.00' ,
	"leave_cycle_start_date" TEXT NULL  ,
	"leave_cycle_end_date" TEXT NULL  ,
	"last_performance_review_date" TEXT NULL  ,
	"next_performance_review_date" TEXT NULL  ,
	"performance_rating" TEXT NULL  ,
	"performance_notes" TEXT NULL  ,
	"remember_token" TEXT NULL  ,
	"created_at" TEXT NULL  ,
	"updated_at" TEXT NULL  ,
	"last_active_at" TEXT NULL  ,
	"deactivated_at" TEXT NULL  ,
	"deactivated_by" TEXT NULL  ,
	"created_by" TEXT NULL  ,
	"updated_by" TEXT NULL  ,
	"notes" TEXT NULL  ,
	"preferences" TEXT NULL,
	FOREIGN KEY("PrimaryStationID") REFERENCES "Stations" ("StationID") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("supervisor_id") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("created_by") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("updated_by") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY("deactivated_by") REFERENCES "users" ("id") ON UPDATE CASCADE ON DELETE SET NULL
) STRICT ;





----
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('301','Executive Office','EXO',NULL,'2701','Executive leadership and strategic management','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('302','Operations','OPS','301','2702','Oversees all operational aspects of fuel stations','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('303','Finance','FIN','301','2703','Manages financial planning, accounting, and reporting','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('304','Human Resources','HR','301','2704','Manages recruitment, training, and employee relations','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('305','Health, Safety & Environment','HSE','301','2724','Ensures HSE compliance','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('306','Central Region','CEN','302','2704','Operations in the Central region','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('307','Eastern Region','EST','302','2705','Operations in the Eastern region','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('308','Western Region','WST','302','2706','Operations in the Western region','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('309','Retail Operations','RET','302','2702','Manages retail fuel sales and convenience stores','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('310','Maintenance','MNT','302','2721','Responsible for equipment maintenance and repairs','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('311','Quality Control','QC','302','2724','Ensures fuel quality standards','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('312','Supply Chain','SCM','302','2702','Manages fuel procurement and logistics','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('313','Accounting','ACC','303','2703','Handles day‑to‑day accounting and bookkeeping','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2703',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('314','Treasury','TRS','303','2703','Manages cash flow and banking relationships','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2703',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('315','Tax','TAX','303','2703','Ensures tax compliance and optimisation','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2703',NULL);
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('328','hjshhshhsh','hjshshh','305',NULL,'shhssh','1','2025-05-07 20:38:36','2025-05-07 20:38:36','5','5');
INSERT INTO "Departments" ("DepartmentID","DepartmentName","DepartmentCode","ParentDepartmentID","ManagerUserID","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('330','3882288','3882288','302',NULL,'jssjshhshshshs','1','2025-05-07 20:48:46','2025-05-07 20:48:46','5','5');







INSERT INTO "InventoryHistory" ("HistoryID","StationID","ProductID","TankID","PumpID","TransactionID","TransferID","ChangeDate","ChangeType","PreviousQuantity","QuantityChange","NewQuantity","UnitPrice","TotalValue","ReasonForChange","AdjustmentCategory","BatchNumber","ExpiryDate","QualityCheck","MeasurementMethod","MeasurementDetails","AuthorizedBy","RecordedBy","VerifiedBy","Notes","AdditionalProperties","CreatedAt") VALUES ('1','503','610',NULL,NULL,NULL,NULL,'2025-05-10 23:21:52','Other','0','999','999',NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'5',NULL,'Initial product assignment',NULL,'2025-05-11 02:21:52');
INSERT INTO "InventoryHistory" ("HistoryID","StationID","ProductID","TankID","PumpID","TransactionID","TransferID","ChangeDate","ChangeType","PreviousQuantity","QuantityChange","NewQuantity","UnitPrice","TotalValue","ReasonForChange","AdjustmentCategory","BatchNumber","ExpiryDate","QualityCheck","MeasurementMethod","MeasurementDetails","AuthorizedBy","RecordedBy","VerifiedBy","Notes","AdditionalProperties","CreatedAt") VALUES ('2','508','614',NULL,NULL,NULL,NULL,'2025-05-10 23:25:39','Other','0','99','99',NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'5',NULL,'Initial product assignment',NULL,'2025-05-11 02:25:39');
INSERT INTO "InventoryHistory" ("HistoryID","StationID","ProductID","TankID","PumpID","TransactionID","TransferID","ChangeDate","ChangeType","PreviousQuantity","QuantityChange","NewQuantity","UnitPrice","TotalValue","ReasonForChange","AdjustmentCategory","BatchNumber","ExpiryDate","QualityCheck","MeasurementMethod","MeasurementDetails","AuthorizedBy","RecordedBy","VerifiedBy","Notes","AdditionalProperties","CreatedAt") VALUES ('3','505','606',NULL,NULL,NULL,NULL,'2025-05-10 23:35:30','Other','0','3','3',NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'5',NULL,'Initial product assignment',NULL,'2025-05-11 02:35:30');
INSERT INTO "InventoryHistory" ("HistoryID","StationID","ProductID","TankID","PumpID","TransactionID","TransferID","ChangeDate","ChangeType","PreviousQuantity","QuantityChange","NewQuantity","UnitPrice","TotalValue","ReasonForChange","AdjustmentCategory","BatchNumber","ExpiryDate","QualityCheck","MeasurementMethod","MeasurementDetails","AuthorizedBy","RecordedBy","VerifiedBy","Notes","AdditionalProperties","CreatedAt") VALUES ('4','504','610',NULL,NULL,NULL,NULL,'2025-05-10 23:38:41','Other','0','3','3',NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'5',NULL,'Initial product assignment',NULL,'2025-05-11 02:38:41');
INSERT INTO "InventoryHistory" ("HistoryID","StationID","ProductID","TankID","PumpID","TransactionID","TransferID","ChangeDate","ChangeType","PreviousQuantity","QuantityChange","NewQuantity","UnitPrice","TotalValue","ReasonForChange","AdjustmentCategory","BatchNumber","ExpiryDate","QualityCheck","MeasurementMethod","MeasurementDetails","AuthorizedBy","RecordedBy","VerifiedBy","Notes","AdditionalProperties","CreatedAt") VALUES ('5','505','612',NULL,NULL,NULL,NULL,'2025-05-10 23:39:27','Other','0','8','8',NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'5',NULL,'Initial product assignment',NULL,'2025-05-11 02:39:27');
INSERT INTO "InventoryHistory" ("HistoryID","StationID","ProductID","TankID","PumpID","TransactionID","TransferID","ChangeDate","ChangeType","PreviousQuantity","QuantityChange","NewQuantity","UnitPrice","TotalValue","ReasonForChange","AdjustmentCategory","BatchNumber","ExpiryDate","QualityCheck","MeasurementMethod","MeasurementDetails","AuthorizedBy","RecordedBy","VerifiedBy","Notes","AdditionalProperties","CreatedAt") VALUES ('6','505','603',NULL,NULL,NULL,NULL,'2025-05-10 23:43:06','Other','0','8','8',NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'5',NULL,'Initial product assignment',NULL,'2025-05-11 02:43:06');
INSERT INTO "InventoryHistory" ("HistoryID","StationID","ProductID","TankID","PumpID","TransactionID","TransferID","ChangeDate","ChangeType","PreviousQuantity","QuantityChange","NewQuantity","UnitPrice","TotalValue","ReasonForChange","AdjustmentCategory","BatchNumber","ExpiryDate","QualityCheck","MeasurementMethod","MeasurementDetails","AuthorizedBy","RecordedBy","VerifiedBy","Notes","AdditionalProperties","CreatedAt") VALUES ('7','501','606',NULL,NULL,NULL,NULL,'2025-05-11 00:19:08','Other','0','5','5',NULL,NULL,NULL,NULL,NULL,NULL,'N/A',NULL,NULL,NULL,'5',NULL,'Initial product assignment',NULL,'2025-05-11 03:19:08');






INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('21','JG-01','Fuel Attendant','350000','425000','500000','1','Entry-level position responsible for dispensing fuel, basic customer service, and maintaining cleanliness of the forecourt area.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('22','JG-02','Cashier','400000','475000','550000','2','Responsible for processing payments, basic accounting, and customer service at the point of sale.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('23','JG-03','Maintenance Technician','450000','550000','650000','3','Responsible for basic maintenance of fuel equipment, pumps, and station facilities.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('24','JG-04','Shift Supervisor','550000','675000','800000','4','Supervises daily operations during assigned shifts, manages staff, and ensures compliance with safety procedures.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('25','JG-05','Forecourt Supervisor','600000','750000','900000','5','Oversees all forecourt operations, including fuel dispensing, equipment maintenance, and safety compliance.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('26','JG-06','Retail Supervisor','650000','800000','950000','6','Manages convenience store operations, inventory, merchandising, and retail staff.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('27','JG-07','Assistant Station Manager','800000','1000000','1200000','7','Assists in overall station management, staff supervision, and operational efficiency.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('28','JG-08','Station Manager','1000000','1250000','1500000','8','Responsible for complete management of a single station, including operations, staff, compliance, and financial performance.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('29','JG-09','Senior Station Manager','1200000','1500000','1800000','9','Manages larger or high-volume stations with additional responsibilities for business development and strategic planning.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('30','JG-10','Area Supervisor','1500000','1850000','2200000','10','Oversees multiple stations within a defined geographic area, ensuring operational standards and performance targets are met.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('31','JG-11','Regional Manager','1800000','2250000','2700000','11','Manages all operations within a region, including business development, compliance, and financial performance.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('32','JG-12','HSE Officer','1000000','1300000','1600000','8','Responsible for health, safety, and environmental compliance across stations.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('33','JG-13','Quality Assurance Specialist','1100000','1400000','1700000','9','Ensures fuel quality standards and testing protocols are maintained across all stations.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('34','JG-14','Maintenance Engineer','1200000','1500000','1800000','9','Specialized role for advanced technical maintenance of fuel systems, tanks, and dispensing equipment.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('35','JG-15','Operations Director','2200000','2750000','3300000','12','Directs all operational aspects of the fuel station network, including strategy, performance, and growth.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('36','JG-16','Finance Director','2300000','2900000','3500000','12','Oversees all financial aspects of the fuel station business, including budgeting, reporting, and financial strategy.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('37','JG-17','Commercial Director','2400000','3000000','3600000','12','Responsible for business development, partnerships, and commercial strategy for the fuel station network.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('38','JG-18','General Manager','3000000','3750000','4500000','13','Overall responsibility for the entire fuel station business, reporting to the board or ownership.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('39','JG-19','Managing Director','3500000','4500000','5500000','14','Executive leadership role with full P&L responsibility and strategic direction of the fuel station business.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('40','JG-20','Chief Executive Officer','4500000','6000000','7500000','15','Highest executive position with ultimate responsibility for company performance, strategy, and stakeholder relations.','1','2025-05-06 23:52:41','2025-05-06 23:52:41',NULL,NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('101','JG-101','Junior Manager','800000','1000000','1200000','7','Entry-level management position with supervisory responsibilities','1','2025-05-07 16:58:37','2025-05-07 16:58:37','100',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('102','JG-102','Senior Technician','600000','750000','900000','5','Experienced technical position responsible for maintenance and operations','1','2025-05-07 16:58:37','2025-05-07 16:58:37','100',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('201','EX-01','Executive Director','6000000','7500000','9000000','15','Top executive positions including CEO, COO, and CFO','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('202','EX-02','Senior Director','5000000','6000000','7000000','14','Senior director positions reporting to executive directors','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('203','EX-03','Director','4000000','4500000','5000000','13','Director-level positions with strategic responsibilities','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('204','MG-01','Senior Manager','3000000','3500000','4000000','12','Senior management positions including regional managers','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('205','MG-02','Manager','2500000','3000000','3500000','11','Management positions including station managers','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('206','MG-03','Assistant Manager','2000000','2250000','2500000','10','Assistant management positions supporting station managers','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('207','SV-01','Senior Supervisor','1800000','2000000','2200000','9','Senior supervisory positions overseeing multiple shifts or areas','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('208','SV-02','Supervisor','1500000','1650000','1800000','8','Supervisory positions responsible for shift operations','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('209','SV-03','Junior Supervisor','1200000','1350000','1500000','7','Entry-level supervisory positions','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('210','TC-01','Senior Technician','1500000','1750000','2000000','8','Senior technical positions requiring specialised skills','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('211','TC-02','Technician','1200000','1350000','1500000','7','Technical positions requiring specialised training','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('212','TC-03','Junior Technician','900000','1050000','1200000','6','Entry-level technical positions','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('213','AD-01','Senior Administrator','1200000','1400000','1600000','7','Senior administrative positions with significant responsibility','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('214','AD-02','Administrator','900000','1050000','1200000','6','Administrative positions supporting operations','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('215','AD-03','Junior Administrator','700000','800000','900000','5','Entry-level administrative positions','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('216','OP-01','Senior Operator','800000','900000','1000000','5','Senior operational positions including senior cashiers and attendants','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('217','OP-02','Operator','600000','700000','800000','4','Operational positions including cashiers and attendants','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('218','OP-03','Junior Operator','400000','450000','500000','3','Entry-level operational positions','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('219','SP-01','Senior Support','500000','550000','600000','3','Senior support positions','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('220','SP-02','Support','400000','425000','450000','2','Support positions including cleaners and security','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('221','SP-03','Junior Support','350000','375000','400000','1','Entry-level support positions','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "JobGrades" ("GradeID","GradeCode","GradeName","MinSalary","MidSalary","MaxSalary","Level","Description","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('228','32653','huahs','323','32333','323345','16','4434','1','2025-05-07 21:40:34','2025-05-07 21:40:34','5','5');


----
-- Data dump for Notifications, a total of 3 rows
----
INSERT INTO "Notifications" ("NotificationID","UserID","StationID","TemplateID","Channel","Type","Title","Message","Payload","Status","Attempts","ScheduledAt","SentAt","CreatedAt","UpdatedAt") VALUES ('1','5',NULL,NULL,'Email','System','shsssshhj','sjhsssshshhshjshjshjs',NULL,'Sent','0',NULL,NULL,'2025-05-08 18:47:33','2025-05-08 18:47:33');
INSERT INTO "Notifications" ("NotificationID","UserID","StationID","TemplateID","Channel","Type","Title","Message","Payload","Status","Attempts","ScheduledAt","SentAt","CreatedAt","UpdatedAt") VALUES ('2','5',NULL,NULL,'Email','System','shsssshhj','sjhsssshshhshjshjshjs',NULL,'Sent','0',NULL,NULL,'2025-05-08 18:48:31','2025-05-08 18:48:31');
INSERT INTO "Notifications" ("NotificationID","UserID","StationID","TemplateID","Channel","Type","Title","Message","Payload","Status","Attempts","ScheduledAt","SentAt","CreatedAt","UpdatedAt") VALUES ('3','5',NULL,NULL,'Email','System','jkkjjkj','sjhsssshshhshjshjshjs',NULL,'Sent','0',NULL,NULL,'2025-05-08 18:49:07','2025-05-08 18:49:07');
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('101','POS-101','Operations Manager','101','101',NULL,'36','Bachelor','Oversees all operational activities across stations',NULL,NULL,NULL,'1','1','2','1','3','1','2025-05-07 16:58:37','2025-05-07 16:58:37','100',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('102','POS-102','Maintenance Supervisor','102','102','101','24','Diploma','Supervises maintenance team and ensures equipment reliability',NULL,NULL,NULL,'1','3','2','1','2','1','2025-05-07 16:58:37','2025-05-07 16:58:37','100',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('401','CEO','Chief Executive Officer','301','201',NULL,'120','Master','Overall responsibility for the entire organisation; reports to Board',NULL,NULL,NULL,'1','1','2','1','10','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('402','COO','Chief Operations Officer','302','201','401','96','Master','Responsible for all operational aspects of the business',NULL,NULL,NULL,'1','1','2','1','9','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('403','CFO','Chief Financial Officer','303','201','401','96','Master','Responsible for all financial aspects of the business',NULL,NULL,NULL,'1','1','2','1','9','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('404','RGM-CEN','Regional Manager – Central','306','204','402','72','Bachelor','Oversees all stations in the Central region',NULL,NULL,NULL,'1','1','2','1','8','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('405','RGM-EST','Regional Manager – Eastern','307','204','402','72','Bachelor','Oversees all stations in the Eastern region',NULL,NULL,NULL,'1','1','2','1','8','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('406','RGM-WST','Regional Manager – Western','308','204','402','72','Bachelor','Oversees all stations in the Western region',NULL,NULL,NULL,'1','1','2','1','8','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('407','STM-KLA','Station Manager – Kampala','306','205','404','60','Bachelor','Manages Kampala station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2704',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('408','STM-ENT','Station Manager – Entebbe Road','306','205','404','60','Bachelor','Manages Entebbe Road station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2704',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('409','STM-JIN','Station Manager – Jinja','307','205','405','60','Bachelor','Manages Jinja station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2705',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('410','STM-MBA','Station Manager – Mbarara','308','205','406','60','Bachelor','Manages Mbarara station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2706',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('411','SFT-KLA','Shift Supervisor – Kampala','306','208','407','36','Diploma','Supervises shift operations at Kampala station',NULL,NULL,NULL,'1','3','2','1','6','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('412','SFT-ENT','Shift Supervisor – Entebbe Road','306','208','408','36','Diploma','Supervises shift operations at Entebbe Road station',NULL,NULL,NULL,'1','3','2','1','6','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2708',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('413','SFT-JIN','Shift Supervisor – Jinja','307','208','409','36','Diploma','Supervises shift operations at Jinja station',NULL,NULL,NULL,'1','3','2','1','6','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2709',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('414','CSR-SNR','Senior Cashier','309','216','411','24','Diploma','Handles cash transactions and supervises junior cashiers',NULL,NULL,NULL,'0','5','2','0','0','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('415','CSR-JNR','Cashier','309','217','414','12','Secondary','Handles cash transactions and customer payments',NULL,NULL,NULL,'0','10','4','0','0','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('416','ATT-SNR','Senior Fuel Attendant','309','216','411','24','Secondary','Dispenses fuel and supervises junior attendants',NULL,NULL,NULL,'0','5','2','0','0','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('417','ATT-JNR','Fuel Attendant','309','217','416','6','Secondary','Dispenses fuel and provides customer service',NULL,NULL,NULL,'0','20','6','0','0','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('418','MNT-ENG','Maintenance Engineer','310','210','402','60','Bachelor','Oversees maintenance of all equipment across stations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('419','MNT-TEC','Maintenance Technician','310','211','418','36','Diploma','Performs maintenance and repairs on station equipment',NULL,NULL,NULL,'0','5','4','0','0','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2721',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('420','HSE-MGR','HSE Manager','305','204','401','72','Bachelor','Oversees health, safety and environmental compliance',NULL,NULL,NULL,'1','1','2','1','8','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('421','HSE-OFF','HSE Officer','305','210','420','48','Bachelor','Ensures HSE compliance at stations',NULL,NULL,NULL,'0','3','4','1','5','1','2025-05-07 18:17:31','2025-05-07 21:00:15','2724',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('422','STM-ENTT','Station Manager – Entebbe Town','306','205','404','60','Bachelor','Manages Entebbe Town station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2704',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('423','STM-MBL','Station Manager – Mbale','307','205','405','60','Bachelor','Manages Mbale station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2705',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('424','STM-FPT','Station Manager – Fort Portal','308','205','406','60','Bachelor','Manages Fort Portal station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2706',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('425','STM-MSK','Station Manager – Masaka','308','205','406','60','Bachelor','Manages Masaka station operations',NULL,NULL,NULL,'1','1','2','1','7','1','2025-05-07 18:17:31','2025-05-07 18:17:31','2706',NULL);
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('140288','63663636','hshhsshjjss','307','30','403','43','Certificate','ddffff','dfff  sdhdhjhd sdhjdhdh  ddd  dddd','dfff  sdhdhjhd sdhjdhdh  ddd  dddd','dfff  sdhdhjhd sdhjdhdh  ddd  dddd','1','1','0','1','1','1','2025-05-07 19:57:57','2025-05-07 19:57:57','5','5');
INSERT INTO "Positions" ("PositionID","PositionCode","PositionTitle","DepartmentID","GradeID","ReportsToPositionID","MinExperience","MinEducation","PositionDescription","Responsibilities","Qualifications","Skills","IsManagement","HeadcountLimit","CurrentHeadcount","IsApprover","ApprovalLevel","IsActive","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('140289','3563563355633365335','mr65656','313','30','420','222',NULL,'2222','3563563355633365335','3563563355633365335','3563563355633365335','0','22','2','0','22','0','2025-05-07 20:02:07','2025-05-13 22:39:59','5','5');


-- Data dump for Products, a total of 18 rows
----
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('6','Fuel','Ayebare Timothy','233','3232','2','22.98','Active','2025-04-30 16:19:57','2025-04-30 16:19:57');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('7','Fuel','Vpower',NULL,'5000','4','50000','Active','2025-05-01 15:09:58','2025-05-01 15:09:58');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('601','Fuel','Petrol','Regular unleaded petrol','4500','18','5000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('602','Fuel','Premium Petrol','High-octane premium unleaded petrol','4800','18','3000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('603','Fuel','Diesel','Regular diesel fuel','4200','18','5000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('604','Fuel','Premium Diesel','Low-sulfur premium diesel','4500','18','3000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('605','Fuel','Kerosene','Kerosene for lighting and cooking','3800','18','2000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('606','Lubricant','Engine Oil 5W-30','Synthetic engine oil for passenger vehicles','35000','18','100','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('607','Lubricant','Engine Oil 10W-40','Semi-synthetic engine oil for commercial vehicles','30000','18','100','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('608','Lubricant','Transmission Fluid','Automatic transmission fluid','28000','18','50','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('609','Lubricant','Brake Fluid','DOT 4 brake fluid','15000','18','50','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('610','Lubricant','Coolant','Engine coolant and antifreeze','12000','18','50','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('611','Gas','LPG 6kg','Liquefied petroleum gas 6kg cylinder','60000','18','20','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('612','Gas','LPG 13kg','Liquefied petroleum gas 13kg cylinder','120000','18','15','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('613','Gas','LPG 45kg','Liquefied petroleum gas 45kg cylinder','380000','18','10','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('614','Other','Car Wash','Full car wash service','15000','18',NULL,'Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('615','Other','Tire Inflation','Tire inflation service','2000','18',NULL,'Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Products" ("ProductID","ProductType","Name","Description","UnitPrice","TaxRate","ReorderLevel","Status","CreatedAt","UpdatedAt") VALUES ('616','Other','Battery Water','Distilled water for batteries','5000','18','20','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');



----
-- Data dump for Pumps, a total of 22 rows
----
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('801','501','701','Petrol Pump 1','125678.45','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('802','501','701','Petrol Pump 2','98765.32','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('803','501','702','Premium Petrol Pump','45678.9','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('804','501','703','Diesel Pump 1','156789.23','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('805','501','703','Diesel Pump 2','134567.87','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('806','501','704','Premium Diesel Pump','34567.89','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('807','501','705','Kerosene Pump','23456.78','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('808','502','706','Petrol Pump 1','87654.32','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('809','502','706','Petrol Pump 2','76543.21','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('810','502','707','Diesel Pump 1','98765.43','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('811','502','707','Diesel Pump 2','87654.32','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('812','502','708','Kerosene Pump','12345.67','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('813','505','709','Petrol Pump 1','65432.1','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('814','505','709','Petrol Pump 2','54321.09','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('815','505','710','Diesel Pump 1','76543.21','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('816','505','710','Diesel Pump 2','65432.1','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('817','505','711','Kerosene Pump','9876.54','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('818','507','712','Petrol Pump 1','54321.09','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('819','507','712','Petrol Pump 2','43210.98','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('820','507','713','Diesel Pump 1','65432.1','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('821','507','713','Diesel Pump 2','54321.09','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Pumps" ("PumpID","StationID","TankID","PumpName","MeterReading","Status","CreatedAt","UpdatedAt") VALUES ('822','507','714','Kerosene Pump','8765.43','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');

----



----
-- Data dump for Roles, a total of 26 rows
----
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('1','System Administrator','Full system access with ability to manage all aspects of the system including users, roles, and configurations','1','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('2','General Manager','Overall management of the entire fuel station network with access to all reports and dashboards','1','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('3','Operations Manager','Manages day-to-day operations across all stations, including staff scheduling and operational issues','0','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('4','Finance Manager','Oversees all financial aspects including sales, expenses, payroll, and financial reporting','0','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('5','Station Manager','Manages a specific station including staff, inventory, and local operations','0','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('6','Assistant Station Manager','Assists the station manager in daily operations and can act in their absence','0','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('7','Shift Supervisor','Oversees operations during a specific shift, manages cashiers and attendants','0','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('8','Fuel Attendant','Operates fuel pumps, assists customers with fueling, and basic customer service','0','2025-05-07 20:58:56','2025-05-07 20:58:56',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('9','Cashier','Handles payments, operates POS system, and basic customer service','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('10','Customer Service Representative','Handles customer inquiries, complaints, and loyalty programs','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('11','Inventory Manager','Manages fuel and non-fuel inventory, orders, and stock levels','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('12','Maintenance Technician','Handles equipment maintenance, repairs, and facility upkeep','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('13','Quality Control Officer','Ensures fuel quality standards and compliance with regulations','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('14','Safety Officer','Oversees safety protocols, training, and emergency procedures','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('15','HR Manager','Manages human resources including hiring, training, and employee relations','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('16','Accountant','Handles bookkeeping, financial records, and tax compliance','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('17','Procurement Officer','Manages purchasing, vendor relationships, and supply chain','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('18','Marketing Coordinator','Handles promotions, advertising, and customer engagement strategies','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('19','IT Support','Provides technical support for systems, hardware, and software','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('20','Compliance Officer','Ensures adherence to regulatory requirements and industry standards','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('21','Internal Auditor','Conducts internal audits of operations, finances, and compliance','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('22','Environmental Compliance Officer','Monitors and ensures compliance with environmental regulations','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('23','Store Manager','Manages the convenience store operations, inventory, and staff','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('24','Store Clerk','Handles store sales, stocking, and customer service','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('25','Report Viewer','Read-only access to reports and dashboards','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);
INSERT INTO "Roles" ("RoleID","RoleName","Description","IsSystem","CreatedAt","UpdatedAt","CreatedBy") VALUES ('26','Auditor','External auditor with read-only access to financial and operational data','0','2025-05-07 20:58:57','2025-05-07 20:58:57',NULL);



----
-- Data dump for StationInventory, a total of 7 rows
----
INSERT INTO "StationInventory" ("InventoryID","StationID","ProductID","CurrentStock","LastUpdated") VALUES ('6','503','610','999','2025-05-10 23:21:52');
INSERT INTO "StationInventory" ("InventoryID","StationID","ProductID","CurrentStock","LastUpdated") VALUES ('7','508','614','99','2025-05-10 23:25:39');
INSERT INTO "StationInventory" ("InventoryID","StationID","ProductID","CurrentStock","LastUpdated") VALUES ('8','505','606','3','2025-05-10 23:35:30');
INSERT INTO "StationInventory" ("InventoryID","StationID","ProductID","CurrentStock","LastUpdated") VALUES ('9','504','610','3','2025-05-10 23:38:41');
INSERT INTO "StationInventory" ("InventoryID","StationID","ProductID","CurrentStock","LastUpdated") VALUES ('10','505','612','8','2025-05-10 23:39:27');
INSERT INTO "StationInventory" ("InventoryID","StationID","ProductID","CurrentStock","LastUpdated") VALUES ('11','505','603','8','2025-05-10 23:43:06');
INSERT INTO "StationInventory" ("InventoryID","StationID","ProductID","CurrentStock","LastUpdated") VALUES ('12','501','606','5','2025-05-11 00:19:08');




----
-- Data dump for Stations, a total of 13 rows
----
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('4','Shell Ntugamo','Ntungamo','256256565','4','2024-08-14','Active','2025-05-01 17:55:16','2025-05-01 17:55:16');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('101','Kigrama Central','Kampala Central','+256700123456','100','2025-05-07','Active','2025-05-07 16:58:37','2025-05-07 16:58:37');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('501','Kigrama Kampala Central','Plot 123, Kampala Road, Kampala','+256700555001','2707','2019-01-15','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('502','Kigrama Entebbe Road','Plot 45, Entebbe Road, Kampala','+256700555002','2708','2019-03-20','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('503','Kigrama Entebbe Town','Plot 78, Main Street, Entebbe','+256700555003','2708','2019-05-25','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('504','Kigrama Jinja Road','Plot 112, Jinja Road, Kampala','+256700555004','2709','2019-07-10','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('505','Kigrama Jinja Town','Plot 34, Main Street, Jinja','+256700555005','2709','2019-09-15','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('506','Kigrama Moroto','Plot 12, Moroto Road, Moroto','+256700555010','2709','2019-10-01','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('507','Kigrama Mbarara','Plot 89, High Street, Mbarara','+256700555007','2710','2020-01-25','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('508','Kigrama Fort Portal','Plot 23, Kasese Road, Fort Portal','+256700555008','2710','2020-03-30','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('509','Kigrama Masaka','Plot 67, Kampala Road, Masaka','+256700555009','2710','2020-06-05','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('510','Kigrama Mbale','Plot 56, Cathedral Avenue, Mbale','+256700555006','2709','2019-11-20','Active','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Stations" ("StationID","StationName","Location","ContactPhone","ManagerUserID","OpeningDate","Status","CreatedAt","UpdatedAt") VALUES ('511','Shell Ntugamo3','Shell Ntugamo4','545455544','2713','2025-05-11','Active','2025-05-10 17:06:38','2025-05-10 17:06:38');



-- Data dump for Tanks, a total of 14 rows
----
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('701','501','601','Petrol Tank 1','50000','35000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('702','501','602','Premium Petrol Tank','30000','20000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('703','501','603','Diesel Tank 1','50000','40000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('704','501','604','Premium Diesel Tank','30000','25000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('705','501','605','Kerosene Tank','20000','15000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('706','502','601','Petrol Tank 1','40000','30000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('707','502','603','Diesel Tank 1','40000','35000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('708','502','605','Kerosene Tank','15000','10000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('709','505','601','Petrol Tank 1','40000','25000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('710','505','603','Diesel Tank 1','40000','30000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('711','505','605','Kerosene Tank','15000','8000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('712','507','601','Petrol Tank 1','40000','28000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('713','507','603','Diesel Tank 1','40000','32000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');
INSERT INTO "Tanks" ("TankID","StationID","ProductID","TankName","Capacity","CurrentLevel","Status","LastFilledDate","CreatedAt","UpdatedAt") VALUES ('714','507','605','Kerosene Tank','15000','9000','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2025-05-07 18:17:31');


INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('1','VAT-STD','Value Added Tax - Standard Rate','VAT','Percentage','18',NULL,'URA','Standard VAT rate applicable to most goods and services in Uganda','Monthly','15','VAT Act Cap 349','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('2','VAT-ZERO','Value Added Tax - Zero Rated','VAT','Percentage','0',NULL,'URA','Zero-rated VAT items as specified in the VAT Act','Monthly','15','VAT Act Cap 349','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('3','VAT-EXEMPT','Value Added Tax - Exempt','VAT','Percentage','0',NULL,'URA','VAT exempt items as specified in the VAT Act','Monthly','15','VAT Act Cap 349','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('4','CIT','Corporate Income Tax','Income','Percentage','30',NULL,'URA','Standard corporate income tax for resident companies','Annual','180','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('5','CIT-PROV','Corporate Income Tax - Provisional','Income','Percentage','30',NULL,'URA','Quarterly provisional corporate income tax payments','Quarterly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('6','WHT-DIV-RES','Withholding Tax - Dividends (Resident)','Withholding','Percentage','15',NULL,'URA','Withholding tax on dividend payments to residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('7','WHT-DIV-NRES','Withholding Tax - Dividends (Non-Resident)','Withholding','Percentage','15',NULL,'URA','Withholding tax on dividend payments to non-residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('8','WHT-INT-RES','Withholding Tax - Interest (Resident)','Withholding','Percentage','15',NULL,'URA','Withholding tax on interest payments to residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('9','WHT-INT-NRES','Withholding Tax - Interest (Non-Resident)','Withholding','Percentage','15',NULL,'URA','Withholding tax on interest payments to non-residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('10','WHT-SERV-RES','Withholding Tax - Services (Resident)','Withholding','Percentage','6',NULL,'URA','Withholding tax on payments for services to residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('11','WHT-SERV-NRES','Withholding Tax - Services (Non-Resident)','Withholding','Percentage','15',NULL,'URA','Withholding tax on payments for services to non-residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('12','WHT-RENT-RES','Withholding Tax - Rent (Resident)','Withholding','Percentage','10',NULL,'URA','Withholding tax on rental payments to residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('13','WHT-RENT-NRES','Withholding Tax - Rent (Non-Resident)','Withholding','Percentage','15',NULL,'URA','Withholding tax on rental payments to non-residents','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('14','WHT-MGMT','Withholding Tax - Management Fees','Withholding','Percentage','15',NULL,'URA','Withholding tax on management fees','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('15','PAYE-TIER1','PAYE - First Tier (0-235,000 UGX)','PAYE','Percentage','0',NULL,'URA','Pay As You Earn tax on monthly income up to UGX 235,000','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('16','PAYE-TIER2','PAYE - Second Tier (235,001-335,000 UGX)','PAYE','Percentage','10',NULL,'URA','Pay As You Earn tax on monthly income from UGX 235,001 to UGX 335,000','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('17','PAYE-TIER3','PAYE - Third Tier (335,001-410,000 UGX)','PAYE','Percentage','20',NULL,'URA','Pay As You Earn tax on monthly income from UGX 335,001 to UGX 410,000','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('18','PAYE-TIER4','PAYE - Fourth Tier (Above 410,000 UGX)','PAYE','Percentage','30',NULL,'URA','Pay As You Earn tax on monthly income above UGX 410,000','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('19','PAYE-TIER5','PAYE - Fifth Tier (Above 10,000,000 UGX)','PAYE','Percentage','10',NULL,'URA','Additional Pay As You Earn tax on monthly income above UGX 10,000,000','Monthly','15','Income Tax Act Cap 340','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('20','NSSF-EMP','NSSF - Employer Contribution','Other','Percentage','10',NULL,'URA','National Social Security Fund employer contribution','Monthly','15','NSSF Act Cap 222','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('21','NSSF-EE','NSSF - Employee Contribution','Other','Percentage','5',NULL,'URA','National Social Security Fund employee contribution','Monthly','15','NSSF Act Cap 222','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('22','EXC-PETROL','Excise Duty - Petrol','Excise','Fixed Amount','1350','Per Liter','URA','Excise duty on petrol (UGX per liter)','Monthly','15','Excise Duty Act 2014','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('23','EXC-DIESEL','Excise Duty - Diesel','Excise','Fixed Amount','1030','Per Liter','URA','Excise duty on diesel (UGX per liter)','Monthly','15','Excise Duty Act 2014','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('24','EXC-KEROSENE','Excise Duty - Kerosene','Excise','Fixed Amount','200','Per Liter','URA','Excise duty on kerosene (UGX per liter)','Monthly','15','Excise Duty Act 2014','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('25','LST-TIER1','Local Service Tax - Tier 1 (Below 100,000 UGX)','Local','Fixed Amount','5000','Per Month','Local Government','Local service tax for monthly income below UGX 100,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('26','LST-TIER2','Local Service Tax - Tier 2 (100,000-200,000 UGX)','Local','Fixed Amount','10000','Per Month','Local Government','Local service tax for monthly income from UGX 100,000 to UGX 200,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('27','LST-TIER3','Local Service Tax - Tier 3 (200,000-300,000 UGX)','Local','Fixed Amount','20000','Per Month','Local Government','Local service tax for monthly income from UGX 200,000 to UGX 300,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('28','LST-TIER4','Local Service Tax - Tier 4 (300,000-400,000 UGX)','Local','Fixed Amount','30000','Per Month','Local Government','Local service tax for monthly income from UGX 300,000 to UGX 400,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('29','LST-TIER5','Local Service Tax - Tier 5 (400,000-500,000 UGX)','Local','Fixed Amount','40000','Per Month','Local Government','Local service tax for monthly income from UGX 400,000 to UGX 500,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('30','LST-TIER6','Local Service Tax - Tier 6 (500,000-600,000 UGX)','Local','Fixed Amount','60000','Per Month','Local Government','Local service tax for monthly income from UGX 500,000 to UGX 600,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('31','LST-TIER7','Local Service Tax - Tier 7 (600,000-700,000 UGX)','Local','Fixed Amount','70000','Per Month','Local Government','Local service tax for monthly income from UGX 600,000 to UGX 700,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('32','LST-TIER8','Local Service Tax - Tier 8 (700,000-800,000 UGX)','Local','Fixed Amount','80000','Per Month','Local Government','Local service tax for monthly income from UGX 700,000 to UGX 800,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('33','LST-TIER9','Local Service Tax - Tier 9 (800,000-900,000 UGX)','Local','Fixed Amount','90000','Per Month','Local Government','Local service tax for monthly income from UGX 800,000 to UGX 900,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('34','LST-TIER10','Local Service Tax - Tier 10 (Above 900,000 UGX)','Local','Fixed Amount','100000','Per Month','Local Government','Local service tax for monthly income above UGX 900,000','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('35','PROP-TAX','Property Tax','Property','Percentage','0',NULL,'Local Government','Property tax on business premises (rates vary by location)','Annual','90','Local Governments Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('36','STAMP-DUTY','Stamp Duty','Other','Percentage','1.5',NULL,'URA','Stamp duty on legal documents and agreements','Other',NULL,'Stamps Act Cap 342','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('37','CUST-DUTY','Customs Duty','Customs','Percentage','0',NULL,'URA','Import duty on goods (rates vary by product category)','Other',NULL,'East African Community Customs Management Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('38','INFRA-LEVY','Infrastructure Levy','Excise','Fixed Amount','100','Per Liter','URA','Levy on fuel for infrastructure development','Monthly','15','Finance Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');
INSERT INTO "TaxTypes" ("TaxTypeID","TaxCode","TaxName","TaxCategory","RateType","DefaultRate","RateUnit","TaxAuthority","Description","FilingFrequency","DueDays","LegalReference","EffectiveFrom","EffectiveTo","IsActive","CreatedAt","UpdatedAt") VALUES ('39','ENV-LEVY','Environmental Levy','Other','Percentage','0.5',NULL,'URA','Environmental levy on specific products','Monthly','15','Finance Act','2023-07-01',NULL,'1','2025-05-04 21:21:27','2025-05-04 21:21:27');

----
-- Data dump for UserPositions, a total of 33 rows
----
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('100','101','2025-05-07',NULL,'1','0','101',NULL,'Active','2025-05-07 16:58:37','2025-05-07 16:58:37','101',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('101','102','2025-05-07',NULL,'1','0','101','100','Active','2025-05-07 16:58:37','2025-05-07 16:58:37','100',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2701','401','2018-01-15',NULL,'1','0',NULL,NULL,'Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2702','402','2018-02-10',NULL,'1','0',NULL,'2701','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2703','403','2018-03-01',NULL,'1','0',NULL,'2701','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2704','404','2018-04-15',NULL,'1','0',NULL,'2702','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2705','405','2018-05-20',NULL,'1','0',NULL,'2702','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2706','406','2018-06-10',NULL,'1','0',NULL,'2702','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2707','407','2019-01-27',NULL,'1','0','501','2704','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2704',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2708','408','2019-02-15',NULL,'1','0','502','2704','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2704',NULL);

INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2709','409','2019-03-20',NULL,'1','0','505','2705','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2705',NULL);

INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2710','410','2019-04-25',NULL,'1','0','507','2706','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2706',NULL);

INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2711','411','2019-05-15',NULL,'1','0','501','2707','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2712','412','2019-06-20',NULL,'1','0','502','2708','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2708',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2713','413','2019-07-25',NULL,'1','0','505','2709','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2709',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2714','414','2020-01-27',NULL,'1','0','501','2711','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2715','415','2020-02-15',NULL,'1','0','501','2714','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2716','415','2020-03-20',NULL,'1','0','502','2712','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2708',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2717','416','2020-04-25',NULL,'1','0','501','2711','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2718','417','2020-05-15',NULL,'1','0','501','2717','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2707',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2719','417','2020-06-20',NULL,'1','0','502','2712','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2708',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2720','417','2020-07-25',NULL,'1','0','505','2713','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2709',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2721','418','2019-08-27',NULL,'1','0',NULL,'2702','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2702',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2722','419','2019-09-15',NULL,'1','0','501','2721','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2721',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2723','419','2019-10-20',NULL,'1','0','502','2721','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2721',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2724','420','2019-11-25',NULL,'1','0',NULL,'2701','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2701',NULL);
INSERT INTO "UserPositions" ("UserID","PositionID","StartDate","EndDate","IsPrimary","IsActing","StationID","SupervisorUserID","Status","CreatedAt","UpdatedAt","CreatedBy","UpdatedBy") VALUES ('2725','421','2020-01-15',NULL,'1','0',NULL,'2724','Active','2025-05-07 18:17:31','2025-05-07 18:17:31','2724',NULL);



INSERT INTO "UserRoles" ("UserID","RoleID","AssignedDate","AssignedBy","IsActive") VALUES ('2701','8','2025-05-07 17:59:09','5','1');
INSERT INTO "UserRoles" ("UserID","RoleID","AssignedDate","AssignedBy","IsActive") VALUES ('2707','20','2025-05-07 19:53:57','5','1');



INSERT INTO "UserStations" ("UserID","StationID","IsPrimary","AssignedDate","EndDate","AssignedBy","Status","Notes","CreatedAt","UpdatedAt") VALUES ('2713','505','0','2025-05-10',NULL,NULL,'Active',NULL,'2025-05-10 17:54:43','2025-05-10 17:54:43');
INSERT INTO "UserStations" ("UserID","StationID","IsPrimary","AssignedDate","EndDate","AssignedBy","Status","Notes","CreatedAt","UpdatedAt") VALUES ('2724','510','0','2025-05-13',NULL,NULL,'Active',NULL,'2025-05-10 17:59:25','2025-05-10 17:59:25');



----
-- Data dump for notification_categories, a total of 3 rows
----
INSERT INTO "notification_categories" ("CategoryID","CategoryName","Description","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('1','System','System notifications','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');
INSERT INTO "notification_categories" ("CategoryID","CategoryName","Description","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('2','User','User-related notifications','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');
INSERT INTO "notification_categories" ("CategoryID","CategoryName","Description","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('3','Station','Station-related notifications','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');



----
-- Data dump for notification_channels, a total of 3 rows
----
INSERT INTO "notification_channels" ("ChannelID","ChannelName","ChannelCode","Description","IsActive","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('1','Email','EMAIL','Email notifications','1','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');
INSERT INTO "notification_channels" ("ChannelID","ChannelName","ChannelCode","Description","IsActive","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('2','SMS','SMS','SMS notifications','1','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');
INSERT INTO "notification_channels" ("ChannelID","ChannelName","ChannelCode","Description","IsActive","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('3','In-App','INAPP','In-app notifications','1','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');



----
-- Data dump for notification_events, a total of 3 rows
----
INSERT INTO "notification_events" ("EventID","EventName","EventCode","CategoryID","Description","IsActive","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('1','User Registration','USER_REGISTRATION','2','Sent when a new user is registered','1','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');
INSERT INTO "notification_events" ("EventID","EventName","EventCode","CategoryID","Description","IsActive","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('2','Password Reset','PASSWORD_RESET','2','Sent when a user requests a password reset','1','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');
INSERT INTO "notification_events" ("EventID","EventName","EventCode","CategoryID","Description","IsActive","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('3','System Maintenance','SYSTEM_MAINTENANCE','1','Sent when system maintenance is scheduled','1','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');


INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('1','EmailFromName','Kigrama Fuel System','Name displayed as the sender of emails','1','2025-05-07 22:20:45');
INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('2','EmailFromAddress','noreply@kigrama.com','Email address used to send notifications','1','2025-05-07 22:20:45');
INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('3','EmailReplyToAddress','support@kigrama.com','Email address for recipients to reply to','1','2025-05-07 22:20:45');
INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('4','DefaultNotificationChannel','1','Default channel for sending notifications','1','2025-05-07 22:20:45');
INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('5','NotificationBatchSize','50','Number of notifications to process in a batch','1','2025-05-07 22:20:45');
INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('6','MaxDailyNotificationsPerUser','20','Maximum notifications per user per day (0 = unlimited)','1','2025-05-07 22:20:45');
INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('7','NotificationRetentionDays','90','Number of days to keep notification logs','1','2025-05-07 22:20:45');
INSERT INTO "notification_settings" ("SettingID","SettingName","SettingValue","Description","UpdatedBy","UpdatedAt") VALUES ('8','EnableNotificationQueue','1','Process notifications in background queue','1','2025-05-07 22:20:45');


INSERT INTO "notification_templates" ("TemplateID","TemplateName","Subject","EventID","ChannelID","TemplateContent","Description","IsActive","UsageCount","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('1','Welcome Email','Welcome to Kigrama Fuel System','1','1','# Welcome to Kigrama Fuel System

Dear {{user.name}},

Thank you for registering with Kigrama Fuel System. Your account has been created successfully.

You can now log in to the system using your credentials.

Thank you,
Kigrama Fuel System Team','Welcome email sent to new users','1','0','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');
INSERT INTO "notification_templates" ("TemplateID","TemplateName","Subject","EventID","ChannelID","TemplateContent","Description","IsActive","UsageCount","CreatedBy","CreatedAt","UpdatedBy","UpdatedAt") VALUES ('2','Password Reset Email','Password Reset Request','2','1','# Password Reset Request

Dear {{user.name}},

We received a request to reset your password. If you did not make this request, please ignore this email.

To reset your password, please click the link below:

[Reset Password]({{system.url}}/reset-password?token={{token}})

This link will expire in 24 hours.

Thank you,
Kigrama Fuel System Team','Email sent when a user requests a password reset','1','0','1','2025-05-07 22:20:45','1','2025-05-07 22:20:45');



INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('4','Wycliffee Mutungi',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Uganda','vexa257@gmail.com',NULL,'Email',NULL,'$2y$12$rOw4SJmUlNngqq09dXeyWeohEURSx2Katv5PKHgvQieX5Qn57Dg.a','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,'1',NULL,NULL,'0786190179',NULL,NULL,NULL,'Admin','Manager',NULL,NULL,NULL,NULL,'Finace','2024-04-17',NULL,NULL,NULL,NULL,NULL,'356356','Monthly',NULL,'5635',NULL,'Bank Transfer','Wycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee Mutungi',NULL,NULL,NULL,NULL,NULL,NULL,'Wycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee MutungiWycliffee Mutungi',NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-01 14:52:24','2025-05-01 14:52:24',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('5','Ayebare Timothy',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Uganda','a.vexa256@gmail.com',NULL,'Email',NULL,'$2y$12$nB59ihuV2PEsmaUBuQkyBuntiA4feMglM7NLjKdGLOr6rNqo7qFUW','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Monthly',NULL,NULL,NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,'JSoVjqQKU5er3Ae4zWPoMaSGhC28Hphn0CBrYWcwO4QvMDSMP0imjsmrxXw3','2025-05-06 17:08:48','2025-05-06 17:08:48',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('100','John Smith',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Uganda','john.smith@kigrama.com',NULL,'Email',NULL,'$2y$12$abcdefghijklmnopqrstuvwxyz123456789','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Manager',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Monthly',NULL,NULL,NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 16:58:37','2025-05-07 16:58:37',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('101','Jane Doe',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Uganda','jane.doe@kigrama.com',NULL,'Email',NULL,'$2y$12$abcdefghijklmnopqrstuvwxyz987654321','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Monthly',NULL,NULL,NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 16:58:37','2025-05-07 16:58:37',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2701','David Mukasa','David','Mukasa',NULL,NULL,NULL,'1975-06-15','Male',NULL,'Plot 45, Nakasero Road','Kampala',NULL,NULL,'Uganda','david.mukasa@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234001',NULL,NULL,NULL,'Admin',NULL,'Chief Executive Officer',NULL,NULL,NULL,NULL,'2018-01-15',NULL,NULL,NULL,NULL,NULL,'7500000','Monthly',NULL,'TIN27012345',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2702','Sarah Namukwaya','Sarah','Namukwaya',NULL,NULL,NULL,'1978-03-22','Female',NULL,'Plot 78, Kololo Hill Drive','Kampala',NULL,NULL,'Uganda','sarah.namukwaya@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234002',NULL,NULL,NULL,'Admin',NULL,'Chief Operations Officer',NULL,NULL,NULL,NULL,'2018-02-10',NULL,NULL,NULL,NULL,NULL,'6500000','Monthly',NULL,'TIN27012346',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2703','Robert Ochieng','Robert','Ochieng',NULL,NULL,NULL,'1980-11-05','Male',NULL,'Plot 112, Bukoto Street','Kampala',NULL,NULL,'Uganda','robert.ochieng@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234003',NULL,NULL,NULL,'Admin',NULL,'Chief Financial Officer',NULL,NULL,NULL,NULL,'2018-03-01',NULL,NULL,NULL,NULL,NULL,'6500000','Monthly',NULL,'TIN27012347',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2704','Patricia Akello','Patricia','Akello',NULL,NULL,NULL,'1982-07-18','Female',NULL,'Plot 34, Ntinda Road','Kampala',NULL,NULL,'Uganda','patricia.akello@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234004',NULL,NULL,NULL,'Manager',NULL,'Regional Manager – Central',NULL,NULL,NULL,NULL,'2018-04-15',NULL,NULL,NULL,NULL,NULL,'4500000','Monthly',NULL,'TIN27012348',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2705','Michael Tumusiime','Michael','Tumusiime',NULL,NULL,NULL,'1983-09-30','Male',NULL,'Plot 56, Kira Road','Kampala',NULL,NULL,'Uganda','michael.tumusiime@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234005',NULL,NULL,NULL,'Manager',NULL,'Regional Manager – Eastern',NULL,NULL,NULL,NULL,'2018-05-20',NULL,NULL,NULL,NULL,NULL,'4500000','Monthly',NULL,'TIN27012349',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2706','Grace Nabukenya','Grace','Nabukenya',NULL,NULL,NULL,'1984-02-12','Female',NULL,'Plot 23, Jinja Road','Jinja',NULL,NULL,'Uganda','grace.nabukenya@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234006',NULL,NULL,NULL,'Manager',NULL,'Regional Manager – Western',NULL,NULL,NULL,NULL,'2018-06-10',NULL,NULL,NULL,NULL,NULL,'4500000','Monthly',NULL,'TIN27012350',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2707','Daniel Okello','Daniel','Okello',NULL,NULL,NULL,'1985-05-25','Male',NULL,'Plot 67, Main Street','Kampala',NULL,NULL,'Uganda','daniel.okello@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234007',NULL,NULL,NULL,'Manager',NULL,'Station Manager',NULL,NULL,NULL,NULL,'2019-01-27',NULL,NULL,NULL,NULL,NULL,'3000000','Monthly',NULL,'TIN27012351',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2708','Florence Nambi','Florence','Nambi',NULL,NULL,NULL,'1986-08-14','Female',NULL,'Plot 89, Central Avenue','Entebbe',NULL,NULL,'Uganda','florence.nambi@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234008',NULL,NULL,NULL,'Manager',NULL,'Station Manager',NULL,NULL,NULL,NULL,'2019-02-15',NULL,NULL,NULL,NULL,NULL,'3000000','Monthly',NULL,'TIN27012352',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2709','Joseph Mugisha','Joseph','Mugisha',NULL,NULL,NULL,'1984-11-30','Male',NULL,'Plot 45, Mbale Road','Mbale',NULL,NULL,'Uganda','joseph.mugisha@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234009',NULL,NULL,NULL,'Manager',NULL,'Station Manager',NULL,NULL,NULL,NULL,'2019-03-20',NULL,NULL,NULL,NULL,NULL,'3000000','Monthly',NULL,'TIN27012353',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2710','Esther Nakato','Esther','Nakato',NULL,NULL,NULL,'1987-04-17','Female',NULL,'Plot 34, Mbarara Road','Mbarara',NULL,NULL,'Uganda','esther.nakato@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234010',NULL,NULL,NULL,'Manager',NULL,'Station Manager',NULL,NULL,NULL,NULL,'2019-04-25',NULL,NULL,NULL,NULL,NULL,'3000000','Monthly',NULL,'TIN27012354',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2711','Peter Wasswa','Peter','Wasswa',NULL,NULL,NULL,'1988-06-22','Male',NULL,'Plot 12, Nsambya Road','Kampala',NULL,NULL,'Uganda','peter.wasswa@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234011',NULL,NULL,NULL,'Manager',NULL,'Shift Supervisor',NULL,NULL,NULL,NULL,'2019-05-15',NULL,NULL,NULL,NULL,NULL,'1800000','Monthly',NULL,'TIN27012355',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2712','Mary Nantongo','Mary','Nantongo',NULL,NULL,NULL,'1989-09-08','Female',NULL,'Plot 56, Entebbe Road','Entebbe',NULL,NULL,'Uganda','mary.nantongo@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234012',NULL,NULL,NULL,'Manager',NULL,'Shift Supervisor',NULL,NULL,NULL,NULL,'2019-06-20',NULL,NULL,NULL,NULL,NULL,'1800000','Monthly',NULL,'TIN27012356',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2713','James Muwonge','James','Muwonge',NULL,NULL,NULL,'1990-01-14','Male',NULL,'Plot 78, Jinja Road','Jinja',NULL,NULL,'Uganda','james.muwonge@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234013',NULL,NULL,NULL,'Manager',NULL,'Shift Supervisor',NULL,NULL,NULL,NULL,'2019-07-25',NULL,NULL,NULL,NULL,NULL,'1800000','Monthly',NULL,'TIN27012357',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2714','Ruth Namukasa','Ruth','Namukasa',NULL,NULL,NULL,'1991-03-28','Female',NULL,'Plot 23, Bukoto Street','Kampala',NULL,NULL,'Uganda','ruth.namukasa@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234014',NULL,NULL,NULL,'Cashier',NULL,'Senior Cashier',NULL,NULL,NULL,NULL,'2020-01-27',NULL,NULL,NULL,NULL,NULL,'800000','Monthly',NULL,'TIN27012358',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2715','Samuel Kato','Samuel','Kato',NULL,NULL,NULL,'1992-05-17','Male',NULL,'Plot 45, Main Street','Entebbe',NULL,NULL,'Uganda','samuel.kato@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234015',NULL,NULL,NULL,'Cashier',NULL,'Cashier',NULL,NULL,NULL,NULL,'2020-02-15',NULL,NULL,NULL,NULL,NULL,'650000','Monthly',NULL,'TIN27012359',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2716','Janet Nakimuli','Janet','Nakimuli',NULL,NULL,NULL,'1993-07-29','Female',NULL,'Plot 67, Mbale Road','Mbale',NULL,NULL,'Uganda','janet.nakimuli@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234016',NULL,NULL,NULL,'Cashier',NULL,'Cashier',NULL,NULL,NULL,NULL,'2020-03-20',NULL,NULL,NULL,NULL,NULL,'650000','Monthly',NULL,'TIN27012360',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2717','George Ssemakula','George','Ssemakula',NULL,NULL,NULL,'1994-09-12','Male',NULL,'Plot 89, Nsambya Road','Kampala',NULL,NULL,'Uganda','george.ssemakula@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234017',NULL,NULL,NULL,'Attendant',NULL,'Senior Fuel Attendant',NULL,NULL,NULL,NULL,'2020-04-25',NULL,NULL,NULL,NULL,NULL,'600000','Monthly',NULL,'TIN27012361',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2718','Agnes Nabbosa','Agnes','Nabbosa',NULL,NULL,NULL,'1995-11-24','Female',NULL,'Plot 12, Entebbe Road','Entebbe',NULL,NULL,'Uganda','agnes.nabbosa@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234018',NULL,NULL,NULL,'Attendant',NULL,'Fuel Attendant',NULL,NULL,NULL,NULL,'2020-05-15',NULL,NULL,NULL,NULL,NULL,'450000','Monthly',NULL,'TIN27012362',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2719','Richard Mugume','Richard','Mugume',NULL,NULL,NULL,'1996-02-05','Male',NULL,'Plot 34, Jinja Road','Jinja',NULL,NULL,'Uganda','richard.mugume@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234019',NULL,NULL,NULL,'Attendant',NULL,'Fuel Attendant',NULL,NULL,NULL,NULL,'2020-06-20',NULL,NULL,NULL,NULL,NULL,'450000','Monthly',NULL,'TIN27012363',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2720','Catherine Namanda','Catherine','Namanda',NULL,NULL,NULL,'1997-04-18','Female',NULL,'Plot 56, Mbarara Road','Mbarara',NULL,NULL,'Uganda','catherine.namanda@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234020',NULL,NULL,NULL,'Attendant',NULL,'Fuel Attendant',NULL,NULL,NULL,NULL,'2020-07-25',NULL,NULL,NULL,NULL,NULL,'450000','Monthly',NULL,'TIN27012364',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2721','Paul Lubega','Paul','Lubega',NULL,NULL,NULL,'1988-06-30','Male',NULL,'Plot 78, Bukoto Street','Kampala',NULL,NULL,'Uganda','paul.lubega@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234021',NULL,NULL,NULL,'Accountant',NULL,'National Maintenance Engineer',NULL,NULL,NULL,NULL,'2019-08-27',NULL,NULL,NULL,NULL,NULL,'2200000','Monthly',NULL,'TIN27012365',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2722','Irene Nakimuli','Irene','Nakimuli',NULL,NULL,NULL,'1989-08-12','Female',NULL,'Plot 90, Main Street','Kampala',NULL,NULL,'Uganda','irene.nakimuli@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234022',NULL,NULL,NULL,'Accountant',NULL,'National Maintenance Technician',NULL,NULL,NULL,NULL,'2019-09-15',NULL,NULL,NULL,NULL,NULL,'1500000','Monthly',NULL,'TIN27012366',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2723','Mark Ssentongo','Mark','Ssentongo',NULL,NULL,NULL,'1990-07-24','Male',NULL,'Plot 23, Ntinda Road','Kampala',NULL,NULL,'Uganda','mark.ssentongo@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234023',NULL,NULL,NULL,'Accountant',NULL,'National Maintenance Technician',NULL,NULL,NULL,NULL,'2019-10-20',NULL,NULL,NULL,NULL,NULL,'1500000','Monthly',NULL,'TIN27012367',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2724','Diana Namuganza','Diana','Namuganza',NULL,NULL,NULL,'1985-12-05','Female',NULL,'Plot 45, Kololo Hill Drive','Kampala',NULL,NULL,'Uganda','diana.namuganza@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234024',NULL,NULL,NULL,'Admin',NULL,'HSE Manager',NULL,NULL,NULL,NULL,'2019-11-25',NULL,NULL,NULL,NULL,NULL,'2800000','Monthly',NULL,'TIN27012368',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('2725','Timothy Kabuye','Timothy','Kabuye',NULL,NULL,NULL,'1986-02-17','Male',NULL,'Plot 67, Bukoto Street','Kampala',NULL,NULL,'Uganda','timothy.kabuye@kigrama.com',NULL,'Email',NULL,'$2y$12$secure.hash.placeholder','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,'+256701234025',NULL,NULL,NULL,'Admin',NULL,'HSE Officer',NULL,NULL,NULL,NULL,'2020-01-15',NULL,NULL,NULL,NULL,NULL,'1800000','Monthly',NULL,'TIN27012369',NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:17:31','2025-05-07 18:17:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('4782873','Ayebare Timothy2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Uganda','vexsa256@gmail.com',NULL,'Email',NULL,'$2y$12$byoPYfN1DPIr9asWmTm0ee8DG4/Kiyk./8f42wik4RtemLwHRH0Tu','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Monthly',NULL,NULL,NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 18:00:15','2025-05-07 18:00:15',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('4782874','Ayebare Timothy22',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Uganda','atimothy@ecsahc.org2',NULL,'Email',NULL,'$2y$12$IWMpX5k7pJ5murciUaMdMusXagciTu/1g5jjWfSRAR4KAdDC189xy','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Monthly',NULL,NULL,NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-05-07 20:05:32','2025-05-07 20:05:32',NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "users" ("id","name","first_name","last_name","middle_name","display_name","profile_photo_path","date_of_birth","gender","national_id","address","city","state","postal_code","country","email","secondary_email","preferred_contact_method","email_verified_at","password","two_factor_enabled","two_factor_secret","two_factor_recovery_codes","password_changed_at","last_login_at","last_login_ip","failed_login_attempts","locked_until","UserID","employee_id","employment_type","Phone","secondary_phone","work_phone","PrimaryStationID","Role","Position","job_title","supervisor_id","work_schedule","shift_preference","Department","HireDate","probation_end_date","contract_end_date","termination_date","termination_reason","rehire_eligibility","Salary","salary_type","pay_grade","TaxIdentificationNumber","tax_status","payment_method","BankDetails","bank_name","bank_account_number","bank_branch","bank_routing_number","mobile_money_provider","mobile_money_number","EmergencyContact","emergency_contact_name","emergency_contact_relationship","emergency_contact_phone","emergency_contact_email","emergency_contact_address","Status","annual_leave_balance","sick_leave_balance","personal_leave_balance","leave_cycle_start_date","leave_cycle_end_date","last_performance_review_date","next_performance_review_date","performance_rating","performance_notes","remember_token","created_at","updated_at","last_active_at","deactivated_at","deactivated_by","created_by","updated_by","notes","preferences") VALUES ('4782875','Ayebare Timothy',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Uganda','vexa256@gmail.com',NULL,'Email',NULL,'$2y$12$98SXXJi0oqJF0np5V99DD..U4ckioEebuTz18Fq865q.K1aDMvNne','0',NULL,NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Monthly',NULL,NULL,NULL,'Bank Transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active','0','0','0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-06-14 16:59:24','2025-06-14 16:59:24',NULL,NULL,NULL,NULL,NULL,NULL,NULL);

-- 1. Supplier Credit Accounts (Core credit management)
CREATE TABLE SupplierCreditAccounts (
  CreditAccountID INTEGER PRIMARY KEY,
  SupplierID INTEGER UNIQUE NOT NULL REFERENCES Suppliers(SupplierID),
  StationID INTEGER UNIQUE NULL REFERENCES Stations(StationID), -- NULL = Global account
  CreditLimit DECIMAL(15,2) NOT NULL DEFAULT 0,
  CurrentBalance DECIMAL(15,2) NOT NULL DEFAULT 0, -- What we owe them
  AvailableCredit DECIMAL(15,2) NOT NULL DEFAULT 0, -- CreditLimit - CurrentBalance
  PaymentTermsDays INTEGER NOT NULL DEFAULT 30,
  LastPaymentDate DATE NULL,
  LastPaymentAmount DECIMAL(15,2) DEFAULT 0,
  IsActive TEXT DEFAULT '1',
  CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
 
)STRICT;

-- 2. Supplier Invoices (What we owe)
CREATE TABLE SupplierInvoices (
  InvoiceID INTEGER PRIMARY KEY,
  SupplierID INTEGER NOT NULL REFERENCES Suppliers(SupplierID),
  StationID INTEGER NOT NULL REFERENCES Stations(StationID),
  InvoiceNumber TEXT NOT NULL,
  InvoiceDate DATE NOT NULL,
  DueDate DATE NOT NULL,
  TotalAmount DECIMAL(15,2) NOT NULL,
  PaidAmount DECIMAL(15,2) DEFAULT 0,
  OutstandingAmount DECIMAL(15,2) NOT NULL, -- TotalAmount - PaidAmount
  Status TEXT DEFAULT 'Outstanding', -- Outstanding, Paid, Overdue, Disputed
  Description TEXT,
  ReceivedBy INTEGER NOT NULL REFERENCES users(id),
  CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
)STRICT;

-- 3. Supplier Payments (What we've paid)
CREATE TABLE SupplierPayments (
  PaymentID INTEGER PRIMARY KEY,
  SupplierID INTEGER NOT NULL REFERENCES Suppliers(SupplierID),
  StationID INTEGER NULL REFERENCES Stations(StationID),
  PaymentReference TEXT NOT NULL UNIQUE,
  PaymentDate DATE NOT NULL,
  PaymentAmount DECIMAL(15,2) NOT NULL,
  PaymentMethod TEXT NOT NULL, -- Bank Transfer, Check, Cash, Mobile Money
  BankReference TEXT,
  Notes TEXT,
  ProcessedBy INTEGER NOT NULL REFERENCES users(id),
  Status TEXT DEFAULT 'Completed', -- Pending, Completed, Failed, Cancelled
  CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP
)STRICT;

-- 4. Payment Allocations (Which invoices each payment covers)
CREATE TABLE SupplierPaymentAllocations (
  AllocationID INTEGER PRIMARY KEY,
  PaymentID INTEGER NOT NULL REFERENCES SupplierPayments(PaymentID),
  InvoiceID INTEGER NOT NULL REFERENCES SupplierInvoices(InvoiceID),
  AllocatedAmount DECIMAL(15,2) NOT NULL,
  AllocationDate DATE NOT NULL DEFAULT CURRENT_DATE,
  CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(PaymentID) REFERENCES SupplierPayments(PaymentID) ON DELETE CASCADE,
  FOREIGN KEY(InvoiceID) REFERENCES SupplierInvoices(InvoiceID) ON DELETE CASCADE
)STRICT;

-- 5. Credit Transactions Log (Simple audit trail)
CREATE TABLE SupplierCreditTransactions (
  TransactionID INTEGER PRIMARY KEY,
  SupplierID INTEGER NOT NULL REFERENCES Suppliers(SupplierID),
  StationID INTEGER NULL REFERENCES Stations(StationID),
  TransactionType TEXT NOT NULL, -- Invoice, Payment, Credit_Adjustment, Limit_Change
  ReferenceID INTEGER NULL, -- InvoiceID or PaymentID
  Amount DECIMAL(15,2) NOT NULL,
  PreviousBalance DECIMAL(15,2) NOT NULL,
  NewBalance DECIMAL(15,2) NOT NULL,
  Description TEXT,
  CreatedBy INTEGER NOT NULL REFERENCES users(id),
  CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP
)STRICT;
-- Auto-update credit account balance when invoice is created
CREATE TRIGGER update_credit_on_invoice_insert
AFTER INSERT ON SupplierInvoices
BEGIN
  UPDATE SupplierCreditAccounts 
  SET 
    CurrentBalance = CurrentBalance + NEW.TotalAmount,
    AvailableCredit = CreditLimit - (CurrentBalance + NEW.TotalAmount),
    UpdatedAt = CURRENT_TIMESTAMP
  WHERE SupplierID = NEW.SupplierID 
    AND (StationID = NEW.StationID OR StationID IS NULL);
    
  -- Log the transaction
  INSERT INTO SupplierCreditTransactions (
    SupplierID, StationID, TransactionType, ReferenceID, Amount, 
    PreviousBalance, NewBalance, Description, CreatedBy
  ) VALUES (
    NEW.SupplierID, NEW.StationID, 'Invoice', NEW.InvoiceID, NEW.TotalAmount,
    (SELECT CurrentBalance - NEW.TotalAmount FROM SupplierCreditAccounts WHERE SupplierID = NEW.SupplierID),
    (SELECT CurrentBalance FROM SupplierCreditAccounts WHERE SupplierID = NEW.SupplierID),
    'Invoice created: ' || NEW.InvoiceNumber,
    NEW.ReceivedBy
  );
END;

-- Auto-update balances when payment allocation is made
CREATE TRIGGER update_balances_on_allocation
AFTER INSERT ON SupplierPaymentAllocations
BEGIN
  -- Update invoice outstanding amount
  UPDATE SupplierInvoices 
  SET 
    PaidAmount = PaidAmount + NEW.AllocatedAmount,
    OutstandingAmount = TotalAmount - (PaidAmount + NEW.AllocatedAmount),
    Status = CASE 
      WHEN (PaidAmount + NEW.AllocatedAmount) >= TotalAmount THEN 'Paid'
      ELSE 'Outstanding'
    END,
    UpdatedAt = CURRENT_TIMESTAMP
  WHERE InvoiceID = NEW.InvoiceID;
  
  -- Update credit account balance
  UPDATE SupplierCreditAccounts 
  SET 
    CurrentBalance = CurrentBalance - NEW.AllocatedAmount,
    AvailableCredit = CreditLimit - (CurrentBalance - NEW.AllocatedAmount),
    LastPaymentDate = NEW.AllocationDate,
    LastPaymentAmount = NEW.AllocatedAmount,
    UpdatedAt = CURRENT_TIMESTAMP
  WHERE SupplierID = (SELECT SupplierID FROM SupplierInvoices WHERE InvoiceID = NEW.InvoiceID);
END;


-- Supplier Credit Summary View
CREATE VIEW SupplierCreditSummary AS
SELECT 
  s.SupplierID,
  s.Name AS SupplierName,
  st.StationID,
  st.StationName,
  sca.CreditLimit,
  sca.CurrentBalance,
  sca.AvailableCredit,
  sca.PaymentTermsDays,
  sca.LastPaymentDate,
  sca.LastPaymentAmount,
  COUNT(si.InvoiceID) AS OutstandingInvoices,
  CASE 
    WHEN sca.CurrentBalance > sca.CreditLimit THEN 'Over Limit'
    WHEN sca.AvailableCredit < (sca.CreditLimit * 0.1) THEN 'Near Limit'
    ELSE 'Normal'
  END AS CreditStatus
FROM SupplierCreditAccounts sca
JOIN Suppliers s ON sca.SupplierID = s.SupplierID
LEFT JOIN Stations st ON sca.StationID = st.StationID
LEFT JOIN SupplierInvoices si ON sca.SupplierID = si.SupplierID 
  AND si.Status = 'Outstanding'
GROUP BY sca.CreditAccountID;

-- Outstanding Invoices with Aging
CREATE VIEW SupplierOutstandingInvoices AS
SELECT 
  si.*,
  s.Name AS SupplierName,
  st.StationName,
  julianday('now') - julianday(si.DueDate) AS DaysOverdue,
  CASE 
    WHEN julianday('now') - julianday(si.DueDate) <= 0 THEN 'Current'
    WHEN julianday('now') - julianday(si.DueDate) <= 30 THEN '1-30 Days'
    WHEN julianday('now') - julianday(si.DueDate) <= 60 THEN '31-60 Days'
    WHEN julianday('now') - julianday(si.DueDate) <= 90 THEN '61-90 Days'
    ELSE '90+ Days'
  END AS AgingBucket
FROM SupplierInvoices si
JOIN Suppliers s ON si.SupplierID = s.SupplierID
JOIN Stations st ON si.StationID = st.StationID
WHERE si.Status IN ('Outstanding', 'Overdue');


-- 1. Customers Master Table (NEW)
CREATE TABLE "Customers" (
  "CustomerID" INTEGER PRIMARY KEY,
  "CustomerType" TEXT NOT NULL DEFAULT 'Individual', -- Individual, Corporate, Fleet
  "CustomerCode" TEXT NOT NULL UNIQUE,
  "FirstName" TEXT NULL,
  "LastName" TEXT NULL,
  "CompanyName" TEXT NULL,
  "PhoneNumber" TEXT NOT NULL,
  "Email" TEXT NULL,
  "NationalID" TEXT NULL,
  "TaxID" TEXT NULL,
  "Address" TEXT NULL,
  "PrimaryStationID" INTEGER NULL REFERENCES "Stations"("StationID"),
  "RegistrationDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "Status" TEXT NOT NULL DEFAULT 'Active', -- Active, Suspended, Blacklisted
  "CreatedBy" INTEGER NOT NULL REFERENCES "users"("id"),
  "CreatedAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "UpdatedAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT;

-- 2. Customer Credit Accounts (NEW)
CREATE TABLE "CustomerCreditAccounts" (
  "CreditAccountID" INTEGER PRIMARY KEY,
  "CustomerID" INTEGER NOT NULL REFERENCES "Customers"("CustomerID"),
  "StationID" INTEGER NULL REFERENCES "Stations"("StationID"), -- NULL = Global account
  "CreditLimit" TEXT NOT NULL DEFAULT '0.00',
  "CurrentBalance" TEXT NOT NULL DEFAULT '0.00', -- What they owe us
  "AvailableCredit" TEXT NOT NULL DEFAULT '0.00', -- CreditLimit - CurrentBalance
  "PaymentTermsDays" TEXT NOT NULL DEFAULT '30',
  "LastPurchaseDate" TEXT NULL,
  "LastPaymentDate" TEXT NULL,
  "LastPaymentAmount" TEXT DEFAULT '0.00',
  "CreditScore" TEXT DEFAULT '100', -- 0-100 scale based on payment history
  "IsActive" TEXT DEFAULT '1',
  "ApprovedBy" INTEGER NOT NULL REFERENCES "users"("id"),
  "ApprovedDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "CreatedAt" TEXT DEFAULT CURRENT_TIMESTAMP,
  "UpdatedAt" TEXT DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("CustomerID", "StationID")
) STRICT;

-- 3. Customer Credit Payments (NEW)
CREATE TABLE "CustomerCreditPayments" (
  "PaymentID" INTEGER PRIMARY KEY,
  "CustomerID" INTEGER NOT NULL REFERENCES "Customers"("CustomerID"),
  "StationID" INTEGER NOT NULL REFERENCES "Stations"("StationID"),
  "PaymentReference" TEXT NOT NULL UNIQUE,
  "PaymentDate" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "PaymentAmount" TEXT NOT NULL,
  "PaymentMethod" TEXT NOT NULL, -- Cash, Bank Transfer, Mobile Money, Card
  "MobileMoneyReference" TEXT NULL,
  "BankReference" TEXT NULL,
  "AllocatedToTransactions" TEXT DEFAULT '[]', -- JSON array of TransactionIDs
  "Notes" TEXT NULL,
  "ReceivedBy" INTEGER NOT NULL REFERENCES "users"("id"),
  "VerifiedBy" INTEGER NULL REFERENCES "users"("id"),
  "Status" TEXT DEFAULT 'Completed', -- Pending, Completed, Failed
  "CreatedAt" TEXT DEFAULT CURRENT_TIMESTAMP,
  "UpdatedAt" TEXT DEFAULT CURRENT_TIMESTAMP
) STRICT;


-- Add CustomerID column to existing Transactions table
ALTER TABLE "Transactions" ADD COLUMN "CustomerID" INTEGER NULL REFERENCES "Customers"("CustomerID");

-- Add CreditSale flag
ALTER TABLE "Transactions" ADD COLUMN "IsCreditSale" TEXT DEFAULT '0';

-- Add Outstanding Amount for credit tracking
ALTER TABLE "Transactions" ADD COLUMN "OutstandingAmount" TEXT DEFAULT '0.00';

-- Create index for better performance
CREATE INDEX "idx_transactions_customer" ON "Transactions"("CustomerID");
CREATE INDEX "idx_transactions_credit" ON "Transactions"("IsCreditSale", "OutstandingAmount");


-- Create customers from existing ReferenceParty data
INSERT INTO "Customers" (CustomerCode, CompanyName, PhoneNumber, CreatedBy)
SELECT DISTINCT 
  'CUST-' || substr(hex(randomblob(4)), 1, 8) as CustomerCode,
  ReferenceParty as CompanyName,
  'N/A' as PhoneNumber,
  1 as CreatedBy
FROM "Transactions" 
WHERE ReferenceParty IS NOT NULL 
  AND ReferenceParty != '';

-- Update Transactions with CustomerID
UPDATE "Transactions" 
SET CustomerID = (
  SELECT CustomerID 
  FROM "Customers" 
  WHERE CompanyName = "Transactions".ReferenceParty
)
WHERE ReferenceParty IS NOT NULL;

-- Customer Credit Summary
CREATE VIEW "CustomerCreditSummary" AS
SELECT 
  c.CustomerID,
  c.CustomerCode,
  COALESCE(c.CompanyName, c.FirstName || ' ' || c.LastName) AS CustomerName,
  c.PhoneNumber,
  c.Status as CustomerStatus,
  s.StationName,
  cca.CreditLimit,
  cca.CurrentBalance,
  cca.AvailableCredit,
  cca.PaymentTermsDays,
  cca.LastPurchaseDate,
  cca.LastPaymentDate,
  cca.CreditScore,
  COUNT(t.TransactionID) as OutstandingTransactions,
  CASE 
    WHEN CAST(cca.CurrentBalance AS DECIMAL) > CAST(cca.CreditLimit AS DECIMAL) THEN 'Over Limit'
    WHEN CAST(cca.AvailableCredit AS DECIMAL) < (CAST(cca.CreditLimit AS DECIMAL) * 0.1) THEN 'Near Limit'
    ELSE 'Normal'
  END AS CreditStatus
FROM "Customers" c
JOIN "CustomerCreditAccounts" cca ON c.CustomerID = cca.CustomerID
LEFT JOIN "Stations" s ON cca.StationID = s.StationID
LEFT JOIN "Transactions" t ON c.CustomerID = t.CustomerID 
  AND t.IsCreditSale = '1' 
  AND CAST(t.OutstandingAmount AS DECIMAL) > 0
GROUP BY c.CustomerID, cca.CreditAccountID;

-- Outstanding Customer Balances
CREATE VIEW "CustomerOutstandingBalances" AS
SELECT 
  t.TransactionID,
  t.TransactionDate,
  c.CustomerCode,
  COALESCE(c.CompanyName, c.FirstName || ' ' || c.LastName) AS CustomerName,
  s.StationName,
  t.TotalAmount,
  t.OutstandingAmount,
  julianday('now') - julianday(t.TransactionDate) AS DaysOutstanding,
  CASE 
    WHEN julianday('now') - julianday(t.TransactionDate) <= 30 THEN 'Current'
    WHEN julianday('now') - julianday(t.TransactionDate) <= 60 THEN '31-60 Days'
    WHEN julianday('now') - julianday(t.TransactionDate) <= 90 THEN '61-90 Days'
    ELSE '90+ Days'
  END AS AgingBucket
FROM "Transactions" t
JOIN "Customers" c ON t.CustomerID = c.CustomerID
JOIN "Stations" s ON t.StationID = s.StationID
WHERE t.IsCreditSale = '1' 
  AND CAST(t.OutstandingAmount AS DECIMAL) > 0;

  
COMMIT;

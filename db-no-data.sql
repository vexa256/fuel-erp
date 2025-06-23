
BEGIN TRANSACTION;

DROP VIEW IF EXISTS SupplierCreditSummary;
DROP VIEW IF EXISTS CustomerCreditSummary;
DROP VIEW IF EXISTS CustomerOutstandingBalances;
DROP VIEW IF EXISTS SupplierOutstandingInvoices;
DROP VIEW IF EXISTS CustomerCreditPayments;
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







-- 1. Supplier Credit Accounts (Core credit management)
CREATE TABLE SupplierCreditAccounts (
  CreditAccountID INTEGER PRIMARY KEY,
  SupplierID INTEGER UNIQUE NOT NULL REFERENCES Suppliers(SupplierID),
  StationID INTEGER UNIQUE NULL REFERENCES Stations(StationID), -- NULL = Global account
  CreditLimit  TEXT NOT NULL DEFAULT 0,
  CurrentBalance  TEXT NOT NULL DEFAULT 0, -- What we owe them
  AvailableCredit  TEXT NOT NULL DEFAULT 0, -- CreditLimit - CurrentBalance
  PaymentTermsDays INTEGER NOT NULL DEFAULT 30,
  LastPaymentDate TEXT NULL,
  LastPaymentAmount  TEXT DEFAULT 0,
  IsActive TEXT DEFAULT '1',
  CreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
) STRICT;

-- 2. Supplier Invoices (What we owe)
-- 2. Supplier Invoices (What we owe)
CREATE TABLE "SupplierInvoices" (
  "id" INTEGER PRIMARY KEY,
  "InvoiceID" TEXT,
  "SupplierID" TEXT NOT NULL,
  "StationID" TEXT NOT NULL,
  "InvoiceNumber" TEXT NOT NULL,
  "InvoiceDate" TEXT NOT NULL,
  "DueDate" TEXT NOT NULL,
  "TotalAmount" REAL NOT NULL,
  "PaidAmount" REAL DEFAULT 0,
  "OutstandingAmount" REAL NOT NULL,
  "Status" TEXT DEFAULT 'Outstanding',
  "Description" TEXT,
  "ReceivedBy" INTEGER,
  "CreatedAt" TEXT DEFAULT CURRENT_TIMESTAMP,
  "UpdatedAt" TEXT DEFAULT CURRENT_TIMESTAMP
) STRICT;

-- 3. Supplier Payments (What we've paid)
CREATE TABLE SupplierPayments (
  PaymentID INTEGER PRIMARY KEY,
  SupplierID INTEGER NOT NULL REFERENCES Suppliers(SupplierID),
  StationID INTEGER NULL REFERENCES Stations(StationID),
  PaymentReference TEXT NOT NULL UNIQUE,
  PaymentDate   TEXT  NOT NULL,
  PaymentAmount  TEXT NOT NULL,
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
  AllocatedAmount  TEXT NOT NULL,
  AllocationDate   TEXT  NOT NULL DEFAULT CURRENT_DATE,
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
  Amount  TEXT NOT NULL,
  PreviousBalance  TEXT NOT NULL,
  NewBalance  TEXT NOT NULL,
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


  --- TrailBase compatible table creation
CREATE TABLE IF NOT EXISTS "CashDrawers" (
  "DrawerID" INTEGER PRIMARY KEY,
  "StationID" INTEGER NOT NULL,
  "ShiftDate" TEXT NOT NULL,
  "ShiftType" TEXT NOT NULL,
  "AttendantID" INTEGER NOT NULL,
  "OpeningBalance" TEXT NOT NULL DEFAULT '0.00',
  "ClosingBalance" TEXT NOT NULL DEFAULT '0.00',
  "ExpectedCash" TEXT NOT NULL DEFAULT '0.00',
  "ActualCash" TEXT NOT NULL DEFAULT '0.00',
  "Variance" TEXT NOT NULL DEFAULT '0.00',
  "CashSales" TEXT NOT NULL DEFAULT '0.00',
  "CashPayouts" TEXT NOT NULL DEFAULT '0.00',
  "Status" TEXT DEFAULT 'Open',
  "OpenedBy" INTEGER NOT NULL,
  "ClosedBy" INTEGER NULL,
  "OpenedAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "ClosedAt" TEXT NULL,
  "Notes" TEXT NULL,
  "CreatedAt" TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY("StationID") REFERENCES "Stations"("StationID"),
  FOREIGN KEY("AttendantID") REFERENCES "users"("id"),
  FOREIGN KEY("OpenedBy") REFERENCES "users"("id"),
  FOREIGN KEY("ClosedBy") REFERENCES "users"("id")
) STRICT;

-- Add unique constraint separately
CREATE UNIQUE INDEX IF NOT EXISTS "idx_cashdrawers_unique" 
ON "CashDrawers"("StationID", "ShiftDate", "ShiftType");
-- Previous content of strict_ready.sql ...
-- Ensure all table creations, inserts, triggers, etc., are above this point.

/* ──────────────────────────────────────────────────────────────
   SUPPLIER CREDIT SUMMARY VIEW
   ──────────────────────────────────────────────────────────── */
DROP VIEW IF EXISTS SupplierCreditSummary;
CREATE VIEW SupplierCreditSummary AS
SELECT
    SupplierCreditAccounts.CreditAccountID,
    SupplierCreditAccounts.SupplierID,
    Suppliers.Name                                                  AS SupplierName,
    SupplierCreditAccounts.StationID,
    Stations.StationName,
    SupplierCreditAccounts.CreditLimit,
    SupplierCreditAccounts.CurrentBalance,
    SupplierCreditAccounts.AvailableCredit,
    SupplierCreditAccounts.PaymentTermsDays,
    SupplierCreditAccounts.LastPaymentDate,
    SupplierCreditAccounts.LastPaymentAmount,
    (
        SELECT COUNT(*)
        FROM   SupplierInvoices
        WHERE  SupplierInvoices.SupplierID = SupplierCreditAccounts.SupplierID
          AND  SupplierInvoices.Status      = 'Outstanding'
    )                                                                AS OutstandingInvoices,
    CASE
        WHEN CAST(SupplierCreditAccounts.CurrentBalance AS REAL)  > CAST(SupplierCreditAccounts.CreditLimit AS REAL)
             THEN 'Over Limit'
        WHEN CAST(SupplierCreditAccounts.AvailableCredit AS REAL) < (CAST(SupplierCreditAccounts.CreditLimit AS REAL) * 0.10)
             THEN 'Near Limit'
        ELSE 'Normal'
    END                                                              AS CreditStatus
FROM   SupplierCreditAccounts
JOIN   Suppliers USING (SupplierID)
LEFT   JOIN Stations  USING (StationID);


/* ──────────────────────────────────────────────────────────────
   CUSTOMER CREDIT SUMMARY VIEW
   ──────────────────────────────────────────────────────────── */
DROP VIEW IF EXISTS CustomerCreditSummary;
CREATE VIEW CustomerCreditSummary AS
SELECT
    Customers.CustomerID,
    Customers.CustomerCode,
    COALESCE(Customers.CompanyName,
             Customers.FirstName || ' ' || Customers.LastName)       AS CustomerName,
    Customers.PhoneNumber,
    Customers.Status                                                 AS CustomerStatus,
    Stations.StationName,
    CustomerCreditAccounts.CreditLimit,
    CustomerCreditAccounts.CurrentBalance,
    CustomerCreditAccounts.AvailableCredit,
    CustomerCreditAccounts.PaymentTermsDays,
    CustomerCreditAccounts.LastPurchaseDate,
    CustomerCreditAccounts.LastPaymentDate,
    CustomerCreditAccounts.CreditScore,
    (
        SELECT COUNT(*)
        FROM   Transactions
        WHERE  Transactions.CustomerID        = Customers.CustomerID
          AND  Transactions.IsCreditSale      = '1' -- Compare TEXT with TEXT literal
          AND  CAST(Transactions.OutstandingAmount AS REAL) > 0 -- CAST TEXT to REAL for comparison
    )                                                                AS OutstandingTransactions,
    CASE
        WHEN CAST(CustomerCreditAccounts.CurrentBalance AS REAL)  > CAST(CustomerCreditAccounts.CreditLimit AS REAL)
             THEN 'Over Limit'
        WHEN CAST(CustomerCreditAccounts.AvailableCredit AS REAL) < (CAST(CustomerCreditAccounts.CreditLimit AS REAL) * 0.10)
             THEN 'Near Limit'
        ELSE 'Normal'
    END                                                              AS CreditStatus
FROM   Customers
JOIN   CustomerCreditAccounts USING (CustomerID)
LEFT   JOIN Stations           USING (StationID);


/* ──────────────────────────────────────────────────────────────
   CUSTOMER OUTSTANDING BALANCES VIEW
   ──────────────────────────────────────────────────────────── */
DROP VIEW IF EXISTS CustomerOutstandingBalances;
CREATE VIEW CustomerOutstandingBalances AS
SELECT
    Transactions.TransactionID,
    Transactions.TransactionDate,
    Customers.CustomerCode,
    COALESCE(Customers.CompanyName,
             Customers.FirstName || ' ' || Customers.LastName)       AS CustomerName,
    Stations.StationName,
    Transactions.TotalAmount,
    Transactions.OutstandingAmount,
    julianday('now') - julianday(Transactions.TransactionDate)         AS DaysOutstanding,
    CASE
        WHEN (julianday('now') - julianday(Transactions.TransactionDate)) <=  30 THEN 'Current'
        WHEN (julianday('now') - julianday(Transactions.TransactionDate)) <=  60 THEN '31-60 Days'
        WHEN (julianday('now') - julianday(Transactions.TransactionDate)) <=  90 THEN '61-90 Days'
        ELSE '90+ Days'
    END                                                              AS AgingBucket
FROM   Transactions
JOIN   Customers USING (CustomerID)
JOIN   Stations  USING (StationID)
WHERE  Transactions.IsCreditSale      = '1' -- Compare TEXT with TEXT literal
  AND  CAST(Transactions.OutstandingAmount AS REAL) > 0; -- CAST TEXT to REAL for comparison

COMMIT;


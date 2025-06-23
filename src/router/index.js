import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const routes = [
  { path: '/', name: 'home', component: HomeView },
  {
    path: '/operations/fuel-pos',
    name: 'operationsFuelPOS',
    component: () => import('@/views/Operations/FuelPOS.vue')
  }
  ,
  {
    path: '/operations/fuel-pos',
    name: 'operationsFuelPOS',
    component: () => import('@/views/Operations/FuelPOS.vue')
  }
  ,
  { path: '/operations/attendance-ops', name: 'operationsAttendanceOps', component: () => import('@/views/Operations/AttendaceOps.vue') },
  { path: '/operations/daily-reading-ops', name: 'operationsDailyReadingOps', component: () => import('@/views/Operations/DailyReadingOps.vue') },
  { path: '/operations/cash-ops', name: 'operationsCashOps', component: () => import('@/views/Operations/CashOps.vue') },
  { path: '/operations/station-ops', name: 'operationsStationOps', component: () => import('@/views/Operations/StationOps.vue') },
  { path: '/operations/shift-ops', name: 'operationsShiftOps', component: () => import('@/views/Operations/ShiftOps.vue') },
  { path: '/operations/operational-approvals', name: 'operationsOperationalApprovals', component: () => import('@/views/Operations/OperationalApprovals.vue') },
  { path: '/hr/approvals', name: 'hrApprovals', component: () => import('@/views/HR/Approvals.vue') },
  { path: '/hr/user-roles-stations', name: 'hrUserRolesStations', component: () => import('@/views/HR/UserRolesAndStations.vue') },
  { path: '/auth/login', name: 'authLogin', component: () => import('@/views/AUTH/Login.vue') },
  { path: '/hr/position-requirements', name: 'hrPositionRequirements', component: () => import('@/views/HR/PositionRequirements.vue') },
  { path: '/hr/employees', name: 'hrEmployees', component: () => import('@/views/HR/MgtEmp.vue') },
  { path: '/hr/positions', name: 'hrPositions', component: () => import('@/views/HR/Positions.vue') },
  { path: '/hr/permissions', name: 'hrPermissions', component: () => import('@/views/HR/Permissions.vue') },
  { path: '/master/stations', name: 'stations', component: () => import('@/views/Stations/MgtStations.vue') },
  { path: '/hr/grades-roles', name: 'hrGradesAndRoles', component: () => import('@/views/HR/GradesAndRoles.vue') },
  { path: '/hr/management', name: 'hrMasterManagement', component: () => import('@/views/HR/HRMasterManagementView.vue') },
  { path: '/price/management', name: 'priceManagement', component: () => import('@/views/Price/MgtPrice.vue') },
  { path: '/master/products', name: 'products', component: () => import('@/views/Stations/Products/MgtProducts.vue') },
  { path: '/master/tanks', name: 'tanks', component: () => import('@/views/Tanks/MgtTanks.vue') },
  { path: '/master/pump-tank-management', name: 'pump-tank-management', component: () => import('@/views/Stations/Pumps/MgtPumps.vue') },
  { path: '/about', name: 'about', component: () => import('../views/AboutView.vue') },
  { path: '/suppliers/registry', name: 'SupplierRegistryDashboard', component: () => import('@/views/Suppliers/SupplierRegistryDashboard.vue') },
  { path: '/suppliers/manage', name: 'SupplierManagementView', component: () => import('@/views/Suppliers/SupplierManagementView.vue') },
  { path: '/suppliers/manage/:supplierId', name: 'SupplierDetailView', component: () => import('@/views/Suppliers/SupplierManagementView.vue'), props: true },
  { path: '/suppliers/stations/overview', name: 'StationAssignmentOverview', component: () => import('@/views/Suppliers/StationAssignmentOverview.vue') },
  { path: '/suppliers/stations/relationships', name: 'SupplierStationRelationshipDetailsView', component: () => import('@/views/Suppliers/SupplierStationRelationshipDetailsView.vue') },
  { path: '/suppliers/credit-accounts', name: 'CreditAccountManagementHub', component: () => import('@/views/Suppliers/CreditAccountManagementHub.vue') },
  { path: '/suppliers/credit-accounts/:accountId', name: 'CreditAccountDetail', component: () => import('@/views/Suppliers/CreditAccountManagementHub.vue'), props: true },
  { path: '/suppliers/invoices', name: 'InvoiceManagementHub', component: () => import('@/views/Suppliers/InvoiceManagementHub.vue') },
  { path: '/suppliers/invoices/:invoiceId', name: 'InvoiceDetail', component: () => import('@/views/Suppliers/InvoiceManagementHub.vue'), props: true },
  { path: '/suppliers/payments', name: 'PaymentManagementHub', component: () => import('@/views/Suppliers/PaymentManagementHub.vue') },
  { path: '/suppliers/allocations', name: 'AllocationManagementHub', component: () => import('@/views/Suppliers/AllocationManagementHub.vue') },
  { path: '/suppliers/credit-analysis', name: 'CreditMonitoringAnalysisDashboard', component: () => import('@/views/Suppliers/CreditMonitoringAnalysisDashboard.vue') },
  { path: '/suppliers/credit-transactions-audit', name: 'CreditTransactionAuditView', component: () => import('@/views/Suppliers/CreditTransactionAuditView.vue') },
  { path: '/suppliers/performance-dashboard', name: 'SupplierPerformanceDashboard', component: () => import('@/views/Suppliers/SupplierPerformanceDashboard.vue') },
  { path: '/suppliers/reports', name: 'ReportingSuite', component: () => import('@/views/Suppliers/ReportingSuite.vue') },
  // Default redirect to registry dashboard
  { path: '/:pathMatch(.*)*', redirect: '/suppliers/registry' }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router

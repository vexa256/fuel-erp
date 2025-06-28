<template>
  <div
    v-if="isAuthenticated"
    class="d-flex flex-column flex-root app-root min-vh-100 bg-light"
    id="kt_app_root"
  >
    <div class="d-flex flex-column flex-root app-root" id="kt_app_root">
      <!--begin::Page-->
      <div class="app-page flex-column flex-column-fluid" id="kt_app_page">
        <!--begin::Header-->
        <div id="kt_app_header" class="app-header d-flex flex-column flex-stack">
          <div class="d-flex align-items-center flex-stack flex-grow-1">
            <div
              class="app-header-logo d-flex align-items-center flex-stack px-lg-11 mb-2"
              id="kt_app_header_logo"
            >
              <div
                class="btn btn-icon btn-active-color-primary w-35px h-35px ms-3 me-2 d-flex d-lg-none"
                id="kt_app_sidebar_mobile_toggle"
              >
                <i class="ki-duotone ki-abstract-14 fs-2"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
              </div>
              <router-link to="/" class="app-sidebar-logo">
                <i class="ki-duotone ki-rocket fs-2x me-2"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
                <span class="fs-3 fw-bolder">FuelERP</span>
              </router-link>
              <div
                id="kt_app_sidebar_toggle"
                class="app-sidebar-toggle btn btn-sm btn-icon btn-color-warning me-n2 d-none d-lg-flex"
                data-kt-toggle="true"
                data-kt-toggle-state="active"
                data-kt-toggle-target="body"
                data-kt-toggle-name="app-sidebar-minimize"
              >
                <i class="ki-duotone ki-exit-left fs-2x rotate-180"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
              </div>
            </div>
            <div class="app-navbar flex-grow-1 justify-content-end" id="kt_app_header_navbar">
              <div class="app-navbar-item d-flex align-items-stretch flex-lg-grow-1 me-2 me-lg-0">
                <div
                  id="kt_header_search"
                  class="header-search d-flex align-items-center w-lg-350px"
                  data-kt-search-keypress="true"
                  data-kt-search-min-length="2"
                  data-kt-search-enter="enter"
                  data-kt-search-layout="menu"
                  data-kt-search-responsive="true"
                  data-kt-menu-trigger="auto"
                  data-kt-menu-permanent="true"
                  data-kt-menu-placement="bottom-start"
                >
                  <div
                    data-kt-search-element="toggle"
                    class="search-toggle-mobile d-flex d-lg-none align-items-center"
                  >
                    <div class="d-flex">
                      <i class="ki-duotone ki-magnifier fs-1"
                        ><span class="path1"></span><span class="path2"></span
                      ></i>
                    </div>
                  </div>
                  <form
                    data-kt-search-element="form"
                    class="d-none d-lg-block w-100 position-relative mb-5 mb-lg-0"
                    autocomplete="off"
                  >
                    <input type="hidden" />
                    <i
                      class="ki-duotone ki-magnifier search-icon fs-2 text-gray-500 position-absolute top-50 translate-middle-y ms-4"
                      ><span class="path1"></span><span class="path2"></span
                    ></i>
                    <input
                      type="text"
                      class="search-input form-control form-control-solid ps-13"
                      name="search"
                      value=""
                      placeholder="Search..."
                      data-kt-search-element="input"
                    />
                  </form>
                  <div
                    data-kt-search-element="content"
                    class="menu menu-sub menu-sub-dropdown py-7 px-7 overflow-hidden w-300px w-md-350px"
                  >
                    <div data-kt-search-element="results" class="d-none"></div>
                    <div data-kt-search-element="empty" class="text-center d-none">
                      No results found
                    </div>
                  </div>
                </div>
              </div>
              <div class="app-navbar-item ms-3 ms-lg-4 me-lg-2" id="kt_header_user_menu_toggle">
                <div
                  class="cursor-pointer symbol symbol-30px symbol-lg-40px"
                  data-kt-menu-trigger="{default: 'click', lg: 'hover'}"
                  data-kt-menu-attach="parent"
                  data-kt-menu-placement="bottom-end"
                >
                  <i class="ki-duotone ki-user fs-2x"
                    ><span class="path1"></span><span class="path2"></span
                  ></i>
                </div>
                <!-- <div
                  class="menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-800 menu-state-bg menu-state-color fw-semibold py-4 fs-6 w-275px"
                  data-kt-menu="true"
                >
                  <div class="menu-item px-3">
                    <div class="menu-content d-flex align-items-center px-3">
                      <div class="symbol symbol-50px me-5">
                        <i class="ki-duotone ki-user fs-2x"
                          ><span class="path1"></span><span class="path2"></span
                        ></i>
                      </div>
                      <div class="d-flex flex-column">
                        <div class="fw-bold d-flex align-items-center fs-5">
                          User Name
                          <span class="badge badge-light-success fw-bold fs-8 px-2 py-1 ms-2"
                            >Role</span
                          >
                        </div>
                        <a href="#" class="fw-semibold text-muted text-hover-primary fs-7"
                          >user@example.com</a
                        >
                      </div>
                    </div>
                  </div>
                  <div class="separator my-2"></div>
                  <div class="menu-item px-5">
                    <router-link to="/profile" class="menu-link px-5">My Profile</router-link>
                  </div>
                  <div class="separator my-2"></div>
                  <div class="menu-item px-5">
                    <a href="#" @click.prevent="logout" class="menu-link px-5">Sign Out</a>
                  </div>
                </div> -->
              </div>
              <div class="app-navbar-item ms-3 ms-lg-4 me-lg-6">
                <a
                  href="#"
                  class="btn btn-icon btn-custom btn-color-gray-600 btn-active-color-primary w-35px h-35px w-md-40px h-md-40px"
                >
                  <i class="ki-duotone ki-setting-3 fs-1"
                    ><span class="path1"></span><span class="path2"></span
                    ><span class="path3"></span><span class="path4"></span
                    ><span class="path5"></span
                  ></i>
                </a>
              </div>
            </div>
          </div>
          <div class="app-header-separator"></div>
        </div>
        <!--end::Header-->

        <div class="app-wrapper flex-column flex-row-fluid" id="kt_app_wrapper">
          <div
            id="kt_app_sidebar"
            class="app-sidebar flex-column"
            data-kt-drawer="true"
            data-kt-drawer-name="app-sidebar"
            data-kt-drawer-activate="{default: true, lg: false}"
            data-kt-drawer-overlay="true"
            data-kt-drawer-width="250px"
            data-kt-drawer-direction="start"
            data-kt-drawer-toggle="#kt_app_sidebar_mobile_toggle"
          >
            <div
              class="d-flex flex-column justify-content-between h-100 hover-scroll-overlay-y my-2"
              id="kt_app_sidebar_main"
              data-kt-scroll="true"
              data-kt-scroll-activate="true"
              data-kt-scroll-height="auto"
              data-kt-scroll-dependencies="#kt_app_header"
              data-kt-scroll-wrappers="#kt_app_main"
              data-kt-scroll-offset="5px"
            >
              <div
                id="kt_app_sidebar_menu"
                data-kt-menu="true"
                data-kt-menu-expand="false"
                class="flex-column-fluid menu menu-sub-indention menu-column menu-rounded menu-active-bg mb-7"
              >
                <!-- DASHBOARD -->
                <div class="menu-item">
                  <router-link class="menu-link" to="/">
                    <span class="menu-icon"
                      ><i class="ki-duotone ki-element-11 fs-1"
                        ><span class="path1"></span><span class="path2"></span
                        ><span class="path3"></span><span class="path4"></span></i
                    ></span>
                    <span class="menu-title">POS</span>
                  </router-link>
                </div>
                <!-- DATA MANAGEMENT -->
                <div class="menu-item pt-5">
                  <div class="menu-content">
                    <span class="menu-heading fw-bold text-uppercase fs-7">Data Mgmt</span>
                  </div>
                </div>

                <div data-kt-menu-trigger="click" class="menu-item menu-accordion">
                  <span class="menu-link">
                    <span class="menu-icon"
                      ><i class="ki-duotone ki-setting-3 fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                        <span class="path5"></span> </i
                    ></span>
                    <span class="menu-title">Masters</span>
                    <span class="menu-arrow"></span>
                  </span>
                  <div class="menu-sub menu-sub-accordion">
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/master/company">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Company</span></router-link
                      >
                    </div> -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/master/stations">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Stations</span></router-link
                      >
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/master/tanks">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Tanks</span></router-link
                      >
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/master/pump-tank-management">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Pump Config</span></router-link
                      >
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/master/products">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Products</span></router-link
                      >
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/price/management">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Prices</span></router-link
                      >
                    </div>
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/SupplierDashboard/management">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Supplier Dashboard</span></router-link
                      >
                    </div>

                    <div class="menu-item">
                      <router-link class="menu-link" to="/SupplierList/management">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Supplier list</span></router-link
                      >
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/master/accounts">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Accounts</span></router-link
                      >
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/admin/users">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Users</span></router-link
                      >
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/admin/roles">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Roles</span></router-link
                      >
                    </div> -->
                  </div>
                </div>

                <div data-kt-menu-trigger="click" class="menu-item menu-accordion">
                  <span class="menu-link">
                    <span class="menu-icon">
                      <i class="ki-duotone ki-people fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                        <span class="path5"></span>
                      </i>
                    </span>
                    <span class="menu-title">Human Resources</span>
                    <span class="menu-arrow"></span>
                  </span>
                  <div class="menu-sub menu-sub-accordion">
                    <!-- PHASE 1: Foundation Master Data -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/management">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Departments</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/grades-roles">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Grades And Roles</span>
                      </router-link>
                    </div>

                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/permissions">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Permissions</span>
                      </router-link>
                    </div> -->

                    <!-- PHASE 2: Position Setup -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/positions">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Positions</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/position-requirements">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Position Requirements</span>
                      </router-link>
                    </div>

                    <!-- PHASE 3: Employee Management -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/employees">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Employee Management</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/user-roles-stations">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">User Role Assignments</span>
                      </router-link>
                    </div>

                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/role-permissions">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Role Permission Matrix</span>
                      </router-link>
                    </div> -->

                    <!-- PHASE 4: Position Assignments & Planning -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/position-assignments">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Position Assignments</span>
                      </router-link>
                    </div> -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/career-paths">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Career Paths</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/succession-plans">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Succession Plans</span>
                      </router-link>
                    </div> -->

                    <!-- PHASE 5: Operational Data -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/attendance">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Attendance</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/hr/certifications">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">User Certifications</span>
                      </router-link>
                    </div> -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/login-history">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Login History</span>
                      </router-link>
                    </div> -->

                    <!-- PHASE 6: Approval Workflows -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/promotion-requests">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Promotion Requests</span>
                      </router-link>
                    </div> -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/position-history">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Position History</span>
                      </router-link>
                    </div> -->

                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/hr/approvals">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Approval Management</span>
                      </router-link>
                    </div> -->
                  </div>
                </div>

                <div data-kt-menu-trigger="click" class="menu-item menu-accordion">
                  <span class="menu-link">
                    <span class="menu-icon">
                      <i class="ki-duotone ki-setting-3 fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                        <span class="path5"></span>
                      </i>
                    </span>
                    <span class="menu-title">Suppliers</span>
                    <span class="menu-arrow"></span>
                  </span>

                  <div class="menu-sub menu-sub-accordion">
                    <!-- ── Core Supplier Management ─────────────────────────────────── -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/registry">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Registry </span>
                      </router-link>
                    </div> -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/manage">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Manage Suppliers</span>
                      </router-link>
                    </div>

                    <!-- ── Supplier-Station Assignment ──────────────────────────────── -->
                    <!-- <div class="menu-item">
                    <router-link class="menu-link" to="/suppliers/stations/overview">
                      <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                      <span class="menu-title">Station Assignment </span>
                    </router-link>
                  </div>
                  <div class="menu-item">
                    <router-link class="menu-link" to="/suppliers/stations/relationships">
                      <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                      <span class="menu-title">Station Relationships</span>
                    </router-link>
                  </div> -->

                    <!-- ── Financial Operations Hubs ────────────────────────────────── -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/credit-accounts">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Credit Accounts </span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/invoices">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Invoices </span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/payments">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Payments </span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/allocations">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Allocation Hub </span>
                      </router-link>
                    </div>

                    <!-- ── Credit Monitoring & Audit ────────────────────────────────── -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/credit-analysis">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Credit Analysis </span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/credit-transactions-audit">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Credit Transactions </span>
                      </router-link>
                    </div>

                    <!-- ── Analytics & Reports ──────────────────────────────────────── -->
                    <!-- <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/performance-dashboard">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Performance Hub</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/suppliers/reports">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Reporting Suite</span>
                      </router-link>
                    </div> -->
                  </div>
                </div>

                <!-- ═══════════════════════════════════════════════════════════════════════════════════ -->
                <!-- ADDITIONAL MENU SECTIONS - 100% DATABASE SUPPORTED (NON-DUPLICATED) -->
                <!-- ═══════════════════════════════════════════════════════════════════════════════════ -->

                <!-- DAILY OPERATIONS -->
                <div class="menu-item pt-5">
                  <div class="menu-content">
                    <span class="menu-heading fw-bold text-uppercase fs-7">Daily Operations</span>
                  </div>
                </div>

                <div data-kt-menu-trigger="click" class="menu-item menu-accordion">
                  <span class="menu-link">
                    <span class="menu-icon">
                      <i class="ki-duotone ki-drop fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </span>
                    <span class="menu-title">Station Operations</span>
                    <span class="menu-arrow"></span>
                  </span>
                  <div class="menu-sub menu-sub-accordion">
                    <!-- 2. CORE FUEL SALES & POS -->
                    <div class="menu-item">
                      <router-link class="menu-link" to="/operations/fuel-pos">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Fuel Sales & POS</span>
                      </router-link>
                    </div>

                    <div class="menu-item">
                      <router-link class="menu-link" to="/station-operations/daily-meter-readings">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Daily Readings</span>
                      </router-link>
                    </div>

                    <div class="menu-item">
                      <router-link class="menu-link" to="/station-operations/dip-readings">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Dip Readings</span>
                      </router-link>
                    </div>

                    <div class="menu-item">
                      <router-link class="menu-link" to="/station-operations/stock-level-monitor">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Stock Level Monitor</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/station-operations/inventory-adjustement">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Inventory Adjustments</span>
                      </router-link>
                    </div>

                    <div class="menu-item">
                      <router-link
                        class="menu-link"
                        to="/station-operations/tanked-inventory-adjustment"
                      >
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Tanked Inventory Adjustments</span>
                      </router-link>
                    </div>

                    <div class="menu-item">
                      <router-link class="menu-link" to="/station-operations/aging-analysis">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Aging Analysis</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/station-operations/variance-analysis">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Variance Analysis</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/station-operations/financial-statement">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Finance Report</span>
                      </router-link>
                    </div>

                    <!-- <div class="menu-item">
                      <router-link
                        class="menu-link"
                        to="/station-operations/cash-drawer-and-variance"
                      >
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Cash Drawer</span>
                      </router-link>
                    </div> -->

                    <div class="menu-item">
                      <router-link
                        class="menu-link"
                        to="/station-operations/customer-credit-accounts-management"
                      >
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Customer Credit</span>
                      </router-link>
                    </div>
                  </div>
                </div>

                <!-- <div data-kt-menu-trigger="click" class="menu-item menu-accordion">
                  <span class="menu-link">
                    <span class="menu-icon">
                      <i class="ki-duotone ki-dollar fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                    </span>
                    <span class="menu-title">Cash Management</span>
                    <span class="menu-arrow"></span>
                  </span>
                  <div class="menu-sub menu-sub-accordion">
                    <div class="menu-item">
                      <router-link class="menu-link" to="/station/cash/drawer-management">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Cash Drawer Manager</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/station/cash/reconciliation">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Cash Reconciliation</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/station/cash/shift-handover">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Shift Handover</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/station/cash/variance-resolution">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Variance Resolution</span>
                      </router-link>
                    </div>
                  </div>
                </div> -->

                <!-- <div data-kt-menu-trigger="click" class="menu-item menu-accordion">
                  <span class="menu-link">
                    <span class="menu-icon">
                      <i class="ki-duotone ki-arrow-up-down fs-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                    </span>
                    <span class="menu-title">Inter-Station Transfers</span>
                    <span class="menu-arrow"></span>
                  </span>
                  <div class="menu-sub menu-sub-accordion">
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/initiate">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Initiate Transfer</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/pending-approvals">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Pending Approvals</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/in-transit">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">In Transit</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/receiving">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Receiving Station</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/reconciliation">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Transfer Reconciliation</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/variance-handling">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Variance Handling</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/tracking">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Transfer Tracking</span>
                      </router-link>
                    </div>
                    <div class="menu-item">
                      <router-link class="menu-link" to="/transfers/documentation">
                        <span class="menu-bullet"><span class="bullet bullet-dot"></span></span>
                        <span class="menu-title">Transfer Documentation</span>
                      </router-link>
                    </div>
                  </div>
                </div> -->

                <!-- ═══════════════════════════════════════════════════════════════════════════════════ -->
                <!-- END ADDITIONAL MENU SECTIONS -->
                <!-- ═══════════════════════════════════════════════════════════════════════════════════ -->
              </div>
            </div>
          </div>
          <!--begin::Main-->
          <div class="app-main flex-column flex-row-fluid" id="kt_app_main">
            <!--begin::Content wrapper-->
            <div class="d-flex flex-column flex-column-fluid">
              <!--begin::Toolbar-->
              <div id="kt_app_toolbar" class="app-toolbar pt-5">
                <!--begin::Toolbar container-->
                <div
                  id="kt_app_toolbar_container"
                  class="app-container container-fluid d-flex align-items-stretch"
                >
                  <!--end::Toolbar wrapper-->
                </div>
                <!--end::Toolbar container-->
              </div>
              <!--end::Toolbar-->
              <!--begin::Content-->
              <div id="kt_app_content" class="app-content flex-column-fluid">
                <!--begin::Content container-->
                <div id="kt_app_content_container" class="app-container container-fluid">
                  <!--begin::Row-->
                  <div class="row gx-5 gx-xl-10">
                    <router-view />
                  </div>
                  <!--end::Row-->
                </div>
                <!--end::Content container-->
              </div>
              <!--end::Content-->
            </div>
            <!--end::Content wrapper-->
            <!--begin::Footer-->
            <div
              id="kt_app_footer"
              class="app-footer align-items-center justify-content-center justify-content-md-between flex-column flex-md-row py-3"
            >
              <!--begin::Copyright-->
              <!-- <div class="text-dark order-2 order-md-1">
                <span class="text-muted fw-semibold me-1">2025&copy;</span>
                <a
                  href="https://keenthemes.com"
                  target="_blank"
                  class="text-gray-800 text-hover-primary"
                  >FUEL ERP</a
                >
              </div> -->
              <!--end::Copyright-->
              <!--begin::Menu-->
              <!-- <ul class="menu menu-gray-600 menu-hover-primary fw-semibold order-1">
                <li class="menu-item">
                  <a href="https://keenthemes.com" target="_blank" class="menu-link px-2">About</a>
                </li>
                <li class="menu-item">
                  <a href="https://devs.keenthemes.com" target="_blank" class="menu-link px-2"
                    >Support</a
                  >
                </li>
                <li class="menu-item">
                  <a
                    href="https://keenthemes.com/products/saul-html-pro"
                    target="_blank"
                    class="menu-link px-2"
                    >Purchase</a
                  >
                </li>
              </ul> -->
              <!--end::Menu-->
            </div>
            <!--end::Footer-->
          </div>
          <!--end:::Main-->
        </div>
      </div>
    </div>
    <div id="kt_scrolltop" class="scrolltop" data-kt-scrolltop="true">
      <i class="ki-duotone ki-arrow-up"><span class="path1"></span><span class="path2"></span></i>
    </div>
  </div>
  <LoginView v-else @authenticated="handleLoginSuccess" />
</template>

<script setup>
import { ref, watch, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import LoginView from '@/views/AUTH/Login.vue' // Use your custom login view!

const AUTH_CONFIG = {
  TOKEN_KEY: 'kigrama_auth_token',
  USER_DATA_KEY: 'kigrama_user_data',
  CHECK_INTERVAL: 300000, // 5 minutes
  SESSION_LIMIT: 24, // hours
}

const router = useRouter()
const route = useRoute()
const isAuthenticated = ref(false)
let sessionTimer = null

function getAuthData() {
  const token = localStorage.getItem(AUTH_CONFIG.TOKEN_KEY)
  const userData = localStorage.getItem(AUTH_CONFIG.USER_DATA_KEY)
  if (!token || !userData) return null
  try {
    const authData = JSON.parse(userData)
    if (!authData.user || !authData.user.id || !authData.user.email) return null
    // Check JWT expiry
    const payload = JSON.parse(atob(token.split('.')[1]))
    const now = Math.floor(Date.now() / 1000)
    if (!payload.exp || payload.exp < now) return null
    // Check session age
    const loginTime = new Date(authData.loginTime)
    const hours = (new Date() - loginTime) / (1000 * 60 * 60)
    if (hours > AUTH_CONFIG.SESSION_LIMIT) return null
    return authData
  } catch {
    return null
  }
}

function setAuthenticated(val) {
  isAuthenticated.value = val
}

function logout(reason = 'Session expired, please login again') {
  // localStorage.removeItem(AUTH_CONFIG.TOKEN_KEY)
  // localStorage.removeItem(AUTH_CONFIG.USER_DATA_KEY)
  // setAuthenticated(false)
  // clearInterval(sessionTimer)
  // // Only redirect if not already on login
  // if (route.path !== '/auth/login') {
  //   router.replace({ path: '/auth/login', query: { message: reason } })
  // }
}

// LoginView will emit "authenticated" on success
function handleLoginSuccess() {
  setAuthenticated(true)
  // Re-initialize Metronic UI
  initializeMetronicComponents()
  // If on /auth/login, go to home
  if (route.path === '/auth/login') {
    router.replace('/')
  }
}

function startSessionMonitoring() {
  clearInterval(sessionTimer)
  sessionTimer = setInterval(() => {
    if (!getAuthData()) {
      logout('Session validation failed or expired')
    }
  }, AUTH_CONFIG.CHECK_INTERVAL)
}
// Auto-close sidebar on any route navigation
router.afterEach(() => {
  nextTick(() => {
    // Primary method: Use Metronic's KTDrawer API
    const drawer = KTDrawer.getInstance('kt_app_sidebar')
    if (drawer) {
      drawer.hide()
    }

    // Fallback: Remove drawer classes
    document.body.classList.remove('drawer-on', 'drawer-overlay')
  })
})
// Listen for logout from another tab
function storageHandler(e) {
  if (e.key === AUTH_CONFIG.TOKEN_KEY && !e.newValue) {
    logout('Logged out from another tab')
  }
}

// --- METRONIC UI INITIALIZATION ---
const initializeMetronicComponents = () => {
  nextTick(() => {
    if (window.KTMenu) window.KTMenu.createInstances()
    if (window.KTToggle) window.KTToggle.createInstances()
    if (window.KTDrawer) window.KTDrawer.createInstances()
    if (window.KTScroll) window.KTScroll.createInstances()
    if (window.KTScrolltop) window.KTScrolltop.createInstances()
  })
}

const AdlogAllAuthData = () => {
  try {
    const token = localStorage.getItem('kigrama_auth_token')
    const userDataStr = localStorage.getItem('kigrama_user_data')
    if (!token) {
      console.error('❌ No auth token found in localStorage (kigrama_auth_token).')
    } else {
      console.log('🔑 AUTH TOKEN:', token)
      try {
        const jwtPayload = JSON.parse(atob(token.split('.')[1]))
        console.log('📦 JWT PAYLOAD:', jwtPayload)
      } catch (err) {
        console.warn('⚠️ Could not parse JWT payload:', err)
      }
    }

    if (!userDataStr) {
      console.error('❌ No user data found in localStorage (kigrama_user_data).')
    } else {
      const userData = JSON.parse(userDataStr)
      console.log('🧑‍💼 AUTH USER DATA (Parsed, full dump):')
      console.dir(userData, { depth: null })
      // Explicitly log common important fields if present
      if (userData.user) console.log('👤 User:', userData.user)
      if (userData.roles) console.log('🎭 Roles:', userData.roles)
      if (userData.permissions) console.log('🔑 Permissions:', userData.permissions)
      if (userData.stations) console.log('🏢 Stations:', userData.stations)
      if (userData.positions) console.log('📋 Positions:', userData.positions)
      if (userData.token) console.log('🪪 Session Token:', userData.token)
      if (userData.loginTime) console.log('⏰ Login Time:', userData.loginTime)
      if (userData.sessionData) console.log('🗃️ Session Data:', userData.sessionData)
    }
    console.log('✅ AUTH DATA LOG COMPLETE')
  } catch (e) {
    console.error('🚨 ERROR LOGGING AUTH DATA:', e)
  }
}

// --- LIFECYCLE ---
onMounted(() => {
  // App body attributes (Metronic requirement)
  document.body.id = 'kt_app_body'
  document.body.setAttribute('data-kt-app-header-fixed', 'true')
  document.body.setAttribute('data-kt-app-header-fixed-mobile', 'true')
  document.body.setAttribute('data-kt-app-sidebar-enabled', 'true')
  document.body.setAttribute('data-kt-app-sidebar-fixed', 'true')
  document.body.setAttribute('data-kt-app-sidebar-hoverable', 'true')
  document.body.setAttribute('data-kt-app-sidebar-push-toolbar', 'true')
  document.body.setAttribute('data-kt-app-sidebar-push-footer', 'true')
  document.body.setAttribute('data-kt-app-toolbar-enabled', 'true')
  document.body.classList.add('app-default')
  document.body.setAttribute('data-kt-app-sidebar-minimize', 'on')
  initializeMetronicComponents()

  // Method 1: Route-based closing (most reliable)
  watch(
    () => route.path,
    () => {
      document.getElementById('kt_app_sidebar_mobile_toggle')?.click()
    },
  )

  // Method 2: Simplified click handler (backup)
  setTimeout(() => {
    document.addEventListener('click', (e) => {
      // Just check if click is inside sidebar, ignore open/closed state
      const sidebar = document.getElementById('kt_app_sidebar')
      if (sidebar && sidebar.contains(e.target)) {
        // Any click inside sidebar closes it
        setTimeout(() => {
          document.getElementById('kt_app_sidebar_mobile_toggle')?.click()
        }, 50)
      }
    })
  }, 1000)

  // Method 3: Attach directly to existing menu links
  setTimeout(() => {
    document.querySelectorAll('.menu-link').forEach((link) => {
      link.addEventListener('click', () => {
        setTimeout(() => {
          document.getElementById('kt_app_sidebar_mobile_toggle')?.click()
        }, 50)
      })
    })
  }, 2000)

  // 1. Auth check on mount
  setAuthenticated(!!getAuthData())

  // 2. Route guard: always enforce login
  watch(
    () => route.fullPath,
    () => {
      if (!getAuthData()) {
        setAuthenticated(false)
        if (route.path !== '/auth/login') {
          router.replace('/auth/login')
        }
      } else {
        setAuthenticated(true)
        initializeMetronicComponents()
        if (route.path === '/auth/login') {
          router.replace('/')
        }
      }
    },
    { immediate: true },
  )

  AdlogAllAuthData()

  // 3. Session monitor
  startSessionMonitoring()
  // 4. Cross-tab logout
  window.addEventListener('storage', storageHandler)
  // 5. Visibility: on tab focus, re-check
  document.addEventListener('visibilitychange', () => {
    if (!document.hidden) {
      if (!getAuthData()) logout('Session expired')
    }
  })
})

onUnmounted(() => {
  clearInterval(sessionTimer)
  window.removeEventListener('storage', storageHandler)
})

// --- LOGOUT for UI ---
// const logout = () => {
//   localStorage.removeItem(AUTH_CONFIG.TOKEN_KEY)
//   localStorage.removeItem(AUTH_CONFIG.USER_DATA_KEY)
//   setAuthenticated(false)
//   router.replace('/auth/login')
// }

// Expose for menus
defineExpose({ logout })
</script>

<style scoped>
.menu-link {
  cursor: pointer;
}
</style>

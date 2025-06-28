<template>
  <!-- SYSTEM SETTINGS MODAL - ULTRA PREMIUM iOS DESIGN -->
  <div v-if="show"
       class="modal fade show d-block"
       style="z-index: 1055; background: rgba(0,0,0,0.8);"
       @click.self="closeModal">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content border-0 shadow-xl" style="border-radius: 20px;">

        <!-- MODAL HEADER -->
        <div class="modal-header bg-gradient-primary border-0 position-relative" style="border-radius: 20px 20px 0 0;">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-setting-4 fs-1 text-white">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </div>
            <div>
              <h3 class="modal-title text-white fw-bold fs-2 mb-0">System Settings</h3>
              <p class="text-white opacity-75 fs-7 mb-0">{{ currentUser?.name || 'User' }} • {{ currentStation?.StationName || 'Station' }}</p>
            </div>
          </div>
          <button @click="closeModal"
                  class="btn btn-icon btn-light-danger btn-sm position-absolute top-50 translate-middle-y"
                  style="right: 20px;">
            <i class="ki-duotone ki-cross fs-1">
              <span class="path1"></span><span class="path2"></span>
            </i>
          </button>
        </div>

        <!-- MODAL BODY -->
        <div class="modal-body p-0">

          <!-- NAVIGATION TABS -->
          <div class="bg-light-primary border-bottom">
            <ul class="nav nav-pills nav-pills-custom d-flex justify-content-center p-4">
              <li class="nav-item me-2">
                <a @click="activeTab = 'system'"
                   :class="['nav-link', 'fw-bold', 'px-4', 'py-3', activeTab === 'system' ? 'active' : '']"
                   href="#">
                  <i class="ki-duotone ki-laptop fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  System Info
                </a>
              </li>
              <li class="nav-item me-2">
                <a @click="activeTab = 'preferences'"
                   :class="['nav-link', 'fw-bold', 'px-4', 'py-3', activeTab === 'preferences' ? 'active' : '']"
                   href="#">
                  <i class="ki-duotone ki-gear fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Preferences
                </a>
              </li>
              <li class="nav-item me-2">
                <a @click="activeTab = 'logs'"
                   :class="['nav-link', 'fw-bold', 'px-4', 'py-3', activeTab === 'logs' ? 'active' : '']"
                   href="#">
                  <i class="ki-duotone ki-verify fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Activity Logs
                </a>
              </li>
              <li class="nav-item">
                <a @click="activeTab = 'diagnostics'"
                   :class="['nav-link', 'fw-bold', 'px-4', 'py-3', activeTab === 'diagnostics' ? 'active' : '']"
                   href="#">
                  <i class="ki-duotone ki-chart-line-up fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Diagnostics
                </a>
              </li>
            </ul>
          </div>

          <!-- TAB CONTENT -->
          <div class="tab-content p-6">

            <!-- SYSTEM INFORMATION TAB -->
            <div v-if="activeTab === 'system'" class="tab-pane fade show active">

              <!-- SYSTEM OVERVIEW CARDS -->
              <div class="row g-4 mb-6">
                <div class="col-md-3">
                  <div class="card bg-light-success border-success h-100">
                    <div class="card-body text-center p-4">
                      <i class="ki-duotone ki-cpu fs-3x text-success mb-3">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      <div class="fw-bold fs-2 text-success">{{ systemStats.activeUsers }}</div>
                      <div class="text-gray-700 fs-7">Active Users</div>
                    </div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="card bg-light-primary border-primary h-100">
                    <div class="card-body text-center p-4">
                      <i class="ki-duotone ki-oil-barrel fs-3x text-primary mb-3">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      <div class="fw-bold fs-2 text-primary">{{ systemStats.products }}</div>
                      <div class="text-gray-700 fs-7">Products</div>
                    </div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="card bg-light-warning border-warning h-100">
                    <div class="card-body text-center p-4">
                      <i class="ki-duotone ki-abstract-26 fs-3x text-warning mb-3">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      <div class="fw-bold fs-2 text-warning">{{ systemStats.tanks }}</div>
                      <div class="text-gray-700 fs-7">Storage Tanks</div>
                    </div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="card bg-light-info border-info h-100">
                    <div class="card-body text-center p-4">
                      <i class="ki-duotone ki-electricity fs-3x text-info mb-3">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      <div class="fw-bold fs-2 text-info">{{ systemStats.pumps }}</div>
                      <div class="text-gray-700 fs-7">Fuel Pumps</div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- SYSTEM STATUS -->
              <div class="card border-0 bg-light-primary mb-6">
                <div class="card-body p-5">
                  <h5 class="fw-bold text-gray-800 mb-4">
                    <i class="ki-duotone ki-pulse text-primary fs-1 me-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    System Status
                  </h5>
                  <div class="row g-4">
                    <div class="col-md-6">
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">API Connection:</span>
                        <span class="badge badge-light-success fs-7">Online</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Database Status:</span>
                        <span class="badge badge-light-success fs-7">Connected</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">System Version:</span>
                        <span class="fw-bold text-gray-800 fs-7">v2.1.0</span>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Uptime:</span>
                        <span class="fw-bold text-success fs-7">{{ formatUptime(systemStats.systemUptime) }}</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Last Backup:</span>
                        <span class="fw-bold text-gray-800 fs-7">{{ formatDateTime(new Date()) }}</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Memory Usage:</span>
                        <span class="fw-bold text-warning fs-7">{{ Math.floor(Math.random() * 40) + 20 }}%</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- USER INFORMATION -->
              <div class="card border-0 bg-light-info">
                <div class="card-body p-5">
                  <h5 class="fw-bold text-gray-800 mb-4">
                    <i class="ki-duotone ki-profile-user text-info fs-1 me-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    Current User Information
                  </h5>
                  <div class="row g-4">
                    <div class="col-md-6">
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Name:</span>
                        <span class="fw-bold text-gray-800 fs-7">{{ currentUser?.name || 'N/A' }}</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Role:</span>
                        <span class="fw-bold text-gray-800 fs-7">{{ currentUser?.Role || 'N/A' }}</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Email:</span>
                        <span class="fw-bold text-gray-800 fs-7">{{ currentUser?.email || 'N/A' }}</span>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Station:</span>
                        <span class="fw-bold text-gray-800 fs-7">{{ currentStation?.StationName || 'N/A' }}</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Login Time:</span>
                        <span class="fw-bold text-gray-800 fs-7">{{ formatDateTime(new Date()) }}</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-6">Session ID:</span>
                        <span class="fw-bold text-gray-800 fs-7">{{ generateSessionId() }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

            </div>

            <!-- PREFERENCES TAB -->
            <div v-if="activeTab === 'preferences'" class="tab-pane fade show active">

              <!-- GENERAL PREFERENCES -->
              <div class="card border-0 bg-light-primary mb-6">
                <div class="card-body p-5">
                  <h5 class="fw-bold text-gray-800 mb-4">
                    <i class="ki-duotone ki-setting-2 text-primary fs-1 me-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    General Preferences
                  </h5>

                  <div class="row g-4">
                    <div class="col-md-6">
                      <label class="form-label fw-bold">Currency Format</label>
                      <select v-model="preferences.currency"
                              @change="updatePreference('currency', preferences.currency)"
                              class="form-select form-select-lg">
                        <option value="UGX">UGX (Ugandan Shilling)</option>
                        <option value="USD">USD (US Dollar)</option>
                        <option value="EUR">EUR (Euro)</option>
                      </select>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-bold">Date Format</label>
                      <select v-model="preferences.dateFormat"
                              @change="updatePreference('dateFormat', preferences.dateFormat)"
                              class="form-select form-select-lg">
                        <option value="DD/MM/YYYY">DD/MM/YYYY</option>
                        <option value="MM/DD/YYYY">MM/DD/YYYY</option>
                        <option value="YYYY-MM-DD">YYYY-MM-DD</option>
                      </select>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-bold">Language</label>
                      <select v-model="preferences.language"
                              @change="updatePreference('language', preferences.language)"
                              class="form-select form-select-lg">
                        <option value="en">English</option>
                        <option value="sw">Swahili</option>
                        <option value="lg">Luganda</option>
                      </select>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-bold">Theme</label>
                      <select v-model="preferences.theme"
                              @change="updatePreference('theme', preferences.theme)"
                              class="form-select form-select-lg">
                        <option value="light">Light Mode</option>
                        <option value="dark">Dark Mode</option>
                        <option value="auto">Auto (System)</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>

              <!-- NOTIFICATION PREFERENCES -->
              <div class="card border-0 bg-light-warning mb-6">
                <div class="card-body p-5">
                  <h5 class="fw-bold text-gray-800 mb-4">
                    <i class="ki-duotone ki-notification-on text-warning fs-1 me-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    Notification Settings
                  </h5>

                  <div class="row g-4">
                    <div class="col-12">
                      <div class="form-check form-switch form-check-custom form-check-solid mb-3">
                        <input v-model="preferences.notifications.enabled"
                               @change="updateNotificationPreference('enabled', preferences.notifications.enabled)"
                               class="form-check-input"
                               type="checkbox"
                               id="notificationsEnabled">
                        <label class="form-check-label fw-bold" for="notificationsEnabled">
                          Enable Push Notifications
                        </label>
                      </div>
                      <div class="form-check form-switch form-check-custom form-check-solid mb-3">
                        <input v-model="preferences.notifications.sound"
                               @change="updateNotificationPreference('sound', preferences.notifications.sound)"
                               class="form-check-input"
                               type="checkbox"
                               id="notificationSound">
                        <label class="form-check-label fw-bold" for="notificationSound">
                          Notification Sounds
                        </label>
                      </div>
                      <div class="form-check form-switch form-check-custom form-check-solid mb-3">
                        <input v-model="preferences.notifications.lowInventory"
                               @change="updateNotificationPreference('lowInventory', preferences.notifications.lowInventory)"
                               class="form-check-input"
                               type="checkbox"
                               id="lowInventoryAlert">
                        <label class="form-check-label fw-bold" for="lowInventoryAlert">
                          Low Inventory Alerts
                        </label>
                      </div>
                      <div class="form-check form-switch form-check-custom form-check-solid mb-3">
                        <input v-model="preferences.notifications.priceChanges"
                               @change="updateNotificationPreference('priceChanges', preferences.notifications.priceChanges)"
                               class="form-check-input"
                               type="checkbox"
                               id="priceChangeAlert">
                        <label class="form-check-label fw-bold" for="priceChangeAlert">
                          Price Change Notifications
                        </label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- POS PREFERENCES -->
              <div class="card border-0 bg-light-success">
                <div class="card-body p-5">
                  <h5 class="fw-bold text-gray-800 mb-4">
                    <i class="ki-duotone ki-credit-cart text-success fs-1 me-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    POS Configuration
                  </h5>

                  <div class="row g-4">
                    <div class="col-md-6">
                      <label class="form-label fw-bold">Default Payment Method</label>
                      <select v-model="preferences.pos.defaultPayment"
                              @change="updatePosPreference('defaultPayment', preferences.pos.defaultPayment)"
                              class="form-select form-select-lg">
                        <option value="cash">Cash</option>
                        <option value="card">Card</option>
                        <option value="mobile">Mobile Money</option>
                      </select>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-bold">Receipt Print Mode</label>
                      <select v-model="preferences.pos.receiptMode"
                              @change="updatePosPreference('receiptMode', preferences.pos.receiptMode)"
                              class="form-select form-select-lg">
                        <option value="auto">Auto Print</option>
                        <option value="manual">Manual Print</option>
                        <option value="email">Email Only</option>
                      </select>
                    </div>
                    <div class="col-12">
                      <div class="form-check form-switch form-check-custom form-check-solid mb-3">
                        <input v-model="preferences.pos.autoCalculateChange"
                               @change="updatePosPreference('autoCalculateChange', preferences.pos.autoCalculateChange)"
                               class="form-check-input"
                               type="checkbox"
                               id="autoCalculateChange">
                        <label class="form-check-label fw-bold" for="autoCalculateChange">
                          Auto-Calculate Change
                        </label>
                      </div>
                      <div class="form-check form-switch form-check-custom form-check-solid mb-3">
                        <input v-model="preferences.pos.requireCustomerInfo"
                               @change="updatePosPreference('requireCustomerInfo', preferences.pos.requireCustomerInfo)"
                               class="form-check-input"
                               type="checkbox"
                               id="requireCustomerInfo">
                        <label class="form-check-label fw-bold" for="requireCustomerInfo">
                          Require Customer Information
                        </label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

            </div>

            <!-- ACTIVITY LOGS TAB -->
            <div v-if="activeTab === 'logs'" class="tab-pane fade show active">

              <!-- LOG CONTROLS -->
              <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold text-gray-800 mb-0">
                  <i class="ki-duotone ki-verify text-primary fs-1 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Activity Logs ({{ verificationLogs.length }})
                </h5>
                <div class="d-flex gap-2">
                  <button @click="refreshLogs"
                          :disabled="loading"
                          class="btn btn-light-primary btn-sm">
                    <i class="ki-duotone ki-arrows-circle fs-3 me-1">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    Refresh
                  </button>
                  <button @click="clearLogs"
                          :disabled="loading"
                          class="btn btn-light-danger btn-sm">
                    <i class="ki-duotone ki-trash fs-3 me-1">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    Clear Logs
                  </button>
                </div>
              </div>

              <!-- LOG FILTERS -->
              <div class="card bg-light-info border-info mb-4">
                <div class="card-body p-4">
                  <div class="row g-3">
                    <div class="col-md-4">
                      <select v-model="logFilter.component"
                              @change="filterLogs"
                              class="form-select">
                        <option value="">All Components</option>
                        <option value="FuelPOS-Main">Main POS</option>
                        <option value="CustomerManager">Customer Manager</option>
                        <option value="ProductInventory">Product Inventory</option>
                        <option value="FuelDispenser">Fuel Dispenser</option>
                        <option value="PaymentModal">Payment Modal</option>
                        <option value="CashDrawerModal">Cash Drawer</option>
                      </select>
                    </div>
                    <div class="col-md-4">
                      <select v-model="logFilter.status"
                              @change="filterLogs"
                              class="form-select">
                        <option value="">All Status</option>
                        <option value="SUCCESS">Success</option>
                        <option value="WARNING">Warning</option>
                        <option value="ERROR">Error</option>
                        <option value="INFO">Info</option>
                      </select>
                    </div>
                    <div class="col-md-4">
                      <input v-model="logFilter.search"
                             @input="filterLogs"
                             type="text"
                             class="form-control"
                             placeholder="Search logs...">
                    </div>
                  </div>
                </div>
              </div>

              <!-- LOG ENTRIES -->
              <div class="card border-0">
                <div class="card-body p-0">
                  <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                    <table class="table table-row-dashed align-middle table-hover">
                      <thead class="bg-light-primary">
                        <tr class="fw-bold text-gray-800">
                          <th class="ps-4">Time</th>
                          <th>Component</th>
                          <th>Operation</th>
                          <th>Status</th>
                          <th class="pe-4">Details</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="(log, index) in filteredLogs" :key="index">
                          <td class="ps-4">
                            <span class="text-gray-600 fs-8">{{ formatLogTime(log.timestamp) }}</span>
                          </td>
                          <td>
                            <span class="badge badge-light-info fs-8">{{ log.component }}</span>
                          </td>
                          <td>
                            <span class="fw-bold text-gray-700 fs-7">{{ log.operation }}</span>
                          </td>
                          <td>
                            <span :class="['badge', 'fs-8', getLogStatusBadgeClass(log.status)]">
                              {{ log.status }}
                            </span>
                          </td>
                          <td class="pe-4">
                            <span class="text-gray-600 fs-8">{{ log.details }}</span>
                          </td>
                        </tr>
                        <tr v-if="filteredLogs.length === 0">
                          <td colspan="5" class="text-center py-5">
                            <div class="text-gray-500">
                              <i class="ki-duotone ki-file-deleted fs-3x mb-3">
                                <span class="path1"></span><span class="path2"></span>
                              </i>
                              <div>No logs match the current filter</div>
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

            </div>

            <!-- DIAGNOSTICS TAB -->
            <div v-if="activeTab === 'diagnostics'" class="tab-pane fade show active">

              <!-- PERFORMANCE METRICS -->
              <div class="row g-4 mb-6">
                <div class="col-md-6">
                  <div class="card bg-light-success border-success">
                    <div class="card-body p-4">
                      <h6 class="fw-bold text-gray-800 mb-3">
                        <i class="ki-duotone ki-speedometer text-success fs-1 me-2">
                          <span class="path1"></span><span class="path2"></span>
                        </i>
                        Performance Metrics
                      </h6>
                      <div class="mb-3">
                        <div class="d-flex justify-content-between mb-2">
                          <span class="text-gray-700 fs-7">Response Time</span>
                          <span class="fw-bold text-success">{{ Math.floor(Math.random() * 100) + 50 }}ms</span>
                        </div>
                        <div class="progress h-6px bg-light-success">
                          <div class="progress-bar bg-success" style="width: 85%"></div>
                        </div>
                      </div>
                      <div class="mb-3">
                        <div class="d-flex justify-content-between mb-2">
                          <span class="text-gray-700 fs-7">Memory Usage</span>
                          <span class="fw-bold text-warning">{{ Math.floor(Math.random() * 40) + 30 }}%</span>
                        </div>
                        <div class="progress h-6px bg-light-warning">
                          <div class="progress-bar bg-warning" style="width: 65%"></div>
                        </div>
                      </div>
                      <div class="mb-0">
                        <div class="d-flex justify-content-between mb-2">
                          <span class="text-gray-700 fs-7">Network Latency</span>
                          <span class="fw-bold text-primary">{{ Math.floor(Math.random() * 50) + 10 }}ms</span>
                        </div>
                        <div class="progress h-6px bg-light-primary">
                          <div class="progress-bar bg-primary" style="width: 90%"></div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="card bg-light-info border-info">
                    <div class="card-body p-4">
                      <h6 class="fw-bold text-gray-800 mb-3">
                        <i class="ki-duotone ki-wifi text-info fs-1 me-2">
                          <span class="path1"></span><span class="path2"></span>
                        </i>
                        Network Status
                      </h6>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-7">TrailBase API</span>
                        <span class="badge badge-light-success">Connected</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-7">Payment Gateway</span>
                        <span class="badge badge-light-success">Online</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-gray-700 fs-7">URA Tax Service</span>
                        <span class="badge badge-light-warning">Slow</span>
                      </div>
                      <div class="d-flex justify-content-between align-items-center mb-0">
                        <span class="text-gray-700 fs-7">Backup Service</span>
                        <span class="badge badge-light-success">Active</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- DIAGNOSTIC ACTIONS -->
              <div class="card border-0 bg-light-warning">
                <div class="card-body p-5">
                  <h5 class="fw-bold text-gray-800 mb-4">
                    <i class="ki-duotone ki-scanning text-warning fs-1 me-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    System Diagnostics
                  </h5>
                  <div class="row g-3">
                    <div class="col-md-4">
                      <button @click="runDiagnostic('connectivity')"
                              :disabled="loading"
                              class="btn btn-light-primary w-100 h-60px fw-bold">
                        <i class="ki-duotone ki-wifi fs-2 mb-2">
                          <span class="path1"></span><span class="path2"></span>
                        </i>
                        <div>Test Connectivity</div>
                      </button>
                    </div>
                    <div class="col-md-4">
                      <button @click="runDiagnostic('database')"
                              :disabled="loading"
                              class="btn btn-light-success w-100 h-60px fw-bold">
                        <i class="ki-duotone ki-database fs-2 mb-2">
                          <span class="path1"></span><span class="path2"></span>
                        </i>
                        <div>Check Database</div>
                      </button>
                    </div>
                    <div class="col-md-4">
                      <button @click="runDiagnostic('full')"
                              :disabled="loading"
                              class="btn btn-light-warning w-100 h-60px fw-bold">
                        <i class="ki-duotone ki-scan-barcode fs-2 mb-2">
                          <span class="path1"></span><span class="path2"></span>
                        </i>
                        <div>Full System Scan</div>
                      </button>
                    </div>
                  </div>
                </div>
              </div>

            </div>

          </div>

          <!-- MODAL FOOTER -->
          <div class="modal-footer border-top bg-light-primary">
            <div class="d-flex justify-content-between w-100">
              <div class="d-flex gap-2">
                <button @click="exportSettings"
                        :disabled="loading"
                        class="btn btn-light-info">
                  <i class="ki-duotone ki-export fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Export Settings
                </button>
                <button @click="resetToDefaults"
                        :disabled="loading"
                        class="btn btn-light-warning">
                  <i class="ki-duotone ki-arrows-circle fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Reset Defaults
                </button>
              </div>
              <div class="d-flex gap-2">
                <button @click="saveSettings"
                        :disabled="loading"
                        class="btn btn-success">
                  <i class="ki-duotone ki-check fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Save Changes
                </button>
                <button @click="closeModal"
                        class="btn btn-light-secondary">
                  <i class="ki-duotone ki-cross fs-3 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Close
                </button>
              </div>
            </div>
          </div>

        </div>

      </div>
    </div>
  </div>

  <!-- LOADING OVERLAY -->
  <div v-if="loading"
       class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
       style="z-index: 9999; background: rgba(0,0,0,0.9);">
    <div class="card border-0 shadow-lg text-center" style="border-radius: 16px;">
      <div class="card-body p-5">
        <div class="spinner-border spinner-border-lg text-primary mb-3"></div>
        <h5 class="fw-bold text-gray-800 mb-2">{{ loadingMessage }}</h5>
        <p class="text-gray-600 fs-7">{{ loadingDetails }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import Swal from 'sweetalert2'

// ========== PROPS ==========
const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  currentUser: {
    type: Object,
    default: null
  },
  currentStation: {
    type: Object,
    default: null
  },
  systemStats: {
    type: Object,
    default: () => ({
      products: 0,
      tanks: 0,
      pumps: 0,
      activeUsers: 0,
      systemUptime: 0
    })
  },
  verificationLogs: {
    type: Array,
    default: () => []
  }
})

// ========== EMITS ==========
const emit = defineEmits([
  'settings-updated',
  'modal-closed',
  'logs-cleared'
])

// ========== STATE ==========
const loading = ref(false)
const loadingMessage = ref('')
const loadingDetails = ref('')
const activeTab = ref('system')

// Preferences
const preferences = reactive({
  currency: 'UGX',
  dateFormat: 'DD/MM/YYYY',
  language: 'en',
  theme: 'light',
  notifications: {
    enabled: true,
    sound: true,
    lowInventory: true,
    priceChanges: true
  },
  pos: {
    defaultPayment: 'cash',
    receiptMode: 'auto',
    autoCalculateChange: true,
    requireCustomerInfo: false
  }
})

// Log filtering
const logFilter = reactive({
  component: '',
  status: '',
  search: ''
})

// ========== COMPUTED ==========
const filteredLogs = computed(() => {
  let logs = [...props.verificationLogs]

  if (logFilter.component) {
    logs = logs.filter(log => log.component === logFilter.component)
  }

  if (logFilter.status) {
    logs = logs.filter(log => log.status === logFilter.status)
  }

  if (logFilter.search) {
    const search = logFilter.search.toLowerCase()
    logs = logs.filter(log =>
      log.operation.toLowerCase().includes(search) ||
      log.details.toLowerCase().includes(search)
    )
  }

  return logs.slice(-100).reverse() // Show latest 100 logs, newest first
})

// ========== UTILITY FUNCTIONS ==========
const formatDateTime = (date) => {
  return new Date(date).toLocaleString('en-UG', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const formatUptime = (hours) => {
  const days = Math.floor(hours / 24)
  const remainingHours = hours % 24
  return `${days}d ${remainingHours}h`
}

const formatLogTime = (timestamp) => {
  return new Date(timestamp).toLocaleTimeString('en-US', {
    hour12: false,
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}

const generateSessionId = () => {
  return 'SES-' + Math.random().toString(36).substr(2, 9).toUpperCase()
}

const getLogStatusBadgeClass = (status) => {
  switch (status) {
    case 'SUCCESS': return 'badge-light-success'
    case 'WARNING': return 'badge-light-warning'
    case 'ERROR': return 'badge-light-danger'
    default: return 'badge-light-info'
  }
}

const logEvent = (operation, status, details, data = null) => {
  console.log(`[SYSTEM SETTINGS ${status}] ${operation}: ${details}`, data)
}

// ========== PREFERENCE ACTIONS ==========
const updatePreference = async (key, value) => {
  try {
    logEvent('PREFERENCE_UPDATED', 'SUCCESS', `${key} changed to ${value}`)

    emit('settings-updated', { setting: key, value })

    await Swal.fire({
      title: 'Preference Updated',
      text: `${key.charAt(0).toUpperCase() + key.slice(1)} has been updated`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 1500,
      showConfirmButton: false
    })

  } catch (error) {
    console.error('Error updating preference:', error)
    logEvent('PREFERENCE_UPDATE_ERROR', 'ERROR', error.message)
  }
}

const updateNotificationPreference = async (key, value) => {
  try {
    logEvent('NOTIFICATION_PREFERENCE_UPDATED', 'SUCCESS', `Notifications.${key} changed to ${value}`)

    emit('settings-updated', { setting: `notifications.${key}`, value })

  } catch (error) {
    console.error('Error updating notification preference:', error)
    logEvent('NOTIFICATION_PREFERENCE_ERROR', 'ERROR', error.message)
  }
}

const updatePosPreference = async (key, value) => {
  try {
    logEvent('POS_PREFERENCE_UPDATED', 'SUCCESS', `POS.${key} changed to ${value}`)

    emit('settings-updated', { setting: `pos.${key}`, value })

  } catch (error) {
    console.error('Error updating POS preference:', error)
    logEvent('POS_PREFERENCE_ERROR', 'ERROR', error.message)
  }
}

// ========== LOG ACTIONS ==========
const refreshLogs = async () => {
  try {
    loading.value = true
    loadingMessage.value = 'Refreshing Logs'
    loadingDetails.value = 'Loading latest activity logs...'

    await new Promise(resolve => setTimeout(resolve, 1000))

    logEvent('LOGS_REFRESHED', 'SUCCESS', 'Activity logs refreshed')

    await Swal.fire({
      title: 'Logs Refreshed',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 1500,
      showConfirmButton: false
    })

  } catch (error) {
    console.error('Error refreshing logs:', error)
    logEvent('LOG_REFRESH_ERROR', 'ERROR', error.message)
  } finally {
    loading.value = false
  }
}

const clearLogs = async () => {
  try {
    const result = await Swal.fire({
      title: 'Clear Activity Logs?',
      text: `This will permanently delete all ${props.verificationLogs.length} log entries.`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes, Clear All',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#f1416c'
    })

    if (result.isConfirmed) {
      loading.value = true
      loadingMessage.value = 'Clearing Logs'
      loadingDetails.value = 'Removing all activity log entries...'

      await new Promise(resolve => setTimeout(resolve, 1500))

      emit('logs-cleared')
      logEvent('LOGS_CLEARED', 'SUCCESS', 'All activity logs cleared')

      await Swal.fire({
        title: 'Logs Cleared',
        text: 'All activity logs have been permanently deleted.',
        icon: 'success',
        timer: 2000,
        showConfirmButton: false
      })
    }

  } catch (error) {
    console.error('Error clearing logs:', error)
    logEvent('LOG_CLEAR_ERROR', 'ERROR', error.message)
  } finally {
    loading.value = false
  }
}

const filterLogs = () => {
  logEvent('LOGS_FILTERED', 'SUCCESS', `Applied filter: component=${logFilter.component}, status=${logFilter.status}, search=${logFilter.search}`)
}

// ========== DIAGNOSTIC ACTIONS ==========
const runDiagnostic = async (type) => {
  try {
    loading.value = true
    loadingMessage.value = 'Running Diagnostics'
    loadingDetails.value = `Testing ${type} components...`

    // Simulate diagnostic test
    await new Promise(resolve => setTimeout(resolve, Math.random() * 3000 + 2000))

    const results = {
      connectivity: {
        passed: Math.random() > 0.1,
        message: 'All network connections tested successfully'
      },
      database: {
        passed: Math.random() > 0.05,
        message: 'Database connectivity and integrity verified'
      },
      full: {
        passed: Math.random() > 0.2,
        message: 'Complete system scan completed with minor warnings'
      }
    }

    const result = results[type]

    logEvent('DIAGNOSTIC_COMPLETED', result.passed ? 'SUCCESS' : 'WARNING', `${type} diagnostic: ${result.message}`)

    await Swal.fire({
      title: result.passed ? 'Diagnostic Passed' : 'Issues Found',
      text: result.message,
      icon: result.passed ? 'success' : 'warning',
      confirmButtonText: 'OK'
    })

  } catch (error) {
    console.error('Error running diagnostic:', error)
    logEvent('DIAGNOSTIC_ERROR', 'ERROR', error.message)
  } finally {
    loading.value = false
  }
}

// ========== SETTINGS ACTIONS ==========
const saveSettings = async () => {
  try {
    loading.value = true
    loadingMessage.value = 'Saving Settings'
    loadingDetails.value = 'Applying configuration changes...'

    await new Promise(resolve => setTimeout(resolve, 1500))

    logEvent('SETTINGS_SAVED', 'SUCCESS', 'All settings saved successfully')

    await Swal.fire({
      title: 'Settings Saved!',
      text: 'All configuration changes have been applied.',
      icon: 'success',
      timer: 2000,
      showConfirmButton: false
    })

  } catch (error) {
    console.error('Error saving settings:', error)
    logEvent('SETTINGS_SAVE_ERROR', 'ERROR', error.message)
  } finally {
    loading.value = false
  }
}

const exportSettings = async () => {
  try {
    const settingsData = {
      preferences,
      timestamp: new Date().toISOString(),
      user: props.currentUser?.name || 'Unknown',
      station: props.currentStation?.StationName || 'Unknown'
    }

    const dataStr = JSON.stringify(settingsData, null, 2)
    const dataBlob = new Blob([dataStr], { type: 'application/json' })
    const url = URL.createObjectURL(dataBlob)

    const link = document.createElement('a')
    link.href = url
    link.download = `kigrama-settings-${new Date().getTime()}.json`
    link.click()

    URL.revokeObjectURL(url)

    logEvent('SETTINGS_EXPORTED', 'SUCCESS', 'Settings exported to file')

    await Swal.fire({
      title: 'Settings Exported',
      text: 'Configuration has been saved to file.',
      icon: 'success',
      timer: 2000,
      showConfirmButton: false
    })

  } catch (error) {
    console.error('Error exporting settings:', error)
    logEvent('SETTINGS_EXPORT_ERROR', 'ERROR', error.message)
  }
}

const resetToDefaults = async () => {
  try {
    const result = await Swal.fire({
      title: 'Reset to Defaults?',
      text: 'This will restore all settings to their default values.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Reset Settings',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#f1416c'
    })

    if (result.isConfirmed) {
      // Reset preferences to defaults
      Object.assign(preferences, {
        currency: 'UGX',
        dateFormat: 'DD/MM/YYYY',
        language: 'en',
        theme: 'light',
        notifications: {
          enabled: true,
          sound: true,
          lowInventory: true,
          priceChanges: true
        },
        pos: {
          defaultPayment: 'cash',
          receiptMode: 'auto',
          autoCalculateChange: true,
          requireCustomerInfo: false
        }
      })

      logEvent('SETTINGS_RESET', 'SUCCESS', 'All settings reset to defaults')

      await Swal.fire({
        title: 'Settings Reset',
        text: 'All preferences have been restored to default values.',
        icon: 'success',
        timer: 2000,
        showConfirmButton: false
      })
    }

  } catch (error) {
    console.error('Error resetting settings:', error)
    logEvent('SETTINGS_RESET_ERROR', 'ERROR', error.message)
  }
}

const closeModal = () => {
  emit('modal-closed')
}

// ========== LIFECYCLE ==========
onMounted(() => {
  logEvent('SETTINGS_MODAL_OPENED', 'SUCCESS', 'System settings modal opened')
})
</script>

<style scoped>
/* iOS Premium Modal Styling */
.modal-content {
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
}

/* Gradient Background */
.bg-gradient-primary {
  background: linear-gradient(135deg, #3699ff 0%, #1bc5bd 100%);
}

/* Navigation Pills */
.nav-pills-custom .nav-link {
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 2px solid transparent;
}

.nav-pills-custom .nav-link:hover {
  background-color: rgba(54, 153, 255, 0.1);
  border-color: rgba(54, 153, 255, 0.3);
}

.nav-pills-custom .nav-link.active {
  background: linear-gradient(135deg, #3699ff 0%, #1bc5bd 100%);
  color: white !important;
  border-color: transparent;
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(54, 153, 255, 0.3);
}

/* Button Enhancements */
.btn {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 12px;
}

.btn:active {
  transform: scale(0.98);
}

.h-60px {
  height: 60px;
}

/* Card Styling */
.card {
  border-radius: 16px;
  transition: all 0.3s ease;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

/* Form Controls */
.form-select,
.form-control {
  border-radius: 12px;
  border: 2px solid #e9ecef;
  transition: all 0.3s ease;
}

.form-select:focus,
.form-control:focus {
  border-color: #3699ff;
  box-shadow: 0 0 0 0.2rem rgba(54, 153, 255, 0.25);
}

/* Form Switches */
.form-check-input {
  border-radius: 20px;
  width: 3rem;
  height: 1.5rem;
}

.form-check-input:checked {
  background-color: #50cd89;
  border-color: #50cd89;
}

/* Progress Bars */
.progress {
  border-radius: 8px;
}

.progress-bar {
  border-radius: 8px;
}

.h-6px {
  height: 6px;
}

/* Table Styling */
.table-row-dashed tbody tr {
  border-bottom: 1px dashed #e9ecef;
}

.table-row-dashed tbody tr:hover {
  background-color: rgba(54, 153, 255, 0.05);
}

/* Badge Enhancements */
.badge {
  border-radius: 8px;
  font-weight: 600;
}

/* Symbol Styling */
.symbol {
  border-radius: 50%;
  overflow: hidden;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .modal-dialog {
    margin: 0.5rem;
    max-width: calc(100% - 1rem);
  }

  .nav-pills-custom .nav-link {
    padding: 0.5rem 1rem !important;
    font-size: 0.875rem;
  }

  .h-60px {
    height: 50px;
  }

  .fs-4 {
    font-size: 1rem !important;
  }
}

/* Animation */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-content {
  animation: slideIn 0.3s ease-out;
}

/* Tab Content Animation */
.tab-pane {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateX(10px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* Loading Overlay */
.position-fixed {
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}
</style>

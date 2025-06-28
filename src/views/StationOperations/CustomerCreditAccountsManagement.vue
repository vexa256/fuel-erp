<template>
  <!-- Station Selection Header -->
  <div class="card card-flush shadow-sm mb-5">
    <div class="card-header pt-6">
      <div class="card-title">
        <div class="d-flex align-items-center">
          <i class="ki-duotone ki-bank fs-2 text-primary me-3">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <h3 class="fw-bold mb-0">Customer Credit Management</h3>
        </div>
      </div>
      <div class="card-toolbar">
        <div class="d-flex align-items-center gap-3">
          <select
            v-model="selectedStationId"
            @change="handleStationChange"
            class="form-select form-select-lg w-250px"
          >
            <option value="">Select Station</option>
            <option
              v-for="station in userStations"
              :key="station.StationID"
              :value="station.StationID"
            >
              {{ station.StationName }}
            </option>
          </select>
          <button @click="refreshData" class="btn btn-light-primary" :disabled="loading">
            <i class="ki-duotone ki-arrows-circle fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Refresh
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Credit Risk Alert Banner -->
  <div v-if="riskAlerts.length > 0" class="alert alert-warning d-flex align-items-center p-5 mb-5">
    <i class="ki-duotone ki-shield-cross fs-2hx text-warning me-4">
      <span class="path1"></span>
      <span class="path2"></span>
      <span class="path3"></span>
    </i>
    <div class="d-flex flex-column">
      <h4 class="mb-1 text-warning">Credit Risk Alerts</h4>
      <span class="fs-6">{{ riskAlerts.length }} account(s) require immediate attention</span>
    </div>
  </div>

  <!-- KPI Summary Cards -->
  <div class="row g-5 g-xl-8 mb-5" v-if="selectedStationId">
    <div class="col-6 col-md-3">
      <div class="card card-flush h-xl-100">
        <div class="card-body">
          <div class="d-flex align-items-center">
            <div class="symbol symbol-45px me-3">
              <span class="symbol-label bg-light-success">
                <i class="ki-duotone ki-people fs-2 text-success">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                </i>
              </span>
            </div>
            <div class="flex-grow-1">
              <span class="text-gray-500 fw-semibold d-block fs-7">Total Customers</span>
              <span class="text-gray-800 fw-bold fs-2">{{ kpiData.totalCustomers }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-6 col-md-3">
      <div class="card card-flush h-xl-100">
        <div class="card-body">
          <div class="d-flex align-items-center">
            <div class="symbol symbol-45px me-3">
              <span class="symbol-label bg-light-warning">
                <i class="ki-duotone ki-wallet fs-2 text-warning">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                </i>
              </span>
            </div>
            <div class="flex-grow-1">
              <span class="text-gray-500 fw-semibold d-block fs-7">Active Credit</span>
              <span class="text-gray-800 fw-bold fs-2">{{ kpiData.activeCreditAccounts }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-6 col-md-3">
      <div class="card card-flush h-xl-100">
        <div class="card-body">
          <div class="d-flex align-items-center">
            <div class="symbol symbol-45px me-3">
              <span class="symbol-label bg-light-danger">
                <i class="ki-duotone ki-bill fs-2 text-danger">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
              </span>
            </div>
            <div class="flex-grow-1">
              <span class="text-gray-500 fw-semibold d-block fs-7">Outstanding</span>
              <span class="text-gray-800 fw-bold fs-2"
                >UGX {{ formatCurrency(kpiData.totalOutstanding) }}</span
              >
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-6 col-md-3">
      <div class="card card-flush h-xl-100">
        <div class="card-body">
          <div class="d-flex align-items-center">
            <div class="symbol symbol-45px me-3">
              <span class="symbol-label bg-light-info">
                <i class="ki-duotone ki-percentage fs-2 text-info">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </span>
            </div>
            <div class="flex-grow-1">
              <span class="text-gray-500 fw-semibold d-block fs-7">Avg Utilization</span>
              <span class="text-gray-800 fw-bold fs-2">{{ kpiData.avgUtilization }}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Main Content Tabs -->
  <div class="card card-flush">
    <div class="card-header pt-6">
      <ul class="nav nav-tabs nav-line-tabs nav-line-tabs-2x border-transparent fs-4 fw-semibold">
        <li class="nav-item">
          <a
            class="nav-link text-active-primary pb-4"
            :class="{ active: activeTab === 'customers' }"
            @click="activeTab = 'customers'"
          >
            <i class="ki-duotone ki-people fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
              <span class="path5"></span>
            </i>
            Customer Registry
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link text-active-primary pb-4"
            :class="{ active: activeTab === 'credit' }"
            @click="activeTab = 'credit'"
          >
            <i class="ki-duotone ki-bill fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
              <span class="path5"></span>
              <span class="path6"></span>
            </i>
            Credit Monitoring
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link text-active-primary pb-4"
            :class="{ active: activeTab === 'payments' }"
            @click="activeTab = 'payments'"
          >
            <i class="ki-duotone ki-wallet fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
            </i>
            Payment Processing
          </a>
        </li>
        <li class="nav-item">
          <a
            class="nav-link text-active-primary pb-4"
            :class="{ active: activeTab === 'aging' }"
            @click="activeTab = 'aging'"
          >
            <i class="ki-duotone ki-chart-line fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Aging Analysis
          </a>
        </li>
      </ul>
    </div>

    <div class="card-body pt-6">
      <!-- Station Selection Warning -->
      <div v-if="!selectedStationId" class="alert alert-info d-flex align-items-center p-5 mb-5">
        <i class="ki-duotone ki-information-5 fs-2hx text-info me-4">
          <span class="path1"></span>
          <span class="path2"></span>
          <span class="path3"></span>
        </i>
        <div class="d-flex flex-column">
          <h4 class="mb-1 text-info">Station Selection Required</h4>
          <span class="fs-6"
            >Please select a station from the dropdown above to view and manage customer credit
            accounts.</span
          >
        </div>
      </div>

      <!-- Customers Tab -->
      <div v-if="activeTab === 'customers' && selectedStationId">
        <div class="d-flex justify-content-between align-items-center mb-5">
          <div class="position-relative w-300px">
            <i
              class="ki-duotone ki-magnifier fs-3 text-gray-500 position-absolute top-50 translate-middle ms-6"
            >
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <input
              v-model="customerSearch"
              type="text"
              class="form-control form-control-lg ps-13"
              placeholder="Search customers..."
            />
          </div>
          <button @click="showAddCustomerModal" class="btn btn-light-primary">
            <i class="ki-duotone ki-plus fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Add Customer
          </button>
        </div>

        <div class="row g-5" v-if="filteredCustomers.length > 0">
          <div
            class="col-12 col-md-6 col-xl-4"
            v-for="customer in filteredCustomers"
            :key="customer.CustomerID"
          >
            <div class="card card-flush h-100 shadow-sm">
              <div class="card-header pt-6">
                <div class="card-title">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <span
                        class="symbol-label"
                        :class="getCustomerTypeSymbol(customer.CustomerType)"
                      >
                        {{ getCustomerInitials(customer) }}
                      </span>
                    </div>
                    <div>
                      <div class="fw-bold text-gray-800 fs-6">{{ getCustomerName(customer) }}</div>
                      <div class="text-gray-500 fs-7">{{ customer.CustomerCode }}</div>
                    </div>
                  </div>
                </div>
                <div class="card-toolbar">
                  <span class="badge" :class="getCustomerStatusBadge(customer.Status)">
                    {{ customer.Status }}
                  </span>
                </div>
              </div>
              <div class="card-body pt-3">
                <div class="row g-3 mb-4">
                  <div class="col-12">
                    <div class="text-gray-500 fs-7">Type</div>
                    <div class="fw-semibold">{{ customer.CustomerType }}</div>
                  </div>
                  <div class="col-12">
                    <div class="text-gray-500 fs-7">Contact</div>
                    <div class="fw-semibold">{{ customer.PhoneNumber }}</div>
                  </div>
                  <div class="col-12">
                    <div class="text-gray-500 fs-7">Registration</div>
                    <div class="fw-semibold">{{ formatDate(customer.RegistrationDate) }}</div>
                  </div>
                </div>
                <div class="separator my-4"></div>
                <div class="d-flex justify-content-between">
                  <button @click="viewCustomer(customer)" class="btn btn-sm btn-light-primary">
                    View
                  </button>
                  <button
                    @click="manageCreditAccount(customer)"
                    class="btn btn-sm btn-light-success"
                  >
                    Credit
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-else-if="selectedStationId && !loading" class="text-center py-10">
          <i class="ki-duotone ki-file-deleted fs-3x text-gray-400 mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <h3 class="text-gray-600 mb-3">No Customers Found</h3>
          <p class="text-gray-500 mb-5">No customers are registered for this station yet.</p>
          <button @click="showAddCustomerModal" class="btn btn-primary">Add First Customer</button>
        </div>
      </div>

      <!-- Credit Monitoring Tab -->
      <div v-if="activeTab === 'credit' && selectedStationId">
        <div class="d-flex justify-content-between align-items-center mb-5">
          <div class="d-flex align-items-center gap-3">
            <select v-model="creditFilter" class="form-select w-150px">
              <option value="">All Accounts</option>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
              <option value="OverLimit">Over Limit</option>
              <option value="NearLimit">Near Limit</option>
              <option value="HighUtilization">High Utilization</option>
            </select>
          </div>
          <div class="d-flex gap-2">
            <button @click="generateCreditReport" class="btn btn-light-info">
              <i class="ki-duotone ki-file-down fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Report
            </button>
            <button @click="runCreditMonitoring" class="btn btn-light-warning">
              <i class="ki-duotone ki-scan-barcode fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
                <span class="path5"></span>
                <span class="path6"></span>
              </i>
              Monitor
            </button>
          </div>
        </div>

        <div class="row g-5" v-if="filteredCreditAccounts.length > 0">
          <div
            class="col-12 col-md-6 col-xl-4"
            v-for="account in filteredCreditAccounts"
            :key="account.CreditAccountID"
          >
            <div
              class="card card-flush h-100 shadow-sm"
              :class="getCreditAccountCardClass(account)"
            >
              <div class="card-header pt-6">
                <div class="card-title">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <span class="symbol-label bg-light-success text-success fw-bold">
                        {{ getCustomerInitials(account) }}
                      </span>
                    </div>
                    <div>
                      <div class="fw-bold text-gray-800 fs-6">{{ getCustomerName(account) }}</div>
                      <div class="text-gray-500 fs-7">{{ account.CustomerCode }}</div>
                    </div>
                  </div>
                </div>
                <div class="card-toolbar">
                  <span class="badge" :class="getCreditStatusBadge(getCreditStatus(account))">
                    {{ getCreditStatus(account) }}
                  </span>
                </div>
              </div>
              <div class="card-body pt-3">
                <div class="row g-3 mb-4">
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Credit Limit</div>
                    <div class="fw-bold text-gray-800">
                      UGX {{ formatCurrency(account.CreditLimit) }}
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Available</div>
                    <div class="fw-bold text-success">
                      UGX {{ formatCurrency(account.AvailableCredit) }}
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Outstanding</div>
                    <div class="fw-bold text-danger">
                      UGX {{ formatCurrency(account.CurrentBalance) }}
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Utilization</div>
                    <div
                      class="fw-bold"
                      :class="getUtilizationColor(getCreditUtilization(account))"
                    >
                      {{ getCreditUtilization(account) }}%
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Credit Score</div>
                    <div class="fw-bold" :class="getCreditScoreColor(account.CreditScore)">
                      {{ account.CreditScore }}%
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Payment Terms</div>
                    <div class="fw-bold">{{ account.PaymentTermsDays }} days</div>
                  </div>
                </div>
                <div class="separator my-4"></div>
                <div class="d-flex justify-content-between">
                  <button @click="adjustCredit(account)" class="btn btn-sm btn-light-warning">
                    Adjust
                  </button>
                  <button @click="recordPayment(account)" class="btn btn-sm btn-light-success">
                    Payment
                  </button>
                  <button @click="viewAccountDetails(account)" class="btn btn-sm btn-light-primary">
                    Details
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-else-if="selectedStationId && !loading" class="text-center py-10">
          <i class="ki-duotone ki-wallet fs-3x text-gray-400 mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
          </i>
          <h3 class="text-gray-600 mb-3">No Credit Accounts</h3>
          <p class="text-gray-500">No credit accounts are active for this station.</p>
        </div>
      </div>

      <!-- Payment Processing Tab -->
      <div v-if="activeTab === 'payments' && selectedStationId">
        <div class="d-flex justify-content-between align-items-center mb-5">
          <div class="d-flex align-items-center gap-3">
            <input v-model="paymentDateFilter" type="date" class="form-control w-150px" />
            <select v-model="paymentMethodFilter" class="form-select w-150px">
              <option value="">All Methods</option>
              <option value="Cash">Cash</option>
              <option value="Bank Transfer">Bank Transfer</option>
              <option value="Mobile Money">Mobile Money</option>
              <option value="Card">Card</option>
            </select>
            <select v-model="paymentStatusFilter" class="form-select w-150px">
              <option value="">All Status</option>
              <option value="Completed">Completed</option>
              <option value="Pending">Pending</option>
              <option value="Failed">Failed</option>
            </select>
          </div>
          <button @click="exportPayments" class="btn btn-light-success">
            <i class="ki-duotone ki-file-down fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Export
          </button>
        </div>

        <div class="table-responsive" v-if="filteredPayments.length > 0">
          <table class="table align-middle table-row-dashed fs-6 gy-5">
            <thead>
              <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                <th>Date & Time</th>
                <th>Customer</th>
                <th>Amount</th>
                <th>Method</th>
                <th>Reference</th>
                <th>Status</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody class="fw-semibold text-gray-600">
              <tr v-for="payment in filteredPayments" :key="payment.PaymentID">
                <td>{{ formatDateTime(payment.PaymentDate) }}</td>
                <td>
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-35px me-3">
                      <span class="symbol-label bg-light-primary text-primary fw-bold fs-7">
                        {{ getCustomerInitials(payment) }}
                      </span>
                    </div>
                    <div>
                      <div class="fw-bold">{{ getCustomerName(payment) }}</div>
                      <div class="text-gray-500 fs-7">{{ payment.CustomerCode }}</div>
                    </div>
                  </div>
                </td>
                <td class="fw-bold text-success">
                  UGX {{ formatCurrency(payment.PaymentAmount) }}
                </td>
                <td>
                  <span class="badge badge-light-info">{{ payment.PaymentMethod }}</span>
                </td>
                <td>
                  <div class="fw-semibold">{{ payment.PaymentReference }}</div>
                  <div class="text-gray-500 fs-7" v-if="payment.MobileMoneyReference">
                    {{ payment.MobileMoneyReference }}
                  </div>
                  <div class="text-gray-500 fs-7" v-if="payment.BankReference">
                    {{ payment.BankReference }}
                  </div>
                </td>
                <td>
                  <span class="badge" :class="getPaymentStatusBadge(payment.Status)">
                    {{ payment.Status }}
                  </span>
                </td>
                <td class="text-end">
                  <button @click="viewPaymentDetails(payment)" class="btn btn-sm btn-light-primary">
                    View
                  </button>
                  <button
                    v-if="payment.Status === 'Pending'"
                    @click="verifyPayment(payment)"
                    class="btn btn-sm btn-light-success ms-1"
                  >
                    Verify
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div v-else-if="selectedStationId && !loading" class="text-center py-10">
          <i class="ki-duotone ki-bill fs-3x text-gray-400 mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
            <span class="path5"></span>
            <span class="path6"></span>
          </i>
          <h3 class="text-gray-600 mb-3">No Payments Found</h3>
          <p class="text-gray-500">No payment records match the current filters.</p>
        </div>
      </div>

      <!-- Aging Analysis Tab -->
      <div v-if="activeTab === 'aging' && selectedStationId">
        <div class="row g-5 mb-5">
          <div class="col-12 col-md-3" v-for="bucket in agingBuckets" :key="bucket.name">
            <div class="card card-flush h-100">
              <div class="card-body">
                <div class="d-flex align-items-center">
                  <div class="symbol symbol-45px me-3">
                    <span class="symbol-label" :class="bucket.colorClass">
                      <i class="ki-duotone ki-calendar fs-2" :class="bucket.iconClass">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </span>
                  </div>
                  <div class="flex-grow-1">
                    <span class="text-gray-500 fw-semibold d-block fs-7">{{ bucket.name }}</span>
                    <span class="text-gray-800 fw-bold fs-2"
                      >UGX {{ formatCurrency(bucket.amount) }}</span
                    >
                    <span class="text-gray-500 fs-7 d-block">{{ bucket.count }} transactions</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="table-responsive" v-if="outstandingBalances.length > 0">
          <table class="table align-middle table-row-dashed fs-6 gy-5">
            <thead>
              <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                <th>Customer</th>
                <th>Transaction Date</th>
                <th>Amount</th>
                <th>Outstanding</th>
                <th>Days Outstanding</th>
                <th>Aging Bucket</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody class="fw-semibold text-gray-600">
              <tr v-for="balance in outstandingBalances" :key="balance.TransactionID">
                <td>
                  <div class="fw-bold">{{ balance.CustomerName }}</div>
                  <div class="text-gray-500 fs-7">{{ balance.CustomerCode }}</div>
                </td>
                <td>{{ formatDate(balance.TransactionDate) }}</td>
                <td class="fw-bold">UGX {{ formatCurrency(balance.TotalAmount) }}</td>
                <td class="fw-bold text-danger">
                  UGX {{ formatCurrency(balance.OutstandingAmount) }}
                </td>
                <td>{{ Math.floor(balance.DaysOutstanding) }} days</td>
                <td>
                  <span class="badge" :class="getAgingBadge(balance.AgingBucket)">
                    {{ balance.AgingBucket }}
                  </span>
                </td>
                <td class="text-end">
                  <button @click="followUpPayment(balance)" class="btn btn-sm btn-light-warning">
                    Follow Up
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <!-- Add Customer Modal -->
  <div
    class="modal fade"
    id="addCustomerModal"
    tabindex="-1"
    aria-hidden="true"
    ref="addCustomerModal"
  >
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h2 class="fw-bold">Add New Customer</h2>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <form @submit.prevent="handleAddCustomer" novalidate>
            <div class="row g-5">
              <div class="col-12">
                <label class="required form-label">Customer Type</label>
                <select
                  v-model="newCustomerForm.CustomerType"
                  class="form-select form-select-lg"
                  :class="{ 'is-invalid': validationErrors.CustomerType }"
                  required
                >
                  <option value="Individual">Individual</option>
                  <option value="Corporate">Corporate</option>
                  <option value="Fleet">Fleet</option>
                </select>
                <div v-if="validationErrors.CustomerType" class="invalid-feedback">
                  {{ validationErrors.CustomerType }}
                </div>
              </div>

              <div class="col-12 col-md-6" v-if="newCustomerForm.CustomerType === 'Individual'">
                <label class="required form-label">First Name</label>
                <input
                  v-model="newCustomerForm.FirstName"
                  type="text"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': validationErrors.FirstName }"
                  required
                />
                <div v-if="validationErrors.FirstName" class="invalid-feedback">
                  {{ validationErrors.FirstName }}
                </div>
              </div>

              <div class="col-12 col-md-6" v-if="newCustomerForm.CustomerType === 'Individual'">
                <label class="required form-label">Last Name</label>
                <input
                  v-model="newCustomerForm.LastName"
                  type="text"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': validationErrors.LastName }"
                  required
                />
                <div v-if="validationErrors.LastName" class="invalid-feedback">
                  {{ validationErrors.LastName }}
                </div>
              </div>

              <div class="col-12" v-if="newCustomerForm.CustomerType !== 'Individual'">
                <label class="required form-label">Company Name</label>
                <input
                  v-model="newCustomerForm.CompanyName"
                  type="text"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': validationErrors.CompanyName }"
                  required
                />
                <div v-if="validationErrors.CompanyName" class="invalid-feedback">
                  {{ validationErrors.CompanyName }}
                </div>
              </div>

              <div class="col-12 col-md-6">
                <label class="required form-label">Phone Number</label>
                <input
                  v-model="newCustomerForm.PhoneNumber"
                  type="tel"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': validationErrors.PhoneNumber }"
                  required
                />
                <div v-if="validationErrors.PhoneNumber" class="invalid-feedback">
                  {{ validationErrors.PhoneNumber }}
                </div>
              </div>

              <div class="col-12 col-md-6">
                <label class="form-label">Email</label>
                <input
                  v-model="newCustomerForm.Email"
                  type="email"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': validationErrors.Email }"
                />
                <div v-if="validationErrors.Email" class="invalid-feedback">
                  {{ validationErrors.Email }}
                </div>
              </div>

              <div class="col-12 col-md-6">
                <label class="form-label">National ID</label>
                <input
                  v-model="newCustomerForm.NationalID"
                  type="text"
                  class="form-control form-control-lg"
                />
              </div>

              <div class="col-12 col-md-6">
                <label class="form-label">Tax ID</label>
                <input
                  v-model="newCustomerForm.TaxID"
                  type="text"
                  class="form-control form-control-lg"
                />
              </div>

              <div class="col-12">
                <label class="form-label">Address</label>
                <textarea
                  v-model="newCustomerForm.Address"
                  class="form-control form-control-lg"
                  rows="3"
                ></textarea>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button @click="handleAddCustomer" class="btn btn-primary" :disabled="saving">
            <span v-if="saving" class="spinner-border spinner-border-sm me-2"></span>
            Add Customer
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Credit Adjustment Modal -->
  <div
    class="modal fade"
    id="creditAdjustmentModal"
    tabindex="-1"
    aria-hidden="true"
    ref="creditAdjustmentModal"
  >
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h2 class="fw-bold">Credit Adjustment</h2>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div v-if="selectedCreditAccount">
            <div class="card card-flush bg-light mb-5">
              <div class="card-body">
                <div class="fw-bold text-gray-800 mb-2">
                  {{ getCustomerName(selectedCreditAccount) }}
                </div>
                <div class="row g-3">
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Current Limit</div>
                    <div class="fw-bold">
                      UGX {{ formatCurrency(selectedCreditAccount.CreditLimit) }}
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Outstanding</div>
                    <div class="fw-bold text-danger">
                      UGX {{ formatCurrency(selectedCreditAccount.CurrentBalance) }}
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Available</div>
                    <div class="fw-bold text-success">
                      UGX {{ formatCurrency(selectedCreditAccount.AvailableCredit) }}
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-gray-500 fs-7">Utilization</div>
                    <div class="fw-bold">{{ getCreditUtilization(selectedCreditAccount) }}%</div>
                  </div>
                </div>
              </div>
            </div>

            <form @submit.prevent="handleCreditAdjustment" novalidate>
              <div class="mb-5">
                <label class="required form-label">Adjustment Type</label>
                <select
                  v-model="creditAdjustmentForm.type"
                  class="form-select form-select-lg"
                  required
                >
                  <option value="limit_increase">Increase Credit Limit</option>
                  <option value="limit_decrease">Decrease Credit Limit</option>
                  <option value="balance_adjustment_positive">Increase Outstanding Balance</option>
                  <option value="balance_adjustment_negative">Decrease Outstanding Balance</option>
                </select>
              </div>

              <div class="mb-5">
                <label class="required form-label">Amount (UGX)</label>
                <input
                  v-model="creditAdjustmentForm.amount"
                  type="number"
                  class="form-control form-control-lg"
                  required
                  min="0"
                  step="1000"
                />
              </div>

              <div class="mb-5">
                <label class="required form-label">Reason</label>
                <textarea
                  v-model="creditAdjustmentForm.reason"
                  class="form-control form-control-lg"
                  rows="3"
                  required
                  placeholder="Provide detailed justification for this adjustment..."
                ></textarea>
              </div>

              <div class="alert alert-warning">
                <strong>Warning:</strong> This adjustment will be logged for audit purposes and
                requires management approval.
              </div>
            </form>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
          <button @click="handleCreditAdjustment" class="btn btn-warning" :disabled="saving">
            <span v-if="saving" class="spinner-border spinner-border-sm me-2"></span>
            Apply Adjustment
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// Authentication data from login system
const authData = JSON.parse(localStorage.getItem('kigrama_user_data') || '{}')
const currentUser = authData.user || {}
const userStations = authData.stations || []

// Reactive State
const loading = ref(false)
const saving = ref(false)
const selectedStationId = ref('')
const activeTab = ref('customers')

// Search and Filter States
const customerSearch = ref('')
const creditFilter = ref('')
const paymentDateFilter = ref('')
const paymentMethodFilter = ref('')
const paymentStatusFilter = ref('')

// Data Arrays
const customers = ref([])
const creditAccounts = ref([])
const payments = ref([])
const outstandingBalances = ref([])
const riskAlerts = ref([])

// KPI Data
const kpiData = reactive({
  totalCustomers: 0,
  activeCreditAccounts: 0,
  totalOutstanding: 0,
  avgUtilization: 0,
})

// Aging Analysis Data
const agingBuckets = ref([
  {
    name: 'Current (0-30 days)',
    amount: 0,
    count: 0,
    colorClass: 'bg-light-success',
    iconClass: 'text-success',
  },
  {
    name: '31-60 Days',
    amount: 0,
    count: 0,
    colorClass: 'bg-light-warning',
    iconClass: 'text-warning',
  },
  {
    name: '61-90 Days',
    amount: 0,
    count: 0,
    colorClass: 'bg-light-danger',
    iconClass: 'text-danger',
  },
  { name: '90+ Days', amount: 0, count: 0, colorClass: 'bg-light-dark', iconClass: 'text-dark' },
])

// Modal Forms
const newCustomerForm = reactive({
  CustomerType: 'Individual',
  FirstName: '',
  LastName: '',
  CompanyName: '',
  PhoneNumber: '',
  Email: '',
  NationalID: '',
  TaxID: '',
  Address: '',
})

const creditAdjustmentForm = reactive({
  type: 'limit_increase',
  amount: '',
  reason: '',
})

const validationErrors = reactive({})
const selectedCreditAccount = ref(null)

// Data Validation Functions - STRICT mode compliance
const validateCustomerForm = () => {
  // Clear all previous errors
  Object.keys(validationErrors).forEach((key) => {
    validationErrors[key] = ''
  })

  let isValid = true

  // CustomerType validation - must be enum value
  const validCustomerTypes = ['Individual', 'Corporate', 'Fleet']
  if (!validCustomerTypes.includes(newCustomerForm.CustomerType)) {
    validationErrors.CustomerType = 'Invalid customer type'
    isValid = false
  }

  // Phone number validation (Uganda format) - NOT NULL constraint
  if (!newCustomerForm.PhoneNumber?.trim()) {
    validationErrors.PhoneNumber = 'Phone number is required'
    isValid = false
  } else if (!/^(\+256|0)[7-9]\d{8}$/.test(newCustomerForm.PhoneNumber.trim())) {
    validationErrors.PhoneNumber =
      'Please enter a valid Uganda phone number (+256/0 + 7-9 + 8 digits)'
    isValid = false
  }

  // Email validation - NULL allowed but must be valid if provided
  if (
    newCustomerForm.Email?.trim() &&
    !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(newCustomerForm.Email.trim())
  ) {
    validationErrors.Email = 'Please enter a valid email address'
    isValid = false
  }

  // Type-specific validation based on CustomerType
  if (newCustomerForm.CustomerType === 'Individual') {
    if (!newCustomerForm.FirstName?.trim()) {
      validationErrors.FirstName = 'First name is required for individual customers'
      isValid = false
    } else if (newCustomerForm.FirstName.trim().length < 2) {
      validationErrors.FirstName = 'First name must be at least 2 characters'
      isValid = false
    }

    if (!newCustomerForm.LastName?.trim()) {
      validationErrors.LastName = 'Last name is required for individual customers'
      isValid = false
    } else if (newCustomerForm.LastName.trim().length < 2) {
      validationErrors.LastName = 'Last name must be at least 2 characters'
      isValid = false
    }

    // Clear company name for individual customers
    newCustomerForm.CompanyName = ''
  } else {
    // Corporate or Fleet
    if (!newCustomerForm.CompanyName?.trim()) {
      validationErrors.CompanyName = 'Company name is required for corporate/fleet customers'
      isValid = false
    } else if (newCustomerForm.CompanyName.trim().length < 3) {
      validationErrors.CompanyName = 'Company name must be at least 3 characters'
      isValid = false
    }

    // Clear individual names for corporate customers
    newCustomerForm.FirstName = ''
    newCustomerForm.LastName = ''
  }

  // Station selection validation - PrimaryStationID cannot be null in our use case
  if (!selectedStationId.value) {
    Swal.fire({
      title: 'Station Required',
      text: 'Please select a station before adding customers',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    isValid = false
  }

  return isValid
}

const validateAmountField = (amount) => {
  if (!amount || isNaN(amount) || parseFloat(amount) <= 0) {
    return false
  }
  // Ensure it's a valid decimal with max 2 decimal places for TEXT storage
  const regex = /^\d+(\.\d{0,2})?$/
  return regex.test(amount.toString())
}

// Foreign Key Validation - Critical for STRICT mode
const validateForeignKeys = async (tableName, data) => {
  try {
    // Validate Station exists
    if (data.StationID || data.PrimaryStationID) {
      const stationId = data.StationID || data.PrimaryStationID
      const stationResponse = await fetch(`${API_BASE_URL}/Stations/${stationId}`, {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      })
      if (!stationResponse.ok) {
        throw new Error('Invalid Station ID - station does not exist')
      }
    }

    // Validate Customer exists (for credit accounts and payments)
    if (data.CustomerID) {
      const customerResponse = await fetch(`${API_BASE_URL}/Customers/${data.CustomerID}`, {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      })
      if (!customerResponse.ok) {
        throw new Error('Invalid Customer ID - customer does not exist')
      }
    }

    // Validate User exists (for ApprovedBy, ReceivedBy, VerifiedBy)
    if (data.ApprovedBy || data.ReceivedBy || data.VerifiedBy) {
      const userId = data.ApprovedBy || data.ReceivedBy || data.VerifiedBy
      if (userId) {
        const userResponse = await fetch(`${API_BASE_URL}/users/${userId}`, {
          headers: {
            Authorization: `Bearer ${authData.token}`,
            'Content-Type': 'application/json',
          },
        })
        if (!userResponse.ok) {
          throw new Error('Invalid User ID - user does not exist')
        }
      }
    }

    return true
  } catch (error) {
    console.error('Foreign key validation error:', error)
    throw error
  }
}

// Computed Properties
const filteredCustomers = computed(() => {
  if (!customerSearch.value) return customers.value
  const search = customerSearch.value.toLowerCase()
  return customers.value.filter((customer) => {
    const name = getCustomerName(customer).toLowerCase()
    const code = customer.CustomerCode.toLowerCase()
    const phone = customer.PhoneNumber.toLowerCase()
    return name.includes(search) || code.includes(search) || phone.includes(search)
  })
})

const filteredCreditAccounts = computed(() => {
  if (!creditFilter.value) return creditAccounts.value
  return creditAccounts.value.filter((account) => {
    const status = getCreditStatus(account)
    const utilization = getCreditUtilization(account)

    if (creditFilter.value === 'Active') return account.IsActive === '1'
    if (creditFilter.value === 'Inactive') return account.IsActive === '0'
    if (creditFilter.value === 'OverLimit') return status === 'Over Limit'
    if (creditFilter.value === 'NearLimit') return status === 'Near Limit'
    if (creditFilter.value === 'HighUtilization') return utilization > 80
    return true
  })
})

const filteredPayments = computed(() => {
  let filtered = payments.value

  if (paymentDateFilter.value) {
    filtered = filtered.filter((payment) => payment.PaymentDate.startsWith(paymentDateFilter.value))
  }

  if (paymentMethodFilter.value) {
    filtered = filtered.filter((payment) => payment.PaymentMethod === paymentMethodFilter.value)
  }

  if (paymentStatusFilter.value) {
    filtered = filtered.filter((payment) => payment.Status === paymentStatusFilter.value)
  }

  return filtered
})

// Utility Functions
const getCustomerName = (customer) => {
  if (customer.CompanyName) return customer.CompanyName
  return `${customer.FirstName || ''} ${customer.LastName || ''}`.trim()
}

const getCustomerInitials = (customer) => {
  if (customer.CompanyName) {
    return customer.CompanyName.substring(0, 2).toUpperCase()
  }
  const first = customer.FirstName ? customer.FirstName[0] : ''
  const last = customer.LastName ? customer.LastName[0] : ''
  return (first + last).toUpperCase() || 'CU'
}

const formatCurrency = (amount) => {
  if (!amount) return '0'
  const num = parseFloat(amount)
  return num.toLocaleString('en-UG', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  })
}

const formatDate = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleDateString('en-GB')
}

const formatDateTime = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleString('en-GB')
}

const getCreditStatus = (account) => {
  const balance = parseFloat(account.CurrentBalance || 0)
  const limit = parseFloat(account.CreditLimit || 0)
  const available = parseFloat(account.AvailableCredit || 0)

  if (balance > limit) return 'Over Limit'
  if (available < limit * 0.1) return 'Near Limit'
  if (balance === 0) return 'No Balance'
  return 'Normal'
}

const getCreditUtilization = (account) => {
  const balance = parseFloat(account.CurrentBalance || 0)
  const limit = parseFloat(account.CreditLimit || 0)
  if (limit === 0) return 0
  return Math.round((balance / limit) * 100)
}

// Generate unique identifiers with collision detection
const generateUniqueCode = (prefix) => {
  const timestamp = Date.now().toString().slice(-6)
  const random = Math.floor(Math.random() * 1000)
    .toString()
    .padStart(3, '0')
  return `${prefix}${timestamp}${random}`
}

const generateUniqueReference = (prefix) => {
  const timestamp = Date.now()
  const random = Math.floor(Math.random() * 10000)
  return `${prefix}-${timestamp}-${random}`
}

// Comprehensive constraint validation for STRICT mode
const validateDatabaseConstraints = (tableName, data) => {
  const errors = []

  if (tableName === 'Customers') {
    // NOT NULL constraints
    if (!data.CustomerType) errors.push('CustomerType is required')
    if (!data.CustomerCode) errors.push('CustomerCode is required')
    if (!data.PhoneNumber) errors.push('PhoneNumber is required')
    if (!data.RegistrationDate) errors.push('RegistrationDate is required')
    if (!data.Status) errors.push('Status is required')
    if (!data.CreatedAt) errors.push('CreatedAt is required')
    if (!data.UpdatedAt) errors.push('UpdatedAt is required')

    // Enum constraints
    if (data.CustomerType && !['Individual', 'Corporate', 'Fleet'].includes(data.CustomerType)) {
      errors.push('CustomerType must be Individual, Corporate, or Fleet')
    }
    if (data.Status && !['Active', 'Suspended', 'Blacklisted'].includes(data.Status)) {
      errors.push('Status must be Active, Suspended, or Blacklisted')
    }
  }

  if (tableName === 'CustomerCreditAccounts') {
    // NOT NULL constraints
    if (data.CustomerID === undefined || data.CustomerID === null)
      errors.push('CustomerID is required')
    if (!data.CreditLimit) errors.push('CreditLimit is required')
    if (!data.CurrentBalance) errors.push('CurrentBalance is required')
    if (!data.AvailableCredit) errors.push('AvailableCredit is required')
    if (!data.PaymentTermsDays) errors.push('PaymentTermsDays is required')
    if (data.ApprovedBy === undefined || data.ApprovedBy === null)
      errors.push('ApprovedBy is required')
    if (!data.ApprovedDate) errors.push('ApprovedDate is required')
  }

  if (tableName === 'CustomerCreditPayments') {
    // NOT NULL constraints
    if (data.CustomerID === undefined || data.CustomerID === null)
      errors.push('CustomerID is required')
    if (data.StationID === undefined || data.StationID === null)
      errors.push('StationID is required')
    if (!data.PaymentReference) errors.push('PaymentReference is required')
    if (!data.PaymentDate) errors.push('PaymentDate is required')
    if (!data.PaymentAmount) errors.push('PaymentAmount is required')
    if (!data.PaymentMethod) errors.push('PaymentMethod is required')
    if (data.ReceivedBy === undefined || data.ReceivedBy === null)
      errors.push('ReceivedBy is required')

    // Enum constraints
    if (
      data.PaymentMethod &&
      !['Cash', 'Bank Transfer', 'Mobile Money', 'Card'].includes(data.PaymentMethod)
    ) {
      errors.push('PaymentMethod must be Cash, Bank Transfer, Mobile Money, or Card')
    }
    if (data.Status && !['Pending', 'Completed', 'Failed'].includes(data.Status)) {
      errors.push('Status must be Pending, Completed, or Failed')
    }
  }

  if (errors.length > 0) {
    throw new Error(`Database constraint violations: ${errors.join(', ')}`)
  }

  return true
}

// Badge Style Functions
const getCustomerTypeBadge = (type) => {
  const badges = {
    Individual: 'badge-light-primary',
    Corporate: 'badge-light-success',
    Fleet: 'badge-light-warning',
  }
  return badges[type] || 'badge-light-secondary'
}

const getCustomerTypeSymbol = (type) => {
  const symbols = {
    Individual: 'bg-light-primary text-primary fw-bold',
    Corporate: 'bg-light-success text-success fw-bold',
    Fleet: 'bg-light-warning text-warning fw-bold',
  }
  return symbols[type] || 'bg-light-secondary text-secondary fw-bold'
}

const getCustomerStatusBadge = (status) => {
  const badges = {
    Active: 'badge-light-success',
    Suspended: 'badge-light-warning',
    Blacklisted: 'badge-light-danger',
  }
  return badges[status] || 'badge-light-secondary'
}

const getCreditStatusBadge = (status) => {
  const badges = {
    Normal: 'badge-light-success',
    'Near Limit': 'badge-light-warning',
    'Over Limit': 'badge-light-danger',
    'No Balance': 'badge-light-info',
  }
  return badges[status] || 'badge-light-secondary'
}

const getCreditAccountCardClass = (account) => {
  const status = getCreditStatus(account)
  if (status === 'Over Limit') return 'border-danger'
  if (status === 'Near Limit') return 'border-warning'
  return ''
}

const getUtilizationColor = (utilization) => {
  if (utilization >= 90) return 'text-danger'
  if (utilization >= 75) return 'text-warning'
  return 'text-success'
}

const getCreditScoreColor = (score) => {
  const scoreNum = parseFloat(score || 0)
  if (scoreNum >= 80) return 'text-success'
  if (scoreNum >= 60) return 'text-warning'
  return 'text-danger'
}

const getPaymentStatusBadge = (status) => {
  const badges = {
    Completed: 'badge-light-success',
    Pending: 'badge-light-warning',
    Failed: 'badge-light-danger',
  }
  return badges[status] || 'badge-light-secondary'
}

const getAgingBadge = (bucket) => {
  const badges = {
    Current: 'badge-light-success',
    '31-60 Days': 'badge-light-warning',
    '61-90 Days': 'badge-light-danger',
    '90+ Days': 'badge-light-dark',
  }
  return badges[bucket] || 'badge-light-secondary'
}

// API Functions
const fetchStationCustomers = async () => {
  if (!selectedStationId.value) return

  try {
    loading.value = true

    const response = await fetch(
      `${API_BASE_URL}/Customers?PrimaryStationID=${selectedStationId.value}`,
      {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      },
    )

    if (!response.ok) throw new Error('Failed to fetch customers')

    const data = await response.json()
    customers.value = data.records || []
  } catch (error) {
    console.error('Error fetching customers:', error)
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load customers',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const fetchCreditSummary = async () => {
  if (!selectedStationId.value) return

  try {
    // Use the CustomerCreditSummary view for comprehensive data
    const response = await fetch(
      `${API_BASE_URL}/CustomerCreditSummary?StationID=${selectedStationId.value}`,
      {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      },
    )

    if (!response.ok) throw new Error('Failed to fetch credit summary')

    const data = await response.json()
    creditAccounts.value = data.records || []
  } catch (error) {
    console.error('Error fetching credit summary:', error)
  }
}

const fetchPayments = async () => {
  if (!selectedStationId.value) return

  try {
    const response = await fetch(
      `${API_BASE_URL}/CustomerCreditPayments?StationID=${selectedStationId.value}`,
      {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      },
    )

    if (!response.ok) throw new Error('Failed to fetch payments')

    const data = await response.json()
    payments.value = data.records || []

    // Fetch customer details for each payment
    await Promise.all(
      payments.value.map(async (payment) => {
        const customerResponse = await fetch(`${API_BASE_URL}/Customers/${payment.CustomerID}`, {
          headers: {
            Authorization: `Bearer ${authData.token}`,
            'Content-Type': 'application/json',
          },
        })

        if (customerResponse.ok) {
          const customerData = await customerResponse.json()
          Object.assign(payment, customerData)
        }
      }),
    )
  } catch (error) {
    console.error('Error fetching payments:', error)
  }
}

const fetchOutstandingBalances = async () => {
  if (!selectedStationId.value) return

  try {
    // Use the CustomerOutstandingBalances view for aging analysis
    const response = await fetch(
      `${API_BASE_URL}/CustomerOutstandingBalances?StationID=${selectedStationId.value}`,
      {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      },
    )

    if (!response.ok) throw new Error('Failed to fetch outstanding balances')

    const data = await response.json()
    outstandingBalances.value = data.records || []

    // Calculate aging buckets
    calculateAgingBuckets()
  } catch (error) {
    console.error('Error fetching outstanding balances:', error)
  }
}

const calculateKPIs = () => {
  kpiData.totalCustomers = customers.value.length
  kpiData.activeCreditAccounts = creditAccounts.value.filter((a) => a.IsActive === '1').length
  kpiData.totalOutstanding = creditAccounts.value.reduce(
    (sum, account) => sum + parseFloat(account.CurrentBalance || 0),
    0,
  )

  // Calculate average credit utilization
  const activeAccounts = creditAccounts.value.filter((a) => a.IsActive === '1')
  if (activeAccounts.length > 0) {
    const totalUtilization = activeAccounts.reduce(
      (sum, account) => sum + getCreditUtilization(account),
      0,
    )
    kpiData.avgUtilization = Math.round(totalUtilization / activeAccounts.length)
  } else {
    kpiData.avgUtilization = 0
  }
}

const calculateAgingBuckets = () => {
  // Reset buckets
  agingBuckets.value.forEach((bucket) => {
    bucket.amount = 0
    bucket.count = 0
  })

  outstandingBalances.value.forEach((balance) => {
    const amount = parseFloat(balance.OutstandingAmount || 0)
    const bucket = balance.AgingBucket

    if (bucket === 'Current') {
      agingBuckets.value[0].amount += amount
      agingBuckets.value[0].count++
    } else if (bucket === '31-60 Days') {
      agingBuckets.value[1].amount += amount
      agingBuckets.value[1].count++
    } else if (bucket === '61-90 Days') {
      agingBuckets.value[2].amount += amount
      agingBuckets.value[2].count++
    } else if (bucket === '90+ Days') {
      agingBuckets.value[3].amount += amount
      agingBuckets.value[3].count++
    }
  })
}

const runCreditMonitoring = () => {
  // Identify risk alerts
  riskAlerts.value = []

  creditAccounts.value.forEach((account) => {
    const status = getCreditStatus(account)
    const utilization = getCreditUtilization(account)
    const score = parseFloat(account.CreditScore || 100)

    if (status === 'Over Limit') {
      riskAlerts.value.push({
        customer: getCustomerName(account),
        type: 'Over Limit',
        message: 'Credit limit exceeded',
      })
    }

    if (utilization > 90 && status !== 'Over Limit') {
      riskAlerts.value.push({
        customer: getCustomerName(account),
        type: 'High Utilization',
        message: `${utilization}% credit utilization`,
      })
    }

    if (score < 60) {
      riskAlerts.value.push({
        customer: getCustomerName(account),
        type: 'Low Credit Score',
        message: `Credit score: ${score}%`,
      })
    }
  })

  Swal.fire({
    title: 'Credit Monitoring Complete',
    text: `Found ${riskAlerts.value.length} risk alerts requiring attention`,
    icon: riskAlerts.value.length > 0 ? 'warning' : 'success',
    confirmButtonColor: '#3699ff',
  })
}

// Event Handlers
const handleStationChange = async () => {
  if (selectedStationId.value) {
    await Promise.all([
      fetchStationCustomers(),
      fetchCreditSummary(),
      fetchPayments(),
      fetchOutstandingBalances(),
    ])
    calculateKPIs()
    runCreditMonitoring()
  }
}

const refreshData = async () => {
  if (selectedStationId.value) {
    await handleStationChange()
    Swal.fire({
      title: 'Refreshed!',
      text: 'Data has been updated',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  }
}

const showAddCustomerModal = () => {
  // Reset form and validation errors
  Object.assign(newCustomerForm, {
    CustomerType: 'Individual',
    FirstName: '',
    LastName: '',
    CompanyName: '',
    PhoneNumber: '',
    Email: '',
    NationalID: '',
    TaxID: '',
    Address: '',
  })

  Object.keys(validationErrors).forEach((key) => {
    validationErrors[key] = ''
  })

  // Show modal using Bootstrap
  const modal = new bootstrap.Modal(document.getElementById('addCustomerModal'))
  modal.show()
}

const handleAddCustomer = async () => {
  if (!validateCustomerForm()) {
    return
  }

  try {
    saving.value = true

    // Generate unique customer code - ensure uniqueness
    const customerCode = generateUniqueCode('CUST')

    // Pre-validate unique constraints to prevent DB errors
    const existingCustomer = await fetch(`${API_BASE_URL}/Customers?CustomerCode=${customerCode}`, {
      headers: {
        Authorization: `Bearer ${authData.token}`,
        'Content-Type': 'application/json',
      },
    })

    const existingData = await existingCustomer.json()
    if (existingData.records && existingData.records.length > 0) {
      throw new Error('Customer code already exists. Please try again.')
    }

    // Prepare customer data with EXACT schema compliance - ALL fields must match schema exactly
    const customerData = {
      CustomerType: newCustomerForm.CustomerType, // TEXT NOT NULL - validated enum
      CustomerCode: customerCode, // TEXT NOT NULL UNIQUE - pre-validated above
      FirstName:
        newCustomerForm.CustomerType === 'Individual' ? newCustomerForm.FirstName || null : null, // TEXT NULL
      LastName:
        newCustomerForm.CustomerType === 'Individual' ? newCustomerForm.LastName || null : null, // TEXT NULL
      CompanyName:
        newCustomerForm.CustomerType !== 'Individual' ? newCustomerForm.CompanyName || null : null, // TEXT NULL
      PhoneNumber: newCustomerForm.PhoneNumber, // TEXT NOT NULL - validated
      Email: newCustomerForm.Email || null, // TEXT NULL
      NationalID: newCustomerForm.NationalID || null, // TEXT NULL
      TaxID: newCustomerForm.TaxID || null, // TEXT NULL
      Address: newCustomerForm.Address || null, // TEXT NULL
      PrimaryStationID: parseInt(selectedStationId.value), // INTEGER NULL REFERENCES Stations(StationID)
      RegistrationDate: new Date().toISOString(), // TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      Status: 'Active', // TEXT NOT NULL DEFAULT 'Active' - enum: Active, Suspended, Blacklisted
      CreatedAt: new Date().toISOString(), // TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      UpdatedAt: new Date().toISOString(), // TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    }

    // Validate database constraints before API call
    validateDatabaseConstraints('Customers', customerData)

    // Validate foreign keys before attempting insertion
    await validateForeignKeys('Customers', customerData)

    // Create customer
    const response = await fetch(`${API_BASE_URL}/Customers`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${authData.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(customerData),
    })

    if (!response.ok) {
      const errorData = await response.json()
      throw new Error(errorData.message || 'Failed to create customer')
    }

    const newCustomer = await response.json()

    // Log to AuditLogs table
    await logAuditAction('INSERT', 'Customers', newCustomer.CustomerID, null, customerData)

    // Hide modal
    bootstrap.Modal.getInstance(document.getElementById('addCustomerModal')).hide()

    await Swal.fire({
      title: 'Success!',
      text: `Customer ${customerCode} created successfully`,
      icon: 'success',
      confirmButtonColor: '#50cd89',
    })

    await fetchStationCustomers()
    calculateKPIs()
  } catch (error) {
    console.error('Error creating customer:', error)
    Swal.fire({
      title: 'Error!',
      text: error.message || 'Failed to create customer',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

const manageCreditAccount = async (customer) => {
  try {
    // Check if credit account exists for this customer-station combination
    const existingAccount = creditAccounts.value.find(
      (account) =>
        account.CustomerID === customer.CustomerID &&
        account.StationID === parseInt(selectedStationId.value),
    )

    if (existingAccount) {
      selectedCreditAccount.value = existingAccount
      const modal = new bootstrap.Modal(document.getElementById('creditAdjustmentModal'))
      modal.show()
    } else {
      // Create new credit account
      const result = await Swal.fire({
        title: 'Create Credit Account',
        html: `
          <div class="mb-3">
            <label class="form-label">Credit Limit (UGX)</label>
            <input id="credit-limit" class="form-control form-control-lg" type="number" min="1000" step="1000" value="100000">
          </div>
          <div class="mb-3">
            <label class="form-label">Payment Terms (Days)</label>
            <select id="payment-terms" class="form-select form-select-lg">
              <option value="30">30 Days</option>
              <option value="60">60 Days</option>
              <option value="90">90 Days</option>
            </select>
          </div>
        `,
        showCancelButton: true,
        confirmButtonText: 'Create Account',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#50cd89',
        preConfirm: () => {
          const limit = document.getElementById('credit-limit').value
          const terms = document.getElementById('payment-terms').value

          if (!limit || parseFloat(limit) < 1000) {
            Swal.showValidationMessage('Minimum credit limit is UGX 1,000')
            return false
          }

          return { limit, terms }
        },
      })

      if (result.isConfirmed) {
        await createCreditAccount(customer, result.value.limit, result.value.terms)
      }
    }
  } catch (error) {
    console.error('Error managing credit account:', error)
  }
}

const createCreditAccount = async (customer, creditLimit, paymentTerms) => {
  try {
    saving.value = true

    // Pre-validate UNIQUE constraint (CustomerID, StationID) to prevent constraint violation
    const existingAccount = await fetch(
      `${API_BASE_URL}/CustomerCreditAccounts?CustomerID=${customer.CustomerID}&StationID=${selectedStationId.value}`,
      {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      },
    )

    const existingData = await existingAccount.json()
    if (existingData.records && existingData.records.length > 0) {
      throw new Error('Credit account already exists for this customer at this station')
    }

    // Prepare account data with EXACT schema compliance - ALL fields must match schema exactly
    const accountData = {
      CustomerID: customer.CustomerID, // INTEGER NOT NULL REFERENCES Customers(CustomerID)
      StationID: parseInt(selectedStationId.value), // INTEGER NULL REFERENCES Stations(StationID) - but we always have a station
      CreditLimit: creditLimit.toString(), // TEXT NOT NULL DEFAULT '0.00' - must be string
      CurrentBalance: '0.00', // TEXT NOT NULL DEFAULT '0.00' - must be string
      AvailableCredit: creditLimit.toString(), // TEXT NOT NULL DEFAULT '0.00' - must be string
      PaymentTermsDays: paymentTerms.toString(), // TEXT NOT NULL DEFAULT '30' - must be string not integer
      LastPurchaseDate: null, // TEXT NULL
      LastPaymentDate: null, // TEXT NULL
      LastPaymentAmount: '0.00', // TEXT DEFAULT '0.00' - must be string
      CreditScore: '100', // TEXT DEFAULT '100' - must be string
      IsActive: '1', // TEXT DEFAULT '1' - must be string
      ApprovedBy: currentUser.id, // INTEGER NOT NULL REFERENCES users(id)
      ApprovedDate: new Date().toISOString(), // TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      CreatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
      UpdatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
    }

    // Validate database constraints before API call
    validateDatabaseConstraints('CustomerCreditAccounts', accountData)

    // Validate foreign keys before attempting insertion
    await validateForeignKeys('CustomerCreditAccounts', accountData)

    // Create credit account
    const response = await fetch(`${API_BASE_URL}/CustomerCreditAccounts`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${authData.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(accountData),
    })

    if (!response.ok) {
      const errorData = await response.json()
      throw new Error(errorData.message || 'Failed to create credit account')
    }

    const newAccount = await response.json()

    // Log to AuditLogs
    await logAuditAction(
      'INSERT',
      'CustomerCreditAccounts',
      newAccount.CreditAccountID,
      null,
      accountData,
    )

    // Create ledger entry for credit account setup
    await createLedgerEntry(
      parseInt(selectedStationId.value),
      '1200', // Accounts Receivable
      'Credit_Account_Setup',
      newAccount.CreditAccountID,
      `Credit account created for ${getCustomerName(customer)} - Limit: UGX ${formatCurrency(creditLimit)}`,
      '0.00',
      '0.00',
    )

    await Swal.fire({
      title: 'Success!',
      text: `Credit account created with limit UGX ${formatCurrency(creditLimit)}`,
      icon: 'success',
      confirmButtonColor: '#50cd89',
    })

    await fetchCreditSummary()
    calculateKPIs()
  } catch (error) {
    console.error('Error creating credit account:', error)
    Swal.fire({
      title: 'Error!',
      text: error.message || 'Failed to create credit account',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

const adjustCredit = (account) => {
  selectedCreditAccount.value = account

  // Reset form
  Object.assign(creditAdjustmentForm, {
    type: 'limit_increase',
    amount: '',
    reason: '',
  })

  const modal = new bootstrap.Modal(document.getElementById('creditAdjustmentModal'))
  modal.show()
}

const handleCreditAdjustment = async () => {
  if (!creditAdjustmentForm.amount || !validateAmountField(creditAdjustmentForm.amount)) {
    Swal.fire({
      title: 'Invalid Amount',
      text: 'Please enter a valid amount',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  if (!creditAdjustmentForm.reason?.trim()) {
    Swal.fire({
      title: 'Reason Required',
      text: 'Please provide a reason for this adjustment',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  try {
    // Double confirmation for financial adjustments
    const result = await Swal.fire({
      title: 'Confirm Credit Adjustment',
      html: `
        <div class="text-start">
          <p><strong>Customer:</strong> ${getCustomerName(selectedCreditAccount.value)}</p>
          <p><strong>Type:</strong> ${creditAdjustmentForm.type.replace(/_/g, ' ')}</p>
          <p><strong>Amount:</strong> UGX ${formatCurrency(creditAdjustmentForm.amount)}</p>
          <p><strong>Reason:</strong> ${creditAdjustmentForm.reason}</p>
          <div class="alert alert-warning mt-3">
            <strong>Warning:</strong> This action cannot be undone and will be logged for audit purposes.
          </div>
        </div>
      `,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Confirm Adjustment',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#f1c40f',
      cancelButtonColor: '#6c757d',
    })

    if (!result.isConfirmed) return

    saving.value = true

    const account = selectedCreditAccount.value
    const amount = parseFloat(creditAdjustmentForm.amount)

    // Store old values for audit logging
    const oldValues = {
      CreditLimit: account.CreditLimit,
      CurrentBalance: account.CurrentBalance,
      AvailableCredit: account.AvailableCredit,
    }

    let updatedData = {}
    let ledgerDescription = ''
    let debitAmount = '0.00'
    let creditAmount = '0.00'

    // Calculate new values based on adjustment type - ensure all values are strings for TEXT fields
    if (creditAdjustmentForm.type === 'limit_increase') {
      const newLimit = parseFloat(account.CreditLimit) + amount
      updatedData = {
        CreditLimit: newLimit.toFixed(2), // TEXT field - must be string with 2 decimal places
        AvailableCredit: (newLimit - parseFloat(account.CurrentBalance)).toFixed(2), // TEXT field - must be string
        UpdatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
      }
      ledgerDescription = `Credit limit increased by UGX ${formatCurrency(amount)} for ${getCustomerName(account)}`
    } else if (creditAdjustmentForm.type === 'limit_decrease') {
      const newLimit = Math.max(
        parseFloat(account.CurrentBalance),
        parseFloat(account.CreditLimit) - amount,
      )
      updatedData = {
        CreditLimit: newLimit.toFixed(2), // TEXT field - must be string with 2 decimal places
        AvailableCredit: (newLimit - parseFloat(account.CurrentBalance)).toFixed(2), // TEXT field - must be string
        UpdatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
      }
      ledgerDescription = `Credit limit decreased by UGX ${formatCurrency(amount)} for ${getCustomerName(account)}`
    } else if (creditAdjustmentForm.type === 'balance_adjustment_positive') {
      const newBalance = parseFloat(account.CurrentBalance) + amount
      updatedData = {
        CurrentBalance: newBalance.toFixed(2), // TEXT field - must be string with 2 decimal places
        AvailableCredit: (parseFloat(account.CreditLimit) - newBalance).toFixed(2), // TEXT field - must be string
        UpdatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
      }
      debitAmount = amount.toFixed(2) // TEXT field - must be string
      ledgerDescription = `Outstanding balance increased by UGX ${formatCurrency(amount)} for ${getCustomerName(account)}`
    } else if (creditAdjustmentForm.type === 'balance_adjustment_negative') {
      const newBalance = Math.max(0, parseFloat(account.CurrentBalance) - amount)
      updatedData = {
        CurrentBalance: newBalance.toFixed(2), // TEXT field - must be string with 2 decimal places
        AvailableCredit: (parseFloat(account.CreditLimit) - newBalance).toFixed(2), // TEXT field - must be string
        UpdatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
      }
      creditAmount = amount.toFixed(2) // TEXT field - must be string
      ledgerDescription = `Outstanding balance decreased by UGX ${formatCurrency(amount)} for ${getCustomerName(account)}`
    }

    // Update credit account
    const response = await fetch(
      `${API_BASE_URL}/CustomerCreditAccounts/${account.CreditAccountID}`,
      {
        method: 'PATCH',
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updatedData),
      },
    )

    if (!response.ok) {
      const errorData = await response.json()
      throw new Error(errorData.message || 'Failed to update credit account')
    }

    // Log to AuditLogs
    await logAuditAction('UPDATE', 'CustomerCreditAccounts', account.CreditAccountID, oldValues, {
      ...oldValues,
      ...updatedData,
      AdjustmentReason: creditAdjustmentForm.reason,
    })

    // Create ledger entry
    await createLedgerEntry(
      parseInt(selectedStationId.value),
      '1200', // Accounts Receivable
      'Credit_Adjustment',
      account.CreditAccountID,
      ledgerDescription + `. Reason: ${creditAdjustmentForm.reason}`,
      debitAmount,
      creditAmount,
    )

    // Hide modal
    bootstrap.Modal.getInstance(document.getElementById('creditAdjustmentModal')).hide()

    await Swal.fire({
      title: 'Success!',
      text: 'Credit adjustment applied successfully',
      icon: 'success',
      confirmButtonColor: '#50cd89',
    })

    await fetchCreditSummary()
    calculateKPIs()
  } catch (error) {
    console.error('Error adjusting credit:', error)
    Swal.fire({
      title: 'Error!',
      text: error.message || 'Failed to apply credit adjustment',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

const recordPayment = async (account) => {
  try {
    const { value: formValues } = await Swal.fire({
      title: 'Record Payment',
      html: `
        <div class="mb-3">
          <label class="form-label">Payment Amount (UGX)</label>
          <input id="payment-amount" class="form-control form-control-lg" type="number" min="1" step="0.01" max="${account.CurrentBalance}">
          <div class="form-text">Maximum: UGX ${formatCurrency(account.CurrentBalance)}</div>
        </div>
        <div class="mb-3">
          <label class="form-label">Payment Method</label>
          <select id="payment-method" class="form-select form-select-lg">
            <option value="Cash">Cash</option>
            <option value="Bank Transfer">Bank Transfer</option>
            <option value="Mobile Money">Mobile Money</option>
            <option value="Card">Card</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">Reference Number</label>
          <input id="payment-reference" class="form-control form-control-lg" type="text" placeholder="Transaction reference">
        </div>
        <div class="mb-3">
          <label class="form-label">Notes (Optional)</label>
          <textarea id="payment-notes" class="form-control" rows="2" placeholder="Additional payment notes"></textarea>
        </div>
      `,
      showCancelButton: true,
      confirmButtonText: 'Record Payment',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#50cd89',
      preConfirm: () => {
        const amount = document.getElementById('payment-amount').value
        const method = document.getElementById('payment-method').value
        const reference = document.getElementById('payment-reference').value
        const notes = document.getElementById('payment-notes').value

        if (!amount || parseFloat(amount) <= 0) {
          Swal.showValidationMessage('Please enter a valid payment amount')
          return false
        }

        if (parseFloat(amount) > parseFloat(account.CurrentBalance)) {
          Swal.showValidationMessage('Payment amount cannot exceed outstanding balance')
          return false
        }

        if (!reference?.trim()) {
          Swal.showValidationMessage('Please enter a reference number')
          return false
        }

        return { amount, method, reference, notes }
      },
    })

    if (formValues) {
      await processPayment(account, formValues)
    }
  } catch (error) {
    console.error('Error recording payment:', error)
  }
}

const processPayment = async (account, paymentData) => {
  try {
    saving.value = true

    // Generate unique payment reference - ensure uniqueness for UNIQUE constraint
    let paymentReference = generateUniqueReference('PAY')

    // Pre-validate UNIQUE constraint on PaymentReference to prevent DB errors
    let existingPayment = await fetch(
      `${API_BASE_URL}/CustomerCreditPayments?PaymentReference=${paymentReference}`,
      {
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
      },
    )

    let existingData = await existingPayment.json()
    while (existingData.records && existingData.records.length > 0) {
      // Generate new reference if collision detected
      paymentReference = generateUniqueReference('PAY')
      existingPayment = await fetch(
        `${API_BASE_URL}/CustomerCreditPayments?PaymentReference=${paymentReference}`,
        {
          headers: {
            Authorization: `Bearer ${authData.token}`,
            'Content-Type': 'application/json',
          },
        },
      )
      existingData = await existingPayment.json()
    }

    // Validate PaymentMethod enum constraint
    const validPaymentMethods = ['Cash', 'Bank Transfer', 'Mobile Money', 'Card']
    if (!validPaymentMethods.includes(paymentData.method)) {
      throw new Error('Invalid payment method')
    }

    // Prepare payment data with EXACT schema compliance - ALL fields must match schema exactly
    const paymentRecord = {
      CustomerID: account.CustomerID, // INTEGER NOT NULL REFERENCES Customers(CustomerID)
      StationID: parseInt(selectedStationId.value), // INTEGER NOT NULL REFERENCES Stations(StationID)
      PaymentReference: paymentReference, // TEXT NOT NULL UNIQUE - pre-validated above
      PaymentDate: new Date().toISOString(), // TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      PaymentAmount: paymentData.amount.toString(), // TEXT NOT NULL - must be string
      PaymentMethod: paymentData.method, // TEXT NOT NULL - validated enum above
      MobileMoneyReference: paymentData.method === 'Mobile Money' ? paymentData.reference : null, // TEXT NULL
      BankReference: paymentData.method === 'Bank Transfer' ? paymentData.reference : null, // TEXT NULL
      AllocatedToTransactions: '[]', // TEXT DEFAULT '[]' - JSON array as string
      Notes: paymentData.notes || null, // TEXT NULL
      ReceivedBy: currentUser.id, // INTEGER NOT NULL REFERENCES users(id)
      VerifiedBy: null, // INTEGER NULL REFERENCES users(id)
      Status: 'Completed', // TEXT DEFAULT 'Completed' - enum: Pending, Completed, Failed
      CreatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
      UpdatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
    }

    // Validate database constraints before API call
    validateDatabaseConstraints('CustomerCreditPayments', paymentRecord)

    // Validate foreign keys before attempting insertion
    await validateForeignKeys('CustomerCreditPayments', paymentRecord)

    // Create payment record
    const paymentResponse = await fetch(`${API_BASE_URL}/CustomerCreditPayments`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${authData.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(paymentRecord),
    })

    if (!paymentResponse.ok) {
      const errorData = await paymentResponse.json()
      throw new Error(errorData.message || 'Failed to record payment')
    }

    const newPayment = await paymentResponse.json()

    // Update credit account balance with exact schema compliance
    const paymentAmount = parseFloat(paymentData.amount)
    const newBalance = Math.max(0, parseFloat(account.CurrentBalance) - paymentAmount)
    const newAvailable = parseFloat(account.CreditLimit) - newBalance

    const accountUpdate = {
      CurrentBalance: newBalance.toFixed(2), // TEXT field - must be string with 2 decimal places
      AvailableCredit: newAvailable.toFixed(2), // TEXT field - must be string with 2 decimal places
      LastPaymentDate: new Date().toISOString().split('T')[0], // TEXT field - date as string YYYY-MM-DD
      LastPaymentAmount: paymentData.amount.toString(), // TEXT field - must be string with 2 decimal places
      UpdatedAt: new Date().toISOString(), // TEXT DEFAULT CURRENT_TIMESTAMP
    }

    await fetch(`${API_BASE_URL}/CustomerCreditAccounts/${account.CreditAccountID}`, {
      method: 'PATCH',
      headers: {
        Authorization: `Bearer ${authData.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(accountUpdate),
    })

    // Log to AuditLogs
    await logAuditAction(
      'INSERT',
      'CustomerCreditPayments',
      newPayment.PaymentID,
      null,
      paymentRecord,
    )
    await logAuditAction(
      'UPDATE',
      'CustomerCreditAccounts',
      account.CreditAccountID,
      {
        CurrentBalance: account.CurrentBalance,
        AvailableCredit: account.AvailableCredit,
      },
      accountUpdate,
    )

    // Create ledger entries (Double entry bookkeeping)
    await Promise.all([
      // Debit Cash/Bank Account
      createLedgerEntry(
        parseInt(selectedStationId.value),
        paymentData.method === 'Cash' ? '1000' : '1010', // Cash or Bank
        'Customer_Payment',
        newPayment.PaymentID,
        `Payment received from ${getCustomerName(account)} via ${paymentData.method}`,
        paymentData.amount.toString(),
        '0.00',
      ),
      // Credit Accounts Receivable
      createLedgerEntry(
        parseInt(selectedStationId.value),
        '1200', // Accounts Receivable
        'Customer_Payment',
        newPayment.PaymentID,
        `Payment applied to ${getCustomerName(account)} credit account`,
        '0.00',
        paymentData.amount.toString(),
      ),
    ])

    await Swal.fire({
      title: 'Payment Recorded!',
      text: `Payment of UGX ${formatCurrency(paymentData.amount)} recorded successfully`,
      icon: 'success',
      confirmButtonColor: '#50cd89',
    })

    // Refresh all data
    await Promise.all([fetchCreditSummary(), fetchPayments(), fetchOutstandingBalances()])
    calculateKPIs()
  } catch (error) {
    console.error('Error processing payment:', error)
    Swal.fire({
      title: 'Error!',
      text: error.message || 'Failed to process payment',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

const verifyPayment = async (payment) => {
  try {
    const result = await Swal.fire({
      title: 'Verify Payment',
      text: `Verify payment of UGX ${formatCurrency(payment.PaymentAmount)} from ${getCustomerName(payment)}?`,
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Verify',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#50cd89',
    })

    if (result.isConfirmed) {
      await fetch(`${API_BASE_URL}/CustomerCreditPayments/${payment.PaymentID}`, {
        method: 'PATCH',
        headers: {
          Authorization: `Bearer ${authData.token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          Status: 'Completed',
          VerifiedBy: currentUser.id,
        }),
      })

      await logAuditAction(
        'UPDATE',
        'CustomerCreditPayments',
        payment.PaymentID,
        { Status: payment.Status },
        { Status: 'Completed', VerifiedBy: currentUser.id },
      )

      await fetchPayments()

      Swal.fire({
        title: 'Verified!',
        text: 'Payment has been verified',
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    }
  } catch (error) {
    console.error('Error verifying payment:', error)
  }
}

// Utility Functions for Modal Display
const viewCustomer = (customer) => {
  Swal.fire({
    title: getCustomerName(customer),
    html: `
      <div class="text-start">
        <div class="row g-3">
          <div class="col-6">
            <strong>Customer Code:</strong><br>${customer.CustomerCode}
          </div>
          <div class="col-6">
            <strong>Type:</strong><br>${customer.CustomerType}
          </div>
          <div class="col-6">
            <strong>Phone:</strong><br>${customer.PhoneNumber}
          </div>
          <div class="col-6">
            <strong>Email:</strong><br>${customer.Email || 'Not provided'}
          </div>
          <div class="col-6">
            <strong>National ID:</strong><br>${customer.NationalID || 'Not provided'}
          </div>
          <div class="col-6">
            <strong>Tax ID:</strong><br>${customer.TaxID || 'Not provided'}
          </div>
          <div class="col-12">
            <strong>Address:</strong><br>${customer.Address || 'Not provided'}
          </div>
          <div class="col-6">
            <strong>Status:</strong><br><span class="badge ${getCustomerStatusBadge(customer.Status)}">${customer.Status}</span>
          </div>
          <div class="col-6">
            <strong>Registration Date:</strong><br>${formatDate(customer.RegistrationDate)}
          </div>
        </div>
      </div>
    `,
    confirmButtonText: 'Close',
    confirmButtonColor: '#3699ff',
    width: '600px',
  })
}

const viewAccountDetails = (account) => {
  const utilization = getCreditUtilization(account)
  const status = getCreditStatus(account)

  Swal.fire({
    title: `Credit Account - ${getCustomerName(account)}`,
    html: `
      <div class="text-start">
        <div class="row g-3">
          <div class="col-6">
            <strong>Credit Limit:</strong><br>UGX ${formatCurrency(account.CreditLimit)}
          </div>
          <div class="col-6">
            <strong>Outstanding:</strong><br>UGX ${formatCurrency(account.CurrentBalance)}
          </div>
          <div class="col-6">
            <strong>Available:</strong><br>UGX ${formatCurrency(account.AvailableCredit)}
          </div>
          <div class="col-6">
            <strong>Utilization:</strong><br><span class="${getUtilizationColor(utilization)}">${utilization}%</span>
          </div>
          <div class="col-6">
            <strong>Credit Score:</strong><br><span class="${getCreditScoreColor(account.CreditScore)}">${account.CreditScore}%</span>
          </div>
          <div class="col-6">
            <strong>Payment Terms:</strong><br>${account.PaymentTermsDays} days
          </div>
          <div class="col-6">
            <strong>Status:</strong><br><span class="badge ${getCreditStatusBadge(status)}">${status}</span>
          </div>
          <div class="col-6">
            <strong>Account Active:</strong><br><span class="badge ${account.IsActive === '1' ? 'badge-light-success' : 'badge-light-danger'}">${account.IsActive === '1' ? 'Yes' : 'No'}</span>
          </div>
          <div class="col-6">
            <strong>Last Purchase:</strong><br>${formatDate(account.LastPurchaseDate)}
          </div>
          <div class="col-6">
            <strong>Last Payment:</strong><br>${formatDate(account.LastPaymentDate)}
          </div>
          <div class="col-6">
            <strong>Last Payment Amount:</strong><br>UGX ${formatCurrency(account.LastPaymentAmount)}
          </div>
          <div class="col-6">
            <strong>Approved Date:</strong><br>${formatDate(account.ApprovedDate)}
          </div>
        </div>
      </div>
    `,
    confirmButtonText: 'Close',
    confirmButtonColor: '#3699ff',
    width: '700px',
  })
}

const viewPaymentDetails = (payment) => {
  Swal.fire({
    title: `Payment Details`,
    html: `
      <div class="text-start">
        <div class="row g-3">
          <div class="col-12">
            <strong>Customer:</strong><br>${getCustomerName(payment)}
          </div>
          <div class="col-6">
            <strong>Amount:</strong><br>UGX ${formatCurrency(payment.PaymentAmount)}
          </div>
          <div class="col-6">
            <strong>Method:</strong><br>${payment.PaymentMethod}
          </div>
          <div class="col-6">
            <strong>Reference:</strong><br>${payment.PaymentReference}
          </div>
          <div class="col-6">
            <strong>Date:</strong><br>${formatDateTime(payment.PaymentDate)}
          </div>
          <div class="col-6">
            <strong>Status:</strong><br><span class="badge ${getPaymentStatusBadge(payment.Status)}">${payment.Status}</span>
          </div>
          <div class="col-6">
            <strong>Received By:</strong><br>Staff ID: ${payment.ReceivedBy}
          </div>
          ${payment.MobileMoneyReference ? `<div class="col-12"><strong>Mobile Money Ref:</strong><br>${payment.MobileMoneyReference}</div>` : ''}
          ${payment.BankReference ? `<div class="col-12"><strong>Bank Reference:</strong><br>${payment.BankReference}</div>` : ''}
          ${payment.Notes ? `<div class="col-12"><strong>Notes:</strong><br>${payment.Notes}</div>` : ''}
          ${payment.VerifiedBy ? `<div class="col-12"><strong>Verified By:</strong><br>Staff ID: ${payment.VerifiedBy}</div>` : ''}
        </div>
      </div>
    `,
    confirmButtonText: 'Close',
    confirmButtonColor: '#3699ff',
    width: '600px',
  })
}

const followUpPayment = async (balance) => {
  const daysOutstanding = Math.floor(balance.DaysOutstanding)

  Swal.fire({
    title: 'Payment Follow-up',
    html: `
      <div class="text-start">
        <p><strong>Customer:</strong> ${balance.CustomerName}</p>
        <p><strong>Outstanding Amount:</strong> UGX ${formatCurrency(balance.OutstandingAmount)}</p>
        <p><strong>Days Outstanding:</strong> ${daysOutstanding} days</p>
        <p><strong>Aging Bucket:</strong> <span class="badge ${getAgingBadge(balance.AgingBucket)}">${balance.AgingBucket}</span></p>
        <div class="alert alert-info mt-3">
          <strong>Recommended Actions:</strong><br>
          ${daysOutstanding <= 30 ? '• Send friendly payment reminder' : ''}
          ${daysOutstanding > 30 && daysOutstanding <= 60 ? '• Phone call for payment discussion<br>• Request payment plan' : ''}
          ${daysOutstanding > 60 && daysOutstanding <= 90 ? '• Formal payment demand letter<br>• Suspend credit privileges<br>• Manager escalation' : ''}
          ${daysOutstanding > 90 ? '• Legal notice preparation<br>• Debt collection consideration<br>• Account review for write-off' : ''}
        </div>
      </div>
    `,
    confirmButtonText: 'Mark as Followed Up',
    showCancelButton: true,
    cancelButtonText: 'Close',
    confirmButtonColor: '#f1c40f',
  })
}

// Report Generation Functions
const generateCreditReport = async () => {
  try {
    const result = await Swal.fire({
      title: 'Generate Credit Report',
      html: `
        <div class="mb-3">
          <label class="form-label">Report Type</label>
          <select id="report-type" class="form-select">
            <option value="summary">Credit Summary Report</option>
            <option value="aging">Aging Analysis Report</option>
            <option value="risk">Risk Assessment Report</option>
            <option value="payment">Payment History Report</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">Date Range</label>
          <select id="date-range" class="form-select">
            <option value="30">Last 30 Days</option>
            <option value="60">Last 60 Days</option>
            <option value="90">Last 90 Days</option>
            <option value="365">Last 12 Months</option>
          </select>
        </div>
      `,
      showCancelButton: true,
      confirmButtonText: 'Generate Report',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#3699ff',
      preConfirm: () => {
        const reportType = document.getElementById('report-type').value
        const dateRange = document.getElementById('date-range').value
        return { reportType, dateRange }
      },
    })

    if (result.isConfirmed) {
      // Simulate report generation
      await Swal.fire({
        title: 'Report Generated!',
        text: `${result.value.reportType} report for ${selectedStationId.value ? 'selected station' : 'all stations'} has been generated.`,
        icon: 'success',
        confirmButtonColor: '#50cd89',
      })
    }
  } catch (error) {
    console.error('Error generating report:', error)
  }
}

const exportPayments = async () => {
  try {
    const result = await Swal.fire({
      title: 'Export Payments',
      text: 'Export payment data for the current filters?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Export',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#50cd89',
    })

    if (result.isConfirmed) {
      // Simulate export
      await Swal.fire({
        title: 'Exported!',
        text: `${filteredPayments.value.length} payment records exported successfully.`,
        icon: 'success',
        confirmButtonColor: '#50cd89',
      })
    }
  } catch (error) {
    console.error('Error exporting payments:', error)
  }
}

// Audit Logging Functions
const logAuditAction = async (action, tableName, recordId, oldValues, newValues) => {
  try {
    const auditData = {
      StationID: selectedStationId.value ? parseInt(selectedStationId.value) : null,
      UserID: currentUser.id,
      Action: action,
      TableName: tableName,
      RecordID: recordId,
      Changes: JSON.stringify({
        oldValues: oldValues || {},
        newValues: newValues || {},
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
      }),
      IPAddress: 'client_ip', // Would be replaced with actual IP in production
    }

    await fetch(`${API_BASE_URL}/AuditLogs`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${authData.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(auditData),
    })
  } catch (error) {
    console.error('Error logging audit action:', error)
  }
}

const createLedgerEntry = async (
  stationId,
  accountCode,
  transactionType,
  referenceId,
  description,
  debitAmount,
  creditAmount,
) => {
  try {
    const ledgerData = {
      StationID: stationId,
      TransactionDate: new Date().toISOString(),
      AccountCode: accountCode,
      TransactionType: transactionType,
      ReferenceID: referenceId,
      Description: description,
      DebitAmount: debitAmount,
      CreditAmount: creditAmount,
      RecordedBy: currentUser.id,
    }

    await fetch(`${API_BASE_URL}/LedgerEntries`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${authData.token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(ledgerData),
    })
  } catch (error) {
    console.error('Error creating ledger entry:', error)
  }
}

// Watchers
watch(selectedStationId, (newValue) => {
  if (newValue) {
    handleStationChange()
  }
})

// Component Initialization
onMounted(() => {
  if (userStations.length === 1) {
    selectedStationId.value = userStations[0].StationID.toString()
  }
})
</script>

<style scoped>
.w-250px {
  width: 250px !important;
}

.w-300px {
  width: 300px !important;
}

.w-150px {
  width: 150px !important;
}

.ps-13 {
  padding-left: 3.5rem !important;
}

.symbol-35px {
  width: 35px;
  height: 35px;
}

.symbol-40px {
  width: 40px;
  height: 40px;
}

.symbol-45px {
  width: 45px;
  height: 45px;
}

.fs-2hx {
  font-size: 1.75rem !important;
}

.modal-lg {
  max-width: 800px;
}

.table-responsive {
  border-radius: 0.475rem;
  overflow: hidden;
}

.card-flush {
  box-shadow: 0 0 50px 0 rgba(82, 63, 105, 0.15);
}

.nav-line-tabs-2x .nav-link {
  border-bottom: 2px solid transparent;
}

.nav-line-tabs-2x .nav-link.active {
  border-bottom-color: var(--bs-primary);
}

.border-danger {
  border: 1px solid #f1416c !important;
}

.border-warning {
  border: 1px solid #ffc700 !important;
}

.invalid-feedback {
  display: block;
}
</style>

<template>
  <div class="d-flex flex-column min-vh-100 bg-light">
    <!-- Premium Header Bar -->
    <div class="bg-white border-bottom shadow-sm">
      <div class="container-fluid px-4 py-3">
        <div class="d-flex justify-content-between align-items-center">
          <div class="d-flex align-items-center gap-3">
            <div class="d-flex align-items-center gap-2">
              <div class="bg-light-primary rounded-3 p-2">
                <i class="ki-duotone ki-wallet fs-2x text-primary">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                </i>
              </div>
              <div>
                <h4 class="mb-0 fw-bold text-gray-900">Payment Allocation</h4>
                <div class="text-muted fs-7">Supplier Credit Management</div>
              </div>
            </div>
          </div>

          <!-- Top Actions -->
          <div class="d-flex align-items-center gap-2">
            <button class="btn btn-light btn-sm" @click="showAnalytics = !showAnalytics">
              <i class="ki-duotone ki-chart-line fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Analytics
            </button>
            <button class="btn btn-light btn-sm" @click="showHelp = true">
              <i class="ki-duotone ki-information fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              Help
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content Area -->
    <div class="flex-grow-1 container-fluid p-4">
      <div class="row g-4">
        <!-- Left Panel - Selection Flow -->
        <div class="col-lg-8">
          <!-- Progress Indicator -->
          <div class="card card-flush mb-4">
            <div class="card-body py-3">
              <div class="d-flex justify-content-between align-items-center position-relative">
                <!-- Progress Line -->
                <div class="position-absolute top-50 start-0 w-100" style="height: 2px; z-index: 0">
                  <div class="bg-gray-300 h-100"></div>
                  <div
                    class="bg-primary h-100 position-absolute top-0 start-0 transition-all"
                    :style="`width: ${(currentStep / (steps.length - 1)) * 100}%`"
                  ></div>
                </div>

                <!-- Steps -->
                <div
                  v-for="(step, idx) in steps"
                  :key="idx"
                  class="d-flex flex-column align-items-center position-relative bg-white px-2"
                  style="z-index: 1"
                >
                  <div
                    :class="[
                      'rounded-circle d-flex align-items-center justify-content-center mb-1',
                      currentStep >= idx ? 'bg-primary text-white' : 'bg-gray-200 text-gray-600',
                      'transition-all',
                    ]"
                    style="width: 40px; height: 40px"
                  >
                    <i v-if="currentStep > idx" class="ki-duotone ki-check fs-3">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <span v-else class="fw-bold">{{ idx + 1 }}</span>
                  </div>
                  <div
                    :class="[
                      'fs-7',
                      currentStep >= idx ? 'text-gray-900 fw-semibold' : 'text-gray-500',
                    ]"
                  >
                    {{ step.title }}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Dynamic Content Area -->
          <div class="card card-flush shadow-sm">
            <div class="card-body">
              <!-- Station Selection -->
              <div v-if="currentStep === 0" class="animate__animated animate__fadeIn">
                <div class="d-flex align-items-center gap-3 mb-4">
                  <div class="bg-light-primary rounded-2 p-3">
                    <i class="ki-duotone ki-map-pin fs-2x text-primary">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </div>
                  <div>
                    <h5 class="mb-1 fw-bold">Select Station</h5>
                    <div class="text-muted fs-6">
                      Choose the station for this payment allocation
                    </div>
                  </div>
                </div>

                <div v-if="loadingStations" class="text-center py-5">
                  <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                  </div>
                </div>

                <div v-else class="row g-3">
                  <div v-for="station in stations" :key="station.StationID" class="col-md-6">
                    <div
                      :class="[
                        'card border hover-elevate-up cursor-pointer h-100',
                        selectedStationId === String(station.StationID)
                          ? 'border-primary bg-light-primary'
                          : '',
                      ]"
                      @click="selectStation(station)"
                    >
                      <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                          <div>
                            <h6 class="fw-bold mb-1">{{ station.StationName }}</h6>
                            <div class="text-muted fs-7">{{ station.Location }}</div>
                            <div class="mt-2">
                              <span class="badge badge-light-success">{{ station.Status }}</span>
                            </div>
                          </div>
                          <div v-if="selectedStationId === String(station.StationID)">
                            <i class="ki-duotone ki-check-circle fs-2x text-primary">
                              <span class="path1"></span>
                              <span class="path2"></span>
                            </i>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div v-if="stationError" class="alert alert-light-danger mt-3">
                  {{ stationError }}
                </div>
              </div>

              <!-- Supplier Selection -->
              <div v-if="currentStep === 1" class="animate__animated animate__fadeIn">
                <div class="d-flex align-items-center gap-3 mb-4">
                  <div class="bg-light-success rounded-2 p-3">
                    <i class="ki-duotone ki-user-square fs-2x text-success">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                      <span class="path4"></span>
                    </i>
                  </div>
                  <div>
                    <h5 class="mb-1 fw-bold">Select Supplier</h5>
                    <div class="text-muted fs-6">
                      Choose supplier assigned to {{ selectedStation?.StationName }}
                    </div>
                  </div>
                </div>

                <div v-if="loadingSuppliers" class="text-center py-5">
                  <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                  </div>
                </div>

                <div v-else-if="!assignedSuppliers.length" class="alert alert-light-warning">
                  <i class="ki-duotone ki-information-5 fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  No suppliers assigned to this station
                </div>

                <div v-else class="row g-3">
                  <div
                    v-for="supplier in assignedSuppliers"
                    :key="supplier.SupplierID"
                    class="col-12"
                  >
                    <div
                      :class="[
                        'card border hover-elevate-up cursor-pointer',
                        selectedSupplierId === supplier.SupplierID
                          ? 'border-primary bg-light-primary'
                          : '',
                      ]"
                      @click="selectSupplier(supplier)"
                    >
                      <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                          <div class="d-flex align-items-center gap-3">
                            <div class="symbol symbol-50px">
                              <div class="symbol-label bg-light-warning">
                                <i class="ki-duotone ki-truck fs-2x text-warning">
                                  <span class="path1"></span>
                                  <span class="path2"></span>
                                  <span class="path3"></span>
                                  <span class="path4"></span>
                                  <span class="path5"></span>
                                </i>
                              </div>
                            </div>
                            <div>
                              <h6 class="fw-bold mb-1">{{ supplier.Name }}</h6>
                              <div class="d-flex gap-3 text-muted fs-7">
                                <span
                                  ><i class="ki-duotone ki-phone fs-6 me-1"
                                    ><span class="path1"></span><span class="path2"></span
                                  ></i>
                                  {{ supplier.Phone }}</span
                                >
                                <span v-if="supplier.Email"
                                  ><i class="ki-duotone ki-sms fs-6 me-1"
                                    ><span class="path1"></span><span class="path2"></span
                                  ></i>
                                  {{ supplier.Email }}</span
                                >
                              </div>
                            </div>
                          </div>
                          <div>
                            <div v-if="selectedSupplierId === supplier.SupplierID">
                              <i class="ki-duotone ki-check-circle fs-2x text-primary">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                            </div>
                            <div v-else class="text-end">
                              <div class="fs-7 text-muted">Credit Limit</div>
                              <div class="fw-bold">
                                {{ formatMoney(supplier.creditLimit || 0) }}
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Payment Selection -->
              <div v-if="currentStep === 2" class="animate__animated animate__fadeIn">
                <div class="d-flex align-items-center gap-3 mb-4">
                  <div class="bg-light-info rounded-2 p-3">
                    <i class="ki-duotone ki-credit-card fs-2x text-info">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </div>
                  <div>
                    <h5 class="mb-1 fw-bold">Select Payment</h5>
                    <div class="text-muted fs-6">Choose an unallocated payment to allocate</div>
                  </div>
                </div>

                <div v-if="loadingPayments" class="text-center py-5">
                  <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                  </div>
                </div>

                <div v-else-if="!unallocatedPayments.length" class="alert alert-light-warning">
                  <i class="ki-duotone ki-information-5 fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  No unallocated payments found for this supplier
                </div>

                <div v-else>
                  <div class="table-responsive">
                    <table
                      class="table table-row-bordered table-row-gray-200 align-middle gs-0 gy-4"
                    >
                      <thead>
                        <tr class="fw-bold text-muted bg-light">
                          <th class="ps-4 min-w-150px">Payment Reference</th>
                          <th class="min-w-100px">Date</th>
                          <th class="min-w-100px">Method</th>
                          <th class="min-w-125px text-end">Amount</th>
                          <th class="min-w-125px text-end">Unallocated</th>
                          <th class="min-w-50px text-end pe-4">Select</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr
                          v-for="payment in unallocatedPayments"
                          :key="payment.PaymentID"
                          :class="{ 'bg-light-primary': selectedPaymentId === payment.PaymentID }"
                          class="cursor-pointer"
                          @click="selectPayment(payment)"
                        >
                          <td class="ps-4">
                            <div class="fw-bold text-gray-800">{{ payment.PaymentReference }}</div>
                          </td>
                          <td>{{ formatDate(payment.PaymentDate) }}</td>
                          <td>
                            <span class="badge badge-light-info">{{ payment.PaymentMethod }}</span>
                          </td>
                          <td class="text-end fw-semibold">
                            {{ formatMoney(payment.PaymentAmount) }}
                          </td>
                          <td class="text-end">
                            <span class="text-success fw-bold">{{
                              formatMoney(getUnallocatedAmount(payment))
                            }}</span>
                          </td>
                          <td class="text-end pe-4">
                            <div class="form-check form-check-custom form-check-solid">
                              <input
                                class="form-check-input"
                                type="radio"
                                :checked="selectedPaymentId === payment.PaymentID"
                              />
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

              <!-- Invoice Allocation -->
              <div v-if="currentStep === 3" class="animate__animated animate__fadeIn">
                <div class="d-flex align-items-center gap-3 mb-4">
                  <div class="bg-light-warning rounded-2 p-3">
                    <i class="ki-duotone ki-document fs-2x text-warning">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </div>
                  <div class="flex-grow-1">
                    <h5 class="mb-1 fw-bold">Allocate to Invoices</h5>
                    <div class="text-muted fs-6">
                      Distribute payment across outstanding invoices
                    </div>
                  </div>
                  <div class="text-end">
                    <div class="fs-7 text-muted">Available to Allocate</div>
                    <div class="fs-3 fw-bold text-success">
                      {{ formatMoney(availableToAllocate) }}
                    </div>
                  </div>
                </div>

                <div v-if="loadingInvoices" class="text-center py-5">
                  <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                  </div>
                </div>

                <div v-else-if="!outstandingInvoices.length" class="alert alert-light-info">
                  <i class="ki-duotone ki-information-5 fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  No outstanding invoices found for this supplier
                </div>

                <div v-else>
                  <div class="table-responsive mb-4">
                    <table
                      class="table table-row-bordered table-row-gray-200 align-middle gs-0 gy-3"
                    >
                      <thead>
                        <tr class="fw-bold text-muted bg-light">
                          <th class="ps-4 min-w-200px">Invoice Details</th>
                          <th class="min-w-100px">Due Date</th>
                          <th class="min-w-125px text-end">Total Amount</th>
                          <th class="min-w-125px text-end">Outstanding</th>
                          <th class="min-w-150px text-end pe-4">Allocate</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="invoice in outstandingInvoices" :key="invoice.InvoiceID">
                          <td class="ps-4">
                            <div class="d-flex flex-column">
                              <div class="fw-bold text-gray-800">{{ invoice.InvoiceNumber }}</div>
                              <div class="fs-7 text-muted">
                                {{ invoice.Description || 'No description' }}
                              </div>
                              <div v-if="invoiceWarnings[invoice.InvoiceID]" class="mt-1">
                                <span class="badge badge-light-danger fs-8">
                                  <i class="ki-duotone ki-information-5 fs-7 me-1">
                                    <span class="path1"></span>
                                    <span class="path2"></span>
                                    <span class="path3"></span>
                                  </i>
                                  {{ invoiceWarnings[invoice.InvoiceID] }}
                                </span>
                              </div>
                            </div>
                          </td>
                          <td>
                            <div :class="['fw-semibold', getDueDateClass(invoice.DueDate)]">
                              {{ formatDate(invoice.DueDate) }}
                            </div>
                            <div class="fs-8 text-muted">{{ getDaysOverdue(invoice.DueDate) }}</div>
                          </td>
                          <td class="text-end">{{ formatMoney(invoice.TotalAmount) }}</td>
                          <td class="text-end">
                            <div class="fw-bold text-danger">
                              {{ formatMoney(invoice.OutstandingAmount) }}
                            </div>
                          </td>
                          <td class="text-end pe-4">
                            <div class="input-group">
                              <span class="input-group-text">UGX</span>
                              <input
                                type="number"
                                class="form-control text-end"
                                v-model.number="allocations[invoice.InvoiceID]"
                                :max="Math.min(invoice.OutstandingAmount, availableToAllocate)"
                                :min="0"
                                step="0.01"
                                @input="validateAllocation(invoice)"
                              />
                            </div>
                          </td>
                        </tr>
                      </tbody>
                      <tfoot>
                        <tr class="fw-bold bg-light">
                          <td colspan="4" class="text-end ps-4">Total Allocated:</td>
                          <td class="text-end pe-4">
                            <div
                              :class="[
                                'fs-4',
                                totalAllocated > availableToAllocate
                                  ? 'text-danger'
                                  : 'text-success',
                              ]"
                            >
                              {{ formatMoney(totalAllocated) }}
                            </div>
                          </td>
                        </tr>
                      </tfoot>
                    </table>
                  </div>

                  <div v-if="allocationErrors.length" class="alert alert-light-danger mb-4">
                    <div class="d-flex align-items-center mb-2">
                      <i class="ki-duotone ki-information-5 fs-2 me-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                      <div class="fw-bold">Validation Errors</div>
                    </div>
                    <ul class="mb-0">
                      <li v-for="(error, idx) in allocationErrors" :key="idx">{{ error }}</li>
                    </ul>
                  </div>
                </div>
              </div>

              <!-- Success -->
              <div v-if="currentStep === 4" class="animate__animated animate__fadeIn">
                <div class="text-center py-8">
                  <div class="mb-4">
                    <div
                      class="bg-light-success rounded-circle d-inline-flex align-items-center justify-content-center"
                      style="width: 100px; height: 100px"
                    >
                      <i class="ki-duotone ki-check fs-1 text-success">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </div>
                  </div>
                  <h3 class="fw-bold mb-2">Allocation Completed Successfully!</h3>
                  <div class="text-muted fs-5 mb-5">
                    Payment has been allocated and all balances have been updated.
                  </div>
                  <div class="d-flex gap-2 justify-content-center">
                    <button class="btn btn-primary" @click="resetWizard">
                      <i class="ki-duotone ki-plus fs-2 me-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                      New Allocation
                    </button>
                    <button class="btn btn-light-primary">
                      <i class="ki-duotone ki-printer fs-2 me-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      Print Receipt
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Navigation Footer -->
            <div v-if="currentStep < 4" class="card-footer bg-light">
              <div class="d-flex justify-content-between align-items-center">
                <button class="btn btn-light" @click="previousStep" :disabled="currentStep === 0">
                  <i class="ki-duotone ki-arrow-left fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Back
                </button>

                <div class="d-flex gap-2">
                  <button
                    v-if="currentStep === 3"
                    class="btn btn-primary"
                    @click="completeAllocation"
                    :disabled="!canComplete || submitting"
                  >
                    <span v-if="submitting" class="spinner-border spinner-border-sm me-2"></span>
                    <i v-else class="ki-duotone ki-check fs-2 me-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    Complete Allocation
                  </button>

                  <button v-else class="btn btn-primary" @click="nextStep" :disabled="!canProceed">
                    Next
                    <i class="ki-duotone ki-arrow-right fs-2 ms-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Panel - Context & Analytics -->
        <div class="col-lg-4">
          <!-- Summary Card -->
          <div class="card card-flush mb-4">
            <div class="card-header pt-5">
              <h3 class="card-title fw-bold">Allocation Summary</h3>
            </div>
            <div class="card-body">
              <div class="d-flex flex-column gap-4">
                <!-- Station -->
                <div v-if="selectedStation">
                  <div class="fs-7 text-muted mb-1">Station</div>
                  <div class="fw-bold">{{ selectedStation.StationName }}</div>
                </div>

                <!-- Supplier -->
                <div v-if="selectedSupplier">
                  <div class="fs-7 text-muted mb-1">Supplier</div>
                  <div class="fw-bold">{{ selectedSupplier.Name }}</div>
                </div>

                <!-- Payment -->
                <div v-if="selectedPayment">
                  <div class="fs-7 text-muted mb-1">Payment</div>
                  <div class="fw-bold">{{ selectedPayment.PaymentReference }}</div>
                  <div class="fs-7 text-muted">
                    {{ formatMoney(selectedPayment.PaymentAmount) }}
                  </div>
                </div>

                <!-- Allocation Progress -->
                <div v-if="currentStep === 3 && selectedPayment">
                  <div class="separator my-4"></div>
                  <div class="fs-7 text-muted mb-2">Allocation Progress</div>
                  <div class="progress" style="height: 8px">
                    <div
                      class="progress-bar bg-success"
                      :style="`width: ${allocationProgress}%`"
                    ></div>
                  </div>
                  <div class="d-flex justify-content-between mt-2 fs-7">
                    <span>{{ formatMoney(totalAllocated) }}</span>
                    <span class="text-muted">{{ formatMoney(availableToAllocate) }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Analytics Card -->
          <div v-if="showAnalytics && analyticsData.series.length" class="card card-flush">
            <div class="card-header pt-5">
              <h3 class="card-title fw-bold">Station Analytics</h3>
            </div>
            <div class="card-body">
              <!-- Simple Chart Alternative -->
              <div class="mb-4">
                <div class="d-flex align-items-center justify-content-between mb-2">
                  <span class="fs-7 fw-semibold">Current (0-30 days)</span>
                  <span class="badge badge-light-success">{{
                    formatMoney(analyticsData.series[0])
                  }}</span>
                </div>
                <div class="progress" style="height: 8px">
                  <div
                    class="progress-bar bg-success"
                    :style="`width: ${getAnalyticsPercent(0)}%`"
                  ></div>
                </div>
              </div>

              <div class="mb-4">
                <div class="d-flex align-items-center justify-content-between mb-2">
                  <span class="fs-7 fw-semibold">Overdue (31-60 days)</span>
                  <span class="badge badge-light-warning">{{
                    formatMoney(analyticsData.series[1])
                  }}</span>
                </div>
                <div class="progress" style="height: 8px">
                  <div
                    class="progress-bar bg-warning"
                    :style="`width: ${getAnalyticsPercent(1)}%`"
                  ></div>
                </div>
              </div>

              <div class="mb-4">
                <div class="d-flex align-items-center justify-content-between mb-2">
                  <span class="fs-7 fw-semibold">Critical (60+ days)</span>
                  <span class="badge badge-light-danger">{{
                    formatMoney(analyticsData.series[2])
                  }}</span>
                </div>
                <div class="progress" style="height: 8px">
                  <div
                    class="progress-bar bg-danger"
                    :style="`width: ${getAnalyticsPercent(2)}%`"
                  ></div>
                </div>
              </div>

              <!-- Risk Indicators -->
              <div v-if="riskIndicators.length" class="mt-4">
                <div class="fs-6 fw-bold mb-3">Risk Indicators</div>
                <div class="d-flex flex-column gap-2">
                  <div
                    v-for="(risk, idx) in riskIndicators"
                    :key="idx"
                    class="alert alert-light-danger py-2 mb-0"
                  >
                    <div class="d-flex align-items-center">
                      <i class="ki-duotone ki-information-5 fs-2 me-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                      <div class="fs-7">{{ risk }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Help Modal -->
    <div v-if="showHelp" class="modal fade show d-block" style="background: rgba(0, 0, 0, 0.5)">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold">Payment Allocation Guide</h5>
            <button type="button" class="btn-close" @click="showHelp = false"></button>
          </div>
          <div class="modal-body">
            <div class="d-flex flex-column gap-4">
              <div>
                <h6 class="fw-bold mb-2">Overview</h6>
                <p class="text-muted">
                  Payment allocation ensures that supplier payments are properly matched to specific
                  invoices, maintaining accurate financial records and enabling proper cash flow
                  management.
                </p>
              </div>

              <div>
                <h6 class="fw-bold mb-2">Process Steps</h6>
                <ol class="text-muted">
                  <li>
                    <strong>Station Selection:</strong> Choose the station where the payment was
                    received
                  </li>
                  <li>
                    <strong>Supplier Selection:</strong> Select the supplier from those assigned to
                    the station
                  </li>
                  <li>
                    <strong>Payment Selection:</strong> Choose an unallocated payment to distribute
                  </li>
                  <li>
                    <strong>Invoice Allocation:</strong> Distribute the payment across outstanding
                    invoices
                  </li>
                  <li><strong>Confirmation:</strong> Review and confirm the allocation</li>
                </ol>
              </div>

              <div>
                <h6 class="fw-bold mb-2">Best Practices</h6>
                <ul class="text-muted">
                  <li>Allocate payments promptly to maintain accurate records</li>
                  <li>Pay attention to overdue invoices (highlighted in red)</li>
                  <li>Review fraud warnings and risk indicators</li>
                  <li>Ensure total allocation doesn't exceed available amount</li>
                </ul>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" @click="showHelp = false">Close</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, watch, onMounted } from 'vue'
import Swal from 'sweetalert2'

// Fix the API base URL
const API_BASE = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT = localStorage.getItem('jwt') || ''

// Wizard state
const steps = [
  { title: 'Station', icon: 'map-pin' },
  { title: 'Supplier', icon: 'user-square' },
  { title: 'Payment', icon: 'credit-card' },
  { title: 'Allocate', icon: 'document' },
  { title: 'Complete', icon: 'check-circle' },
]

const currentStep = ref(0)

// Data state
const stations = ref([])
const assignedSuppliers = ref([])
const unallocatedPayments = ref([])
const outstandingInvoices = ref([])

// Selection state
const selectedStationId = ref('')
const selectedSupplierId = ref('')
const selectedPaymentId = ref('')
const allocations = reactive({})

// Loading states
const loadingStations = ref(false)
const loadingSuppliers = ref(false)
const loadingPayments = ref(false)
const loadingInvoices = ref(false)
const submitting = ref(false)

// UI state
const showAnalytics = ref(true)
const showHelp = ref(false)
const stationError = ref('')

// Validation and warnings
const allocationErrors = ref([])
const invoiceWarnings = reactive({})
const riskIndicators = ref([])

// Analytics data
const analyticsData = reactive({
  series: [0, 0, 0],
  total: 0,
})

// Computed properties
const selectedStation = computed(() =>
  stations.value.find((s) => String(s.StationID) === selectedStationId.value),
)

const selectedSupplier = computed(() =>
  assignedSuppliers.value.find((s) => s.SupplierID === selectedSupplierId.value),
)

const selectedPayment = computed(() =>
  unallocatedPayments.value.find((p) => p.PaymentID === selectedPaymentId.value),
)

const availableToAllocate = computed(() => {
  if (!selectedPayment.value) return 0
  return Number(selectedPayment.value.PaymentAmount || 0)
})

const totalAllocated = computed(() => {
  return Object.values(allocations).reduce((sum, val) => sum + (Number(val) || 0), 0)
})

const allocationProgress = computed(() => {
  if (!availableToAllocate.value) return 0
  return Math.min(100, (totalAllocated.value / availableToAllocate.value) * 100)
})

const canProceed = computed(() => {
  switch (currentStep.value) {
    case 0:
      return !!selectedStationId.value
    case 1:
      return !!selectedSupplierId.value
    case 2:
      return !!selectedPaymentId.value
    case 3:
      return totalAllocated.value > 0 && totalAllocated.value <= availableToAllocate.value
    default:
      return false
  }
})

const canComplete = computed(() => {
  return (
    totalAllocated.value > 0 &&
    totalAllocated.value <= availableToAllocate.value &&
    allocationErrors.value.length === 0
  )
})

// Helper functions
const formatMoney = (amount) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount)
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  return new Date(dateStr).toLocaleDateString('en-UG')
}

const getDaysOverdue = (dueDate) => {
  const days = Math.floor((new Date() - new Date(dueDate)) / (1000 * 60 * 60 * 24))
  if (days <= 0) return 'Not overdue'
  return `${days} days overdue`
}

const getDueDateClass = (dueDate) => {
  const days = Math.floor((new Date() - new Date(dueDate)) / (1000 * 60 * 60 * 24))
  if (days > 60) return 'text-danger'
  if (days > 30) return 'text-warning'
  if (days > 0) return 'text-info'
  return 'text-success'
}

const getUnallocatedAmount = (payment) => {
  // In a real system, you'd calculate this based on previous allocations
  return payment.PaymentAmount
}

const getAnalyticsPercent = (index) => {
  if (!analyticsData.total) return 0
  return Math.round((analyticsData.series[index] / analyticsData.total) * 100)
}

// API functions
const apiCall = async (url, options = {}) => {
  try {
    const response = await fetch(url, {
      ...options,
      headers: {
        Authorization: `Bearer ${JWT}`,
        'Content-Type': 'application/json',
        ...options.headers,
      },
    })

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API Call Failed:', error)
    throw error
  }
}

// Data fetching functions
const fetchStations = async () => {
  loadingStations.value = true
  stationError.value = ''
  try {
    const data = await apiCall(`${API_BASE}/Stations`)
    stations.value = data.records || []
  } catch (error) {
    stationError.value = 'Failed to load stations. Please check your connection.'
    Swal.fire({
      icon: 'error',
      title: 'Failed to load stations',
      text: stationError.value,
    })
  } finally {
    loadingStations.value = false
  }
}

const fetchAssignedSuppliers = async () => {
  if (!selectedStationId.value) return

  loadingSuppliers.value = true
  try {
    // First get supplier-station relationships
    const supplierStationsData = await apiCall(
      `${API_BASE}/SupplierStations?StationID=${selectedStationId.value}`,
    )

    const supplierIds = (supplierStationsData.records || []).map((r) => r.SupplierID)

    if (supplierIds.length === 0) {
      assignedSuppliers.value = []
      return
    }

    // Then get supplier details
    const suppliersData = await apiCall(
      `${API_BASE}/Suppliers?SupplierID=in.(${supplierIds.join(',')})`,
    )

    assignedSuppliers.value = suppliersData.records || []

    // Get credit information for each supplier
    for (const supplier of assignedSuppliers.value) {
      try {
        const creditData = await apiCall(
          `${API_BASE}/SupplierCreditAccounts?SupplierID=${supplier.SupplierID}&StationID=${selectedStationId.value}`,
        )
        if (creditData.records && creditData.records[0]) {
          supplier.creditLimit = creditData.records[0].CreditLimit
          supplier.currentBalance = creditData.records[0].CurrentBalance
        }
      } catch (error) {
        console.warn('Could not fetch credit data for supplier', supplier.SupplierID)
      }
    }
  } catch (error) {
    console.error('Error fetching suppliers:', error)
    assignedSuppliers.value = []
  } finally {
    loadingSuppliers.value = false
  }
}

const fetchUnallocatedPayments = async () => {
  if (!selectedSupplierId.value || !selectedStationId.value) return

  loadingPayments.value = true
  try {
    const data = await apiCall(
      `${API_BASE}/SupplierPayments?SupplierID=${selectedSupplierId.value}&StationID=${selectedStationId.value}`,
    )

    // For now, assume all payments are unallocated (you'll need to implement allocation tracking)
    unallocatedPayments.value = (data.records || []).filter((p) => p.Status === 'Completed')
  } catch (error) {
    console.error('Error fetching payments:', error)
    unallocatedPayments.value = []
  } finally {
    loadingPayments.value = false
  }
}

const fetchOutstandingInvoices = async () => {
  if (!selectedSupplierId.value || !selectedStationId.value) return

  loadingInvoices.value = true
  try {
    const data = await apiCall(
      `${API_BASE}/SupplierInvoices?SupplierID=${selectedSupplierId.value}&StationID=${selectedStationId.value}&Status=Outstanding`,
    )

    outstandingInvoices.value = (data.records || []).filter(
      (inv) => Number(inv.OutstandingAmount) > 0,
    )

    // Run fraud checks
    checkInvoiceWarnings()
    updateAnalytics()
  } catch (error) {
    console.error('Error fetching invoices:', error)
    outstandingInvoices.value = []
  } finally {
    loadingInvoices.value = false
  }
}

// Fraud and risk detection
const checkInvoiceWarnings = () => {
  Object.keys(invoiceWarnings).forEach((k) => delete invoiceWarnings[k])
  riskIndicators.value = []

  const invoiceMap = {}

  for (const invoice of outstandingInvoices.value) {
    // Check for duplicates
    const key = `${invoice.InvoiceNumber}-${invoice.SupplierID}`
    if (invoiceMap[key]) {
      invoiceWarnings[invoice.InvoiceID] = 'Possible duplicate invoice'
      riskIndicators.value.push(`Duplicate invoice detected: ${invoice.InvoiceNumber}`)
    }
    invoiceMap[key] = true

    // Check overdue status
    const daysOverdue = Math.floor((new Date() - new Date(invoice.DueDate)) / (1000 * 60 * 60 * 24))
    if (daysOverdue > 180) {
      invoiceWarnings[invoice.InvoiceID] = 'Severely overdue (>180 days)'
      riskIndicators.value.push(`Invoice ${invoice.InvoiceNumber} is severely overdue`)
    }

    // Check unusual amounts
    if (invoice.OutstandingAmount > 100000000) {
      invoiceWarnings[invoice.InvoiceID] = 'Unusually high amount'
      riskIndicators.value.push(`High value invoice: ${invoice.InvoiceNumber}`)
    }
  }
}

const updateAnalytics = () => {
  const current = []
  const medium = []
  const old = []

  for (const invoice of outstandingInvoices.value) {
    const daysOverdue = Math.floor((new Date() - new Date(invoice.DueDate)) / (1000 * 60 * 60 * 24))
    const amount = Number(invoice.OutstandingAmount)

    if (daysOverdue <= 30) current.push(amount)
    else if (daysOverdue <= 60) medium.push(amount)
    else old.push(amount)
  }

  analyticsData.series = [
    current.reduce((a, b) => a + b, 0),
    medium.reduce((a, b) => a + b, 0),
    old.reduce((a, b) => a + b, 0),
  ]

  analyticsData.total = analyticsData.series.reduce((a, b) => a + b, 0)
}

// Validation
const validateAllocation = (invoice) => {
  allocationErrors.value = []

  const amount = Number(allocations[invoice.InvoiceID] || 0)

  if (amount < 0) {
    allocationErrors.value.push('Allocation amounts cannot be negative')
  }

  if (amount > invoice.OutstandingAmount) {
    allocationErrors.value.push(
      `Cannot allocate more than outstanding amount for invoice ${invoice.InvoiceNumber}`,
    )
  }

  if (totalAllocated.value > availableToAllocate.value) {
    allocationErrors.value.push('Total allocation exceeds available payment amount')
  }
}

// Actions
const selectStation = (station) => {
  selectedStationId.value = String(station.StationID)
  nextStep()
}

const selectSupplier = (supplier) => {
  selectedSupplierId.value = supplier.SupplierID
  nextStep()
}

const selectPayment = (payment) => {
  selectedPaymentId.value = payment.PaymentID
  nextStep()
}

const nextStep = () => {
  if (canProceed.value && currentStep.value < steps.length - 1) {
    currentStep.value++

    // Trigger data loading for next step
    switch (currentStep.value) {
      case 1:
        fetchAssignedSuppliers()
        break
      case 2:
        fetchUnallocatedPayments()
        break
      case 3:
        fetchOutstandingInvoices()
        break
    }
  }
}

const previousStep = () => {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

const completeAllocation = async () => {
  if (!canComplete.value) return

  submitting.value = true
  try {
    // Create allocation records
    const allocationPromises = []

    for (const [invoiceId, amount] of Object.entries(allocations)) {
      if (amount > 0) {
        allocationPromises.push(
          apiCall(`${API_BASE}/SupplierPaymentAllocations`, {
            method: 'POST',
            body: JSON.stringify({
              PaymentID: selectedPaymentId.value,
              InvoiceID: Number(invoiceId),
              AllocatedAmount: String(amount),
              AllocationDate: new Date().toISOString().split('T')[0],
            }),
          }),
        )
      }
    }

    await Promise.all(allocationPromises)

    // Log the transaction
    await apiCall(`${API_BASE}/SupplierCreditTransactions`, {
      method: 'POST',
      body: JSON.stringify({
        SupplierID: selectedSupplierId.value,
        StationID: Number(selectedStationId.value),
        TransactionType: 'Payment',
        ReferenceID: selectedPaymentId.value,
        Amount: String(totalAllocated.value),
        PreviousBalance: '0', // You'd calculate this from current balance
        NewBalance: '0', // You'd calculate this
        Description: `Payment allocation for ${selectedPayment.value.PaymentReference}`,
        CreatedBy: 1, // Get from current user
      }),
    })

    currentStep.value = 4

    Swal.fire({
      icon: 'success',
      title: 'Success!',
      text: 'Payment has been allocated successfully',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Error completing allocation:', error)
    Swal.fire({
      icon: 'error',
      title: 'Allocation Failed',
      text: 'Failed to complete allocation. Please try again.',
    })
  } finally {
    submitting.value = false
  }
}

const resetWizard = () => {
  currentStep.value = 0
  selectedStationId.value = ''
  selectedSupplierId.value = ''
  selectedPaymentId.value = ''
  Object.keys(allocations).forEach((k) => delete allocations[k])
  allocationErrors.value = []
  Object.keys(invoiceWarnings).forEach((k) => delete invoiceWarnings[k])
  riskIndicators.value = []
  analyticsData.series = [0, 0, 0]
  analyticsData.total = 0
}

// Initialize
onMounted(() => {
  fetchStations()
})
</script>

<style scoped>
.hover-elevate-up {
  transition: all 0.3s ease;
}

.hover-elevate-up:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.cursor-pointer {
  cursor: pointer;
}

.transition-all {
  transition: all 0.3s ease;
}

.animate__animated {
  animation-duration: 0.5s;
}

.symbol {
  display: inline-block;
  flex-shrink: 0;
  position: relative;
  border-radius: 0.475rem;
}

.symbol-label {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  border-radius: inherit;
}

.symbol-50px {
  width: 50px;
  height: 50px;
}
</style>

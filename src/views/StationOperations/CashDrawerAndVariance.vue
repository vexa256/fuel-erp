<template>
  <div class="d-flex flex-column gap-5 h-100">
    <!-- Header Card -->
    <div class="card card-flush shadow-sm">
      <div class="card-header pt-7 pb-4">
        <div class="card-title">
          <h1 class="fw-bold text-gray-900 fs-2x">
            <i class="ki-duotone ki-wallet text-primary fs-1 me-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Cash Drawer Variance Resolution
          </h1>
        </div>
        <div class="card-toolbar">
          <div class="d-flex align-items-center gap-3">
            <!-- Shift Status -->
            <div
              v-if="currentUserShift"
              class="badge fs-7 fw-bold px-3 py-2"
              :class="currentUserShift.readOnly ? 'badge-light-warning' : 'badge-light-primary'"
            >
              <i
                class="ki-duotone fs-6 me-1"
                :class="
                  currentUserShift.readOnly ? 'ki-eye text-warning' : 'ki-calendar text-primary'
                "
              >
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ currentUserShift.readOnly ? 'View Only' : 'Shift' }}:
              {{ currentUserShift.ShiftType }} #{{ currentUserShift.DrawerID }}
            </div>
            <!-- Single Station Info (No Selection) -->
            <div v-if="assignedStation" class="badge badge-light-info fs-7 fw-bold px-3 py-2">
              <i class="ki-duotone ki-home text-info fs-6 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Station: {{ assignedStation.Name || `Station ${assignedStation.StationID}` }}
            </div>
            <!-- Station Loading State -->
            <div
              v-else-if="stationLoading"
              class="badge badge-light-warning fs-7 fw-bold px-3 py-2"
            >
              <div class="spinner-border spinner-border-sm me-2" role="status"></div>
              Loading Station...
            </div>
            <!-- No Station Error State -->
            <div
              v-else-if="!assignedStation"
              class="badge badge-light-danger fs-7 fw-bold px-3 py-2"
            >
              <i class="ki-duotone ki-cross-circle text-danger fs-6 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              No Station Assigned
            </div>
            <!-- Current User -->
            <div class="badge badge-light-success fs-7 fw-bold px-3 py-2">
              <i class="ki-duotone ki-user text-success fs-6 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ currentUser?.name || 'User' }}
            </div>
            <!-- System Status -->
            <div
              class="badge fs-7 fw-bold px-3 py-2"
              :class="systemStatus.online ? 'badge-light-success' : 'badge-light-danger'"
            >
              <i
                class="ki-duotone fs-6 me-1"
                :class="
                  systemStatus.online
                    ? 'ki-check-circle text-success'
                    : 'ki-cross-circle text-danger'
                "
              >
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ systemStatus.online ? 'Online' : 'Offline' }}
            </div>
            <!-- Close Shift Button -->
            <button
              v-if="currentUserShift && !currentUserShift.readOnly"
              @click="closeCurrentShift"
              class="btn btn-sm btn-light-danger"
              :disabled="loading"
            >
              <i class="ki-duotone ki-cross-circle text-danger fs-6 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Close Shift
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content Card with Wizard -->
    <div class="card card-flush shadow-sm flex-grow-1">
      <div class="card-body p-0">
        <!-- Wizard Navigation -->
        <div
          class="stepper stepper-pills stepper-column d-flex flex-column flex-xl-row flex-row-fluid gap-10"
          id="kt_create_account_stepper"
        >
          <!-- Stepper Nav -->
          <div
            class="card d-flex justify-content-center justify-content-xl-start flex-row-auto w-100 w-xl-300px w-xxl-400px border-0"
          >
            <div class="card-body px-6 px-lg-10 px-xxl-15 py-20">
              <div class="stepper-nav">
                <!-- Step 1 -->
                <div
                  class="stepper-item"
                  :class="{ current: currentStep === 1, completed: currentStep > 1 }"
                >
                  <div class="stepper-wrapper">
                    <div class="stepper-icon">
                      <i class="ki-duotone ki-check stepper-check fs-1"></i>
                      <span class="stepper-number">1</span>
                    </div>
                    <div class="stepper-label">
                      <h3 class="stepper-title">Shift Detection</h3>
                      <div class="stepper-desc fw-semibold">Initialize cash drawer</div>
                    </div>
                  </div>
                  <div class="stepper-line h-40px"></div>
                </div>

                <!-- Step 2 -->
                <div
                  class="stepper-item"
                  :class="{ current: currentStep === 2, completed: currentStep > 2 }"
                >
                  <div class="stepper-wrapper">
                    <div class="stepper-icon">
                      <i class="ki-duotone ki-check stepper-check fs-1"></i>
                      <span class="stepper-number">2</span>
                    </div>
                    <div class="stepper-label">
                      <h3 class="stepper-title">Variance Detection</h3>
                      <div class="stepper-desc fw-semibold">Calculate discrepancies</div>
                    </div>
                  </div>
                  <div class="stepper-line h-40px"></div>
                </div>

                <!-- Step 3 -->
                <div
                  class="stepper-item"
                  :class="{ current: currentStep === 3, completed: currentStep > 3 }"
                >
                  <div class="stepper-wrapper">
                    <div class="stepper-icon">
                      <i class="ki-duotone ki-check stepper-check fs-1"></i>
                      <span class="stepper-number">3</span>
                    </div>
                    <div class="stepper-label">
                      <h3 class="stepper-title">Discrepancy Analysis</h3>
                      <div class="stepper-desc fw-semibold">Document variances</div>
                    </div>
                  </div>
                  <div class="stepper-line h-40px"></div>
                </div>

                <!-- Step 4 -->
                <div
                  class="stepper-item"
                  :class="{ current: currentStep === 4, completed: currentStep > 4 }"
                >
                  <div class="stepper-wrapper">
                    <div class="stepper-icon">
                      <i class="ki-duotone ki-check stepper-check fs-1"></i>
                      <span class="stepper-number">4</span>
                    </div>
                    <div class="stepper-label">
                      <h3 class="stepper-title">Resolution Actions</h3>
                      <div class="stepper-desc fw-semibold">Apply corrections</div>
                    </div>
                  </div>
                  <div class="stepper-line h-40px"></div>
                </div>

                <!-- Step 5 -->
                <div
                  class="stepper-item"
                  :class="{ current: currentStep === 5, completed: currentStep > 5 }"
                >
                  <div class="stepper-wrapper">
                    <div class="stepper-icon">
                      <i class="ki-duotone ki-check stepper-check fs-1"></i>
                      <span class="stepper-number">5</span>
                    </div>
                    <div class="stepper-label">
                      <h3 class="stepper-title">Handover Completion</h3>
                      <div class="stepper-desc fw-semibold">Finalize shift transfer</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Stepper Content -->
          <div class="card d-flex flex-row-fluid flex-center">
            <div class="card-body py-20 w-100 mw-xl-700px px-9">
              <!-- Step 1: Shift Detection -->
              <div v-if="currentStep === 1" class="current">
                <div class="w-100">
                  <div class="pb-10 pb-lg-12">
                    <h2 class="fw-bold text-gray-900 fs-2x mb-4">Current Shift Status</h2>
                    <p class="text-muted fs-6 fw-semibold">
                      Review your active cash drawer and shift information.
                    </p>
                  </div>

                  <!-- Loading State -->
                  <div
                    v-if="loading && (!shiftInitialized || stationLoading)"
                    class="d-flex flex-column align-items-center py-10"
                  >
                    <div class="spinner-border text-primary mb-3" role="status">
                      <span class="visually-hidden">Loading...</span>
                    </div>
                    <div class="text-center">
                      <h5 class="text-gray-700 mb-2">
                        {{
                          stationLoading
                            ? 'Loading Your Assigned Station'
                            : 'Detecting Your Current Shift'
                        }}
                      </h5>
                      <span class="text-muted fs-7">
                        {{
                          stationLoading
                            ? 'Retrieving station assignment from database...'
                            : 'Checking for existing shift or creating new one...'
                        }}
                      </span>
                    </div>
                  </div>

                  <!-- Current Shift Display -->
                  <div v-else-if="currentUserShift" class="row g-6">
                    <!-- Main Shift Card -->
                    <div class="col-12">
                      <div class="card card-flush border border-primary h-xl-100">
                        <div class="card-header bg-light-primary">
                          <div class="card-title d-flex align-items-center">
                            <i class="ki-duotone ki-wallet text-primary fs-2x me-3">
                              <span class="path1"></span>
                              <span class="path2"></span>
                              <span class="path3"></span>
                            </i>
                            <div>
                              <h3 class="text-primary mb-1">
                                {{ shiftAction }} Cash Drawer #{{ currentUserShift.DrawerID }}
                              </h3>
                              <span class="text-muted fs-7 fw-semibold"
                                >{{ currentUserShift.ShiftType }} Shift</span
                              >
                              <span
                                v-if="shiftAction === 'Created'"
                                class="badge badge-success ms-2"
                                >Auto-Created</span
                              >
                              <span
                                v-else-if="shiftAction === 'Resumed'"
                                class="badge badge-info ms-2"
                                >Resumed</span
                              >
                              <span
                                v-else-if="shiftAction === 'Taken Over'"
                                class="badge badge-warning ms-2"
                                >Taken Over</span
                              >
                            </div>
                          </div>
                        </div>
                        <div class="card-body">
                          <div class="row g-4">
                            <div class="col-md-3">
                              <span class="text-muted fs-7 fw-semibold d-block">Shift Date</span>
                              <span class="fs-6 fw-bold text-gray-800">{{
                                currentUserShift.ShiftDate
                              }}</span>
                            </div>
                            <div class="col-md-3">
                              <span class="text-muted fs-7 fw-semibold d-block">Opened At</span>
                              <span class="fs-6 fw-bold text-gray-800">{{
                                formatDateTime(currentUserShift.OpenedAt)
                              }}</span>
                            </div>
                            <div class="col-md-3">
                              <span class="text-muted fs-7 fw-semibold d-block"
                                >Opening Balance</span
                              >
                              <span class="fs-6 fw-bold text-success"
                                >UGX {{ formatCurrency(currentUserShift.OpeningBalance) }}</span
                              >
                            </div>
                            <div class="col-md-3">
                              <span class="text-muted fs-7 fw-semibold d-block">Expected Cash</span>
                              <span class="fs-6 fw-bold text-info"
                                >UGX {{ formatCurrency(currentUserShift.ExpectedCash) }}</span
                              >
                            </div>
                          </div>

                          <!-- Shift Duration -->
                          <div class="mt-6 p-4 bg-light-info rounded">
                            <div class="d-flex align-items-center">
                              <i class="ki-duotone ki-time text-info fs-2x me-3">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                              <div>
                                <h5 class="text-info mb-1">Shift Duration</h5>
                                <p class="text-muted fs-7 mb-0">
                                  {{ calculateShiftDuration(currentUserShift.OpenedAt) }}
                                </p>
                              </div>
                            </div>
                          </div>

                          <!-- Station Information -->
                          <div class="mt-6 p-4 bg-light-success rounded">
                            <div class="d-flex align-items-center">
                              <i class="ki-duotone ki-home text-success fs-2x me-3">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                              <div>
                                <h5 class="text-success mb-1">Assigned Station</h5>
                                <p class="text-muted fs-7 mb-0">
                                  {{
                                    assignedStation?.Name || `Station ${assignedStation?.StationID}`
                                  }}
                                  <span
                                    v-if="assignedStation?.IsPrimary === '1'"
                                    class="badge badge-primary ms-2"
                                    >Primary</span
                                  >
                                </p>
                              </div>
                            </div>
                          </div>

                          <!-- Read-Only Notice -->
                          <div
                            v-if="currentUserShift?.readOnly"
                            class="mt-6 p-4 bg-light-warning rounded border border-warning"
                          >
                            <div class="d-flex align-items-center">
                              <i class="ki-duotone ki-eye text-warning fs-2x me-3">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                              <div>
                                <h5 class="text-warning mb-1">Read-Only Access</h5>
                                <p class="text-muted fs-7 mb-0">
                                  You have view-only access to this shift. Contact the shift owner
                                  to take over.
                                </p>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Shift Performance Chart -->
                    <div class="col-12">
                      <div class="card card-flush border border-gray-300">
                        <div class="card-header">
                          <h3 class="card-title">Shift Performance Dashboard</h3>
                        </div>
                        <div class="card-body">
                          <canvas ref="shiftStatsChart" width="400" height="200"></canvas>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Error State -->
                  <div v-else-if="!loading && !currentUserShift" class="col-12">
                    <div class="text-center py-10">
                      <i class="ki-duotone ki-cross-circle fs-3x text-danger mb-4">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <h3 class="text-danger">Shift Initialization Failed</h3>
                      <p class="text-muted fs-6">
                        {{
                          initializationError ||
                          'Unable to initialize shift. Please contact system administrator.'
                        }}
                      </p>
                      <button @click="retryInitialization" class="btn btn-primary">
                        <i class="ki-duotone ki-arrows-circle fs-6 me-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        Retry Initialization
                      </button>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Step 2: Variance Detection -->
              <div v-if="currentStep === 2" class="current">
                <div class="w-100">
                  <div class="pb-10 pb-lg-12">
                    <h2 class="fw-bold text-gray-900 fs-2x mb-4">Variance Detection</h2>
                    <p class="text-muted fs-6 fw-semibold">
                      Calculate and analyze cash discrepancies for the selected drawer.
                    </p>
                  </div>

                  <!-- Selected Drawer Info -->
                  <div class="card bg-light-primary border border-primary mb-8">
                    <div class="card-body">
                      <h4 class="card-title text-primary">
                        Current Cash Drawer #{{ currentUserShift?.DrawerID }}
                      </h4>
                      <div class="row g-4">
                        <div class="col-md-3">
                          <span class="text-muted fs-7 fw-semibold d-block">Shift Type</span>
                          <span class="fs-6 fw-bold text-gray-800">{{
                            currentUserShift?.ShiftType
                          }}</span>
                        </div>
                        <div class="col-md-3">
                          <span class="text-muted fs-7 fw-semibold d-block">Attendant</span>
                          <span class="fs-6 fw-bold text-gray-800">{{ currentUser?.name }}</span>
                        </div>
                        <div class="col-md-3">
                          <span class="text-muted fs-7 fw-semibold d-block">Opening Balance</span>
                          <span class="fs-6 fw-bold text-success"
                            >UGX {{ formatCurrency(currentUserShift?.OpeningBalance) }}</span
                          >
                        </div>
                        <div class="col-md-3">
                          <span class="text-muted fs-7 fw-semibold d-block">Expected Cash</span>
                          <span class="fs-6 fw-bold text-info"
                            >UGX {{ formatCurrency(currentUserShift?.ExpectedCash) }}</span
                          >
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Cash Count Form -->
                  <div class="card card-flush">
                    <div class="card-header">
                      <h3 class="card-title">Physical Cash Count</h3>
                    </div>
                    <div class="card-body">
                      <div class="row g-6">
                        <div class="col-md-6">
                          <label class="required form-label">Actual Cash Amount (UGX)</label>
                          <input
                            v-model="varianceForm.actualCash"
                            type="number"
                            step="0.01"
                            min="0"
                            class="form-control form-control-lg"
                            :class="{ 'is-invalid': errors.actualCash }"
                            :disabled="currentUserShift?.readOnly"
                            placeholder="Enter physical cash count"
                          />
                          <div v-if="errors.actualCash" class="invalid-feedback">
                            {{ errors.actualCash }}
                          </div>
                          <div v-if="currentUserShift?.readOnly" class="form-text text-warning">
                            <i class="ki-duotone ki-information-5 fs-6 me-1">
                              <span class="path1"></span>
                              <span class="path2"></span>
                              <span class="path3"></span>
                            </i>
                            Read-only mode - input disabled
                          </div>
                        </div>
                        <div class="col-md-6">
                          <label class="form-label">Additional Cash Payouts</label>
                          <input
                            v-model="varianceForm.cashPayouts"
                            type="number"
                            step="0.01"
                            min="0"
                            class="form-control form-control-lg"
                            :disabled="currentUserShift?.readOnly"
                            placeholder="Enter any cash payouts"
                          />
                        </div>
                      </div>

                      <!-- Variance Calculation -->
                      <div class="mt-8 p-6 bg-light-info rounded border border-info">
                        <h4 class="text-info mb-4">Variance Calculation</h4>
                        <div class="row g-4">
                          <div class="col-md-3">
                            <span class="text-muted fs-7 fw-semibold d-block">Expected Cash</span>
                            <span class="fs-5 fw-bold text-gray-800"
                              >UGX {{ formatCurrency(currentUserShift?.ExpectedCash || 0) }}</span
                            >
                          </div>
                          <div class="col-md-3">
                            <span class="text-muted fs-7 fw-semibold d-block">Actual Cash</span>
                            <span class="fs-5 fw-bold text-primary"
                              >UGX {{ formatCurrency(varianceForm.actualCash || 0) }}</span
                            >
                          </div>
                          <div class="col-md-3">
                            <span class="text-muted fs-7 fw-semibold d-block">Cash Payouts</span>
                            <span class="fs-5 fw-bold text-warning"
                              >UGX {{ formatCurrency(varianceForm.cashPayouts || 0) }}</span
                            >
                          </div>
                          <div class="col-md-3">
                            <span class="text-muted fs-7 fw-semibold d-block">Net Variance</span>
                            <span
                              class="fs-4 fw-bold"
                              :class="getVarianceClass(calculatedVariance)"
                            >
                              UGX {{ formatCurrency(Math.abs(calculatedVariance)) }}
                              <span v-if="calculatedVariance !== 0" class="fs-6">
                                ({{ calculatedVariance > 0 ? 'Over' : 'Short' }})
                              </span>
                            </span>
                          </div>
                        </div>

                        <!-- Fraud Risk Assessment -->
                        <div
                          v-if="Math.abs(calculatedVariance) > 0"
                          class="mt-6 p-4 rounded"
                          :class="getFraudRiskClass(Math.abs(calculatedVariance))"
                        >
                          <div class="d-flex align-items-center">
                            <i
                              class="ki-duotone ki-security-user fs-2x me-3"
                              :class="getFraudRiskIconClass(Math.abs(calculatedVariance))"
                            >
                              <span class="path1"></span>
                              <span class="path2"></span>
                            </i>
                            <div>
                              <h5 class="mb-1">
                                {{ getFraudRiskLevel(Math.abs(calculatedVariance)) }} Risk Detection
                              </h5>
                              <p class="text-muted fs-7 mb-0">
                                {{ getFraudRiskMessage(Math.abs(calculatedVariance)) }}
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>

                      <!-- Variance Chart -->
                      <div class="mt-8">
                        <div class="card card-flush border border-gray-300">
                          <div class="card-header">
                            <h3 class="card-title">Variance Analysis Chart</h3>
                          </div>
                          <div class="card-body">
                            <canvas ref="varianceChart" width="400" height="200"></canvas>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Step 3: Discrepancy Analysis -->
              <div v-if="currentStep === 3" class="current">
                <div class="w-100">
                  <div class="pb-10 pb-lg-12">
                    <h2 class="fw-bold text-gray-900 fs-2x mb-4">Discrepancy Analysis</h2>
                    <p class="text-muted fs-6 fw-semibold">
                      Document and categorize the identified variance.
                    </p>
                  </div>

                  <!-- Variance Summary -->
                  <div class="card mb-8" :class="getVarianceSummaryClass(calculatedVariance)">
                    <div class="card-body">
                      <div class="d-flex align-items-center">
                        <i
                          class="ki-duotone fs-3x me-4"
                          :class="getVarianceIcon(calculatedVariance)"
                        >
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                        </i>
                        <div class="flex-grow-1">
                          <h3 class="mb-1">
                            Variance Detected: UGX
                            {{ formatCurrency(Math.abs(calculatedVariance)) }}
                          </h3>
                          <p class="text-muted fs-6 mb-0">
                            {{
                              calculatedVariance > 0
                                ? 'Cash overage detected'
                                : calculatedVariance < 0
                                  ? 'Cash shortage detected'
                                  : 'No variance detected'
                            }}
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Discrepancy Documentation -->
                  <div class="card card-flush">
                    <div class="card-header">
                      <h3 class="card-title">Variance Documentation</h3>
                    </div>
                    <div class="card-body">
                      <div class="row g-6">
                        <div class="col-md-6">
                          <label class="required form-label">Variance Category</label>
                          <select
                            v-model="analysisForm.category"
                            class="form-select form-select-lg"
                            :class="{ 'is-invalid': errors.category }"
                            :disabled="currentUserShift?.readOnly"
                          >
                            <option value="">Select category...</option>
                            <option value="counting_error">Counting Error</option>
                            <option value="transaction_error">Transaction Error</option>
                            <option value="change_mistake">Change Mistake</option>
                            <option value="fraudulent_activity">Fraudulent Activity</option>
                            <option value="system_error">System Error</option>
                            <option value="unaccounted_sale">Unaccounted Sale</option>
                            <option value="other">Other</option>
                          </select>
                          <div v-if="errors.category" class="invalid-feedback">
                            {{ errors.category }}
                          </div>
                        </div>
                        <div class="col-md-6">
                          <label class="required form-label">Severity Level</label>
                          <select
                            v-model="analysisForm.severity"
                            class="form-select form-select-lg"
                            :class="{ 'is-invalid': errors.severity }"
                            :disabled="currentUserShift?.readOnly"
                          >
                            <option value="">Select severity...</option>
                            <option value="low">Low (Under UGX 50,000)</option>
                            <option value="medium">Medium (UGX 50,000 - 200,000)</option>
                            <option value="high">High (Over UGX 200,000)</option>
                          </select>
                          <div v-if="errors.severity" class="invalid-feedback">
                            {{ errors.severity }}
                          </div>
                        </div>
                      </div>

                      <div class="row g-6 mt-6">
                        <div class="col-12">
                          <label class="required form-label">Detailed Explanation</label>
                          <textarea
                            v-model="analysisForm.explanation"
                            class="form-control form-control-lg"
                            :class="{ 'is-invalid': errors.explanation }"
                            :disabled="currentUserShift?.readOnly"
                            rows="4"
                            placeholder="Provide a detailed explanation of the variance..."
                          ></textarea>
                          <div v-if="errors.explanation" class="invalid-feedback">
                            {{ errors.explanation }}
                          </div>
                        </div>
                      </div>

                      <div class="row g-6 mt-6">
                        <div class="col-md-6">
                          <label class="form-label">Contributing Factors</label>
                          <div class="d-flex flex-wrap gap-2">
                            <label
                              v-for="factor in contributingFactors"
                              :key="factor"
                              class="form-check form-check-custom form-check-success"
                            >
                              <input
                                v-model="analysisForm.factors"
                                :value="factor"
                                type="checkbox"
                                class="form-check-input"
                                :disabled="currentUserShift?.readOnly"
                              />
                              <span class="form-check-label fs-7">{{ factor }}</span>
                            </label>
                          </div>
                        </div>
                        <div class="col-md-6">
                          <label class="form-label">Potential Solutions</label>
                          <div class="d-flex flex-wrap gap-2">
                            <label
                              v-for="solution in potentialSolutions"
                              :key="solution"
                              class="form-check form-check-custom form-check-primary"
                            >
                              <input
                                v-model="analysisForm.solutions"
                                :value="solution"
                                type="checkbox"
                                class="form-check-input"
                                :disabled="currentUserShift?.readOnly"
                              />
                              <span class="form-check-label fs-7">{{ solution }}</span>
                            </label>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Step 4: Resolution Actions -->
              <div v-if="currentStep === 4" class="current">
                <div class="w-100">
                  <div class="pb-10 pb-lg-12">
                    <h2 class="fw-bold text-gray-900 fs-2x mb-4">Resolution Actions</h2>
                    <p class="text-muted fs-6 fw-semibold">
                      Apply corrections and document resolution actions.
                    </p>
                  </div>

                  <!-- Action Selection -->
                  <div class="card card-flush">
                    <div class="card-header">
                      <h3 class="card-title">Resolution Method</h3>
                    </div>
                    <div class="card-body">
                      <div class="row g-6">
                        <div class="col-12">
                          <label class="required form-label">Primary Action</label>
                          <select
                            v-model="resolutionForm.action"
                            class="form-select form-select-lg"
                            :class="{ 'is-invalid': errors.action }"
                            :disabled="currentUserShift?.readOnly"
                          >
                            <option value="">Select resolution action...</option>
                            <option value="adjust_drawer">Adjust Drawer Balance</option>
                            <option value="create_variance_entry">Create Variance Entry</option>
                            <option value="investigate_further">Mark for Investigation</option>
                            <option value="transfer_shortage">Transfer Shortage to Loss</option>
                            <option value="recount_cash">Initiate Recount</option>
                          </select>
                          <div v-if="errors.action" class="invalid-feedback">
                            {{ errors.action }}
                          </div>
                        </div>
                      </div>

                      <div class="row g-6 mt-6">
                        <div class="col-md-6">
                          <label class="form-label">Adjustment Amount (UGX)</label>
                          <input
                            v-model="resolutionForm.adjustmentAmount"
                            type="number"
                            step="0.01"
                            class="form-control form-control-lg"
                            :disabled="currentUserShift?.readOnly"
                            placeholder="Enter adjustment amount"
                          />
                        </div>
                        <div class="col-md-6">
                          <label class="form-label">Reference Number</label>
                          <input
                            v-model="resolutionForm.referenceNumber"
                            type="text"
                            class="form-control form-control-lg"
                            :disabled="currentUserShift?.readOnly"
                            placeholder="Enter reference number"
                          />
                        </div>
                      </div>

                      <div class="row g-6 mt-6">
                        <div class="col-12">
                          <label class="required form-label">Resolution Notes</label>
                          <textarea
                            v-model="resolutionForm.notes"
                            class="form-control form-control-lg"
                            :class="{ 'is-invalid': errors.resolutionNotes }"
                            :disabled="currentUserShift?.readOnly"
                            rows="4"
                            placeholder="Document the resolution actions taken..."
                          ></textarea>
                          <div v-if="errors.resolutionNotes" class="invalid-feedback">
                            {{ errors.resolutionNotes }}
                          </div>
                        </div>
                      </div>

                      <!-- Authorization -->
                      <div
                        v-if="!currentUserShift?.readOnly"
                        class="mt-8 p-6 bg-light-warning rounded border border-warning"
                      >
                        <h4 class="text-warning mb-4">Authorization Required</h4>
                        <div class="row g-4">
                          <div class="col-md-6">
                            <label class="form-label">Supervisor Password</label>
                            <input
                              v-model="resolutionForm.supervisorPassword"
                              type="password"
                              class="form-control form-control-lg"
                              placeholder="Enter supervisor password"
                            />
                          </div>
                          <div class="col-md-6">
                            <label class="form-label">Authorized By</label>
                            <input
                              v-model="resolutionForm.authorizedBy"
                              type="text"
                              class="form-control form-control-lg"
                              placeholder="Supervisor name"
                            />
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Step 5: Handover Completion -->
              <div v-if="currentStep === 5" class="current">
                <div class="w-100">
                  <div class="pb-10 pb-lg-12">
                    <h2 class="fw-bold text-gray-900 fs-2x mb-4">Handover Completion</h2>
                    <p class="text-muted fs-6 fw-semibold">
                      Finalize the shift handover and close the cash drawer.
                    </p>
                  </div>

                  <!-- Summary Review -->
                  <div class="card card-flush mb-8">
                    <div class="card-header">
                      <h3 class="card-title">Resolution Summary</h3>
                    </div>
                    <div class="card-body">
                      <div class="row g-6">
                        <div class="col-md-4">
                          <div class="card bg-light-info border border-info">
                            <div class="card-body text-center">
                              <i class="ki-duotone ki-wallet text-info fs-3x mb-3">
                                <span class="path1"></span>
                                <span class="path2"></span>
                                <span class="path3"></span>
                              </i>
                              <h4 class="text-info">Original Variance</h4>
                              <p class="fs-4 fw-bold text-gray-800 mb-0">
                                UGX {{ formatCurrency(Math.abs(calculatedVariance)) }}
                              </p>
                            </div>
                          </div>
                        </div>
                        <div class="col-md-4">
                          <div class="card bg-light-warning border border-warning">
                            <div class="card-body text-center">
                              <i class="ki-duotone ki-abstract-39 text-warning fs-3x mb-3">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                              <h4 class="text-warning">Resolution Action</h4>
                              <p class="fs-6 fw-bold text-gray-800 mb-0">
                                {{ resolutionForm.action || 'Not selected' }}
                              </p>
                            </div>
                          </div>
                        </div>
                        <div class="col-md-4">
                          <div class="card bg-light-success border border-success">
                            <div class="card-body text-center">
                              <i class="ki-duotone ki-check-circle text-success fs-3x mb-3">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                              <h4 class="text-success">Final Status</h4>
                              <p class="fs-6 fw-bold text-gray-800 mb-0">
                                {{ currentUserShift?.readOnly ? 'View Only' : 'Ready to Close' }}
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Final Confirmation -->
                  <div v-if="!currentUserShift?.readOnly" class="card card-flush">
                    <div class="card-header">
                      <h3 class="card-title">Final Confirmation</h3>
                    </div>
                    <div class="card-body">
                      <div class="row g-6">
                        <div class="col-12">
                          <div class="form-check form-check-custom form-check-success">
                            <input
                              v-model="handoverForm.confirmAccuracy"
                              type="checkbox"
                              class="form-check-input"
                              id="confirmAccuracy"
                            />
                            <label class="form-check-label fw-semibold" for="confirmAccuracy">
                              I confirm that all information provided is accurate and complete
                            </label>
                          </div>
                        </div>
                        <div class="col-12 mt-4">
                          <div class="form-check form-check-custom form-check-success">
                            <input
                              v-model="handoverForm.confirmResolution"
                              type="checkbox"
                              class="form-check-input"
                              id="confirmResolution"
                            />
                            <label class="form-check-label fw-semibold" for="confirmResolution">
                              I confirm that the variance has been properly resolved according to
                              company policy
                            </label>
                          </div>
                        </div>
                        <div class="col-12 mt-4">
                          <div class="form-check form-check-custom form-check-success">
                            <input
                              v-model="handoverForm.confirmHandover"
                              type="checkbox"
                              class="form-check-input"
                              id="confirmHandover"
                            />
                            <label class="form-check-label fw-semibold" for="confirmHandover">
                              I authorize the closure of this cash drawer and completion of shift
                              handover
                            </label>
                          </div>
                        </div>
                      </div>

                      <div class="row g-6 mt-8">
                        <div class="col-12">
                          <label class="form-label">Final Comments</label>
                          <textarea
                            v-model="handoverForm.finalComments"
                            class="form-control form-control-lg"
                            rows="3"
                            placeholder="Any final comments or observations..."
                          ></textarea>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Read-Only Final Summary -->
                  <div v-else class="card card-flush bg-light-warning">
                    <div class="card-body text-center">
                      <i class="ki-duotone ki-eye text-warning fs-3x mb-3">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <h4 class="text-warning">Read-Only Access</h4>
                      <p class="text-muted mb-0">
                        You are viewing this shift in read-only mode. Contact the shift owner to
                        take over and complete the handover process.
                      </p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Navigation Buttons -->
              <div class="d-flex flex-stack pt-10">
                <div class="me-2">
                  <button
                    v-if="currentStep > 1"
                    @click="previousStep"
                    type="button"
                    class="btn btn-lg btn-light-primary me-3"
                    :disabled="loading"
                  >
                    <i class="ki-duotone ki-arrow-left fs-4 me-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    Previous
                  </button>
                </div>
                <div>
                  <button
                    v-if="currentStep < 5"
                    @click="nextStep"
                    type="button"
                    class="btn btn-lg btn-primary"
                    :disabled="!canProceed || loading"
                  >
                    Next
                    <i class="ki-duotone ki-arrow-right fs-4 ms-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </button>
                  <button
                    v-else-if="!currentUserShift?.readOnly"
                    @click="completeHandover"
                    type="button"
                    class="btn btn-lg btn-success"
                    :disabled="!canComplete || loading"
                    data-kt-indicator="off"
                  >
                    <span class="indicator-label">
                      <i class="ki-duotone ki-check fs-4 me-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      Complete Handover
                    </span>
                    <span class="indicator-progress">
                      Please wait...
                      <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
                    </span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted, nextTick } from 'vue'
import Swal from 'sweetalert2'

// ============================================================================
// API CONFIGURATION & AUTHENTICATION
// ============================================================================
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// CRITICAL: Enhanced Authentication Data Retrieval
const getAuthData = () => {
  try {
    const authData = localStorage.getItem('kigrama_user_data')
    const parsed = authData ? JSON.parse(authData) : null

    // SECURITY: Validate auth data structure
    if (!parsed?.user?.id) {
      console.error('❌ Invalid auth data structure detected - missing user')
      return null
    }

    return parsed
  } catch (error) {
    console.error('❌ Error parsing auth data:', error)
    return null
  }
}

const getAuthToken = () => {
  const token = localStorage.getItem('kigrama_auth_token')
  if (!token) {
    console.error('❌ No authentication token found')
  }
  return token || ''
}

// Authentication data
const authData = ref(getAuthData())
const currentUser = computed(() => authData.value?.user)

// ============================================================================
// COMPONENT STATE & REACTIVE DATA
// ============================================================================
const loading = ref(false)
const currentStep = ref(1)
const systemStatus = ref({ online: true })
const shiftInitialized = ref(false)
const stationLoading = ref(false)
const initializationError = ref('')
const shiftAction = ref('') // 'Created', 'Resumed', 'Taken Over'

// CRITICAL: Single Station Assignment (No Selection)
const assignedStation = ref(null)
const currentUserShift = ref(null)

// Form states with proper initialization
const varianceForm = reactive({
  actualCash: '',
  cashPayouts: '0',
})

const analysisForm = reactive({
  category: '',
  severity: '',
  explanation: '',
  factors: [],
  solutions: [],
})

const resolutionForm = reactive({
  action: '',
  adjustmentAmount: '',
  referenceNumber: '',
  notes: '',
  supervisorPassword: '',
  authorizedBy: '',
})

const handoverForm = reactive({
  confirmAccuracy: false,
  confirmResolution: false,
  confirmHandover: false,
  finalComments: '',
})

// Error handling
const errors = reactive({
  actualCash: '',
  category: '',
  severity: '',
  explanation: '',
  action: '',
  resolutionNotes: '',
})

// Constants
const contributingFactors = [
  'Busy shift period',
  'New attendant',
  'System glitch',
  'Customer disputes',
  'Change shortage',
  'Training issues',
]

const potentialSolutions = [
  'Additional training',
  'System upgrade',
  'Process review',
  'Supervision increase',
  'Equipment check',
  'Policy clarification',
]

// ============================================================================
// COMPUTED PROPERTIES - DATABASE COMPLIANT
// ============================================================================
const calculatedVariance = computed(() => {
  try {
    // CRITICAL: All CashDrawers monetary fields are TEXT in database
    const expected = parseFloat(currentUserShift.value?.ExpectedCash || '0')
    const actual = parseFloat(varianceForm.actualCash || '0')
    const payouts = parseFloat(varianceForm.cashPayouts || '0')

    // VALIDATION: Ensure all values are valid numbers
    if (isNaN(expected) || isNaN(actual) || isNaN(payouts)) {
      console.warn('⚠️ Invalid numbers in variance calculation')
      return 0
    }

    // BUSINESS LOGIC: Variance = (Actual + Payouts) - Expected
    const result = actual + payouts - expected
    return isNaN(result) ? 0 : result
  } catch (error) {
    console.error('❌ Error calculating variance:', error)
    return 0
  }
})

const canProceed = computed(() => {
  try {
    // SECURITY: Read-only mode restrictions
    if (currentUserShift.value?.readOnly && currentStep.value > 1) {
      return false // Read-only users can only view step 1
    }

    switch (currentStep.value) {
      case 1:
        return !!(currentUserShift.value && shiftInitialized.value)
      case 2:
        return !!(
          varianceForm.actualCash &&
          varianceForm.actualCash !== '' &&
          currentUserShift.value
        )
      case 3:
        return !!(
          analysisForm.category &&
          analysisForm.severity &&
          analysisForm.explanation &&
          currentUserShift.value
        )
      case 4:
        return !!(resolutionForm.action && resolutionForm.notes && currentUserShift.value)
      case 5:
        return !!currentUserShift.value
      default:
        return false
    }
  } catch (error) {
    console.error('❌ Error in canProceed computed:', error)
    return false
  }
})

const canComplete = computed(() => {
  try {
    // SECURITY: Cannot complete in read-only mode
    if (currentUserShift.value?.readOnly) {
      return false
    }

    return !!(
      handoverForm.confirmAccuracy &&
      handoverForm.confirmResolution &&
      handoverForm.confirmHandover &&
      currentUserShift.value
    )
  } catch (error) {
    console.error('❌ Error in canComplete computed:', error)
    return false
  }
})

// ============================================================================
// DATABASE-COMPLIANT API HELPER FUNCTIONS
// ============================================================================

// CRITICAL: Enhanced API Helper with Strict Security and Error Handling
const apiCall = async (method, endpoint, data = null) => {
  try {
    const token = getAuthToken()
    if (!token) {
      throw new Error('SECURITY_ERROR: No authentication token available')
    }

    // SECURITY: Validate current user context
    if (!currentUser.value?.id) {
      throw new Error('SECURITY_ERROR: No authenticated user context')
    }

    const config = {
      method,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
    }

    if (data && (method === 'POST' || method === 'PATCH')) {
      config.body = JSON.stringify(data)
    }

    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000)

    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...config,
      signal: controller.signal,
    })

    clearTimeout(timeoutId)

    if (!response.ok) {
      let errorMessage = `HTTP ${response.status}: ${response.statusText}`
      try {
        const errorData = await response.json()
        errorMessage = errorData.message || errorData.error || errorMessage
      } catch (parseError) {
        console.warn('⚠️ Could not parse error response:', parseError)
      }
      throw new Error(errorMessage)
    }

    const result = await response.json()
    return result
  } catch (error) {
    if (error.name === 'AbortError') {
      throw new Error('REQUEST_TIMEOUT: Please check your connection')
    }
    if (error.name === 'TypeError' && error.message.includes('fetch')) {
      throw new Error('NETWORK_ERROR: Please check your connection')
    }
    throw error
  }
}

// CRITICAL: Enhanced Security and Audit Logging
const logSecurityEvent = async (level, details, data = null) => {
  try {
    // VALIDATION: Ensure all required security context exists
    if (!assignedStation.value?.StationID || !currentUser.value?.id) {
      console.warn('⚠️ Cannot log security event: missing station or user info')
      return false
    }

    const logEntry = {
      StationID: assignedStation.value.StationID,
      UserID: currentUser.value.id,
      Action: `SECURITY_EVENT: ${level}`,
      TableName: 'CashDrawers',
      RecordID: currentUserShift.value?.DrawerID || null,
      Changes: JSON.stringify({
        level,
        details,
        data,
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
        sessionId: `${currentUser.value.id}-${Date.now()}`,
      }),
      IPAddress: 'CLIENT_IP',
    }

    await apiCall('POST', '/AuditLogs', logEntry)
    console.log(`🔐 Security event logged: ${level}`)
    return true
  } catch (error) {
    console.error('❌ Failed to log security event:', error)
    return false
  }
}

const logFraudDetection = async (riskScore, severity, fraudType, description) => {
  try {
    // VALIDATION: Ensure security context
    if (!assignedStation.value?.StationID || !currentUser.value?.id) {
      console.warn('⚠️ Cannot log fraud detection: missing station or user info')
      return false
    }

    const fraudEntry = {
      TransactionID: null,
      StationID: assignedStation.value.StationID,
      UserID: currentUser.value.id,
      RiskScore: riskScore.toString(),
      Severity: severity,
      FraudType: fraudType,
      Description: description,
      Status: 'Flagged',
      DetectedAt: new Date().toISOString(),
    }

    await apiCall('POST', '/FraudDetectionLogs', fraudEntry)
    console.log(`🚨 Fraud detection logged: ${fraudType} (Risk: ${riskScore})`)
    return true
  } catch (error) {
    console.error('❌ Failed to log fraud detection:', error)
    return false
  }
}

// ============================================================================
// CRITICAL: SINGLE STATION ASSIGNMENT LOGIC - NO SELECTION
// ============================================================================

// CRITICAL: Load FIRST Active Station Assignment Only (No Selection)
const loadSingleUserStation = async () => {
  try {
    stationLoading.value = true

    if (!currentUser.value?.id) {
      throw new Error('AUTHENTICATION_ERROR: No user ID available')
    }

    const userId = currentUser.value.id
    console.log(`🔍 Loading FIRST station assignment for User ID: ${userId}`)

    // STEP 1: Get user's station assignments from UserStations table
    const userStationResponse = await apiCall('GET', `/UserStations?UserID=${userId}&Status=Active`)
    const userStationAssignments = userStationResponse.records || []

    console.log('📋 User Station Assignments:', userStationAssignments)

    if (userStationAssignments.length === 0) {
      throw new Error(
        `ACCESS_DENIED: User ${userId} has no active station assignments. Contact administrator to assign stations.`,
      )
    }

    // CRITICAL: Take ONLY the FIRST station assignment (as per requirements)
    const firstAssignment = userStationAssignments[0]
    console.log(`🎯 Using FIRST station assignment:`, firstAssignment)

    // STEP 2: Load detailed station information for the first assignment only
    try {
      const stationResponse = await apiCall('GET', `/Stations/${firstAssignment.StationID}`)

      // Handle different TrailBase response formats
      let station = stationResponse
      if (stationResponse.records && stationResponse.records.length > 0) {
        station = stationResponse.records[0]
      }

      assignedStation.value = {
        ...station,
        ...firstAssignment, // Include assignment details (IsPrimary, AssignedDate, etc.)
        StationID: firstAssignment.StationID, // Ensure StationID is preserved
        UserAssignment: firstAssignment, // Full assignment record for reference
      }
    } catch (stationError) {
      console.error(`❌ Error loading station ${firstAssignment.StationID}:`, stationError)
      assignedStation.value = {
        StationID: firstAssignment.StationID,
        Name: `Station ${firstAssignment.StationID}`,
        Status: 'Error Loading',
        UserAssignment: firstAssignment,
        LoadError: stationError.message,
      }
    }

    console.log('🏢 Assigned Station:', assignedStation.value)

    // STEP 3: Log station assignment
    await logSecurityEvent(
      'SINGLE_STATION_ASSIGNED',
      'User assigned to single station (first from UserStations)',
      {
        userId,
        stationId: assignedStation.value.StationID,
        stationName: assignedStation.value.Name,
        isPrimary: firstAssignment.IsPrimary,
        totalAssignments: userStationAssignments.length,
        assignmentDetails: firstAssignment,
      },
    )

    // STEP 4: Show notification if user had multiple stations (now using only first)
    if (userStationAssignments.length > 1) {
      await Swal.fire({
        title: 'Single Station Mode',
        html: `
          <div class="text-start">
            <p class="mb-3"><strong>You have ${userStationAssignments.length} station assignments.</strong></p>
            <p>Using: <strong>${assignedStation.value.Name || `Station ${assignedStation.value.StationID}`}</strong></p>
            <p class="text-muted mt-3">This system operates in single-station mode. Contact administrator if you need to work at a different station.</p>
          </div>
        `,
        icon: 'info',
        confirmButtonText: 'Continue',
        confirmButtonColor: '#3699ff',
      })
    }

    return assignedStation.value
  } catch (error) {
    console.error('❌ Error loading single user station:', error)

    await Swal.fire({
      title: 'Station Assignment Error',
      html: `
        <div class="text-start">
          <p class="mb-3"><strong>Unable to load your station assignment:</strong></p>
          <p class="text-danger">${error.message}</p>
          <p class="mt-3"><strong>Required Actions:</strong></p>
          <ul class="text-muted">
            <li>Contact your administrator to assign you to a station</li>
            <li>Verify your user permissions in the system</li>
            <li>Check that you have active station assignments</li>
          </ul>
        </div>
      `,
      icon: 'error',
      confirmButtonText: 'Contact Administrator',
      confirmButtonColor: '#f1416c',
      allowOutsideClick: false,
      allowEscapeKey: false,
    })

    throw error
  } finally {
    stationLoading.value = false
  }
}

// ============================================================================
// CRITICAL: DATABASE-COMPLIANT SHIFT DETECTION & MANAGEMENT
// ============================================================================

// CRITICAL: Constraint-Safe Shift Detection with 100% Database Compliance
const detectAndInitializeShift = async () => {
  try {
    loading.value = true
    initializationError.value = ''

    // SECURITY: Validate authentication context
    if (!currentUser.value?.id) {
      throw new Error('SECURITY_ERROR: No authenticated user found')
    }

    if (!assignedStation.value?.StationID) {
      throw new Error('SECURITY_ERROR: No station assigned. Please contact administrator.')
    }

    const today = new Date().toISOString().split('T')[0] // YYYY-MM-DD format
    const currentShift = getCurrentShiftType()
    const userId = parseInt(currentUser.value.id)
    const stationId = parseInt(assignedStation.value.StationID)

    console.log(`🔍 CONSTRAINT-SAFE shift detection for User ${userId} at Station ${stationId}`)
    console.log(`📅 Date: ${today}, Shift: ${currentShift}`)

    // SECURITY: Log shift access attempt
    await logSecurityEvent('SHIFT_ACCESS_ATTEMPT', 'User attempting to access shift management', {
      userId,
      stationId,
      stationName: assignedStation.value.Name,
      shiftType: currentShift,
      date: today,
    })

    // DATABASE CONSTRAINT: Check unique constraint (StationID, ShiftDate, ShiftType) BEFORE any operations
    const existingShiftResponse = await apiCall(
      'GET',
      `/CashDrawers?StationID=${stationId}&ShiftDate=${today}&ShiftType=${currentShift}`,
    )

    const existingShifts = existingShiftResponse.records || []

    // SECURITY: Additional validation - ensure returned shifts match our query
    const validShifts = existingShifts.filter(
      (shift) =>
        parseInt(shift.StationID) === stationId &&
        shift.ShiftDate === today &&
        shift.ShiftType === currentShift,
    )

    console.log(
      `🔍 Found ${validShifts.length} existing shifts for constraint (${stationId}, ${today}, ${currentShift})`,
    )

    if (validShifts.length > 0) {
      const existingShift = validShifts[0]
      console.log(`📋 Processing existing shift:`, existingShift)

      // BUSINESS LOGIC: Handle existing shift based on status and ownership
      if (existingShift.Status === 'Open') {
        if (parseInt(existingShift.AttendantID) === userId) {
          // User's own open shift - resume normally
          currentUserShift.value = existingShift
          shiftInitialized.value = true
          shiftAction.value = 'Resumed'

          await logSecurityEvent('SHIFT_RESUMED', 'User resuming their own active shift', {
            drawerId: existingShift.DrawerID,
            openedAt: existingShift.OpenedAt,
            stationName: assignedStation.value.Name,
          })

          await Swal.fire({
            title: 'Active Shift Resumed',
            text: `Resuming your ${currentShift} shift (Drawer #${existingShift.DrawerID}) at ${assignedStation.value.Name}`,
            icon: 'info',
            toast: true,
            position: 'top-end',
            timer: 4000,
            showConfirmButton: false,
          })
        } else {
          // Different user's open shift - offer handover
          await handleShiftHandover(existingShift, userId)
        }
      } else if (existingShift.Status === 'Closed') {
        // CONSTRAINT VIOLATION: Closed shift exists but constraint prevents new shift creation
        throw new Error(
          `DATABASE_CONSTRAINT_VIOLATION: A ${currentShift} shift already exists for station ${stationId} on ${today} (Status: ${existingShift.Status}, DrawerID: ${existingShift.DrawerID}). The database unique constraint prevents creating another shift for this combination.`,
        )
      } else {
        // Unknown status - treat as constraint violation
        throw new Error(
          `DATABASE_CONSTRAINT_VIOLATION: A ${currentShift} shift with status '${existingShift.Status}' already exists for station ${stationId} on ${today} (DrawerID: ${existingShift.DrawerID}). The database unique constraint prevents creating another shift.`,
        )
      }
    } else {
      // No existing shift - safe to create new shift
      console.log(`✅ No constraint violations found, creating new ${currentShift} shift`)
      await createConstraintSafeShift(userId, stationId, today, currentShift)
    }
  } catch (error) {
    console.error('❌ Error in constraint-safe shift detection:', error)
    initializationError.value = error.message

    // ENHANCED ERROR HANDLING: Check for specific constraint violation patterns
    if (
      error.message.includes('DATABASE_CONSTRAINT_VIOLATION') ||
      error.message.includes('already exists') ||
      error.message.includes('UNIQUE constraint failed')
    ) {
      await Swal.fire({
        title: 'Shift Constraint Violation',
        html: `
          <div class="text-start">
            <p class="mb-3"><strong>Database Constraint Error:</strong></p>
            <p class="text-danger">${error.message}</p>
            <p class="mt-3"><strong>This means:</strong></p>
            <ul class="text-muted">
              <li>Another shift already exists for this station/date/time combination</li>
              <li>The database prevents duplicate shifts for the same constraint</li>
              <li>This is a protective measure to maintain data integrity</li>
            </ul>
            <p class="mt-3"><strong>Options:</strong></p>
            <ul class="text-muted">
              <li>Wait for the existing shift to be closed</li>
              <li>Contact the current shift owner for handover</li>
              <li>Contact your supervisor or administrator</li>
            </ul>
          </div>
        `,
        icon: 'error',
        confirmButtonText: 'OK',
        confirmButtonColor: '#f1416c',
      })
    } else {
      // Other errors - show standard error dialog
      await Swal.fire({
        title: 'Shift Initialization Error',
        text: error.message || 'Failed to initialize shift. Please contact system administrator.',
        icon: 'error',
        confirmButtonColor: '#f1416c',
      })
    }
  } finally {
    loading.value = false
  }
}

// CRITICAL: Constraint-Safe Shift Creation with 100% Database Compliance
const createConstraintSafeShift = async (userId, stationId, date, shiftType) => {
  try {
    console.log(
      `🔧 Creating constraint-safe shift: User ${userId}, Station ${stationId}, ${date}, ${shiftType}`,
    )

    // CRITICAL: Final constraint check immediately before creation (race condition protection)
    const finalCheck = await apiCall(
      'GET',
      `/CashDrawers?StationID=${stationId}&ShiftDate=${date}&ShiftType=${shiftType}`,
    )

    if (finalCheck.records && finalCheck.records.length > 0) {
      throw new Error(
        `DATABASE_CONSTRAINT_VIOLATION: A ${shiftType} shift was just created for station ${stationId} on ${date} by another process (race condition detected)`,
      )
    }

    // Calculate opening balance
    const openingBalance = await calculateOpeningBalance(stationId, date, shiftType)

    // CRITICAL: All monetary fields MUST be TEXT strings (per database schema)
    // DATABASE COMPLIANCE: Ensure all required NOT NULL fields are present
    const shiftData = {
      StationID: stationId, // INTEGER NOT NULL (FK)
      ShiftDate: date, // TEXT NOT NULL
      ShiftType: shiftType, // TEXT NOT NULL
      AttendantID: userId, // INTEGER NOT NULL (FK)
      OpeningBalance: openingBalance.toFixed(2), // TEXT NOT NULL DEFAULT '0.00'
      ClosingBalance: '0.00', // TEXT NOT NULL DEFAULT '0.00'
      ExpectedCash: openingBalance.toFixed(2), // TEXT NOT NULL DEFAULT '0.00'
      ActualCash: '0.00', // TEXT NOT NULL DEFAULT '0.00'
      Variance: '0.00', // TEXT NOT NULL DEFAULT '0.00'
      CashSales: '0.00', // TEXT NOT NULL DEFAULT '0.00'
      CashPayouts: '0.00', // TEXT NOT NULL DEFAULT '0.00'
      Status: 'Open', // TEXT DEFAULT 'Open'
      OpenedBy: userId, // INTEGER NOT NULL (FK)
      OpenedAt: new Date().toISOString(), // TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      Notes: `Automatically created ${shiftType} shift for ${currentUser.value?.name || 'User'} at ${formatDateTime(new Date().toISOString())}`, // TEXT NULL
    }

    // VALIDATION: Verify all required NOT NULL fields are present and valid
    const requiredFields = [
      'StationID',
      'ShiftDate',
      'ShiftType',
      'AttendantID',
      'OpeningBalance',
      'ClosingBalance',
      'ExpectedCash',
      'ActualCash',
      'Variance',
      'CashSales',
      'CashPayouts',
      'OpenedBy',
      'OpenedAt',
    ]
    const missingFields = requiredFields.filter(
      (field) =>
        shiftData[field] === null || shiftData[field] === undefined || shiftData[field] === '',
    )

    if (missingFields.length > 0) {
      throw new Error(
        `DATABASE_VALIDATION_ERROR: Missing required fields: ${missingFields.join(', ')}`,
      )
    }

    // FK VALIDATION: Ensure all foreign key references exist
    if (!Number.isInteger(stationId) || stationId <= 0) {
      throw new Error(`FK_CONSTRAINT_ERROR: Invalid StationID ${stationId}`)
    }
    if (!Number.isInteger(userId) || userId <= 0) {
      throw new Error(`FK_CONSTRAINT_ERROR: Invalid AttendantID/OpenedBy ${userId}`)
    }

    // SECURITY: Fraud prevention checks
    await performShiftFraudChecks(userId, stationId, date, shiftType)

    console.log(`📝 Creating shift with data:`, shiftData)

    // CREATE: Database operation with proper error handling
    const response = await apiCall('POST', '/CashDrawers', shiftData)

    if (!response) {
      throw new Error('DATABASE_ERROR: Failed to create shift - no response from server')
    }

    // TRAILBASE: Extract DrawerID from response (PRIMARY KEY)
    let drawerId = null
    if (response.DrawerID) {
      drawerId = response.DrawerID
    } else if (response.records && response.records.length > 0) {
      drawerId = response.records[0].DrawerID
    } else if (response.id) {
      drawerId = response.id
    }

    if (!drawerId) {
      console.error('❌ Unexpected response format:', response)
      throw new Error('DATABASE_ERROR: Failed to create shift - invalid response format')
    }

    // SUCCESS: Update local state
    currentUserShift.value = { ...shiftData, DrawerID: drawerId }
    shiftInitialized.value = true
    shiftAction.value = 'Created'

    // AUDIT: Log successful creation
    await logSecurityEvent(
      'CONSTRAINT_SAFE_SHIFT_CREATED',
      'Shift created with constraint safety checks',
      {
        drawerId: drawerId,
        openingBalance,
        shiftType,
        userId,
        stationId,
        constraintKey: `${stationId}-${date}-${shiftType}`,
      },
    )

    // SUCCESS NOTIFICATION
    await Swal.fire({
      title: 'Shift Successfully Created!',
      html: `
        <div class="text-start">
          <p class="mb-2"><strong>New Shift Details:</strong></p>
          <ul class="list-unstyled">
            <li>• Drawer ID: #${drawerId}</li>
            <li>• Shift Type: ${shiftType}</li>
            <li>• Station: ${assignedStation.value.Name}</li>
            <li>• Opening Balance: UGX ${formatCurrency(openingBalance)}</li>
            <li>• Opened: ${formatDateTime(new Date().toISOString())}</li>
          </ul>
        </div>
      `,
      icon: 'success',
      confirmButtonText: 'Continue',
      confirmButtonColor: '#1BC5BD',
    })
  } catch (error) {
    console.error('❌ Error creating constraint-safe shift:', error)

    // AUDIT: Log failure with detailed context
    await logSecurityEvent('SHIFT_CREATION_FAILED', 'Failed to create constraint-safe shift', {
      error: error.message,
      userId,
      stationId,
      shiftType,
      date,
      constraintKey: `${stationId}-${date}-${shiftType}`,
    })

    throw error // Re-throw to be handled by caller
  }
}

// CRITICAL: Enhanced Shift Handover with Security and Constraint Safety
const handleShiftHandover = async (existingShift, newUserId) => {
  try {
    // Get current attendant name for display
    const currentAttendantName = await getUserName(existingShift.AttendantID)

    const result = await Swal.fire({
      title: 'Shift Handover Required',
      html: `
        <div class="text-start">
          <p class="mb-3"><strong>An active ${existingShift.ShiftType} shift already exists:</strong></p>
          <ul class="list-unstyled">
            <li>• Drawer: #${existingShift.DrawerID}</li>
            <li>• Current Attendant: ${currentAttendantName}</li>
            <li>• Opened: ${formatDateTime(existingShift.OpenedAt)}</li>
            <li>• Opening Balance: UGX ${formatCurrency(existingShift.OpeningBalance)}</li>
          </ul>
          <p class="text-warning mt-3"><strong>Options:</strong></p>
          <p class="text-muted fs-7">You can take over this shift or view it in read-only mode.</p>
        </div>
      `,
      icon: 'question',
      showCancelButton: true,
      showDenyButton: true,
      confirmButtonText: 'Take Over Shift',
      denyButtonText: 'View Only (Read-Only)',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#1BC5BD',
      denyButtonColor: '#3699ff',
      cancelButtonColor: '#f1416c',
    })

    if (result.isConfirmed) {
      // Perform shift handover
      await performShiftHandover(existingShift, newUserId)
    } else if (result.isDenied) {
      // Read-only access
      currentUserShift.value = { ...existingShift, readOnly: true }
      shiftInitialized.value = true
      shiftAction.value = 'Viewing (Read-Only)'

      await Swal.fire({
        title: 'Read-Only Access',
        text: 'You have read-only access to this shift. Some functions are limited.',
        icon: 'info',
        toast: true,
        position: 'top-end',
        timer: 3000,
        showConfirmButton: false,
      })
    } else {
      // User cancelled - set error
      throw new Error('Shift access cancelled by user. Cannot proceed without active shift.')
    }
  } catch (error) {
    console.error('❌ Error handling shift handover:', error)
    throw error // Re-throw to be handled by detectAndInitializeShift
  }
}

// CRITICAL: Database-Compliant Shift Handover with FK Safety
const performShiftHandover = async (existingShift, newUserId) => {
  try {
    // AUDIT: Log handover attempt
    await logSecurityEvent(
      'SHIFT_HANDOVER_INITIATED',
      'User attempting to take over existing shift',
      {
        drawerId: existingShift.DrawerID,
        previousAttendant: existingShift.AttendantID,
        newAttendant: newUserId,
      },
    )

    // FK VALIDATION: Ensure newUserId exists in users table before update
    try {
      await apiCall('GET', `/users/${newUserId}`)
    } catch (userError) {
      throw new Error(`FK_CONSTRAINT_ERROR: User ID ${newUserId} does not exist in users table`)
    }

    // DATABASE: Update only specific fields (PATCH operation)
    const handoverData = {
      AttendantID: newUserId, // INTEGER NOT NULL (FK to users.id)
      Notes: `${existingShift.Notes || ''}\n\nShift handed over to User #${newUserId} at ${formatDateTime(new Date().toISOString())}`,
    }

    const response = await apiCall('PATCH', `/CashDrawers/${existingShift.DrawerID}`, handoverData)

    // TrailBase PATCH typically returns updated record
    let updatedShift = response
    if (response.records && response.records.length > 0) {
      updatedShift = response.records[0]
    }

    // Update local state
    currentUserShift.value = { ...existingShift, ...handoverData, ...updatedShift }
    shiftInitialized.value = true
    shiftAction.value = 'Taken Over'

    // AUDIT: Log successful handover
    await logSecurityEvent('SHIFT_HANDOVER_COMPLETED', 'Shift successfully handed over', {
      drawerId: existingShift.DrawerID,
      previousAttendant: existingShift.AttendantID,
      newAttendant: newUserId,
    })

    await Swal.fire({
      title: 'Shift Handover Complete!',
      text: `You have successfully taken over ${existingShift.ShiftType} shift (Drawer #${existingShift.DrawerID})`,
      icon: 'success',
      confirmButtonColor: '#1BC5BD',
    })
  } catch (error) {
    console.error('❌ Error performing shift handover:', error)
    await logSecurityEvent('SHIFT_HANDOVER_FAILED', 'Shift handover failed', {
      error: error.message,
      drawerId: existingShift.DrawerID,
    })
    throw error
  }
}

// ============================================================================
// HELPER FUNCTIONS - DATABASE COMPLIANT
// ============================================================================

const getCurrentShiftType = () => {
  const hour = new Date().getHours()
  if (hour >= 6 && hour < 14) return 'Morning'
  if (hour >= 14 && hour < 22) return 'Afternoon'
  return 'Night'
}

const calculateOpeningBalance = async (stationId, date, shiftType) => {
  try {
    let openingBalance = 100000 // Default UGX 100,000

    // Try to get the closing balance from the most recent closed shift
    const prevShiftResponse = await apiCall(
      'GET',
      `/CashDrawers?StationID=${stationId}&Status=Closed&limit=1&sort=-ClosedAt`,
    )

    const prevShifts = prevShiftResponse.records || []
    if (prevShifts.length > 0) {
      // CRITICAL: Parse TEXT field to number
      const prevClosingBalance = parseFloat(prevShifts[0].ClosingBalance || '0')
      if (prevClosingBalance > 0) {
        openingBalance = prevClosingBalance
      }
    }

    // FRAUD DETECTION: Check for unreasonable opening balance
    if (openingBalance > 1000000) {
      // Over 1M UGX
      await logFraudDetection(
        75,
        'high',
        'Suspicious Opening Balance',
        `Unusually high opening balance: UGX ${formatCurrency(openingBalance)}`,
      )

      openingBalance = 500000 // Cap at reasonable amount
    }

    return openingBalance
  } catch (error) {
    console.error('❌ Error calculating opening balance:', error)
    return 100000 // Fallback default
  }
}

const performShiftFraudChecks = async (userId, stationId, date, shiftType) => {
  try {
    // Check for rapid successive shift creations
    const recentShiftsResponse = await apiCall(
      'GET',
      `/CashDrawers?AttendantID=${userId}&limit=10&sort=-OpenedAt`,
    )

    const recentShifts = recentShiftsResponse.records || []
    const shiftsToday = recentShifts.filter((s) => s.ShiftDate === date)

    if (shiftsToday.length >= 2) {
      await logFraudDetection(
        80,
        'high',
        'Excessive Shift Creation',
        `User attempting to create ${shiftsToday.length + 1} shifts in one day`,
      )
    }

    // Check for off-hours access
    const hour = new Date().getHours()
    if (
      (shiftType === 'Morning' && (hour < 5 || hour > 15)) ||
      (shiftType === 'Afternoon' && (hour < 13 || hour > 23)) ||
      (shiftType === 'Night' && hour < 21 && hour > 7)
    ) {
      await logFraudDetection(
        60,
        'medium',
        'Off-Hours Shift Creation',
        `${shiftType} shift created at unusual time: ${hour}:00`,
      )
    }
  } catch (error) {
    console.error('❌ Error in fraud checks:', error)
  }
}

const getUserName = async (userId) => {
  try {
    const response = await apiCall('GET', `/users/${userId}`)

    let user = response
    if (response.records && response.records.length > 0) {
      user = response.records[0]
    }

    return user?.name || user?.email || `User #${userId}`
  } catch (error) {
    console.error('❌ Error getting user name:', error)
    return `User #${userId}`
  }
}

// CRITICAL: Database-Compliant Shift Closure
const closeCurrentShift = async () => {
  if (!currentUserShift.value) {
    await Swal.fire({
      title: 'No Active Shift',
      text: 'There is no active shift to close',
      icon: 'warning',
      confirmButtonColor: '#3699ff',
    })
    return
  }

  // SECURITY: Prevent read-only users from closing shifts
  if (currentUserShift.value.readOnly) {
    await Swal.fire({
      title: 'Access Denied',
      text: 'You cannot close a shift in read-only mode',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  const result = await Swal.fire({
    title: 'Close Current Shift?',
    html: `
      <div class="text-start">
        <p><strong>Shift Details:</strong></p>
        <ul class="list-unstyled">
          <li>• Drawer: #${currentUserShift.value.DrawerID}</li>
          <li>• Type: ${currentUserShift.value.ShiftType}</li>
          <li>• Opened: ${formatDateTime(currentUserShift.value.OpenedAt)}</li>
          <li>• Duration: ${calculateShiftDuration(currentUserShift.value.OpenedAt)}</li>
        </ul>
        <p class="text-warning mt-3"><strong>Warning:</strong> This action cannot be undone.</p>
      </div>
    `,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, Close Shift',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#3699ff',
  })

  if (!result.isConfirmed) return

  try {
    loading.value = true

    // FK VALIDATION: Ensure ClosedBy user exists
    const closedByUserId = currentUser.value.id
    try {
      await apiCall('GET', `/users/${closedByUserId}`)
    } catch (userError) {
      throw new Error(`FK_CONSTRAINT_ERROR: ClosedBy User ID ${closedByUserId} does not exist`)
    }

    // CRITICAL: All monetary fields must be TEXT strings
    const finalData = {
      Status: 'Closed',
      ClosedBy: closedByUserId, // INTEGER NULL (FK to users.id)
      ClosedAt: new Date().toISOString(), // TEXT NULL
      ClosingBalance:
        currentUserShift.value.ActualCash ||
        currentUserShift.value.ExpectedCash ||
        currentUserShift.value.OpeningBalance,
      Notes: `${currentUserShift.value.Notes || ''}\n\nShift closed manually by ${currentUser.value.name} at ${formatDateTime(new Date().toISOString())}`,
    }

    await apiCall('PATCH', `/CashDrawers/${currentUserShift.value.DrawerID}`, finalData)

    // AUDIT: Log closure
    await logSecurityEvent('MANUAL_SHIFT_CLOSURE', 'Shift manually closed by user', {
      drawerId: currentUserShift.value.DrawerID,
      shiftType: currentUserShift.value.ShiftType,
      closingBalance: finalData.ClosingBalance,
    })

    await Swal.fire({
      title: 'Shift Closed Successfully!',
      text: `Drawer #${currentUserShift.value.DrawerID} has been closed`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    // Reset state and retry initialization
    resetForm()
    currentStep.value = 1
    await detectAndInitializeShift()
  } catch (error) {
    console.error('❌ Error closing shift:', error)
    await Swal.fire({
      title: 'Error Closing Shift!',
      text: error.message || 'Failed to close shift',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

const formatCurrency = (amount) => {
  const numAmount = parseFloat(amount || 0)
  return new Intl.NumberFormat('en-UG').format(numAmount)
}

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString('en-UG', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

const calculateShiftDuration = (openedAt) => {
  const now = new Date()
  const opened = new Date(openedAt)
  const diff = now - opened
  const hours = Math.floor(diff / (1000 * 60 * 60))
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  return `${hours}h ${minutes}m`
}

const getVarianceClass = (variance) => {
  if (variance === 0) return 'text-success'
  return variance > 0 ? 'text-warning' : 'text-danger'
}

const getVarianceSummaryClass = (variance) => {
  if (variance === 0) return 'bg-light-success border border-success'
  return variance > 0
    ? 'bg-light-warning border border-warning'
    : 'bg-light-danger border border-danger'
}

const getVarianceIcon = (variance) => {
  if (variance === 0) return 'ki-check-circle text-success'
  return variance > 0 ? 'ki-arrow-up text-warning' : 'ki-arrow-down text-danger'
}

const getFraudRiskLevel = (amount) => {
  if (amount < 50000) return 'Low'
  if (amount < 200000) return 'Medium'
  return 'High'
}

const getFraudRiskClass = (amount) => {
  if (amount < 50000) return 'bg-light-info border border-info'
  if (amount < 200000) return 'bg-light-warning border border-warning'
  return 'bg-light-danger border border-danger'
}

const getFraudRiskIconClass = (amount) => {
  if (amount < 50000) return 'text-info'
  if (amount < 200000) return 'text-warning'
  return 'text-danger'
}

const getFraudRiskMessage = (amount) => {
  if (amount < 50000) return 'Minor variance detected. Standard documentation required.'
  if (amount < 200000) return 'Moderate variance detected. Supervisor review recommended.'
  return 'Significant variance detected. Management escalation required.'
}

// ============================================================================
// CHART FUNCTIONS
// ============================================================================
const shiftStatsChart = ref(null)
const varianceChart = ref(null)
let shiftChart = null
let varianceChartInstance = null

const createShiftStatsChart = async () => {
  if (!shiftStatsChart.value || !currentUserShift.value) return

  try {
    if (shiftChart) {
      shiftChart.destroy()
      shiftChart = null
    }

    // Dynamic import with fallback
    let Chart
    try {
      Chart = (await import('https://cdnjs.cloudflare.com/ajax/libs/chart.js/3.9.1/chart.min.js'))
        .default
    } catch (importError) {
      console.warn('⚠️ Could not load Chart.js from CDN:', importError)
      shiftStatsChart.value.innerHTML = `
        <div class="d-flex flex-column align-items-center justify-content-center h-200px">
          <i class="ki-duotone ki-chart-simple text-muted fs-3x mb-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          <p class="text-muted text-center">Chart visualization unavailable</p>
        </div>
      `
      return
    }

    const ctx = shiftStatsChart.value.getContext('2d')

    // CRITICAL: Parse TEXT fields to numbers
    const openingBalance = parseFloat(currentUserShift.value.OpeningBalance || '0')
    const expectedCash = parseFloat(currentUserShift.value.ExpectedCash || '0')
    const cashSales = parseFloat(currentUserShift.value.CashSales || '0')
    const cashPayouts = parseFloat(currentUserShift.value.CashPayouts || '0')

    const chartData = [openingBalance, cashSales, cashPayouts, expectedCash]
    if (chartData.every((val) => val === 0)) {
      shiftStatsChart.value.innerHTML = `
        <div class="d-flex flex-column align-items-center justify-content-center h-200px">
          <i class="ki-duotone ki-information text-info fs-3x mb-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          <p class="text-muted text-center">No financial data available yet</p>
        </div>
      `
      return
    }

    shiftChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Opening Balance', 'Cash Sales', 'Cash Payouts', 'Expected Final'],
        datasets: [
          {
            data: chartData,
            backgroundColor: ['#3699FF', '#1BC5BD', '#FFA800', '#8950FC'],
            borderWidth: 2,
            borderColor: '#ffffff',
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'bottom' },
          title: {
            display: true,
            text: `Shift #${currentUserShift.value.DrawerID} Financial Overview`,
          },
        },
      },
    })
  } catch (error) {
    console.error('❌ Error creating shift stats chart:', error)
    if (shiftStatsChart.value) {
      shiftStatsChart.value.innerHTML = `
        <div class="d-flex flex-column align-items-center justify-content-center h-200px">
          <i class="ki-duotone ki-cross-circle text-danger fs-3x mb-3">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <p class="text-danger text-center">Chart creation failed</p>
        </div>
      `
    }
  }
}

const createVarianceChart = async () => {
  if (!varianceChart.value || !currentUserShift.value) return

  try {
    if (varianceChartInstance) {
      varianceChartInstance.destroy()
      varianceChartInstance = null
    }

    let Chart
    try {
      Chart = (await import('https://cdnjs.cloudflare.com/ajax/libs/chart.js/3.9.1/chart.min.js'))
        .default
    } catch (importError) {
      console.warn('⚠️ Could not load Chart.js for variance chart:', importError)
      varianceChart.value.innerHTML = `
        <div class="d-flex flex-column align-items-center justify-content-center h-200px">
          <i class="ki-duotone ki-chart-simple text-muted fs-3x mb-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          <p class="text-muted text-center">Variance chart unavailable</p>
        </div>
      `
      return
    }

    const ctx = varianceChart.value.getContext('2d')

    // CRITICAL: Parse TEXT fields correctly
    const expected = parseFloat(currentUserShift.value?.ExpectedCash || '0')
    const actual = parseFloat(varianceForm.actualCash || '0')
    const variance = calculatedVariance.value

    varianceChartInstance = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['Expected', 'Actual', 'Variance'],
        datasets: [
          {
            label: 'Amount (UGX)',
            data: [expected, actual, Math.abs(variance)],
            backgroundColor: [
              '#3699FF',
              variance >= 0 ? '#1BC5BD' : '#F64E60',
              variance >= 0 ? '#FFA800' : '#F64E60',
            ],
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function (value) {
                return 'UGX ' + value.toLocaleString()
              },
            },
          },
        },
        plugins: {
          title: {
            display: true,
            text: 'Cash Analysis Breakdown',
          },
        },
      },
    })
  } catch (error) {
    console.error('❌ Error creating variance chart:', error)
    if (varianceChart.value) {
      varianceChart.value.innerHTML = `
        <div class="d-flex flex-column align-items-center justify-content-center h-200px">
          <i class="ki-duotone ki-cross-circle text-danger fs-3x mb-3">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <p class="text-danger text-center">Variance chart failed</p>
        </div>
      `
    }
  }
}

// ============================================================================
// STEP NAVIGATION & FORM HANDLING
// ============================================================================

const nextStep = async () => {
  if (!canProceed.value) return

  clearErrors()

  if (currentStep.value === 2) {
    if (!varianceForm.actualCash) {
      errors.actualCash = 'Actual cash amount is required'
      return
    }

    // FRAUD DETECTION: Check for high variance
    const variance = Math.abs(calculatedVariance.value)
    if (variance > 50000) {
      const riskScore = variance > 200000 ? 85 : 65
      const severity = variance > 200000 ? 'high' : 'medium'

      await logFraudDetection(
        riskScore,
        severity,
        'Cash Variance',
        `Significant cash variance detected: UGX ${formatCurrency(variance)}`,
      )
    }

    await nextTick()
    createVarianceChart()
  }

  if (currentStep.value === 3) {
    if (!analysisForm.category) {
      errors.category = 'Variance category is required'
      return
    }
    if (!analysisForm.severity) {
      errors.severity = 'Severity level is required'
      return
    }
    if (!analysisForm.explanation) {
      errors.explanation = 'Detailed explanation is required'
      return
    }
  }

  if (currentStep.value === 4) {
    if (!resolutionForm.action) {
      errors.action = 'Resolution action is required'
      return
    }
    if (!resolutionForm.notes) {
      errors.resolutionNotes = 'Resolution notes are required'
      return
    }
  }

  currentStep.value++
}

const previousStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--
  }
}

const clearErrors = () => {
  Object.keys(errors).forEach((key) => {
    errors[key] = ''
  })
}

// CRITICAL: Database-Compliant Handover Completion
const completeHandover = async () => {
  if (!canComplete.value) {
    await Swal.fire({
      title: 'Incomplete Form',
      text: 'Please complete all required confirmations before proceeding',
      icon: 'warning',
      confirmButtonColor: '#3699ff',
    })
    return
  }

  const result = await Swal.fire({
    title: 'Complete Handover?',
    text: 'This action will close the cash drawer and cannot be undone. Are you sure?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, Complete Handover',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#1BC5BD',
    cancelButtonColor: '#f1416c',
  })

  if (!result.isConfirmed) return

  try {
    loading.value = true

    const button = document.querySelector('[data-kt-indicator]')
    if (button) {
      button.setAttribute('data-kt-indicator', 'on')
    }

    // FK VALIDATION: Ensure ClosedBy user exists
    const closedByUserId = currentUser.value.id
    try {
      await apiCall('GET', `/users/${closedByUserId}`)
    } catch (userError) {
      throw new Error(`FK_CONSTRAINT_ERROR: ClosedBy User ID ${closedByUserId} does not exist`)
    }

    // CRITICAL: All monetary fields must be TEXT strings (database compliance)
    const updateData = {
      ClosingBalance: parseFloat(varianceForm.actualCash || 0).toFixed(2), // TEXT NOT NULL
      ActualCash: parseFloat(varianceForm.actualCash || 0).toFixed(2), // TEXT NOT NULL
      Variance: calculatedVariance.value.toFixed(2), // TEXT NOT NULL
      CashPayouts: parseFloat(varianceForm.cashPayouts || 0).toFixed(2), // TEXT NOT NULL
      Status: 'Closed', // TEXT
      ClosedBy: closedByUserId, // INTEGER NULL (FK)
      ClosedAt: new Date().toISOString(), // TEXT NULL
      Notes: `${currentUserShift.value?.Notes || ''}\n\nVariance Resolution:\nCategory: ${analysisForm.category}\nAction: ${resolutionForm.action}\nResolution: ${resolutionForm.notes}\nFinal Comments: ${handoverForm.finalComments}`, // TEXT NULL
    }

    // VALIDATION: Ensure required fields are present
    if (!updateData.ClosedBy) {
      throw new Error('VALIDATION_ERROR: ClosedBy user ID is required')
    }

    await apiCall('PATCH', `/CashDrawers/${currentUserShift.value.DrawerID}`, updateData)

    // AUDIT: Log completion
    await logSecurityEvent('HANDOVER_COMPLETION', 'Cash drawer variance resolution completed', {
      drawerId: currentUserShift.value.DrawerID,
      variance: calculatedVariance.value,
      resolution: resolutionForm.action,
      finalBalance: updateData.ClosingBalance,
    })

    await Swal.fire({
      title: 'Handover Complete!',
      text: `Cash drawer #${currentUserShift.value.DrawerID} has been successfully closed with variance resolution.`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    // Reset and restart
    resetForm()
    currentStep.value = 1
    await detectAndInitializeShift()
  } catch (error) {
    console.error('❌ Error completing handover:', error)
    await Swal.fire({
      title: 'Error!',
      text: error.message || 'Failed to complete handover',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false

    const button = document.querySelector('[data-kt-indicator]')
    if (button) {
      button.setAttribute('data-kt-indicator', 'off')
    }
  }
}

const resetForm = () => {
  currentUserShift.value = null
  shiftInitialized.value = false
  shiftAction.value = ''
  initializationError.value = ''
  varianceForm.actualCash = ''
  varianceForm.cashPayouts = '0'
  analysisForm.category = ''
  analysisForm.severity = ''
  analysisForm.explanation = ''
  analysisForm.factors = []
  analysisForm.solutions = []
  resolutionForm.action = ''
  resolutionForm.adjustmentAmount = ''
  resolutionForm.referenceNumber = ''
  resolutionForm.notes = ''
  resolutionForm.supervisorPassword = ''
  resolutionForm.authorizedBy = ''
  handoverForm.confirmAccuracy = false
  handoverForm.confirmResolution = false
  handoverForm.confirmHandover = false
  handoverForm.finalComments = ''
  clearErrors()
}

// Retry initialization function for error state
const retryInitialization = async () => {
  try {
    resetForm()
    currentStep.value = 1
    await loadSingleUserStation()
    await detectAndInitializeShift()
  } catch (error) {
    console.error('❌ Error in retry initialization:', error)
    initializationError.value = error.message
  }
}

// ============================================================================
// COMPONENT LIFECYCLE - SIMPLIFIED SINGLE STATION MODE
// ============================================================================

onMounted(async () => {
  console.log('🎯 Cash Drawer Variance Resolution component mounted - DATABASE COMPLIANT MODE')

  try {
    // STEP 1: Critical Authentication Validation
    if (!authData.value) {
      throw new Error('SECURITY_ERROR: No authentication data found')
    }

    if (!currentUser.value) {
      throw new Error('SECURITY_ERROR: User information not available')
    }

    console.log('👤 Current User:', currentUser.value)

    // STEP 2: Load SINGLE User Station Assignment (No Selection)
    console.log('🏢 Loading single user station assignment...')
    console.log(`📍 Current time: ${new Date().toLocaleString()}`)
    console.log(`🕐 Shift type: ${getCurrentShiftType()}`)

    await loadSingleUserStation()

    if (!assignedStation.value) {
      throw new Error(
        'SECURITY_ERROR: No station assigned. Contact administrator to assign you to a station.',
      )
    }

    console.log('🏢 Assigned Station:', assignedStation.value)

    // STEP 3: Check system connectivity
    systemStatus.value.online = navigator.onLine !== false

    // STEP 4: Detect and initialize shift with constraint safety
    console.log('🔍 Detecting user shift with constraint safety...')
    await detectAndInitializeShift()

    // STEP 5: Create charts if shift is initialized
    if (shiftInitialized.value && currentUserShift.value) {
      await nextTick()
      try {
        await createShiftStatsChart()
      } catch (chartError) {
        console.warn('⚠️ Could not create shift stats chart:', chartError)
      }
    }

    console.log('✅ Component initialization completed successfully')
  } catch (error) {
    console.error('❌ Component initialization error:', error)
    initializationError.value = error.message

    // Determine error type and show appropriate message
    let errorTitle = 'Initialization Error'
    let errorSolutions = [
      'Refresh the page',
      'Check your login status',
      'Contact system administrator',
    ]

    if (error.message.includes('No authentication')) {
      errorTitle = 'Authentication Error'
      errorSolutions = [
        'Please log in again',
        'Clear browser cache and cookies',
        'Contact IT support if problem persists',
      ]
    } else if (error.message.includes('station')) {
      errorTitle = 'Station Assignment Error'
      errorSolutions = [
        'Contact your manager to assign you to a station',
        'Verify your user permissions',
        'Check that you have active station assignments in the system',
      ]
    } else if (error.message.includes('DATABASE_CONSTRAINT_VIOLATION')) {
      errorTitle = 'Database Constraint Error'
      errorSolutions = [
        'Wait for existing shifts to close',
        'Contact current shift attendant for handover',
        'Contact supervisor or administrator',
        'Try again in a few minutes',
      ]
    }

    await Swal.fire({
      title: errorTitle,
      html: `
        <div class="text-start">
          <p class="mb-3"><strong>Component failed to initialize:</strong></p>
          <p class="text-danger">${error.message}</p>
          <p class="mt-3"><strong>Possible solutions:</strong></p>
          <ul class="text-muted">
            ${errorSolutions.map((solution) => `<li>${solution}</li>`).join('')}
          </ul>
        </div>
      `,
      icon: 'error',
      confirmButtonText: 'Retry',
      confirmButtonColor: '#3699ff',
      showCancelButton: true,
      cancelButtonText: 'Reload Page',
      cancelButtonColor: '#f1416c',
    })
      .then((result) => {
        if (result.isConfirmed) {
          // Retry initialization
          retryInitialization()
        } else if (result.isDismissed) {
          // Reload page
          window.location.reload()
        }
      })
      .catch((swalError) => {
        console.error('❌ Error showing initialization error dialog:', swalError)
        // Fallback to browser alert
        if (confirm(`Initialization failed: ${error.message}\n\nClick OK to reload the page.`)) {
          window.location.reload()
        }
      })
  }
})

onUnmounted(() => {
  console.log('🧹 Cleaning up Cash Drawer Variance Resolution component')

  try {
    if (shiftChart) {
      shiftChart.destroy()
      shiftChart = null
    }
    if (varianceChartInstance) {
      varianceChartInstance.destroy()
      varianceChartInstance = null
    }
  } catch (error) {
    console.warn('⚠️ Error during cleanup:', error)
  }
})
</script>

<style scoped>
/* iOS-inspired design with bright Metronic colors */
.card {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
}

.stepper-nav .stepper-item {
  transition: all 0.3s ease;
}

.stepper-nav .stepper-item.current .stepper-icon {
  background: linear-gradient(135deg, #3699ff, #1bc5bd);
  border-color: #3699ff;
  transform: scale(1.1);
}

.form-control:focus {
  border-color: #3699ff;
  box-shadow: 0 0 0 0.2rem rgba(54, 153, 255, 0.25);
}

.btn {
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-1px);
}

.badge {
  border-radius: 6px;
  font-weight: 600;
}

/* Mobile responsiveness */
@media (max-width: 767.98px) {
  .stepper {
    flex-direction: column !important;
  }

  .card-body {
    padding: 1rem !important;
  }

  .btn-lg {
    padding: 0.75rem 1.5rem;
    font-size: 0.9rem;
  }
}
</style>

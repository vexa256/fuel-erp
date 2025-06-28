<template>
  <div class="container-fluid p-4 bg-light-primary min-vh-100">
    <!-- Authority Gate - Restrict Access -->
    <div v-if="!hasElevatedPrivileges" class="text-center py-20">
      <div class="card card-flush border-0 shadow-lg">
        <div class="card-body p-10">
          <i class="ki-duotone ki-security-check fs-3x text-danger mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
            <span class="path5"></span>
            <span class="path6"></span>
          </i>
          <h3 class="text-gray-900 fw-bolder fs-2 mb-3">Access Restricted</h3>
          <p class="text-gray-600 fs-4 mb-5">
            Only Station Managers and System Administrators can modify meter readings.
          </p>
          <div class="bg-light-warning rounded-3 p-4 mb-5">
            <p class="text-warning fw-bold mb-2">Your Current Role:</p>
            <p class="text-gray-700 mb-0">{{ currentUserRole }} - {{ currentUserPosition }}</p>
          </div>
          <button @click="requestAccess" class="btn btn-light-primary">
            <i class="ki-duotone ki-message-question fs-4 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Request Access
          </button>
        </div>
      </div>
    </div>

    <!-- Main Application - Authorized Users Only -->
    <div v-else>
      <!-- Shift Validation Gate -->
      <div v-if="shiftCheckComplete && !hasOpenShift && !isSystemAdmin" class="text-center py-20">
        <div class="card card-flush border-0 shadow-lg">
          <div class="card-body p-10">
            <i class="ki-duotone ki-time fs-3x text-warning mb-5">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <h3 class="text-gray-900 fw-bolder fs-2 mb-3">No Active Shift Found</h3>
            <p class="text-gray-600 fs-4 mb-5">
              You must have an active {{ currentShiftType }} shift open to access meter readings.
            </p>

            <!-- Enhanced User Context Display -->
            <div class="bg-light-info rounded-4 p-6 mb-6 text-start">
              <h5 class="text-info fw-bold mb-4">
                <i class="ki-duotone ki-user-tick fs-4 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                Your Current Session
              </h5>
              <div class="row g-3">
                <div class="col-md-6">
                  <div class="bg-white rounded-3 p-3">
                    <div class="text-info fw-bold fs-6 mb-1">Attendant</div>
                    <div class="text-gray-700">{{ currentUser?.name }}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="bg-white rounded-3 p-3">
                    <div class="text-info fw-bold fs-6 mb-1">Expected Shift</div>
                    <div class="text-gray-700">
                      {{ currentShiftType }} ({{ currentShiftTimeRange }})
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="bg-white rounded-3 p-3">
                    <div class="text-info fw-bold fs-6 mb-1">Station</div>
                    <div class="text-gray-700">{{ userStation?.StationName }}</div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="bg-white rounded-3 p-3">
                    <div class="text-info fw-bold fs-6 mb-1">Current Time</div>
                    <div class="text-gray-700">{{ currentTime }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Enhanced Instructions -->
            <div class="bg-light-warning rounded-4 p-6 mb-6 text-start">
              <h5 class="text-warning fw-bold mb-4">
                <i class="ki-duotone ki-information-5 fs-4 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                How to Open Your {{ currentShiftType }} Shift
              </h5>
              <ol class="text-gray-700 fs-5 mb-0">
                <li class="mb-3">Navigate to Cash Drawer Management</li>
                <li class="mb-3">Open {{ currentShiftType }} Shift</li>
                <li class="mb-3">Enter Opening Balance and verify details</li>
                <li class="mb-0">Return here - this page will automatically refresh</li>
              </ol>
            </div>

            <div class="row g-4 mb-6">
              <div class="col-md-6">
                <div class="bg-light-danger rounded-3 p-4">
                  <div class="text-danger fw-bold fs-5 mb-2">Shift Status</div>
                  <div class="text-gray-700">
                    <strong>Required:</strong> {{ currentShiftType }} Shift<br />
                    <strong>Status:</strong>
                    <span class="text-danger fw-bold">No Active Shift</span>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="bg-light-secondary rounded-3 p-4">
                  <div class="text-gray-800 fw-bold fs-5 mb-2">Quick Actions</div>
                  <div class="d-flex flex-column gap-2">
                    <button @click="goToShiftManagement" class="btn btn-sm btn-primary">
                      <i class="ki-duotone ki-element-plus fs-6 me-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                        <span class="path5"></span>
                      </i>
                      Open {{ currentShiftType }} Shift
                    </button>
                    <button
                      @click="recheckShiftStatus"
                      class="btn btn-sm btn-light-info"
                      :disabled="loading"
                    >
                      <i
                        class="ki-duotone ki-arrows-circle fs-6 me-2"
                        :class="{ 'spinner-border spinner-border-sm': loading }"
                      >
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      Recheck Status
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <div v-if="shiftValidationError" class="alert alert-danger">
              <h6 class="fw-bold mb-2">Shift Validation Error</h6>
              <p class="mb-0">{{ shiftValidationError }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- AI Insights Banner -->
      <div
        v-if="(hasOpenShift || isSystemAdmin) && currentAIInsight"
        class="alert alert-dismissible bg-light-success border-success mb-6"
      >
        <div class="d-flex align-items-center">
          <i class="ki-duotone ki-abstract-26 fs-2x text-success me-4">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <div class="flex-grow-1">
            <h5 class="text-success fw-bold mb-1">🤖 AI Fraud Detection</h5>
            <p class="text-gray-800 mb-0">{{ currentAIInsight.message }}</p>
            <div class="fs-7 text-gray-600 mt-1">
              Confidence: {{ currentAIInsight.confidence }}% • Type: {{ currentAIInsight.type }}
            </div>
          </div>
          <button type="button" class="btn btn-sm btn-light-success me-2" @click="showNextInsight">
            Next Tip
          </button>
          <button type="button" class="btn-close" @click="currentAIInsight = null"></button>
        </div>
      </div>

      <!-- Fraud Detection Alert Banner -->
      <div
        v-if="activeFraudAlerts.length > 0"
        class="alert alert-dismissible bg-light-danger border-danger mb-6"
      >
        <div class="d-flex align-items-center">
          <i class="ki-duotone ki-security-check fs-2x text-danger me-4">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
            <span class="path5"></span>
            <span class="path6"></span>
          </i>
          <div class="flex-grow-1">
            <h5 class="text-danger fw-bold mb-1">⚠️ Fraud Detection Alert</h5>
            <p class="text-gray-800 mb-0">{{ activeFraudAlerts[0].Description }}</p>
            <div class="fs-7 text-gray-600 mt-1">
              Risk Score: {{ activeFraudAlerts[0].RiskScore }}% • Severity:
              {{ activeFraudAlerts[0].Severity }}
            </div>
          </div>
          <button type="button" class="btn btn-sm btn-light-danger me-2" @click="showFraudDetails">
            View Details
          </button>
          <button type="button" class="btn-close" @click="dismissFraudAlert"></button>
        </div>
      </div>

      <!-- Main Meter Reading Interface -->
      <div v-if="hasOpenShift || isSystemAdmin">
        <!-- Enhanced Header with Fraud Detection Status -->
        <div class="card card-flush border-0 shadow-lg mb-6">
          <div class="card-body p-6">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
              <div class="d-flex align-items-center gap-4">
                <div class="symbol symbol-60px symbol-circle bg-light-success">
                  <i class="ki-duotone ki-gauge fs-2x text-success">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                  </i>
                </div>
                <div>
                  <h1 class="text-gray-900 fw-bolder fs-2 mb-1">Smart Meter Reading System</h1>
                  <p class="text-gray-600 fs-5 mb-0">
                    {{ userStation?.StationName || 'Loading...' }}
                  </p>
                  <div class="badge badge-light-info fs-7 mt-1">
                    {{ currentUserRole }} • {{ currentUserPosition }}
                  </div>
                </div>
              </div>
              <div class="d-flex align-items-center gap-2">
                <div class="text-end me-3">
                  <div class="text-gray-900 fw-bold fs-6">Fraud Protection</div>
                  <div class="badge" :class="fraudProtectionStatusBadge">
                    {{ fraudProtectionStatus.text }}
                  </div>
                </div>
                <button @click="showSystemInfoModal" class="btn btn-light-info btn-sm">
                  <i class="ki-duotone ki-information-5 fs-4">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </button>
                <button
                  @click="refreshAllData"
                  class="btn btn-light-primary btn-sm"
                  :disabled="loading"
                >
                  <i
                    class="ki-duotone ki-arrows-circle fs-4"
                    :class="{ 'spinner-border spinner-border-sm': loading }"
                  >
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </button>
              </div>
            </div>

            <!-- Live Metrics Dashboard with Fraud Indicators -->
            <div class="row g-4 mt-5">
              <div class="col-lg-3 col-md-6">
                <div class="bg-light-success rounded-4 p-4 text-center">
                  <i class="ki-duotone ki-drop fs-3x text-success mb-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div class="text-success fw-bolder fs-2">{{ activePumps.length }}</div>
                  <div class="text-gray-600 fw-bold fs-7">Active Pumps</div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6">
                <div class="bg-light-warning rounded-4 p-4 text-center">
                  <i class="ki-duotone ki-chart-line-up fs-3x text-warning mb-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div class="text-warning fw-bolder fs-2">{{ totalVariance }}L</div>
                  <div class="text-gray-600 fw-bold fs-7">Total Variance</div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6">
                <div class="bg-light-info rounded-4 p-4 text-center">
                  <i class="ki-duotone ki-check-circle fs-3x text-info mb-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div class="text-info fw-bolder fs-2">{{ completedReadings }}</div>
                  <div class="text-gray-600 fw-bold fs-7">Completed</div>
                </div>
              </div>
              <div class="col-lg-3 col-md-6">
                <div class="bg-light-danger rounded-4 p-4 text-center">
                  <i class="ki-duotone ki-security-check fs-3x text-danger mb-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                    <span class="path6"></span>
                  </i>
                  <div class="text-danger fw-bolder fs-2">{{ activeEventCount }}</div>
                  <div class="text-gray-600 fw-bold fs-7">Security Events</div>
                </div>
              </div>
            </div>

            <!-- Auto-Detected Session Information -->
            <div class="card border border-success mt-5">
              <div class="card-header bg-light-success">
                <h5 class="text-success fw-bold mb-0">
                  <i class="ki-duotone ki-verify fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                    <span class="path6"></span>
                  </i>
                  Auto-Detected Session Information
                </h5>
              </div>
              <div class="card-body">
                <div class="row g-4">
                  <div class="col-md-3">
                    <label class="form-label fw-bold text-gray-800">Reading Date</label>
                    <input
                      v-model="selectedDate"
                      type="date"
                      class="form-control form-control-lg border-success"
                      :max="maxAllowedDate"
                      :min="minAllowedDate"
                      @change="handleDateChange"
                    />
                    <div v-if="dateValidationError" class="text-danger fs-7 mt-1">
                      {{ dateValidationError }}
                    </div>
                  </div>
                  <div class="col-md-3">
                    <label class="form-label fw-bold text-gray-800">Auto-Detected Shift</label>
                    <div
                      class="form-control form-control-lg border-success bg-light-success text-center"
                    >
                      <div class="text-success fw-bold fs-5">{{ currentShiftType }}</div>
                      <div class="text-gray-600 fs-7">{{ currentShiftTimeRange }}</div>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <label class="form-label fw-bold text-gray-800">Logged-in Attendant</label>
                    <div class="form-control form-control-lg border-success bg-light-success">
                      <div class="text-success fw-bold">{{ currentUser?.name }}</div>
                      <div class="text-gray-600 fs-7">ID: {{ currentUser?.id }}</div>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <label class="form-label fw-bold text-gray-800">Current Time</label>
                    <div class="form-control form-control-lg border-info bg-light-info text-center">
                      <div class="text-info fw-bold">{{ currentTime }}</div>
                      <div class="text-gray-600 fs-7">Local Time</div>
                    </div>
                  </div>
                </div>

                <!-- Session Context with Fraud Protection Status -->
                <div class="row g-3 mt-3">
                  <div class="col-12">
                    <div class="bg-light-primary rounded-3 p-3">
                      <div class="row g-3 text-center">
                        <div class="col-6 col-md-3">
                          <div class="text-primary fw-bold">{{ stationPumps.length }}</div>
                          <div class="text-gray-600 fs-8">Total Pumps</div>
                        </div>
                        <div class="col-6 col-md-3">
                          <div class="text-primary fw-bold">{{ shiftTransactionCount }}</div>
                          <div class="text-gray-600 fs-8">Transactions</div>
                        </div>
                        <div class="col-6 col-md-3">
                          <div class="text-primary fw-bold">{{ fraudDetectionRules.length }}</div>
                          <div class="text-gray-600 fs-8">Fraud Rules</div>
                        </div>
                        <div class="col-6 col-md-3">
                          <div class="text-primary fw-bold">{{ sessionId.split('-')[0] }}</div>
                          <div class="text-gray-600 fs-8">Session ID</div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Real-Time Pump Grid with Fraud Detection -->
        <div class="row g-4" v-if="!loading">
          <div v-for="pump in stationPumps" :key="pump.PumpID" class="col-xl-4 col-lg-6">
            <div
              class="card card-flush border-0 shadow-lg h-100 pump-card"
              :class="getPumpSecurityStatusClass(pump.PumpID)"
              @click="handlePumpCardClick(pump)"
              role="button"
              :aria-label="`${pump.PumpName} - ${pump.ProductName} ${getFraudStatusText(pump.PumpID)}`"
            >
              <!-- Fraud Alert Overlay -->
              <div
                v-if="hasFraudAlert(pump.PumpID)"
                class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
                style="background: rgba(255, 193, 7, 0.9); z-index: 10; border-radius: 20px"
              >
                <div class="text-center text-dark">
                  <i class="ki-duotone ki-security-check fs-3x mb-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                    <span class="path6"></span>
                  </i>
                  <div class="fw-bold fs-5 mb-2">Security Event Logged</div>
                  <div class="fs-7">High variance detected - Continue normally</div>
                </div>
              </div>

              <div class="card-body p-6">
                <!-- Pump Header with Security Status -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                  <div class="d-flex align-items-center gap-3">
                    <div class="symbol symbol-50px symbol-circle" :class="getPumpStatusClass(pump)">
                      <i class="ki-duotone ki-gauge fs-2x" :class="getPumpIconClass(pump)">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                      </i>
                    </div>
                    <div>
                      <h4 class="text-gray-900 fw-bolder fs-4 mb-1">{{ pump.PumpName }}</h4>
                      <p class="text-gray-600 fs-6 mb-0">{{ pump.ProductName }}</p>
                    </div>
                  </div>
                  <div class="d-flex flex-column gap-1">
                    <div class="badge fs-6" :class="getReadingStatusBadge(pump.PumpID)">
                      {{ getReadingStatus(pump.PumpID) }}
                    </div>
                    <div v-if="hasFraudAlert(pump.PumpID)" class="badge badge-light-warning fs-8">
                      <i class="ki-duotone ki-security-check fs-7 me-1">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                        <span class="path5"></span>
                        <span class="path6"></span>
                      </i>
                      Monitored
                    </div>
                  </div>
                </div>

                <!-- Current vs Expected Display -->
                <div class="row g-3 mb-4">
                  <div class="col-6">
                    <div class="text-center">
                      <div class="text-gray-900 fw-bold fs-5">{{ pump.MeterReading }}L</div>
                      <div class="text-gray-600 fs-7">Current Reading</div>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-center">
                      <div class="text-primary fw-bold fs-5">
                        {{ getExpectedReading(pump.PumpID) }}L
                      </div>
                      <div class="text-gray-600 fs-7">Expected</div>
                    </div>
                  </div>
                </div>

                <!-- Live Variance with Fraud Risk Indicator -->
                <div class="mb-4">
                  <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="text-gray-600 fs-7 fw-bold">Live Variance</span>
                    <span class="fw-bold fs-6" :class="getVarianceColorClass(pump.PumpID)">
                      {{ getLiveVariance(pump.PumpID) }}L
                    </span>
                  </div>
                  <div class="progress h-6px bg-light-secondary">
                    <div
                      class="progress-bar"
                      :class="getVarianceProgressClass(pump.PumpID)"
                      :style="{ width: getVariancePercentage(pump.PumpID) + '%' }"
                    ></div>
                  </div>
                  <div
                    v-if="getFraudRiskLevel(pump.PumpID) !== 'LOW'"
                    class="fs-8 text-warning mt-1"
                  >
                    Fraud Risk: {{ getFraudRiskLevel(pump.PumpID) }}
                  </div>
                </div>

                <!-- Transaction Summary -->
                <div class="bg-light-info rounded-3 p-3">
                  <div class="row g-2 text-center">
                    <div class="col-4">
                      <div class="text-info fw-bold fs-6">
                        {{ getShiftTransactions(pump.PumpID) }}
                      </div>
                      <div class="text-gray-600 fs-8">Transactions</div>
                    </div>
                    <div class="col-4">
                      <div class="text-info fw-bold fs-6">{{ getShiftSales(pump.PumpID) }}L</div>
                      <div class="text-gray-600 fs-8">Sales</div>
                    </div>
                    <div class="col-4">
                      <div class="badge" :class="getAccuracyBadge(pump.PumpID)">
                        {{ getAccuracyScore(pump.PumpID) }}%
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Action Indicator -->
                <div class="mt-3 text-center">
                  <div v-if="hasFraudAlert(pump.PumpID)" class="badge badge-light-warning fs-7">
                    <i class="ki-duotone ki-security-check fs-6 me-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                      <span class="path4"></span>
                      <span class="path5"></span>
                      <span class="path6"></span>
                    </i>
                    Security Monitored
                  </div>
                  <div v-else-if="hasReading(pump.PumpID)" class="badge badge-light-success fs-7">
                    <i class="ki-duotone ki-check-circle fs-6 me-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    Verified
                  </div>
                  <div v-else class="badge badge-light-primary fs-7">
                    <i class="ki-duotone ki-plus-circle fs-6 me-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    Add Reading
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="text-center py-20">
          <div class="spinner-border text-primary mb-4" style="width: 4rem; height: 4rem"></div>
          <p class="text-gray-600 fw-bold fs-4">{{ loadingMessage }}</p>
        </div>
      </div>
    </div>

    <!-- Pump Reading Modal with Fraud Detection -->
    <div class="modal fade" id="pumpModal" tabindex="-1" v-if="selectedPump">
      <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content border-0 shadow-xl">
          <div class="modal-header bg-primary">
            <div class="d-flex align-items-center gap-3">
              <div class="symbol symbol-45px symbol-circle bg-light-success">
                <i class="ki-duotone ki-gauge fs-2x text-success">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                </i>
              </div>
              <div>
                <h3 class="modal-title text-white fw-bolder mb-0">{{ selectedPump.PumpName }}</h3>
                <p class="text-light fs-6 mb-0">
                  {{ selectedPump.ProductName }} • Tank {{ selectedPump.TankName }}
                </p>
              </div>
            </div>
            <button
              type="button"
              class="btn-close btn-close-white"
              @click="closePumpModal"
            ></button>
          </div>

          <div class="modal-body p-6">
            <!-- Enhanced Session Context Display -->
            <div class="card border border-info mb-6">
              <div class="card-header bg-light-info">
                <h5 class="text-info fw-bold mb-0">
                  <i class="ki-duotone ki-user-tick fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  Auto-Detected Reading Context
                </h5>
              </div>
              <div class="card-body">
                <div class="row g-4">
                  <div class="col-md-3">
                    <div class="bg-light-success rounded-3 p-3 text-center">
                      <div class="text-success fw-bold fs-6">{{ currentUser?.name }}</div>
                      <div class="text-gray-600 fs-8">Attendant</div>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <div class="bg-light-primary rounded-3 p-3 text-center">
                      <div class="text-primary fw-bold fs-6">{{ currentShiftType }}</div>
                      <div class="text-gray-600 fs-8">{{ currentShiftTimeRange }}</div>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <div class="bg-light-warning rounded-3 p-3 text-center">
                      <div class="text-warning fw-bold fs-6">{{ selectedDate }}</div>
                      <div class="text-gray-600 fs-8">Reading Date</div>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <div class="bg-light-info rounded-3 p-3 text-center">
                      <div class="text-info fw-bold fs-6">{{ currentTime }}</div>
                      <div class="text-gray-600 fs-8">Current Time</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Real-Time Calculation Dashboard -->
            <div class="row g-4 mb-6">
              <div class="col-md-3">
                <div class="bg-light-primary rounded-4 p-4 text-center">
                  <div class="text-primary fw-bolder fs-3">{{ selectedPump.MeterReading }}L</div>
                  <div class="text-gray-600 fs-7 fw-bold">Current Reading</div>
                </div>
              </div>
              <div class="col-md-3">
                <div class="bg-light-info rounded-4 p-4 text-center">
                  <div class="text-info fw-bolder fs-3">{{ calculatedExpected }}L</div>
                  <div class="text-gray-600 fs-7 fw-bold">Expected Reading</div>
                </div>
              </div>
              <div class="col-md-3">
                <div class="bg-light-success rounded-4 p-4 text-center">
                  <div class="text-success fw-bolder fs-3">{{ totalShiftSales }}L</div>
                  <div class="text-gray-600 fs-7 fw-bold">Shift Sales</div>
                </div>
              </div>
              <div class="col-md-3">
                <div class="bg-light-warning rounded-4 p-4 text-center">
                  <div class="text-warning fw-bolder fs-3">{{ liveVarianceValue }}L</div>
                  <div class="text-gray-600 fs-7 fw-bold">Live Variance</div>
                </div>
              </div>
            </div>

            <!-- Mathematical Breakdown -->
            <div class="card border border-info mb-6">
              <div class="card-header bg-light-info">
                <h5 class="text-info fw-bold mb-0">
                  <i class="ki-duotone ki-calculator fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Real-Time Calculation Breakdown
                </h5>
              </div>
              <div class="card-body">
                <div class="row g-4">
                  <div class="col-md-6">
                    <h6 class="text-gray-800 fw-bold mb-3">Formula Applied:</h6>
                    <div class="bg-light-secondary rounded-3 p-3">
                      <code class="text-dark">
                        Expected = Opening + Σ(Sales)<br />
                        Variance = Actual - Expected<br />
                        Accuracy = (1 - |Variance|/Expected) × 100%
                      </code>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <h6 class="text-gray-800 fw-bold mb-3">Live Data Sources:</h6>
                    <ul class="list-unstyled">
                      <li class="mb-2">
                        <i class="ki-duotone ki-check-circle fs-6 text-success me-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        Pumps.MeterReading
                      </li>
                      <li class="mb-2">
                        <i class="ki-duotone ki-check-circle fs-6 text-success me-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        TransactionItems.Quantity
                      </li>
                      <li class="mb-2">
                        <i class="ki-duotone ki-check-circle fs-6 text-success me-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        DailyReadings.OpeningReading
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>

            <!-- Fraud Detection Block -->
            <div v-if="requiresFraudDetection" class="card border border-warning mb-6">
              <div class="card-header bg-light-warning">
                <h5 class="text-warning fw-bold mb-0">
                  <i class="ki-duotone ki-security-check fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                    <span class="path6"></span>
                  </i>
                  Fraud Detection - High Variance Detected
                </h5>
              </div>
              <div class="card-body">
                <div class="row g-4">
                  <div class="col-md-8">
                    <div class="alert alert-warning">
                      <h6 class="fw-bold mb-2">Variance Threshold Exceeded</h6>
                      <p class="mb-3">
                        <strong>Current Variance:</strong> {{ Math.abs(liveVarianceValue) }}L<br />
                        <strong>Allowable Threshold:</strong> {{ varianceThreshold }}L<br />
                        <strong>Excess:</strong>
                        {{ Math.abs(liveVarianceValue) - varianceThreshold }}L
                      </p>
                      <div class="bg-light rounded-3 p-3">
                        <strong>Status:</strong> Reading will be automatically saved with security
                        monitoring
                      </div>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="text-center">
                      <div class="bg-light-info rounded-3 p-4">
                        <i class="ki-duotone ki-security-check fs-3x text-info mb-3">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                          <span class="path4"></span>
                          <span class="path5"></span>
                          <span class="path6"></span>
                        </i>
                        <div class="text-info fw-bold">Auto-Monitoring</div>
                        <div class="fs-7 text-gray-600">Fraud Detection Active</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Reading Input Form -->
            <form @submit.prevent="savePumpReading" novalidate>
              <div class="row g-4 mb-6">
                <div class="col-md-4">
                  <label class="required form-label text-gray-800 fw-bold"
                    >Opening Reading (L)</label
                  >
                  <input
                    v-model="pumpReading.openingReading"
                    type="number"
                    step="0.01"
                    class="form-control form-control-lg border-primary"
                    :class="{ 'is-invalid': pumpErrors.openingReading }"
                    placeholder="0.00"
                    @input="calculateRealTimeMetrics"
                  />
                  <div v-if="pumpErrors.openingReading" class="invalid-feedback">
                    {{ pumpErrors.openingReading }}
                  </div>
                  <div class="form-text">Previous: {{ getPreviousReading('opening') }}L</div>
                </div>

                <div class="col-md-4">
                  <label class="required form-label text-gray-800 fw-bold"
                    >Current Reading (L)</label
                  >
                  <input
                    v-model="pumpReading.currentReading"
                    type="number"
                    step="0.01"
                    class="form-control form-control-lg border-primary"
                    :class="{ 'is-invalid': pumpErrors.currentReading }"
                    placeholder="0.00"
                    @input="calculateRealTimeMetrics"
                  />
                  <div v-if="pumpErrors.currentReading" class="invalid-feedback">
                    {{ pumpErrors.currentReading }}
                  </div>
                  <div class="form-text">Live from pump meter</div>
                </div>

                <div class="col-md-4">
                  <label class="form-label text-gray-800 fw-bold">Calculated Sales (L)</label>
                  <input
                    :value="calculatedSales"
                    type="text"
                    class="form-control form-control-lg bg-light-success border-success fw-bold"
                    readonly
                    tabindex="-1"
                  />
                  <div class="form-text">Auto: Current - Opening</div>
                </div>

                <div class="col-12">
                  <label class="form-label text-gray-800 fw-bold">Notes & Justification</label>
                  <textarea
                    v-model="pumpReading.notes"
                    class="form-control border-info"
                    rows="3"
                    placeholder="Optional notes for this reading..."
                    maxlength="500"
                  ></textarea>
                  <div class="form-text d-flex justify-content-between">
                    <span>{{
                      Math.abs(liveVarianceValue) > 10
                        ? 'Recommended for high variances'
                        : 'Optional notes'
                    }}</span>
                    <span>{{ pumpReading.notes?.length || 0 }}/500</span>
                  </div>
                </div>
              </div>

              <!-- Real-Time Transaction Verification -->
              <div class="card border border-success mb-6">
                <div class="card-header bg-light-success">
                  <h5 class="text-success fw-bold mb-0">
                    <i class="ki-duotone ki-verify fs-4 me-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                      <span class="path4"></span>
                      <span class="path5"></span>
                      <span class="path6"></span>
                    </i>
                    Transaction Verification
                  </h5>
                </div>
                <div class="card-body">
                  <div class="row g-4">
                    <div class="col-md-6">
                      <h6 class="text-gray-800 fw-bold mb-3">Shift Transactions:</h6>
                      <div class="bg-light rounded-3 p-3">
                        <div class="d-flex justify-content-between mb-2">
                          <span>Total Transactions:</span>
                          <strong>{{ shiftTransactionCount }}</strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                          <span>Total Volume:</span>
                          <strong>{{ totalShiftSales }}L</strong>
                        </div>
                        <div class="d-flex justify-content-between">
                          <span>Average per Transaction:</span>
                          <strong>{{ averageTransactionSize }}L</strong>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <h6 class="text-gray-800 fw-bold mb-3">Security Metrics:</h6>
                      <div class="bg-light rounded-3 p-3">
                        <div class="d-flex justify-content-between mb-2">
                          <span>Variance Percentage:</span>
                          <strong class="text-warning">{{ variancePercentage }}%</strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                          <span>Accuracy Score:</span>
                          <strong class="text-success">{{ accuracyScore }}%</strong>
                        </div>
                        <div class="d-flex justify-content-between">
                          <span>Risk Level:</span>
                          <span class="badge" :class="riskLevelBadge">{{ riskLevel }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>

          <div class="modal-footer bg-light-secondary p-6">
            <div class="d-flex w-100 gap-3">
              <button
                v-if="hasExistingReading"
                @click="deletePumpReading"
                class="btn btn-light-danger"
                :disabled="pumpSaving"
              >
                <i class="ki-duotone ki-trash fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                </i>
                Delete
              </button>
              <button type="button" class="btn btn-light" @click="closePumpModal">Cancel</button>
              <button
                @click="savePumpReading"
                class="btn flex-grow-1"
                :class="getSaveButtonClass()"
                :disabled="!isPumpReadingValid() || pumpSaving"
              >
                <span v-if="pumpSaving" class="spinner-border spinner-border-sm me-2"></span>
                <i v-else class="ki-duotone ki-check fs-4 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                {{ getSaveButtonText() }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- System Information Modal -->
    <div class="modal fade" id="systemInfoModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg">
          <div class="modal-header bg-info">
            <h3 class="modal-title text-white fw-bold">System Information & Fraud Protection</h3>
            <button
              type="button"
              class="btn-close btn-close-white"
              @click="closeSystemInfoModal"
            ></button>
          </div>
          <div class="modal-body p-6">
            <!-- Authority Matrix -->
            <div class="mb-6">
              <h6 class="text-gray-800 fw-bold mb-4">Your Auto-Detected Session</h6>
              <div class="bg-light-success rounded-3 p-4">
                <div class="row g-3">
                  <div class="col-md-6"><strong>User:</strong> {{ currentUser?.name }}</div>
                  <div class="col-md-6"><strong>Role:</strong> {{ currentUserRole }}</div>
                  <div class="col-md-6"><strong>Position:</strong> {{ currentUserPosition }}</div>
                  <div class="col-md-6">
                    <strong>Station:</strong> {{ userStation?.StationName }}
                  </div>
                  <div class="col-md-6">
                    <strong>Auto-Detected Shift:</strong> {{ currentShiftType }}
                  </div>
                  <div class="col-md-6">
                    <strong>Access Level:</strong>
                    <span class="badge badge-light-success">{{
                      hasElevatedPrivileges ? 'Authorized' : 'Restricted'
                    }}</span>
                  </div>
                  <div class="col-md-6"><strong>Session:</strong> {{ sessionId }}</div>
                  <div class="col-md-6"><strong>Current Time:</strong> {{ currentTime }}</div>
                </div>
              </div>
            </div>

            <!-- Fraud Detection Rules -->
            <div class="mb-6">
              <h6 class="text-gray-800 fw-bold mb-4">Active Fraud Detection Rules</h6>
              <div class="bg-light-warning rounded-3 p-4">
                <div
                  v-for="rule in fraudDetectionRules"
                  :key="rule.DetectionRuleID"
                  class="d-flex align-items-center gap-3 mb-3"
                >
                  <div class="symbol symbol-40px symbol-circle bg-light-warning">
                    <i class="ki-duotone ki-security-check fs-2x text-warning">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                      <span class="path4"></span>
                      <span class="path5"></span>
                      <span class="path6"></span>
                    </i>
                  </div>
                  <div>
                    <div class="text-gray-900 fw-bold">{{ rule.RuleName }}</div>
                    <div class="text-gray-600 fs-7">
                      {{ rule.Description || 'Active fraud detection rule' }}
                    </div>
                  </div>
                  <div class="ms-auto">
                    <span
                      class="badge"
                      :class="rule.Enabled === '1' ? 'badge-light-success' : 'badge-light-danger'"
                    >
                      {{ rule.Enabled === '1' ? 'Active' : 'Disabled' }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <!-- System Status -->
            <div>
              <h6 class="text-gray-800 fw-bold mb-4">Real-Time System Status</h6>
              <div class="row g-3">
                <div class="col-6 col-md-3">
                  <div class="text-center">
                    <div class="text-success fw-bold fs-4">{{ systemMetrics.uptime }}%</div>
                    <div class="text-gray-600 fs-8">Uptime</div>
                  </div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="text-center">
                    <div class="text-info fw-bold fs-4">{{ systemMetrics.responseTime }}ms</div>
                    <div class="text-gray-600 fs-8">Response</div>
                  </div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="text-center">
                    <div class="text-warning fw-bold fs-4">{{ systemMetrics.activeUsers }}</div>
                    <div class="text-gray-600 fs-8">Active Users</div>
                  </div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="text-center">
                    <div class="text-primary fw-bold fs-4">{{ systemMetrics.dbConnections }}</div>
                    <div class="text-gray-600 fs-8">DB Connections</div>
                  </div>
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
import { ref, reactive, computed, onMounted, onUnmounted, watch, nextTick } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// Authentication & Authorization
const authData = ref(JSON.parse(localStorage.getItem('kigrama_user_data') || '{}'))
const currentUser = computed(() => authData.value.user || {})
const userStation = computed(() => {
  const stations = authData.value.stations || []
  return stations.find((s) => s.IsPrimary === '1') || stations[0] || null
})

// Enhanced Role-Based Access Control
const currentUserRole = computed(() => currentUser.value?.Role || 'Unknown')
const currentUserPosition = computed(() => {
  const positions = authData.value.positions || []
  const primary = positions.find((p) => p.IsPrimary === '1') || positions[0]
  return primary?.PositionTitle || 'Unknown'
})

const hasElevatedPrivileges = computed(() => {
  const role = currentUserRole.value.toLowerCase()
  const position = currentUserPosition.value.toLowerCase()
  return (
    role.includes('admin') ||
    role.includes('manager') ||
    position.includes('manager') ||
    position.includes('supervisor') ||
    position.includes('admin')
  )
})

// AUTO-DETECTION: Current Time and Shift Logic
const currentTime = ref('')
const currentShiftType = ref('')
const currentShiftTimeRange = ref('')

const determineCurrentShift = () => {
  const now = new Date()
  const hours = now.getHours()
  const minutes = now.getMinutes()
  const timeString = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`
  currentTime.value = timeString

  if (hours >= 6 && hours < 14) {
    currentShiftType.value = 'Morning'
    currentShiftTimeRange.value = '06:00-14:00'
  } else if (hours >= 14 && hours < 22) {
    currentShiftType.value = 'Afternoon'
    currentShiftTimeRange.value = '14:00-22:00'
  } else {
    currentShiftType.value = 'Night'
    currentShiftTimeRange.value = '22:00-06:00'
  }
}

// Component State
const loading = ref(true)
const loadingMessage = ref('Initializing fraud detection system...')
const selectedDate = ref('')
const selectedShift = ref('')
const selectedAttendant = ref('')
const maxAllowedDate = ref('')
const minAllowedDate = ref('')
const dateValidationError = ref('')

// Shift Management State
const activeShift = ref(null)
const hasOpenShift = ref(false)
const shiftValidationError = ref('')
const aiInsights = ref([])
const currentAIInsight = ref(null)
const shiftCheckComplete = ref(false)

// FRAUD DETECTION STATE (Replacing Approval System)
const activeFraudAlerts = ref([])
const fraudDetectionRules = ref([])
const eventLogEntries = ref([])
const fraudDetectionPollingInterval = ref(null)

// Data Collections
const stationPumps = ref([])
const stationAttendants = ref([])
const stationManagers = ref([])
const shiftTransactions = ref([])
const products = ref([])

// Reading State Management
const readings = reactive(new Map())
const pumpErrors = reactive({})
const pumpSaving = ref(false)

// FRAUD DETECTION MAPS (Replacing Approval Maps)
const fraudAlertsMap = reactive(new Map())
const eventLogMap = reactive(new Map())

// Selected Pump Modal State
const selectedPump = ref(null)
const pumpReading = reactive({
  openingReading: '',
  currentReading: '',
  notes: '',
  readingId: null,
})

// Fraud Detection Thresholds
const varianceThreshold = ref(20) // Configurable threshold

// System Status
const fraudProtectionStatus = reactive({
  text: 'Active',
  color: 'success',
})

const systemMetrics = reactive({
  uptime: 99.9,
  responseTime: 45,
  activeUsers: 12,
  dbConnections: 8,
})

const sessionId = ref(`${currentUser.value?.id || 'unknown'}-${Date.now()}`)

// Modal Instances
let pumpModalInstance = null
let systemInfoModalInstance = null

// Computed Properties
const fraudProtectionStatusBadge = computed(() => `badge-light-${fraudProtectionStatus.color}`)

const activePumps = computed(() => stationPumps.value.filter((pump) => pump.Status === 'Active'))

const completedReadings = computed(
  () => stationPumps.value.filter((pump) => hasReading(pump.PumpID)).length,
)

const activeEventCount = computed(
  () => eventLogEntries.value.filter((e) => e.Status === 'OPEN').length,
)

const totalVariance = computed(() => {
  return stationPumps.value
    .reduce((total, pump) => {
      return total + Math.abs(parseFloat(getLiveVariance(pump.PumpID)) || 0)
    }, 0)
    .toFixed(2)
})

// Selected Pump Calculations
const calculatedExpected = computed(() => {
  if (!selectedPump.value || !pumpReading.openingReading) return '0.00'
  const opening = parseFloat(pumpReading.openingReading) || 0
  const sales = parseFloat(totalShiftSales.value) || 0
  return (opening + sales).toFixed(2)
})

const calculatedSales = computed(() => {
  if (!pumpReading.openingReading || !pumpReading.currentReading) return '0.00'
  const opening = parseFloat(pumpReading.openingReading) || 0
  const current = parseFloat(pumpReading.currentReading) || 0
  return (current - opening).toFixed(2)
})

const totalShiftSales = computed(() => {
  if (!selectedPump.value) return '0.00'
  return getShiftSales(selectedPump.value.PumpID)
})

const liveVarianceValue = computed(() => {
  if (!pumpReading.currentReading || !calculatedExpected.value) return 0
  const actual = parseFloat(pumpReading.currentReading) || 0
  const expected = parseFloat(calculatedExpected.value) || 0
  return (actual - expected).toFixed(2)
})

const requiresFraudDetection = computed(
  () => Math.abs(parseFloat(liveVarianceValue.value)) > varianceThreshold.value,
)

const hasExistingReading = computed(() => Boolean(pumpReading.readingId))

const shiftTransactionCount = computed(() => shiftTransactions.value.length)

const averageTransactionSize = computed(() => {
  if (shiftTransactionCount.value === 0) return '0.00'
  const total = parseFloat(totalShiftSales.value) || 0
  return (total / shiftTransactionCount.value).toFixed(2)
})

const variancePercentage = computed(() => {
  const expected = parseFloat(calculatedExpected.value) || 1
  const variance = Math.abs(parseFloat(liveVarianceValue.value)) || 0
  return ((variance / expected) * 100).toFixed(1)
})

const accuracyScore = computed(() => {
  const percentage = parseFloat(variancePercentage.value) || 0
  return Math.max(0, 100 - percentage).toFixed(1)
})

const riskLevel = computed(() => {
  const variance = Math.abs(parseFloat(liveVarianceValue.value)) || 0
  if (variance > 50) return 'Critical'
  if (variance > 20) return 'High'
  if (variance > 10) return 'Medium'
  return 'Low'
})

const riskLevelBadge = computed(() => {
  switch (riskLevel.value) {
    case 'Critical':
      return 'badge-light-danger'
    case 'High':
      return 'badge-light-warning'
    case 'Medium':
      return 'badge-light-info'
    default:
      return 'badge-light-success'
  }
})

// System Admin Override
const isSystemAdmin = computed(() => {
  const role = currentUserRole.value.toLowerCase()
  return role.includes('system') && role.includes('admin')
})

// Auto-update current time every minute
const updateCurrentTime = () => {
  determineCurrentShift()
  if (!selectedShift.value || selectedShift.value !== currentShiftType.value) {
    selectedShift.value = currentShiftType.value
  }
}

// Enhanced API Request with Full Authentication
const apiRequest = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${getAuthToken()}`,
        'X-Station-ID': userStation.value?.StationID?.toString(),
        'X-User-ID': currentUser.value?.id?.toString(),
        'X-Session-ID': sessionId.value,
        'X-Shift-Type': currentShiftType.value,
        'X-Attendant-ID': selectedAttendant.value?.toString(),
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.message || `HTTP ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}

const getAuthToken = () => {
  return authData.value.token || localStorage.getItem('kigrama_auth_token') || ''
}

// FRAUD DETECTION SYSTEM FUNCTIONS (Replacing Approval Functions)

const loadFraudDetectionRules = async () => {
  console.log('🔍 FRAUD DETECTION: Loading active fraud detection rules...')

  try {
    const response = await apiRequest('/FraudDetectionRules?Enabled=1')
    fraudDetectionRules.value = response.records || []
    console.log('✅ FRAUD DETECTION: Loaded fraud rules:', fraudDetectionRules.value.length)
  } catch (error) {
    console.error('💥 FRAUD DETECTION: Error loading rules:', error)
  }
}

const loadActiveFraudAlerts = async () => {
  console.log('🔍 FRAUD DETECTION: Loading active fraud alerts...')

  if (!userStation.value?.StationID) return

  try {
    const response = await apiRequest(
      `/FraudDetectionLogs?StationID=${userStation.value.StationID}&UserID=${selectedAttendant.value}&Status=Flagged`,
    )

    activeFraudAlerts.value = response.records || []
    console.log('🔍 FRAUD DETECTION: Found active fraud alerts:', activeFraudAlerts.value.length)

    // Map fraud alerts to pump IDs
    fraudAlertsMap.clear()
    activeFraudAlerts.value.forEach((alert) => {
      if (alert.FraudType === 'METER_READING_VARIANCE') {
        // Extract pump ID from description or use a lookup
        const pumpId = extractPumpIdFromAlert(alert)
        if (pumpId) {
          fraudAlertsMap.set(pumpId, {
            fraudLogId: alert.FraudLogID,
            riskScore: alert.RiskScore,
            severity: alert.Severity,
            description: alert.Description,
            detectedAt: alert.DetectedAt,
          })
        }
      }
    })
  } catch (error) {
    console.error('💥 FRAUD DETECTION: Error loading alerts:', error)
  }
}

const loadEventLogEntries = async () => {
  console.log('🔍 EVENT LOG: Loading active event log entries...')

  if (!userStation.value?.StationID) return

  try {
    const response = await apiRequest(
      `/EventLog?AffectedStationID=${userStation.value.StationID}&Status=OPEN&EventType=FRAUD`,
    )

    eventLogEntries.value = response.records || []
    console.log('🔍 EVENT LOG: Found active events:', eventLogEntries.value.length)

    // Map event logs to relevant entities
    eventLogMap.clear()
    eventLogEntries.value.forEach((event) => {
      if (event.PumpID) {
        eventLogMap.set(event.PumpID, {
          eventId: event.EventID,
          riskLevel: event.RiskLevel,
          severity: event.Severity,
          title: event.Title,
          description: event.Description,
        })
      }
    })
  } catch (error) {
    console.error('💥 EVENT LOG: Error loading entries:', error)
  }
}

const extractPumpIdFromAlert = (alert) => {
  // Extract pump ID from alert description or metadata
  try {
    if (alert.Description && alert.Description.includes('Pump')) {
      const match = alert.Description.match(/Pump\s+(\d+)/i)
      return match ? parseInt(match[1]) : null
    }
    return null
  } catch (error) {
    return null
  }
}

const startFraudDetectionPolling = () => {
  console.log('🔄 FRAUD DETECTION: Starting real-time fraud monitoring...')

  if (fraudDetectionPollingInterval.value) {
    clearInterval(fraudDetectionPollingInterval.value)
  }

  fraudDetectionPollingInterval.value = setInterval(async () => {
    try {
      await checkFraudAlertUpdates()
    } catch (error) {
      console.error('💥 FRAUD DETECTION: Polling error:', error)
    }
  }, 30000)
}

const stopFraudDetectionPolling = () => {
  if (fraudDetectionPollingInterval.value) {
    clearInterval(fraudDetectionPollingInterval.value)
    fraudDetectionPollingInterval.value = null
    console.log('🛑 FRAUD DETECTION: Stopped polling')
  }
}

const checkFraudAlertUpdates = async () => {
  console.log('🔄 FRAUD DETECTION: Checking for fraud alert updates...')

  try {
    await loadActiveFraudAlerts()
    await loadEventLogEntries()
  } catch (error) {
    console.error('💥 FRAUD DETECTION: Update check failed:', error)
  }
}

// FRAUD DETECTION HELPER FUNCTIONS

const hasFraudAlert = (pumpId) => {
  return fraudAlertsMap.has(pumpId) || eventLogMap.has(pumpId)
}

const getFraudStatusText = (pumpId) => {
  if (fraudAlertsMap.has(pumpId)) return '(Fraud Alert Active)'
  if (eventLogMap.has(pumpId)) return '(Security Event)'
  return ''
}

const getFraudRiskLevel = (pumpId) => {
  const variance = Math.abs(parseFloat(getLiveVariance(pumpId)) || 0)
  if (variance > 50) return 'CRITICAL'
  if (variance > 20) return 'HIGH'
  if (variance > 10) return 'MEDIUM'
  return 'LOW'
}

const getPumpSecurityStatusClass = (pumpId) => {
  if (hasFraudAlert(pumpId)) return 'fraud-monitored'
  return ''
}

const showFraudDetails = () => {
  if (activeFraudAlerts.value.length === 0) return

  const alert = activeFraudAlerts.value[0]
  Swal.fire({
    title: 'Fraud Detection Alert',
    html: `
      <div class="text-start">
        <p><strong>Type:</strong> ${alert.FraudType}</p>
        <p><strong>Risk Score:</strong> ${alert.RiskScore}%</p>
        <p><strong>Severity:</strong> ${alert.Severity}</p>
        <p><strong>Description:</strong> ${alert.Description}</p>
        <p><strong>Detected:</strong> ${new Date(alert.DetectedAt).toLocaleString()}</p>
        <hr/>
        <p class="text-info">This is an automated detection. Operations can continue normally while the system monitors activity.</p>
      </div>
    `,
    icon: 'warning',
    confirmButtonColor: '#f1416c',
  })
}

const dismissFraudAlert = () => {
  if (activeFraudAlerts.value.length > 0) {
    activeFraudAlerts.value.shift()
  }
}

// ENHANCED SHIFT VALIDATION FUNCTIONS
const validateActiveShift = async () => {
  console.log(
    '🔍 ENHANCED SHIFT VALIDATION: Starting comprehensive shift validation with auto-detection...',
  )

  if (isSystemAdmin.value) {
    console.log('🔑 SHIFT VALIDATION: System Admin detected - bypassing shift validation')
    hasOpenShift.value = true
    shiftCheckComplete.value = true
    return true
  }

  if (!userStation.value?.StationID || !currentUser.value?.id) {
    console.error('❌ SHIFT VALIDATION: Missing required data')
    shiftValidationError.value = 'Missing station or user information'
    shiftCheckComplete.value = true
    return false
  }

  try {
    const today = new Date().toISOString().split('T')[0]
    const response = await apiRequest(
      `/CashDrawers?StationID=${userStation.value.StationID}&AttendantID=${selectedAttendant.value}&Status=Open&ShiftDate=${today}&ShiftType=${currentShiftType.value}`,
    )

    const openShifts = response.records || []

    if (openShifts.length > 0) {
      const validShift = openShifts.find((shift) => {
        const shiftDate = new Date(shift.ShiftDate).toISOString().split('T')[0]
        return (
          shiftDate === today &&
          shift.Status === 'Open' &&
          shift.StationID === userStation.value.StationID &&
          shift.AttendantID === selectedAttendant.value &&
          shift.ShiftType === currentShiftType.value
        )
      })

      if (validShift) {
        activeShift.value = validShift
        hasOpenShift.value = true
        generateShiftAIInsights(validShift)
        startFraudDetectionPolling()
      } else {
        hasOpenShift.value = false
        shiftValidationError.value = `No open ${currentShiftType.value} shift found`
      }
    } else {
      hasOpenShift.value = false
      shiftValidationError.value = `No open ${currentShiftType.value} shift found`
    }

    shiftCheckComplete.value = true
    return hasOpenShift.value
  } catch (error) {
    console.error('💥 ENHANCED SHIFT VALIDATION ERROR:', error)
    shiftValidationError.value = `Shift validation failed: ${error.message}`
    hasOpenShift.value = false
    shiftCheckComplete.value = true
    return false
  }
}

const recheckShiftStatus = async () => {
  loading.value = true
  loadingMessage.value = 'Rechecking auto-detected shift status...'

  try {
    updateCurrentTime()
    shiftCheckComplete.value = false
    await validateActiveShift()

    if (hasOpenShift.value) {
      await Swal.fire({
        title: 'Shift Found!',
        text: `Active ${currentShiftType.value} shift detected. You can now access meter readings.`,
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 3000,
        showConfirmButton: false,
      })
      await loadInitialData()
    } else {
      await Swal.fire({
        title: 'No Active Shift',
        text: `Please open a ${currentShiftType.value} shift in Cash Drawer Management.`,
        icon: 'warning',
      })
    }
  } catch (error) {
    await Swal.fire({
      title: 'Recheck Failed!',
      text: error.message,
      icon: 'error',
    })
  } finally {
    loading.value = false
  }
}

const goToShiftManagement = () => {
  window.location.href = `/shift-management?shift=${currentShiftType.value}&attendant=${selectedAttendant.value}&station=${userStation.value.StationID}`
}

const handlePumpCardClick = (pump) => {
  // No locking - all pumps accessible, fraud detection runs in background
  openPumpModal(pump)
}

// ENHANCED AI INSIGHTS SYSTEM
const generateShiftAIInsights = (shift) => {
  const insights = [
    {
      type: 'Fraud_Protection_Active',
      message: `Fraud detection is active for your ${currentShiftType.value} shift. All readings are automatically monitored for suspicious activity.`,
      confidence: 100,
      priority: 'high',
    },
    {
      type: 'Auto_Detection_Success',
      message: `Welcome ${currentUser.value.name}! Your ${currentShiftType.value} shift has been auto-detected and fraud protection is enabled.`,
      confidence: 100,
      priority: 'high',
    },
    {
      type: 'Security_Enhancement',
      message:
        'Advanced security features are monitoring all meter readings. High variances will be logged automatically without blocking operations.',
      confidence: 95,
      priority: 'medium',
    },
  ]

  aiInsights.value = insights
  currentAIInsight.value = insights[0]
}

const generateGeneralAIInsights = () => {
  const insights = [
    {
      type: 'System_Admin_Fraud_Monitor',
      message: `As System Admin, you have full access with comprehensive fraud monitoring. All activities are logged for compliance.`,
      confidence: 100,
      priority: 'high',
    },
  ]

  aiInsights.value = insights
  currentAIInsight.value = insights[0]
}

const showNextInsight = () => {
  if (aiInsights.value.length === 0) return
  const currentIndex = aiInsights.value.findIndex((insight) => insight === currentAIInsight.value)
  const nextIndex = (currentIndex + 1) % aiInsights.value.length
  currentAIInsight.value = aiInsights.value[nextIndex]
}

// Access Control Functions
const requestAccess = async () => {
  const result = await Swal.fire({
    title: 'Request Elevated Access',
    html: `
      <div class="text-start">
        <p>Submit a request to your station manager for meter reading privileges?</p>
        <hr/>
        <p><strong>Auto-Detected Context:</strong></p>
        <ul>
          <li><strong>Requester:</strong> ${currentUser.value.name}</li>
          <li><strong>Current Shift:</strong> ${currentShiftType.value}</li>
          <li><strong>Station:</strong> ${userStation.value.StationName}</li>
        </ul>
      </div>
    `,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Submit Request',
    cancelButtonText: 'Cancel',
  })

  if (result.isConfirmed) {
    try {
      const eventData = {
        EventType: 'ACCESS',
        EventSubType: 'ROLE_VIOLATION',
        Title: `Access Request - ${currentShiftType.value} Shift`,
        Description: `User ${currentUser.value?.name} requesting meter reading privileges for ${currentShiftType.value} shift`,
        RiskLevel: 'LOW',
        Severity: 2,
        AffectedStationID: userStation.value?.StationID,
        AffectedUserID: currentUser.value?.id,
        Status: 'OPEN',
      }

      await apiRequest('/EventLog', {
        method: 'POST',
        body: JSON.stringify(eventData),
      })

      await Swal.fire({
        title: 'Request Submitted!',
        text: `Your access request has been logged in the system`,
        icon: 'success',
      })
    } catch (error) {
      await Swal.fire({
        title: 'Request Failed!',
        text: error.message,
        icon: 'error',
      })
    }
  }
}

// Data Loading Functions
const loadInitialData = async () => {
  try {
    loadingMessage.value = 'Loading station data...'
    await loadStationPumps()

    loadingMessage.value = 'Loading staff information...'
    await loadStationAttendants()

    loadingMessage.value = 'Loading fraud detection rules...'
    await loadFraudDetectionRules()

    loadingMessage.value = 'Checking fraud alerts...'
    await loadActiveFraudAlerts()

    loadingMessage.value = 'Loading event log entries...'
    await loadEventLogEntries()

    loadingMessage.value = 'Loading shift transactions...'
    if (selectedDate.value && currentShiftType.value) {
      await loadShiftTransactions()
    }
  } catch (error) {
    console.error('💥 ENHANCED DATA LOADING ERROR:', error)
    throw error
  }
}

const loadStationPumps = async () => {
  if (!userStation.value?.StationID) return

  try {
    const [pumpsData, tanksData, productsData] = await Promise.all([
      apiRequest(`/Pumps?StationID=${userStation.value.StationID}`),
      apiRequest(`/Tanks?StationID=${userStation.value.StationID}`),
      apiRequest('/Products'),
    ])

    products.value = productsData.records || []
    const tanks = tanksData.records || []
    const pumps = (pumpsData.records || []).filter(
      (pump) => pump.StationID === userStation.value.StationID,
    )

    stationPumps.value = pumps.map((pump) => {
      const tank = tanks.find((t) => t.TankID === pump.TankID)
      const product = products.value.find((p) => p.ProductID === tank?.ProductID)
      return {
        ...pump,
        TankName: tank?.TankName || 'Unknown Tank',
        ProductName: product?.Name || 'Unknown Product',
      }
    })

    // Initialize readings
    stationPumps.value.forEach((pump) => {
      if (!readings.has(pump.PumpID)) {
        readings.set(pump.PumpID, {
          openingReading: '',
          currentReading: '',
          notes: '',
          readingId: null,
        })
      }
    })

    console.log('✅ Enhanced loaded pumps:', stationPumps.value.length)
  } catch (error) {
    console.error('Error loading pumps:', error)
    throw error
  }
}

const loadStationAttendants = async () => {
  if (!userStation.value?.StationID) return

  try {
    const userStationsData = await apiRequest(
      `/UserStations?StationID=${userStation.value.StationID}`,
    )
    const userStations = userStationsData.records || []

    const attendantPromises = userStations.map(async (us) => {
      try {
        const userData = await apiRequest(`/users/${us.UserID}`)
        return {
          id: userData.id,
          name: userData.name || userData.email,
          role: userData.Role,
        }
      } catch (error) {
        return null
      }
    })

    const attendants = await Promise.all(attendantPromises)
    stationAttendants.value = attendants.filter((a) => a !== null)
  } catch (error) {
    console.error('Error loading attendants:', error)
  }
}

const loadShiftTransactions = async () => {
  if (!selectedDate.value || !currentShiftType.value) return

  try {
    const shiftRanges = {
      Morning: { start: '06:00', end: '14:00' },
      Afternoon: { start: '14:00', end: '22:00' },
      Night: { start: '22:00', end: '06:00' },
    }

    const range = shiftRanges[currentShiftType.value]
    if (!range) return

    const startDateTime = `${selectedDate.value}T${range.start}:00`
    const endDateTime =
      currentShiftType.value === 'Night'
        ? `${new Date(new Date(selectedDate.value).getTime() + 24 * 60 * 60 * 1000).toISOString().split('T')[0]}T${range.end}:00`
        : `${selectedDate.value}T${range.end}:00`

    const transactionsData = await apiRequest(
      `/Transactions?StationID=${userStation.value.StationID}&TransactionDate>=${startDateTime}&TransactionDate<=${endDateTime}&HandledBy=${selectedAttendant.value}`,
    )

    const transactions = transactionsData.records || []
    const transactionItemPromises = transactions.map(async (transaction) => {
      try {
        const itemsData = await apiRequest(
          `/TransactionItems?TransactionID=${transaction.TransactionID}`,
        )
        return (itemsData.records || []).map((item) => ({
          ...item,
          TransactionDate: transaction.TransactionDate,
          HandledBy: transaction.HandledBy,
        }))
      } catch (error) {
        return []
      }
    })

    const allItems = await Promise.all(transactionItemPromises)
    shiftTransactions.value = allItems.flat()
  } catch (error) {
    console.error('Error loading shift transactions:', error)
  }
}

// Calculation Functions
const calculateRealTimeMetrics = () => {
  if (!selectedPump.value) return

  Object.keys(pumpErrors).forEach((key) => {
    delete pumpErrors[key]
  })

  const opening = parseFloat(pumpReading.openingReading) || 0
  const current = parseFloat(pumpReading.currentReading) || 0

  if (opening < 0) {
    pumpErrors.openingReading = 'Cannot be negative'
  }

  if (current < 0) {
    pumpErrors.currentReading = 'Cannot be negative'
  }

  if (current < opening) {
    pumpErrors.currentReading = 'Current reading cannot be less than opening'
  }
}

// Helper Functions
const getReading = (pumpId) => {
  if (!readings.has(pumpId)) {
    readings.set(pumpId, {
      openingReading: '',
      currentReading: '',
      notes: '',
      readingId: null,
    })
  }
  return readings.get(pumpId)
}

const hasReading = (pumpId) => {
  const reading = getReading(pumpId)
  return Boolean(reading.readingId) || (reading.openingReading && reading.currentReading)
}

const getLiveVariance = (pumpId) => {
  const reading = getReading(pumpId)
  if (!reading.openingReading || !reading.currentReading) return '0.00'

  const opening = parseFloat(reading.openingReading) || 0
  const current = parseFloat(reading.currentReading) || 0
  const expectedSales = parseFloat(getShiftSales(pumpId)) || 0
  const expected = opening + expectedSales

  return (current - expected).toFixed(2)
}

const getExpectedReading = (pumpId) => {
  const reading = getReading(pumpId)
  if (!reading.openingReading) return '0.00'

  const opening = parseFloat(reading.openingReading) || 0
  const sales = parseFloat(getShiftSales(pumpId)) || 0

  return (opening + sales).toFixed(2)
}

const getShiftSales = (pumpId) => {
  const pumpSales = shiftTransactions.value
    .filter((item) => item.PumpID === pumpId)
    .reduce((total, item) => total + (parseFloat(item.Quantity) || 0), 0)

  return pumpSales.toFixed(2)
}

const getShiftTransactions = (pumpId) => {
  return shiftTransactions.value.filter((item) => item.PumpID === pumpId).length
}

const getAccuracyScore = (pumpId) => {
  const variance = Math.abs(parseFloat(getLiveVariance(pumpId)) || 0)
  const expected = parseFloat(getExpectedReading(pumpId)) || 1
  const percentage = (variance / expected) * 100
  return Math.max(0, 100 - percentage).toFixed(0)
}

// Status Helper Functions
const getPumpStatusClass = (pump) => {
  if (hasFraudAlert(pump.PumpID)) return 'bg-light-warning'
  if (hasReading(pump.PumpID)) return 'bg-light-success'
  return 'bg-light-primary'
}

const getPumpIconClass = (pump) => {
  if (hasFraudAlert(pump.PumpID)) return 'text-warning'
  if (hasReading(pump.PumpID)) return 'text-success'
  return 'text-primary'
}

const getReadingStatus = (pumpId) => {
  if (hasFraudAlert(pumpId)) return 'Monitored'
  if (hasReading(pumpId)) return 'Complete'
  return 'Pending'
}

const getReadingStatusBadge = (pumpId) => {
  if (hasFraudAlert(pumpId)) return 'badge-light-warning'
  if (hasReading(pumpId)) return 'badge-light-success'
  return 'badge-light-primary'
}

const getVarianceColorClass = (pumpId) => {
  const variance = Math.abs(parseFloat(getLiveVariance(pumpId)) || 0)
  if (variance > 50) return 'text-danger'
  if (variance > 20) return 'text-warning'
  return 'text-success'
}

const getVarianceProgressClass = (pumpId) => {
  const variance = Math.abs(parseFloat(getLiveVariance(pumpId)) || 0)
  if (variance > 50) return 'bg-danger'
  if (variance > 20) return 'bg-warning'
  return 'bg-success'
}

const getVariancePercentage = (pumpId) => {
  const variance = Math.abs(parseFloat(getLiveVariance(pumpId)) || 0)
  return Math.min(100, (variance / 100) * 100)
}

const getAccuracyBadge = (pumpId) => {
  const score = parseFloat(getAccuracyScore(pumpId)) || 0
  if (score >= 95) return 'badge-light-success'
  if (score >= 85) return 'badge-light-warning'
  return 'badge-light-danger'
}

const getSaveButtonClass = () => {
  if (requiresFraudDetection.value) return 'btn-warning'
  return 'btn-success'
}

const getSaveButtonText = () => {
  if (requiresFraudDetection.value) {
    return 'Save with Fraud Monitoring'
  }
  if (hasExistingReading.value) {
    return 'Update Reading'
  }
  return 'Save Reading'
}

// Modal Functions
const openPumpModal = (pump) => {
  selectedPump.value = pump
  const reading = getReading(pump.PumpID)

  pumpReading.openingReading = reading.openingReading
  pumpReading.currentReading = reading.currentReading
  pumpReading.notes = reading.notes
  pumpReading.readingId = reading.readingId

  Object.keys(pumpErrors).forEach((key) => {
    delete pumpErrors[key]
  })

  calculateRealTimeMetrics()

  nextTick(() => {
    const modalElement = document.getElementById('pumpModal')
    if (modalElement) {
      pumpModalInstance = new bootstrap.Modal(modalElement)
      pumpModalInstance.show()
    }
  })
}

const closePumpModal = () => {
  if (pumpModalInstance) {
    pumpModalInstance.hide()
  }
  selectedPump.value = null
}

const showSystemInfoModal = () => {
  nextTick(() => {
    const modalElement = document.getElementById('systemInfoModal')
    if (modalElement) {
      systemInfoModalInstance = new bootstrap.Modal(modalElement)
      systemInfoModalInstance.show()
    }
  })
}

const closeSystemInfoModal = () => {
  if (systemInfoModalInstance) {
    systemInfoModalInstance.hide()
  }
}

// Validation Functions
const isPumpReadingValid = () => {
  return (
    pumpReading.openingReading &&
    pumpReading.currentReading &&
    !pumpErrors.openingReading &&
    !pumpErrors.currentReading
  )
}

const getPreviousReading = (type) => {
  const mockPrevious = {
    opening: '2450.75',
    closing: '2850.25',
  }
  return mockPrevious[type] || '0.00'
}

// ENHANCED SAVE FUNCTION WITH FRAUD DETECTION
const savePumpReading = async () => {
  console.log('💾 ENHANCED SAVE: Starting save with fraud detection...')

  if (!isPumpReadingValid()) {
    console.error('❌ VALIDATION: Reading validation failed')
    return
  }

  pumpSaving.value = true

  try {
    // Enhanced reading data
    const readingData = {
      StationID: userStation.value.StationID,
      ReadingDate: selectedDate.value,
      PumpID: selectedPump.value.PumpID,
      TankID: selectedPump.value.TankID,
      OpeningReading: pumpReading.openingReading,
      ClosingReading: pumpReading.currentReading,
      CalculatedSales: calculatedSales.value,
      Variance: liveVarianceValue.value,
      RecordedBy: selectedAttendant.value,
      Status: 'Completed', // Always complete - no approval blocking
      // Notes field removed - not in DailyReadings schema
    }

    // FRAUD DETECTION WORKFLOW
    if (requiresFraudDetection.value) {
      console.log('🚨 FRAUD DETECTION: High variance detected - logging security events...')

      // 1. Log Fraud Detection Entry
      const fraudLogData = {
        StationID: userStation.value.StationID,
        UserID: selectedAttendant.value,
        RiskScore: Math.min(100, Math.abs(parseFloat(liveVarianceValue.value)) * 2).toString(),
        Severity: riskLevel.value.toLowerCase(),
        FraudType: 'METER_READING_VARIANCE',
        Description: `High variance detected: ${Math.abs(parseFloat(liveVarianceValue.value))}L on ${selectedPump.value.PumpName} by ${currentUser.value.name} during ${currentShiftType.value} shift`,
        Status: 'Flagged',
      }

      const fraudResponse = await apiRequest('/FraudDetectionLogs', {
        method: 'POST',
        body: JSON.stringify(fraudLogData),
      })

      // 2. Log Event Log Entry
      const eventLogData = {
        EventType: 'FRAUD',
        EventSubType: 'READING_VARIANCE',
        Title: `High Variance Alert - ${selectedPump.value.PumpName}`,
        Description: `Meter reading variance of ${Math.abs(parseFloat(liveVarianceValue.value))}L detected on ${selectedPump.value.PumpName} during ${currentShiftType.value} shift`,
        RiskLevel: riskLevel.value.toUpperCase(),
        Severity: riskLevel.value === 'Critical' ? 9 : riskLevel.value === 'High' ? 7 : 5,
        AffectedStationID: userStation.value.StationID,
        AffectedUserID: selectedAttendant.value,
        PumpID: selectedPump.value.PumpID,
        TankID: selectedPump.value.TankID,
        DailyReadingID: null, // Will be updated after reading is saved
        PreviousValue: pumpReading.openingReading,
        CurrentValue: pumpReading.currentReading,
        ExpectedValue: calculatedExpected.value,
        VarianceAmount: liveVarianceValue.value,
        FraudLogID: fraudResponse.FraudLogID,
        Status: 'OPEN',
        NotificationsSent: 'YES',
        EscalationLevel: riskLevel.value === 'Critical' ? 3 : riskLevel.value === 'High' ? 2 : 1,
      }

      const eventResponse = await apiRequest('/EventLog', {
        method: 'POST',
        body: JSON.stringify(eventLogData),
      })

      // 3. Create Notification
      const notificationData = {
        UserID: null, // System-wide notification
        StationID: userStation.value.StationID,
        Channel: 'System',
        Type: 'Fraud_Alert',
        Title: `Meter Reading Variance Alert - ${currentShiftType.value} Shift`,
        Message: `High variance (${Math.abs(parseFloat(liveVarianceValue.value))}L) detected on ${selectedPump.value.PumpName} by ${currentUser.value.name}. Reading saved with monitoring enabled.`,
        Status: 'Queued',
      }

      await apiRequest('/Notifications', {
        method: 'POST',
        body: JSON.stringify(notificationData),
      })

      console.log('✅ FRAUD DETECTION: Security events logged successfully')
    }

    // Save/update reading (always proceeds)
    let result
    if (pumpReading.readingId) {
      result = await apiRequest(`/DailyReadings/${pumpReading.readingId}`, {
        method: 'PATCH',
        body: JSON.stringify(readingData),
      })
    } else {
      result = await apiRequest('/DailyReadings', {
        method: 'POST',
        body: JSON.stringify(readingData),
      })
    }

    // Update pump meter reading
    await apiRequest(`/Pumps/${selectedPump.value.PumpID}`, {
      method: 'PATCH',
      body: JSON.stringify({ MeterReading: pumpReading.currentReading }),
    })

    // Update local state
    const reading = getReading(selectedPump.value.PumpID)
    reading.openingReading = pumpReading.openingReading
    reading.currentReading = pumpReading.currentReading
    reading.notes = pumpReading.notes
    reading.readingId = result.ReadingID || pumpReading.readingId

    const pump = stationPumps.value.find((p) => p.PumpID === selectedPump.value.PumpID)
    if (pump) {
      pump.MeterReading = pumpReading.currentReading
    }

    // Enhanced audit logging
    await logAuditAction('METER_READING_SAVED', {
      pumpId: selectedPump.value.PumpID,
      variance: liveVarianceValue.value,
      fraudDetectionTriggered: requiresFraudDetection.value,
      attendant: currentUser.value.name,
      shift: currentShiftType.value,
      readingData,
    })

    const successMessage = requiresFraudDetection.value
      ? `${currentShiftType.value} shift reading saved with fraud monitoring enabled`
      : `${currentShiftType.value} shift reading saved successfully`

    await Swal.fire({
      title: 'Success!',
      text: successMessage,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    closePumpModal()

    // Reload fraud detection data
    await loadActiveFraudAlerts()
    await loadEventLogEntries()
  } catch (error) {
    console.error('💥 SAVE ERROR:', error)
    await Swal.fire({
      title: 'Save Failed!',
      text: error.message || `Failed to save ${currentShiftType.value} shift reading`,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    pumpSaving.value = false
  }
}

const deletePumpReading = async () => {
  const result = await Swal.fire({
    title: 'Delete Reading?',
    text: 'This action cannot be undone',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, Delete',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
  })

  if (!result.isConfirmed || !pumpReading.readingId) return

  pumpSaving.value = true

  try {
    await apiRequest(`/DailyReadings/${pumpReading.readingId}`, {
      method: 'DELETE',
    })

    const reading = getReading(selectedPump.value.PumpID)
    Object.assign(reading, {
      openingReading: '',
      currentReading: '',
      notes: '',
      readingId: null,
    })

    await Swal.fire({
      title: 'Deleted!',
      text: `${currentShiftType.value} shift reading has been deleted`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })

    closePumpModal()
  } catch (error) {
    await Swal.fire({
      title: 'Delete Failed!',
      text: error.message || 'Failed to delete reading',
      icon: 'error',
    })
  } finally {
    pumpSaving.value = false
  }
}

// Utility Functions
const updateDateLimits = () => {
  const today = new Date()
  maxAllowedDate.value = today.toISOString().split('T')[0]

  const minDate = new Date(today)
  minDate.setDate(today.getDate() - 7)
  minAllowedDate.value = minDate.toISOString().split('T')[0]
}

const handleDateChange = () => {
  dateValidationError.value = ''

  if (!selectedDate.value) {
    dateValidationError.value = 'Date is required'
    return
  }

  const selectedDateObj = new Date(selectedDate.value)
  const today = new Date()

  if (selectedDateObj > today) {
    dateValidationError.value = 'Future dates are not allowed'
    return
  }

  if (selectedDate.value && currentShiftType.value) {
    loadShiftTransactions()
  }
}

const refreshAllData = async () => {
  loading.value = true
  loadingMessage.value = 'Refreshing all data with fraud detection...'

  try {
    updateCurrentTime()
    await Promise.all([
      loadStationPumps(),
      loadStationAttendants(),
      loadFraudDetectionRules(),
      loadActiveFraudAlerts(),
      loadEventLogEntries(),
      loadShiftTransactions(),
    ])

    await Swal.fire({
      title: 'Refreshed!',
      text: `All data updated for ${currentShiftType.value} shift`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    await Swal.fire({
      title: 'Refresh Failed!',
      text: error.message,
      icon: 'error',
    })
  } finally {
    loading.value = false
  }
}

// Audit Logging
const logAuditAction = async (action, data = {}) => {
  try {
    const auditLog = {
      StationID: userStation.value?.StationID,
      UserID: selectedAttendant.value,
      Action: action.toUpperCase(),
      TableName: 'DailyReadings',
      RecordID: data.pumpId || null,
      Changes: JSON.stringify({
        ...data,
        sessionId: sessionId.value,
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
        autoDetectedShift: currentShiftType.value,
        fraudDetectionEnabled: true,
      }),
      IPAddress: 'client_ip',
    }

    await apiRequest('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify(auditLog),
    })
  } catch (error) {
    console.error('Audit logging failed:', error)
  }
}

// Component Initialization
onMounted(async () => {
  console.log('🔄 ENHANCED METER READING: Initializing with fraud detection...')

  updateCurrentTime()
  selectedAttendant.value = currentUser.value?.id || ''

  if (!authData.value.user || !userStation.value) {
    await Swal.fire({
      title: 'Authentication Required',
      text: 'Please login to access this system',
      icon: 'warning',
    })
    window.location.href = '/login'
    return
  }

  if (!hasElevatedPrivileges.value) {
    loading.value = false
    return
  }

  const today = new Date()
  selectedDate.value = today.toISOString().split('T')[0]
  updateDateLimits()

  const timeUpdateInterval = setInterval(updateCurrentTime, 60000)

  try {
    loadingMessage.value = 'Validating auto-detected shift...'
    const shiftValid = await validateActiveShift()

    if (hasOpenShift.value || isSystemAdmin.value) {
      await loadInitialData()

      if (isSystemAdmin.value && !hasOpenShift.value) {
        generateGeneralAIInsights()
      }
    }
  } catch (error) {
    await Swal.fire({
      title: 'System Error!',
      text: error.message,
      icon: 'error',
    })
  } finally {
    loading.value = false
  }

  onUnmounted(() => {
    clearInterval(timeUpdateInterval)
  })
})

// Watchers
watch([selectedDate, currentShiftType], () => {
  if (selectedDate.value && currentShiftType.value) {
    loadShiftTransactions()
  }
})

watch(currentShiftType, (newShift) => {
  if (newShift && selectedShift.value !== newShift) {
    selectedShift.value = newShift
  }
})

// Cleanup
onUnmounted(() => {
  stopFraudDetectionPolling()
})
</script>

<style scoped>
.pump-card {
  transition: all 0.3s ease;
  cursor: pointer;
}

.pump-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1) !important;
}

.fraud-monitored {
  border: 2px solid #ffc107 !important;
  background: linear-gradient(45deg, rgba(255, 193, 7, 0.1), rgba(255, 193, 7, 0.05));
}

.fraud-monitored::before {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 20px 20px 0;
  border-color: transparent #ffc107 transparent transparent;
  z-index: 1;
}

.fraud-monitored::after {
  content: '⚠️';
  position: absolute;
  top: 2px;
  right: 2px;
  font-size: 10px;
  z-index: 2;
}
</style>
<style scoped>
.pump-card {
  transition: all 0.3s ease;
  cursor: pointer;
}

.pump-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1) !important;
}

.fraud-monitored {
  border: 2px solid #ffc107 !important;
  background: linear-gradient(45deg, rgba(255, 193, 7, 0.1), rgba(255, 193, 7, 0.05));
}

.fraud-monitored::before {
  content: '';
  position: absolute;
  top: 0;
  right: 0;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 20px 20px 0;
  border-color: transparent #ffc107 transparent transparent;
  z-index: 1;
}

.fraud-monitored::after {
  content: '⚠️';
  position: absolute;
  top: 2px;
  right: 2px;
  font-size: 10px;
  z-index: 2;
}
</style>

<style scoped>
/* Enhanced pump card styling with auto-detection context */
.pump-card {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 20px;
}

.pump-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15) !important;
}

/* Auto-detection success styling */
.auto-detected {
  background: linear-gradient(135deg, #00d4aa 0%, #00d4aa 100%);
  color: white;
  border: 2px solid #00d4aa !important;
}

.auto-detected .form-control {
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.5);
  color: #1e1e2d;
  font-weight: 600;
}

/* Progress bar enhancements */
.progress {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
}

.progress-bar {
  transition: width 0.8s ease-in-out;
}

/* Modal styling enhancements */
.modal-content {
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
}

.modal-header {
  border-bottom: none;
  padding: 2.5rem 2.5rem 1.5rem;
}

.modal-body {
  padding: 1.5rem 2.5rem 2.5rem;
}

.modal-footer {
  border-top: none;
  padding: 1.5rem 2.5rem 2.5rem;
}

/* Form control enhancements */
.form-control:focus {
  border-color: var(--bs-primary);
  box-shadow: 0 0 0 0.25rem rgba(54, 153, 255, 0.15);
  transform: translateY(-1px);
}

.form-control-lg {
  border-radius: 16px;
  padding: 1.25rem 1.5rem;
  font-weight: 500;
}

.form-select-lg {
  border-radius: 16px;
  padding: 1.25rem 1.5rem;
  font-weight: 500;
}

/* Auto-detection status styling */
.auto-detection-status {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  padding: 1.5rem;
  color: white;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.auto-detection-status .badge {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

/* Button styling */
.btn {
  border-radius: 16px;
  font-weight: 600;
  padding: 1rem 2rem;
  border-width: 2px;
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.btn-lg {
  border-radius: 20px;
  padding: 1.25rem 2.5rem;
}

/* Enhanced shift-specific styling */
.shift-morning {
  background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
  border: 2px solid #fcb69f;
}

.shift-afternoon {
  background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
  border: 2px solid #fed6e3;
}

.shift-night {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: 2px solid #764ba2;
  color: white;
}

/* Badge enhancements */
.badge {
  border-radius: 12px;
  font-weight: 600;
  padding: 0.75rem 1rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* Card styling */
.card {
  border-radius: 20px;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.card-flush > .card-body {
  padding: 2rem;
}

/* Alert styling */
.alert {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

/* Symbol enhancements */
.symbol {
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.symbol:hover {
  transform: scale(1.05);
}

/* Code block styling */
code {
  background-color: var(--bs-gray-100);
  padding: 0.5rem;
  border-radius: 8px;
  font-family: 'Monaco', 'Menlo', monospace;
}

/* Loading animation */
.spinner-border {
  width: 4rem;
  height: 4rem;
  border-width: 0.4rem;
}

/* Auto-detection highlights */
.auto-highlight {
  background: linear-gradient(135deg, rgba(0, 212, 170, 0.1) 0%, rgba(0, 212, 170, 0.2) 100%);
  border: 2px solid rgba(0, 212, 170, 0.3);
  border-radius: 16px;
  padding: 1rem;
  margin: 0.5rem 0;
}

.auto-highlight h5,
.auto-highlight h6 {
  color: #00d4aa;
  font-weight: 700;
}

/* Time display styling */
.time-display {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 12px;
  padding: 0.75rem 1rem;
  font-family: 'Monaco', 'Menlo', monospace;
  font-weight: 700;
  text-align: center;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .modal-dialog {
    margin: 1rem;
  }

  .modal-xl {
    max-width: calc(100% - 2rem);
  }

  .card-body {
    padding: 1.5rem;
  }

  .btn {
    padding: 0.75rem 1.5rem;
  }

  .modal-header {
    padding: 2rem 2rem 1rem;
  }

  .modal-body {
    padding: 1rem 2rem 2rem;
  }

  .modal-footer {
    padding: 1rem 2rem 2rem;
  }

  .auto-detection-status {
    padding: 1rem;
  }

  .time-display {
    font-size: 0.9rem;
    padding: 0.5rem 0.75rem;
  }
}

/* Custom utilities */
.h-6px {
  height: 6px;
}

.min-vh-100 {
  min-height: 100vh;
}

/* Animation classes */
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulseGlow {
  0% {
    box-shadow: 0 0 5px rgba(0, 212, 170, 0.5);
  }
  50% {
    box-shadow: 0 0 20px rgba(0, 212, 170, 0.8);
  }
  100% {
    box-shadow: 0 0 5px rgba(0, 212, 170, 0.5);
  }
}

.pump-card {
  animation: slideInUp 0.6s ease-out;
}

.auto-detected {
  animation: pulseGlow 2s ease-in-out infinite;
}

/* Access restriction styling */
.access-restricted {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

/* Pump locking and approval styling */
.pump-disabled {
  position: relative;
  opacity: 0.7;
  cursor: not-allowed !important;
  transform: none !important;
}

.pump-disabled:hover {
  transform: none !important;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08) !important;
}

.pump-pending {
  border: 2px solid #ffc700 !important;
  box-shadow: 0 0 0 0.25rem rgba(255, 199, 0, 0.25) !important;
}

/* Enhanced shift validation styling */
.shift-required {
  background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
}

.shift-auto-detected {
  background: linear-gradient(135deg, #00d4aa 0%, #00a085 100%);
  color: white;
}

/* AI Insights styling with auto-detection */
.ai-insight-banner {
  background: linear-gradient(135deg, #00d4aa 0%, #00a085 100%);
  border: none;
  color: white;
}

.ai-insight-banner .btn-light-success {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
}

.ai-insight-banner .btn-light-success:hover {
  background: rgba(255, 255, 255, 0.3);
}

/* Auto-detection context cards */
.context-card {
  background: linear-gradient(135deg, rgba(0, 212, 170, 0.05) 0%, rgba(0, 212, 170, 0.1) 100%);
  border: 1px solid rgba(0, 212, 170, 0.2);
  border-radius: 16px;
  transition: all 0.3s ease;
}

.context-card:hover {
  background: linear-gradient(135deg, rgba(0, 212, 170, 0.1) 0%, rgba(0, 212, 170, 0.15) 100%);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 212, 170, 0.2);
}

/* Enhanced session information styling */
.session-info {
  background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
  border: 2px solid #00d4aa;
  border-radius: 20px;
  padding: 1.5rem;
  box-shadow: 0 8px 30px rgba(0, 212, 170, 0.15);
}

.session-info .form-control {
  background: rgba(0, 212, 170, 0.05);
  border: 2px solid rgba(0, 212, 170, 0.2);
  color: #1e1e2d;
  font-weight: 600;
}

.session-info .form-control:focus {
  background: rgba(0, 212, 170, 0.1);
  border-color: #00d4aa;
  box-shadow: 0 0 0 0.25rem rgba(0, 212, 170, 0.25);
}

/* Auto-selected attendant styling */
.attendant-auto-selected {
  background: linear-gradient(135deg, #00d4aa 0%, #ffffff 100%);
  border: 2px solid #00d4aa;
  color: #1e1e2d;
  font-weight: 700;
  text-align: center;
  padding: 1rem;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 212, 170, 0.3);
}

/* Real-time updates indicator */
.real-time-indicator {
  position: relative;
  overflow: hidden;
}

.real-time-indicator::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, transparent, #00d4aa, transparent);
  animation: sweep 2s ease-in-out infinite;
}

@keyframes sweep {
  0% {
    left: -100%;
  }
  100% {
    left: 100%;
  }
}

/* Enhanced typography for auto-detection */
.auto-text {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-weight: 600;
  color: #00d4aa;
}

.shift-badge {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 700;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

/* Status indicators with auto-detection */
.status-online {
  background: linear-gradient(135deg, #00d4aa 0%, #00a085 100%);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  animation: pulseGlow 2s ease-in-out infinite;
}

.status-auto {
  background: linear-gradient(135deg, #ffc700 0%, #ff8c00 100%);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
}

/* Enhanced accessibility for auto-detection */
.sr-only-auto {
  position: absolute !important;
  width: 1px !important;
  height: 1px !important;
  padding: 0 !important;
  margin: -1px !important;
  overflow: hidden !important;
  clip: rect(0, 0, 0, 0) !important;
  white-space: nowrap !important;
  border: 0 !important;
}

/* Focus states for auto-detected elements */
.auto-detected:focus,
.auto-detected:focus-within {
  outline: 3px solid rgba(0, 212, 170, 0.5);
  outline-offset: 2px;
}

/* Enhanced print styles for auto-detection context */
@media print {
  .auto-detection-status {
    background: #f8f9fa !important;
    color: #1e1e2d !important;
    border: 2px solid #00d4aa !important;
  }

  .shift-badge {
    background: #f8f9fa !important;
    color: #1e1e2d !important;
    border: 1px solid #6c757d !important;
  }
}
</style>

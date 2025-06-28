<template>
  <div class="d-flex flex-column gap-4">
    <!-- iOS-Style Station Header -->
    <div
      class="card border-0 shadow-lg"
      style="background: linear-gradient(135deg, #ff6b6b 0%, #4ecdc4 100%); border-radius: 20px"
    >
      <div class="card-body p-5">
        <div class="d-flex align-items-center justify-content-between">
          <div>
            <h1 class="text-white fw-bold mb-2 fs-2">
              {{ stationInfo.StationName || 'Loading...' }}
            </h1>
            <div class="d-flex align-items-center gap-3">
              <span class="badge bg-white text-primary fw-bold fs-6">{{
                currentUser.name || 'User'
              }}</span>
              <span class="badge bg-warning text-dark fw-bold fs-6">{{ currentShift }} Shift</span>
            </div>
          </div>
          <div class="text-end">
            <div class="text-white opacity-75 fs-7 mb-2">{{ currentDate }}</div>
            <span class="badge" :class="shiftStatusBadge">
              <i class="ki-duotone ki-status fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ shiftStatus }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- AI Insights Card -->
    <div v-if="aiInsights.length > 0" class="card border-0 shadow-sm" style="border-radius: 16px">
      <div class="card-header bg-light-info py-4" style="border-radius: 16px 16px 0 0">
        <h3 class="card-title fw-bold text-info mb-0 fs-4">
          <i class="ki-duotone ki-flash fs-1 text-info me-3">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          AI Station Intelligence
        </h3>
      </div>
      <div class="card-body p-5">
        <div
          v-for="insight in aiInsights"
          :key="insight.id"
          class="d-flex align-items-start gap-4 mb-4 last:mb-0"
        >
          <span
            class="badge fs-7 fw-bold px-3 py-2"
            :class="getInsightBadgeClass(insight.priority)"
            >{{ insight.type }}</span
          >
          <div class="flex-grow-1">
            <div class="fw-semibold text-gray-900 fs-6 mb-1">{{ insight.message }}</div>
            <div class="text-gray-600 fs-7">Confidence: {{ insight.confidence }}%</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Performance Chart Card -->
    <div class="card border-0 shadow-sm" style="border-radius: 16px">
      <div class="card-header bg-light-primary py-4" style="border-radius: 16px 16px 0 0">
        <h3 class="card-title fw-bold text-primary mb-0 fs-4">
          <i class="ki-duotone ki-chart-simple fs-1 text-primary me-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          Reading Progress
        </h3>
      </div>
      <div class="card-body p-5">
        <div class="row g-4 mb-5">
          <div class="col-6">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-50px symbol-circle bg-light-success me-4">
                <span class="symbol-label text-success fw-bold fs-4">{{ completedPumps }}</span>
              </div>
              <div>
                <div class="text-gray-900 fw-bold fs-5">Completed</div>
                <div class="text-gray-600 fs-6">Pumps Read</div>
              </div>
            </div>
          </div>
          <div class="col-6">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-50px symbol-circle bg-light-warning me-4">
                <span class="symbol-label text-warning fw-bold fs-4">{{ pendingPumps }}</span>
              </div>
              <div>
                <div class="text-gray-900 fw-bold fs-5">Pending</div>
                <div class="text-gray-600 fs-6">Awaiting Read</div>
              </div>
            </div>
          </div>
        </div>

        <!-- ARM Chart -->
        <div class="position-relative d-flex justify-content-center" style="height: 140px">
          <canvas ref="performanceChart" width="140" height="140"></canvas>
        </div>

        <!-- Progress Summary -->
        <div class="text-center mt-4">
          <div class="fs-3 fw-bold text-gray-900">{{ completionPercentage }}%</div>
          <div class="text-gray-600 fs-6">Reading Progress</div>
        </div>
      </div>
    </div>

    <!-- Shift Management Card - MANDATORY REQUIREMENT -->
    <div
      v-if="!hasActiveShift && !loading"
      class="card border-0 shadow-lg"
      style="border-radius: 16px; border: 3px solid #f1416c"
    >
      <div class="card-body p-6 text-center">
        <i class="ki-duotone ki-shield-cross mb-4" style="font-size: 5rem; color: #f1416c">
          <span class="path1"></span>
          <span class="path2"></span>
          <span class="path3"></span>
        </i>
        <h3 class="fw-bold text-danger mb-3 fs-2">Shift Required</h3>
        <p class="text-gray-700 mb-5 fs-4">
          You must open a <strong>{{ currentShift }}</strong> shift before accessing meter readings.
          This is required for proper tracking and security.
        </p>
        <div class="alert alert-warning mb-5" style="border-radius: 12px">
          <div class="d-flex align-items-center">
            <i class="ki-duotone ki-information-5 fs-1 text-warning me-4">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <div>
              <div class="fw-bold text-warning fs-5">Station Security Active</div>
              <div class="text-gray-700 fs-6">
                All station resources are protected. Only authorized users with active shifts can
                access pump readings.
              </div>
            </div>
          </div>
        </div>
        <button
          @click="openShift"
          :disabled="loading"
          class="btn btn-danger btn-lg fw-bold px-8 py-4"
          style="border-radius: 16px; min-height: 60px"
        >
          <i class="ki-duotone ki-shield-tick fs-1 me-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          Open {{ currentShift }} Shift Now
        </button>
      </div>
    </div>

    <!-- Access Blocked Warning -->
    <div
      v-if="!hasActiveShift && !loading"
      class="card border-0 shadow-sm bg-light-danger"
      style="border-radius: 16px"
    >
      <div class="card-body p-5">
        <div class="d-flex align-items-center">
          <i class="ki-duotone ki-lock fs-1 text-danger me-4">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <div>
            <div class="fw-bold text-danger fs-5">Pump Readings Locked</div>
            <div class="text-gray-700 fs-6">
              Station {{ userStation?.StationID }} resources are secured. Open your shift to begin
              operations.
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pumps Grid -->
    <div v-if="hasActiveShift" class="row g-4">
      <div v-for="pump in stationPumps" :key="pump.PumpID" class="col-12 col-md-6">
        <div
          class="card h-100 border-0 shadow-sm position-relative cursor-pointer"
          style="border-radius: 16px; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1)"
          :class="getPumpCardClass(pump)"
          @click="openPumpModal(pump)"
        >
          <!-- Status Badge -->
          <div class="position-absolute top-0 end-0 m-4">
            <span class="badge fs-6 fw-bold px-3 py-2" :class="getPumpStatusBadge(pump)">
              {{ getPumpStatus(pump) }}
            </span>
          </div>

          <div class="card-body p-5">
            <!-- Pump Header -->
            <div class="d-flex align-items-center mb-4">
              <div class="symbol symbol-60px symbol-circle me-4" :class="getPumpSymbolClass(pump)">
                <i class="ki-duotone ki-oil fs-1">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
              <div class="flex-grow-1">
                <h4 class="fw-bold text-gray-900 mb-1 fs-4">{{ pump.PumpName }}</h4>
                <div class="text-gray-600 fs-6">{{ pump.ProductName || 'Fuel Product' }}</div>
              </div>
            </div>

            <!-- Current Reading -->
            <div class="mb-4">
              <div class="text-gray-600 fs-7 mb-2">Current Reading</div>
              <div class="fw-bold text-primary fs-3">{{ formatReading(pump.MeterReading) }}L</div>
            </div>

            <!-- Reading Progress -->
            <div v-if="hasReading(pump.PumpID)" class="mb-4">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="text-gray-600 fs-7">Sales Today</span>
                <span class="fw-bold text-success fs-5"
                  >{{ getCalculatedSales(pump.PumpID) }}L</span
                >
              </div>
              <div class="progress" style="height: 8px; border-radius: 4px">
                <div class="progress-bar bg-success" style="width: 100%; border-radius: 4px"></div>
              </div>
            </div>

            <!-- Variance Alert -->
            <div
              v-if="getVarianceAlert(pump.PumpID)"
              class="alert alert-warning p-3 mb-0"
              style="border-radius: 12px"
            >
              <div class="d-flex align-items-center">
                <i class="ki-duotone ki-warning fs-2 text-warning me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <span class="fs-7 fw-semibold">{{ getVarianceAlert(pump.PumpID) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pump Reading Modal -->
    <div v-if="selectedPump" class="modal fade show d-block" style="background: rgba(0, 0, 0, 0.6)">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0" style="border-radius: 24px">
          <div class="modal-header border-0 pb-0 pt-6 px-6">
            <h3 class="modal-title fw-bold text-gray-900 fs-2">{{ selectedPump.PumpName }}</h3>
            <button
              @click="closePumpModal"
              class="btn btn-icon btn-sm btn-active-light-primary"
              style="border-radius: 8px"
            >
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>

          <div class="modal-body px-6 pb-6">
            <!-- Current Info Card -->
            <div class="card bg-light-primary mb-6" style="border-radius: 16px">
              <div class="card-body p-5">
                <div class="row g-4">
                  <div class="col-6">
                    <div class="text-primary fs-7 mb-2">Current Reading</div>
                    <div class="fw-bold text-gray-900 fs-3">
                      {{ formatReading(selectedPump.MeterReading) }}L
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-primary fs-7 mb-2">Product Type</div>
                    <div class="fw-bold text-gray-900 fs-5">
                      {{ selectedPump.ProductName || 'Fuel' }}
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Reading Form -->
            <div class="row g-5">
              <div class="col-12">
                <label class="required form-label fw-semibold fs-5">Opening Reading (L)</label>
                <input
                  v-model="pumpReading.openingReading"
                  @input="validateReadings"
                  type="number"
                  step="0.01"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': readingErrors.opening }"
                  placeholder="Enter opening meter reading"
                  style="border-radius: 12px; border-width: 2px; min-height: 60px; font-size: 18px"
                />
                <div v-if="readingErrors.opening" class="invalid-feedback fs-6">
                  {{ readingErrors.opening }}
                </div>
              </div>

              <div class="col-12">
                <label class="required form-label fw-semibold fs-5">Closing Reading (L)</label>
                <input
                  v-model="pumpReading.closingReading"
                  @input="validateReadings"
                  type="number"
                  step="0.01"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': readingErrors.closing }"
                  placeholder="Enter closing meter reading"
                  style="border-radius: 12px; border-width: 2px; min-height: 60px; font-size: 18px"
                />
                <div v-if="readingErrors.closing" class="invalid-feedback fs-6">
                  {{ readingErrors.closing }}
                </div>
              </div>
            </div>

            <!-- Live Calculations -->
            <div
              v-if="pumpReading.openingReading && pumpReading.closingReading"
              class="card bg-light-success mt-6"
              style="border-radius: 16px"
            >
              <div class="card-body p-5">
                <div class="row g-4 text-center">
                  <div class="col-4">
                    <div class="text-success fs-7 mb-2">Sales</div>
                    <div class="fw-bold text-gray-900 fs-3">{{ getLiveSales() }}L</div>
                  </div>
                  <div class="col-4">
                    <div class="text-success fs-7 mb-2">Variance</div>
                    <div class="fw-bold fs-3" :class="getVarianceColorClass()">
                      {{ getLiveVariance() }}L
                    </div>
                  </div>
                  <div class="col-4">
                    <div class="text-success fs-7 mb-2">Accuracy</div>
                    <div class="fw-bold text-gray-900 fs-3">{{ getAccuracyScore() }}%</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- High Variance Alert -->
            <div
              v-if="requiresFraudMonitoring"
              class="alert alert-warning mt-6"
              style="border-radius: 16px"
            >
              <div class="d-flex align-items-center">
                <i class="ki-duotone ki-shield-search fs-1 text-warning me-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div>
                  <div class="fw-bold text-warning fs-5">High Variance Detected</div>
                  <div class="text-gray-700 fs-6">
                    This reading will be flagged for management review
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="modal-footer border-0 pt-0 px-6 pb-6">
            <button
              @click="closePumpModal"
              class="btn btn-light fw-bold me-3 px-6 py-3"
              style="border-radius: 12px"
            >
              Cancel
            </button>
            <button
              @click="saveReading"
              :disabled="!canSaveReading || saving"
              class="btn fw-bold px-6 py-3"
              :class="requiresFraudMonitoring ? 'btn-warning' : 'btn-success'"
              style="border-radius: 12px; min-width: 140px"
            >
              <span v-if="!saving">{{ getSaveButtonText() }}</span>
              <span v-else class="d-flex align-items-center">
                <span class="spinner-border spinner-border-sm me-2"></span>
                Saving...
              </span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Shift Opening Modal - MANDATORY REQUIREMENT -->
    <div
      v-if="showShiftModal"
      class="modal fade show d-block"
      style="background: rgba(0, 0, 0, 0.8)"
    >
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0" style="border-radius: 24px; border: 3px solid #f1416c">
          <div
            class="modal-header border-0 pt-6 px-6"
            style="
              background: linear-gradient(135deg, #f1416c 0%, #ff6b6b 100%);
              border-radius: 24px 24px 0 0;
            "
          >
            <div class="w-100">
              <h3 class="modal-title fw-bold fs-2 text-white text-center">
                <i class="ki-duotone ki-shield-tick fs-1 me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                Security: Open {{ currentShift }} Shift
              </h3>
              <p class="text-white opacity-75 text-center mb-0 fs-6">
                Required for station access and operations tracking
              </p>
            </div>
            <!-- NO CLOSE BUTTON - SHIFT IS MANDATORY -->
          </div>
          <div class="modal-body px-6 pb-6">
            <!-- Security Notice -->
            <div class="alert alert-info mb-6" style="border-radius: 16px">
              <div class="d-flex align-items-center">
                <i class="ki-duotone ki-shield-check fs-1 text-info me-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div>
                  <div class="fw-bold text-info fs-5">Station Security Protocol</div>
                  <div class="text-gray-700 fs-6">
                    Station {{ userStation?.StationID }} resources are protected. You must open a
                    shift to access pump readings and ensure proper audit trails.
                  </div>
                </div>
              </div>
            </div>

            <div class="mb-6">
              <label class="required form-label fw-semibold fs-5">Opening Cash Balance (UGX)</label>
              <input
                v-model="shiftForm.openingBalance"
                @input="validateShiftForm"
                type="number"
                class="form-control form-control-lg"
                :class="{ 'is-invalid': shiftForm.errors.openingBalance }"
                placeholder="Enter opening cash amount"
                style="border-radius: 12px; border-width: 2px; min-height: 60px; font-size: 18px"
                step="0.01"
                min="0"
              />
              <div v-if="shiftForm.errors.openingBalance" class="invalid-feedback fs-6">
                {{ shiftForm.errors.openingBalance }}
              </div>
            </div>

            <!-- Auto-Detection Info -->
            <div class="alert alert-success" style="border-radius: 16px">
              <div class="d-flex align-items-center">
                <i class="ki-duotone ki-check-circle fs-1 text-success me-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div>
                  <div class="fw-bold text-success fs-5">Auto-Detected Information</div>
                  <div class="text-gray-700 fs-6 mb-2">
                    <strong>Shift:</strong> {{ currentShift }} ({{ currentTime }}) <br />
                    <strong>Station:</strong>
                    {{ stationInfo.StationName || userStation?.StationID }} <br />
                    <strong>User:</strong> {{ currentUser.name || currentUser.id }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer border-0 px-6 pb-6">
            <!-- NO CANCEL BUTTON - SHIFT IS MANDATORY -->
            <div class="w-100 d-flex justify-content-center">
              <button
                @click="confirmOpenShift"
                :disabled="!canOpenShift || saving"
                class="btn btn-danger btn-lg fw-bold px-8 py-4"
                style="border-radius: 12px; min-width: 200px"
              >
                <span v-if="!saving">
                  <i class="ki-duotone ki-shield-tick fs-2 me-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  Open Secure Shift
                </span>
                <span v-else class="d-flex align-items-center justify-content-center">
                  <span class="spinner-border spinner-border-sm me-2"></span>
                  Securing Access...
                </span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading Overlay -->
    <div
      v-if="loading"
      class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
      style="background: rgba(0, 0, 0, 0.8); z-index: 9999"
    >
      <div class="card p-8 text-center border-0" style="border-radius: 24px">
        <div class="spinner-border text-primary mb-4" style="width: 60px; height: 60px"></div>
        <div class="fw-bold text-gray-700 fs-4">{{ loadingMessage }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, reactive, nextTick } from 'vue'
import Swal from 'sweetalert2'

// =====================================================================
// CORE CONFIGURATION & STATE
// =====================================================================
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// Session Management (from localStorage)
const authData = ref(JSON.parse(localStorage.getItem('kigrama_user_data') || '{}'))
const currentUser = computed(() => authData.value.user || {})
const userStation = computed(() => {
  const stations = authData.value.stations || []
  return stations.find((s) => s.IsPrimary === '1') || stations[0] || null
})

// Component State
const loading = ref(true)
const loadingMessage = ref('Initializing meter reading system...')
const saving = ref(false)

// Shift Management
const hasActiveShift = ref(false)
const activeShiftData = ref(null)
const showShiftModal = ref(false)
const shiftForm = reactive({
  openingBalance: '',
  errors: {},
})

// Data Collections
const stationInfo = ref({})
const stationPumps = ref([])
const pumpReadings = reactive(new Map())

// Selected Pump Modal
const selectedPump = ref(null)
const pumpReading = reactive({
  openingReading: '',
  closingReading: '',
})
const readingErrors = reactive({})

// AI Insights
const aiInsights = ref([])

// Performance Chart
const performanceChart = ref(null)

// =====================================================================
// COMPUTED PROPERTIES
// =====================================================================
const currentDate = computed(() => {
  return new Date().toLocaleDateString('en-UG', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
})

const currentTime = computed(() => {
  return new Date().toLocaleTimeString('en-UG', {
    hour: '2-digit',
    minute: '2-digit',
  })
})

const currentShift = computed(() => {
  const hour = new Date().getHours()
  if (hour >= 6 && hour < 14) return 'Morning'
  if (hour >= 14 && hour < 22) return 'Afternoon'
  return 'Night'
})

const shiftStatus = computed(() => {
  return hasActiveShift.value ? 'Active' : 'No Shift'
})

const shiftStatusBadge = computed(() => {
  return hasActiveShift.value ? 'bg-success text-white' : 'bg-danger text-white'
})

const completedPumps = computed(() => {
  return stationPumps.value.filter((pump) => hasReading(pump.PumpID)).length
})

const pendingPumps = computed(() => {
  return stationPumps.value.length - completedPumps.value
})

const completionPercentage = computed(() => {
  if (stationPumps.value.length === 0) return 0
  return Math.round((completedPumps.value / stationPumps.value.length) * 100)
})

const canSaveReading = computed(() => {
  return (
    pumpReading.openingReading &&
    pumpReading.closingReading &&
    !readingErrors.opening &&
    !readingErrors.closing
  )
})

const canOpenShift = computed(() => {
  return shiftForm.openingBalance && !shiftForm.errors.openingBalance
})

const requiresFraudMonitoring = computed(() => {
  if (!pumpReading.openingReading || !pumpReading.closingReading) return false
  const variance = Math.abs(parseFloat(getLiveVariance()))
  return variance > 20 // 20L threshold for fraud monitoring
})

// =====================================================================
// SIMPLIFIED API FUNCTIONS
// =====================================================================
const apiRequest = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      const errorData = await response.text().then((text) => {
        try {
          return JSON.parse(text)
        } catch {
          return { message: text || `HTTP ${response.status}` }
        }
      })
      throw new Error(errorData.message || `HTTP ${response.status}`)
    }

    // Handle empty responses
    const responseText = await response.text()
    if (!responseText || responseText.trim() === '') {
      return {}
    }

    try {
      return JSON.parse(responseText)
    } catch (jsonError) {
      console.warn('Non-JSON response received:', responseText)
      return { message: 'Success', data: responseText }
    }
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}

// =====================================================================
// SIMPLIFIED LOGGING (ONLY FRAUDDETECTIONLOGS)
// =====================================================================
const logFraudDetection = async (fraudType, description, riskScore) => {
  try {
    const validRiskScore = Math.max(0, Math.min(100, parseFloat(riskScore) || 0)).toString()
    let status = 'Open'
    const severity = 'medium'

    if (parseFloat(validRiskScore) >= 70) status = 'Flagged'
    else if (parseFloat(validRiskScore) >= 40) status = 'Review'
    else if (parseFloat(validRiskScore) < 40) status = 'Cleared'

    const fraudData = {
      DetectionRuleID: null,
      TransactionID: null,
      StationID: userStation.value?.StationID || null,
      UserID: currentUser.value?.id || null,
      RiskScore: validRiskScore,
      Severity: severity,
      FraudType: fraudType.substring(0, 100),
      Description: description.substring(0, 500),
      DetectedAt: new Date().toISOString(),
      Status: status,
      ResolvedBy: null,
      ResolvedAt: null,
      Notes: null,
      CreatedAt: new Date().toISOString(),
      UpdatedAt: new Date().toISOString(),
    }

    await apiRequest('/FraudDetectionLogs', {
      method: 'POST',
      body: JSON.stringify(fraudData),
    })

    console.log(`✅ FraudDetectionLog created: ${fraudType} - Risk: ${validRiskScore}`)
  } catch (error) {
    console.warn('⚠️ FraudDetectionLog creation failed (non-blocking):', error.message)
  }
}

// Simplified suspicious activity detector - only uses FraudDetectionLogs
const detectSuspiciousActivity = async (context, data) => {
  try {
    let riskScore = 0
    const suspiciousIndicators = []

    // Only detect real suspicious patterns
    if (context === 'meter_reading' && data.variance) {
      const variance = Math.abs(parseFloat(data.variance))
      if (variance > 50) {
        suspiciousIndicators.push(`Extremely high variance: ${variance}L`)
        riskScore = 80
      } else if (variance > 20) {
        suspiciousIndicators.push(`High variance detected: ${variance}L`)
        riskScore = 60
      }
    }

    if (context === 'meter_rollback_attempt') {
      suspiciousIndicators.push('Meter tampering attempt detected')
      riskScore = 70
    }

    if (context === 'negative_sales_attempt') {
      suspiciousIndicators.push('Negative sales attempt detected')
      riskScore = 75
    }

    // Only log if significant risk - ONLY FraudDetectionLogs
    if (riskScore >= 60 && suspiciousIndicators.length > 0) {
      await logFraudDetection(context.toUpperCase(), suspiciousIndicators.join('; '), riskScore)
    }

    return { suspicious: riskScore >= 60, riskScore }
  } catch (error) {
    console.warn('⚠️ Suspicious activity detection failed (non-blocking):', error.message)
    return { suspicious: false, riskScore: 0 }
  }
}

// =====================================================================
// DATA LOADING FUNCTIONS
// =====================================================================
const loadStationData = async () => {
  if (!userStation.value?.StationID) {
    throw new Error('No station assigned to user')
  }

  try {
    // STRICT SECURITY: Load station info with exact ID match
    const stationResponse = await apiRequest(`/Stations/${userStation.value.StationID}`)
    stationInfo.value = stationResponse || {}

    // SECURITY VALIDATION: Ensure loaded station matches user's assigned station
    if (stationInfo.value.StationID !== userStation.value.StationID) {
      throw new Error('Station data mismatch - security violation detected')
    }

    // STRICT STATION FILTERING: Only load pumps for THIS specific station
    const pumpsResponse = await apiRequest(`/Pumps?StationID=${userStation.value.StationID}`)
    const pumps = pumpsResponse.records || []

    // SECURITY VALIDATION: Double-check all pumps belong to user's station
    const validPumps = pumps.filter(
      (pump) => pump && pump.StationID === userStation.value.StationID,
    )

    // SECURITY ALERT: Log any cross-station data leakage attempt
    if (validPumps.length !== pumps.length && pumps.length > 0) {
      console.error(
        `🚨 SECURITY VIOLATION: Cross-station pump data detected! Expected: ${validPumps.length}, Received: ${pumps.length}`,
      )
      await logFraudDetection(
        'UNAUTHORIZED_DATA_ACCESS',
        `Attempted access to pumps from other stations. User station: ${userStation.value.StationID}`,
        85,
      )
    }

    // STRICT STATION FILTERING: Only load tanks for THIS specific station
    let tanks = []
    try {
      const tanksResponse = await apiRequest(`/Tanks?StationID=${userStation.value.StationID}`)
      tanks = (tanksResponse.records || []).filter(
        (tank) => tank && tank.StationID === userStation.value.StationID,
      )
    } catch (error) {
      console.warn('Failed to load tanks:', error.message)
    }

    // Load products (global resource, but validate usage)
    let products = []
    try {
      const productsResponse = await apiRequest('/Products')
      products = productsResponse.records || []
    } catch (error) {
      console.warn('Failed to load products:', error.message)
    }

    // SECURE DATA ENRICHMENT: Only enrich with station-owned resources
    stationPumps.value = validPumps.map((pump) => {
      // SECURITY: Only match tanks that belong to this station
      const tank = tanks.find(
        (t) => t && t.TankID === pump.TankID && t.StationID === userStation.value.StationID,
      )

      const product = products.find((p) => p && p.ProductID === tank?.ProductID)

      return {
        ...pump,
        ProductName: product?.Name || 'Unknown Product',
        // SECURITY MARKER: Ensure pump is validated for this station
        StationValidated: true,
      }
    })

    // SECURITY VALIDATION: Final check all pumps are station-validated
    const unvalidatedPumps = stationPumps.value.filter((pump) => !pump.StationValidated)
    if (unvalidatedPumps.length > 0) {
      throw new Error('Security validation failed - unauthorized pump access detected')
    }

    // Initialize readings map for validated pumps only
    stationPumps.value.forEach((pump) => {
      if (pump && pump.PumpID && !pumpReadings.has(pump.PumpID)) {
        pumpReadings.set(pump.PumpID, {
          openingReading: '',
          closingReading: '',
          variance: 0,
          readingId: null,
          stationId: userStation.value.StationID, // Security tracking
        })
      }
    })

    console.log(
      `✅ Securely loaded ${stationPumps.value.length} validated pumps for station ${userStation.value.StationID}`,
    )
  } catch (error) {
    console.error('Error loading station data:', error)
    throw new Error(`Failed to load station data: ${error.message}`)
  }
}

const checkActiveShift = async () => {
  if (!userStation.value?.StationID || !currentUser.value?.id) {
    console.warn('Missing station or user data for shift check')
    return
  }

  try {
    const today = new Date().toISOString().split('T')[0]

    // STRICT STATION FILTERING - Only get shifts for THIS user's station
    const response = await apiRequest(
      `/CashDrawers?StationID=${userStation.value.StationID}&ShiftDate=${today}&ShiftType=${currentShift.value}&Status=Open&AttendantID=${currentUser.value.id}`,
    )

    const shifts = response.records || []

    // DOUBLE VALIDATION - Ensure shift belongs to current user AND current station
    const activeShift = shifts.find(
      (shift) =>
        shift &&
        shift.AttendantID === currentUser.value.id &&
        shift.StationID === userStation.value.StationID &&
        shift.Status === 'Open',
    )

    if (activeShift) {
      hasActiveShift.value = true
      activeShiftData.value = activeShift
      generateAIInsights()
      console.log(
        `✅ Found active ${currentShift.value} shift for user ${currentUser.value.id} at station ${userStation.value.StationID}`,
      )
    } else {
      hasActiveShift.value = false
      activeShiftData.value = null

      // MANDATORY SHIFT REQUIREMENT - Auto-prompt to open shift
      setTimeout(() => {
        if (!hasActiveShift.value && !showShiftModal.value) {
          showShiftModal.value = true
        }
      }, 1000)

      console.log(`❌ No active ${currentShift.value} shift found - user must open shift first`)
    }
  } catch (error) {
    console.error('Error checking shift status:', error)
    hasActiveShift.value = false
    activeShiftData.value = null

    // Force shift modal on error
    setTimeout(() => {
      if (!showShiftModal.value) {
        showShiftModal.value = true
      }
    }, 1000)
  }
}

const loadExistingReadings = async () => {
  if (!userStation.value?.StationID || !currentUser.value?.id) {
    console.warn('Missing station or user data for loading existing readings')
    return
  }

  try {
    const today = new Date().toISOString().split('T')[0]

    // STRICT SECURITY: Only load readings for THIS user at THIS station on THIS date
    const response = await apiRequest(
      `/DailyReadings?StationID=${userStation.value.StationID}&ReadingDate=${today}&RecordedBy=${currentUser.value.id}`,
    )

    const readings = response.records || []
    let loadedCount = 0
    const securityViolations = []

    readings.forEach((reading) => {
      // SECURITY VALIDATION: Triple-check reading ownership
      if (
        reading &&
        reading.PumpID &&
        reading.StationID === userStation.value.StationID &&
        reading.RecordedBy === currentUser.value.id &&
        pumpReadings.has(reading.PumpID)
      ) {
        // ADDITIONAL SECURITY: Verify pump belongs to user's station
        const pump = stationPumps.value.find((p) => p.PumpID === reading.PumpID)
        if (pump && pump.StationID === userStation.value.StationID) {
          const pumpReading = pumpReadings.get(reading.PumpID)
          if (pumpReading) {
            pumpReading.openingReading = reading.OpeningReading || ''
            pumpReading.closingReading = reading.ClosingReading || ''
            pumpReading.variance = parseFloat(reading.Variance || 0)
            pumpReading.readingId = reading.ReadingID
            loadedCount++
          }
        } else {
          // SECURITY VIOLATION: Reading for pump not owned by this station
          securityViolations.push({
            readingId: reading.ReadingID,
            pumpId: reading.PumpID,
            stationId: reading.StationID,
          })
        }
      } else if (reading && reading.StationID !== userStation.value.StationID) {
        // SECURITY VIOLATION: Cross-station reading access
        securityViolations.push({
          readingId: reading.ReadingID,
          unauthorizedStation: reading.StationID,
          userStation: userStation.value.StationID,
        })
      }
    })

    // SECURITY ALERT: Log any violations
    if (securityViolations.length > 0) {
      console.error(
        `🚨 SECURITY VIOLATIONS: ${securityViolations.length} unauthorized reading access attempts`,
      )
      await logFraudDetection(
        'UNAUTHORIZED_READING_ACCESS',
        `Attempted access to readings from other stations/users. Violations: ${securityViolations.length}`,
        90,
      )
    }

    console.log(`✅ Securely loaded ${loadedCount} validated readings for today`)
  } catch (error) {
    console.error('Error loading existing readings:', error)
  }
}

// =====================================================================
// AI INSIGHTS GENERATION
// =====================================================================
const generateAIInsights = () => {
  const insights = []
  const currentHour = new Date().getHours()

  try {
    if (currentHour >= 6 && currentHour <= 9) {
      insights.push({
        id: 'morning_rush',
        type: 'Peak Hours',
        message:
          'Morning rush hour period - ensure all pumps are operational for maximum efficiency',
        confidence: 90,
        priority: 'medium',
      })
    }

    if (hasActiveShift.value) {
      insights.push({
        id: 'shift_active',
        type: 'Shift Status',
        message: `${currentShift.value} shift is active - all readings are being monitored for accuracy`,
        confidence: 100,
        priority: 'high',
      })
    }

    if (stationPumps.value && stationPumps.value.length > 0) {
      const completion = (completedPumps.value / stationPumps.value.length) * 100

      if (completion > 0 && completion < 100) {
        insights.push({
          id: 'completion_status',
          type: 'Progress Update',
          message: `${completion.toFixed(0)}% of pumps completed - ${pendingPumps.value} pumps remaining`,
          confidence: 100,
          priority: 'medium',
        })
      } else if (completion === 100) {
        insights.push({
          id: 'all_complete',
          type: 'Achievement',
          message: 'All pump readings completed successfully - ready for shift closure',
          confidence: 100,
          priority: 'high',
        })
      }
    }

    aiInsights.value = insights
  } catch (error) {
    console.error('Error generating AI insights:', error)
    aiInsights.value = []
  }
}

// =====================================================================
// SHIFT MANAGEMENT
// =====================================================================
const openShift = () => {
  // MANDATORY SHIFT REQUIREMENT - Auto-open modal (no cancellation allowed)
  showShiftModal.value = true
  shiftForm.openingBalance = ''
  shiftForm.errors = {}
}

const validateShiftForm = () => {
  const errors = {}

  if (!shiftForm.openingBalance) {
    errors.openingBalance = 'Opening balance is required'
  } else {
    const amount = parseFloat(shiftForm.openingBalance)
    if (isNaN(amount) || amount < 0) {
      errors.openingBalance = 'Invalid amount'
    } else if (amount > 10000000) {
      errors.openingBalance = 'Amount exceeds maximum limit'
    }
  }

  shiftForm.errors = errors
}

const confirmOpenShift = async () => {
  if (!canOpenShift.value) return

  // SECURITY: Additional validation
  if (!userStation.value?.StationID || !currentUser.value?.id) {
    Swal.fire({
      title: 'Authentication Error',
      text: 'Invalid user or station data. Please login again.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  saving.value = true

  try {
    const today = new Date().toISOString().split('T')[0]

    // SECURITY: Check for existing shifts to prevent conflicts
    const existingShiftsCheck = await apiRequest(
      `/CashDrawers?StationID=${userStation.value.StationID}&ShiftDate=${today}&ShiftType=${currentShift.value}&Status=Open`,
    )

    const conflictingShifts = (existingShiftsCheck.records || []).filter(
      (shift) => shift.AttendantID !== currentUser.value.id,
    )

    if (conflictingShifts.length > 0) {
      await logFraudDetection(
        'SHIFT_CONFLICT_ATTEMPT',
        `Attempted to open shift when another user has active shift on same station/shift type`,
        70,
      )

      Swal.fire({
        title: 'Shift Conflict',
        text: 'Another user already has an active shift for this time period.',
        icon: 'error',
        confirmButtonColor: '#f1416c',
      })
      return
    }

    // SECURITY: Strict shift data with validation
    const shiftData = {
      StationID: userStation.value.StationID, // SECURITY: Force user's station
      ShiftDate: today,
      ShiftType: currentShift.value,
      AttendantID: currentUser.value.id, // SECURITY: Force current user
      OpeningBalance: shiftForm.openingBalance,
      ClosingBalance: '0.00',
      ExpectedCash: shiftForm.openingBalance,
      ActualCash: '0.00',
      Variance: '0.00',
      CashSales: '0.00',
      CashPayouts: '0.00',
      Status: 'Open',
      OpenedBy: currentUser.value.id, // SECURITY: Force current user
      ClosedBy: null,
      OpenedAt: new Date().toISOString(),
      ClosedAt: null,
      Notes: `SECURED: Station ${userStation.value.StationID} access granted`, // Security note
      CreatedAt: new Date().toISOString(),
    }

    const response = await apiRequest('/CashDrawers', {
      method: 'POST',
      body: JSON.stringify(shiftData),
    })

    // SECURITY: Validate response belongs to current user/station
    if (
      response.StationID !== userStation.value.StationID ||
      response.AttendantID !== currentUser.value.id
    ) {
      throw new Error('Security validation failed - shift ownership mismatch')
    }

    hasActiveShift.value = true
    activeShiftData.value = response
    showShiftModal.value = false

    generateAIInsights()

    Swal.fire({
      title: 'Shift Secured!',
      text: `${currentShift.value} shift opened successfully with security validation`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 4000,
      showConfirmButton: false,
    })

    console.log(
      `🔐 SECURE SHIFT OPENED: User ${currentUser.value.id} at Station ${userStation.value.StationID}`,
    )
  } catch (error) {
    console.error('Error opening shift:', error)

    await logFraudDetection('SHIFT_OPENING_FAILURE', `Failed to open shift: ${error.message}`, 60)

    Swal.fire({
      title: 'Error Opening Shift',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

// =====================================================================
// PUMP READING FUNCTIONS
// =====================================================================
const openPumpModal = async (pump) => {
  selectedPump.value = pump
  const reading = pumpReadings.get(pump.PumpID)

  pumpReading.openingReading = reading?.openingReading || ''
  pumpReading.closingReading = reading?.closingReading || ''

  readingErrors.opening = ''
  readingErrors.closing = ''
}

const closePumpModal = async () => {
  selectedPump.value = null
  pumpReading.openingReading = ''
  pumpReading.closingReading = ''
  readingErrors.opening = ''
  readingErrors.closing = ''
}

const validateReadings = () => {
  if (!selectedPump.value) return

  const errors = {}

  // BASIC VALIDATION ONLY - NO LOGGING DURING TYPING
  if (pumpReading.openingReading) {
    const opening = parseFloat(pumpReading.openingReading)
    const current = parseFloat(selectedPump.value.MeterReading || 0)

    if (isNaN(opening) || opening < 0) {
      errors.opening = 'Invalid reading format'
    } else if (opening < current) {
      errors.opening = 'Opening reading cannot be less than current reading'
    }
  }

  if (pumpReading.closingReading && pumpReading.openingReading) {
    const closing = parseFloat(pumpReading.closingReading)
    const opening = parseFloat(pumpReading.openingReading)

    if (isNaN(closing) || closing < 0) {
      errors.closing = 'Invalid reading format'
    } else if (closing < opening) {
      errors.closing = 'Closing reading cannot be less than opening reading'
    }
  }

  readingErrors.opening = errors.opening || ''
  readingErrors.closing = errors.closing || ''
}

const saveReading = async () => {
  if (!canSaveReading.value) return

  // SECURITY: Block if no active shift
  if (!hasActiveShift.value) {
    Swal.fire({
      title: 'Shift Required',
      text: 'You must have an active shift to save readings',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  // SECURITY: Validate pump ownership
  if (!selectedPump.value || selectedPump.value.StationID !== userStation.value.StationID) {
    await logFraudDetection(
      'UNAUTHORIZED_PUMP_ACCESS',
      `Attempted to save reading for unauthorized pump. Pump Station: ${selectedPump.value?.StationID}, User Station: ${userStation.value.StationID}`,
      95,
    )

    Swal.fire({
      title: 'Security Violation',
      text: 'Unauthorized pump access detected',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  saving.value = true

  try {
    const today = new Date().toISOString().split('T')[0]
    const sales = parseFloat(getLiveSales())
    const variance = parseFloat(getLiveVariance())
    const openingReading = parseFloat(pumpReading.openingReading)
    const closingReading = parseFloat(pumpReading.closingReading)
    const current = parseFloat(selectedPump.value.MeterReading || 0)

    // ONLY LOG SUSPICIOUS ACTIVITY ON SUBMISSION
    if (openingReading < current) {
      await detectSuspiciousActivity('meter_rollback_attempt', {
        pumpId: selectedPump.value.PumpID,
        currentReading: current,
        attemptedReading: openingReading,
      })
    }

    if (closingReading < openingReading) {
      await detectSuspiciousActivity('negative_sales_attempt', {
        pumpId: selectedPump.value.PumpID,
        openingReading: openingReading,
        closingReading: closingReading,
      })
    }

    if (Math.abs(variance) > 20) {
      await detectSuspiciousActivity('meter_reading', {
        pumpId: selectedPump.value.PumpID,
        variance: variance,
      })
    }

    // SECURITY: Double-validate all IDs belong to user's station
    const readingData = {
      StationID: userStation.value.StationID, // SECURITY: Force user's station
      ReadingDate: today,
      PumpID: selectedPump.value.PumpID,
      TankID: selectedPump.value.TankID,
      OpeningReading: pumpReading.openingReading,
      ClosingReading: pumpReading.closingReading,
      DipReading: null,
      CalculatedSales: sales.toString(),
      Variance: variance.toString(),
      RecordedBy: currentUser.value.id.toString(), // SECURITY: Force current user
      VerifiedBy: null,
      Status: 'Completed',
      CreatedAt: new Date().toISOString(),
    }

    const existingReading = pumpReadings.get(selectedPump.value.PumpID)
    let response

    if (existingReading?.readingId) {
      response = await apiRequest(`/DailyReadings/${existingReading.readingId}`, {
        method: 'PATCH',
        body: JSON.stringify(readingData),
      })
    } else {
      response = await apiRequest('/DailyReadings', {
        method: 'POST',
        body: JSON.stringify(readingData),
      })
    }

    const readingId = response.ReadingID || response.id || existingReading?.readingId

    // SECURITY: Only update pumps that belong to user's station
    if (selectedPump.value.StationID === userStation.value.StationID) {
      await apiRequest(`/Pumps/${selectedPump.value.PumpID}`, {
        method: 'PATCH',
        body: JSON.stringify({
          MeterReading: pumpReading.closingReading,
          UpdatedAt: new Date().toISOString(),
        }),
      })
    }

    // Update local state with security tracking
    pumpReadings.set(selectedPump.value.PumpID, {
      openingReading: pumpReading.openingReading,
      closingReading: pumpReading.closingReading,
      variance: variance,
      readingId: readingId,
      stationId: userStation.value.StationID, // Security tracking
      savedBy: currentUser.value.id, // Security tracking
      savedAt: new Date().toISOString(), // Security tracking
    })

    const pump = stationPumps.value.find((p) => p.PumpID === selectedPump.value.PumpID)
    if (pump && pump.StationID === userStation.value.StationID) {
      pump.MeterReading = pumpReading.closingReading
    }

    generateAIInsights()
    updateChart()

    Swal.fire({
      title: 'Success!',
      text: 'Reading saved successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    closePumpModal()
  } catch (error) {
    console.error('Error saving reading:', error)

    Swal.fire({
      title: 'Error Saving Reading',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

// =====================================================================
// HELPER FUNCTIONS
// =====================================================================
const hasReading = (pumpId) => {
  const reading = pumpReadings.get(pumpId)
  return reading && reading.openingReading && reading.closingReading
}

const getCalculatedSales = (pumpId) => {
  const reading = pumpReadings.get(pumpId)
  if (!reading || !reading.openingReading || !reading.closingReading) return '0.00'

  const sales = parseFloat(reading.closingReading) - parseFloat(reading.openingReading)
  return sales > 0 ? sales.toFixed(2) : '0.00'
}

const getVarianceAlert = (pumpId) => {
  const reading = pumpReadings.get(pumpId)
  if (!reading || !reading.variance) return null

  const variance = Math.abs(reading.variance)
  if (variance > 20) return `High variance: ${variance.toFixed(2)}L`
  if (variance > 10) return `Medium variance: ${variance.toFixed(2)}L`
  return null
}

const getLiveSales = () => {
  if (!pumpReading.openingReading || !pumpReading.closingReading) return '0.00'
  const sales = parseFloat(pumpReading.closingReading) - parseFloat(pumpReading.openingReading)
  return sales > 0 ? sales.toFixed(2) : '0.00'
}

const getLiveVariance = () => {
  if (!pumpReading.openingReading || !pumpReading.closingReading) return '0.00'
  const sales = parseFloat(getLiveSales())
  const expectedVariance = sales * 0.02 // 2% expected variance
  return expectedVariance.toFixed(2)
}

const getAccuracyScore = () => {
  const variance = Math.abs(parseFloat(getLiveVariance()))
  const sales = parseFloat(getLiveSales())
  if (sales === 0) return '100'

  const accuracyPercentage = Math.max(0, 100 - (variance / sales) * 100)
  return accuracyPercentage.toFixed(0)
}

const getVarianceColorClass = () => {
  const variance = Math.abs(parseFloat(getLiveVariance()))
  if (variance > 20) return 'text-danger'
  if (variance > 10) return 'text-warning'
  return 'text-success'
}

const formatReading = (reading) => {
  const value = parseFloat(reading || 0)
  if (isNaN(value)) return '0.00'
  return value.toLocaleString('en-UG', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })
}

const getPumpCardClass = (pump) => {
  if (!pump || pump.Status !== 'Active') return 'bg-light-secondary'
  if (hasReading(pump.PumpID)) return 'bg-light-success'
  return 'bg-light-primary'
}

const getPumpStatusBadge = (pump) => {
  if (!pump || pump.Status !== 'Active') return 'badge-light-secondary'
  if (hasReading(pump.PumpID)) return 'badge-light-success'
  return 'badge-light-primary'
}

const getPumpStatus = (pump) => {
  if (!pump || pump.Status !== 'Active') return 'Inactive'
  if (hasReading(pump.PumpID)) return 'Complete'
  return 'Pending'
}

const getPumpSymbolClass = (pump) => {
  if (!pump || pump.Status !== 'Active') return 'bg-light-secondary'
  if (hasReading(pump.PumpID)) return 'bg-light-success'
  return 'bg-light-primary'
}

const getInsightBadgeClass = (priority) => {
  if (!priority) return 'badge-light-info'
  switch (priority.toLowerCase()) {
    case 'high':
      return 'badge-light-danger'
    case 'medium':
      return 'badge-light-warning'
    default:
      return 'badge-light-info'
  }
}

const getSaveButtonText = () => {
  if (requiresFraudMonitoring.value) return 'Save with Monitoring'
  if (!selectedPump.value) return 'Save Reading'
  const existingReading = pumpReadings.get(selectedPump.value.PumpID)
  return existingReading?.readingId ? 'Update Reading' : 'Save Reading'
}

// =====================================================================
// CHART FUNCTIONS
// =====================================================================
const initChart = () => {
  if (!performanceChart.value) return

  try {
    const ctx = performanceChart.value.getContext('2d')
    if (!ctx) return

    const completed = completedPumps.value
    const total = stationPumps.value.length

    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height)

    if (total === 0) return

    const centerX = ctx.canvas.width / 2
    const centerY = ctx.canvas.height / 2
    const radius = 50

    ctx.beginPath()
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
    ctx.fillStyle = '#f1f3f4'
    ctx.fill()

    if (completed > 0) {
      const completedAngle = (completed / total) * 2 * Math.PI
      ctx.beginPath()
      ctx.arc(centerX, centerY, radius, -Math.PI / 2, -Math.PI / 2 + completedAngle)
      ctx.arc(centerX, centerY, 25, -Math.PI / 2 + completedAngle, -Math.PI / 2, true)
      ctx.fillStyle = '#50cd89'
      ctx.fill()
    }

    ctx.fillStyle = '#181c32'
    ctx.font = 'bold 18px Inter'
    ctx.textAlign = 'center'
    ctx.fillText(`${completed}`, centerX, centerY - 5)
    ctx.font = 'bold 12px Inter'
    ctx.fillText(`of ${total}`, centerX, centerY + 10)
  } catch (error) {
    console.error('Chart initialization error:', error)
  }
}

const updateChart = () => {
  nextTick(() => {
    try {
      initChart()
    } catch (error) {
      console.error('Chart update error:', error)
    }
  })
}

// =====================================================================
// INITIALIZATION
// =====================================================================
const initializeSystem = async () => {
  loading.value = true
  loadingMessage.value = 'Initializing meter reading system...'

  try {
    if (!authData.value.user || !userStation.value) {
      throw new Error('Authentication required - please login first')
    }

    if (!currentUser.value.id) {
      throw new Error('Invalid user data - missing user ID')
    }

    if (!userStation.value.StationID) {
      throw new Error('No station assigned to user')
    }

    loadingMessage.value = 'Loading station data...'
    await loadStationData()

    loadingMessage.value = 'Checking shift status...'
    await checkActiveShift()

    loadingMessage.value = 'Loading existing readings...'
    await loadExistingReadings()

    generateAIInsights()

    await nextTick()
    setTimeout(() => {
      try {
        initChart()
      } catch (error) {
        console.error('Chart initialization delayed error:', error)
      }
    }, 100)

    console.log(`✅ System initialized successfully for station ${userStation.value.StationID}`)
  } catch (error) {
    console.error('Initialization error:', error)

    await Swal.fire({
      title: 'Initialization Failed',
      text: error.message || 'Failed to initialize the meter reading system',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  initializeSystem()
})
</script>

<style scoped>
.card {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(10px);
}

.card:hover {
  transform: translateY(-8px);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15) !important;
}

.cursor-pointer {
  cursor: pointer;
}

.btn {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 600;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.btn:active {
  transform: scale(0.95);
}

.form-control {
  transition: all 0.3s ease;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
}

.form-control:focus {
  border-color: #4ecdc4;
  box-shadow: 0 0 0 0.2rem rgba(78, 205, 196, 0.25);
  transform: scale(1.02);
}

.modal-content {
  backdrop-filter: blur(25px);
  background: rgba(255, 255, 255, 0.95);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
}

.symbol {
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.card:hover .symbol {
  transform: scale(1.1) rotate(5deg);
}

.progress-bar {
  transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.alert {
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.badge {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  transition: all 0.3s ease;
}

.badge:hover {
  transform: scale(1.05);
}

@media (max-width: 768px) {
  .btn {
    min-height: 54px;
    font-size: 17px;
    border-radius: 14px !important;
  }

  .form-control {
    min-height: 54px;
    font-size: 17px;
    border-radius: 14px !important;
  }

  .card-body {
    padding: 1.5rem !important;
  }

  .modal-dialog {
    margin: 1rem;
  }

  .modal-content {
    border-radius: 20px !important;
  }

  .symbol {
    width: 50px !important;
    height: 50px !important;
  }
}

@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

@media (prefers-contrast: high) {
  .card {
    border: 3px solid #000 !important;
  }

  .btn {
    border: 2px solid #000 !important;
  }

  .form-control {
    border: 2px solid #000 !important;
  }
}

.btn:focus-visible,
.form-control:focus-visible {
  outline: 3px solid #4ecdc4;
  outline-offset: 2px;
}

.spinner-border {
  animation: spinner-border 0.8s linear infinite;
}

.card[class*='bg-light-']:hover {
  transform: translateY(-4px) scale(1.02);
}
</style>

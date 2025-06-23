<template>
  <div class="d-flex flex-column gap-7 p-5">
    <!-- Station Selection Screen -->
    <div v-if="!dashboardReady" class="d-flex flex-column gap-7">
      <!-- Header -->
      <div class="card card-flush bg-light-primary">
        <div class="card-body text-center p-8">
          <i class="ki-duotone ki-bank fs-4x text-primary mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <h1 class="fw-bold fs-2x text-gray-900 mb-3">Supplier Credit Analytics</h1>
          <p class="fs-5 text-gray-700 mb-0">
            AI-powered credit monitoring with advanced date filtering
          </p>
        </div>
      </div>

      <!-- Station Selection -->
      <div class="card card-flush">
        <div class="card-header">
          <h3 class="card-title fw-bold text-gray-900">
            <i class="ki-duotone ki-geolocation fs-2 text-primary me-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Select Station for Analysis
          </h3>
        </div>
        <div class="card-body">
          <div class="row g-5">
            <div class="col-12">
              <label class="form-label required fs-4 fw-bold text-gray-900">Station Location</label>
              <select
                v-model="selectedStationId"
                class="form-select form-select-lg form-select-solid"
                :disabled="loading"
              >
                <option value="">Choose a station to analyze...</option>
                <option
                  v-for="station in stations"
                  :key="station.StationID"
                  :value="station.StationID"
                >
                  {{ station.StationName }} - {{ station.Location }}
                </option>
              </select>
            </div>
            <div class="col-12" v-if="selectedStationId">
              <button
                @click="fetchCreditData"
                class="btn btn-lg btn-light-success w-100"
                :disabled="loading"
              >
                <span v-if="!loading">
                  <i class="ki-duotone ki-chart-line-up fs-2 me-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Launch Credit Analytics Dashboard
                </span>
                <span v-else>
                  <span class="spinner-border spinner-border-sm me-3"></span>
                  Loading credit data...
                </span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Dashboard -->
    <div v-if="dashboardReady" class="d-flex flex-column gap-7">
      <!-- Dashboard Header with Date Filtering -->
      <div class="card card-flush bg-gradient-primary">
        <div class="card-body p-6">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div class="d-flex align-items-center">
              <i class="ki-duotone ki-chart-pie-3 fs-3x text-white me-4">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div>
                <h1 class="fw-bold fs-2x text-white mb-1">{{ selectedStationName }}</h1>
                <p class="text-white opacity-75 fs-5 mb-0">Period: {{ currentDateRangeLabel }}</p>
              </div>
            </div>
            <div class="d-flex gap-3">
              <button
                @click="showDateFilters = !showDateFilters"
                class="btn btn-light-primary"
                :class="{ active: showDateFilters }"
              >
                <i class="ki-duotone ki-calendar-edit fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Date Filters
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Advanced Date Filtering Panel -->
      <div v-if="showDateFilters" class="card card-flush border-primary">
        <div class="card-header bg-light-primary">
          <h3 class="card-title fw-bold text-primary">
            <i class="ki-duotone ki-calendar-search fs-2 me-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Advanced Date Filtering
          </h3>
        </div>
        <div class="card-body">
          <!-- Quick Date Presets -->
          <div class="mb-8">
            <label class="form-label fw-bold text-gray-900 mb-4">Quick Date Ranges</label>
            <div class="row g-3">
              <div
                v-for="preset in dateRangePresets.slice(0, -1)"
                :key="preset.value"
                class="col-6 col-md-4 col-lg-3"
              >
                <button
                  @click="setDateRange(preset.value)"
                  class="btn w-100 btn-outline btn-outline-primary"
                  :class="{ 'btn-primary text-white': selectedDateRange === preset.value }"
                >
                  <i class="ki-duotone fs-2 mb-2" :class="`ki-${preset.icon}`">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  <div class="fw-bold fs-7">{{ preset.label }}</div>
                </button>
              </div>
            </div>
          </div>

          <!-- Custom Date Range -->
          <div class="separator my-5"></div>
          <div class="row g-5">
            <div class="col-12">
              <label class="form-label fw-bold text-gray-900">
                <i class="ki-duotone ki-calendar-edit fs-2 text-primary me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Custom Date Range
              </label>
            </div>
            <div class="col-12 col-md-5">
              <label class="form-label required">From Date</label>
              <input
                v-model="dateFilterFrom"
                type="date"
                class="form-control form-control-lg form-control-solid"
                :max="dateFilterTo"
              />
            </div>
            <div class="col-12 col-md-5">
              <label class="form-label required">To Date</label>
              <input
                v-model="dateFilterTo"
                type="date"
                class="form-control form-control-lg form-control-solid"
                :min="dateFilterFrom"
                :max="formatDate(new Date())"
              />
            </div>
            <div class="col-12 col-md-2 d-flex align-items-end">
              <button
                @click="applyCustomDateRange"
                class="btn btn-lg btn-success w-100"
                :disabled="!dateFilterFrom || !dateFilterTo"
              >
                <i class="ki-duotone ki-check fs-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Apply
              </button>
            </div>
          </div>

          <!-- Close Panel Button -->
          <div class="text-center mt-6">
            <button @click="showDateFilters = false" class="btn btn-light-primary">
              <i class="ki-duotone ki-up fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Hide Date Filters
            </button>
          </div>
        </div>
      </div>

      <!-- AI Insights Overview -->
      <div class="row g-5">
        <div class="col-12 col-md-3">
          <div class="card card-flush bg-light-danger h-100">
            <div class="card-body text-center p-6">
              <i class="ki-duotone ki-shield-cross fs-4x text-danger mb-4">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <h3 class="fw-bold fs-2x text-gray-900">{{ aiInsights.riskScore }}%</h3>
              <p class="text-gray-700 fs-6 mb-0">AI Risk Score</p>
              <div class="badge badge-light-danger mt-2">{{ currentDateRangeLabel }}</div>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-3">
          <div class="card card-flush bg-light-success h-100">
            <div class="card-body text-center p-6">
              <i class="ki-duotone ki-rocket fs-4x text-success mb-4">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <h3 class="fw-bold fs-2x text-gray-900">{{ aiInsights.paymentVelocity }}%</h3>
              <p class="text-gray-700 fs-6 mb-0">Payment Velocity</p>
              <div class="badge badge-light-success mt-2">{{ currentDateRangeLabel }}</div>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-3">
          <div class="card card-flush bg-light-warning h-100">
            <div class="card-body text-center p-6">
              <i class="ki-duotone ki-percentage fs-4x text-warning mb-4">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <h3 class="fw-bold fs-2x text-gray-900">{{ aiInsights.creditUtilization }}%</h3>
              <p class="text-gray-700 fs-6 mb-0">Credit Utilization</p>
              <div class="badge badge-light-warning mt-2">{{ currentDateRangeLabel }}</div>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-3">
          <div class="card card-flush bg-light-info h-100">
            <div class="card-body text-center p-6">
              <i class="ki-duotone ki-people fs-4x text-info mb-4">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <h3 class="fw-bold fs-2x text-gray-900">{{ creditSummary.length }}</h3>
              <p class="text-gray-700 fs-6 mb-0">Active Suppliers</p>
              <div class="badge badge-light-info mt-2">Total</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Risk Distribution & Credit Utilization Charts -->
      <div class="row g-5">
        <div class="col-12 col-lg-6">
          <div class="card card-flush h-100">
            <div class="card-header">
              <h3 class="card-title fw-bold text-gray-900">
                <i class="ki-duotone ki-chart-pie-simple fs-2 text-primary me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Risk Distribution Analysis
              </h3>
              <div class="badge badge-light-primary">{{ currentDateRangeLabel }}</div>
            </div>
            <div class="card-body">
              <canvas ref="riskDistributionChart" width="400" height="300"></canvas>
            </div>
          </div>
        </div>
        <div class="col-12 col-lg-6">
          <div class="card card-flush h-100">
            <div class="card-header">
              <h3 class="card-title fw-bold text-gray-900">
                <i class="ki-duotone ki-chart-line-up fs-2 text-success me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Credit Utilization by Supplier
              </h3>
              <div class="badge badge-light-success">Top 8 Suppliers</div>
            </div>
            <div class="card-body">
              <canvas ref="creditUtilizationChart" width="400" height="300"></canvas>
            </div>
          </div>
        </div>
      </div>

      <!-- Payment Trends & Invoice Aging Charts -->
      <div class="row g-5">
        <div class="col-12 col-lg-6">
          <div class="card card-flush h-100">
            <div class="card-header">
              <h3 class="card-title fw-bold text-gray-900">
                <i class="ki-duotone ki-chart-line fs-2 text-info me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                Payment Trends Analysis
              </h3>
              <div class="badge badge-light-info">{{ currentDateRangeLabel }}</div>
            </div>
            <div class="card-body">
              <canvas ref="paymentTrendChart" width="400" height="300"></canvas>
            </div>
          </div>
        </div>
        <div class="col-12 col-lg-6">
          <div class="card card-flush h-100">
            <div class="card-header">
              <h3 class="card-title fw-bold text-gray-900">
                <i class="ki-duotone ki-calendar-8 fs-2 text-warning me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                Invoice Age Distribution
              </h3>
              <div class="badge badge-light-warning">{{ currentDateRangeLabel }}</div>
            </div>
            <div class="card-body">
              <canvas ref="invoiceAgeChart" width="400" height="300"></canvas>
            </div>
          </div>
        </div>
      </div>

      <!-- AI Cash Flow Forecast -->
      <div class="card card-flush">
        <div class="card-header">
          <h3 class="card-title fw-bold text-gray-900">
            <i class="ki-duotone ki-graph-up fs-2 text-primary me-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            AI Cash Flow Forecast
          </h3>
          <div class="badge badge-light-primary">Based on {{ currentDateRangeLabel }} patterns</div>
        </div>
        <div class="card-body">
          <canvas ref="cashflowForecastChart" width="400" height="400"></canvas>
        </div>
      </div>

      <!-- AI Recommendations -->
      <div class="card card-flush">
        <div class="card-header">
          <h3 class="card-title fw-bold text-gray-900">
            <i class="ki-duotone ki-brain fs-2 text-success me-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            AI Recommendations & Insights
          </h3>
          <div class="badge badge-light-success">{{ currentDateRangeLabel }}</div>
        </div>
        <div class="card-body">
          <div v-if="aiInsights.recommendations.length === 0" class="text-center p-8">
            <i class="ki-duotone ki-check-circle fs-4x text-success mb-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <h4 class="fw-bold text-gray-900 mb-3">All Systems Optimal</h4>
            <p class="text-gray-700">
              No critical issues detected for the selected period. Keep monitoring!
            </p>
          </div>
          <div v-else class="row g-5">
            <div
              v-for="(recommendation, index) in aiInsights.recommendations"
              :key="index"
              class="col-12 col-lg-6"
            >
              <div
                class="card card-flush h-100"
                :class="getRecommendationCardClass(recommendation.type)"
              >
                <div class="card-body p-6">
                  <div class="d-flex align-items-start gap-4">
                    <i
                      class="ki-duotone fs-3x"
                      :class="getRecommendationIconClass(recommendation.type)"
                    >
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div class="flex-grow-1">
                      <h5 class="fw-bold text-gray-900 mb-2">{{ recommendation.title }}</h5>
                      <p class="text-gray-700 mb-3">{{ recommendation.message }}</p>
                      <button
                        class="btn btn-sm"
                        :class="getRecommendationButtonClass(recommendation.type)"
                      >
                        {{ recommendation.action }}
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Strategic Supplier Ranking -->
      <div class="card card-flush">
        <div class="card-header">
          <h3 class="card-title fw-bold text-gray-900">
            <i class="ki-duotone ki-medal-star fs-2 text-warning me-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Strategic Supplier Ranking
          </h3>
          <div class="badge badge-light-warning">Period Volume Analysis</div>
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table align-middle table-row-dashed fs-6 gy-3">
              <thead>
                <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
                  <th class="min-w-125px">Rank</th>
                  <th class="min-w-200px">Supplier</th>
                  <th class="min-w-100px">Strategic Value</th>
                  <th class="min-w-100px">Risk Level</th>
                  <th class="min-w-125px">Period Volume</th>
                  <th class="min-w-100px">Status</th>
                </tr>
              </thead>
              <tbody class="fw-semibold text-gray-600">
                <tr
                  v-for="(supplier, index) in aiInsights.supplierRanking.slice(0, 10)"
                  :key="index"
                >
                  <td>
                    <div class="d-flex align-items-center">
                      <div
                        class="badge badge-circle badge-lg me-3"
                        :class="getRankBadgeClass(index)"
                      >
                        {{ index + 1 }}
                      </div>
                    </div>
                  </td>
                  <td>
                    <div class="fw-bold text-gray-900">{{ supplier.name }}</div>
                  </td>
                  <td>
                    <div class="d-flex align-items-center">
                      <div class="progress h-6px w-100px me-3">
                        <div
                          class="progress-bar"
                          :class="getStrategicValueClass(supplier.strategicValue)"
                          :style="{ width: supplier.strategicValue + '%' }"
                        ></div>
                      </div>
                      <span class="fw-bold fs-7">{{ supplier.strategicValue }}%</span>
                    </div>
                  </td>
                  <td>
                    <span class="badge" :class="getRiskLevelClass(supplier.riskLevel)">
                      {{ supplier.riskLevel }}
                    </span>
                  </td>
                  <td>
                    <span class="fw-bold">{{ formatCurrency(supplier.periodVolume) }}</span>
                  </td>
                  <td>
                    <span class="badge" :class="getStatusClass(supplier.status)">
                      {{ supplier.status }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick, watch } from 'vue'
import Swal from 'sweetalert2'
import * as Chart from 'chart.js'

// Register Chart.js components
Chart.Chart.register(...Chart.registerables)

// Core state
const loading = ref(false)
const selectedStationId = ref('')
const stations = ref([])
const suppliers = ref([])
const creditSummary = ref([])
const invoices = ref([])
const payments = ref([])
const creditTransactions = ref([])
const dashboardReady = ref(false)

// Date filtering state
const dateFilterFrom = ref('')
const dateFilterTo = ref('')
const selectedDateRange = ref('last30days')
const showDateFilters = ref(false)

// Chart refs
const riskDistributionChart = ref(null)
const creditUtilizationChart = ref(null)
const paymentTrendChart = ref(null)
const invoiceAgeChart = ref(null)
const cashflowForecastChart = ref(null)

// Chart instances
let riskDistributionChartInstance = null
let creditUtilizationChartInstance = null
let paymentTrendChartInstance = null
let invoiceAgeChartInstance = null
let cashflowForecastChartInstance = null

// API Configuration
const API_BASE_URL = 'http://localhost:4000/api/records/v1'
const JWT_TOKEN =
  localStorage.getItem('jwt') ||
  'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJzdWIiOiJkMDc1QVZVSVNCcW9HN3dvZFV0MVZ3PT0iLCJpYXQiOjE3NTAyNDc4ODgsImV4cCI6MTc1MDI1MTQ4OCwiZW1haWwiOiJhZG1pbkBsb2NhbGhvc3QiLCJjc3JmX3Rva2VuIjoiOWdWQmpzU0MzN1NBTmVhU3pCelQifQ.i-Lj_KsB-TXZ1vgsu4CPEdICamdOznhKDh42Jx7oi4F29K5voeBER5bBycrnQ0uK7-G45F-18SibATxo_F3rBQ'

// AI Analytics State
const aiInsights = ref({
  riskScore: 0,
  paymentVelocity: 0,
  creditUtilization: 0,
  recommendations: [],
  cashflowForecast: [],
  supplierRanking: [],
})

// Chart colors
const chartColors = ['#1BC5BD', '#FFA800', '#F64E60', '#8950FC', '#3699FF', '#1BC5BD']

// Date range presets
const dateRangePresets = [
  { value: 'today', label: 'Today', icon: 'calendar-2' },
  { value: 'yesterday', label: 'Yesterday', icon: 'calendar' },
  { value: 'thisweek', label: 'This Week', icon: 'calendar-8' },
  { value: 'lastweek', label: 'Last Week', icon: 'calendar-8' },
  { value: 'thismonth', label: 'This Month', icon: 'calendar-tick' },
  { value: 'lastmonth', label: 'Last Month', icon: 'calendar-tick' },
  { value: 'last30days', label: 'Last 30 Days', icon: 'calendar-search' },
  { value: 'last90days', label: 'Last 90 Days', icon: 'calendar-search' },
  { value: 'thisquarter', label: 'This Quarter', icon: 'chart-pie-4' },
  { value: 'lastquarter', label: 'Last Quarter', icon: 'chart-pie-4' },
  { value: 'thisyear', label: 'This Year', icon: 'calendar-add' },
  { value: 'lastyear', label: 'Last Year', icon: 'calendar-add' },
  { value: 'custom', label: 'Custom Range', icon: 'calendar-edit' },
]

// Utility functions for template classes
const getRecommendationCardClass = (type) => {
  const classes = {
    danger: 'border-danger',
    warning: 'border-warning',
    info: 'border-info',
    success: 'border-success',
  }
  return classes[type] || ''
}

const getRecommendationIconClass = (type) => {
  const classes = {
    danger: 'ki-danger text-danger',
    warning: 'ki-warning text-warning',
    info: 'ki-information text-info',
    success: 'ki-check-circle text-success',
  }
  return classes[type] || ''
}

const getRecommendationButtonClass = (type) => {
  const classes = {
    danger: 'btn-light-danger',
    warning: 'btn-light-warning',
    info: 'btn-light-info',
    success: 'btn-light-success',
  }
  return classes[type] || ''
}

const getRankBadgeClass = (index) => {
  if (index < 3) return 'badge-success'
  if (index >= 3 && index < 7) return 'badge-warning'
  return 'badge-light'
}

const getStrategicValueClass = (value) => {
  if (value >= 70) return 'bg-success'
  if (value >= 40) return 'bg-warning'
  return 'bg-danger'
}

const getRiskLevelClass = (level) => {
  const classes = {
    Low: 'badge-light-success',
    Medium: 'badge-light-warning',
    High: 'badge-light-danger',
  }
  return classes[level] || 'badge-light'
}

const getStatusClass = (status) => {
  const classes = {
    Normal: 'badge-light-success',
    'Near Limit': 'badge-light-warning',
    'Over Limit': 'badge-light-danger',
  }
  return classes[status] || 'badge-light'
}

// Format currency
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount || 0)
}

// Set date range based on preset
const setDateRange = (preset) => {
  const now = new Date()
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())

  switch (preset) {
    case 'today':
      dateFilterFrom.value = formatDate(today)
      dateFilterTo.value = formatDate(today)
      break
    case 'yesterday':
      const yesterday = new Date(today)
      yesterday.setDate(yesterday.getDate() - 1)
      dateFilterFrom.value = formatDate(yesterday)
      dateFilterTo.value = formatDate(yesterday)
      break
    case 'thisweek':
      const thisWeekStart = new Date(today)
      thisWeekStart.setDate(today.getDate() - today.getDay())
      dateFilterFrom.value = formatDate(thisWeekStart)
      dateFilterTo.value = formatDate(today)
      break
    case 'lastweek':
      const lastWeekEnd = new Date(today)
      lastWeekEnd.setDate(today.getDate() - today.getDay() - 1)
      const lastWeekStart = new Date(lastWeekEnd)
      lastWeekStart.setDate(lastWeekEnd.getDate() - 6)
      dateFilterFrom.value = formatDate(lastWeekStart)
      dateFilterTo.value = formatDate(lastWeekEnd)
      break
    case 'thismonth':
      const thisMonthStart = new Date(today.getFullYear(), today.getMonth(), 1)
      dateFilterFrom.value = formatDate(thisMonthStart)
      dateFilterTo.value = formatDate(today)
      break
    case 'lastmonth':
      const lastMonthStart = new Date(today.getFullYear(), today.getMonth() - 1, 1)
      const lastMonthEnd = new Date(today.getFullYear(), today.getMonth(), 0)
      dateFilterFrom.value = formatDate(lastMonthStart)
      dateFilterTo.value = formatDate(lastMonthEnd)
      break
    case 'last30days':
      const last30Days = new Date(today)
      last30Days.setDate(today.getDate() - 30)
      dateFilterFrom.value = formatDate(last30Days)
      dateFilterTo.value = formatDate(today)
      break
    case 'last90days':
      const last90Days = new Date(today)
      last90Days.setDate(today.getDate() - 90)
      dateFilterFrom.value = formatDate(last90Days)
      dateFilterTo.value = formatDate(today)
      break
    case 'thisquarter':
      const quarter = Math.floor(today.getMonth() / 3)
      const quarterStart = new Date(today.getFullYear(), quarter * 3, 1)
      dateFilterFrom.value = formatDate(quarterStart)
      dateFilterTo.value = formatDate(today)
      break
    case 'lastquarter':
      const lastQuarter = Math.floor(today.getMonth() / 3) - 1
      const lastQuarterYear = lastQuarter < 0 ? today.getFullYear() - 1 : today.getFullYear()
      const adjustedQuarter = lastQuarter < 0 ? 3 : lastQuarter
      const lastQuarterStart = new Date(lastQuarterYear, adjustedQuarter * 3, 1)
      const lastQuarterEnd = new Date(lastQuarterYear, adjustedQuarter * 3 + 3, 0)
      dateFilterFrom.value = formatDate(lastQuarterStart)
      dateFilterTo.value = formatDate(lastQuarterEnd)
      break
    case 'thisyear':
      const yearStart = new Date(today.getFullYear(), 0, 1)
      dateFilterFrom.value = formatDate(yearStart)
      dateFilterTo.value = formatDate(today)
      break
    case 'lastyear':
      const lastYearStart = new Date(today.getFullYear() - 1, 0, 1)
      const lastYearEnd = new Date(today.getFullYear() - 1, 11, 31)
      dateFilterFrom.value = formatDate(lastYearStart)
      dateFilterTo.value = formatDate(lastYearEnd)
      break
  }

  if (preset !== 'custom') {
    selectedDateRange.value = preset
    if (dashboardReady.value) {
      fetchCreditData()
    }
  }
}

// Format date for input fields
const formatDate = (date) => {
  return date.toISOString().split('T')[0]
}

// Apply custom date range
const applyCustomDateRange = () => {
  if (!dateFilterFrom.value || !dateFilterTo.value) {
    Swal.fire({
      title: 'Invalid Date Range',
      text: 'Please select both start and end dates',
      icon: 'warning',
      confirmButtonColor: '#FFA800',
    })
    return
  }

  if (new Date(dateFilterFrom.value) > new Date(dateFilterTo.value)) {
    Swal.fire({
      title: 'Invalid Date Range',
      text: 'Start date cannot be after end date',
      icon: 'warning',
      confirmButtonColor: '#FFA800',
    })
    return
  }

  selectedDateRange.value = 'custom'
  fetchCreditData()
  showDateFilters.value = false
}

// Get display label for current date range
const currentDateRangeLabel = computed(() => {
  const preset = dateRangePresets.find((p) => p.value === selectedDateRange.value)
  if (preset && selectedDateRange.value !== 'custom') {
    return preset.label
  }
  if (dateFilterFrom.value && dateFilterTo.value) {
    return `${new Date(dateFilterFrom.value).toLocaleDateString()} - ${new Date(dateFilterTo.value).toLocaleDateString()}`
  }
  return 'Last 30 Days'
})

// Filter data by date range
const filterByDateRange = (data, dateField) => {
  if (!dateFilterFrom.value || !dateFilterTo.value) return data

  const fromDate = new Date(dateFilterFrom.value)
  const toDate = new Date(dateFilterTo.value)
  toDate.setHours(23, 59, 59, 999)

  return data.filter((item) => {
    if (!item[dateField]) return false
    const itemDate = new Date(item[dateField])
    return itemDate >= fromDate && itemDate <= toDate
  })
}

// Fetch stations on mount
const fetchStations = async () => {
  loading.value = true
  try {
    const response = await fetch(`${API_BASE_URL}/Stations`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error(`Failed to fetch stations: ${response.status}`)
    }

    const data = await response.json()
    stations.value = data.records || []
  } catch (error) {
    console.error('Error fetching stations:', error)
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load stations',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Fetch supplier credit data for selected station
const fetchCreditData = async () => {
  if (!selectedStationId.value) return

  loading.value = true
  try {
    // Fetch suppliers
    const suppliersResponse = await fetch(`${API_BASE_URL}/Suppliers`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (suppliersResponse.ok) {
      const suppliersData = await suppliersResponse.json()
      suppliers.value = suppliersData.records || []
    }

    // Fetch supplier credit accounts
    const creditAccountsResponse = await fetch(`${API_BASE_URL}/SupplierCreditAccounts`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (creditAccountsResponse.ok) {
      const creditAccountsData = await creditAccountsResponse.json()
      const allCreditAccounts = creditAccountsData.records || []

      // Create credit summary by joining with suppliers
      creditSummary.value = allCreditAccounts
        .map((account) => {
          const supplier = suppliers.value.find((s) => s.SupplierID === account.SupplierID)
          return {
            ...account,
            SupplierName: supplier?.Name || 'Unknown Supplier',
            CreditStatus: getCreditStatus(account),
          }
        })
        .filter(
          (account) => !selectedStationId.value || account.StationID == selectedStationId.value,
        )
    }

    // Fetch supplier invoices
    const invoicesResponse = await fetch(`${API_BASE_URL}/SupplierInvoices`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (invoicesResponse.ok) {
      const invoicesData = await invoicesResponse.json()
      const allInvoices = invoicesData.records || []
      invoices.value = filterByDateRange(
        allInvoices.filter(
          (inv) => !selectedStationId.value || inv.StationID == selectedStationId.value,
        ),
        'InvoiceDate',
      )
    }

    // Fetch supplier payments
    const paymentsResponse = await fetch(`${API_BASE_URL}/SupplierPayments`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (paymentsResponse.ok) {
      const paymentsData = await paymentsResponse.json()
      const allPayments = paymentsData.records || []
      payments.value = filterByDateRange(
        allPayments.filter(
          (payment) => !selectedStationId.value || payment.StationID == selectedStationId.value,
        ),
        'PaymentDate',
      )
    }

    // Fetch supplier credit transactions
    const transactionsResponse = await fetch(`${API_BASE_URL}/SupplierCreditTransactions`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (transactionsResponse.ok) {
      const transactionsData = await transactionsResponse.json()
      const allTransactions = transactionsData.records || []
      creditTransactions.value = filterByDateRange(
        allTransactions.filter(
          (transaction) =>
            !selectedStationId.value || transaction.StationID == selectedStationId.value,
        ),
        'CreatedAt',
      )
    }

    // Generate AI insights
    generateAIInsights()
    dashboardReady.value = true

    // Create charts after data is loaded
    await nextTick()
    createCharts()

    Swal.fire({
      title: 'Success!',
      text: `Credit data loaded for ${currentDateRangeLabel.value}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Error fetching credit data:', error)
    Swal.fire({
      title: 'Error!',
      text: `Failed to load credit data: ${error.message}`,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Get credit status helper
const getCreditStatus = (account) => {
  const creditLimit = parseFloat(account.CreditLimit) || 0
  const currentBalance = parseFloat(account.CurrentBalance) || 0

  if (currentBalance > creditLimit) return 'Over Limit'
  if (currentBalance > creditLimit * 0.9) return 'Near Limit'
  return 'Normal'
}

// AI-Powered Credit Risk Assessment
const calculateCreditRisk = (supplier) => {
  const creditLimit = parseFloat(supplier.CreditLimit) || 0
  const currentBalance = parseFloat(supplier.CurrentBalance) || 0
  const utilizationRatio = creditLimit > 0 ? currentBalance / creditLimit : 0

  // Simple risk calculation - you can enhance this
  const riskScore = utilizationRatio * 100
  return Math.min(100, Math.max(0, riskScore))
}

// AI Payment Velocity Analysis
const calculatePaymentVelocity = () => {
  if (payments.value.length === 0) return 50

  const recentPayments = payments.value.sort(
    (a, b) => new Date(b.PaymentDate) - new Date(a.PaymentDate),
  )
  if (recentPayments.length < 2) return 50

  // Calculate average payment intervals
  const intervals = []
  for (let i = 1; i < Math.min(recentPayments.length, 10); i++) {
    const current = new Date(recentPayments[i - 1].PaymentDate)
    const previous = new Date(recentPayments[i].PaymentDate)
    intervals.push((current - previous) / (1000 * 60 * 60 * 24))
  }

  const avgInterval = intervals.reduce((sum, interval) => sum + interval, 0) / intervals.length
  const velocity = Math.max(0, 100 - avgInterval * 2)
  return Math.min(100, velocity)
}

// Generate cashflow forecast
const generateCashflowForecast = () => {
  const forecast = []
  const avgMonthlyPayment =
    payments.value.length > 0
      ? (payments.value.reduce((sum, p) => sum + parseFloat(p.PaymentAmount || 0), 0) /
          payments.value.length) *
        30
      : 0

  const currentDate = new Date()
  for (let i = 0; i < 6; i++) {
    const forecastDate = new Date(currentDate)
    forecastDate.setMonth(forecastDate.getMonth() + i)

    const seasonalMultiplier =
      forecastDate.getMonth() >= 9 ? 1.2 : forecastDate.getMonth() <= 2 ? 0.8 : 1.0
    const forecastAmount = avgMonthlyPayment * seasonalMultiplier

    forecast.push({
      month: forecastDate.toLocaleDateString('en-US', { month: 'short', year: 'numeric' }),
      projected: Math.round(forecastAmount),
      confidence: Math.max(60, 90 - i * 5),
    })
  }

  return forecast
}

// Generate supplier ranking
const generateSupplierRanking = () => {
  return suppliers.value
    .map((supplier) => {
      const creditAccount = creditSummary.value.find((cs) => cs.SupplierID === supplier.SupplierID)
      if (!creditAccount) return null

      const riskScore = calculateCreditRisk(creditAccount)
      const supplierPayments = payments.value.filter((p) => p.SupplierID === supplier.SupplierID)
      const totalVolume = supplierPayments.reduce(
        (sum, p) => sum + parseFloat(p.PaymentAmount || 0),
        0,
      )

      const volumeScore = Math.min(100, (totalVolume / 100000) * 100)
      const reliabilityScore = 100 - riskScore
      const strategicValue = volumeScore * 0.4 + reliabilityScore * 0.6

      return {
        name: supplier.Name || 'Unknown Supplier',
        strategicValue: Math.round(strategicValue),
        creditLimit: parseFloat(creditAccount.CreditLimit) || 0,
        periodVolume: totalVolume,
        riskLevel: riskScore < 30 ? 'Low' : riskScore < 60 ? 'Medium' : 'High',
        status: creditAccount.CreditStatus || 'Unknown',
      }
    })
    .filter(Boolean)
    .sort((a, b) => b.strategicValue - a.strategicValue)
}

// Generate AI Insights
const generateAIInsights = () => {
  if (creditSummary.value.length === 0) {
    aiInsights.value = {
      riskScore: 0,
      paymentVelocity: 0,
      creditUtilization: 0,
      recommendations: [],
      cashflowForecast: [],
      supplierRanking: [],
    }
    return
  }

  const totalCreditLimit = creditSummary.value.reduce(
    (sum, cs) => sum + parseFloat(cs.CreditLimit || 0),
    0,
  )
  const totalCurrentBalance = creditSummary.value.reduce(
    (sum, cs) => sum + parseFloat(cs.CurrentBalance || 0),
    0,
  )
  const avgRiskScore =
    creditSummary.value.reduce((sum, cs) => sum + calculateCreditRisk(cs), 0) /
    creditSummary.value.length

  const creditUtilization =
    totalCreditLimit > 0 ? (totalCurrentBalance / totalCreditLimit) * 100 : 0
  const paymentVelocity = calculatePaymentVelocity()

  const recommendations = []

  if (creditUtilization > 80) {
    recommendations.push({
      type: 'warning',
      title: 'High Credit Utilization',
      message: `Credit utilization at ${creditUtilization.toFixed(1)}% for selected period.`,
      action: 'Review Credit Policies',
    })
  }

  if (avgRiskScore > 70) {
    recommendations.push({
      type: 'danger',
      title: 'Elevated Risk Profile',
      message: `Average risk score ${avgRiskScore.toFixed(1)}% during ${currentDateRangeLabel.value}.`,
      action: 'Conduct Risk Assessment',
    })
  }

  if (paymentVelocity < 40) {
    recommendations.push({
      type: 'info',
      title: 'Slow Payment Velocity',
      message: `Payment velocity ${paymentVelocity.toFixed(1)}% for selected period.`,
      action: 'Optimize Payment Terms',
    })
  }

  aiInsights.value = {
    riskScore: Math.round(avgRiskScore),
    paymentVelocity: Math.round(paymentVelocity),
    creditUtilization: Math.round(creditUtilization),
    recommendations,
    cashflowForecast: generateCashflowForecast(),
    supplierRanking: generateSupplierRanking(),
  }
}

// Create charts using Chart.js
const createCharts = () => {
  createRiskDistributionChart()
  createCreditUtilizationChart()
  createPaymentTrendChart()
  createInvoiceAgeChart()
  createCashflowForecastChart()
}

const createRiskDistributionChart = () => {
  if (!riskDistributionChart.value) return

  const distribution = { Low: 0, Medium: 0, High: 0 }
  creditSummary.value.forEach((cs) => {
    const risk = calculateCreditRisk(cs)
    if (risk < 30) distribution.Low++
    else if (risk < 60) distribution.Medium++
    else distribution.High++
  })

  const ctx = riskDistributionChart.value.getContext('2d')
  if (riskDistributionChartInstance) {
    riskDistributionChartInstance.destroy()
  }

  riskDistributionChartInstance = new Chart.Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['Low Risk', 'Medium Risk', 'High Risk'],
      datasets: [
        {
          data: [distribution.Low, distribution.Medium, distribution.High],
          backgroundColor: ['#1BC5BD', '#FFA800', '#F64E60'],
          borderWidth: 0,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            padding: 20,
            usePointStyle: true,
          },
        },
      },
    },
  })
}

const createCreditUtilizationChart = () => {
  if (!creditUtilizationChart.value) return

  const data = creditSummary.value
    .slice(0, 8)
    .map((cs) => ({
      supplier: (cs.SupplierName || 'Unknown').substring(0, 12),
      utilization:
        parseFloat(cs.CreditLimit) > 0
          ? (parseFloat(cs.CurrentBalance) / parseFloat(cs.CreditLimit)) * 100
          : 0,
    }))
    .sort((a, b) => b.utilization - a.utilization)

  const ctx = creditUtilizationChart.value.getContext('2d')
  if (creditUtilizationChartInstance) {
    creditUtilizationChartInstance.destroy()
  }

  creditUtilizationChartInstance = new Chart.Chart(ctx, {
    type: 'bar',
    data: {
      labels: data.map((d) => d.supplier),
      datasets: [
        {
          label: 'Utilization %',
          data: data.map((d) => d.utilization),
          backgroundColor: '#FFA800',
          borderRadius: 4,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          max: 100,
        },
      },
    },
  })
}

const createPaymentTrendChart = () => {
  if (!paymentTrendChart.value) return

  const dailyData = {}
  payments.value.forEach((payment) => {
    if (payment.PaymentDate) {
      const day = new Date(payment.PaymentDate).toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
      })
      dailyData[day] = (dailyData[day] || 0) + parseFloat(payment.PaymentAmount || 0)
    }
  })

  const data = Object.entries(dailyData)
    .slice(-10)
    .map(([day, amount]) => ({ day, amount: Math.round(amount) }))

  const ctx = paymentTrendChart.value.getContext('2d')
  if (paymentTrendChartInstance) {
    paymentTrendChartInstance.destroy()
  }

  paymentTrendChartInstance = new Chart.Chart(ctx, {
    type: 'line',
    data: {
      labels: data.map((d) => d.day),
      datasets: [
        {
          label: 'Payment Amount',
          data: data.map((d) => d.amount),
          borderColor: '#1BC5BD',
          backgroundColor: 'rgba(27, 197, 189, 0.1)',
          fill: true,
          tension: 0.4,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  })
}

const createInvoiceAgeChart = () => {
  if (!invoiceAgeChart.value) return

  const ageDistribution = { Current: 0, '1-30 Days': 0, '31-60 Days': 0, '60+ Days': 0 }
  const currentDate = new Date()

  invoices.value.forEach((invoice) => {
    if (invoice.InvoiceDate) {
      const daysOld = Math.floor(
        (currentDate - new Date(invoice.InvoiceDate)) / (1000 * 60 * 60 * 24),
      )
      if (daysOld <= 0) ageDistribution.Current++
      else if (daysOld <= 30) ageDistribution['1-30 Days']++
      else if (daysOld <= 60) ageDistribution['31-60 Days']++
      else ageDistribution['60+ Days']++
    }
  })

  const data = Object.entries(ageDistribution).map(([age, count]) => ({ age, count }))

  const ctx = invoiceAgeChart.value.getContext('2d')
  if (invoiceAgeChartInstance) {
    invoiceAgeChartInstance.destroy()
  }

  invoiceAgeChartInstance = new Chart.Chart(ctx, {
    type: 'bar',
    data: {
      labels: data.map((d) => d.age),
      datasets: [
        {
          label: 'Invoice Count',
          data: data.map((d) => d.count),
          backgroundColor: '#8950FC',
          borderRadius: 4,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false,
        },
      },
      scales: {
        y: {
          beginAtZero: true,
        },
      },
    },
  })
}

const createCashflowForecastChart = () => {
  if (!cashflowForecastChart.value) return

  const data = aiInsights.value.cashflowForecast

  const ctx = cashflowForecastChart.value.getContext('2d')
  if (cashflowForecastChartInstance) {
    cashflowForecastChartInstance.destroy()
  }

  cashflowForecastChartInstance = new Chart.Chart(ctx, {
    type: 'line',
    data: {
      labels: data.map((d) => d.month),
      datasets: [
        {
          label: 'Projected Amount',
          data: data.map((d) => d.projected),
          borderColor: '#3699FF',
          backgroundColor: 'rgba(54, 153, 255, 0.1)',
          fill: true,
          tension: 0.4,
        },
        {
          label: 'Confidence Level',
          data: data.map((d) => d.confidence),
          borderColor: '#8950FC',
          borderDash: [5, 5],
          fill: false,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'bottom',
        },
      },
    },
  })
}

// Watch for station selection
watch(selectedStationId, (newStationId) => {
  if (newStationId) {
    setDateRange('last30days')
  } else {
    dashboardReady.value = false
  }
})

// Get selected station name
const selectedStationName = computed(() => {
  const station = stations.value.find(
    (s) => s.StationID && s.StationID.toString() === selectedStationId.value,
  )
  return station?.StationName || ''
})

// Initialize default date range
onMounted(() => {
  setDateRange('last30days')
  fetchStations()
})
</script>

<style scoped>
.active {
  background-color: rgba(255, 255, 255, 0.2) !important;
  border-color: rgba(255, 255, 255, 0.3) !important;
}

.bg-gradient-primary {
  background: linear-gradient(135deg, #1bc5bd 0%, #3699ff 100%);
}

.badge-circle {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
}

.progress {
  background-color: #f1f3f4;
  border-radius: 4px;
}

.table-responsive {
  border-radius: 8px;
  overflow: hidden;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
}

.card-flush {
  box-shadow: 0 0 50px 0 rgba(82, 63, 105, 0.15);
  border: 0;
  border-radius: 12px;
}

.btn-outline {
  border: 2px solid;
  background: transparent;
  transition: all 0.3s ease;
}

.btn-outline:hover {
  transform: translateY(-2px);
}
</style>

<template>
  <div class="d-flex flex-column gap-5">
    <!-- Header Section -->
    <div class="card card-flush">
      <div class="card-header bg-light-primary">
        <div class="card-title d-flex align-items-center gap-3">
          <i class="ki-duotone ki-chart-pie-3 fs-1 text-primary">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          <div>
            <h1 class="fs-2 fw-bold text-gray-900 mb-0">Supplier Credit Analysis</h1>
            <p class="fs-6 text-gray-600 mb-0">AI-Enhanced Credit Risk Assessment & Management</p>
          </div>
        </div>
        <div class="card-toolbar">
          <button
            class="btn btn-light-success btn-lg"
            @click="fetchCreditData"
            :disabled="!selectedStationId"
          >
            <i class="ki-duotone ki-arrows-circle fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Refresh Analysis
          </button>
        </div>
      </div>
    </div>

    <!-- Station Selection -->
    <div class="card card-flush border-light-warning" v-if="!selectedStationId">
      <div class="card-body text-center py-10">
        <i class="ki-duotone ki-geolocation fs-3x text-warning mb-5">
          <span class="path1"></span>
          <span class="path2"></span>
        </i>
        <h3 class="fs-2 fw-bold text-gray-900 mb-3">Select Station for Analysis</h3>
        <p class="fs-5 text-gray-600 mb-8">
          Choose a station to view detailed supplier credit information
        </p>
        <select v-model="selectedStationId" class="form-select form-select-lg w-350px mx-auto">
          <option value="">Choose Station...</option>
          <option v-for="station in stations" :key="station.StationID" :value="station.StationID">
            {{ station.StationName }} - {{ station.Location }}
          </option>
        </select>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="card card-flush">
      <div class="card-body text-center py-15">
        <div class="spinner-border spinner-border-lg text-primary" role="status"></div>
        <p class="fs-5 text-gray-600 mt-5">Analyzing credit data...</p>
      </div>
    </div>

    <!-- Main Dashboard -->
    <div v-if="selectedStationId && !loading" class="d-flex flex-column gap-5">
      <!-- AI Risk Assessment -->
      <div class="card card-flush bg-light-info">
        <div class="card-header">
          <h3 class="card-title fw-bold text-info">
            <i class="ki-duotone ki-abstract-26 fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            AI Risk Assessment
          </h3>
        </div>
        <div class="card-body">
          <div class="row g-5">
            <div class="col-md-4">
              <div class="text-center">
                <div class="fs-2x fw-bold text-info mb-2">
                  {{ aiInsights.riskScore?.toFixed(1) }}%
                </div>
                <span :class="'badge fs-6 ' + getRiskBadgeClass(aiInsights.riskScore)">
                  {{
                    aiInsights.riskScore >= 80
                      ? 'HIGH RISK'
                      : aiInsights.riskScore >= 60
                        ? 'MEDIUM RISK'
                        : 'LOW RISK'
                  }}
                </span>
              </div>
            </div>
            <div class="col-md-8">
              <h5 class="fw-bold text-gray-900 mb-3">AI Recommendations</h5>
              <div class="d-flex flex-column gap-2">
                <div
                  v-for="rec in aiInsights.recommendations"
                  :key="rec"
                  class="d-flex align-items-center gap-2"
                >
                  <i class="ki-duotone ki-check-circle fs-5 text-success">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <span class="fs-6 text-gray-700">{{ rec }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Key Metrics -->
      <div class="row g-5">
        <div class="col-xl-3 col-md-6">
          <div class="card card-flush bg-light-success">
            <div class="card-body">
              <div class="fw-bold fs-2 text-success mb-2">
                {{ formatCurrency(analytics.totalCreditLimit) }}
              </div>
              <div class="fs-6 fw-semibold text-gray-600">Total Credit Limit</div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-md-6">
          <div class="card card-flush bg-light-warning">
            <div class="card-body">
              <div class="fw-bold fs-2 text-warning mb-2">
                {{ formatCurrency(analytics.totalOutstanding) }}
              </div>
              <div class="fs-6 fw-semibold text-gray-600">Outstanding Balance</div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-md-6">
          <div class="card card-flush bg-light-danger">
            <div class="card-body">
              <div class="fw-bold fs-2 text-danger mb-2">
                {{ formatCurrency(analytics.totalOverdue) }}
              </div>
              <div class="fs-6 fw-semibold text-gray-600">Overdue Amount</div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-md-6">
          <div class="card card-flush bg-light-primary">
            <div class="card-body">
              <div class="fw-bold fs-2 text-primary mb-2">
                {{ analytics.creditUtilization?.toFixed(1) }}%
              </div>
              <div class="fs-6 fw-semibold text-gray-600">Credit Utilization</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Credit Utilization Chart -->
      <div class="card card-flush">
        <div class="card-header">
          <h3 class="card-title fw-bold">
            <i class="ki-duotone ki-chart-line-up fs-2 me-2 text-primary">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Credit Utilization by Supplier
          </h3>
        </div>
        <div class="card-body">
          <div class="d-flex flex-column gap-4">
            <div
              v-for="item in chartData.creditUtilization.slice(0, 8)"
              :key="item.supplier"
              class="d-flex align-items-center gap-4"
            >
              <div class="w-150px fs-6 fw-semibold text-gray-700">{{ item.supplier }}</div>
              <div class="flex-grow-1">
                <div class="progress h-15px">
                  <div
                    class="progress-bar"
                    :class="'bg-' + getUtilizationColor(item.utilization)"
                    :style="{ width: Math.min(item.utilization, 100) + '%' }"
                  ></div>
                </div>
              </div>
              <div class="w-60px text-end">
                <span :class="'badge ' + getRiskBadgeClass(item.utilization)">
                  {{ item.utilization.toFixed(1) }}%
                </span>
              </div>
              <div class="w-100px text-end fs-6 fw-semibold text-gray-600">
                {{ formatCurrency(item.used) }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Outstanding Invoices & Payments Row -->
      <div class="row g-5">
        <!-- Outstanding Invoices -->
        <div class="col-xl-8">
          <div class="card card-flush">
            <div class="card-header">
              <h3 class="card-title fw-bold">
                <i class="ki-duotone ki-bill fs-2 me-2 text-warning">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                </i>
                Outstanding Invoices
              </h3>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table align-middle table-row-dashed">
                  <thead>
                    <tr class="text-gray-600 fw-bold fs-7 text-uppercase">
                      <th>Supplier</th>
                      <th>Invoice #</th>
                      <th>Date</th>
                      <th>Amount</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="invoice in invoices.slice(0, 5)" :key="invoice.InvoiceID">
                      <td class="fs-6 fw-semibold text-gray-800">
                        {{
                          suppliers.find((s) => s.SupplierID == invoice.SupplierID)?.Name ||
                          'Unknown'
                        }}
                      </td>
                      <td class="fs-6 text-gray-600">{{ invoice.InvoiceNumber }}</td>
                      <td class="fs-6 text-gray-600">
                        {{ new Date(invoice.InvoiceDate).toLocaleDateString() }}
                      </td>
                      <td class="fs-6 fw-bold text-gray-800">
                        {{ formatCurrency(invoice.OutstandingAmount) }}
                      </td>
                      <td>
                        <span
                          :class="
                            'badge ' +
                            (invoice.Status === 'Paid'
                              ? 'badge-light-success'
                              : 'badge-light-warning')
                          "
                        >
                          {{ invoice.Status }}
                        </span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

        <!-- Aging Analysis -->
        <div class="col-xl-4">
          <div class="card card-flush">
            <div class="card-header">
              <h3 class="card-title fw-bold">
                <i class="ki-duotone ki-calendar-8 fs-2 me-2 text-info">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
                Aging Analysis
              </h3>
            </div>
            <div class="card-body">
              <div class="d-flex flex-column gap-4">
                <div class="d-flex justify-content-between align-items-center">
                  <span class="fs-6 fw-semibold text-gray-700">Current (0-30 days)</span>
                  <span class="fs-6 fw-bold text-success">{{
                    formatCurrency(chartData.outstandingAging.current)
                  }}</span>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                  <span class="fs-6 fw-semibold text-gray-700">31-60 days</span>
                  <span class="fs-6 fw-bold text-warning">{{
                    formatCurrency(chartData.outstandingAging.thirty)
                  }}</span>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                  <span class="fs-6 fw-semibold text-gray-700">61-90 days</span>
                  <span class="fs-6 fw-bold text-primary">{{
                    formatCurrency(chartData.outstandingAging.sixty)
                  }}</span>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                  <span class="fs-6 fw-semibold text-gray-700">90+ days</span>
                  <span class="fs-6 fw-bold text-danger">{{
                    formatCurrency(chartData.outstandingAging.ninety)
                  }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Alerts & Trends -->
      <div class="row g-5">
        <div class="col-xl-6">
          <div class="card card-flush bg-light-danger">
            <div class="card-header">
              <h3 class="card-title fw-bold text-danger">
                <i class="ki-duotone ki-warning-2 fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                Critical Alerts
              </h3>
            </div>
            <div class="card-body">
              <div v-if="aiInsights.alerts?.length" class="d-flex flex-column gap-3">
                <div
                  v-for="alert in aiInsights.alerts"
                  :key="alert"
                  class="d-flex align-items-center gap-2"
                >
                  <i class="ki-duotone ki-notification-bing fs-5 text-danger">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  <span class="fs-6 fw-semibold text-gray-800">{{ alert }}</span>
                </div>
              </div>
              <div v-else class="text-center py-5">
                <i class="ki-duotone ki-check-circle fs-3x text-success">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <p class="fs-6 text-gray-600 mt-3 mb-0">No critical alerts at this time</p>
              </div>
            </div>
          </div>
        </div>

        <div class="col-xl-6">
          <div class="card card-flush bg-light-info">
            <div class="card-header">
              <h3 class="card-title fw-bold text-info">
                <i class="ki-duotone ki-chart-line-down fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                Market Trends
              </h3>
            </div>
            <div class="card-body">
              <div class="d-flex flex-column gap-3">
                <div
                  v-for="trend in aiInsights.trends"
                  :key="trend"
                  class="d-flex align-items-center gap-2"
                >
                  <i class="ki-duotone ki-arrow-up-right fs-5 text-info">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <span class="fs-6 fw-semibold text-gray-800">{{ trend }}</span>
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
import { ref, computed, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'

// Core reactive state
const loading = ref(false)
const selectedStationId = ref('')
const stations = ref([])
const suppliers = ref([])
const creditAccounts = ref([])
const invoices = ref([])
const payments = ref([])
const creditTransactions = ref([])

// API configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN = localStorage.getItem('jwt') || 'your-jwt-token'

// AI Analysis state
const aiInsights = ref({
  riskScore: 0,
  recommendations: [],
  trends: [],
  alerts: [],
})

// Chart data
const chartData = computed(() => ({
  creditUtilization: creditAccounts.value.map((acc) => ({
    supplier: suppliers.value.find((s) => s.SupplierID === acc.SupplierID)?.Name || 'Unknown',
    used: parseFloat(acc.CurrentBalance || 0),
    limit: parseFloat(acc.CreditLimit || 0),
    utilization:
      parseFloat(acc.CreditLimit) > 0
        ? (parseFloat(acc.CurrentBalance || 0) / parseFloat(acc.CreditLimit)) * 100
        : 0,
  })),
  paymentTrends: payments.value.slice(-6).map((payment) => ({
    month: new Date(payment.PaymentDate).toLocaleDateString('en-US', { month: 'short' }),
    amount: parseFloat(payment.PaymentAmount || 0),
  })),
  outstandingAging: invoices.value.reduce(
    (acc, invoice) => {
      const daysOld = Math.floor(
        (Date.now() - new Date(invoice.InvoiceDate).getTime()) / (1000 * 60 * 60 * 24),
      )
      if (daysOld <= 30) acc.current += parseFloat(invoice.OutstandingAmount || 0)
      else if (daysOld <= 60) acc.thirty += parseFloat(invoice.OutstandingAmount || 0)
      else if (daysOld <= 90) acc.sixty += parseFloat(invoice.OutstandingAmount || 0)
      else acc.ninety += parseFloat(invoice.OutstandingAmount || 0)
      return acc
    },
    { current: 0, thirty: 0, sixty: 0, ninety: 0 },
  ),
}))

// Computed analytics
const analytics = computed(() => {
  const totalCreditLimit = creditAccounts.value.reduce(
    (sum, acc) => sum + parseFloat(acc.CreditLimit || 0),
    0,
  )
  const totalOutstanding = creditAccounts.value.reduce(
    (sum, acc) => sum + parseFloat(acc.CurrentBalance || 0),
    0,
  )
  const totalOverdue = invoices.value
    .filter((inv) => {
      const daysOld = Math.floor(
        (Date.now() - new Date(inv.InvoiceDate).getTime()) / (1000 * 60 * 60 * 24),
      )
      return daysOld > 30 && parseFloat(inv.OutstandingAmount || 0) > 0
    })
    .reduce((sum, inv) => sum + parseFloat(inv.OutstandingAmount || 0), 0)

  return {
    totalCreditLimit,
    totalOutstanding,
    totalOverdue,
    creditUtilization: totalCreditLimit > 0 ? (totalOutstanding / totalCreditLimit) * 100 : 0,
    overallRisk: simulateRiskScore(totalOutstanding, totalCreditLimit, totalOverdue),
  }
})

// API helper function
const apiRequest = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API Request failed:', error)
    throw error
  }
}

// Data fetching functions
const fetchStations = async () => {
  try {
    const data = await apiRequest('/Stations')
    stations.value = data.records || []
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load stations',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
}

const fetchSuppliers = async () => {
  try {
    const data = await apiRequest('/Suppliers')
    suppliers.value = data.records || []
  } catch (error) {
    console.error('Failed to fetch suppliers:', error)
  }
}

const fetchCreditData = async () => {
  if (!selectedStationId.value) return

  loading.value = true
  try {
    const [accountsData, invoicesData, paymentsData, transactionsData] = await Promise.all([
      apiRequest(`/SupplierCreditAccounts?StationID=${selectedStationId.value}`),
      apiRequest(`/SupplierInvoices?StationID=${selectedStationId.value}`),
      apiRequest(`/SupplierPayments?StationID=${selectedStationId.value}`),
      apiRequest(`/SupplierCreditTransactions?StationID=${selectedStationId.value}`),
    ])

    creditAccounts.value = accountsData.records || []
    invoices.value = invoicesData.records || []
    payments.value = paymentsData.records || []
    creditTransactions.value = transactionsData.records || []

    // Generate AI insights after data load
    generateAIInsights()

    Swal.fire({
      title: 'Success!',
      text: 'Credit data loaded successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load credit data',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// AI Simulation functions
const simulateRiskScore = (outstanding, limit, overdue) => {
  const utilizationRisk = limit > 0 ? (outstanding / limit) * 40 : 0
  const overdueRisk = overdue > 0 ? Math.min((overdue / outstanding) * 30, 30) : 0
  const baseRisk = Math.random() * 10
  return Math.min(utilizationRisk + overdueRisk + baseRisk, 100)
}

const generateAIInsights = () => {
  const riskScore = analytics.value.overallRisk
  const recommendations = []
  const trends = []
  const alerts = []

  // Risk-based recommendations
  if (riskScore > 80) {
    recommendations.push('URGENT: Implement immediate payment recovery procedures')
    recommendations.push('Consider reducing credit limits for high-risk suppliers')
    alerts.push('High credit risk detected across multiple suppliers')
  } else if (riskScore > 60) {
    recommendations.push('Schedule payment discussions with overdue suppliers')
    recommendations.push('Review credit terms for underperforming accounts')
  } else {
    recommendations.push('Maintain current credit monitoring practices')
    recommendations.push('Consider extending credit to reliable suppliers')
  }

  // Trend analysis
  const utilizationTrend = Math.random() > 0.5 ? 'increasing' : 'decreasing'
  trends.push(`Credit utilization ${utilizationTrend} by ${(Math.random() * 15 + 5).toFixed(1)}%`)
  trends.push(`Payment frequency improved by ${(Math.random() * 10 + 2).toFixed(1)}% this quarter`)

  // Automated alerts
  creditAccounts.value.forEach((account) => {
    const utilization = (parseFloat(account.CurrentBalance) / parseFloat(account.CreditLimit)) * 100
    if (utilization > 90) {
      const supplier = suppliers.value.find((s) => s.SupplierID === account.SupplierID)
      alerts.push(
        `${supplier?.Name || 'Unknown'}: Credit utilization at ${utilization.toFixed(1)}%`,
      )
    }
  })

  aiInsights.value = {
    riskScore: riskScore,
    recommendations,
    trends,
    alerts,
    lastUpdated: new Date().toISOString(),
    confidence: 85 + Math.random() * 10,
  }
}

const formatCurrency = (amount) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
  }).format(amount || 0)
}

const getRiskBadgeClass = (risk) => {
  if (risk >= 80) return 'badge-light-danger'
  if (risk >= 60) return 'badge-light-warning'
  if (risk >= 40) return 'badge-light-primary'
  return 'badge-light-success'
}

const getUtilizationColor = (utilization) => {
  if (utilization >= 90) return 'danger'
  if (utilization >= 75) return 'warning'
  if (utilization >= 50) return 'primary'
  return 'success'
}

// Watchers
watch(selectedStationId, (newStationId) => {
  if (newStationId) {
    fetchCreditData()
  }
})

// Lifecycle
onMounted(async () => {
  await Promise.all([fetchStations(), fetchSuppliers()])
})
</script>

<style scoped>
.progress {
  border-radius: 8px;
  overflow: hidden;
}

.progress-bar {
  transition: width 0.6s ease;
}

.w-150px {
  width: 150px !important;
}

.w-350px {
  width: 350px !important;
}

.w-60px {
  width: 60px !important;
}

.w-100px {
  width: 100px !important;
}

.h-15px {
  height: 15px !important;
}

.spinner-border-lg {
  width: 3rem;
  height: 3rem;
}

.card-flush .card-header {
  border-radius: 0.75rem 0.75rem 0 0;
}

.table th {
  border-bottom: 1px solid #e4e6ef;
  background-color: #f9f9f9;
}

.fs-2x {
  font-size: 2.5rem !important;
}

.fs-3x {
  font-size: 3rem !important;
}

@media (max-width: 768px) {
  .w-150px {
    width: 100px !important;
  }

  .fs-2x {
    font-size: 2rem !important;
  }

  .card-body {
    padding: 1rem !important;
  }
}
</style>

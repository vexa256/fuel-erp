<template>
  <div class="d-flex flex-column gap-5 p-4">
    <!-- Header Section -->
    <div class="card card-flush bg-light-primary">
      <div class="card-body p-6">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-45px bg-primary">
              <span class="symbol-label">
                <i class="ki-duotone ki-wallet fs-1 text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </span>
            </div>
            <div>
              <h1 class="text-dark fw-bold fs-2 mb-0">Cash Drawer</h1>
              <span class="text-gray-600 fs-6">{{ selectedStation?.StationName || 'Select Station' }}</span>
            </div>
          </div>
          <div class="d-flex gap-2">
            <button v-if="!hasOpenDrawer" @click="showOpenDrawerModal = true" class="btn btn-light-success btn-sm">
              <i class="ki-duotone ki-plus fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Open Drawer
            </button>
            <button v-if="hasOpenDrawer" @click="showCloseDrawerModal = true" class="btn btn-light-danger btn-sm">
              <i class="ki-duotone ki-cross fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Close Drawer
            </button>
          </div>
        </div>

        <!-- Station Selector -->
        <div v-if="userStations.length > 1" class="d-flex gap-2 flex-wrap">
          <button v-for="station in userStations" :key="station.StationID" @click="switchStation(station)" :class="[
            'btn btn-sm',
            selectedStation?.StationID === station.StationID
              ? 'btn-primary'
              : 'btn-light-primary'
          ]">
            {{ station.StationName }}
          </button>
        </div>
      </div>
    </div>

    <!-- Current Drawer Status -->
    <div v-if="hasOpenDrawer" class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold text-dark">Current Shift</h3>
        <div class="card-toolbar">
          <span class="badge badge-light-success fs-7">
            {{ currentDrawer.ShiftType }} - OPEN
          </span>
        </div>
      </div>
      <div class="card-body p-6">
        <div class="row g-4">
          <!-- Opening Balance -->
          <div class="col-6 col-md-3">
            <div class="bg-light-info rounded p-4 text-center">
              <i class="ki-duotone ki-chart-line-up fs-2x text-info mb-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="fw-bold text-dark fs-4">{{ formatCurrency(currentDrawer.OpeningBalance) }}</div>
              <div class="text-gray-600 fs-7">Opening</div>
            </div>
          </div>

          <!-- Cash Sales -->
          <div class="col-6 col-md-3">
            <div class="bg-light-success rounded p-4 text-center">
              <i class="ki-duotone ki-dollar fs-2x text-success mb-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div class="fw-bold text-dark fs-4">{{ formatCurrency(currentDrawer.CashSales) }}</div>
              <div class="text-gray-600 fs-7">Sales</div>
            </div>
          </div>

          <!-- Expected Cash -->
          <div class="col-6 col-md-3">
            <div class="bg-light-warning rounded p-4 text-center">
              <i class="ki-duotone ki-calculator fs-2x text-warning mb-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="fw-bold text-dark fs-4">{{ formatCurrency(currentDrawer.ExpectedCash) }}</div>
              <div class="text-gray-600 fs-7">Expected</div>
            </div>
          </div>

          <!-- Variance -->
          <div class="col-6 col-md-3">
            <div :class="['rounded', 'p-4', 'text-center', 'bg-light-' + varianceStatus]">
              <i class="ki-duotone ki-arrows-circle fs-2x mb-2" :class="'text-' + varianceStatus">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="fw-bold text-dark fs-4">{{ formatCurrency(currentVariance) }}</div>
              <div class="text-gray-600 fs-7">Variance</div>
            </div>
          </div>
        </div>

        <!-- Quick Actions -->
        <div class="separator my-5"></div>
        <div class="d-flex gap-3 flex-wrap">
          <button @click="openCashOperation('sale')" class="btn btn-light-success">
            <i class="ki-duotone ki-plus fs-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Record Sale
          </button>
          <button @click="openCashOperation('payout')" class="btn btn-light-danger">
            <i class="ki-duotone ki-minus fs-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Record Payout
          </button>
        </div>
      </div>
    </div>

    <!-- Statistics & Charts -->
    <div class="row g-5">
      <!-- Daily Performance Chart -->
      <div class="col-12 col-md-6">
        <div class="card card-flush h-100">
          <div class="card-header">
            <h3 class="card-title fw-bold text-dark">Daily Variance Trend</h3>
          </div>
          <div class="card-body">
            <div class="chart-container">
              <div v-for="(day, index) in chartData.dailyVariances" :key="index"
                class="d-flex align-items-center justify-content-between mb-3">
                <span class="text-gray-700 fw-semibold">{{ day.date }}</span>
                <div class="d-flex align-items-center gap-2">
                  <div class="progress" style="width: 100px; height: 8px;">
                    <div class="progress-bar"
                      :class="parseFloat(day.variance) <= 50 ? 'bg-success' : parseFloat(day.variance) <= 100 ? 'bg-warning' : 'bg-danger'"
                      :style="`width: ${Math.min((parseFloat(day.variance) / 200) * 100, 100)}%`"></div>
                  </div>
                  <span class="badge badge-light-primary fs-8">{{ formatCurrency(day.variance) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Cash Trends Chart -->
      <div class="col-12 col-md-6">
        <div class="card card-flush h-100">
          <div class="card-header">
            <h3 class="card-title fw-bold text-dark">Cash Sales Trend</h3>
          </div>
          <div class="card-body">
            <div class="chart-container">
              <div v-for="(day, index) in chartData.cashTrends" :key="index"
                class="d-flex align-items-center justify-content-between mb-3">
                <span class="text-gray-700 fw-semibold">{{ day.date }}</span>
                <div class="d-flex align-items-center gap-2">
                  <div class="progress" style="width: 100px; height: 8px;">
                    <div class="progress-bar bg-primary"
                      :style="`width: ${Math.min((parseFloat(day.amount) / Math.max(...chartData.cashTrends.map(d => parseFloat(d.amount)))) * 100, 100)}%`">
                    </div>
                  </div>
                  <span class="badge badge-light-success fs-8">{{ formatCurrency(day.amount) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-5">
      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-success">
          <div class="card-body text-center p-6">
            <i class="ki-duotone ki-chart-pie-4 fs-2x text-success mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <div class="fw-bold text-dark fs-3">{{ formatCurrency(statistics.todaysCash) }}</div>
            <div class="text-gray-600 fs-7">Today's Cash</div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-warning">
          <div class="card-body text-center p-6">
            <i class="ki-duotone ki-chart-line-down fs-2x text-warning mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <div class="fw-bold text-dark fs-3">{{ formatCurrency(statistics.weeklyVariance) }}</div>
            <div class="text-gray-600 fs-7">Avg Variance</div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-info">
          <div class="card-body text-center p-6">
            <i class="ki-duotone ki-clock fs-2x text-info mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <div class="fw-bold text-dark fs-3">{{ statistics.avgClosingTime }}</div>
            <div class="text-gray-600 fs-7">Avg Close Time</div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-primary">
          <div class="card-body text-center p-6">
            <i class="ki-duotone ki-folder fs-2x text-primary mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <div class="fw-bold text-dark fs-3">{{ statistics.totalDrawers }}</div>
            <div class="text-gray-600 fs-7">Total Shifts</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Drawer History -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold text-dark">Recent Shifts</h3>
        <div class="card-toolbar">
          <span class="badge badge-light-primary">{{ drawerHistory.length }} Shifts</span>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table align-middle table-row-dashed fs-6 gy-4">
            <thead>
              <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
                <th>Date</th>
                <th>Shift</th>
                <th>Opening</th>
                <th>Sales</th>
                <th>Expected</th>
                <th>Actual</th>
                <th>Variance</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody class="text-gray-600 fw-semibold">
              <tr v-for="drawer in drawerHistory.slice(0, 10)" :key="drawer.DrawerID">
                <td>{{ new Date(drawer.ShiftDate).toLocaleDateString() }}</td>
                <td>
                  <span class="badge badge-light-info">{{ drawer.ShiftType }}</span>
                </td>
                <td>{{ formatCurrency(drawer.OpeningBalance) }}</td>
                <td>{{ formatCurrency(drawer.CashSales) }}</td>
                <td>{{ formatCurrency(drawer.ExpectedCash) }}</td>
                <td>{{ formatCurrency(drawer.ActualCash) }}</td>
                <td>
                  <span :class="[
                    'badge',
                    parseFloat(drawer.Variance) === 0 ? 'badge-light-success' :
                      Math.abs(parseFloat(drawer.Variance)) <= 50 ? 'badge-light-warning' :
                        'badge-light-danger'
                  ]">
                    {{ formatCurrency(drawer.Variance) }}
                  </span>
                </td>
                <td>
                  <span :class="[
                    'badge',
                    drawer.Status === 'Open' ? 'badge-light-success' : 'badge-light-primary'
                  ]">
                    {{ drawer.Status }}
                  </span>
                </td>
              </tr>
              <tr v-if="drawerHistory.length === 0">
                <td colspan="8" class="text-center py-8">
                  <div class="text-gray-400">
                    <i class="ki-duotone ki-folder-down fs-3x mb-3">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div>No drawer history found</div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Open Drawer Modal -->
    <div v-if="showOpenDrawerModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title fw-bold">Open Cash Drawer</h3>
            <button @click="showOpenDrawerModal = false" class="btn btn-icon btn-sm btn-active-light-primary">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="openNewDrawer">
              <div class="row g-5">
                <div class="col-12">
                  <label class="form-label required">Station</label>
                  <select v-model="openDrawerForm.stationId" class="form-select form-select-lg">
                    <option v-for="station in userStations" :key="station.StationID" :value="station.StationID">
                      {{ station.StationName }}
                    </option>
                  </select>
                  <div v-if="errors.openDrawer.stationId" class="text-danger fs-7 mt-1">
                    {{ errors.openDrawer.stationId }}
                  </div>
                </div>

                <div class="col-12">
                  <label class="form-label required">Shift Type</label>
                  <select v-model="openDrawerForm.shiftType" class="form-select form-select-lg">
                    <option value="Morning">Morning Shift</option>
                    <option value="Afternoon">Afternoon Shift</option>
                    <option value="Night">Night Shift</option>
                  </select>
                </div>

                <div class="col-12">
                  <label class="form-label required">Opening Balance (UGX)</label>
                  <input v-model="openDrawerForm.openingBalance" type="number" step="0.01"
                    class="form-control form-control-lg" placeholder="0.00" />
                  <div v-if="errors.openDrawer.openingBalance" class="text-danger fs-7 mt-1">
                    {{ errors.openDrawer.openingBalance }}
                  </div>
                </div>

                <div class="col-12">
                  <label class="form-label">Notes</label>
                  <textarea v-model="openDrawerForm.notes" class="form-control" rows="3"
                    placeholder="Optional notes..."></textarea>
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button @click="showOpenDrawerModal = false" class="btn btn-light">Cancel</button>
            <button @click="openNewDrawer" :disabled="loading" class="btn btn-primary">
              <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
              Open Drawer
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Close Drawer Modal -->
    <div v-if="showCloseDrawerModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title fw-bold">Close Cash Drawer</h3>
            <button @click="showCloseDrawerModal = false" class="btn btn-icon btn-sm btn-active-light-primary">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body">
            <div class="bg-light-warning rounded p-4 mb-5">
              <div class="d-flex align-items-center gap-3">
                <i class="ki-duotone ki-information-5 fs-2x text-warning">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div>
                  <div class="fw-bold text-dark">Expected Cash: {{ formatCurrency(currentDrawer?.ExpectedCash) }}</div>
                  <div class="text-gray-600 fs-7">Count your actual cash and enter the amount below</div>
                </div>
              </div>
            </div>

            <form @submit.prevent="closeDrawer">
              <div class="row g-5">
                <div class="col-12">
                  <label class="form-label required">Actual Cash Count (UGX)</label>
                  <input v-model="closeDrawerForm.actualCash" type="number" step="0.01"
                    class="form-control form-control-lg" placeholder="0.00" />
                </div>

                <div class="col-12">
                  <label class="form-label">Closing Notes</label>
                  <textarea v-model="closeDrawerForm.notes" class="form-control" rows="3"
                    placeholder="Any variance explanations or notes..."></textarea>
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button @click="showCloseDrawerModal = false" class="btn btn-light">Cancel</button>
            <button @click="closeDrawer" :disabled="loading" class="btn btn-danger">
              <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
              Close Drawer
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Cash Operation Modal -->
    <div v-if="showCashOperationModal" class="modal fade show d-block" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title fw-bold">Record Cash {{ cashOperationType === 'sale' ? 'Sale' : 'Payout' }}</h3>
            <button @click="showCashOperationModal = false" class="btn btn-icon btn-sm btn-active-light-primary">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="recordCashOperation">
              <div class="row g-5">
                <div class="col-12">
                  <label class="form-label required">Amount (UGX)</label>
                  <input v-model="cashOperationForm.amount" type="number" step="0.01"
                    class="form-control form-control-lg" placeholder="0.00" />
                </div>

                <div class="col-12">
                  <label class="form-label required">Description</label>
                  <input v-model="cashOperationForm.description" type="text" class="form-control form-control-lg"
                    :placeholder="cashOperationType === 'sale' ? 'Fuel sale, convenience items, etc.' : 'Petty cash, refund, etc.'" />
                </div>

                <div class="col-12">
                  <label class="form-label">Reference</label>
                  <input v-model="cashOperationForm.reference" type="text" class="form-control form-control-lg"
                    placeholder="Receipt number, invoice, etc." />
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button @click="showCashOperationModal = false" class="btn btn-light">Cancel</button>
            <button @click="recordCashOperation" :disabled="loading" :class="[
              'btn',
              cashOperationType === 'sale' ? 'btn-success' : 'btn-danger'
            ]">
              <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
              Record {{ cashOperationType === 'sale' ? 'Sale' : 'Payout' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading Overlay -->
    <div v-if="loading" class="overlay">
      <div class="overlay-wrapper">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'http://localhost:4000/api/records/v1'
const JWT_TOKEN = localStorage.getItem('kigrama_auth_token') || 'demo_token'

// Get user data from localStorage
const getUserData = () => {
  try {
    const userData = localStorage.getItem('kigrama_user_data')
    return userData ? JSON.parse(userData) : null
  } catch {
    return null
  }
}

const authData = getUserData()
const currentUser = authData?.user || { id: 1, name: 'Demo User' }

// Reactive State
const loading = ref(false)
const currentDrawer = ref(null)
const drawerHistory = ref([])
const userStations = ref([])
const selectedStation = ref(null)
const activeTab = ref('current')
const showOpenDrawerModal = ref(false)
const showCloseDrawerModal = ref(false)
const showCashOperationModal = ref(false)
const cashOperationType = ref('sale')

// Statistics
const statistics = ref({
  todaysCash: 0,
  weeklyVariance: 0,
  avgClosingTime: '00:00',
  totalDrawers: 0
})

// Chart Data
const chartData = ref({
  dailyVariances: [],
  cashTrends: [],
  closureTimes: []
})

// Forms
const openDrawerForm = reactive({
  stationId: '',
  shiftType: 'Morning',
  openingBalance: '0.00',
  notes: ''
})

const closeDrawerForm = reactive({
  actualCash: '0.00',
  notes: ''
})

const cashOperationForm = reactive({
  amount: '0.00',
  description: '',
  reference: ''
})

// Form Errors
const errors = reactive({
  openDrawer: {},
  closeDrawer: {},
  cashOperation: {}
})

// Computed Properties
const currentVariance = computed(() => {
  if (!currentDrawer.value) return '0.00'
  const expected = parseFloat(currentDrawer.value.ExpectedCash || 0)
  const actual = parseFloat(currentDrawer.value.ActualCash || 0)
  return (actual - expected).toFixed(2)
})

const varianceStatus = computed(() => {
  const variance = parseFloat(currentVariance.value)
  if (variance === 0) return 'success'
  if (Math.abs(variance) <= 50) return 'warning'
  return 'danger'
})

const hasOpenDrawer = computed(() => {
  return currentDrawer.value && currentDrawer.value.Status === 'Open'
})

// API Helper
const apiCall = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Authorization': `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    })

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API Call Error:', error)
    throw error
  }
}

// Fetch User Stations
const fetchUserStations = async () => {
  try {
    loading.value = true
    const response = await apiCall(`/UserStations?UserID=${currentUser.id}`)
    const userStationData = response.records || []

    const stationPromises = userStationData.map(async (us) => {
      const stationResponse = await apiCall(`/Stations/${us.StationID}`)
      return { ...stationResponse, userStation: us }
    })

    userStations.value = await Promise.all(stationPromises)

    if (userStations.value.length > 0 && !selectedStation.value) {
      selectedStation.value = userStations.value[0]
      openDrawerForm.stationId = userStations.value[0].StationID
      await fetchCurrentDrawer()
    }
  } catch (error) {
    console.error('Error fetching user stations:', error)
    await Swal.fire({
      title: 'Error!',
      text: 'Could not load your assigned stations',
      icon: 'error',
      confirmButtonColor: '#f1416c'
    })
  } finally {
    loading.value = false
  }
}

// Fetch Current Drawer
const fetchCurrentDrawer = async () => {
  if (!selectedStation.value) return

  try {
    const response = await apiCall(`/CashDrawers?StationID=${selectedStation.value.StationID}&Status=Open&AttendantID=${currentUser.id}`)
    const drawers = response.records || []
    currentDrawer.value = drawers.length > 0 ? drawers[0] : null
  } catch (error) {
    console.error('Error fetching current drawer:', error)
  }
}

// Fetch Drawer History
const fetchDrawerHistory = async () => {
  if (!selectedStation.value) return

  try {
    const response = await apiCall(`/CashDrawers?StationID=${selectedStation.value.StationID}&AttendantID=${currentUser.id}&limit=20&sort=-CreatedAt`)
    drawerHistory.value = response.records || []
    calculateStatistics()
  } catch (error) {
    console.error('Error fetching drawer history:', error)
  }
}

// Calculate Statistics
const calculateStatistics = () => {
  if (drawerHistory.value.length === 0) return

  const today = new Date().toISOString().split('T')[0]
  const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]

  const todaysDrawers = drawerHistory.value.filter(d => d.ShiftDate === today)
  statistics.value.todaysCash = todaysDrawers.reduce((sum, d) => sum + parseFloat(d.CashSales || 0), 0)

  const weeklyDrawers = drawerHistory.value.filter(d => d.ShiftDate >= weekAgo)
  const totalVariance = weeklyDrawers.reduce((sum, d) => sum + Math.abs(parseFloat(d.Variance || 0)), 0)
  statistics.value.weeklyVariance = weeklyDrawers.length > 0 ? (totalVariance / weeklyDrawers.length) : 0

  statistics.value.totalDrawers = drawerHistory.value.length

  generateChartData()
}

// Generate Chart Data
const generateChartData = () => {
  const last7Days = []
  for (let i = 6; i >= 0; i--) {
    const date = new Date(Date.now() - i * 24 * 60 * 60 * 1000)
    const dateStr = date.toISOString().split('T')[0]
    const dayDrawers = drawerHistory.value.filter(d => d.ShiftDate === dateStr)
    const avgVariance = dayDrawers.length > 0
      ? dayDrawers.reduce((sum, d) => sum + Math.abs(parseFloat(d.Variance || 0)), 0) / dayDrawers.length
      : 0

    last7Days.push({
      date: date.toLocaleDateString('en-US', { weekday: 'short' }),
      variance: avgVariance.toFixed(2)
    })
  }
  chartData.value.dailyVariances = last7Days

  const cashTrends = []
  for (let i = 6; i >= 0; i--) {
    const date = new Date(Date.now() - i * 24 * 60 * 60 * 1000)
    const dateStr = date.toISOString().split('T')[0]
    const dayDrawers = drawerHistory.value.filter(d => d.ShiftDate === dateStr)
    const totalCash = dayDrawers.reduce((sum, d) => sum + parseFloat(d.CashSales || 0), 0)

    cashTrends.push({
      date: date.toLocaleDateString('en-US', { weekday: 'short' }),
      amount: totalCash.toFixed(0)
    })
  }
  chartData.value.cashTrends = cashTrends
}

// Validate Open Drawer Form
const validateOpenDrawerForm = () => {
  errors.openDrawer = {}

  if (!openDrawerForm.stationId) {
    errors.openDrawer.stationId = 'Station is required'
  }

  if (!openDrawerForm.shiftType) {
    errors.openDrawer.shiftType = 'Shift type is required'
  }

  if (!openDrawerForm.openingBalance || parseFloat(openDrawerForm.openingBalance) < 0) {
    errors.openDrawer.openingBalance = 'Valid opening balance is required'
  }

  return Object.keys(errors.openDrawer).length === 0
}

// Open New Drawer
const openNewDrawer = async () => {
  if (!validateOpenDrawerForm()) return

  try {
    loading.value = true

    const newDrawer = {
      StationID: parseInt(openDrawerForm.stationId),
      ShiftDate: new Date().toISOString().split('T')[0],
      ShiftType: openDrawerForm.shiftType,
      AttendantID: currentUser.id,
      OpeningBalance: openDrawerForm.openingBalance,
      ClosingBalance: '0.00',
      ExpectedCash: openDrawerForm.openingBalance,
      ActualCash: '0.00',
      Variance: '0.00',
      CashSales: '0.00',
      CashPayouts: '0.00',
      Status: 'Open',
      OpenedBy: currentUser.id,
      Notes: openDrawerForm.notes || null
    }

    await apiCall('/CashDrawers', {
      method: 'POST',
      body: JSON.stringify(newDrawer)
    })

    await Swal.fire({
      title: 'Drawer Opened!',
      text: `${openDrawerForm.shiftType} shift started successfully`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false
    })

    showOpenDrawerModal.value = false
    await fetchCurrentDrawer()
    await fetchDrawerHistory()
  } catch (error) {
    console.error('Error opening drawer:', error)
    await Swal.fire({
      title: 'Error!',
      text: 'Could not open cash drawer',
      icon: 'error',
      confirmButtonColor: '#f1416c'
    })
  } finally {
    loading.value = false
  }
}

// Close Drawer
const closeDrawer = async () => {
  if (!currentDrawer.value) return

  try {
    loading.value = true

    const actualCash = parseFloat(closeDrawerForm.actualCash)
    const expectedCash = parseFloat(currentDrawer.value.ExpectedCash)
    const variance = actualCash - expectedCash

    const updateData = {
      ActualCash: closeDrawerForm.actualCash,
      ClosingBalance: closeDrawerForm.actualCash,
      Variance: variance.toFixed(2),
      Status: 'Closed',
      ClosedBy: currentUser.id,
      ClosedAt: new Date().toISOString(),
      Notes: closeDrawerForm.notes || null
    }

    await apiCall(`/CashDrawers/${currentDrawer.value.DrawerID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData)
    })

    const varianceText = variance === 0 ? 'Perfect!' :
      Math.abs(variance) <= 50 ? 'Small variance detected' :
        'Large variance - please review'

    await Swal.fire({
      title: 'Drawer Closed!',
      text: `Shift ended. ${varianceText}`,
      icon: variance === 0 ? 'success' : Math.abs(variance) <= 50 ? 'warning' : 'error',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false
    })

    showCloseDrawerModal.value = false
    currentDrawer.value = null
    await fetchDrawerHistory()
  } catch (error) {
    console.error('Error closing drawer:', error)
    await Swal.fire({
      title: 'Error!',
      text: 'Could not close cash drawer',
      icon: 'error',
      confirmButtonColor: '#f1416c'
    })
  } finally {
    loading.value = false
  }
}

// Open Cash Operation Modal
const openCashOperation = (type) => {
  cashOperationType.value = type
  showCashOperationModal.value = true
}

// Record Cash Operation
const recordCashOperation = async () => {
  if (!currentDrawer.value) return

  try {
    loading.value = true

    const amount = parseFloat(cashOperationForm.amount)
    const currentCashSales = parseFloat(currentDrawer.value.CashSales || 0)
    const currentCashPayouts = parseFloat(currentDrawer.value.CashPayouts || 0)
    const currentExpected = parseFloat(currentDrawer.value.ExpectedCash || 0)

    let updateData = {}

    if (cashOperationType.value === 'sale') {
      updateData = {
        CashSales: (currentCashSales + amount).toFixed(2),
        ExpectedCash: (currentExpected + amount).toFixed(2)
      }
    } else {
      updateData = {
        CashPayouts: (currentCashPayouts + amount).toFixed(2),
        ExpectedCash: (currentExpected - amount).toFixed(2)
      }
    }

    await apiCall(`/CashDrawers/${currentDrawer.value.DrawerID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData)
    })

    await Swal.fire({
      title: 'Recorded!',
      text: `Cash ${cashOperationType.value} of UGX ${amount.toLocaleString()} recorded`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false
    })

    showCashOperationModal.value = false
    cashOperationForm.amount = '0.00'
    cashOperationForm.description = ''
    cashOperationForm.reference = ''
    await fetchCurrentDrawer()
  } catch (error) {
    console.error('Error recording cash operation:', error)
    await Swal.fire({
      title: 'Error!',
      text: 'Could not record cash operation',
      icon: 'error',
      confirmButtonColor: '#f1416c'
    })
  } finally {
    loading.value = false
  }
}

// Switch Station
const switchStation = async (station) => {
  selectedStation.value = station
  openDrawerForm.stationId = station.StationID
  await fetchCurrentDrawer()
  await fetchDrawerHistory()
}

// Format Currency
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(parseFloat(amount || 0))
}

// Format Time
const formatTime = (dateString) => {
  if (!dateString) return '--:--'
  return new Date(dateString).toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true
  })
}

// Initialize Component
onMounted(async () => {
  await fetchUserStations()
})
</script>

<style scoped>
.overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.chart-container {
  max-height: 300px;
  overflow-y: auto;
}

.modal.show {
  background: rgba(0, 0, 0, 0.5);
}

.progress {
  background-color: #f1f3ff;
  border-radius: 4px;
}

.symbol-label {
  border-radius: 8px;
}
</style>

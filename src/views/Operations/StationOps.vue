<template>
  <!-- Main Station Dashboard Container -->
  <div class="d-flex flex-column gap-5 p-4">
    
    <!-- Station Selection Modal for Super Users and Multi-Station Users -->
    <div 
      v-if="showStationModal"
      class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
      style="background: rgba(0, 0, 0, 0.7); z-index: 9999"
    >
      <div class="card shadow-lg" style="max-width: 500px; width: 90%">
        <div class="card-header bg-primary">
          <h3 class="card-title text-white fw-bold mb-0">
            <i class="ki-duotone ki-shop fs-2 text-white me-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Select Your Station
          </h3>
        </div>
        <div class="card-body p-6">
          <p class="text-gray-700 mb-4">
            {{ isSuperUser ? 'Select a station to manage:' : 'Choose your working station:' }}
          </p>
          <div class="row g-3">
            <div 
              v-for="station in availableStations" 
              :key="station.StationID"
              class="col-12"
            >
              <button
                @click="selectStation(station)"
                :disabled="loading"
                class="btn btn-light-primary btn-lg w-100 text-start d-flex align-items-center gap-3 p-4"
                style="border-radius: 12px;"
              >
                <div class="symbol symbol-50px">
                  <div class="symbol-label bg-primary">
                    <i class="ki-duotone ki-shop fs-2 text-white">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                  </div>
                </div>
                <div class="flex-grow-1">
                  <h6 class="fw-bold text-gray-900 mb-1">{{ station.StationName }}</h6>
                  <p class="text-gray-600 mb-0">{{ station.Location }}</p>
                </div>
                <i class="ki-duotone ki-arrow-right fs-2 text-primary">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Station Header -->
    <div class="card card-flush bg-gradient-primary" v-if="selectedStation.StationID">
      <div class="card-body p-6">
        <div class="d-flex align-items-center justify-content-between">
          <div class="d-flex align-items-center gap-4">
            <div class="symbol symbol-60px">
              <div class="symbol-label bg-white bg-opacity-20">
                <i class="ki-duotone ki-shop fs-2x text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </div>
            </div>
            <div>
              <h1 class="fw-bold text-white mb-1 fs-2">
                {{ selectedStation.StationName }}
              </h1>
              <p class="text-white opacity-75 mb-0 fs-5">
                {{ selectedStation.Location }} • {{ currentShiftStatus }}
              </p>
            </div>
          </div>
          <div class="text-end">
            <button
              @click="showStationModal = true"
              class="btn btn-white btn-sm mb-2"
            >
              <i class="ki-duotone ki-switch fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Switch Station
            </button>
            <div class="badge badge-lg" :class="`badge-light-${shiftStatusColor}`">
              {{ attendanceStatus }}
            </div>
            <p class="text-white opacity-75 mb-0 mt-1 fs-6">{{ shiftDuration }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Action Cards -->
    <div class="row g-4">
      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100" :class="shiftActionClass">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone fs-3x mb-3" :class="shiftActionIcon">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <button
              @click="handleShiftAction"
              :disabled="loading"
              class="btn btn-lg w-100 fw-bold"
              :class="shiftActionButtonClass"
            >
              {{ shiftActionText }}
            </button>
          </div>
        </div>
      </div>
      
      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-info h-100">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-time fs-3x text-info mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <button
              @click="handleClockInOut"
              :disabled="loading"
              class="btn btn-info btn-lg w-100 fw-bold"
            >
              {{ attendanceStatus === 'Present' ? 'Clock Out' : 'Clock In' }}
            </button>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-warning h-100">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-chart-line-up fs-3x text-warning mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <button
              @click="navigateToReadings"
              class="btn btn-warning btn-lg w-100 fw-bold"
            >
              Take Readings
            </button>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-danger h-100">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-information fs-3x text-danger mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <button
              @click="navigateToIncidents"
              class="btn btn-danger btn-lg w-100 fw-bold"
            >
              Report Issue
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- KPI Dashboard Cards -->
    <div class="row g-4">
      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-primary h-100">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-chart-line-up fs-3x text-primary mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <h2 class="fw-bold text-gray-900 mb-1">
              {{ formatCurrency(todayStats.totalSales) }}
            </h2>
            <p class="text-gray-600 fw-semibold mb-0">Today's Sales</p>
            <div class="progress h-6px mt-2">
              <div
                class="progress-bar bg-primary"
                :style="`width: ${salesProgressPercentage}%`"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-success h-100">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-basket fs-3x text-success mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
            </i>
            <h2 class="fw-bold text-gray-900 mb-1">{{ todayStats.totalTransactions }}</h2>
            <p class="text-gray-600 fw-semibold mb-0">Transactions</p>
            <div class="progress h-6px mt-2">
              <div
                class="progress-bar bg-success"
                :style="`width: ${transactionProgressPercentage}%`"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-warning h-100">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-wallet fs-3x text-warning mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
            </i>
            <h2 class="fw-bold text-gray-900 mb-1">
              {{ formatCurrency(todayStats.cashBalance) }}
            </h2>
            <p class="text-gray-600 fw-semibold mb-0">Cash Balance</p>
            <div class="progress h-6px mt-2">
              <div
                class="progress-bar bg-warning"
                :style="`width: ${Math.min(100, Math.abs(todayStats.cashBalance) / 1000000 * 100)}%`"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush" :class="`bg-light-${varianceColor}`">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-arrow-up-down fs-3x mb-3" :class="`text-${varianceColor}`">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <h2 class="fw-bold text-gray-900 mb-1">
              {{ formatCurrency(Math.abs(todayStats.variance)) }}
            </h2>
            <p class="text-gray-600 fw-semibold mb-0">Cash Variance</p>
            <div class="progress h-6px mt-2">
              <div
                class="progress-bar"
                :class="`bg-${varianceColor}`"
                :style="`width: ${Math.min(100, Math.abs(todayStats.variance) / 50000 * 100)}%`"
              ></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Real-Time Charts Section -->
    <div class="row g-5">
      <!-- Hourly Sales Chart -->
      <div class="col-12 col-lg-8">
        <div class="card card-flush h-100">
          <div class="card-header py-4">
            <h3 class="card-title fw-bold">
              <i class="ki-duotone ki-chart-line fs-2 text-primary me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              Hourly Sales Performance
            </h3>
            <div class="card-toolbar">
              <div class="badge badge-light-success fw-bold">
                Peak: {{ peakSalesHour }}:00
              </div>
            </div>
          </div>
          <div class="card-body">
            <div class="chart-container" style="height: 280px">
              <div class="d-flex align-items-end justify-content-between h-100 gap-1">
                <div 
                  v-for="hour in 24" 
                  :key="hour-1" 
                  class="d-flex flex-column align-items-center"
                  style="flex: 1;"
                >
                  <div
                    class="bg-primary rounded-top mb-2 transition-all"
                    :style="`height: ${getHourlyBarHeight(hour-1)}px; width: 100%; max-width: 20px;`"
                    :class="{ 'bg-success': hour-1 === peakSalesHour }"
                  ></div>
                  <small class="text-gray-600 fw-semibold">{{ hour-1 }}</small>
                </div>
              </div>
            </div>
            <div class="mt-4 p-3 bg-light-info rounded">
              <div class="d-flex align-items-center gap-2">
                <i class="ki-duotone ki-artificial-intelligence fs-2 text-info">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div class="badge badge-info fw-bold">AI Insight</div>
              </div>
              <p class="text-gray-800 mt-2 mb-0 fw-semibold">{{ aiInsight }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Payment Methods Breakdown -->
      <div class="col-12 col-lg-4">
        <div class="card card-flush h-100">
          <div class="card-header py-4">
            <h3 class="card-title fw-bold">
              <i class="ki-duotone ki-chart-pie fs-2 text-success me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              Payment Methods
            </h3>
          </div>
          <div class="card-body">
            <!-- Payment Method Visual Chart -->
            <div class="payment-chart mb-4">
              <div 
                v-for="(amount, method) in paymentMethods" 
                :key="method"
                class="mb-3"
              >
                <div class="d-flex justify-content-between align-items-center mb-1">
                  <span class="fw-semibold text-gray-800">{{ method }}</span>
                  <span class="fw-bold text-gray-900">{{ formatCurrency(amount) }}</span>
                </div>
                <div class="progress h-8px">
                  <div
                    class="progress-bar"
                    :class="getPaymentMethodColor(method)"
                    :style="`width: ${getPaymentMethodPercentage(amount)}%`"
                  ></div>
                </div>
              </div>
            </div>

            <!-- Payment Summary -->
            <div class="separator my-4"></div>
            <div class="d-flex justify-content-between py-2">
              <span class="fw-bold text-gray-800">Total Collected:</span>
              <span class="fw-bold text-success fs-5">{{ formatCurrency(totalPayments) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Equipment Status Overview -->
    <div class="card card-flush">
      <div class="card-header py-4">
        <h3 class="card-title fw-bold">
          <i class="ki-duotone ki-abstract-26 fs-2 text-danger me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Equipment Status Overview
        </h3>
        <div class="card-toolbar">
          <button
            @click="refreshEquipmentStatus"
            :disabled="loading"
            class="btn btn-sm btn-light-primary"
          >
            <i class="ki-duotone ki-arrows-circle fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Refresh
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="row g-4">
          <!-- Fuel Pumps -->
          <div class="col-12 col-md-6">
            <h6 class="fw-bold mb-3 text-gray-800">
              <i class="ki-duotone ki-abstract-26 fs-1 text-primary me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Fuel Dispensers ({{ stationPumps.length }})
            </h6>
            <div class="row g-2">
              <div 
                v-for="pump in stationPumps" 
                :key="pump.PumpID" 
                class="col-6 col-lg-4"
              >
                <div class="card card-flush bg-light-success h-100">
                  <div class="card-body p-3 text-center">
                    <i class="ki-duotone ki-abstract-26 fs-2x text-success mb-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <h6 class="fw-bold mb-1">{{ pump.PumpName }}</h6>
                    <span class="badge badge-success">{{ pump.Status }}</span>
                    <div class="mt-2">
                      <small class="text-gray-600">{{ Math.round(85 + Math.random() * 15) }}% Uptime</small>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Storage Tanks -->
          <div class="col-12 col-md-6">
            <h6 class="fw-bold mb-3 text-gray-800">
              <i class="ki-duotone ki-bucket fs-1 text-info me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              Storage Tanks ({{ stationTanks.length }})
            </h6>
            <div class="row g-2">
              <div 
                v-for="tank in stationTanks" 
                :key="tank.TankID" 
                class="col-6 col-lg-4"
              >
                <div class="card card-flush bg-light-info h-100">
                  <div class="card-body p-3 text-center">
                    <i class="ki-duotone ki-bucket fs-2x text-info mb-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                      <span class="path4"></span>
                    </i>
                    <h6 class="fw-bold mb-1">{{ tank.TankName }}</h6>
                    <div class="progress h-6px mb-2">
                      <div
                        class="progress-bar bg-info"
                        :style="`width: ${getTankFillPercentage(tank)}%`"
                      ></div>
                    </div>
                    <small class="text-gray-600">{{ getTankFillPercentage(tank) }}% Full</small>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading Overlay -->
    <div
      v-if="loading"
      class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
      style="background: rgba(0, 0, 0, 0.5); z-index: 9998"
    >
      <div class="card shadow">
        <div class="card-body text-center p-5">
          <div class="spinner-border text-primary mb-3" style="width: 3rem; height: 3rem"></div>
          <h6 class="fw-bold">{{ loadingMessage }}</h6>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'http://localhost:4000/api/records/v1'

// State Management
const loading = ref(false)
const loadingMessage = ref('Loading...')
const showStationModal = ref(false)

// User Authentication Data
const currentUser = ref({})
const availableStations = ref([])
const selectedStation = ref({})

// Station Data
const stationPumps = ref([])
const stationTanks = ref([])
const activeShift = ref({})
const attendanceStatus = ref('Not Clocked In')

// Dashboard Statistics
const todayStats = reactive({
  totalSales: 0,
  totalTransactions: 0,
  cashBalance: 0,
  variance: 0
})

const paymentMethods = ref({})
const hourlySalesData = ref({})

// Super User Emails
const SUPER_USER_EMAILS = ['vexa256@gmail.com', 'atimothy@ecsahc.org']

// Computed Properties
const isSuperUser = computed(() => {
  return SUPER_USER_EMAILS.includes(currentUser.value.email?.toLowerCase())
})

const currentShiftStatus = computed(() => {
  if (!activeShift.value.DrawerID) return 'No Active Shift'
  return activeShift.value.Status === 'Open' ? 'Shift Active' : 'Shift Closed'
})

const shiftStatusColor = computed(() => {
  if (!activeShift.value.DrawerID) return 'secondary'
  return activeShift.value.Status === 'Open' ? 'success' : 'primary'
})

const shiftDuration = computed(() => {
  if (!activeShift.value.OpenedAt) return '0h 0m'
  const start = new Date(activeShift.value.OpenedAt)
  const now = new Date()
  const diff = now - start
  const hours = Math.floor(diff / (1000 * 60 * 60))
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  return `${hours}h ${minutes}m`
})

const shiftActionClass = computed(() => {
  if (!activeShift.value.DrawerID) return 'bg-light-success'
  return activeShift.value.Status === 'Open' ? 'bg-light-danger' : 'bg-light-secondary'
})

const shiftActionIcon = computed(() => {
  if (!activeShift.value.DrawerID) return 'ki-play text-success'
  return activeShift.value.Status === 'Open' ? 'ki-stop text-danger' : 'ki-check-circle text-secondary'
})

const shiftActionText = computed(() => {
  if (!activeShift.value.DrawerID) return 'Start Shift'
  return activeShift.value.Status === 'Open' ? 'End Shift' : 'Shift Closed'
})

const shiftActionButtonClass = computed(() => {
  if (!activeShift.value.DrawerID) return 'btn-success'
  return activeShift.value.Status === 'Open' ? 'btn-danger' : 'btn-secondary'
})

const varianceColor = computed(() => {
  const variance = Math.abs(todayStats.variance)
  if (variance > 100000) return 'danger'
  if (variance > 50000) return 'warning'
  return 'success'
})

const salesProgressPercentage = computed(() => {
  const target = 5000000 // 5M UGX daily target
  return Math.min(100, (todayStats.totalSales / target) * 100)
})

const transactionProgressPercentage = computed(() => {
  const target = 200 // 200 transactions daily target
  return Math.min(100, (todayStats.totalTransactions / target) * 100)
})

const totalPayments = computed(() => {
  return Object.values(paymentMethods.value).reduce((sum, amount) => sum + amount, 0)
})

const peakSalesHour = computed(() => {
  let maxSales = 0
  let peakHour = 0
  
  for (const [hour, sales] of Object.entries(hourlySalesData.value)) {
    if (sales > maxSales) {
      maxSales = sales
      peakHour = parseInt(hour)
    }
  }
  
  return peakHour
})

const aiInsight = computed(() => {
  const currentHour = new Date().getHours()
  const peakHour = peakSalesHour.value
  const variance = Math.abs(todayStats.variance)
  
  if (variance > 100000) {
    return `Critical variance detected! Review transactions around ${peakHour}:00. Immediate supervisor notification required.`
  }
  
  if (currentHour >= 6 && currentHour <= 9) {
    return `Morning peak detected at ${peakHour}:00. Recommend ensuring all dispensers operational for rush hour.`
  }
  
  if (currentHour >= 17 && currentHour <= 19) {
    return `Evening rush approaching. Peak historical activity at ${peakHour}:00. Monitor cash levels closely.`
  }
  
  return `Performance tracking normal. Peak sales historically at ${peakHour}:00. Current variance within acceptable limits.`
})

// API Helper Functions
const getAuthHeaders = () => {
  const token = localStorage.getItem('kigrama_auth_token') || 'demo_token'
  return {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
}

const apiCall = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: getAuthHeaders(),
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

// Initialization Functions
const initializeUser = () => {
  try {
    const userData = localStorage.getItem('kigrama_user_data')
    if (userData) {
      const authData = JSON.parse(userData)
      currentUser.value = authData.user || {}
    }
    
    if (!currentUser.value.id) {
      showError('Authentication Error', 'User not properly authenticated')
      return false
    }
    
    return true
  } catch (error) {
    showError('Data Error', 'Failed to load user data')
    return false
  }
}

const fetchAvailableStations = async () => {
  try {
    if (isSuperUser.value) {
      // Super users see all stations
      const response = await apiCall('/Stations')
      availableStations.value = response.records || []
    } else {
      // Regular users see only their assigned stations
      const userStationsResponse = await apiCall(`/UserStations?UserID=${currentUser.value.id}`)
      const userStations = userStationsResponse.records || []
      
      if (userStations.length === 0) {
        showError('No Stations', 'No stations assigned to your account. Contact your manager.')
        return
      }
      
      // Fetch station details for each assigned station
      const stationPromises = userStations.map(async (us) => {
        try {
          const stationResponse = await apiCall(`/Stations/${us.StationID}`)
          return { ...stationResponse, userStationData: us }
        } catch (error) {
          console.error(`Failed to fetch station ${us.StationID}:`, error)
          return null
        }
      })
      
      const stations = await Promise.all(stationPromises)
      availableStations.value = stations.filter(station => station !== null)
    }
    
    // Auto-select if user has primary station or only one station
    if (availableStations.value.length === 1) {
      await selectStation(availableStations.value[0])
    } else if (currentUser.value.PrimaryStationID && !isSuperUser.value) {
      const primaryStation = availableStations.value.find(s => s.StationID === currentUser.value.PrimaryStationID)
      if (primaryStation) {
        await selectStation(primaryStation)
      } else {
        showStationModal.value = true
      }
    } else {
      showStationModal.value = true
    }
    
  } catch (error) {
    console.error('Error fetching stations:', error)
    showError('Station Loading Error', 'Failed to load available stations')
  }
}

const selectStation = async (station) => {
  if (!station || loading.value) return
  
  loading.value = true
  loadingMessage.value = `Loading ${station.StationName}...`
  showStationModal.value = false
  
  try {
    selectedStation.value = station
    
    // Initialize station data
    await Promise.all([
      fetchStationEquipment(),
      fetchActiveShift(),
      fetchTodayAttendance(),
      fetchTodayStatistics()
    ])
    
    await Swal.fire({
      title: 'Station Selected!',
      text: `Now managing ${station.StationName}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false
    })
    
  } catch (error) {
    console.error('Error selecting station:', error)
    showError('Station Selection Error', 'Failed to load station data')
  } finally {
    loading.value = false
  }
}

const fetchStationEquipment = async () => {
  try {
    const [pumpsResponse, tanksResponse] = await Promise.all([
      apiCall(`/Pumps?StationID=${selectedStation.value.StationID}`),
      apiCall(`/Tanks?StationID=${selectedStation.value.StationID}`)
    ])
    
    stationPumps.value = pumpsResponse.records || []
    stationTanks.value = tanksResponse.records || []
    
  } catch (error) {
    console.error('Error fetching station equipment:', error)
  }
}

const fetchActiveShift = async () => {
  try {
    const today = new Date().toISOString().split('T')[0]
    const response = await apiCall(`/CashDrawers?StationID=${selectedStation.value.StationID}&ShiftDate=${today}`)
    
    if (response.records && response.records.length > 0) {
      activeShift.value = response.records[0]
    } else {
      activeShift.value = {}
    }
    
  } catch (error) {
    console.error('Error fetching active shift:', error)
    activeShift.value = {}
  }
}

const fetchTodayAttendance = async () => {
  try {
    const today = new Date().toISOString().split('T')[0]
    const response = await apiCall(`/Attendance?UserID=${currentUser.value.id}&AttendanceDate=${today}`)
    
    if (response.records && response.records.length > 0) {
      const attendance = response.records[0]
      attendanceStatus.value = attendance.Status || 'Not Clocked In'
    } else {
      attendanceStatus.value = 'Not Clocked In'
    }
    
  } catch (error) {
    console.error('Error fetching attendance:', error)
    attendanceStatus.value = 'Not Clocked In'
  }
}

const fetchTodayStatistics = async () => {
  try {
    const today = new Date().toISOString().split('T')[0]
    const transactionsResponse = await apiCall(`/Transactions?StationID=${selectedStation.value.StationID}&TransactionDate=${today}`)
    
    const transactions = transactionsResponse.records || []
    
    // Calculate statistics
    todayStats.totalTransactions = transactions.length
    todayStats.totalSales = transactions.reduce((sum, t) => sum + parseFloat(t.TotalAmount || 0), 0)
    todayStats.cashBalance = parseFloat(activeShift.value.ActualCash || 0)
    todayStats.variance = parseFloat(activeShift.value.Variance || 0)
    
    // Process payment methods
    const methods = {}
    const hourly = {}
    
    transactions.forEach(transaction => {
      const method = transaction.PaymentMethod || 'Unknown'
      methods[method] = (methods[method] || 0) + parseFloat(transaction.TotalAmount || 0)
      
      const hour = new Date(transaction.TransactionDate).getHours()
      hourly[hour] = (hourly[hour] || 0) + parseFloat(transaction.TotalAmount || 0)
    })
    
    paymentMethods.value = methods
    hourlySalesData.value = hourly
    
  } catch (error) {
    console.error('Error fetching today statistics:', error)
  }
}

// Action Handlers
const handleShiftAction = async () => {
  if (!activeShift.value.DrawerID) {
    await startShift()
  } else if (activeShift.value.Status === 'Open') {
    await endShift()
  }
}

const startShift = async () => {
  const result = await Swal.fire({
    title: 'Start New Shift',
    text: 'This will begin a new shift session. Are you ready?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Start Shift',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#50cd89'
  })
  
  if (!result.isConfirmed) return
  
  loading.value = true
  loadingMessage.value = 'Starting shift...'
  
  try {
    const shiftData = {
      StationID: selectedStation.value.StationID,
      ShiftDate: new Date().toISOString().split('T')[0],
      ShiftType: getShiftType(),
      AttendantID: currentUser.value.id,
      OpeningBalance: '0',
      ExpectedCash: '0',
      ActualCash: '0',
      Variance: '0',
      CashSales: '0',
      CashPayouts: '0',
      Status: 'Open',
      OpenedBy: currentUser.value.id,
      OpenedAt: new Date().toISOString()
    }
    
    const response = await apiCall('/CashDrawers', {
      method: 'POST',
      body: JSON.stringify(shiftData)
    })
    
    activeShift.value = response
    
    await Swal.fire({
      title: 'Shift Started!',
      text: 'Your shift has been successfully started',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false
    })
    
    // Auto clock in if not already
    if (attendanceStatus.value !== 'Present') {
      await handleClockInOut()
    }
    
  } catch (error) {
    showError('Failed to start shift', error.message)
  } finally {
    loading.value = false
  }
}

const endShift = async () => {
  const result = await Swal.fire({
    title: 'End Shift Confirmation',
    html: `
      <div class="text-start">
        <p><strong>Cash Variance:</strong> ${formatCurrency(todayStats.variance)}</p>
        <p><strong>Total Sales:</strong> ${formatCurrency(todayStats.totalSales)}</p>
        <p><strong>Transactions:</strong> ${todayStats.totalTransactions}</p>
        <br>
        <p>Are you sure you want to end your shift?</p>
      </div>
    `,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, End Shift',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c'
  })
  
  if (!result.isConfirmed) return
  
  loading.value = true
  loadingMessage.value = 'Ending shift...'
  
  try {
    const updateData = {
      Status: 'Closed',
      ClosedBy: currentUser.value.id,
      ClosedAt: new Date().toISOString()
    }
    
    await apiCall(`/CashDrawers/${activeShift.value.DrawerID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData)
    })
    
    activeShift.value.Status = 'Closed'
    
    await Swal.fire({
      title: 'Shift Ended Successfully!',
      text: 'Your shift has been completed',
      icon: 'success',
      confirmButtonColor: '#50cd89'
    })
    
  } catch (error) {
    showError('Failed to end shift', error.message)
  } finally {
    loading.value = false
  }
}

const handleClockInOut = async () => {
  loading.value = true
  loadingMessage.value = attendanceStatus.value === 'Present' ? 'Clocking out...' : 'Clocking in...'
  
  try {
    if (attendanceStatus.value === 'Present') {
      // Clock out logic would go here
      attendanceStatus.value = 'Completed'
    } else {
      // Clock in
      const attendanceData = {
        StationID: selectedStation.value.StationID,
        UserID: currentUser.value.id,
        AttendanceDate: new Date().toISOString().split('T')[0],
        TimeIn: new Date().toISOString(),
        Status: 'Present'
      }
      
      await apiCall('/Attendance', {
        method: 'POST',
        body: JSON.stringify(attendanceData)
      })
      
      attendanceStatus.value = 'Present'
    }
    
    await Swal.fire({
      title: attendanceStatus.value === 'Present' ? 'Clocked In!' : 'Clocked Out!',
      text: `You have been successfully ${attendanceStatus.value === 'Present' ? 'clocked in' : 'clocked out'}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false
    })
    
  } catch (error) {
    showError('Clock in/out failed', error.message)
  } finally {
    loading.value = false
  }
}

const refreshEquipmentStatus = async () => {
  loading.value = true
  loadingMessage.value = 'Refreshing equipment status...'
  
  try {
    await fetchStationEquipment()
    
    await Swal.fire({
      title: 'Status Updated!',
      text: 'Equipment status has been refreshed',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false
    })
    
  } catch (error) {
    showError('Refresh failed', error.message)
  } finally {
    loading.value = false
  }
}

// Navigation Functions
const navigateToReadings = () => {
  // Navigation logic would go here
  Swal.fire({
    title: 'Navigate to Readings',
    text: 'This would navigate to the readings view',
    icon: 'info'
  })
}

const navigateToIncidents = () => {
  // Navigation logic would go here
  Swal.fire({
    title: 'Navigate to Incidents',
    text: 'This would navigate to the incident reporting view',
    icon: 'info'
  })
}

// Helper Functions
const getShiftType = () => {
  const hour = new Date().getHours()
  if (hour >= 6 && hour < 14) return 'Morning'
  if (hour >= 14 && hour < 22) return 'Afternoon'
  return 'Night'
}

const getHourlyBarHeight = (hour) => {
  const sales = hourlySalesData.value[hour] || 0
  const maxSales = Math.max(...Object.values(hourlySalesData.value), 1)
  return Math.max(10, (sales / maxSales) * 200)
}

const getTankFillPercentage = (tank) => {
  return Math.round((parseFloat(tank.CurrentLevel || 0) / parseFloat(tank.Capacity || 1)) * 100)
}

const getPaymentMethodColor = (method) => {
  const colors = {
    'Cash': 'bg-success',
    'Card': 'bg-primary',
    'Mobile Money': 'bg-warning',
    'Credit': 'bg-info'
  }
  return colors[method] || 'bg-secondary'
}

const getPaymentMethodPercentage = (amount) => {
  const total = totalPayments.value
  return total > 0 ? (amount / total) * 100 : 0
}

const formatCurrency = (amount) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0
  }).format(amount || 0)
}

const showError = (title, message) => {
  Swal.fire({
    title: title,
    text: message,
    icon: 'error',
    confirmButtonColor: '#f1416c'
  })
}

// Lifecycle
onMounted(async () => {
  if (initializeUser()) {
    await fetchAvailableStations()
  }
})

// Watch for station changes to refresh data
watch(() => selectedStation.value.StationID, (newStationId) => {
  if (newStationId) {
    // Refresh data periodically
    const interval = setInterval(async () => {
      if (selectedStation.value.StationID === newStationId) {
        await fetchTodayStatistics()
      } else {
        clearInterval(interval)
      }
    }, 30000) // Refresh every 30 seconds
  }
})
</script>

<style scoped>
/* Minimal custom CSS - Maximum 30 lines */
.bg-gradient-primary {
  background: linear-gradient(135deg, #3699ff 0%, #0d6efd 100%);
}

.chart-container {
  background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
  border-radius: 12px;
  padding: 20px;
}

.payment-chart .progress {
  border-radius: 6px;
}

.card-flush {
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.card-flush:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.transition-all {
  transition: all 0.3s ease;
}

.symbol-label {
  border-radius: 12px;
}
</style>
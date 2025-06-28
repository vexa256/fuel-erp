<template>
  <div class="d-flex flex-column gap-5">
    <!-- Header Section -->
    <div class="card card-flush bg-light-primary">
      <div class="card-body">
        <div class="d-flex justify-content-between align-items-center">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px">
              <div class="symbol-label bg-primary">
                <i class="ki-duotone ki-calendar-8 fs-2 text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
              </div>
            </div>
            <div>
              <h2 class="text-primary fw-bold mb-1">Shift Management</h2>
              <p class="text-gray-600 mb-0">{{ currentStation?.StationName || 'Loading...' }}</p>
            </div>
          </div>
          <div class="text-end">
            <span class="badge badge-light-success fs-7">{{ currentShiftStatus }}</span>
            <p class="text-gray-500 fs-8 mb-0">{{ formatTime(new Date()) }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Current Shift Status Cards -->
    <div class="row g-3">
      <div class="col-6">
        <div class="card card-flush bg-light-success">
          <div class="card-body p-4">
            <div class="d-flex align-items-center gap-2">
              <i class="ki-duotone ki-timer fs-1 text-success">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div>
                <p class="text-success fs-6 fw-bold mb-0">{{ shiftDuration }}</p>
                <p class="text-gray-600 fs-8 mb-0">Shift Duration</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-6">
        <div class="card card-flush bg-light-warning">
          <div class="card-body p-4">
            <div class="d-flex align-items-center gap-2">
              <i class="ki-duotone ki-dollar fs-1 text-warning">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div>
                <p class="text-warning fs-6 fw-bold mb-0">
                  ${{ currentCashDrawer?.ActualCash || '0.00' }}
                </p>
                <p class="text-gray-600 fs-8 mb-0">Cash on Hand</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold">Quick Actions</h3>
      </div>
      <div class="card-body">
        <div class="row g-3">
          <div class="col-6" v-if="!isClockeedIn">
            <button
              @click="clockIn"
              :disabled="loading"
              class="btn btn-light-success w-100 h-60px d-flex flex-column justify-content-center"
            >
              <i class="ki-duotone ki-entrance-right fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <span class="fw-bold">Clock In</span>
            </button>
          </div>
          <div class="col-6" v-if="isClockeedIn">
            <button
              @click="clockOut"
              :disabled="loading"
              class="btn btn-light-danger w-100 h-60px d-flex flex-column justify-content-center"
            >
              <i class="ki-duotone ki-entrance-left fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <span class="fw-bold">Clock Out</span>
            </button>
          </div>
          <div class="col-6" v-if="!isShiftOpen">
            <button
              @click="openShift"
              :disabled="loading"
              class="btn btn-light-primary w-100 h-60px d-flex flex-column justify-content-center"
            >
              <i class="ki-duotone ki-bank fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <span class="fw-bold">Open Shift</span>
            </button>
          </div>
          <div class="col-6" v-if="isShiftOpen">
            <button
              @click="closeShift"
              :disabled="loading"
              class="btn btn-light-info w-100 h-60px d-flex flex-column justify-content-center"
            >
              <i class="ki-duotone ki-safe-home fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <span class="fw-bold">Close Shift</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Shift Performance Chart -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold">Today's Performance</h3>
        <div class="card-toolbar">
          <span class="badge badge-light-primary">{{ todaysSales.toFixed(2) }}% Target</span>
        </div>
      </div>
      <div class="card-body">
        <canvas ref="performanceChart" height="200"></canvas>
      </div>
    </div>

    <!-- Cash Drawer Summary -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold">Cash Drawer</h3>
        <div class="card-toolbar">
          <button @click="showCashDrawerModal" class="btn btn-sm btn-light-primary">
            <i class="ki-duotone ki-notepad-edit fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Update
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="row g-3">
          <div class="col-6">
            <div class="bg-light-success rounded p-3">
              <p class="text-success fs-7 fw-bold mb-1">Opening Balance</p>
              <p class="text-dark fs-5 fw-bold mb-0">
                ${{ currentCashDrawer?.OpeningBalance || '0.00' }}
              </p>
            </div>
          </div>
          <div class="col-6">
            <div class="bg-light-warning rounded p-3">
              <p class="text-warning fs-7 fw-bold mb-1">Expected Cash</p>
              <p class="text-dark fs-5 fw-bold mb-0">
                ${{ currentCashDrawer?.ExpectedCash || '0.00' }}
              </p>
            </div>
          </div>
          <div class="col-6">
            <div class="bg-light-info rounded p-3">
              <p class="text-info fs-7 fw-bold mb-1">Actual Cash</p>
              <p class="text-dark fs-5 fw-bold mb-0">
                ${{ currentCashDrawer?.ActualCash || '0.00' }}
              </p>
            </div>
          </div>
          <div class="col-6">
            <div :class="`bg-light-${varianceColor} rounded p-3`">
              <p :class="`text-${varianceColor} fs-7 fw-bold mb-1`">Variance</p>
              <p class="text-dark fs-5 fw-bold mb-0">${{ cashVariance }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold">Recent Activity</h3>
        <div class="card-toolbar">
          <button @click="refreshData" class="btn btn-sm btn-light-primary">
            <i class="ki-duotone ki-arrows-circle fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Refresh
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="timeline timeline-border-dashed">
          <div class="timeline-item" v-for="activity in recentActivity" :key="activity.id">
            <div class="timeline-line w-40px"></div>
            <div class="timeline-icon symbol symbol-circle symbol-40px">
              <div :class="`symbol-label bg-light-${activity.color}`">
                <i :class="`ki-duotone ${activity.icon} fs-4 text-${activity.color}`">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
            </div>
            <div class="timeline-content mb-5">
              <div class="pe-3 mb-2">
                <div class="fs-6 fw-bold mb-1">{{ activity.title }}</div>
                <div class="text-gray-600 fs-7">{{ activity.description }}</div>
              </div>
              <div class="overflow-auto">
                <span class="badge badge-light-primary">{{ formatTime(activity.timestamp) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading Overlay -->
    <div
      v-if="loading"
      class="position-fixed top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center bg-dark bg-opacity-50"
      style="z-index: 1050"
    >
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'
import Chart from 'chart.js/auto'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN = localStorage.getItem('kigrama_auth_token') || 'demo_token'

// Component State
const loading = ref(false)
const performanceChart = ref(null)
let chartInstance = null

// User & Station Data
const userData = ref(JSON.parse(localStorage.getItem('kigrama_user_data') || '{}'))
const currentStation = ref(null)
const userStations = ref([])

// Shift Data
const currentAttendance = ref(null)
const currentCashDrawer = ref(null)
const recentActivity = ref([])
const shiftStartTime = ref(null)

// API Helper Function
const apiCall = async (endpoint, options = {}) => {
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
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.message || `API Error: ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API call failed:', error)
    throw error
  }
}

// Computed Properties
const isClockeedIn = computed(() => {
  return (
    currentAttendance.value && currentAttendance.value.TimeIn && !currentAttendance.value.TimeOut
  )
})

const isShiftOpen = computed(() => {
  return currentCashDrawer.value && currentCashDrawer.value.Status === 'Open'
})

const currentShiftStatus = computed(() => {
  if (isClockeedIn.value && isShiftOpen.value) return 'Active Shift'
  if (isClockeedIn.value) return 'Clocked In'
  if (isShiftOpen.value) return 'Shift Open'
  return 'Off Duty'
})

const shiftDuration = computed(() => {
  if (!shiftStartTime.value) return '00:00:00'

  const start = new Date(shiftStartTime.value)
  const now = new Date()
  const diff = now - start

  const hours = Math.floor(diff / (1000 * 60 * 60))
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  const seconds = Math.floor((diff % (1000 * 60)) / 1000)

  return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
})

const cashVariance = computed(() => {
  if (!currentCashDrawer.value) return '0.00'
  const expected = parseFloat(currentCashDrawer.value.ExpectedCash || 0)
  const actual = parseFloat(currentCashDrawer.value.ActualCash || 0)
  return (actual - expected).toFixed(2)
})

const varianceColor = computed(() => {
  const variance = parseFloat(cashVariance.value)
  if (variance > 0) return 'success'
  if (variance < 0) return 'danger'
  return 'primary'
})

const todaysSales = ref(85.6) // Simulated sales percentage

// Data Fetching Functions
const fetchUserStations = async () => {
  try {
    const userId = userData.value.user?.id
    if (!userId) throw new Error('User ID not found')

    const response = await apiCall(`/UserStations?UserID=${userId}`)
    userStations.value = response.records || []

    // Get primary station details
    if (userStations.value.length > 0) {
      const primaryStation =
        userStations.value.find((us) => us.IsPrimary === '1') || userStations.value[0]
      const stationResponse = await apiCall(`/Stations/${primaryStation.StationID}`)
      currentStation.value = stationResponse
    }
  } catch (error) {
    console.error('Error fetching user stations:', error)
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load station data',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
}

const fetchCurrentAttendance = async () => {
  try {
    const userId = userData.value.user?.id
    const stationId = currentStation.value?.StationID
    if (!userId || !stationId) return

    const today = new Date().toISOString().split('T')[0]
    const response = await apiCall(
      `/Attendance?UserID=${userId}&StationID=${stationId}&AttendanceDate=${today}`,
    )

    if (response.records && response.records.length > 0) {
      currentAttendance.value = response.records[0]
      if (currentAttendance.value.TimeIn) {
        shiftStartTime.value = currentAttendance.value.TimeIn
      }
    }
  } catch (error) {
    console.error('Error fetching attendance:', error)
  }
}

const fetchCurrentCashDrawer = async () => {
  try {
    const userId = userData.value.user?.id
    const stationId = currentStation.value?.StationID
    if (!userId || !stationId) return

    const today = new Date().toISOString().split('T')[0]
    const response = await apiCall(
      `/CashDrawers?StationID=${stationId}&ShiftDate=${today}&AttendantID=${userId}`,
    )

    if (response.records && response.records.length > 0) {
      currentCashDrawer.value = response.records[0]
    }
  } catch (error) {
    console.error('Error fetching cash drawer:', error)
  }
}

const loadRecentActivity = () => {
  // Simulated activity data based on actual operations
  recentActivity.value = [
    {
      id: 1,
      title: 'Shift Started',
      description: 'Clock-in recorded successfully',
      timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000),
      icon: 'ki-entrance-right',
      color: 'success',
    },
    {
      id: 2,
      title: 'Cash Drawer Opened',
      description: 'Opening balance: $500.00',
      timestamp: new Date(Date.now() - 1.5 * 60 * 60 * 1000),
      icon: 'ki-bank',
      color: 'primary',
    },
    {
      id: 3,
      title: 'Transaction Processed',
      description: '45.5L Gasoline - $58.50',
      timestamp: new Date(Date.now() - 45 * 60 * 1000),
      icon: 'ki-arrow-up-right',
      color: 'info',
    },
    {
      id: 4,
      title: 'Cash Count',
      description: 'Interim count: $1,250.75',
      timestamp: new Date(Date.now() - 30 * 60 * 1000),
      icon: 'ki-dollar',
      color: 'warning',
    },
  ]
}

// Action Functions
const clockIn = async () => {
  loading.value = true
  try {
    const now = new Date().toISOString()
    const today = new Date().toISOString().split('T')[0]

    const attendanceData = {
      StationID: currentStation.value.StationID,
      UserID: userData.value.user.id,
      AttendanceDate: today,
      TimeIn: now,
      Status: 'Present',
      Notes: 'Clock-in via mobile app',
    }

    await apiCall('/Attendance', {
      method: 'POST',
      body: JSON.stringify(attendanceData),
    })

    await Swal.fire({
      title: 'Clocked In!',
      text: `Welcome back! Shift started at ${formatTime(new Date())}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    await fetchCurrentAttendance()
    addActivity('Clock In', 'Successfully clocked in for shift', 'success', 'ki-entrance-right')
  } catch (error) {
    Swal.fire({
      title: 'Clock In Failed!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const clockOut = async () => {
  const result = await Swal.fire({
    title: 'Clock Out Confirmation',
    text: 'Are you sure you want to clock out?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, Clock Out',
    confirmButtonColor: '#f1416c',
  })

  if (!result.isConfirmed) return

  loading.value = true
  try {
    const now = new Date().toISOString()

    await apiCall(`/Attendance/${currentAttendance.value.AttendanceID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        TimeOut: now,
        Status: 'Completed',
      }),
    })

    await Swal.fire({
      title: 'Clocked Out!',
      text: `Shift ended at ${formatTime(new Date())}. Have a great day!`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    currentAttendance.value = null
    shiftStartTime.value = null
    addActivity('Clock Out', 'Successfully clocked out from shift', 'danger', 'ki-entrance-left')
  } catch (error) {
    Swal.fire({
      title: 'Clock Out Failed!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const openShift = async () => {
  const { value: openingBalance } = await Swal.fire({
    title: 'Open Cash Drawer',
    text: 'Enter opening cash balance:',
    input: 'number',
    inputAttributes: {
      min: 0,
      step: 0.01,
      placeholder: '0.00',
    },
    showCancelButton: true,
    confirmButtonText: 'Open Shift',
    confirmButtonColor: '#3699ff',
  })

  if (!openingBalance && openingBalance !== 0) return

  loading.value = true
  try {
    const today = new Date().toISOString().split('T')[0]

    const drawerData = {
      StationID: currentStation.value.StationID,
      ShiftDate: today,
      ShiftType: 'Day', // Could be dynamic
      AttendantID: userData.value.user.id,
      OpeningBalance: parseFloat(openingBalance).toFixed(2),
      ExpectedCash: parseFloat(openingBalance).toFixed(2),
      ActualCash: parseFloat(openingBalance).toFixed(2),
      Status: 'Open',
      OpenedBy: userData.value.user.id,
      OpenedAt: new Date().toISOString(),
      Notes: 'Shift opened via mobile app',
    }

    await apiCall('/CashDrawers', {
      method: 'POST',
      body: JSON.stringify(drawerData),
    })

    await Swal.fire({
      title: 'Shift Opened!',
      text: `Cash drawer opened with $${openingBalance}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    await fetchCurrentCashDrawer()
    addActivity('Shift Opened', `Opening balance: $${openingBalance}`, 'primary', 'ki-bank')
  } catch (error) {
    Swal.fire({
      title: 'Open Shift Failed!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const closeShift = async () => {
  const { value: actualCash } = await Swal.fire({
    title: 'Close Cash Drawer',
    text: 'Enter actual cash count:',
    input: 'number',
    inputAttributes: {
      min: 0,
      step: 0.01,
      placeholder: currentCashDrawer.value?.ExpectedCash || '0.00',
    },
    showCancelButton: true,
    confirmButtonText: 'Close Shift',
    confirmButtonColor: '#f1416c',
  })

  if (!actualCash && actualCash !== 0) return

  loading.value = true
  try {
    await apiCall(`/CashDrawers/${currentCashDrawer.value.DrawerID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        ActualCash: parseFloat(actualCash).toFixed(2),
        ClosingBalance: parseFloat(actualCash).toFixed(2),
        Variance: (
          parseFloat(actualCash) - parseFloat(currentCashDrawer.value.ExpectedCash)
        ).toFixed(2),
        Status: 'Closed',
        ClosedBy: userData.value.user.id,
        ClosedAt: new Date().toISOString(),
      }),
    })

    const variance = parseFloat(actualCash) - parseFloat(currentCashDrawer.value.ExpectedCash)

    await Swal.fire({
      title: 'Shift Closed!',
      text: `Final count: $${actualCash} | Variance: $${variance.toFixed(2)}`,
      icon: variance === 0 ? 'success' : 'warning',
      toast: true,
      position: 'top-end',
      timer: 4000,
      showConfirmButton: false,
    })

    await fetchCurrentCashDrawer()
    addActivity('Shift Closed', `Final count: $${actualCash}`, 'info', 'ki-safe-home')
  } catch (error) {
    Swal.fire({
      title: 'Close Shift Failed!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const showCashDrawerModal = async () => {
  if (!currentCashDrawer.value) {
    Swal.fire({
      title: 'No Active Drawer',
      text: 'Please open a shift first',
      icon: 'info',
      confirmButtonColor: '#3699ff',
    })
    return
  }

  const { value: cashCount } = await Swal.fire({
    title: 'Update Cash Count',
    text: 'Enter current cash amount:',
    input: 'number',
    inputValue: currentCashDrawer.value.ActualCash,
    inputAttributes: {
      min: 0,
      step: 0.01,
    },
    showCancelButton: true,
    confirmButtonText: 'Update',
  })

  if (!cashCount && cashCount !== 0) return

  loading.value = true
  try {
    await apiCall(`/CashDrawers/${currentCashDrawer.value.DrawerID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        ActualCash: parseFloat(cashCount).toFixed(2),
        Variance: (
          parseFloat(cashCount) - parseFloat(currentCashDrawer.value.ExpectedCash)
        ).toFixed(2),
      }),
    })

    await Swal.fire({
      title: 'Updated!',
      text: 'Cash count updated successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })

    await fetchCurrentCashDrawer()
    addActivity('Cash Count', `Updated count: $${cashCount}`, 'warning', 'ki-dollar')
  } catch (error) {
    Swal.fire({
      title: 'Update Failed!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Utility Functions
const formatTime = (date) => {
  return new Date(date).toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  })
}

const addActivity = (title, description, color, icon) => {
  recentActivity.value.unshift({
    id: Date.now(),
    title,
    description,
    timestamp: new Date(),
    color,
    icon,
  })

  // Keep only last 10 activities
  if (recentActivity.value.length > 10) {
    recentActivity.value = recentActivity.value.slice(0, 10)
  }
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([fetchCurrentAttendance(), fetchCurrentCashDrawer()])

    await Swal.fire({
      title: 'Refreshed!',
      text: 'Data updated successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Refresh error:', error)
  } finally {
    loading.value = false
  }
}

// Chart Setup
const setupPerformanceChart = () => {
  nextTick(() => {
    if (!performanceChart.value) return

    const ctx = performanceChart.value.getContext('2d')

    if (chartInstance) {
      chartInstance.destroy()
    }

    chartInstance = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Completed', 'Remaining'],
        datasets: [
          {
            data: [todaysSales.value, 100 - todaysSales.value],
            backgroundColor: ['#50cd89', '#e4e6ef'],
            borderWidth: 0,
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
        cutout: '70%',
      },
    })
  })
}

// Update shift timer
setInterval(() => {
  if (shiftStartTime.value) {
    // Force reactivity update
    shiftStartTime.value = shiftStartTime.value
  }
}, 1000)

// Initialize Component
onMounted(async () => {
  loading.value = true
  try {
    await fetchUserStations()
    if (currentStation.value) {
      await Promise.all([fetchCurrentAttendance(), fetchCurrentCashDrawer()])
    }
    loadRecentActivity()
    setupPerformanceChart()
  } catch (error) {
    console.error('Initialization error:', error)
    Swal.fire({
      title: 'Initialization Error',
      text: 'Failed to load shift data',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.timeline-border-dashed .timeline-item .timeline-line {
  border-left: 2px dashed #e4e6ef;
}

.symbol-40px {
  width: 40px;
  height: 40px;
}

.h-60px {
  height: 60px;
}

/* iOS-style touch targets */
.btn {
  min-height: 44px;
}

/* Mobile-optimized spacing */
@media (max-width: 576px) {
  .card-body {
    padding: 1rem;
  }

  .gap-3 {
    gap: 0.75rem !important;
  }

  .gap-5 {
    gap: 1.5rem !important;
  }
}
</style>

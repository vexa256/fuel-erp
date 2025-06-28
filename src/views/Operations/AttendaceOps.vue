<template>
  <div class="d-flex flex-column gap-5 p-4 bg-light">
    <!-- Header Section -->
    <div class="card card-flush shadow-sm border-0">
      <div class="card-body p-6">
        <div class="d-flex align-items-center justify-content-between mb-4">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-45px bg-light-primary">
              <i class="ki-duotone ki-timer fs-2 text-primary">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
            </div>
            <div>
              <h2 class="fs-2 fw-bold text-gray-900 mb-0">Staff Attendance</h2>
              <p class="fs-6 text-gray-600 mb-0">
                {{ currentStation?.StationName || 'Loading...' }}
              </p>
            </div>
          </div>
          <div class="d-flex gap-2">
            <button class="btn btn-sm btn-light-info" @click="refreshData">
              <i class="ki-duotone ki-arrows-circle fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
            <button class="btn btn-sm btn-light-warning" @click="showHistoryModal = true">
              <i class="ki-duotone ki-calendar fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              History
            </button>
          </div>
        </div>

        <!-- Current Status Card -->
        <div class="card bg-gradient-primary border-0">
          <div class="card-body p-5 text-white">
            <div class="d-flex align-items-center justify-content-between">
              <div>
                <h3 class="fs-3 fw-bold text-white mb-2">{{ currentTime }}</h3>
                <p class="fs-6 opacity-75 mb-0">{{ currentDate }}</p>
              </div>
              <div class="text-end">
                <div class="badge" :class="attendanceStatusBadge">
                  {{ attendanceStatus }}
                </div>
                <p class="fs-7 opacity-75 mt-1 mb-0" v-if="todayAttendance">
                  {{ formatTimeIn(todayAttendance.TimeIn) }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Clock In/Out Section -->
    <div class="card card-flush shadow-sm border-0">
      <div class="card-body p-6">
        <h3 class="fs-4 fw-bold text-gray-900 mb-5">Clock Management</h3>

        <div class="row g-4 mb-6">
          <div class="col-6">
            <button
              class="btn btn-lg btn-light-success w-100 h-75px d-flex flex-column justify-content-center"
              @click="clockIn"
              :disabled="loading || (todayAttendance && todayAttendance.TimeIn)"
            >
              <i class="ki-duotone ki-entrance-right fs-2x text-success mb-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <span class="fw-bold">Clock In</span>
            </button>
          </div>
          <div class="col-6">
            <button
              class="btn btn-lg btn-light-danger w-100 h-75px d-flex flex-column justify-content-center"
              @click="clockOut"
              :disabled="loading || !todayAttendance || todayAttendance.TimeOut"
            >
              <i class="ki-duotone ki-entrance-left fs-2x text-danger mb-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <span class="fw-bold">Clock Out</span>
            </button>
          </div>
        </div>

        <!-- Add Notes Section -->
        <div
          class="mb-4"
          v-if="todayAttendance && todayAttendance.TimeIn && !todayAttendance.TimeOut"
        >
          <label class="form-label fs-6 fw-semibold">Add Notes (Optional)</label>
          <textarea
            v-model="attendanceNotes"
            class="form-control form-control-lg"
            rows="3"
            placeholder="Add any relevant notes about your shift..."
          ></textarea>
        </div>

        <!-- Today's Summary -->
        <div class="card bg-light-info border-0" v-if="todayAttendance">
          <div class="card-body p-4">
            <h5 class="fs-5 fw-bold text-info mb-3">Today's Summary</h5>
            <div class="row g-3">
              <div class="col-6">
                <div class="d-flex align-items-center gap-2">
                  <i class="ki-duotone ki-time fs-3 text-success">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div>
                    <p class="fs-7 text-gray-600 mb-0">Time In</p>
                    <p class="fs-6 fw-bold text-gray-900 mb-0">
                      {{ formatTimeIn(todayAttendance.TimeIn) || '--:--' }}
                    </p>
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="d-flex align-items-center gap-2">
                  <i class="ki-duotone ki-time fs-3 text-danger">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div>
                    <p class="fs-7 text-gray-600 mb-0">Time Out</p>
                    <p class="fs-6 fw-bold text-gray-900 mb-0">
                      {{ formatTimeIn(todayAttendance.TimeOut) || '--:--' }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <div class="separator my-3"></div>
            <div class="d-flex justify-content-between">
              <span class="fs-6 text-gray-600">Hours Worked:</span>
              <span class="fs-6 fw-bold text-primary">{{ calculateHoursWorked() }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Attendance Stats Chart -->
    <div class="card card-flush shadow-sm border-0">
      <div class="card-body p-6">
        <div class="d-flex align-items-center justify-content-between mb-5">
          <h3 class="fs-4 fw-bold text-gray-900 mb-0">Weekly Attendance</h3>
          <div class="badge badge-light-primary fs-7">Last 7 Days</div>
        </div>

        <!-- Chart Container -->
        <div class="position-relative">
          <canvas ref="attendanceChart" class="mh-300px"></canvas>
        </div>

        <!-- Quick Stats -->
        <div class="row g-3 mt-4">
          <div class="col-3">
            <div class="text-center p-3 bg-light-success rounded">
              <div class="fs-2 fw-bold text-success">{{ weeklyStats.present }}</div>
              <div class="fs-7 text-gray-600">Present</div>
            </div>
          </div>
          <div class="col-3">
            <div class="text-center p-3 bg-light-warning rounded">
              <div class="fs-2 fw-bold text-warning">{{ weeklyStats.late }}</div>
              <div class="fs-7 text-gray-600">Late</div>
            </div>
          </div>
          <div class="col-3">
            <div class="text-center p-3 bg-light-danger rounded">
              <div class="fs-2 fw-bold text-danger">{{ weeklyStats.absent }}</div>
              <div class="fs-7 text-gray-600">Absent</div>
            </div>
          </div>
          <div class="col-3">
            <div class="text-center p-3 bg-light-primary rounded">
              <div class="fs-2 fw-bold text-primary">{{ weeklyStats.avgHours }}</div>
              <div class="fs-7 text-gray-600">Avg Hours</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Attendance Records -->
    <div class="card card-flush shadow-sm border-0">
      <div class="card-body p-6">
        <h3 class="fs-4 fw-bold text-gray-900 mb-5">Recent Records</h3>

        <div class="timeline timeline-border-dashed" v-if="recentAttendance.length > 0">
          <div
            class="timeline-item"
            v-for="record in recentAttendance.slice(0, 5)"
            :key="record.AttendanceID"
          >
            <div class="timeline-line w-2px"></div>
            <div class="timeline-icon symbol symbol-30px">
              <div class="symbol-label" :class="getStatusColor(record.Status)">
                <i class="ki-duotone ki-check fs-5 text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
            </div>
            <div class="timeline-content ms-3">
              <div class="d-flex align-items-center justify-content-between mb-1">
                <span class="fs-6 fw-bold text-gray-900">{{
                  formatDate(record.AttendanceDate)
                }}</span>
                <div class="badge" :class="getStatusBadge(record.Status)">
                  {{ record.Status }}
                </div>
              </div>
              <div class="d-flex align-items-center gap-4 text-gray-600 fs-7">
                <span v-if="record.TimeIn">
                  <i class="ki-duotone ki-entrance-right fs-6 text-success me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  {{ formatTimeIn(record.TimeIn) }}
                </span>
                <span v-if="record.TimeOut">
                  <i class="ki-duotone ki-entrance-left fs-6 text-danger me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  {{ formatTimeIn(record.TimeOut) }}
                </span>
              </div>
              <p class="fs-7 text-gray-500 mt-1 mb-0" v-if="record.Notes">
                {{ record.Notes }}
              </p>
            </div>
          </div>
        </div>

        <div class="text-center py-5" v-else>
          <i class="ki-duotone ki-file-deleted fs-3x text-gray-400 mb-3">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <p class="fs-6 text-gray-600">No attendance records found</p>
        </div>
      </div>
    </div>

    <!-- Attendance History Modal -->
    <div class="modal fade" tabindex="-1" v-if="showHistoryModal">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header border-0 pb-0">
            <h3 class="modal-title fs-4 fw-bold">Attendance History</h3>
            <button type="button" class="btn-close" @click="showHistoryModal = false"></button>
          </div>

          <div class="modal-body">
            <!-- Date Filter -->
            <div class="row g-3 mb-5">
              <div class="col-6">
                <label class="form-label fs-6 fw-semibold">From Date</label>
                <input
                  type="date"
                  class="form-control form-control-lg"
                  v-model="historyFilter.startDate"
                  @change="loadAttendanceHistory"
                />
              </div>
              <div class="col-6">
                <label class="form-label fs-6 fw-semibold">To Date</label>
                <input
                  type="date"
                  class="form-control form-control-lg"
                  v-model="historyFilter.endDate"
                  @change="loadAttendanceHistory"
                />
              </div>
            </div>

            <!-- History Table -->
            <div class="table-responsive">
              <table class="table table-rounded table-striped border gy-7 gs-7">
                <thead>
                  <tr class="fw-semibold fs-6 text-gray-800 border-bottom-2 border-gray-200">
                    <th>Date</th>
                    <th>Time In</th>
                    <th>Time Out</th>
                    <th>Hours</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="record in attendanceHistory" :key="record.AttendanceID">
                    <td class="fw-bold">{{ formatDate(record.AttendanceDate) }}</td>
                    <td>{{ formatTimeIn(record.TimeIn) || '--:--' }}</td>
                    <td>{{ formatTimeIn(record.TimeOut) || '--:--' }}</td>
                    <td>{{ calculateRecordHours(record) }}</td>
                    <td>
                      <div class="badge" :class="getStatusBadge(record.Status)">
                        {{ record.Status }}
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="text-center py-5" v-if="attendanceHistory.length === 0">
              <i class="ki-duotone ki-file-deleted fs-3x text-gray-400 mb-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <p class="fs-6 text-gray-600">No records found for selected period</p>
            </div>
          </div>

          <div class="modal-footer border-0 pt-0">
            <button type="button" class="btn btn-light-primary" @click="showHistoryModal = false">
              Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading Overlay -->
    <div
      class="d-flex justify-content-center align-items-center position-fixed top-0 start-0 w-100 h-100 bg-black bg-opacity-25"
      style="z-index: 9999"
      v-if="loading"
    >
      <div class="card shadow-lg border-0">
        <div class="card-body p-5 text-center">
          <div class="spinner-border text-primary mb-3" role="status"></div>
          <p class="fs-6 fw-semibold text-gray-700 mb-0">{{ loadingMessage }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted, nextTick } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN =
  localStorage.getItem('kigrama_auth_token') || 'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.demo_token'

// Current User Context
const currentUser = ref(JSON.parse(localStorage.getItem('kigrama_user_data') || '{}'))?.user || null
const currentStation = ref(null)

// State Management
const loading = ref(false)
const loadingMessage = ref('Loading...')
const currentTime = ref('')
const currentDate = ref('')
const attendanceNotes = ref('')
const showHistoryModal = ref(false)

// Data Collections
const todayAttendance = ref(null)
const recentAttendance = ref([])
const attendanceHistory = ref([])
const weeklyStats = reactive({
  present: 0,
  late: 0,
  absent: 0,
  avgHours: '0.0',
})

// Chart Reference
const attendanceChart = ref(null)
let chartInstance = null

// History Filter
const historyFilter = reactive({
  startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
  endDate: new Date().toISOString().split('T')[0],
})

// Computed Properties
const attendanceStatus = computed(() => {
  if (!todayAttendance.value) return 'Not Clocked In'
  if (todayAttendance.value.TimeOut) return 'Clocked Out'
  return 'Clocked In'
})

const attendanceStatusBadge = computed(() => {
  if (!todayAttendance.value) return 'badge-light-warning'
  if (todayAttendance.value.TimeOut) return 'badge-light-danger'
  return 'badge-light-success'
})

// Time Management
const updateCurrentTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true,
  })
  currentDate.value = now.toLocaleDateString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

// API Helper Functions
const apiCall = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${JWT_TOKEN}`,
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
    console.error('API Call Error:', error)
    throw error
  }
}

// Load User's Primary Station
const loadUserStation = async () => {
  try {
    if (!currentUser.value?.id) return

    const response = await apiCall(`/UserStations?UserID=${currentUser.value.id}&IsPrimary=1`)
    const userStations = response.records || []

    if (userStations.length > 0) {
      const stationResponse = await apiCall(`/Stations/${userStations[0].StationID}`)
      currentStation.value = stationResponse
    }
  } catch (error) {
    console.error('Error loading user station:', error)
  }
}

// Load Today's Attendance
const loadTodayAttendance = async () => {
  try {
    if (!currentUser.value?.id || !currentStation.value?.StationID) return

    const today = new Date().toISOString().split('T')[0]
    const response = await apiCall(
      `/Attendance?UserID=${currentUser.value.id}&StationID=${currentStation.value.StationID}&AttendanceDate=${today}`,
    )
    const records = response.records || []

    todayAttendance.value = records.length > 0 ? records[0] : null
  } catch (error) {
    console.error('Error loading today attendance:', error)
  }
}

// Load Recent Attendance
const loadRecentAttendance = async () => {
  try {
    if (!currentUser.value?.id || !currentStation.value?.StationID) return

    const response = await apiCall(
      `/Attendance?UserID=${currentUser.value.id}&StationID=${currentStation.value.StationID}&sort=-AttendanceDate&limit=10`,
    )
    recentAttendance.value = response.records || []
  } catch (error) {
    console.error('Error loading recent attendance:', error)
  }
}

// Calculate Weekly Stats
const calculateWeeklyStats = () => {
  const weekData = recentAttendance.value.slice(0, 7)

  weeklyStats.present = weekData.filter((r) => r.Status === 'Present').length
  weeklyStats.late = weekData.filter((r) => r.Status === 'Late').length
  weeklyStats.absent = weekData.filter((r) => r.Status === 'Absent').length

  const totalHours = weekData.reduce((sum, record) => {
    const hours = parseFloat(calculateRecordHours(record)) || 0
    return sum + hours
  }, 0)

  weeklyStats.avgHours = weekData.length > 0 ? (totalHours / weekData.length).toFixed(1) : '0.0'
}

// Clock In Function
const clockIn = async () => {
  try {
    const result = await Swal.fire({
      title: 'Clock In Confirmation',
      text: 'Are you ready to start your shift?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Yes, Clock In',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#00a651',
      cancelButtonColor: '#f1416c',
    })

    if (!result.isConfirmed) return

    loading.value = true
    loadingMessage.value = 'Clocking in...'

    const attendanceData = {
      StationID: currentStation.value.StationID,
      UserID: currentUser.value.id,
      AttendanceDate: new Date().toISOString().split('T')[0],
      TimeIn: new Date().toISOString(),
      Status: 'Present',
      Notes: attendanceNotes.value || null,
    }

    await apiCall('/Attendance', {
      method: 'POST',
      body: JSON.stringify(attendanceData),
    })

    await Swal.fire({
      title: 'Clocked In Successfully!',
      text: 'Have a great shift!',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    attendanceNotes.value = ''
    await refreshData()
  } catch (error) {
    console.error('Clock in error:', error)
    await Swal.fire({
      title: 'Clock In Failed',
      text: error.message || 'Unable to clock in. Please try again.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Clock Out Function
const clockOut = async () => {
  try {
    const result = await Swal.fire({
      title: 'Clock Out Confirmation',
      text: 'Are you ready to end your shift?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Yes, Clock Out',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#f1416c',
      cancelButtonColor: '#3699ff',
    })

    if (!result.isConfirmed) return

    loading.value = true
    loadingMessage.value = 'Clocking out...'

    const updateData = {
      TimeOut: new Date().toISOString(),
      Notes: attendanceNotes.value || todayAttendance.value.Notes,
    }

    await apiCall(`/Attendance/${todayAttendance.value.AttendanceID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData),
    })

    await Swal.fire({
      title: 'Clocked Out Successfully!',
      text: 'Thanks for your hard work today!',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    attendanceNotes.value = ''
    await refreshData()
  } catch (error) {
    console.error('Clock out error:', error)
    await Swal.fire({
      title: 'Clock Out Failed',
      text: error.message || 'Unable to clock out. Please try again.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Load Attendance History
const loadAttendanceHistory = async () => {
  try {
    if (!currentUser.value?.id || !currentStation.value?.StationID) return

    const response = await apiCall(
      `/Attendance?UserID=${currentUser.value.id}&StationID=${currentStation.value.StationID}&sort=-AttendanceDate`,
    )
    let records = response.records || []

    // Filter by date range
    records = records.filter((record) => {
      const recordDate = record.AttendanceDate
      return recordDate >= historyFilter.startDate && recordDate <= historyFilter.endDate
    })

    attendanceHistory.value = records
  } catch (error) {
    console.error('Error loading attendance history:', error)
  }
}

// Create Attendance Chart
const createAttendanceChart = async () => {
  if (!attendanceChart.value) return

  try {
    // Import Chart.js dynamically
    const { Chart, registerables } = await import(
      'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js'
    )
    Chart.register(...registerables)

    const ctx = attendanceChart.value.getContext('2d')

    // Prepare chart data
    const last7Days = []
    const attendanceData = []

    for (let i = 6; i >= 0; i--) {
      const date = new Date()
      date.setDate(date.getDate() - i)
      const dateStr = date.toISOString().split('T')[0]
      last7Days.push(date.toLocaleDateString('en-US', { weekday: 'short' }))

      const dayRecord = recentAttendance.value.find((r) => r.AttendanceDate === dateStr)
      attendanceData.push(dayRecord ? 1 : 0)
    }

    chartInstance = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: last7Days,
        datasets: [
          {
            label: 'Attendance',
            data: attendanceData,
            backgroundColor: [
              '#00a651',
              '#00a651',
              '#00a651',
              '#00a651',
              '#00a651',
              '#ffc700',
              '#f1416c',
            ],
            borderRadius: 6,
            borderSkipped: false,
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
            max: 1,
            ticks: {
              stepSize: 1,
              callback: function (value) {
                return value === 1 ? 'Present' : 'Absent'
              },
            },
          },
          x: {
            grid: {
              display: false,
            },
          },
        },
      },
    })
  } catch (error) {
    console.error('Error creating chart:', error)
  }
}

// Utility Functions
const formatTimeIn = (timeString) => {
  if (!timeString) return null
  const date = new Date(timeString)
  return date.toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: true,
  })
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}

const calculateHoursWorked = () => {
  if (!todayAttendance.value?.TimeIn) return '0.0 hrs'

  const timeIn = new Date(todayAttendance.value.TimeIn)
  const timeOut = todayAttendance.value.TimeOut
    ? new Date(todayAttendance.value.TimeOut)
    : new Date()

  const diffMs = timeOut - timeIn
  const hours = diffMs / (1000 * 60 * 60)

  return `${hours.toFixed(1)} hrs`
}

const calculateRecordHours = (record) => {
  if (!record.TimeIn || !record.TimeOut) return '0.0'

  const timeIn = new Date(record.TimeIn)
  const timeOut = new Date(record.TimeOut)
  const diffMs = timeOut - timeIn
  const hours = diffMs / (1000 * 60 * 60)

  return hours.toFixed(1)
}

const getStatusColor = (status) => {
  switch (status) {
    case 'Present':
      return 'bg-success'
    case 'Late':
      return 'bg-warning'
    case 'Absent':
      return 'bg-danger'
    default:
      return 'bg-secondary'
  }
}

const getStatusBadge = (status) => {
  switch (status) {
    case 'Present':
      return 'badge-light-success'
    case 'Late':
      return 'badge-light-warning'
    case 'Absent':
      return 'badge-light-danger'
    default:
      return 'badge-light-secondary'
  }
}

// Refresh All Data
const refreshData = async () => {
  loading.value = true
  loadingMessage.value = 'Refreshing data...'

  try {
    await loadTodayAttendance()
    await loadRecentAttendance()
    calculateWeeklyStats()

    // Recreate chart with new data
    if (chartInstance) {
      chartInstance.destroy()
    }
    await nextTick()
    await createAttendanceChart()

    await Swal.fire({
      title: 'Data Refreshed',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Error refreshing data:', error)
  } finally {
    loading.value = false
  }
}

// Time Interval
let timeInterval = null

// Component Lifecycle
onMounted(async () => {
  loading.value = true
  loadingMessage.value = 'Loading attendance data...'

  try {
    updateCurrentTime()
    timeInterval = setInterval(updateCurrentTime, 1000)

    await loadUserStation()
    await loadTodayAttendance()
    await loadRecentAttendance()
    calculateWeeklyStats()

    await nextTick()
    await createAttendanceChart()
  } catch (error) {
    console.error('Error loading initial data:', error)
    await Swal.fire({
      title: 'Loading Error',
      text: 'Unable to load attendance data. Please refresh the page.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
})

onUnmounted(() => {
  if (timeInterval) {
    clearInterval(timeInterval)
  }
  if (chartInstance) {
    chartInstance.destroy()
  }
})
</script>

<style scoped>
.timeline {
  position: relative;
}

.timeline-item {
  position: relative;
  padding-bottom: 20px;
}

.timeline-line {
  position: absolute;
  left: 15px;
  top: 30px;
  bottom: -20px;
  background-color: #e1e3ea;
}

.timeline-icon {
  position: relative;
  z-index: 2;
}

.timeline-content {
  min-height: 30px;
}

.modal.fade {
  display: block !important;
  background-color: rgba(0, 0, 0, 0.5);
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.card-gradient-primary {
  background: linear-gradient(135deg, #3699ff 0%, #0084f4 100%);
}

.h-75px {
  height: 75px !important;
}

.mh-300px {
  max-height: 300px;
}

@media (max-width: 768px) {
  .modal-lg {
    max-width: 95%;
  }

  .card-body {
    padding: 1rem !important;
  }

  .fs-2 {
    font-size: 1.5rem !important;
  }

  .h-75px {
    height: 60px !important;
  }
}
</style>

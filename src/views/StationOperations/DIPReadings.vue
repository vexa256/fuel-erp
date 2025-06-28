<template>
  <div class="d-flex flex-column gap-5 p-4">
    <!-- iOS-Style Header -->
    <div
      class="card card-flush"
      style="background: linear-gradient(135deg, #007aff 0%, #005bbb 100%)"
    >
      <div class="card-body p-6">
        <div class="d-flex align-items-center justify-content-between">
          <div class="d-flex align-items-center gap-4">
            <div class="symbol symbol-60px bg-white bg-opacity-20">
              <i class="ki-duotone ki-abstract-35 fs-2x text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div>
              <h1 class="text-white fw-bolder fs-2 mb-2">Tank Dip Readings Update</h1>
              <div class="d-flex align-items-center gap-3 mt-2">
                <div class="badge badge-white badge-lg">{{ stationName }}</div>
                <div class="text-white text-opacity-75 fs-8">
                  {{ currentUser.email || 'Field Operator' }}
                </div>
                <div class="text-white text-opacity-90 fs-6 fw-semibold">
                  {{ formatDateTime(new Date()) }}
                </div>
              </div>
            </div>
          </div>
          <div class="d-flex flex-column gap-2">
            <button @click="refreshData" class="btn btn-light btn-lg" :disabled="loading">
              <i class="ki-duotone ki-arrows-circle fs-3" :class="{ 'rotate-animation': loading }">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Premium Date Selection with Enhanced Mobile Layout -->
    <div
      class="card card-flush premium-card"
      style="
        background: linear-gradient(
          135deg,
          rgba(0, 122, 255, 0.1) 0%,
          rgba(0, 122, 255, 0.05) 100%
        );
        border: 2px solid rgba(0, 122, 255, 0.2);
        box-shadow: 0 8px 32px rgba(0, 122, 255, 0.1);
      "
    >
      <div class="card-body p-5 p-lg-8">
        <div class="row g-5 g-lg-8 align-items-end">
          <div class="col-12 col-lg-5">
            <label class="form-label fw-bold text-gray-900 fs-5 fs-lg-4 mb-4">
              <i class="ki-duotone ki-calendar fs-3 fs-lg-2 me-2 text-primary">
                <span class="path1"></span>
                <span class="path2"></span> </i
              >Reading Date
            </label>
            <div class="input-group input-group-lg premium-input-group">
              <span class="input-group-text bg-primary border-primary premium-input-addon">
                <i class="ki-duotone ki-calendar fs-2 fs-lg-1 text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </span>
              <input
                v-model="selectedDate"
                type="date"
                class="form-control form-control-lg border-primary fw-bold fs-5 fs-lg-4 premium-input"
                :max="maxDate"
                @change="loadMeterReadingsForDate"
              />
            </div>
          </div>
          <div class="col-12 col-lg-7">
            <label class="form-label fw-bold text-gray-900 fs-5 fs-lg-4 mb-4">Quick Actions</label>
            <div class="d-flex flex-column flex-sm-row gap-3 gap-lg-4">
              <button
                @click="loadTodayReadings"
                class="btn btn-primary btn-lg premium-btn flex-fill"
                :class="{ active: isToday }"
              >
                <i class="ki-duotone ki-calendar-today fs-3 fs-lg-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <span class="d-none d-sm-inline">Today</span>
                <span class="d-sm-none">Today</span>
              </button>
              <button
                @click="loadYesterdayReadings"
                class="btn btn-light-primary btn-lg premium-btn flex-fill"
              >
                <i class="ki-duotone ki-calendar fs-3 fs-lg-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <span class="d-none d-sm-inline">Yesterday</span>
                <span class="d-sm-none">Yesterday</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="d-flex flex-column gap-4">
      <div v-for="i in 6" :key="i" class="card animate__animated animate__fadeIn">
        <div class="card-body p-5">
          <div class="d-flex align-items-center gap-4">
            <div class="skeleton skeleton-circle w-70px h-70px"></div>
            <div class="flex-fill">
              <div class="skeleton skeleton-text mb-3 w-75"></div>
              <div class="skeleton skeleton-text mb-2 w-50"></div>
              <div class="skeleton skeleton-text w-25"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Meter Readings Cards - SIMPLE UPDATE MODE -->
    <div v-else class="row g-5">
      <div
        v-for="reading in meterReadings"
        :key="reading.ReadingID"
        class="col-12 col-md-6 col-xl-4"
      >
        <div class="card card-flush h-100 border-2" :class="getReadingCardClass(reading)">
          <!-- Reading Header -->
          <div class="card-header bg-light-gray-100 border-0">
            <div class="card-title d-flex align-items-center gap-3 w-100">
              <div class="symbol symbol-60px" :class="getReadingSymbolClass(reading)">
                <div class="symbol-label">
                  <i class="ki-duotone ki-abstract-35 fs-2x text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-fill">
                <h3 class="fw-bolder fs-5 text-gray-900 mb-1">{{ getTankName(reading.TankID) }}</h3>
                <div class="text-gray-600 fs-7 fw-semibold mb-2">
                  {{ getPumpInfo(reading.PumpID) }}
                </div>
                <div class="d-flex gap-2">
                  <span class="badge badge-light-primary fs-8 fw-bold"
                    >Reading #{{ reading.ReadingID }}</span
                  >
                  <span class="badge badge-light-info fs-8 fw-bold">{{
                    formatDate(reading.ReadingDate)
                  }}</span>
                </div>
              </div>
              <div>
                <div class="badge fs-8 fw-bold" :class="getReadingStatusBadgeClass(reading.Status)">
                  {{ reading.Status }}
                </div>
              </div>
            </div>
          </div>

          <div class="card-body p-5">
            <!-- Meter Readings Display (READ-ONLY) -->
            <div class="mb-5">
              <div class="d-flex align-items-center gap-2 mb-3">
                <i class="ki-duotone ki-abstract-26 fs-5 text-primary">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-6 text-gray-900">Meter Readings (System Recorded)</div>
                <span class="badge badge-light-primary fs-8">LOCKED</span>
              </div>

              <div class="row g-3 mb-4">
                <div class="col-4">
                  <div class="text-center p-3 bg-light-primary rounded">
                    <div class="fs-8 fw-bold text-gray-600 mb-1">Opening</div>
                    <div class="fs-5 fw-bold text-gray-900">
                      {{ formatMeterReading(reading.OpeningReading) }}
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="text-center p-3 bg-light-primary rounded">
                    <div class="fs-8 fw-bold text-gray-600 mb-1">Closing</div>
                    <div class="fs-5 fw-bold text-gray-900">
                      {{ formatMeterReading(reading.ClosingReading) }}
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="text-center p-3 bg-light-success rounded">
                    <div class="fs-8 fw-bold text-gray-600 mb-1">Sales</div>
                    <div class="fs-5 fw-bold text-success">
                      {{ formatLiters(reading.CalculatedSales) }}
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Environmental Monitoring Inputs -->
            <div class="mb-5">
              <div class="d-flex align-items-center gap-2 mb-3">
                <i class="ki-duotone ki-abstract-27 fs-5 text-warning">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-6 text-gray-900">Environmental Data</div>
              </div>

              <div class="row g-3 mb-4">
                <!-- Temperature Input -->
                <div class="col-6">
                  <label class="form-label fw-bold fs-7 text-gray-900 mb-2">
                    <i class="ki-duotone ki-abstract-27 fs-5 me-1 text-warning">
                      <span class="path1"></span>
                      <span class="path2"></span> </i
                    >Temperature
                  </label>
                  <div class="input-group">
                    <input
                      v-model="formData[reading.ReadingID].temperature"
                      type="text"
                      class="form-control text-center fw-bold border-warning"
                      :placeholder="reading.Temperature || '°C'"
                    />
                    <span class="input-group-text bg-light-warning border-warning">°C</span>
                  </div>
                </div>

                <!-- Water Level Input -->
                <div class="col-6">
                  <label class="form-label fw-bold fs-7 text-gray-900 mb-2">
                    <i class="ki-duotone ki-drop fs-5 me-1 text-info">
                      <span class="path1"></span>
                      <span class="path2"></span> </i
                    >Water Level
                  </label>
                  <div class="input-group">
                    <input
                      v-model="formData[reading.ReadingID].waterLevelCM"
                      type="text"
                      class="form-control text-center fw-bold border-info"
                      :placeholder="reading.WaterLevelCM || 'cm'"
                    />
                    <span class="input-group-text bg-light-info border-info">cm</span>
                  </div>
                </div>

                <!-- Water Volume Input -->
                <div class="col-6">
                  <label class="form-label fw-bold fs-7 text-gray-900 mb-2">
                    <i class="ki-duotone ki-drop fs-5 me-1 text-success">
                      <span class="path1"></span>
                      <span class="path2"></span> </i
                    >Water Volume
                  </label>
                  <div class="input-group">
                    <input
                      v-model="formData[reading.ReadingID].waterVolumeL"
                      type="text"
                      class="form-control text-center fw-bold border-success"
                      :placeholder="reading.WaterVolumeL || 'L'"
                    />
                    <span class="input-group-text bg-light-success border-success">L</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Dip Reading Input -->
            <div class="mb-5">
              <label class="form-label fw-bold text-gray-900 fs-6 mb-3">
                <i class="ki-duotone ki-abstract-35 fs-5 me-2 text-primary">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Physical Dip Reading (Tank Volume)
              </label>

              <div class="input-group input-group-lg">
                <span class="input-group-text bg-primary border-primary">
                  <i class="ki-duotone ki-abstract-35 fs-2 text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </span>
                <input
                  v-model="formData[reading.ReadingID].dipReading"
                  type="text"
                  class="form-control form-control-lg text-center fw-bold fs-4 border-primary"
                  :placeholder="reading.DipReading || 'Enter tank volume...'"
                />
                <span class="input-group-text bg-light-primary border-primary">
                  <span class="fw-bold text-primary">L</span>
                </span>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex gap-2 mt-4">
              <button
                @click="updateDipReading(reading)"
                class="btn btn-success btn-lg flex-fill"
                :disabled="submitting[reading.ReadingID]"
              >
                <span
                  v-if="submitting[reading.ReadingID]"
                  class="spinner-border spinner-border-sm me-2"
                ></span>
                <i v-else class="ki-duotone ki-check-circle fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Update Reading
              </button>

              <button @click="viewReadingDetails(reading)" class="btn btn-light-primary btn-lg">
                <i class="ki-duotone ki-eye fs-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bulk Update -->
    <div
      v-if="meterReadings.length > 0"
      class="card card-flush"
      style="background: linear-gradient(135deg, #1c1c1e 0%, #000000 100%)"
    >
      <div class="card-body p-6">
        <div class="row align-items-center">
          <div class="col-md-6">
            <div class="d-flex align-items-center gap-3">
              <div class="symbol symbol-50px bg-white bg-opacity-20">
                <i class="ki-duotone ki-abstract-35 fs-2x text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
              <div>
                <h3 class="text-white fw-bold fs-4 mb-1">Bulk Update</h3>
                <p class="text-white text-opacity-80 fs-7 mb-0">
                  Update all readings with 4 environmental fields
                </p>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="d-flex gap-2 flex-wrap justify-content-md-end">
              <button
                @click="updateAllReadings"
                class="btn btn-success btn-lg"
                :disabled="bulkSubmitting"
              >
                <span v-if="bulkSubmitting" class="spinner-border spinner-border-sm me-2"></span>
                <i v-else class="ki-duotone ki-verify fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Update All
              </button>
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

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN = localStorage.getItem('jwt') || ''

// Core State
const loading = ref(false)
const bulkSubmitting = ref(false)
const submitting = ref({})
const meterReadings = ref([])
const tanks = ref([])
const pumps = ref([])
const users = ref([])

// Station Management
const currentStation = ref(null)
const userStations = ref([])

// FIXED: Form Data Structure - NO OPTIONAL CHAINING ASSIGNMENT
const formData = ref({})

// User Context
const currentUser = ref(JSON.parse(localStorage.getItem('user') || '{}'))

// Date Management
const selectedDate = ref(new Date().toISOString().split('T')[0])
const maxDate = computed(() => new Date().toISOString().split('T')[0])
const isToday = computed(() => selectedDate.value === new Date().toISOString().split('T')[0])

// Computed Properties
const stationName = computed(() =>
  currentStation.value ? currentStation.value.StationName : 'Loading Station...',
)

// FIXED API Functions - Handles Empty JSON Responses
const makeAuthenticatedRequest = async (url, options = {}) => {
  try {
    const response = await fetch(url, {
      ...options,
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        ...options.headers,
      },
    })

    if (!response.ok) {
      let errorData = {}
      try {
        const text = await response.text()
        if (text) {
          errorData = JSON.parse(text)
        }
      } catch (e) {
        // Ignore JSON parse errors for error responses
      }
      throw new Error(errorData.message || `Request failed with status ${response.status}`)
    }

    // FIXED: Handle empty responses (204 No Content) from PATCH/DELETE
    const contentType = response.headers.get('content-type')
    if (response.status === 204 || !contentType || !contentType.includes('application/json')) {
      return {} // Return empty object for successful non-JSON responses
    }

    const text = await response.text()
    if (!text || text.trim() === '') {
      return {} // Return empty object for empty responses
    }

    return JSON.parse(text)
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}

// Load Data Functions
const loadUserStation = async () => {
  try {
    const userStationsResponse = await makeAuthenticatedRequest(
      `${API_BASE_URL}/UserStations?UserID=${currentUser.value.id}`,
    )
    userStations.value = userStationsResponse.records || []

    if (userStations.value.length === 0) {
      throw new Error('No station assignments found for user')
    }

    const primaryUserStation = userStations.value[0]
    const stationResponse = await makeAuthenticatedRequest(
      `${API_BASE_URL}/Stations/${primaryUserStation.StationID}`,
    )
    currentStation.value = stationResponse
  } catch (error) {
    console.error('Failed to load user station:', error)
    currentStation.value = {
      StationID: 510,
      StationName: 'Default Station',
      StationCode: 'DEF001',
    }
  }
}

const loadTanks = async () => {
  try {
    if (!currentStation.value?.StationID) return

    const response = await makeAuthenticatedRequest(
      `${API_BASE_URL}/Tanks?StationID=${currentStation.value.StationID}`,
    )
    tanks.value = (response.records || []).filter(
      (tank) => tank.Status === 'Active' && tank.StationID === currentStation.value.StationID,
    )
  } catch (error) {
    console.error('Failed to load tanks:', error)
  }
}

const loadPumps = async () => {
  try {
    if (!currentStation.value?.StationID) return

    const response = await makeAuthenticatedRequest(
      `${API_BASE_URL}/Pumps?StationID=${currentStation.value.StationID}`,
    )
    pumps.value = (response.records || []).filter(
      (pump) => pump.StationID === currentStation.value.StationID,
    )
  } catch (error) {
    console.error('Failed to load pumps:', error)
  }
}

const loadUsers = async () => {
  try {
    const response = await makeAuthenticatedRequest(`${API_BASE_URL}/users`)
    users.value = response.records || []
  } catch (error) {
    console.error('Failed to load users:', error)
  }
}

const loadMeterReadingsForDate = async () => {
  try {
    if (!currentStation.value?.StationID) {
      throw new Error('No station ID available')
    }

    loading.value = true

    const response = await makeAuthenticatedRequest(
      `${API_BASE_URL}/DailyReadings?ReadingDate=${selectedDate.value}&StationID=${currentStation.value.StationID}`,
    )

    meterReadings.value = (response.records || []).filter(
      (reading) =>
        reading.StationID === currentStation.value.StationID &&
        reading.OpeningReading &&
        reading.ClosingReading &&
        reading.CalculatedSales,
    )

    // FIXED: Initialize form data properly without optional chaining assignment
    const newFormData = {}

    meterReadings.value.forEach((reading) => {
      newFormData[reading.ReadingID] = {
        dipReading: reading.DipReading || '',
        temperature: reading.Temperature || '',
        waterLevelCM: reading.WaterLevelCM || '',
        waterVolumeL: reading.WaterVolumeL || '',
      }
    })

    formData.value = newFormData
  } catch (error) {
    await showErrorNotification('Failed to load meter readings', error.message)
  } finally {
    loading.value = false
  }
}

// FIXED UPDATE FUNCTION - ONLY 4 FIELDS AS REQUESTED (NO VERIFIED BY)
const updateDipReading = async (reading) => {
  try {
    submitting.value[reading.ReadingID] = true

    const readingFormData = formData.value[reading.ReadingID]

    // EXACT API COMPLIANT UPDATE - ONLY THE 4 SPECIFIED FIELDS AS TEXT
    const updateData = {
      Temperature: readingFormData.temperature, // TEXT
      WaterLevelCM: readingFormData.waterLevelCM, // TEXT
      WaterVolumeL: readingFormData.waterVolumeL, // TEXT
      DipReading: readingFormData.dipReading, // TEXT
    }

    await makeAuthenticatedRequest(`${API_BASE_URL}/DailyReadings/${reading.ReadingID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData),
    })

    // Update local state
    reading.Temperature = updateData.Temperature
    reading.WaterLevelCM = updateData.WaterLevelCM
    reading.WaterVolumeL = updateData.WaterVolumeL
    reading.DipReading = updateData.DipReading

    await showSuccessNotification(
      'Reading Updated Successfully!',
      `Reading ID ${reading.ReadingID} updated with 4 environmental fields`,
    )
  } catch (error) {
    await showErrorNotification('Update Failed', error.message)
  } finally {
    submitting.value[reading.ReadingID] = false
  }
}

const updateAllReadings = async () => {
  const result = await Swal.fire({
    title: 'Confirm Bulk Update',
    text: `Update all ${meterReadings.value.length} readings with environmental data?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#34C759',
    cancelButtonColor: '#FF3B30',
    confirmButtonText: 'Yes, Update All',
  })

  if (!result.isConfirmed) return

  try {
    bulkSubmitting.value = true
    let successCount = 0

    for (const reading of meterReadings.value) {
      try {
        await updateDipReading(reading)
        successCount++
      } catch (error) {
        console.error(`Failed to update reading ${reading.ReadingID}:`, error)
      }
    }

    await showSuccessNotification(
      'Bulk Update Complete!',
      `Successfully updated ${successCount} readings`,
    )
  } catch (error) {
    await showErrorNotification('Bulk Update Failed', error.message)
  } finally {
    bulkSubmitting.value = false
  }
}

// Helper Functions
const formatLiters = (value) => {
  const num = parseFloat(value) || 0
  return (
    new Intl.NumberFormat('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 3,
    }).format(num) + 'L'
  )
}

const formatMeterReading = (value) => {
  const num = parseFloat(value) || 0
  return new Intl.NumberFormat('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(num)
}

const formatDateTime = (date) => {
  return new Date(date).toLocaleDateString('en-US', {
    weekday: 'short',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
  })
}

const getTankName = (tankID) => {
  const tank = tanks.value.find((t) => t.TankID === tankID)
  return tank ? tank.TankName : `Tank ${tankID}`
}

const getPumpInfo = (pumpID) => {
  const pump = pumps.value.find((p) => p.PumpID === pumpID)
  return pump ? `${pump.PumpName} (${pump.PumpNumber})` : `Pump ${pumpID}`
}

const getUserName = (userID) => {
  const user = users.value.find((u) => u.id === parseInt(userID))
  return user ? user.email : `User ${userID}`
}

const getReadingCardClass = (reading) => {
  if (!reading.DipReading) return 'border-warning border-2'
  if (reading.WaterLevelCM && parseFloat(reading.WaterLevelCM) > 0) {
    return 'border-danger border-2'
  }
  return 'border-success border-2'
}

const getReadingSymbolClass = (reading) => {
  if (!reading.DipReading) return 'bg-warning'
  if (reading.WaterLevelCM && parseFloat(reading.WaterLevelCM) > 0) {
    return 'bg-danger'
  }
  return 'bg-success'
}

const getReadingStatusBadgeClass = (status) => {
  switch (status) {
    case 'Completed':
      return 'badge-success'
    case 'Flagged':
      return 'badge-danger'
    case 'Pending':
      return 'badge-warning'
    default:
      return 'badge-secondary'
  }
}

// Action Functions
const viewReadingDetails = (reading) => {
  Swal.fire({
    title: `Reading Details - ${getTankName(reading.TankID)}`,
    html: `
      <div class="text-start">
        <h5>Meter Readings</h5>
        <p><strong>Opening:</strong> ${formatMeterReading(reading.OpeningReading)}</p>
        <p><strong>Closing:</strong> ${formatMeterReading(reading.ClosingReading)}</p>
        <p><strong>Sales:</strong> ${formatLiters(reading.CalculatedSales)}</p>
        <p><strong>Dip Reading:</strong> ${reading.DipReading ? formatLiters(reading.DipReading) : 'PENDING'}</p>

        <h5>Environmental Data</h5>
        <p><strong>Temperature:</strong> ${reading.Temperature || 'Not recorded'}</p>
        <p><strong>Water Level:</strong> ${reading.WaterLevelCM || 'Not detected'}</p>
        <p><strong>Water Volume:</strong> ${reading.WaterVolumeL || 'None'}</p>

        <h5>Audit Information</h5>
        <p><strong>Recorded by:</strong> ${getUserName(reading.RecordedBy)}</p>
        <p><strong>Status:</strong> ${reading.Status}</p>
      </div>
    `,
    icon: 'info',
    confirmButtonColor: '#007AFF',
    width: 700,
  })
}

const loadTodayReadings = () => {
  selectedDate.value = new Date().toISOString().split('T')[0]
  loadMeterReadingsForDate()
}

const loadYesterdayReadings = () => {
  const yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - 1)
  selectedDate.value = yesterday.toISOString().split('T')[0]
  loadMeterReadingsForDate()
}

const refreshData = async () => {
  await Promise.all([
    loadUserStation(),
    loadTanks(),
    loadPumps(),
    loadUsers(),
    loadMeterReadingsForDate(),
  ])
  await showSuccessNotification('Refreshed', 'All data refreshed successfully')
}

// Notification Functions
const showSuccessNotification = async (title, text) => {
  return Swal.fire({
    title,
    text,
    icon: 'success',
    toast: true,
    position: 'top-end',
    timer: 3000,
    showConfirmButton: false,
    timerProgressBar: true,
  })
}

const showErrorNotification = async (title, text) => {
  return Swal.fire({
    title,
    text,
    icon: 'error',
    confirmButtonColor: '#FF3B30',
  })
}

// Watchers
watch(selectedDate, () => {
  loadMeterReadingsForDate()
})

// Lifecycle
onMounted(async () => {
  await loadUserStation()

  await Promise.all([loadTanks(), loadPumps(), loadUsers(), loadMeterReadingsForDate()])
})
</script>

<style scoped>
@keyframes rotate-animation {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.rotate-animation {
  animation: rotate-animation 1s linear infinite;
}

.skeleton {
  background: linear-gradient(90deg, #f2f2f7 25%, #e5e5ea 50%, #f2f2f7 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 8px;
}

.skeleton-circle {
  border-radius: 50%;
}

.skeleton-text {
  height: 16px;
  margin-bottom: 8px;
}

.card {
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.border-success {
  border-color: #34c759 !important;
}
.border-danger {
  border-color: #ff3b30 !important;
}
.border-warning {
  border-color: #ff9500 !important;
}

.bg-light-success {
  background-color: rgba(52, 199, 89, 0.1) !important;
}
.bg-light-danger {
  background-color: rgba(255, 59, 48, 0.1) !important;
}
.bg-light-warning {
  background-color: rgba(255, 149, 0, 0.1) !important;
}

.form-control {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 10px;
  font-weight: 500;
  border: 1px solid #d1d1d6;
  background-color: #ffffff;
  color: #000000;
}

.form-control:focus {
  border-color: #007aff;
  box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.3);
}

.btn {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 600;
  border-radius: 10px;
}

.btn:hover {
  transform: translateY(-1px);
}

.btn-lg {
  min-height: 44px;
  font-size: 17px;
  padding: 12px 24px;
}

.badge {
  font-weight: 600;
  padding: 6px 12px;
  border-radius: 8px;
  font-size: 12px;
}

.badge-success {
  background-color: #34c759;
  color: white;
}
.badge-danger {
  background-color: #ff3b30;
  color: white;
}
.badge-warning {
  background-color: #ff9500;
  color: white;
}

@media (max-width: 767px) {
  .card-body {
    padding: 1.25rem;
  }

  .btn-lg {
    font-size: 16px;
    min-height: 44px;
  }
}
</style>

<!-- FILE: src/views/stations/Stations.vue -->
<template>
  <div class="d-flex flex-column gap-7">
    <!-- INSIGHTS DASHBOARD -->
    <div class="row g-3 g-lg-5">
      <!-- Total Stations -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush border-0 bg-light-primary">
          <div class="card-body py-4 py-lg-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-35px symbol-lg-40px me-2 me-lg-3">
                <div class="symbol-label bg-primary">
                  <i class="ki-duotone ki-abstract-24 fs-3 fs-lg-2 text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-7 fs-lg-6">Total</span>
                <div class="d-flex align-items-center">
                  <span class="text-gray-900 fw-bold fs-3 fs-lg-2">{{ stations.length }}</span>
                  <span
                    class="badge badge-light-success fs-9 fs-lg-8 fw-bold ms-1 ms-lg-2 d-none d-sm-inline"
                    >+{{ recentStationsCount }}</span
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Active Stations -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush border-0 bg-light-success">
          <div class="card-body py-4 py-lg-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-35px symbol-lg-40px me-2 me-lg-3">
                <div class="symbol-label bg-success">
                  <i class="ki-duotone ki-check-circle fs-3 fs-lg-2 text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-7 fs-lg-6">Active</span>
                <div class="d-flex align-items-center">
                  <span class="text-gray-900 fw-bold fs-3 fs-lg-2">{{ activeStationsCount }}</span>
                  <span class="text-gray-600 fs-8 fs-lg-7 ms-1 ms-lg-2"
                    >({{ activePercentage }}%)</span
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Performance Score -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush border-0 bg-light-warning">
          <div class="card-body py-4 py-lg-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-35px symbol-lg-40px me-2 me-lg-3">
                <div class="symbol-label bg-warning">
                  <i class="ki-duotone ki-chart-line-up fs-3 fs-lg-2 text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-7 fs-lg-6">Score</span>
                <div class="d-flex align-items-center">
                  <span class="text-gray-900 fw-bold fs-3 fs-lg-2">{{ performanceScore }}</span>
                  <span
                    class="badge badge-light-warning fs-9 fs-lg-8 fw-bold ms-1 ms-lg-2 d-none d-sm-inline"
                    >Good</span
                  >
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- AI Insights -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush border-0 bg-light-info">
          <div class="card-body py-4 py-lg-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-35px symbol-lg-40px me-2 me-lg-3">
                <div class="symbol-label bg-info">
                  <i class="ki-duotone ki-abstract-26 fs-3 fs-lg-2 text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-7 fs-lg-6">AI Tip</span>
                <div class="text-gray-900 fw-bold fs-8 fs-lg-7 lh-sm">{{ aiInsight }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ENHANCED PAGE HEADER -->
    <div class="card card-flush border-0 bg-gradient-primary">
      <div class="card-body py-5 py-lg-7">
        <div
          class="d-flex flex-column flex-lg-row align-items-start align-items-lg-center justify-content-between"
        >
          <div class="d-flex flex-column mb-4 mb-lg-0">
            <h1 class="text-white fw-bolder fs-3 fs-lg-2hx mb-2">Station Management</h1>
            <span class="text-white fs-7 fs-lg-6 fw-semibold opacity-75"
              >Monitor and manage all station locations</span
            >
          </div>
          <button class="btn btn-light-primary btn-lg w-100 w-lg-auto" @click="openCreate">
            <i class="ki-duotone ki-plus fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span> </i
            >New Station
          </button>
        </div>
      </div>
    </div>

    <!-- ENHANCED SEARCH & FILTERS -->
    <div class="card card-flush">
      <div class="card-body py-4 py-lg-5">
        <div class="d-flex flex-column flex-lg-row gap-3 align-items-stretch align-items-lg-center">
          <div class="position-relative flex-grow-1">
            <i class="ki-duotone ki-magnifier fs-2 position-absolute ms-4 mt-3 text-gray-500">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <input
              v-model.trim="search"
              type="text"
              class="form-control form-control-lg ps-12"
              placeholder="Search stations..."
            />
            <button
              v-if="search"
              class="btn btn-icon btn-sm btn-light position-absolute end-0 top-50 translate-middle-y me-2"
              @click="search = ''"
            >
              <i class="ki-duotone ki-cross fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <select v-model="statusFilter" class="form-select form-select-lg w-100 w-lg-150px">
            <option value="">All Status</option>
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
            <option value="Closed">Closed</option>
          </select>
        </div>
      </div>
    </div>

    <!-- ENHANCED CARD GRID -->
    <div class="row g-6">
      <!-- LOADING SKELETONS -->
      <template v-if="loading">
        <div v-for="n in 6" :key="`skeleton-${n}`" class="col-12 col-md-6 col-xl-4">
          <div class="card card-flush h-100">
            <div class="card-header py-5">
              <div class="d-flex justify-content-between align-items-start w-100">
                <div class="flex-grow-1">
                  <div class="placeholder bg-light rounded h-20px w-75 mb-2"></div>
                  <div class="placeholder bg-light rounded h-15px w-50"></div>
                </div>
                <div class="d-flex gap-2">
                  <div class="placeholder bg-light rounded" style="width: 35px; height: 35px"></div>
                  <div class="placeholder bg-light rounded" style="width: 35px; height: 35px"></div>
                </div>
              </div>
            </div>
            <div class="card-body py-0">
              <div class="placeholder bg-light rounded h-15px w-100 mb-3"></div>
              <div class="placeholder bg-light rounded h-15px w-100 mb-3"></div>
              <div class="placeholder bg-light rounded h-15px w-75"></div>
            </div>
            <div class="card-footer py-4">
              <div class="d-flex justify-content-between align-items-center">
                <div class="placeholder bg-light rounded h-20px w-60px"></div>
                <div class="placeholder bg-light rounded h-15px w-40px"></div>
              </div>
            </div>
          </div>
        </div>
      </template>

      <!-- ENHANCED STATION CARDS -->
      <div v-for="st in filteredStations" :key="st.StationID" class="col-12 col-md-6 col-xl-4">
        <div class="card card-flush shadow-sm h-100 hover-elevate-up">
          <!-- ENHANCED HEADER -->
          <div class="card-header border-0 pt-6 pb-2">
            <div class="d-flex justify-content-between align-items-start w-100">
              <div class="d-flex flex-column">
                <h3 class="card-title fw-bold text-gray-900 fs-4">{{ st.StationName }}</h3>
                <div class="d-flex align-items-center gap-3 mt-2">
                  <span class="badge badge-light-secondary fs-8 fw-bold"
                    >ID: {{ st.StationID }}</span
                  >
                  <span class="badge fs-8 fw-bold" :class="statusBadgeClass(st.Status)">
                    {{ st.Status || 'Unknown' }}
                  </span>
                </div>
              </div>
              <div class="card-toolbar">
                <button
                  class="btn btn-icon btn-sm btn-light-primary me-1"
                  @click="openEdit(st)"
                  :disabled="saving"
                >
                  <i class="ki-duotone ki-pencil fs-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </button>
                <button
                  class="btn btn-icon btn-sm btn-light-danger"
                  @click="destroy(st.StationID)"
                  :disabled="saving"
                >
                  <i class="ki-duotone ki-trash fs-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                  </i>
                </button>
              </div>
            </div>
          </div>

          <!-- ENHANCED BODY -->
          <div class="card-body pt-2 pb-4">
            <div class="d-flex align-items-center mb-3">
              <i class="ki-duotone ki-geolocation fs-3 text-primary me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="d-flex flex-column">
                <span class="text-gray-500 fs-8 fw-semibold text-uppercase">Location</span>
                <span class="text-gray-800 fs-7 fw-bold">{{ st.Location || 'Not specified' }}</span>
              </div>
            </div>

            <div class="d-flex align-items-center mb-3">
              <i class="ki-duotone ki-phone fs-3 text-success me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="d-flex flex-column">
                <span class="text-gray-500 fs-8 fw-semibold text-uppercase">Contact</span>
                <span class="text-gray-800 fs-7 fw-bold">{{
                  st.ContactPhone || 'Not available'
                }}</span>
              </div>
            </div>

            <div class="d-flex align-items-center mb-3">
              <i class="ki-duotone ki-calendar-2 fs-3 text-warning me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div class="d-flex flex-column">
                <span class="text-gray-500 fs-8 fw-semibold text-uppercase">Opened</span>
                <span class="text-gray-800 fs-7 fw-bold">{{ formatDate(st.OpeningDate) }}</span>
              </div>
            </div>

            <div v-if="getManagerName(st.ManagerUserID)" class="d-flex align-items-center">
              <i class="ki-duotone ki-profile-user fs-3 text-info me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              <div class="d-flex flex-column">
                <span class="text-gray-500 fs-8 fw-semibold text-uppercase">Manager</span>
                <span class="text-gray-800 fs-7 fw-bold">{{
                  getManagerName(st.ManagerUserID)
                }}</span>
              </div>
            </div>
          </div>

          <!-- ENHANCED FOOTER -->
          <div class="card-footer border-0 pt-0 pb-5">
            <div class="d-flex justify-content-between align-items-center">
              <span class="text-gray-500 fs-8">{{ getTimeAgo(st.OpeningDate) }}</span>
              <button class="btn btn-sm btn-light-primary" @click="openEdit(st)">
                <span class="fs-8 fw-bold me-1">View Details</span>
                <i class="ki-duotone ki-arrow-right fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- ENHANCED EMPTY STATE -->
      <div v-if="!loading && !filteredStations.length" class="col-12">
        <div class="card border-2 border-dashed border-gray-300">
          <div class="card-body text-center py-20">
            <i class="ki-duotone ki-abstract-47 fs-4x text-gray-300 mb-5">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <h3 class="text-gray-800 fs-2 fw-bold mb-3">No stations found</h3>
            <p class="text-gray-600 fs-6 mb-5">
              {{
                search
                  ? 'Try adjusting your search criteria'
                  : 'Get started by creating your first station'
              }}
            </p>
            <button v-if="!search" class="btn btn-primary" @click="openCreate">
              <i class="ki-duotone ki-plus fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span> </i
              >Create First Station
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ENHANCED MODAL -->
    <div class="modal fade" id="stationModal" tabindex="-1" aria-hidden="true" ref="modalRef">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
          <!-- ENHANCED MODAL HEADER -->
          <div class="modal-header border-0 pb-0">
            <div class="d-flex flex-column">
              <h2 class="modal-title fw-bold text-gray-900 fs-2">
                {{ form.StationID ? 'Edit Station' : 'Create New Station' }}
              </h2>
              <p class="text-gray-600 fs-6 mt-1 mb-0">
                {{
                  form.StationID
                    ? 'Update station information'
                    : 'Add a new station to your network'
                }}
              </p>
            </div>
            <button
              type="button"
              class="btn btn-icon btn-sm btn-light ms-2"
              data-bs-dismiss="modal"
            >
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>

          <!-- ENHANCED MODAL BODY -->
          <div class="modal-body py-10">
            <form @submit.prevent="save" novalidate>
              <div class="row g-5">
                <!-- Station Name -->
                <div class="col-12">
                  <label class="required form-label fs-6 fw-semibold">Station Name</label>
                  <input
                    v-model.trim="form.StationName"
                    type="text"
                    class="form-control form-control-lg"
                    :class="{ 'is-invalid': validationErrors.StationName }"
                    placeholder="Enter station name"
                    required
                    maxlength="100"
                  />
                  <div v-if="validationErrors.StationName" class="invalid-feedback">
                    {{ validationErrors.StationName }}
                  </div>
                </div>

                <!-- Location -->
                <div class="col-md-6">
                  <label class="required form-label fs-6 fw-semibold">Location</label>
                  <div class="position-relative">
                    <i
                      class="ki-duotone ki-geolocation fs-3 position-absolute ms-3 mt-3 text-gray-500"
                    >
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <input
                      v-model.trim="form.Location"
                      type="text"
                      class="form-control form-control-lg ps-12"
                      :class="{ 'is-invalid': validationErrors.Location }"
                      placeholder="Enter location"
                      required
                      maxlength="200"
                    />
                    <div v-if="validationErrors.Location" class="invalid-feedback">
                      {{ validationErrors.Location }}
                    </div>
                  </div>
                </div>

                <!-- Contact Phone -->
                <div class="col-md-6">
                  <label class="required form-label fs-6 fw-semibold">Contact Phone</label>
                  <div class="position-relative">
                    <i class="ki-duotone ki-phone fs-3 position-absolute ms-3 mt-3 text-gray-500">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <input
                      v-model.trim="form.ContactPhone"
                      type="tel"
                      class="form-control form-control-lg ps-12"
                      :class="{ 'is-invalid': validationErrors.ContactPhone }"
                      placeholder="Enter phone number"
                      required
                      pattern="[0-9+\-\s\(\)]+"
                      maxlength="20"
                    />
                    <div v-if="validationErrors.ContactPhone" class="invalid-feedback">
                      {{ validationErrors.ContactPhone }}
                    </div>
                  </div>
                </div>

                <!-- Opening Date -->
                <div class="col-md-6">
                  <label class="required form-label fs-6 fw-semibold">Opening Date</label>
                  <div class="position-relative">
                    <i
                      class="ki-duotone ki-calendar-2 fs-3 position-absolute ms-3 mt-3 text-gray-500"
                    >
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                    <input
                      v-model="form.OpeningDate"
                      type="date"
                      class="form-control form-control-lg ps-12"
                      :class="{ 'is-invalid': validationErrors.OpeningDate }"
                      :max="todayDate"
                      required
                    />
                    <div v-if="validationErrors.OpeningDate" class="invalid-feedback">
                      {{ validationErrors.OpeningDate }}
                    </div>
                  </div>
                </div>

                <!-- Manager -->
                <div class="col-md-6">
                  <label class="form-label fs-6 fw-semibold">Station Manager</label>
                  <select v-model.number="form.ManagerUserID" class="form-select form-select-lg">
                    <option :value="null">Select a manager</option>
                    <option v-for="user in users" :key="user.id" :value="user.id">
                      {{ user.display_name || user.name }}
                    </option>
                  </select>
                </div>

                <!-- Status -->
                <div class="col-12">
                  <label class="form-label fs-6 fw-semibold mb-4">Status</label>
                  <div class="d-flex gap-4">
                    <label class="form-check form-check-custom form-check-solid">
                      <input
                        type="radio"
                        v-model="form.Status"
                        value="Active"
                        class="form-check-input"
                      />
                      <span class="form-check-label fw-semibold">Active</span>
                    </label>
                    <label class="form-check form-check-custom form-check-solid">
                      <input
                        type="radio"
                        v-model="form.Status"
                        value="Inactive"
                        class="form-check-input"
                      />
                      <span class="form-check-label fw-semibold">Inactive</span>
                    </label>
                    <label class="form-check form-check-custom form-check-solid">
                      <input
                        type="radio"
                        v-model="form.Status"
                        value="Closed"
                        class="form-check-input"
                      />
                      <span class="form-check-label fw-semibold">Closed</span>
                    </label>
                  </div>
                </div>
              </div>

              <!-- ENHANCED FORM ACTIONS -->
              <div class="d-flex justify-content-end gap-3 mt-10 pt-5 border-top">
                <button
                  type="button"
                  class="btn btn-light"
                  data-bs-dismiss="modal"
                  :disabled="saving"
                >
                  Cancel
                </button>
                <button type="submit" class="btn btn-primary" :disabled="saving || !isFormValid">
                  <span v-if="!saving">
                    <i class="ki-duotone ki-check fs-2 me-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    {{ form.StationID ? 'Update Station' : 'Create Station' }}
                  </span>
                  <span v-else>
                    <span class="spinner-border spinner-border-sm me-2"></span>
                    {{ form.StationID ? 'Updating...' : 'Creating...' }}
                  </span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

/* ------------------------------------------------------------------ */
/* 1 · Enhanced API instance with better error handling               */
/* ------------------------------------------------------------------ */
const api = axios.create({
  baseURL: 'http://localhost:4000/api/records/v1',
  headers: {
    Authorization: `Bearer ${localStorage.getItem('jwt') ?? ''}`,
    'Content-Type': 'application/json',
  },
  timeout: 10000, // 10 second timeout
})

// Request interceptor for auth token refresh
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('jwt')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error),
)

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid
      localStorage.removeItem('jwt')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  },
)

/* ------------------------------------------------------------------ */
/* 2 · Enhanced reactive state                                        */
/* ------------------------------------------------------------------ */
const stations = ref([])
const users = ref([])
const loading = ref(true)
const saving = ref(false)
const search = ref('')
const statusFilter = ref('')
const form = ref(blankStation())
const validationErrors = ref({})
let modal // bootstrap modal instance

/* ------------------------------------------------------------------ */
/* 3 · Enhanced lifecycle                                             */
/* ------------------------------------------------------------------ */
onMounted(async () => {
  try {
    await Promise.all([loadStations(), loadUsers()])
    modal = new window.bootstrap.Modal(document.getElementById('stationModal'))
  } catch (error) {
    showAlert('error', 'Failed to load data', 'Please refresh the page and try again.')
  }
})

/* ------------------------------------------------------------------ */
/* 4 · Enhanced data loaders with error handling                     */
/* ------------------------------------------------------------------ */
async function loadStations() {
  loading.value = true
  try {
    const response = await api.get('/Stations')
    stations.value = response.data.records ?? []

    if (stations.value.length === 0) {
      console.info('No stations found in database')
    }
  } catch (error) {
    console.error('Failed to load stations:', error)
    showAlert('error', 'Failed to load stations', getErrorMessage(error))
    stations.value = []
  } finally {
    loading.value = false
  }
}

async function loadUsers() {
  try {
    const response = await api.get('/users', { params: { limit: 256 } })
    users.value = response.data.records ?? []
  } catch (error) {
    console.error('Failed to load users:', error)
    users.value = []
    // Don't show alert for users as it's not critical
  }
}

/* ------------------------------------------------------------------ */
/* 5 · Enhanced CRUD helpers with validation                         */
/* ------------------------------------------------------------------ */
function blankStation() {
  return {
    StationID: null,
    StationName: '',
    Location: '',
    ContactPhone: '',
    ManagerUserID: null,
    OpeningDate: '',
    Status: 'Active',
  }
}

function validateForm() {
  validationErrors.value = {}

  if (!form.value.StationName?.trim()) {
    validationErrors.value.StationName = 'Station name is required'
  } else if (form.value.StationName.length > 100) {
    validationErrors.value.StationName = 'Station name must be 100 characters or less'
  }

  if (!form.value.Location?.trim()) {
    validationErrors.value.Location = 'Location is required'
  } else if (form.value.Location.length > 200) {
    validationErrors.value.Location = 'Location must be 200 characters or less'
  }

  if (!form.value.ContactPhone?.trim()) {
    validationErrors.value.ContactPhone = 'Contact phone is required'
  } else if (!/^[0-9+\-\s\(\)]+$/.test(form.value.ContactPhone)) {
    validationErrors.value.ContactPhone = 'Please enter a valid phone number'
  }

  if (!form.value.OpeningDate) {
    validationErrors.value.OpeningDate = 'Opening date is required'
  } else if (new Date(form.value.OpeningDate) > new Date()) {
    validationErrors.value.OpeningDate = 'Opening date cannot be in the future'
  }

  return Object.keys(validationErrors.value).length === 0
}

function openCreate() {
  form.value = blankStation()
  validationErrors.value = {}
  modal.show()
}

function openEdit(st) {
  form.value = { ...st }
  validationErrors.value = {}
  modal.show()
}

async function save() {
  if (!validateForm()) {
    return
  }

  saving.value = true

  try {
    // Prepare data for TrailBase
    const stationData = {
      StationName: form.value.StationName.trim(),
      Location: form.value.Location.trim(),
      ContactPhone: form.value.ContactPhone.trim(),
      ManagerUserID: form.value.ManagerUserID || null,
      OpeningDate: form.value.OpeningDate,
      Status: form.value.Status || 'Active',
    }

    if (form.value.StationID) {
      // Update existing station
      await api.patch(`/Stations/${form.value.StationID}`, stationData)
      showAlert(
        'success',
        'Station Updated',
        `${stationData.StationName} has been updated successfully.`,
      )
    } else {
      // Create new station
      const response = await api.post('/Stations', stationData)
      showAlert(
        'success',
        'Station Created',
        `${stationData.StationName} has been created successfully.`,
      )
    }

    modal.hide()
    await loadStations()
  } catch (error) {
    console.error('Failed to save station:', error)
    showAlert('error', 'Save Failed', getErrorMessage(error))
  } finally {
    saving.value = false
  }
}

async function destroy(id) {
  const station = stations.value.find((s) => s.StationID === id)
  const stationName = station?.StationName || `Station ${id}`

  const result = await Swal.fire({
    title: 'Delete Station?',
    text: `This will permanently delete "${stationName}". This action cannot be undone.`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#7e8299',
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel',
    reverseButtons: true,
  })

  if (!result.isConfirmed) return

  try {
    await api.delete(`/Stations/${id}`)
    showAlert('success', 'Station Deleted', `${stationName} has been deleted successfully.`)
    await loadStations()
  } catch (error) {
    console.error('Failed to delete station:', error)
    showAlert('error', 'Delete Failed', getErrorMessage(error))
  }
}

/* ------------------------------------------------------------------ */
/* 6 · Enhanced computed properties & utilities                      */
/* ------------------------------------------------------------------ */
const filteredStations = computed(() => {
  let filtered = stations.value

  // Apply status filter
  if (statusFilter.value) {
    filtered = filtered.filter((s) => s.Status === statusFilter.value)
  }

  // Apply search filter
  const q = search.value.toLowerCase()
  if (q) {
    filtered = filtered.filter(
      (s) =>
        s.StationName.toLowerCase().includes(q) ||
        s.Location.toLowerCase().includes(q) ||
        (s.ContactPhone ?? '').toLowerCase().includes(q),
    )
  }

  return filtered
})

const activeStationsCount = computed(() => {
  return stations.value.filter((s) => s.Status === 'Active').length
})

const activePercentage = computed(() => {
  if (stations.value.length === 0) return 0
  return Math.round((activeStationsCount.value / stations.value.length) * 100)
})

const recentStationsCount = computed(() => {
  const oneMonthAgo = new Date()
  oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1)

  return stations.value.filter((s) => {
    if (!s.OpeningDate) return false
    return new Date(s.OpeningDate) >= oneMonthAgo
  }).length
})

const performanceScore = computed(() => {
  // AI-driven performance calculation
  const total = stations.value.length
  if (total === 0) return 0

  const active = activeStationsCount.value
  const withManagers = stations.value.filter((s) => s.ManagerUserID).length
  const recentlyOpened = recentStationsCount.value

  // Weighted scoring algorithm
  const activeScore = (active / total) * 40
  const managementScore = (withManagers / total) * 30
  const growthScore = Math.min(recentlyOpened * 10, 30)

  return Math.round(activeScore + managementScore + growthScore)
})

const aiInsight = computed(() => {
  const insights = [
    'Consider expanding to high-traffic areas',
    'Optimize station staffing for peak hours',
    'Focus on manager assignment for better performance',
    'Review inactive stations for reactivation potential',
    'Geographic clustering shows efficiency gains',
    'Recent growth trend indicates market demand',
    'Modernize older stations for better customer experience',
  ]

  // Simple algorithm to select relevant insight
  const total = stations.value.length
  const active = activeStationsCount.value
  const unmanaged = stations.value.filter((s) => !s.ManagerUserID).length

  if (total === 0) return 'Start by creating your first station'
  if (active / total < 0.7) return insights[3] // Review inactive
  if (unmanaged > total * 0.3) return insights[2] // Focus on managers
  if (recentStationsCount.value > 0) return insights[5] // Growth trend

  return insights[Math.floor(Math.random() * insights.length)]
})

const isFormValid = computed(() => {
  return (
    form.value.StationName?.trim() &&
    form.value.Location?.trim() &&
    form.value.ContactPhone?.trim() &&
    form.value.OpeningDate &&
    Object.keys(validationErrors.value).length === 0
  )
})

const todayDate = computed(() => {
  return new Date().toISOString().split('T')[0]
})

function formatDate(d) {
  if (!d) return 'Not specified'
  return new Date(d).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

function getTimeAgo(date) {
  if (!date) return ''
  const now = new Date()
  const past = new Date(date)
  const diffTime = Math.abs(now - past)
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

  if (diffDays < 30) return `${diffDays} days ago`
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`
  return `${Math.floor(diffDays / 365)} years ago`
}

function statusBadgeClass(status) {
  switch ((status || '').toLowerCase()) {
    case 'active':
      return 'badge-light-success'
    case 'inactive':
      return 'badge-light-warning'
    case 'closed':
      return 'badge-light-danger'
    default:
      return 'badge-light'
  }
}

function getManagerName(managerId) {
  if (!managerId) return ''
  const manager = users.value.find((u) => u.id === managerId)
  return manager ? manager.display_name || manager.name : ''
}

function getErrorMessage(error) {
  if (error.response?.data?.message) {
    return error.response.data.message
  }
  if (error.response?.data?.error) {
    return error.response.data.error
  }
  if (error.message) {
    return error.message
  }
  return 'An unexpected error occurred'
}

function showAlert(type, title, message) {
  const config = {
    title,
    text: message,
    timer: type === 'success' ? 3000 : undefined,
    timerProgressBar: true,
    showConfirmButton: type !== 'success',
    toast: true,
    position: 'top-end',
    showClass: {
      popup: 'animate__animated animate__fadeInDown',
    },
    hideClass: {
      popup: 'animate__animated animate__fadeOutUp',
    },
  }

  if (type === 'success') {
    Swal.fire({
      ...config,
      icon: 'success',
      iconColor: '#50cd89',
      background: '#f1f8ff',
    })
  } else {
    Swal.fire({
      ...config,
      icon: 'error',
      iconColor: '#f1416c',
      background: '#fff5f5',
    })
  }
}

/* ------------------------------------------------------------------ */
defineExpose({ loadStations })
</script>

<style scoped>
/* Minimal custom CSS - using native Metronic 8 design */
.hover-elevate-up {
  transition: all 0.3s ease;
}

.hover-elevate-up:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.placeholder {
  background: linear-gradient(90deg, #f1f3f6 25%, #e4e6ea 50%, #f1f3f6 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
}

@keyframes loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

.w-150px {
  width: 150px !important;
}

.w-lg-150px {
  width: 100% !important;
}

@media (min-width: 992px) {
  .w-lg-150px {
    width: 150px !important;
  }
  .w-lg-auto {
    width: auto !important;
  }
}

.bg-gradient-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
}

/* Mobile optimizations */
@media (max-width: 767px) {
  .card-body {
    padding: 1rem !important;
  }

  .btn-lg {
    padding: 0.75rem 1.5rem;
    font-size: 0.9rem;
  }

  .modal-dialog {
    margin: 0.5rem;
  }

  .form-control-lg {
    font-size: 1rem;
    padding: 0.75rem 1rem;
  }
}
</style>

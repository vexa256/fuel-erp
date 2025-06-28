<template>
  <div class="w-100 d-flex flex-column gap-6 p-5 bg-light-primary rounded-4 overflow-auto">
    <!-- Header with Stats -->
    <div class="d-flex justify-content-between align-items-start flex-wrap gap-4">
      <div>
        <h2 class="fw-bolder fs-1 text-dark">🚚 Supplier Registry</h2>
        <div class="text-muted fs-6">Manage suppliers and station assignments</div>
      </div>
      <button
        class="btn btn-light-success btn-lg d-inline-flex align-items-center gap-2"
        @click="handleCreate"
      >
        <i class="ki-duotone ki-plus fs-2">
          <span class="path1"></span><span class="path2"></span>
        </i>
        <span class="d-none d-sm-inline">New Supplier</span>
      </button>
    </div>

    <!-- Stats Dashboard -->
    <div class="row g-4">
      <div class="col-6 col-md-3">
        <div class="card bg-light-success border-0 shadow-sm">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-delivery-3 fs-2x text-success mb-2">
              <span class="path1"></span><span class="path2"></span><span class="path3"></span>
            </i>
            <div class="fw-bold fs-2 text-dark">{{ supplierStats.total }}</div>
            <div class="text-success fs-7">Total Suppliers</div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card bg-light-primary border-0 shadow-sm">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-global fs-2x text-primary mb-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            <div class="fw-bold fs-2 text-dark">{{ supplierStats.global }}</div>
            <div class="text-primary fs-7">Global Suppliers</div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card bg-light-warning border-0 shadow-sm">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-map fs-2x text-warning mb-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            <div class="fw-bold fs-2 text-dark">{{ supplierStats.local }}</div>
            <div class="text-warning fs-7">Station-Specific</div>
          </div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="card bg-light-info border-0 shadow-sm">
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-questionnaire-tablet fs-2x text-info mb-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            <div class="fw-bold fs-2 text-dark">{{ supplierStats.active }}</div>
            <div class="text-info fs-7">Active Suppliers</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Search & Filter -->
    <div class="d-flex flex-column gap-4">
      <input
        v-model="searchTerm"
        class="form-control form-control-lg bg-light-info rounded"
        placeholder="🔍 Search supplier by name, contact, or phone..."
      />
      <div class="row g-3">
        <div class="col-md-6">
          <select
            v-model="statusFilter"
            class="form-select form-select-lg bg-light-warning rounded"
          >
            <option value="All">All Statuses</option>
            <option value="Active">Active Only</option>
            <option value="Inactive">Inactive Only</option>
          </select>
        </div>
        <div class="col-md-6">
          <select
            v-model="typeFilter"
            class="form-select form-select-lg bg-light-secondary rounded"
          >
            <option value="All">All Types</option>
            <option value="Global">Global Suppliers</option>
            <option value="Local">Station-Specific</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="isLoading" class="text-center py-10">
      <span class="spinner-border text-primary"></span>
      <div class="text-muted fs-6 mt-3">Loading supplier data...</div>
    </div>

    <!-- No Results -->
    <div v-else-if="filteredSuppliers.length === 0" class="text-center py-10">
      <i class="ki-duotone ki-information-5 fs-3x text-warning mb-3">
        <span class="path1"></span><span class="path2"></span><span class="path3"></span>
      </i>
      <h4 class="text-gray-500 fw-semibold">No matching suppliers found</h4>
      <p class="text-gray-400">Try adjusting your search criteria or create a new supplier</p>
    </div>

    <!-- Supplier Cards -->
    <div v-else class="row g-5">
      <div v-for="supplier in filteredSuppliers" :key="supplier.SupplierID" class="col-12 col-lg-6">
        <div class="card shadow-sm bg-light-secondary rounded-4 border-0 h-100">
          <div class="card-body p-5 d-flex flex-column gap-4">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-start gap-3">
              <div class="flex-grow-1">
                <div class="d-flex align-items-center gap-2 mb-2">
                  <h3 class="text-dark fw-bold fs-3 mb-0">{{ supplier.Name }}</h3>
                  <span
                    v-if="supplier.IsGlobal === '1'"
                    class="badge badge-light-primary fs-8 fw-bold"
                  >
                    <i class="ki-duotone ki-global fs-7">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    GLOBAL
                  </span>
                </div>
                <div class="text-muted fs-7">
                  {{ supplier.ContactPerson || 'No contact person' }}
                </div>
                <div class="text-muted fs-8">
                  TIN: {{ supplier.TaxIdentificationNumber || 'N/A' }}
                </div>
              </div>
              <div class="d-flex flex-column gap-1">
                <div class="d-flex gap-1">
                  <button class="btn btn-sm btn-light-primary" @click="handleEdit(supplier)">
                    <i class="ki-duotone ki-pencil fs-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                  <button class="btn btn-sm btn-light-info" @click="handleManageStations(supplier)">
                    <i class="ki-duotone ki-map fs-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                  <button
                    class="btn btn-sm btn-light-danger"
                    @click="handleDelete(supplier.SupplierID)"
                  >
                    <i class="ki-duotone ki-trash fs-2">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                </div>
              </div>
            </div>

            <!-- Contact Info -->
            <div class="d-flex flex-column gap-2 text-gray-700 fs-6">
              <div class="d-flex align-items-center gap-2">
                <i class="ki-duotone ki-sms fs-2 text-success">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <a :href="`mailto:${supplier.Email || ''}`" class="text-hover-primary">{{
                  supplier.Email || 'No email'
                }}</a>
              </div>
              <div class="d-flex align-items-center gap-2">
                <i class="ki-duotone ki-phone fs-2 text-success">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <a :href="`tel:${supplier.Phone || ''}`" class="text-hover-primary">{{
                  supplier.Phone || 'No phone'
                }}</a>
              </div>
              <div class="d-flex align-items-center gap-2">
                <i class="ki-duotone ki-geolocation fs-2 text-success">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <span class="text-gray-600">{{ supplier.Address || 'No address' }}</span>
              </div>
            </div>

            <!-- Station Assignments -->
            <div class="d-flex flex-column gap-3">
              <div class="d-flex align-items-center justify-content-between">
                <span class="fw-bold text-gray-800 fs-7">Station Coverage</span>
                <span class="badge badge-light-info fs-8">
                  {{ getStationAssignments(supplier.SupplierID).length }} stations
                </span>
              </div>
              <div v-if="supplier.IsGlobal === '1'" class="alert alert-primary py-2 px-3">
                <i class="ki-duotone ki-information-4 fs-6 text-primary me-2">
                  <span class="path1"></span><span class="path2"></span><span class="path3"></span>
                </i>
                <span class="fs-7">Serves all stations globally</span>
              </div>
              <div
                v-else-if="getStationAssignments(supplier.SupplierID).length > 0"
                class="d-flex flex-wrap gap-1"
              >
                <span
                  v-for="assignment in getStationAssignments(supplier.SupplierID).slice(0, 3)"
                  :key="assignment.StationID"
                  class="badge badge-light-secondary fs-8"
                >
                  {{ getStationName(assignment.StationID) }}
                </span>
                <span
                  v-if="getStationAssignments(supplier.SupplierID).length > 3"
                  class="badge badge-light-warning fs-8"
                >
                  +{{ getStationAssignments(supplier.SupplierID).length - 3 }} more
                </span>
              </div>
              <div v-else class="text-muted fs-8 fst-italic">No station assignments</div>
            </div>

            <!-- Status Badge -->
            <div class="mt-auto">
              <span
                class="badge fs-7 fw-bold px-4 py-2 rounded-pill"
                :class="supplier.Status === 'Active' ? 'badge-light-success' : 'badge-light-danger'"
              >
                <i
                  class="ki-duotone fs-7 me-1"
                  :class="
                    supplier.Status === 'Active'
                      ? 'ki-check-circle text-success'
                      : 'ki-cross-circle text-danger'
                  "
                >
                  <span class="path1"></span><span class="path2"></span>
                </i>
                {{ supplier.Status }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Supplier Form Modal -->
    <div class="modal fade modal-fullscreen" id="supplierModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-5">
          <div class="d-flex justify-content-between align-items-center mb-5">
            <h3 class="fw-bold fs-2 mb-0">{{ editingId ? 'Edit Supplier' : 'New Supplier' }}</h3>
            <button type="button" class="btn btn-sm btn-light" data-bs-dismiss="modal">
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </button>
          </div>

          <div class="d-flex flex-column gap-4">
            <div class="row g-4">
              <div class="col-12">
                <label class="form-label fs-6 fw-bold text-gray-900">Supplier Name *</label>
                <input
                  v-model="form.Name"
                  placeholder="Enter supplier company name"
                  class="form-control form-control-lg bg-light rounded"
                />
              </div>

              <div class="col-md-6">
                <label class="form-label fs-6 fw-bold text-gray-900">Contact Person *</label>
                <input
                  v-model="form.ContactPerson"
                  placeholder="Primary contact name"
                  class="form-control form-control-lg bg-light rounded"
                />
              </div>

              <div class="col-md-6">
                <label class="form-label fs-6 fw-bold text-gray-900">Phone Number *</label>
                <input
                  v-model="form.Phone"
                  type="tel"
                  placeholder="+256 700 123 456"
                  class="form-control form-control-lg bg-light rounded"
                />
              </div>

              <div class="col-md-6">
                <label class="form-label fs-6 fw-bold text-gray-900">Email Address</label>
                <input
                  v-model="form.Email"
                  type="email"
                  placeholder="supplier@company.com"
                  class="form-control form-control-lg bg-light rounded"
                />
              </div>

              <div class="col-md-6">
                <label class="form-label fs-6 fw-bold text-gray-900">Tax ID (TIN)</label>
                <input
                  v-model="form.TaxIdentificationNumber"
                  placeholder="Enter TIN number"
                  class="form-control form-control-lg bg-light rounded"
                />
              </div>

              <div class="col-12">
                <label class="form-label fs-6 fw-bold text-gray-900">Address</label>
                <textarea
                  v-model="form.Address"
                  placeholder="Full business address"
                  rows="3"
                  class="form-control form-control-lg bg-light rounded"
                ></textarea>
              </div>

              <div class="col-md-6">
                <label class="form-label fs-6 fw-bold text-gray-900">Supplier Type *</label>
                <select v-model="form.IsGlobal" class="form-select form-select-lg bg-light rounded">
                  <option value="">Select type</option>
                  <option value="1">Global (Serves all stations)</option>
                  <option value="0">Station-Specific</option>
                </select>
              </div>

              <div class="col-md-6">
                <label class="form-label fs-6 fw-bold text-gray-900">Status *</label>
                <select v-model="form.Status" class="form-select form-select-lg bg-light rounded">
                  <option value="">Select status</option>
                  <option value="Active">Active</option>
                  <option value="Inactive">Inactive</option>
                </select>
              </div>
            </div>

            <div class="d-flex flex-column gap-3 pt-5">
              <button
                @click="handleSubmit"
                class="btn btn-primary btn-lg w-100"
                :data-kt-indicator="isSubmitting ? 'on' : 'off'"
              >
                <span class="indicator-label">
                  <i class="ki-duotone ki-check fs-2 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  {{ editingId ? 'Update Supplier' : 'Create Supplier' }}
                </span>
                <span class="indicator-progress">
                  Saving...
                  <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
                </span>
              </button>
              <button type="button" class="btn btn-light btn-lg w-100" data-bs-dismiss="modal">
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Station Assignment Modal -->
    <div class="modal fade modal-fullscreen" id="stationModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-5">
          <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
              <h3 class="fw-bold fs-2 mb-1">Station Assignments</h3>
              <p class="text-muted fs-6 mb-0">{{ selectedSupplier?.Name || 'Supplier' }}</p>
            </div>
            <button type="button" class="btn btn-sm btn-light" data-bs-dismiss="modal">
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </button>
          </div>

          <div
            v-if="selectedSupplier && selectedSupplier.IsGlobal === '1'"
            class="alert alert-primary"
          >
            <i class="ki-duotone ki-information-4 fs-2 text-primary me-2">
              <span class="path1"></span><span class="path2"></span><span class="path3"></span>
            </i>
            <strong>Global Supplier:</strong> This supplier automatically serves all stations and
            cannot have individual station assignments.
          </div>

          <div v-else class="d-flex flex-column gap-5">
            <!-- Quick Actions -->
            <div class="d-flex gap-3">
              <button class="btn btn-light-success btn-sm" @click="selectAllStations">
                <i class="ki-duotone ki-check-square fs-2 me-2">
                  <span class="path1"></span><span class="path2"></span><span class="path3"></span>
                </i>
                Select All
              </button>
              <button class="btn btn-light-warning btn-sm" @click="clearAllStations">
                <i class="ki-duotone ki-cross-square fs-2 me-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                Clear All
              </button>
            </div>

            <!-- Station List -->
            <div class="row g-4" style="max-height: 400px; overflow-y: auto">
              <div v-for="station in allStations" :key="station.StationID" class="col-12 col-md-6">
                <div
                  class="card border-2"
                  :class="
                    isStationAssigned(station.StationID)
                      ? 'border-success bg-light-success'
                      : 'border-light bg-light'
                  "
                >
                  <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center">
                      <div class="flex-grow-1">
                        <h5 class="fw-bold text-dark mb-1">{{ station.StationName }}</h5>
                        <p class="text-muted fs-7 mb-2">{{ station.Location }}</p>
                        <span
                          class="badge fs-8"
                          :class="
                            station.Status === 'Active'
                              ? 'badge-light-success'
                              : 'badge-light-danger'
                          "
                        >
                          {{ station.Status }}
                        </span>
                      </div>
                      <div class="form-check form-switch form-check-custom form-check-solid">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          :checked="isStationAssigned(station.StationID)"
                          @change="toggleStationAssignment(station.StationID)"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Save Button -->
            <div class="d-flex gap-3">
              <button
                class="btn btn-primary btn-lg flex-fill"
                @click="saveStationAssignments"
                :data-kt-indicator="isSavingAssignments ? 'on' : 'off'"
              >
                <span class="indicator-label">
                  <i class="ki-duotone ki-check fs-2 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Save Assignments
                </span>
                <span class="indicator-progress">
                  Saving...
                  <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
                </span>
              </button>
              <button type="button" class="btn btn-light btn-lg" data-bs-dismiss="modal">
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import Swal from 'sweetalert2'

// TrailBase API configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN =
  localStorage.getItem('jwt') ||
  'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJzdWIiOiJkMDc1QVZVSVNCcW9HN3dvZFV0MVZ3PT0iLCJpYXQiOjE3NTAyNDc4ODgsImV4cCI6MTc1MDI1MTQ4OCwiZW1haWwiOiJhZG1pbkBsb2NhbGhvc3QiLCJjc3JmX3Rva2VuIjoiOWdWQmpzU0MzN1NBTmVhU3pCelQifQ.i-Lj_KsB-TXZ1vgsu4CPEdICamdOznhKDh42Jx7oi4F29K5voeBER5bBycrnQ0uK7-G45F-18SibATxo_F3rBQ'

// State management
const suppliers = ref([])
const allStations = ref([])
const supplierStations = ref([])
const isLoading = ref(false)
const isSubmitting = ref(false)
const isSavingAssignments = ref(false)
const editingId = ref(null)
const selectedSupplier = ref(null)
const searchTerm = ref('')
const statusFilter = ref('All')
const typeFilter = ref('All')

// Form data with proper defaults
const form = ref({
  Name: '',
  ContactPerson: '',
  Email: '',
  Phone: '',
  Address: '',
  TaxIdentificationNumber: '',
  IsGlobal: '0',
  Status: 'Active',
})

// Modal instances
let supplierModal = null
let stationModal = null

// Station assignment state
const selectedStationIds = ref(new Set())

// Lifecycle
onMounted(async () => {
  try {
    await Promise.all([fetchSuppliers(), fetchStations(), fetchSupplierStations()])

    // Initialize Bootstrap modals safely
    setTimeout(() => {
      const supplierModalEl = document.getElementById('supplierModal')
      const stationModalEl = document.getElementById('stationModal')

      if (supplierModalEl && window.bootstrap) {
        supplierModal = new window.bootstrap.Modal(supplierModalEl)
      }
      if (stationModalEl && window.bootstrap) {
        stationModal = new window.bootstrap.Modal(stationModalEl)
      }
    }, 100)
  } catch (error) {
    console.error('Error during component initialization:', error)
  }
})

// API calls with proper error handling
const fetchSuppliers = async () => {
  isLoading.value = true
  try {
    const response = await fetch(`${API_BASE_URL}/Suppliers`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }

    const data = await response.json()
    suppliers.value = Array.isArray(data.records) ? data.records : []
  } catch (error) {
    console.error('Error fetching suppliers:', error)
    suppliers.value = []
    Swal.fire({
      icon: 'error',
      title: 'Error!',
      text: 'Failed to load suppliers. Please check your connection.',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    isLoading.value = false
  }
}

const fetchStations = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/Stations`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }

    const data = await response.json()
    allStations.value = Array.isArray(data.records) ? data.records : []
  } catch (error) {
    console.error('Error fetching stations:', error)
    allStations.value = []
  }
}

const fetchSupplierStations = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/SupplierStations`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }

    const data = await response.json()
    supplierStations.value = Array.isArray(data.records) ? data.records : []
  } catch (error) {
    console.error('Error fetching supplier stations:', error)
    supplierStations.value = []
  }
}

// CRUD operations with validation
const handleCreate = () => {
  editingId.value = null
  form.value = {
    Name: '',
    ContactPerson: '',
    Email: '',
    Phone: '',
    Address: '',
    TaxIdentificationNumber: '',
    IsGlobal: '0',
    Status: 'Active',
  }

  if (supplierModal) {
    supplierModal.show()
  }
}

const handleEdit = (supplier) => {
  if (!supplier || !supplier.SupplierID) {
    console.error('Invalid supplier data for editing')
    return
  }

  editingId.value = supplier.SupplierID
  form.value = {
    Name: supplier.Name || '',
    ContactPerson: supplier.ContactPerson || '',
    Email: supplier.Email || '',
    Phone: supplier.Phone || '',
    Address: supplier.Address || '',
    TaxIdentificationNumber: supplier.TaxIdentificationNumber || '',
    IsGlobal: supplier.IsGlobal || '0',
    Status: supplier.Status || 'Active',
  }

  if (supplierModal) {
    supplierModal.show()
  }
}

const handleSubmit = async () => {
  // Basic validation
  if (!form.value.Name || !form.value.Phone) {
    Swal.fire({
      icon: 'warning',
      title: 'Validation Error',
      text: 'Please fill in all required fields (Name and Phone)',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  isSubmitting.value = true

  const url = editingId.value
    ? `${API_BASE_URL}/Suppliers/${editingId.value}`
    : `${API_BASE_URL}/Suppliers`
  const method = editingId.value ? 'PATCH' : 'POST'

  try {
    const response = await fetch(url, {
      method,
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(form.value),
    })

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.message || `HTTP ${response.status}: ${response.statusText}`)
    }

    Swal.fire({
      icon: 'success',
      title: 'Success!',
      text: editingId.value ? 'Supplier updated successfully' : 'Supplier created successfully',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })

    if (supplierModal) {
      supplierModal.hide()
    }

    await fetchSuppliers()
  } catch (error) {
    console.error('Error saving supplier:', error)
    Swal.fire({
      icon: 'error',
      title: 'Error!',
      text: error.message || 'Failed to save supplier',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    isSubmitting.value = false
  }
}

const handleDelete = (supplierId) => {
  if (!supplierId) {
    console.error('Invalid supplier ID for deletion')
    return
  }

  Swal.fire({
    title: 'Delete Supplier?',
    text: 'This action cannot be undone. All station assignments will also be removed.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#6c757d',
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel',
  }).then(async (result) => {
    if (result.isConfirmed) {
      try {
        const response = await fetch(`${API_BASE_URL}/Suppliers/${supplierId}`, {
          method: 'DELETE',
          headers: {
            Authorization: `Bearer ${JWT_TOKEN}`,
          },
        })

        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`)
        }

        Swal.fire({
          icon: 'success',
          title: 'Deleted!',
          text: 'Supplier has been deleted successfully',
          toast: true,
          position: 'top-end',
          timer: 2000,
          showConfirmButton: false,
        })

        await Promise.all([fetchSuppliers(), fetchSupplierStations()])
      } catch (error) {
        console.error('Error deleting supplier:', error)
        Swal.fire({
          icon: 'error',
          title: 'Error!',
          text: 'Failed to delete supplier',
          confirmButtonColor: '#f1416c',
        })
      }
    }
  })
}

// Station assignment management
const handleManageStations = (supplier) => {
  if (!supplier || !supplier.SupplierID) {
    console.error('Invalid supplier data for station management')
    return
  }

  selectedSupplier.value = supplier
  const assignments = getStationAssignments(supplier.SupplierID)
  selectedStationIds.value = new Set(assignments.map((a) => a.StationID))

  if (stationModal) {
    stationModal.show()
  }
}

const isStationAssigned = (stationId) => {
  if (!stationId || !selectedStationIds.value) return false
  return selectedStationIds.value.has(stationId)
}

const toggleStationAssignment = (stationId) => {
  if (!stationId || !selectedStationIds.value) return

  if (selectedStationIds.value.has(stationId)) {
    selectedStationIds.value.delete(stationId)
  } else {
    selectedStationIds.value.add(stationId)
  }
}

const selectAllStations = () => {
  if (!allStations.value || !Array.isArray(allStations.value)) return
  selectedStationIds.value = new Set(allStations.value.map((s) => s.StationID))
}

const clearAllStations = () => {
  selectedStationIds.value = new Set()
}

const saveStationAssignments = async () => {
  if (!selectedSupplier.value || !selectedSupplier.value.SupplierID) {
    console.error('No supplier selected for station assignment')
    return
  }

  isSavingAssignments.value = true

  try {
    const supplierId = selectedSupplier.value.SupplierID
    const currentAssignments = getStationAssignments(supplierId)
    const currentStationIds = new Set(currentAssignments.map((a) => a.StationID))

    // Find stations to add and remove
    const toAdd = Array.from(selectedStationIds.value).filter((id) => !currentStationIds.has(id))
    const toRemove = Array.from(currentStationIds).filter((id) => !selectedStationIds.value.has(id))

    // Add new assignments
    for (const stationId of toAdd) {
      try {
        const response = await fetch(`${API_BASE_URL}/SupplierStations`, {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${JWT_TOKEN}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            SupplierID: supplierId,
            StationID: stationId,
          }),
        })

        if (!response.ok) {
          console.error(`Failed to add station ${stationId}:`, response.statusText)
        }
      } catch (error) {
        console.error(`Error adding station ${stationId}:`, error)
      }
    }

    // Remove old assignments
    for (const assignment of currentAssignments) {
      if (toRemove.includes(assignment.StationID)) {
        try {
          const response = await fetch(
            `${API_BASE_URL}/SupplierStations/${assignment.SupplierID}`,
            {
              method: 'DELETE',
              headers: {
                Authorization: `Bearer ${JWT_TOKEN}`,
              },
            },
          )

          if (!response.ok) {
            console.error(`Failed to remove station ${assignment.StationID}:`, response.statusText)
          }
        } catch (error) {
          console.error(`Error removing station ${assignment.StationID}:`, error)
        }
      }
    }

    Swal.fire({
      icon: 'success',
      title: 'Success!',
      text: 'Station assignments updated successfully',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })

    if (stationModal) {
      stationModal.hide()
    }

    await fetchSupplierStations()
  } catch (error) {
    console.error('Error saving station assignments:', error)
    Swal.fire({
      icon: 'error',
      title: 'Error!',
      text: 'Failed to save station assignments',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    isSavingAssignments.value = false
  }
}

// Helper functions with null checks
const getStationAssignments = (supplierId) => {
  if (!supplierId || !Array.isArray(supplierStations.value)) return []
  return supplierStations.value.filter((ss) => ss && ss.SupplierID === supplierId)
}

const getStationName = (stationId) => {
  if (!stationId || !Array.isArray(allStations.value)) return 'Unknown Station'
  const station = allStations.value.find((s) => s && s.StationID === stationId)
  return station ? station.StationName : 'Unknown Station'
}

// Computed properties with safe defaults
const filteredSuppliers = computed(() => {
  if (!Array.isArray(suppliers.value)) return []

  return suppliers.value.filter((supplier) => {
    if (!supplier) return false

    const searchValue = (searchTerm.value || '').toLowerCase()
    const matchesSearch =
      !searchValue ||
      (supplier.Name || '').toLowerCase().includes(searchValue) ||
      (supplier.ContactPerson || '').toLowerCase().includes(searchValue) ||
      (supplier.Phone || '').toLowerCase().includes(searchValue)

    const matchesStatus = statusFilter.value === 'All' || supplier.Status === statusFilter.value

    const matchesType =
      typeFilter.value === 'All' ||
      (typeFilter.value === 'Global' && supplier.IsGlobal === '1') ||
      (typeFilter.value === 'Local' && supplier.IsGlobal !== '1')

    return matchesSearch && matchesStatus && matchesType
  })
})

const supplierStats = computed(() => {
  if (!Array.isArray(suppliers.value)) {
    return { total: 0, active: 0, global: 0, local: 0 }
  }

  const total = suppliers.value.length
  const active = suppliers.value.filter((s) => s && s.Status === 'Active').length
  const global = suppliers.value.filter((s) => s && s.IsGlobal === '1').length
  const local = suppliers.value.filter((s) => s && s.IsGlobal !== '1').length

  return { total, active, global, local }
})
</script>

<style scoped>
.modal-content {
  border-radius: 1.5rem;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
}

.form-control,
.form-select {
  padding: 1rem 1.25rem;
  font-size: 1rem;
  border: 2px solid #e4e6ea;
  transition: all 0.3s ease;
}

.form-control:focus,
.form-select:focus {
  border-color: #009ef7;
  box-shadow: 0 0 0 0.2rem rgba(0, 158, 247, 0.25);
}

.form-label {
  margin-bottom: 0.5rem;
}

textarea {
  resize: none;
}

.badge {
  font-size: 0.75rem;
  padding: 0.5rem 0.75rem;
}

.spinner-border {
  width: 1.5rem;
  height: 1.5rem;
}

.card {
  transition: all 0.3s ease;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.form-check-input {
  width: 2.5rem;
  height: 1.25rem;
}

.alert {
  border: none;
  border-radius: 1rem;
}

@media (max-width: 768px) {
  .modal-content {
    margin: 1rem;
    border-radius: 1rem;
  }

  .btn-lg {
    padding: 0.875rem 1.5rem;
    font-size: 1rem;
  }
}
</style>

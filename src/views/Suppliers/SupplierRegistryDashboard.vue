<template>
  <div class="d-flex flex-column mh-100 p-5 p-md-10" style="background-color: #f5f5f5">
    <!-- Page Header - iOS Style -->
    <div class="d-flex flex-column flex-md-row align-items-center justify-content-between mb-7">
      <div class="mb-3 mb-md-0">
        <h1 class="fs-1 fw-bolder text-gray-900 mb-0">Suppliers</h1>
        <p class="fs-6 fw-semibold text-gray-600">Manage and track supplier metrics</p>
      </div>
      <button
        @click="toggleRegistrationForm"
        class="btn btn-lg w-100 w-md-auto"
        :class="
          showRegistrationForm
            ? 'btn-outline btn-outline-dashed btn-outline-primary btn-active-light-primary'
            : 'btn-primary'
        "
      >
        <i class="ki-duotone ki-plus fs-2">
          <span class="path1"></span>
          <span class="path2"></span>
        </i>
        {{ showRegistrationForm ? 'View Dashboard' : 'Add Supplier' }}
      </button>
    </div>

    <!-- Registration Form Card - iOS Style -->
    <div v-if="showRegistrationForm" class="card shadow-sm mb-5" style="border-radius: 12px">
      <div
        class="card-header border-0 pt-6"
        style="
          background-color: #ffffff;
          border-top-left-radius: 12px;
          border-top-right-radius: 12px;
        "
      >
        <h3 class="card-title align-items-start flex-column">
          <span class="card-label fw-bolder fs-3 mb-1 text-gray-900">New Supplier</span>
          <span class="text-muted mt-1 fw-semibold fs-7">Enter supplier details below</span>
        </h3>
      </div>
      <div
        class="card-body py-10 px-lg-10"
        style="
          background-color: #ffffff;
          border-bottom-left-radius: 12px;
          border-bottom-right-radius: 12px;
        "
      >
        <form @submit.prevent="submitSupplier" novalidate>
          <div class="row g-5 g-lg-8">
            <div class="col-12">
              <label class="required form-label fw-bold fs-6">Supplier Name</label>
              <input
                v-model="supplierForm.Name"
                type="text"
                class="form-control form-control-lg form-control-solid"
                :class="{ 'is-invalid border-danger': errors.Name }"
                placeholder="e.g., Kigrama Fuels Ltd"
                required
              />
              <div v-if="errors.Name" class="fv-plugins-message-container invalid-feedback">
                {{ errors.Name }}
              </div>
            </div>

            <div class="col-12 col-md-6">
              <label class="form-label fw-bold fs-6">Contact Person</label>
              <input
                v-model="supplierForm.ContactPerson"
                type="text"
                class="form-control form-control-lg form-control-solid"
                placeholder="e.g., John Doe"
              />
            </div>

            <div class="col-12 col-md-6">
              <label class="required form-label fw-bold fs-6">Phone Number</label>
              <input
                v-model="supplierForm.Phone"
                type="tel"
                class="form-control form-control-lg form-control-solid"
                :class="{ 'is-invalid border-danger': errors.Phone }"
                placeholder="+256 7XX XXX XXX"
                required
              />
              <div v-if="errors.Phone" class="fv-plugins-message-container invalid-feedback">
                {{ errors.Phone }}
              </div>
            </div>

            <div class="col-12 col-md-6">
              <label class="form-label fw-bold fs-6">Email Address</label>
              <input
                v-model="supplierForm.Email"
                type="email"
                class="form-control form-control-lg form-control-solid"
                :class="{ 'is-invalid border-danger': errors.Email }"
                placeholder="supplier@example.com"
              />
              <div v-if="errors.Email" class="fv-plugins-message-container invalid-feedback">
                {{ errors.Email }}
              </div>
            </div>
            <div class="col-12 col-md-6">
              <label class="form-label fw-bold fs-6">Tax ID Number</label>
              <input
                v-model="supplierForm.TaxIdentificationNumber"
                type="text"
                class="form-control form-control-lg form-control-solid"
                placeholder="e.g., 100XXXXXXX"
              />
            </div>

            <div class="col-12">
              <label class="form-label fw-bold fs-6">Address</label>
              <textarea
                v-model="supplierForm.Address"
                rows="3"
                class="form-control form-control-lg form-control-solid"
                placeholder="Full business address"
              ></textarea>
            </div>

            <div class="col-12">
              <label class="form-label fw-bold fs-6 mb-3">Supplier Type</label>
              <div class="d-flex flex-wrap gap-5">
                <div class="form-check form-check-custom form-check-solid">
                  <input
                    class="form-check-input"
                    type="radio"
                    v-model="supplierForm.IsGlobal"
                    value="0"
                    id="localSupplierRadio"
                  />
                  <label class="form-check-label fs-6 text-gray-800" for="localSupplierRadio">
                    Local Supplier
                  </label>
                </div>
                <div class="form-check form-check-custom form-check-solid">
                  <input
                    class="form-check-input"
                    type="radio"
                    v-model="supplierForm.IsGlobal"
                    value="1"
                    id="globalSupplierRadio"
                  />
                  <label class="form-check-label fs-6 text-gray-800" for="globalSupplierRadio">
                    Global Supplier
                  </label>
                </div>
              </div>
            </div>
          </div>

          <div class="d-flex flex-column flex-sm-row justify-content-end gap-3 mt-10">
            <button type="button" @click="resetForm" class="btn btn-light btn-lg w-100 w-sm-auto">
              Reset
            </button>
            <button
              type="submit"
              class="btn btn-success btn-lg w-100 w-sm-auto"
              :disabled="loading"
              data-kt-indicator="on"
            >
              <span class="indicator-label">
                <i class="ki-duotone ki-check fs-3 me-1">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Register Supplier
              </span>
              <span class="indicator-progress">
                Please wait...
                <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
              </span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Dashboard View - iOS Style -->
    <div v-else>
      <!-- KPI Cards Row - iOS Style -->
      <div class="row g-5 g-xl-8 mb-5 mb-xl-8">
        <div class="col-6 col-md-3">
          <div
            class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-100"
            style="background-color: #f9f9f9; border-radius: 12px"
          >
            <div class="card-body d-flex flex-column justify-content-center text-center py-6">
              <i class="ki-duotone ki-people fs-3x text-primary mb-3">
                <span class="path1"></span><span class="path2"></span><span class="path3"></span
                ><span class="path4"></span><span class="path5"></span>
              </i>
              <div class="fs-1 fw-bolder text-gray-900">{{ kpiData.totalSuppliers }}</div>
              <div class="fs-7 fw-semibold text-gray-600">Total Suppliers</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div
            class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-100"
            style="background-color: #f9f9f9; border-radius: 12px"
          >
            <div class="card-body d-flex flex-column justify-content-center text-center py-6">
              <i class="ki-duotone ki-shield-tick fs-3x text-success mb-3">
                <span class="path1"></span><span class="path2"></span>
              </i>
              <div class="fs-1 fw-bolder text-gray-900">{{ kpiData.activeSuppliers }}</div>
              <div class="fs-7 fw-semibold text-gray-600">Active</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div
            class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-100"
            style="background-color: #f9f9f9; border-radius: 12px"
          >
            <div class="card-body d-flex flex-column justify-content-center text-center py-6">
              <i class="ki-duotone ki-delivery fs-3x text-warning mb-3">
                <span class="path1"></span><span class="path2"></span><span class="path3"></span
                ><span class="path4"></span><span class="path5"></span>
              </i>
              <div class="fs-1 fw-bolder text-gray-900">{{ kpiData.globalSuppliers }}</div>
              <div class="fs-7 fw-semibold text-gray-600">Global</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div
            class="card card-flush bgi-no-repeat bgi-size-contain bgi-position-x-end h-100"
            style="background-color: #f9f9f9; border-radius: 12px"
          >
            <div class="card-body d-flex flex-column justify-content-center text-center py-6">
              <i class="ki-duotone ki-calendar-tick fs-3x text-info mb-3">
                <span class="path1"></span><span class="path2"></span><span class="path3"></span
                ><span class="path4"></span><span class="path5"></span><span class="path6"></span>
              </i>
              <div class="fs-1 fw-bolder text-gray-900">{{ kpiData.newThisMonth }}</div>
              <div class="fs-7 fw-semibold text-gray-600">New This Month</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Charts and AI Risk - iOS Style -->
      <div class="row g-5 g-xl-8 mb-5 mb-xl-8">
        <div class="col-12 col-lg-7">
          <div class="card shadow-sm h-100" style="border-radius: 12px">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title align-items-start flex-column">
                <span class="card-label fw-bolder fs-3 mb-1 text-gray-900">Supplier Overview</span>
              </h3>
            </div>
            <div class="card-body">
              <div class="row g-5">
                <div class="col-12 col-md-6">
                  <canvas ref="statusChartEl" style="height: 250px"></canvas>
                </div>
                <div class="col-12 col-md-6">
                  <canvas ref="trendChartEl" style="height: 250px"></canvas>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-12 col-lg-5">
          <div class="card shadow-sm h-100" style="border-radius: 12px">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title align-items-start flex-column">
                <span class="card-label fw-bolder fs-3 mb-1 text-gray-900">AI Risk Assessment</span>
                <span class="text-muted mt-1 fw-semibold fs-7">Simulated supplier risk levels</span>
              </h3>
            </div>
            <div class="card-body d-flex flex-column justify-content-around">
              <div class="d-flex align-items-center bg-light-success rounded p-5 mb-5">
                <i class="ki-duotone ki-shield-tick fs-3x text-success me-5"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
                <div class="flex-grow-1 me-2">
                  <a href="#" class="fw-bold text-gray-800 text-hover-primary fs-6">Low Risk</a>
                  <span class="text-muted fw-semibold d-block">{{ aiData.lowRisk }} Suppliers</span>
                </div>
                <span class="fw-bold text-success py-1 fs-3"
                  >{{ calculatePercentage(aiData.lowRisk, kpiData.totalSuppliers) }}%</span
                >
              </div>
              <div class="d-flex align-items-center bg-light-warning rounded p-5 mb-5">
                <i class="ki-duotone ki-shield-alert fs-3x text-warning me-5"
                  ><span class="path1"></span><span class="path2"></span><span class="path3"></span
                ></i>
                <div class="flex-grow-1 me-2">
                  <a href="#" class="fw-bold text-gray-800 text-hover-primary fs-6">Medium Risk</a>
                  <span class="text-muted fw-semibold d-block"
                    >{{ aiData.mediumRisk }} Suppliers</span
                  >
                </div>
                <span class="fw-bold text-warning py-1 fs-3"
                  >{{ calculatePercentage(aiData.mediumRisk, kpiData.totalSuppliers) }}%</span
                >
              </div>
              <div class="d-flex align-items-center bg-light-danger rounded p-5">
                <i class="ki-duotone ki-shield-cross fs-3x text-danger me-5"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
                <div class="flex-grow-1 me-2">
                  <a href="#" class="fw-bold text-gray-800 text-hover-primary fs-6">High Risk</a>
                  <span class="text-muted fw-semibold d-block"
                    >{{ aiData.highRisk }} Suppliers</span
                  >
                </div>
                <span class="fw-bold text-danger py-1 fs-3"
                  >{{ calculatePercentage(aiData.highRisk, kpiData.totalSuppliers) }}%</span
                >
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Suppliers List - iOS Style -->
      <div class="card shadow-sm" style="border-radius: 12px">
        <div class="card-header border-0 pt-6">
          <h3 class="card-title align-items-start flex-column">
            <span class="card-label fw-bolder fs-3 mb-1 text-gray-900">Recent Suppliers</span>
            <span class="text-muted mt-1 fw-semibold fs-7"
              >Top {{ filteredSuppliers.length }} recently added or updated</span
            >
          </h3>
          <div class="card-toolbar">
            <div class="d-flex align-items-center position-relative my-1">
              <i class="ki-duotone ki-magnifier fs-3 position-absolute ms-4">
                <span class="path1"></span><span class="path2"></span>
              </i>
              <input
                v-model="searchTerm"
                type="text"
                class="form-control form-control-solid w-200px ps-12"
                placeholder="Search Suppliers"
              />
            </div>
          </div>
        </div>
        <div class="card-body py-3">
          <div
            v-if="loadingSuppliers"
            class="d-flex justify-content-center align-items-center min-h-200px"
          >
            <div class="spinner-border text-primary" role="status">
              <span class="visually-hidden">Loading...</span>
            </div>
          </div>
          <div
            v-else-if="filteredSuppliers.length === 0"
            class="d-flex flex-column align-items-center justify-content-center min-h-200px text-center"
          >
            <i class="ki-duotone ki-abstract-14 fs-5x text-gray-400 mb-3">
              <span class="path1"></span><span class="path2"></span>
            </i>
            <p class="fs-4 text-gray-600 fw-semibold">No suppliers found.</p>
            <p class="fs-6 text-gray-500">Try adjusting your search or add a new supplier.</p>
          </div>
          <div v-else class="list-group list-group-flush">
            <div
              v-for="supplier in filteredSuppliers"
              :key="supplier.SupplierID"
              class="list-group-item d-flex flex-column flex-sm-row align-items-sm-center justify-content-between py-5 px-0"
            >
              <div class="d-flex align-items-center mb-3 mb-sm-0">
                <div class="symbol symbol-50px me-4">
                  <div class="symbol-label fs-2 fw-bold" :class="getSupplierBgColor(supplier.Name)">
                    {{ getInitials(supplier.Name) }}
                  </div>
                </div>
                <div class="d-flex justify-content-start flex-column">
                  <a
                    href="#"
                    @click.prevent="openDetailsModal(supplier)"
                    class="text-gray-800 fw-bold text-hover-primary fs-6"
                    >{{ supplier.Name }}</a
                  >
                  <span class="text-muted fw-semibold text-muted d-block fs-7">{{
                    supplier.ContactPerson || 'No contact person'
                  }}</span>
                </div>
              </div>
              <div class="d-flex flex-column align-items-sm-end">
                <span
                  class="badge fs-7 mb-1"
                  :class="{
                    'badge-light-success': supplier.Status === 'Active',
                    'badge-light-danger': supplier.Status === 'Inactive',
                    'badge-light-warning': supplier.Status === 'Pending',
                  }"
                  >{{ supplier.Status }}</span
                >
                <span class="text-muted fs-7">{{
                  supplier.IsGlobal === '1' ? 'Global' : 'Local'
                }}</span>
              </div>
              <button
                @click="openDetailsModal(supplier)"
                class="btn btn-sm btn-light-primary mt-3 mt-sm-0 ms-sm-5"
              >
                View
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Supplier Details Modal - iOS Style -->
    <div v-if="showDetailsModal" class="modal-backdrop fade show"></div>
    <div
      v-if="showDetailsModal"
      @click.self="closeDetailsModal"
      class="modal fade show"
      style="display: block"
      tabindex="-1"
      aria-modal="true"
      role="dialog"
    >
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div v-if="selectedSupplier" class="modal-content" style="border-radius: 12px">
          <div class="modal-header border-0 pt-7 pb-5 px-7">
            <h3 class="modal-title fw-bolder fs-3 text-gray-900">Supplier Information</h3>
            <div
              @click="closeDetailsModal"
              class="btn btn-icon btn-sm btn-active-light-primary ms-2"
              aria-label="Close"
            >
              <i class="ki-duotone ki-cross fs-1"
                ><span class="path1"></span><span class="path2"></span
              ></i>
            </div>
          </div>
          <div class="modal-body px-7 py-5">
            <div class="d-flex align-items-center mb-7">
              <div class="symbol symbol-75px symbol-circle me-5">
                <div
                  class="symbol-label fs-1 fw-bold"
                  :class="getSupplierBgColor(selectedSupplier.Name)"
                >
                  {{ getInitials(selectedSupplier.Name) }}
                </div>
              </div>
              <div class="flex-grow-1">
                <h2 class="fw-bolder text-gray-900 mb-1">{{ selectedSupplier.Name }}</h2>
                <span class="text-muted fw-semibold fs-6">{{
                  selectedSupplier.ContactPerson || 'N/A'
                }}</span>
              </div>
            </div>

            <div class="d-flex flex-wrap justify-content-start gap-3 mb-7">
              <span
                class="badge badge-lg fs-7"
                :class="{
                  'badge-light-success': selectedSupplier.Status === 'Active',
                  'badge-light-danger': selectedSupplier.Status === 'Inactive',
                  'badge-light-warning': selectedSupplier.Status === 'Pending',
                }"
              >
                <i
                  class="ki-duotone ki-abstract-39 fs-5 me-1"
                  :class="{
                    'text-success': selectedSupplier.Status === 'Active',
                    'text-danger': selectedSupplier.Status === 'Inactive',
                    'text-warning': selectedSupplier.Status === 'Pending',
                  }"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
                {{ selectedSupplier.Status }}
              </span>
              <span
                class="badge badge-lg fs-7"
                :class="
                  selectedSupplier.IsGlobal === '1' ? 'badge-light-info' : 'badge-light-primary'
                "
              >
                <i
                  class="ki-duotone ki-delivery fs-5 me-1"
                  :class="selectedSupplier.IsGlobal === '1' ? 'text-info' : 'text-primary'"
                  ><span class="path1"></span><span class="path2"></span><span class="path3"></span
                  ><span class="path4"></span><span class="path5"></span
                ></i>
                {{ selectedSupplier.IsGlobal === '1' ? 'Global Supplier' : 'Local Supplier' }}
              </span>
            </div>

            <div class="separator separator-dashed mb-7"></div>

            <div class="row g-5 mb-3">
              <div class="col-md-6">
                <div class="fw-semibold text-gray-500 fs-7">Phone Number:</div>
                <div class="fw-bold text-gray-800 fs-6">{{ selectedSupplier.Phone }}</div>
              </div>
              <div class="col-md-6">
                <div class="fw-semibold text-gray-500 fs-7">Email Address:</div>
                <div class="fw-bold text-gray-800 fs-6">{{ selectedSupplier.Email || 'N/A' }}</div>
              </div>
            </div>
            <div class="row g-5 mb-7">
              <div class="col-md-6">
                <div class="fw-semibold text-gray-500 fs-7">Address:</div>
                <div class="fw-bold text-gray-800 fs-6">
                  {{ selectedSupplier.Address || 'N/A' }}
                </div>
              </div>
              <div class="col-md-6">
                <div class="fw-semibold text-gray-500 fs-7">Tax ID:</div>
                <div class="fw-bold text-gray-800 fs-6">
                  {{ selectedSupplier.TaxIdentificationNumber || 'N/A' }}
                </div>
              </div>
            </div>

            <div class="separator separator-dashed mb-7"></div>

            <div class="d-flex flex-stack">
              <div class="fw-semibold text-gray-500 fs-7">Date Registered:</div>
              <div class="fw-bold text-gray-800 fs-6">
                {{ formatDisplayDate(selectedSupplier.CreatedAt) }}
              </div>
            </div>
          </div>
          <div class="modal-footer flex-center border-0 pt-0 pb-7 px-7">
            <button @click="closeDetailsModal" type="button" class="btn btn-primary w-100">
              Done
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'
// Chart.js is assumed globally available

const showRegistrationForm = ref(false)
const loading = ref(false)
const loadingSuppliers = ref(false)
const searchTerm = ref('')
const suppliers = ref([])
const kpiData = ref({
  totalSuppliers: 0,
  activeSuppliers: 0,
  globalSuppliers: 0,
  newThisMonth: 0,
})
const aiData = ref({
  lowRisk: 0,
  mediumRisk: 0,
  highRisk: 0,
})
const errors = ref({})
const supplierForm = ref({
  Name: '',
  ContactPerson: '',
  Email: '',
  Phone: '',
  Address: '',
  TaxIdentificationNumber: '',
  IsGlobal: '0',
  Status: 'Active',
})

const showDetailsModal = ref(false)
const selectedSupplier = ref(null)

const statusChartEl = ref(null)
const trendChartEl = ref(null)
let statusChartInstance = null
let trendChartInstance = null

const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN =
  localStorage.getItem('jwt') ||
  'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJzdWIiOiJkMDc1QVZVSVNCcW9HN3dvZFV0MVZ3PT0iLCJpYXQiOjE3NTAyNDc4ODgsImV4cCI6MTc1MDI1MTQ4OCwiZW1haWwiOiJhZG1pbkBsb2NhbGhvc3QiLCJjc3JmX3Rva2VuIjoiOWdWQmpzU0MzN1NBTmVhU3pCelQifQ.i-Lj_KsB-TXZ1vgsu4CPEdICamdOznhKDh42Jx7oi4F29K5voeBER5bBycrnQ0uK7-G45F-18SibATxo_F3rBQ'

const filteredSuppliers = computed(() => {
  if (!searchTerm.value) return suppliers.value.slice(0, 6) // Show top 6 for mobile-friendly list
  return suppliers.value
    .filter(
      (supplier) =>
        supplier.Name.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
        (supplier.ContactPerson &&
          supplier.ContactPerson.toLowerCase().includes(searchTerm.value.toLowerCase())),
    )
    .slice(0, 6)
})

const getInitials = (name) => {
  if (!name || typeof name !== 'string') return 'NA'
  return name
    .split(' ')
    .map((n) => n[0])
    .join('')
    .substring(0, 2)
    .toUpperCase()
}

const supplierColors = ['bg-primary', 'bg-success', 'bg-info', 'bg-warning', 'bg-danger', 'bg-dark']
const getSupplierBgColor = (name) => {
  if (!name) return 'bg-secondary text-inverse-secondary'
  let hash = 0
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash)
  }
  const index = Math.abs(hash % supplierColors.length)
  return `${supplierColors[index]} text-inverse-${supplierColors[index].replace('bg-', '')}`
}

const formatDisplayDate = (dateString) => {
  if (!dateString) return 'N/A'
  try {
    return new Date(dateString).toLocaleDateString('en-GB', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
    })
  } catch (e) {
    return dateString
  }
}

const calculatePercentage = (value, total) => {
  if (total === 0) return 0
  return ((value / total) * 100).toFixed(0)
}

const openDetailsModal = (supplier) => {
  selectedSupplier.value = supplier
  showDetailsModal.value = true
  document.body.classList.add('modal-open') // Metronic class for backdrop
}

const closeDetailsModal = () => {
  showDetailsModal.value = false
  document.body.classList.remove('modal-open')
  setTimeout(() => {
    selectedSupplier.value = null
  }, 300)
}

const toggleRegistrationForm = () => {
  showRegistrationForm.value = !showRegistrationForm.value
  if (!showRegistrationForm.value) {
    resetForm()
    nextTick(() => {
      if (suppliers.value.length > 0) {
        initializeCharts()
      }
    })
  } else {
    if (statusChartInstance) statusChartInstance.destroy()
    if (trendChartInstance) trendChartInstance.destroy()
    statusChartInstance = null
    trendChartInstance = null
  }
}

const resetForm = () => {
  supplierForm.value = {
    Name: '',
    ContactPerson: '',
    Email: '',
    Phone: '',
    Address: '',
    TaxIdentificationNumber: '',
    IsGlobal: '0',
    Status: 'Active',
  }
  errors.value = {}
}

const validateForm = () => {
  errors.value = {}
  if (!supplierForm.value.Name.trim()) errors.value.Name = 'Supplier name is required'
  if (!supplierForm.value.Phone.trim()) errors.value.Phone = 'Phone number is required'
  else if (!/^\+?[0-9\s-()]{7,15}$/.test(supplierForm.value.Phone.trim()))
    errors.value.Phone = 'Valid phone number required'
  if (supplierForm.value.Email && !/\S+@\S+\.\S+/.test(supplierForm.value.Email))
    errors.value.Email = 'Valid email address required'
  return Object.keys(errors.value).length === 0
}

const submitSupplier = async () => {
  if (!validateForm()) return
  loading.value = true
  document.querySelector('[data-kt-indicator="on"]')?.setAttribute('data-kt-indicator', 'on')

  try {
    const response = await fetch(`${API_BASE_URL}/Suppliers`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${JWT_TOKEN}` },
      body: JSON.stringify({
        ...supplierForm.value,
        CreatedAt: new Date().toISOString(),
        UpdatedAt: new Date().toISOString(),
      }),
    })
    if (response.ok) {
      Swal.fire({
        title: 'Success!',
        text: 'Supplier registered.',
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
      resetForm()
      showRegistrationForm.value = false
      await loadSuppliers()
    } else {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.message || `Registration failed. Status: ${response.status}`)
    }
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: error.message || 'Unexpected error.',
      icon: 'error',
      confirmButtonColor: '#D9214E',
    })
  } finally {
    loading.value = false
    document.querySelector('[data-kt-indicator="on"]')?.setAttribute('data-kt-indicator', 'off')
  }
}

const loadSuppliers = async () => {
  loadingSuppliers.value = true
  try {
    const response = await fetch(`${API_BASE_URL}/Suppliers?sort=-CreatedAt`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (response.ok) {
      const data = await response.json()
      suppliers.value = data.records || []
      kpiData.value = {
        totalSuppliers: suppliers.value.length,
        activeSuppliers: suppliers.value.filter((s) => s.Status === 'Active').length,
        globalSuppliers: suppliers.value.filter((s) => String(s.IsGlobal) === '1').length,
        newThisMonth: suppliers.value.filter((s) => {
          if (!s.CreatedAt) return false
          const created = new Date(s.CreatedAt)
          const now = new Date()
          return (
            created.getMonth() === now.getMonth() && created.getFullYear() === now.getFullYear()
          )
        }).length,
      }
      simulateAIRiskAssessment()
      if (!showRegistrationForm.value) {
        nextTick(() => {
          initializeCharts()
        })
      }
    } else {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.message || `Failed to load suppliers. Status: ${response.status}`)
    }
  } catch (error) {
    Swal.fire({
      title: 'Load Error!',
      text: error.message || 'Failed to load data.',
      icon: 'error',
      confirmButtonColor: '#D9214E',
    })
    suppliers.value = []
  } finally {
    loadingSuppliers.value = false
  }
}

const simulateAIRiskAssessment = () => {
  const riskFactors = suppliers.value.map((s) => {
    let score = 0
    if (!(s.Email && s.Email.includes('@'))) score += 25
    if (!(s.TaxIdentificationNumber && s.TaxIdentificationNumber.length > 0)) score += 30
    if (s.Status !== 'Active') score += 40
    if (String(s.IsGlobal) === '1') score += 5
    return score
  })
  aiData.value = {
    lowRisk: riskFactors.filter((s) => s <= 30).length,
    mediumRisk: riskFactors.filter((s) => s > 30 && s <= 60).length,
    highRisk: riskFactors.filter((s) => s > 60).length,
  }
}

const initializeCharts = () => {
  if (!statusChartEl.value || !trendChartEl.value || typeof Chart === 'undefined') return
  if (statusChartInstance) statusChartInstance.destroy()
  if (trendChartInstance) trendChartInstance.destroy()

  const statusData = {
    labels: ['Active', 'Inactive', 'Pending'],
    datasets: [
      {
        data: [
          suppliers.value.filter((s) => s.Status === 'Active').length,
          suppliers.value.filter((s) => s.Status === 'Inactive').length,
          suppliers.value.filter((s) => s.Status === 'Pending').length,
        ],
        backgroundColor: ['#3E97FF', '#F1416C', '#FFC700'], // Bright iOS-like colors
        borderWidth: 0,
      },
    ],
  }
  statusChartInstance = new Chart(statusChartEl.value, {
    type: 'doughnut',
    data: statusData,
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '70%',
      plugins: { legend: { display: false } },
    },
  })

  const trendDataRaw = Array.from({ length: 6 }, (_, i) => {
    const d = new Date()
    d.setMonth(d.getMonth() - (5 - i))
    return {
      month: d.toLocaleDateString('en-US', { month: 'short' }),
      count: suppliers.value.filter((s) => {
        if (!s.CreatedAt) return false
        const c = new Date(s.CreatedAt)
        return c.getMonth() === d.getMonth() && c.getFullYear() === d.getFullYear()
      }).length,
    }
  })
  trendChartInstance = new Chart(trendChartEl.value, {
    type: 'line',
    data: {
      labels: trendDataRaw.map((m) => m.month),
      datasets: [
        {
          label: 'New Suppliers',
          data: trendDataRaw.map((m) => m.count),
          borderColor: '#3E97FF',
          backgroundColor: 'rgba(62, 151, 255, 0.1)',
          tension: 0.4,
          fill: true,
          pointRadius: 4,
          pointBackgroundColor: '#3E97FF',
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, ticks: { stepSize: 1, precision: 0 } },
        x: { grid: { display: false } },
      },
    },
  })
}

onMounted(async () => {
  await loadSuppliers()
})
</script>

<style scoped>
/* Minimal custom CSS, primarily leveraging Metronic utilities */
.modal-open {
  /* Ensure Metronic's modal open class is effective */
  overflow: hidden;
  padding-right: 0px !important; /* Override Metronic's default padding if scrollbar appears */
}
.form-control-solid {
  background-color: #f5f7fa; /* iOS-like light grey input */
  border-color: #f5f7fa;
  color: #5e6278;
  font-weight: 500;
}
.form-control-solid:focus {
  background-color: #ffffff;
  border-color: #3e97ff; /* Bright blue focus */
  box-shadow: none;
}
.is-invalid.form-control-solid {
  border-color: #d9214e !important; /* Bright red for errors */
}
.btn-primary {
  background-color: #3e97ff; /* Bright blue for primary actions */
  border-color: #3e97ff;
}
.btn-primary:hover,
.btn-primary:focus,
.btn-primary:active {
  background-color: #2483ff;
  border-color: #2483ff;
}
.btn-success {
  background-color: #4caf50; /* Bright green for success */
  border-color: #4caf50;
}
.btn-success:hover,
.btn-success:focus,
.btn-success:active {
  background-color: #43a047;
  border-color: #43a047;
}

/* iOS-like card styling */
.card {
  border: none; /* Remove default borders for a cleaner iOS look */
}

/* iOS-like list items */
.list-group-item {
  border: none; /* Remove default borders */
  border-bottom: 1px solid #e5e5ea; /* Subtle iOS-like separator */
}
.list-group-item:last-child {
  border-bottom: none;
}

/* Ensure bright and shouting colors for KPI icons and text if not covered by Metronic */
.text-primary {
  color: #3e97ff !important;
}
.text-success {
  color: #4caf50 !important;
}
.text-warning {
  color: #ff9f0a !important;
} /* Brighter warning */
.text-info {
  color: #5ac8fa !important;
} /* Brighter info */
.text-danger {
  color: #d9214e !important;
} /* Brighter danger */

.bg-primary {
  background-color: #3e97ff !important;
}
.text-inverse-primary {
  color: #ffffff !important;
}
.bg-success {
  background-color: #4caf50 !important;
}
.text-inverse-success {
  color: #ffffff !important;
}
.bg-info {
  background-color: #5ac8fa !important;
}
.text-inverse-info {
  color: #ffffff !important;
}
.bg-warning {
  background-color: #ff9f0a !important;
}
.text-inverse-warning {
  color: #ffffff !important;
}
.bg-danger {
  background-color: #d9214e !important;
}
.text-inverse-danger {
  color: #ffffff !important;
}
.bg-dark {
  background-color: #1c1c1e !important;
} /* iOS dark mode like color */
.text-inverse-dark {
  color: #ffffff !important;
}

/* Specific for mobile view to enhance iOS feel */
@media (max-width: 767.98px) {
  .mh-100 {
    padding: 1rem !important; /* Less padding on mobile */
  }
  .fs-1 {
    font-size: 1.75rem !important;
  } /* Slightly smaller main titles on mobile */
  .card-body {
    padding: 1rem;
  }
  .modal-dialog {
    margin: 0.5rem;
  } /* Full width modals on mobile */
  .modal-content {
    border-radius: 10px;
  } /* Consistent border radius */
}
</style>

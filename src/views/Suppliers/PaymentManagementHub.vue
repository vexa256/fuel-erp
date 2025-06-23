<template>
  <div class="d-flex flex-column gap-5">
    <!-- Header -->
    <div class="card card-flush border-0 bg-light-primary">
      <div class="card-header pt-8 pb-3">
        <div class="d-flex align-items-center justify-content-between w-100">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px bg-white">
              <i class="ki-duotone ki-dollar fs-2x text-primary">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
            </div>
            <div>
              <h1 class="fw-bold text-gray-900 mb-1">Supplier Payments</h1>
              <span class="text-gray-600 fs-6"
                >Manage and track all supplier payment transactions</span
              >
            </div>
          </div>
          <button
            @click="showCreateForm = !showCreateForm"
            class="btn btn-lg"
            :class="showCreateForm ? 'btn-light-danger' : 'btn-light-success'"
          >
            <i class="ki-duotone fs-2" :class="showCreateForm ? 'ki-cross' : 'ki-plus'">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            {{ showCreateForm ? 'Cancel' : 'New Payment' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Payment Statistics -->
    <div class="row g-5">
      <!-- Today's Payments -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-success h-100">
          <div class="card-body p-5 text-center">
            <div class="symbol symbol-40px mx-auto mb-3">
              <i class="ki-duotone ki-calendar-tick fs-1 text-success">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div class="fs-6 fw-semibold text-gray-600 mb-1">Today</div>
            <div class="fs-2x fw-bold text-success">{{ paymentStats.todayCount }}</div>
            <div class="fs-7 text-gray-500">Payments</div>
          </div>
        </div>
      </div>

      <!-- Total Amount -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-primary h-100">
          <div class="card-body p-5 text-center">
            <div class="symbol symbol-40px mx-auto mb-3">
              <i class="ki-duotone ki-wallet fs-1 text-primary">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div class="fs-6 fw-semibold text-gray-600 mb-1">Total</div>
            <div class="fs-2x fw-bold text-primary">
              {{ formatCurrency(paymentStats.todayAmount) }}
            </div>
            <div class="fs-7 text-gray-500">UGX</div>
          </div>
        </div>
      </div>

      <!-- Pending -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-warning h-100">
          <div class="card-body p-5 text-center">
            <div class="symbol symbol-40px mx-auto mb-3">
              <i class="ki-duotone ki-time fs-1 text-warning">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div class="fs-6 fw-semibold text-gray-600 mb-1">Pending</div>
            <div class="fs-2x fw-bold text-warning">{{ paymentStats.pendingCount }}</div>
            <div class="fs-7 text-gray-500">Payments</div>
          </div>
        </div>
      </div>

      <!-- Success Rate -->
      <div class="col-6 col-lg-3">
        <div class="card card-flush bg-light-info h-100">
          <div class="card-body p-5 text-center">
            <div class="symbol symbol-40px mx-auto mb-3">
              <i class="ki-duotone ki-chart-line fs-1 text-info">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
            </div>
            <div class="fs-6 fw-semibold text-gray-600 mb-1">Success</div>
            <div class="fs-2x fw-bold text-info">{{ paymentStats.successRate }}%</div>
            <div class="fs-7 text-gray-500">Rate</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Payment Analytics Chart -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold text-gray-900">
          <i class="ki-duotone ki-chart-line fs-2 text-primary me-2">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          Payment Trends (Last 7 Days)
        </h3>
      </div>
      <div class="card-body">
        <div class="row g-5">
          <div class="col-12 col-lg-8">
            <div class="d-flex flex-column h-300px">
              <canvas ref="paymentsChart" style="height: 250px"></canvas>
            </div>
          </div>
          <div class="col-12 col-lg-4">
            <div class="d-flex flex-column gap-5">
              <div class="d-flex align-items-center justify-content-between">
                <span class="fw-bold text-gray-700">Bank Transfer</span>
                <span class="badge badge-light-primary fs-6">{{ methodStats.bankTransfer }}%</span>
              </div>
              <div class="d-flex align-items-center justify-content-between">
                <span class="fw-bold text-gray-700">Cash</span>
                <span class="badge badge-light-success fs-6">{{ methodStats.cash }}%</span>
              </div>
              <div class="d-flex align-items-center justify-content-between">
                <span class="fw-bold text-gray-700">Mobile Money</span>
                <span class="badge badge-light-warning fs-6">{{ methodStats.mobileMoney }}%</span>
              </div>
              <div class="d-flex align-items-center justify-content-between">
                <span class="fw-bold text-gray-700">Check</span>
                <span class="badge badge-light-info fs-6">{{ methodStats.check }}%</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Create Payment Form -->
    <div v-if="showCreateForm" class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold text-gray-900">
          <i class="ki-duotone ki-plus fs-2 text-success me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Create New Payment
        </h3>
      </div>
      <div class="card-body p-7">
        <div class="row g-5">
          <!-- Supplier Selection -->
          <div class="col-12 col-lg-6">
            <label class="required form-label fw-bold text-gray-800 fs-5">Supplier</label>
            <select
              v-model="paymentForm.SupplierID"
              class="form-select form-select-lg"
              :class="{ 'is-invalid': errors.SupplierID }"
              :disabled="loadingSuppliers"
            >
              <option value="">{{ loadingSuppliers ? 'Loading...' : 'Choose supplier...' }}</option>
              <option
                v-for="supplier in suppliers"
                :key="supplier.SupplierID"
                :value="supplier.SupplierID"
              >
                {{ supplier.Name }}
              </option>
            </select>
            <div v-if="errors.SupplierID" class="invalid-feedback">{{ errors.SupplierID }}</div>
          </div>

          <!-- Station Selection -->
          <div class="col-12 col-lg-6">
            <label class="form-label fw-bold text-gray-800 fs-5">Station</label>
            <select
              v-model="paymentForm.StationID"
              class="form-select form-select-lg"
              :disabled="loadingStations"
            >
              <option value="">General/All Stations</option>
              <option
                v-for="station in stations"
                :key="station.StationID"
                :value="station.StationID"
              >
                {{ station.StationName }}
              </option>
            </select>
          </div>

          <!-- Payment Reference -->
          <div class="col-12 col-lg-6">
            <label class="required form-label fw-bold text-gray-800 fs-5">Payment Reference</label>
            <div class="input-group input-group-lg">
              <input
                v-model="paymentForm.PaymentReference"
                type="text"
                class="form-control"
                :class="{ 'is-invalid': errors.PaymentReference }"
                placeholder="Enter payment reference"
              />
              <button
                @click="generatePaymentReference"
                type="button"
                class="btn btn-light-primary"
                :disabled="loadingReference"
              >
                <i v-if="!loadingReference" class="ki-duotone ki-refresh fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <span v-else class="spinner-border spinner-border-sm"></span>
              </button>
            </div>
            <div v-if="errors.PaymentReference" class="invalid-feedback">
              {{ errors.PaymentReference }}
            </div>
          </div>

          <!-- Payment Date -->
          <div class="col-12 col-lg-6">
            <label class="required form-label fw-bold text-gray-800 fs-5">Payment Date</label>
            <input
              v-model="paymentForm.PaymentDate"
              type="date"
              class="form-control form-control-lg"
              :class="{ 'is-invalid': errors.PaymentDate }"
            />
            <div v-if="errors.PaymentDate" class="invalid-feedback">{{ errors.PaymentDate }}</div>
          </div>

          <!-- Payment Amount -->
          <div class="col-12 col-lg-6">
            <label class="required form-label fw-bold text-gray-800 fs-5"
              >Payment Amount (UGX)</label
            >
            <input
              v-model="paymentForm.PaymentAmount"
              type="number"
              step="0.01"
              min="0"
              class="form-control form-control-lg"
              :class="{ 'is-invalid': errors.PaymentAmount }"
              placeholder="0.00"
            />
            <div v-if="errors.PaymentAmount" class="invalid-feedback">
              {{ errors.PaymentAmount }}
            </div>
          </div>

          <!-- Payment Method -->
          <div class="col-12 col-lg-6">
            <label class="required form-label fw-bold text-gray-800 fs-5">Payment Method</label>
            <select
              v-model="paymentForm.PaymentMethod"
              class="form-select form-select-lg"
              :class="{ 'is-invalid': errors.PaymentMethod }"
            >
              <option value="Bank Transfer">Bank Transfer</option>
              <option value="Check">Check</option>
              <option value="Cash">Cash</option>
              <option value="Mobile Money">Mobile Money</option>
            </select>
            <div v-if="errors.PaymentMethod" class="invalid-feedback">
              {{ errors.PaymentMethod }}
            </div>
          </div>

          <!-- Bank Reference -->
          <div class="col-12">
            <label class="required form-label fw-bold text-gray-800 fs-5"
              >Bank Reference / Transaction ID</label
            >
            <input
              v-model="paymentForm.BankReference"
              type="text"
              class="form-control form-control-lg"
              :class="{ 'is-invalid': errors.BankReference }"
              placeholder="Enter bank reference or transaction ID"
            />
            <div v-if="errors.BankReference" class="invalid-feedback">
              {{ errors.BankReference }}
            </div>
          </div>

          <!-- Notes -->
          <div class="col-12">
            <label class="required form-label fw-bold text-gray-800 fs-5">Payment Notes</label>
            <textarea
              v-model="paymentForm.Notes"
              class="form-control form-control-lg"
              :class="{ 'is-invalid': errors.Notes }"
              rows="4"
              placeholder="Enter payment details, invoice numbers, or additional information..."
            ></textarea>
            <div v-if="errors.Notes" class="invalid-feedback">{{ errors.Notes }}</div>
          </div>

          <!-- Submit Button -->
          <div class="col-12">
            <div class="d-flex gap-3">
              <button
                @click="createPayment"
                class="btn btn-lg btn-success flex-grow-1"
                :disabled="submitting || !isFormValid"
                :data-kt-indicator="submitting ? 'on' : 'off'"
              >
                <span class="indicator-label">
                  <i class="ki-duotone ki-check fs-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Create Payment
                </span>
                <span class="indicator-progress">
                  Processing... <span class="spinner-border spinner-border-sm ms-2"></span>
                </span>
              </button>
              <button @click="resetForm" type="button" class="btn btn-lg btn-light-secondary">
                <i class="ki-duotone ki-trash fs-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                </i>
                Reset
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Payments -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title fw-bold text-gray-900">
          <i class="ki-duotone ki-calendar fs-2 text-info me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Recent Payments
        </h3>
        <div class="card-toolbar">
          <button
            @click="fetchPayments"
            class="btn btn-sm btn-light-primary"
            :disabled="loadingPayments"
          >
            <i v-if="!loadingPayments" class="ki-duotone ki-refresh fs-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <span v-else class="spinner-border spinner-border-sm"></span>
            Refresh
          </button>
        </div>
      </div>
      <div class="card-body p-0">
        <div v-if="loadingPayments" class="d-flex justify-content-center py-10">
          <div class="spinner-border text-primary"></div>
        </div>
        <div v-else-if="payments.length === 0" class="text-center py-10">
          <i class="ki-duotone ki-file-deleted fs-3x text-gray-400 mb-3">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <p class="text-gray-500 fs-5">No payments found</p>
        </div>
        <div v-else class="table-responsive">
          <table class="table align-middle table-row-dashed gs-5">
            <thead>
              <tr class="text-start text-gray-600 fw-bold fs-7 text-uppercase">
                <th>Supplier</th>
                <th>Reference</th>
                <th>Amount</th>
                <th>Method</th>
                <th>Date</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody class="fw-semibold text-gray-700">
              <tr v-for="payment in payments" :key="payment.PaymentID">
                <td>
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-30px me-3">
                      <div class="symbol-label bg-light-primary">
                        <i class="ki-duotone ki-supplier fs-3 text-primary">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <span class="fw-bold">{{ getSupplierName(payment.SupplierID) }}</span>
                  </div>
                </td>
                <td>
                  <span class="badge badge-light-info fs-7">{{ payment.PaymentReference }}</span>
                </td>
                <td>
                  <span class="fw-bold text-primary"
                    >UGX {{ formatCurrency(payment.PaymentAmount) }}</span
                  >
                </td>
                <td>
                  <span class="text-gray-800">{{ payment.PaymentMethod }}</span>
                </td>
                <td>
                  <span class="text-gray-600">{{ formatDate(payment.PaymentDate) }}</span>
                </td>
                <td>
                  <span
                    class="badge fs-7"
                    :class="{
                      'badge-light-success': payment.Status === 'Completed',
                      'badge-light-warning': payment.Status === 'Pending',
                      'badge-light-danger': payment.Status === 'Failed',
                      'badge-light-secondary': payment.Status === 'Cancelled',
                    }"
                  >
                    {{ payment.Status }}
                  </span>
                </td>
                <td>
                  <button @click="viewPaymentDetails(payment)" class="btn btn-sm btn-light-primary">
                    <i class="ki-duotone ki-eye fs-5">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import Swal from 'sweetalert2'
import * as Chart from 'chart.js'

// Register all Chart.js components
Chart.Chart.register(...Chart.registerables)

// Form state
const showCreateForm = ref(false)
const submitting = ref(false)
const loadingPayments = ref(false)
const loadingSuppliers = ref(false)
const loadingStations = ref(false)
const loadingReference = ref(false)

// Data
const payments = ref([])
const suppliers = ref([])
const stations = ref([])
const currentUser = ref(null)

// Statistics
const paymentStats = ref({
  todayCount: 0,
  todayAmount: 0,
  pendingCount: 0,
  successRate: 95,
})

const methodStats = ref({
  bankTransfer: 0,
  cash: 0,
  mobileMoney: 0,
  check: 0,
})

// Chart reference
const paymentsChart = ref(null)

// Form data
const paymentForm = ref({
  SupplierID: '',
  StationID: '',
  PaymentReference: '',
  PaymentDate: new Date().toISOString().split('T')[0],
  PaymentAmount: '',
  PaymentMethod: 'Bank Transfer',
  BankReference: '',
  Notes: '',
  ProcessedBy: '1',
  Status: 'Completed',
})

// Form validation
const errors = ref({})

// API configuration
const API_BASE_URL = 'http://localhost:4000/api/records/v1'
const JWT_TOKEN =
  localStorage.getItem('jwt') ||
  'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJzdWIiOiJkMDc1QVZVSVNCcW9HN3dvZFV0MVZ3PT0iLCJpYXQiOjE3NTA1NDE0NzYsImV4cCI6MTc1MDU0NTA3NiwiZW1haWwiOiJhZG1pbkBsb2NhbGhvc3QiLCJjc3JmX3Rva2VuIjoiU096UjJaS2Z5ZkM1RU80TXFhaEEifQ.0o7bR0Ow7iTss_U_F8YkdclzknFMF2c6osVOExKvI8d-Jmx5dU-P2woXhJAItU29sxIG8i9pxWAgOUutCuT9Bg'

// Computed properties
const isFormValid = computed(() => {
  return (
    paymentForm.value.SupplierID &&
    paymentForm.value.PaymentReference &&
    paymentForm.value.PaymentDate &&
    paymentForm.value.PaymentAmount &&
    parseFloat(paymentForm.value.PaymentAmount) > 0 &&
    paymentForm.value.PaymentMethod &&
    paymentForm.value.BankReference &&
    paymentForm.value.Notes
  )
})

// Utility functions
const formatCurrency = (amount) => {
  return parseFloat(amount || 0).toLocaleString('en-UG', { minimumFractionDigits: 2 })
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-UG')
}

const getSupplierName = (supplierId) => {
  const supplier = suppliers.value.find((s) => s.SupplierID == supplierId)
  return supplier ? supplier.Name : 'Unknown'
}

// Generate unique payment reference
const generatePaymentReference = async () => {
  loadingReference.value = true
  try {
    // Create a more unique reference
    const timestamp = Date.now()
    const userId = currentUser.value?.id || '1'
    const randomPart = Math.random().toString(36).substring(2, 12).toUpperCase()
    const microtime = performance.now().toString().replace('.', '').substring(0, 8)

    let newReference = `SPP-${timestamp}-U${userId}-${randomPart}-${microtime}`

    // Check if reference exists (simple check)
    let isUnique = false
    let attempts = 0

    while (!isUnique && attempts < 5) {
      try {
        const checkResponse = await fetch(
          `${API_BASE_URL}/SupplierPayments?PaymentReference=${encodeURIComponent(newReference)}`,
          {
            method: 'GET',
            headers: {
              Authorization: `Bearer ${JWT_TOKEN}`,
              'Content-Type': 'application/json',
            },
          },
        )

        if (checkResponse.ok) {
          const checkData = await checkResponse.json()
          isUnique = !checkData.records || checkData.records.length === 0
        } else {
          // If check fails, assume it's unique
          isUnique = true
        }

        if (!isUnique) {
          // Generate new reference with additional randomness
          const extraRandom = Math.random().toString(36).substring(2, 8).toUpperCase()
          newReference = `SPP-${Date.now()}-U${userId}-${randomPart}-${microtime}-${extraRandom}`
          attempts++
        }
      } catch (error) {
        console.warn('Reference uniqueness check failed, proceeding:', error)
        isUnique = true // Assume unique if check fails
      }
    }

    paymentForm.value.PaymentReference = newReference

    Swal.fire({
      title: 'Reference Generated!',
      text: `Unique reference: ${newReference}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Error generating reference:', error)
    // Fallback reference
    const fallbackRef = `SPP-FALLBACK-${Date.now()}-${Math.random().toString(36).substring(2, 10).toUpperCase()}`
    paymentForm.value.PaymentReference = fallbackRef

    Swal.fire({
      title: 'Fallback Reference',
      text: 'Generated fallback reference',
      icon: 'warning',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })
  } finally {
    loadingReference.value = false
  }
}

// Fetch functions
const fetchPayments = async () => {
  loadingPayments.value = true
  try {
    const response = await fetch(`${API_BASE_URL}/SupplierPayments`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) throw new Error(`Failed to fetch payments: ${response.status}`)

    const data = await response.json()
    payments.value = (data.records || []).slice(0, 10) // Latest 10 payments

    // Calculate stats
    calculatePaymentStats()
  } catch (error) {
    console.error('Error fetching payments:', error)
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load payments data',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loadingPayments.value = false
  }
}

const fetchSuppliers = async () => {
  loadingSuppliers.value = true
  try {
    const response = await fetch(`${API_BASE_URL}/Suppliers`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) throw new Error(`Failed to fetch suppliers: ${response.status}`)

    const data = await response.json()
    suppliers.value = data.records || []
  } catch (error) {
    console.error('Error fetching suppliers:', error)
  } finally {
    loadingSuppliers.value = false
  }
}

const fetchStations = async () => {
  loadingStations.value = true
  try {
    const response = await fetch(`${API_BASE_URL}/Stations`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) throw new Error(`Failed to fetch stations: ${response.status}`)

    const data = await response.json()
    stations.value = data.records || []
  } catch (error) {
    console.error('Error fetching stations:', error)
  } finally {
    loadingStations.value = false
  }
}

const getCurrentUser = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/users`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (response.ok) {
      const data = await response.json()
      if (data.records && data.records.length > 0) {
        currentUser.value = data.records[0]
        paymentForm.value.ProcessedBy = String(currentUser.value.id)
      }
    }
  } catch (error) {
    console.error('Error fetching current user:', error)
    paymentForm.value.ProcessedBy = '1'
  }
}

// Calculate payment statistics
const calculatePaymentStats = () => {
  const today = new Date().toISOString().split('T')[0]
  const todayPayments = payments.value.filter((p) => p.PaymentDate === today)

  paymentStats.value.todayCount = todayPayments.length
  paymentStats.value.todayAmount = todayPayments.reduce(
    (sum, p) => sum + parseFloat(p.PaymentAmount || 0),
    0,
  )
  paymentStats.value.pendingCount = payments.value.filter((p) => p.Status === 'Pending').length

  const completed = payments.value.filter((p) => p.Status === 'Completed').length
  paymentStats.value.successRate =
    payments.value.length > 0 ? Math.round((completed / payments.value.length) * 100) : 95

  // Calculate method distribution
  const total = payments.value.length
  if (total > 0) {
    methodStats.value.bankTransfer = Math.round(
      (payments.value.filter((p) => p.PaymentMethod === 'Bank Transfer').length / total) * 100,
    )
    methodStats.value.cash = Math.round(
      (payments.value.filter((p) => p.PaymentMethod === 'Cash').length / total) * 100,
    )
    methodStats.value.mobileMoney = Math.round(
      (payments.value.filter((p) => p.PaymentMethod === 'Mobile Money').length / total) * 100,
    )
    methodStats.value.check = Math.round(
      (payments.value.filter((p) => p.PaymentMethod === 'Check').length / total) * 100,
    )
  }
}

// Create payment chart
const createPaymentChart = () => {
  if (!paymentsChart.value) return

  const ctx = paymentsChart.value.getContext('2d')

  // Generate last 7 days data
  const last7Days = []
  const amounts = []

  for (let i = 6; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)
    const dateStr = date.toISOString().split('T')[0]
    last7Days.push(date.toLocaleDateString('en-UG', { weekday: 'short' }))

    const dayPayments = payments.value.filter((p) => p.PaymentDate === dateStr)
    amounts.push(dayPayments.reduce((sum, p) => sum + parseFloat(p.PaymentAmount || 0), 0))
  }

  new Chart.Chart(ctx, {
    type: 'line',
    data: {
      labels: last7Days,
      datasets: [
        {
          label: 'Payment Amount (UGX)',
          data: amounts,
          borderColor: '#009ef7',
          backgroundColor: 'rgba(0, 158, 247, 0.1)',
          tension: 0.4,
          fill: true,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'top',
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

// Form validation
const validateForm = () => {
  errors.value = {}

  // SupplierID validation (NOT NULL, INTEGER)
  if (!paymentForm.value.SupplierID) {
    errors.value.SupplierID = 'Supplier is required'
  } else if (isNaN(parseInt(paymentForm.value.SupplierID))) {
    errors.value.SupplierID = 'Invalid supplier selection'
  }

  // PaymentReference validation (NOT NULL, UNIQUE, TEXT)
  if (!paymentForm.value.PaymentReference) {
    errors.value.PaymentReference = 'Payment reference is required'
  } else if (paymentForm.value.PaymentReference.length < 5) {
    errors.value.PaymentReference = 'Payment reference must be at least 5 characters'
  } else if (paymentForm.value.PaymentReference.length > 255) {
    errors.value.PaymentReference = 'Payment reference too long (max 255 characters)'
  }

  // PaymentDate validation (NOT NULL, TEXT)
  if (!paymentForm.value.PaymentDate) {
    errors.value.PaymentDate = 'Payment date is required'
  } else if (!/^\d{4}-\d{2}-\d{2}$/.test(paymentForm.value.PaymentDate)) {
    errors.value.PaymentDate = 'Invalid date format (YYYY-MM-DD required)'
  }

  // PaymentAmount validation (NOT NULL, TEXT but numeric)
  if (!paymentForm.value.PaymentAmount) {
    errors.value.PaymentAmount = 'Payment amount is required'
  } else {
    const amount = parseFloat(paymentForm.value.PaymentAmount)
    if (isNaN(amount) || amount <= 0) {
      errors.value.PaymentAmount = 'Payment amount must be greater than 0'
    } else if (amount > 999999999.99) {
      errors.value.PaymentAmount = 'Payment amount too large'
    }
  }

  // PaymentMethod validation (NOT NULL, TEXT with specific values)
  const allowedMethods = ['Bank Transfer', 'Check', 'Cash', 'Mobile Money']
  if (!paymentForm.value.PaymentMethod) {
    errors.value.PaymentMethod = 'Payment method is required'
  } else if (!allowedMethods.includes(paymentForm.value.PaymentMethod)) {
    errors.value.PaymentMethod = 'Invalid payment method'
  }

  // BankReference validation (TEXT, can be null but we require it for audit)
  if (!paymentForm.value.BankReference || paymentForm.value.BankReference.trim().length === 0) {
    errors.value.BankReference = 'Bank reference is required for audit purposes'
  } else if (paymentForm.value.BankReference.length > 255) {
    errors.value.BankReference = 'Bank reference too long (max 255 characters)'
  }

  // Notes validation (TEXT, we require it for documentation)
  if (!paymentForm.value.Notes || paymentForm.value.Notes.trim().length === 0) {
    errors.value.Notes = 'Payment notes are required for documentation'
  } else if (paymentForm.value.Notes.trim().length < 10) {
    errors.value.Notes = 'Notes must be at least 10 characters for proper documentation'
  } else if (paymentForm.value.Notes.length > 1000) {
    errors.value.Notes = 'Notes too long (max 1000 characters)'
  }

  return Object.keys(errors.value).length === 0
}

// Create payment
const createPayment = async () => {
  if (!validateForm()) {
    Swal.fire({
      title: 'Validation Error!',
      text: 'Please fix the form errors before submitting',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  submitting.value = true

  try {
    // Prepare payment data according to exact schema
    const paymentData = {
      SupplierID: parseInt(paymentForm.value.SupplierID), // INTEGER NOT NULL
      StationID: paymentForm.value.StationID ? parseInt(paymentForm.value.StationID) : null, // INTEGER NULL
      PaymentReference: paymentForm.value.PaymentReference.trim(), // TEXT NOT NULL UNIQUE
      PaymentDate: paymentForm.value.PaymentDate, // TEXT NOT NULL
      PaymentAmount: paymentForm.value.PaymentAmount.toString(), // TEXT NOT NULL (stored as TEXT but numeric)
      PaymentMethod: paymentForm.value.PaymentMethod, // TEXT NOT NULL
      BankReference: paymentForm.value.BankReference.trim(), // TEXT (can be null but we provide it)
      Notes: paymentForm.value.Notes.trim(), // TEXT (can be null but we provide it)
      ProcessedBy: parseInt(paymentForm.value.ProcessedBy), // INTEGER NOT NULL
      Status: paymentForm.value.Status, // TEXT with DEFAULT 'Completed'
      // CreatedAt will be set automatically by the database
    }

    console.log('Creating payment with data:', paymentData)

    // Verify foreign key constraints before submission
    const supplierExists = suppliers.value.find((s) => s.SupplierID == paymentData.SupplierID)
    if (!supplierExists) {
      throw new Error('Selected supplier does not exist')
    }

    if (paymentData.StationID) {
      const stationExists = stations.value.find((s) => s.StationID == paymentData.StationID)
      if (!stationExists) {
        throw new Error('Selected station does not exist')
      }
    }

    const response = await fetch(`${API_BASE_URL}/SupplierPayments`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(paymentData),
    })

    if (!response.ok) {
      let errorMessage = `Payment creation failed: ${response.status}`

      try {
        const errorText = await response.text()
        console.error('Server error response:', errorText)

        // Try to parse error response
        const errorData = JSON.parse(errorText)
        errorMessage = errorData.message || errorData.error || errorMessage

        // Handle specific database errors
        if (errorText.includes('UNIQUE constraint failed')) {
          errorMessage = 'Payment reference already exists. Please generate a new reference.'
        } else if (errorText.includes('FOREIGN KEY constraint failed')) {
          errorMessage = 'Invalid supplier or station selected. Please refresh and try again.'
        }
      } catch (parseError) {
        console.error('Could not parse error response:', parseError)
      }

      throw new Error(errorMessage)
    }

    const result = await response.json()
    console.log('Payment created successfully:', result)

    // Show success message with payment details
    Swal.fire({
      title: 'Payment Created!',
      html: `
        <div class="text-start">
          <p><strong>Reference:</strong> ${paymentData.PaymentReference}</p>
          <p><strong>Amount:</strong> UGX ${formatCurrency(paymentData.PaymentAmount)}</p>
          <p><strong>Supplier:</strong> ${supplierExists.Name}</p>
          <p><strong>Method:</strong> ${paymentData.PaymentMethod}</p>
        </div>
      `,
      icon: 'success',
      confirmButtonColor: '#50cd89',
    })

    // Reset form and refresh data
    resetForm()
    showCreateForm.value = false
    await Promise.all([fetchPayments(), generatePaymentReference()])
  } catch (error) {
    console.error('Error creating payment:', error)
    Swal.fire({
      title: 'Creation Failed!',
      text: error.message || 'Could not create payment. Please try again.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    submitting.value = false
  }
}

// Reset form
const resetForm = () => {
  paymentForm.value = {
    SupplierID: '',
    StationID: '',
    PaymentReference: '',
    PaymentDate: new Date().toISOString().split('T')[0],
    PaymentAmount: '',
    PaymentMethod: 'Bank Transfer',
    BankReference: '',
    Notes: '',
    ProcessedBy: currentUser.value?.id || '1',
    Status: 'Completed',
  }
  errors.value = {}
}

// View payment details
const viewPaymentDetails = (payment) => {
  const supplier = suppliers.value.find((s) => s.SupplierID == payment.SupplierID)

  Swal.fire({
    title: 'Payment Details',
    html: `
      <div class="text-start">
        <p><strong>Supplier:</strong> ${supplier?.Name || 'Unknown'}</p>
        <p><strong>Reference:</strong> ${payment.PaymentReference}</p>
        <p><strong>Amount:</strong> UGX ${formatCurrency(payment.PaymentAmount)}</p>
        <p><strong>Method:</strong> ${payment.PaymentMethod}</p>
        <p><strong>Date:</strong> ${formatDate(payment.PaymentDate)}</p>
        <p><strong>Bank Reference:</strong> ${payment.BankReference || 'N/A'}</p>
        <p><strong>Status:</strong> ${payment.Status}</p>
        <p><strong>Notes:</strong> ${payment.Notes || 'No notes'}</p>
      </div>
    `,
    width: '500px',
    confirmButtonText: 'Close',
  })
}

// Initialize component
onMounted(async () => {
  await Promise.all([fetchSuppliers(), fetchStations(), getCurrentUser(), fetchPayments()])

  await generatePaymentReference()

  // Create chart after data is loaded
  setTimeout(() => {
    createPaymentChart()
  }, 500)
})
</script>

<style scoped>
.form-control:focus {
  border-color: var(--bs-primary);
  box-shadow: 0 0 0 0.25rem rgba(var(--bs-primary-rgb), 0.25);
}

.card-flush {
  box-shadow: 0 0.5rem 1.5rem 0.5rem rgba(0, 0, 0, 0.075);
  border-radius: 12px;
}

.btn-lg {
  min-height: 50px;
  font-weight: 600;
  border-radius: 8px;
}

.symbol {
  border-radius: 8px;
}

.form-select-lg,
.form-control-lg {
  min-height: 50px;
  font-size: 1rem;
  border-radius: 8px;
}

.table th {
  border-bottom: 2px solid var(--bs-gray-200);
  padding: 1rem 0.75rem;
}

.table td {
  padding: 1rem 0.75rem;
  border-bottom: 1px solid var(--bs-gray-200);
}

@media (max-width: 768px) {
  .card-header {
    padding: 1rem;
  }

  .card-body {
    padding: 1rem !important;
  }

  .table-responsive {
    font-size: 0.875rem;
  }
}
</style>

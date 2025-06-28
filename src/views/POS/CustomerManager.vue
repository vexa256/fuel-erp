<template>
  <!-- CUSTOMER SELECTION & CREDIT MANAGEMENT - IOS PREMIUM DESIGN -->
  <div class="customer-manager-container">
    <!-- PREMIUM HEADER SECTION -->
    <div class="card border-0 shadow-lg mb-4 bg-gradient-primary">
      <div class="card-body p-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-profile-user fs-1 text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div>
              <h3 class="text-white fw-bold fs-2 mb-0">Customer Selection</h3>
              <p class="text-white opacity-75 fs-7 mb-0">
                Choose customer type and manage accounts
              </p>
            </div>
          </div>
          <button
            @click="resetCustomerSelection"
            :disabled="disabled"
            class="btn btn-light-danger btn-sm"
          >
            <i class="ki-duotone ki-arrows-circle fs-3 me-1">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Reset
          </button>
        </div>

        <!-- CUSTOMER TYPE SELECTION CARDS -->
        <div class="row g-3">
          <div class="col-6">
            <button
              @click="setCustomerType('walk-in')"
              :disabled="disabled"
              :class="[
                'btn w-100 h-80px shadow-sm',
                customerType === 'walk-in'
                  ? 'btn-light-success border-success bg-light-success'
                  : 'btn-light border-light bg-white',
              ]"
              style="transition: all 0.3s ease"
            >
              <div class="d-flex align-items-center justify-content-center h-100">
                <div class="text-center">
                  <i
                    :class="[
                      'ki-duotone ki-user-tick fs-2x mb-2',
                      customerType === 'walk-in' ? 'text-success' : 'text-gray-500',
                    ]"
                  >
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div
                    :class="[
                      'fw-bold fs-5',
                      customerType === 'walk-in' ? 'text-success' : 'text-gray-700',
                    ]"
                  >
                    Walk-in
                  </div>
                  <div
                    :class="[
                      'fs-8',
                      customerType === 'walk-in' ? 'text-success opacity-75' : 'text-gray-500',
                    ]"
                  >
                    Cash Payment
                  </div>
                </div>
              </div>
            </button>
          </div>
          <div class="col-6">
            <button
              @click="setCustomerType('registered')"
              :disabled="disabled"
              :class="[
                'btn w-100 h-80px shadow-sm',
                customerType === 'registered'
                  ? 'btn-light-info border-info bg-light-info'
                  : 'btn-light border-light bg-white',
              ]"
              style="transition: all 0.3s ease"
            >
              <div class="d-flex align-items-center justify-content-center h-100">
                <div class="text-center">
                  <i
                    :class="[
                      'ki-duotone ki-address-book fs-2x mb-2',
                      customerType === 'registered' ? 'text-info' : 'text-gray-500',
                    ]"
                  >
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div
                    :class="[
                      'fw-bold fs-5',
                      customerType === 'registered' ? 'text-info' : 'text-gray-700',
                    ]"
                  >
                    Credit Account
                  </div>
                  <div
                    :class="[
                      'fs-8',
                      customerType === 'registered' ? 'text-info opacity-75' : 'text-gray-500',
                    ]"
                  >
                    Account Billing
                  </div>
                </div>
              </div>
            </button>
          </div>
        </div>

        <!-- LIVE STATS MINI CARDS -->
        <div v-if="customerStats.totalCustomers > 0" class="row g-2 mt-3">
          <div class="col-4">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-2">
                <div class="fw-bold text-white fs-6">{{ customerStats.totalCustomers }}</div>
                <div class="text-white opacity-75 fs-9">Total</div>
              </div>
            </div>
          </div>
          <div class="col-4">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-2">
                <div class="fw-bold text-white fs-6">{{ customerStats.activeAccounts }}</div>
                <div class="text-white opacity-75 fs-9">Active</div>
              </div>
            </div>
          </div>
          <div class="col-4">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-2">
                <div class="fw-bold text-white fs-6">
                  {{ formatShortCurrency(customerStats.totalCredit) }}
                </div>
                <div class="text-white opacity-75 fs-9">Credit</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- CUSTOMER SEARCH & SELECTION SECTION -->
    <div v-if="customerType === 'registered'" class="card border-0 shadow-sm mb-4">
      <div class="card-body p-4">
        <!-- SEARCH INPUT WITH PREMIUM STYLING -->
        <div class="position-relative mb-4">
          <input
            v-model="searchQuery"
            @input="handleSearchInput"
            @focus="handleSearchFocus"
            @blur="handleSearchBlur"
            type="text"
            class="form-control form-control-lg ps-5 pe-5"
            :class="getSearchInputClass"
            :style="getSearchInputStyle"
            placeholder="Search customers by name, phone, or code..."
            :disabled="disabled || loadingCustomers"
            maxlength="100"
          />

          <!-- SEARCH ICON -->
          <i
            class="ki-duotone ki-magnifier position-absolute top-50 start-0 translate-middle-y ms-3 fs-2 text-gray-500"
          >
            <span class="path1"></span>
            <span class="path2"></span>
          </i>

          <!-- LOADING SPINNER -->
          <div
            v-if="loadingCustomers"
            class="position-absolute top-50 end-0 translate-middle-y me-3"
          >
            <div class="spinner-border spinner-border-sm text-primary"></div>
          </div>

          <!-- CLEAR BUTTON -->
          <button
            v-if="searchQuery && !loadingCustomers"
            @click="clearSearch"
            class="btn btn-icon btn-light-danger btn-sm position-absolute top-50 end-0 translate-middle-y me-2"
          >
            <i class="ki-duotone ki-cross fs-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </button>
        </div>

        <!-- SEARCH SUGGESTIONS -->
        <div v-if="showSearchSuggestions" class="mb-3">
          <div class="fs-8 text-gray-600 mb-2">Quick Search:</div>
          <div class="d-flex gap-2 flex-wrap">
            <button
              v-for="suggestion in searchSuggestions"
              :key="suggestion"
              @click="applySuggestion(suggestion)"
              class="btn btn-light-primary btn-sm fs-8"
            >
              {{ suggestion }}
            </button>
          </div>
        </div>

        <!-- SELECTED CUSTOMER DISPLAY -->
        <div v-if="selectedCustomer" class="card bg-gradient-success border-success mb-4 shadow-sm">
          <div class="card-body p-4">
            <div class="d-flex align-items-start justify-content-between">
              <div class="flex-grow-1">
                <div class="d-flex align-items-center gap-3 mb-3">
                  <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-30">
                    <i class="ki-duotone ki-profile-circle fs-1 text-white">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                  </div>
                  <div>
                    <h5 class="fw-bold text-white mb-1">
                      {{ getCustomerDisplayName(selectedCustomer) }}
                    </h5>
                    <div class="fs-7 text-white opacity-75">
                      {{ selectedCustomer.CustomerCode }} • {{ selectedCustomer.PhoneNumber }}
                    </div>
                    <div v-if="selectedCustomer.Email" class="fs-8 text-white opacity-75">
                      {{ selectedCustomer.Email }}
                    </div>
                  </div>
                </div>

                <!-- CREDIT ACCOUNT INFORMATION -->
                <div v-if="selectedCustomer.creditAccount" class="row g-3">
                  <div class="col-6">
                    <div class="card bg-white bg-opacity-20 border-0">
                      <div class="card-body p-3 text-center">
                        <i class="ki-duotone ki-dollar fs-2 text-white mb-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        <div class="fw-bold text-white fs-5">
                          {{ formatCurrency(selectedCustomer.creditAccount.CreditLimit) }}
                        </div>
                        <div class="text-white opacity-75 fs-8">Credit Limit</div>
                      </div>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="card bg-white bg-opacity-20 border-0">
                      <div class="card-body p-3 text-center">
                        <i class="ki-duotone ki-wallet fs-2 text-white mb-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                        </i>
                        <div class="fw-bold text-white fs-5">
                          {{ formatCurrency(selectedCustomer.creditAccount.AvailableCredit) }}
                        </div>
                        <div class="text-white opacity-75 fs-8">Available</div>
                      </div>
                    </div>
                  </div>
                  <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center">
                      <span class="text-white opacity-90 fs-7">Current Balance:</span>
                      <span class="fw-bold text-white fs-6">{{
                        formatCurrency(selectedCustomer.creditAccount.CurrentBalance)
                      }}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-1">
                      <span class="text-white opacity-90 fs-7">Payment Terms:</span>
                      <span class="fw-bold text-white fs-7"
                        >{{ selectedCustomer.creditAccount.PaymentTermsDays }} days</span
                      >
                    </div>

                    <!-- CREDIT STATUS INDICATOR -->
                    <div class="mt-3">
                      <div class="progress" style="height: 8px">
                        <div
                          class="progress-bar bg-white"
                          :style="{
                            width: getCreditUsagePercentage(selectedCustomer.creditAccount) + '%',
                          }"
                        ></div>
                      </div>
                      <div class="d-flex justify-content-between mt-1">
                        <span class="text-white opacity-75 fs-9">Credit Usage</span>
                        <span class="text-white opacity-75 fs-9"
                          >{{ getCreditUsagePercentage(selectedCustomer.creditAccount) }}%</span
                        >
                      </div>
                    </div>
                  </div>
                </div>

                <!-- NO CREDIT ACCOUNT WARNING -->
                <div
                  v-else
                  class="alert alert-warning bg-warning bg-opacity-20 border-warning py-2 mt-3"
                >
                  <i class="ki-duotone ki-information fs-3 me-2 text-warning">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <span class="text-warning fw-bold fs-7"
                    >No credit account found for this customer</span
                  >
                </div>
              </div>

              <!-- CLEAR CUSTOMER BUTTON -->
              <button
                @click="clearSelectedCustomer"
                :disabled="disabled"
                class="btn btn-icon btn-light-danger btn-sm ms-3"
              >
                <i class="ki-duotone ki-cross fs-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
            </div>
          </div>
        </div>

        <!-- SEARCH RESULTS -->
        <div
          v-if="searchResults.length && !selectedCustomer && searchQuery.length >= 2"
          class="card border-info shadow-sm"
        >
          <div class="card-header bg-light-info border-info">
            <h6 class="fw-bold text-info mb-0">
              <i class="ki-duotone ki-search-list fs-3 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              Search Results ({{ searchResults.length }})
            </h6>
          </div>
          <div class="card-body p-0 max-h-400px overflow-auto">
            <div
              v-for="(customer, index) in searchResults.slice(0, 8)"
              :key="customer.CustomerID"
              @click="selectCustomer(customer)"
              class="p-3 cursor-pointer hover-bg-light border-bottom border-light position-relative"
              :class="{ 'border-bottom-0': index === Math.min(searchResults.length - 1, 7) }"
              style="transition: all 0.2s ease"
            >
              <div class="d-flex align-items-center gap-3">
                <!-- CUSTOMER AVATAR -->
                <div class="symbol symbol-45px symbol-circle bg-light-primary">
                  <i class="ki-duotone ki-profile-circle fs-2 text-primary">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </div>

                <!-- CUSTOMER INFO -->
                <div class="flex-grow-1">
                  <div class="fw-bold text-gray-800 fs-6 mb-1">
                    {{ getCustomerDisplayName(customer) }}
                  </div>
                  <div class="fs-8 text-gray-600 mb-1">
                    {{ customer.PhoneNumber }} • {{ customer.CustomerCode }}
                  </div>
                  <div v-if="customer.Email" class="fs-9 text-gray-500">{{ customer.Email }}</div>

                  <!-- CREDIT INFO BADGE -->
                  <div v-if="customer.creditAccount" class="d-flex gap-2 mt-2">
                    <span class="badge badge-light-success fs-9">
                      Credit: {{ formatCurrency(customer.creditAccount.AvailableCredit) }}
                    </span>
                    <span
                      :class="['badge fs-9', getCreditStatusBadgeClass(customer.creditAccount)]"
                    >
                      {{ getCreditStatus(customer.creditAccount) }}
                    </span>
                  </div>
                  <div v-else class="mt-2">
                    <span class="badge badge-light-warning fs-9">No Credit Account</span>
                  </div>
                </div>

                <!-- SELECT ARROW -->
                <i class="ki-duotone ki-arrow-right fs-2 text-info">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>

              <!-- LOADING OVERLAY FOR INDIVIDUAL CUSTOMER -->
              <div
                v-if="loadingCustomerDetails === customer.CustomerID"
                class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center bg-white bg-opacity-75"
              >
                <div class="spinner-border spinner-border-sm text-primary"></div>
              </div>
            </div>

            <!-- MORE RESULTS INDICATOR -->
            <div v-if="searchResults.length > 8" class="p-3 text-center bg-light-info">
              <span class="text-info fw-bold fs-8"
                >{{ searchResults.length - 8 }} more results... Refine your search</span
              >
            </div>
          </div>
        </div>

        <!-- NO RESULTS STATE -->
        <div
          v-if="
            searchQuery.length >= 2 &&
            !loadingCustomers &&
            searchResults.length === 0 &&
            !selectedCustomer
          "
          class="card border-warning bg-light-warning"
        >
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-information-5 fs-3x text-warning mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <h6 class="fw-bold text-warning mb-2">No customers found</h6>
            <p class="text-warning opacity-75 fs-7 mb-3">
              Try searching with different keywords or check the spelling
            </p>
            <button @click="createNewCustomer" class="btn btn-warning">
              <i class="ki-duotone ki-plus fs-3 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Create New Customer
            </button>
          </div>
        </div>

        <!-- EMPTY SEARCH STATE -->
        <div
          v-if="
            customerType === 'registered' &&
            !selectedCustomer &&
            searchQuery.length < 2 &&
            !loadingCustomers
          "
          class="card border-primary bg-light-primary"
        >
          <div class="card-body p-4 text-center">
            <i class="ki-duotone ki-search-list fs-3x text-primary mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <h6 class="fw-bold text-primary mb-2">Search for a customer</h6>
            <p class="text-primary opacity-75 fs-7">
              Enter at least 2 characters to start searching
            </p>
          </div>
        </div>
      </div>
    </div>

    <!-- VERIFICATION LOG PANEL (DEVELOPMENT MODE) -->
    <div
      v-if="showVerificationLog && verificationLog.length > 0"
      class="card border-info bg-light-info"
    >
      <div class="card-header bg-info">
        <h6 class="fw-bold text-white mb-0">
          <i class="ki-duotone ki-verify fs-3 me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Verification Log ({{ verificationLog.length }})
        </h6>
      </div>
      <div class="card-body p-0 max-h-200px overflow-auto">
        <div
          v-for="(log, index) in verificationLog.slice(-5)"
          :key="index"
          class="p-2 border-bottom border-light"
        >
          <div class="d-flex justify-content-between">
            <span :class="['fs-8 fw-bold', getLogStatusClass(log.status)]">{{
              log.operation
            }}</span>
            <span class="fs-9 text-gray-500">{{ formatTimestamp(log.timestamp) }}</span>
          </div>
          <div class="fs-9 text-gray-600">{{ log.details }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import Swal from 'sweetalert2'

// ========== PROPS & EMITS ==========
const props = defineProps({
  disabled: {
    type: Boolean,
    default: false,
  },
  stationId: {
    type: Number,
    default: null,
  },
  showVerificationLog: {
    type: Boolean,
    default: false,
  },
})

const emits = defineEmits([
  'customer-selected',
  'customer-cleared',
  'customer-type-changed',
  'verification-log-updated',
])

// ========== CONSTANTS ==========
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const SEARCH_DEBOUNCE_DELAY = 500
const MAX_SEARCH_RESULTS = 50
const MIN_SEARCH_LENGTH = 2

// ========== REACTIVE STATE ==========
const customerType = ref('walk-in')
const selectedCustomer = ref(null)
const searchQuery = ref('')
const searchResults = ref([])
const loadingCustomers = ref(false)
const loadingCustomerDetails = ref(null)
const searchFocused = ref(false)

// Customer Statistics
const customerStats = reactive({
  totalCustomers: 0,
  activeAccounts: 0,
  totalCredit: 0,
})

// Verification System (Simplified)
const verificationLog = ref([])

// Search Enhancement
const searchSuggestions = ref(['Corporate', 'Individual', 'Fleet', 'Government'])
const showSearchSuggestions = ref(false)

// Debounce Control
let searchDebounceTimer = null
let currentSearchController = null

// ========== COMPUTED PROPERTIES ==========
const getSearchInputClass = computed(() => {
  let classes = []

  if (searchFocused.value) {
    classes.push('border-primary', 'shadow')
  } else if (selectedCustomer.value) {
    classes.push('border-success')
  } else if (
    searchQuery.value.length >= MIN_SEARCH_LENGTH &&
    searchResults.value.length === 0 &&
    !loadingCustomers.value
  ) {
    classes.push('border-warning')
  } else {
    classes.push('border-light')
  }

  return classes.join(' ')
})

const getSearchInputStyle = computed(() => {
  return {
    fontSize: '1.1rem',
    borderWidth: '2px',
    borderRadius: '12px',
    transition: 'all 0.3s ease',
  }
})

// ========== UTILITY FUNCTIONS ==========
const formatCurrency = (amount) => {
  const num = parseFloat(amount) || 0
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(num)
}

const formatShortCurrency = (amount) => {
  const num = parseFloat(amount) || 0
  if (num >= 1000000) return `${(num / 1000000).toFixed(1)}M`
  if (num >= 1000) return `${(num / 1000).toFixed(1)}K`
  return formatCurrency(num)
}

const formatTimestamp = (timestamp) => {
  return new Date(timestamp).toLocaleTimeString('en-US', {
    hour12: false,
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  })
}

const getAuthToken = () => {
  return localStorage.getItem('kigrama_auth_token') || 'demo_token'
}

const getCustomerDisplayName = (customer) => {
  if (!customer) return ''
  return (
    customer.CompanyName ||
    `${customer.FirstName || ''} ${customer.LastName || ''}`.trim() ||
    customer.CustomerCode ||
    'Unknown Customer'
  )
}

const getCreditUsagePercentage = (creditAccount) => {
  if (!creditAccount) return 0
  const limit = parseFloat(creditAccount.CreditLimit || 0)
  const balance = parseFloat(creditAccount.CurrentBalance || 0)
  if (limit === 0) return 0
  return Math.min(Math.round((balance / limit) * 100), 100)
}

const getCreditStatus = (creditAccount) => {
  if (!creditAccount) return 'No Account'
  const usage = getCreditUsagePercentage(creditAccount)
  if (usage >= 90) return 'Critical'
  if (usage >= 75) return 'High Usage'
  if (usage >= 50) return 'Moderate'
  return 'Good Standing'
}

const getCreditStatusBadgeClass = (creditAccount) => {
  const status = getCreditStatus(creditAccount)
  switch (status) {
    case 'Critical':
      return 'badge-danger'
    case 'High Usage':
      return 'badge-warning'
    case 'Moderate':
      return 'badge-info'
    case 'Good Standing':
      return 'badge-success'
    default:
      return 'badge-secondary'
  }
}

const getLogStatusClass = (status) => {
  switch (status) {
    case 'SUCCESS':
      return 'text-success'
    case 'WARNING':
      return 'text-warning'
    case 'ERROR':
      return 'text-danger'
    default:
      return 'text-info'
  }
}

// ========== SIMPLIFIED LOGGING SYSTEM ==========
const logEvent = (operation, status, details) => {
  const logEntry = {
    timestamp: new Date().toISOString(),
    operation,
    status,
    details,
    component: 'CustomerManager',
  }

  verificationLog.value.push(logEntry)

  // Keep only last 20 entries to prevent memory issues
  if (verificationLog.value.length > 20) {
    verificationLog.value = verificationLog.value.slice(-20)
  }

  console.log(`[CUSTOMER ${status}] ${operation}: ${details}`)

  // Emit to parent for global logging (without causing recursion)
  emits('verification-log-updated', logEntry)
}

// ========== SAFE API FUNCTIONS ==========
const safeApiCall = async (endpoint, options = {}) => {
  // Cancel any existing search request
  if (currentSearchController) {
    currentSearchController.abort()
  }

  // Create new controller for this request
  currentSearchController = new AbortController()
  const timeoutId = setTimeout(() => currentSearchController.abort(), 10000)

  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      signal: currentSearchController.signal,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${getAuthToken()}`,
        ...options.headers,
      },
      ...options,
    })

    clearTimeout(timeoutId)

    if (!response.ok) {
      throw new Error(`API Error ${response.status}`)
    }

    const responseText = await response.text()
    if (!responseText.trim()) {
      return { success: true, records: [] }
    }

    return JSON.parse(responseText)
  } catch (error) {
    clearTimeout(timeoutId)
    if (error.name === 'AbortError') {
      throw new Error('Request cancelled')
    }
    throw error
  } finally {
    currentSearchController = null
  }
}

// ========== CUSTOMER MANAGEMENT FUNCTIONS ==========
const setCustomerType = (type) => {
  try {
    const previousType = customerType.value
    customerType.value = type

    if (type === 'walk-in') {
      selectedCustomer.value = null
      searchQuery.value = ''
      searchResults.value = []
      showSearchSuggestions.value = false
    }

    logEvent('CUSTOMER_TYPE_CHANGED', 'SUCCESS', `Type changed to ${type}`)

    emits('customer-type-changed', { type, previousType })

    if (type === 'walk-in') {
      emits('customer-cleared')
    }

    // Load stats only for registered type
    if (type === 'registered') {
      loadCustomerStats()
    }
  } catch (error) {
    console.error('Error setting customer type:', error)
    logEvent('CUSTOMER_TYPE_ERROR', 'ERROR', error.message)
  }
}

const resetCustomerSelection = async () => {
  try {
    const result = await Swal.fire({
      title: 'Reset Customer Selection?',
      text: 'This will clear the current customer and return to walk-in mode',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Yes, Reset',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#f1416c',
    })

    if (result.isConfirmed) {
      customerType.value = 'walk-in'
      selectedCustomer.value = null
      searchQuery.value = ''
      searchResults.value = []
      showSearchSuggestions.value = false

      logEvent('SELECTION_RESET', 'SUCCESS', 'Customer selection reset')

      emits('customer-cleared')

      await Swal.fire({
        title: 'Reset Complete',
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    }
  } catch (error) {
    console.error('Error resetting selection:', error)
    logEvent('RESET_ERROR', 'ERROR', error.message)
  }
}

const handleSearchInput = () => {
  // Clear previous debounce timer
  if (searchDebounceTimer) {
    clearTimeout(searchDebounceTimer)
  }

  // Set new debounce timer
  searchDebounceTimer = setTimeout(() => {
    searchCustomers()
  }, SEARCH_DEBOUNCE_DELAY)
}

const searchCustomers = async () => {
  try {
    const query = searchQuery.value.trim()

    if (query.length < MIN_SEARCH_LENGTH) {
      searchResults.value = []
      showSearchSuggestions.value = query.length === 0
      return
    }

    loadingCustomers.value = true
    showSearchSuggestions.value = false

    logEvent('SEARCH_START', 'SUCCESS', `Searching: "${query}"`)

    const response = await safeApiCall('/Customers')
    const allCustomers = response.records || []

    // Filter customers based on search query
    searchResults.value = allCustomers
      .filter((customer) => {
        const searchFields = [
          customer.CompanyName,
          customer.FirstName,
          customer.LastName,
          customer.PhoneNumber,
          customer.CustomerCode,
          customer.Email,
        ]
          .filter(Boolean)
          .join(' ')
          .toLowerCase()

        return searchFields.includes(query.toLowerCase())
      })
      .slice(0, MAX_SEARCH_RESULTS)

    // Load credit accounts for results
    await loadCreditAccountsForResults()

    logEvent('SEARCH_COMPLETE', 'SUCCESS', `Found ${searchResults.value.length} customers`)
  } catch (error) {
    if (error.message !== 'Request cancelled') {
      console.error('Search error:', error)
      logEvent('SEARCH_ERROR', 'ERROR', error.message)
      searchResults.value = []
    }
  } finally {
    loadingCustomers.value = false
  }
}

const loadCreditAccountsForResults = async () => {
  try {
    const creditPromises = searchResults.value.map(async (customer) => {
      try {
        const response = await safeApiCall(
          `/CustomerCreditAccounts?CustomerID=${customer.CustomerID}`,
        )
        const accounts = response.records || []

        customer.creditAccount =
          accounts.find((acc) => acc.StationID === props.stationId || acc.StationID === null) ||
          null
      } catch (error) {
        customer.creditAccount = null
      }
    })

    await Promise.all(creditPromises)
  } catch (error) {
    console.error('Error loading credit accounts:', error)
  }
}

const selectCustomer = async (customer) => {
  try {
    if (props.disabled) return

    loadingCustomerDetails.value = customer.CustomerID

    logEvent('CUSTOMER_SELECTION', 'SUCCESS', `Selecting: ${customer.CustomerCode}`)

    // Load complete customer data
    const customerData = await loadCompleteCustomerData(customer.CustomerID)

    if (customerData) {
      selectedCustomer.value = customerData
      searchResults.value = []
      searchQuery.value = getCustomerDisplayName(customerData)

      emits('customer-selected', {
        customer: customerData,
        timestamp: new Date().toISOString(),
      })

      await Swal.fire({
        title: 'Customer Selected',
        text: `${getCustomerDisplayName(customerData)} selected`,
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    }
  } catch (error) {
    console.error('Selection error:', error)
    logEvent('SELECTION_ERROR', 'ERROR', error.message)

    await Swal.fire({
      title: 'Selection Error',
      text: 'Could not select customer. Please try again.',
      icon: 'error',
    })
  } finally {
    loadingCustomerDetails.value = null
  }
}

const loadCompleteCustomerData = async (customerId) => {
  try {
    // Load customer details
    const customer = await safeApiCall(`/Customers/${customerId}`)

    if (!customer) {
      throw new Error(`Customer ${customerId} not found`)
    }

    // Load credit account
    const creditResponse = await safeApiCall(`/CustomerCreditAccounts?CustomerID=${customerId}`)
    const creditAccounts = creditResponse.records || []

    customer.creditAccount =
      creditAccounts.find((acc) => acc.StationID === props.stationId || acc.StationID === null) ||
      null

    return customer
  } catch (error) {
    logEvent('DATA_LOAD_ERROR', 'ERROR', error.message)
    throw error
  }
}

const clearSelectedCustomer = () => {
  selectedCustomer.value = null
  searchQuery.value = ''
  searchResults.value = []
  logEvent('CUSTOMER_CLEARED', 'SUCCESS', 'Customer cleared')
  emits('customer-cleared')
}

const clearSearch = () => {
  searchQuery.value = ''
  searchResults.value = []
  showSearchSuggestions.value = true
}

const handleSearchFocus = () => {
  searchFocused.value = true
  if (searchQuery.value.length === 0) {
    showSearchSuggestions.value = true
  }
}

const handleSearchBlur = () => {
  searchFocused.value = false
  setTimeout(() => {
    if (!searchQuery.value) {
      showSearchSuggestions.value = false
    }
  }, 200)
}

const applySuggestion = (suggestion) => {
  searchQuery.value = suggestion
  showSearchSuggestions.value = false
  searchCustomers()
}

const createNewCustomer = async () => {
  await Swal.fire({
    title: 'Create New Customer',
    text: 'Customer creation feature will be available in the full system',
    icon: 'info',
  })
}

const loadCustomerStats = async () => {
  try {
    const [customersResponse, creditResponse] = await Promise.all([
      safeApiCall('/Customers'),
      safeApiCall('/CustomerCreditAccounts'),
    ])

    const customers = customersResponse.records || []
    const creditAccounts = creditResponse.records || []

    customerStats.totalCustomers = customers.length
    customerStats.activeAccounts = creditAccounts.filter((acc) => acc.IsActive === '1').length
    customerStats.totalCredit = creditAccounts.reduce(
      (sum, acc) => sum + parseFloat(acc.AvailableCredit || 0),
      0,
    )

    logEvent('STATS_LOADED', 'SUCCESS', `Stats: ${customerStats.totalCustomers} customers`)
  } catch (error) {
    console.error('Error loading stats:', error)
    logEvent('STATS_ERROR', 'ERROR', error.message)
  }
}

// ========== CLEANUP FUNCTIONS ==========
const cleanup = () => {
  // Clear any pending timers
  if (searchDebounceTimer) {
    clearTimeout(searchDebounceTimer)
    searchDebounceTimer = null
  }

  // Cancel any pending requests
  if (currentSearchController) {
    currentSearchController.abort()
    currentSearchController = null
  }
}

// ========== LIFECYCLE ==========
onMounted(async () => {
  console.log('🎯 CustomerManager Component Mounted')

  try {
    logEvent('COMPONENT_MOUNTED', 'SUCCESS', 'CustomerManager initialized')
    await loadCustomerStats()
    logEvent('COMPONENT_READY', 'SUCCESS', 'CustomerManager ready')
  } catch (error) {
    console.error('Mount error:', error)
    logEvent('MOUNT_ERROR', 'ERROR', error.message)
  }
})

onUnmounted(() => {
  cleanup()
  logEvent('COMPONENT_UNMOUNTED', 'SUCCESS', 'CustomerManager cleanup complete')
})
</script>

<style scoped>
/* iOS Premium Styling */
.customer-manager-container {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Gradient Backgrounds */
.bg-gradient-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.bg-gradient-success {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}

/* Touch Optimizations */
.btn {
  min-height: 44px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn:active {
  transform: scale(0.98);
}

.form-control {
  min-height: 44px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Card Enhancements */
.card {
  border-radius: 16px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Hover Effects */
.hover-bg-light:hover {
  background-color: #f8f9fa !important;
  transform: translateX(4px);
}

.cursor-pointer:active {
  transform: scale(0.98);
}

/* Progress Bar Styling */
.progress {
  background-color: rgba(255, 255, 255, 0.3);
  border-radius: 8px;
}

.progress-bar {
  border-radius: 8px;
  transition: width 0.3s ease;
}

/* Shadow Enhancements */
.shadow-sm {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
}

.shadow-lg {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12) !important;
}

/* Responsive Utilities */
.max-h-400px {
  max-height: 400px;
}

.max-h-200px {
  max-height: 200px;
}

.h-80px {
  height: 80px;
}

/* Animation Enhancements */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card {
  animation: slideIn 0.3s ease-out;
}

/* Text Enhancements */
.fs-9 {
  font-size: 0.75rem !important;
}

/* Input Focus States */
.form-control:focus {
  border-width: 2px;
  box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.15);
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .card-body {
    padding: 1rem !important;
  }

  .fs-2 {
    font-size: 1.5rem !important;
  }

  .symbol-50px {
    width: 40px !important;
    height: 40px !important;
  }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
</style>

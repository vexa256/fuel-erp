<template>
  <!-- CASH DRAWER MANAGEMENT MODAL - ULTRA PREMIUM iOS DESIGN -->
  <div v-if="show"
       class="modal fade show d-block"
       style="z-index: 1055; background: rgba(0,0,0,0.8);"
       @click.self="closeModal">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content border-0 shadow-xl" style="border-radius: 20px;">

        <!-- MODAL HEADER -->
        <div class="modal-header bg-gradient-primary border-0 position-relative" style="border-radius: 20px 20px 0 0;">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-dollar fs-1 text-white">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </div>
            <div>
              <h3 class="modal-title text-white fw-bold fs-2 mb-0">Cash Drawer Management</h3>
              <p class="text-white opacity-75 fs-7 mb-0">{{ currentDrawer?.Status || 'No Active Drawer' }} • {{ formatDateTime(new Date()) }}</p>
            </div>
          </div>
          <button @click="closeModal"
                  class="btn btn-icon btn-light-danger btn-sm position-absolute top-50 translate-middle-y"
                  style="right: 20px;">
            <i class="ki-duotone ki-cross fs-1">
              <span class="path1"></span><span class="path2"></span>
            </i>
          </button>
        </div>

        <!-- MODAL BODY -->
        <div class="modal-body p-0">

          <!-- DRAWER STATUS SECTION -->
          <div class="p-6 bg-light-primary">
            <div class="row g-4">
              <!-- CURRENT STATUS -->
              <div class="col-md-6">
                <div class="card bg-white border-0 h-100 shadow-sm">
                  <div class="card-body text-center p-4">
                    <div :class="['symbol', 'symbol-70px', 'symbol-circle', 'mx-auto', 'mb-3', getDrawerStatusBadgeClass()]">
                      <i :class="['ki-duotone', getDrawerStatusIcon(), 'fs-2x', 'text-white']">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                    </div>
                    <h4 class="fw-bold text-gray-800 mb-2">{{ currentDrawer?.Status || 'Closed' }}</h4>
                    <p class="text-gray-600 fs-7 mb-0">
                      {{ currentDrawer ? `Opened ${formatRelativeTime(currentDrawer.OpenedAt)}` : 'No active cash drawer' }}
                    </p>
                  </div>
                </div>
              </div>

              <!-- QUICK STATS -->
              <div class="col-md-6">
                <div class="card bg-white border-0 h-100 shadow-sm">
                  <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                      <span class="text-gray-700 fs-6">Opening Balance:</span>
                      <span class="fw-bold text-success fs-5">{{ formatCurrency(currentDrawer?.OpeningBalance || 0) }}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                      <span class="text-gray-700 fs-6">Cash Sales:</span>
                      <span class="fw-bold text-primary fs-5">{{ formatCurrency(currentDrawer?.CashSales || 0) }}</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                      <span class="text-gray-700 fs-6">Expected:</span>
                      <span class="fw-bold text-info fs-5">{{ formatCurrency(expectedCash) }}</span>
                    </div>
                    <div class="separator my-3"></div>
                    <div class="d-flex justify-content-between align-items-center">
                      <span class="fw-bold text-gray-800 fs-5">Variance:</span>
                      <span :class="['fw-bold', 'fs-4', getVarianceClass()]">{{ formatCurrency(variance) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- ACTION BUTTONS SECTION -->
          <div class="p-6">
            <div class="row g-3">
              <!-- OPEN DRAWER -->
              <div v-if="!currentDrawer || currentDrawer.Status === 'Closed'" class="col-md-6">
                <button @click="openDrawer"
                        :disabled="loading"
                        class="btn btn-light-success w-100 h-80px fw-bold fs-4">
                  <i class="ki-duotone ki-plus-circle fs-2x mb-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  <div>Open Drawer</div>
                </button>
              </div>

              <!-- COUNT CASH -->
              <div v-if="currentDrawer?.Status === 'Open'" class="col-md-6">
                <button @click="countCash"
                        :disabled="loading"
                        class="btn btn-light-primary w-100 h-80px fw-bold fs-4">
                  <i class="ki-duotone ki-calculator fs-2x mb-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  <div>Count Cash</div>
                </button>
              </div>

              <!-- CLOSE DRAWER -->
              <div v-if="currentDrawer?.Status === 'Open'" class="col-md-6">
                <button @click="closeDrawer"
                        :disabled="loading"
                        class="btn btn-light-warning w-100 h-80px fw-bold fs-4">
                  <i class="ki-duotone ki-lock fs-2x mb-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  <div>Close Drawer</div>
                </button>
              </div>

              <!-- VIEW HISTORY -->
              <div class="col-md-6">
                <button @click="viewHistory"
                        :disabled="loading"
                        class="btn btn-light-info w-100 h-80px fw-bold fs-4">
                  <i class="ki-duotone ki-time fs-2x mb-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  <div>View History</div>
                </button>
              </div>
            </div>
          </div>

          <!-- CASH COUNT SECTION (COLLAPSIBLE) -->
          <div v-if="showCashCount && currentDrawer?.Status === 'Open'" class="border-top bg-light-info">
            <div class="p-6">
              <h5 class="fw-bold text-gray-800 mb-4">
                <i class="ki-duotone ki-calculator text-primary fs-1 me-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                Cash Count Verification
              </h5>

              <!-- DENOMINATION COUNTER -->
              <div class="row g-3">
                <div v-for="denom in denominations" :key="denom.value" class="col-md-6 col-lg-4">
                  <div class="card bg-white border-primary">
                    <div class="card-body p-3">
                      <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="fw-bold text-gray-700">{{ formatCurrency(denom.value) }}</span>
                        <span class="badge badge-light-primary fs-8">{{ denom.type }}</span>
                      </div>
                      <div class="d-flex align-items-center gap-2">
                        <button @click="updateDenomination(denom.value, denom.count - 1)"
                                :disabled="denom.count <= 0"
                                class="btn btn-icon btn-light-danger btn-sm">
                          <i class="ki-duotone ki-minus fs-4">
                            <span class="path1"></span><span class="path2"></span>
                          </i>
                        </button>
                        <input v-model.number="denom.count"
                               @input="validateDenomination(denom)"
                               type="number"
                               min="0"
                               class="form-control form-control-sm text-center fw-bold"
                               style="max-width: 80px;">
                        <button @click="updateDenomination(denom.value, denom.count + 1)"
                                class="btn btn-icon btn-light-primary btn-sm">
                          <i class="ki-duotone ki-plus fs-4">
                            <span class="path1"></span><span class="path2"></span>
                          </i>
                        </button>
                      </div>
                      <div class="text-center mt-2">
                        <span class="text-success fw-bold fs-7">{{ formatCurrency(denom.value * denom.count) }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- COUNT SUMMARY -->
              <div class="card bg-light-success border-success mt-4">
                <div class="card-body p-4">
                  <div class="row text-center">
                    <div class="col-4">
                      <div class="fs-2 fw-bold text-success">{{ formatCurrency(countedCash) }}</div>
                      <div class="text-gray-600 fs-7">Counted Cash</div>
                    </div>
                    <div class="col-4">
                      <div class="fs-2 fw-bold text-primary">{{ formatCurrency(expectedCash) }}</div>
                      <div class="text-gray-600 fs-7">Expected Cash</div>
                    </div>
                    <div class="col-4">
                      <div :class="['fs-2', 'fw-bold', getVarianceClass()]">{{ formatCurrency(countVariance) }}</div>
                      <div class="text-gray-600 fs-7">Variance</div>
                    </div>
                  </div>
                  <div class="mt-3">
                    <button @click="saveCashCount"
                            :disabled="loading"
                            class="btn btn-success w-100 fw-bold">
                      <i class="ki-duotone ki-check fs-3 me-2">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      Save Cash Count
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>

      </div>
    </div>
  </div>

  <!-- LOADING OVERLAY -->
  <div v-if="loading"
       class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
       style="z-index: 9999; background: rgba(0,0,0,0.9);">
    <div class="card border-0 shadow-lg text-center" style="border-radius: 16px;">
      <div class="card-body p-5">
        <div class="spinner-border spinner-border-lg text-primary mb-3"></div>
        <h5 class="fw-bold text-gray-800 mb-2">{{ loadingMessage }}</h5>
        <p class="text-gray-600 fs-7">{{ loadingDetails }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, watch, onMounted } from 'vue'
import Swal from 'sweetalert2'

// ========== PROPS ==========
const props = defineProps({
  show: {
    type: Boolean,
    default: false
  },
  currentDrawer: {
    type: Object,
    default: null
  },
  stationId: {
    type: [String, Number],
    required: true
  },
  userId: {
    type: [String, Number],
    required: true
  }
})

// ========== EMITS ==========
const emit = defineEmits([
  'drawer-updated',
  'modal-closed',
  'verification-log-updated'
])

// ========== STATE ==========
const loading = ref(false)
const loadingMessage = ref('')
const loadingDetails = ref('')
const showCashCount = ref(false)

// Cash Counting
const denominations = reactive([
  { value: 50000, count: 0, type: 'Note' },
  { value: 20000, count: 0, type: 'Note' },
  { value: 10000, count: 0, type: 'Note' },
  { value: 5000, count: 0, type: 'Note' },
  { value: 2000, count: 0, type: 'Note' },
  { value: 1000, count: 0, type: 'Note' },
  { value: 500, count: 0, type: 'Coin' },
  { value: 200, count: 0, type: 'Coin' },
  { value: 100, count: 0, type: 'Coin' },
  { value: 50, count: 0, type: 'Coin' }
])

// ========== COMPUTED ==========
const expectedCash = computed(() => {
  const opening = parseFloat(props.currentDrawer?.OpeningBalance || 0)
  const sales = parseFloat(props.currentDrawer?.CashSales || 0)
  return opening + sales
})

const variance = computed(() => {
  const actual = parseFloat(props.currentDrawer?.ActualCash || 0)
  return actual - expectedCash.value
})

const countedCash = computed(() => {
  return denominations.reduce((total, denom) => {
    return total + (denom.value * denom.count)
  }, 0)
})

const countVariance = computed(() => {
  return countedCash.value - expectedCash.value
})

// ========== UTILITY FUNCTIONS ==========
const formatCurrency = (amount) => {
  const num = parseFloat(amount) || 0
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(num)
}

const formatDateTime = (date) => {
  return new Date(date).toLocaleString('en-UG', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const formatRelativeTime = (dateStr) => {
  const date = new Date(dateStr)
  const now = new Date()
  const diffMs = now - date
  const diffMins = Math.floor(diffMs / 60000)

  if (diffMins < 60) return `${diffMins} minutes ago`
  if (diffMins < 1440) return `${Math.floor(diffMins / 60)} hours ago`
  return `${Math.floor(diffMins / 1440)} days ago`
}

const getDrawerStatusBadgeClass = () => {
  const status = props.currentDrawer?.Status
  switch (status) {
    case 'Open': return 'bg-success'
    case 'Closed': return 'bg-danger'
    default: return 'bg-secondary'
  }
}

const getDrawerStatusIcon = () => {
  const status = props.currentDrawer?.Status
  switch (status) {
    case 'Open': return 'ki-unlock'
    case 'Closed': return 'ki-lock'
    default: return 'ki-question'
  }
}

const getVarianceClass = () => {
  const varianceAmount = countedCash.value ? countVariance.value : variance.value
  if (Math.abs(varianceAmount) < 100) return 'text-success'
  if (Math.abs(varianceAmount) < 1000) return 'text-warning'
  return 'text-danger'
}

const logEvent = (operation, status, details, data = null) => {
  const logEntry = {
    timestamp: new Date().toISOString(),
    operation,
    status,
    details,
    data,
    component: 'CashDrawerModal',
    userId: props.userId
  }

  emit('verification-log-updated', logEntry)
  console.log(`[CASH DRAWER ${status}] ${operation}: ${details}`, data)
}

// ========== ACTIONS ==========
const openDrawer = async () => {
  try {
    const result = await Swal.fire({
      title: 'Open Cash Drawer',
      html: `
        <div class="mb-3">
          <label class="form-label fw-bold">Opening Balance (UGX)</label>
          <input id="opening-balance" type="number" class="form-control form-control-lg text-center fs-4" value="100000" min="0">
        </div>
      `,
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Open Drawer',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#50cd89',
      preConfirm: () => {
        const balance = document.getElementById('opening-balance').value
        if (!balance || parseFloat(balance) < 0) {
          Swal.showValidationMessage('Please enter a valid opening balance')
          return false
        }
        return { openingBalance: parseFloat(balance) }
      }
    })

    if (result.isConfirmed) {
      loading.value = true
      loadingMessage.value = 'Opening Cash Drawer'
      loadingDetails.value = 'Initializing cash drawer for your shift...'

      // API call would go here
      await new Promise(resolve => setTimeout(resolve, 1500))

      const newDrawer = {
        DrawerID: Math.floor(Math.random() * 10000),
        StationID: props.stationId,
        AttendantID: props.userId,
        OpeningBalance: result.value.openingBalance.toString(),
        CashSales: '0.00',
        ActualCash: result.value.openingBalance.toString(),
        Status: 'Open',
        OpenedAt: new Date().toISOString(),
        OpenedBy: props.userId
      }

      emit('drawer-updated', { drawer: newDrawer, action: 'opened' })
      logEvent('DRAWER_OPENED', 'SUCCESS', `Cash drawer opened with ${formatCurrency(result.value.openingBalance)}`)

      await Swal.fire({
        title: 'Drawer Opened!',
        text: `Cash drawer is now open with ${formatCurrency(result.value.openingBalance)} opening balance`,
        icon: 'success',
        timer: 2000,
        showConfirmButton: false
      })
    }

  } catch (error) {
    console.error('Error opening drawer:', error)
    logEvent('DRAWER_OPEN_ERROR', 'ERROR', error.message)

    await Swal.fire({
      title: 'Error!',
      text: 'Failed to open cash drawer. Please try again.',
      icon: 'error',
      confirmButtonColor: '#f1416c'
    })
  } finally {
    loading.value = false
  }
}

const countCash = () => {
  showCashCount.value = !showCashCount.value

  if (showCashCount.value) {
    // Reset denominations
    denominations.forEach(denom => denom.count = 0)
    logEvent('CASH_COUNT_STARTED', 'SUCCESS', 'Cash counting interface opened')
  } else {
    logEvent('CASH_COUNT_CANCELLED', 'WARNING', 'Cash counting cancelled')
  }
}

const updateDenomination = (value, newCount) => {
  const denom = denominations.find(d => d.value === value)
  if (denom && newCount >= 0) {
    denom.count = Math.max(0, newCount)
  }
}

const validateDenomination = (denom) => {
  if (denom.count < 0) denom.count = 0
  if (isNaN(denom.count)) denom.count = 0
}

const saveCashCount = async () => {
  try {
    loading.value = true
    loadingMessage.value = 'Saving Cash Count'
    loadingDetails.value = 'Recording cash count and variance...'

    // API call would go here
    await new Promise(resolve => setTimeout(resolve, 1000))

    const updatedDrawer = {
      ...props.currentDrawer,
      ActualCash: countedCash.value.toString(),
      Variance: countVariance.value.toString(),
      CountedAt: new Date().toISOString()
    }

    emit('drawer-updated', { drawer: updatedDrawer, action: 'counted' })
    logEvent('CASH_COUNTED', 'SUCCESS', `Cash counted: ${formatCurrency(countedCash.value)}, Variance: ${formatCurrency(countVariance.value)}`)

    showCashCount.value = false

    await Swal.fire({
      title: 'Cash Count Saved!',
      html: `
        <div class="text-center">
          <div class="fs-3 fw-bold text-success mb-2">${formatCurrency(countedCash.value)}</div>
          <div class="text-gray-600 mb-2">Cash Counted</div>
          <div class="fs-6 ${Math.abs(countVariance.value) > 100 ? 'text-danger' : 'text-success'}">
            Variance: ${formatCurrency(countVariance.value)}
          </div>
        </div>
      `,
      icon: 'success',
      timer: 3000,
      showConfirmButton: false
    })

  } catch (error) {
    console.error('Error saving cash count:', error)
    logEvent('CASH_COUNT_ERROR', 'ERROR', error.message)
  } finally {
    loading.value = false
  }
}

const closeDrawer = async () => {
  try {
    const result = await Swal.fire({
      title: 'Close Cash Drawer?',
      html: `
        <div class="alert alert-warning">
          <i class="ki-duotone ki-information-5 fs-2 text-warning me-2">
            <span class="path1"></span><span class="path2"></span><span class="path3"></span>
          </i>
          This will close your cash drawer and end your shift. Make sure all cash has been counted.
        </div>
        <div class="mt-3">
          <div class="d-flex justify-content-between mb-2">
            <span>Expected Cash:</span>
            <span class="fw-bold">${formatCurrency(expectedCash.value)}</span>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span>Actual Cash:</span>
            <span class="fw-bold">${formatCurrency(props.currentDrawer?.ActualCash || 0)}</span>
          </div>
          <div class="d-flex justify-content-between">
            <span>Variance:</span>
            <span class="fw-bold ${Math.abs(variance.value) > 100 ? 'text-danger' : 'text-success'}">${formatCurrency(variance.value)}</span>
          </div>
        </div>
      `,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Close Drawer',
      cancelButtonText: 'Keep Open',
      confirmButtonColor: '#f1416c'
    })

    if (result.isConfirmed) {
      loading.value = true
      loadingMessage.value = 'Closing Cash Drawer'
      loadingDetails.value = 'Finalizing cash drawer and generating reports...'

      // API call would go here
      await new Promise(resolve => setTimeout(resolve, 2000))

      const closedDrawer = {
        ...props.currentDrawer,
        Status: 'Closed',
        ClosedAt: new Date().toISOString(),
        ClosedBy: props.userId,
        FinalVariance: variance.value.toString()
      }

      emit('drawer-updated', { drawer: closedDrawer, action: 'closed' })
      logEvent('DRAWER_CLOSED', 'SUCCESS', `Cash drawer closed with ${formatCurrency(variance.value)} variance`)

      await Swal.fire({
        title: 'Drawer Closed!',
        text: 'Cash drawer has been successfully closed and reports generated.',
        icon: 'success',
        timer: 2000,
        showConfirmButton: false
      })

      closeModal()
    }

  } catch (error) {
    console.error('Error closing drawer:', error)
    logEvent('DRAWER_CLOSE_ERROR', 'ERROR', error.message)
  } finally {
    loading.value = false
  }
}

const viewHistory = async () => {
  try {
    loading.value = true
    loadingMessage.value = 'Loading History'
    loadingDetails.value = 'Fetching cash drawer history...'

    // API call would go here
    await new Promise(resolve => setTimeout(resolve, 1000))

    // Generate sample history data
    const historyData = Array.from({ length: 5 }, (_, i) => ({
      date: new Date(Date.now() - i * 86400000).toISOString().split('T')[0],
      opening: Math.floor(Math.random() * 200000) + 50000,
      sales: Math.floor(Math.random() * 500000) + 100000,
      variance: Math.floor(Math.random() * 10000) - 5000
    }))

    const historyHtml = historyData.map(h => `
      <div class="d-flex justify-content-between border-bottom py-2">
        <div>
          <div class="fw-bold">${h.date}</div>
          <div class="fs-8 text-gray-600">Sales: ${formatCurrency(h.sales)}</div>
        </div>
        <div class="text-end">
          <div class="fw-bold">${formatCurrency(h.opening)}</div>
          <div class="fs-8 ${Math.abs(h.variance) > 1000 ? 'text-danger' : 'text-success'}">
            Var: ${formatCurrency(h.variance)}
          </div>
        </div>
      </div>
    `).join('')

    await Swal.fire({
      title: 'Cash Drawer History',
      html: `<div style="max-height: 300px; overflow-y: auto;">${historyHtml}</div>`,
      icon: 'info',
      confirmButtonText: 'Close',
      width: 600
    })

    logEvent('HISTORY_VIEWED', 'SUCCESS', 'Cash drawer history accessed')

  } catch (error) {
    console.error('Error loading history:', error)
    logEvent('HISTORY_ERROR', 'ERROR', error.message)
  } finally {
    loading.value = false
  }
}

const closeModal = () => {
  showCashCount.value = false
  emit('modal-closed')
}

// ========== LIFECYCLE ==========
onMounted(() => {
  logEvent('MODAL_OPENED', 'SUCCESS', 'Cash drawer modal opened')
})

// ========== WATCHERS ==========
watch(() => props.show, (newVal) => {
  if (newVal) {
    showCashCount.value = false
  }
})
</script>

<style scoped>
/* iOS Premium Modal Styling */
.modal-content {
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
}

/* Gradient Background */
.bg-gradient-primary {
  background: linear-gradient(135deg, #3699ff 0%, #1bc5bd 100%);
}

/* Button Enhancements */
.btn {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 12px;
}

.btn:active {
  transform: scale(0.98);
}

.h-80px {
  height: 80px;
}

/* Card Styling */
.card {
  border-radius: 16px;
  transition: all 0.3s ease;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

/* Symbol Styling */
.symbol {
  border-radius: 50%;
  overflow: hidden;
}

/* Separator */
.separator {
  border-bottom: 1px solid #e9ecef;
}

/* Input Styling */
.form-control {
  border-radius: 8px;
  border: 2px solid #e9ecef;
  transition: all 0.3s ease;
}

.form-control:focus {
  border-color: #3699ff;
  box-shadow: 0 0 0 0.2rem rgba(54, 153, 255, 0.25);
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .modal-dialog {
    margin: 1rem;
    max-width: calc(100% - 2rem);
  }

  .h-80px {
    height: 60px;
  }

  .fs-4 {
    font-size: 1rem !important;
  }
}

/* Animation */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-content {
  animation: slideIn 0.3s ease-out;
}

/* Loading Overlay */
.position-fixed {
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}
</style>

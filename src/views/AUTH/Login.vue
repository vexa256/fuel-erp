<template>
  <!-- Full Screen Login Modal Overlay - Covers Everything -->
  <div v-show="showLoginModal" class="login-modal-overlay position-fixed top-0 start-0 w-100 h-100 d-flex flex-column"
    id="kt_login_modal">
    <!-- Gradient Background -->
    <div class="position-absolute top-0 start-0 w-100 h-100 bg-gradient-primary opacity-90"></div>
    <div class="position-absolute top-0 start-0 w-100 h-100 bg-light-primary opacity-15"></div>

    <!-- Login Container -->
    <div class="d-flex flex-column flex-center flex-column-fluid position-relative">
      <!-- Main Login Card -->
      <div class="card card-flush shadow-lg w-100 mx-5 mx-lg-0" style="max-width: 500px; border-radius: 20px">
        <!-- Header Section -->
        <div class="card-header bg-primary d-flex flex-column align-items-center py-10"
          style="border-radius: 20px 20px 0 0">
          <!-- Logo Icon -->
          <div class="symbol symbol-80px mb-5">
            <div class="symbol-label bg-light-primary">
              <i class="ki-duotone ki-oil fs-1 text-primary">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
          </div>

          <!-- Brand Text -->
          <h1 class="text-white fw-bolder fs-2x mb-2">Cloud Fuel ERP</h1>
          <p class="text-white opacity-75 fs-5 mb-0">Advanced Cloud Fuel Station Management</p>
        </div>

        <!-- Login Form Body -->
        <div class="card-body p-10">
          <!-- Welcome Message -->
          <div class="text-center mb-8">
            <h2 class="text-gray-900 fw-bolder fs-2 mb-3">Welcome Back!</h2>
            <p class="text-gray-600 fs-6">Sign in to access your dashboard</p>
          </div>

          <!-- Login Form -->
          <form @submit.prevent="handleLogin" novalidate class="form w-100">
            <!-- Email Field -->
            <div class="mb-6">
              <label class="form-label fw-semibold text-gray-900 fs-6 required">Email Address</label>
              <div class="position-relative">
                <input v-model="loginForm.email" type="email" class="form-control form-control-lg form-control-solid"
                  :class="{ 'is-invalid': errors.email }" placeholder="Enter your email" autocomplete="email"
                  required />
                <i class="ki-duotone ki-sms position-absolute top-50 end-0 translate-middle-y me-3 fs-2 text-gray-500">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
              <div v-if="errors.email" class="invalid-feedback d-block">
                {{ errors.email }}
              </div>
            </div>

            <!-- Password Field -->
            <div class="mb-6">
              <label class="form-label fw-semibold text-gray-900 fs-6 required">Password</label>
              <div class="position-relative">
                <input v-model="loginForm.password" :type="showPassword ? 'text' : 'password'"
                  class="form-control form-control-lg form-control-solid" :class="{ 'is-invalid': errors.password }"
                  placeholder="Enter your password" autocomplete="current-password" required />
                <button type="button" @click="togglePassword"
                  class="btn btn-sm btn-icon position-absolute top-50 end-0 translate-middle-y me-3">
                  <i class="ki-duotone fs-2 text-gray-500" :class="showPassword ? 'ki-eye-slash' : 'ki-eye'">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </button>
              </div>
              <div v-if="errors.password" class="invalid-feedback d-block">
                {{ errors.password }}
              </div>
            </div>

            <!-- Remember Me -->
            <div class="d-flex flex-stack flex-wrap gap-3 mb-8">
              <div class="form-check form-check-sm form-check-custom form-check-solid">
                <input v-model="loginForm.rememberMe" class="form-check-input" type="checkbox" id="rememberMe" />
                <label class="form-check-label text-gray-700 fs-6" for="rememberMe">
                  Remember me
                </label>
              </div>

              <button type="button" class="link-primary fs-6 fw-bold text-decoration-none">
                Forgot Password?
              </button>
            </div>

            <!-- Login Button -->
            <div class="d-grid">
              <button type="submit" class="btn btn-lg btn-primary fw-bolder" :class="{ disabled: loading }"
                :disabled="loading">
                <span v-if="!loading">
                  <i class="ki-duotone ki-entrance-right fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Sign In
                </span>
                <span v-else class="d-flex align-items-center">
                  <span class="spinner-border spinner-border-sm me-2"></span>
                  Signing in...
                </span>
              </button>
            </div>
          </form>

          <!-- Security Notice -->
          <div class="text-center mt-8">
            <div class="badge badge-light-success py-3 px-4">
              <i class="ki-duotone ki-security-check fs-5 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Secure Enterprise Login
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div class="card-footer bg-light-primary text-center py-5" style="border-radius: 0 0 20px 20px">
          <p class="text-gray-600 fs-7 mb-2">© 2025 Kigrama Fuel Station Management System</p>
          <p class="text-gray-500 fs-8 mb-0">Powered by TrailBase & Vue.js</p>
        </div>
      </div>

      <!-- System Status Indicator -->
      <div class="position-fixed bottom-0 end-0 m-5">
        <div class="badge badge-circle badge-lg" :class="systemStatus.online ? 'badge-success' : 'badge-danger'">
          <i class="ki-duotone ki-wifi fs-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
            <span class="path5"></span>
          </i>
        </div>
      </div>
    </div>
  </div>

  <!-- Main App Content (Hidden until authenticated) -->
  <div v-show="isAuthenticated" class="main-app-content">
    <div class="d-flex flex-column min-vh-100 bg-light">
      <!-- Success Header -->
      <div class="bg-success text-white text-center py-8">
        <h1 class="text-white fw-bolder fs-1 mb-2">🎉 Login Successful!</h1>
        <p class="text-white opacity-75 fs-4">Welcome to Kigrama Fuel Station Management System</p>
      </div>

      <!-- Content Area -->
      <div class="flex-grow-1 d-flex flex-center">
        <div class="card shadow-lg w-100 mx-5" style="max-width: 600px">
          <div class="card-body text-center p-10">
            <i class="ki-duotone ki-check-circle fs-3x text-success mb-5">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <h3 class="text-gray-900 fw-bolder fs-2 mb-5">Authentication Complete</h3>
            <p class="text-gray-600 fs-5 mb-8">
              The full-screen login modal has been successfully hidden.<br />
              Your main application content would appear here.
            </p>

            <div class="row g-5">
              <div class="col-6">
                <div class="card card-flush bg-light-primary">
                  <div class="card-body text-center py-5">
                    <i class="ki-duotone ki-user fs-2x text-primary mb-3">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <h6 class="text-gray-900 fw-bold">User Data</h6>
                    <p class="text-gray-600 fs-7">Complete profile loaded</p>
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="card card-flush bg-light-success">
                  <div class="card-body text-center py-5">
                    <i class="ki-duotone ki-security-check fs-2x text-success mb-3">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <h6 class="text-gray-900 fw-bold">Permissions</h6>
                    <p class="text-gray-600 fs-7">Access rights verified</p>
                  </div>
                </div>
              </div>
            </div>

            <button @click="logout" class="btn btn-light-danger btn-lg mt-8">
              <i class="ki-duotone ki-exit-right fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Test Logout (Show Modal Again)
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
import Swal from 'sweetalert2'

// -- API Config --
const API_BASE_URL = 'http://localhost:4000/api/records/v1'

// -- Auth/Session --
const getAuthData = () => {
  try { const d = localStorage.getItem('kigrama_user_data'); return d ? JSON.parse(d) : null } catch { return null }
}
const getAuthToken = () => localStorage.getItem('kigrama_auth_token') || 'demo_token'

// -- State (as per UI) --
const loading = ref(false)
const processing = ref(false)
const currentUser = ref(null)
const currentStation = ref(null)
const products = ref([])
const productInventory = ref(new Map())
const selectedCategory = ref('fuel')
const productCategories = ref([
  { id: 'fuel', name: 'Fuel', icon: 'ki-oil-barrel' },
  { id: 'lubricants', name: 'Lubricants', icon: 'ki-oil' },
  { id: 'gas', name: 'Gas', icon: 'ki-gas-station' },
  { id: 'services', name: 'Services', icon: 'ki-wrench' }
])
const customerType = ref('walk-in')
const selectedCustomer = ref(null)
const showCustomerSearch = ref(false)
const customerSearchQuery = ref('')
const customerSearchResults = ref([])
const cartItems = ref([])
const taxRate = ref(18) // Uganda VAT
const paymentMethod = ref('Cash')
const cashReceived = ref(0)
const paymentReference = ref('')
const todayStats = reactive({ totalSales: 0, transactions: 0, revenue: 0, customers: 0 })
const salesChart = ref(null)
const showSettingsModal = ref(false)
const searchDebounceTimer = ref(null)
const MAX_QUANTITY = 10000
const MIN_QUANTITY = 0.01
const MAX_CASH_AMOUNT = 50000000

// -- Computed --
const filteredProducts = computed(() => {
  if (!products.value.length) return []
  return products.value.filter(product => {
    if (!product?.ProductType) return false
    const category = selectedCategory.value.toLowerCase()
    const type = product.ProductType.toLowerCase()
    switch (category) {
      case 'fuel': return type === 'fuel' || type.includes('petrol') || type.includes('diesel')
      case 'lubricants': return type.includes('lubricant') || type.includes('oil')
      case 'gas': return type.includes('gas') || type.includes('lpg')
      default: return !['fuel', 'petrol', 'diesel', 'lubricant', 'oil', 'gas', 'lpg'].some(t => type.includes(t))
    }
  })
})
const cartSubtotal = computed(() => cartItems.value.reduce((sum, item) => sum + (parseFloat(item.total) || 0), 0))
const cartTax = computed(() => cartSubtotal.value * (taxRate.value / 100))
const cartTotal = computed(() => cartSubtotal.value + cartTax.value)
const canProcessSale = computed(() => {
  if (!cartItems.value.length || processing.value) return false
  switch (paymentMethod.value) {
    case 'Cash': return cashReceived.value >= cartTotal.value && cashReceived.value <= MAX_CASH_AMOUNT
    case 'Card':
    case 'Mobile Money': return paymentReference.value.trim().length >= 3
    default: return false
  }
})
const getCashInputClass = computed(() => {
  if (cashReceived.value === 0) return ''
  if (cashReceived.value >= cartTotal.value) return 'border-success'
  return 'border-danger'
})

// -- Helpers --
const formatCurrency = amount => new Intl.NumberFormat('en-UG', { style: 'currency', currency: 'UGX', minimumFractionDigits: 0, maximumFractionDigits: 0 }).format(parseFloat(amount) || 0)
const getProductIcon = type => {
  if (!type) return 'ki-cube-2'
  const t = type.toLowerCase()
  if (t.includes('fuel') || t.includes('petrol') || t.includes('diesel')) return 'ki-oil-barrel'
  if (t.includes('lubricant') || t.includes('oil')) return 'ki-oil'
  if (t.includes('gas') || t.includes('lpg')) return 'ki-gas-station'
  return 'ki-cube-2'
}
const getStockLevel = product => parseFloat(productInventory.value.get(product.ProductID) || 0)
const getStockBadgeClass = stock => { const l = parseFloat(stock) || 0; if (l <= 100) return 'badge-light-danger'; if (l <= 500) return 'badge-light-warning'; return 'badge-light-success' }
const getCustomerDisplayName = customer => customer.CompanyName || `${customer.FirstName || ''} ${customer.LastName || ''}`.trim() || customer.CustomerCode
const validateNumber = (v, min = 0, max = Infinity) => { const n = parseFloat(v); return isNaN(n) ? min : Math.min(Math.max(n, min), max) }
const logError = async (user, station, op, error, details={}) => {
  // Log to AuditLogs and notify (never blocks UI)
  try {
    await apiCall('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify({
        UserID: user?.id || null,
        StationID: station?.StationID || null,
        Operation: op,
        Message: (error && error.message) ? error.message : JSON.stringify(error),
        Details: JSON.stringify(details),
        CreatedAt: new Date().toISOString()
      })
    })
  } catch (err) { console.error('Audit log failed:', err) }
}

// -- API: Strictly as per schema --
const apiCall = async (endpoint, options = {}) => {
  try {
    const controller = new AbortController()
    const timeoutId = setTimeout(() => controller.abort(), 30000)
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      signal: controller.signal,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${getAuthToken()}`,
        ...options.headers
      },
      ...options
    })
    clearTimeout(timeoutId)
    if (!response.ok) throw new Error(`API Error ${response.status}: ${await response.text().catch(() => 'Unknown error')}`)
    return await response.json()
  } catch (error) {
    throw error
  }
}

// -- Data Loaders --
const loadUserData = async () => {
  const authData = getAuthData()
  if (!authData?.user) throw new Error('No authentication data found')
  currentUser.value = authData.user
  if (authData.stations?.length > 0) currentStation.value = authData.stations.find(s => s.IsPrimary === '1') || authData.stations[0]
  else throw new Error('No stations assigned to user')
}
const loadProducts = async () => {
  loading.value = true
  try {
    const data = await apiCall('/Products')
    products.value = (data.records || []).filter(p => p.Status === 'Active' && p.Name && p.ProductType)
    await loadInventoryLevels()
  } catch (error) {
    await logError(currentUser.value, currentStation.value, 'loadProducts', error)
    throw error
  }
  loading.value = false
}
const loadInventoryLevels = async () => {
  if (!currentStation.value?.StationID || !products.value.length) return
  try {
    const data = await apiCall(`/StationInventory?StationID=${currentStation.value.StationID}`)
    const inventory = data.records || []
    productInventory.value.clear()
    inventory.forEach(item => { if (item.ProductID && item.CurrentStock !== undefined) productInventory.value.set(item.ProductID, item.CurrentStock) })
  } catch (error) {
    await logError(currentUser.value, currentStation.value, 'loadInventoryLevels', error)
    throw error
  }
}
const loadTodayStats = async () => {
  if (!currentStation.value?.StationID) return
  try {
    const today = new Date().toISOString().split('T')[0]
    const data = await apiCall(`/Transactions?StationID=${currentStation.value.StationID}&TransactionDate=${today}`)
    const tx = data.records || []
    todayStats.totalSales = tx.length
    todayStats.transactions = tx.length
    todayStats.revenue = tx.reduce((sum, t) => sum + parseFloat(t.TotalAmount || 0), 0)
    todayStats.customers = new Set(tx.map(t => t.CustomerID).filter(Boolean)).size
  } catch (error) {
    await logError(currentUser.value, currentStation.value, 'loadTodayStats', error)
  }
}

// -- POS CORE: Transaction Handler (FULL COMPLIANCE) --
const processSale = async () => {
  processing.value = true
  const opContext = { user: currentUser.value, station: currentStation.value, cart: cartItems.value }
  const now = new Date()
  const today = now.toISOString().split('T')[0]
  let fraudFlagged = false
  let fraudReasons = []
  let transactionId = null
  let auditId = null
  let approvalId = null

  try {
    // --- FRAUD/AI ---
    // 1. Transaction flood
    const recentSales = await apiCall(`/Transactions?StationID=${currentStation.value.StationID}&TransactionDate=${today}&HandledBy=${currentUser.value.id}&_sort=-CreatedAt&_limit=10`)
    if ((recentSales.records || []).length >= 10) {
      fraudFlagged = true; fraudReasons.push('Transaction flood')
    }
    // 2. Off-hours
    if (now.getHours() < 5 || now.getHours() > 23) { fraudFlagged = true; fraudReasons.push('Off-hours sale') }
    // 3. High-amount/quantity
    if (cartTotal.value > 5000000 || cartItems.value.some(i => i.quantity > 1000)) {
      fraudFlagged = true; fraudReasons.push('Unusually high value/quantity')
    }
    // 4. Role restriction
    const roles = (getAuthData()?.roles || []).map(r => r.Name)
    if (!roles.some(r => ['Sales', 'POS', 'Manager'].includes(r))) {
      fraudFlagged = true; fraudReasons.push('Role not allowed for POS sales')
    }
    // 5. Invalid pricing
    if (cartItems.value.some(item => item.unitPrice <= 0) || cartTax.value < 0) {
      fraudFlagged = true; fraudReasons.push('Invalid pricing/tax')
    }
    if (fraudFlagged) {
      await apiCall('/FraudDetectionLogs', {
        method: 'POST',
        body: JSON.stringify({
          StationID: currentStation.value.StationID,
          UserID: currentUser.value.id,
          Reason: fraudReasons.join('; '),
          DetectedAt: now.toISOString(),
          TransactionPayload: JSON.stringify(cartItems.value),
          Status: 'Flagged'
        })
      })
      await Swal.fire({
        title: 'Sale Blocked!',
        text: `Fraud risk detected: ${fraudReasons.join(', ')}`,
        icon: 'error', confirmButtonText: 'Close'
      })
      processing.value = false; return
    }

    // --- Attendance record (auto-check-in if not today) ---
    let attendanceId = null
    const attToday = await apiCall(`/Attendance?UserID=${currentUser.value.id}&Date=${today}`)
    if (!(attToday.records && attToday.records.length)) {
      const attRes = await apiCall('/Attendance', {
        method: 'POST',
        body: JSON.stringify({
          UserID: currentUser.value.id,
          StationID: currentStation.value.StationID,
          Date: today,
          CheckInTime: now.toISOString(),
          Status: 'Present'
        })
      })
      attendanceId = attRes.AttendanceID || attRes.id || null
    } else {
      attendanceId = attToday.records[0].AttendanceID
    }

    // --- DailyReadings (auto-log tank reading for every sale, simplified) ---
    for (const item of cartItems.value) {
      if (item.product.ProductType.toLowerCase().includes('fuel')) {
        // Simulate reading (actual UI would use real tank/pump sensors)
        await apiCall('/DailyReadings', {
          method: 'POST',
          body: JSON.stringify({
            StationID: currentStation.value.StationID,
            ProductID: item.product.ProductID,
            ReadingDate: today,
            MeasuredStock: getStockLevel(item.product) - item.quantity,
            CapturedBy: currentUser.value.id
          })
        })
      }
    }

    // --- Approval Workflow: Trigger for large sales (above 5M or >1000L) ---
    if (cartTotal.value > 5000000 || cartItems.value.some(i => i.quantity > 1000)) {
      const approvalRes = await apiCall('/Approvals', {
        method: 'POST',
        body: JSON.stringify({
          StationID: currentStation.value.StationID,
          RequesterID: currentUser.value.id,
          RequestType: 'POS Sale Approval',
          Reference: `TXN-REQ-${Date.now()}`,
          Status: 'Pending',
          Amount: cartTotal.value,
          CreatedAt: now.toISOString(),
        })
      })
      approvalId = approvalRes.ApprovalID || approvalRes.id || null
      await apiCall('/ApprovalActions', {
        method: 'POST',
        body: JSON.stringify({
          ApprovalID: approvalId,
          Action: 'Request',
          UserID: currentUser.value.id,
          Timestamp: now.toISOString(),
          Comments: 'Auto-escalated by POS AI'
        })
      })
    }

    // --- Create Transaction (exact schema) ---
    const transactionData = {
      StationID: currentStation.value.StationID,
      TransactionDate: today,
      TransactionType: 'Sale',
      TotalAmount: cartTotal.value.toFixed(2),
      TaxAmount: cartTax.value.toFixed(2),
      PaymentMethod: paymentMethod.value,
      PaymentReference: paymentReference.value || `TXN-${Date.now()}`,
      PaymentStatus: 'Paid',
      Status: 'Completed',
      HandledBy: currentUser.value.id,
      CustomerID: selectedCustomer.value?.CustomerID || null,
      Notes: approvalId ? `Approval: ${approvalId}` : 'POS Sale'
    }
    const transactionRes = await apiCall('/Transactions', { method: 'POST', body: JSON.stringify(transactionData) })
    transactionId = transactionRes.TransactionID || transactionRes.id || null

    // --- Create TransactionItems (one per product, exact schema) ---
    for (const item of cartItems.value) {
      const itemData = {
        TransactionID: transactionId,
        ProductID: item.product.ProductID,
        Quantity: item.quantity.toString(),
        UnitPrice: item.unitPrice.toFixed(2),
        SellingPrice: item.unitPrice.toFixed(2),
        TaxRate: taxRate.value.toString(),
        Subtotal: item.total.toFixed(2)
      }
      await apiCall('/TransactionItems', { method: 'POST', body: JSON.stringify(itemData) })
      // -- Inventory update (PATCH StationInventory exact) --
      const inventoryData = await apiCall(`/StationInventory?StationID=${currentStation.value.StationID}&ProductID=${item.product.ProductID}`)
      const inventory = inventoryData.records?.[0]
      if (inventory) {
        const newStock = Math.max(0, parseFloat(inventory.CurrentStock || 0) - item.quantity)
        await apiCall(`/StationInventory/${inventory.InventoryID}`, { method: 'PATCH', body: JSON.stringify({ CurrentStock: newStock.toString(), LastUpdated: now.toISOString() }) })
        productInventory.value.set(item.product.ProductID, newStock)
      }
    }

    // --- LedgerEntries (double-entry: Debit Sales, Credit Inventory) ---
    await apiCall('/LedgerEntries', {
      method: 'POST',
      body: JSON.stringify({
        TransactionID: transactionId,
        Account: 'Sales',
        Debit: cartTotal.value.toFixed(2),
        Credit: '0.00',
        Narration: `POS Sale by ${currentUser.value.name}`,
        CreatedAt: now.toISOString()
      })
    })
    await apiCall('/LedgerEntries', {
      method: 'POST',
      body: JSON.stringify({
        TransactionID: transactionId,
        Account: 'Inventory',
        Debit: '0.00',
        Credit: cartTotal.value.toFixed(2),
        Narration: `POS Sale by ${currentUser.value.name}`,
        CreatedAt: now.toISOString()
      })
    })

    // --- AuditLogs (record sale and all major events) ---
    const auditRes = await apiCall('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify({
        UserID: currentUser.value.id,
        StationID: currentStation.value.StationID,
        Operation: 'POS Sale',
        Message: `Sale completed: ${transactionId}`,
        Details: JSON.stringify({ cart: cartItems.value, payment: paymentMethod.value, approvalId }),
        CreatedAt: now.toISOString()
      })
    })
    auditId = auditRes.AuditLogID || auditRes.id || null

    // --- Notifications (to user/admin on big sale/approval) ---
    if (approvalId) {
      await apiCall('/Notifications', {
        method: 'POST',
        body: JSON.stringify({
          UserID: currentUser.value.id,
          StationID: currentStation.value.StationID,
          Title: 'High-value sale requires approval',
          Message: `POS sale of UGX ${formatCurrency(cartTotal.value)} is pending approval.`,
          RelatedID: approvalId,
          Type: 'Approval',
          CreatedAt: now.toISOString()
        })
      })
    }

    // --- Final User Notification ---
    await Swal.fire({
      title: 'Sale Completed!',
      html: `<div class="fw-bold fs-3 text-success mb-2">${formatCurrency(cartTotal.value)}</div><div class="text-gray-600">${paymentMethod.value} Payment</div>`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2500,
      showConfirmButton: false
    })

    // --- UI reset/refresh ---
    cartItems.value = []
    await Promise.all([loadInventoryLevels(), loadTodayStats()])

  } catch (error) {
    await logError(currentUser.value, currentStation.value, 'POS Sale Failed', error, opContext)
    await apiCall('/FraudDetectionLogs', {
      method: 'POST',
      body: JSON.stringify({
        StationID: currentStation.value.StationID,
        UserID: currentUser.value.id,
        Reason: 'Transaction failed: ' + (error && error.message ? error.message : JSON.stringify(error)),
        DetectedAt: new Date().toISOString(),
        TransactionPayload: JSON.stringify(cartItems.value),
        Status: 'Error'
      })
    })
    await Swal.fire({ title: 'Sale Failed', text: error.message || 'Could not process sale', icon: 'error', confirmButtonText: 'Close' })
  }
  processing.value = false
}

// --- Rest of UI logic: addToCart, removeFromCart, searchCustomers, payment/validation, and load lifecycle is as in previous scripts ---

// -- Lifecycle/Init --
onMounted(async () => {
  try {
    await loadUserData()
    await Promise.all([loadProducts(), loadTodayStats()])
    await nextTick()
    // You can include your ARM chart logic here
  } catch (error) {
    await Swal.fire({
      title: 'Initialization Failed', text: error.message || 'Unable to initialize POS system. Please contact support.',
      icon: 'error', confirmButtonText: 'Reload Page'
    }).then(() => { window.location.reload() })
  }
})
</script>


<template>
  <!-- COMPLETE FUEL POS SYSTEM - IOS PREMIUM DESIGN -->
  <div class="fuel-pos-system d-flex flex-column min-vh-100 bg-light">

    <!-- MAIN HEADER WITH LIVE STATS -->
    <div class="card border-0 rounded-0 bg-gradient-primary shadow-sm">
      <div class="card-body px-4 py-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-oil-barrel fs-1 text-white">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </div>
            <div>
              <h2 class="text-white fw-bold fs-3 mb-0">Kigrama Fuel POS</h2>
              <p class="text-white opacity-75 fs-7 mb-0">{{ currentUser?.name || 'Attendant' }} • {{ currentStation?.StationName || 'Station' }}</p>
            </div>
          </div>
          <div class="d-flex gap-2">
            <button @click="openCashDrawer" class="btn btn-light-success btn-sm">
              <i class="ki-duotone ki-dollar fs-3">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Cash Drawer
            </button>
            <button @click="openSystemSettings" class="btn btn-light-info btn-sm">
              <i class="ki-duotone ki-setting-2 fs-3">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Settings
            </button>
          </div>
        </div>

        <!-- LIVE STATS DASHBOARD -->
        <div class="row g-3">
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-dollar fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ formatShortCurrency(todayStats.revenue) }}</div>
                <div class="text-white opacity-75 fs-8">Revenue</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-oil-barrel fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ todayStats.fuelDispensed }}L</div>
                <div class="text-white opacity-75 fs-8">Fuel Sold</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-basket fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ todayStats.transactions }}</div>
                <div class="text-white opacity-75 fs-8">Sales</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-profile-user fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ todayStats.customers }}</div>
                <div class="text-white opacity-75 fs-8">Customers</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- CUSTOMER MANAGER SECTION -->
    <CustomerManager
      :disabled="processing"
      :station-id="currentStation?.StationID"
      :show-verification-log="showVerificationLogs"
      @customer-selected="handleCustomerSelected"
      @customer-cleared="handleCustomerCleared"
      @customer-type-changed="handleCustomerTypeChanged"
      @verification-log-updated="handleVerificationLog" />

    <!-- PRODUCT INVENTORY SECTION -->
    <ProductInventory
      :cart-items="cartItems"
      :station-id="currentStation?.StationID"
      :show-verification-log="showVerificationLogs"
      :disabled="processing"
      @product-selected="handleProductSelected"
      @add-to-cart="handleAddToCart"
      @verification-log-updated="handleVerificationLog"
      @inventory-updated="handleInventoryUpdated" />

    <!-- FUEL DISPENSER MODAL -->
    <FuelDispenser
      :show="showFuelDispenser"
      :selected-product="selectedProduct"
      :station-id="currentStation?.StationID"
      :show-verification-log="showVerificationLogs"
      @fuel-dispensed="handleFuelDispensed"
      @dispensing-cancelled="closeFuelDispenser"
      @verification-log-updated="handleVerificationLog"
      @step-changed="handleFuelDispenserStep" />

    <!-- SHOPPING CART SECTION -->
    <div v-if="cartItems.length > 0" class="card border-0 shadow-lg mb-3">
      <div class="card-body p-4">
        <!-- Cart Header -->
        <div class="d-flex align-items-center justify-content-between mb-3">
          <h5 class="fw-bold text-gray-800 mb-0">
            <i class="ki-duotone ki-basket text-warning fs-1 me-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            Shopping Cart ({{ cartItems.length }} items)
          </h5>
          <div class="d-flex gap-2">
            <button @click="clearCart" class="btn btn-light-danger btn-sm" :disabled="processing">
              <i class="ki-duotone ki-trash fs-3 me-1">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Clear
            </button>
            <button @click="toggleCartExpanded" class="btn btn-light-primary btn-sm">
              <i :class="['ki-duotone', cartExpanded ? 'ki-up' : 'ki-down', 'fs-3']">
                <span class="path1"></span><span class="path2"></span>
              </i>
              {{ cartExpanded ? 'Collapse' : 'Expand' }}
            </button>
          </div>
        </div>

        <!-- Cart Items (Expandable) -->
        <div v-if="cartExpanded" class="mb-3">
          <div v-for="(item, index) in cartItems"
               :key="`cart-${item.product.ProductID}-${index}`"
               class="card bg-light mb-2">
            <div class="card-body p-3">
              <div class="d-flex align-items-center gap-3">
                <!-- Product Info -->
                <div class="flex-grow-1">
                  <div class="fw-bold text-gray-800 fs-6 mb-1">{{ item.product.Name }}</div>
                  <div class="fs-8 text-gray-500">{{ formatCurrency(item.unitPrice) }} each</div>
                  <div v-if="item.tankInfo" class="fs-8 text-info">
                    {{ item.tankInfo.TankName }} → {{ item.pumpInfo.PumpName }}
                  </div>
                </div>

                <!-- Quantity Controls -->
                <div class="d-flex align-items-center gap-2">
                  <button @click="updateCartQuantity(index, item.quantity - 1)"
                          :disabled="processing"
                          class="btn btn-icon btn-light-danger btn-sm w-35px h-35px">
                    <i class="ki-duotone ki-minus fs-4">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                  <span class="fw-bold fs-5 text-center" style="min-width: 50px;">
                    {{ item.quantity }}{{ item.isFuel ? 'L' : '' }}
                  </span>
                  <button @click="updateCartQuantity(index, item.quantity + 1)"
                          :disabled="processing"
                          class="btn btn-icon btn-light-primary btn-sm w-35px h-35px">
                    <i class="ki-duotone ki-plus fs-4">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                </div>

                <!-- Item Total -->
                <div class="text-end">
                  <div class="fw-bold text-success fs-5">{{ formatCurrency(item.total) }}</div>
                  <button @click="removeFromCart(index)"
                          :disabled="processing"
                          class="btn btn-icon btn-light-danger btn-xs mt-1">
                    <i class="ki-duotone ki-trash fs-5">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Cart Summary -->
        <div class="card bg-light-primary border-primary">
          <div class="card-body p-3">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="text-gray-700 fs-6">Subtotal:</span>
              <span class="fw-bold fs-6">{{ formatCurrency(cartSubtotal) }}</span>
            </div>
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="text-gray-700 fs-6">Tax ({{ taxRate }}%):</span>
              <span class="fw-bold fs-6">{{ formatCurrency(cartTax) }}</span>
            </div>
            <div class="separator my-2"></div>
            <div class="d-flex justify-content-between align-items-center mb-3">
              <span class="fw-bold text-gray-800 fs-4">Total:</span>
              <span class="fw-bold text-success fs-3">{{ formatCurrency(cartTotal) }}</span>
            </div>

            <!-- Credit Validation Warning -->
            <div v-if="selectedCustomer?.creditAccount && cartTotal > parseFloat(selectedCustomer.creditAccount.AvailableCredit)"
                 class="alert alert-warning py-2 mb-3">
              <i class="ki-duotone ki-information fs-3 me-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
              <small>Exceeds available credit by {{ formatCurrency(cartTotal - parseFloat(selectedCustomer.creditAccount.AvailableCredit)) }}</small>
            </div>

            <!-- Checkout Button -->
            <button @click="openPaymentSheet"
                    :disabled="!canProceedToPayment || processing"
                    class="btn btn-primary w-100 h-60px fs-4 fw-bold">
              <i class="ki-duotone ki-credit-cart fs-1 me-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Proceed to Payment
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- PAYMENT MODAL -->
    <PaymentModal
      :show="showPaymentSheet"
      :cart-items="cartItems"
      :customer="selectedCustomer"
      :total-amount="cartTotal"
      :station-id="currentStation?.StationID"
      :current-cash-drawer="currentCashDrawer"
      @payment-completed="handlePaymentCompleted"
      @payment-cancelled="closePaymentSheet"
      @verification-log-updated="handleVerificationLog" />

    <!-- CASH DRAWER MODAL -->
    <CashDrawerModal
      :show="showCashDrawerModal"
      :current-drawer="currentCashDrawer"
      :station-id="currentStation?.StationID"
      :user-id="currentUser?.id"
      @drawer-updated="handleCashDrawerUpdated"
      @modal-closed="closeCashDrawer"
      @verification-log-updated="handleVerificationLog" />

    <!-- SYSTEM SETTINGS MODAL -->
    <SystemSettingsModal
      :show="showSettingsModal"
      :current-user="currentUser"
      :current-station="currentStation"
      :system-stats="systemStats"
      :verification-logs="allVerificationLogs"
      @settings-updated="handleSettingsUpdated"
      @modal-closed="closeSystemSettings"
      @logs-cleared="clearVerificationLogs" />

    <!-- VERIFICATION LOGS PANEL (DEVELOPMENT MODE) -->
    <div v-if="showVerificationLogs && allVerificationLogs.length > 0"
         class="card border-info bg-light-info position-fixed bottom-0 end-0 m-3"
         style="max-width: 400px; max-height: 300px; z-index: 1040;">
      <div class="card-header bg-info d-flex justify-content-between align-items-center">
        <h6 class="fw-bold text-white mb-0">
          <i class="ki-duotone ki-verify fs-3 me-2">
            <span class="path1"></span><span class="path2"></span>
          </i>
          System Verification Logs
        </h6>
        <button @click="toggleVerificationLogs" class="btn btn-icon btn-light btn-xs">
          <i class="ki-duotone ki-cross fs-4">
            <span class="path1"></span><span class="path2"></span>
          </i>
        </button>
      </div>
      <div class="card-body p-0 overflow-auto">
        <div v-for="(log, index) in allVerificationLogs.slice(-20)"
             :key="index"
             class="p-2 border-bottom border-light">
          <div class="d-flex justify-content-between">
            <span :class="['fs-8 fw-bold', getLogStatusClass(log.status)]">
              [{{ log.component }}] {{ log.operation }}
            </span>
            <span class="fs-9 text-gray-500">{{ formatLogTimestamp(log.timestamp) }}</span>
          </div>
          <div class="fs-9 text-gray-600">{{ log.details }}</div>
        </div>
      </div>
    </div>

    <!-- LOADING OVERLAY -->
    <div v-if="loading"
         class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
         style="z-index: 9999; background: rgba(0,0,0,0.8);">
      <div class="card border-0 shadow-lg text-center" style="border-radius: 16px;">
        <div class="card-body p-5">
          <div class="spinner-border spinner-border-lg text-primary mb-3"></div>
          <h5 class="fw-bold text-gray-800 mb-2">{{ loadingMessage }}</h5>
          <p class="text-gray-600 fs-7">{{ loadingDetails }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import Swal from 'sweetalert2'

// Import child components
import CustomerManager from '@/views/POS/CustomerManager.vue'
import ProductInventory from '@/views/POS/ProductInventory.vue'
import FuelDispenser from '@/views/POS/FuelDispenser.vue'
import PaymentModal from '@/views/POS/PaymentModal.vue'
import CashDrawerModal from '@/views/POS/CashDrawer.vue'
import SystemSettingsModal from '@/views/POS/SystemSettings.vue'

// ========== REACTIVE STATE ==========
const loading = ref(false)
const loadingMessage = ref('')
const loadingDetails = ref('')
const processing = ref(false)

// User & Session
const currentUser = ref(null)
const currentStation = ref(null)

// UI State
const showFuelDispenser = ref(false)
const showPaymentSheet = ref(false)
const showCashDrawerModal = ref(false)
const showSettingsModal = ref(false)
const showVerificationLogs = ref(true)

// Customer Management
const selectedCustomer = ref(null)
const customerType = ref('walk-in')

// Product & Fuel Dispensing
const selectedProduct = ref(null)

// Cart Management
const cartItems = ref([])
const cartExpanded = ref(true)
const taxRate = ref(18)

// Cash Drawer
const currentCashDrawer = ref(null)

// Verification & Logging
const allVerificationLogs = ref([])

// Auto-refresh timer
let statsRefreshTimer = null

// ========== REACTIVE STATS ==========
const todayStats = reactive({
  transactions: 0,
  revenue: 0,
  customers: 0,
  fuelDispensed: 0
})

const systemStats = reactive({
  products: 0,
  tanks: 0,
  pumps: 0,
  activeUsers: 0,
  systemUptime: 0
})

// ========== COMPUTED PROPERTIES ==========
const cartSubtotal = computed(() => {
  return cartItems.value.reduce((sum, item) => sum + (parseFloat(item.total) || 0), 0)
})

const cartTax = computed(() => {
  return cartSubtotal.value * (taxRate.value / 100)
})

const cartTotal = computed(() => {
  return cartSubtotal.value + cartTax.value
})

const canProceedToPayment = computed(() => {
  if (!cartItems.value.length) return false

  if (customerType.value === 'registered') {
    if (!selectedCustomer.value) return false
    if (selectedCustomer.value.creditAccount) {
      const availableCredit = parseFloat(selectedCustomer.value.creditAccount.AvailableCredit || 0)
      return cartTotal.value <= availableCredit
    }
    return false
  }

  return true
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

const formatShortCurrency = (amount) => {
  const num = parseFloat(amount) || 0
  if (num >= 1000000) return `${(num / 1000000).toFixed(1)}M`
  if (num >= 1000) return `${(num / 1000).toFixed(1)}K`
  return formatCurrency(num)
}

const formatLogTimestamp = (timestamp) => {
  return new Date(timestamp).toLocaleTimeString('en-US', {
    hour12: false,
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}

const getLogStatusClass = (status) => {
  switch (status) {
    case 'SUCCESS': return 'text-success'
    case 'WARNING': return 'text-warning'
    case 'ERROR': return 'text-danger'
    default: return 'text-info'
  }
}

const getAuthData = () => {
  try {
    const data = localStorage.getItem('kigrama_user_data')
    return data ? JSON.parse(data) : null
  } catch {
    return null
  }
}

// ========== CUSTOMER MANAGEMENT ==========
const handleCustomerSelected = (data) => {
  selectedCustomer.value = data.customer
  customerType.value = 'registered'

  logSystemEvent('CUSTOMER_SELECTED', 'SUCCESS', `Customer selected: ${data.customer.CustomerCode}`)
}

const handleCustomerCleared = () => {
  selectedCustomer.value = null
  customerType.value = 'walk-in'

  logSystemEvent('CUSTOMER_CLEARED', 'SUCCESS', 'Customer selection cleared')
}

const handleCustomerTypeChanged = (data) => {
  customerType.value = data.type

  logSystemEvent('CUSTOMER_TYPE_CHANGED', 'SUCCESS', `Customer type changed to: ${data.type}`)
}

// ========== PRODUCT & INVENTORY MANAGEMENT ==========
const handleProductSelected = (data) => {
  selectedProduct.value = data.product

  if (data.product.ProductType?.toLowerCase().includes('fuel')) {
    showFuelDispenser.value = true
  } else {
    handleAddToCart({
      product: data.product,
      quantity: 1
    })
  }

  logSystemEvent('PRODUCT_SELECTED', 'SUCCESS', `Product selected: ${data.product.Name}`)
}

const handleAddToCart = (data) => {
  try {
    const existingIndex = cartItems.value.findIndex(item =>
      item.product.ProductID === data.product.ProductID && !item.isFuel
    )

    if (existingIndex >= 0) {
      const currentQty = cartItems.value[existingIndex].quantity
      updateCartQuantity(existingIndex, currentQty + (data.quantity || 1))
    } else {
      const unitPrice = parseFloat(data.product.SellingPrice || data.product.UnitPrice || 0)
      const quantity = data.quantity || 1
      const total = unitPrice * quantity

      cartItems.value.push({
        product: { ...data.product },
        quantity,
        unitPrice,
        total,
        isFuel: false,
        addedAt: new Date().toISOString()
      })
    }

    logSystemEvent('ITEM_ADDED_TO_CART', 'SUCCESS', `${data.product.Name} added to cart`)

  } catch (error) {
    console.error('Error adding to cart:', error)
    logSystemEvent('ADD_TO_CART_ERROR', 'ERROR', error.message)
  }
}

const handleInventoryUpdated = (data) => {
  systemStats.products = data.products
  systemStats.tanks = data.tanks
  systemStats.pumps = data.pumps

  logSystemEvent('INVENTORY_UPDATED', 'SUCCESS', `Inventory refreshed: ${data.products} products`)
}

// ========== FUEL DISPENSING ==========
const handleFuelDispensed = (data) => {
  try {
    const fuelItem = {
      product: { ...data.product },
      quantity: data.quantity,
      unitPrice: data.unitPrice,
      total: data.totalCost,
      tankInfo: { ...data.tank },
      pumpInfo: { ...data.pump },
      isFuel: true,
      addedAt: new Date().toISOString()
    }

    cartItems.value.push(fuelItem)
    showFuelDispenser.value = false
    selectedProduct.value = null

    logSystemEvent('FUEL_DISPENSED', 'SUCCESS', `${data.quantity}L of ${data.product.Name} added to cart`)

  } catch (error) {
    console.error('Error handling fuel dispense:', error)
    logSystemEvent('FUEL_DISPENSE_ERROR', 'ERROR', error.message)
  }
}

const closeFuelDispenser = () => {
  showFuelDispenser.value = false
  selectedProduct.value = null
}

const handleFuelDispenserStep = (data) => {
  logSystemEvent('FUEL_DISPENSER_STEP', 'SUCCESS', `Fuel dispenser step ${data.step} (${data.direction})`)
}

// ========== CART MANAGEMENT ==========
const updateCartQuantity = (index, newQuantity) => {
  try {
    if (index < 0 || index >= cartItems.value.length) return

    const item = cartItems.value[index]
    const validQty = Math.max(0.01, parseFloat(newQuantity) || 0)

    if (validQty <= 0) {
      removeFromCart(index)
      return
    }

    item.quantity = validQty
    item.total = item.unitPrice * validQty

    logSystemEvent('CART_QUANTITY_UPDATED', 'SUCCESS', `Updated ${item.product.Name} quantity to ${validQty}`)

  } catch (error) {
    console.error('Error updating cart quantity:', error)
    logSystemEvent('CART_UPDATE_ERROR', 'ERROR', error.message)
  }
}

const removeFromCart = (index) => {
  try {
    if (index >= 0 && index < cartItems.value.length) {
      const item = cartItems.value[index]
      cartItems.value.splice(index, 1)

      if (cartItems.value.length === 0) {
        cartExpanded.value = false
      }

      logSystemEvent('ITEM_REMOVED_FROM_CART', 'SUCCESS', `Removed ${item.product.Name} from cart`)
    }
  } catch (error) {
    console.error('Error removing from cart:', error)
    logSystemEvent('CART_REMOVE_ERROR', 'ERROR', error.message)
  }
}

const clearCart = async () => {
  try {
    if (cartItems.value.length === 0) return

    const result = await Swal.fire({
      title: 'Clear Cart?',
      text: `Remove all ${cartItems.value.length} items from cart?`,
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Yes, Clear',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#f1416c',
      cancelButtonColor: '#6c757d'
    })

    if (result.isConfirmed) {
      const itemCount = cartItems.value.length
      cartItems.value = []
      cartExpanded.value = false

      logSystemEvent('CART_CLEARED', 'SUCCESS', `Cleared ${itemCount} items from cart`)

      await Swal.fire({
        title: 'Cart Cleared',
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 1500,
        showConfirmButton: false
      })
    }
  } catch (error) {
    console.error('Error clearing cart:', error)
    logSystemEvent('CART_CLEAR_ERROR', 'ERROR', error.message)
  }
}

const toggleCartExpanded = () => {
  cartExpanded.value = !cartExpanded.value
}

// ========== PAYMENT PROCESSING ==========
const openPaymentSheet = () => {
  if (cartItems.value.length === 0) return
  showPaymentSheet.value = true

  logSystemEvent('PAYMENT_SHEET_OPENED', 'SUCCESS', `Payment initiated for ${formatCurrency(cartTotal.value)}`)
}

const closePaymentSheet = () => {
  showPaymentSheet.value = false
}

const handlePaymentCompleted = async (data) => {
  try {
    processing.value = true

    logSystemEvent('PAYMENT_COMPLETED', 'SUCCESS', `Payment completed: ${data.transactionId}`)

    // Clear cart and reset customer
    cartItems.value = []
    cartExpanded.value = false
    selectedCustomer.value = null
    customerType.value = 'walk-in'

    // Close payment sheet
    showPaymentSheet.value = false

    // Update stats
    await loadTodayStats()

    await Swal.fire({
      title: 'Sale Completed!',
      html: `
        <div class="text-center">
          <div class="fs-2 fw-bold text-success mb-2">${formatCurrency(data.totalAmount)}</div>
          <div class="text-gray-600 mb-2">Transaction #${data.transactionId}</div>
          <div class="fs-7 text-gray-500">${data.paymentMethod} Payment</div>
        </div>
      `,
      icon: 'success',
      confirmButtonText: 'Continue',
      timer: 3000
    })

  } catch (error) {
    console.error('Error handling payment completion:', error)
    logSystemEvent('PAYMENT_COMPLETION_ERROR', 'ERROR', error.message)
  } finally {
    processing.value = false
  }
}

// ========== CASH DRAWER MANAGEMENT ==========
const openCashDrawer = () => {
  showCashDrawerModal.value = true
}

const closeCashDrawer = () => {
  showCashDrawerModal.value = false
}

const handleCashDrawerUpdated = async (data) => {
  currentCashDrawer.value = data.drawer

  logSystemEvent('CASH_DRAWER_UPDATED', 'SUCCESS', `Cash drawer ${data.action}`)

  // Refresh today stats
  await loadTodayStats()
}

// ========== SYSTEM SETTINGS ==========
const openSystemSettings = () => {
  showSettingsModal.value = true
}

const closeSystemSettings = () => {
  showSettingsModal.value = false
}

const handleSettingsUpdated = (data) => {
  logSystemEvent('SETTINGS_UPDATED', 'SUCCESS', `Settings updated: ${data.setting}`)
}

// ========== VERIFICATION & LOGGING ==========
const handleVerificationLog = (logEntry) => {
  allVerificationLogs.value.push(logEntry)

  // Keep only last 500 entries
  if (allVerificationLogs.value.length > 500) {
    allVerificationLogs.value = allVerificationLogs.value.slice(-500)
  }
}

const logSystemEvent = (operation, status, details, data = null) => {
  const logEntry = {
    timestamp: new Date().toISOString(),
    operation,
    status,
    details,
    data,
    component: 'FuelPOS-Main',
    userId: currentUser.value?.id
  }

  allVerificationLogs.value.push(logEntry)
  console.log(`[FUEL POS ${status}] ${operation}: ${details}`, data)
}

const toggleVerificationLogs = () => {
  showVerificationLogs.value = !showVerificationLogs.value
}

const clearVerificationLogs = () => {
  allVerificationLogs.value = []
  logSystemEvent('VERIFICATION_LOGS_CLEARED', 'SUCCESS', 'All verification logs cleared')
}

// ========== DATA LOADING ==========
const loadUserData = async () => {
  try {
    const authData = getAuthData()
    if (!authData?.user) {
      throw new Error('No authentication data found')
    }

    currentUser.value = authData.user

    if (authData.stations?.length > 0) {
      currentStation.value = authData.stations.find(s => s.IsPrimary === '1') || authData.stations[0]
    } else {
      throw new Error('No stations assigned to user')
    }

    logSystemEvent('USER_DATA_LOADED', 'SUCCESS', `User: ${currentUser.value.name}, Station: ${currentStation.value.StationName}`)

  } catch (error) {
    console.error('Error loading user data:', error)
    logSystemEvent('USER_DATA_LOAD_ERROR', 'ERROR', error.message)
    throw error
  }
}

const loadTodayStats = async () => {
  try {
    if (!currentStation.value?.StationID) return

    const today = new Date().toISOString().split('T')[0]

    // This would typically call your API
    // For now, using simulated data
    todayStats.transactions = Math.floor(Math.random() * 50) + 20
    todayStats.revenue = Math.floor(Math.random() * 5000000) + 1000000
    todayStats.customers = Math.floor(Math.random() * 30) + 10
    todayStats.fuelDispensed = Math.floor(Math.random() * 2000) + 500

    logSystemEvent('TODAY_STATS_LOADED', 'SUCCESS', `Stats loaded: ${todayStats.transactions} transactions, ${formatShortCurrency(todayStats.revenue)} revenue`)

  } catch (error) {
    console.error('Error loading today stats:', error)
    logSystemEvent('TODAY_STATS_ERROR', 'ERROR', error.message)
  }
}

const loadSystemStats = async () => {
  try {
    // This would typically call your API
    // For now, using simulated data
    systemStats.products = Math.floor(Math.random() * 50) + 20
    systemStats.tanks = Math.floor(Math.random() * 10) + 5
    systemStats.pumps = Math.floor(Math.random() * 15) + 8
    systemStats.activeUsers = Math.floor(Math.random() * 5) + 2
    systemStats.systemUptime = Math.floor(Math.random() * 24) + 1

    logSystemEvent('SYSTEM_STATS_LOADED', 'SUCCESS', 'System statistics updated')

  } catch (error) {
    console.error('Error loading system stats:', error)
    logSystemEvent('SYSTEM_STATS_ERROR', 'ERROR', error.message)
  }
}

const loadCurrentCashDrawer = async () => {
  try {
    if (!currentStation.value?.StationID) return

    // This would typically call your API to get current cash drawer
    // For now, using simulated data
    const hasDrawer = Math.random() > 0.3

    if (hasDrawer) {
      currentCashDrawer.value = {
        DrawerID: Math.floor(Math.random() * 1000),
        StationID: currentStation.value.StationID,
        AttendantID: currentUser.value.id,
        OpeningBalance: '100000.00',
        CashSales: (Math.random() * 500000).toFixed(2),
        Status: 'Open',
        OpenedAt: new Date().toISOString()
      }
    }

    logSystemEvent('CASH_DRAWER_LOADED', 'SUCCESS', hasDrawer ? 'Cash drawer found' : 'No active cash drawer')

  } catch (error) {
    console.error('Error loading cash drawer:', error)
    logSystemEvent('CASH_DRAWER_ERROR', 'ERROR', error.message)
  }
}

// ========== AUTO-REFRESH ==========
const startAutoRefresh = () => {
  statsRefreshTimer = setInterval(async () => {
    await Promise.all([
      loadTodayStats(),
      loadSystemStats()
    ])
  }, 30000) // Refresh every 30 seconds
}

const stopAutoRefresh = () => {
  if (statsRefreshTimer) {
    clearInterval(statsRefreshTimer)
    statsRefreshTimer = null
  }
}

// ========== INITIALIZATION ==========
const initializePOS = async () => {
  try {
    loading.value = true
    loadingMessage.value = 'Initializing Fuel POS System'
    loadingDetails.value = 'Loading user data and system configuration...'

    await loadUserData()

    loadingDetails.value = 'Loading today\'s statistics and cash drawer...'
    await Promise.all([
      loadTodayStats(),
      loadSystemStats(),
      loadCurrentCashDrawer()
    ])

    loadingDetails.value = 'Starting auto-refresh services...'
    startAutoRefresh()

    logSystemEvent('POS_INITIALIZED', 'SUCCESS', 'Fuel POS system initialized successfully')

    await Swal.fire({
      title: 'Fuel POS Ready',
      text: `Welcome ${currentUser.value.name}! System is ready for operations.`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false
    })

  } catch (error) {
    console.error('POS initialization error:', error)
    logSystemEvent('POS_INIT_ERROR', 'ERROR', error.message)

    await Swal.fire({
      title: 'Initialization Failed',
      text: error.message || 'Unable to initialize Fuel POS system. Please contact support.',
      icon: 'error',
      confirmButtonText: 'Retry'
    }).then(() => {
      window.location.reload()
    })
  } finally {
    loading.value = false
  }
}

// ========== LIFECYCLE ==========
onMounted(async () => {
  console.log('⛽ Kigrama Fuel POS System Loading...')

  try {
    await initializePOS()
    console.log('✅ Kigrama Fuel POS System Ready!')

  } catch (error) {
    console.error('❌ Fuel POS System Failed to Load:', error)
  }
})

onUnmounted(() => {
  stopAutoRefresh()
  logSystemEvent('POS_SHUTDOWN', 'SUCCESS', 'Fuel POS system shutdown')
})
</script>

<style scoped>
/* iOS Premium Styling */
.fuel-pos-system {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Gradient Backgrounds */
.bg-gradient-primary {
  background: linear-gradient(135deg, #3699ff 0%, #1bc5bd 100%);
}

/* Touch Optimizations */
.btn {
  min-height: 44px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn:active {
  transform: scale(0.98);
}

/* Card Enhancements */
.card {
  border-radius: 16px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Symbol & Badge Styling */
.symbol {
  border-radius: 50%;
  overflow: hidden;
}

/* Shadow Enhancements */
.shadow-sm {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
}

.shadow-lg {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12) !important;
}

/* Utility Classes */
.w-35px {
  width: 35px;
}

.h-35px {
  height: 35px;
}

.h-60px {
  height: 60px;
}

/* Separator */
.separator {
  border-bottom: 1px solid #e9ecef;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .card-body {
    padding: 1rem !important;
  }

  .fs-3 {
    font-size: 1.25rem !important;
  }

  .symbol-50px {
    width: 40px !important;
    height: 40px !important;
  }
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

/* Loading Overlay */
.position-fixed {
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
</style>

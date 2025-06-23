<template>
  <div class="d-flex flex-column min-vh-100 bg-light-primary gap-5">
    <!-- HEADER -->
    <div class="card card-flush bg-primary mb-0 rounded-0 border-0">
      <div class="card-body py-4 d-flex align-items-center justify-content-between">
        <div class="d-flex align-items-center gap-3">
          <i class="ki-duotone ki-gas-station fs-1 text-white"><span class="path1"></span><span
              class="path2"></span></i>
          <div>
            <h3 class="text-white fw-bold fs-3 mb-0">{{ currentStation?.StationName || 'POS' }}</h3>
            <span class="text-white opacity-75 fs-7">{{ currentUser?.name }}</span>
          </div>
        </div>
        <button @click="showSettings" class="btn btn-icon btn-light-info btn-sm" aria-label="Settings">
          <i class="ki-duotone ki-setting-2 fs-2"><span class="path1"></span><span class="path2"></span></i>
        </button>
      </div>
    </div>
    <!-- QUICK STATS -->
    <div class="px-4">
      <div class="row g-3">
        <div class="col-3">
          <div class="card card-flush bg-light-success shadow-sm text-center">
            <div class="card-body py-3">
              <div class="fs-2 fw-bold text-success">{{ todayStats.totalSales }}</div>
              <div class="fs-8 text-success opacity-75">Sales</div>
            </div>
          </div>
        </div>
        <div class="col-3">
          <div class="card card-flush bg-light-warning shadow-sm text-center">
            <div class="card-body py-3">
              <div class="fs-2 fw-bold text-warning">{{ todayStats.transactions }}</div>
              <div class="fs-8 text-warning opacity-75">Trans</div>
            </div>
          </div>
        </div>
        <div class="col-3">
          <div class="card card-flush bg-light-info shadow-sm text-center">
            <div class="card-body py-3">
              <div class="fs-2 fw-bold text-info">{{ formatCurrency(todayStats.revenue) }}</div>
              <div class="fs-8 text-info opacity-75">Revenue</div>
            </div>
          </div>
        </div>
        <div class="col-3">
          <div class="card card-flush bg-light-danger shadow-sm text-center">
            <div class="card-body py-3">
              <div class="fs-2 fw-bold text-danger">{{ todayStats.customers }}</div>
              <div class="fs-8 text-danger opacity-75">Clients</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- ARM ANALYTICS: SALES CHART -->
    <div class="px-4">
      <div class="card card-flush shadow-sm mb-2">
        <div class="card-header">
          <h4 class="card-title fw-bold"><i class="ki-duotone ki-chart-line text-success fs-1 me-2"><span
                class="path1"></span><span class="path2"></span></i>Sales Trend</h4>
        </div>
        <div class="card-body">
          <canvas ref="salesChart" width="400" height="120" aria-label="Sales ARM"></canvas>
        </div>
      </div>
    </div>
    <!-- MAIN CONTENT -->
    <div class="flex-grow-1 px-4 pb-4">
      <div class="row g-3">
        <!-- PRODUCT PANEL -->
        <div class="col-12 col-lg-7">
          <div class="card card-flush mb-3 shadow-sm">
            <div class="card-body p-3">
              <div class="d-flex align-items-center justify-content-between mb-3">
                <h4 class="fw-bold text-gray-800 mb-0"><i class="ki-duotone ki-oil-barrel text-primary fs-1 me-2"><span
                      class="path1"></span><span class="path2"></span></i>Select Products</h4>
                <button @click="refreshProducts" class="btn btn-light-primary btn-sm" :disabled="loading"><i
                    class="ki-duotone ki-arrows-circle fs-3"><span class="path1"></span><span
                      class="path2"></span></i></button>
              </div>
              <div class="d-flex gap-2 mb-3 overflow-auto" role="tablist">
                <button v-for="category in productCategories" :key="category.id" @click="selectedCategory = category.id"
                  :class="['btn', 'btn-sm', 'flex-shrink-0', selectedCategory === category.id ? 'btn-primary' : 'btn-light-primary']"
                  :aria-selected="selectedCategory === category.id">
                  <i :class="['ki-duotone', category.icon, 'fs-3', 'me-1']"><span class="path1"></span><span
                      class="path2"></span></i>{{ category.name }}
                </button>
              </div>
              <div v-if="loading" class="text-center py-5">
                <div class="spinner-border spinner-border-lg text-primary"></div>
                <div class="mt-2 text-gray-600">Loading products...</div>
              </div>
              <div v-else class="row g-2">
                <div v-for="product in filteredProducts" :key="product.ProductID" class="col-6 col-md-4 col-lg-3">
                  <div @click="addToCart(product)" class="card card-flush h-100 cursor-pointer position-relative"
                    :class="{ 'border-primary': isProductInCart(product.ProductID), 'border-danger': getStockLevel(product) <= 0 }"
                    :aria-label="product.Name" :aria-disabled="getStockLevel(product) <= 0" style="min-height:120px">
                    <div class="card-body p-2 text-center">
                      <i :class="['ki-duotone', getProductIcon(product.ProductType), 'fs-2x', 'text-primary', 'mb-2']"><span
                          class="path1"></span><span class="path2"></span></i>
                      <h6 class="fw-bold text-gray-800 mb-1 fs-7">{{ product.Name }}</h6>
                      <div class="fs-5 fw-bold text-success">{{ formatCurrency(product.SellingPrice ||
                        product.UnitPrice) }}</div>
                      <div class="fs-8 text-gray-500">{{ product.ProductType }}</div>
                      <span class="badge badge-sm" :class="getStockBadgeClass(getStockLevel(product))">{{
                        getStockLevel(product) }}L</span>
                      <div v-if="getStockLevel(product) <= 0"
                        class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center bg-danger bg-opacity-10 rounded">
                        <span class="badge badge-danger">OUT OF STOCK</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div v-if="!loading && filteredProducts.length === 0" class="text-center py-5">
                <i class="ki-duotone ki-information-4 fs-3x text-gray-400 mb-2"><span class="path1"></span><span
                    class="path2"></span></i>
                <div class="text-gray-600">No products in this category</div>
              </div>
            </div>
          </div>
        </div>
        <!-- CART + PAYMENT -->
        <div class="col-12 col-lg-5">
          <!-- CUSTOMER -->
          <div class="card card-flush mb-3 shadow-sm">
            <div class="card-body p-3">
              <h5 class="fw-bold text-gray-800 mb-2"><i class="ki-duotone ki-profile-user text-info fs-1 me-2"><span
                    class="path1"></span><span class="path2"></span></i>Customer</h5>
              <div class="d-flex gap-2 mb-2">
                <button @click="setCustomerType('walk-in')"
                  :class="['btn', 'flex-fill', customerType === 'walk-in' ? 'btn-success' : 'btn-light-success']"><i
                    class="ki-duotone ki-user-tick fs-3 me-1"><span class="path1"></span><span
                      class="path2"></span></i>Walk-in</button>
                <button @click="setCustomerType('registered')"
                  :class="['btn', 'flex-fill', customerType === 'registered' ? 'btn-info' : 'btn-light-info']"><i
                    class="ki-duotone ki-address-book fs-3 me-1"><span class="path1"></span><span
                      class="path2"></span></i>Registered</button>
              </div>
              <div v-if="selectedCustomer" class="bg-light-info p-2 rounded mb-2">
                <div class="fw-bold text-info">{{ getCustomerDisplayName(selectedCustomer) }}</div>
                <div class="fs-8 text-info opacity-75">{{ selectedCustomer.CustomerCode }}</div>
              </div>
              <div v-if="showCustomerSearch" class="mb-2">
                <input v-model="customerSearchQuery" @input="searchCustomers" type="text"
                  class="form-control form-control-lg" placeholder="Search by name, phone, or code..."
                  :disabled="loadingCustomers" />
                <div v-if="loadingCustomers" class="mt-2 text-center">
                  <div class="spinner-border spinner-border-sm text-primary"></div>
                </div>
                <div v-else-if="customerSearchResults.length" class="mt-2 max-h-200px overflow-auto">
                  <div v-for="customer in customerSearchResults" :key="customer.CustomerID"
                    @click="selectCustomer(customer)" class="p-2 border rounded cursor-pointer hover-bg-light mb-1">
                    <div class="fw-bold">{{ getCustomerDisplayName(customer) }}</div>
                    <div class="fs-8 text-gray-500">{{ customer.PhoneNumber }} • {{ customer.CustomerCode }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- CART -->
          <div class="card card-flush mb-3 shadow-sm">
            <div class="card-header">
              <h5 class="card-title fw-bold"><i class="ki-duotone ki-basket text-warning fs-1 me-2"><span
                    class="path1"></span><span class="path2"></span></i>Cart ({{ cartItems.length }})</h5>
              <button v-if="cartItems.length" @click="clearCart" class="btn btn-light-danger btn-sm"><i
                  class="ki-duotone ki-trash fs-3"><span class="path1"></span><span
                    class="path2"></span></i>Clear</button>
            </div>
            <div class="card-body p-0">
              <div v-if="!cartItems.length" class="p-4 text-center text-gray-500"><i
                  class="ki-duotone ki-basket fs-2x text-gray-400 mb-3"><span class="path1"></span><span
                    class="path2"></span></i>
                <div>No items in cart</div>
              </div>
              <div v-for="(item, index) in cartItems" :key="`cart-${index}-${item.product.ProductID}`"
                class="p-2 border-bottom">
                <div class="d-flex align-items-center justify-content-between mb-1">
                  <div class="fw-bold text-gray-800">{{ item.product.Name }}</div>
                  <button @click="removeFromCart(index)" class="btn btn-icon btn-light-danger btn-xs"><i
                      class="ki-duotone ki-cross fs-4"><span class="path1"></span><span
                        class="path2"></span></i></button>
                </div>
                <div class="d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center gap-2">
                    <button @click="updateQuantity(index, Math.max(0.01, item.quantity - 1))"
                      class="btn btn-icon btn-light-primary btn-xs"><i class="ki-duotone ki-minus fs-5"><span
                          class="path1"></span><span class="path2"></span></i></button>
                    <input :value="item.quantity" @blur="validateAndUpdateQuantity(index, $event.target.value)"
                      @keyup.enter="validateAndUpdateQuantity(index, $event.target.value)" type="number" min="0.01"
                      step="0.01" class="form-control form-control-sm text-center" style="width:70px;" />
                    <button @click="updateQuantity(index, item.quantity + 1)"
                      class="btn btn-icon btn-light-primary btn-xs"><i class="ki-duotone ki-plus fs-5"><span
                          class="path1"></span><span class="path2"></span></i></button>
                  </div>
                  <div class="text-end">
                    <div class="fw-bold text-success">{{ formatCurrency(item.total) }}</div>
                    <div class="fs-8 text-gray-500">@ {{ formatCurrency(item.unitPrice) }}</div>
                  </div>
                </div>
              </div>
              <div v-if="cartItems.length" class="p-3 bg-light-primary">
                <div class="d-flex justify-content-between mb-1"><span class="text-gray-600">Subtotal:</span><span
                    class="fw-bold">{{ formatCurrency(cartSubtotal) }}</span></div>
                <div class="d-flex justify-content-between mb-1"><span class="text-gray-600">Tax ({{ taxRate
                    }}%):</span><span class="fw-bold">{{ formatCurrency(cartTax) }}</span></div>
                <div class="separator my-2"></div>
                <div class="d-flex justify-content-between"><span class="fw-bold text-gray-800 fs-4">Total:</span><span
                    class="fw-bold text-success fs-3">{{ formatCurrency(cartTotal) }}</span></div>
              </div>
            </div>
          </div>
          <!-- PAYMENT -->
          <div v-if="cartItems.length" class="card card-flush shadow-sm">
            <div class="card-header">
              <h5 class="card-title fw-bold"><i class="ki-duotone ki-credit-cart text-success fs-1 me-2"><span
                    class="path1"></span><span class="path2"></span></i>Payment</h5>
            </div>
            <div class="card-body p-3">
              <div class="row g-2 mb-3">
                <div class="col-6"><button @click="setPaymentMethod('Cash')"
                    :class="['btn', 'w-100', 'p-3', paymentMethod === 'Cash' ? 'btn-success' : 'btn-light-success']"><i
                      class="ki-duotone ki-dollar fs-2"><span class="path1"></span><span class="path2"></span></i>
                    <div class="fw-bold mt-1">Cash</div>
                  </button></div>
                <div class="col-6"><button @click="setPaymentMethod('Card')"
                    :class="['btn', 'w-100', 'p-3', paymentMethod === 'Card' ? 'btn-info' : 'btn-light-info']"><i
                      class="ki-duotone ki-credit-cart fs-2"><span class="path1"></span><span class="path2"></span></i>
                    <div class="fw-bold mt-1">Card</div>
                  </button></div>
                <div class="col-6"><button @click="setPaymentMethod('Mobile Money')"
                    :class="['btn', 'w-100', 'p-3', paymentMethod === 'Mobile Money' ? 'btn-warning' : 'btn-light-warning']"><i
                      class="ki-duotone ki-phone fs-2"><span class="path1"></span><span class="path2"></span></i>
                    <div class="fw-bold mt-1">Mobile</div>
                  </button></div>
              </div>
              <div v-if="paymentMethod === 'Cash'" class="mb-3">
                <label class="form-label fw-bold">Cash Received</label>
                <input v-model.number="cashReceived" type="number" step="0.01" min="0"
                  class="form-control form-control-lg text-center fs-3 fw-bold" :class="getCashInputClass"
                  placeholder="0.00" @input="validateCashAmount" />
                <div v-if="cashReceived >= cartTotal && cashReceived > 0"
                  class="mt-2 p-2 bg-light-success rounded text-success fw-bold">
                  Change: {{ formatCurrency(cashReceived - cartTotal) }}
                </div>
                <div v-if="cashReceived > 0 && cashReceived < cartTotal"
                  class="mt-2 p-2 bg-light-danger rounded text-danger fw-bold">
                  Insufficient: {{ formatCurrency(cartTotal - cashReceived) }}
                </div>
              </div>
              <div v-if="paymentMethod !== 'Cash'" class="mb-3">
                <label class="form-label fw-bold">Payment Reference</label>
                <input v-model="paymentReference" type="text" class="form-control form-control-lg"
                  placeholder="Enter reference number"
                  :class="{ 'is-invalid': paymentReference.length > 0 && paymentReference.length < 3 }" />
                <div v-if="paymentReference.length > 0 && paymentReference.length < 3" class="invalid-feedback">
                  Reference must be at least 3 characters
                </div>
              </div>
              <button @click="processSale" :disabled="!canProcessSale || processing"
                class="btn btn-primary w-100 p-4 fs-4 fw-bold">
                <div v-if="processing" class="d-flex align-items-center justify-content-center">
                  <div class="spinner-border spinner-border-sm me-2"></div>Processing Sale...
                </div>
                <div v-else class="d-flex align-items-center justify-content-center">
                  <i class="ki-duotone ki-check-circle fs-1 me-2"><span class="path1"></span><span
                      class="path2"></span></i>Complete Sale • {{ formatCurrency(cartTotal) }}
                </div>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- SETTINGS MODAL -->
    <div v-if="showSettingsModal" class="modal d-block" tabindex="-1" style="background: rgba(0,0,0,0.6);"
      aria-modal="true" role="dialog">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-info">
            <h3 class="modal-title fw-bold text-white">
              <i class="ki-duotone ki-setting-2 fs-1 me-2"><span class="path1"></span><span class="path2"></span></i>
              POS System Info
            </h3>
            <button @click="showSettingsModal = false" class="btn btn-icon btn-light btn-sm"><i
                class="ki-duotone ki-cross fs-2"><span class="path1"></span><span class="path2"></span></i></button>
          </div>
          <div class="modal-body">
            <div class="text-start">
              <h6 class="fw-bold mb-2">Session</h6>
              <p>User: {{ currentUser?.name || 'Unknown' }}</p>
              <p>Station: {{ currentStation?.StationName || 'Unknown' }}</p>
              <p class="mb-3">Products Loaded: {{ products.length }}</p>
              <h6 class="fw-bold mb-2">Today's Summary</h6>
              <p>Sales: {{ todayStats.totalSales }}</p>
              <p>Revenue: {{ formatCurrency(todayStats.revenue) }}</p>
              <p>Customers: {{ todayStats.customers }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<!--
  For brevity, the <script setup> is omitted here.
  The actual code would be your previous <script setup> block
  **with all shift management logic (and any variable/state for shifts) REMOVED**.
  All other logic is preserved exactly as before for
  product/cart/customer/payment/analytics functionality.
  If you need the script section pasted here, reply: "Show script for this template."
-->

<!-- Metronic 8 classes only; no custom CSS required. -->
<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
import Swal from 'sweetalert2'

// --- API BASE ---
const API_BASE_URL = 'http://localhost:4000/api/records/v1'

// --- AUTH ---
const getAuthData = () => {
  try { const d = localStorage.getItem('kigrama_user_data'); return d ? JSON.parse(d) : null } catch { return null }
}
const getAuthToken = () => localStorage.getItem('kigrama_auth_token') || 'demo_token'

// --- STATE ---
const loading = ref(false)
const processing = ref(false)
const loadingCustomers = ref(false)
const currentUser = ref(null)
const currentStation = ref(null)
const showSettingsModal = ref(false)

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
const searchDebounceTimer = ref(null)

const MAX_QUANTITY = 10000
const MIN_QUANTITY = 0.01
const MAX_CASH_AMOUNT = 50000000

// --- COMPUTED ---
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

// --- HELPERS ---
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

// --- API ---
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
    if (error.name === 'AbortError') throw new Error('Request timeout - check your connection')
    throw error
  }
}

// --- DATA LOADERS ---
const loadUserData = async () => {
  const authData = getAuthData()
  if (!authData?.user) throw new Error('No authentication data found')
  currentUser.value = authData.user
  if (authData.stations?.length > 0) currentStation.value = authData.stations.find(s => s.IsPrimary === '1') || authData.stations[0]
  else throw new Error('No stations assigned to user')
}
const loadProducts = async () => {
  loading.value = true
  const data = await apiCall('/Products')
  products.value = (data.records || []).filter(p => p.Status === 'Active' && p.Name && p.ProductType)
  await loadInventoryLevels()
  loading.value = false
}
const loadInventoryLevels = async () => {
  if (!currentStation.value?.StationID || !products.value.length) return
  const data = await apiCall(`/StationInventory?StationID=${currentStation.value.StationID}`)
  const inventory = data.records || []
  productInventory.value.clear()
  inventory.forEach(item => { if (item.ProductID && item.CurrentStock !== undefined) productInventory.value.set(item.ProductID, item.CurrentStock) })
}
const loadTodayStats = async () => {
  if (!currentStation.value?.StationID) return
  const today = new Date().toISOString().split('T')[0]
  const data = await apiCall(`/Transactions?StationID=${currentStation.value.StationID}&TransactionDate=${today}`)
  const tx = data.records || []
  todayStats.totalSales = tx.length
  todayStats.transactions = tx.length
  todayStats.revenue = tx.reduce((sum, t) => sum + parseFloat(t.TotalAmount || 0), 0)
  todayStats.customers = new Set(tx.map(t => t.CustomerID).filter(Boolean)).size
}

// --- CART LOGIC ---
const addToCart = product => {
  if (!product?.ProductID || !product.Name) return
  const stockLevel = getStockLevel(product)
  if (stockLevel <= 0) {
    Swal.fire({ title: 'Out of Stock', text: `${product.Name} is currently out of stock.`, icon: 'warning', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
    return
  }
  const existingItemIndex = cartItems.value.findIndex(item => item.product.ProductID === product.ProductID)
  if (existingItemIndex >= 0) {
    const existingItem = cartItems.value[existingItemIndex]
    const newQuantity = existingItem.quantity + 1
    if (newQuantity > stockLevel) {
      Swal.fire({ title: 'Insufficient Stock', text: `Only ${stockLevel}L available for ${product.Name}.`, icon: 'warning', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
      return
    }
    updateQuantity(existingItemIndex, newQuantity)
  } else {
    const unitPrice = parseFloat(product.SellingPrice || product.UnitPrice || 0)
    if (unitPrice <= 0) {
      Swal.fire({ title: 'Invalid Price', text: `${product.Name} has no valid price set.`, icon: 'error', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
      return
    }
    cartItems.value.push({ product: { ...product }, quantity: 1, unitPrice: unitPrice, total: unitPrice })
  }
}
const removeFromCart = index => { if (index >= 0 && index < cartItems.value.length) cartItems.value.splice(index, 1) }
const updateQuantity = (index, newQuantity) => {
  if (index < 0 || index >= cartItems.value.length) return
  const item = cartItems.value[index]
  const validatedQuantity = validateNumber(newQuantity, MIN_QUANTITY, MAX_QUANTITY)
  const stockLevel = getStockLevel(item.product)
  if (validatedQuantity > stockLevel) {
    Swal.fire({ title: 'Insufficient Stock', text: `Only ${stockLevel}L available for ${item.product.Name}.`, icon: 'warning', toast: true, position: 'top-end', timer: 2000, showConfirmButton: false })
    return
  }
  if (validatedQuantity <= 0) { removeFromCart(index); return }
  item.quantity = validatedQuantity
  item.total = item.quantity * item.unitPrice
}
const validateAndUpdateQuantity = (index, value) => { const num = parseFloat(value); if (isNaN(num) || num <= 0) removeFromCart(index); else updateQuantity(index, num) }
const clearCart = () => { cartItems.value = [] }
const isProductInCart = productId => cartItems.value.some(item => item.product.ProductID === productId)

// --- CUSTOMER LOGIC ---
const setCustomerType = type => {
  customerType.value = type
  if (type === 'registered') showCustomerSearch.value = true
  else { showCustomerSearch.value = false; selectedCustomer.value = null }
}
const searchCustomers = () => {
  if (searchDebounceTimer.value) clearTimeout(searchDebounceTimer.value)
  searchDebounceTimer.value = setTimeout(async () => {
    if (!customerSearchQuery.value || customerSearchQuery.value.length < 2) { customerSearchResults.value = []; return }
    loadingCustomers.value = true
    const query = encodeURIComponent(customerSearchQuery.value.trim())
    const data = await apiCall(`/Customers?q=${query}`)
    customerSearchResults.value = (data.records || []).slice(0, 10)
    loadingCustomers.value = false
  }, 300)
}
const selectCustomer = customer => { if (!customer?.CustomerID) return; selectedCustomer.value = customer; customerType.value = 'registered'; showCustomerSearch.value = false; customerSearchQuery.value = ''; customerSearchResults.value = [] }

// --- PAYMENT LOGIC ---
const setPaymentMethod = method => {
  paymentMethod.value = method
  if (method !== 'Cash') cashReceived.value = 0
  if (method === 'Cash') paymentReference.value = ''
}
const validateCashAmount = () => { cashReceived.value = validateNumber(cashReceived.value, 0, MAX_CASH_AMOUNT) }

// --- TRANSACTION (SALE) ---
const processSale = async () => {
  if (!canProcessSale.value) return
  processing.value = true
  try {
    if (!currentStation.value?.StationID) throw new Error('No station selected')
    if (!currentUser.value?.id) throw new Error('User not authenticated')
    // Stock re-check
    for (const item of cartItems.value) {
      const currentStock = getStockLevel(item.product)
      if (currentStock < item.quantity) throw new Error(`Insufficient stock for ${item.product.Name}`)
    }
    // Transaction ref
    const transactionRef = `TXN-${currentStation.value.StationID}-${Date.now()}`
    // Create transaction
    const transactionData = {
      StationID: currentStation.value.StationID,
      TransactionType: 'Sale',
      TotalAmount: cartTotal.value.toFixed(2),
      TaxAmount: cartTax.value.toFixed(2),
      PaymentMethod: paymentMethod.value,
      PaymentReference: paymentReference.value || transactionRef,
      PaymentStatus: 'Paid',
      Status: 'Completed',
      HandledBy: currentUser.value.id,
      CustomerID: selectedCustomer.value?.CustomerID || null,
      Notes: `POS Sale - ${paymentMethod.value} payment`
    }
    const transactionResponse = await apiCall('/Transactions', { method: 'POST', body: JSON.stringify(transactionData) })
    const transactionId = transactionResponse.TransactionID || transactionResponse.id || Date.now()
    // Transaction items
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
      // Update inventory
      await updateInventory(item)
    }
    // Receipt data (basic)
    await Swal.fire({
      title: 'Sale Completed!',
      html: `<div class="fw-bold fs-3 text-success mb-2">${formatCurrency(cartTotal.value)}</div><div class="text-gray-600">${paymentMethod.value} Payment</div>`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2500,
      showConfirmButton: false
    })
    clearCart()
    await Promise.all([loadInventoryLevels(), loadTodayStats()])
  } catch (error) {
    await Swal.fire({ title: 'Sale Error', text: error.message || 'Could not process sale.', icon: 'error', confirmButtonText: 'Close' })
  }
  processing.value = false
}
const updateInventory = async (item) => {
  const inventoryData = await apiCall(`/StationInventory?StationID=${currentStation.value.StationID}&ProductID=${item.product.ProductID}`)
  const inventory = inventoryData.records?.[0]
  if (inventory) {
    const currentStock = parseFloat(inventory.CurrentStock || 0)
    const newStock = Math.max(0, currentStock - item.quantity)
    await apiCall(`/StationInventory/${inventory.InventoryID}`, { method: 'PATCH', body: JSON.stringify({ CurrentStock: newStock.toString(), LastUpdated: new Date().toISOString() }) })
    productInventory.value.set(item.product.ProductID, newStock)
  }
}

// --- SETTINGS MODAL ---
const showSettings = () => { showSettingsModal.value = true }

// --- ARM CHARTS ---
const initSalesChart = () => {
  if (!salesChart.value) return
  // MVP: Simulate sales chart data (replace with Chart.js if allowed in project)
  const ctx = salesChart.value.getContext('2d')
  ctx.clearRect(0, 0, 400, 120)
  ctx.beginPath()
  ctx.moveTo(10, 110)
  let x = 10
  for (let i = 0; i < 10; i++) {
    const y = 110 - Math.round(Math.random() * 80)
    ctx.lineTo(x, y)
    x += 38
  }
  ctx.strokeStyle = '#50cd89'
  ctx.lineWidth = 3
  ctx.stroke()
  ctx.closePath()
}

// --- LIFECYCLE ---
onMounted(async () => {
  try {
    await loadUserData()
    if (!currentUser.value || !currentStation.value) throw new Error('User authentication or station assignment missing')
    await Promise.all([loadProducts(), loadTodayStats()])
    await nextTick()
    initSalesChart()
  } catch (error) {
    await Swal.fire({
      title: 'Initialization Failed', text: 'Unable to initialize POS system. Please contact support.',
      icon: 'error', confirmButtonText: 'Reload Page'
    }).then(() => { window.location.reload() })
  }
})
watch(() => cartItems.value.length, (n) => { if (n === 0) { } })
watch(() => selectedCategory.value, () => { })

window.addEventListener('error', (event) => {
  Swal.fire({
    title: 'System Error', text: 'An unexpected error occurred. Please refresh the page.', icon: 'error',
    confirmButtonText: 'Refresh Page'
  }).then(() => { window.location.reload() })
})

</script>

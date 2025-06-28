<template>
  <!-- PRODUCT CATALOG & STOCK MANAGEMENT - IOS PREMIUM DESIGN -->
  <div class="product-inventory-container">
    <!-- PREMIUM HEADER SECTION -->
    <div class="card border-0 shadow-lg mb-4 bg-gradient-primary">
      <div class="card-body p-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-cube-2 fs-1 text-white">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
            </div>
            <div>
              <h3 class="text-white fw-bold fs-2 mb-0">Product Catalog</h3>
              <p class="text-white opacity-75 fs-7 mb-0">
                {{ filteredProducts.length }} products • Real-time inventory
              </p>
            </div>
          </div>
          <div class="d-flex gap-2">
            <button
              @click="refreshInventory"
              :disabled="loading"
              class="btn btn-light-success btn-sm"
            >
              <i
                :class="[
                  'ki-duotone',
                  loading ? 'ki-arrows-circle' : 'ki-arrows-circle',
                  'fs-3 me-1',
                ]"
                :style="loading ? 'animation: spin 1s linear infinite;' : ''"
              >
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Refresh
            </button>
            <button @click="toggleStockView" class="btn btn-light-info btn-sm">
              <i class="ki-duotone ki-eye fs-3 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              {{ showStockDetails ? 'Simple' : 'Detailed' }}
            </button>
          </div>
        </div>

        <!-- INVENTORY STATS -->
        <div class="row g-3">
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-oil-barrel fs-2x text-white mb-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ inventoryStats.fuelProducts }}</div>
                <div class="text-white opacity-75 fs-8">Fuel Items</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-cube-2 fs-2x text-white mb-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ inventoryStats.nonFuelProducts }}</div>
                <div class="text-white opacity-75 fs-8">Other Items</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-information fs-2x text-white mb-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ inventoryStats.lowStockItems }}</div>
                <div class="text-white opacity-75 fs-8">Low Stock</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-cross-circle fs-2x text-white mb-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ inventoryStats.outOfStockItems }}</div>
                <div class="text-white opacity-75 fs-8">Out of Stock</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- SEARCH & FILTER SECTION -->
    <div class="card border-0 shadow-sm mb-4">
      <div class="card-body p-4">
        <!-- SEARCH INPUT -->
        <div class="position-relative mb-4">
          <input
            v-model="searchQuery"
            @input="debouncedSearch"
            type="text"
            class="form-control form-control-lg ps-5 pe-5"
            :class="getSearchInputClass"
            :style="getSearchInputStyle"
            placeholder="Search products by name or type..."
            :disabled="loading"
            maxlength="100"
          />

          <i
            class="ki-duotone ki-magnifier position-absolute top-50 start-0 translate-middle-y ms-3 fs-2 text-gray-500"
          >
            <span class="path1"></span>
            <span class="path2"></span>
          </i>

          <button
            v-if="searchQuery"
            @click="clearSearch"
            class="btn btn-icon btn-light-danger btn-sm position-absolute top-50 end-0 translate-middle-y me-2"
          >
            <i class="ki-duotone ki-cross fs-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </button>
        </div>

        <!-- CATEGORY FILTERS -->
        <div class="d-flex gap-2 flex-wrap mb-3">
          <button
            v-for="category in productCategories"
            :key="category.type"
            @click="setActiveFilter(category.type)"
            :class="[
              'btn btn-sm',
              activeFilter === category.type ? category.activeClass : category.inactiveClass,
            ]"
            style="transition: all 0.3s ease"
          >
            <i :class="['ki-duotone', category.icon, 'fs-4 me-1']">
              <span class="path1"></span>
              <span class="path2"></span>
              <span v-if="category.icon.includes('oil-barrel')" class="path3"></span>
            </i>
            {{ category.label }} ({{ getProductCountByType(category.type) }})
          </button>
        </div>

        <!-- STOCK STATUS FILTERS -->
        <div class="d-flex gap-2 flex-wrap">
          <button
            v-for="status in stockStatusFilters"
            :key="status.type"
            @click="setStockFilter(status.type)"
            :class="[
              'btn btn-sm',
              activeStockFilter === status.type ? status.activeClass : 'btn-light',
            ]"
            style="transition: all 0.3s ease"
          >
            <i :class="['ki-duotone', status.icon, 'fs-4 me-1']">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            {{ status.label }} ({{ getProductCountByStock(status.type) }})
          </button>
        </div>
      </div>
    </div>

    <!-- LOADING STATE -->
    <div v-if="loading" class="card border-0 shadow-sm">
      <div class="card-body p-5 text-center">
        <div class="spinner-border spinner-border-lg text-primary mb-3"></div>
        <h5 class="fw-bold text-gray-700 mb-2">Loading Products</h5>
        <p class="text-gray-500 fs-7">Fetching real-time inventory data...</p>
        <div class="progress mt-3" style="height: 6px">
          <div class="progress-bar bg-primary progress-bar-animated" style="width: 100%"></div>
        </div>
      </div>
    </div>

    <!-- PRODUCTS GRID -->
    <div v-else-if="filteredProducts.length > 0" class="row g-3">
      <div
        v-for="product in paginatedProducts"
        :key="product.ProductID"
        :class="getProductColumnClass"
      >
        <div
          @click="selectProduct(product)"
          class="card h-100 cursor-pointer position-relative border-0 shadow-sm"
          :class="getProductCardClass(product)"
          style="min-height: 200px; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1)"
        >
          <!-- OUT OF STOCK OVERLAY -->
          <div
            v-if="getAvailableStock(product) <= 0"
            class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center bg-danger bg-opacity-90 rounded z-2"
          >
            <div class="text-center text-white">
              <i class="ki-duotone ki-information fs-2x mb-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="fw-bold fs-6">OUT OF STOCK</div>
            </div>
          </div>

          <!-- LOW STOCK WARNING -->
          <div v-else-if="isLowStock(product)" class="position-absolute top-0 end-0 mt-2 me-2 z-1">
            <span class="badge badge-warning">
              <i class="ki-duotone ki-information fs-5 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Low Stock
            </span>
          </div>

          <!-- CART QUANTITY INDICATOR -->
          <div
            v-if="getCartQuantity(product.ProductID) > 0"
            class="position-absolute top-0 start-0 mt-2 ms-2 z-1"
          >
            <span
              class="badge badge-circle badge-success fs-8 fw-bold w-30px h-30px d-flex align-items-center justify-content-center"
            >
              {{ getCartQuantity(product.ProductID) }}
            </span>
          </div>

          <div class="card-body p-3 d-flex flex-column h-100">
            <!-- PRODUCT HEADER -->
            <div class="text-center mb-3">
              <div
                class="symbol symbol-60px symbol-circle mx-auto mb-3"
                :class="getProductIconBg(product.ProductType)"
              >
                <i
                  :class="[
                    'ki-duotone',
                    getProductIcon(product.ProductType),
                    'fs-2x',
                    getProductIconColor(product.ProductType),
                  ]"
                >
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span
                    v-if="getProductIcon(product.ProductType).includes('oil-barrel')"
                    class="path3"
                  ></span>
                </i>
              </div>

              <!-- PRODUCT NAME & TYPE -->
              <h6 class="fw-bold text-gray-800 mb-1 fs-6">{{ product.Name }}</h6>
              <div class="fs-8 text-gray-500 mb-2">{{ product.ProductType }}</div>

              <!-- PRODUCT PRICE -->
              <div class="fw-bold text-success fs-4 mb-2">
                {{ formatCurrency(getProductPrice(product)) }}
              </div>
            </div>

            <!-- STOCK INFORMATION -->
            <div class="flex-grow-1">
              <!-- FUEL PRODUCT DETAILS -->
              <div v-if="isFuelProduct(product)" class="mb-3">
                <div class="row g-2 mb-2">
                  <div class="col-6">
                    <div class="card bg-light-info border-0">
                      <div class="card-body p-2 text-center">
                        <i class="ki-duotone ki-oil-barrel fs-3 text-info mb-1">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        <div class="fw-bold text-info fs-7">
                          {{ getAvailableTanks(product).length }}
                        </div>
                        <div class="text-info fs-9">Tanks</div>
                      </div>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="card bg-light-warning border-0">
                      <div class="card-body p-2 text-center">
                        <i class="ki-duotone ki-gas-station fs-3 text-warning mb-1">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        <div class="fw-bold text-warning fs-7">
                          {{ getAvailablePumps(product).length }}
                        </div>
                        <div class="text-warning fs-9">Pumps</div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- TANK LEVEL VISUALIZATION -->
                <div v-if="showStockDetails && getAvailableTanks(product).length > 0" class="mb-2">
                  <div class="fs-8 text-gray-600 mb-1">Tank Levels:</div>
                  <div
                    v-for="tank in getAvailableTanks(product).slice(0, 2)"
                    :key="tank.TankID"
                    class="mb-1"
                  >
                    <div class="d-flex justify-content-between fs-9 text-gray-600">
                      <span>{{ tank.TankName }}</span>
                      <span
                        >{{ formatStock(tank.CurrentLevel) }}/{{
                          formatStock(tank.Capacity)
                        }}L</span
                      >
                    </div>
                    <div class="progress" style="height: 4px">
                      <div
                        class="progress-bar"
                        :class="getTankLevelProgressClass(tank)"
                        :style="{ width: getTankLevelPercentage(tank) + '%' }"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- NON-FUEL STOCK DETAILS -->
              <div v-else class="mb-3">
                <div class="card bg-light-primary border-0">
                  <div class="card-body p-2 text-center">
                    <i class="ki-duotone ki-package fs-3 text-primary mb-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                    <div class="fw-bold text-primary fs-6">
                      {{ formatStock(getAvailableStock(product)) }}
                    </div>
                    <div class="text-primary fs-9">Units Available</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- STOCK STATUS BADGE -->
            <div class="mt-auto text-center">
              <span
                :class="[
                  'badge',
                  'badge-lg',
                  'w-100',
                  getStockBadgeClass(getAvailableStock(product)),
                ]"
              >
                <i :class="['ki-duotone', getStockIcon(getAvailableStock(product)), 'fs-4 me-1']">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                {{ getStockStatusText(getAvailableStock(product)) }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- NO PRODUCTS STATE -->
    <div v-else-if="!loading && products.length === 0" class="card border-warning bg-light-warning">
      <div class="card-body p-5 text-center">
        <i class="ki-duotone ki-cube-2 fs-3x text-warning mb-3">
          <span class="path1"></span>
          <span class="path2"></span>
          <span class="path3"></span>
        </i>
        <h5 class="fw-bold text-warning mb-2">No Products Available</h5>
        <p class="text-warning opacity-75 fs-7 mb-3">No products are configured for this station</p>
        <button @click="refreshInventory" class="btn btn-warning">
          <i class="ki-duotone ki-arrows-circle fs-3 me-1">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Refresh Inventory
        </button>
      </div>
    </div>

    <!-- NO FILTERED RESULTS -->
    <div
      v-else-if="!loading && filteredProducts.length === 0 && products.length > 0"
      class="card border-info bg-light-info"
    >
      <div class="card-body p-4 text-center">
        <i class="ki-duotone ki-search-list fs-3x text-info mb-3">
          <span class="path1"></span>
          <span class="path2"></span>
          <span class="path3"></span>
        </i>
        <h6 class="fw-bold text-info mb-2">No matching products</h6>
        <p class="text-info opacity-75 fs-7 mb-3">Try adjusting your search or filter criteria</p>
        <button @click="clearAllFilters" class="btn btn-info">
          <i class="ki-duotone ki-filter-edit fs-3 me-1">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Clear Filters
        </button>
      </div>
    </div>

    <!-- PAGINATION -->
    <div v-if="totalPages > 1" class="d-flex justify-content-center mt-4">
      <div class="d-flex gap-2">
        <button
          @click="previousPage"
          :disabled="currentPage === 1"
          class="btn btn-light-primary btn-sm"
        >
          <i class="ki-duotone ki-arrow-left fs-4">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
        </button>

        <span class="btn btn-primary btn-sm"> {{ currentPage }} / {{ totalPages }} </span>

        <button
          @click="nextPage"
          :disabled="currentPage === totalPages"
          class="btn btn-light-primary btn-sm"
        >
          <i class="ki-duotone ki-arrow-right fs-4">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
        </button>
      </div>
    </div>

    <!-- VERIFICATION LOG PANEL -->
    <div
      v-if="showVerificationLog && verificationLog.length > 0"
      class="card border-info bg-light-info mt-4"
    >
      <div class="card-header bg-info">
        <h6 class="fw-bold text-white mb-0">
          <i class="ki-duotone ki-verify fs-3 me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Inventory Verification Log
        </h6>
      </div>
      <div class="card-body p-0 max-h-200px overflow-auto">
        <div
          v-for="(log, index) in verificationLog.slice(-10)"
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
import { ref, reactive, computed, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'

// ========== PROPS & EMITS ==========
const props = defineProps({
  cartItems: {
    type: Array,
    default: () => [],
  },
  stationId: {
    type: Number,
    default: null,
  },
  showVerificationLog: {
    type: Boolean,
    default: false,
  },
  disabled: {
    type: Boolean,
    default: false,
  },
})

const emits = defineEmits([
  'product-selected',
  'add-to-cart',
  'verification-log-updated',
  'inventory-updated',
])

// ========== CONSTANTS ==========
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const SEARCH_DEBOUNCE_DELAY = 300
const PRODUCTS_PER_PAGE = 12
const LOW_STOCK_THRESHOLD = 10
const CRITICAL_STOCK_THRESHOLD = 5

// ========== REACTIVE STATE ==========
const loading = ref(false)
const products = ref([])
const tanks = ref([])
const pumps = ref([])
const stationInventory = ref(new Map())

// Search & Filtering
const searchQuery = ref('')
const activeFilter = ref('all')
const activeStockFilter = ref('all')
const showStockDetails = ref(false)

// Pagination
const currentPage = ref(1)

// Verification System
const verificationLog = ref([])

// Search Timer
let searchDebounceTimer = null

// ========== COMPUTED PROPERTIES ==========
const filteredProducts = computed(() => {
  let filtered = products.value

  // Apply search filter
  if (searchQuery.value.trim()) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(
      (product) =>
        product.Name.toLowerCase().includes(query) ||
        product.ProductType.toLowerCase().includes(query) ||
        product.Description?.toLowerCase().includes(query),
    )
  }

  // Apply category filter
  if (activeFilter.value !== 'all') {
    filtered = filtered.filter((product) => {
      if (activeFilter.value === 'fuel') {
        return isFuelProduct(product)
      } else if (activeFilter.value === 'non-fuel') {
        return !isFuelProduct(product)
      } else {
        return product.ProductType.toLowerCase() === activeFilter.value.toLowerCase()
      }
    })
  }

  // Apply stock filter
  if (activeStockFilter.value !== 'all') {
    filtered = filtered.filter((product) => {
      const stock = getAvailableStock(product)
      switch (activeStockFilter.value) {
        case 'in-stock':
          return stock > LOW_STOCK_THRESHOLD
        case 'low-stock':
          return stock > 0 && stock <= LOW_STOCK_THRESHOLD
        case 'out-of-stock':
          return stock <= 0
        default:
          return true
      }
    })
  }

  return filtered.sort((a, b) => {
    // Sort by stock status (in stock first), then by name
    const stockA = getAvailableStock(a)
    const stockB = getAvailableStock(b)

    if (stockA <= 0 && stockB > 0) return 1
    if (stockA > 0 && stockB <= 0) return -1

    return a.Name.localeCompare(b.Name)
  })
})

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * PRODUCTS_PER_PAGE
  const end = start + PRODUCTS_PER_PAGE
  return filteredProducts.value.slice(start, end)
})

const totalPages = computed(() => {
  return Math.ceil(filteredProducts.value.length / PRODUCTS_PER_PAGE)
})

const inventoryStats = computed(() => {
  const stats = {
    fuelProducts: 0,
    nonFuelProducts: 0,
    lowStockItems: 0,
    outOfStockItems: 0,
    totalValue: 0,
  }

  products.value.forEach((product) => {
    const stock = getAvailableStock(product)
    const price = getProductPrice(product)

    if (isFuelProduct(product)) {
      stats.fuelProducts++
    } else {
      stats.nonFuelProducts++
    }

    if (stock <= 0) {
      stats.outOfStockItems++
    } else if (stock <= LOW_STOCK_THRESHOLD) {
      stats.lowStockItems++
    }

    stats.totalValue += stock * price
  })

  return stats
})

const productCategories = computed(() => [
  {
    type: 'all',
    label: 'All Products',
    icon: 'ki-category',
    activeClass: 'btn-primary',
    inactiveClass: 'btn-light-primary',
  },
  {
    type: 'fuel',
    label: 'Fuel',
    icon: 'ki-oil-barrel',
    activeClass: 'btn-success',
    inactiveClass: 'btn-light-success',
  },
  {
    type: 'lubricant',
    label: 'Lubricants',
    icon: 'ki-oil',
    activeClass: 'btn-info',
    inactiveClass: 'btn-light-info',
  },
  {
    type: 'gas',
    label: 'Gas',
    icon: 'ki-gas-station',
    activeClass: 'btn-warning',
    inactiveClass: 'btn-light-warning',
  },
  {
    type: 'service',
    label: 'Services',
    icon: 'ki-wrench',
    activeClass: 'btn-danger',
    inactiveClass: 'btn-light-danger',
  },
])

const stockStatusFilters = computed(() => [
  {
    type: 'all',
    label: 'All Stock',
    icon: 'ki-category',
    activeClass: 'btn-primary',
  },
  {
    type: 'in-stock',
    label: 'In Stock',
    icon: 'ki-check-circle',
    activeClass: 'btn-success',
  },
  {
    type: 'low-stock',
    label: 'Low Stock',
    icon: 'ki-information',
    activeClass: 'btn-warning',
  },
  {
    type: 'out-of-stock',
    label: 'Out of Stock',
    icon: 'ki-cross-circle',
    activeClass: 'btn-danger',
  },
])

const getProductColumnClass = computed(() => {
  const productCount = paginatedProducts.value.length
  if (productCount === 1) return 'col-12'
  if (productCount === 2) return 'col-6'
  if (productCount <= 4) return 'col-6 col-md-6 col-lg-3'
  return 'col-6 col-md-4 col-lg-3 col-xl-2'
})

const getSearchInputClass = computed(() => {
  let classes = ['border-light']

  if (searchQuery.value.trim()) {
    if (filteredProducts.value.length > 0) {
      classes = ['border-success']
    } else {
      classes = ['border-warning']
    }
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

const formatStock = (stock) => {
  const num = parseFloat(stock) || 0
  if (num >= 1000) return `${(num / 1000).toFixed(1)}k`
  return `${num.toFixed(0)}`
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

const getCurrentUser = () => {
  try {
    const userData = localStorage.getItem('kigrama_user_data')
    return userData ? JSON.parse(userData).user : { id: 1, name: 'Demo User' }
  } catch {
    return { id: 1, name: 'Demo User' }
  }
}

// ========== PRODUCT CLASSIFICATION ==========
const isFuelProduct = (product) => {
  if (!product?.ProductType) return false
  const type = product.ProductType.toLowerCase()
  return (
    type === 'fuel' ||
    type.includes('petrol') ||
    type.includes('diesel') ||
    type.includes('gasoline') ||
    type.includes('kerosene')
  )
}

const getProductIcon = (productType) => {
  if (!productType) return 'ki-cube-2'

  const type = productType.toLowerCase()
  if (type.includes('fuel') || type.includes('petrol') || type.includes('diesel'))
    return 'ki-oil-barrel'
  if (type.includes('lubricant') || type.includes('oil')) return 'ki-oil'
  if (type.includes('gas') || type.includes('lpg')) return 'ki-gas-station'
  if (type.includes('service')) return 'ki-wrench'
  return 'ki-cube-2'
}

const getProductIconColor = (productType) => {
  if (!productType) return 'text-white'

  const type = productType.toLowerCase()
  if (type.includes('fuel') || type.includes('petrol') || type.includes('diesel'))
    return 'text-white'
  if (type.includes('lubricant') || type.includes('oil')) return 'text-white'
  if (type.includes('gas') || type.includes('lpg')) return 'text-white'
  if (type.includes('service')) return 'text-white'
  return 'text-white'
}

const getProductIconBg = (productType) => {
  if (!productType) return 'bg-gray-500'

  const type = productType.toLowerCase()
  if (type.includes('fuel') || type.includes('petrol') || type.includes('diesel'))
    return 'bg-success'
  if (type.includes('lubricant') || type.includes('oil')) return 'bg-info'
  if (type.includes('gas') || type.includes('lpg')) return 'bg-warning'
  if (type.includes('service')) return 'bg-danger'
  return 'bg-primary'
}

const getProductPrice = (product) => {
  return parseFloat(product.SellingPrice || product.UnitPrice || 0)
}

const getAvailableStock = (product) => {
  if (isFuelProduct(product)) {
    // For fuel, return total tank levels
    const productTanks = tanks.value.filter((tank) => tank.ProductID === product.ProductID)
    return productTanks.reduce((sum, tank) => sum + parseFloat(tank.CurrentLevel || 0), 0)
  } else {
    // For non-fuel, return station inventory
    return parseFloat(stationInventory.value.get(product.ProductID) || 0)
  }
}

const getAvailableTanks = (product) => {
  return tanks.value.filter(
    (tank) =>
      tank.ProductID === product.ProductID &&
      tank.Status === 'Active' &&
      parseFloat(tank.CurrentLevel || 0) >= 0,
  )
}

const getAvailablePumps = (product) => {
  const productTanks = getAvailableTanks(product)
  const tankIds = productTanks.map((tank) => tank.TankID)

  return pumps.value.filter((pump) => tankIds.includes(pump.TankID) && pump.Status === 'Active')
}

const isLowStock = (product) => {
  const stock = getAvailableStock(product)
  return stock > 0 && stock <= LOW_STOCK_THRESHOLD
}

const getCartQuantity = (productId) => {
  const item = props.cartItems.find((item) => item.product.ProductID === productId)
  return item ? item.quantity : 0
}

const getProductCardClass = (product) => {
  const stock = getAvailableStock(product)
  const inCart = getCartQuantity(product.ProductID) > 0

  let classes = []

  if (stock <= 0) {
    classes.push('border-danger', 'bg-light-danger')
  } else if (isLowStock(product)) {
    classes.push('border-warning', 'bg-light-warning')
  } else if (inCart) {
    classes.push('border-success', 'bg-light-success')
  } else {
    classes.push('bg-white', 'hover-elevate-up')
  }

  return classes.join(' ')
}

const getStockBadgeClass = (stock) => {
  if (stock <= 0) return 'badge-danger'
  if (stock <= CRITICAL_STOCK_THRESHOLD) return 'badge-warning'
  if (stock <= LOW_STOCK_THRESHOLD) return 'badge-info'
  return 'badge-success'
}

const getStockIcon = (stock) => {
  if (stock <= 0) return 'ki-cross-circle'
  if (stock <= CRITICAL_STOCK_THRESHOLD) return 'ki-information'
  if (stock <= LOW_STOCK_THRESHOLD) return 'ki-information'
  return 'ki-check-circle'
}

const getStockStatusText = (stock) => {
  if (stock <= 0) return 'Out of Stock'
  if (stock <= CRITICAL_STOCK_THRESHOLD) return 'Critical Stock'
  if (stock <= LOW_STOCK_THRESHOLD) return 'Low Stock'
  return 'In Stock'
}

const getTankLevelPercentage = (tank) => {
  const current = parseFloat(tank.CurrentLevel || 0)
  const capacity = parseFloat(tank.Capacity || 1)
  return Math.min(Math.round((current / capacity) * 100), 100)
}

const getTankLevelProgressClass = (tank) => {
  const percentage = getTankLevelPercentage(tank)
  if (percentage <= 10) return 'bg-danger'
  if (percentage <= 25) return 'bg-warning'
  if (percentage <= 50) return 'bg-info'
  return 'bg-success'
}

const getProductCountByType = (type) => {
  if (type === 'all') return products.value.length
  if (type === 'fuel') return products.value.filter((p) => isFuelProduct(p)).length
  if (type === 'non-fuel') return products.value.filter((p) => !isFuelProduct(p)).length
  return products.value.filter((p) => p.ProductType.toLowerCase() === type.toLowerCase()).length
}

const getProductCountByStock = (type) => {
  switch (type) {
    case 'all':
      return products.value.length
    case 'in-stock':
      return products.value.filter((p) => getAvailableStock(p) > LOW_STOCK_THRESHOLD).length
    case 'low-stock':
      return products.value.filter((p) => {
        const stock = getAvailableStock(p)
        return stock > 0 && stock <= LOW_STOCK_THRESHOLD
      }).length
    case 'out-of-stock':
      return products.value.filter((p) => getAvailableStock(p) <= 0).length
    default:
      return 0
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

// ========== VERIFICATION SYSTEM ==========
const logVerification = (operation, status, details, data = null) => {
  const logEntry = {
    timestamp: new Date().toISOString(),
    operation,
    status, // 'SUCCESS', 'WARNING', 'ERROR'
    details,
    data,
    userId: getCurrentUser().id,
    component: 'ProductInventory',
  }

  verificationLog.value.push(logEntry)

  // // Keep only last 50 entries
  // if (verificationLog.value.length > 50) {
  //   verificationLog.value = verificationLog.value.slice(-50)
  // }

  // console.log(`[INVENTORY VERIFICATION ${status}] ${operation}: ${details}`, data)

  // Emit to parent for global logging
  emits('verification-log-updated', logEntry)

  // Create audit log
  createVerificationAuditLog(logEntry)
}

const createVerificationAuditLog = async (logEntry) => {
  try {
    await apiCall('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify({
        StationID: props.stationId,
        UserID: logEntry.userId,
        Action: `INVENTORY_VERIFICATION: ${logEntry.operation}`,
        TableName: 'ProductInventory',
        Changes: JSON.stringify({
          status: logEntry.status,
          details: logEntry.details,
          data: logEntry.data,
          timestamp: logEntry.timestamp,
        }),
        IPAddress: 'ProductInventory-Component',
        LogTimestamp: logEntry.timestamp,
      }),
    })
  } catch (error) {
    console.error('Failed to log verification audit:', error)
  }
}

const verifyInventoryData = async (productId, expectedData) => {
  const verification = {
    success: true,
    errors: [],
    warnings: [],
    details: {},
  }

  try {
    logVerification(
      'INVENTORY_VERIFICATION_START',
      'SUCCESS',
      `Starting inventory verification for product ${productId}`,
    )

    // Verify product record
    const product = await apiCall(`/Products/${productId}`)
    if (!product) {
      verification.success = false
      verification.errors.push(`Product ${productId} not found`)
      logVerification('PRODUCT_NOT_FOUND', 'ERROR', `Product ${productId} not found`)
      return verification
    }

    // Verify station inventory
    const inventoryResponse = await apiCall(
      `/StationInventory?StationID=${props.stationId}&ProductID=${productId}`,
    )
    const inventory = inventoryResponse.records?.[0]

    if (expectedData.inventory && inventory) {
      const expectedStock = parseFloat(expectedData.inventory.CurrentStock || 0)
      const actualStock = parseFloat(inventory.CurrentStock || 0)

      if (Math.abs(expectedStock - actualStock) > 0.01) {
        const error = `Inventory stock mismatch. Expected: ${expectedStock}, Actual: ${actualStock}`
        verification.errors.push(error)
        verification.success = false
        logVerification('INVENTORY_STOCK_MISMATCH', 'ERROR', error)
      }
    }

    // Verify fuel system data if applicable
    if (isFuelProduct(product) && expectedData.tanks) {
      for (const expectedTank of expectedData.tanks) {
        const actualTank = await apiCall(`/Tanks/${expectedTank.TankID}`)
        if (!actualTank) {
          verification.errors.push(`Tank ${expectedTank.TankID} not found`)
          verification.success = false
          continue
        }

        const expectedLevel = parseFloat(expectedTank.CurrentLevel || 0)
        const actualLevel = parseFloat(actualTank.CurrentLevel || 0)

        if (Math.abs(expectedLevel - actualLevel) > 0.01) {
          const error = `Tank level mismatch for ${expectedTank.TankName}. Expected: ${expectedLevel}, Actual: ${actualLevel}`
          verification.errors.push(error)
          verification.success = false
          logVerification('TANK_LEVEL_MISMATCH', 'ERROR', error)
        }
      }
    }

    verification.details = { product, inventory, expected: expectedData }

    if (verification.success) {
      logVerification(
        'INVENTORY_VERIFICATION_SUCCESS',
        'SUCCESS',
        `Inventory verification completed for product ${productId}`,
      )
    } else {
      logVerification(
        'INVENTORY_VERIFICATION_FAILED',
        'ERROR',
        `Inventory verification failed with ${verification.errors.length} errors`,
      )
    }

    return verification
  } catch (error) {
    verification.success = false
    verification.errors.push(`Verification error: ${error.message}`)
    logVerification(
      'INVENTORY_VERIFICATION_ERROR',
      'ERROR',
      `Critical verification error: ${error.message}`,
    )
    return verification
  }
}

// ========== API FUNCTIONS ==========
const apiCall = async (endpoint, options = {}) => {
  const controller = new AbortController()
  const timeoutId = setTimeout(() => controller.abort(), 30000)

  try {
    logVerification('API_CALL_START', 'SUCCESS', `Starting API call: ${endpoint}`)

    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      signal: controller.signal,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${getAuthToken()}`,
        ...options.headers,
      },
      ...options,
    })

    clearTimeout(timeoutId)

    if (!response.ok) {
      const errorText = await response.text().catch(() => 'Unknown error')
      logVerification(
        'API_CALL_FAILED',
        'ERROR',
        `API call failed: ${response.status} - ${errorText}`,
      )
      throw new Error(`API Error ${response.status}: ${errorText}`)
    }

    const responseText = await response.text()
    if (!responseText.trim()) {
      logVerification('API_CALL_EMPTY_RESPONSE', 'WARNING', `Empty response from ${endpoint}`)
      return { success: true }
    }

    try {
      const data = JSON.parse(responseText)
      logVerification('API_CALL_SUCCESS', 'SUCCESS', `API call successful: ${endpoint}`)
      return data
    } catch (parseError) {
      logVerification('API_CALL_PARSE_ERROR', 'ERROR', `JSON parse error: ${parseError.message}`)
      throw new Error('Invalid JSON response from server')
    }
  } catch (error) {
    clearTimeout(timeoutId)
    if (error.name === 'AbortError') {
      logVerification('API_CALL_TIMEOUT', 'ERROR', `API call timeout: ${endpoint}`)
      throw new Error('Request timeout - please try again')
    }
    logVerification('API_CALL_ERROR', 'ERROR', `API call error: ${error.message}`)
    throw error
  }
}

// ========== DATA LOADING FUNCTIONS ==========
const loadProducts = async () => {
  try {
    logVerification('PRODUCTS_LOAD_START', 'SUCCESS', 'Loading products')

    const response = await apiCall('/Products')
    const allProducts = response.records || []

    products.value = allProducts
      .filter(
        (product) =>
          product.Status === 'Active' &&
          product.Name &&
          product.ProductType &&
          (product.UnitPrice > 0 || product.SellingPrice > 0),
      )
      .sort((a, b) => a.Name.localeCompare(b.Name))

    logVerification(
      'PRODUCTS_LOAD_SUCCESS',
      'SUCCESS',
      `Loaded ${products.value.length} active products`,
    )
  } catch (error) {
    console.error('Error loading products:', error)
    logVerification('PRODUCTS_LOAD_ERROR', 'ERROR', error.message)
    throw error
  }
}

const loadTanksAndPumps = async () => {
  try {
    if (!props.stationId) {
      logVerification(
        'TANKS_PUMPS_LOAD_SKIP',
        'WARNING',
        'No station ID provided, skipping tanks and pumps load',
      )
      return
    }

    logVerification(
      'TANKS_PUMPS_LOAD_START',
      'SUCCESS',
      `Loading tanks and pumps for station ${props.stationId}`,
    )

    const [tanksResponse, pumpsResponse] = await Promise.all([
      apiCall(`/Tanks?StationID=${props.stationId}`),
      apiCall(`/Pumps?StationID=${props.stationId}`),
    ])

    tanks.value = tanksResponse.records || []
    pumps.value = pumpsResponse.records || []

    logVerification(
      'TANKS_PUMPS_LOAD_SUCCESS',
      'SUCCESS',
      `Loaded ${tanks.value.length} tanks and ${pumps.value.length} pumps`,
    )
  } catch (error) {
    console.error('Error loading tanks and pumps:', error)
    logVerification('TANKS_PUMPS_LOAD_ERROR', 'ERROR', error.message)
  }
}

const loadStationInventory = async () => {
  try {
    if (!props.stationId) {
      logVerification(
        'INVENTORY_LOAD_SKIP',
        'WARNING',
        'No station ID provided, skipping inventory load',
      )
      return
    }

    logVerification(
      'INVENTORY_LOAD_START',
      'SUCCESS',
      `Loading inventory for station ${props.stationId}`,
    )

    const response = await apiCall(`/StationInventory?StationID=${props.stationId}`)
    const inventory = response.records || []

    stationInventory.value.clear()
    inventory.forEach((item) => {
      if (item.ProductID && item.CurrentStock !== undefined) {
        stationInventory.value.set(item.ProductID, parseFloat(item.CurrentStock || 0))
      }
    })

    logVerification(
      'INVENTORY_LOAD_SUCCESS',
      'SUCCESS',
      `Loaded inventory for ${stationInventory.value.size} products`,
    )
  } catch (error) {
    console.error('Error loading station inventory:', error)
    logVerification('INVENTORY_LOAD_ERROR', 'ERROR', error.message)
  }
}

const refreshInventory = async () => {
  try {
    loading.value = true

    await Swal.fire({
      title: 'Refreshing Inventory',
      text: 'Updating product and stock data...',
      icon: 'info',
      toast: true,
      position: 'top-end',
      timer: 1000,
      showConfirmButton: false,
    })

    await Promise.all([loadProducts(), loadTanksAndPumps(), loadStationInventory()])

    // Emit inventory updated event
    emits('inventory-updated', {
      products: products.value.length,
      tanks: tanks.value.length,
      pumps: pumps.value.length,
      timestamp: new Date().toISOString(),
    })

    await Swal.fire({
      title: 'Inventory Updated',
      text: 'All product and stock data has been refreshed',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Error refreshing inventory:', error)

    await Swal.fire({
      title: 'Refresh Failed',
      text: 'Could not refresh inventory data',
      icon: 'error',
      confirmButtonText: 'OK',
    })
  } finally {
    loading.value = false
  }
}

// ========== UI EVENT HANDLERS ==========
const selectProduct = async (product) => {
  try {
    if (props.disabled) return

    const stock = getAvailableStock(product)

    if (stock <= 0) {
      await Swal.fire({
        title: 'Out of Stock',
        text: `${product.Name} is currently out of stock`,
        icon: 'warning',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
      return
    }

    logVerification(
      'PRODUCT_SELECTION',
      'SUCCESS',
      `Product selected: ${product.Name} (${product.ProductID})`,
    )

    // Verify product data before selection
    const verification = await verifyInventoryData(product.ProductID, {
      inventory: { CurrentStock: stock },
      tanks: isFuelProduct(product) ? getAvailableTanks(product) : undefined,
    })

    emits('product-selected', {
      product: product,
      verification: verification,
      availableStock: stock,
      tanks: isFuelProduct(product) ? getAvailableTanks(product) : [],
      pumps: isFuelProduct(product) ? getAvailablePumps(product) : [],
      timestamp: new Date().toISOString(),
    })

    if (!verification.success) {
      logVerification(
        'PRODUCT_SELECTION_WARNING',
        'WARNING',
        `Product selected with verification warnings: ${verification.errors.join(', ')}`,
      )
    }
  } catch (error) {
    console.error('Error selecting product:', error)
    logVerification('PRODUCT_SELECTION_ERROR', 'ERROR', error.message)
  }
}

const debouncedSearch = () => {
  if (searchDebounceTimer) {
    clearTimeout(searchDebounceTimer)
  }

  searchDebounceTimer = setTimeout(() => {
    currentPage.value = 1 // Reset to first page on search
    logVerification('PRODUCT_SEARCH', 'SUCCESS', `Search query: "${searchQuery.value}"`)
  }, SEARCH_DEBOUNCE_DELAY)
}

const clearSearch = () => {
  searchQuery.value = ''
  currentPage.value = 1
}

const setActiveFilter = (filter) => {
  activeFilter.value = filter
  currentPage.value = 1
  logVerification('FILTER_CHANGED', 'SUCCESS', `Category filter changed to: ${filter}`)
}

const setStockFilter = (filter) => {
  activeStockFilter.value = filter
  currentPage.value = 1
  logVerification('STOCK_FILTER_CHANGED', 'SUCCESS', `Stock filter changed to: ${filter}`)
}

const clearAllFilters = () => {
  searchQuery.value = ''
  activeFilter.value = 'all'
  activeStockFilter.value = 'all'
  currentPage.value = 1
  logVerification('FILTERS_CLEARED', 'SUCCESS', 'All filters cleared')
}

const toggleStockView = () => {
  showStockDetails.value = !showStockDetails.value
  logVerification(
    'STOCK_VIEW_TOGGLED',
    'SUCCESS',
    `Stock details view: ${showStockDetails.value ? 'detailed' : 'simple'}`,
  )
}

const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
  }
}

// ========== WATCHERS ==========
watch(
  () => props.stationId,
  async (newStationId) => {
    if (newStationId) {
      await Promise.all([loadTanksAndPumps(), loadStationInventory()])
    }
  },
)

// ========== LIFECYCLE ==========
onMounted(async () => {
  console.log('📦 ProductInventory Component Mounted')

  try {
    loading.value = true

    logVerification('COMPONENT_MOUNTED', 'SUCCESS', 'ProductInventory component initialized')

    await Promise.all([loadProducts(), loadTanksAndPumps(), loadStationInventory()])

    logVerification('COMPONENT_READY', 'SUCCESS', 'ProductInventory component ready for use')
  } catch (error) {
    console.error('ProductInventory mount error:', error)
    logVerification('COMPONENT_MOUNT_ERROR', 'ERROR', error.message)

    await Swal.fire({
      title: 'Load Error',
      text: 'Could not load product inventory. Please refresh.',
      icon: 'error',
      confirmButtonText: 'Retry',
    }).then(() => {
      refreshInventory()
    })
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
/* iOS Premium Styling */
.product-inventory-container {
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

.cursor-pointer:active {
  transform: scale(0.98);
}

/* Card Enhancements */
.card {
  border-radius: 16px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.hover-elevate-up:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

/* Symbol & Badge Styling */
.symbol {
  border-radius: 50%;
  overflow: hidden;
}

.badge-lg {
  padding: 8px 12px;
  font-size: 0.875rem;
  border-radius: 8px;
}

.badge-circle {
  border-radius: 50%;
}

.w-30px {
  width: 30px;
}

.h-30px {
  height: 30px;
}

/* Progress Bar Styling */
.progress {
  background-color: rgba(0, 0, 0, 0.1);
  border-radius: 4px;
  overflow: hidden;
}

.progress-bar {
  border-radius: 4px;
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
.max-h-200px {
  max-height: 200px;
}

/* Loading Animation */
@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Grid Layout Enhancements */
.row.g-3 > * {
  padding: 0.75rem;
}

/* Typography */
.fs-9 {
  font-size: 0.75rem !important;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .card-body {
    padding: 1rem !important;
  }

  .symbol-60px {
    width: 50px !important;
    height: 50px !important;
  }

  .fs-2x {
    font-size: 1.5rem !important;
  }
}

@media (max-width: 576px) {
  .btn-sm {
    padding: 0.25rem 0.5rem !important;
    font-size: 0.75rem !important;
  }

  .d-flex.gap-2.flex-wrap {
    gap: 0.25rem !important;
  }
}

/* Z-index Management */
.z-1 {
  z-index: 1;
}

.z-2 {
  z-index: 2;
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Form Enhancements */
.form-control {
  min-height: 44px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.form-control:focus {
  border-width: 2px;
  box-shadow: 0 0 0 0.25rem rgba(54, 153, 255, 0.15);
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
</style>

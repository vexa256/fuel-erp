<template>
  <div class="d-flex flex-column gap-5 p-4"
    style="min-height: 100vh; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">

    <!-- Header Section -->
    <div class="card card-flush shadow-sm">
      <div class="card-header py-4">
        <div class="d-flex align-items-center justify-content-between w-100">
          <div class="d-flex align-items-center gap-3">
            <i class="ki-duotone ki-gas-station fs-1 text-primary">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <div>
              <h1 class="fw-bold fs-2 text-gray-900 mb-0">Daily Operations</h1>
              <p class="text-muted fs-6 mb-0">{{ currentStationName }} - {{ currentShiftDate }}</p>
            </div>
          </div>
          <div class="d-flex gap-2">
            <button @click="refreshData" class="btn btn-light-primary btn-sm" :disabled="loading">
              <i class="ki-duotone ki-arrows-circle fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
            <button @click="openCashDrawer" class="btn btn-light-success btn-sm">
              <i class="ki-duotone ki-dollar fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-3">
      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-primary">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <i class="ki-duotone ki-chart-line-up fs-2x text-primary me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div>
                <div class="fs-3 fw-bold text-primary">{{ formatCurrency(todayStats.totalSales) }}</div>
                <div class="fs-7 text-muted">Total Sales</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-success">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <i class="ki-duotone ki-droplet fs-2x text-success me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div>
                <div class="fs-3 fw-bold text-success">{{ todayStats.totalVolume }}L</div>
                <div class="fs-7 text-muted">Volume Sold</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-warning">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <i class="ki-duotone ki-design fs-2x text-warning me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div>
                <div class="fs-3 fw-bold text-warning">{{ todayStats.activeTransactions }}</div>
                <div class="fs-7 text-muted">Transactions</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-danger">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <i class="ki-duotone ki-percentage fs-2x text-danger me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div>
                <div class="fs-3 fw-bold text-danger">{{ todayStats.variance }}%</div>
                <div class="fs-7 text-muted">Variance</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Performance Chart -->
    <div class="card card-flush shadow-sm">
      <div class="card-header py-4">
        <h3 class="card-title fw-bold">Sales Performance</h3>
        <div class="card-toolbar">
          <select v-model="chartPeriod" class="form-select form-select-sm w-auto">
            <option value="today">Today</option>
            <option value="week">This Week</option>
            <option value="month">This Month</option>
          </select>
        </div>
      </div>
      <div class="card-body">
        <div ref="salesChart" style="height: 200px;"></div>
      </div>
    </div>

    <!-- Tabs Navigation -->
    <div class="card card-flush shadow-sm">
      <div class="card-header p-0">
        <div class="nav nav-stretch nav-pills nav-pills-custom d-flex">
          <div v-for="tab in tabs" :key="tab.id" @click="activeTab = tab.id"
            class="nav-link d-flex align-items-center px-4 py-3 cursor-pointer"
            :class="{ 'active bg-primary text-white': activeTab === tab.id }">
            <i :class="tab.icon" class="fs-3 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span v-if="tab.paths > 2" class="path3"></span>
            </i>
            <span class="fw-semibold">{{ tab.name }}</span>
            <span v-if="tab.badge" class="badge badge-light-danger ms-2">{{ tab.badge }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Tab Content -->

    <!-- Pump Readings Tab -->
    <div v-show="activeTab === 'pumps'" class="card card-flush shadow-sm">
      <div class="card-header py-4">
        <h3 class="card-title fw-bold">Pump Meter Readings</h3>
        <div class="card-toolbar">
          <button @click="addPumpReading" class="btn btn-primary btn-sm">
            <i class="ki-duotone ki-plus fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Add Reading
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="row g-4">
          <div v-for="pump in pumps" :key="pump.PumpID" class="col-12 col-md-6">
            <div class="card card-bordered">
              <div class="card-header py-3">
                <div class="d-flex align-items-center justify-content-between w-100">
                  <div class="d-flex align-items-center gap-2">
                    <i class="ki-duotone ki-droplet fs-2 text-primary">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div>
                      <h6 class="fw-bold mb-0">{{ pump.PumpName }}</h6>
                      <small class="text-muted">{{ getProductName(pump.ProductID) }}</small>
                    </div>
                  </div>
                  <span :class="getPumpStatusClass(pump.Status)">{{ pump.Status }}</span>
                </div>
              </div>
              <div class="card-body py-3">
                <div class="row g-3">
                  <div class="col-6">
                    <label class="form-label fs-7 fw-semibold">Opening Reading</label>
                    <input v-model="pumpReadings[pump.PumpID]?.opening" type="number" step="0.01"
                      class="form-control form-control-sm" placeholder="0.00" />
                  </div>
                  <div class="col-6">
                    <label class="form-label fs-7 fw-semibold">Closing Reading</label>
                    <input v-model="pumpReadings[pump.PumpID]?.closing" type="number" step="0.01"
                      class="form-control form-control-sm" placeholder="0.00" />
                  </div>
                  <div class="col-12">
                    <div class="d-flex justify-content-between align-items-center bg-light-primary p-2 rounded">
                      <span class="fs-7 fw-semibold text-primary">Calculated Sales:</span>
                      <span class="fs-6 fw-bold text-primary">{{ calculatePumpSales(pump.PumpID) }}L</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Tank Readings Tab -->
    <div v-show="activeTab === 'tanks'" class="card card-flush shadow-sm">
      <div class="card-header py-4">
        <h3 class="card-title fw-bold">Tank Dip Readings</h3>
        <div class="card-toolbar">
          <button @click="addTankReading" class="btn btn-primary btn-sm">
            <i class="ki-duotone ki-plus fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Add Reading
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="row g-4">
          <div v-for="tank in tanks" :key="tank.TankID" class="col-12 col-md-6">
            <div class="card card-bordered">
              <div class="card-header py-3">
                <div class="d-flex align-items-center justify-content-between w-100">
                  <div class="d-flex align-items-center gap-2">
                    <i class="ki-duotone ki-flask fs-2 text-success">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div>
                      <h6 class="fw-bold mb-0">{{ tank.TankName }}</h6>
                      <small class="text-muted">{{ getProductName(tank.ProductID) }}</small>
                    </div>
                  </div>
                  <span :class="getTankStatusClass(tank.Status)">{{ tank.Status }}</span>
                </div>
              </div>
              <div class="card-body py-3">
                <div class="row g-3">
                  <div class="col-6">
                    <label class="form-label fs-7 fw-semibold">Capacity</label>
                    <div class="form-control form-control-sm bg-light">{{ tank.Capacity }}L</div>
                  </div>
                  <div class="col-6">
                    <label class="form-label fs-7 fw-semibold">Previous Level</label>
                    <div class="form-control form-control-sm bg-light">{{ tank.CurrentLevel }}L</div>
                  </div>
                  <div class="col-12">
                    <label class="form-label fs-7 fw-semibold">Current Dip Reading</label>
                    <input v-model="tankReadings[tank.TankID]?.dipReading" type="number" step="0.01"
                      class="form-control form-control-sm" placeholder="Enter dip reading" />
                  </div>
                  <div class="col-12">
                    <div class="progress" style="height: 20px;">
                      <div class="progress-bar bg-success" :style="{ width: getTankFillPercentage(tank) + '%' }">
                        {{ getTankFillPercentage(tank) }}%
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Reconciliation Tab -->
    <div v-show="activeTab === 'reconciliation'" class="card card-flush shadow-sm">
      <div class="card-header py-4">
        <h3 class="card-title fw-bold">Sales Reconciliation</h3>
        <div class="card-toolbar">
          <button @click="generateReconciliation" class="btn btn-primary btn-sm" :disabled="loading">
            <i class="ki-duotone ki-calculator fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Calculate
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="row g-4">
          <!-- Summary Cards -->
          <div class="col-12">
            <div class="row g-3">
              <div class="col-6 col-md-3">
                <div class="card bg-light-info">
                  <div class="card-body text-center py-4">
                    <i class="ki-duotone ki-chart-pie-simple fs-2x text-info mb-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div class="fs-4 fw-bold text-info">{{ reconciliation.meterSales }}L</div>
                    <div class="fs-7 text-muted">Meter Sales</div>
                  </div>
                </div>
              </div>
              <div class="col-6 col-md-3">
                <div class="card bg-light-success">
                  <div class="card-body text-center py-4">
                    <i class="ki-duotone ki-shop fs-2x text-success mb-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div class="fs-4 fw-bold text-success">{{ reconciliation.systemSales }}L</div>
                    <div class="fs-7 text-muted">System Sales</div>
                  </div>
                </div>
              </div>
              <div class="col-6 col-md-3">
                <div class="card bg-light-warning">
                  <div class="card-body text-center py-4">
                    <i class="ki-duotone ki-percentage fs-2x text-warning mb-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div class="fs-4 fw-bold text-warning">{{ reconciliation.variance }}L</div>
                    <div class="fs-7 text-muted">Variance</div>
                  </div>
                </div>
              </div>
              <div class="col-6 col-md-3">
                <div class="card bg-light-danger">
                  <div class="card-body text-center py-4">
                    <i class="ki-duotone ki-pulse fs-2x text-danger mb-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div class="fs-4 fw-bold text-danger">{{ reconciliation.variancePercent }}%</div>
                    <div class="fs-7 text-muted">Variance %</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Detailed Reconciliation Table -->
          <div class="col-12">
            <div class="table-responsive">
              <table class="table table-row-dashed table-row-gray-300 align-middle gs-0 gy-4">
                <thead>
                  <tr class="fw-bold text-muted">
                    <th>Product</th>
                    <th>Meter Reading</th>
                    <th>System Sales</th>
                    <th>Variance</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="item in reconciliationDetails" :key="item.ProductID">
                    <td>
                      <div class="d-flex align-items-center">
                        <div class="symbol symbol-30px me-3">
                          <span class="symbol-label bg-light-primary text-primary fs-6 fw-bold">
                            {{ item.ProductName.charAt(0) }}
                          </span>
                        </div>
                        <div>
                          <div class="fw-semibold">{{ item.ProductName }}</div>
                          <div class="fs-7 text-muted">{{ item.ProductType }}</div>
                        </div>
                      </div>
                    </td>
                    <td class="fw-semibold">{{ item.meterReading }}L</td>
                    <td class="fw-semibold">{{ item.systemSales }}L</td>
                    <td>
                      <span :class="getVarianceClass(item.variance)" class="fw-bold">
                        {{ item.variance }}L
                      </span>
                    </td>
                    <td>
                      <span :class="getVarianceStatusClass(item.variancePercent)">
                        {{ getVarianceStatus(item.variancePercent) }}
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Cash Management Tab -->
    <div v-show="activeTab === 'cash'" class="card card-flush shadow-sm">
      <div class="card-header py-4">
        <h3 class="card-title fw-bold">Cash Drawer Management</h3>
        <div class="card-toolbar">
          <button @click="closeCashDrawer" class="btn btn-danger btn-sm" :disabled="!currentDrawer.DrawerID">
            <i class="ki-duotone ki-lock fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Close Drawer
          </button>
        </div>
      </div>
      <div class="card-body">
        <div class="row g-4">
          <!-- Current Drawer Status -->
          <div class="col-12">
            <div class="card bg-light-success">
              <div class="card-body">
                <div class="d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center gap-3">
                    <i class="ki-duotone ki-dollar fs-2x text-success">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                    <div>
                      <h5 class="fw-bold text-success mb-1">Cash Drawer Status</h5>
                      <p class="text-muted mb-0">{{ currentDrawer.Status || 'Closed' }} - {{ currentShiftDate }}</p>
                    </div>
                  </div>
                  <span :class="getDrawerStatusClass(currentDrawer.Status)">
                    {{ currentDrawer.Status || 'Closed' }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Cash Summary -->
          <div class="col-12">
            <div class="row g-3">
              <div class="col-6 col-md-3">
                <label class="form-label fs-7 fw-semibold">Opening Balance</label>
                <input v-model="cashForm.openingBalance" type="number" step="0.01" class="form-control form-control-lg"
                  :readonly="currentDrawer.Status === 'Closed'" />
              </div>
              <div class="col-6 col-md-3">
                <label class="form-label fs-7 fw-semibold">Cash Sales</label>
                <div class="form-control form-control-lg bg-light">{{ formatCurrency(cashForm.cashSales) }}</div>
              </div>
              <div class="col-6 col-md-3">
                <label class="form-label fs-7 fw-semibold">Cash Payouts</label>
                <input v-model="cashForm.cashPayouts" type="number" step="0.01" class="form-control form-control-lg" />
              </div>
              <div class="col-6 col-md-3">
                <label class="form-label fs-7 fw-semibold">Expected Cash</label>
                <div class="form-control form-control-lg bg-light-primary text-primary fw-bold">
                  {{ formatCurrency(calculateExpectedCash()) }}
                </div>
              </div>
              <div class="col-6 col-md-3">
                <label class="form-label fs-7 fw-semibold">Actual Cash Count</label>
                <input v-model="cashForm.actualCash" type="number" step="0.01" class="form-control form-control-lg" />
              </div>
              <div class="col-6 col-md-3">
                <label class="form-label fs-7 fw-semibold">Variance</label>
                <div :class="getCashVarianceClass()" class="form-control form-control-lg fw-bold">
                  {{ formatCurrency(calculateCashVariance()) }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Variance Chart -->
    <div class="card card-flush shadow-sm">
      <div class="card-header py-4">
        <h3 class="card-title fw-bold">Variance Trends</h3>
        <div class="card-toolbar">
          <select v-model="varianceChartPeriod" class="form-select form-select-sm w-auto">
            <option value="7days">Last 7 Days</option>
            <option value="30days">Last 30 Days</option>
            <option value="90days">Last 90 Days</option>
          </select>
        </div>
      </div>
      <div class="card-body">
        <div ref="varianceChart" style="height: 250px;"></div>
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="d-flex gap-3 mt-4">
      <button @click="saveAllReadings" class="btn btn-success flex-fill" :disabled="loading">
        <i class="ki-duotone ki-check fs-3">
          <span class="path1"></span>
          <span class="path2"></span>
        </i>
        Save All Readings
      </button>
      <button @click="submitForApproval" class="btn btn-primary flex-fill" :disabled="loading">
        <i class="ki-duotone ki-send fs-3">
          <span class="path1"></span>
          <span class="path2"></span>
        </i>
        Submit for Approval
      </button>
    </div>

    <!-- Loading Overlay -->
    <div v-if="loading"
      class="position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
      style="background: rgba(255,255,255,0.8); z-index: 1000;">
      <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;"></div>
    </div>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'http://localhost:4000/api/records/v1'
const JWT_TOKEN = localStorage.getItem('kigrama_auth_token') || 'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9'

// Reactive State
const loading = ref(false)
const activeTab = ref('pumps')
const chartPeriod = ref('today')
const varianceChartPeriod = ref('7days')

// User and Station Data
const currentUser = ref(JSON.parse(localStorage.getItem('kigrama_user_data') || '{}'))
const currentStationID = ref(currentUser.value.user?.PrimaryStationID || 1)
const currentStationName = ref('Kigrama Main Station')
const currentShiftDate = ref(new Date().toISOString().split('T')[0])

// Data Collections
const pumps = ref([])
const tanks = ref([])
const products = ref([])
const dailyReadings = ref([])
const transactions = ref([])
const currentDrawer = ref({})

// Form Data
const pumpReadings = ref({})
const tankReadings = ref({})
const cashForm = reactive({
  openingBalance: 0,
  cashSales: 0,
  cashPayouts: 0,
  actualCash: 0
})

// Chart Refs
const salesChart = ref(null)
const varianceChart = ref(null)

// Tab Configuration
const tabs = computed(() => [
  {
    id: 'pumps',
    name: 'Pump Readings',
    icon: 'ki-duotone ki-droplet',
    paths: 2,
    badge: pumps.value.filter(p => !pumpReadings.value[p.PumpID]?.closing).length || null
  },
  {
    id: 'tanks',
    name: 'Tank Dips',
    icon: 'ki-duotone ki-flask',
    paths: 2,
    badge: tanks.value.filter(t => !tankReadings.value[t.TankID]?.dipReading).length || null
  },
  {
    id: 'reconciliation',
    name: 'Reconciliation',
    icon: 'ki-duotone ki-calculator',
    paths: 2
  },
  {
    id: 'cash',
    name: 'Cash Management',
    icon: 'ki-duotone ki-dollar',
    paths: 3,
    badge: currentDrawer.value.Status === 'Open' ? '1' : null
  }
])

// Computed Statistics
const todayStats = computed(() => {
  const todayTransactions = transactions.value.filter(t =>
    new Date(t.TransactionDate).toDateString() === new Date().toDateString()
  )

  const totalSales = todayTransactions.reduce((sum, t) => sum + parseFloat(t.TotalAmount || 0), 0)
  const totalVolume = todayTransactions.reduce((sum, t) => {
    const items = getTransactionItems(t.TransactionID)
    return sum + items.reduce((vol, item) => vol + parseFloat(item.Quantity || 0), 0)
  }, 0)

  const meterSales = Object.values(pumpReadings.value).reduce((sum, reading) => {
    return sum + (parseFloat(reading.closing || 0) - parseFloat(reading.opening || 0))
  }, 0)

  const variance = ((meterSales - totalVolume) / Math.max(totalVolume, 1) * 100).toFixed(2)

  return {
    totalSales: totalSales.toFixed(2),
    totalVolume: totalVolume.toFixed(2),
    activeTransactions: todayTransactions.length,
    variance: variance
  }
})

// Reconciliation Data
const reconciliation = reactive({
  meterSales: 0,
  systemSales: 0,
  variance: 0,
  variancePercent: 0
})

const reconciliationDetails = ref([])

// API Helper Functions
const makeAPICall = async (endpoint, method = 'GET', data = null) => {
  try {
    const options = {
      method,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${JWT_TOKEN}`
      }
    }

    if (data && (method === 'POST' || method === 'PATCH')) {
      options.body = JSON.stringify(data)
    }

    const response = await fetch(`${API_BASE_URL}${endpoint}`, options)

    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API call failed:', error)
    throw error
  }
}

// Data Fetching Functions
const fetchStationData = async () => {
  try {
    // Fetch pumps for current station
    const pumpsData = await makeAPICall(`/Pumps?StationID=${currentStationID.value}`)
    pumps.value = pumpsData.records || []

    // Fetch tanks for current station
    const tanksData = await makeAPICall(`/Tanks?StationID=${currentStationID.value}`)
    tanks.value = tanksData.records || []

    // Fetch products
    const productsData = await makeAPICall('/Products')
    products.value = productsData.records || []

    // Initialize reading forms
    initializeReadingForms()

  } catch (error) {
    console.error('Error fetching station data:', error)
    showErrorNotification('Failed to load station data')
  }
}

const fetchDailyReadings = async () => {
  try {
    const readingsData = await makeAPICall(
      `/DailyReadings?StationID=${currentStationID.value}&ReadingDate=${currentShiftDate.value}`
    )
    dailyReadings.value = readingsData.records || []

    // Populate existing readings
    populateExistingReadings()

  } catch (error) {
    console.error('Error fetching daily readings:', error)
  }
}

const fetchTransactions = async () => {
  try {
    const transactionsData = await makeAPICall(
      `/Transactions?StationID=${currentStationID.value}&limit=1000`
    )
    transactions.value = transactionsData.records || []
  } catch (error) {
    console.error('Error fetching transactions:', error)
  }
}

const fetchCashDrawer = async () => {
  try {
    const drawerData = await makeAPICall(
      `/CashDrawers?StationID=${currentStationID.value}&ShiftDate=${currentShiftDate.value}`
    )
    const drawers = drawerData.records || []
    currentDrawer.value = drawers.find(d => d.Status === 'Open') || {}

    if (currentDrawer.value.DrawerID) {
      cashForm.openingBalance = parseFloat(currentDrawer.value.OpeningBalance || 0)
      cashForm.cashSales = parseFloat(currentDrawer.value.CashSales || 0)
      cashForm.cashPayouts = parseFloat(currentDrawer.value.CashPayouts || 0)
      cashForm.actualCash = parseFloat(currentDrawer.value.ActualCash || 0)
    }
  } catch (error) {
    console.error('Error fetching cash drawer:', error)
  }
}

// Helper Functions
const initializeReadingForms = () => {
  pumps.value.forEach(pump => {
    if (!pumpReadings.value[pump.PumpID]) {
      pumpReadings.value[pump.PumpID] = {
        opening: pump.MeterReading || 0,
        closing: '',
        pumpId: pump.PumpID
      }
    }
  })

  tanks.value.forEach(tank => {
    if (!tankReadings.value[tank.TankID]) {
      tankReadings.value[tank.TankID] = {
        dipReading: '',
        tankId: tank.TankID
      }
    }
  })
}

const populateExistingReadings = () => {
  dailyReadings.value.forEach(reading => {
    if (reading.PumpID && pumpReadings.value[reading.PumpID]) {
      pumpReadings.value[reading.PumpID].opening = reading.OpeningReading || 0
      pumpReadings.value[reading.PumpID].closing = reading.ClosingReading || ''
    }

    if (reading.TankID && tankReadings.value[reading.TankID]) {
      tankReadings.value[reading.TankID].dipReading = reading.DipReading || ''
    }
  })
}

const getProductName = (productId) => {
  const product = products.value.find(p => p.ProductID == productId)
  return product ? product.Name : 'Unknown'
}

const getTransactionItems = (transactionId) => {
  // This would typically fetch transaction items from API
  // For now, return empty array as placeholder
  return []
}

const calculatePumpSales = (pumpId) => {
  const reading = pumpReadings.value[pumpId]
  if (!reading || !reading.closing || !reading.opening) return '0.00'

  const sales = parseFloat(reading.closing) - parseFloat(reading.opening)
  return sales.toFixed(2)
}

const getTankFillPercentage = (tank) => {
  const reading = tankReadings.value[tank.TankID]
  if (!reading || !reading.dipReading) return 0

  const percentage = (parseFloat(reading.dipReading) / parseFloat(tank.Capacity)) * 100
  return Math.min(100, Math.max(0, percentage.toFixed(1)))
}

// Status Classes
const getPumpStatusClass = (status) => {
  const classes = {
    'Active': 'badge badge-light-success',
    'Inactive': 'badge badge-light-danger',
    'Maintenance': 'badge badge-light-warning'
  }
  return classes[status] || 'badge badge-light-secondary'
}

const getTankStatusClass = (status) => {
  const classes = {
    'Active': 'badge badge-light-success',
    'Inactive': 'badge badge-light-danger',
    'Maintenance': 'badge badge-light-warning'
  }
  return classes[status] || 'badge badge-light-secondary'
}

const getDrawerStatusClass = (status) => {
  const classes = {
    'Open': 'badge badge-light-success',
    'Closed': 'badge badge-light-secondary'
  }
  return classes[status] || 'badge badge-light-secondary'
}

const getVarianceClass = (variance) => {
  const val = parseFloat(variance)
  if (val > 5) return 'text-danger'
  if (val > 2) return 'text-warning'
  return 'text-success'
}

const getVarianceStatusClass = (variancePercent) => {
  const val = Math.abs(parseFloat(variancePercent))
  if (val > 5) return 'badge badge-light-danger'
  if (val > 2) return 'badge badge-light-warning'
  return 'badge badge-light-success'
}

const getVarianceStatus = (variancePercent) => {
  const val = Math.abs(parseFloat(variancePercent))
  if (val > 5) return 'Critical'
  if (val > 2) return 'Moderate'
  return 'Acceptable'
}

const getCashVarianceClass = () => {
  const variance = calculateCashVariance()
  if (Math.abs(variance) > 1000) return 'bg-light-danger text-danger'
  if (Math.abs(variance) > 500) return 'bg-light-warning text-warning'
  return 'bg-light-success text-success'
}

// Calculation Functions
const calculateExpectedCash = () => {
  return parseFloat(cashForm.openingBalance) + parseFloat(cashForm.cashSales) - parseFloat(cashForm.cashPayouts)
}

const calculateCashVariance = () => {
  return parseFloat(cashForm.actualCash) - calculateExpectedCash()
}

const formatCurrency = (amount) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0
  }).format(amount || 0)
}

// Chart Functions
const initializeCharts = () => {
  nextTick(() => {
    if (salesChart.value) {
      createSalesChart()
    }
    if (varianceChart.value) {
      createVarianceChart()
    }
  })
}

const createSalesChart = () => {
  // Simple chart implementation using CSS
  const chartData = generateSalesChartData()
  const chartHtml = `
    <div class="d-flex align-items-end justify-content-between h-100 gap-2">
      ${chartData.map((value, index) => `
        <div class="d-flex flex-column align-items-center flex-fill">
          <div class="bg-primary rounded" style="height: ${value}%; min-height: 20px; width: 100%;"></div>
          <small class="text-muted mt-2">${index + 1}</small>
        </div>
      `).join('')}
    </div>
  `
  salesChart.value.innerHTML = chartHtml
}

const createVarianceChart = () => {
  const chartData = generateVarianceChartData()
  const chartHtml = `
    <div class="d-flex align-items-center justify-content-between h-100 gap-2">
      ${chartData.map((value, index) => `
        <div class="d-flex flex-column align-items-center flex-fill">
          <div class="${value >= 0 ? 'bg-success' : 'bg-danger'} rounded"
               style="height: ${Math.abs(value * 10)}%; min-height: 10px; width: 100%;
                      margin-top: ${value >= 0 ? '0' : 'auto'}; margin-bottom: ${value >= 0 ? 'auto' : '0'};"></div>
          <small class="text-muted mt-2">Day ${index + 1}</small>
        </div>
      `).join('')}
    </div>
  `
  varianceChart.value.innerHTML = chartHtml
}

const generateSalesChartData = () => {
  // Generate sample data based on period
  const dataPoints = chartPeriod.value === 'today' ? 24 :
    chartPeriod.value === 'week' ? 7 : 30

  return Array.from({ length: dataPoints }, () => Math.random() * 100)
}

const generateVarianceChartData = () => {
  const dataPoints = varianceChartPeriod.value === '7days' ? 7 :
    varianceChartPeriod.value === '30days' ? 30 : 90

  return Array.from({ length: dataPoints }, () => (Math.random() - 0.5) * 10)
}

// Action Functions
const addPumpReading = async () => {
  const { value: pumpId } = await Swal.fire({
    title: 'Select Pump',
    input: 'select',
    inputOptions: pumps.value.reduce((options, pump) => {
      options[pump.PumpID] = pump.PumpName
      return options
    }, {}),
    inputPlaceholder: 'Choose a pump',
    showCancelButton: true,
    confirmButtonText: 'Add Reading',
    confirmButtonColor: '#3699ff'
  })

  if (pumpId) {
    const { value: formValues } = await Swal.fire({
      title: 'Add Pump Reading',
      html: `
        <div class="row g-3">
          <div class="col-6">
            <label class="form-label">Opening Reading</label>
            <input id="opening" type="number" step="0.01" class="form-control" value="${pumpReadings.value[pumpId]?.opening || 0}">
          </div>
          <div class="col-6">
            <label class="form-label">Closing Reading</label>
            <input id="closing" type="number" step="0.01" class="form-control" placeholder="0.00">
          </div>
        </div>
      `,
      focusConfirm: false,
      preConfirm: () => {
        return {
          opening: document.getElementById('opening').value,
          closing: document.getElementById('closing').value
        }
      },
      showCancelButton: true,
      confirmButtonText: 'Save Reading',
      confirmButtonColor: '#50cd89'
    })

    if (formValues) {
      pumpReadings.value[pumpId] = {
        ...pumpReadings.value[pumpId],
        opening: formValues.opening,
        closing: formValues.closing
      }

      showSuccessNotification('Pump reading added successfully')
    }
  }
}

const addTankReading = async () => {
  const { value: tankId } = await Swal.fire({
    title: 'Select Tank',
    input: 'select',
    inputOptions: tanks.value.reduce((options, tank) => {
      options[tank.TankID] = tank.TankName
      return options
    }, {}),
    inputPlaceholder: 'Choose a tank',
    showCancelButton: true,
    confirmButtonText: 'Add Reading',
    confirmButtonColor: '#3699ff'
  })

  if (tankId) {
    const { value: dipReading } = await Swal.fire({
      title: 'Tank Dip Reading',
      input: 'number',
      inputLabel: 'Current Dip Reading (Liters)',
      inputPlaceholder: 'Enter dip reading',
      inputAttributes: {
        step: '0.01',
        min: '0'
      },
      showCancelButton: true,
      confirmButtonText: 'Save Reading',
      confirmButtonColor: '#50cd89'
    })

    if (dipReading) {
      tankReadings.value[tankId] = {
        ...tankReadings.value[tankId],
        dipReading: dipReading
      }

      showSuccessNotification('Tank reading added successfully')
    }
  }
}

const generateReconciliation = () => {
  loading.value = true

  setTimeout(() => {
    // Calculate meter sales from pump readings
    const meterSales = Object.values(pumpReadings.value).reduce((sum, reading) => {
      return sum + (parseFloat(reading.closing || 0) - parseFloat(reading.opening || 0))
    }, 0)

    // Calculate system sales from transactions
    const systemSales = transactions.value
      .filter(t => new Date(t.TransactionDate).toDateString() === new Date().toDateString())
      .reduce((sum, t) => {
        const items = getTransactionItems(t.TransactionID)
        return sum + items.reduce((vol, item) => vol + parseFloat(item.Quantity || 0), 0)
      }, 0)

    const variance = meterSales - systemSales
    const variancePercent = systemSales > 0 ? (variance / systemSales * 100) : 0

    reconciliation.meterSales = meterSales.toFixed(2)
    reconciliation.systemSales = systemSales.toFixed(2)
    reconciliation.variance = variance.toFixed(2)
    reconciliation.variancePercent = variancePercent.toFixed(2)

    // Generate detailed reconciliation by product
    reconciliationDetails.value = products.value.map(product => {
      const productMeterSales = Object.values(pumpReadings.value)
        .filter(reading => {
          const pump = pumps.value.find(p => p.PumpID === reading.pumpId)
          return pump && getProductName(pump.ProductID) === product.Name
        })
        .reduce((sum, reading) => sum + (parseFloat(reading.closing || 0) - parseFloat(reading.opening || 0)), 0)

      const productSystemSales = Math.random() * 1000 // Placeholder
      const productVariance = productMeterSales - productSystemSales
      const productVariancePercent = productSystemSales > 0 ? (productVariance / productSystemSales * 100) : 0

      return {
        ProductID: product.ProductID,
        ProductName: product.Name,
        ProductType: product.ProductType,
        meterReading: productMeterSales.toFixed(2),
        systemSales: productSystemSales.toFixed(2),
        variance: productVariance.toFixed(2),
        variancePercent: productVariancePercent.toFixed(2)
      }
    })

    loading.value = false
    showSuccessNotification('Reconciliation calculated successfully')
  }, 1500)
}

const openCashDrawer = async () => {
  if (currentDrawer.value.DrawerID) {
    showWarningNotification('Cash drawer is already open')
    return
  }

  const { value: openingBalance } = await Swal.fire({
    title: 'Open Cash Drawer',
    input: 'number',
    inputLabel: 'Opening Balance (UGX)',
    inputPlaceholder: 'Enter opening cash amount',
    inputAttributes: {
      step: '0.01',
      min: '0'
    },
    showCancelButton: true,
    confirmButtonText: 'Open Drawer',
    confirmButtonColor: '#50cd89'
  })

  if (openingBalance) {
    try {
      loading.value = true

      const newDrawer = {
        StationID: currentStationID.value,
        ShiftDate: currentShiftDate.value,
        ShiftType: 'Day',
        AttendantID: currentUser.value.user?.id,
        OpeningBalance: openingBalance,
        ClosingBalance: 0,
        ExpectedCash: openingBalance,
        ActualCash: 0,
        Variance: 0,
        CashSales: 0,
        CashPayouts: 0,
        Status: 'Open',
        OpenedBy: currentUser.value.user?.id
      }

      const response = await makeAPICall('/CashDrawers', 'POST', newDrawer)
      currentDrawer.value = response
      cashForm.openingBalance = parseFloat(openingBalance)

      showSuccessNotification('Cash drawer opened successfully')
    } catch (error) {
      showErrorNotification('Failed to open cash drawer')
    } finally {
      loading.value = false
    }
  }
}

const closeCashDrawer = async () => {
  if (!currentDrawer.value.DrawerID) {
    showWarningNotification('No open cash drawer found')
    return
  }

  const result = await Swal.fire({
    title: 'Close Cash Drawer',
    text: 'Are you sure you want to close the cash drawer?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Close Drawer',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c'
  })

  if (result.isConfirmed) {
    try {
      loading.value = true

      const updateData = {
        ClosingBalance: cashForm.actualCash,
        ExpectedCash: calculateExpectedCash(),
        ActualCash: cashForm.actualCash,
        Variance: calculateCashVariance(),
        CashSales: cashForm.cashSales,
        CashPayouts: cashForm.cashPayouts,
        Status: 'Closed',
        ClosedBy: currentUser.value.user?.id,
        ClosedAt: new Date().toISOString()
      }

      await makeAPICall(`/CashDrawers/${currentDrawer.value.DrawerID}`, 'PATCH', updateData)
      currentDrawer.value = {}

      showSuccessNotification('Cash drawer closed successfully')
    } catch (error) {
      showErrorNotification('Failed to close cash drawer')
    } finally {
      loading.value = false
    }
  }
}

const saveAllReadings = async () => {
  loading.value = true

  try {
    const readingsToSave = []

    // Prepare pump readings
    Object.entries(pumpReadings.value).forEach(([pumpId, reading]) => {
      if (reading.opening !== '' && reading.closing !== '') {
        readingsToSave.push({
          StationID: currentStationID.value,
          ReadingDate: currentShiftDate.value,
          PumpID: parseInt(pumpId),
          OpeningReading: reading.opening,
          ClosingReading: reading.closing,
          CalculatedSales: parseFloat(reading.closing) - parseFloat(reading.opening),
          RecordedBy: currentUser.value.user?.id,
          Status: 'Pending'
        })
      }
    })

    // Prepare tank readings
    Object.entries(tankReadings.value).forEach(([tankId, reading]) => {
      if (reading.dipReading !== '') {
        readingsToSave.push({
          StationID: currentStationID.value,
          ReadingDate: currentShiftDate.value,
          TankID: parseInt(tankId),
          DipReading: reading.dipReading,
          RecordedBy: currentUser.value.user?.id,
          Status: 'Pending'
        })
      }
    })

    // Save all readings
    for (const reading of readingsToSave) {
      await makeAPICall('/DailyReadings', 'POST', reading)
    }

    showSuccessNotification(`${readingsToSave.length} readings saved successfully`)

  } catch (error) {
    console.error('Error saving readings:', error)
    showErrorNotification('Failed to save readings')
  } finally {
    loading.value = false
  }
}

const submitForApproval = async () => {
  const result = await Swal.fire({
    title: 'Submit for Approval',
    text: 'Submit all readings for manager approval?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Submit',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#3699ff'
  })

  if (result.isConfirmed) {
    loading.value = true

    try {
      // Create approval request
      const approvalRequest = {
        RequestType: 'DailyReadings',
        RequestTypeID: currentStationID.value,
        RequestTitle: `Daily Readings - ${currentStationName.value} - ${currentShiftDate.value}`,
        RequestDetails: `Daily pump and tank readings submission for approval`,
        RequesterUserID: currentUser.value.user?.id,
        RequesterStationID: currentStationID.value,
        Status: 'Pending',
        Priority: 'Normal'
      }

      await makeAPICall('/Approvals', 'POST', approvalRequest)

      showSuccessNotification('Readings submitted for approval successfully')

    } catch (error) {
      console.error('Error submitting for approval:', error)
      showErrorNotification('Failed to submit for approval')
    } finally {
      loading.value = false
    }
  }
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([
      fetchStationData(),
      fetchDailyReadings(),
      fetchTransactions(),
      fetchCashDrawer()
    ])
    showSuccessNotification('Data refreshed successfully')
  } catch (error) {
    showErrorNotification('Failed to refresh data')
  } finally {
    loading.value = false
  }
}

// Notification Functions
const showSuccessNotification = (message) => {
  Swal.fire({
    title: 'Success!',
    text: message,
    icon: 'success',
    toast: true,
    position: 'top-end',
    timer: 3000,
    showConfirmButton: false
  })
}

const showErrorNotification = (message) => {
  Swal.fire({
    title: 'Error!',
    text: message,
    icon: 'error',
    confirmButtonColor: '#f1416c'
  })
}

const showWarningNotification = (message) => {
  Swal.fire({
    title: 'Warning!',
    text: message,
    icon: 'warning',
    confirmButtonColor: '#ffc700'
  })
}

// Watchers
watch(chartPeriod, () => {
  createSalesChart()
})

watch(varianceChartPeriod, () => {
  createVarianceChart()
})

// Initialize Component
onMounted(async () => {
  console.log('📊 Daily Operations Management View Loaded')
  console.log('👤 Current User:', currentUser.value)
  console.log('🏢 Current Station ID:', currentStationID.value)

  loading.value = true

  try {
    await Promise.all([
      fetchStationData(),
      fetchDailyReadings(),
      fetchTransactions(),
      fetchCashDrawer()
    ])

    // Initialize charts after data is loaded
    initializeCharts()

  } catch (error) {
    console.error('Error initializing component:', error)
    showErrorNotification('Failed to load initial data')
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.nav-pills-custom .nav-link {
  border-radius: 8px;
  margin-right: 4px;
  transition: all 0.2s ease;
}

.nav-pills-custom .nav-link:hover {
  background-color: rgba(54, 153, 255, 0.1);
  transform: translateY(-1px);
}

.nav-pills-custom .nav-link.active {
  box-shadow: 0 4px 12px rgba(54, 153, 255, 0.3);
}

.card {
  border-radius: 12px;
  border: none;
  transition: all 0.2s ease;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.btn {
  border-radius: 8px;
  font-weight: 600;
  padding: 8px 16px;
  transition: all 0.2s ease;
}

.btn:hover {
  transform: translateY(-1px);
}

.form-control {
  border-radius: 8px;
  border: 1px solid #e4e6ef;
  transition: all 0.2s ease;
}

.form-control:focus {
  border-color: #3699ff;
  box-shadow: 0 0 0 0.2rem rgba(54, 153, 255, 0.25);
}

.table {
  border-radius: 8px;
  overflow: hidden;
}

.progress {
  border-radius: 8px;
  overflow: hidden;
}

.cursor-pointer {
  cursor: pointer;
}

/* Mobile optimizations */
@media (max-width: 768px) {
  .card-body {
    padding: 1rem;
  }

  .nav-pills-custom .nav-link {
    font-size: 0.875rem;
    padding: 0.75rem 1rem;
  }

  .fs-3 {
    font-size: 1.25rem !important;
  }

  .btn {
    padding: 12px 20px;
    font-size: 1rem;
  }
}
</style>

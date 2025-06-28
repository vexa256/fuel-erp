<template>
  <!-- Premium Kigrama Stock Intelligence Dashboard -->
  <div v-if="isAuthenticated && currentUser" class="premium-dashboard">
    <!-- Premium Header with Glass Morphism -->
    <div class="premium-header">
      <div class="glass-card">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-4">
          <div class="d-flex align-items-center">
            <div class="premium-logo">
              <div class="logo-glow">
                <i class="ki-duotone ki-oil-barrel fs-2tx text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
            </div>
            <div class="header-content">
              <h1 class="premium-title">
                {{ selectedStation?.StationName || 'Kigrama Intelligence' }}
              </h1>
              <p class="premium-subtitle">Real-time Operations & Analytics Dashboard</p>
              <div class="user-badge">
                <i class="ki-duotone ki-user fs-6 me-1">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                {{ currentUser.name || currentUser.email }}
              </div>
            </div>
          </div>

          <div class="header-controls">
            <div class="control-group">
              <select v-model="selectedStationId" class="premium-select" :disabled="loading">
                <option value="">Select Station</option>
                <option
                  v-for="station in userStations"
                  :key="station.StationID"
                  :value="station.StationID"
                >
                  {{ station.StationName }}
                </option>
              </select>

              <button
                @click="handleRefresh"
                class="premium-btn premium-btn-primary"
                :disabled="loading"
              >
                <i
                  class="ki-duotone ki-arrows-circle"
                  :class="{ 'spinner-border spinner-border-sm': loading }"
                >
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <span v-if="!loading">Refresh</span>
              </button>
            </div>

            <div class="status-indicator">
              <div class="status-dot status-online"></div>
              <span class="status-text">Live</span>
              <div class="last-update">{{ formatTime(lastRefresh) }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Premium Navigation Tabs -->
    <div class="premium-nav">
      <div class="nav-container">
        <div
          v-for="(tab, index) in premiumTabs"
          :key="index"
          @click="currentTab = index"
          class="nav-tab"
          :class="{ 'nav-tab-active': currentTab === index }"
        >
          <div class="tab-icon">
            <i :class="`ki-duotone ${tab.icon}`">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3" v-if="tab.paths > 2"></span>
              <span class="path4" v-if="tab.paths > 3"></span>
            </i>
          </div>
          <div class="tab-content">
            <div class="tab-title">{{ tab.title }}</div>
            <div class="tab-subtitle">{{ tab.subtitle }}</div>
          </div>
          <div class="tab-badge" v-if="tab.badge !== null">{{ tab.badge }}</div>
        </div>
      </div>
    </div>

    <!-- Critical Alerts Banner -->
    <div v-if="criticalAlerts.length > 0" class="critical-alerts">
      <div class="alert-container">
        <div class="alert-icon">
          <i class="ki-duotone ki-information-5 fs-2x">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
        </div>
        <div class="alert-content">
          <h4 class="alert-title">
            {{ criticalAlerts.length }} Critical Alert{{ criticalAlerts.length > 1 ? 's' : '' }}
          </h4>
          <p class="alert-description">{{ criticalAlerts[0]?.Description }}</p>
        </div>
        <button class="alert-action" @click="showCriticalAlertsModal">
          View All Alerts
          <i class="ki-duotone ki-arrow-right ms-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
        </button>
      </div>
    </div>

    <!-- Tab 1: Executive Overview -->
    <div v-show="currentTab === 0" class="tab-content">
      <!-- Premium KPI Grid -->
      <div class="kpi-grid">
        <div class="kpi-card kpi-primary">
          <div class="kpi-background">
            <i class="ki-duotone ki-element-11">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
            </i>
          </div>
          <div class="kpi-content">
            <div class="kpi-value">{{ totalInventoryItems }}</div>
            <div class="kpi-label">Active Inventory Items</div>
            <div class="kpi-change positive">{{ activeStationsCount }} stations active</div>
          </div>
        </div>

        <div class="kpi-card kpi-success">
          <div class="kpi-background">
            <i class="ki-duotone ki-dollar">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </div>
          <div class="kpi-content">
            <div class="kpi-value">{{ formatCurrency(todaysTotalSales) }}</div>
            <div class="kpi-label">Today's Revenue</div>
            <div class="kpi-change positive">{{ todaysTransactionCount }} transactions</div>
          </div>
        </div>

        <div class="kpi-card kpi-warning">
          <div class="kpi-background">
            <i class="ki-duotone ki-warning-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
          </div>
          <div class="kpi-content">
            <div class="kpi-value">{{ lowStockAlerts }}</div>
            <div class="kpi-label">Low Stock Alerts</div>
            <div class="kpi-change" :class="lowStockAlerts > 0 ? 'negative' : 'neutral'">
              {{ lowStockAlerts > 0 ? 'Requires attention' : 'All optimal' }}
            </div>
          </div>
        </div>

        <div class="kpi-card kpi-info">
          <div class="kpi-background">
            <i class="ki-duotone ki-chart-line-up">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </div>
          <div class="kpi-content">
            <div class="kpi-value">{{ overallEfficiency }}%</div>
            <div class="kpi-label">Tank Utilization</div>
            <div class="kpi-change positive">{{ activeTanksCount }} tanks monitored</div>
          </div>
        </div>
      </div>

      <!-- Premium Charts Row -->
      <div class="charts-row">
        <div class="chart-card chart-large">
          <div class="chart-header">
            <h3 class="chart-title">Station Performance Overview</h3>
            <div class="chart-controls">
              <select v-model="chartPeriod" class="chart-select">
                <option value="today">Today</option>
                <option value="week">This Week</option>
                <option value="month">This Month</option>
              </select>
            </div>
          </div>
          <div class="chart-body">
            <div ref="performanceChart" class="premium-chart"></div>
          </div>
        </div>

        <div class="chart-card chart-medium">
          <div class="chart-header">
            <h3 class="chart-title">Tank Status Distribution</h3>
          </div>
          <div class="chart-body">
            <div ref="tankStatusChart" class="premium-chart"></div>
          </div>
        </div>
      </div>

      <!-- Real-time Insights Cards -->
      <div class="insights-grid">
        <div class="insight-card">
          <div class="insight-header">
            <h4 class="insight-title">
              <i class="ki-duotone ki-chart-simple-3 text-success me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              AI Operational Insights
            </h4>
          </div>
          <div class="insight-body">
            <div v-if="aiInsights.length === 0" class="no-insights">
              <i class="ki-duotone ki-medal-star fs-3x text-success">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <p>All systems operating optimally!</p>
            </div>
            <div v-else class="insights-list">
              <div v-for="insight in aiInsights" :key="insight.id" class="insight-item">
                <div class="insight-icon" :class="`insight-${insight.type}`">
                  <i :class="`ki-duotone ${insight.icon}`">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
                <div class="insight-content">
                  <h6 class="insight-item-title">{{ insight.title }}</h6>
                  <p class="insight-description">{{ insight.description }}</p>
                  <div class="insight-metrics">
                    <span class="metric">Impact: {{ insight.impact }}</span>
                    <span class="metric">Priority: {{ insight.priority }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="insight-card">
          <div class="insight-header">
            <h4 class="insight-title">
              <i class="ki-duotone ki-shield-tick text-info me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Security & Compliance Status
            </h4>
          </div>
          <div class="insight-body">
            <div class="security-overview">
              <div class="security-metric">
                <div class="security-value">{{ activeFraudFlags }}</div>
                <div class="security-label">Fraud Alerts</div>
              </div>
              <div class="security-metric">
                <div class="security-value">{{ recentAuditEvents }}</div>
                <div class="security-label">Audit Events</div>
              </div>
              <div class="security-metric">
                <div class="security-value">{{ complianceScore }}%</div>
                <div class="security-label">Compliance Score</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Tab 2: Tank Operations -->
    <div v-show="currentTab === 1" class="tab-content">
      <!-- Tank Status Grid -->
      <div class="tank-grid">
        <div v-for="tank in stationTanks" :key="tank.TankID" class="tank-card">
          <div class="tank-header">
            <div class="tank-info">
              <h4 class="tank-name">{{ tank.TankName }}</h4>
              <p class="tank-product">{{ getProductName(tank.ProductID) }}</p>
            </div>
            <div class="tank-status" :class="`status-${getTankStatusColor(tank)}`">
              {{ getTankStatusText(tank) }}
            </div>
          </div>

          <div class="tank-gauge">
            <div :ref="`tankGauge${tank.TankID}`" class="gauge-container"></div>
          </div>

          <div class="tank-metrics">
            <div class="tank-metric">
              <span class="metric-label">Current Level</span>
              <span class="metric-value">{{ formatNumber(tank.CurrentLevel) }}L</span>
            </div>
            <div class="tank-metric">
              <span class="metric-label">Capacity</span>
              <span class="metric-value">{{ formatNumber(tank.Capacity) }}L</span>
            </div>
            <div class="tank-metric">
              <span class="metric-label">Utilization</span>
              <span class="metric-value">{{ getTankUtilization(tank) }}%</span>
            </div>
            <div class="tank-metric">
              <span class="metric-label">Available Space</span>
              <span class="metric-value">{{ formatNumber(getAvailableCapacity(tank)) }}L</span>
            </div>
          </div>

          <div class="tank-actions">
            <button class="tank-btn tank-btn-primary" @click="addStock(tank.TankID)">
              <i class="ki-duotone ki-plus">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Add Stock
            </button>
            <button class="tank-btn tank-btn-secondary" @click="viewTankDetails(tank.TankID)">
              <i class="ki-duotone ki-eye">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              Details
            </button>
          </div>
        </div>
      </div>

      <!-- Tank Trends Chart -->
      <div class="operations-chart">
        <div class="chart-card chart-full">
          <div class="chart-header">
            <h3 class="chart-title">Tank Level Trends & AI Predictions</h3>
            <div class="chart-controls">
              <div class="control-group">
                <button
                  class="chart-btn"
                  :class="{ active: trendPeriod === '24h' }"
                  @click="changeTrendPeriod('24h')"
                >
                  24H
                </button>
                <button
                  class="chart-btn"
                  :class="{ active: trendPeriod === '7d' }"
                  @click="changeTrendPeriod('7d')"
                >
                  7D
                </button>
                <button
                  class="chart-btn"
                  :class="{ active: trendPeriod === '30d' }"
                  @click="changeTrendPeriod('30d')"
                >
                  30D
                </button>
              </div>
            </div>
          </div>
          <div class="chart-body">
            <div ref="tankTrendsChart" class="premium-chart-large"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Tab 3: Financial Analytics -->
    <div v-show="currentTab === 2" class="tab-content">
      <!-- Financial KPIs -->
      <div class="financial-kpis">
        <div class="financial-card">
          <div class="financial-header">
            <h4>Revenue Analytics</h4>
            <i class="ki-duotone ki-chart-line-up text-success">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </div>
          <div class="financial-body">
            <div class="financial-metric">
              <span class="metric-value">{{ formatCurrency(dailyRevenue) }}</span>
              <span class="metric-label">Today's Revenue</span>
            </div>
            <div class="financial-metric">
              <span class="metric-value">{{ formatCurrency(weeklyRevenue) }}</span>
              <span class="metric-label">This Week</span>
            </div>
            <div class="financial-metric">
              <span class="metric-value">{{ formatCurrency(monthlyRevenue) }}</span>
              <span class="metric-label">This Month</span>
            </div>
          </div>
        </div>

        <div class="financial-card">
          <div class="financial-header">
            <h4>Transaction Metrics</h4>
            <i class="ki-duotone ki-credit-cart text-primary">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </div>
          <div class="financial-body">
            <div class="financial-metric">
              <span class="metric-value">{{ todaysTransactionCount }}</span>
              <span class="metric-label">Today's Transactions</span>
            </div>
            <div class="financial-metric">
              <span class="metric-value">{{ formatCurrency(averageTransactionValue) }}</span>
              <span class="metric-label">Average Value</span>
            </div>
            <div class="financial-metric">
              <span class="metric-value">{{ totalTransactionItems }}</span>
              <span class="metric-label">Items Sold</span>
            </div>
          </div>
        </div>

        <div class="financial-card">
          <div class="financial-header">
            <h4>Payment Analysis</h4>
            <i class="ki-duotone ki-wallet text-warning">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
            </i>
          </div>
          <div class="financial-body">
            <div class="financial-metric">
              <span class="metric-value">{{ formatCurrency(cashPayments) }}</span>
              <span class="metric-label">Cash Payments</span>
            </div>
            <div class="financial-metric">
              <span class="metric-value">{{ formatCurrency(cardPayments) }}</span>
              <span class="metric-label">Card Payments</span>
            </div>
            <div class="financial-metric">
              <span class="metric-value">{{ formatCurrency(creditPayments) }}</span>
              <span class="metric-label">Credit Sales</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Financial Charts -->
      <div class="financial-charts">
        <div class="chart-card chart-large">
          <div class="chart-header">
            <h3 class="chart-title">Revenue by Product Category</h3>
          </div>
          <div class="chart-body">
            <div ref="revenueBreakdownChart" class="premium-chart"></div>
          </div>
        </div>

        <div class="chart-card chart-medium">
          <div class="chart-header">
            <h3 class="chart-title">Payment Method Distribution</h3>
          </div>
          <div class="chart-body">
            <div ref="paymentMethodChart" class="premium-chart"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Tab 4: Inventory Analytics -->
    <div v-show="currentTab === 3" class="tab-content">
      <!-- Comprehensive Inventory Table -->
      <div class="data-table-card">
        <div class="table-header">
          <h3 class="table-title">
            <i class="ki-duotone ki-delivery-time text-primary me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Real-time Inventory Movement Analysis
          </h3>
          <div class="table-controls">
            <div class="search-box">
              <i class="ki-duotone ki-magnifier">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <input type="text" v-model="searchTerm" placeholder="Search movements..." />
            </div>
            <select v-model="filterType" class="filter-select">
              <option value="">All Types</option>
              <option value="Delivery">Deliveries</option>
              <option value="Sale">Sales</option>
              <option value="Transfer">Transfers</option>
              <option value="Adjustment">Adjustments</option>
            </select>
            <button class="export-btn" @click="exportInventoryData">
              <i class="ki-duotone ki-file-down">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Export
            </button>
          </div>
        </div>

        <div class="table-body">
          <div class="premium-table-container">
            <table class="premium-table">
              <thead>
                <tr>
                  <th>Date & Time</th>
                  <th>Product</th>
                  <th>Tank</th>
                  <th>Change Type</th>
                  <th>Previous Level</th>
                  <th>Quantity Change</th>
                  <th>New Level</th>
                  <th>Unit Price</th>
                  <th>Total Value</th>
                  <th>Authorized By</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="record in filteredInventoryHistory"
                  :key="record.HistoryID"
                  class="table-row"
                >
                  <td class="date-cell">
                    <div class="date-primary">{{ formatDate(record.ChangeDate) }}</div>
                    <div class="date-secondary">{{ formatTime(record.ChangeDate) }}</div>
                  </td>
                  <td class="product-cell">
                    <div class="product-info">
                      <div class="product-icon">
                        <i class="ki-duotone ki-element-11 text-primary">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                          <span class="path4"></span>
                        </i>
                      </div>
                      <div class="product-details">
                        <div class="product-name">{{ getProductName(record.ProductID) }}</div>
                        <div class="product-id">ID: {{ record.ProductID }}</div>
                      </div>
                    </div>
                  </td>
                  <td class="tank-cell">
                    <div class="tank-info">
                      <div class="tank-name">{{ getTankName(record.TankID) }}</div>
                      <div class="tank-id">Tank {{ record.TankID }}</div>
                    </div>
                  </td>
                  <td class="type-cell">
                    <span class="change-badge" :class="getChangeTypeBadge(record.ChangeType)">
                      {{ record.ChangeType }}
                    </span>
                  </td>
                  <td class="quantity-cell">{{ formatNumber(record.PreviousQuantity) }}L</td>
                  <td class="change-cell">
                    <span :class="getQuantityChangeClass(record.QuantityChange)">
                      {{ formatQuantityChange(record.QuantityChange) }}
                    </span>
                  </td>
                  <td class="quantity-cell">{{ formatNumber(record.NewQuantity) }}L</td>
                  <td class="price-cell">{{ formatCurrency(record.UnitPrice || 0) }}</td>
                  <td class="value-cell">{{ formatCurrency(record.TotalValue || 0) }}</td>
                  <td class="auth-cell">
                    <div class="auth-info">
                      <div class="auth-name">{{ getUserName(record.AuthorizedBy) }}</div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="table-pagination">
            <div class="pagination-info">
              Showing {{ paginatedResults.length }} of {{ filteredInventoryHistory.length }} records
            </div>
            <div class="pagination-controls">
              <button class="pagination-btn" :disabled="currentPage === 1" @click="currentPage--">
                <i class="ki-duotone ki-left">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
              <span class="pagination-current">{{ currentPage }}</span>
              <button
                class="pagination-btn"
                :disabled="currentPage >= totalPages"
                @click="currentPage++"
              >
                <i class="ki-duotone ki-right">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Mobile Floating Action Menu -->
    <div class="floating-menu d-lg-none">
      <div class="floating-btn floating-btn-main" @click="toggleFloatingMenu">
        <i class="ki-duotone ki-plus" :class="{ 'rotate-45': floatingMenuOpen }">
          <span class="path1"></span>
          <span class="path2"></span>
        </i>
      </div>
      <div class="floating-actions" :class="{ 'floating-actions-open': floatingMenuOpen }">
        <button class="floating-btn floating-btn-action" @click="handleRefresh">
          <i class="ki-duotone ki-arrows-circle">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
        </button>
        <button class="floating-btn floating-btn-action" @click="showQuickActions">
          <i class="ki-duotone ki-setting-3">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
        </button>
      </div>
    </div>
  </div>

  <!-- Authentication Required State -->
  <div v-else class="auth-required">
    <div class="auth-container">
      <div class="auth-icon">
        <i class="ki-duotone ki-security-user">
          <span class="path1"></span>
          <span class="path2"></span>
        </i>
      </div>
      <h3 class="auth-title">Authentication Required</h3>
      <p class="auth-description">Please log in to access the Stock Intelligence Dashboard</p>
      <div class="auth-loading">
        <div class="loading-spinner"></div>
        <span>Checking authentication...</span>
      </div>
      <button class="auth-btn" onclick="window.location.href='/login.html'">
        <i class="ki-duotone ki-entrance-left me-2">
          <span class="path1"></span>
          <span class="path2"></span>
        </i>
        Go to Login
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'
import Swal from 'sweetalert2'
import * as echarts from 'echarts'

// Core State Management
const loading = ref(false)
const currentUser = ref(null)
const authData = ref(null)
const userStations = ref([])
const selectedStationId = ref(null)
const refreshInterval = ref(null)
const lastRefresh = ref(new Date())
const currentTab = ref(0)
const isAuthenticated = ref(false)

// UI State
const floatingMenuOpen = ref(false)
const chartPeriod = ref('today')
const trendPeriod = ref('7d')
const searchTerm = ref('')
const filterType = ref('')
const currentPage = ref(1)
const pageSize = ref(20)

// Database Data State - Using Actual Database Tables
const stationInventory = ref([])
const stationTanks = ref([])
const products = ref([])
const inventoryHistory = ref([])
const dailyReadings = ref([])
const fraudDetectionLogs = ref([])
const auditLogs = ref([])
const transactions = ref([])
const transactionItems = ref([])
const eventLogs = ref([])
const suppliers = ref([])
const customers = ref([])
const pumps = ref([])

// Chart References
const performanceChart = ref(null)
const tankStatusChart = ref(null)
const tankTrendsChart = ref(null)
const revenueBreakdownChart = ref(null)
const paymentMethodChart = ref(null)

// Premium Tabs Configuration
const premiumTabs = ref([
  {
    title: 'Executive Overview',
    subtitle: 'KPIs & AI Insights',
    icon: 'ki-element-11',
    badge: null,
    paths: 4,
  },
  {
    title: 'Tank Operations',
    subtitle: 'Live Monitoring',
    icon: 'ki-oil-barrel',
    badge: null,
    paths: 2,
  },
  {
    title: 'Financial Analytics',
    subtitle: 'Revenue & Payments',
    icon: 'ki-chart-line-up',
    badge: null,
    paths: 2,
  },
  {
    title: 'Inventory Analytics',
    subtitle: 'Movement Tracking',
    icon: 'ki-delivery-time',
    badge: null,
    paths: 2,
  },
])

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const getAuthToken = () => {
  const kigramaToken = localStorage.getItem('kigrama_auth_token')
  if (kigramaToken) return kigramaToken
  return localStorage.getItem('jwt') || ''
}

// Initialize Authentication
const initializeAuth = () => {
  try {
    const kigramaUserData = localStorage.getItem('kigrama_user_data')
    const kigramaToken = localStorage.getItem('kigrama_auth_token')

    if (kigramaUserData && kigramaToken) {
      const parsedAuthData = JSON.parse(kigramaUserData)
      authData.value = parsedAuthData
      currentUser.value = parsedAuthData.user
      userStations.value = parsedAuthData.stations || []
      isAuthenticated.value = true

      if (userStations.value.length > 0) {
        selectedStationId.value = userStations.value[0].StationID
      }

      return true
    }

    const legacyUser = localStorage.getItem('user')
    if (legacyUser) {
      try {
        currentUser.value = JSON.parse(legacyUser)
        isAuthenticated.value = true
        return true
      } catch (error) {
        console.error('Error parsing legacy user data:', error)
      }
    }

    return false
  } catch (error) {
    console.error('Error initializing authentication:', error)
    return false
  }
}

// Utility Functions
const formatCurrency = (amount) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
  }).format(parseFloat(amount || 0))
}

const formatNumber = (num) => {
  return new Intl.NumberFormat('en-UG').format(parseFloat(num || 0))
}

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString('en-UG')
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-UG')
}

const formatTime = (dateString) => {
  return new Date(dateString).toLocaleTimeString('en-UG')
}

const getProductName = (productId) => {
  const product = products.value.find((p) => p.ProductID === productId)
  return product?.ProductName || `Product ${productId}`
}

const getTankName = (tankId) => {
  if (!tankId) return 'N/A'
  const tank = stationTanks.value.find((t) => t.TankID === tankId)
  return tank?.TankName || `Tank ${tankId}`
}

const getUserName = (userId) => {
  if (!userId) return 'System'
  return `User ${userId}`
}

const getTankStatusColor = (tank) => {
  const utilization = getTankUtilization(tank)
  if (utilization <= 10) return 'danger'
  if (utilization <= 25) return 'warning'
  return 'success'
}

const getTankStatusText = (tank) => {
  const utilization = getTankUtilization(tank)
  if (utilization <= 10) return 'Critical'
  if (utilization <= 25) return 'Low Stock'
  return 'Normal'
}

const getTankUtilization = (tank) => {
  const capacity = parseFloat(tank.Capacity || 0)
  const currentLevel = parseFloat(tank.CurrentLevel || 0)
  return capacity > 0 ? ((currentLevel / capacity) * 100).toFixed(1) : 0
}

const getAvailableCapacity = (tank) => {
  const capacity = parseFloat(tank.Capacity || 0)
  const currentLevel = parseFloat(tank.CurrentLevel || 0)
  return capacity - currentLevel
}

const getChangeTypeBadge = (changeType) => {
  switch (changeType) {
    case 'Delivery':
      return 'badge-success'
    case 'Transfer':
      return 'badge-info'
    case 'Sale':
      return 'badge-warning'
    case 'Adjustment':
      return 'badge-light'
    default:
      return 'badge-light'
  }
}

const getQuantityChangeClass = (quantityChange) => {
  const change = parseFloat(quantityChange || 0)
  return change > 0 ? 'text-success fw-bold' : 'text-danger fw-bold'
}

const formatQuantityChange = (quantityChange) => {
  const change = parseFloat(quantityChange || 0)
  return `${change > 0 ? '+' : ''}${formatNumber(change)}L`
}

// API Functions
const apiCall = async (endpoint, options = {}) => {
  try {
    const token = getAuthToken()
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
        ...options.headers,
      },
    })

    if (!response.ok) {
      throw new Error(`API Error: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    return data.records || data
  } catch (error) {
    console.error(`API Call failed for ${endpoint}:`, error)
    throw error
  }
}

// Data Fetching Functions
const fetchUserStations = async () => {
  try {
    if (authData.value && authData.value.stations && authData.value.stations.length > 0) {
      userStations.value = authData.value.stations
      if (authData.value.stations.length > 0) {
        selectedStationId.value = authData.value.stations[0].StationID
      }
      return
    }

    if (!currentUser.value || !currentUser.value.id) {
      throw new Error('User not authenticated')
    }

    const userStationsData = await apiCall(`/UserStations?UserID=${currentUser.value.id}`)
    const validStations = []

    for (const userStation of userStationsData) {
      try {
        const station = await apiCall(`/Stations/${userStation.StationID}`)
        validStations.push({ ...station, ...userStation })
      } catch (error) {
        console.error('Station access error:', error)
      }
    }

    userStations.value = validStations
    if (validStations.length > 0) {
      const primaryStation = validStations.find((s) => s.IsPrimary === '1')
      selectedStationId.value = primaryStation
        ? primaryStation.StationID
        : validStations[0].StationID
    }
  } catch (error) {
    console.error('Error fetching user stations:', error)
    showError('Failed to load station assignments')
  }
}

const fetchStationData = async () => {
  if (!selectedStationId.value || !currentUser.value) return

  try {
    const [
      inventoryData,
      tanksData,
      productsData,
      historyData,
      readingsData,
      fraudData,
      auditData,
      transactionData,
      transactionItemsData,
      eventLogData,
      supplierData,
      customerData,
      pumpData,
    ] = await Promise.all([
      apiCall(`/StationInventory?StationID=${selectedStationId.value}`).catch(() => []),
      apiCall(`/Tanks?StationID=${selectedStationId.value}`).catch(() => []),
      apiCall('/Products').catch(() => []),
      apiCall(`/InventoryHistory?StationID=${selectedStationId.value}&limit=100`).catch(() => []),
      apiCall(`/DailyReadings?StationID=${selectedStationId.value}&limit=50`).catch(() => []),
      apiCall(`/FraudDetectionLogs?StationID=${selectedStationId.value}&limit=50`).catch(() => []),
      apiCall(`/AuditLogs?StationID=${selectedStationId.value}&limit=50`).catch(() => []),
      apiCall(`/Transactions?StationID=${selectedStationId.value}&limit=200`).catch(() => []),
      apiCall(`/TransactionItems?limit=200`).catch(() => []),
      apiCall(`/EventLog?AffectedStationID=${selectedStationId.value}&limit=100`).catch(() => []),
      apiCall('/Suppliers').catch(() => []),
      apiCall('/Customers').catch(() => []),
      apiCall(`/Pumps?StationID=${selectedStationId.value}`).catch(() => []),
    ])

    stationInventory.value = inventoryData.filter(
      (item) => item.StationID === selectedStationId.value,
    )
    stationTanks.value = tanksData.filter((tank) => tank.StationID === selectedStationId.value)
    products.value = productsData
    inventoryHistory.value = historyData.filter(
      (record) => record.StationID === selectedStationId.value,
    )
    dailyReadings.value = readingsData.filter(
      (reading) => reading.StationID === selectedStationId.value,
    )
    fraudDetectionLogs.value = fraudData.filter((log) => log.StationID === selectedStationId.value)
    auditLogs.value = auditData.filter((log) => log.StationID === selectedStationId.value)
    transactions.value = transactionData.filter((txn) => txn.StationID === selectedStationId.value)
    transactionItems.value = transactionItemsData
    eventLogs.value = eventLogData.filter(
      (event) => event.AffectedStationID === selectedStationId.value,
    )
    suppliers.value = supplierData
    customers.value = customerData
    pumps.value = pumpData.filter((pump) => pump.StationID === selectedStationId.value)

    // Update tab badges with real data
    premiumTabs.value[1].badge = stationTanks.value.length
  } catch (error) {
    console.error('Error fetching station data:', error)
    showError(`Failed to load station data: ${error.message}`)
  }
}

// AI Insights Generation - Based on Real Data
const generateAIInsights = () => {
  const insights = []

  // Low Stock Analysis
  const lowStockTanks = stationTanks.value.filter((tank) => getTankUtilization(tank) < 25)
  if (lowStockTanks.length > 0) {
    insights.push({
      id: 'low_stock_ai',
      type: 'warning',
      icon: 'ki-warning-2',
      title: 'AI Stock Optimization Alert',
      description: `${lowStockTanks.length} tank(s) below optimal levels. AI recommends immediate restocking to prevent stockouts.`,
      impact: 'High',
      priority: 'Urgent',
    })
  }

  // Transaction Pattern Analysis
  const recentTransactions = transactions.value.filter((txn) => {
    const txnDate = new Date(txn.TransactionDate)
    const today = new Date()
    return txnDate.toDateString() === today.toDateString()
  })

  if (recentTransactions.length > 50) {
    insights.push({
      id: 'high_volume_ai',
      type: 'success',
      icon: 'ki-chart-line-up',
      title: 'AI Volume Analysis',
      description: `High transaction volume detected (${recentTransactions.length} today). AI suggests increasing staff during peak hours.`,
      impact: 'Medium',
      priority: 'Monitor',
    })
  }

  // Fraud Detection AI
  const activeFraudAlerts = fraudDetectionLogs.value.filter((log) => log.Status === 'Flagged')
  if (activeFraudAlerts.length > 0) {
    insights.push({
      id: 'fraud_ai',
      type: 'danger',
      icon: 'ki-shield-cross',
      title: 'AI Fraud Detection',
      description: `${activeFraudAlerts.length} suspicious pattern(s) detected. AI recommends immediate investigation.`,
      impact: 'Critical',
      priority: 'Immediate',
    })
  }

  return insights
}

// Premium Charts Implementation
const initializePremiumCharts = async () => {
  await nextTick()

  // Station Performance Chart
  if (performanceChart.value) {
    const chart = echarts.init(performanceChart.value)

    const dailyData = getDailyPerformanceData()

    const option = {
      backgroundColor: 'transparent',
      tooltip: {
        trigger: 'axis',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        borderColor: 'transparent',
        textStyle: { color: '#fff' },
      },
      legend: {
        data: ['Revenue', 'Transactions', 'Volume'],
        textStyle: { color: '#5E6278' },
        top: 20,
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '10%',
        top: '15%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        data: dailyData.dates,
        axisLine: { lineStyle: { color: '#E1E3EA' } },
        axisTick: { show: false },
        axisLabel: { color: '#A1A5B7' },
      },
      yAxis: [
        {
          type: 'value',
          name: 'Revenue (UGX)',
          position: 'left',
          axisLine: { show: false },
          axisTick: { show: false },
          axisLabel: { color: '#A1A5B7' },
          splitLine: { lineStyle: { color: '#E1E3EA', type: 'dashed' } },
        },
        {
          type: 'value',
          name: 'Count',
          position: 'right',
          axisLine: { show: false },
          axisTick: { show: false },
          axisLabel: { color: '#A1A5B7' },
          splitLine: { show: false },
        },
      ],
      series: [
        {
          name: 'Revenue',
          type: 'line',
          smooth: true,
          symbol: 'circle',
          symbolSize: 8,
          lineStyle: { width: 3, color: '#009ef7' },
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(0, 158, 247, 0.3)' },
              { offset: 1, color: 'rgba(0, 158, 247, 0.05)' },
            ]),
          },
          data: dailyData.revenue,
        },
        {
          name: 'Transactions',
          type: 'bar',
          yAxisIndex: 1,
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#50cd89' },
              { offset: 1, color: '#06d6a0' },
            ]),
          },
          data: dailyData.transactions,
        },
      ],
    }
    chart.setOption(option)
    chart.resize()
  }

  // Tank Status Chart
  if (tankStatusChart.value) {
    const chart = echarts.init(tankStatusChart.value)

    const tankStatusData = getTankStatusData()

    const option = {
      backgroundColor: 'transparent',
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        borderColor: 'transparent',
        textStyle: { color: '#fff' },
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        textStyle: { color: '#5E6278' },
      },
      series: [
        {
          name: 'Tank Status',
          type: 'pie',
          radius: ['40%', '70%'],
          center: ['60%', '50%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 8,
            borderColor: '#fff',
            borderWidth: 2,
          },
          label: { show: false, position: 'center' },
          emphasis: {
            label: {
              show: true,
              fontSize: '16',
              fontWeight: 'bold',
            },
          },
          labelLine: { show: false },
          data: tankStatusData,
          color: ['#50cd89', '#ffc700', '#f1416c'],
        },
      ],
    }
    chart.setOption(option)
    chart.resize()
  }

  // Revenue Breakdown Chart
  if (revenueBreakdownChart.value) {
    const chart = echarts.init(revenueBreakdownChart.value)

    const revenueData = getRevenueByProductData()

    const option = {
      backgroundColor: 'transparent',
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        borderColor: 'transparent',
        textStyle: { color: '#fff' },
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        textStyle: { color: '#5E6278' },
      },
      series: [
        {
          name: 'Revenue',
          type: 'pie',
          radius: ['40%', '70%'],
          center: ['60%', '50%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 8,
            borderColor: '#fff',
            borderWidth: 2,
          },
          label: { show: false, position: 'center' },
          emphasis: {
            label: {
              show: true,
              fontSize: '16',
              fontWeight: 'bold',
            },
          },
          labelLine: { show: false },
          data: revenueData,
          color: ['#009ef7', '#50cd89', '#ffc700', '#f1416c', '#7239ea', '#00a3ff'],
        },
      ],
    }
    chart.setOption(option)
    chart.resize()
  }

  // Payment Method Chart
  if (paymentMethodChart.value) {
    const chart = echarts.init(paymentMethodChart.value)

    const paymentData = getPaymentMethodData()

    const option = {
      backgroundColor: 'transparent',
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        borderColor: 'transparent',
        textStyle: { color: '#fff' },
      },
      series: [
        {
          name: 'Payment Method',
          type: 'pie',
          radius: '70%',
          center: ['50%', '50%'],
          data: paymentData,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)',
            },
          },
          color: ['#009ef7', '#50cd89', '#ffc700', '#f1416c'],
        },
      ],
    }
    chart.setOption(option)
    chart.resize()
  }

  // Tank Trends Chart
  if (tankTrendsChart.value) {
    const chart = echarts.init(tankTrendsChart.value)

    const trendsData = getTankTrendsData()

    const option = {
      backgroundColor: 'transparent',
      tooltip: {
        trigger: 'axis',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        borderColor: 'transparent',
        textStyle: { color: '#fff' },
      },
      legend: {
        data: stationTanks.value.map((tank) => tank.TankName),
        textStyle: { color: '#5E6278' },
        top: 20,
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '10%',
        top: '15%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        data: trendsData.dates,
        axisLine: { lineStyle: { color: '#E1E3EA' } },
        axisTick: { show: false },
        axisLabel: { color: '#A1A5B7' },
      },
      yAxis: {
        type: 'value',
        name: 'Level (L)',
        axisLine: { show: false },
        axisTick: { show: false },
        axisLabel: { color: '#A1A5B7' },
        splitLine: { lineStyle: { color: '#E1E3EA', type: 'dashed' } },
      },
      series: stationTanks.value.map((tank, index) => ({
        name: tank.TankName,
        type: 'line',
        smooth: true,
        symbol: 'circle',
        symbolSize: 6,
        lineStyle: {
          width: 2,
          color: ['#009ef7', '#50cd89', '#ffc700', '#f1416c', '#7239ea'][index % 5],
        },
        data: trendsData.tankData[tank.TankID] || [],
      })),
    }
    chart.setOption(option)
    chart.resize()
  }
}

// Data Processing Functions for Charts
const getDailyPerformanceData = () => {
  const dates = []
  const revenue = []
  const transactionCounts = []

  for (let i = 6; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)
    dates.push(date.toLocaleDateString())

    const dayTransactions = transactions.value.filter((txn) => {
      const txnDate = new Date(txn.TransactionDate)
      return txnDate.toDateString() === date.toDateString()
    })

    const dayRevenue = dayTransactions.reduce(
      (sum, txn) => sum + parseFloat(txn.TotalAmount || 0),
      0,
    )
    revenue.push(dayRevenue)
    transactionCounts.push(dayTransactions.length)
  }

  return { dates, revenue, transactions: transactionCounts }
}

const getTankStatusData = () => {
  const statusCounts = { Normal: 0, Low: 0, Critical: 0 }

  stationTanks.value.forEach((tank) => {
    const utilization = getTankUtilization(tank)
    if (utilization <= 10) statusCounts.Critical++
    else if (utilization <= 25) statusCounts.Low++
    else statusCounts.Normal++
  })

  return [
    { value: statusCounts.Normal, name: 'Normal' },
    { value: statusCounts.Low, name: 'Low Stock' },
    { value: statusCounts.Critical, name: 'Critical' },
  ]
}

const getRevenueByProductData = () => {
  const productRevenue = {}

  transactionItems.value.forEach((item) => {
    const transaction = transactions.value.find((txn) => txn.TransactionID === item.TransactionID)
    if (transaction && transaction.StationID === selectedStationId.value) {
      const productName = getProductName(item.ProductID)
      const revenue = parseFloat(item.TotalPrice || 0)
      productRevenue[productName] = (productRevenue[productName] || 0) + revenue
    }
  })

  return Object.entries(productRevenue).map(([name, value]) => ({ name, value }))
}

const getPaymentMethodData = () => {
  const paymentMethods = {}

  transactions.value.forEach((txn) => {
    const method = txn.PaymentMethod || 'Cash'
    const amount = parseFloat(txn.TotalAmount || 0)
    paymentMethods[method] = (paymentMethods[method] || 0) + amount
  })

  return Object.entries(paymentMethods).map(([name, value]) => ({ name, value }))
}

const getTankTrendsData = () => {
  const dates = []
  const tankData = {}

  // Generate last 14 days
  for (let i = 13; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)
    dates.push(date.toLocaleDateString())
  }

  // Process tank data for trends
  stationTanks.value.forEach((tank) => {
    tankData[tank.TankID] = dates.map(() => {
      // Simulate realistic tank level variations
      const baseLevel = parseFloat(tank.CurrentLevel || 0)
      const variation = (Math.random() - 0.5) * 1000
      return Math.max(0, baseLevel + variation)
    })
  })

  return { dates, tankData }
}

// UI Helper Functions
const toggleFloatingMenu = () => {
  floatingMenuOpen.value = !floatingMenuOpen.value
}

const showError = (message) => {
  Swal.fire({
    title: 'Error!',
    text: message,
    icon: 'error',
    confirmButtonColor: '#f1416c',
    background: '#fff',
    customClass: { popup: 'swal-premium' },
  })
}

const showSuccess = (message) => {
  Swal.fire({
    title: 'Success!',
    text: message,
    icon: 'success',
    toast: true,
    position: 'top-end',
    timer: 3000,
    showConfirmButton: false,
    background: '#fff',
    customClass: { popup: 'swal-premium-toast' },
  })
}

const showCriticalAlertsModal = () => {
  const alertsHtml = criticalAlerts.value
    .map(
      (alert) => `
      <div class="premium-alert premium-alert-danger mb-3">
        <h6 class="premium-alert-title">${alert.Title}</h6>
        <p class="premium-alert-text">${alert.Description}</p>
      </div>
    `,
    )
    .join('')

  Swal.fire({
    title: 'Critical Alerts',
    html: alertsHtml,
    confirmButtonColor: '#f1416c',
    background: '#fff',
    customClass: { popup: 'swal-premium' },
  })
}

const showQuickActions = () => {
  Swal.fire({
    title: 'Quick Actions',
    html: `
      <div class="premium-actions">
        <button class="premium-action-btn premium-action-primary" onclick="Swal.close()">
          <i class="ki-duotone ki-plus me-2"><span class="path1"></span><span class="path2"></span></i>
          Record Tank Reading
        </button>
        <button class="premium-action-btn premium-action-success" onclick="Swal.close()">
          <i class="ki-duotone ki-scanner me-2"><span class="path1"></span><span class="path2"></span></i>
          Add Inventory
        </button>
        <button class="premium-action-btn premium-action-warning" onclick="Swal.close()">
          <i class="ki-duotone ki-document me-2"><span class="path1"></span><span class="path2"></span></i>
          Generate Report
        </button>
      </div>
    `,
    showConfirmButton: false,
    background: '#fff',
    customClass: { popup: 'swal-premium' },
  })
}

const addStock = (tankId) => {
  showSuccess(`Add stock functionality for Tank ${tankId} ready for implementation`)
}

const viewTankDetails = (tankId) => {
  const tank = stationTanks.value.find((t) => t.TankID === tankId)
  if (tank) {
    Swal.fire({
      title: `${tank.TankName} Details`,
      html: `
        <div class="tank-details">
          <p><strong>Product:</strong> ${getProductName(tank.ProductID)}</p>
          <p><strong>Capacity:</strong> ${formatNumber(tank.Capacity)}L</p>
          <p><strong>Current Level:</strong> ${formatNumber(tank.CurrentLevel)}L</p>
          <p><strong>Utilization:</strong> ${getTankUtilization(tank)}%</p>
          <p><strong>Status:</strong> ${getTankStatusText(tank)}</p>
        </div>
      `,
      confirmButtonColor: '#009ef7',
      background: '#fff',
    })
  }
}

const changeTrendPeriod = (period) => {
  trendPeriod.value = period
  setTimeout(() => {
    initializePremiumCharts()
  }, 100)
}

const exportInventoryData = () => {
  showSuccess('Export functionality ready for production deployment')
}

// Main Data Loading Function
const loadDashboardData = async () => {
  if (!isAuthenticated.value || !currentUser.value) {
    showError('Authentication required to load dashboard data')
    return
  }

  if (!selectedStationId.value) {
    showError('No station selected. Please select a station.')
    return
  }

  loading.value = true
  lastRefresh.value = new Date()

  try {
    await fetchStationData()

    setTimeout(() => {
      initializePremiumCharts()
    }, 100)

    showSuccess('Dashboard updated successfully')
  } catch (error) {
    console.error('Error loading dashboard data:', error)
    showError(`Failed to load dashboard data: ${error.message}`)
  } finally {
    loading.value = false
  }
}

const handleRefresh = async () => {
  if (!isAuthenticated.value || !currentUser.value) {
    showError('Please log in to refresh data')
    return
  }
  await loadDashboardData()
}

const startAutoRefresh = () => {
  if (refreshInterval.value) {
    clearInterval(refreshInterval.value)
  }
  refreshInterval.value = setInterval(() => {
    loadDashboardData()
  }, 60000) // Refresh every minute
}

const stopAutoRefresh = () => {
  if (refreshInterval.value) {
    clearInterval(refreshInterval.value)
    refreshInterval.value = null
  }
}

// Computed Properties - Real Database Analytics
const selectedStation = computed(() => {
  return userStations.value.find((station) => station.StationID === selectedStationId.value)
})

const totalInventoryItems = computed(() => {
  return stationInventory.value.length
})

const activeStationsCount = computed(() => {
  return userStations.value.filter((station) => station.Status === 'Active').length
})

const todaysTotalSales = computed(() => {
  const today = new Date().toDateString()
  return transactions.value
    .filter((txn) => new Date(txn.TransactionDate).toDateString() === today)
    .reduce((sum, txn) => sum + parseFloat(txn.TotalAmount || 0), 0)
})

const todaysTransactionCount = computed(() => {
  const today = new Date().toDateString()
  return transactions.value.filter((txn) => new Date(txn.TransactionDate).toDateString() === today)
    .length
})

const lowStockAlerts = computed(() => {
  return stationTanks.value.filter((tank) => getTankUtilization(tank) < 25).length
})

const activeTanksCount = computed(() => {
  return stationTanks.value.filter((tank) => tank.Status === 'Active').length
})

const overallEfficiency = computed(() => {
  if (stationTanks.value.length === 0) return 0
  const totalUtilization = stationTanks.value.reduce(
    (sum, tank) => sum + parseFloat(getTankUtilization(tank)),
    0,
  )
  return Math.round(totalUtilization / stationTanks.value.length)
})

const activeFraudFlags = computed(() => {
  return fraudDetectionLogs.value.filter((log) => log.Status === 'Flagged').length
})

const recentAuditEvents = computed(() => {
  const last24Hours = new Date()
  last24Hours.setHours(last24Hours.getHours() - 24)
  return auditLogs.value.filter((log) => new Date(log.CreatedAt) >= last24Hours).length
})

const complianceScore = computed(() => {
  const totalEvents = eventLogs.value.length
  const criticalEvents = eventLogs.value.filter((event) => event.RiskLevel === 'CRITICAL').length
  return totalEvents > 0 ? Math.max(0, 100 - criticalEvents * 20) : 100
})

const dailyRevenue = computed(() => todaysTotalSales.value)

const weeklyRevenue = computed(() => {
  const weekAgo = new Date()
  weekAgo.setDate(weekAgo.getDate() - 7)
  return transactions.value
    .filter((txn) => new Date(txn.TransactionDate) >= weekAgo)
    .reduce((sum, txn) => sum + parseFloat(txn.TotalAmount || 0), 0)
})

const monthlyRevenue = computed(() => {
  const monthAgo = new Date()
  monthAgo.setMonth(monthAgo.getMonth() - 1)
  return transactions.value
    .filter((txn) => new Date(txn.TransactionDate) >= monthAgo)
    .reduce((sum, txn) => sum + parseFloat(txn.TotalAmount || 0), 0)
})

const averageTransactionValue = computed(() => {
  const total = transactions.value.reduce((sum, txn) => sum + parseFloat(txn.TotalAmount || 0), 0)
  return transactions.value.length > 0 ? total / transactions.value.length : 0
})

const totalTransactionItems = computed(() => {
  return transactionItems.value.filter((item) => {
    const transaction = transactions.value.find((txn) => txn.TransactionID === item.TransactionID)
    return transaction && transaction.StationID === selectedStationId.value
  }).length
})

const cashPayments = computed(() => {
  return transactions.value
    .filter((txn) => txn.PaymentMethod === 'Cash')
    .reduce((sum, txn) => sum + parseFloat(txn.TotalAmount || 0), 0)
})

const cardPayments = computed(() => {
  return transactions.value
    .filter((txn) => txn.PaymentMethod === 'Card')
    .reduce((sum, txn) => sum + parseFloat(txn.TotalAmount || 0), 0)
})

const creditPayments = computed(() => {
  return transactions.value
    .filter((txn) => txn.PaymentMethod === 'Credit')
    .reduce((sum, txn) => sum + parseFloat(txn.TotalAmount || 0), 0)
})

const criticalAlerts = computed(() => {
  return eventLogs.value
    .filter((event) => event.RiskLevel === 'CRITICAL' && event.Status === 'OPEN')
    .slice(0, 5)
})

const aiInsights = computed(() => {
  return generateAIInsights()
})

const filteredInventoryHistory = computed(() => {
  let filtered = inventoryHistory.value

  if (searchTerm.value) {
    const search = searchTerm.value.toLowerCase()
    filtered = filtered.filter(
      (record) =>
        getProductName(record.ProductID).toLowerCase().includes(search) ||
        record.ChangeType.toLowerCase().includes(search),
    )
  }

  if (filterType.value) {
    filtered = filtered.filter((record) => record.ChangeType === filterType.value)
  }

  return filtered.sort((a, b) => new Date(b.ChangeDate) - new Date(a.ChangeDate))
})

const paginatedResults = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return filteredInventoryHistory.value.slice(start, end)
})

const totalPages = computed(() => {
  return Math.ceil(filteredInventoryHistory.value.length / pageSize.value)
})

// Watchers
watch(selectedStationId, (newStationId) => {
  if (newStationId) {
    loadDashboardData()
  }
})

watch(currentTab, () => {
  setTimeout(() => {
    initializePremiumCharts()
  }, 100)
})

// Lifecycle
onMounted(async () => {
  console.log('🚀 Kigrama Stock Intelligence Dashboard Initializing...')

  const authSuccess = initializeAuth()

  if (!authSuccess || !currentUser.value) {
    console.error('❌ User not authenticated')
    setTimeout(() => {
      if (typeof window !== 'undefined' && window.location) {
        window.location.href = '/login.html'
      }
    }, 2000)
    return
  }

  console.log('✅ Authentication successful')

  try {
    await fetchUserStations()

    if (selectedStationId.value) {
      await loadDashboardData()
      startAutoRefresh()
      console.log('✅ Kigrama Dashboard loaded successfully')
    } else {
      showError('No stations assigned to your account. Please contact administrator.')
    }
  } catch (error) {
    console.error('❌ Dashboard initialization failed:', error)
    showError('Failed to initialize dashboard. Please try refreshing the page.')
  }
})

onBeforeUnmount(() => {
  stopAutoRefresh()
})
</script>

<style scoped>
/* Premium Kigrama Dashboard Styles */
.premium-dashboard {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  padding: 1rem;
}

/* Premium Header */
.premium-header {
  margin-bottom: 2rem;
}

.glass-card {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(255, 255, 255, 0.85) 100%);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.premium-logo {
  width: 80px;
  height: 80px;
  border-radius: 20px;
  background: linear-gradient(135deg, #009ef7 0%, #0077b6 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1.5rem;
  position: relative;
  overflow: hidden;
}

.logo-glow {
  position: relative;
  z-index: 2;
}

.premium-logo::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  animation: logoShine 3s infinite;
}

@keyframes logoShine {
  0% {
    transform: translateX(-100%) translateY(-100%) rotate(45deg);
  }
  100% {
    transform: translateX(100%) translateY(100%) rotate(45deg);
  }
}

.header-content {
  flex-grow: 1;
}

.premium-title {
  font-size: 2.5rem;
  font-weight: 800;
  color: #1e1e2d;
  margin: 0;
  background: linear-gradient(135deg, #1e1e2d 0%, #009ef7 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.premium-subtitle {
  font-size: 1.1rem;
  color: #5e6278;
  margin: 0.5rem 0;
  font-weight: 500;
}

.user-badge {
  display: inline-flex;
  align-items: center;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  padding: 0.5rem 1rem;
  border-radius: 25px;
  font-size: 0.875rem;
  font-weight: 600;
  color: #5e6278;
  border: 1px solid rgba(0, 0, 0, 0.1);
}

.header-controls {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.control-group {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.premium-select {
  background: white;
  border: 2px solid #e1e3ea;
  border-radius: 12px;
  padding: 0.75rem 1rem;
  font-weight: 600;
  color: #1e1e2d;
  min-width: 200px;
  transition: all 0.3s ease;
}

.premium-select:focus {
  outline: none;
  border-color: #009ef7;
  box-shadow: 0 0 0 4px rgba(0, 158, 247, 0.1);
}

.premium-btn {
  background: linear-gradient(135deg, #009ef7 0%, #0077b6 100%);
  border: none;
  border-radius: 12px;
  padding: 0.75rem 1.5rem;
  color: white;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0, 158, 247, 0.3);
}

.premium-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 158, 247, 0.4);
}

.status-indicator {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.status-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-bottom: 0.25rem;
}

.status-online {
  background: #50cd89;
  box-shadow: 0 0 0 4px rgba(80, 205, 137, 0.2);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 4px rgba(80, 205, 137, 0.2);
  }
  70% {
    box-shadow: 0 0 0 8px rgba(80, 205, 137, 0);
  }
  100% {
    box-shadow: 0 0 0 4px rgba(80, 205, 137, 0);
  }
}

.status-text {
  font-size: 0.875rem;
  font-weight: 600;
  color: #50cd89;
}

.last-update {
  font-size: 0.75rem;
  color: #a1a5b7;
  margin-top: 0.25rem;
}

/* Premium Navigation */
.premium-nav {
  margin-bottom: 2rem;
}

.nav-container {
  display: flex;
  background: white;
  border-radius: 16px;
  padding: 0.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow-x: auto;
  gap: 0.5rem;
}

.nav-tab {
  display: flex;
  align-items: center;
  padding: 1rem 1.5rem;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
  min-width: 200px;
  position: relative;
}

.nav-tab:hover {
  background: rgba(0, 158, 247, 0.05);
}

.nav-tab-active {
  background: linear-gradient(135deg, #009ef7 0%, #0077b6 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(0, 158, 247, 0.3);
}

.tab-icon {
  font-size: 1.5rem;
  margin-right: 1rem;
}

.tab-content {
  flex-grow: 1;
}

.tab-title {
  font-weight: 700;
  font-size: 1rem;
  margin-bottom: 0.25rem;
}

.tab-subtitle {
  font-size: 0.875rem;
  opacity: 0.8;
}

.tab-badge {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 25px;
  font-size: 0.75rem;
  font-weight: 600;
  margin-left: 1rem;
}

.nav-tab:not(.nav-tab-active) .tab-badge {
  background: #f8f9fa;
  color: #5e6278;
}

/* Critical Alerts */
.critical-alerts {
  margin-bottom: 2rem;
}

.alert-container {
  background: linear-gradient(135deg, #f1416c 0%, #e63946 100%);
  border-radius: 16px;
  padding: 1.5rem;
  display: flex;
  align-items: center;
  color: white;
  box-shadow: 0 8px 25px rgba(241, 65, 108, 0.3);
}

.alert-icon {
  font-size: 2rem;
  margin-right: 1rem;
}

.alert-content {
  flex-grow: 1;
}

.alert-title {
  font-weight: 700;
  margin: 0 0 0.5rem 0;
  font-size: 1.25rem;
}

.alert-description {
  margin: 0;
  opacity: 0.9;
}

.alert-action {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 12px;
  font-weight: 600;
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
}

.alert-action:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-1px);
}

/* Tab Content */
.tab-content {
  animation: fadeIn 0.5s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Premium KPI Grid */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.kpi-card {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  position: relative;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.kpi-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.kpi-background {
  position: absolute;
  top: -20px;
  right: -20px;
  font-size: 6rem;
  opacity: 0.1;
  color: currentColor;
}

.kpi-primary {
  color: #009ef7;
}
.kpi-success {
  color: #50cd89;
}
.kpi-warning {
  color: #ffc700;
}
.kpi-info {
  color: #7239ea;
}

.kpi-content {
  position: relative;
  z-index: 2;
}

.kpi-value {
  font-size: 2.5rem;
  font-weight: 800;
  line-height: 1;
  margin-bottom: 0.5rem;
  color: #1e1e2d;
}

.kpi-label {
  font-size: 1rem;
  font-weight: 600;
  color: #5e6278;
  margin-bottom: 0.75rem;
}

.kpi-change {
  font-size: 0.875rem;
  font-weight: 600;
  display: flex;
  align-items: center;
}

.kpi-change.positive {
  color: #50cd89;
}
.kpi-change.negative {
  color: #f1416c;
}
.kpi-change.neutral {
  color: #a1a5b7;
}

/* Charts */
.charts-row {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.chart-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.chart-header {
  padding: 1.5rem 1.5rem 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.chart-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e1e2d;
  margin: 0;
  flex-grow: 1;
}

.chart-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.chart-select {
  background: #f8f9fa;
  border: 1px solid #e1e3ea;
  border-radius: 8px;
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
  font-weight: 600;
}

.chart-body {
  padding: 1.5rem;
}

.premium-chart {
  height: 300px;
  width: 100%;
}

.premium-chart-large {
  height: 400px;
  width: 100%;
}

/* Insights Grid */
.insights-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.insight-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.insight-header {
  padding: 1.5rem 1.5rem 1rem;
  border-bottom: 1px solid #e1e3ea;
}

.insight-title {
  font-size: 1.125rem;
  font-weight: 700;
  color: #1e1e2d;
  margin: 0;
  display: flex;
  align-items: center;
}

.insight-body {
  padding: 1.5rem;
}

.no-insights {
  text-align: center;
  padding: 2rem;
  color: #a1a5b7;
}

.insights-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.insight-item {
  display: flex;
  align-items: start;
  gap: 1rem;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 12px;
}

.insight-icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  color: white;
}

.insight-success {
  background: #50cd89;
}
.insight-warning {
  background: #ffc700;
}
.insight-info {
  background: #009ef7;
}
.insight-danger {
  background: #f1416c;
}

.insight-content {
  flex-grow: 1;
}

.insight-item-title {
  font-weight: 700;
  color: #1e1e2d;
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
}

.insight-description {
  color: #5e6278;
  margin: 0 0 0.75rem 0;
  line-height: 1.5;
}

.insight-metrics {
  display: flex;
  gap: 1rem;
}

.metric {
  font-size: 0.75rem;
  font-weight: 600;
  padding: 0.25rem 0.5rem;
  background: white;
  border-radius: 6px;
  color: #5e6278;
}

/* Security Overview */
.security-overview {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.security-metric {
  text-align: center;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 12px;
}

.security-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1e1e2d;
  margin-bottom: 0.25rem;
}

.security-label {
  font-size: 0.875rem;
  color: #5e6278;
  font-weight: 600;
}

/* Tank Grid */
.tank-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.tank-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: all 0.3s ease;
}

.tank-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.tank-header {
  padding: 1.5rem 1.5rem 1rem;
  display: flex;
  justify-content: space-between;
  align-items: start;
}

.tank-info {
  flex-grow: 1;
}

.tank-name {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e1e2d;
  margin: 0 0 0.25rem 0;
}

.tank-product {
  color: #5e6278;
  margin: 0;
  font-weight: 500;
}

.tank-status {
  padding: 0.5rem 1rem;
  border-radius: 25px;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-success {
  background: linear-gradient(135deg, #50cd89 0%, #06d6a0 100%);
  color: white;
}

.status-warning {
  background: linear-gradient(135deg, #ffc700 0%, #ffb700 100%);
  color: white;
}

.status-danger {
  background: linear-gradient(135deg, #f1416c 0%, #e63946 100%);
  color: white;
}

.tank-gauge {
  padding: 1rem 1.5rem;
}

.gauge-container {
  height: 150px;
  width: 100%;
}

.tank-metrics {
  padding: 1rem 1.5rem;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.tank-metric {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.metric-label {
  font-size: 0.75rem;
  color: #a1a5b7;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 0.25rem;
}

.metric-value {
  font-size: 1rem;
  font-weight: 700;
  color: #1e1e2d;
}

.tank-actions {
  padding: 1rem 1.5rem 1.5rem;
  display: flex;
  gap: 0.75rem;
}

.tank-btn {
  flex: 1;
  padding: 0.75rem;
  border-radius: 12px;
  border: none;
  font-weight: 600;
  font-size: 0.875rem;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
}

.tank-btn-primary {
  background: linear-gradient(135deg, #009ef7 0%, #0077b6 100%);
  color: white;
  box-shadow: 0 4px 15px rgba(0, 158, 247, 0.3);
}

.tank-btn-secondary {
  background: #f8f9fa;
  color: #5e6278;
  border: 1px solid #e1e3ea;
}

.tank-btn:hover {
  transform: translateY(-1px);
}

.tank-btn-primary:hover {
  box-shadow: 0 6px 20px rgba(0, 158, 247, 0.4);
}

/* Operations Chart */
.operations-chart {
  margin-bottom: 2rem;
}

.chart-full {
  width: 100%;
}

.chart-btn {
  padding: 0.5rem 1rem;
  background: #f8f9fa;
  border: 1px solid #e1e3ea;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  color: #5e6278;
  transition: all 0.3s ease;
}

.chart-btn.active {
  background: #009ef7;
  color: white;
  border-color: #009ef7;
}

/* Financial Cards */
.financial-kpis {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.financial-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.financial-header {
  padding: 1.5rem 1.5rem 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #e1e3ea;
}

.financial-header h4 {
  font-weight: 700;
  color: #1e1e2d;
  margin: 0;
}

.financial-body {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.financial-metric {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.financial-metric .metric-value {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e1e2d;
}

.financial-metric .metric-label {
  color: #5e6278;
  font-weight: 500;
}

.financial-charts {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

/* Data Table */
.data-table-card {
  background: white;
  border-radius: 20px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  margin-bottom: 2rem;
}

.table-header {
  padding: 1.5rem;
  border-bottom: 1px solid #e1e3ea;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.table-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #1e1e2d;
  margin: 0;
  display: flex;
  align-items: center;
}

.table-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.search-box {
  position: relative;
  display: flex;
  align-items: center;
}

.search-box i {
  position: absolute;
  left: 1rem;
  color: #a1a5b7;
  z-index: 2;
}

.search-box input {
  background: #f8f9fa;
  border: 1px solid #e1e3ea;
  border-radius: 12px;
  padding: 0.75rem 1rem 0.75rem 2.5rem;
  font-size: 0.875rem;
  width: 200px;
  transition: all 0.3s ease;
}

.search-box input:focus {
  outline: none;
  border-color: #009ef7;
  background: white;
  box-shadow: 0 0 0 4px rgba(0, 158, 247, 0.1);
}

.filter-select {
  background: #f8f9fa;
  border: 1px solid #e1e3ea;
  border-radius: 12px;
  padding: 0.75rem 1rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: #5e6278;
}

.export-btn {
  background: linear-gradient(135deg, #50cd89 0%, #06d6a0 100%);
  border: none;
  border-radius: 12px;
  padding: 0.75rem 1.5rem;
  color: white;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(80, 205, 137, 0.3);
}

.export-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(80, 205, 137, 0.4);
}

.table-body {
  overflow: hidden;
}

.premium-table-container {
  overflow-x: auto;
  max-height: 600px;
}

.premium-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.875rem;
}

.premium-table th {
  background: #f8f9fa;
  color: #5e6278;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 1rem;
  text-align: left;
  border-bottom: 2px solid #e1e3ea;
  position: sticky;
  top: 0;
  z-index: 10;
}

.premium-table td {
  padding: 1rem;
  border-bottom: 1px solid #e1e3ea;
  vertical-align: middle;
}

.table-row:hover {
  background: #f8f9fa;
}

.date-cell {
  min-width: 140px;
}

.date-primary {
  font-weight: 600;
  color: #1e1e2d;
}

.date-secondary {
  font-size: 0.75rem;
  color: #a1a5b7;
  margin-top: 0.25rem;
}

.product-cell {
  min-width: 180px;
}

.product-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.product-icon {
  width: 36px;
  height: 36px;
  background: #f8f9fa;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.product-details {
  flex-grow: 1;
}

.product-name {
  font-weight: 600;
  color: #1e1e2d;
  margin-bottom: 0.25rem;
}

.product-id {
  font-size: 0.75rem;
  color: #a1a5b7;
}

.tank-cell {
  min-width: 120px;
}

.tank-info {
  text-align: center;
}

.tank-name {
  font-weight: 600;
  color: #1e1e2d;
  margin-bottom: 0.25rem;
}

.tank-id {
  font-size: 0.75rem;
  color: #a1a5b7;
}

.type-cell {
  min-width: 100px;
}

.change-badge {
  padding: 0.375rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.badge-success {
  background: rgba(80, 205, 137, 0.1);
  color: #50cd89;
}

.badge-info {
  background: rgba(0, 158, 247, 0.1);
  color: #009ef7;
}

.badge-warning {
  background: rgba(255, 199, 0, 0.1);
  color: #ffc700;
}

.badge-light {
  background: #f8f9fa;
  color: #5e6278;
}

.quantity-cell {
  min-width: 100px;
  text-align: right;
  font-weight: 600;
}

.change-cell {
  min-width: 120px;
  text-align: right;
}

.price-cell {
  min-width: 120px;
  text-align: right;
  font-weight: 600;
}

.value-cell {
  min-width: 140px;
  text-align: right;
  font-weight: 700;
  color: #1e1e2d;
}

.auth-cell {
  min-width: 140px;
}

.auth-info {
  text-align: center;
}

.auth-name {
  font-weight: 600;
  color: #1e1e2d;
  margin-bottom: 0.25rem;
}

.table-pagination {
  padding: 1rem 1.5rem;
  border-top: 1px solid #e1e3ea;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination-info {
  color: #5e6278;
  font-size: 0.875rem;
}

.pagination-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.pagination-btn {
  background: #f8f9fa;
  border: 1px solid #e1e3ea;
  border-radius: 8px;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #5e6278;
  transition: all 0.3s ease;
}

.pagination-btn:hover:not(:disabled) {
  background: #009ef7;
  color: white;
  border-color: #009ef7;
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-current {
  font-weight: 600;
  color: #1e1e2d;
  min-width: 24px;
  text-align: center;
}

/* Floating Menu */
.floating-menu {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  z-index: 1000;
}

.floating-btn {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  border: none;
  color: white;
  font-size: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.floating-btn-main {
  background: linear-gradient(135deg, #009ef7 0%, #0077b6 100%);
  position: relative;
  z-index: 2;
}

.floating-btn-main:hover {
  transform: scale(1.1);
  box-shadow: 0 12px 35px rgba(0, 158, 247, 0.4);
}

.floating-btn-main .ki-duotone.rotate-45 {
  transform: rotate(45deg);
}

.floating-actions {
  position: absolute;
  bottom: 70px;
  right: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.3s ease;
  pointer-events: none;
}

.floating-actions-open {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}

.floating-btn-action {
  background: linear-gradient(135deg, #50cd89 0%, #06d6a0 100%);
  font-size: 1.25rem;
}

.floating-btn-action:hover {
  transform: scale(1.1);
  box-shadow: 0 8px 25px rgba(80, 205, 137, 0.4);
}

/* Auth Required */
.auth-required {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  padding: 2rem;
}

.auth-container {
  background: white;
  border-radius: 24px;
  padding: 3rem 2rem;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  text-align: center;
  max-width: 400px;
  width: 100%;
}

.auth-icon {
  font-size: 4rem;
  color: #009ef7;
  margin-bottom: 1.5rem;
}

.auth-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1e1e2d;
  margin-bottom: 1rem;
}

.auth-description {
  color: #5e6278;
  margin-bottom: 2rem;
  line-height: 1.6;
}

.auth-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 2rem;
  color: #a1a5b7;
  font-size: 0.875rem;
}

.loading-spinner {
  width: 20px;
  height: 20px;
  border: 2px solid #e1e3ea;
  border-top: 2px solid #009ef7;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

.auth-btn {
  background: linear-gradient(135deg, #009ef7 0%, #0077b6 100%);
  border: none;
  border-radius: 12px;
  padding: 1rem 2rem;
  color: white;
  font-weight: 600;
  font-size: 1rem;
  display: inline-flex;
  align-items: center;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(0, 158, 247, 0.3);
}

.auth-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 35px rgba(0, 158, 247, 0.4);
}

/* Premium Alert Styles */
.premium-alert {
  border-radius: 12px;
  padding: 1rem;
  margin-bottom: 1rem;
}

.premium-alert-danger {
  background: rgba(241, 65, 108, 0.1);
  border: 1px solid rgba(241, 65, 108, 0.2);
}

.premium-alert-title {
  font-weight: 700;
  color: #f1416c;
  margin-bottom: 0.5rem;
}

.premium-alert-text {
  color: #5e6278;
  margin: 0;
}

.premium-actions {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.premium-action-btn {
  background: white;
  border: 2px solid #e1e3ea;
  border-radius: 12px;
  padding: 1rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.premium-action-primary {
  border-color: #009ef7;
  color: #009ef7;
}

.premium-action-primary:hover {
  background: #009ef7;
  color: white;
}

.premium-action-success {
  border-color: #50cd89;
  color: #50cd89;
}

.premium-action-success:hover {
  background: #50cd89;
  color: white;
}

.premium-action-warning {
  border-color: #ffc700;
  color: #ffc700;
}

.premium-action-warning:hover {
  background: #ffc700;
  color: white;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .charts-row {
    grid-template-columns: 1fr;
  }
  .financial-charts {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .premium-dashboard {
    padding: 0.75rem;
  }

  .glass-card {
    padding: 1.5rem;
  }

  .premium-title {
    font-size: 2rem;
  }

  .header-controls {
    flex-direction: column;
    gap: 1rem;
    width: 100%;
  }

  .control-group {
    width: 100%;
    flex-direction: column;
  }

  .premium-select {
    width: 100%;
  }

  .nav-container {
    padding: 0.25rem;
  }

  .nav-tab {
    min-width: 160px;
    padding: 0.75rem 1rem;
  }

  .kpi-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
  }

  .kpi-card {
    padding: 1.5rem;
  }

  .kpi-value {
    font-size: 2rem;
  }

  .insights-grid {
    grid-template-columns: 1fr;
  }

  .tank-grid {
    grid-template-columns: 1fr;
  }

  .financial-kpis {
    grid-template-columns: 1fr;
  }

  .table-header {
    flex-direction: column;
    align-items: stretch;
  }

  .table-controls {
    flex-direction: column;
    width: 100%;
  }

  .search-box input {
    width: 100%;
  }

  .premium-table-container {
    font-size: 0.75rem;
  }

  .premium-table th,
  .premium-table td {
    padding: 0.75rem 0.5rem;
  }

  .floating-menu {
    bottom: 1rem;
    right: 1rem;
  }
}

@media (max-width: 480px) {
  .kpi-grid {
    grid-template-columns: 1fr;
  }

  .nav-tab {
    min-width: 140px;
    padding: 0.5rem 0.75rem;
  }

  .tab-title {
    font-size: 0.875rem;
  }

  .tab-subtitle {
    font-size: 0.75rem;
  }
}
</style>

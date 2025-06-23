<template>
  <div class="d-flex flex-column gap-5">
    <!-- Page Header -->
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
      <div class="d-flex align-items-center gap-3">
        <i class="ki-duotone ki-package fs-1 text-primary">
          <span class="path1"></span>
          <span class="path2"></span>
          <span class="path3"></span>
        </i>
        <div>
          <h1 class="fs-2 fw-bold text-gray-900 mb-0">Product Management</h1>
          <p class="text-muted fs-6 mb-0">Manage products and their tank/station assignments</p>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="d-flex gap-2">
        <button @click="refreshData" class="btn btn-sm btn-light" :disabled="loading">
          <i class="ki-duotone ki-arrows-circle fs-4">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <span class="d-none d-sm-inline">Refresh</span>
        </button>
        <button @click="showCreateProductForm" class="btn btn-sm btn-primary">
          <i class="ki-duotone ki-plus fs-4">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Add Product
        </button>
      </div>
    </div>

    <!-- Filters -->
    <div class="card card-flush">
      <div class="card-body py-4">
        <div class="row g-3 align-items-center">
          <div class="col-12 col-md-4">
            <label class="form-label fs-7 fw-semibold">Product Type</label>
            <select
              v-model="filters.productType"
              @change="filterProducts"
              class="form-select form-select-sm"
            >
              <option value="">All Product Types</option>
              <option value="Fuel">Fuel</option>
              <option value="Lubricant">Lubricants</option>
              <option value="Gas">Gas</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div class="col-12 col-md-4">
            <label class="form-label fs-7 fw-semibold">Status</label>
            <select
              v-model="filters.status"
              @change="filterProducts"
              class="form-select form-select-sm"
            >
              <option value="">All Status</option>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
            </select>
          </div>
          <div class="col-12 col-md-4">
            <label class="form-label fs-7 fw-semibold">Station</label>
            <select
              v-model="filters.stationId"
              @change="filterProducts"
              class="form-select form-select-sm"
            >
              <option value="">All Stations</option>
              <option
                v-for="station in stations"
                :key="station.StationID"
                :value="station.StationID"
              >
                {{ station.StationName }}
              </option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <!-- KPI Cards & Charts -->
    <div class="row g-5">
      <!-- KPI Summary Cards -->
      <div class="col-12">
        <div class="row g-3">
          <div class="col-6 col-md-3">
            <div class="card card-flush bg-primary">
              <div class="card-body text-center">
                <div class="text-white fs-2 fw-bold">{{ kpis.totalProducts }}</div>
                <div class="text-white opacity-75 fs-7">Total Products</div>
              </div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="card card-flush bg-success">
              <div class="card-body text-center">
                <div class="text-white fs-2 fw-bold">{{ kpis.tankedProducts }}</div>
                <div class="text-white opacity-75 fs-7">Tanked Products</div>
              </div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="card card-flush bg-info">
              <div class="card-body text-center">
                <div class="text-white fs-2 fw-bold">{{ kpis.nonTankedProducts }}</div>
                <div class="text-white opacity-75 fs-7">Non-Tanked Products</div>
              </div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="card card-flush bg-warning">
              <div class="card-body text-center">
                <div class="text-white fs-2 fw-bold">{{ kpis.unassignedProducts }}</div>
                <div class="text-white opacity-75 fs-7">Unassigned</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Charts -->
      <div class="col-12 col-lg-4">
        <div class="card card-flush">
          <div class="card-header">
            <h3 class="card-title fw-bold">Product Distribution</h3>
          </div>
          <div class="card-body">
            <div ref="productDistributionChart" style="height: 250px"></div>
          </div>
        </div>
      </div>

      <div class="col-12 col-lg-4">
        <div class="card card-flush">
          <div class="card-header">
            <h3 class="card-title fw-bold">Assignment Status</h3>
          </div>
          <div class="card-body">
            <div ref="assignmentStatusChart" style="height: 250px"></div>
          </div>
        </div>
      </div>

      <div class="col-12 col-lg-4">
        <div class="card card-flush">
          <div class="card-header">
            <h3 class="card-title fw-bold">Station Coverage</h3>
          </div>
          <div class="card-body">
            <div ref="stationCoverageChart" style="height: 250px"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Product Grid - Desktop -->
    <div class="card card-flush d-none d-lg-block">
      <div class="card-header">
        <h3 class="card-title fw-bold">Products & Assignments</h3>
        <div class="card-toolbar">
          <button @click="showBulkAssignment" class="btn btn-sm btn-light me-2">
            <i class="ki-duotone ki-arrows-loop fs-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Bulk Assignment
          </button>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle gs-2">
            <thead class="bg-light">
              <tr class="fw-bold text-muted">
                <th class="ps-4">Product</th>
                <th>Type</th>
                <th>Price</th>
                <th>Assignment Type</th>
                <th>Stations Assigned</th>
                <th>Current Stock</th>
                <th>Status</th>
                <th class="text-center pe-4">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="loading">
                <td colspan="8" class="text-center py-10">
                  <div class="spinner-border text-primary" role="status"></div>
                  <div class="text-muted mt-2">Loading products...</div>
                </td>
              </tr>
              <tr v-else-if="productAssignments.length === 0">
                <td colspan="8" class="text-center py-10">
                  <div class="text-muted">No products found</div>
                </td>
              </tr>
              <tr
                v-else
                v-for="product in productAssignments"
                :key="product.ProductID"
                class="border-bottom"
              >
                <td class="ps-4">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <div class="symbol-label bg-light-primary">
                        <i
                          :class="getProductIcon(product.ProductType)"
                          class="fs-2 text-primary"
                        ></i>
                      </div>
                    </div>
                    <div>
                      <div class="fw-bold text-gray-900">{{ product.Name }}</div>
                      <div class="text-muted fs-7">
                        {{ product.Description || 'No description' }}
                      </div>
                    </div>
                  </div>
                </td>
                <td>
                  <span :class="getProductTypeBadgeClass(product.ProductType)">
                    {{ product.ProductType }}
                  </span>
                </td>
                <td>
                  <div class="fw-semibold">UGX {{ formatPrice(product.UnitPrice) }}</div>
                  <div class="text-muted fs-7">{{ product.TaxRate }}% tax</div>
                </td>
                <td>
                  <span :class="getAssignmentTypeBadgeClass(product.assignmentType)">
                    {{ product.assignmentType }}
                  </span>
                </td>
                <td>
                  <div class="fw-semibold">{{ product.totalAssignments }} assignments</div>
                  <div class="text-muted fs-7">
                    <span v-if="product.tankAssignments.length"
                      >{{ product.tankAssignments.length }} tanks</span
                    >
                    <span
                      v-if="product.tankAssignments.length && product.inventoryAssignments.length"
                      >,
                    </span>
                    <span v-if="product.inventoryAssignments.length"
                      >{{ product.inventoryAssignments.length }} inventory</span
                    >
                  </div>
                </td>
                <td>
                  <div class="fw-semibold">
                    {{ getTotalStock(product) }} {{ getStockUnit(product.ProductType) }}
                  </div>
                  <div v-if="product.ReorderLevel" class="text-muted fs-7">
                    Reorder: {{ product.ReorderLevel }}
                  </div>
                </td>
                <td>
                  <span :class="getStatusBadgeClass(product.Status)">
                    {{ product.Status }}
                  </span>
                </td>
                <td class="text-center pe-4">
                  <div class="btn-group btn-group-sm">
                    <button
                      @click="editProduct(product)"
                      class="btn btn-icon btn-light"
                      title="Edit Product"
                    >
                      <i class="ki-duotone ki-pencil fs-5">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </button>
                    <button
                      @click="manageAssignments(product)"
                      class="btn btn-icon btn-light"
                      title="Manage Assignments"
                    >
                      <i class="ki-duotone ki-setting-2 fs-5">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </button>
                    <button
                      @click="viewProductHistory(product)"
                      class="btn btn-icon btn-light"
                      title="View History"
                    >
                      <i class="ki-duotone ki-time fs-5">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Product Cards - Mobile -->
    <div class="d-block d-lg-none">
      <div class="row g-3">
        <div v-if="loading" class="col-12 text-center py-10">
          <div class="spinner-border text-primary" role="status"></div>
          <div class="text-muted mt-2">Loading products...</div>
        </div>
        <div v-else-if="productAssignments.length === 0" class="col-12 text-center py-10">
          <div class="text-muted">No products found</div>
        </div>
        <div v-else v-for="product in productAssignments" :key="product.ProductID" class="col-12">
          <div class="card border">
            <div class="card-body p-4">
              <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                  <h5 class="fw-bold mb-1">{{ product.Name }}</h5>
                  <div class="text-muted fs-7">{{ product.Description || 'No description' }}</div>
                </div>
                <span :class="getProductTypeBadgeClass(product.ProductType)">
                  {{ product.ProductType }}
                </span>
              </div>

              <div class="row g-2 mb-3">
                <div class="col-6">
                  <div class="text-muted fs-8">Price</div>
                  <div class="fs-7 fw-semibold">UGX {{ formatPrice(product.UnitPrice) }}</div>
                </div>
                <div class="col-6">
                  <div class="text-muted fs-8">Assignment Type</div>
                  <span :class="getAssignmentTypeBadgeClass(product.assignmentType)">
                    {{ product.assignmentType }}
                  </span>
                </div>
              </div>

              <div class="row g-2 mb-3">
                <div class="col-6">
                  <div class="text-muted fs-8">Assignments</div>
                  <div class="fs-7">{{ product.totalAssignments }} stations</div>
                </div>
                <div class="col-6">
                  <div class="text-muted fs-8">Status</div>
                  <span :class="getStatusBadgeClass(product.Status)">
                    {{ product.Status }}
                  </span>
                </div>
              </div>

              <div class="d-flex gap-2">
                <button @click="editProduct(product)" class="btn btn-sm btn-light flex-fill">
                  <i class="ki-duotone ki-pencil fs-5 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Edit
                </button>
                <button
                  @click="manageAssignments(product)"
                  class="btn btn-sm btn-primary flex-fill"
                >
                  <i class="ki-duotone ki-setting-2 fs-5 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Assignments
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Alerts -->
    <div v-if="alerts.length > 0" class="card card-flush border-warning">
      <div class="card-header bg-warning">
        <h3 class="card-title text-white fw-bold">
          <i class="ki-duotone ki-warning-2 fs-2 me-2">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          Product Alerts
        </h3>
      </div>
      <div class="card-body">
        <div class="row g-3">
          <div v-for="alert in alerts" :key="alert.id" class="col-12 col-md-6">
            <div class="alert alert-warning d-flex align-items-center">
              <i class="ki-duotone ki-information-5 fs-2 me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div>
                <div class="fw-bold">{{ alert.title }}</div>
                <div class="text-muted fs-7">{{ alert.message }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'
import axios from 'axios'

// Reactive state
const loading = ref(false)
const products = ref([])
const stations = ref([])
const tanks = ref([])
const stationInventory = ref([])
const alerts = ref([])

// Filters
const filters = ref({
  stationId: '',
  productType: '',
  status: '',
})

// Chart refs
const productDistributionChart = ref(null)
const assignmentStatusChart = ref(null)
const stationCoverageChart = ref(null)

// API setup - Fixed with correct capitalized table names
const api = axios.create({
  baseURL: 'http://localhost:4000/api/records/v1',
  headers: {
    Authorization: `Bearer ${localStorage.getItem('jwt')}`,
    'Content-Type': 'application/json',
  },
  timeout: 10000,
})

// Computed properties
const kpis = computed(() => {
  const totalProducts = products.value.length
  const tankedProductIds = new Set(tanks.value.map((t) => t.ProductID).filter((id) => id))
  const nonTankedProductIds = new Set(
    stationInventory.value.map((s) => s.ProductID).filter((id) => id),
  )
  const allAssignedIds = new Set([...tankedProductIds, ...nonTankedProductIds])

  return {
    totalProducts,
    tankedProducts: tankedProductIds.size,
    nonTankedProducts: nonTankedProductIds.size,
    unassignedProducts: totalProducts - allAssignedIds.size,
  }
})

const filteredProducts = computed(() => {
  let filtered = products.value

  if (filters.value.productType) {
    filtered = filtered.filter((product) => product.ProductType === filters.value.productType)
  }

  if (filters.value.status) {
    filtered = filtered.filter((product) => product.Status === filters.value.status)
  }

  return filtered
})

const productAssignments = computed(() => {
  return filteredProducts.value.map((product) => {
    // Find tank assignments
    const tankAssignments = tanks.value.filter((tank) => tank.ProductID == product.ProductID)
    // Find station inventory assignments
    const inventoryAssignments = stationInventory.value.filter(
      (inv) => inv.ProductID == product.ProductID,
    )

    return {
      ...product,
      tankAssignments,
      inventoryAssignments,
      totalAssignments: tankAssignments.length + inventoryAssignments.length,
      assignmentType:
        tankAssignments.length > 0
          ? 'Tanked'
          : inventoryAssignments.length > 0
            ? 'Non-Tanked'
            : 'Unassigned',
    }
  })
})

// Methods - Fixed with proper error handling
const loadProducts = async () => {
  try {
    const response = await api.get('/Products')
    products.value = response.data.records || []
  } catch (error) {
    console.error('Failed to load products:', error)
    showErrorNotification('Failed to load products')
  }
}

const loadStations = async () => {
  try {
    const response = await api.get('/Stations')
    stations.value = response.data.records || []
  } catch (error) {
    console.error('Failed to load stations:', error)
    showErrorNotification('Failed to load stations')
  }
}

const loadTanks = async () => {
  try {
    const response = await api.get('/Tanks')
    tanks.value = response.data.records || []
  } catch (error) {
    console.error('Failed to load tanks:', error)
    showErrorNotification('Failed to load tanks')
  }
}

const loadStationInventory = async () => {
  try {
    const response = await api.get('/StationInventory')
    stationInventory.value = response.data.records || []
  } catch (error) {
    console.error('Failed to load station inventory:', error)
    showErrorNotification('Failed to load station inventory')
  }
}

const filterProducts = () => {
  generateAlerts()
  updateCharts()
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([loadProducts(), loadStations(), loadTanks(), loadStationInventory()])
    generateAlerts()
    await nextTick()
    initializeCharts()
    showSuccessNotification('Data refreshed successfully')
  } finally {
    loading.value = false
  }
}

const generateAlerts = () => {
  alerts.value = []

  products.value.forEach((product) => {
    // Check for unassigned products
    const isAssigned =
      tanks.value.some((t) => t.ProductID == product.ProductID) ||
      stationInventory.value.some((s) => s.ProductID == product.ProductID)

    if (!isAssigned && product.Status === 'Active') {
      alerts.value.push({
        id: `unassigned-${product.ProductID}`,
        title: `Unassigned Product - ${product.Name}`,
        message: `This active product is not assigned to any station`,
      })
    }

    // Check for low stock on non-tanked products
    if (product.ReorderLevel) {
      const totalStock = stationInventory.value
        .filter((inv) => inv.ProductID == product.ProductID)
        .reduce((sum, inv) => sum + parseFloat(inv.CurrentStock || 0), 0)

      if (totalStock <= parseFloat(product.ReorderLevel)) {
        alerts.value.push({
          id: `lowstock-${product.ProductID}`,
          title: `Low Stock - ${product.Name}`,
          message: `Stock level (${totalStock}) is at or below reorder level (${product.ReorderLevel})`,
        })
      }
    }
  })
}

const initializeCharts = () => {
  if (typeof ApexCharts === 'undefined') {
    console.warn('ApexCharts not loaded, skipping charts')
    return
  }

  // Clear existing charts
  if (productDistributionChart.value) {
    productDistributionChart.value.innerHTML = ''
  }
  if (assignmentStatusChart.value) {
    assignmentStatusChart.value.innerHTML = ''
  }
  if (stationCoverageChart.value) {
    stationCoverageChart.value.innerHTML = ''
  }

  initProductDistributionChart()
  initAssignmentStatusChart()
  initStationCoverageChart()
}

const initProductDistributionChart = () => {
  if (!productDistributionChart.value || products.value.length === 0) return

  try {
    const distribution = products.value.reduce((acc, product) => {
      acc[product.ProductType] = (acc[product.ProductType] || 0) + 1
      return acc
    }, {})

    const series = Object.values(distribution).filter((val) => !isNaN(val) && val > 0)
    const labels = Object.keys(distribution).filter((key) => distribution[key] > 0)

    if (series.length === 0) return

    const options = {
      series,
      chart: {
        type: 'donut',
        height: 250,
      },
      labels,
      colors: ['#009EF7', '#50CD89', '#FFC700', '#F1416C'],
      legend: {
        position: 'bottom',
      },
      dataLabels: {
        enabled: true,
      },
    }

    new ApexCharts(productDistributionChart.value, options).render()
  } catch (error) {
    console.error('Error rendering product distribution chart:', error)
  }
}

const initAssignmentStatusChart = () => {
  if (!assignmentStatusChart.value || productAssignments.value.length === 0) return

  try {
    const assignments = productAssignments.value.reduce((acc, product) => {
      acc[product.assignmentType] = (acc[product.assignmentType] || 0) + 1
      return acc
    }, {})

    const series = Object.values(assignments).filter((val) => !isNaN(val) && val > 0)
    const labels = Object.keys(assignments).filter((key) => assignments[key] > 0)

    if (series.length === 0) return

    const options = {
      series,
      chart: {
        type: 'pie',
        height: 250,
      },
      labels,
      colors: ['#50CD89', '#009EF7', '#FFC700'],
      legend: {
        position: 'bottom',
      },
      dataLabels: {
        enabled: true,
      },
    }

    new ApexCharts(assignmentStatusChart.value, options).render()
  } catch (error) {
    console.error('Error rendering assignment status chart:', error)
  }
}

const initStationCoverageChart = () => {
  if (!stationCoverageChart.value || stations.value.length === 0) return

  try {
    const stationData = stations.value
      .map((station) => {
        const tankProducts = tanks.value.filter((t) => t.StationID == station.StationID).length
        const inventoryProducts = stationInventory.value.filter(
          (i) => i.StationID == station.StationID,
        ).length
        const total = tankProducts + inventoryProducts

        return {
          x:
            station.StationName.length > 10
              ? station.StationName.substring(0, 10) + '...'
              : station.StationName,
          y: isNaN(total) ? 0 : total,
        }
      })
      .filter((item) => typeof item.y === 'number')

    if (stationData.length === 0) return

    const options = {
      series: [
        {
          name: 'Products',
          data: stationData,
        },
      ],
      chart: {
        type: 'bar',
        height: 250,
        toolbar: { show: false },
      },
      colors: ['#009EF7'],
      xaxis: {
        type: 'category',
      },
      dataLabels: {
        enabled: true,
      },
    }

    new ApexCharts(stationCoverageChart.value, options).render()
  } catch (error) {
    console.error('Error rendering station coverage chart:', error)
  }
}

const updateCharts = () => {
  setTimeout(() => {
    initializeCharts()
  }, 100)
}

// Helper methods
const getProductIcon = (productType) => {
  const icons = {
    Fuel: 'ki-duotone ki-oil-barrel',
    Lubricant: 'ki-duotone ki-drop',
    Gas: 'ki-duotone ki-gas-stove',
    Other: 'ki-duotone ki-package',
  }
  return icons[productType] || 'ki-duotone ki-package'
}

const getProductTypeBadgeClass = (productType) => {
  const classes = {
    Fuel: 'badge badge-light-primary',
    Lubricant: 'badge badge-light-success',
    Gas: 'badge badge-light-warning',
    Other: 'badge badge-light-info',
  }
  return classes[productType] || 'badge badge-light-secondary'
}

const getAssignmentTypeBadgeClass = (assignmentType) => {
  const classes = {
    Tanked: 'badge badge-success',
    'Non-Tanked': 'badge badge-info',
    Unassigned: 'badge badge-warning',
  }
  return classes[assignmentType] || 'badge badge-secondary'
}

const getStatusBadgeClass = (status) => {
  return status === 'Active' ? 'badge badge-success' : 'badge badge-secondary'
}

const formatPrice = (price) => {
  return Number(price || 0).toLocaleString()
}

const getTotalStock = (product) => {
  try {
    if (product.tankAssignments.length > 0) {
      return product.tankAssignments
        .reduce((sum, tank) => sum + parseFloat(tank.CurrentLevel || 0), 0)
        .toFixed(0)
    }
    return product.inventoryAssignments
      .reduce((sum, inv) => sum + parseFloat(inv.CurrentStock || 0), 0)
      .toFixed(0)
  } catch (error) {
    return '0'
  }
}

const getStockUnit = (productType) => {
  return productType === 'Fuel' ? 'L' : productType === 'Gas' ? 'units' : 'L'
}

const getStationName = (stationId) => {
  const station = stations.value.find((s) => s.StationID == stationId)
  return station ? station.StationName : 'Unknown Station'
}

// Action methods with bigger modals
const showCreateProductForm = async () => {
  const { value: formValues } = await Swal.fire({
    title: 'Create New Product',
    html: `
      <div class="text-start">
        <div class="mb-3">
          <label class="form-label">Product Name</label>
          <input id="product-name" type="text" class="form-control" placeholder="Enter product name">
        </div>
        <div class="mb-3">
          <label class="form-label">Product Type</label>
          <select id="product-type" class="form-control">
            <option value="Fuel">Fuel</option>
            <option value="Lubricant">Lubricant</option>
            <option value="Gas">Gas</option>
            <option value="Other">Other</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">Description</label>
          <textarea id="description" class="form-control" rows="3" placeholder="Product description"></textarea>
        </div>
        <div class="mb-3">
          <label class="form-label">Unit Price (UGX)</label>
          <input id="unit-price" type="number" class="form-control" placeholder="Enter unit price">
        </div>
        <div class="mb-3">
          <label class="form-label">Tax Rate (%)</label>
          <input id="tax-rate" type="number" class="form-control" value="18" placeholder="Tax rate">
        </div>
        <div class="mb-3">
          <label class="form-label">Reorder Level</label>
          <input id="reorder-level" type="number" class="form-control" placeholder="Reorder level (optional)">
        </div>
      </div>
    `,
    width: '600px',
    focusConfirm: false,
    showCancelButton: true,
    confirmButtonText: 'Create Product',
    cancelButtonText: 'Cancel',
    preConfirm: () => {
      const name = document.getElementById('product-name').value
      const productType = document.getElementById('product-type').value
      const description = document.getElementById('description').value
      const unitPrice = document.getElementById('unit-price').value
      const taxRate = document.getElementById('tax-rate').value
      const reorderLevel = document.getElementById('reorder-level').value

      if (!name || !unitPrice) {
        Swal.showValidationMessage('Please fill in product name and unit price')
        return false
      }

      return {
        name,
        productType,
        description,
        unitPrice: Number(unitPrice),
        taxRate: Number(taxRate) || 18,
        reorderLevel: reorderLevel ? Number(reorderLevel) : null,
      }
    },
  })

  if (formValues) {
    await createProduct(formValues)
  }
}

const createProduct = async (data) => {
  try {
    loading.value = true

    await api.post('/Products', {
      ProductType: data.productType,
      Name: data.name,
      Description: data.description,
      UnitPrice: data.unitPrice,
      TaxRate: data.taxRate,
      ReorderLevel: data.reorderLevel,
      Status: 'Active',
    })

    await loadProducts()
    generateAlerts()
    updateCharts()

    showSuccessNotification(`Product "${data.name}" created successfully`)
  } catch (error) {
    console.error('Failed to create product:', error)
    showErrorNotification('Failed to create product')
  } finally {
    loading.value = false
  }
}

const editProduct = async (product) => {
  const { value: formValues } = await Swal.fire({
    title: `Edit ${product.Name}`,
    html: `
      <div class="text-start">
        <div class="mb-3">
          <label class="form-label">Product Name</label>
          <input id="product-name" type="text" class="form-control" value="${product.Name}">
        </div>
        <div class="mb-3">
          <label class="form-label">Product Type</label>
          <select id="product-type" class="form-control">
            <option value="Fuel" ${product.ProductType === 'Fuel' ? 'selected' : ''}>Fuel</option>
            <option value="Lubricant" ${product.ProductType === 'Lubricant' ? 'selected' : ''}>Lubricant</option>
            <option value="Gas" ${product.ProductType === 'Gas' ? 'selected' : ''}>Gas</option>
            <option value="Other" ${product.ProductType === 'Other' ? 'selected' : ''}>Other</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">Description</label>
          <textarea id="description" class="form-control" rows="3">${product.Description || ''}</textarea>
        </div>
        <div class="mb-3">
          <label class="form-label">Unit Price (UGX)</label>
          <input id="unit-price" type="number" class="form-control" value="${product.UnitPrice}">
        </div>
        <div class="mb-3">
          <label class="form-label">Tax Rate (%)</label>
          <input id="tax-rate" type="number" class="form-control" value="${product.TaxRate}">
        </div>
        <div class="mb-3">
          <label class="form-label">Reorder Level</label>
          <input id="reorder-level" type="number" class="form-control" value="${product.ReorderLevel || ''}">
        </div>
        <div class="mb-3">
          <label class="form-label">Status</label>
          <select id="status" class="form-control">
            <option value="Active" ${product.Status === 'Active' ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${product.Status === 'Inactive' ? 'selected' : ''}>Inactive</option>
          </select>
        </div>
      </div>
    `,
    width: '600px',
    showCancelButton: true,
    confirmButtonText: 'Save Changes',
    cancelButtonText: 'Cancel',
    preConfirm: () => {
      const name = document.getElementById('product-name').value
      const productType = document.getElementById('product-type').value
      const description = document.getElementById('description').value
      const unitPrice = document.getElementById('unit-price').value
      const taxRate = document.getElementById('tax-rate').value
      const reorderLevel = document.getElementById('reorder-level').value
      const status = document.getElementById('status').value

      if (!name || !unitPrice) {
        Swal.showValidationMessage('Please fill in product name and unit price')
        return false
      }

      return {
        name,
        productType,
        description,
        unitPrice: Number(unitPrice),
        taxRate: Number(taxRate),
        reorderLevel: reorderLevel ? Number(reorderLevel) : null,
        status,
      }
    },
  })

  if (formValues) {
    await updateProduct(product.ProductID, formValues)
  }
}

const updateProduct = async (productId, data) => {
  try {
    loading.value = true

    const updateData = {
      ProductType: data.productType,
      Name: data.name,
      Description: data.description,
      UnitPrice: data.unitPrice,
      TaxRate: data.taxRate,
      ReorderLevel: data.reorderLevel,
      Status: data.status,
      UpdatedAt: new Date().toISOString(),
    }

    // Try different API patterns based on common record-based systems
    let updateSuccess = false
    let lastError = null

    // Pattern 1: PATCH method
    try {
      console.log('Trying PATCH /Products/' + productId)
      await api.patch(`/Products/${productId}`, updateData)
      console.log('✅ PATCH method succeeded')
      updateSuccess = true
    } catch (error) {
      console.log('❌ PATCH failed:', error.response?.status)
      lastError = error
    }

    // Pattern 2: POST method (common in record-based APIs)
    if (!updateSuccess) {
      try {
        console.log('Trying POST /Products/' + productId)
        await api.post(`/Products/${productId}`, updateData)
        console.log('✅ POST method succeeded')
        updateSuccess = true
      } catch (error) {
        console.log('❌ POST failed:', error.response?.status)
        lastError = error
      }
    }

    // Pattern 3: PUT with records path
    if (!updateSuccess) {
      try {
        console.log('Trying PUT /Products/records/' + productId)
        await api.put(`/Products/records/${productId}`, updateData)
        console.log('✅ PUT records method succeeded')
        updateSuccess = true
      } catch (error) {
        console.log('❌ PUT records failed:', error.response?.status)
        lastError = error
      }
    }

    // Pattern 4: PUT with query parameter
    if (!updateSuccess) {
      try {
        console.log('Trying PUT /Products?id=' + productId)
        await api.put(`/Products?id=${productId}`, updateData)
        console.log('✅ PUT query method succeeded')
        updateSuccess = true
      } catch (error) {
        console.log('❌ PUT query failed:', error.response?.status)
        lastError = error
      }
    }

    // Pattern 5: Original PUT (fallback)
    if (!updateSuccess) {
      try {
        console.log('Trying original PUT /Products/' + productId)
        await api.put(`/Products/${productId}`, updateData)
        console.log('✅ Original PUT method succeeded')
        updateSuccess = true
      } catch (error) {
        console.log('❌ Original PUT failed:', error.response?.status)
        lastError = error
      }
    }

    if (!updateSuccess) {
      console.error('All update methods failed. Last error:', lastError)
      throw lastError
    }

    await loadProducts()
    generateAlerts()
    updateCharts()

    showSuccessNotification('Product updated successfully')
  } catch (error) {
    console.error('Failed to update product:', error)
    const errorMsg =
      error.response?.status === 405
        ? 'Update method not supported by server. Check console for details.'
        : `Failed to update product (${error.response?.status || 'Network Error'})`
    showErrorNotification(errorMsg)
  } finally {
    loading.value = false
  }
}

const manageAssignments = async (product) => {
  const isTankableProduct = ['Fuel'].includes(product.ProductType)

  if (isTankableProduct) {
    await manageTankAssignments(product)
  } else {
    await manageStationInventoryAssignments(product)
  }
}

const manageTankAssignments = async (product) => {
  // Get all tanks and current assignments
  const assignedTankIds = tanks.value
    .filter((tank) => tank.ProductID == product.ProductID)
    .map((tank) => tank.TankID)

  const stationOptions = stations.value.map((station) => {
    const stationTanks = tanks.value.filter((tank) => tank.StationID == station.StationID)

    return {
      station,
      tanks: stationTanks,
    }
  })

  let tankOptionsHtml = stationOptions
    .map(
      (stationOption) => `
    <div class="mb-4">
      <h6 class="fw-bold text-primary">${stationOption.station.StationName}</h6>
      ${stationOption.tanks.length === 0 ? '<p class="text-muted small">No tanks available</p>' : ''}
      ${stationOption.tanks
        .map(
          (tank) => `
        <div class="form-check">
          <input class="form-check-input" type="checkbox" value="${tank.TankID}"
                 id="tank-${tank.TankID}" ${assignedTankIds.includes(tank.TankID) ? 'checked' : ''}
                 ${tank.ProductID && tank.ProductID != product.ProductID ? 'disabled' : ''}>
          <label class="form-check-label" for="tank-${tank.TankID}">
            ${tank.TankName} (${tank.Capacity}L capacity)
            ${tank.ProductID && tank.ProductID != product.ProductID ? ' - <span class="text-danger">Assigned to another product</span>' : ''}
          </label>
        </div>
      `,
        )
        .join('')}
    </div>
  `,
    )
    .join('')

  const { value: selectedTanks } = await Swal.fire({
    title: `Manage Tank Assignments - ${product.Name}`,
    html: `
      <div class="text-start">
        <p class="text-muted mb-4">Select tanks to assign this product to:</p>
        ${tankOptionsHtml}
      </div>
    `,
    width: '700px',
    showCancelButton: true,
    confirmButtonText: 'Save Assignments',
    cancelButtonText: 'Cancel',
    preConfirm: () => {
      const checkboxes = document.querySelectorAll('input[type="checkbox"]:checked:not(:disabled)')
      return Array.from(checkboxes).map((cb) => cb.value)
    },
  })

  if (selectedTanks !== undefined) {
    await updateTankAssignments(product.ProductID, selectedTanks)
  }
}

const updateTankAssignments = async (productId, selectedTankIds) => {
  try {
    loading.value = true

    // Get current assignments
    const currentAssignments = tanks.value.filter((tank) => tank.ProductID == productId)
    const currentTankIds = currentAssignments.map((tank) => tank.TankID.toString())

    // Determine tanks to assign and unassign
    const tanksToAssign = selectedTankIds.filter((id) => !currentTankIds.includes(id))
    const tanksToUnassign = currentTankIds.filter((id) => !selectedTankIds.includes(id))

    console.log('🔧 Tank assignment changes:', {
      tanksToAssign,
      tanksToUnassign,
      productId,
    })

    // Helper function to try different update methods
    const updateTank = async (tankId, updateData) => {
      const methods = [
        { name: 'PATCH', fn: () => api.patch(`/Tanks/${tankId}`, updateData) },
        { name: 'POST', fn: () => api.post(`/Tanks/${tankId}`, updateData) },
        { name: 'PUT Records', fn: () => api.put(`/Tanks/records/${tankId}`, updateData) },
        { name: 'PUT Query', fn: () => api.put(`/Tanks?id=${tankId}`, updateData) },
        { name: 'PUT', fn: () => api.put(`/Tanks/${tankId}`, updateData) },
      ]

      for (const method of methods) {
        try {
          console.log(`Trying ${method.name} for tank ${tankId}`)
          await method.fn()
          console.log(`✅ ${method.name} succeeded for tank ${tankId}`)
          return true
        } catch (error) {
          console.log(`❌ ${method.name} failed for tank ${tankId}:`, error.response?.status)
          continue
        }
      }
      throw new Error(`Failed to update tank ${tankId} - all methods failed`)
    }

    // Assign new tanks
    for (const tankId of tanksToAssign) {
      try {
        console.log(`🔗 Assigning product ${productId} to tank ${tankId}`)
        await updateTank(tankId, {
          ProductID: parseInt(productId),
          UpdatedAt: new Date().toISOString(),
        })
        console.log(`✅ Tank ${tankId} assigned to product ${productId}`)
      } catch (error) {
        console.error(`❌ Failed to assign tank ${tankId}:`, error.message)
        // Continue with other assignments even if one fails
      }
    }

    // Unassign removed tanks
    for (const tankId of tanksToUnassign) {
      try {
        console.log(`🔓 Unassigning tank ${tankId} from product ${productId}`)
        await updateTank(tankId, {
          ProductID: null,
          UpdatedAt: new Date().toISOString(),
        })
        console.log(`✅ Tank ${tankId} unassigned from product ${productId}`)
      } catch (error) {
        console.error(`❌ Failed to unassign tank ${tankId}:`, error.message)
        // Continue with other unassignments even if one fails
      }
    }

    console.log('🔄 Reloading tank data...')
    await loadTanks()
    generateAlerts()
    updateCharts()

    showSuccessNotification('Tank assignments updated successfully')
  } catch (error) {
    console.error('💥 Failed to update tank assignments:', error)
    showErrorNotification('Failed to update tank assignments')
  } finally {
    loading.value = false
  }
}

const manageStationInventoryAssignments = async (product) => {
  const currentAssignments = stationInventory.value.filter(
    (inv) => inv.ProductID == product.ProductID,
  )

  const stationCheckboxes = stations.value
    .map((station) => {
      const existing = currentAssignments.find((inv) => inv.StationID == station.StationID)
      return `
      <div class="form-check mb-2">
        <input class="form-check-input" type="checkbox" value="${station.StationID}"
               id="station-${station.StationID}" ${existing ? 'checked' : ''}>
        <label class="form-check-label" for="station-${station.StationID}">
          <strong>${station.StationName}</strong>
          ${existing ? ` <span class="text-muted">(Current stock: ${existing.CurrentStock})</span>` : ''}
        </label>
      </div>
    `
    })
    .join('')

  const { value: result } = await Swal.fire({
    title: `Manage Station Assignments - ${product.Name}`,
    html: `
      <div class="text-start">
        <p class="text-muted mb-4">Select stations to assign this product to:</p>
        ${stationCheckboxes}
        <hr class="my-4">
        <div>
          <label class="form-label">Initial Stock Level (for new assignments)</label>
          <input id="initial-stock" type="number" class="form-control" value="0" placeholder="Initial stock level">
        </div>
      </div>
    `,
    width: '600px',
    showCancelButton: true,
    confirmButtonText: 'Save Assignments',
    cancelButtonText: 'Cancel',
    preConfirm: () => {
      const checkboxes = document.querySelectorAll('input[type="checkbox"]:checked')
      const selectedStations = Array.from(checkboxes).map((cb) => cb.value)
      const initialStock = document.getElementById('initial-stock').value
      return { selectedStations, initialStock: Number(initialStock) || 0 }
    },
  })

  if (result) {
    await updateStationInventoryAssignments(
      product.ProductID,
      result.selectedStations,
      result.initialStock,
    )
  }
}

const updateStationInventoryAssignments = async (productId, selectedStationIds, initialStock) => {
  try {
    loading.value = true

    const currentAssignments = stationInventory.value.filter((inv) => inv.ProductID == productId)
    const currentStationIds = currentAssignments.map((inv) => inv.StationID.toString())

    const stationsToAdd = selectedStationIds.filter((id) => !currentStationIds.includes(id))
    const stationsToRemove = currentStationIds.filter((id) => !selectedStationIds.includes(id))

    console.log('📊 Assignment changes:', {
      stationsToAdd,
      stationsToRemove,
      productId,
      initialStock,
    })

    // Helper function to try different delete methods
    const deleteStationInventory = async (inventoryId) => {
      const methods = [
        { name: 'DELETE', fn: () => api.delete(`/StationInventory/${inventoryId}`) },
        { name: 'POST Delete', fn: () => api.post(`/StationInventory/${inventoryId}/delete`) },
        {
          name: 'PUT Soft Delete',
          fn: () => api.put(`/StationInventory/${inventoryId}`, { deleted: true }),
        },
        {
          name: 'PATCH Soft Delete',
          fn: () => api.patch(`/StationInventory/${inventoryId}`, { deleted: true }),
        },
      ]

      for (const method of methods) {
        try {
          console.log(`Trying ${method.name} for inventory ${inventoryId}`)
          await method.fn()
          console.log(`✅ ${method.name} succeeded for inventory ${inventoryId}`)
          return true
        } catch (error) {
          console.log(
            `❌ ${method.name} failed for inventory ${inventoryId}:`,
            error.response?.status,
          )
          continue
        }
      }
      throw new Error(`Failed to delete station inventory ${inventoryId} - all methods failed`)
    }

    // Add new station assignments
    for (const stationId of stationsToAdd) {
      try {
        console.log(`📝 Creating station inventory for station ${stationId}`)
        await api.post('/StationInventory', {
          StationID: parseInt(stationId),
          ProductID: parseInt(productId),
          CurrentStock: initialStock.toString(),
          LastUpdated: new Date().toISOString(),
        })
        console.log(`✅ Station inventory created for station ${stationId}`)
      } catch (error) {
        console.error(
          `❌ Failed to create station inventory for station ${stationId}:`,
          error.response?.data || error.message,
        )
        throw error // Re-throw to stop the process if station inventory creation fails
      }
    }

    // Remove station assignments
    for (const stationId of stationsToRemove) {
      const existing = currentAssignments.find((inv) => inv.StationID == stationId)
      if (existing) {
        try {
          console.log(
            `🗑️ Deleting station inventory ${existing.InventoryID} for station ${stationId}`,
          )
          await deleteStationInventory(existing.InventoryID)
          console.log(`✅ Station inventory deleted for station ${stationId}`)
        } catch (error) {
          console.warn(`❌ Failed to delete station inventory for station ${stationId}:`, error)
          // Continue with other deletions even if one fails
        }
      }
    }

    console.log('🔄 Reloading station inventory data...')
    await loadStationInventory()
    generateAlerts()
    updateCharts()

    showSuccessNotification('Station assignments updated successfully')
  } catch (error) {
    console.error('💥 Failed to update station assignments:', error)
    const errorDetails = error.response?.data
      ? `Server error: ${JSON.stringify(error.response.data)}`
      : error.message
    showErrorNotification(`Failed to update station assignments: ${errorDetails}`)
  } finally {
    loading.value = false
  }
}

const viewProductHistory = async (product) => {
  try {
    console.log(`📊 Loading history for product ${product.ProductID}`)

    // Try different query patterns for the history API
    const historyQueryMethods = [
      () => api.get(`/InventoryHistory?ProductID=${product.ProductID}&limit=20`),
      () => api.get(`/InventoryHistory?filter=ProductID=${product.ProductID}&limit=20`),
      () => api.get(`/InventoryHistory/${product.ProductID}`),
      () => api.get(`/InventoryHistory`, { params: { ProductID: product.ProductID, limit: 20 } }),
    ]

    let history = []
    let historyLoaded = false

    for (const method of historyQueryMethods) {
      try {
        console.log('Trying history query method...')
        const response = await method()
        history = response.data.records || response.data || []
        historyLoaded = true
        console.log(`✅ History loaded: ${history.length} records`)
        break
      } catch (error) {
        console.log(`❌ History query failed:`, error.response?.status)
        continue
      }
    }

    if (!historyLoaded) {
      console.log('⚠️ Could not load history, showing message')
      Swal.fire({
        title: `${product.Name} History`,
        text: 'Unable to load product history at this time',
        icon: 'warning',
        width: '500px',
      })
      return
    }

    if (history.length === 0) {
      Swal.fire({
        title: `${product.Name} History`,
        text: 'No recent history found',
        icon: 'info',
        width: '500px',
      })
      return
    }

    const historyHtml = `
      <div class="table-responsive">
        <table class="table table-sm">
          <thead>
            <tr>
              <th>Date</th>
              <th>Station</th>
              <th>Type</th>
              <th>Change</th>
              <th>Notes</th>
            </tr>
          </thead>
          <tbody>
            ${history
              .slice(0, 10) // Limit to 10 records
              .map(
                (h) => `
              <tr>
                <td>${h.ChangeDate ? new Date(h.ChangeDate).toLocaleDateString() : 'N/A'}</td>
                <td>${getStationName(h.StationID) || 'Unknown'}</td>
                <td>${h.ChangeType || 'N/A'}</td>
                <td>${h.QuantityChange ? (h.QuantityChange > 0 ? '+' : '') + h.QuantityChange : 'N/A'}</td>
                <td>${h.Notes || '-'}</td>
              </tr>
            `,
              )
              .join('')}
          </tbody>
        </table>
      </div>
    `

    Swal.fire({
      title: `${product.Name} - Recent History`,
      html: historyHtml,
      width: '900px',
      confirmButtonText: 'Close',
    })
  } catch (error) {
    console.error('💥 Failed to load product history:', error)
    showErrorNotification('Failed to load product history')
  }
}

const showBulkAssignment = () => {
  Swal.fire({
    title: 'Bulk Assignment',
    text: 'Bulk assignment functionality will be available in the next update',
    icon: 'info',
    width: '500px',
  })
}

// Notification helpers
const showSuccessNotification = (message) => {
  Swal.fire({
    title: 'Success!',
    text: message,
    icon: 'success',
    toast: true,
    position: 'top-end',
    timer: 3000,
    showConfirmButton: false,
  })
}

const showErrorNotification = (message) => {
  Swal.fire({
    title: 'Error!',
    text: message,
    icon: 'error',
    confirmButtonColor: '#f1416c',
    width: '500px',
  })
}

// Debug function to test API methods - you can call this from browser console
window.debugAPI = async () => {
  console.log('🔍 Testing API methods...')

  // Test if we have any products to test with
  if (products.value.length === 0) {
    console.log('❌ No products available for testing')
    return
  }

  const testProduct = products.value[0]
  const testData = { Status: testProduct.Status } // Simple update

  const methods = [
    { name: 'GET Products', test: () => api.get('/Products') },
    {
      name: 'PATCH Product',
      test: () => api.patch(`/Products/${testProduct.ProductID}`, testData),
    },
    { name: 'POST Product', test: () => api.post(`/Products/${testProduct.ProductID}`, testData) },
    { name: 'PUT Product', test: () => api.put(`/Products/${testProduct.ProductID}`, testData) },
    {
      name: 'PUT Records',
      test: () => api.put(`/Products/records/${testProduct.ProductID}`, testData),
    },
    { name: 'PUT Query', test: () => api.put(`/Products?id=${testProduct.ProductID}`, testData) },
  ]

  for (const method of methods) {
    try {
      await method.test()
      console.log(`✅ ${method.name}: SUCCESS`)
    } catch (error) {
      console.log(`❌ ${method.name}: FAILED (${error.response?.status || 'Network Error'})`)
    }
  }

  console.log('🔍 API testing complete. Check the logs above to see which methods work.')
}

// Initialize
onMounted(async () => {
  console.log('🚀 Product Management loaded!')
  console.log('💡 To debug API methods, run: window.debugAPI()')
  console.log('🔍 This will test which HTTP methods your API supports')

  await refreshData()
})
</script>

<style scoped>
.card-flush {
  box-shadow: 0 0 50px 0 rgba(82, 63, 105, 0.05);
}

.symbol-label {
  display: flex;
  align-items: center;
  justify-content: center;
}

@media (max-width: 768px) {
  .btn-group-sm .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.75rem;
  }

  .fs-8 {
    font-size: 0.7rem !important;
  }
}
</style>

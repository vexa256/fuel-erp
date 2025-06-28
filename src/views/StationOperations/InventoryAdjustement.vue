<template>
  <div class="d-flex flex-column gap-7">
    <!-- Premium Header -->
    <div class="card card-flush shadow-sm">
      <div class="card-header border-0 pt-7">
        <div class="card-title">
          <div class="d-flex align-items-center">
            <div class="symbol symbol-50px me-4">
              <div class="symbol-label bg-light-primary">
                <i class="ki-duotone ki-cube-2 fs-2hx text-primary">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </div>
            </div>
            <div>
              <h1 class="fw-bold text-gray-900 mb-1">Non-Fuel Inventory Management</h1>
              <div class="text-muted fs-6">
                Station-level inventory control for lubricants, gas, and other products
              </div>
            </div>
          </div>
        </div>
        <div class="card-toolbar">
          <div class="d-flex align-items-center gap-3">
            <div class="badge badge-light-primary fs-7 px-4 py-2">
              <i class="ki-duotone ki-geolocation fs-6 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ currentStation?.Name || 'No Station Selected' }}
            </div>
            <div class="badge badge-light-success fs-7 px-4 py-2">
              <i class="ki-duotone ki-check-circle fs-6 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Online
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Information Alert for Non-Fuel Products -->
    <div class="alert alert-dismissible bg-light-info border border-info d-flex align-items-center">
      <div class="symbol symbol-40px me-4">
        <div class="symbol-label bg-info">
          <i class="ki-duotone ki-information-5 fs-2 text-white">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
        </div>
      </div>
      <div class="flex-grow-1">
        <h6 class="mb-1 text-gray-800">Non-Fuel Products Only</h6>
        <div class="text-gray-700">
          This view manages lubricants, gas cylinders, and other non-fuel products. Fuel products
          (petrol, diesel, kerosene) are managed separately through the fuel management system.
        </div>
      </div>
    </div>

    <!-- Financial Overview Cards -->
    <div class="row g-6 g-xl-9">
      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100 shadow-sm">
          <div class="card-body d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-4">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-light-success">
                  <i class="ki-duotone ki-arrow-up fs-1 text-success">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-2hx fw-bold text-gray-800">
                  {{ formatCurrency(financialStats.totalInventoryValue) }}
                </div>
                <div class="fs-7 text-muted">Total Inventory Value</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-success">
              <div class="progress-bar bg-success" style="width: 85%"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100 shadow-sm">
          <div class="card-body d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-4">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-light-warning">
                  <i class="ki-duotone ki-chart-line-up fs-1 text-warning">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-2hx fw-bold text-gray-800">
                  {{ formatCurrency(Math.abs(financialStats.adjustmentImpact)) }}
                </div>
                <div class="fs-7 text-muted">30-Day Adjustment Impact</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-warning">
              <div class="progress-bar bg-warning" style="width: 65%"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100 shadow-sm">
          <div class="card-body d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-4">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-light-danger">
                  <i class="ki-duotone ki-arrow-down fs-1 text-danger">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-2hx fw-bold text-gray-800">
                  {{ formatCurrency(financialStats.totalLosses) }}
                </div>
                <div class="fs-7 text-muted">Total Losses (30 Days)</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-danger">
              <div class="progress-bar bg-danger" style="width: 25%"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100 shadow-sm">
          <div class="card-body d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-4">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-light-info">
                  <i class="ki-duotone ki-abstract-39 fs-1 text-info">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-2hx fw-bold text-gray-800">{{ analytics.totalProducts }}</div>
                <div class="fs-7 text-muted">Non-Fuel Products</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-info">
              <div class="progress-bar bg-info" style="width: 95%"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Premium Navigation Tabs -->
    <div class="card card-flush shadow-sm">
      <div class="card-body p-0">
        <ul class="nav nav-stretch nav-pills nav-pills-custom border-transparent fs-5 fw-bold">
          <li class="nav-item">
            <a
              class="nav-link text-center py-4 px-6"
              :class="{ active: activeTab === 'current' }"
              @click="activeTab = 'current'"
              href="#"
            >
              <span class="nav-icon mb-3">
                <i class="ki-duotone ki-element-7 fs-2hx">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </span>
              <span class="nav-text">Non-Fuel Stock</span>
            </a>
          </li>

          <li class="nav-item">
            <a
              class="nav-link text-center py-4 px-6"
              :class="{ active: activeTab === 'adjust' }"
              @click="activeTab = 'adjust'"
              href="#"
            >
              <span class="nav-icon mb-3">
                <i class="ki-duotone ki-pencil fs-2hx">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </span>
              <span class="nav-text">Make Adjustment</span>
            </a>
          </li>

          <li class="nav-item">
            <a
              class="nav-link text-center py-4 px-6"
              :class="{ active: activeTab === 'history' }"
              @click="activeTab = 'history'"
              href="#"
            >
              <span class="nav-icon mb-3">
                <i class="ki-duotone ki-time fs-2hx">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </span>
              <span class="nav-text">History</span>
            </a>
          </li>

          <li class="nav-item">
            <a
              class="nav-link text-center py-4 px-6"
              :class="{ active: activeTab === 'analytics' }"
              @click="activeTab = 'analytics'"
              href="#"
            >
              <span class="nav-icon mb-3">
                <i class="ki-duotone ki-chart-pie fs-2hx">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </span>
              <span class="nav-text">Analytics</span>
            </a>
          </li>
        </ul>
      </div>
    </div>

    <!-- Tab Content -->
    <div class="tab-content">
      <!-- Current Stock Tab -->
      <div v-show="activeTab === 'current'" class="row g-6">
        <div class="col-12">
          <div class="card card-flush shadow-sm">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title fw-bold text-gray-900">Non-Fuel Station Inventory</h3>
              <div class="card-toolbar">
                <button
                  class="btn btn-sm btn-light-primary"
                  @click="loadStationInventory"
                  :disabled="loading"
                >
                  <i class="ki-duotone ki-arrows-circle fs-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Refresh Data
                </button>
              </div>
            </div>
            <div class="card-body">
              <div v-if="loading" class="text-center py-20">
                <div class="spinner-border spinner-border-lg text-primary" role="status"></div>
                <div class="mt-5 fs-6 text-muted">Loading inventory data...</div>
              </div>

              <div v-else-if="!filteredStationInventory.length" class="text-center py-20">
                <div class="symbol symbol-100px mx-auto mb-7">
                  <div class="symbol-label bg-light-warning">
                    <i class="ki-duotone ki-information fs-3x text-warning">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                  </div>
                </div>
                <h4 class="text-muted">No non-fuel inventory records found</h4>
                <p class="text-muted">
                  This view shows only non-fuel products. Fuel products are managed separately.
                </p>
              </div>

              <div v-else class="row g-6">
                <div
                  v-for="item in filteredStationInventory"
                  :key="item.InventoryID"
                  class="col-12 col-md-6 col-xl-4"
                >
                  <div class="card card-bordered h-100 shadow-sm hover-elevate-up">
                    <div class="card-body text-center position-relative">
                      <!-- Stock Status Indicator -->
                      <div class="position-absolute top-0 end-0 m-4">
                        <div
                          class="badge badge-circle badge-lg"
                          :class="getStockStatusBadge(item.CurrentStock)"
                        >
                          <i class="ki-duotone ki-abstract-39 fs-4">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </div>
                      </div>

                      <!-- Product Info -->
                      <div class="symbol symbol-75px mx-auto mb-5">
                        <div class="symbol-label bg-light-primary">
                          <i class="ki-duotone ki-abstract-39 fs-2x text-primary">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </div>
                      </div>

                      <h5 class="card-title mb-3 text-gray-800">
                        {{ getProductName(item.ProductID) }}
                      </h5>

                      <!-- Stock Level -->
                      <div class="fs-1 fw-bold text-gray-900 mb-3">
                        {{ formatNumber(item.CurrentStock) }}
                        <span class="fs-6 text-muted">units</span>
                      </div>

                      <!-- Financial Value -->
                      <div class="mb-4">
                        <div class="fs-6 text-muted">Current Value</div>
                        <div class="fs-4 fw-bold text-success">
                          {{ formatCurrency(calculateProductValue(item)) }}
                        </div>
                      </div>

                      <!-- Status Badge -->
                      <div class="mb-4">
                        <span
                          class="badge badge-lg"
                          :class="getStockStatusBadge(item.CurrentStock)"
                        >
                          {{ getStockStatus(item.CurrentStock) }}
                        </span>
                      </div>

                      <!-- Last Updated -->
                      <div class="text-muted fs-7">
                        <i class="ki-duotone ki-time fs-6 me-1">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        Updated: {{ formatDateTime(item.LastUpdated) }}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Make Adjustment Tab -->
      <div v-show="activeTab === 'adjust'" class="row g-6">
        <div class="col-12 col-xl-8">
          <div class="card card-flush shadow-sm">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title fw-bold text-gray-900">Create Inventory Adjustment</h3>
              <div class="card-toolbar">
                <span class="badge badge-light-info">Step-by-Step Process</span>
              </div>
            </div>
            <div class="card-body">
              <form @submit.prevent="createAdjustment" novalidate>
                <!-- Step 1: Product Selection -->
                <div class="mb-8">
                  <div class="d-flex align-items-center mb-4">
                    <div class="symbol symbol-30px me-3">
                      <div class="symbol-label bg-primary">
                        <span class="text-white fw-bold fs-6">1</span>
                      </div>
                    </div>
                    <h5 class="mb-0 text-gray-800">Select Product</h5>
                  </div>

                  <select
                    v-model="adjustmentForm.ProductID"
                    class="form-select form-select-lg form-select-solid"
                    :class="{ 'is-invalid': errors.ProductID }"
                    @change="onProductChange"
                  >
                    <option value="">Choose a non-fuel product to adjust...</option>
                    <option
                      v-for="product in filteredProducts"
                      :key="product.ProductID"
                      :value="product.ProductID"
                    >
                      {{ product.Name }} - {{ product.ProductType }} ({{
                        formatCurrency(product.UnitPrice)
                      }}/unit)
                    </option>
                  </select>
                  <div v-if="errors.ProductID" class="invalid-feedback">
                    {{ errors.ProductID }}
                  </div>
                </div>

                <!-- Current Stock Display -->
                <div
                  v-if="selectedInventoryRecord"
                  class="alert alert-dismissible bg-light-info border border-info mb-8"
                >
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-50px me-4">
                      <div class="symbol-label bg-info">
                        <i class="ki-duotone ki-information-5 fs-2 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                        </i>
                      </div>
                    </div>
                    <div class="flex-grow-1">
                      <h6 class="mb-1 text-gray-800">Current Stock Information</h6>
                      <div class="row">
                        <div class="col-6">
                          <div class="fs-7 text-muted">Current Stock</div>
                          <div class="fs-5 fw-bold text-gray-800">
                            {{ formatNumber(selectedInventoryRecord.CurrentStock) }} units
                          </div>
                        </div>
                        <div class="col-6">
                          <div class="fs-7 text-muted">Current Value</div>
                          <div class="fs-5 fw-bold text-success">
                            {{ formatCurrency(calculateProductValue(selectedInventoryRecord)) }}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Step 2: Adjustment Details -->
                <div class="mb-8">
                  <div class="d-flex align-items-center mb-4">
                    <div class="symbol symbol-30px me-3">
                      <div class="symbol-label bg-warning">
                        <span class="text-white fw-bold fs-6">2</span>
                      </div>
                    </div>
                    <h5 class="mb-0 text-gray-800">Adjustment Details</h5>
                  </div>

                  <div class="row g-6">
                    <div class="col-12 col-md-6">
                      <label class="required form-label fw-semibold">Adjustment Type</label>
                      <select
                        v-model="adjustmentForm.ChangeType"
                        class="form-select form-select-lg form-select-solid"
                        :class="{ 'is-invalid': errors.ChangeType }"
                      >
                        <option value="">Select adjustment type...</option>
                        <option value="Physical Count">Physical Count Adjustment</option>
                        <option value="Loss Adjustment">Loss/Shrinkage</option>
                        <option value="Found Inventory">Found Inventory</option>
                        <option value="Quality Control">Quality Control</option>
                        <option value="Transfer Correction">Transfer Correction</option>
                        <option value="System Correction">System Correction</option>
                        <option value="Delivery">Delivery Received</option>
                        <option value="Other">Other</option>
                      </select>
                      <div v-if="errors.ChangeType" class="invalid-feedback">
                        {{ errors.ChangeType }}
                      </div>
                    </div>

                    <div class="col-12 col-md-6">
                      <label class="required form-label fw-semibold">Quantity Change</label>
                      <div class="input-group input-group-lg input-group-solid">
                        <span class="input-group-text">±</span>
                        <input
                          v-model="adjustmentForm.QuantityChange"
                          type="number"
                          step="0.01"
                          class="form-control form-control-lg form-control-solid"
                          :class="{ 'is-invalid': errors.QuantityChange }"
                          placeholder="Enter adjustment amount"
                        />
                        <span class="input-group-text">units</span>
                      </div>
                      <div v-if="errors.QuantityChange" class="invalid-feedback">
                        {{ errors.QuantityChange }}
                      </div>
                      <div class="form-text">Use negative numbers for stock reductions</div>
                    </div>
                  </div>
                </div>

                <!-- Step 3: Documentation -->
                <div class="mb-8">
                  <div class="d-flex align-items-center mb-4">
                    <div class="symbol symbol-30px me-3">
                      <div class="symbol-label bg-success">
                        <span class="text-white fw-bold fs-6">3</span>
                      </div>
                    </div>
                    <h5 class="mb-0 text-gray-800">Documentation & Details</h5>
                  </div>

                  <div class="row g-6">
                    <div class="col-12">
                      <label class="required form-label fw-semibold">Reason for Adjustment</label>
                      <input
                        v-model="adjustmentForm.ReasonForChange"
                        type="text"
                        class="form-control form-control-lg form-control-solid"
                        :class="{ 'is-invalid': errors.ReasonForChange }"
                        placeholder="Provide a detailed explanation for this adjustment"
                      />
                      <div v-if="errors.ReasonForChange" class="invalid-feedback">
                        {{ errors.ReasonForChange }}
                      </div>
                    </div>

                    <div class="col-12 col-md-6">
                      <label class="form-label fw-semibold">Additional Notes</label>
                      <textarea
                        v-model="adjustmentForm.Notes"
                        class="form-control form-control-solid"
                        rows="4"
                        placeholder="Any additional observations, batch numbers, or supporting information..."
                      ></textarea>
                    </div>

                    <div class="col-12 col-md-6">
                      <label class="form-label fw-semibold">Batch Number</label>
                      <input
                        v-model="adjustmentForm.BatchNumber"
                        type="text"
                        class="form-control form-control-lg form-control-solid"
                        placeholder="Optional batch or lot number"
                      />

                      <label class="form-label fw-semibold mt-4">Measurement Method</label>
                      <select
                        v-model="adjustmentForm.MeasurementMethod"
                        class="form-select form-select-solid"
                      >
                        <option value="Manual Count">Manual Count</option>
                        <option value="Tank Dipping">Tank Dipping</option>
                        <option value="Meter Reading">Meter Reading</option>
                        <option value="Electronic Gauge">Electronic Gauge</option>
                        <option value="Calculated">Calculated</option>
                        <option value="System Generated">System Generated</option>
                      </select>
                    </div>
                  </div>
                </div>

                <!-- Financial Impact Preview -->
                <div
                  v-if="selectedInventoryRecord && adjustmentForm.QuantityChange"
                  class="alert alert-dismissible bg-light-primary border border-primary mb-8"
                >
                  <div class="d-flex align-items-center mb-4">
                    <div class="symbol symbol-40px me-3">
                      <div class="symbol-label bg-primary">
                        <i class="ki-duotone ki-chart-pie fs-2 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                        </i>
                      </div>
                    </div>
                    <h6 class="mb-0 text-gray-800">Financial Impact Preview</h6>
                  </div>

                  <div class="row text-center g-4">
                    <div class="col-3">
                      <div class="fs-7 text-muted">Current Stock</div>
                      <div class="fs-5 fw-bold text-gray-800">
                        {{ formatNumber(selectedInventoryRecord.CurrentStock) }}
                      </div>
                      <div class="fs-7 text-success">
                        {{ formatCurrency(calculateProductValue(selectedInventoryRecord)) }}
                      </div>
                    </div>
                    <div class="col-3">
                      <div class="fs-7 text-muted">Adjustment</div>
                      <div
                        class="fs-5 fw-bold"
                        :class="
                          parseFloat(adjustmentForm.QuantityChange) >= 0
                            ? 'text-success'
                            : 'text-danger'
                        "
                      >
                        {{ parseFloat(adjustmentForm.QuantityChange) >= 0 ? '+' : ''
                        }}{{ formatNumber(adjustmentForm.QuantityChange) }}
                      </div>
                      <div
                        class="fs-7"
                        :class="
                          parseFloat(adjustmentForm.QuantityChange) >= 0
                            ? 'text-success'
                            : 'text-danger'
                        "
                      >
                        {{ formatCurrency(calculateAdjustmentValue()) }}
                      </div>
                    </div>
                    <div class="col-3">
                      <div class="fs-7 text-muted">New Stock</div>
                      <div class="fs-5 fw-bold text-gray-800">
                        {{ formatNumber(calculateNewStock()) }}
                      </div>
                      <div class="fs-7 text-primary">
                        {{ formatCurrency(calculateNewProductValue()) }}
                      </div>
                    </div>
                    <div class="col-3">
                      <div class="fs-7 text-muted">Net Impact</div>
                      <div
                        class="fs-5 fw-bold"
                        :class="calculateAdjustmentValue() >= 0 ? 'text-success' : 'text-danger'"
                      >
                        {{ calculateAdjustmentValue() >= 0 ? '+' : ''
                        }}{{ formatCurrency(calculateAdjustmentValue()) }}
                      </div>
                      <div class="fs-7 text-muted">
                        {{ calculateAdjustmentValue() >= 0 ? 'Value Added' : 'Value Lost' }}
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Submit Button -->
                <div class="text-center">
                  <button
                    type="submit"
                    class="btn btn-primary btn-lg px-12"
                    :disabled="loading || !isFormValid"
                  >
                    <span v-if="loading" class="spinner-border spinner-border-sm me-3"></span>
                    <i v-else class="ki-duotone ki-check fs-2 me-3">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    {{ loading ? 'Processing Adjustment...' : 'Create Adjustment' }}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- Quick Actions Sidebar -->
        <div class="col-12 col-xl-4">
          <div class="card card-flush shadow-sm h-100">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title fw-bold text-gray-900">Quick Actions</h3>
            </div>
            <div class="card-body">
              <div class="d-grid gap-4">
                <button
                  class="btn btn-light-success btn-lg text-start"
                  @click="
                    setQuickAdjustment(
                      'Physical Count',
                      'Monthly physical stock count verification',
                    )
                  "
                >
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-4">
                      <div class="symbol-label bg-success">
                        <i class="ki-duotone ki-search-list fs-2 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fw-bold">Physical Count</div>
                      <div class="fs-7 text-muted">Stock verification</div>
                    </div>
                  </div>
                </button>

                <button
                  class="btn btn-light-warning btn-lg text-start"
                  @click="
                    setQuickAdjustment(
                      'Loss Adjustment',
                      'Stock loss due to evaporation or spillage',
                    )
                  "
                >
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-4">
                      <div class="symbol-label bg-warning">
                        <i class="ki-duotone ki-arrow-down fs-2 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fw-bold">Record Loss</div>
                      <div class="fs-7 text-muted">Evaporation, spillage</div>
                    </div>
                  </div>
                </button>

                <button
                  class="btn btn-light-info btn-lg text-start"
                  @click="
                    setQuickAdjustment('Delivery', 'Stock replenishment from supplier delivery')
                  "
                >
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-4">
                      <div class="symbol-label bg-info">
                        <i class="ki-duotone ki-truck fs-2 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                          <span class="path4"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fw-bold">New Delivery</div>
                      <div class="fs-7 text-muted">Supplier replenishment</div>
                    </div>
                  </div>
                </button>

                <button
                  class="btn btn-light-primary btn-lg text-start"
                  @click="
                    setQuickAdjustment(
                      'Transfer Correction',
                      'Correction for inter-station transfer discrepancy',
                    )
                  "
                >
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-4">
                      <div class="symbol-label bg-primary">
                        <i class="ki-duotone ki-arrows-loop fs-2 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fw-bold">Transfer Fix</div>
                      <div class="fs-7 text-muted">Discrepancy correction</div>
                    </div>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- History Tab -->
      <div v-show="activeTab === 'history'" class="row g-6">
        <div class="col-12">
          <div class="card card-flush shadow-sm">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title fw-bold text-gray-900">Adjustment History</h3>
              <div class="card-toolbar">
                <button class="btn btn-sm btn-light-primary" @click="loadAdjustmentHistory">
                  <i class="ki-duotone ki-arrows-circle fs-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Refresh
                </button>
              </div>
            </div>
            <div class="card-body">
              <div v-if="!adjustmentHistory.length" class="text-center py-20">
                <div class="symbol symbol-100px mx-auto mb-7">
                  <div class="symbol-label bg-light-info">
                    <i class="ki-duotone ki-file-deleted fs-3x text-info">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </div>
                </div>
                <h4 class="text-muted">No adjustment history found</h4>
                <p class="text-muted">
                  Your adjustment history will appear here once you make adjustments.
                </p>
              </div>

              <div v-else class="table-responsive">
                <table class="table table-rounded table-hover table-striped border gy-7 gs-7">
                  <thead class="bg-light">
                    <tr class="fw-semibold fs-6 text-gray-800 border-bottom-2 border-gray-200">
                      <th class="min-w-150px">Date & Time</th>
                      <th class="min-w-150px">Product</th>
                      <th class="min-w-100px">Type</th>
                      <th class="min-w-100px text-end">Previous Stock</th>
                      <th class="min-w-100px text-end">Change</th>
                      <th class="min-w-100px text-end">New Stock</th>
                      <th class="min-w-120px text-end">Financial Impact</th>
                      <th class="min-w-200px">Reason</th>
                      <th class="min-w-100px">User</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr
                      v-for="item in adjustmentHistory"
                      :key="item.HistoryID"
                      class="hover-bg-light"
                    >
                      <td>
                        <div class="fw-bold text-gray-800">{{ formatDate(item.ChangeDate) }}</div>
                        <div class="fs-7 text-muted">{{ formatTime(item.ChangeDate) }}</div>
                      </td>
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="symbol symbol-30px me-3">
                            <div class="symbol-label bg-light-primary">
                              <i class="ki-duotone ki-abstract-39 fs-6 text-primary">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                            </div>
                          </div>
                          <div class="fw-bold text-gray-800">
                            {{ getProductName(item.ProductID) }}
                          </div>
                        </div>
                      </td>
                      <td>
                        <span class="badge badge-light-primary">{{ item.ChangeType }}</span>
                      </td>
                      <td class="text-end fw-bold">{{ formatNumber(item.PreviousQuantity) }}</td>
                      <td class="text-end">
                        <span
                          class="fw-bold"
                          :class="
                            parseFloat(item.QuantityChange) >= 0 ? 'text-success' : 'text-danger'
                          "
                        >
                          {{ parseFloat(item.QuantityChange) >= 0 ? '+' : ''
                          }}{{ formatNumber(item.QuantityChange) }}
                        </span>
                      </td>
                      <td class="text-end fw-bold">{{ formatNumber(item.NewQuantity) }}</td>
                      <td class="text-end">
                        <span
                          class="fw-bold"
                          :class="
                            parseFloat(item.TotalValue || 0) >= 0 ? 'text-success' : 'text-danger'
                          "
                        >
                          {{ formatCurrency(item.TotalValue || 0) }}
                        </span>
                      </td>
                      <td>
                        <div class="text-gray-800">{{ item.ReasonForChange || 'N/A' }}</div>
                        <div v-if="item.Notes" class="fs-7 text-muted">{{ item.Notes }}</div>
                      </td>
                      <td>{{ getUserDisplayName(item.RecordedBy) }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Analytics Tab -->
      <div v-show="activeTab === 'analytics'" class="row g-6">
        <!-- Financial Trend Chart -->
        <div class="col-12 col-xl-8">
          <div class="card card-flush shadow-sm h-100">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title fw-bold text-gray-900">Financial Impact Trends</h3>
              <div class="card-toolbar">
                <span class="badge badge-light-info">30-Day Overview</span>
              </div>
            </div>
            <div class="card-body">
              <div ref="financialChart" style="width: 100%; height: 400px"></div>
            </div>
          </div>
        </div>

        <!-- Key Metrics -->
        <div class="col-12 col-xl-4">
          <div class="card card-flush shadow-sm h-100">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title fw-bold text-gray-900">Key Metrics</h3>
            </div>
            <div class="card-body">
              <div class="d-flex flex-column gap-6">
                <div class="d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <div class="symbol-label bg-light-success">
                        <i class="ki-duotone ki-arrow-up fs-2 text-success">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fs-6 text-muted">Total Gains</div>
                      <div class="fs-5 fw-bold text-gray-800">
                        {{ formatCurrency(financialStats.totalGains) }}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="separator"></div>

                <div class="d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <div class="symbol-label bg-light-danger">
                        <i class="ki-duotone ki-arrow-down fs-2 text-danger">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fs-6 text-muted">Total Losses</div>
                      <div class="fs-5 fw-bold text-gray-800">
                        {{ formatCurrency(Math.abs(financialStats.totalLosses)) }}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="separator"></div>

                <div class="d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <div class="symbol-label bg-light-primary">
                        <i class="ki-duotone ki-chart-line-up fs-2 text-primary">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fs-6 text-muted">Net Impact</div>
                      <div
                        class="fs-5 fw-bold"
                        :class="financialStats.netImpact >= 0 ? 'text-success' : 'text-danger'"
                      >
                        {{ formatCurrency(financialStats.netImpact) }}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="separator"></div>

                <div class="d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <div class="symbol-label bg-light-warning">
                        <i class="ki-duotone ki-percentage fs-2 text-warning">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fs-6 text-muted">Loss Ratio</div>
                      <div class="fs-5 fw-bold text-gray-800">{{ financialStats.lossRatio }}%</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product Performance Chart -->
        <div class="col-12">
          <div class="card card-flush shadow-sm">
            <div class="card-header border-0 pt-6">
              <h3 class="card-title fw-bold text-gray-900">Product Performance Overview</h3>
            </div>
            <div class="card-body">
              <div ref="productChart" style="width: 100%; height: 300px"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'
import * as echarts from 'echarts'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// Get auth data from universal login logic
const getAuthData = () => {
  try {
    return JSON.parse(localStorage.getItem('kigrama_user_data') || '{}')
  } catch {
    return {}
  }
}

const getJwtToken = () => {
  return localStorage.getItem('kigrama_auth_token') || ''
}

// Reactive State
const AUTH_DATA = ref(getAuthData())
const JWT_TOKEN = ref(getJwtToken())
const activeTab = ref('current')
const loading = ref(false)
const stationInventory = ref([])
const products = ref([])
const stationTanks = ref([])
const adjustmentHistory = ref([])
const users = ref([]) // Add users data for user name lookup

// Chart references
const financialChart = ref(null)
const productChart = ref(null)

// Adjustment Form
const adjustmentForm = reactive({
  ProductID: '',
  ChangeType: '',
  QuantityChange: '',
  ReasonForChange: '',
  Notes: '',
  BatchNumber: '',
  MeasurementMethod: 'Manual Count',
})

// Form Errors
const errors = reactive({})

// Computed Properties
const currentUser = computed(() => AUTH_DATA.value.user || {})
const userStations = computed(() => AUTH_DATA.value.stations || [])
const currentStation = computed(() => userStations.value[0] || null)
const currentStationId = computed(() => currentStation.value?.StationID || null)

const selectedInventoryRecord = computed(() => {
  if (!adjustmentForm.ProductID) return null
  return stationInventory.value.find((item) => item.ProductID == adjustmentForm.ProductID)
})

// Filter out tanked products - only show non-fuel products for this view
const filteredProducts = computed(() => {
  if (!stationTanks.value.length) return products.value

  const tankedProductIds = stationTanks.value.map((tank) => tank.ProductID)
  return products.value.filter((product) => !tankedProductIds.includes(product.ProductID))
})

// Filter station inventory to only show non-tanked products
const filteredStationInventory = computed(() => {
  if (!stationTanks.value.length) return stationInventory.value

  const tankedProductIds = stationTanks.value.map((tank) => tank.ProductID)
  return stationInventory.value.filter((item) => !tankedProductIds.includes(item.ProductID))
})

const isFormValid = computed(() => {
  return (
    adjustmentForm.ProductID &&
    adjustmentForm.ChangeType &&
    adjustmentForm.QuantityChange &&
    adjustmentForm.ReasonForChange?.length >= 10
  )
})

const analytics = computed(() => {
  const totalProducts = filteredStationInventory.value.length
  const totalStock = filteredStationInventory.value.reduce(
    (sum, item) => sum + parseFloat(item.CurrentStock || 0),
    0,
  )
  const lowStockItems = filteredStationInventory.value.filter(
    (item) => parseFloat(item.CurrentStock || 0) < 100,
  ).length
  const recentAdjustments = adjustmentHistory.value.filter(
    (h) => new Date(h.ChangeDate) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
  ).length

  return {
    totalProducts,
    totalStock,
    lowStockItems,
    recentAdjustments,
    lastUpdate: new Date().toLocaleString(),
  }
})

const financialStats = computed(() => {
  const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000)
  const recentHistory = adjustmentHistory.value.filter(
    (h) => new Date(h.ChangeDate) > thirtyDaysAgo,
  )

  const totalGains = recentHistory
    .filter((h) => parseFloat(h.TotalValue || 0) > 0)
    .reduce((sum, h) => sum + parseFloat(h.TotalValue || 0), 0)

  const totalLosses = recentHistory
    .filter((h) => parseFloat(h.TotalValue || 0) < 0)
    .reduce((sum, h) => sum + parseFloat(h.TotalValue || 0), 0)

  const totalInventoryValue = filteredStationInventory.value.reduce((sum, item) => {
    const product = filteredProducts.value.find((p) => p.ProductID === item.ProductID)
    const price = parseFloat(product?.UnitPrice || 0)
    const stock = parseFloat(item.CurrentStock || 0)
    return sum + price * stock
  }, 0)

  const adjustmentImpact = totalGains + totalLosses
  const netImpact = totalGains + totalLosses
  const lossRatio =
    totalInventoryValue > 0 ? ((Math.abs(totalLosses) / totalInventoryValue) * 100).toFixed(2) : 0

  return {
    totalInventoryValue,
    adjustmentImpact,
    totalGains,
    totalLosses,
    netImpact,
    lossRatio,
  }
})

// API Helper Function with improved error handling
const apiCall = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${JWT_TOKEN.value}`,
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      let errorText = 'Unknown error'
      try {
        errorText = await response.text()
      } catch (e) {
        errorText = `HTTP ${response.status} ${response.statusText}`
      }
      throw new Error(`API Error: ${response.status} ${response.statusText} - ${errorText}`)
    }

    // Check if response has content
    const contentLength = response.headers.get('content-length')
    const contentType = response.headers.get('content-type')

    // If content-length is 0 or response status is 204, return empty object
    if (contentLength === '0' || response.status === 204) {
      return {}
    }

    // If content-type indicates JSON, try to parse
    if (contentType && contentType.includes('application/json')) {
      try {
        const text = await response.text()
        return text.trim() ? JSON.parse(text) : {}
      } catch (parseError) {
        console.warn('Failed to parse JSON response:', parseError)
        return {}
      }
    }

    // For non-JSON responses, return empty object
    return {}
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}

// Fraud Detection Logic
const detectSuspiciousActivity = (adjustmentData) => {
  const quantityChange = Math.abs(parseFloat(adjustmentData.QuantityChange || 0))
  const totalValue = quantityChange * parseFloat(getSelectedProductPrice())

  const suspiciousFlags = {
    largeQuantityAdjustment: quantityChange > 1000,
    highValueAdjustment: totalValue > 500000,
    offHoursActivity: new Date().getHours() < 6 || new Date().getHours() > 22,
    emptyOrVagueReason:
      !adjustmentData.ReasonForChange?.trim() || adjustmentData.ReasonForChange.length < 10,
    frequentAdjustments: hasFrequentRecentAdjustments(),
    unusualPattern: quantityChange > 5000,
  }

  const flagCount = Object.values(suspiciousFlags).filter(Boolean).length
  const riskScore = Math.min(flagCount * 15, 100)

  return {
    riskScore,
    riskLevel:
      riskScore >= 75 ? 'CRITICAL' : riskScore >= 50 ? 'HIGH' : riskScore >= 25 ? 'MEDIUM' : 'LOW',
    flags: Object.keys(suspiciousFlags).filter((key) => suspiciousFlags[key]),
    isSuspicious: flagCount > 0,
    severity:
      riskScore >= 75 ? 'Critical' : riskScore >= 50 ? 'High' : riskScore >= 25 ? 'Medium' : 'Low',
  }
}

// Focused Logging Function (removed EventLog as requested)
const logToTables = async (action, data, fraudResult = null) => {
  const timestamp = new Date().toISOString()

  // Log to AuditLogs
  try {
    await apiCall('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify({
        TableName: data.tableName || 'StationInventory',
        RecordID: data.recordId?.toString() || null,
        Action: action,
        OldValues: JSON.stringify(data.oldValues || {}),
        NewValues: JSON.stringify(data.newValues || {}),
        UserID: currentUser.value.id,
        IPAddress: 'client_ip_placeholder',
        UserAgent: navigator.userAgent,
        Timestamp: timestamp,
        AdditionalInfo: JSON.stringify({
          stationId: currentStationId.value,
          productId: data.productId,
          details: data.details || {},
        }),
      }),
    })
  } catch (auditError) {
    console.error('Failed to log to AuditLogs:', auditError)
    // Don't throw - logging failures shouldn't block business operations
  }

  // Log to FraudDetectionLogs if suspicious
  if (fraudResult?.isSuspicious) {
    try {
      await apiCall('/FraudDetectionLogs', {
        method: 'POST',
        body: JSON.stringify({
          DetectionRuleID: null,
          TransactionID: null,
          StationID: currentStationId.value,
          UserID: currentUser.value.id,
          RiskScore: fraudResult.riskScore.toString(),
          Severity: fraudResult.severity,
          FraudType: 'Inventory Adjustment',
          Description: `Suspicious inventory adjustment: ${fraudResult.flags.join(', ')}`,
          DetectedAt: timestamp,
          Status: 'Open',
          ResolvedBy: null,
          ResolvedAt: null,
          Notes: `Product: ${data.productName}, Change: ${data.quantityChange}, Reason: ${data.reason}`,
          CreatedAt: timestamp,
          UpdatedAt: timestamp,
        }),
      })
    } catch (fraudError) {
      console.error('Failed to log to FraudDetectionLogs:', fraudError)
      // Don't throw - logging failures shouldn't block business operations
    }
  }
}

// Load Station Tanks (100% station-specific)
const loadStationTanks = async () => {
  if (!currentStationId.value) return

  try {
    const response = await apiCall(`/Tanks?StationID=${currentStationId.value}`)
    stationTanks.value = response.records || []

    console.log('Loaded station tanks:', stationTanks.value.length)

    await logToTables('VIEW_STATION_TANKS', {
      tableName: 'Tanks',
      details: { recordCount: stationTanks.value.length },
    })
  } catch (error) {
    console.error('Failed to load station tanks:', error)
    // Don't show error to user as this is for filtering purposes
    stationTanks.value = [] // Ensure empty array on error
  }
}

// Load Station Inventory (100% station-specific)
const loadStationInventory = async () => {
  if (!currentStationId.value) {
    Swal.fire({
      title: 'No Station Assigned',
      text: 'You are not assigned to any station',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  loading.value = true
  try {
    const response = await apiCall(`/StationInventory?StationID=${currentStationId.value}`)
    stationInventory.value = response.records || []

    console.log('Loaded station inventory:', stationInventory.value.length)

    await logToTables('VIEW_STATION_INVENTORY', {
      tableName: 'StationInventory',
      details: { recordCount: stationInventory.value.length },
    })
  } catch (error) {
    console.error('Failed to load station inventory:', error)
    stationInventory.value = [] // Ensure empty array on error

    Swal.fire({
      title: 'Load Failed',
      text: 'Failed to load station inventory data',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Load Users for name display
const loadUsers = async () => {
  try {
    const response = await apiCall('/users')
    users.value = response.records || []

    console.log('Loaded users:', users.value.length)
  } catch (error) {
    console.error('Failed to load users:', error)
    users.value = [] // Ensure empty array on error
  }
}

// Load Products
const loadProducts = async () => {
  try {
    const response = await apiCall('/Products')
    products.value = response.records || []

    console.log('Loaded products:', products.value.length)
  } catch (error) {
    console.error('Failed to load products:', error)
    products.value = [] // Ensure empty array on error
  }
}

// Load Adjustment History (100% station-specific)
const loadAdjustmentHistory = async () => {
  if (!currentStationId.value) return

  try {
    const response = await apiCall(
      `/InventoryHistory?StationID=${currentStationId.value}&limit=100`,
    )
    adjustmentHistory.value = (response.records || []).sort(
      (a, b) => new Date(b.ChangeDate) - new Date(a.ChangeDate),
    )

    console.log('Loaded adjustment history:', adjustmentHistory.value.length)

    await logToTables('VIEW_ADJUSTMENT_HISTORY', {
      tableName: 'InventoryHistory',
      details: { recordCount: adjustmentHistory.value.length },
    })
  } catch (error) {
    console.error('Failed to load adjustment history:', error)
    adjustmentHistory.value = [] // Ensure empty array on error
  }
}

// Form Validation
const validateForm = () => {
  // Clear previous errors
  Object.keys(errors).forEach((key) => {
    errors[key] = ''
  })

  let isValid = true

  if (!adjustmentForm.ProductID) {
    errors.ProductID = 'Product selection is required'
    isValid = false
  }

  if (!adjustmentForm.ChangeType) {
    errors.ChangeType = 'Adjustment type is required'
    isValid = false
  }

  if (!adjustmentForm.QuantityChange || adjustmentForm.QuantityChange === '0') {
    errors.QuantityChange = 'Quantity change is required and cannot be zero'
    isValid = false
  } else if (isNaN(parseFloat(adjustmentForm.QuantityChange))) {
    errors.QuantityChange = 'Quantity change must be a valid number'
    isValid = false
  }

  if (!adjustmentForm.ReasonForChange?.trim()) {
    errors.ReasonForChange = 'Reason is required'
    isValid = false
  } else if (adjustmentForm.ReasonForChange.trim().length < 10) {
    errors.ReasonForChange = 'Reason must be at least 10 characters'
    isValid = false
  }

  return isValid
}

// Create Adjustment
const createAdjustment = async () => {
  if (!validateForm()) return

  const quantityChange = parseFloat(adjustmentForm.QuantityChange)
  const currentStock = parseFloat(selectedInventoryRecord.value?.CurrentStock || 0)
  const newStock = currentStock + quantityChange

  if (newStock < 0) {
    Swal.fire({
      title: 'Invalid Adjustment',
      text: 'Adjustment would result in negative stock. Please check your values.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  loading.value = true

  console.log('Starting adjustment creation with data:', {
    productId: adjustmentForm.ProductID,
    changeType: adjustmentForm.ChangeType,
    quantityChange: quantityChange,
    newStock: newStock,
    stationId: currentStationId.value,
  })

  try {
    const selectedProduct = filteredProducts.value.find(
      (p) => p.ProductID == adjustmentForm.ProductID,
    )
    const unitPrice = parseFloat(selectedProduct?.UnitPrice || 0)
    const totalValue = quantityChange * unitPrice
    const timestamp = new Date().toISOString()

    // Fraud detection
    const fraudResult = detectSuspiciousActivity({
      ...adjustmentForm,
      QuantityChange: quantityChange,
      totalValue,
    })

    // Prepare InventoryHistory data
    const historyData = {
      StationID: currentStationId.value,
      ProductID: parseInt(adjustmentForm.ProductID),
      TankID: null,
      PumpID: null,
      TransactionID: null,
      TransferID: null,
      ChangeDate: timestamp,
      ChangeType: adjustmentForm.ChangeType,
      PreviousQuantity: currentStock.toString(),
      QuantityChange: quantityChange.toString(),
      NewQuantity: newStock.toString(),
      UnitPrice: unitPrice.toString(),
      TotalValue: totalValue.toString(),
      ReasonForChange: adjustmentForm.ReasonForChange,
      AdjustmentCategory: adjustmentForm.ChangeType,
      BatchNumber: adjustmentForm.BatchNumber || null,
      ExpiryDate: null,
      QualityCheck: 'Passed',
      MeasurementMethod: adjustmentForm.MeasurementMethod,
      MeasurementDetails: adjustmentForm.Notes || null,
      AuthorizedBy: currentUser.value.id?.toString(),
      RecordedBy: currentUser.value.id?.toString(),
      VerifiedBy: null,
      Notes: adjustmentForm.Notes || null,
      AdditionalProperties: JSON.stringify({
        fraudRisk: fraudResult.riskLevel,
        userAgent: navigator.userAgent,
        clientTimestamp: timestamp,
      }),
      CreatedAt: timestamp,
    }

    // Create inventory history record
    let historyResponse = {}
    try {
      console.log('Creating inventory history with data:', historyData)

      historyResponse = await apiCall('/InventoryHistory', {
        method: 'POST',
        body: JSON.stringify(historyData),
      })

      console.log('History creation response:', historyResponse)
    } catch (historyError) {
      console.error('Failed to create inventory history:', historyError)
      // Continue with other operations even if history creation fails
    }

    // Update or create station inventory record
    try {
      if (selectedInventoryRecord.value) {
        console.log(
          'Updating existing inventory record:',
          selectedInventoryRecord.value.InventoryID,
        )

        const updateResponse = await apiCall(
          `/StationInventory/${selectedInventoryRecord.value.InventoryID}`,
          {
            method: 'PATCH',
            body: JSON.stringify({
              CurrentStock: newStock.toString(),
              LastUpdated: timestamp,
            }),
          },
        )

        console.log('Inventory update response:', updateResponse)
      } else {
        console.log('Creating new inventory record for product:', adjustmentForm.ProductID)

        const createResponse = await apiCall('/StationInventory', {
          method: 'POST',
          body: JSON.stringify({
            StationID: currentStationId.value,
            ProductID: parseInt(adjustmentForm.ProductID),
            CurrentStock: newStock.toString(),
            LastUpdated: timestamp,
          }),
        })

        console.log('Inventory creation response:', createResponse)
      }
    } catch (inventoryError) {
      console.error('Failed to update station inventory:', inventoryError)
      throw new Error('Failed to update inventory record')
    }

    // Focused logging (removed EventLog)
    await logToTables(
      'CREATE_INVENTORY_ADJUSTMENT',
      {
        tableName: 'InventoryHistory',
        recordId: historyResponse?.id || historyResponse?.HistoryID || null,
        productId: adjustmentForm.ProductID,
        productName: selectedProduct?.Name,
        quantityChange: quantityChange.toString(),
        reason: adjustmentForm.ReasonForChange,
        notes: adjustmentForm.Notes,
        oldValues: { CurrentStock: currentStock },
        newValues: { CurrentStock: newStock },
        details: {
          changeType: adjustmentForm.ChangeType,
          measurementMethod: adjustmentForm.MeasurementMethod,
          batchNumber: adjustmentForm.BatchNumber,
          totalValue: totalValue,
        },
      },
      fraudResult,
    )

    // Success notification
    await Swal.fire({
      title: 'Adjustment Created!',
      text: `${selectedProduct?.Name} stock adjusted by ${quantityChange >= 0 ? '+' : ''}${quantityChange} units`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    // Reset form
    Object.assign(adjustmentForm, {
      ProductID: '',
      ChangeType: '',
      QuantityChange: '',
      ReasonForChange: '',
      Notes: '',
      BatchNumber: '',
      MeasurementMethod: 'Manual Count',
    })
    Object.assign(errors, {})

    // Refresh data and switch to history tab
    try {
      await Promise.all([loadStationInventory(), loadAdjustmentHistory()])

      // Update charts
      nextTick(() => {
        initializeCharts()
      })

      activeTab.value = 'history'
    } catch (refreshError) {
      console.error('Failed to refresh data after adjustment:', refreshError)
      // Show warning but don't block the success flow
      Swal.fire({
        title: 'Refresh Warning',
        text: 'Adjustment created successfully, but failed to refresh display. Please refresh manually.',
        icon: 'warning',
        confirmButtonColor: '#3699ff',
      })
    }
  } catch (error) {
    console.error('Adjustment creation error:', error)

    // Provide more specific error messages
    let errorMessage = 'Failed to create inventory adjustment'
    if (error.message.includes('Failed to update inventory record')) {
      errorMessage = 'Failed to update inventory record. Please try again.'
    } else if (error.message.includes('API Error: 401')) {
      errorMessage = 'Authentication failed. Please login again.'
    } else if (error.message.includes('API Error: 403')) {
      errorMessage = 'Access denied. You may not have permission to make adjustments.'
    } else if (error.message.includes('API Error: 500')) {
      errorMessage = 'Server error. Please contact support if this continues.'
    } else if (error.message) {
      errorMessage = error.message
    }

    await Swal.fire({
      title: 'Adjustment Failed',
      text: errorMessage,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Initialize Charts
const initializeCharts = () => {
  if (financialChart.value) {
    const chart = echarts.init(financialChart.value)

    // Prepare financial trend data
    const last30Days = []
    const financialData = []
    for (let i = 29; i >= 0; i--) {
      const date = new Date(Date.now() - i * 24 * 60 * 60 * 1000)
      last30Days.push(date.toISOString().split('T')[0])

      const dayHistory = adjustmentHistory.value.filter(
        (h) => h.ChangeDate && h.ChangeDate.split('T')[0] === date.toISOString().split('T')[0],
      )

      const dayTotal = dayHistory.reduce((sum, h) => sum + parseFloat(h.TotalValue || 0), 0)
      financialData.push(dayTotal)
    }

    const option = {
      title: {
        text: 'Daily Financial Impact',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 'bold',
        },
      },
      tooltip: {
        trigger: 'axis',
        formatter: function (params) {
          const value = params[0].value
          return `${params[0].name}<br/>Impact: ${formatCurrency(value)}`
        },
      },
      xAxis: {
        type: 'category',
        data: last30Days,
        axisLabel: {
          formatter: function (value) {
            return new Date(value).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
          },
        },
      },
      yAxis: {
        type: 'value',
        axisLabel: {
          formatter: function (value) {
            return formatCurrency(value)
          },
        },
      },
      series: [
        {
          data: financialData,
          type: 'line',
          smooth: true,
          areaStyle: {
            color: {
              type: 'linear',
              x: 0,
              y: 0,
              x2: 0,
              y2: 1,
              colorStops: [
                {
                  offset: 0,
                  color: 'rgba(54, 153, 255, 0.3)',
                },
                {
                  offset: 1,
                  color: 'rgba(54, 153, 255, 0.05)',
                },
              ],
            },
          },
          lineStyle: {
            color: '#3699ff',
            width: 3,
          },
          itemStyle: {
            color: '#3699ff',
          },
        },
      ],
    }

    chart.setOption(option)
  }

  if (productChart.value) {
    const chart = echarts.init(productChart.value)

    // Prepare product performance data
    const productData = filteredProducts.value
      .map((product) => {
        const inventory = filteredStationInventory.value.find(
          (i) => i.ProductID === product.ProductID,
        )
        const stock = parseFloat(inventory?.CurrentStock || 0)
        const value = stock * parseFloat(product.UnitPrice || 0)

        return {
          name: product.Name,
          value: value,
        }
      })
      .filter((p) => p.value > 0)

    const option = {
      title: {
        text: 'Inventory Value by Product',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 'bold',
        },
      },
      tooltip: {
        trigger: 'item',
        formatter: function (params) {
          return `${params.name}<br/>Value: ${formatCurrency(params.value)}<br/>Percentage: ${params.percent}%`
        },
      },
      series: [
        {
          type: 'pie',
          radius: ['40%', '70%'],
          data: productData,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)',
            },
          },
        },
      ],
    }

    chart.setOption(option)
  }
}

// Helper Functions
const getProductName = (productId) => {
  const product = products.value.find((p) => p.ProductID === productId)
  return product?.Name || 'Unknown Product'
}

const getSelectedProductPrice = () => {
  if (!adjustmentForm.ProductID) return 0
  const product = filteredProducts.value.find((p) => p.ProductID == adjustmentForm.ProductID)
  return parseFloat(product?.UnitPrice || 0)
}

const hasFrequentRecentAdjustments = () => {
  const recentAdjustments = adjustmentHistory.value.filter(
    (h) =>
      h.ProductID == adjustmentForm.ProductID &&
      new Date(h.ChangeDate) > new Date(Date.now() - 24 * 60 * 60 * 1000),
  )
  return recentAdjustments.length >= 3
}

const calculateNewStock = () => {
  if (!selectedInventoryRecord.value || !adjustmentForm.QuantityChange) return 0
  return (
    parseFloat(selectedInventoryRecord.value.CurrentStock) +
    parseFloat(adjustmentForm.QuantityChange)
  )
}

const calculateProductValue = (inventoryItem) => {
  const product = filteredProducts.value.find((p) => p.ProductID === inventoryItem.ProductID)
  const price = parseFloat(product?.UnitPrice || 0)
  const stock = parseFloat(inventoryItem.CurrentStock || 0)
  return price * stock
}

const calculateAdjustmentValue = () => {
  if (!adjustmentForm.QuantityChange) return 0
  const price = getSelectedProductPrice()
  return parseFloat(adjustmentForm.QuantityChange) * price
}

const calculateNewProductValue = () => {
  if (!selectedInventoryRecord.value || !adjustmentForm.QuantityChange) return 0
  const newStock = calculateNewStock()
  const price = getSelectedProductPrice()
  return newStock * price
}

const onProductChange = () => {
  errors.ProductID = ''
}

const setQuickAdjustment = (changeType, reason) => {
  adjustmentForm.ChangeType = changeType
  adjustmentForm.ReasonForChange = reason
  errors.ChangeType = ''
  errors.ReasonForChange = ''
}

const getStockStatus = (stock) => {
  const stockLevel = parseFloat(stock || 0)
  if (stockLevel > 500) return 'Optimal'
  if (stockLevel > 100) return 'Low'
  return 'Critical'
}

const getStockStatusBadge = (stock) => {
  const stockLevel = parseFloat(stock || 0)
  if (stockLevel > 500) return 'badge-success'
  if (stockLevel > 100) return 'badge-warning'
  return 'badge-danger'
}

const getUserDisplayName = (userId) => {
  if (!userId) return 'Unknown User'

  // Check if it's the current logged-in user
  if (currentUser.value.id && currentUser.value.id == userId) {
    return currentUser.value.name || currentUser.value.email || `User #${userId}`
  }

  // Look up user in the users array
  const user = users.value.find((u) => u.id == userId)
  if (user) {
    return user.name || user.email || user.username || `User #${userId}`
  }

  // Fallback to user ID if not found
  return `User #${userId}`
}

const formatNumber = (value) => {
  return parseFloat(value || 0).toLocaleString('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })
}

const formatDateTime = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

const formatDate = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  })
}

const formatTime = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
  })
}

const formatCurrency = (value) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
  }).format(value || 0)
}

// Component Initialization
onMounted(async () => {
  if (!currentStationId.value) {
    Swal.fire({
      title: 'Station Required',
      text: 'You must be assigned to a station to manage inventory',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  // Load tanks first to enable proper filtering
  await loadStationTanks()

  // Then load other data
  await Promise.all([loadUsers(), loadProducts(), loadStationInventory(), loadAdjustmentHistory()])

  // Initialize charts after data loads
  nextTick(() => {
    initializeCharts()
  })
})
</script>

<style scoped>
/* Premium Card Design */
.card {
  box-shadow: 0 0.5rem 1.5rem 0.5rem rgba(0, 0, 0, 0.075);
  border: 0;
  transition: all 0.3s ease;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.175);
}

.hover-elevate-up:hover {
  transform: translateY(-4px);
  transition: all 0.3s ease;
}

/* Premium Navigation */
.nav-pills-custom .nav-link {
  border-radius: 0.75rem;
  border: none;
  background: transparent;
  color: #7e8299;
  transition: all 0.3s ease;
  margin: 0.25rem;
}

.nav-pills-custom .nav-link.active {
  background: linear-gradient(135deg, #3699ff 0%, #0066cc 100%);
  color: white;
  box-shadow: 0 0.5rem 2rem rgba(54, 153, 255, 0.3);
}

.nav-pills-custom .nav-link:hover:not(.active) {
  color: #3699ff;
  background: rgba(54, 153, 255, 0.1);
  transform: translateY(-1px);
}

.nav-pills-custom .nav-icon {
  display: block;
  margin-bottom: 0.5rem;
}

/* Premium Form Controls */
.form-control:focus,
.form-select:focus {
  border-color: #3699ff;
  box-shadow: 0 0 0 0.25rem rgba(54, 153, 255, 0.25);
}

.form-control-solid {
  background-color: #f8f9fa;
  border-color: #e1e3ea;
}

.form-control-solid:focus {
  background-color: #ffffff;
  border-color: #3699ff;
}

/* Premium Buttons */
.btn-primary {
  background: linear-gradient(135deg, #3699ff 0%, #0066cc 100%);
  border: none;
  border-radius: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  box-shadow: 0 0.5rem 2rem rgba(54, 153, 255, 0.3);
}

.btn-primary:hover:not(:disabled) {
  background: linear-gradient(135deg, #0066cc 0%, #004499 100%);
  transform: translateY(-2px);
  box-shadow: 0 1rem 3rem rgba(54, 153, 255, 0.4);
}

.btn-light-success,
.btn-light-warning,
.btn-light-info,
.btn-light-primary {
  border-radius: 0.75rem;
  border: none;
  transition: all 0.3s ease;
}

.btn-light-success:hover {
  transform: translateY(-2px);
  box-shadow: 0 0.5rem 2rem rgba(80, 205, 137, 0.3);
}

.btn-light-warning:hover {
  transform: translateY(-2px);
  box-shadow: 0 0.5rem 2rem rgba(255, 199, 0, 0.3);
}

.btn-light-info:hover {
  transform: translateY(-2px);
  box-shadow: 0 0.5rem 2rem rgba(55, 188, 255, 0.3);
}

.btn-light-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 0.5rem 2rem rgba(54, 153, 255, 0.3);
}

/* Premium Table */
.table-hover tbody tr:hover {
  background-color: rgba(54, 153, 255, 0.05);
}

.hover-bg-light:hover {
  background-color: #f8f9fa !important;
}

/* Premium Alerts */
.alert {
  border-radius: 0.75rem;
  border: none;
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

/* Premium Badges */
.badge {
  border-radius: 0.5rem;
  font-weight: 500;
  letter-spacing: 0.3px;
}

.badge-circle {
  border-radius: 50%;
  width: 2.5rem;
  height: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.badge-lg {
  padding: 0.5rem 1rem;
  font-size: 0.75rem;
}

/* Premium Progress Bars */
.progress {
  border-radius: 0.5rem;
  overflow: hidden;
}

.progress-bar {
  transition: width 0.6s ease;
}

/* Premium Symbols */
.symbol {
  border-radius: 0.75rem;
}

.symbol-label {
  border-radius: 0.75rem;
}

/* Loading Animation */
.spinner-border-lg {
  width: 3rem;
  height: 3rem;
}

/* Responsive Design */
@media (max-width: 768px) {
  .nav-pills-custom .nav-link {
    padding: 0.75rem 0.5rem;
  }

  .nav-pills-custom .nav-text {
    font-size: 0.75rem;
  }

  .fs-2hx {
    font-size: 1.75rem !important;
  }

  .card-body {
    padding: 1rem;
  }
}

/* Chart Containers */
#financialChart,
#productChart {
  width: 100%;
  height: 400px;
}

/* Separator */
.separator {
  height: 1px;
  background-color: #e1e3ea;
  margin: 0.5rem 0;
}

/* Input Group Enhancements */
.input-group-text {
  background-color: #f8f9fa;
  border-color: #e1e3ea;
  color: #7e8299;
  font-weight: 600;
}

/* Premium Shadows */
.shadow-sm {
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075) !important;
}
</style>

<template>
  <div class="d-flex flex-column gap-5">
    <!-- Dashboard Header -->
    <div class="card card-flush">
      <div class="card-header py-5">
        <h3 class="card-title align-items-start flex-column">
          <span class="card-label fw-bold text-dark">Tank Management</span>
          <span class="text-gray-400 mt-1 fw-semibold fs-6"
            >Monitoring and managing fuel tank inventory</span
          >
        </h3>
        <div class="card-toolbar">
          <button @click="openCreateModal" class="btn btn-primary d-flex align-items-center">
            <i class="ki-duotone ki-plus fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Add Tank
          </button>
        </div>
      </div>
    </div>

    <!-- KPI Stats Cards -->
    <div class="row g-5 g-xl-8">
      <!-- Total Tanks -->
      <div class="col-6 col-lg-3">
        <div class="card bg-light-primary card-xl-stretch mb-xl-8">
          <div class="card-body p-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-50px me-5">
                <span class="symbol-label bg-light-primary">
                  <i class="ki-duotone ki-oil-barrel fs-2x text-primary">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </span>
              </div>
              <div class="d-flex flex-column">
                <span
                  class="fs-2hx fw-bold text-dark"
                  data-kt-countup="true"
                  data-kt-countup-value="14"
                  >{{ totalTanks }}</span
                >
                <span class="text-gray-600 fw-semibold fs-6">Total Tanks</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Total Capacity -->
      <div class="col-6 col-lg-3">
        <div class="card bg-light-success card-xl-stretch mb-xl-8">
          <div class="card-body p-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-50px me-5">
                <span class="symbol-label bg-light-success">
                  <i class="ki-duotone ki-water fs-2x text-success">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </span>
              </div>
              <div class="d-flex flex-column">
                <span class="fs-2hx fw-bold text-dark">{{ formatCapacity(totalCapacity) }}</span>
                <span class="text-gray-600 fw-semibold fs-6">Total Capacity</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Current Stock -->
      <div class="col-6 col-lg-3">
        <div class="card bg-light-info card-xl-stretch mb-xl-8">
          <div class="card-body p-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-50px me-5">
                <span class="symbol-label bg-light-info">
                  <i class="ki-duotone ki-droplet fs-2x text-info">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </span>
              </div>
              <div class="d-flex flex-column">
                <span class="fs-2hx fw-bold text-dark">{{
                  formatCapacity(totalCurrentLevel)
                }}</span>
                <span class="text-gray-600 fw-semibold fs-6">Current Stock</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Utilization Rate -->
      <div class="col-6 col-lg-3">
        <div class="card bg-light-warning card-xl-stretch mb-xl-8">
          <div class="card-body p-5">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-50px me-5">
                <span class="symbol-label bg-light-warning">
                  <i class="ki-duotone ki-percentage fs-2x text-warning">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </span>
              </div>
              <div class="d-flex flex-column">
                <span class="fs-2hx fw-bold text-dark">{{ overallUtilization }}%</span>
                <span class="text-gray-600 fw-semibold fs-6">Utilization Rate</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Analytics Charts Row -->
    <div class="row g-5 g-xl-8">
      <!-- Tank Capacity vs Current Level by Station -->
      <div class="col-xl-8 col-lg-7 col-12">
        <div class="card card-flush h-xl-100">
          <div class="card-header py-7">
            <h3 class="card-title align-items-start flex-column">
              <span class="card-label fw-bold text-dark">Station Tank Overview</span>
              <span class="text-gray-400 mt-1 fw-semibold fs-6"
                >{{ stationsWithTanks }} Stations | {{ activeTanksCount }} Active Tanks</span
              >
            </h3>
            <div class="card-toolbar">
              <select
                v-model="chartGroupBy"
                class="form-select form-select-solid w-150px"
                data-control="select2"
                data-hide-search="true"
                aria-label="Group chart by"
              >
                <option value="station">By Station</option>
                <option value="product">By Product</option>
                <option value="utilization">By Utilization</option>
              </select>
            </div>
          </div>
          <div class="card-body pt-3">
            <div id="tank_levels_chart" style="height: 350px" class="chart-container"></div>
            <div v-if="loading" class="d-flex justify-content-center my-10">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Tank Status & Utilization Categories -->
      <div class="col-xl-4 col-lg-5 col-12">
        <div class="card card-flush h-xl-100">
          <div class="card-header py-7">
            <h3 class="card-title align-items-start flex-column">
              <span class="card-label fw-bold text-dark">Tank Categories</span>
              <span class="text-gray-400 mt-1 fw-semibold fs-6">By Utilization Level</span>
            </h3>
          </div>
          <div class="card-body pt-3">
            <div id="tank_categories_chart" style="height: 200px" class="chart-container"></div>

            <div class="d-flex flex-column mt-8">
              <div class="d-flex align-items-center mb-5">
                <div class="d-flex align-items-center me-2">
                  <span class="bullet bullet-vertical h-40px bg-danger me-3"></span>
                  <div class="flex-grow-1">
                    <a href="#" class="text-gray-800 text-hover-primary fw-bold fs-6"
                      >Critical (&lt;20%)</a
                    >
                    <span class="text-muted d-block fw-semibold">Requires immediate refill</span>
                  </div>
                </div>
                <div class="badge badge-danger fs-6 fw-bold">
                  {{ utilizationCategories.critical }}
                </div>
              </div>

              <div class="d-flex align-items-center mb-5">
                <div class="d-flex align-items-center me-2">
                  <span class="bullet bullet-vertical h-40px bg-warning me-3"></span>
                  <div class="flex-grow-1">
                    <a href="#" class="text-gray-800 text-hover-primary fw-bold fs-6"
                      >Low (20-50%)</a
                    >
                    <span class="text-muted d-block fw-semibold">Schedule refill soon</span>
                  </div>
                </div>
                <div class="badge badge-warning fs-6 fw-bold">{{ utilizationCategories.low }}</div>
              </div>

              <div class="d-flex align-items-center mb-5">
                <div class="d-flex align-items-center me-2">
                  <span class="bullet bullet-vertical h-40px bg-info me-3"></span>
                  <div class="flex-grow-1">
                    <a href="#" class="text-gray-800 text-hover-primary fw-bold fs-6"
                      >Good (50-80%)</a
                    >
                    <span class="text-muted d-block fw-semibold">Adequate supply</span>
                  </div>
                </div>
                <div class="badge badge-info fs-6 fw-bold">{{ utilizationCategories.good }}</div>
              </div>

              <div class="d-flex align-items-center">
                <div class="d-flex align-items-center me-2">
                  <span class="bullet bullet-vertical h-40px bg-success me-3"></span>
                  <div class="flex-grow-1">
                    <a href="#" class="text-gray-800 text-hover-primary fw-bold fs-6"
                      >Full (80%+)</a
                    >
                    <span class="text-muted d-block fw-semibold">Recently filled</span>
                  </div>
                </div>
                <div class="badge badge-success fs-6 fw-bold">{{ utilizationCategories.full }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Secondary Analytics Row -->
    <div class="row g-5 g-xl-8">
      <!-- Product Type Distribution -->
      <div class="col-xl-6 col-12">
        <div class="card card-flush h-xl-100">
          <div class="card-header py-7">
            <h3 class="card-title align-items-start flex-column">
              <span class="card-label fw-bold text-dark">Product Distribution</span>
              <span class="text-gray-400 mt-1 fw-semibold fs-6"
                >{{ uniqueProductsCount }} Fuel Types</span
              >
            </h3>
          </div>
          <div class="card-body pt-3">
            <div
              id="product_distribution_chart"
              style="height: 300px"
              class="chart-container"
            ></div>
          </div>
        </div>
      </div>

      <!-- Tank Utilization Heatmap -->
      <div class="col-xl-6 col-12">
        <div class="card card-flush h-xl-100">
          <div class="card-header py-7">
            <h3 class="card-title align-items-start flex-column">
              <span class="card-label fw-bold text-dark">Tank Utilization Map</span>
              <span class="text-gray-400 mt-1 fw-semibold fs-6">Real-time Capacity Status</span>
            </h3>
          </div>
          <div class="card-body pt-3">
            <div id="utilization_heatmap_chart" style="height: 300px" class="chart-container"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Filters & Actions -->
    <div class="card card-flush">
      <div class="card-header align-items-center pt-8 pb-0">
        <h3 class="card-title align-items-start flex-column">
          <span class="card-label fw-bold text-dark">Tank Inventory</span>
          <span class="text-gray-400 mt-1 fw-semibold fs-6">Manage and monitor your tanks</span>
        </h3>
      </div>

      <!-- Filter Toolbar -->
      <div class="card-header align-items-center py-5 gap-2 gap-md-5 border-0">
        <div class="card-title">
          <div class="d-flex align-items-center position-relative my-1">
            <i class="ki-duotone ki-magnifier fs-3 position-absolute ms-4">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <input
              v-model="searchQuery"
              type="text"
              class="form-control form-control-solid w-250px ps-12"
              placeholder="Search tanks..."
              aria-label="Search tanks"
            />
          </div>
        </div>
        <div class="card-toolbar flex-row-fluid justify-content-end gap-3">
          <select
            v-model="selectedStation"
            class="form-select form-select-solid w-150px"
            data-control="select2"
            data-hide-search="true"
            aria-label="Filter by station"
          >
            <option value="">All Stations</option>
            <option
              v-for="station in stationsWithTanksList"
              :key="station.StationID"
              :value="station.StationID"
            >
              {{ station.StationName }}
            </option>
          </select>
          <select
            v-model="selectedStatus"
            class="form-select form-select-solid w-125px"
            data-control="select2"
            data-hide-search="true"
            aria-label="Filter by status"
          >
            <option value="">All Status</option>
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
            <option value="Maintenance">Maintenance</option>
          </select>
          <button @click="openCreateModal" class="btn btn-primary">
            <i class="ki-duotone ki-plus fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Add Tank
          </button>
        </div>
      </div>

      <!-- Tanks Grid -->
      <div class="card-body pt-0">
        <div class="row g-5">
          <div v-if="loading && !tanks.length" class="col-12">
            <div class="d-flex justify-content-center my-10">
              <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
              </div>
            </div>
          </div>
          <div v-if="!loading && !paginatedTanks.length" class="col-12">
            <div class="text-center my-10">
              <i class="ki-duotone ki-oil-barrel fs-5tx text-gray-300 mb-5">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="fw-semibold fs-3 text-gray-600">No tanks found</div>
              <div class="text-gray-500 mt-3">Try adjusting your search or filters</div>
              <button @click="openCreateModal" class="btn btn-primary mt-5">
                <i class="ki-duotone ki-plus fs-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Add Your First Tank
              </button>
            </div>
          </div>
          <div v-for="tank in paginatedTanks" :key="tank.TankID" class="col-12 col-md-6 col-xl-4">
            <div
              :class="[
                'card h-100',
                tank.Status === 'Active'
                  ? 'card-bordered border-success'
                  : tank.Status === 'Maintenance'
                    ? 'card-bordered border-warning'
                    : 'card-bordered',
              ]"
            >
              <div class="card-header ribbon ribbon-end">
                <div :class="['ribbon-label', getStatusRibbonClass(tank.Status)]">
                  {{ tank.Status }}
                </div>
                <h3 class="card-title">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-40px me-3">
                      <span :class="['symbol-label', getProductBgClass(tank.ProductID)]">
                        <i class="ki-duotone ki-oil-barrel fs-1 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </span>
                    </div>
                    <div class="d-flex flex-column">
                      <span class="fs-4 fw-bold text-dark text-hover-primary">{{
                        tank.TankName
                      }}</span>
                      <span class="text-muted fw-semibold">{{
                        getStationName(tank.StationID)
                      }}</span>
                    </div>
                  </div>
                </h3>
              </div>
              <div class="card-body py-5">
                <div class="d-flex flex-column gap-5">
                  <!-- Product Info -->
                  <div class="d-flex align-items-center">
                    <div class="d-flex flex-column flex-grow-1">
                      <span class="text-muted fw-semibold">Product</span>
                      <div class="d-flex align-items-center">
                        <span
                          :class="['bullet bullet-dot me-2', getProductBulletClass(tank.ProductID)]"
                        ></span>
                        <span class="fw-bold fs-6 text-gray-800">{{
                          getProductName(tank.ProductID)
                        }}</span>
                      </div>
                    </div>
                    <div class="d-flex flex-column min-w-125px">
                      <span class="text-muted fw-semibold text-end">Capacity</span>
                      <span class="fw-bold fs-6 text-gray-800 text-end"
                        >{{ formatNumber(tank.Capacity) }}L</span
                      >
                    </div>
                  </div>

                  <!-- Level Gauge -->
                  <div>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                      <span class="text-muted fs-7 fw-semibold"
                        >Current Level: {{ formatNumber(tank.CurrentLevel) }}L</span
                      >
                      <span class="fw-bold fs-6" :class="getUtilizationTextClass(tank)"
                        >{{ getCapacityPercentage(tank) }}%</span
                      >
                    </div>
                    <div class="h-8px mx-3 w-100 bg-light rounded">
                      <div
                        :class="['h-8px rounded', getUtilizationClass(tank)]"
                        :style="{ width: getCapacityPercentage(tank) + '%' }"
                        role="progressbar"
                        :aria-valuenow="getCapacityPercentage(tank)"
                        aria-valuemin="0"
                        aria-valuemax="100"
                      ></div>
                    </div>
                  </div>

                  <!-- Last Filled Date -->
                  <div class="d-flex justify-content-between">
                    <div class="d-flex flex-column">
                      <span class="text-muted fw-semibold">Last Filled</span>
                      <span class="fw-bold fs-6 text-gray-800">{{
                        formatDate(tank.LastFilledDate)
                      }}</span>
                    </div>
                    <div class="d-flex flex-column">
                      <span class="text-muted fw-semibold text-end">Created</span>
                      <span class="fw-bold fs-6 text-gray-800 text-end">{{
                        formatDate(tank.CreatedAt)
                      }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card-footer d-flex justify-content-end">
                <button
                  @click="editTank(tank)"
                  class="btn btn-light btn-active-light-primary btn-sm me-2"
                >
                  <i class="ki-duotone ki-pencil fs-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Edit
                </button>
                <button
                  @click="deleteTank(tank)"
                  class="btn btn-light btn-active-light-danger btn-sm"
                >
                  <i class="ki-duotone ki-trash fs-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                  </i>
                  Delete
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Pagination -->
        <div v-if="paginatedTanks.length" class="d-flex flex-stack flex-wrap pt-10">
          <div class="fs-6 fw-semibold text-gray-700">
            Showing {{ startIndex + 1 }} to {{ Math.min(endIndex, filteredTanks.length) }} of
            {{ filteredTanks.length }} tanks
          </div>
          <ul class="pagination">
            <li :class="['page-item', currentPage === 1 ? 'disabled' : '']">
              <a @click.prevent="previousPage" class="page-link" href="#" aria-label="Previous">
                <i class="ki-duotone ki-left fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </a>
            </li>
            <li
              v-for="page in visiblePageNumbers"
              :key="page"
              :class="['page-item', page === currentPage ? 'active' : '']"
            >
              <a @click.prevent="goToPage(page)" class="page-link" href="#">
                {{ page }}
              </a>
            </li>
            <li :class="['page-item', currentPage === totalPages ? 'disabled' : '']">
              <a @click.prevent="nextPage" class="page-link" href="#" aria-label="Next">
                <i class="ki-duotone ki-right fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <!-- Tank Modal -->
    <div class="modal fade" id="tankModal" tabindex="-1" aria-hidden="true" ref="tankModalRef">
      <div class="modal-dialog modal-dialog-centered mw-650px">
        <div class="modal-content">
          <div class="modal-header pb-0 border-0 justify-content-end">
            <div class="btn btn-sm btn-icon btn-active-color-primary" data-bs-dismiss="modal">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
          </div>
          <div class="modal-body scroll-y mx-5 mx-xl-18 pt-0 pb-15">
            <div class="text-center mb-13">
              <h1 class="mb-3">{{ isEditing ? 'Edit Tank' : 'Add New Tank' }}</h1>
              <div class="text-muted fw-semibold fs-5">
                {{
                  isEditing
                    ? 'Modify tank details and inventory levels'
                    : 'Enter tank details to add to your inventory'
                }}
              </div>
            </div>

            <form @submit.prevent="saveTank" class="form" novalidate>
              <div class="d-flex flex-column mb-8">
                <label class="d-flex align-items-center fs-6 fw-semibold mb-2">
                  <span class="required">Tank Name</span>
                  <i
                    class="fas fa-exclamation-circle ms-2 fs-7"
                    data-bs-toggle="tooltip"
                    title="Specify a unique tank name"
                  ></i>
                </label>
                <input
                  v-model="form.TankName"
                  type="text"
                  class="form-control form-control-solid"
                  :class="{ 'is-invalid': formErrors.TankName }"
                  placeholder="Enter tank name"
                  name="tank-name"
                />
                <div v-if="formErrors.TankName" class="invalid-feedback d-block">
                  {{ formErrors.TankName }}
                </div>
              </div>

              <div class="row g-8 mb-8">
                <div class="col-md-6">
                  <label class="d-flex align-items-center fs-6 fw-semibold mb-2">
                    <span class="required">Station</span>
                  </label>
                  <select
                    v-model="form.StationID"
                    class="form-select form-select-solid"
                    :class="{ 'is-invalid': formErrors.StationID }"
                    name="station"
                  >
                    <option value="">Select Station</option>
                    <option
                      v-for="station in stations"
                      :key="station.StationID"
                      :value="station.StationID"
                    >
                      {{ station.StationName }}
                    </option>
                  </select>
                  <div v-if="formErrors.StationID" class="invalid-feedback d-block">
                    {{ formErrors.StationID }}
                  </div>
                </div>

                <div class="col-md-6">
                  <label class="d-flex align-items-center fs-6 fw-semibold mb-2">
                    <span class="required">Product</span>
                  </label>
                  <select
                    v-model="form.ProductID"
                    class="form-select form-select-solid"
                    :class="{ 'is-invalid': formErrors.ProductID }"
                    name="product"
                  >
                    <option value="">Select Product</option>
                    <option
                      v-for="product in fuelProducts"
                      :key="product.ProductID"
                      :value="product.ProductID"
                    >
                      {{ product.Name }}
                    </option>
                  </select>
                  <div v-if="formErrors.ProductID" class="invalid-feedback d-block">
                    {{ formErrors.ProductID }}
                  </div>
                </div>
              </div>

              <div class="row g-8 mb-8">
                <div class="col-md-6">
                  <label class="d-flex align-items-center fs-6 fw-semibold mb-2">
                    <span class="required">Capacity (L)</span>
                  </label>
                  <input
                    v-model.number="form.Capacity"
                    type="number"
                    class="form-control form-control-solid"
                    :class="{ 'is-invalid': formErrors.Capacity }"
                    placeholder="Enter capacity in liters"
                    name="capacity"
                    min="0"
                  />
                  <div v-if="formErrors.Capacity" class="invalid-feedback d-block">
                    {{ formErrors.Capacity }}
                  </div>
                </div>

                <div class="col-md-6">
                  <label class="d-flex align-items-center fs-6 fw-semibold mb-2">
                    <span class="required">Current Level (L)</span>
                  </label>
                  <input
                    v-model.number="form.CurrentLevel"
                    type="number"
                    class="form-control form-control-solid"
                    :class="{ 'is-invalid': formErrors.CurrentLevel }"
                    placeholder="Enter current level in liters"
                    name="current-level"
                    min="0"
                  />
                  <div v-if="formErrors.CurrentLevel" class="invalid-feedback d-block">
                    {{ formErrors.CurrentLevel }}
                  </div>
                </div>
              </div>

              <div class="d-flex flex-column mb-8">
                <label class="d-flex align-items-center fs-6 fw-semibold mb-2">
                  <span class="required">Status</span>
                </label>
                <select
                  v-model="form.Status"
                  class="form-select form-select-solid"
                  :class="{ 'is-invalid': formErrors.Status }"
                  name="status"
                >
                  <option value="Active">Active</option>
                  <option value="Inactive">Inactive</option>
                  <option value="Maintenance">Maintenance</option>
                </select>
                <div v-if="formErrors.Status" class="invalid-feedback d-block">
                  {{ formErrors.Status }}
                </div>
              </div>

              <div class="d-flex flex-center flex-row-fluid pt-5">
                <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">
                  Cancel
                </button>
                <button type="submit" class="btn btn-primary" :disabled="formSubmitting">
                  <span v-if="!formSubmitting" class="indicator-label">
                    {{ isEditing ? 'Update Tank' : 'Save Tank' }}
                  </span>
                  <span v-if="formSubmitting" class="indicator-progress">
                    Please wait...
                    <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
                  </span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick, watch, onUnmounted } from 'vue'
import Swal from 'sweetalert2'
import axios from 'axios'

// State
const tanks = ref([])
const stations = ref([])
const products = ref([])
const loading = ref(false)
const formSubmitting = ref(false)
const searchQuery = ref('')
const selectedStation = ref('')
const selectedStatus = ref('')
const chartGroupBy = ref('station')
const currentPage = ref(1)
const pageSize = ref(9)
const isEditing = ref(false)
const tankModalRef = ref(null)
const tankModal = ref(null)
const formErrors = ref({})

// Chart instances
const chartInstances = ref({})

// Form state
const initialFormState = {
  TankName: '',
  StationID: '',
  ProductID: '',
  Capacity: '',
  CurrentLevel: '',
  Status: 'Active',
  LastFilledDate: new Date().toISOString().split('T')[0],
}

const form = ref({ ...initialFormState })

// API client
const api = axios.create({
  baseURL: 'http://localhost:4000/api/records/v1',
  headers: {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${localStorage.getItem('jwt')}`,
  },
  timeout: 10000,
})

// Add response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('API Error:', error)
    const errorMessage =
      error.response?.data?.message || error.message || 'An unexpected error occurred'

    Swal.fire({
      title: 'Error!',
      text: errorMessage,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })

    return Promise.reject(error)
  },
)

// Computed properties
const filteredTanks = computed(() => {
  let filtered = tanks.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(
      (tank) =>
        tank.TankName.toLowerCase().includes(query) ||
        getStationName(tank.StationID).toLowerCase().includes(query) ||
        getProductName(tank.ProductID).toLowerCase().includes(query),
    )
  }

  if (selectedStation.value) {
    filtered = filtered.filter((tank) => tank.StationID == selectedStation.value)
  }

  if (selectedStatus.value) {
    filtered = filtered.filter((tank) => tank.Status === selectedStatus.value)
  }

  return filtered
})

const totalPages = computed(() => Math.ceil(filteredTanks.value.length / pageSize.value))
const startIndex = computed(() => (currentPage.value - 1) * pageSize.value)
const endIndex = computed(() => startIndex.value + pageSize.value)
const paginatedTanks = computed(() => filteredTanks.value.slice(startIndex.value, endIndex.value))

// Pagination control
const visiblePageNumbers = computed(() => {
  const pages = []
  const maxVisiblePages = 5

  if (totalPages.value <= maxVisiblePages) {
    // Show all pages if there are 5 or fewer
    for (let i = 1; i <= totalPages.value; i++) {
      pages.push(i)
    }
  } else {
    // Logic for showing a subset of pages with current page in the middle
    let startPage = Math.max(1, currentPage.value - Math.floor(maxVisiblePages / 2))
    let endPage = Math.min(totalPages.value, startPage + maxVisiblePages - 1)

    // Adjust if we're near the end
    if (endPage - startPage + 1 < maxVisiblePages) {
      startPage = Math.max(1, endPage - maxVisiblePages + 1)
    }

    for (let i = startPage; i <= endPage; i++) {
      pages.push(i)
    }
  }

  return pages
})

// Stats computed properties
const totalTanks = computed(() => tanks.value.length)

const totalCapacity = computed(() =>
  tanks.value.reduce((sum, tank) => sum + (parseInt(tank.Capacity) || 0), 0),
)

const totalCurrentLevel = computed(() =>
  tanks.value.reduce((sum, tank) => sum + (parseInt(tank.CurrentLevel) || 0), 0),
)

const overallUtilization = computed(() =>
  totalCapacity.value ? Math.round((totalCurrentLevel.value / totalCapacity.value) * 100) : 0,
)

const activeTanksCount = computed(
  () => tanks.value.filter((tank) => tank.Status === 'Active').length,
)

// Station analytics
const stationsWithTanks = computed(() => {
  const stationIds = new Set(tanks.value.map((tank) => tank.StationID))
  return stationIds.size
})

const stationsWithTanksList = computed(() => {
  const stationIds = new Set(tanks.value.map((tank) => tank.StationID))
  return stations.value.filter((station) => stationIds.has(station.StationID))
})

// Product analytics
const uniqueProductsCount = computed(() => {
  const productIds = new Set(tanks.value.map((tank) => tank.ProductID))
  return productIds.size
})

const fuelProducts = computed(() => products.value.filter((p) => p.ProductType === 'Fuel'))

// Utilization categories
const utilizationCategories = computed(() => {
  const categories = { critical: 0, low: 0, good: 0, full: 0 }

  tanks.value.forEach((tank) => {
    const utilization = getCapacityPercentage(tank)
    if (utilization < 20) categories.critical++
    else if (utilization < 50) categories.low++
    else if (utilization < 80) categories.good++
    else categories.full++
  })

  return categories
})

// Helper functions
const formatNumber = (number) => new Intl.NumberFormat().format(number || 0)

const formatCapacity = (liters) => {
  if (liters >= 1000000) return `${(liters / 1000000).toFixed(1)}M`
  if (liters >= 1000) return `${(liters / 1000).toFixed(1)}K`
  return formatNumber(liters)
}

const formatDate = (dateString) => {
  if (!dateString) return 'N/A'

  try {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    })
  } catch (e) {
    return 'Invalid date'
  }
}

const getStationName = (stationId) =>
  stations.value.find((s) => s.StationID == stationId)?.StationName || 'Unknown'

const getProductName = (productId) =>
  products.value.find((p) => p.ProductID == productId)?.Name || 'Unknown'

const getCapacityPercentage = (tank) =>
  tank.Capacity ? Math.round((tank.CurrentLevel / tank.Capacity) * 100) : 0

const getStatusRibbonClass = (status) => {
  switch (status) {
    case 'Active':
      return 'ribbon-success'
    case 'Inactive':
      return 'ribbon-danger'
    case 'Maintenance':
      return 'ribbon-warning'
    default:
      return 'ribbon-primary'
  }
}

const getUtilizationClass = (tank) => {
  const pct = getCapacityPercentage(tank)
  if (pct < 20) return 'bg-danger'
  if (pct < 50) return 'bg-warning'
  if (pct < 80) return 'bg-info'
  return 'bg-success'
}

const getUtilizationTextClass = (tank) => {
  const pct = getCapacityPercentage(tank)
  if (pct < 20) return 'text-danger'
  if (pct < 50) return 'text-warning'
  if (pct < 80) return 'text-info'
  return 'text-success'
}

// Product-specific styling functions
const getProductBgClass = (productId) => {
  const product = products.value.find((p) => p.ProductID == productId)
  if (!product) return 'bg-primary'

  // Assign colors based on product type or name
  const productName = product.Name.toLowerCase()
  if (productName.includes('petrol') || productName.includes('premium')) return 'bg-danger'
  if (productName.includes('diesel')) return 'bg-success'
  if (productName.includes('kerosene')) return 'bg-info'
  if (productName.includes('lpg') || productName.includes('gas')) return 'bg-warning'
  return 'bg-primary'
}

const getProductBulletClass = (productId) => {
  const product = products.value.find((p) => p.ProductID == productId)
  if (!product) return 'bg-primary'

  const productName = product.Name.toLowerCase()
  if (productName.includes('petrol') || productName.includes('premium')) return 'bg-danger'
  if (productName.includes('diesel')) return 'bg-success'
  if (productName.includes('kerosene')) return 'bg-info'
  if (productName.includes('lpg') || productName.includes('gas')) return 'bg-warning'
  return 'bg-primary'
}

// Chart rendering
const renderCharts = async () => {
  await nextTick() // Ensure DOM is updated

  // Small delay to ensure ApexCharts can find elements
  setTimeout(() => {
    renderTankLevelsChart()
    renderCategoriesChart()
    renderProductDistributionChart()
    renderUtilizationHeatmap()
  }, 100)
}

const destroyChart = (elementId) => {
  if (chartInstances.value[elementId]) {
    chartInstances.value[elementId].destroy()
    delete chartInstances.value[elementId]
  }
}

const destroyAllCharts = () => {
  Object.keys(chartInstances.value).forEach((chartId) => {
    if (chartInstances.value[chartId]) {
      chartInstances.value[chartId].destroy()
      delete chartInstances.value[chartId]
    }
  })
}

const renderTankLevelsChart = () => {
  const elementId = 'tank_levels_chart'
  const element = document.getElementById(elementId)
  if (!element) return

  destroyChart(elementId)

  // Prepare chart data based on grouping
  let chartData = []
  let categories = []

  if (chartGroupBy.value === 'station') {
    const stationGroups = {}

    tanks.value.forEach((tank) => {
      const stationName = getStationName(tank.StationID)
      if (!stationGroups[stationName]) {
        stationGroups[stationName] = { capacity: 0, current: 0 }
      }
      stationGroups[stationName].capacity += parseInt(tank.Capacity) || 0
      stationGroups[stationName].current += parseInt(tank.CurrentLevel) || 0
    })

    categories = Object.keys(stationGroups)
    chartData = [
      {
        name: 'Total Capacity',
        data: categories.map((station) => Math.round(stationGroups[station].capacity / 1000)),
      },
      {
        name: 'Current Level',
        data: categories.map((station) => Math.round(stationGroups[station].current / 1000)),
      },
    ]
  } else if (chartGroupBy.value === 'product') {
    const productGroups = {}

    tanks.value.forEach((tank) => {
      const productName = getProductName(tank.ProductID)
      if (!productGroups[productName]) {
        productGroups[productName] = { capacity: 0, current: 0 }
      }
      productGroups[productName].capacity += parseInt(tank.Capacity) || 0
      productGroups[productName].current += parseInt(tank.CurrentLevel) || 0
    })

    categories = Object.keys(productGroups)
    chartData = [
      {
        name: 'Total Capacity',
        data: categories.map((product) => Math.round(productGroups[product].capacity / 1000)),
      },
      {
        name: 'Current Level',
        data: categories.map((product) => Math.round(productGroups[product].current / 1000)),
      },
    ]
  } else {
    // Group by utilization level
    const utilizationRanges = {
      'Critical (0-20%)': { capacity: 0, current: 0 },
      'Low (20-50%)': { capacity: 0, current: 0 },
      'Good (50-80%)': { capacity: 0, current: 0 },
      'Full (80%+)': { capacity: 0, current: 0 },
    }

    tanks.value.forEach((tank) => {
      const utilization = getCapacityPercentage(tank)
      const capacity = parseInt(tank.Capacity) || 0
      const current = parseInt(tank.CurrentLevel) || 0

      if (utilization < 20) {
        utilizationRanges['Critical (0-20%)'].capacity += capacity
        utilizationRanges['Critical (0-20%)'].current += current
      } else if (utilization < 50) {
        utilizationRanges['Low (20-50%)'].capacity += capacity
        utilizationRanges['Low (20-50%)'].current += current
      } else if (utilization < 80) {
        utilizationRanges['Good (50-80%)'].capacity += capacity
        utilizationRanges['Good (50-80%)'].current += current
      } else {
        utilizationRanges['Full (80%+)'].capacity += capacity
        utilizationRanges['Full (80%+)'].current += current
      }
    })

    // Filter out empty categories
    categories = Object.keys(utilizationRanges).filter(
      (range) => utilizationRanges[range].capacity > 0,
    )

    chartData = [
      {
        name: 'Total Capacity',
        data: categories.map((range) => Math.round(utilizationRanges[range].capacity / 1000)),
      },
      {
        name: 'Current Level',
        data: categories.map((range) => Math.round(utilizationRanges[range].current / 1000)),
      },
    ]
  }

  // Configure and render chart
  const options = {
    series: chartData,
    chart: {
      type: 'bar',
      height: 350,
      stacked: false,
      toolbar: {
        show: true,
        tools: {
          download: true,
          selection: false,
          zoom: false,
          zoomin: false,
          zoomout: false,
          pan: false,
          reset: false,
        },
      },
      fontFamily: 'inherit',
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: '60%',
        borderRadius: 5,
      },
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      show: true,
      width: 2,
      colors: ['transparent'],
    },
    xaxis: {
      categories: categories,
      axisBorder: {
        show: false,
      },
      axisTicks: {
        show: false,
      },
      labels: {
        style: {
          colors: '#a1a5b7',
          fontSize: '12px',
        },
        rotate: -45,
        rotateAlways: false,
      },
    },
    yaxis: {
      title: {
        text: 'Volume (K Liters)',
        style: {
          color: '#a1a5b7',
          fontSize: '12px',
        },
      },
      labels: {
        style: {
          colors: '#a1a5b7',
          fontSize: '12px',
        },
      },
    },
    fill: {
      opacity: 1,
    },
    states: {
      normal: {
        filter: {
          type: 'none',
        },
      },
      hover: {
        filter: {
          type: 'none',
        },
      },
      active: {
        allowMultipleDataPointsSelection: false,
        filter: {
          type: 'none',
        },
      },
    },
    tooltip: {
      style: {
        fontSize: '12px',
      },
      y: {
        formatter: function (val) {
          return val + ' K Liters'
        },
      },
    },
    colors: ['#E4E6EF', '#009EF7'],
    grid: {
      borderColor: '#EBEDF3',
      strokeDashArray: 4,
      yaxis: {
        lines: {
          show: true,
        },
      },
    },
    legend: {
      position: 'top',
      horizontalAlign: 'right',
      offsetY: -30,
      fontSize: '13px',
      fontWeight: 500,
      markers: {
        width: 10,
        height: 10,
        radius: 100,
      },
      itemMargin: {
        horizontal: 10,
      },
    },
    responsive: [
      {
        breakpoint: 1024,
        options: {
          chart: {
            height: 300,
          },
          plotOptions: {
            bar: {
              columnWidth: '65%',
            },
          },
          legend: {
            position: 'bottom',
            horizontalAlign: 'center',
            offsetY: 0,
          },
        },
      },
      {
        breakpoint: 480,
        options: {
          chart: {
            height: 250,
          },
          plotOptions: {
            bar: {
              columnWidth: '75%',
            },
          },
          legend: {
            position: 'bottom',
            horizontalAlign: 'center',
            offsetY: 0,
          },
          xaxis: {
            labels: {
              rotate: -90,
            },
          },
        },
      },
    ],
  }

  try {
    chartInstances.value[elementId] = new ApexCharts(element, options)
    chartInstances.value[elementId].render()
  } catch (e) {
    console.error(`Error rendering chart ${elementId}:`, e)
    destroyChart(elementId) // Clean up on render error
  }
}

const renderCategoriesChart = () => {
  const elementId = 'tank_categories_chart'
  const element = document.getElementById(elementId)
  if (!element) return

  destroyChart(elementId)

  const categories = utilizationCategories.value
  const data = [categories.critical, categories.low, categories.good, categories.full]
  const labels = ['Critical', 'Low', 'Good', 'Full']

  // Calculate percentages for better visualization
  const total = data.reduce((sum, val) => sum + val, 0) || 1 // Avoid division by zero
  const percentages = data.map((val) => Math.round((val / total) * 100))

  const options = {
    series: percentages,
    chart: {
      width: '100%',
      type: 'donut',
      fontFamily: 'inherit',
    },
    labels: labels,
    colors: ['#F1416C', '#FFC700', '#7239EA', '#50CD89'],
    stroke: {
      width: 0,
    },
    plotOptions: {
      pie: {
        donut: {
          size: '65%',
          background: 'transparent',
          labels: {
            show: true,
            name: {
              show: true,
              fontSize: '12px',
              fontWeight: 600,
              offsetY: -10,
            },
            value: {
              show: true,
              fontSize: '22px',
              fontWeight: 700,
              offsetY: 5,
              formatter: function (val) {
                return val + '%'
              },
            },
            total: {
              show: true,
              label: 'Total',
              color: '#9CA3AF',
              fontSize: '13px',
              fontWeight: 700,
              formatter: function () {
                return totalTanks.value
              },
            },
          },
        },
      },
    },
    dataLabels: {
      enabled: false,
    },
    responsive: [
      {
        breakpoint: 480,
        options: {
          chart: {
            height: 180,
          },
        },
      },
    ],
    legend: {
      show: false,
    },
  }

  try {
    chartInstances.value[elementId] = new ApexCharts(element, options)
    chartInstances.value[elementId].render()
  } catch (e) {
    console.error(`Error rendering chart ${elementId}:`, e)
    destroyChart(elementId)
  }
}

const renderProductDistributionChart = () => {
  const elementId = 'product_distribution_chart'
  const element = document.getElementById(elementId)
  if (!element) return

  destroyChart(elementId)

  const productCounts = {}
  tanks.value.forEach((tank) => {
    const productName = getProductName(tank.ProductID)
    productCounts[productName] = (productCounts[productName] || 0) + 1
  })

  const labels = Object.keys(productCounts)
  const data = Object.values(productCounts)

  const options = {
    series: data,
    chart: {
      width: '100%',
      type: 'pie',
      fontFamily: 'inherit',
    },
    labels: labels,
    colors: ['#009EF7', '#50CD89', '#FFC700', '#F1416C', '#7239EA', '#3F4254'],
    stroke: {
      width: 3,
      colors: ['#FFFFFF'],
    },
    fill: {
      opacity: 1,
    },
    states: {
      normal: {
        filter: {
          type: 'none',
        },
      },
      hover: {
        filter: {
          type: 'none',
        },
      },
      active: {
        filter: {
          type: 'none',
        },
      },
    },
    tooltip: {
      style: {
        fontSize: '12px',
      },
      y: {
        formatter: function (val) {
          return val + ' tanks'
        },
      },
    },
    legend: {
      position: 'bottom',
      fontSize: '13px',
      fontWeight: 500,
      offsetY: 10,
      markers: {
        width: 10,
        height: 10,
        radius: 100,
      },
      itemMargin: {
        horizontal: 10,
        vertical: 5,
      },
    },
    responsive: [
      {
        breakpoint: 480,
        options: {
          chart: {
            height: 250,
          },
          legend: {
            fontSize: '11px',
            itemMargin: {
              horizontal: 5,
              vertical: 3,
            },
          },
        },
      },
    ],
  }

  try {
    chartInstances.value[elementId] = new ApexCharts(element, options)
    chartInstances.value[elementId].render()
  } catch (e) {
    console.error(`Error rendering chart ${elementId}:`, e)
    destroyChart(elementId)
  }
}

const renderUtilizationHeatmap = () => {
  const elementId = 'utilization_heatmap_chart'
  const element = document.getElementById(elementId)
  if (!element) return

  destroyChart(elementId)

  // Create heatmap data
  const heatmapData = []
  const stationGroups = {}

  // Group tanks by station (limit to top 5 stations for mobile view)
  tanks.value.forEach((tank) => {
    const stationName = getStationName(tank.StationID)
    if (!stationGroups[stationName]) stationGroups[stationName] = []
    stationGroups[stationName].push(tank)
  })

  // Take only top 5 stations with most tanks
  let topStations = Object.entries(stationGroups)
    .sort((a, b) => b[1].length - a[1].length)
    .slice(0, 5)
    .map((entry) => entry[0])

  // Create heatmap series (one per station)
  topStations.forEach((stationName) => {
    const stationData = stationGroups[stationName]
      .slice(0, 5) // Limit to 5 tanks per station for better visualization
      .map((tank) => ({
        x: tank.TankName,
        y: getCapacityPercentage(tank),
      }))

    heatmapData.push({
      name: stationName,
      data: stationData,
    })
  })

  const options = {
    series: heatmapData,
    chart: {
      height: 300,
      type: 'heatmap',
      fontFamily: 'inherit',
      toolbar: {
        show: false,
      },
    },
    dataLabels: {
      enabled: true,
      style: {
        fontSize: '12px',
        fontWeight: 500,
      },
      formatter: function (val) {
        return val + '%'
      },
    },
    colors: ['#009EF7'],
    plotOptions: {
      heatmap: {
        colorScale: {
          ranges: [
            {
              from: 0,
              to: 20,
              color: '#F1416C',
              name: 'Critical',
            },
            {
              from: 21,
              to: 50,
              color: '#FFC700',
              name: 'Low',
            },
            {
              from: 51,
              to: 80,
              color: '#7239EA',
              name: 'Good',
            },
            {
              from: 81,
              to: 100,
              color: '#50CD89',
              name: 'Full',
            },
          ],
        },
      },
    },
    xaxis: {
      labels: {
        style: {
          colors: '#a1a5b7',
          fontSize: '12px',
        },
        rotate: -45,
        rotateAlways: false,
        maxHeight: 60,
      },
    },
    yaxis: {
      labels: {
        style: {
          colors: '#a1a5b7',
          fontSize: '12px',
        },
      },
    },
    grid: {
      padding: {
        left: 10,
        right: 10,
      },
      borderColor: '#EBEDF3',
      strokeDashArray: 4,
    },
    stroke: {
      width: 1,
      colors: ['#FFFFFF'],
    },
    tooltip: {
      y: {
        formatter: function (val) {
          return val + '% filled'
        },
      },
    },
    responsive: [
      {
        breakpoint: 480,
        options: {
          chart: {
            height: 250,
          },
          dataLabels: {
            enabled: false,
          },
        },
      },
    ],
  }

  try {
    chartInstances.value[elementId] = new ApexCharts(element, options)
    chartInstances.value[elementId].render()
  } catch (e) {
    console.error(`Error rendering chart ${elementId}:`, e)
    destroyChart(elementId)
  }
}

// CRUD Operations
const fetchData = async () => {
  loading.value = true

  try {
    const [tanksRes, stationsRes, productsRes] = await Promise.all([
      api.get('/Tanks'),
      api.get('/Stations'),
      api.get('/Products'),
    ])

    tanks.value = tanksRes.data.records || []
    stations.value = stationsRes.data.records || []
    products.value = productsRes.data.records || []

    await renderCharts()
  } catch (error) {
    // Error handling done by axios interceptor
  } finally {
    loading.value = false
  }
}

// Modal Management
const openCreateModal = () => {
  isEditing.value = false
  formErrors.value = {}
  form.value = { ...initialFormState }

  // Show modal
  if (!tankModal.value) {
    tankModal.value = new bootstrap.Modal(tankModalRef.value)
  }
  tankModal.value.show()
}

const editTank = (tank) => {
  isEditing.value = true
  formErrors.value = {}
  form.value = { ...tank }

  // Show modal
  if (!tankModal.value) {
    tankModal.value = new bootstrap.Modal(tankModalRef.value)
  }
  tankModal.value.show()
}

// Form validation
const validateForm = () => {
  const errors = {}

  if (!form.value.TankName?.trim()) {
    errors.TankName = 'Tank name is required'
  }

  if (!form.value.StationID) {
    errors.StationID = 'Please select a station'
  }

  if (!form.value.ProductID) {
    errors.ProductID = 'Please select a product'
  }

  if (!form.value.Capacity || form.value.Capacity <= 0) {
    errors.Capacity = 'Capacity must be greater than zero'
  }

  if (
    form.value.CurrentLevel === undefined ||
    form.value.CurrentLevel === null ||
    form.value.CurrentLevel < 0
  ) {
    errors.CurrentLevel = 'Current level must be zero or greater'
  }

  if (form.value.CurrentLevel > form.value.Capacity) {
    errors.CurrentLevel = 'Current level cannot exceed capacity'
  }

  if (!form.value.Status) {
    errors.Status = 'Please select a status'
  }

  formErrors.value = errors
  return Object.keys(errors).length === 0
}

// Save tank (create or update)
const saveTank = async () => {
  if (!validateForm()) {
    return
  }

  formSubmitting.value = true

  try {
    if (isEditing.value) {
      await api.put(`/Tanks/${form.value.TankID}`, form.value)
    } else {
      await api.post('/Tanks', form.value)
    }

    await fetchData()

    if (tankModal.value) {
      tankModal.value.hide()
    }

    Swal.fire({
      title: isEditing.value ? 'Tank Updated!' : 'Tank Created!',
      text: `Tank "${form.value.TankName}" has been ${isEditing.value ? 'updated' : 'created'} successfully.`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })
  } catch (error) {
    // Error handling done by axios interceptor
  } finally {
    formSubmitting.value = false
  }
}

// Delete tank
const deleteTank = async (tank) => {
  const result = await Swal.fire({
    title: 'Delete Tank?',
    text: `Are you sure you want to delete "${tank.TankName}"? This action cannot be undone.`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'No, cancel',
    confirmButtonColor: '#F1416C',
    cancelButtonColor: '#B5B5C3',
    reverseButtons: true,
  })

  if (result.isConfirmed) {
    try {
      await api.delete(`/Tanks/${tank.TankID}`)
      await fetchData()

      Swal.fire({
        title: 'Deleted!',
        text: `Tank "${tank.TankName}" has been deleted.`,
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 3000,
        showConfirmButton: false,
      })
    } catch (error) {
      // Error handling done by axios interceptor
    }
  }
}

// Pagination
const goToPage = (page) => {
  currentPage.value = page
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
  }
}

const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
  }
}

// Watch for changes that should trigger chart re-rendering
watch(
  [tanks, chartGroupBy],
  () => {
    renderCharts()
  },
  { deep: true },
)

// Initialize component
onMounted(async () => {
  await fetchData()

  // Initialize the modal reference
  if (tankModalRef.value) {
    tankModal.value = new bootstrap.Modal(tankModalRef.value)
  }
})

// Clean up charts on unmount
onUnmounted(() => {
  destroyAllCharts()
})
</script>

<style scoped>
/* Mobile-first approach */
.chart-container {
  min-height: 200px;
  position: relative;
}

/* Custom progress bar styling */
.progress {
  height: 8px;
  border-radius: 0.475rem;
}

/* Custom bullet styling */
.bullet {
  display: inline-block;
  border-radius: 99px;
  width: 8px;
  height: 8px;
}

.bullet.bullet-vertical {
  width: 4px;
}

/* Custom card hover effect */
.card {
  transition:
    transform 0.2s ease,
    box-shadow 0.2s ease;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 0.5rem 1.5rem 0.5rem rgba(0, 0, 0, 0.075);
}

/* Tablet and above adjustments */
@media (min-width: 768px) {
  .chart-container {
    min-height: 300px;
  }
}
</style>

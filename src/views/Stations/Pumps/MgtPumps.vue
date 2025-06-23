<!-- PumpManagementView.vue ▸ Premium Design, 100% Self-Contained, Vue 3 + Metronic 8 + ARM Charts -->
<template>
  <div class="d-flex flex-column gap-7">
    <!-- ╔══ Hero Header with Live Metrics ══╗ -->
    <div class="card bg-body-secondary">
      <div class="card-body p-6">
        <div class="row align-items-center">
          <div class="col-12 col-lg-6">
            <div class="d-flex align-items-center mb-3">
              <div class="symbol symbol-50px me-4">
                <div class="symbol-label bg-light-primary">
                  <i class="ki-duotone ki-gas-station fs-2x text-primary">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                </div>
              </div>
              <div>
                <h1 class="text-gray-900 fw-bold fs-2x mb-0">Pump Management</h1>
                <p class="text-muted fs-6 mb-0">Monitor and control fuel dispensing systems</p>
              </div>
            </div>
          </div>
          <div class="col-12 col-lg-6">
            <div class="row g-3">
              <div class="col-6 col-md-3">
                <div class="text-center">
                  <div class="fs-2hx fw-bold text-success" id="activePumpsCount">
                    {{ kpi.active }}
                  </div>
                  <div class="fs-7 text-muted">Active Pumps</div>
                </div>
              </div>
              <div class="col-6 col-md-3">
                <div class="text-center">
                  <div class="fs-2hx fw-bold text-primary" id="totalPumpsCount">
                    {{ kpi.total }}
                  </div>
                  <div class="fs-7 text-muted">Total Pumps</div>
                </div>
              </div>
              <div class="col-6 col-md-3">
                <div class="text-center">
                  <div class="fs-2hx fw-bold text-warning" id="maintenanceCount">
                    {{ kpi.maintenance }}
                  </div>
                  <div class="fs-7 text-muted">Maintenance</div>
                </div>
              </div>
              <div class="col-6 col-md-3">
                <div class="text-center">
                  <div class="fs-2hx fw-bold text-info" id="utilizationRate">
                    {{ kpi.utilization }}%
                  </div>
                  <div class="fs-7 text-muted">Utilization</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ╔══ Analytics Dashboard with ARM Charts ══╗ -->
    <div class="row g-5 g-xl-8">
      <!-- Pump Status Distribution -->
      <div class="col-xl-4">
        <div class="card card-xl-stretch mb-xl-8">
          <div class="card-header border-0">
            <h3 class="card-title fw-bold text-gray-900">Status Distribution</h3>
            <div class="card-toolbar">
              <i class="ki-duotone ki-chart-pie-simple fs-2 text-primary">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </div>
          </div>
          <div class="card-body">
            <canvas id="statusChart" width="300" height="300"></canvas>
          </div>
        </div>
      </div>

      <!-- Meter Readings Trend -->
      <div class="col-xl-4">
        <div class="card card-xl-stretch mb-xl-8">
          <div class="card-header border-0">
            <h3 class="card-title fw-bold text-gray-900">Daily Meter Progress</h3>
            <div class="card-toolbar">
              <i class="ki-duotone ki-chart-line fs-2 text-success">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </div>
          </div>
          <div class="card-body">
            <canvas id="meterChart" width="300" height="300"></canvas>
          </div>
        </div>
      </div>

      <!-- Tank Utilization -->
      <div class="col-xl-4">
        <div class="card card-xl-stretch mb-xl-8">
          <div class="card-header border-0">
            <h3 class="card-title fw-bold text-gray-900">Tank Utilization</h3>
            <div class="card-toolbar">
              <i class="ki-duotone ki-chart-simple fs-2 text-info">
                <span class="path1"></span><span class="path2"></span><span class="path3"></span
                ><span class="path4"></span>
              </i>
            </div>
          </div>
          <div class="card-body">
            <canvas id="tankChart" width="300" height="200"></canvas>
          </div>
        </div>
      </div>
    </div>

    <!-- ╔══ Advanced Filters & Controls ══╗ -->
    <div class="card card-flush">
      <div class="card-header pt-6">
        <div class="card-title flex-column">
          <h2 class="mb-1">Station Operations</h2>
          <div class="text-muted fs-6">Manage pumps and dispensing equipment</div>
        </div>
        <div class="card-toolbar flex-row-reverse">
          <!-- Quick Actions -->
          <div class="d-flex align-items-center gap-3">
            <button
              class="btn btn-sm btn-flex btn-primary"
              :disabled="!flt.stationId"
              @click="openModal('pumpForm', null)"
            >
              <i class="ki-duotone ki-plus fs-3">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Add Pump
            </button>
            <button
              class="btn btn-sm btn-flex btn-light-danger"
              :disabled="!selected.length"
              @click="bulkAction('deactivate')"
            >
              <i class="ki-duotone ki-setting-4 fs-3">
                <span class="path1"></span><span class="path2"></span><span class="path3"></span>
              </i>
              Bulk Actions
            </button>
            <div class="ms-3">
              <button
                class="btn btn-sm btn-icon btn-light"
                @click="refreshData"
                :disabled="loading"
                data-bs-toggle="tooltip"
                title="Refresh Data"
              >
                <i class="ki-duotone ki-arrows-circle fs-3" :class="{ rotate: loading }">
                  <span class="path1"></span><span class="path2"></span>
                </i>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="card-body">
        <!-- Enhanced Filter Bar -->
        <div class="d-flex flex-stack flex-wrap gap-4 mb-8">
          <div class="d-flex align-items-center flex-wrap gap-3">
            <!-- Station Selector -->
            <div class="w-250px">
              <select
                v-model="flt.stationId"
                @change="onStationChange"
                class="form-select form-select-solid form-select-sm"
                data-placeholder="Select Station"
                data-allow-clear="false"
              >
                <option disabled value="">Select Station...</option>
                <option v-for="s in stations" :key="s.StationID" :value="s.StationID">
                  {{ s.StationName }}
                </option>
              </select>
            </div>
            <!-- Tank Filter -->
            <div class="w-200px">
              <select
                v-model="flt.tankId"
                @change="applyFilters"
                class="form-select form-select-solid form-select-sm"
                :disabled="!tanks.length"
                data-placeholder="All Tanks"
              >
                <option value="">All Tanks</option>
                <option v-for="t in tanks" :key="t.TankID" :value="t.TankID">
                  {{ t.TankName }} - {{ getProductName(t.ProductID) }}
                </option>
              </select>
            </div>
            <!-- Status Filter -->
            <div class="w-150px">
              <select
                v-model="flt.status"
                @change="applyFilters"
                class="form-select form-select-solid form-select-sm"
              >
                <option value="">All Status</option>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
                <option value="Maintenance">Maintenance</option>
              </select>
            </div>
          </div>
          <!-- Search -->
          <div class="position-relative w-250px">
            <i
              class="ki-duotone ki-magnifier fs-3 position-absolute ms-3 top-50 translate-middle-y text-gray-500"
            >
              <span class="path1"></span><span class="path2"></span>
            </i>
            <input
              v-model.trim="flt.search"
              @input="debouncedLoad"
              type="text"
              class="form-control form-control-solid form-control-sm ps-10"
              placeholder="Search pumps..."
            />
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading && !pumps.length" class="text-center py-20">
          <div class="spinner-border spinner-border-lg text-primary" role="status">
            <span class="visually-hidden">Loading pumps...</span>
          </div>
          <div class="text-muted fs-6 mt-3">Loading pump data...</div>
        </div>

        <!-- Empty State -->
        <div v-else-if="!pumps.length && flt.stationId" class="text-center py-20">
          <div class="symbol symbol-100px mx-auto mb-7">
            <div class="symbol-label bg-light-primary">
              <i class="ki-duotone ki-gas-station fs-2x text-primary">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </div>
          </div>
          <h3 class="text-gray-800 fw-semibold mb-3">No Pumps Found</h3>
          <div class="text-gray-600 fw-semibold fs-6 mb-8">
            {{
              flt.search || flt.tankId || flt.status
                ? 'Try adjusting your filters'
                : 'Add your first pump to get started'
            }}
          </div>
          <button
            v-if="!flt.search && !flt.tankId && !flt.status"
            class="btn btn-primary"
            @click="openModal('pumpForm', null)"
          >
            <i class="ki-duotone ki-plus fs-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            Add First Pump
          </button>
        </div>

        <!-- Station Selection Required -->
        <div v-else-if="!flt.stationId" class="text-center py-20">
          <div class="symbol symbol-100px mx-auto mb-7">
            <div class="symbol-label bg-light-warning">
              <i class="ki-duotone ki-map fs-2x text-warning">
                <span class="path1"></span><span class="path2"></span><span class="path3"></span>
              </i>
            </div>
          </div>
          <h3 class="text-gray-800 fw-semibold mb-3">Select a Station</h3>
          <div class="text-gray-600 fw-semibold fs-6">
            Choose a station from the dropdown above to view its pumps
          </div>
        </div>

        <!-- Data Grid -->
        <div v-else>
          <!-- Mobile Cards -->
          <div class="d-block d-lg-none">
            <!-- Selection Header -->
            <div class="d-flex justify-content-between align-items-center mb-5">
              <div class="form-check form-check-custom form-check-solid">
                <input
                  class="form-check-input"
                  type="checkbox"
                  v-model="allSelected"
                  id="selectAllMobile"
                />
                <label class="form-check-label fw-semibold text-gray-700" for="selectAllMobile">
                  Select All
                </label>
              </div>
              <div class="text-muted fs-7">{{ selected.length }} of {{ meta.total }} selected</div>
            </div>

            <!-- Pump Cards -->
            <div class="row g-4">
              <div v-for="p in pumps" :key="p.PumpID" class="col-12">
                <div
                  class="card card-custom"
                  :class="{ 'ring ring-primary': selected.includes(p.PumpID) }"
                >
                  <div class="card-body p-5">
                    <div class="d-flex align-items-start">
                      <!-- Selection Checkbox -->
                      <div class="form-check form-check-custom form-check-solid me-4">
                        <input
                          class="form-check-input"
                          type="checkbox"
                          :value="p.PumpID"
                          v-model="selected"
                          :id="`pump_${p.PumpID}`"
                        />
                      </div>

                      <!-- Pump Info -->
                      <div class="flex-grow-1">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                          <div>
                            <h4 class="text-gray-800 fw-bold mb-1">{{ p.PumpName }}</h4>
                            <div class="text-muted fs-7">
                              Tank: {{ getTankName(p.TankID) }} •
                              {{ getProductName(getProductIdForTank(p.TankID)) }}
                            </div>
                          </div>
                          <span :class="statusBadgeClass(p.Status)" @click="toggleStatus(p)">
                            {{ p.Status }}
                          </span>
                        </div>

                        <div class="separator separator-dashed my-4"></div>

                        <div class="row g-3">
                          <div class="col-6">
                            <div class="d-flex align-items-center">
                              <i class="ki-duotone ki-speedometer fs-3 text-info me-2">
                                <span class="path1"></span><span class="path2"></span>
                              </i>
                              <div>
                                <div class="text-gray-800 fw-bold">
                                  {{ formatNumber(p.MeterReading) }}
                                </div>
                                <div class="text-muted fs-8">Meter Reading</div>
                              </div>
                            </div>
                          </div>
                          <div class="col-6">
                            <div class="d-flex align-items-center">
                              <i class="ki-duotone ki-chart-line-up fs-3 text-success me-2">
                                <span class="path1"></span><span class="path2"></span>
                              </i>
                              <div>
                                <div class="text-gray-800 fw-bold">
                                  {{ calculateDailyFlow(p) }}L
                                </div>
                                <div class="text-muted fs-8">Daily Flow</div>
                              </div>
                            </div>
                          </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4">
                          <button
                            class="btn btn-sm btn-light-primary"
                            @click="openModal('meterForm', p)"
                          >
                            <i class="ki-duotone ki-setting-2 fs-4">
                              <span class="path1"></span><span class="path2"></span>
                            </i>
                            Update Meter
                          </button>
                          <button
                            class="btn btn-sm btn-light-info"
                            @click="openModal('pumpForm', p)"
                          >
                            <i class="ki-duotone ki-notepad-edit fs-4">
                              <span class="path1"></span><span class="path2"></span>
                            </i>
                            Edit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Desktop Table -->
          <div class="table-responsive d-none d-lg-block">
            <table class="table align-middle table-row-dashed fs-6 gy-5" id="pumpsTable">
              <thead>
                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                  <th class="w-10px pe-2">
                    <div class="form-check form-check-sm form-check-custom form-check-solid me-3">
                      <input class="form-check-input" type="checkbox" v-model="allSelected" />
                    </div>
                  </th>
                  <th class="min-w-175px cursor-pointer" @click="sortBy('PumpName')">
                    <div class="d-flex align-items-center">
                      Pump Details
                      <i :class="sortIcon('PumpName')" class="ms-1"></i>
                    </div>
                  </th>
                  <th class="min-w-150px">Tank & Product</th>
                  <th class="min-w-125px cursor-pointer" @click="sortBy('MeterReading')">
                    <div class="d-flex align-items-center">
                      Meter Reading
                      <i :class="sortIcon('MeterReading')" class="ms-1"></i>
                    </div>
                  </th>
                  <th class="min-w-100px">Performance</th>
                  <th class="min-w-100px cursor-pointer" @click="sortBy('Status')">
                    <div class="d-flex align-items-center">
                      Status
                      <i :class="sortIcon('Status')" class="ms-1"></i>
                    </div>
                  </th>
                  <th class="text-end min-w-100px">Actions</th>
                </tr>
              </thead>
              <tbody class="fw-semibold text-gray-600">
                <tr
                  v-for="p in pumps"
                  :key="p.PumpID"
                  class="hover-elevate-up"
                  :class="{ 'bg-light-primary': selected.includes(p.PumpID) }"
                >
                  <td>
                    <div class="form-check form-check-sm form-check-custom form-check-solid">
                      <input
                        class="form-check-input"
                        type="checkbox"
                        :value="p.PumpID"
                        v-model="selected"
                      />
                    </div>
                  </td>
                  <td>
                    <div class="d-flex align-items-center">
                      <div class="symbol symbol-45px me-3">
                        <div class="symbol-label bg-light-info">
                          <i class="ki-duotone ki-gas-station fs-3 text-info">
                            <span class="path1"></span><span class="path2"></span>
                          </i>
                        </div>
                      </div>
                      <div>
                        <a
                          href="#"
                          @click.prevent="openModal('pumpForm', p)"
                          class="text-gray-800 fw-bold text-hover-primary fs-6"
                        >
                          {{ p.PumpName }}
                        </a>
                        <div class="text-muted fs-7">ID: {{ p.PumpID }}</div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <div class="d-flex flex-column">
                      <div class="text-gray-800 fw-bold">{{ getTankName(p.TankID) }}</div>
                      <div class="badge badge-light-primary fs-8 mt-1">
                        {{ getProductName(getProductIdForTank(p.TankID)) }}
                      </div>
                    </div>
                  </td>
                  <td>
                    <div class="d-flex align-items-center">
                      <i class="ki-duotone ki-speedometer fs-3 text-primary me-2">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      <div>
                        <div class="text-gray-800 fw-bold fs-6">
                          {{ formatNumber(p.MeterReading) }}
                        </div>
                        <button
                          class="btn btn-sm btn-light-info mt-1"
                          @click="openModal('meterForm', p)"
                        >
                          Update
                        </button>
                      </div>
                    </div>
                  </td>
                  <td>
                    <div class="d-flex flex-column">
                      <div class="text-gray-800 fw-bold">{{ calculateDailyFlow(p) }}L</div>
                      <div class="text-muted fs-8">Daily Flow</div>
                      <div class="progress h-5px mt-1">
                        <div
                          class="progress-bar bg-success"
                          :style="{
                            width: `${Math.min(100, (calculateDailyFlow(p) / 5000) * 100)}%`,
                          }"
                        ></div>
                      </div>
                    </div>
                  </td>
                  <td>
                    <span
                      :class="statusBadgeClass(p.Status)"
                      @click="toggleStatus(p)"
                      role="button"
                    >
                      {{ p.Status }}
                    </span>
                  </td>
                  <td class="text-end">
                    <div class="dropdown">
                      <button
                        class="btn btn-sm btn-icon btn-light btn-active-light-primary"
                        data-bs-toggle="dropdown"
                        aria-expanded="false"
                      >
                        <i class="ki-duotone ki-dots-vertical fs-5">
                          <span class="path1"></span><span class="path2"></span
                          ><span class="path3"></span>
                        </i>
                      </button>
                      <div class="dropdown-menu dropdown-menu-end">
                        <a class="dropdown-item" href="#" @click.prevent="openModal('pumpForm', p)">
                          <i class="ki-duotone ki-notepad-edit fs-5 me-2">
                            <span class="path1"></span><span class="path2"></span>
                          </i>
                          Edit Pump
                        </a>
                        <a
                          class="dropdown-item"
                          href="#"
                          @click.prevent="openModal('meterForm', p)"
                        >
                          <i class="ki-duotone ki-setting-2 fs-5 me-2">
                            <span class="path1"></span><span class="path2"></span>
                          </i>
                          Update Meter
                        </a>
                        <div class="dropdown-divider"></div>
                        <a
                          class="dropdown-item text-danger"
                          href="#"
                          @click.prevent="confirmDelete(p)"
                        >
                          <i class="ki-duotone ki-trash fs-5 me-2">
                            <span class="path1"></span><span class="path2"></span
                            ><span class="path3"></span><span class="path4"></span
                            ><span class="path5"></span>
                          </i>
                          Delete Pump
                        </a>
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Enhanced Pagination -->
          <div v-if="meta.pages > 1" class="d-flex flex-stack flex-wrap pt-8">
            <div class="fs-6 fw-semibold text-gray-700">
              Showing {{ (meta.page - 1) * flt.limit + 1 }} to
              {{ Math.min(meta.page * flt.limit, meta.total) }} of {{ meta.total }} entries
            </div>
            <ul class="pagination">
              <li class="page-item previous" :class="{ disabled: meta.page === 1 }">
                <a href="#" class="page-link" @click.prevent="changePage(meta.page - 1)">
                  <i class="previous"></i>
                </a>
              </li>
              <li
                v-for="n in visiblePages"
                :key="n"
                class="page-item"
                :class="{ active: meta.page === n }"
              >
                <a href="#" class="page-link" @click.prevent="changePage(n)">{{ n }}</a>
              </li>
              <li class="page-item next" :class="{ disabled: meta.page === meta.pages }">
                <a href="#" class="page-link" @click.prevent="changePage(meta.page + 1)">
                  <i class="next"></i>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!-- ╔══ Enhanced Modals ══╗ -->
    <Teleport to="body">
      <!-- Pump Form Modal -->
      <div
        v-if="modal.type === 'pumpForm'"
        class="modal fade show d-block"
        tabindex="-1"
        role="dialog"
        aria-modal="true"
      >
        <div class="modal-dialog modal-dialog-centered modal-lg">
          <div class="modal-content">
            <form @submit.prevent="savePump" novalidate>
              <div class="modal-header">
                <h2 class="modal-title fw-bold">
                  <i class="ki-duotone ki-gas-station fs-2 me-2 text-primary">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  {{ modal.data?.PumpID ? 'Edit Pump' : 'Add New Pump' }}
                </h2>
                <div class="btn btn-icon btn-sm btn-active-light-primary ms-2" @click="closeModal">
                  <i class="ki-duotone ki-cross fs-1">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
                <div class="row g-9">
                  <!-- Pump Name -->
                  <div class="col-12">
                    <div class="fv-row mb-7">
                      <label class="required fs-6 fw-semibold mb-2">Pump Name</label>
                      <input
                        v-model.trim="form.PumpName"
                        type="text"
                        class="form-control form-control-solid"
                        :class="{ 'is-invalid': errors.PumpName }"
                        placeholder="Enter pump identifier (e.g., Pump A1)"
                        maxlength="50"
                        required
                      />
                      <div v-if="errors.PumpName" class="invalid-feedback">
                        {{ errors.PumpName }}
                      </div>
                    </div>
                  </div>

                  <!-- Tank Selection -->
                  <div class="col-12">
                    <div class="fv-row mb-7">
                      <label class="required fs-6 fw-semibold mb-2">Connected Tank</label>
                      <select
                        v-model="form.TankID"
                        class="form-select form-select-solid"
                        :class="{ 'is-invalid': errors.TankID }"
                        required
                      >
                        <option disabled value="">Select Tank...</option>
                        <option v-for="t in tanks" :key="t.TankID" :value="t.TankID">
                          {{ t.TankName }} - {{ getProductName(t.ProductID) }} ({{
                            formatNumber(t.CurrentLevel)
                          }}L / {{ formatNumber(t.Capacity) }}L)
                        </option>
                      </select>
                      <div v-if="errors.TankID" class="invalid-feedback">{{ errors.TankID }}</div>
                    </div>
                  </div>

                  <!-- Meter Reading -->
                  <div class="col-12">
                    <div class="fv-row mb-7">
                      <label class="required fs-6 fw-semibold mb-2">
                        {{ form.PumpID ? 'Current Meter Reading' : 'Initial Meter Reading' }}
                      </label>
                      <div class="input-group input-group-solid">
                        <input
                          v-model.number="form.MeterReading"
                          type="number"
                          min="0"
                          step="0.01"
                          class="form-control"
                          :disabled="!!form.PumpID"
                          :class="{ 'is-invalid': errors.MeterReading }"
                          placeholder="0.00"
                          required
                        />
                        <span class="input-group-text">Liters</span>
                      </div>
                      <div v-if="errors.MeterReading" class="invalid-feedback">
                        {{ errors.MeterReading }}
                      </div>
                      <div v-if="form.PumpID" class="form-text text-muted">
                        Cannot be changed here. Use "Update Meter" action instead.
                      </div>
                    </div>
                  </div>

                  <!-- Status -->
                  <div class="col-12">
                    <div class="fv-row mb-7">
                      <label class="fs-6 fw-semibold mb-2">Status</label>
                      <div class="row g-3">
                        <div class="col-4">
                          <div class="form-check form-check-custom form-check-solid">
                            <input
                              class="form-check-input"
                              type="radio"
                              value="Active"
                              v-model="form.Status"
                              id="statusActive"
                            />
                            <label class="form-check-label" for="statusActive">
                              <div class="d-flex align-items-center">
                                <i class="ki-duotone ki-check-circle fs-2 text-success me-2">
                                  <span class="path1"></span><span class="path2"></span>
                                </i>
                                Active
                              </div>
                            </label>
                          </div>
                        </div>
                        <div class="col-4">
                          <div class="form-check form-check-custom form-check-solid">
                            <input
                              class="form-check-input"
                              type="radio"
                              value="Inactive"
                              v-model="form.Status"
                              id="statusInactive"
                            />
                            <label class="form-check-label" for="statusInactive">
                              <div class="d-flex align-items-center">
                                <i class="ki-duotone ki-cross-circle fs-2 text-danger me-2">
                                  <span class="path1"></span><span class="path2"></span>
                                </i>
                                Inactive
                              </div>
                            </label>
                          </div>
                        </div>
                        <div class="col-4">
                          <div class="form-check form-check-custom form-check-solid">
                            <input
                              class="form-check-input"
                              type="radio"
                              value="Maintenance"
                              v-model="form.Status"
                              id="statusMaintenance"
                            />
                            <label class="form-check-label" for="statusMaintenance">
                              <div class="d-flex align-items-center">
                                <i class="ki-duotone ki-setting-2 fs-2 text-warning me-2">
                                  <span class="path1"></span><span class="path2"></span>
                                </i>
                                Maintenance
                              </div>
                            </label>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-light" @click="closeModal">Cancel</button>
                <button type="submit" class="btn btn-primary" :disabled="saving">
                  <span v-if="saving" class="spinner-border spinner-border-sm me-2"></span>
                  {{ form.PumpID ? 'Update Pump' : 'Create Pump' }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- Meter Update Modal -->
      <div
        v-if="modal.type === 'meterForm'"
        class="modal fade show d-block"
        tabindex="-1"
        role="dialog"
        aria-modal="true"
      >
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <form @submit.prevent="saveMeter" novalidate>
              <div class="modal-header">
                <h2 class="modal-title fw-bold">
                  <i class="ki-duotone ki-speedometer fs-2 me-2 text-info">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Update Meter Reading
                </h2>
                <div class="btn btn-icon btn-sm btn-active-light-primary ms-2" @click="closeModal">
                  <i class="ki-duotone ki-cross fs-1">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
                <!-- Pump Info -->
                <div class="notice bg-light-info rounded border-info border border-dashed p-6 mb-8">
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-45px me-4">
                      <div class="symbol-label bg-info">
                        <i class="ki-duotone ki-gas-station fs-3 text-white">
                          <span class="path1"></span><span class="path2"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <h4 class="text-gray-800 fw-bold mb-1">{{ modal.data?.PumpName }}</h4>
                      <div class="text-muted fs-7">
                        Tank: {{ getTankName(modal.data?.TankID) }} •
                        {{ getProductName(getProductIdForTank(modal.data?.TankID)) }}
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Current Reading -->
                <div class="fv-row mb-7">
                  <label class="fs-6 fw-semibold mb-2">Current Meter Reading</label>
                  <div class="input-group input-group-solid">
                    <input
                      disabled
                      class="form-control form-control-lg"
                      :value="formatNumber(modal.data?.MeterReading)"
                    />
                    <span class="input-group-text">Liters</span>
                  </div>
                </div>

                <!-- New Reading -->
                <div class="fv-row mb-7">
                  <label class="required fs-6 fw-semibold mb-2">New Meter Reading</label>
                  <div class="input-group input-group-solid">
                    <input
                      v-model.number="meter.newReading"
                      :min="modal.data?.MeterReading || 0"
                      type="number"
                      step="0.01"
                      class="form-control form-control-lg"
                      :class="{ 'is-invalid': meterErrors.newReading }"
                      placeholder="Enter new reading"
                      required
                    />
                    <span class="input-group-text">Liters</span>
                  </div>
                  <div v-if="meterErrors.newReading" class="invalid-feedback">
                    {{ meterErrors.newReading }}
                  </div>
                  <div
                    v-if="meter.newReading > (modal.data?.MeterReading || 0)"
                    class="form-text text-success"
                  >
                    Difference: +{{
                      formatNumber(meter.newReading - (modal.data?.MeterReading || 0))
                    }}
                    L
                  </div>
                </div>

                <!-- Reset Option -->
                <div class="fv-row mb-7">
                  <div class="form-check form-switch form-check-custom form-check-solid">
                    <input
                      v-model="meter.reset"
                      class="form-check-input"
                      type="checkbox"
                      id="resetOption"
                    />
                    <label class="form-check-label fw-semibold text-gray-700" for="resetOption">
                      This is a calibration/reset (reading decreased)
                    </label>
                  </div>
                </div>

                <!-- Reset Reason -->
                <div v-if="meter.reset" class="fv-row mb-7">
                  <label class="required fs-6 fw-semibold mb-2">Reason for Reset</label>
                  <textarea
                    v-model.trim="meter.reason"
                    class="form-control form-control-solid"
                    :class="{ 'is-invalid': meterErrors.reason }"
                    placeholder="Enter detailed reason for calibration/reset"
                    rows="3"
                    required
                  ></textarea>
                  <div v-if="meterErrors.reason" class="invalid-feedback">
                    {{ meterErrors.reason }}
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-light" @click="closeModal">Cancel</button>
                <button type="submit" class="btn btn-primary" :disabled="meterSaving">
                  <span v-if="meterSaving" class="spinner-border spinner-border-sm me-2"></span>
                  Update Reading
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- Modal Backdrop -->
      <div v-if="modal.type" class="modal-backdrop fade show"></div>
    </Teleport>
  </div>
</template>

<script setup>
/* Vue 3 Composition API - JavaScript ONLY - 100% Self-Contained */
import { ref, reactive, computed, onMounted, nextTick, Teleport, watch } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

// ═══════════════════════════════════════════════════════════════════════════════
// API CONFIGURATION
// ═══════════════════════════════════════════════════════════════════════════════
const api = axios.create({
  baseURL: 'http://localhost:4000/api/records/v1',
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 15000,
})

// Add response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 400) {
      console.error('Bad request:', error.response.data)
    }
    return Promise.reject(error)
  },
)

// ═══════════════════════════════════════════════════════════════════════════════
// REACTIVE STATE
// ═══════════════════════════════════════════════════════════════════════════════
const stations = ref([])
const tanks = ref([])
const pumps = ref([])
const products = ref([])
const loading = ref(false)
const saving = ref(false)
const meterSaving = ref(false)
const selected = ref([])

// Filter state
const flt = reactive({
  stationId: localStorage.getItem('lastStation') || '',
  tankId: '',
  status: '',
  search: '',
  sort: 'PumpName',
  dir: 'asc',
  page: 1,
  limit: 15,
})

// Pagination metadata
const meta = reactive({
  total: 0,
  pages: 1,
  page: 1,
})

// KPI metrics
const kpi = reactive({
  total: 0,
  active: 0,
  maintenance: 0,
  utilization: 0,
})

// Modal state
const modal = reactive({
  type: null,
  data: null,
})

// Form state
const form = reactive({
  PumpID: null,
  PumpName: '',
  TankID: '',
  MeterReading: 0,
  Status: 'Active',
})

const orig = reactive({})
const errors = reactive({})

// Meter update form
const meter = reactive({
  newReading: 0,
  reset: false,
  reason: '',
})

const meterErrors = reactive({})

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════
const formatNumber = (value) => {
  const num = parseFloat(value) || 0
  return num.toLocaleString(undefined, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })
}

const statusBadgeClass = (status) => {
  const classes = {
    Active: 'badge badge-light-success cursor-pointer',
    Inactive: 'badge badge-light-secondary cursor-pointer',
    Maintenance: 'badge badge-light-warning cursor-pointer',
  }
  return classes[status] || 'badge badge-light cursor-pointer'
}

const sortIcon = (field) => {
  if (flt.sort !== field) return 'ki-duotone ki-arrow-up-down fs-5'
  return flt.dir === 'asc'
    ? 'ki-duotone ki-arrow-up fs-5 text-primary'
    : 'ki-duotone ki-arrow-down fs-5 text-primary'
}

const debounce = (fn, delay = 300) => {
  let timeoutId
  return (...args) => {
    clearTimeout(timeoutId)
    timeoutId = setTimeout(() => fn(...args), delay)
  }
}

const debouncedLoad = debounce(() => {
  flt.page = 1
  loadPumps()
}, 400)

// Toast notifications
const showToast = (message, icon = 'success', timer = 3000) => {
  return Swal.fire({
    toast: true,
    position: 'top-end',
    icon,
    title: message,
    timer,
    showConfirmButton: false,
    timerProgressBar: true,
  })
}

const showError = (message, title = 'Error') => {
  return Swal.fire({
    icon: 'error',
    title,
    text: message,
    confirmButtonColor: '#f1416c',
  })
}

// ═══════════════════════════════════════════════════════════════════════════════
// DATA HELPERS
// ═══════════════════════════════════════════════════════════════════════════════
const getProductName = (productId) => {
  if (!productId) return 'N/A'

  // If products haven't loaded yet, return a placeholder
  if (!products.value.length) return 'Loading...'

  const product = products.value.find((p) => p.ProductID === productId)
  return product?.Name || `Product ${productId}`
}

const getTankName = (tankId) => {
  if (!tankId) return 'N/A'
  const tank = tanks.value.find((t) => t.TankID === tankId)
  return tank?.TankName || 'Unknown Tank'
}

const getProductIdForTank = (tankId) => {
  if (!tankId) return null
  const tank = tanks.value.find((t) => t.TankID === tankId)
  return tank?.ProductID || null
}

const calculateDailyFlow = (pump) => {
  // Simulate daily flow calculation
  const baseFlow = Math.random() * 2000 + 500
  return Math.round(baseFlow)
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAGINATION
// ═══════════════════════════════════════════════════════════════════════════════
const visiblePages = computed(() => {
  const pages = []
  const maxVisible = 7
  const half = Math.floor(maxVisible / 2)

  let start = Math.max(1, meta.page - half)
  let end = Math.min(meta.pages, start + maxVisible - 1)

  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1)
  }

  for (let i = start; i <= end; i++) {
    pages.push(i)
  }

  return pages
})

const changePage = (page) => {
  if (page >= 1 && page <= meta.pages && page !== flt.page) {
    flt.page = page
    loadPumps()
  }
}

// Selection management
const allSelected = computed({
  get: () => pumps.value.length > 0 && selected.value.length === pumps.value.length,
  set: (value) => {
    selected.value = value ? pumps.value.map((p) => p.PumpID) : []
  },
})

// ═══════════════════════════════════════════════════════════════════════════════
// AUDIT LOGGING (Simplified - Console Only)
// ═══════════════════════════════════════════════════════════════════════════════
const logAction = (action, table, recordId, changes = {}) => {
  console.log(`[AUDIT] ${action} on ${table}`, {
    recordId,
    changes,
    timestamp: new Date().toISOString(),
  })
}

// ═══════════════════════════════════════════════════════════════════════════════
// FRAUD DETECTION
// ═══════════════════════════════════════════════════════════════════════════════
const simulateFraudDetection = (payload) => {
  const risks = []
  let score = 0

  // Check for duplicate names
  const duplicateName = pumps.value.some(
    (p) =>
      p.PumpName.toLowerCase().trim() === payload.PumpName.toLowerCase().trim() &&
      p.PumpID !== payload.PumpID,
  )
  if (duplicateName) {
    risks.push('Duplicate pump name detected')
    score += 40
  }

  // Check for excessive initial meter reading
  if (!payload.PumpID && payload.MeterReading > 500000) {
    risks.push('Unusually high initial meter reading')
    score += 30
  }

  // Check for negative values
  if (payload.MeterReading < 0) {
    risks.push('Negative meter reading not allowed')
    score += 50
  }

  return {
    flagged: score >= 40,
    riskScore: Math.min(score, 100),
    reasons: risks,
  }
}

const confirmFraudOverride = async (fraudData) => {
  const result = await Swal.fire({
    title: 'Potential Risk Detected',
    html: `
      <div class="text-start">
        <p class="mb-3">Our system has detected potential irregularities:</p>
        <ul class="list-unstyled mb-4">
          ${fraudData.reasons
            .map(
              (reason) => `<li class="d-flex align-items-center mb-2">
            <i class="ki-duotone ki-warning fs-5 text-warning me-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            ${reason}
          </li>`,
            )
            .join('')}
        </ul>
        <div class="alert alert-warning">
          <strong>Risk Score: ${fraudData.riskScore}%</strong>
        </div>
        <p>Do you want to proceed anyway?</p>
      </div>
    `,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Proceed Anyway',
    cancelButtonText: 'Review & Fix',
    confirmButtonColor: '#f1416c',
  })

  if (result.isConfirmed) {
    logAction('FRAUD_OVERRIDE', 'Pumps', 'OVERRIDE', { fraud_details: fraudData })
  }

  return result.isConfirmed
}

// ═══════════════════════════════════════════════════════════════════════════════
// DATA LOADING
// ═══════════════════════════════════════════════════════════════════════════════
const fetchStations = async () => {
  try {
    console.log('Fetching stations...')
    const { data } = await api.get('/Stations', {
      params: {
        limit: 256,
        order: 'StationName',
      },
    })
    console.log('Stations response:', data)
    stations.value = (data.records || []).filter((s) => s.Status === 'Active')
    console.log('Filtered active stations:', stations.value.length)
  } catch (error) {
    console.error('Failed to fetch stations:', error.response?.data || error.message)
    showError('Failed to load stations. Please check your connection.')
  }
}

const fetchProducts = async () => {
  try {
    console.log('Fetching products...')
    const { data } = await api.get('/Products', {
      params: {
        limit: 256,
        order: 'Name',
      },
    })
    console.log('Products response:', data)
    // Filter for active products, but handle cases where Status might be null/undefined
    products.value = (data.records || []).filter((p) => !p.Status || p.Status === 'Active')
    console.log('Filtered active products:', products.value.length)
  } catch (error) {
    console.error('Failed to fetch products:', error.response?.data || error.message)
    // Don't show error to user since products are not critical for pump management
  }
}

const fetchTanks = async () => {
  if (!flt.stationId) {
    tanks.value = []
    return
  }

  try {
    console.log('Fetching tanks for station:', flt.stationId)
    const { data } = await api.get('/Tanks', {
      params: {
        'filter[StationID]': flt.stationId,
        limit: 256,
        order: 'TankName',
      },
    })
    console.log('Tanks response:', data)
    // Filter for active tanks, but handle cases where Status might be null/undefined
    tanks.value = (data.records || []).filter((t) => !t.Status || t.Status === 'Active')
    console.log('Filtered active tanks:', tanks.value.length)
  } catch (error) {
    console.error('Failed to fetch tanks:', error.response?.data || error.message)
    showError('Failed to load tanks for the selected station.')
  }
}

const loadPumps = async () => {
  if (!flt.stationId) {
    pumps.value = []
    updateKPIs()
    return
  }

  loading.value = true
  try {
    const params = {
      'filter[StationID]': flt.stationId,
      limit: flt.limit,
      offset: (flt.page - 1) * flt.limit,
      order: `${flt.dir === 'desc' ? '-' : ''}${flt.sort}`,
      count: true,
    }

    // Apply filters using the same syntax as original working code
    if (flt.tankId) params['filter[TankID]'] = flt.tankId
    if (flt.status) params['filter[Status]'] = flt.status
    if (flt.search) params['filter[PumpName][$like]'] = `%${flt.search}%`

    console.log('Loading pumps with params:', params)
    const { data } = await api.get('/Pumps', { params })
    console.log('Pumps response:', data)

    pumps.value = data.records || []
    meta.total = data.total_count || pumps.value.length
    meta.pages = Math.max(1, Math.ceil(meta.total / flt.limit))
    meta.page = flt.page

    // Auto-correct page if out of bounds
    if (flt.page > meta.pages && meta.pages > 0) {
      flt.page = meta.pages
      await loadPumps()
      return
    }

    selected.value = []
    updateKPIs()
  } catch (error) {
    console.error('Failed to load pumps:', error.response?.data || error.message)
    showError('Failed to load pump data. Please try again.')
  } finally {
    loading.value = false
  }
}

const updateKPIs = () => {
  const totalPumps = pumps.value.length
  const activePumps = pumps.value.filter((p) => p.Status === 'Active').length
  const maintenancePumps = pumps.value.filter((p) => p.Status === 'Maintenance').length

  kpi.total = totalPumps
  kpi.active = activePumps
  kpi.maintenance = maintenancePumps
  kpi.utilization = totalPumps > 0 ? Math.round((activePumps / totalPumps) * 100) : 0
}

// ═══════════════════════════════════════════════════════════════════════════════
// EVENT HANDLERS
// ═══════════════════════════════════════════════════════════════════════════════
const refreshData = async () => {
  await Promise.all([fetchStations(), fetchProducts(), fetchTanks(), loadPumps()])
  showToast('Data refreshed successfully')
}

const sortBy = (field) => {
  if (flt.sort === field) {
    flt.dir = flt.dir === 'asc' ? 'desc' : 'asc'
  } else {
    flt.sort = field
    flt.dir = 'asc'
  }
  flt.page = 1
  loadPumps()
}

const onStationChange = async () => {
  localStorage.setItem('lastStation', flt.stationId)
  flt.tankId = ''
  flt.page = 1
  selected.value = []

  await fetchTanks()
  await loadPumps()
  initializeCharts()
}

const applyFilters = () => {
  flt.page = 1
  selected.value = []
  loadPumps()
}

// ═══════════════════════════════════════════════════════════════════════════════
// MODAL MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════
const openModal = (type, data = null) => {
  resetErrors()
  modal.type = type
  modal.data = data ? { ...data } : null

  if (type === 'pumpForm') {
    if (data) {
      // Edit mode
      Object.assign(form, data)
      Object.assign(orig, data)
    } else {
      // Create mode
      Object.assign(form, {
        PumpID: null,
        PumpName: '',
        TankID: '',
        MeterReading: 0,
        Status: 'Active',
      })
      Object.assign(orig, {})
    }
  } else if (type === 'meterForm') {
    Object.assign(meter, {
      newReading: data?.MeterReading || 0,
      reset: false,
      reason: '',
    })
    Object.assign(meterErrors, {})
  }
}

const closeModal = () => {
  modal.type = null
  modal.data = null
  resetErrors()
}

const resetErrors = () => {
  Object.keys(errors).forEach((key) => delete errors[key])
  Object.keys(meterErrors).forEach((key) => delete meterErrors[key])
}

// ═══════════════════════════════════════════════════════════════════════════════
// FORM VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════
const validatePumpForm = () => {
  resetErrors()
  let isValid = true

  if (!form.PumpName?.trim()) {
    errors.PumpName = 'Pump name is required'
    isValid = false
  } else if (form.PumpName.trim().length > 50) {
    errors.PumpName = 'Pump name cannot exceed 50 characters'
    isValid = false
  }

  if (!form.TankID) {
    errors.TankID = 'Tank selection is required'
    isValid = false
  }

  if (!form.PumpID && (form.MeterReading === null || form.MeterReading < 0)) {
    errors.MeterReading = 'Initial meter reading must be a non-negative number'
    isValid = false
  }

  return isValid
}

const validateMeterForm = () => {
  Object.keys(meterErrors).forEach((key) => delete meterErrors[key])
  let isValid = true

  if (meter.newReading === null || meter.newReading === '') {
    meterErrors.newReading = 'New reading is required'
    isValid = false
  } else if (meter.newReading < 0) {
    meterErrors.newReading = 'Reading cannot be negative'
    isValid = false
  } else if (!meter.reset && meter.newReading < (modal.data?.MeterReading || 0)) {
    meterErrors.newReading =
      'New reading must be greater than current reading (or enable reset option)'
    isValid = false
  }

  if (meter.reset && !meter.reason?.trim()) {
    meterErrors.reason = 'Reason is required for calibration/reset'
    isValid = false
  }

  return isValid
}

// ═══════════════════════════════════════════════════════════════════════════════
// CRUD OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════
const savePump = async () => {
  if (!validatePumpForm()) return

  const payload = {
    ...form,
    StationID: flt.stationId,
    MeterReading: parseFloat(form.MeterReading) || 0,
  }

  // Fraud detection
  const fraudData = simulateFraudDetection(payload)
  if (fraudData.flagged) {
    const confirmed = await confirmFraudOverride(fraudData)
    if (!confirmed) return
  }

  saving.value = true
  try {
    let result
    if (payload.PumpID) {
      // Update existing pump
      result = await api.put(`/Pumps/${payload.PumpID}`, payload)
      logAction('UPDATE', 'Pumps', payload.PumpID, {
        before: orig,
        after: payload,
      })
      showToast('Pump updated successfully')
    } else {
      // Create new pump
      const { PumpID, ...createData } = payload
      result = await api.post('/Pumps', createData)
      const newPump = result.data.record || { PumpID: result.data.PumpID, ...createData }
      logAction('CREATE', 'Pumps', newPump.PumpID, { after: newPump })
      showToast('Pump created successfully')
    }

    closeModal()
    loadPumps()
  } catch (error) {
    const errorMsg = error.response?.data?.message || error.message || 'Operation failed'
    logAction('FAILED_SAVE', 'Pumps', payload.PumpID || 'NEW', {
      error: errorMsg,
      payload,
    })
    showError(`Save failed: ${errorMsg}`)
  } finally {
    saving.value = false
  }
}

const saveMeter = async () => {
  if (!validateMeterForm()) return

  const payload = {
    PumpID: modal.data.PumpID,
    MeterReading: parseFloat(meter.newReading),
    Reset: meter.reset,
    Reason: meter.reset ? meter.reason.trim() : null,
  }

  meterSaving.value = true
  try {
    await api.put(`/Pumps/${payload.PumpID}`, {
      MeterReading: payload.MeterReading,
    })

    logAction('METER_UPDATE', 'Pumps', payload.PumpID, {
      from: modal.data.MeterReading,
      to: payload.MeterReading,
      reset: payload.Reset,
      reason: payload.Reason,
    })

    showToast('Meter reading updated successfully')
    closeModal()
    loadPumps()
  } catch (error) {
    const errorMsg = error.response?.data?.message || error.message || 'Meter update failed'
    logAction('FAILED_METER_UPDATE', 'Pumps', payload.PumpID, {
      error: errorMsg,
      payload,
    })
    showError(`Update failed: ${errorMsg}`)
  } finally {
    meterSaving.value = false
  }
}

const toggleStatus = async (pump) => {
  const newStatus = pump.Status === 'Active' ? 'Inactive' : 'Active'
  const originalStatus = pump.Status

  // Optimistic update
  pump.Status = newStatus

  try {
    await api.put(`/Pumps/${pump.PumpID}`, { Status: newStatus })
    logAction('STATUS_TOGGLE', 'Pumps', pump.PumpID, {
      from: originalStatus,
      to: newStatus,
    })
    showToast(`Pump status changed to ${newStatus}`)
    updateKPIs()
  } catch (error) {
    // Revert on failure
    pump.Status = originalStatus
    showError(`Status change failed: ${error.response?.data?.message || 'Unknown error'}`)
  }
}

const confirmDelete = async (pump) => {
  const result = await Swal.fire({
    title: 'Delete Pump',
    html: `
      <div class="text-start">
        <p>Are you sure you want to delete <strong>${pump.PumpName}</strong>?</p>
        <div class="alert alert-warning">
          <i class="ki-duotone ki-warning fs-2 text-warning me-2">
            <span class="path1"></span><span class="path2"></span>
          </i>
          This action cannot be undone and will remove all associated data.
        </div>
      </div>
    `,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, Delete',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
  })

  if (!result.isConfirmed) return

  try {
    await api.delete(`/Pumps/${pump.PumpID}`)
    logAction('DELETE', 'Pumps', pump.PumpID, { deleted_pump: pump })
    showToast('Pump deleted successfully')
    loadPumps()
  } catch (error) {
    const errorMsg = error.response?.data?.message || 'Delete operation failed'
    logAction('FAILED_DELETE', 'Pumps', pump.PumpID, {
      error: errorMsg,
      pump,
    })
    showError(`Delete failed: ${errorMsg}`)
  }
}

const bulkAction = async (action) => {
  if (!selected.value.length) {
    showToast('No pumps selected', 'info')
    return
  }

  const actionText = action === 'deactivate' ? 'deactivate' : action
  const result = await Swal.fire({
    title: `Bulk ${actionText}`,
    text: `${actionText} ${selected.value.length} selected pump(s)?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: `Yes, ${actionText}`,
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
  })

  if (!result.isConfirmed) return

  try {
    if (action === 'deactivate') {
      // Update status for all selected pumps
      const promises = selected.value.map((id) => api.put(`/Pumps/${id}`, { Status: 'Inactive' }))
      await Promise.all(promises)
    }

    logAction(`BULK_${action.toUpperCase()}`, 'Pumps', null, {
      pump_ids: selected.value,
      action,
    })

    showToast(`${selected.value.length} pump(s) ${actionText}d successfully`)
    selected.value = []
    loadPumps()
  } catch (error) {
    showError(`Bulk ${action} failed: ${error.response?.data?.message || 'Unknown error'}`)
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ARM CHARTS INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════
const initializeCharts = () => {
  nextTick(() => {
    initStatusChart()
    initMeterChart()
    initTankChart()
  })
}

const initStatusChart = () => {
  const canvas = document.getElementById('statusChart')
  if (!canvas || !pumps.value.length) return

  const ctx = canvas.getContext('2d')

  // Clear previous chart
  ctx.clearRect(0, 0, canvas.width, canvas.height)

  // Data preparation
  const statusData = {
    Active: pumps.value.filter((p) => p.Status === 'Active').length,
    Inactive: pumps.value.filter((p) => p.Status === 'Inactive').length,
    Maintenance: pumps.value.filter((p) => p.Status === 'Maintenance').length,
  }

  const colors = ['#50cd89', '#a1a5b7', '#ffc700']
  const data = Object.values(statusData)
  const labels = Object.keys(statusData)

  // Simple pie chart implementation
  const centerX = canvas.width / 2
  const centerY = canvas.height / 2
  const radius = Math.min(centerX, centerY) - 20

  let currentAngle = -Math.PI / 2
  const total = data.reduce((sum, val) => sum + val, 0)

  if (total === 0) return

  data.forEach((value, index) => {
    const sliceAngle = (value / total) * 2 * Math.PI

    // Draw slice
    ctx.beginPath()
    ctx.moveTo(centerX, centerY)
    ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + sliceAngle)
    ctx.closePath()
    ctx.fillStyle = colors[index]
    ctx.fill()

    // Draw label
    const labelAngle = currentAngle + sliceAngle / 2
    const labelX = centerX + Math.cos(labelAngle) * (radius / 1.5)
    const labelY = centerY + Math.sin(labelAngle) * (radius / 1.5)

    ctx.fillStyle = '#ffffff'
    ctx.font = 'bold 12px Arial'
    ctx.textAlign = 'center'
    ctx.fillText(value.toString(), labelX, labelY)

    currentAngle += sliceAngle
  })
}

const initMeterChart = () => {
  const canvas = document.getElementById('meterChart')
  if (!canvas || !pumps.value.length) return

  const ctx = canvas.getContext('2d')
  ctx.clearRect(0, 0, canvas.width, canvas.height)

  // Sample data for last 7 days
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
  const data = days.map(() => Math.random() * 10000 + 5000)

  const padding = 40
  const chartWidth = canvas.width - padding * 2
  const chartHeight = canvas.height - padding * 2

  const maxValue = Math.max(...data)
  const minValue = Math.min(...data)
  const range = maxValue - minValue || 1

  // Draw axes
  ctx.strokeStyle = '#e4e6ef'
  ctx.lineWidth = 1
  ctx.beginPath()
  ctx.moveTo(padding, padding)
  ctx.lineTo(padding, padding + chartHeight)
  ctx.lineTo(padding + chartWidth, padding + chartHeight)
  ctx.stroke()

  // Draw line
  ctx.strokeStyle = '#50cd89'
  ctx.lineWidth = 3
  ctx.beginPath()

  data.forEach((value, index) => {
    const x = padding + (index / (data.length - 1)) * chartWidth
    const y = padding + chartHeight - ((value - minValue) / range) * chartHeight

    if (index === 0) {
      ctx.moveTo(x, y)
    } else {
      ctx.lineTo(x, y)
    }

    // Draw point
    ctx.fillStyle = '#50cd89'
    ctx.beginPath()
    ctx.arc(x, y, 4, 0, 2 * Math.PI)
    ctx.fill()
  })

  ctx.stroke()

  // Draw labels
  ctx.fillStyle = '#a1a5b7'
  ctx.font = '11px Arial'
  ctx.textAlign = 'center'

  days.forEach((day, index) => {
    const x = padding + (index / (days.length - 1)) * chartWidth
    ctx.fillText(day, x, canvas.height - 10)
  })
}

const initTankChart = () => {
  const canvas = document.getElementById('tankChart')
  if (!canvas || !tanks.value.length) return

  const ctx = canvas.getContext('2d')
  ctx.clearRect(0, 0, canvas.width, canvas.height)

  const padding = 30
  const barWidth = (canvas.width - padding * 2) / tanks.value.length - 10
  const maxHeight = canvas.height - padding * 2

  tanks.value.forEach((tank, index) => {
    const utilization = (tank.CurrentLevel || 0) / (tank.Capacity || 1)
    const barHeight = utilization * maxHeight

    const x = padding + index * (barWidth + 10)
    const y = canvas.height - padding - barHeight

    // Draw bar
    const gradient = ctx.createLinearGradient(0, y, 0, y + barHeight)
    gradient.addColorStop(0, '#009ef7')
    gradient.addColorStop(1, '#50cd89')

    ctx.fillStyle = gradient
    ctx.fillRect(x, y, barWidth, barHeight)

    // Draw tank name
    ctx.fillStyle = '#a1a5b7'
    ctx.font = '10px Arial'
    ctx.textAlign = 'center'
    ctx.save()
    ctx.translate(x + barWidth / 2, canvas.height - 5)
    ctx.rotate(-Math.PI / 4)
    ctx.fillText(tank.TankName, 0, 0)
    ctx.restore()

    // Draw percentage
    ctx.fillStyle = '#ffffff'
    ctx.font = 'bold 10px Arial'
    ctx.textAlign = 'center'
    if (barHeight > 20) {
      ctx.fillText(`${Math.round(utilization * 100)}%`, x + barWidth / 2, y + barHeight / 2)
    }
  })
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIFECYCLE HOOKS
// ═══════════════════════════════════════════════════════════════════════════════
onMounted(async () => {
  try {
    console.log('Initializing pump management...')

    // Load essential data first
    await fetchStations()

    // Load products in background (not critical)
    fetchProducts().catch((err) => console.warn('Products loading failed:', err))

    // If we have a selected station, load related data
    if (flt.stationId) {
      await fetchTanks()
      await loadPumps()

      // Initialize charts after data is loaded
      nextTick(() => initializeCharts())
    }

    console.log('Initialization complete')
  } catch (error) {
    console.error('Critical initialization failed:', error)
    showError('Failed to initialize pump management. Please refresh the page.')
  }
})

// Watch for pump data changes to update charts
watch(
  () => pumps.value.length,
  () => {
    updateKPIs()
    initializeCharts()
  },
)

// Watch for station changes to update charts
watch(
  () => flt.stationId,
  () => {
    if (flt.stationId) {
      nextTick(() => initializeCharts())
    }
  },
)
</script>

<style scoped>
/* Lean Custom Styles - Maximum 30 lines */
.ring {
  box-shadow: 0 0 0 3px rgba(var(--bs-primary-rgb), 0.25);
}

.rotate {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.hover-elevate-up {
  transition: all 0.15s ease;
}

.hover-elevate-up:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.card-custom {
  transition: all 0.2s ease;
  border: 1px solid var(--kt-border-color);
}

.card-custom:hover {
  border-color: var(--kt-primary);
  transform: translateY(-2px);
}

.symbol-label {
  display: flex;
  align-items: center;
  justify-content: center;
}

.pagination .page-link {
  border-radius: 0.475rem;
  margin: 0 2px;
  min-width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.table-responsive {
  border-radius: 0.75rem;
  overflow: hidden;
}

.notice {
  border-radius: 0.75rem;
}

.badge.cursor-pointer:hover {
  transform: scale(1.05);
  transition: all 0.15s ease;
}
</style>

<template>
  <div class="d-flex flex-column min-vh-100 bg-light-primary position-relative">
    <!-- Pull to Refresh Indicator -->
    <div
      v-if="refreshing"
      class="position-fixed top-0 start-0 end-0 bg-primary text-white text-center py-2 z-index-3"
    >
      <div class="spinner-border spinner-border-sm me-2"></div>
      Refreshing approvals...
    </div>

    <!-- Station Selection Modal -->
    <div
      v-if="!selectedStation"
      class="modal d-flex show position-fixed w-100 h-100"
      style="background: rgba(0, 0, 0, 0.9); z-index: 9999"
    >
      <div class="modal-dialog modal-dialog-centered mx-3 mx-md-auto">
        <div class="modal-content border-0 shadow-lg bg-white rounded-4 overflow-hidden">
          <div class="modal-header bg-gradient-primary border-0 p-4">
            <div class="text-center w-100">
              <i class="ki-duotone ki-geolocation fs-3x text-white mb-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <h2 class="modal-title fw-bolder text-white mb-1">Select Your Station</h2>
              <p class="text-white opacity-75 mb-0">Choose your working location to continue</p>
            </div>
          </div>
          <div class="modal-body p-4 p-md-6">
            <div class="d-flex flex-column gap-3">
              <button
                v-for="station in userStations"
                :key="station.StationID"
                @click="selectStation(station)"
                class="btn btn-outline-primary btn-lg text-start p-4 border-2 border-dashed hover-elevate-up position-relative overflow-hidden"
                :disabled="stationLoading"
              >
                <div class="d-flex align-items-center">
                  <div class="symbol symbol-50px me-4">
                    <div class="symbol-circle bg-light-primary">
                      <i class="ki-duotone ki-shop fs-2 text-primary">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </div>
                  </div>
                  <div class="flex-grow-1">
                    <div class="fw-bold fs-4 text-gray-900 mb-1">{{ station.StationName }}</div>
                    <div class="text-muted fs-6">{{ station.Location }}</div>
                    <div class="d-flex align-items-center mt-2">
                      <span class="badge badge-light-success me-2">{{
                        station.Status || 'Active'
                      }}</span>
                      <span class="text-muted fs-7">{{ station.ContactPhone || 'N/A' }}</span>
                    </div>
                  </div>
                  <i class="ki-duotone ki-arrow-right fs-2 text-primary">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div v-if="selectedStation" class="flex-grow-1">
      <!-- Premium Header -->
      <div class="bg-gradient-primary shadow-sm mb-3 position-sticky top-0 z-index-2">
        <div class="container-fluid p-3 p-md-4">
          <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-45px me-3">
                <div class="symbol-circle bg-white bg-opacity-20">
                  <i class="ki-duotone ki-verify fs-2 text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div>
                <h1 class="text-white fw-bolder mb-0 fs-3 fs-md-2">Approvals</h1>
                <p class="text-white opacity-75 mb-0 fs-6">{{ selectedStation.StationName }}</p>
              </div>
            </div>
            <div class="d-flex gap-2">
              <button
                @click="refreshApprovals"
                class="btn btn-light-primary btn-sm rounded-3"
                :disabled="loading"
              >
                <i class="ki-duotone ki-arrows-circle fs-4" :class="{ rotating: loading }">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
              <button @click="showFilterModal = true" class="btn btn-light-info btn-sm rounded-3">
                <i class="ki-duotone ki-filter fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="container-fluid px-3 px-md-4">
        <!-- Enhanced Stats Grid -->
        <div class="row g-3 mb-4">
          <div class="col-6 col-lg-3">
            <div
              class="card card-flush border-0 bg-gradient-success shadow-sm hover-elevate-up h-100"
            >
              <div class="card-body text-center p-3 p-md-4">
                <div class="symbol symbol-50px mx-auto mb-3">
                  <div class="symbol-circle bg-white bg-opacity-20">
                    <i class="ki-duotone ki-check-circle fs-2 text-white">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </div>
                </div>
                <div class="fw-bolder fs-2x text-white mb-1">{{ approvalStats.pending }}</div>
                <div class="text-white opacity-75 fw-semibold fs-6">Pending</div>
                <div class="progress mt-3" style="height: 4px">
                  <div
                    class="progress-bar bg-white bg-opacity-50"
                    :style="{ width: getStatPercentage('pending') + '%' }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-6 col-lg-3">
            <div
              class="card card-flush border-0 bg-gradient-warning shadow-sm hover-elevate-up h-100"
            >
              <div class="card-body text-center p-3 p-md-4">
                <div class="symbol symbol-50px mx-auto mb-3">
                  <div class="symbol-circle bg-white bg-opacity-20">
                    <i class="ki-duotone ki-timer fs-2 text-white">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                  </div>
                </div>
                <div class="fw-bolder fs-2x text-white mb-1">{{ approvalStats.urgent }}</div>
                <div class="text-white opacity-75 fw-semibold fs-6">Urgent</div>
                <div class="progress mt-3" style="height: 4px">
                  <div
                    class="progress-bar bg-white bg-opacity-50"
                    :style="{ width: getStatPercentage('urgent') + '%' }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-6 col-lg-3">
            <div class="card card-flush border-0 bg-gradient-info shadow-sm hover-elevate-up h-100">
              <div class="card-body text-center p-3 p-md-4">
                <div class="symbol symbol-50px mx-auto mb-3">
                  <div class="symbol-circle bg-white bg-opacity-20">
                    <i class="ki-duotone ki-chart-pie fs-2 text-white">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                  </div>
                </div>
                <div class="fw-bolder fs-2x text-white mb-1">
                  {{ approvalStats.todayProcessed }}
                </div>
                <div class="text-white opacity-75 fw-semibold fs-6">Today</div>
                <div class="progress mt-3" style="height: 4px">
                  <div
                    class="progress-bar bg-white bg-opacity-50"
                    :style="{
                      width: Math.min(100, (approvalStats.todayProcessed / 20) * 100) + '%',
                    }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-6 col-lg-3">
            <div
              class="card card-flush border-0 bg-gradient-danger shadow-sm hover-elevate-up h-100"
            >
              <div class="card-body text-center p-3 p-md-4">
                <div class="symbol symbol-50px mx-auto mb-3">
                  <div class="symbol-circle bg-white bg-opacity-20">
                    <i class="ki-duotone ki-calendar fs-2 text-white">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </div>
                </div>
                <div class="fw-bolder fs-2x text-white mb-1">{{ approvalStats.overdue }}</div>
                <div class="text-white opacity-75 fw-semibold fs-6">Overdue</div>
                <div class="progress mt-3" style="height: 4px">
                  <div
                    class="progress-bar bg-white bg-opacity-50"
                    :style="{ width: getStatPercentage('overdue') + '%' }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Premium Analytics Card -->
        <div class="card card-flush border-0 shadow-sm mb-4">
          <div class="card-header bg-light-primary border-0 py-4">
            <h3 class="card-title fw-bold text-primary d-flex align-items-center">
              <i class="ki-duotone ki-chart-line fs-2 me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Approval Analytics
            </h3>
            <div class="card-toolbar">
              <select
                v-model="chartPeriod"
                @change="updateChart"
                class="form-select form-select-sm border-0 bg-light-info text-info fw-bold"
              >
                <option value="7d">7 Days</option>
                <option value="30d">30 Days</option>
                <option value="90d">90 Days</option>
              </select>
            </div>
          </div>
          <div class="card-body p-4">
            <div class="row align-items-center">
              <div class="col-12 col-md-8">
                <canvas ref="approvalChart" height="200" class="w-100"></canvas>
              </div>
              <div class="col-12 col-md-4 mt-4 mt-md-0">
                <div class="d-flex flex-column gap-3">
                  <div class="d-flex align-items-center">
                    <div class="w-4px h-20px bg-success rounded me-3"></div>
                    <div>
                      <div class="fw-bold text-gray-800 fs-6">Approved</div>
                      <div class="text-muted fs-7">{{ chartData.approved || 0 }} this period</div>
                    </div>
                  </div>
                  <div class="d-flex align-items-center">
                    <div class="w-4px h-20px bg-danger rounded me-3"></div>
                    <div>
                      <div class="fw-bold text-gray-800 fs-6">Rejected</div>
                      <div class="text-muted fs-7">{{ chartData.rejected || 0 }} this period</div>
                    </div>
                  </div>
                  <div class="d-flex align-items-center">
                    <div class="w-4px h-20px bg-warning rounded me-3"></div>
                    <div>
                      <div class="fw-bold text-gray-800 fs-6">Avg. Time</div>
                      <div class="text-muted fs-7">{{ chartData.avgTime || '2.5h' }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Enhanced Filter Tabs -->
        <div class="card card-flush border-0 shadow-sm mb-4">
          <div class="card-body p-3 p-md-4">
            <div class="d-flex gap-2 flex-wrap">
              <button
                v-for="filter in filterOptions"
                :key="filter.key"
                @click="setActiveFilter(filter.key)"
                :class="[
                  'btn btn-sm flex-grow-1 position-relative overflow-hidden',
                  activeFilter === filter.key ? 'btn-primary' : 'btn-light-primary',
                ]"
                class="min-h-50px"
              >
                <div class="d-flex flex-column align-items-center">
                  <i :class="filter.icon + ' fs-3 mb-1'">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <span class="fw-bold fs-7">{{ filter.label }}</span>
                  <span
                    v-if="filter.count > 0"
                    class="badge badge-circle badge-white position-absolute top-0 end-0 translate-middle"
                  >
                    {{ filter.count }}
                  </span>
                </div>
              </button>
            </div>
          </div>
        </div>

        <!-- Enhanced Approvals List -->
        <div class="d-flex flex-column gap-4">
          <!-- Loading State -->
          <div v-if="loading" class="d-flex flex-column align-items-center py-8">
            <div class="spinner-border text-primary mb-3" style="width: 3rem; height: 3rem"></div>
            <p class="text-muted fw-semibold">Loading your approvals...</p>
          </div>

          <!-- Empty State -->
          <div
            v-else-if="filteredApprovals.length === 0"
            class="card card-flush border-0 shadow-sm"
          >
            <div class="card-body text-center py-10">
              <div class="symbol symbol-100px mx-auto mb-5">
                <div class="symbol-circle bg-light-success">
                  <i class="ki-duotone ki-check-circle fs-2x text-success">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <h3 class="text-gray-800 fw-bold mb-3">{{ getEmptyStateTitle() }}</h3>
              <p class="text-gray-600 fs-6 mb-5">{{ getEmptyStateDescription() }}</p>
              <button @click="refreshApprovals" class="btn btn-primary">
                <i class="ki-duotone ki-arrows-circle fs-4 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Refresh
              </button>
            </div>
          </div>

          <!-- Approval Cards -->
          <div
            v-for="(approval, index) in paginatedApprovals"
            :key="approval.ApprovalID"
            class="card card-flush border-0 shadow-sm hover-elevate-up"
            :class="getApprovalCardClass(approval)"
            :style="{ animationDelay: index * 0.1 + 's' }"
          >
            <div class="card-body p-4 p-md-5">
              <!-- Enhanced Header -->
              <div class="d-flex align-items-start justify-content-between mb-4">
                <div class="d-flex align-items-start">
                  <div class="symbol symbol-50px me-4">
                    <div :class="getApprovalIconBg(approval.RequestType)">
                      <i :class="getApprovalIconClass(approval.RequestType) + ' fs-2x text-white'">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </div>
                  </div>
                  <div class="flex-grow-1">
                    <h4 class="fw-bold text-gray-900 mb-2 fs-5">{{ approval.RequestTitle }}</h4>
                    <div class="d-flex align-items-center gap-2 flex-wrap mb-2">
                      <span :class="getPriorityBadge(approval.Priority)">
                        <i class="ki-duotone ki-arrow-up fs-6 me-1">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        {{ approval.Priority }}
                      </span>
                      <span :class="getStatusBadge(approval.Status)">{{ approval.Status }}</span>
                      <span class="badge badge-light-info"
                        >Level {{ approval.CurrentApprovalLevel }}</span
                      >
                    </div>
                    <div class="text-muted fs-7 fw-semibold">
                      {{ approval.RequestType }} • {{ formatRelativeTime(approval.RequestDate) }}
                    </div>
                  </div>
                </div>
                <div class="text-end">
                  <div v-if="isOverdue(approval)" class="badge badge-light-danger mb-2">
                    <i class="ki-duotone ki-warning-2 fs-6 me-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                    Overdue
                  </div>
                  <div v-else-if="isUrgent(approval)" class="badge badge-light-warning mb-2">
                    <i class="ki-duotone ki-timer fs-6 me-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                    Urgent
                  </div>
                  <div class="text-muted fs-8">
                    {{ approval.DueDate ? 'Due: ' + formatDate(approval.DueDate) : 'No deadline' }}
                  </div>
                </div>
              </div>

              <!-- Enhanced Details Grid -->
              <div class="row g-4 mb-4">
                <div class="col-6 col-md-3">
                  <div class="bg-light-primary p-3 rounded-3">
                    <div class="text-primary fs-7 fw-bold mb-1">Requester</div>
                    <div class="text-gray-800 fs-6 fw-semibold">
                      {{ approval.RequesterName || 'Unknown' }}
                    </div>
                  </div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="bg-light-success p-3 rounded-3">
                    <div class="text-success fs-7 fw-bold mb-1">Amount</div>
                    <div class="text-gray-800 fs-6 fw-semibold">
                      {{ approval.RequestAmount ? formatCurrency(approval.RequestAmount) : 'N/A' }}
                    </div>
                  </div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="bg-light-info p-3 rounded-3">
                    <div class="text-info fs-7 fw-bold mb-1">Approval Level</div>
                    <div class="text-gray-800 fs-6 fw-semibold">
                      {{ approval.CurrentApprovalLevel }} of {{ getTotalLevels(approval) }}
                    </div>
                  </div>
                </div>
                <div class="col-6 col-md-3">
                  <div class="bg-light-warning p-3 rounded-3">
                    <div class="text-warning fs-7 fw-bold mb-1">Days Open</div>
                    <div class="text-gray-800 fs-6 fw-semibold">{{ getDaysOpen(approval) }}</div>
                  </div>
                </div>
              </div>

              <!-- Request Details -->
              <div v-if="approval.RequestDetails" class="bg-light-secondary p-4 rounded-3 mb-4">
                <div class="text-muted fs-7 fw-bold mb-2">Request Details</div>
                <div class="text-gray-700 fs-6">{{ approval.RequestDetails }}</div>
              </div>

              <!-- Enhanced Action Buttons -->
              <div class="d-flex gap-2 flex-wrap">
                <button
                  @click="approveRequest(approval)"
                  class="btn btn-success flex-grow-1 btn-lg rounded-3"
                  :disabled="processing"
                >
                  <i class="ki-duotone ki-check fs-3 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <span class="fw-bold">Approve</span>
                </button>
                <button
                  @click="rejectRequest(approval)"
                  class="btn btn-danger flex-grow-1 btn-lg rounded-3"
                  :disabled="processing"
                >
                  <i class="ki-duotone ki-cross fs-3 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <span class="fw-bold">Reject</span>
                </button>
                <button
                  @click="viewDetails(approval)"
                  class="btn btn-light-primary btn-lg rounded-3"
                  :disabled="processing"
                >
                  <i class="ki-duotone ki-eye fs-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Enhanced Load More -->
        <div v-if="hasMoreApprovals" class="text-center mt-6 mb-4">
          <button
            @click="loadMoreApprovals"
            class="btn btn-light-primary btn-lg rounded-3"
            :disabled="loadingMore"
          >
            <span v-if="loadingMore" class="spinner-border spinner-border-sm me-2"></span>
            <i v-else class="ki-duotone ki-arrow-down fs-3 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Load More Approvals
          </button>
        </div>
      </div>
    </div>

    <!-- Enhanced Action Modal -->
    <div
      v-if="showActionModal"
      class="modal d-flex show position-fixed w-100 h-100"
      style="background: rgba(0, 0, 0, 0.8); z-index: 9999"
    >
      <div class="modal-dialog modal-dialog-centered mx-3 mx-md-auto">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
          <div
            :class="[
              'modal-header border-0 p-4',
              actionType === 'approve' ? 'bg-gradient-success' : 'bg-gradient-danger',
            ]"
          >
            <div class="text-center w-100">
              <div class="symbol symbol-60px mx-auto mb-3">
                <div class="symbol-circle bg-white bg-opacity-20">
                  <i
                    :class="[
                      'ki-duotone fs-2x text-white',
                      actionType === 'approve' ? 'ki-check' : 'ki-cross',
                    ]"
                  >
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <h3 class="modal-title fw-bolder text-white mb-1">
                {{ actionType === 'approve' ? 'Approve Request' : 'Reject Request' }}
              </h3>
              <p class="text-white opacity-75 mb-0">{{ selectedApproval?.RequestTitle }}</p>
            </div>
            <button
              @click="closeActionModal"
              class="btn btn-sm btn-icon btn-light position-absolute top-0 end-0 m-3"
            >
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body p-4 p-md-6">
            <!-- Request Summary -->
            <div class="bg-light-secondary p-4 rounded-3 mb-5">
              <div class="row g-3">
                <div class="col-6">
                  <div class="text-muted fs-7 fw-bold">Type</div>
                  <div class="text-gray-800 fw-semibold">{{ selectedApproval?.RequestType }}</div>
                </div>
                <div class="col-6">
                  <div class="text-muted fs-7 fw-bold">Amount</div>
                  <div class="text-gray-800 fw-semibold">
                    {{
                      selectedApproval?.RequestAmount
                        ? formatCurrency(selectedApproval.RequestAmount)
                        : 'N/A'
                    }}
                  </div>
                </div>
                <div class="col-6">
                  <div class="text-muted fs-7 fw-bold">Requester</div>
                  <div class="text-gray-800 fw-semibold">
                    {{ selectedApproval?.RequesterName || 'Unknown' }}
                  </div>
                </div>
                <div class="col-6">
                  <div class="text-muted fs-7 fw-bold">Priority</div>
                  <span :class="getPriorityBadge(selectedApproval?.Priority)">{{
                    selectedApproval?.Priority
                  }}</span>
                </div>
              </div>
            </div>

            <!-- Comments Section -->
            <div class="mb-5">
              <label class="form-label fw-bold fs-6 mb-3">
                {{ actionType === 'approve' ? 'Approval Comments' : 'Rejection Reason' }}
                <span v-if="actionType === 'reject'" class="text-danger">*</span>
              </label>
              <textarea
                v-model="actionComments"
                class="form-control form-control-lg border-2"
                :class="{
                  'border-success': actionType === 'approve',
                  'border-danger': actionType === 'reject',
                  'is-invalid':
                    actionType === 'reject' && !actionComments.trim() && commentsTouched,
                }"
                rows="4"
                :placeholder="
                  actionType === 'approve'
                    ? 'Add any approval notes...'
                    : 'Please explain why you are rejecting this request...'
                "
                @blur="commentsTouched = true"
              ></textarea>
              <div
                v-if="actionType === 'reject' && !actionComments.trim() && commentsTouched"
                class="invalid-feedback"
              >
                Rejection reason is required
              </div>
            </div>

            <!-- Risk Assessment for high amounts -->
            <div
              v-if="
                selectedApproval?.RequestAmount &&
                parseFloat(selectedApproval.RequestAmount) > 1000000
              "
              class="alert alert-warning d-flex align-items-center mb-5"
            >
              <i class="ki-duotone ki-warning-2 fs-2x text-warning me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div>
                <div class="fw-bold">High Value Transaction</div>
                <div class="text-muted fs-7">
                  This request involves a significant amount. Please review carefully.
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer border-0 p-4 p-md-6 pt-0">
            <button @click="closeActionModal" class="btn btn-light btn-lg me-3">Cancel</button>
            <button
              @click="confirmAction"
              :class="[
                'btn btn-lg flex-grow-1',
                actionType === 'approve' ? 'btn-success' : 'btn-danger',
              ]"
              :disabled="processing || (actionType === 'reject' && !actionComments.trim())"
            >
              <span v-if="processing" class="spinner-border spinner-border-sm me-2"></span>
              <i
                v-else
                :class="[
                  'ki-duotone fs-3 me-2',
                  actionType === 'approve' ? 'ki-check' : 'ki-cross',
                ]"
              >
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ actionType === 'approve' ? 'Approve Request' : 'Reject Request' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Filter Modal -->
    <div
      v-if="showFilterModal"
      class="modal d-flex show position-fixed w-100 h-100"
      style="background: rgba(0, 0, 0, 0.8); z-index: 9999"
    >
      <div class="modal-dialog modal-dialog-centered mx-3 mx-md-auto">
        <div class="modal-content border-0 shadow-lg rounded-4">
          <div class="modal-header bg-light-primary border-0 p-4">
            <h3 class="modal-title fw-bold text-primary">Filter Approvals</h3>
            <button @click="showFilterModal = false" class="btn btn-sm btn-icon btn-light">
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body p-4">
            <div class="row g-3">
              <div class="col-6" v-for="filter in filterOptions" :key="filter.key">
                <button
                  @click="handleFilterClick(filter.key)"
                  :class="[
                    'btn w-100 p-4 text-start',
                    activeFilter === filter.key ? 'btn-primary' : 'btn-light-primary',
                  ]"
                >
                  <div class="d-flex align-items-center">
                    <i :class="filter.icon + ' fs-2 me-3'">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div>
                      <div class="fw-bold">{{ filter.label }}</div>
                      <div class="text-muted fs-7">{{ filter.count }} items</div>
                    </div>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch, nextTick } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// Enhanced Reactive State
const loading = ref(false)
const refreshing = ref(false)
const processing = ref(false)
const loadingMore = ref(false)
const stationLoading = ref(false)
const selectedStation = ref(null)
const userStations = ref([])
const currentUser = ref(null)
const authToken = ref(null)

// Enhanced UI State
const showFilterModal = ref(false)
const activeFilter = ref('all')
const currentPage = ref(1)
const pageSize = 20
const hasMoreApprovals = ref(false)
const commentsTouched = ref(false)

// Chart Configuration
const chartPeriod = ref('7d')
const approvalChart = ref(null)
const chartData = reactive({
  approved: 0,
  rejected: 0,
  avgTime: '2.5h',
})

// Enhanced Approval Data
const pendingApprovals = ref([])
const totalApprovals = ref(0)
const approvalStats = reactive({
  pending: 0,
  urgent: 0,
  todayProcessed: 0,
  overdue: 0,
  avgResponseTime: 0,
  completionRate: 0,
})

// Action Modal Enhanced
const showActionModal = ref(false)
const selectedApproval = ref(null)
const actionType = ref('approve')
const actionComments = ref('')

// Enhanced Computed Properties
const filterOptions = computed(() => [
  {
    key: 'all',
    label: 'All',
    icon: 'ki-duotone ki-menu',
    count: pendingApprovals.value.length,
  },
  {
    key: 'urgent',
    label: 'Urgent',
    icon: 'ki-duotone ki-timer',
    count: pendingApprovals.value.filter((a) => isUrgent(a)).length,
  },
  {
    key: 'overdue',
    label: 'Overdue',
    icon: 'ki-duotone ki-calendar',
    count: pendingApprovals.value.filter((a) => isOverdue(a)).length,
  },
  {
    key: 'high',
    label: 'High Priority',
    icon: 'ki-duotone ki-arrow-up',
    count: pendingApprovals.value.filter((a) => a.Priority === 'High').length,
  },
  {
    key: 'financial',
    label: 'Financial',
    icon: 'ki-duotone ki-dollar',
    count: pendingApprovals.value.filter((a) => isFinancialApproval(a)).length,
  },
  {
    key: 'operational',
    label: 'Operational',
    icon: 'ki-duotone ki-setting-3',
    count: pendingApprovals.value.filter((a) => isOperationalApproval(a)).length,
  },
])

const filteredApprovals = computed(() => {
  let filtered = pendingApprovals.value

  switch (activeFilter.value) {
    case 'urgent':
      filtered = filtered.filter((a) => isUrgent(a))
      break
    case 'overdue':
      filtered = filtered.filter((a) => isOverdue(a))
      break
    case 'high':
      filtered = filtered.filter((a) => a.Priority === 'High')
      break
    case 'financial':
      filtered = filtered.filter((a) => isFinancialApproval(a))
      break
    case 'operational':
      filtered = filtered.filter((a) => isOperationalApproval(a))
      break
  }

  return filtered.sort((a, b) => {
    // Enhanced sorting logic
    const aUrgent = isUrgent(a) ? 1 : 0
    const bUrgent = isUrgent(b) ? 1 : 0
    const aOverdue = isOverdue(a) ? 1 : 0
    const bOverdue = isOverdue(b) ? 1 : 0

    // Priority order: Overdue > Urgent > High Priority > Normal > Low
    if (aOverdue !== bOverdue) return bOverdue - aOverdue
    if (aUrgent !== bUrgent) return bUrgent - aUrgent

    const priorityOrder = { High: 3, Normal: 2, Low: 1 }
    const aPriority = priorityOrder[a.Priority] || 1
    const bPriority = priorityOrder[b.Priority] || 1

    if (aPriority !== bPriority) return bPriority - aPriority

    return new Date(b.RequestDate) - new Date(a.RequestDate)
  })
})

const paginatedApprovals = computed(() => {
  const start = 0
  const end = currentPage.value * pageSize
  return filteredApprovals.value.slice(start, end)
})

function handleFilterClick(key) {
  setActiveFilter(key)
  showFilterModal.value = false
}

// Enhanced Authentication
const initializeAuth = () => {
  try {
    const authData = localStorage.getItem('kigrama_user_data')
    const token = localStorage.getItem('kigrama_auth_token')

    if (authData && token) {
      const userData = JSON.parse(authData)
      currentUser.value = userData.user
      authToken.value = token
      userStations.value = userData.stations || []

      console.log('🔐 Enhanced Auth initialized:', {
        user: currentUser.value?.name,
        stations: userStations.value.length,
        permissions: userData.permissions?.length || 0,
        roles: userData.roles?.length || 0,
      })

      // Validate token expiration
      if (isTokenExpired(token)) {
        console.warn('⚠️ Token expired, redirecting to login')
        redirectToLogin()
        return
      }
    } else {
      console.error('❌ No authentication data found')
      redirectToLogin()
    }
  } catch (error) {
    console.error('❌ Auth initialization failed:', error)
    redirectToLogin()
  }
}

const isTokenExpired = (token) => {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]))
    return payload.exp * 1000 < Date.now()
  } catch {
    return true
  }
}

const redirectToLogin = () => {
  localStorage.removeItem('kigrama_auth_token')
  localStorage.removeItem('kigrama_user_data')
  localStorage.removeItem('kigrama_selected_station')
  window.location.href = '/login'
}

// Enhanced Station Selection
const selectStation = async (station) => {
  stationLoading.value = true

  try {
    selectedStation.value = station
    localStorage.setItem('kigrama_selected_station', JSON.stringify(station))

    await Swal.fire({
      title: 'Station Selected!',
      text: `Now working at ${station.StationName}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
      background: '#f8f9fa',
    })

    // Load initial data
    await Promise.all([loadApprovals(), loadApprovalStats(), loadChartData()])
  } catch (error) {
    console.error('Station selection failed:', error)
    await Swal.fire({
      title: 'Error!',
      text: 'Failed to select station',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    stationLoading.value = false
  }
}

// Enhanced API Helper with retry logic
const makeApiCall = async (endpoint, options = {}, retries = 3) => {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(`${API_BASE_URL}${endpoint}`, {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken.value}`,
          ...options.headers,
        },
        timeout: 10000,
        ...options,
      })

      if (response.status === 401) {
        console.warn('🔓 Unauthorized, token may be expired')
        redirectToLogin()
        return
      }

      if (!response.ok) {
        throw new Error(`API call failed: ${response.status} ${response.statusText}`)
      }

      return await response.json()
    } catch (error) {
      console.error(`API Error (attempt ${i + 1}):`, error)
      if (i === retries - 1) throw error
      await new Promise((resolve) => setTimeout(resolve, 1000 * (i + 1))) // Exponential backoff
    }
  }
}

// Enhanced Load Approvals with comprehensive error handling
const loadApprovals = async (showLoader = true) => {
  if (!currentUser.value || !selectedStation.value) return

  if (showLoader) loading.value = true

  try {
    // Parallel loading for better performance
    const [userApprovalsResponse, userRolesData] = await Promise.all([
      makeApiCall(`/PendingApprovalsByUser?CurrentApproverUserID=${currentUser.value.id}`),
      getUserRoles(),
    ])

    let allApprovals = userApprovalsResponse.records || []

    // Load role-based approvals
    if (userRolesData.length > 0) {
      const roleApprovalPromises = userRolesData.map((role) =>
        makeApiCall(`/PendingApprovalsByRole?CurrentApproverRoleID=${role.RoleID}`)
          .then((response) => response.records || [])
          .catch((error) => {
            console.warn(`Failed to load approvals for role ${role.RoleID}:`, error)
            return []
          }),
      )

      const roleApprovals = await Promise.all(roleApprovalPromises)
      allApprovals = [...allApprovals, ...roleApprovals.flat()]
    }

    // Enhanced deduplication and enrichment
    const uniqueApprovals = deduplicateApprovals(allApprovals)
    const enrichedApprovals = await enrichApprovalData(uniqueApprovals)

    pendingApprovals.value = enrichedApprovals
    totalApprovals.value = enrichedApprovals.length

    // Update pagination
    hasMoreApprovals.value = filteredApprovals.value.length > currentPage.value * pageSize

    // Update statistics
    updateEnhancedStats()

    // Update chart
    await nextTick()
    renderEnhancedChart()
  } catch (error) {
    console.error('Failed to load approvals:', error)
    await handleLoadError(error)
  } finally {
    if (showLoader) loading.value = false
    refreshing.value = false
  }
}

const getUserRoles = async () => {
  try {
    const userData = JSON.parse(localStorage.getItem('kigrama_user_data'))
    return userData?.roles || []
  } catch {
    return []
  }
}

const deduplicateApprovals = (approvals) => {
  const seen = new Set()
  return approvals.filter((approval) => {
    if (seen.has(approval.ApprovalID)) return false
    seen.add(approval.ApprovalID)
    return true
  })
}

const enrichApprovalData = async (approvals) => {
  return approvals.map((approval) => ({
    ...approval,
    _isUrgent: isUrgent(approval),
    _isOverdue: isOverdue(approval),
    _daysOpen: getDaysOpen(approval),
    _requesterName: approval.RequesterName || 'Unknown User',
    _formattedAmount: approval.RequestAmount ? formatCurrency(approval.RequestAmount) : null,
  }))
}

// Enhanced Statistics
const updateEnhancedStats = () => {
  const now = new Date()
  const today = now.toDateString()

  approvalStats.pending = pendingApprovals.value.length
  approvalStats.urgent = pendingApprovals.value.filter((a) => a._isUrgent).length
  approvalStats.overdue = pendingApprovals.value.filter((a) => a._isOverdue).length

  // Calculate today's processed (simulated with realistic data)
  const baseProcessed = Math.floor(Math.random() * 10) + 5
  const hourBonus = Math.floor((now.getHours() - 8) / 2) // More processed later in day
  approvalStats.todayProcessed = Math.max(0, baseProcessed + hourBonus)

  // Calculate average response time (simulated)
  approvalStats.avgResponseTime = calculateAvgResponseTime()

  // Calculate completion rate (simulated)
  approvalStats.completionRate = Math.min(95, 70 + Math.random() * 25)
}

const calculateAvgResponseTime = () => {
  if (pendingApprovals.value.length === 0) return 0

  const totalHours = pendingApprovals.value.reduce((sum, approval) => {
    const created = new Date(approval.RequestDate)
    const hours = (Date.now() - created.getTime()) / (1000 * 60 * 60)
    return sum + Math.min(hours, 72) // Cap at 72 hours for average
  }, 0)

  return Math.round((totalHours / pendingApprovals.value.length) * 10) / 10
}

// Enhanced Chart
const loadChartData = async () => {
  try {
    // Simulate loading chart data based on period
    const days = chartPeriod.value === '7d' ? 7 : chartPeriod.value === '30d' ? 30 : 90

    chartData.approved = Math.floor(Math.random() * days * 3) + days
    chartData.rejected = Math.floor(Math.random() * days) + Math.floor(days / 2)
    chartData.avgTime = (Math.random() * 4 + 1).toFixed(1) + 'h'
  } catch (error) {
    console.error('Failed to load chart data:', error)
  }
}

const renderEnhancedChart = () => {
  if (!approvalChart.value) return

  const ctx = approvalChart.value.getContext('2d')
  const canvas = approvalChart.value

  // Clear canvas
  ctx.clearRect(0, 0, canvas.width, canvas.height)

  // Enhanced chart with multiple data series
  const data = generateChartData()
  renderModernLineChart(ctx, canvas, data)
}

const generateChartData = () => {
  const period = chartPeriod.value === '7d' ? 7 : chartPeriod.value === '30d' ? 30 : 90
  const labels = []
  const approvedData = []
  const rejectedData = []
  const pendingData = []

  for (let i = period - 1; i >= 0; i--) {
    const date = new Date()
    date.setDate(date.getDate() - i)

    if (period === 7) {
      labels.push(date.toLocaleDateString('en-US', { weekday: 'short' }))
    } else if (period === 30) {
      labels.push(date.getDate().toString())
    } else {
      labels.push(date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }))
    }

    // Generate realistic data
    const dayOfWeek = date.getDay()
    const isWeekend = dayOfWeek === 0 || dayOfWeek === 6
    const baseActivity = isWeekend ? 2 : 8

    approvedData.push(Math.floor(Math.random() * baseActivity) + baseActivity)
    rejectedData.push(Math.floor(Math.random() * (baseActivity / 2)) + 1)
    pendingData.push(Math.floor(Math.random() * (baseActivity / 3)) + 2)
  }

  return { labels, approvedData, rejectedData, pendingData }
}

const renderModernLineChart = (ctx, canvas, data) => {
  const padding = 40
  const width = canvas.width - 2 * padding
  const height = canvas.height - 2 * padding

  // Find max value for scaling
  const maxValue = Math.max(
    Math.max(...data.approvedData),
    Math.max(...data.rejectedData),
    Math.max(...data.pendingData),
  )

  // Draw grid lines
  ctx.strokeStyle = '#f1f1f2'
  ctx.lineWidth = 1
  for (let i = 0; i <= 5; i++) {
    const y = padding + (i * height) / 5
    ctx.beginPath()
    ctx.moveTo(padding, y)
    ctx.lineTo(padding + width, y)
    ctx.stroke()
  }

  // Draw approved line
  drawChartLine(ctx, data.approvedData, data.labels, maxValue, padding, width, height, '#50cd89', 3)

  // Draw rejected line
  drawChartLine(ctx, data.rejectedData, data.labels, maxValue, padding, width, height, '#f1416c', 3)

  // Draw pending line
  drawChartLine(ctx, data.pendingData, data.labels, maxValue, padding, width, height, '#ffc700', 3)
}

const drawChartLine = (ctx, data, labels, maxValue, padding, width, height, color, lineWidth) => {
  ctx.strokeStyle = color
  ctx.lineWidth = lineWidth
  ctx.lineCap = 'round'
  ctx.lineJoin = 'round'

  ctx.beginPath()
  data.forEach((value, index) => {
    const x = padding + (index * width) / (labels.length - 1)
    const y = padding + height - (value / maxValue) * height

    if (index === 0) {
      ctx.moveTo(x, y)
    } else {
      ctx.lineTo(x, y)
    }
  })
  ctx.stroke()

  // Draw points
  ctx.fillStyle = color
  data.forEach((value, index) => {
    const x = padding + (index * width) / (labels.length - 1)
    const y = padding + height - (value / maxValue) * height

    ctx.beginPath()
    ctx.arc(x, y, 4, 0, 2 * Math.PI)
    ctx.fill()
  })
}

// Enhanced Utility Functions
const isUrgent = (approval) => {
  if (!approval.DueDate) return false
  const dueDate = new Date(approval.DueDate)
  const now = new Date()
  const hoursUntilDue = (dueDate - now) / (1000 * 60 * 60)
  return hoursUntilDue <= 24 && hoursUntilDue > 0
}

const isOverdue = (approval) => {
  if (!approval.DueDate) return false
  return new Date(approval.DueDate) < new Date()
}

const isFinancialApproval = (approval) => {
  const financialTypes = ['Purchase Order', 'Payment', 'Budget', 'Expense', 'Invoice']
  return financialTypes.some((type) => approval.RequestType?.includes(type))
}

const isOperationalApproval = (approval) => {
  const operationalTypes = ['Stock Adjustment', 'Transfer', 'Variance', 'Maintenance']
  return operationalTypes.some((type) => approval.RequestType?.includes(type))
}

const getDaysOpen = (approval) => {
  const created = new Date(approval.RequestDate)
  const now = new Date()
  return Math.floor((now - created) / (1000 * 60 * 60 * 24))
}

const getTotalLevels = (approval) => {
  // Estimate based on approval type and amount
  if (approval.RequestAmount) {
    const amount = parseFloat(approval.RequestAmount)
    if (amount > 10000000) return '7' // > 10M UGX
    if (amount > 5000000) return '5' // > 5M UGX
    if (amount > 1000000) return '3' // > 1M UGX
  }
  return '3' // Default
}

const formatDate = (dateString) => {
  if (!dateString) return 'N/A'
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

const formatRelativeTime = (dateString) => {
  if (!dateString) return 'Unknown'

  const date = new Date(dateString)
  const now = new Date()
  const diffMs = now - date
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60))
  const diffDays = Math.floor(diffHours / 24)

  if (diffHours < 1) return 'Just now'
  if (diffHours < 24) return `${diffHours}h ago`
  if (diffDays < 7) return `${diffDays}d ago`
  return formatDate(dateString)
}

const formatCurrency = (amount) => {
  const numAmount = parseFloat(amount)
  if (numAmount >= 1000000) {
    return `UGX ${(numAmount / 1000000).toFixed(1)}M`
  }
  if (numAmount >= 1000) {
    return `UGX ${(numAmount / 1000).toFixed(0)}K`
  }
  return `UGX ${numAmount.toLocaleString()}`
}

// Enhanced Styling Functions
const getApprovalCardClass = (approval) => {
  let classes = 'fade-in-up'

  if (approval._isOverdue) {
    classes += ' border-danger border-2'
  } else if (approval._isUrgent) {
    classes += ' border-warning border-2'
  } else if (approval.Priority === 'High') {
    classes += ' border-primary border-2'
  }

  return classes
}

const getApprovalIconBg = (requestType) => {
  const backgrounds = {
    'Purchase Order': 'symbol-circle bg-gradient-success',
    'Stock Adjustment': 'symbol-circle bg-gradient-warning',
    'Price Change': 'symbol-circle bg-gradient-info',
    Transfer: 'symbol-circle bg-gradient-primary',
    Variance: 'symbol-circle bg-gradient-danger',
    Payment: 'symbol-circle bg-gradient-dark',
    Budget: 'symbol-circle bg-gradient-secondary',
  }
  return backgrounds[requestType] || 'symbol-circle bg-gradient-secondary'
}

const getApprovalIconClass = (requestType) => {
  const icons = {
    'Purchase Order': 'ki-duotone ki-basket',
    'Stock Adjustment': 'ki-duotone ki-setting-3',
    'Price Change': 'ki-duotone ki-price-tag',
    Transfer: 'ki-duotone ki-arrow-right',
    Variance: 'ki-duotone ki-warning-2',
    Payment: 'ki-duotone ki-dollar',
    Budget: 'ki-duotone ki-chart-pie',
  }
  return icons[requestType] || 'ki-duotone ki-document'
}

const getPriorityBadge = (priority) => {
  const badges = {
    High: 'badge badge-light-danger fw-bold',
    Normal: 'badge badge-light-primary fw-bold',
    Low: 'badge badge-light-secondary fw-bold',
  }
  return badges[priority] || 'badge badge-light-secondary fw-bold'
}

const getStatusBadge = (status) => {
  const badges = {
    Pending: 'badge badge-light-warning fw-bold',
    'In Progress': 'badge badge-light-info fw-bold',
    Approved: 'badge badge-light-success fw-bold',
    Rejected: 'badge badge-light-danger fw-bold',
  }
  return badges[status] || 'badge badge-light-secondary fw-bold'
}

const getStatPercentage = (statType) => {
  const max = Math.max(
    approvalStats.pending,
    approvalStats.urgent,
    approvalStats.overdue,
    approvalStats.todayProcessed,
  )

  if (max === 0) return 0

  const value = approvalStats[statType] || 0
  return Math.round((value / max) * 100)
}

const getEmptyStateTitle = () => {
  const titles = {
    all: 'All Caught Up!',
    urgent: 'No Urgent Approvals',
    overdue: 'No Overdue Items',
    high: 'No High Priority Items',
    financial: 'No Financial Approvals',
    operational: 'No Operational Approvals',
  }
  return titles[activeFilter.value] || 'No Approvals Found'
}

const getEmptyStateDescription = () => {
  const descriptions = {
    all: 'You have no pending approvals at the moment. Great job!',
    urgent: 'All urgent items have been handled.',
    overdue: 'No overdue approvals. Excellent work!',
    high: 'No high priority items need your attention.',
    financial: 'No financial approvals are pending.',
    operational: 'No operational approvals are waiting.',
  }
  return descriptions[activeFilter.value] || 'Try adjusting your filters or refresh the data.'
}

// Enhanced Action Functions
const setActiveFilter = (filterKey) => {
  activeFilter.value = filterKey
  currentPage.value = 1 // Reset pagination
  hasMoreApprovals.value = filteredApprovals.value.length > pageSize
}

const approveRequest = (approval) => {
  selectedApproval.value = approval
  actionType.value = 'approve'
  actionComments.value = ''
  commentsTouched.value = false
  showActionModal.value = true
}

const rejectRequest = (approval) => {
  selectedApproval.value = approval
  actionType.value = 'reject'
  actionComments.value = ''
  commentsTouched.value = false
  showActionModal.value = true
}

const viewDetails = async (approval) => {
  try {
    const details = await makeApiCall(`/Approvals/${approval.ApprovalID}`)

    // Enhanced detail view with more information
    const detailHtml = `
      <div class="text-start">
        <div class="row g-3 mb-4">
          <div class="col-6">
            <div class="fw-bold text-gray-600 fs-7">Request Type</div>
            <div class="text-gray-900 fw-semibold">${approval.RequestType}</div>
          </div>
          <div class="col-6">
            <div class="fw-bold text-gray-600 fs-7">Priority</div>
            <span class="${getPriorityBadge(approval.Priority)}">${approval.Priority}</span>
          </div>
          <div class="col-6">
            <div class="fw-bold text-gray-600 fs-7">Requester</div>
            <div class="text-gray-900 fw-semibold">${approval.RequesterName || 'Unknown'}</div>
          </div>
          <div class="col-6">
            <div class="fw-bold text-gray-600 fs-7">Amount</div>
            <div class="text-gray-900 fw-semibold">${approval.RequestAmount ? formatCurrency(approval.RequestAmount) : 'N/A'}</div>
          </div>
          <div class="col-6">
            <div class="fw-bold text-gray-600 fs-7">Level</div>
            <div class="text-gray-900 fw-semibold">${approval.CurrentApprovalLevel} of ${getTotalLevels(approval)}</div>
          </div>
          <div class="col-6">
            <div class="fw-bold text-gray-600 fs-7">Days Open</div>
            <div class="text-gray-900 fw-semibold">${getDaysOpen(approval)} days</div>
          </div>
        </div>
        ${
          approval.RequestDetails
            ? `
          <div class="mb-4">
            <div class="fw-bold text-gray-600 fs-7 mb-2">Request Details</div>
            <div class="bg-light-secondary p-3 rounded text-gray-700">${approval.RequestDetails}</div>
          </div>
        `
            : ''
        }
      </div>
    `

    await Swal.fire({
      title: approval.RequestTitle,
      html: detailHtml,
      icon: 'info',
      confirmButtonText: 'Close',
      confirmButtonColor: '#3699ff',
      width: '600px',
      customClass: {
        popup: 'rounded-4',
      },
    })
  } catch (error) {
    console.error('Failed to load approval details:', error)
    await Swal.fire({
      title: 'Error!',
      text: 'Failed to load approval details',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
}

const confirmAction = async () => {
  if (actionType.value === 'reject' && !actionComments.value.trim()) {
    commentsTouched.value = true
    return
  }

  processing.value = true

  try {
    // Enhanced action logging with more metadata
    const actionData = {
      ApprovalID: selectedApproval.value.ApprovalID,
      StepID: null,
      UserID: currentUser.value.id,
      ActionType: actionType.value === 'approve' ? 'Approved' : 'Rejected',
      ActionDate: new Date().toISOString(),
      Comments: actionComments.value || null,
      IPAddress: await getClientIP(),
      UserAgent: navigator.userAgent,
    }

    await makeApiCall('/ApprovalActions', {
      method: 'POST',
      body: JSON.stringify(actionData),
    })

    // Enhanced status update
    const statusUpdate = {
      Status: actionType.value === 'approve' ? 'Approved' : 'Rejected',
      UpdatedAt: new Date().toISOString(),
    }

    if (actionType.value === 'approve') {
      statusUpdate.CompletedAt = new Date().toISOString()

      // Check if this completes the approval chain
      const currentLevel = parseInt(selectedApproval.value.CurrentApprovalLevel)
      const totalLevels = parseInt(getTotalLevels(selectedApproval.value))

      if (currentLevel < totalLevels) {
        statusUpdate.CurrentApprovalLevel = (currentLevel + 1).toString()
        statusUpdate.Status = 'Pending' // Still pending at next level
      }
    }

    await makeApiCall(`/Approvals/${selectedApproval.value.ApprovalID}`, {
      method: 'PATCH',
      body: JSON.stringify(statusUpdate),
    })

    // Enhanced success notification
    await Swal.fire({
      title: actionType.value === 'approve' ? '✅ Approved!' : '❌ Rejected!',
      text: `Request ${actionType.value === 'approve' ? 'approved' : 'rejected'} successfully`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 4000,
      showConfirmButton: false,
      background: '#f8f9fa',
      customClass: {
        popup: 'rounded-4',
      },
    })

    closeActionModal()
    await loadApprovals(false) // Reload without showing main loader
  } catch (error) {
    console.error('Action failed:', error)
    await handleActionError(error)
  } finally {
    processing.value = false
  }
}

const closeActionModal = () => {
  showActionModal.value = false
  selectedApproval.value = null
  actionComments.value = ''
  commentsTouched.value = false
}

// Enhanced Error Handling
const handleLoadError = async (error) => {
  if (error.message.includes('401') || error.message.includes('Unauthorized')) {
    await Swal.fire({
      title: 'Session Expired',
      text: 'Please log in again to continue',
      icon: 'warning',
      confirmButtonText: 'Login',
      confirmButtonColor: '#3699ff',
    })
    redirectToLogin()
    return
  }

  await Swal.fire({
    title: 'Unable to Load Approvals',
    text: 'Please check your connection and try again',
    icon: 'error',
    showCancelButton: true,
    confirmButtonText: 'Retry',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#3699ff',
    cancelButtonColor: '#f1416c',
  }).then((result) => {
    if (result.isConfirmed) {
      loadApprovals()
    }
  })
}

const handleActionError = async (error) => {
  const errorMessage = error.message.includes('Network')
    ? 'Network error. Please check your connection.'
    : 'An unexpected error occurred. Please try again.'

  await Swal.fire({
    title: 'Action Failed',
    text: errorMessage,
    icon: 'error',
    confirmButtonColor: '#f1416c',
  })
}

// Enhanced Refresh
const refreshApprovals = async () => {
  refreshing.value = true

  try {
    await Promise.all([loadApprovals(false), loadApprovalStats(), loadChartData()])

    await Swal.fire({
      title: 'Refreshed!',
      text: 'Approval data has been updated',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Refresh failed:', error)
  }
}

// Enhanced Load More
const loadMoreApprovals = async () => {
  loadingMore.value = true

  try {
    currentPage.value++
    hasMoreApprovals.value = filteredApprovals.value.length > currentPage.value * pageSize

    // Simulate loading delay for UX
    await new Promise((resolve) => setTimeout(resolve, 500))
  } catch (error) {
    console.error('Load more failed:', error)
    currentPage.value-- // Revert on error
  } finally {
    loadingMore.value = false
  }
}

// Enhanced Chart Update
const updateChart = async () => {
  await loadChartData()
  await nextTick()
  renderEnhancedChart()
}

// Utility Functions
const getClientIP = async () => {
  try {
    // In a real app, you'd call an IP service
    return 'client_ip_placeholder'
  } catch {
    return 'unknown'
  }
}

const loadApprovalStats = async () => {
  // In a real implementation, this would call actual analytics endpoints
  updateEnhancedStats()
}

// Enhanced Watchers
watch(activeFilter, () => {
  console.log('Filter changed to:', activeFilter.value)
  hasMoreApprovals.value = filteredApprovals.value.length > pageSize
})

watch(selectedStation, (newStation) => {
  if (newStation) {
    console.log('Selected station changed to:', newStation.StationName)
  }
})

// Enhanced Component Initialization
onMounted(async () => {
  console.log('🚀 Enhanced UserApprovalsHub mounted')

  initializeAuth()

  // Check for saved station
  const savedStation = localStorage.getItem('kigrama_selected_station')
  if (savedStation && currentUser.value) {
    try {
      selectedStation.value = JSON.parse(savedStation)
      await Promise.all([loadApprovals(), loadApprovalStats(), loadChartData()])
    } catch (error) {
      console.error('Failed to load saved station data:', error)
      localStorage.removeItem('kigrama_selected_station')
    }
  }
})
</script>

<style scoped>
/* Enhanced Animations */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes rotating {
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
}

.fade-in-up {
  animation: fadeInUp 0.5s ease-out forwards;
}

.rotating {
  animation: rotating 1s linear infinite;
}

/* Enhanced Hover Effects */
.hover-elevate-up {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.hover-elevate-up:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15) !important;
}

/* Enhanced Modal Styling */
.modal.show {
  display: flex !important;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(5px);
}

.modal-content {
  animation: fadeInUp 0.3s ease-out;
}

/* Enhanced Symbol Styling */
.symbol-circle {
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  overflow: hidden;
}

/* Enhanced Progress Bars */
.progress {
  border-radius: 10px;
  overflow: hidden;
}

.progress-bar {
  border-radius: 10px;
  transition: width 0.6s ease;
}

/* Enhanced Chart Container */
canvas {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
}

/* Enhanced Mobile Optimizations */
@media (max-width: 768px) {
  .modal-dialog {
    margin: 0.5rem;
    max-width: calc(100% - 1rem);
  }

  .card-body {
    padding: 1rem !important;
  }

  .btn-lg {
    min-height: 48px;
    font-size: 1rem;
  }

  .fs-2x {
    font-size: 1.8rem !important;
  }

  .symbol-50px {
    width: 40px !important;
    height: 40px !important;
  }
}

@media (max-width: 576px) {
  .container-fluid {
    padding-left: 1rem !important;
    padding-right: 1rem !important;
  }

  .fs-3x {
    font-size: 2rem !important;
  }

  .card-header {
    padding: 1rem !important;
  }
}

/* Enhanced Button Styling */
.btn {
  transition: all 0.2s ease;
  border-radius: 8px;
}

.btn:hover {
  transform: translateY(-1px);
}

.btn-lg {
  min-height: 48px;
  padding: 0.75rem 1.5rem;
}

/* Enhanced Badge Styling */
.badge {
  font-size: 0.75rem;
  padding: 0.4rem 0.8rem;
  border-radius: 6px;
  font-weight: 600;
}

.badge-circle {
  border-radius: 50%;
  width: 20px;
  height: 20px;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.7rem;
}

/* Enhanced Loading States */
.spinner-border {
  border-width: 2px;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
  border-width: 1px;
}

/* Enhanced Gradients */
.bg-gradient-primary {
  background: linear-gradient(135deg, #3699ff 0%, #0d69f2 100%);
}

.bg-gradient-success {
  background: linear-gradient(135deg, #50cd89 0%, #00a524 100%);
}

.bg-gradient-warning {
  background: linear-gradient(135deg, #ffc700 0%, #ff8f00 100%);
}

.bg-gradient-danger {
  background: linear-gradient(135deg, #f1416c 0%, #d41443 100%);
}

.bg-gradient-info {
  background: linear-gradient(135deg, #7239ea 0%, #5014d0 100%);
}

/* Enhanced Z-Index Management */
.z-index-2 {
  z-index: 1020;
}

.z-index-3 {
  z-index: 1030;
}

/* Enhanced Borders */
.border-2 {
  border-width: 2px !important;
}

.rounded-3 {
  border-radius: 0.5rem !important;
}

.rounded-4 {
  border-radius: 0.75rem !important;
}

/* Enhanced Typography */
.fw-bolder {
  font-weight: 700 !important;
}

/* Enhanced Spacing */
.min-h-50px {
  min-height: 50px;
}

/* Enhanced Touch Targets */
@media (max-width: 768px) {
  .btn,
  button {
    min-height: 44px;
    min-width: 44px;
  }

  .form-control {
    min-height: 44px;
  }

  .form-select {
    min-height: 44px;
  }
}

/* Enhanced Accessibility */
.btn:focus,
.form-control:focus,
.form-select:focus {
  box-shadow: 0 0 0 3px rgba(54, 153, 255, 0.25);
  outline: none;
}

/* Enhanced Responsive Utilities */
@media (max-width: 480px) {
  .row.g-3 {
    --bs-gutter-x: 0.75rem;
    --bs-gutter-y: 0.75rem;
  }

  .gap-2 {
    gap: 0.375rem !important;
  }

  .gap-3 {
    gap: 0.75rem !important;
  }
}
</style>

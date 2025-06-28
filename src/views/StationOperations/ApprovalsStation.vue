<template>
  <div class="container-fluid p-4 bg-light-primary min-vh-100">
    <!-- Authority Gate - RBAC Control -->
    <div v-if="!hasApprovalAuthority" class="text-center py-20">
      <div class="card card-flush border-0 shadow-lg">
        <div class="card-body p-10">
          <i class="ki-duotone ki-security-user fs-3x text-danger mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
          </i>
          <h3 class="text-gray-900 fw-bolder fs-2 mb-3">Approval Access Restricted</h3>
          <p class="text-gray-600 fs-4 mb-5">
            Only authorized approvers can access the approval management system.
          </p>
          <div class="bg-light-warning rounded-3 p-4 mb-5">
            <p class="text-warning fw-bold mb-2">Your Current Authorization:</p>
            <p class="text-gray-700 mb-0">{{ currentUserRole }} - {{ currentUserPosition }}</p>
            <p class="text-gray-700 mb-0">Station: {{ userStation?.StationName }}</p>
          </div>
          <button @click="requestApprovalAccess" class="btn btn-light-primary">
            <i class="ki-duotone ki-message-question fs-4 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Request Approval Access
          </button>
        </div>
      </div>
    </div>

    <!-- Main Approval Management Interface -->
    <div v-else>
      <!-- AI Fraud Detection Alert -->
      <div
        v-if="currentFraudAlert"
        class="alert alert-dismissible bg-light-danger border-danger mb-6"
      >
        <div class="d-flex align-items-center">
          <i class="ki-duotone ki-security-check fs-2x text-danger me-4">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
            <span class="path5"></span>
            <span class="path6"></span>
          </i>
          <div class="flex-grow-1">
            <h5 class="text-danger fw-bold mb-1">🚨 AI Fraud Detection Alert</h5>
            <p class="text-gray-800 mb-0">{{ currentFraudAlert.description }}</p>
            <div class="fs-7 text-gray-600 mt-1">
              Risk Score: {{ currentFraudAlert.riskScore }}% • Severity:
              {{ currentFraudAlert.severity }}
            </div>
          </div>
          <button type="button" class="btn btn-sm btn-light-danger me-2" @click="investigateFraud">
            Investigate
          </button>
          <button type="button" class="btn-close" @click="currentFraudAlert = null"></button>
        </div>
      </div>

      <!-- Enhanced Header with Real-Time Metrics -->
      <div class="card card-flush border-0 shadow-lg mb-6">
        <div class="card-body p-6">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
            <div class="d-flex align-items-center gap-4">
              <div class="symbol symbol-60px symbol-circle bg-light-success">
                <i class="ki-duotone ki-security-check fs-2x text-success">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
              </div>
              <div>
                <h1 class="text-gray-900 fw-bolder fs-2 mb-1">Approval Management Center</h1>
                <p class="text-gray-600 fs-5 mb-0">
                  {{ userStation?.StationName || 'System-wide Approvals' }}
                </p>
                <div class="badge badge-light-info fs-7 mt-1">
                  {{ approverLevel }} • {{ currentUserRole }}
                </div>
              </div>
            </div>
            <div class="d-flex align-items-center gap-2">
              <div class="text-end me-3">
                <div class="text-gray-900 fw-bold fs-6">Approval Authority</div>
                <div class="badge" :class="authorityBadge">{{ authorityLevel }}</div>
              </div>
              <button @click="showApprovalStats" class="btn btn-light-info btn-sm">
                <i class="ki-duotone ki-chart-simple fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                </i>
              </button>
              <button
                @click="refreshApprovalData"
                class="btn btn-light-primary btn-sm"
                :disabled="loading"
              >
                <i
                  class="ki-duotone ki-arrows-circle fs-4"
                  :class="{ 'spinner-border spinner-border-sm': loading }"
                >
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
            </div>
          </div>

          <!-- Real-Time Approval Metrics Dashboard -->
          <div class="row g-4 mt-5">
            <div class="col-lg-3 col-md-6">
              <div class="bg-light-danger rounded-4 p-4 text-center">
                <i class="ki-duotone ki-time fs-3x text-danger mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="text-danger fw-bolder fs-2">{{ pendingApprovals.length }}</div>
                <div class="text-gray-600 fw-bold fs-7">Pending Approvals</div>
              </div>
            </div>
            <div class="col-lg-3 col-md-6">
              <div class="bg-light-warning rounded-4 p-4 text-center">
                <i class="ki-duotone ki-security-check fs-3x text-warning mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
                <div class="text-warning fw-bolder fs-2">{{ highRiskApprovals }}</div>
                <div class="text-gray-600 fw-bold fs-7">High Risk Items</div>
              </div>
            </div>
            <div class="col-lg-3 col-md-6">
              <div class="bg-light-info rounded-4 p-4 text-center">
                <i class="ki-duotone ki-chart-line-up fs-3x text-info mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="text-info fw-bolder fs-2">{{ approvalVelocity }}%</div>
                <div class="text-gray-600 fw-bold fs-7">24h Velocity</div>
              </div>
            </div>
            <div class="col-lg-3 col-md-6">
              <div class="bg-light-success rounded-4 p-4 text-center">
                <i class="ki-duotone ki-verify fs-3x text-success mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
                <div class="text-success fw-bolder fs-2">{{ completedToday }}</div>
                <div class="text-gray-600 fw-bold fs-7">Completed Today</div>
              </div>
            </div>
          </div>

          <!-- Auto-Detected Approver Context -->
          <div class="card border border-success mt-5">
            <div class="card-header bg-light-success">
              <h5 class="text-success fw-bold mb-0">
                <i class="ki-duotone ki-user-tick fs-4 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                Auto-Detected Approver Session
              </h5>
            </div>
            <div class="card-body">
              <div class="row g-4">
                <div class="col-md-3">
                  <div class="bg-light-success rounded-3 p-3 text-center">
                    <div class="text-success fw-bold fs-6">{{ currentUser?.name }}</div>
                    <div class="text-gray-600 fs-8">Approver</div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="bg-light-primary rounded-3 p-3 text-center">
                    <div class="text-primary fw-bold fs-6">{{ approverLevel }}</div>
                    <div class="text-gray-600 fs-8">Authority Level</div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="bg-light-warning rounded-3 p-3 text-center">
                    <div class="text-warning fw-bold fs-6">{{ currentTime }}</div>
                    <div class="text-gray-600 fs-8">Session Time</div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="bg-light-info rounded-3 p-3 text-center">
                    <div class="text-info fw-bold fs-6">{{ sessionId.split('-')[0] }}</div>
                    <div class="text-gray-600 fs-8">Session ID</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Approval Filter Controls -->
      <div class="card card-flush border-0 shadow-lg mb-6">
        <div class="card-body p-4">
          <div class="row g-3">
            <div class="col-lg-2 col-md-4 col-6">
              <select
                v-model="filters.status"
                @change="applyFilters"
                class="form-select form-select-lg"
              >
                <option value="">All Status</option>
                <option value="Pending">Pending</option>
                <option value="Approved">Approved</option>
                <option value="Denied">Denied</option>
                <option value="Escalated">Escalated</option>
              </select>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
              <select
                v-model="filters.type"
                @change="applyFilters"
                class="form-select form-select-lg"
              >
                <option value="">All Types</option>
                <option value="Purchase_Order">Purchase Orders</option>
                <option value="Meter_Reading_Variance">Meter Variances</option>
                <option value="Stock_Adjustment">Stock Adjustments</option>
                <option value="Price_Change">Price Changes</option>
                <option value="Transfer_Request">Transfers</option>
                <option value="Ledger_Correction">Ledger Corrections</option>
                <option value="Emergency_Override">Emergency Overrides</option>
              </select>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
              <select
                v-model="filters.priority"
                @change="applyFilters"
                class="form-select form-select-lg"
              >
                <option value="">All Priority</option>
                <option value="Critical">Critical</option>
                <option value="High">High</option>
                <option value="Normal">Normal</option>
                <option value="Low">Low</option>
              </select>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
              <select
                v-model="filters.riskLevel"
                @change="applyFilters"
                class="form-select form-select-lg"
              >
                <option value="">All Risk</option>
                <option value="Critical">Critical Risk</option>
                <option value="High">High Risk</option>
                <option value="Medium">Medium Risk</option>
                <option value="Low">Low Risk</option>
              </select>
            </div>
            <div class="col-lg-2 col-md-4 col-6">
              <input
                v-model="filters.dateFrom"
                type="date"
                class="form-control form-control-lg"
                @change="applyFilters"
              />
            </div>
            <div class="col-lg-2 col-md-4 col-6">
              <button @click="resetFilters" class="btn btn-light-secondary w-100 h-100">
                <i class="ki-duotone ki-arrows-circle fs-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Reset
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Critical Approvals Grid (iOS-Native Cards) -->
      <div class="row g-4" v-if="!loading">
        <div
          v-for="approval in filteredApprovals"
          :key="approval.ApprovalID"
          class="col-xl-6 col-lg-6"
        >
          <div
            class="card card-flush border-0 shadow-lg h-100 approval-card"
            :class="getApprovalCardClass(approval)"
            @click="handleApprovalClick(approval)"
            role="button"
            :aria-label="`${approval.RequestTitle} - ${approval.Status}`"
            tabindex="0"
            @keydown.enter="handleApprovalClick(approval)"
            @keydown.space.prevent="handleApprovalClick(approval)"
          >
            <!-- Fraud Risk Overlay -->
            <div
              v-if="isFraudFlagged(approval)"
              class="position-absolute top-0 end-0 m-3"
              style="z-index: 5"
            >
              <div class="badge badge-light-danger fs-8">
                <i class="ki-duotone ki-security-check fs-6 me-1">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
                FRAUD RISK
              </div>
            </div>

            <div class="card-body p-6">
              <!-- Approval Header with Risk Indicator -->
              <div class="d-flex align-items-start justify-content-between mb-4">
                <div class="d-flex align-items-center gap-3">
                  <div
                    class="symbol symbol-50px symbol-circle"
                    :class="getApprovalStatusClass(approval)"
                  >
                    <i class="ki-duotone fs-2x" :class="getApprovalIconClass(approval)">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                      <span class="path4"></span>
                      <span class="path5"></span>
                      <span class="path6"></span>
                    </i>
                  </div>
                  <div>
                    <h4 class="text-gray-900 fw-bolder fs-5 mb-1">{{ approval.RequestTitle }}</h4>
                    <p class="text-gray-600 fs-6 mb-0">
                      {{ approval.RequestType.replace('_', ' ') }}
                    </p>
                  </div>
                </div>
                <div class="d-flex flex-column gap-1">
                  <div class="badge fs-6" :class="getStatusBadge(approval.Status)">
                    {{ approval.Status }}
                  </div>
                  <div class="badge" :class="getPriorityBadge(approval.Priority)">
                    {{ approval.Priority }}
                  </div>
                </div>
              </div>

              <!-- AI Risk Assessment -->
              <div class="bg-light-info rounded-3 p-3 mb-4">
                <div class="row g-2">
                  <div class="col-6">
                    <div class="text-center">
                      <div class="text-info fw-bold fs-6">{{ getAIRiskScore(approval) }}%</div>
                      <div class="text-gray-600 fs-8">AI Risk Score</div>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-center">
                      <div class="text-info fw-bold fs-6">{{ getAIConfidence(approval) }}%</div>
                      <div class="text-gray-600 fs-8">AI Confidence</div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Approval Details -->
              <div class="row g-3 mb-4">
                <div class="col-6">
                  <div class="text-center">
                    <div class="text-gray-900 fw-bold fs-6">
                      {{ formatCurrency(approval.RequestAmount) }}
                    </div>
                    <div class="text-gray-600 fs-7">Amount</div>
                  </div>
                </div>
                <div class="col-6">
                  <div class="text-center">
                    <div class="text-primary fw-bold fs-6">
                      {{ getDaysOld(approval.RequestDate) }}
                    </div>
                    <div class="text-gray-600 fs-7">Days Old</div>
                  </div>
                </div>
              </div>

              <!-- Requester Information -->
              <div class="bg-light-secondary rounded-3 p-3 mb-4">
                <div class="d-flex align-items-center gap-2">
                  <i class="ki-duotone ki-user fs-4 text-secondary">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div>
                    <div class="text-gray-900 fw-bold fs-7">
                      {{ getRequesterName(approval.RequesterUserID) }}
                    </div>
                    <div class="text-gray-600 fs-8">
                      {{ getRequesterPosition(approval.RequesterUserID) }}
                    </div>
                  </div>
                </div>
              </div>

              <!-- Approval Workflow Progress -->
              <div class="mb-4">
                <div class="d-flex align-items-center justify-content-between mb-2">
                  <span class="text-gray-600 fs-7 fw-bold">Approval Progress</span>
                  <span class="fw-bold fs-6">
                    Step {{ approval.CurrentApprovalLevel }} of {{ getTotalSteps(approval) }}
                  </span>
                </div>
                <div class="progress h-8px bg-light-secondary rounded-3">
                  <div
                    class="progress-bar bg-primary rounded-3"
                    :style="{ width: getProgressPercentage(approval) + '%' }"
                  ></div>
                </div>
              </div>

              <!-- SLA Timer -->
              <div class="d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                  <i class="ki-duotone ki-time fs-4" :class="getSLATimerClass(approval)">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <span class="fw-bold fs-7" :class="getSLATimerClass(approval)">
                    {{ getSLATimeRemaining(approval) }}
                  </span>
                </div>
                <div class="text-end">
                  <div class="badge" :class="getUrgencyBadge(approval)">
                    {{ getUrgencyLevel(approval) }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-20">
        <div class="spinner-border text-primary mb-4" style="width: 4rem; height: 4rem"></div>
        <p class="text-gray-600 fw-bold fs-4">{{ loadingMessage }}</p>
      </div>

      <!-- Empty State -->
      <div v-if="!loading && filteredApprovals.length === 0" class="text-center py-20">
        <div class="card card-flush border-0 shadow-lg">
          <div class="card-body p-10">
            <i class="ki-duotone ki-check-circle fs-3x text-success mb-5">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <h3 class="text-gray-900 fw-bolder fs-2 mb-3">All Clear!</h3>
            <p class="text-gray-600 fs-4 mb-5">No pending approvals match your current filters.</p>
            <button @click="resetFilters" class="btn btn-light-primary">
              <i class="ki-duotone ki-arrows-circle fs-4 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Reset Filters
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Approval Action Modal -->
    <div class="modal fade" id="approvalModal" tabindex="-1" v-if="selectedApproval">
      <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content border-0 shadow-xl">
          <div class="modal-header bg-primary">
            <div class="d-flex align-items-center gap-3">
              <div class="symbol symbol-45px symbol-circle bg-light-success">
                <i class="ki-duotone ki-security-check fs-2x text-success">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                  <span class="path5"></span>
                  <span class="path6"></span>
                </i>
              </div>
              <div>
                <h3 class="modal-title text-white fw-bolder mb-0">
                  {{ selectedApproval.RequestTitle }}
                </h3>
                <p class="text-light fs-6 mb-0">
                  {{ selectedApproval.RequestType.replace('_', ' ') }} • ID:
                  {{ selectedApproval.ApprovalID }}
                </p>
              </div>
            </div>
            <button
              type="button"
              class="btn-close btn-close-white"
              @click="closeApprovalModal"
            ></button>
          </div>

          <div class="modal-body p-6">
            <!-- Critical Fraud Detection Analysis -->
            <div v-if="selectedApprovalFraudData" class="card border border-danger mb-6">
              <div class="card-header bg-light-danger">
                <h5 class="text-danger fw-bold mb-0">
                  <i class="ki-duotone ki-security-check fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                    <span class="path6"></span>
                  </i>
                  AI Fraud Detection Analysis
                </h5>
              </div>
              <div class="card-body">
                <div class="row g-4">
                  <div class="col-md-4">
                    <div class="text-center">
                      <div class="text-danger fw-bolder fs-2">
                        {{ selectedApprovalFraudData.riskScore }}%
                      </div>
                      <div class="text-gray-600 fs-7">Risk Score</div>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="text-center">
                      <div class="text-warning fw-bolder fs-2">
                        {{ selectedApprovalFraudData.anomalies }}
                      </div>
                      <div class="text-gray-600 fs-7">Anomalies</div>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="text-center">
                      <div
                        class="badge"
                        :class="getFraudSeverityBadge(selectedApprovalFraudData.severity)"
                      >
                        {{ selectedApprovalFraudData.severity }}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="mt-4">
                  <h6 class="text-gray-800 fw-bold mb-3">Risk Factors:</h6>
                  <div class="bg-light rounded-3 p-3">
                    <ul class="mb-0">
                      <li
                        v-for="factor in selectedApprovalFraudData.riskFactors"
                        :key="factor"
                        class="mb-1"
                      >
                        {{ factor }}
                      </li>
                    </ul>
                  </div>
                </div>

                <div class="mt-4" v-if="selectedApprovalFraudData.recommendations.length > 0">
                  <h6 class="text-gray-800 fw-bold mb-3">AI Recommendations:</h6>
                  <div class="bg-light-info rounded-3 p-3">
                    <ul class="mb-0">
                      <li
                        v-for="rec in selectedApprovalFraudData.recommendations"
                        :key="rec"
                        class="mb-1 text-info"
                      >
                        {{ rec }}
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>

            <!-- Approval Request Details -->
            <div class="card border border-info mb-6">
              <div class="card-header bg-light-info">
                <h5 class="text-info fw-bold mb-0">
                  <i class="ki-duotone ki-document-copy fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Request Details & Business Context
                </h5>
              </div>
              <div class="card-body">
                <div class="row g-4">
                  <div class="col-md-6">
                    <h6 class="text-gray-800 fw-bold mb-3">Basic Information:</h6>
                    <div class="bg-light rounded-3 p-3">
                      <div class="mb-2">
                        <strong>Type:</strong> {{ selectedApproval.RequestType.replace('_', ' ') }}
                      </div>
                      <div class="mb-2">
                        <strong>Amount:</strong>
                        {{ formatCurrency(selectedApproval.RequestAmount) }}
                      </div>
                      <div class="mb-2">
                        <strong>Priority:</strong> {{ selectedApproval.Priority }}
                      </div>
                      <div class="mb-2"><strong>Status:</strong> {{ selectedApproval.Status }}</div>
                      <div class="mb-0">
                        <strong>Submitted:</strong>
                        {{ formatDateTime(selectedApproval.RequestDate) }}
                      </div>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <h6 class="text-gray-800 fw-bold mb-3">Business Impact:</h6>
                    <div class="bg-light rounded-3 p-3">
                      <div class="mb-2">
                        <strong>Station:</strong>
                        {{ getStationName(selectedApproval.RequesterStationID) }}
                      </div>
                      <div class="mb-2">
                        <strong>Department:</strong>
                        {{ getDepartmentName(selectedApproval.RequesterDepartmentID) }}
                      </div>
                      <div class="mb-2">
                        <strong>SLA Deadline:</strong>
                        {{ formatDateTime(selectedApproval.DueDate) }}
                      </div>
                      <div class="mb-0">
                        <strong>Escalation Level:</strong> Level
                        {{ selectedApproval.CurrentApprovalLevel }}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="mt-4">
                  <h6 class="text-gray-800 fw-bold mb-3">Request Description:</h6>
                  <div class="bg-light-secondary rounded-3 p-3">
                    <p class="mb-0">
                      {{ selectedApproval.RequestDetails || 'No additional details provided.' }}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Approval Workflow Steps -->
            <div class="card border border-success mb-6">
              <div class="card-header bg-light-success">
                <h5 class="text-success fw-bold mb-0">
                  <i class="ki-duotone ki-route fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Approval Workflow & History
                </h5>
              </div>
              <div class="card-body">
                <div class="timeline">
                  <div
                    v-for="(step, index) in approvalSteps"
                    :key="step.StepID"
                    class="timeline-item"
                  >
                    <div class="timeline-line" :class="getTimelineLineClass(step, index)"></div>
                    <div class="timeline-icon" :class="getTimelineIconClass(step)">
                      <i class="ki-duotone ki-check fs-2x">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </div>
                    <div class="timeline-content ms-3">
                      <div class="d-flex align-items-center justify-content-between mb-2">
                        <h6 class="text-gray-900 fw-bold mb-0">
                          Step {{ step.StepNumber }}: {{ step.ApproverType }}
                        </h6>
                        <span class="badge" :class="getStepStatusBadge(step.Status)">{{
                          step.Status
                        }}</span>
                      </div>
                      <p class="text-gray-600 fs-7 mb-1">Approver: {{ getApproverName(step) }}</p>
                      <p class="text-gray-500 fs-8 mb-0">
                        {{ step.StartedAt ? formatDateTime(step.StartedAt) : 'Not started' }}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Current Approver Actions -->
            <div v-if="canApprove(selectedApproval)" class="card border border-warning mb-6">
              <div class="card-header bg-light-warning">
                <h5 class="text-warning fw-bold mb-0">
                  <i class="ki-duotone ki-security-user fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                  </i>
                  Your Approval Action Required
                </h5>
              </div>
              <div class="card-body">
                <div class="row g-4">
                  <div class="col-12">
                    <label class="form-label text-gray-800 fw-bold">Comments & Justification</label>
                    <textarea
                      v-model="approvalComments"
                      class="form-control border-warning"
                      rows="4"
                      placeholder="Enter your comments, justification, or concerns about this approval request..."
                      maxlength="1000"
                    ></textarea>
                    <div class="form-text d-flex justify-content-between">
                      <span>Required for denials and high-risk approvals</span>
                      <span>{{ approvalComments?.length || 0 }}/1000</span>
                    </div>
                  </div>
                </div>

                <!-- Critical Security Verification -->
                <div v-if="requiresSecurityVerification(selectedApproval)" class="mt-4">
                  <div class="bg-light-danger rounded-3 p-4">
                    <h6 class="text-danger fw-bold mb-3">
                      <i class="ki-duotone ki-security-check fs-4 me-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                        <span class="path5"></span>
                        <span class="path6"></span>
                      </i>
                      Security Verification Required
                    </h6>
                    <div class="form-check">
                      <input
                        v-model="securityVerified"
                        class="form-check-input"
                        type="checkbox"
                        id="securityCheck"
                      />
                      <label class="form-check-label text-gray-700" for="securityCheck">
                        I verify this approval complies with company policies and fraud prevention
                        measures
                      </label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="modal-footer bg-light-secondary p-6">
            <div class="d-flex w-100 gap-3">
              <button type="button" class="btn btn-light" @click="closeApprovalModal">
                Cancel
              </button>

              <div v-if="canApprove(selectedApproval)" class="d-flex gap-3 flex-grow-1">
                <button
                  @click="denyApproval"
                  class="btn btn-danger"
                  :disabled="
                    approvalProcessing ||
                    (!approvalComments && requiresComments(selectedApproval, 'deny'))
                  "
                >
                  <span
                    v-if="approvalProcessing"
                    class="spinner-border spinner-border-sm me-2"
                  ></span>
                  <i v-else class="ki-duotone ki-cross fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Deny Request
                </button>
                <button
                  @click="approveRequest"
                  class="btn btn-success flex-grow-1"
                  :disabled="
                    approvalProcessing ||
                    (requiresSecurityVerification(selectedApproval) && !securityVerified)
                  "
                >
                  <span
                    v-if="approvalProcessing"
                    class="spinner-border spinner-border-sm me-2"
                  ></span>
                  <i v-else class="ki-duotone ki-check fs-4 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Approve Meter Reading
                </button>
              </div>

              <div v-else class="flex-grow-1 text-center">
                <div class="alert alert-warning mb-0">
                  <strong>No Approval Authority:</strong> You cannot approve this request.
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Approval Statistics Modal -->
    <div class="modal fade" id="statsModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg">
          <div class="modal-header bg-info">
            <h3 class="modal-title text-white fw-bold">Approval Statistics & Analytics</h3>
            <button
              type="button"
              class="btn-close btn-close-white"
              @click="closeStatsModal"
            ></button>
          </div>
          <div class="modal-body p-6">
            <!-- Performance Metrics -->
            <div class="mb-6">
              <h6 class="text-gray-800 fw-bold mb-4">Your Approval Performance</h6>
              <div class="row g-4">
                <div class="col-md-3">
                  <div class="text-center">
                    <div class="text-success fw-bold fs-3">{{ approvalStats.approved }}</div>
                    <div class="text-gray-600 fs-8">Approved</div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="text-center">
                    <div class="text-danger fw-bold fs-3">{{ approvalStats.denied }}</div>
                    <div class="text-gray-600 fs-8">Denied</div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="text-center">
                    <div class="text-warning fw-bold fs-3">{{ approvalStats.escalated }}</div>
                    <div class="text-gray-600 fs-8">Escalated</div>
                  </div>
                </div>
                <div class="col-md-3">
                  <div class="text-center">
                    <div class="text-info fw-bold fs-3">{{ approvalStats.avgTime }}h</div>
                    <div class="text-gray-600 fs-8">Avg Time</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Recent Activity -->
            <div>
              <h6 class="text-gray-800 fw-bold mb-4">Recent Activity (Last 7 Days)</h6>
              <div class="bg-light rounded-3 p-4">
                <div v-if="recentActivity.length > 0">
                  <div
                    v-for="activity in recentActivity"
                    :key="activity.id"
                    class="d-flex align-items-center gap-3 mb-3"
                  >
                    <div
                      class="symbol symbol-35px symbol-circle"
                      :class="getActivityStatusClass(activity.action)"
                    >
                      <i class="ki-duotone fs-5" :class="getActivityIconClass(activity.action)">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </div>
                    <div class="flex-grow-1">
                      <div class="text-gray-900 fw-bold fs-7">{{ activity.title }}</div>
                      <div class="text-gray-600 fs-8">{{ activity.description }}</div>
                    </div>
                    <div class="text-gray-500 fs-8">{{ activity.timeAgo }}</div>
                  </div>
                </div>
                <div v-else class="text-center text-gray-600">
                  <p class="mb-0">No recent approval activity</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted, watch, nextTick } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// Authentication & Authorization
const authData = ref(JSON.parse(localStorage.getItem('kigrama_user_data') || '{}'))
const currentUser = computed(() => authData.value.user || {})
const userStation = computed(() => {
  const stations = authData.value.stations || []
  return stations.find((s) => s.IsPrimary === '1') || stations[0] || null
})

// Enhanced Role-Based Access Control for Approvals
const currentUserRole = computed(() => currentUser.value?.Role || 'Unknown')
const currentUserPosition = computed(() => {
  const positions = authData.value.positions || []
  const primary = positions.find((p) => p.IsPrimary === '1') || positions[0]
  return primary?.PositionTitle || 'Unknown'
})

const hasApprovalAuthority = computed(() => {
  const role = currentUserRole.value.toLowerCase()
  const position = currentUserPosition.value.toLowerCase()

  return (
    role.includes('admin') ||
    role.includes('manager') ||
    role.includes('supervisor') ||
    role.includes('controller') ||
    role.includes('cfo') ||
    role.includes('approver') ||
    position.includes('manager') ||
    position.includes('supervisor') ||
    position.includes('controller') ||
    position.includes('head') ||
    position.includes('lead')
  )
})

const approverLevel = computed(() => {
  const role = currentUserRole.value.toLowerCase()
  const position = currentUserPosition.value.toLowerCase()

  if (role.includes('cfo') || position.includes('cfo')) return 'CFO Level'
  if (role.includes('finance') && (role.includes('controller') || position.includes('controller')))
    return 'Finance Controller'
  if (role.includes('manager') || position.includes('manager')) return 'Manager Level'
  if (role.includes('supervisor') || position.includes('supervisor')) return 'Supervisor Level'
  if (role.includes('admin')) return 'System Admin'
  return 'Approver'
})

const authorityLevel = computed(() => {
  const role = currentUserRole.value.toLowerCase()
  if (role.includes('cfo')) return 'Unlimited'
  if (role.includes('controller')) return 'Finance'
  if (role.includes('manager')) return 'Station'
  return 'Limited'
})

const authorityBadge = computed(() => {
  switch (authorityLevel.value) {
    case 'Unlimited':
      return 'badge-light-success'
    case 'Finance':
      return 'badge-light-info'
    case 'Station':
      return 'badge-light-warning'
    default:
      return 'badge-light-secondary'
  }
})

// Component State
const loading = ref(true)
const loadingMessage = ref('Initializing approval management system...')
const currentTime = ref('')
const sessionId = ref(`${currentUser.value?.id || 'unknown'}-${Date.now()}`)

// Approval Data Collections
const pendingApprovals = ref([])
const allApprovals = ref([])
const approvalSteps = ref([])
const approvalActions = ref([])
const fraudDetectionLogs = ref([])
const userLookup = reactive(new Map())
const stationLookup = reactive(new Map())
const departmentLookup = reactive(new Map())

// Fraud Detection State
const currentFraudAlert = ref(null)
const selectedApprovalFraudData = ref(null)

// Filter State
const filters = reactive({
  status: '',
  type: '',
  priority: '',
  riskLevel: '',
  dateFrom: '',
  dateTo: '',
})

// Modal State
const selectedApproval = ref(null)
const approvalComments = ref('')
const securityVerified = ref(false)
const approvalProcessing = ref(false)

// Statistics State
const approvalStats = reactive({
  approved: 0,
  denied: 0,
  escalated: 0,
  avgTime: 0,
})

const recentActivity = ref([])

// Modal Instances
let approvalModalInstance = null
let statsModalInstance = null

// Computed Properties
const filteredApprovals = computed(() => {
  let filtered = allApprovals.value

  if (filters.status) {
    filtered = filtered.filter((a) => a.Status === filters.status)
  }
  if (filters.type) {
    filtered = filtered.filter((a) => a.RequestType === filters.type)
  }
  if (filters.priority) {
    filtered = filtered.filter((a) => a.Priority === filters.priority)
  }
  if (filters.riskLevel) {
    const riskLevel = filters.riskLevel
    filtered = filtered.filter((a) => getAIRiskLevel(a) === riskLevel)
  }
  if (filters.dateFrom) {
    filtered = filtered.filter((a) => new Date(a.RequestDate) >= new Date(filters.dateFrom))
  }

  // Sort by priority and date
  return filtered.sort((a, b) => {
    const priorityOrder = { Critical: 4, High: 3, Normal: 2, Low: 1 }
    const aPriority = priorityOrder[a.Priority] || 0
    const bPriority = priorityOrder[b.Priority] || 0

    if (aPriority !== bPriority) return bPriority - aPriority
    return new Date(b.RequestDate) - new Date(a.RequestDate)
  })
})

const highRiskApprovals = computed(() => {
  return allApprovals.value.filter((a) => getAIRiskScore(a) >= 75).length
})

const approvalVelocity = computed(() => {
  const today = new Date()
  const yesterday = new Date(today.getTime() - 24 * 60 * 60 * 1000)

  const completedToday = allApprovals.value.filter((a) => {
    const completedAt = new Date(a.CompletedAt || a.UpdatedAt)
    return completedAt >= yesterday && (a.Status === 'Approved' || a.Status === 'Denied')
  }).length

  const totalPending = pendingApprovals.value.length
  if (totalPending === 0) return 100

  return Math.min(100, Math.round((completedToday / (completedToday + totalPending)) * 100))
})

const completedToday = computed(() => {
  const today = new Date().toISOString().split('T')[0]
  return allApprovals.value.filter((a) => {
    const completedDate = (a.CompletedAt || a.UpdatedAt || '').split('T')[0]
    return completedDate === today && (a.Status === 'Approved' || a.Status === 'Denied')
  }).length
})

// Time Update Function
const updateCurrentTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString('en-US', {
    hour12: false,
    hour: '2-digit',
    minute: '2-digit',
  })
}

// Enhanced API Request with Authentication
const apiRequest = async (endpoint, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${getAuthToken()}`,
        'X-Station-ID': userStation.value?.StationID?.toString(),
        'X-User-ID': currentUser.value?.id?.toString(),
        'X-Session-ID': sessionId.value,
        'X-Approval-Authority': approverLevel.value,
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.message || `HTTP ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}

const getAuthToken = () => {
  return authData.value.token || localStorage.getItem('kigrama_auth_token') || ''
}

// Data Loading Functions
const loadApprovalData = async () => {
  console.log(
    '📊 METER READING APPROVAL SYSTEM: Loading approval data with authority level:',
    approverLevel.value,
  )

  try {
    loadingMessage.value = 'Loading meter reading approval requests...'

    // STEP 1: Load approvals based on authority level - Focus on Meter Reading Variances
    let approvalQuery = '/Approvals?RequestType=Meter_Reading_Variance'

    // Station Managers see their station's approvals
    if (authorityLevel.value === 'Station' && userStation.value?.StationID) {
      approvalQuery += `&RequesterStationID=${userStation.value.StationID}`
    }
    // System Admins see all approvals
    else if (authorityLevel.value === 'Unlimited') {
      // See all meter reading approvals
    }
    // Limited users see only their assigned approvals
    else if (authorityLevel.value === 'Limited') {
      approvalQuery += `&CurrentApproverUserID=${currentUser.value?.id}`
    }

    console.log('📡 APPROVAL QUERY:', approvalQuery)
    const approvalsData = await apiRequest(approvalQuery)
    allApprovals.value = approvalsData.records || []

    console.log('📊 LOADED METER READING APPROVALS:', {
      total: allApprovals.value.length,
      pending: allApprovals.value.filter((a) => a.Status === 'Pending').length,
      approved: allApprovals.value.filter((a) => a.Status === 'Approved').length,
      denied: allApprovals.value.filter((a) => a.Status === 'Denied').length,
      authority: authorityLevel.value,
    })

    // STEP 2: Filter pending approvals for current user authority
    pendingApprovals.value = allApprovals.value.filter((approval) => {
      if (approval.Status !== 'Pending') return false

      // System Admin can approve anything
      if (authorityLevel.value === 'Unlimited') return true

      // Station Manager can approve their station's requests
      if (authorityLevel.value === 'Station' && userStation.value?.StationID) {
        return approval.RequesterStationID === userStation.value.StationID
      }

      // Limited users see assigned approvals
      if (authorityLevel.value === 'Limited') {
        return approval.CurrentApproverUserID === currentUser.value?.id
      }

      return false
    })

    console.log('📊 FILTERED PENDING APPROVALS:', {
      pendingCount: pendingApprovals.value.length,
      authority: authorityLevel.value,
      stationId: userStation.value?.StationID,
    })

    loadingMessage.value = 'Loading user information...'
    await loadUserLookup()

    loadingMessage.value = 'Loading station data...'
    await loadStationLookup()

    loadingMessage.value = 'Checking meter reading fraud detection...'
    await loadMeterReadingFraudDetection()

    loadingMessage.value = 'Loading approval statistics...'
    await loadApprovalStats()
  } catch (error) {
    console.error('💥 METER READING APPROVAL LOADING ERROR:', error)
    throw error
  }
}

const loadUserLookup = async () => {
  try {
    const usersData = await apiRequest('/users')
    const users = usersData.records || []

    users.forEach((user) => {
      userLookup.set(user.id, {
        name: user.name || user.email,
        role: user.Role,
        position: user.Position,
        email: user.email,
      })
    })

    console.log('✅ APPROVAL SYSTEM: Loaded user lookup:', userLookup.size)
  } catch (error) {
    console.error('Error loading users:', error)
  }
}

const loadStationLookup = async () => {
  try {
    const [stationsData, departmentsData] = await Promise.all([
      apiRequest('/Stations'),
      apiRequest('/Departments'),
    ])

    const stations = stationsData.records || []
    const departments = departmentsData.records || []

    stations.forEach((station) => {
      stationLookup.set(station.StationID, station.StationName)
    })

    departments.forEach((dept) => {
      departmentLookup.set(dept.DepartmentID, dept.DepartmentName)
    })

    console.log('✅ APPROVAL SYSTEM: Loaded lookup data')
  } catch (error) {
    console.error('Error loading lookup data:', error)
  }
}

const loadMeterReadingFraudDetection = async () => {
  try {
    // Load fraud detection logs specifically for meter reading transactions
    const fraudData = await apiRequest(
      '/FraudDetectionLogs?Status=Open&FraudType=Meter_Reading_Variance',
    )
    fraudDetectionLogs.value = fraudData.records || []

    console.log('📊 METER READING FRAUD DETECTION:', {
      totalFraudLogs: fraudDetectionLogs.value.length,
      criticalAlerts: fraudDetectionLogs.value.filter((log) => log.Severity === 'Critical').length,
      highRiskAlerts: fraudDetectionLogs.value.filter((log) => log.Severity === 'High').length,
    })

    // Generate AI fraud alert for meter reading if high-risk items exist
    const criticalMeterFraud = fraudDetectionLogs.value.find(
      (log) =>
        log.Severity === 'Critical' &&
        parseFloat(log.RiskScore || '0') >= 90 &&
        log.FraudType === 'Meter_Reading_Variance',
    )

    if (criticalMeterFraud) {
      currentFraudAlert.value = {
        id: criticalMeterFraud.FraudLogID,
        description:
          criticalMeterFraud.Description ||
          'High-risk meter reading variance detected - potential fuel theft or manipulation',
        riskScore: criticalMeterFraud.RiskScore || '90',
        severity: criticalMeterFraud.Severity || 'Critical',
        detectedAt: criticalMeterFraud.DetectedAt,
        fraudType: 'Meter_Reading_Variance',
      }
    }

    // Create fraud detection rules for suspicious meter reading patterns
    await createMeterReadingFraudRules()

    console.log(
      '✅ METER READING FRAUD DETECTION: Loaded fraud detection data:',
      fraudDetectionLogs.value.length,
    )
  } catch (error) {
    console.error('💥 METER READING FRAUD DETECTION ERROR:', error)
  }
}

// Create specific fraud detection rules for meter reading variances
const createMeterReadingFraudRules = async () => {
  try {
    const existingRulesData = await apiRequest('/FraudDetectionRules')
    const existingRules = existingRulesData.records || []

    const meterReadingRules = [
      {
        RuleName: 'Excessive_Meter_Variance',
        Description: 'Detects meter reading variances exceeding 50L threshold',
        Threshold: '50.0',
        Enabled: '1',
      },
      {
        RuleName: 'Repeated_High_Variances',
        Description: 'Detects attendants with multiple high variance submissions',
        Threshold: '3.0',
        Enabled: '1',
      },
      {
        RuleName: 'Off_Hours_Reading_Manipulation',
        Description: 'Detects suspicious meter readings submitted during off-hours',
        Threshold: '22.0',
        Enabled: '1',
      },
    ]

    for (const rule of meterReadingRules) {
      const existingRule = existingRules.find((r) => r.RuleName === rule.RuleName)
      if (!existingRule) {
        console.log('📡 CREATING FRAUD RULE:', rule.RuleName)
        await apiRequest('/FraudDetectionRules', {
          method: 'POST',
          body: JSON.stringify(rule),
        })
      }
    }
  } catch (error) {
    console.error('Error creating fraud rules:', error)
  }
}

const loadApprovalStats = async () => {
  try {
    // Calculate stats from current data
    const userApprovals = allApprovals.value.filter(
      (a) =>
        a.CurrentApproverUserID === currentUser.value?.id ||
        (a.Status !== 'Pending' && a.RequesterUserID === currentUser.value?.id),
    )

    approvalStats.approved = userApprovals.filter((a) => a.Status === 'Approved').length
    approvalStats.denied = userApprovals.filter((a) => a.Status === 'Denied').length
    approvalStats.escalated = userApprovals.filter((a) => a.Status === 'Escalated').length

    // Calculate average processing time
    const completedApprovals = userApprovals.filter((a) => a.CompletedAt)
    if (completedApprovals.length > 0) {
      const totalTime = completedApprovals.reduce((sum, approval) => {
        const start = new Date(approval.RequestDate)
        const end = new Date(approval.CompletedAt)
        return sum + (end - start)
      }, 0)
      approvalStats.avgTime = Math.round(totalTime / completedApprovals.length / (1000 * 60 * 60))
    }

    // Generate recent activity
    generateRecentActivity()

    console.log('✅ APPROVAL SYSTEM: Statistics loaded:', approvalStats)
  } catch (error) {
    console.error('Error loading approval stats:', error)
  }
}

const generateRecentActivity = () => {
  const activities = allApprovals.value
    .filter((a) => a.UpdatedAt || a.CompletedAt)
    .sort((a, b) => new Date(b.UpdatedAt || b.CompletedAt) - new Date(a.UpdatedAt || a.CompletedAt))
    .slice(0, 5)
    .map((approval) => ({
      id: approval.ApprovalID,
      action: approval.Status,
      title: approval.RequestTitle,
      description: `${approval.RequestType.replace('_', ' ')} - ${formatCurrency(approval.RequestAmount)}`,
      timeAgo: getTimeAgo(approval.UpdatedAt || approval.CompletedAt),
    }))

  recentActivity.value = activities
}

// AI Fraud Detection Functions
const getAIRiskScore = (approval) => {
  // AI-powered risk assessment algorithm
  let riskScore = 0

  // Amount-based risk (30% weight)
  const amount = parseFloat(approval.RequestAmount || '0')
  if (amount > 100000) riskScore += 30
  else if (amount > 50000) riskScore += 20
  else if (amount > 10000) riskScore += 10
  else riskScore += 5

  // Time-based risk (20% weight)
  const requestDate = new Date(approval.RequestDate)
  const now = new Date()
  const hourOfDay = requestDate.getHours()
  const dayOfWeek = requestDate.getDay()

  if (hourOfDay < 6 || hourOfDay > 22) riskScore += 15 // Off-hours
  if (dayOfWeek === 0 || dayOfWeek === 6) riskScore += 10 // Weekend

  // Urgency-based risk (15% weight)
  if (approval.Priority === 'Critical') riskScore += 15
  else if (approval.Priority === 'High') riskScore += 10

  // Type-based risk (20% weight)
  const riskTypes = {
    Purchase_Order: 10,
    Stock_Adjustment: 15,
    Price_Change: 20,
    Emergency_Override: 25,
    Ledger_Correction: 15,
  }
  riskScore += riskTypes[approval.RequestType] || 5

  // Historical pattern risk (15% weight)
  const requesterRisk = calculateRequesterRisk(approval.RequesterUserID)
  riskScore += requesterRisk

  return Math.min(100, Math.max(0, riskScore))
}

const calculateRequesterRisk = (userId) => {
  const userApprovals = allApprovals.value.filter((a) => a.RequesterUserID === userId)
  if (userApprovals.length === 0) return 5

  const deniedCount = userApprovals.filter((a) => a.Status === 'Denied').length
  const denialRate = deniedCount / userApprovals.length

  if (denialRate > 0.3) return 15
  if (denialRate > 0.2) return 10
  if (denialRate > 0.1) return 7
  return 3
}

const getAIConfidence = (approval) => {
  // AI confidence in risk assessment
  const dataPoints = [
    approval.RequestAmount ? 20 : 0,
    approval.RequestDetails ? 15 : 0,
    approval.RequesterUserID ? 20 : 0,
    approval.RequestType ? 15 : 0,
    approval.Priority ? 10 : 0,
    approval.RequesterStationID ? 10 : 0,
    approval.RequesterDepartmentID ? 10 : 0,
  ]

  return dataPoints.reduce((sum, points) => sum + points, 0)
}

const getAIRiskLevel = (approval) => {
  const score = getAIRiskScore(approval)
  if (score >= 75) return 'Critical'
  if (score >= 60) return 'High'
  if (score >= 40) return 'Medium'
  return 'Low'
}

const isFraudFlagged = (approval) => {
  return (
    getAIRiskScore(approval) >= 80 ||
    fraudDetectionLogs.value.some(
      (log) => log.TransactionID === approval.RequestTypeID && log.Severity === 'Critical',
    )
  )
}

const generateFraudAnalysis = (approval) => {
  const riskScore = getAIRiskScore(approval)
  const riskFactors = []
  const recommendations = []

  // METER READING SPECIFIC FRAUD ANALYSIS
  if (approval.RequestType === 'Meter_Reading_Variance') {
    const variance = parseFloat(approval.RequestAmount || '0')

    // High variance analysis
    if (variance > 50) {
      riskFactors.push(
        `Extremely high meter variance: ${variance}L exceeds normal operational limits`,
      )
      recommendations.push(
        'Verify physical meter readings and check for equipment malfunction or manipulation',
      )
    } else if (variance > 30) {
      riskFactors.push(`Significant meter variance: ${variance}L requires detailed investigation`)
      recommendations.push('Review transaction logs and compare with dip stick readings')
    }

    // Time-based analysis for meter readings
    const requestDate = new Date(approval.RequestDate)
    const hourOfDay = requestDate.getHours()
    if (hourOfDay < 6 || hourOfDay > 22) {
      riskFactors.push('Meter reading submitted during off-business hours - unusual timing')
      recommendations.push('Verify attendant was on authorized shift and readings are legitimate')
    }

    // Requester pattern analysis
    const requesterRisk = calculateRequesterRisk(approval.RequesterUserID)
    if (requesterRisk > 10) {
      riskFactors.push('Attendant has history of high variance or denied meter reading requests')
      recommendations.push('Review attendant training records and consider additional supervision')
    }

    // Station-specific analysis
    const stationName = getStationName(approval.RequesterStationID)
    if (stationName && stationName !== 'Unknown Station') {
      // Check for multiple high variance requests from same station
      const stationHighVarianceCount = allApprovals.value.filter(
        (a) =>
          a.RequesterStationID === approval.RequesterStationID &&
          a.RequestType === 'Meter_Reading_Variance' &&
          parseFloat(a.RequestAmount || '0') > 20,
      ).length

      if (stationHighVarianceCount > 3) {
        riskFactors.push(
          `Station ${stationName} has multiple high variance requests - pattern detected`,
        )
        recommendations.push('Investigate station equipment, procedures, and staff training')
      }
    }

    // Equipment manipulation indicators
    if (variance > 25 && hourOfDay >= 22) {
      riskFactors.push(
        'High variance combined with late-night submission suggests potential fuel theft',
      )
      recommendations.push(
        'Immediate physical verification required - check for equipment tampering',
      )
    }

    // Add meter reading specific recommendations
    if (riskScore >= 75) {
      recommendations.push('Require dual witness verification for all readings at this station')
      recommendations.push('Implement mandatory CCTV review for high variance periods')
    }
  }

  // Generic fraud analysis for other types
  else {
    const amount = parseFloat(approval.RequestAmount || '0')
    if (amount > 50000) {
      riskFactors.push(`High amount transaction: ${formatCurrency(amount)}`)
      recommendations.push('Verify with finance controller and require additional documentation')
    }

    const requestDate = new Date(approval.RequestDate)
    const hourOfDay = requestDate.getHours()
    if (hourOfDay < 6 || hourOfDay > 22) {
      riskFactors.push('Request submitted during off-business hours')
      recommendations.push('Verify requester identity and business justification')
    }

    if (approval.Priority === 'Critical') {
      riskFactors.push('Marked as critical priority - bypass attempt potential')
      recommendations.push('Verify urgency with station manager and document justification')
    }
  }

  return {
    riskScore,
    severity: getAIRiskLevel(approval),
    anomalies: riskFactors.length,
    riskFactors,
    recommendations,
  }
}

// Approval Logic Functions
// METER READING APPROVAL LOGIC
const canApprove = (approval) => {
  // Check if current user can approve this meter reading request
  if (approval.Status !== 'Pending') return false

  // System admin can approve anything
  if (
    currentUserRole.value.toLowerCase().includes('system') &&
    currentUserRole.value.toLowerCase().includes('admin')
  ) {
    return true
  }

  // For Meter Reading Variances - Station Manager authority
  if (approval.RequestType === 'Meter_Reading_Variance') {
    // Station Manager can approve requests from their station
    if (approverLevel.value.includes('Manager') && userStation.value?.StationID) {
      return approval.RequesterStationID === userStation.value.StationID
    }

    // Finance Controller can approve any meter reading variance
    if (approverLevel.value.includes('Controller')) {
      return true
    }

    // CFO can approve anything
    if (approverLevel.value === 'CFO Level') {
      return true
    }
  }

  // For other approval types (if any)
  const amount = parseFloat(approval.RequestAmount || '0')

  switch (approval.RequestType) {
    case 'Purchase_Order':
      if (amount > 10000 && approverLevel.value !== 'CFO Level') return false
      return approverLevel.value.includes('Manager') || approverLevel.value.includes('Controller')

    case 'Stock_Adjustment':
      if (amount > 2000 && !approverLevel.value.includes('Controller')) return false
      return approverLevel.value.includes('Manager') || approverLevel.value.includes('Controller')

    case 'Price_Change':
      return approverLevel.value === 'CFO Level'

    case 'Ledger_Correction':
      return approverLevel.value.includes('Controller') || approverLevel.value === 'CFO Level'

    case 'Emergency_Override':
      return approverLevel.value.includes('Manager') || approverLevel.value === 'CFO Level'

    default:
      return approverLevel.value.includes('Manager') || approverLevel.value.includes('Supervisor')
  }
}

const requiresSecurityVerification = (approval) => {
  const riskScore = getAIRiskScore(approval)
  const amount = parseFloat(approval.RequestAmount || '0')

  return (
    riskScore >= 70 ||
    amount > 50000 ||
    approval.RequestType === 'Emergency_Override' ||
    approval.Priority === 'Critical'
  )
}

const requiresComments = (approval, action) => {
  if (action === 'deny') return true
  if (requiresSecurityVerification(approval)) return true
  if (getAIRiskScore(approval) >= 60) return true
  return false
}

// ENHANCED METER READING APPROVAL FUNCTIONS
const approveRequest = async () => {
  if (!selectedApproval.value) return

  const approval = selectedApproval.value

  // Verify security requirements
  if (requiresSecurityVerification(approval) && !securityVerified.value) {
    await Swal.fire({
      title: 'Security Verification Required',
      text: 'Please complete the security verification before approving this high-risk request.',
      icon: 'warning',
    })
    return
  }

  approvalProcessing.value = true

  try {
    console.log('🔄 APPROVAL PROCESSING: Starting meter reading approval workflow...')
    console.log('📊 APPROVAL CONTEXT:', {
      approvalId: approval.ApprovalID,
      requestType: approval.RequestType,
      pumpId: approval.RequestTypeID,
      stationId: approval.RequesterStationID,
      attendantId: approval.RequesterUserID,
      approver: currentUser.value.name,
    })

    // STEP 1: Create detailed approval action record
    const actionData = {
      ApprovalID: approval.ApprovalID,
      StepID: null, // Single step approval - no escalation
      UserID: currentUser.value.id,
      ActionType: 'Approved',
      Comments:
        approvalComments.value ||
        `Meter reading variance approved by ${currentUser.value.name} - ${approverLevel.value}. Risk assessment completed and acceptable.`,
      IPAddress: 'client_ip',
      UserAgent: navigator.userAgent,
    }

    console.log('📡 CREATING APPROVAL ACTION:', actionData)
    await apiRequest('/ApprovalActions', {
      method: 'POST',
      body: JSON.stringify(actionData),
    })

    // STEP 2: Update main approval record - FINAL APPROVAL (No Escalation)
    const updateData = {
      Status: 'Approved',
      CompletedAt: new Date().toISOString(),
      CurrentApproverUserID: null, // Clear current approver - process complete
      CurrentApprovalLevel: '1', // Single level - no escalation
      Priority: 'Completed', // Mark as completed priority
    }

    console.log('📡 UPDATING APPROVAL STATUS:', updateData)
    await apiRequest(`/Approvals/${approval.ApprovalID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData),
    })

    // STEP 3: Handle Meter Reading Specific Logic
    if (approval.RequestType === 'Meter_Reading_Variance') {
      await handleMeterReadingApproval(approval, 'Approved')
    }

    // STEP 4: Create success notification for requester
    const notificationData = {
      UserID: approval.RequesterUserID,
      StationID: approval.RequesterStationID,
      Channel: 'System',
      Type: 'Approval_Approved',
      Title: '✅ Meter Reading Approved',
      Message: `Your meter reading variance has been approved by ${currentUser.value.name}. You can now continue with operations.`,
      Status: 'Queued',
      ScheduledAt: new Date().toISOString(),
    }

    console.log('📡 CREATING APPROVAL NOTIFICATION:', notificationData)
    await apiRequest('/Notifications', {
      method: 'POST',
      body: JSON.stringify(notificationData),
    })

    // STEP 5: Comprehensive audit logging
    await logAuditAction('METER_READING_APPROVED', {
      approvalId: approval.ApprovalID,
      requestType: approval.RequestType,
      pumpId: approval.RequestTypeID,
      stationId: approval.RequesterStationID,
      attendantId: approval.RequesterUserID,
      variance: approval.RequestAmount,
      riskScore: getAIRiskScore(approval),
      securityVerified: securityVerified.value,
      comments: approvalComments.value,
      approver: currentUser.value.name,
      approverLevel: approverLevel.value,
      completedAt: new Date().toISOString(),
    })

    await Swal.fire({
      title: 'Meter Reading Approved!',
      html: `
        <div class="text-start">
          <p><strong>${approval.RequestTitle}</strong> has been approved.</p>
          <hr/>
          <p><strong>Details:</strong></p>
          <ul>
            <li><strong>Pump:</strong> ${approval.RequestTitle}</li>
            <li><strong>Variance:</strong> ${approval.RequestAmount}L</li>
            <li><strong>Attendant:</strong> ${getRequesterName(approval.RequesterUserID)}</li>
            <li><strong>Station:</strong> ${getStationName(approval.RequesterStationID)}</li>
          </ul>
          <p class="text-success">✅ The attendant can now continue operations.</p>
        </div>
      `,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 5000,
      showConfirmButton: false,
    })

    closeApprovalModal()
    await refreshApprovalData()
  } catch (error) {
    console.error('💥 APPROVAL ERROR:', error)
    await Swal.fire({
      title: 'Approval Failed!',
      text: error.message,
      icon: 'error',
    })
  } finally {
    approvalProcessing.value = false
  }
}

const denyApproval = async () => {
  if (!selectedApproval.value) return

  if (!approvalComments.value) {
    await Swal.fire({
      title: 'Comments Required',
      text: 'Please provide detailed comments explaining why this meter reading variance is being denied.',
      icon: 'warning',
    })
    return
  }

  const result = await Swal.fire({
    title: 'Confirm Meter Reading Denial',
    html: `
      <div class="text-start">
        <p>Are you sure you want to deny this meter reading variance?</p>
        <hr/>
        <p><strong>Impact:</strong></p>
        <ul>
          <li>The attendant will need to re-record readings</li>
          <li>The pump will remain locked until corrected</li>
          <li>This will be logged in the audit trail</li>
        </ul>
        <p><strong>Your reason:</strong></p>
        <div class="bg-light p-3 rounded">${approvalComments.value}</div>
      </div>
    `,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, Deny Request',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
  })

  if (!result.isConfirmed) return

  approvalProcessing.value = true

  try {
    const approval = selectedApproval.value

    console.log('🔄 DENIAL PROCESSING: Starting meter reading denial workflow...')
    console.log('📊 DENIAL CONTEXT:', {
      approvalId: approval.ApprovalID,
      requestType: approval.RequestType,
      pumpId: approval.RequestTypeID,
      denialReason: approvalComments.value,
      denier: currentUser.value.name,
    })

    // STEP 1: Create detailed denial action record
    const actionData = {
      ApprovalID: approval.ApprovalID,
      StepID: null, // Single step approval - no escalation
      UserID: currentUser.value.id,
      ActionType: 'Denied',
      Comments: approvalComments.value,
      IPAddress: 'client_ip',
      UserAgent: navigator.userAgent,
    }

    console.log('📡 CREATING DENIAL ACTION:', actionData)
    await apiRequest('/ApprovalActions', {
      method: 'POST',
      body: JSON.stringify(actionData),
    })

    // STEP 2: Update main approval record - FINAL DENIAL
    const updateData = {
      Status: 'Denied',
      CompletedAt: new Date().toISOString(),
      CurrentApproverUserID: null, // Clear current approver - process complete
      CurrentApprovalLevel: '1', // Single level - no escalation
      Priority: 'Denied', // Mark as denied priority
    }

    console.log('📡 UPDATING APPROVAL STATUS TO DENIED:', updateData)
    await apiRequest(`/Approvals/${approval.ApprovalID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData),
    })

    // STEP 3: Handle Meter Reading Specific Logic
    if (approval.RequestType === 'Meter_Reading_Variance') {
      await handleMeterReadingApproval(approval, 'Denied')
    }

    // STEP 4: Create denial notification for requester
    const notificationData = {
      UserID: approval.RequesterUserID,
      StationID: approval.RequesterStationID,
      Channel: 'System',
      Type: 'Approval_Denied',
      Title: '❌ Meter Reading Denied',
      Message: `Your meter reading variance has been denied by ${currentUser.value.name}. Reason: ${approvalComments.value}. Please re-record accurate readings.`,
      Status: 'Queued',
      ScheduledAt: new Date().toISOString(),
    }

    console.log('📡 CREATING DENIAL NOTIFICATION:', notificationData)
    await apiRequest('/Notifications', {
      method: 'POST',
      body: JSON.stringify(notificationData),
    })

    // STEP 5: Comprehensive audit logging
    await logAuditAction('METER_READING_DENIED', {
      approvalId: approval.ApprovalID,
      requestType: approval.RequestType,
      pumpId: approval.RequestTypeID,
      stationId: approval.RequesterStationID,
      attendantId: approval.RequesterUserID,
      variance: approval.RequestAmount,
      riskScore: getAIRiskScore(approval),
      denialReason: approvalComments.value,
      denier: currentUser.value.name,
      approverLevel: approverLevel.value,
      completedAt: new Date().toISOString(),
    })

    await Swal.fire({
      title: 'Meter Reading Denied',
      html: `
        <div class="text-start">
          <p><strong>${approval.RequestTitle}</strong> has been denied.</p>
          <hr/>
          <p><strong>Reason:</strong> ${approvalComments.value}</p>
          <p class="text-warning">⚠️ The attendant must re-record accurate readings.</p>
        </div>
      `,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 5000,
      showConfirmButton: false,
    })

    closeApprovalModal()
    await refreshApprovalData()
  } catch (error) {
    console.error('💥 DENIAL ERROR:', error)
    await Swal.fire({
      title: 'Denial Failed!',
      text: error.message,
      icon: 'error',
    })
  } finally {
    approvalProcessing.value = false
  }
}

// METER READING SPECIFIC APPROVAL HANDLER
const handleMeterReadingApproval = async (approval, actionType) => {
  console.log('🔄 METER READING HANDLER: Processing specific meter reading logic...')
  console.log('📊 METER READING CONTEXT:', {
    pumpId: approval.RequestTypeID,
    stationId: approval.RequesterStationID,
    attendantId: approval.RequesterUserID,
    actionType: actionType,
  })

  try {
    if (actionType === 'Approved') {
      // STEP 1: Update DailyReadings status to approved
      const dailyReadingsResponse = await apiRequest(
        `/DailyReadings?PumpID=${approval.RequestTypeID}&RecordedBy=${approval.RequesterUserID}&Status=Pending_Approval`,
      )

      const dailyReadings = dailyReadingsResponse.records || []
      console.log('📡 FOUND DAILY READINGS:', dailyReadings.length)

      for (const reading of dailyReadings) {
        const updateData = {
          Status: 'Approved',
          VerifiedBy: currentUser.value.id,
          Notes:
            (reading.Notes || '') +
            ` | APPROVED by ${currentUser.value.name} on ${new Date().toISOString()}`,
        }

        console.log('📡 UPDATING DAILY READING:', reading.ReadingID, updateData)
        await apiRequest(`/DailyReadings/${reading.ReadingID}`, {
          method: 'PATCH',
          body: JSON.stringify(updateData),
        })

        // Update pump meter reading if current reading exists
        if (reading.ClosingReading) {
          const pumpUpdateData = {
            MeterReading: reading.ClosingReading,
            UpdatedAt: new Date().toISOString(),
          }

          console.log('📡 UPDATING PUMP METER READING:', approval.RequestTypeID, pumpUpdateData)
          await apiRequest(`/Pumps/${approval.RequestTypeID}`, {
            method: 'PATCH',
            body: JSON.stringify(pumpUpdateData),
          })
        }

        // Create inventory history record for approved variance
        const inventoryHistoryData = {
          StationID: approval.RequesterStationID,
          ProductID: reading.ProductID || 1, // Default to fuel product
          PumpID: approval.RequestTypeID,
          TransactionID: null,
          TransferID: null,
          ChangeDate: new Date().toISOString(),
          ChangeType: 'Variance_Approved',
          PreviousQuantity: reading.OpeningReading || '0',
          QuantityChange: reading.Variance || '0',
          NewQuantity: reading.ClosingReading || '0',
          ReasonForChange: `Meter reading variance approved: ${reading.Variance}L variance`,
          AdjustmentCategory: 'Approved_Variance',
          AuthorizedBy: currentUser.value.id,
          RecordedBy: approval.RequesterUserID,
          VerifiedBy: currentUser.value.id,
          Notes: `Approval ID: ${approval.ApprovalID} | Approved by: ${currentUser.value.name}`,
        }

        console.log('📡 CREATING INVENTORY HISTORY:', inventoryHistoryData)
        await apiRequest('/InventoryHistory', {
          method: 'POST',
          body: JSON.stringify(inventoryHistoryData),
        })
      }
    } else if (actionType === 'Denied') {
      // STEP 1: Update DailyReadings status to denied - requires re-recording
      const dailyReadingsResponse = await apiRequest(
        `/DailyReadings?PumpID=${approval.RequestTypeID}&RecordedBy=${approval.RequesterUserID}&Status=Pending_Approval`,
      )

      const dailyReadings = dailyReadingsResponse.records || []
      console.log('📡 FOUND DAILY READINGS FOR DENIAL:', dailyReadings.length)

      for (const reading of dailyReadings) {
        const updateData = {
          Status: 'Denied',
          VerifiedBy: currentUser.value.id,
          Notes:
            (reading.Notes || '') +
            ` | DENIED by ${currentUser.value.name} on ${new Date().toISOString()} - Reason: ${approvalComments.value}`,
        }

        console.log('📡 UPDATING DAILY READING TO DENIED:', reading.ReadingID, updateData)
        await apiRequest(`/DailyReadings/${reading.ReadingID}`, {
          method: 'PATCH',
          body: JSON.stringify(updateData),
        })

        // DO NOT update pump meter reading - attendant must re-record
      }
    }

    console.log('✅ METER READING HANDLER: Successfully processed meter reading logic')
  } catch (error) {
    console.error('💥 METER READING HANDLER ERROR:', error)
    throw error
  }
}

// Real-time Approval Status Polling for Meter Reading Integration
const startApprovalPolling = () => {
  console.log(
    '🔄 REAL-TIME POLLING: Starting approval status monitoring for meter reading integration...',
  )

  // Clear existing interval
  if (approvalPollingInterval.value) {
    clearInterval(approvalPollingInterval.value)
  }

  // Poll every 15 seconds for real-time updates
  approvalPollingInterval.value = setInterval(async () => {
    try {
      await checkForApprovalUpdates()
    } catch (error) {
      console.error('💥 APPROVAL POLLING ERROR:', error)
    }
  }, 15000) // More frequent polling for meter reading integration
}

const stopApprovalPolling = () => {
  if (approvalPollingInterval.value) {
    clearInterval(approvalPollingInterval.value)
    approvalPollingInterval.value = null
    console.log('🛑 REAL-TIME POLLING: Stopped')
  }
}

const checkForApprovalUpdates = async () => {
  if (loading.value) return // Don't poll while loading

  try {
    // Check for new meter reading approval requests
    const newApprovalsResponse = await apiRequest(
      '/Approvals?RequestType=Meter_Reading_Variance&Status=Pending',
    )
    const newApprovals = newApprovalsResponse.records || []

    // Check if we have new approvals that weren't in our list
    const currentApprovalIds = new Set(allApprovals.value.map((a) => a.ApprovalID))
    const actualNewApprovals = newApprovals.filter(
      (approval) => !currentApprovalIds.has(approval.ApprovalID),
    )

    if (actualNewApprovals.length > 0) {
      console.log('📡 NEW METER READING APPROVALS DETECTED:', actualNewApprovals.length)

      // Add new approvals to our list
      allApprovals.value = [...allApprovals.value, ...actualNewApprovals]

      // Update pending approvals
      pendingApprovals.value = allApprovals.value.filter(
        (approval) => approval.Status === 'Pending' && canApprove(approval),
      )

      // Show notification for new approvals
      if (actualNewApprovals.length > 0) {
        const notification = actualNewApprovals[0] // Show first new approval
        await Swal.fire({
          title: 'New Meter Reading Approval',
          html: `
            <div class="text-start">
              <p><strong>${notification.RequestTitle}</strong></p>
              <p><strong>Variance:</strong> ${notification.RequestAmount}L</p>
              <p><strong>Station:</strong> ${getStationName(notification.RequesterStationID)}</p>
              <p><strong>Attendant:</strong> ${getRequesterName(notification.RequesterUserID)}</p>
            </div>
          `,
          icon: 'info',
          toast: true,
          position: 'top-end',
          timer: 5000,
          showConfirmButton: false,
        })
      }
    }
  } catch (error) {
    console.error('Error checking for approval updates:', error)
  }
}

const getTotalSteps = (approval) => {
  // Calculate total steps based on approval type and amount
  const amount = parseFloat(approval.RequestAmount || '0')

  switch (approval.RequestType) {
    case 'Purchase_Order':
      return amount > 50000 ? 3 : 2
    case 'Price_Change':
      return 3
    case 'Emergency_Override':
      return 2
    default:
      return 2
  }
}

const getProgressPercentage = (approval) => {
  const currentLevel = parseInt(approval.CurrentApprovalLevel) || 1
  const totalSteps = getTotalSteps(approval)
  return Math.round((currentLevel / totalSteps) * 100)
}

// UI Helper Functions
const getApprovalCardClass = (approval) => {
  const riskScore = getAIRiskScore(approval)
  if (riskScore >= 80) return 'border-danger'
  if (riskScore >= 60) return 'border-warning'
  if (approval.Priority === 'Critical') return 'border-danger'
  return ''
}

const getApprovalStatusClass = (approval) => {
  switch (approval.Status) {
    case 'Approved':
      return 'bg-light-success'
    case 'Denied':
      return 'bg-light-danger'
    case 'Escalated':
      return 'bg-light-warning'
    default:
      return 'bg-light-primary'
  }
}

const getApprovalIconClass = (approval) => {
  switch (approval.Status) {
    case 'Approved':
      return 'ki-check text-success'
    case 'Denied':
      return 'ki-cross text-danger'
    case 'Escalated':
      return 'ki-arrow-up text-warning'
    default:
      return 'ki-time text-primary'
  }
}

const getStatusBadge = (status) => {
  switch (status) {
    case 'Approved':
      return 'badge-light-success'
    case 'Denied':
      return 'badge-light-danger'
    case 'Escalated':
      return 'badge-light-warning'
    case 'Pending':
      return 'badge-light-primary'
    default:
      return 'badge-light-secondary'
  }
}

const getPriorityBadge = (priority) => {
  switch (priority) {
    case 'Critical':
      return 'badge-light-danger'
    case 'High':
      return 'badge-light-warning'
    case 'Normal':
      return 'badge-light-info'
    case 'Low':
      return 'badge-light-secondary'
    default:
      return 'badge-light-secondary'
  }
}

const getFraudSeverityBadge = (severity) => {
  switch (severity) {
    case 'Critical':
      return 'badge-danger'
    case 'High':
      return 'badge-warning'
    case 'Medium':
      return 'badge-info'
    default:
      return 'badge-secondary'
  }
}

const getUrgencyBadge = (approval) => {
  const urgency = getUrgencyLevel(approval)
  switch (urgency) {
    case 'Critical':
      return 'badge-danger'
    case 'High':
      return 'badge-warning'
    case 'Medium':
      return 'badge-info'
    default:
      return 'badge-secondary'
  }
}

const getUrgencyLevel = (approval) => {
  const daysOld = getDaysOld(approval.RequestDate)
  const riskScore = getAIRiskScore(approval)

  if (approval.Priority === 'Critical' || riskScore >= 80 || daysOld >= 7) return 'Critical'
  if (approval.Priority === 'High' || riskScore >= 60 || daysOld >= 3) return 'High'
  if (daysOld >= 1) return 'Medium'
  return 'Low'
}

const getSLATimeRemaining = (approval) => {
  if (!approval.DueDate) return 'No SLA'

  const now = new Date()
  const due = new Date(approval.DueDate)
  const diff = due - now

  if (diff < 0) return 'Overdue'

  const hours = Math.floor(diff / (1000 * 60 * 60))
  if (hours < 24) return `${hours}h remaining`

  const days = Math.floor(hours / 24)
  return `${days}d remaining`
}

const getSLATimerClass = (approval) => {
  const remaining = getSLATimeRemaining(approval)
  if (remaining === 'Overdue') return 'text-danger'
  if (remaining.includes('h') && parseInt(remaining) <= 6) return 'text-warning'
  return 'text-info'
}

// Utility Functions
const formatCurrency = (amount) => {
  const num = parseFloat(amount || '0')
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
  }).format(num)
}

const formatDateTime = (dateString) => {
  if (!dateString) return 'Not set'
  return new Date(dateString).toLocaleString('en-UG')
}

const getDaysOld = (dateString) => {
  const date = new Date(dateString)
  const now = new Date()
  const diff = now - date
  return Math.floor(diff / (1000 * 60 * 60 * 24))
}

const getTimeAgo = (dateString) => {
  const date = new Date(dateString)
  const now = new Date()
  const diff = now - date

  const minutes = Math.floor(diff / (1000 * 60))
  if (minutes < 60) return `${minutes}m ago`

  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours}h ago`

  const days = Math.floor(hours / 24)
  return `${days}d ago`
}

const getRequesterName = (userId) => {
  const user = userLookup.get(userId)
  return user?.name || 'Unknown User'
}

const getRequesterPosition = (userId) => {
  const user = userLookup.get(userId)
  return user?.position || 'Unknown Position'
}

const getStationName = (stationId) => {
  return stationLookup.get(stationId) || 'Unknown Station'
}

const getDepartmentName = (deptId) => {
  return departmentLookup.get(deptId) || 'Unknown Department'
}

const getApproverName = (step) => {
  if (step.ApproverUserID) {
    return getRequesterName(step.ApproverUserID)
  }
  return step.ApproverType || 'Auto-assigned'
}

const getTimelineLineClass = (step, index) => {
  if (step.Status === 'Completed') return 'bg-success'
  if (step.Status === 'In_Progress') return 'bg-warning'
  return 'bg-light-secondary'
}

const getTimelineIconClass = (step) => {
  switch (step.Status) {
    case 'Completed':
      return 'bg-success'
    case 'In_Progress':
      return 'bg-warning'
    default:
      return 'bg-light-secondary'
  }
}

const getStepStatusBadge = (status) => {
  switch (status) {
    case 'Completed':
      return 'badge-light-success'
    case 'In_Progress':
      return 'badge-light-warning'
    default:
      return 'badge-light-secondary'
  }
}

const getActivityStatusClass = (action) => {
  switch (action) {
    case 'Approved':
      return 'bg-light-success'
    case 'Denied':
      return 'bg-light-danger'
    case 'Escalated':
      return 'bg-light-warning'
    default:
      return 'bg-light-info'
  }
}

const getActivityIconClass = (action) => {
  switch (action) {
    case 'Approved':
      return 'ki-check text-success'
    case 'Denied':
      return 'ki-cross text-danger'
    case 'Escalated':
      return 'ki-arrow-up text-warning'
    default:
      return 'ki-time text-info'
  }
}

// Modal Functions
const handleApprovalClick = (approval) => {
  selectedApproval.value = approval
  approvalComments.value = ''
  securityVerified.value = false

  // Generate fraud analysis for selected approval
  selectedApprovalFraudData.value = generateFraudAnalysis(approval)

  // Load approval steps (simplified)
  approvalSteps.value = [
    {
      StepID: 1,
      StepNumber: 1,
      ApproverType: approverLevel.value,
      ApproverUserID: currentUser.value.id,
      Status: 'In_Progress',
      StartedAt: approval.RequestDate,
    },
  ]

  openApprovalModal()
}

const openApprovalModal = () => {
  nextTick(() => {
    const modalElement = document.getElementById('approvalModal')
    if (modalElement) {
      approvalModalInstance = new bootstrap.Modal(modalElement)
      approvalModalInstance.show()
    }
  })
}

const closeApprovalModal = () => {
  if (approvalModalInstance) {
    approvalModalInstance.hide()
  }
  selectedApproval.value = null
  selectedApprovalFraudData.value = null
}

const showApprovalStats = () => {
  nextTick(() => {
    const modalElement = document.getElementById('statsModal')
    if (modalElement) {
      statsModalInstance = new bootstrap.Modal(modalElement)
      statsModalInstance.show()
    }
  })
}

const closeStatsModal = () => {
  if (statsModalInstance) {
    statsModalInstance.hide()
  }
}

// Filter Functions
const applyFilters = () => {
  // Filters are automatically applied via computed property
  console.log('Filters applied:', filters)
}

const resetFilters = () => {
  Object.keys(filters).forEach((key) => {
    filters[key] = ''
  })
}

// Fraud Investigation
const investigateFraud = async () => {
  if (!currentFraudAlert.value) return

  const result = await Swal.fire({
    title: 'Fraud Investigation',
    html: `
      <div class="text-start">
        <p><strong>Risk Score:</strong> ${currentFraudAlert.value.riskScore}%</p>
        <p><strong>Severity:</strong> ${currentFraudAlert.value.severity}</p>
        <p><strong>Description:</strong> ${currentFraudAlert.value.description}</p>
        <hr/>
        <p>How would you like to proceed?</p>
      </div>
    `,
    icon: 'warning',
    showCancelButton: true,
    showDenyButton: true,
    confirmButtonText: 'Escalate to Security',
    denyButtonText: 'Mark as False Positive',
    cancelButtonText: 'Continue Monitoring',
  })

  if (result.isConfirmed) {
    // Escalate to security
    await logAuditAction('FRAUD_ESCALATED', {
      fraudLogId: currentFraudAlert.value.id,
      action: 'escalated_to_security',
      riskScore: currentFraudAlert.value.riskScore,
    })

    await Swal.fire({
      title: 'Escalated!',
      text: 'Security team has been notified.',
      icon: 'success',
    })
  } else if (result.isDenied) {
    // Mark as false positive
    await logAuditAction('FRAUD_FALSE_POSITIVE', {
      fraudLogId: currentFraudAlert.value.id,
      action: 'marked_false_positive',
    })

    await Swal.fire({
      title: 'Marked as False Positive',
      text: 'The alert has been dismissed.',
      icon: 'info',
    })
  }

  currentFraudAlert.value = null
}

// Access Request Function
const requestApprovalAccess = async () => {
  const result = await Swal.fire({
    title: 'Request Approval Access',
    html: `
      <div class="text-start">
        <p>Submit a request for approval management access?</p>
        <hr/>
        <p><strong>Your Details:</strong></p>
        <ul>
          <li><strong>Name:</strong> ${currentUser.value.name}</li>
          <li><strong>Role:</strong> ${currentUserRole.value}</li>
          <li><strong>Position:</strong> ${currentUserPosition.value}</li>
          <li><strong>Station:</strong> ${userStation.value?.StationName}</li>
        </ul>
      </div>
    `,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Submit Request',
    cancelButtonText: 'Cancel',
  })

  if (result.isConfirmed) {
    try {
      const requestData = {
        RequestType: 'Access_Request',
        RequestTitle: 'Approval Management Access Request',
        RequestDetails: `User ${currentUser.value.name} requesting approval management access. Current role: ${currentUserRole.value}, Position: ${currentUserPosition.value}`,
        RequesterUserID: currentUser.value.id,
        RequesterStationID: userStation.value?.StationID,
        Status: 'Pending',
        Priority: 'Normal',
      }

      await apiRequest('/Approvals', {
        method: 'POST',
        body: JSON.stringify(requestData),
      })

      await Swal.fire({
        title: 'Request Submitted!',
        text: 'Your access request has been sent to management for review.',
        icon: 'success',
      })
    } catch (error) {
      await Swal.fire({
        title: 'Request Failed!',
        text: error.message,
        icon: 'error',
      })
    }
  }
}

// Data Refresh Function
const refreshApprovalData = async () => {
  loading.value = true
  loadingMessage.value = 'Refreshing approval data...'

  try {
    await loadApprovalData()

    await Swal.fire({
      title: 'Refreshed!',
      text: 'Approval data has been updated.',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    await Swal.fire({
      title: 'Refresh Failed!',
      text: error.message,
      icon: 'error',
    })
  } finally {
    loading.value = false
  }
}

// Audit Logging
const logAuditAction = async (action, data = {}) => {
  try {
    const auditLog = {
      StationID: userStation.value?.StationID,
      UserID: currentUser.value?.id,
      Action: action.toUpperCase(),
      TableName: 'Approvals',
      RecordID: data.approvalId || null,
      Changes: JSON.stringify({
        ...data,
        sessionId: sessionId.value,
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
        approverLevel: approverLevel.value,
        authorityLevel: authorityLevel.value,
      }),
      IPAddress: 'client_ip',
    }

    await apiRequest('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify(auditLog),
    })
  } catch (error) {
    console.error('Audit logging failed:', error)
  }
}

// Component Initialization - Meter Reading Approval Focus
onMounted(async () => {
  console.log(
    '🔄 METER READING APPROVAL MANAGEMENT: Initializing with authority level:',
    approverLevel.value,
  )

  // Start time update interval
  updateCurrentTime()
  const timeUpdateInterval = setInterval(updateCurrentTime, 60000)

  // Authentication verification
  if (!authData.value.user || !userStation.value) {
    console.error('❌ AUTHENTICATION: Missing user or station data')
    await Swal.fire({
      title: 'Authentication Required',
      text: 'Please login to access the meter reading approval system',
      icon: 'warning',
    })
    window.location.href = '/login'
    return
  }

  // Access control check for meter reading approvals
  if (!hasApprovalAuthority.value) {
    console.log('❌ ACCESS CONTROL: Insufficient approval authority for meter reading approvals')
    loading.value = false
    return
  }

  try {
    await loadApprovalData()

    // Start real-time polling for meter reading approval updates
    startApprovalPolling()

    console.log('✅ METER READING APPROVAL MANAGEMENT: Initialization completed')
    console.log('📊 METER READING APPROVAL FINAL STATE:', {
      userRole: currentUserRole.value,
      userPosition: currentUserPosition.value,
      approverLevel: approverLevel.value,
      authorityLevel: authorityLevel.value,
      totalApprovals: allApprovals.value.length,
      pendingApprovals: pendingApprovals.value.length,
      meterReadingApprovals: allApprovals.value.filter(
        (a) => a.RequestType === 'Meter_Reading_Variance',
      ).length,
      highRiskApprovals: highRiskApprovals.value,
      fraudAlerts: fraudDetectionLogs.value.length,
      stationId: userStation.value?.StationID,
      stationName: userStation.value?.StationName,
    })
  } catch (error) {
    console.error('💥 METER READING APPROVAL INITIALIZATION ERROR:', error)
    await Swal.fire({
      title: 'System Error!',
      text: error.message,
      icon: 'error',
    })
  } finally {
    loading.value = false
  }

  // Cleanup function
  onUnmounted(() => {
    clearInterval(timeUpdateInterval)
    stopApprovalPolling()
  })
})
</script>

<style scoped>
/* iOS-Native Approval Card Styling */
.approval-card {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 20px;
  background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.approval-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 15px 45px rgba(0, 0, 0, 0.15);
}

.approval-card:active {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

/* Critical fraud risk overlay */
.approval-card.border-danger {
  border: 2px solid #f1416c !important;
  box-shadow: 0 4px 20px rgba(241, 65, 108, 0.3);
}

.approval-card.border-danger:hover {
  box-shadow: 0 15px 45px rgba(241, 65, 108, 0.4);
}

.approval-card.border-warning {
  border: 2px solid #ffc700 !important;
  box-shadow: 0 4px 20px rgba(255, 199, 0, 0.3);
}

/* Modal enhancements */
.modal-content {
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
}

.modal-header {
  border-bottom: none;
  padding: 2.5rem 2.5rem 1.5rem;
  background: linear-gradient(135deg, #3699ff 0%, #0077b6 100%);
}

.modal-body {
  padding: 1.5rem 2.5rem 2.5rem;
  max-height: 70vh;
  overflow-y: auto;
}

.modal-footer {
  border-top: none;
  padding: 1.5rem 2.5rem 2.5rem;
}

/* Form controls */
.form-control:focus,
.form-select:focus {
  border-color: var(--bs-primary);
  box-shadow: 0 0 0 0.25rem rgba(54, 153, 255, 0.15);
  transform: translateY(-1px);
}

.form-control-lg,
.form-select-lg {
  border-radius: 16px;
  padding: 1.25rem 1.5rem;
  font-weight: 500;
  transition: all 0.3s ease;
}

/* Button styling */
.btn {
  border-radius: 16px;
  font-weight: 600;
  padding: 1rem 2rem;
  border-width: 2px;
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.btn-lg {
  border-radius: 20px;
  padding: 1.25rem 2.5rem;
}

/* Progress bars */
.progress {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
}

.progress-bar {
  transition: width 0.8s ease-in-out;
  border-radius: 12px;
}

/* Timeline styling */
.timeline {
  position: relative;
  padding-left: 2rem;
}

.timeline-item {
  position: relative;
  margin-bottom: 2rem;
}

.timeline-line {
  position: absolute;
  left: -2rem;
  top: 1rem;
  width: 2px;
  height: 100%;
  background: var(--bs-gray-300);
}

.timeline-icon {
  position: absolute;
  left: -2.5rem;
  top: 0;
  width: 3rem;
  height: 3rem;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.timeline-content {
  background: white;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  margin-left: 1rem;
}

/* Badge enhancements */
.badge {
  border-radius: 12px;
  font-weight: 600;
  padding: 0.5rem 1rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.badge:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* Card styling */
.card {
  border-radius: 20px;
  border: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.card-flush > .card-body {
  padding: 2rem;
}

/* Alert styling */
.alert {
  border-radius: 16px;
  border: none;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.alert-dismissible .btn-close {
  padding: 1rem;
}

/* Symbol enhancements */
.symbol {
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.symbol:hover {
  transform: scale(1.05);
}

/* Loading animation */
.spinner-border {
  width: 4rem;
  height: 4rem;
  border-width: 0.4rem;
}

/* Authority level indicators */
.authority-unlimited {
  background: linear-gradient(135deg, #00d4aa 0%, #00a085 100%);
  color: white;
}

.authority-finance {
  background: linear-gradient(135deg, #3699ff 0%, #0077b6 100%);
  color: white;
}

.authority-station {
  background: linear-gradient(135deg, #ffc700 0%, #ff8c00 100%);
  color: white;
}

.authority-limited {
  background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
  color: white;
}

/* Fraud detection styling */
.fraud-risk-critical {
  background: linear-gradient(135deg, #f1416c 0%, #dc3545 100%);
  color: white;
  animation: pulseRed 2s ease-in-out infinite;
}

@keyframes pulseRed {
  0% {
    box-shadow: 0 0 5px rgba(241, 65, 108, 0.5);
  }
  50% {
    box-shadow: 0 0 25px rgba(241, 65, 108, 0.8);
  }
  100% {
    box-shadow: 0 0 5px rgba(241, 65, 108, 0.5);
  }
}

.fraud-analysis {
  background: linear-gradient(135deg, rgba(241, 65, 108, 0.05) 0%, rgba(241, 65, 108, 0.1) 100%);
  border: 2px solid rgba(241, 65, 108, 0.2);
  border-radius: 20px;
}

/* Security verification */
.security-verification {
  background: linear-gradient(135deg, rgba(255, 199, 0, 0.1) 0%, rgba(255, 193, 7, 0.15) 100%);
  border: 2px solid rgba(255, 199, 0, 0.3);
  border-radius: 16px;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .modal-dialog {
    margin: 1rem;
  }

  .modal-xl {
    max-width: calc(100% - 2rem);
  }

  .card-body {
    padding: 1.5rem;
  }

  .btn {
    padding: 0.75rem 1.5rem;
  }

  .modal-header {
    padding: 2rem 2rem 1rem;
  }

  .modal-body {
    padding: 1rem 2rem 2rem;
    max-height: 60vh;
  }

  .modal-footer {
    padding: 1rem 2rem 2rem;
  }

  .timeline {
    padding-left: 1.5rem;
  }

  .timeline-icon {
    left: -2rem;
    width: 2.5rem;
    height: 2.5rem;
  }

  .timeline-content {
    margin-left: 0.5rem;
    padding: 1rem;
  }
}

/* Animation classes */
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.approval-card {
  animation: slideInUp 0.6s ease-out;
}

.alert {
  animation: fadeIn 0.5s ease-out;
}

/* Custom utilities */
.h-8px {
  height: 8px;
}

.min-vh-100 {
  min-height: 100vh;
}

/* Print styles */
@media print {
  .approval-card {
    background: white !important;
    box-shadow: none !important;
    border: 1px solid #dee2e6 !important;
  }

  .modal {
    display: none !important;
  }

  .btn {
    display: none !important;
  }
}

/* High contrast mode support */
@media (prefers-contrast: high) {
  .approval-card {
    border: 2px solid #000;
  }

  .badge {
    border: 1px solid #000;
  }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
  .approval-card,
  .btn,
  .badge,
  .progress-bar {
    transition: none;
  }

  .approval-card:hover {
    transform: none;
  }

  .btn:hover {
    transform: none;
  }
}

/* Focus states for accessibility */
.approval-card:focus {
  outline: 3px solid rgba(54, 153, 255, 0.5);
  outline-offset: 2px;
}

.btn:focus {
  outline: 3px solid rgba(54, 153, 255, 0.5);
  outline-offset: 2px;
}

/* Screen reader only content */
.sr-only {
  position: absolute !important;
  width: 1px !important;
  height: 1px !important;
  padding: 0 !important;
  margin: -1px !important;
  overflow: hidden !important;
  clip: rect(0, 0, 0, 0) !important;
  white-space: nowrap !important;
  border: 0 !important;
}
</style>

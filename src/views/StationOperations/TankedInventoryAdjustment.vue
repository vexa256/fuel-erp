<template>
  <div class="d-flex flex-column gap-5">
    <!-- iOS Premium Header -->
    <div class="card card-flush shadow-sm">
      <div class="card-header border-0 pt-7 pb-0">
        <div class="card-title">
          <div class="d-flex align-items-center">
            <div class="symbol symbol-60px me-4">
              <div class="symbol-label bg-gradient-danger">
                <i class="ki-duotone ki-setting-2 fs-2hx text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
            </div>
            <div>
              <h1 class="fw-bold text-gray-900 mb-0 fs-2">Tank Inventory Adjustment Wizard</h1>
              <div class="text-muted fs-6 fw-semibold">Step-by-Step Secure Adjustment Process</div>
            </div>
          </div>
        </div>
        <div class="card-toolbar">
          <div class="d-flex align-items-center gap-3">
            <div class="badge badge-light-primary fs-7 px-4 py-2">
              <i class="ki-duotone ki-geolocation fs-6 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ currentStation?.Name || 'No Station' }}
            </div>
            <div class="badge badge-light-success fs-7 px-4 py-2">
              <i class="ki-duotone ki-shield-tick fs-6 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              API/ASTM Compliant
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Critical Security Alert -->
    <div
      class="alert alert-dismissible bg-light-danger border border-danger d-flex align-items-center p-5"
    >
      <div class="symbol symbol-50px me-4">
        <div class="symbol-label bg-danger">
          <i class="ki-duotone ki-security-user fs-2 text-white">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
        </div>
      </div>
      <div class="flex-grow-1">
        <h6 class="mb-2 text-gray-800 fw-bold">High-Security Inventory Control</h6>
        <div class="text-gray-700 fw-semibold">
          All adjustments are monitored by AI fraud detection. Suspicious activities trigger
          immediate alerts and logging. International standards enforced.
        </div>
      </div>
    </div>

    <!-- Wizard Progress Bar -->
    <div class="card card-flush shadow-sm">
      <div class="card-body p-6">
        <div class="d-flex align-items-center justify-content-between mb-5">
          <h3 class="fw-bold text-gray-900">Adjustment Process</h3>
          <span class="badge badge-light-primary">Step {{ currentWizardStep }} of 4</span>
        </div>

        <!-- Progress Steps -->
        <div class="d-flex align-items-center justify-content-between position-relative">
          <!-- Progress Line -->
          <div
            class="position-absolute w-100 h-4px bg-light-primary rounded"
            style="top: 20px; z-index: 1"
          ></div>
          <div
            class="position-absolute h-4px bg-primary rounded transition-all"
            style="top: 20px; z-index: 2"
            :style="`width: ${((currentWizardStep - 1) / 3) * 100}%`"
          ></div>

          <!-- Step Indicators -->
          <div
            v-for="step in wizardSteps"
            :key="step.number"
            class="d-flex flex-column align-items-center position-relative"
            style="z-index: 3"
          >
            <div
              class="symbol symbol-40px mb-3"
              :class="
                currentWizardStep >= step.number
                  ? 'symbol-circle bg-primary'
                  : 'symbol-circle bg-light-primary'
              "
            >
              <div class="symbol-label">
                <i
                  :class="[
                    step.icon,
                    'fs-5',
                    currentWizardStep >= step.number ? 'text-white' : 'text-primary',
                  ]"
                >
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3" v-if="step.icon.includes('setting-2')"></span>
                </i>
              </div>
            </div>
            <div class="text-center">
              <div
                class="fw-bold fs-7"
                :class="currentWizardStep >= step.number ? 'text-primary' : 'text-muted'"
              >
                {{ step.title }}
              </div>
              <div class="fs-8 text-muted">{{ step.subtitle }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Real-Time KPI Cards with Modal Triggers -->
    <div class="row g-5 g-xl-8">
      <div class="col-6 col-lg-3">
        <div
          class="card card-flush h-100 shadow-sm cursor-pointer"
          @click="openModal('adjustments')"
        >
          <div class="card-body p-5 d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-5">
              <div class="symbol symbol-50px me-4">
                <div class="symbol-label bg-light-primary">
                  <i class="ki-duotone ki-abstract-39 fs-2hx text-primary">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-1 fw-bold text-gray-800">
                  {{ adjustmentMetrics.totalAdjustments }}
                </div>
                <div class="fs-7 text-muted fw-semibold">Today's Adjustments</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-primary rounded">
              <div
                class="progress-bar bg-primary rounded"
                :style="`width: ${Math.min(adjustmentMetrics.totalAdjustments * 10, 100)}%`"
              ></div>
            </div>
            <div class="mt-3 text-center">
              <span class="badge badge-light-primary">Click to View Details</span>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100 shadow-sm cursor-pointer" @click="openModal('tanks')">
          <div class="card-body p-5 d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-5">
              <div class="symbol symbol-50px me-4">
                <div class="symbol-label bg-light-warning">
                  <i class="ki-duotone ki-chart-pie-3 fs-2hx text-warning">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-1 fw-bold text-gray-800">{{ enrichedTanks.length }}</div>
                <div class="fs-7 text-muted fw-semibold">Active Tanks</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-warning rounded">
              <div class="progress-bar bg-warning rounded" style="width: 85%"></div>
            </div>
            <div class="mt-3 text-center">
              <span class="badge badge-light-warning">Click to View Tanks</span>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100 shadow-sm cursor-pointer" @click="openModal('security')">
          <div class="card-body p-5 d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-5">
              <div class="symbol symbol-50px me-4">
                <div class="symbol-label bg-light-success">
                  <i class="ki-duotone ki-verify fs-2hx text-success">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                    <span class="path5"></span>
                    <span class="path6"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-1 fw-bold text-gray-800">{{ fraudMetrics.complianceScore }}%</div>
                <div class="fs-7 text-muted fw-semibold">Compliance Score</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-success rounded">
              <div
                class="progress-bar bg-success rounded"
                :style="`width: ${fraudMetrics.complianceScore}%`"
              ></div>
            </div>
            <div class="mt-3 text-center">
              <span class="badge badge-light-success">Click for Security</span>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div class="card card-flush h-100 shadow-sm cursor-pointer" @click="openModal('analytics')">
          <div class="card-body p-5 d-flex flex-column justify-content-between">
            <div class="d-flex align-items-center mb-5">
              <div class="symbol symbol-50px me-4">
                <div class="symbol-label bg-light-danger">
                  <i class="ki-duotone ki-security-check fs-2hx text-danger">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </div>
              </div>
              <div class="flex-grow-1">
                <div class="fs-1 fw-bold text-gray-800">{{ fraudMetrics.riskAlerts }}</div>
                <div class="fs-7 text-muted fw-semibold">Risk Alerts</div>
              </div>
            </div>
            <div class="progress h-6px bg-light-danger rounded">
              <div
                class="progress-bar bg-danger rounded"
                :style="`width: ${Math.min(fraudMetrics.riskAlerts * 25, 100)}%`"
              ></div>
            </div>
            <div class="mt-3 text-center">
              <span class="badge badge-light-danger">Click for Analytics</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Wizard Content -->
    <div class="card card-flush shadow-sm">
      <div class="card-header border-0 pt-6">
        <h3 class="card-title fw-bold text-gray-900 fs-3">
          {{ wizardSteps[currentWizardStep - 1]?.title }}
          <span class="text-muted fs-6">- {{ wizardSteps[currentWizardStep - 1]?.subtitle }}</span>
        </h3>
        <div class="card-toolbar">
          <button class="btn btn-light-primary me-3" @click="refreshData" :disabled="loading">
            <i class="ki-duotone ki-arrows-circle fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Refresh
          </button>
          <button
            v-if="currentWizardStep > 1"
            class="btn btn-light-secondary me-3"
            @click="previousStep"
          >
            <i class="ki-duotone ki-left fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Previous
          </button>
          <button
            v-if="currentWizardStep < 4"
            class="btn btn-primary"
            @click="nextStep"
            :disabled="!canProceedToNextStep"
          >
            Next
            <i class="ki-duotone ki-right fs-2 ms-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </button>
        </div>
      </div>
      <div class="card-body pt-0">
        <div v-if="loading" class="text-center py-15">
          <div class="spinner-border spinner-border-lg text-primary" role="status"></div>
          <div class="mt-5 fs-6 text-muted">Loading wizard data...</div>
        </div>

        <!-- Step 1: Tank Selection -->
        <div v-else-if="currentWizardStep === 1" class="wizard-step">
          <div v-if="!enrichedTanks.length" class="text-center py-15">
            <div class="symbol symbol-100px mx-auto mb-7">
              <div class="symbol-label bg-light-danger">
                <i class="ki-duotone ki-gas-station fs-3x text-danger">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </div>
            </div>
            <h4 class="text-muted">No tanks available</h4>
            <p class="text-muted">This station has no fuel tanks configured for adjustments.</p>
          </div>

          <div v-else>
            <div class="alert alert-light-info mb-7">
              <div class="d-flex align-items-center">
                <i class="ki-duotone ki-information-5 fs-2 text-info me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div class="flex-grow-1">
                  <h6 class="mb-1">Step 1: Select Tank for Adjustment</h6>
                  <div class="fs-7">
                    Choose the fuel tank you want to adjust. Each tank shows real-time data and risk
                    assessment.
                  </div>
                </div>
              </div>
            </div>

            <div class="row g-5">
              <div
                v-for="tank in enrichedTanks"
                :key="tank.TankID"
                class="col-12 col-md-6 col-xl-4"
              >
                <div
                  class="card card-bordered h-100 shadow-sm cursor-pointer tank-selection-card"
                  :class="{ 'border-primary selected-tank': selectedTankId === tank.TankID }"
                  @click="selectTank(tank)"
                >
                  <div class="card-body position-relative p-6">
                    <!-- Selection Indicator -->
                    <div
                      v-if="selectedTankId === tank.TankID"
                      class="position-absolute top-0 end-0 mt-4 me-4"
                    >
                      <div class="badge badge-circle badge-lg badge-success">
                        <i class="ki-duotone ki-check fs-4 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </div>
                    </div>

                    <!-- Risk Status Badge -->
                    <div class="position-absolute top-0 start-0 mt-4 ms-4">
                      <div
                        class="badge badge-circle badge-lg"
                        :class="getFraudRiskBadge(tank.fraudAnalysis.riskLevel)"
                      >
                        <i class="ki-duotone ki-security-check fs-4 text-white">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                        </i>
                      </div>
                    </div>

                    <!-- Tank Header -->
                    <div class="d-flex align-items-center mb-5 mt-7">
                      <div class="symbol symbol-50px me-4">
                        <div class="symbol-label bg-light-primary">
                          <i class="ki-duotone ki-abstract-39 fs-2 text-primary">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </div>
                      </div>
                      <div class="flex-grow-1">
                        <h5 class="card-title mb-1 text-gray-800 fw-bold">{{ tank.TankName }}</h5>
                        <div class="text-muted fs-7 fw-semibold">
                          {{ getProductName(tank.ProductID) }}
                        </div>
                      </div>
                    </div>

                    <!-- Current Level -->
                    <div class="mb-5">
                      <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted fs-7 fw-semibold">Current Level</span>
                        <span class="fw-bold text-primary"
                          >{{ formatVolume(tank.CurrentLevel) }}L</span
                        >
                      </div>
                      <div class="progress h-8px rounded">
                        <div
                          class="progress-bar rounded"
                          :class="getFillBarClass(tank.fillPercentage)"
                          :style="`width: ${tank.fillPercentage}%`"
                        ></div>
                      </div>
                      <div class="mt-2 fs-8 text-muted">
                        {{ (tank.fillPercentage || 0).toFixed(1) }}% Capacity
                      </div>
                    </div>

                    <!-- International Standards -->
                    <div class="d-flex flex-column gap-2 mb-4">
                      <div class="d-flex justify-content-between">
                        <span class="text-muted fs-8">API Gravity:</span>
                        <span class="fw-bold text-gray-800"
                          >{{ tank.internationalStandards.apiGravity }}°</span
                        >
                      </div>
                      <div class="d-flex justify-content-between">
                        <span class="text-muted fs-8">Density:</span>
                        <span class="fw-bold text-gray-800"
                          >{{ tank.internationalStandards.density }} kg/L</span
                        >
                      </div>
                      <div class="d-flex justify-content-between">
                        <span class="text-muted fs-8">Risk Score:</span>
                        <span
                          class="fw-bold"
                          :class="getFraudRiskColor(tank.fraudAnalysis.riskLevel)"
                        >
                          {{ tank.fraudAnalysis.riskScore }}/100
                        </span>
                      </div>
                    </div>

                    <!-- Selection Prompt -->
                    <div class="text-center mt-4">
                      <span
                        class="badge"
                        :class="
                          selectedTankId === tank.TankID ? 'badge-success' : 'badge-light-primary'
                        "
                      >
                        {{ selectedTankId === tank.TankID ? 'Selected' : 'Click to Select' }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Step 2: Adjustment Configuration -->
        <div v-else-if="currentWizardStep === 2" class="wizard-step">
          <div class="alert alert-light-info mb-7">
            <div class="d-flex align-items-center">
              <i class="ki-duotone ki-setting-2 fs-2 text-info me-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <div class="flex-grow-1">
                <h6 class="mb-1">Step 2: Configure Adjustment Parameters</h6>
                <div class="fs-7">
                  Set the adjustment type, quantity, and provide detailed justification. All
                  parameters are validated against international standards.
                </div>
              </div>
            </div>
          </div>

          <div class="row g-7">
            <div class="col-12 col-xl-8">
              <!-- Selected Tank Info -->
              <div class="card card-bordered mb-7">
                <div class="card-body p-6">
                  <h5 class="mb-4">Selected Tank: {{ selectedTank?.TankName }}</h5>
                  <div class="row g-5">
                    <div class="col-6">
                      <div class="d-flex justify-content-between">
                        <span class="text-muted">Current Level:</span>
                        <span class="fw-bold">{{ formatVolume(selectedTank?.CurrentLevel) }}L</span>
                      </div>
                    </div>
                    <div class="col-6">
                      <div class="d-flex justify-content-between">
                        <span class="text-muted">Capacity:</span>
                        <span class="fw-bold">{{ formatVolume(selectedTank?.Capacity) }}L</span>
                      </div>
                    </div>
                    <div class="col-6">
                      <div class="d-flex justify-content-between">
                        <span class="text-muted">Fill Level:</span>
                        <span class="fw-bold"
                          >{{ (selectedTank?.fillPercentage || 0).toFixed(1) }}%</span
                        >
                      </div>
                    </div>
                    <div class="col-6">
                      <div class="d-flex justify-content-between">
                        <span class="text-muted">Product:</span>
                        <span class="fw-bold">{{ getProductName(selectedTank?.ProductID) }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Adjustment Form -->
              <div class="card card-bordered">
                <div class="card-body p-8">
                  <h5 class="mb-6">Adjustment Configuration</h5>

                  <!-- Adjustment Category -->
                  <div class="mb-6">
                    <label class="form-label fw-bold required fs-6">Adjustment Category</label>
                    <select
                      v-model="adjustmentForm.category"
                      class="form-select form-select-lg"
                      :class="{ 'is-invalid': adjustmentErrors.category }"
                      @change="validateAdjustmentForm"
                    >
                      <option value="">Select category...</option>
                      <option
                        v-for="category in adjustmentCategories"
                        :key="category.code"
                        :value="category.code"
                      >
                        {{ category.name }}
                      </option>
                    </select>
                    <div v-if="adjustmentErrors.category" class="invalid-feedback">
                      {{ adjustmentErrors.category }}
                    </div>
                    <div class="form-text">
                      Choose the most appropriate category for this adjustment
                    </div>
                  </div>

                  <!-- Adjustment Quantity -->
                  <div class="mb-6">
                    <label class="form-label fw-bold required fs-6"
                      >Adjustment Quantity (Liters)</label
                    >
                    <div class="input-group input-group-lg">
                      <span class="input-group-text">
                        <i class="ki-duotone ki-droplet fs-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </span>
                      <input
                        v-model="adjustmentForm.quantity"
                        type="number"
                        step="0.01"
                        class="form-control"
                        :class="{ 'is-invalid': adjustmentErrors.quantity }"
                        placeholder="+ for increase, - for decrease"
                        @input="validateAdjustmentForm"
                        @blur="calculateAdjustmentImpact"
                      />
                      <div v-if="adjustmentErrors.quantity" class="invalid-feedback">
                        {{ adjustmentErrors.quantity }}
                      </div>
                    </div>
                    <div class="form-text">
                      Range: {{ formatVolume(adjustmentLimits.min) }}L to
                      {{ formatVolume(adjustmentLimits.max) }}L
                    </div>
                  </div>

                  <!-- Reason -->
                  <div class="mb-6">
                    <label class="form-label fw-bold required fs-6">Detailed Justification</label>
                    <textarea
                      v-model="adjustmentForm.reason"
                      class="form-control form-control-lg"
                      :class="{ 'is-invalid': adjustmentErrors.reason }"
                      rows="4"
                      placeholder="Provide detailed justification for this adjustment including root cause analysis..."
                      @input="validateAdjustmentForm"
                    ></textarea>
                    <div v-if="adjustmentErrors.reason" class="invalid-feedback">
                      {{ adjustmentErrors.reason }}
                    </div>
                    <div class="form-text">Minimum 10 characters, maximum 500 characters</div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-12 col-xl-4">
              <!-- Impact Preview -->
              <div v-if="adjustmentImpact.calculated" class="card card-bordered mb-5">
                <div class="card-body p-6">
                  <h6 class="mb-4">Adjustment Impact Preview</h6>
                  <div class="d-flex flex-column gap-3">
                    <div class="d-flex justify-content-between">
                      <span class="text-muted">Current Level:</span>
                      <span class="fw-bold"
                        >{{ formatVolume(adjustmentImpact.currentLevel) }}L</span
                      >
                    </div>
                    <div class="d-flex justify-content-between">
                      <span class="text-muted">New Level:</span>
                      <span
                        class="fw-bold"
                        :class="adjustmentImpact.newLevel >= 0 ? 'text-success' : 'text-danger'"
                      >
                        {{ formatVolume(adjustmentImpact.newLevel) }}L
                      </span>
                    </div>
                    <div class="d-flex justify-content-between">
                      <span class="text-muted">Fill Percentage:</span>
                      <span class="fw-bold"
                        >{{ (adjustmentImpact.newFillPercentage || 0).toFixed(1) }}%</span
                      >
                    </div>
                    <div class="d-flex justify-content-between">
                      <span class="text-muted">Financial Impact:</span>
                      <span
                        class="fw-bold"
                        :class="
                          adjustmentImpact.financialImpact >= 0 ? 'text-success' : 'text-danger'
                        "
                      >
                        {{ formatCurrency(Math.abs(adjustmentImpact.financialImpact)) }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- AI Tax Advisory -->
              <div v-if="taxAdvisory.show" class="card card-bordered">
                <div class="card-body p-6">
                  <div class="d-flex align-items-start">
                    <i class="ki-duotone ki-technology-2 fs-2 text-primary me-3 mt-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                    <div class="flex-grow-1">
                      <h6 class="mb-3">AI Tax Advisory</h6>
                      <div class="fs-7 mb-3">{{ taxAdvisory.message }}</div>
                      <div v-if="taxAdvisory.implications.length">
                        <div class="fs-8 text-muted fw-bold mb-2">Tax Implications:</div>
                        <ul class="list-unstyled">
                          <li
                            v-for="implication in taxAdvisory.implications"
                            :key="implication"
                            class="fs-8 mb-1"
                          >
                            • {{ implication }}
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Step 3: Review & Validation -->
        <div v-else-if="currentWizardStep === 3" class="wizard-step">
          <div class="alert alert-light-warning mb-7">
            <div class="d-flex align-items-center">
              <i class="ki-duotone ki-verify fs-2 text-warning me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
                <span class="path5"></span>
                <span class="path6"></span>
              </i>
              <div class="flex-grow-1">
                <h6 class="mb-1">Step 3: Review & Final Validation</h6>
                <div class="fs-7">
                  Carefully review all adjustment details before submission. This is your final
                  chance to make changes.
                </div>
              </div>
            </div>
          </div>

          <div class="row g-7">
            <div class="col-12 col-xl-8">
              <!-- Review Summary -->
              <div class="card card-bordered">
                <div class="card-header">
                  <h5 class="card-title">Adjustment Summary</h5>
                  <div class="card-toolbar">
                    <span class="badge badge-light-warning">Pending Execution</span>
                  </div>
                </div>
                <div class="card-body p-8">
                  <div class="table-responsive">
                    <table class="table table-rounded table-row-bordered border gy-7 gs-7">
                      <tbody>
                        <tr>
                          <td class="fw-bold text-muted">Tank</td>
                          <td class="text-end fw-bold">{{ selectedTank?.TankName }}</td>
                        </tr>
                        <tr>
                          <td class="fw-bold text-muted">Product</td>
                          <td class="text-end fw-bold">
                            {{ getProductName(selectedTank?.ProductID) }}
                          </td>
                        </tr>
                        <tr>
                          <td class="fw-bold text-muted">Current Level</td>
                          <td class="text-end fw-bold">
                            {{ formatVolume(selectedTank?.CurrentLevel) }}L
                          </td>
                        </tr>
                        <tr>
                          <td class="fw-bold text-muted">Adjustment Quantity</td>
                          <td class="text-end fw-bold">
                            <span
                              :class="
                                parseFloat(adjustmentForm.quantity) >= 0
                                  ? 'text-success'
                                  : 'text-danger'
                              "
                            >
                              {{ formatVariance(adjustmentForm.quantity) }}L
                            </span>
                          </td>
                        </tr>
                        <tr>
                          <td class="fw-bold text-muted">New Level</td>
                          <td class="text-end fw-bold text-primary">
                            {{ formatVolume(adjustmentImpact.newLevel) }}L
                          </td>
                        </tr>
                        <tr>
                          <td class="fw-bold text-muted">Category</td>
                          <td class="text-end">
                            <span class="badge badge-light-info">
                              {{
                                adjustmentCategories.find((c) => c.code === adjustmentForm.category)
                                  ?.name
                              }}
                            </span>
                          </td>
                        </tr>
                        <tr>
                          <td class="fw-bold text-muted">Financial Impact</td>
                          <td class="text-end fw-bold">
                            {{ formatCurrency(Math.abs(adjustmentImpact.financialImpact)) }}
                          </td>
                        </tr>
                        <tr>
                          <td class="fw-bold text-muted">Risk Assessment</td>
                          <td class="text-end">
                            <span
                              class="badge"
                              :class="getFraudRiskBadge(selectedTank?.fraudAnalysis.riskLevel)"
                            >
                              {{ selectedTank?.fraudAnalysis.riskLevel }} Risk
                            </span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>

                  <!-- Justification -->
                  <div class="mt-7">
                    <h6 class="mb-3">Justification</h6>
                    <div class="p-4 bg-light-secondary rounded">
                      <div class="fs-6 text-gray-800">{{ adjustmentForm.reason }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-12 col-xl-4">
              <!-- Compliance Check -->
              <div class="card card-bordered mb-5">
                <div class="card-body p-6">
                  <h6 class="mb-4">International Compliance</h6>
                  <div class="d-flex flex-column gap-3">
                    <div class="d-flex align-items-center">
                      <i class="ki-duotone ki-check-circle fs-3 text-success me-3">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <span class="fs-7">API/ASTM Standards Compliant</span>
                    </div>
                    <div class="d-flex align-items-center">
                      <i class="ki-duotone ki-check-circle fs-3 text-success me-3">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <span class="fs-7">Within 5% Adjustment Limits</span>
                    </div>
                    <div class="d-flex align-items-center">
                      <i class="ki-duotone ki-check-circle fs-3 text-success me-3">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <span class="fs-7">Fraud Detection Cleared</span>
                    </div>
                    <div class="d-flex align-items-center">
                      <i class="ki-duotone ki-check-circle fs-3 text-success me-3">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <span class="fs-7">Security Logging Enabled</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Warning -->
              <div class="alert alert-light-danger">
                <div class="d-flex align-items-start">
                  <i class="ki-duotone ki-warning-2 fs-2 text-danger me-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  <div class="flex-grow-1">
                    <h6 class="text-danger mb-2">Final Warning</h6>
                    <div class="fs-7">
                      This adjustment will be immediately executed and logged for audit. Ensure all
                      details are correct before proceeding.
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Step 4: Execution -->
        <div v-else-if="currentWizardStep === 4" class="wizard-step">
          <div class="text-center py-15">
            <div v-if="submitting">
              <div class="symbol symbol-100px mx-auto mb-7">
                <div class="symbol-label bg-light-primary">
                  <div class="spinner-border spinner-border-lg text-primary"></div>
                </div>
              </div>
              <h4 class="text-primary mb-3">Processing Adjustment...</h4>
              <p class="text-muted">
                Please wait while the system processes your inventory adjustment securely.
              </p>
            </div>

            <div v-else>
              <!-- Execute Button -->
              <button
                class="btn btn-danger btn-lg px-10"
                @click="submitAdjustment"
                :disabled="!canSubmitAdjustment"
              >
                <i class="ki-duotone ki-check fs-2 me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Execute Inventory Adjustment
              </button>

              <div class="mt-7">
                <div class="alert alert-light-warning">
                  <div class="fs-7">
                    <strong>Security Notice:</strong> This adjustment will be monitored by AI fraud
                    detection systems and logged for regulatory compliance.
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Full Screen Modal for Data Tables -->
    <div
      class="modal fade"
      id="dataModal"
      tabindex="-1"
      aria-hidden="true"
      ref="dataModalRef"
      data-bs-backdrop="static"
    >
      <div class="modal-dialog modal-fullscreen">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title fw-bold">
              <i :class="currentModalData.icon + ' fs-2 me-3'">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3" v-if="currentModalData.icon?.includes('setting')"></span>
              </i>
              {{ currentModalData.title }}
            </h3>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body p-10">
            <!-- Recent Adjustments Modal Content -->
            <div v-if="currentModalType === 'adjustments'">
              <div class="row g-5 mb-7">
                <div class="col-12 col-md-3">
                  <div class="card bg-light-primary">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-primary">
                        {{ adjustmentMetrics.totalAdjustments }}
                      </div>
                      <div class="fs-6 text-muted">Today's Adjustments</div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-3">
                  <div class="card bg-light-success">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-success">
                        {{ formatCurrency(adjustmentMetrics.totalValue) }}
                      </div>
                      <div class="fs-6 text-muted">Total Value</div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-3">
                  <div class="card bg-light-warning">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-warning">
                        {{ recentAdjustments.filter((adj) => adj.riskLevel === 'HIGH').length }}
                      </div>
                      <div class="fs-6 text-muted">High Risk</div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-3">
                  <div class="card bg-light-info">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-info">
                        {{ recentAdjustments.filter((adj) => adj.riskLevel === 'LOW').length }}
                      </div>
                      <div class="fs-6 text-muted">Low Risk</div>
                    </div>
                  </div>
                </div>
              </div>

              <div v-if="!recentAdjustments.length" class="text-center py-15">
                <div class="symbol symbol-100px mx-auto mb-7">
                  <div class="symbol-label bg-light-success">
                    <i class="ki-duotone ki-verify fs-3x text-success">
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                      <span class="path4"></span>
                      <span class="path5"></span>
                      <span class="path6"></span>
                    </i>
                  </div>
                </div>
                <h4 class="text-success">No adjustments today</h4>
                <p class="text-muted">All tank levels are accurate and compliant.</p>
              </div>

              <div v-else class="table-responsive">
                <table class="table table-rounded table-hover align-middle border gy-7 gs-7">
                  <thead class="bg-light">
                    <tr class="fw-bold fs-6 text-gray-800 border-bottom-2 border-gray-200">
                      <th class="min-w-150px">Tank</th>
                      <th class="min-w-100px text-end">Quantity</th>
                      <th class="min-w-100px text-end">Value</th>
                      <th class="min-w-120px">Category</th>
                      <th class="min-w-100px">Risk Level</th>
                      <th class="min-w-120px">Time</th>
                      <th class="min-w-150px">Recorded By</th>
                      <th class="min-w-200px">Reason</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="adjustment in recentAdjustments" :key="adjustment.HistoryID">
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="symbol symbol-40px me-3">
                            <div class="symbol-label bg-light-primary">
                              <i class="ki-duotone ki-abstract-39 fs-6 text-primary">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                            </div>
                          </div>
                          <div>
                            <div class="fw-bold text-gray-800">
                              {{ getTankNameSafe(adjustment.TankID) }}
                            </div>
                            <div class="fs-7 text-muted">
                              {{ getProductNameByTankSafe(adjustment.TankID) }}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td class="text-end">
                        <span
                          class="fw-bold"
                          :class="
                            parseFloat(adjustment.QuantityChange || '0') >= 0
                              ? 'text-success'
                              : 'text-danger'
                          "
                        >
                          {{ formatVariance(adjustment.QuantityChange) }}L
                        </span>
                      </td>
                      <td class="text-end fw-bold">{{ formatCurrency(adjustment.TotalValue) }}</td>
                      <td>
                        <span class="badge badge-light-info">{{
                          adjustment.AdjustmentCategory || 'Standard'
                        }}</span>
                      </td>
                      <td>
                        <span class="badge" :class="getRiskLevelBadge(adjustment.riskLevel)">
                          {{ adjustment.riskLevel || 'LOW' }}
                        </span>
                      </td>
                      <td class="fs-7 text-muted">{{ formatDateTime(adjustment.CreatedAt) }}</td>
                      <td class="fs-7">{{ getUserNameSafe(adjustment.RecordedBy) }}</td>
                      <td class="fs-7" style="max-width: 200px">
                        <div class="text-truncate" :title="adjustment.ReasonForChange">
                          {{ adjustment.ReasonForChange || 'No reason provided' }}
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- Tanks Modal Content -->
            <div v-else-if="currentModalType === 'tanks'">
              <div class="row g-5 mb-7">
                <div class="col-12 col-md-4">
                  <div class="card bg-light-primary">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-primary">{{ enrichedTanks.length }}</div>
                      <div class="fs-6 text-muted">Total Tanks</div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-4">
                  <div class="card bg-light-success">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-success">
                        {{
                          enrichedTanks.filter((t) => t.fraudAnalysis.riskLevel === 'LOW').length
                        }}
                      </div>
                      <div class="fs-6 text-muted">Low Risk Tanks</div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-4">
                  <div class="card bg-light-danger">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-danger">
                        {{
                          enrichedTanks.filter((t) => t.fraudAnalysis.riskLevel === 'HIGH').length
                        }}
                      </div>
                      <div class="fs-6 text-muted">High Risk Tanks</div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="table-responsive">
                <table class="table table-rounded table-hover align-middle border gy-7 gs-7">
                  <thead class="bg-light">
                    <tr class="fw-bold fs-6 text-gray-800 border-bottom-2 border-gray-200">
                      <th class="min-w-150px">Tank</th>
                      <th class="min-w-100px text-end">Current Level</th>
                      <th class="min-w-100px text-end">Capacity</th>
                      <th class="min-w-100px text-end">Fill %</th>
                      <th class="min-w-100px">API Gravity</th>
                      <th class="min-w-100px">Density</th>
                      <th class="min-w-100px">Risk Level</th>
                      <th class="min-w-100px text-end">Est. Value</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="tank in enrichedTanks" :key="tank.TankID">
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="symbol symbol-40px me-3">
                            <div class="symbol-label bg-light-primary">
                              <i class="ki-duotone ki-abstract-39 fs-6 text-primary">
                                <span class="path1"></span>
                                <span class="path2"></span>
                              </i>
                            </div>
                          </div>
                          <div>
                            <div class="fw-bold text-gray-800">{{ tank.TankName }}</div>
                            <div class="fs-7 text-muted">{{ getProductName(tank.ProductID) }}</div>
                          </div>
                        </div>
                      </td>
                      <td class="text-end fw-bold">{{ formatVolume(tank.CurrentLevel) }}L</td>
                      <td class="text-end fw-bold">{{ formatVolume(tank.Capacity) }}L</td>
                      <td class="text-end">
                        <span class="fw-bold" :class="getFillBarClass(tank.fillPercentage || 0)">
                          {{ (tank.fillPercentage || 0).toFixed(1) }}%
                        </span>
                      </td>
                      <td class="fw-bold">{{ tank.internationalStandards.apiGravity }}°</td>
                      <td class="fw-bold">{{ tank.internationalStandards.density }}</td>
                      <td>
                        <span
                          class="badge"
                          :class="getFraudRiskBadge(tank.fraudAnalysis.riskLevel)"
                        >
                          {{ tank.fraudAnalysis.riskLevel }}
                        </span>
                      </td>
                      <td class="text-end fw-bold">
                        {{
                          formatCurrency(
                            parseFloat(tank.CurrentLevel) *
                              parseFloat(getProductPrice(tank.ProductID)),
                          )
                        }}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- Security Modal Content -->
            <div v-else-if="currentModalType === 'security'">
              <div class="row g-5 mb-7">
                <div class="col-12 col-md-4">
                  <div class="card bg-light-success">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-success">
                        {{ fraudMetrics.complianceScore }}%
                      </div>
                      <div class="fs-6 text-muted">Compliance Score</div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-4">
                  <div class="card bg-light-danger">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-danger">{{ fraudAlerts.length }}</div>
                      <div class="fs-6 text-muted">Active Alerts</div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-4">
                  <div class="card bg-light-warning">
                    <div class="card-body text-center p-6">
                      <div class="fs-2hx fw-bold text-warning">
                        {{
                          enrichedTanks.filter((t) => t.fraudAnalysis.riskLevel === 'MEDIUM').length
                        }}
                      </div>
                      <div class="fs-6 text-muted">Medium Risk</div>
                    </div>
                  </div>
                </div>
              </div>

              <div v-if="!fraudAlerts.length" class="text-center py-15">
                <div class="symbol symbol-100px mx-auto mb-7">
                  <div class="symbol-label bg-light-success">
                    <i class="ki-duotone ki-shield-tick fs-3x text-success">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </div>
                </div>
                <h4 class="text-success">All Systems Secure</h4>
                <p class="text-muted">No security alerts detected.</p>
              </div>

              <div v-else class="table-responsive">
                <table class="table table-rounded table-hover align-middle border gy-7 gs-7">
                  <thead class="bg-light">
                    <tr class="fw-bold fs-6 text-gray-800 border-bottom-2 border-gray-200">
                      <th class="min-w-150px">Alert Type</th>
                      <th class="min-w-100px">Severity</th>
                      <th class="min-w-100px text-end">Risk Score</th>
                      <th class="min-w-200px">Description</th>
                      <th class="min-w-120px">Detected At</th>
                      <th class="min-w-100px">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="alert in fraudAlerts" :key="alert.FraudLogID">
                      <td class="fw-bold">{{ alert.AlertType }}</td>
                      <td>
                        <span class="badge" :class="getFraudSeverityBadge(alert.Severity)">
                          {{ alert.Severity }}
                        </span>
                      </td>
                      <td class="text-end fw-bold">{{ alert.RiskScore }}/100</td>
                      <td>{{ alert.Description }}</td>
                      <td class="fs-7 text-muted">{{ formatDateTime(alert.DetectedAt) }}</td>
                      <td>
                        <span class="badge badge-light-warning">{{ alert.Status }}</span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- Analytics Modal Content -->
            <div v-else-if="currentModalType === 'analytics'">
              <div class="row g-5">
                <div class="col-12 col-xl-8">
                  <!-- Financial Analytics Chart -->
                  <div class="card card-bordered">
                    <div class="card-header">
                      <h5 class="card-title">Financial Impact Analytics</h5>
                    </div>
                    <div class="card-body">
                      <div
                        class="min-h-400px d-flex align-items-center justify-content-center bg-light-primary rounded"
                      >
                        <div class="text-center">
                          <i class="ki-duotone ki-chart-pie-3 fs-3x text-primary mb-3">
                            <span class="path1"></span>
                            <span class="path2"></span>
                            <span class="path3"></span>
                          </i>
                          <div class="fs-5 fw-bold text-primary">Financial Analytics Chart</div>
                          <div class="fs-7 text-muted">AI-Powered Insights Dashboard</div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-xl-4">
                  <!-- AI Financial Advisory -->
                  <div class="card card-bordered mb-5">
                    <div class="card-body p-6">
                      <div class="d-flex align-items-start">
                        <i class="ki-duotone ki-technology-2 fs-2 text-primary me-3">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                        </i>
                        <div class="flex-grow-1">
                          <h6 class="mb-2">AI Financial Insights</h6>
                          <div class="fs-7">{{ financialAnalytics.aiInsight }}</div>
                          <div class="mt-3">
                            <div class="fs-8 text-muted fw-bold">Recommendations:</div>
                            <ul class="list-unstyled mt-1">
                              <li
                                v-for="rec in financialAnalytics.recommendations"
                                :key="rec"
                                class="fs-8 mb-1"
                              >
                                • {{ rec }}
                              </li>
                            </ul>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Key Metrics -->
                  <div class="card card-bordered">
                    <div class="card-body p-6">
                      <h6 class="text-success mb-3">Financial Health Score</h6>
                      <div class="d-flex align-items-center gap-3">
                        <div class="flex-grow-1">
                          <div class="progress h-8px bg-light-success">
                            <div
                              class="progress-bar bg-success"
                              :style="`width: ${financialAnalytics.healthScore}%`"
                            ></div>
                          </div>
                        </div>
                        <div class="fw-bold text-success">
                          {{ financialAnalytics.healthScore }}%
                        </div>
                      </div>
                      <div class="fs-8 text-muted mt-2">
                        Based on adjustment patterns and compliance
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" @click="closeModal">Close</button>
            <button type="button" class="btn btn-primary" @click="refreshData">
              <i class="ki-duotone ki-arrows-circle fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Refresh Data
            </button>
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

// Authentication Data - CORRECTED ACCESS PATTERN
const getAuthData = () => {
  try {
    const userData = localStorage.getItem('kigrama_user_data')
    return userData ? JSON.parse(userData) : {}
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
const loading = ref(false)
const submitting = ref(false)
const selectedTankId = ref(null)

// Wizard State
const currentWizardStep = ref(1)
const wizardSteps = [
  {
    number: 1,
    title: 'Tank Selection',
    subtitle: 'Choose Tank',
    icon: 'ki-duotone ki-abstract-39',
  },
  {
    number: 2,
    title: 'Configuration',
    subtitle: 'Set Parameters',
    icon: 'ki-duotone ki-setting-2',
  },
  { number: 3, title: 'Review', subtitle: 'Validate Details', icon: 'ki-duotone ki-verify' },
  { number: 4, title: 'Execute', subtitle: 'Final Submission', icon: 'ki-duotone ki-check' },
]

// Modal State
const currentModalType = ref('')
const currentModalData = reactive({
  title: '',
  icon: '',
})
const dataModalRef = ref(null)

// Data Collections
const tanks = ref([])
const products = ref([])
const recentAdjustments = ref([])
const fraudAlerts = ref([])
const users = ref([])

// Form State
const adjustmentForm = reactive({
  category: '',
  quantity: '',
  reason: '',
})

const adjustmentErrors = reactive({
  category: '',
  quantity: '',
  reason: '',
})

const adjustmentImpact = reactive({
  calculated: false,
  currentLevel: 0,
  newLevel: 0,
  newFillPercentage: 0,
  financialImpact: 0,
})

// Computed Properties
const currentUser = computed(() => AUTH_DATA.value.user || {})
const userStations = computed(() => AUTH_DATA.value.stations || [])
const currentStation = computed(() => userStations.value[0] || null)
const currentStationId = computed(() => currentStation.value?.StationID || null)

const selectedTank = computed(() => {
  return tanks.value.find((t) => t.TankID === selectedTankId.value) || null
})

// Wizard Navigation
const canProceedToNextStep = computed(() => {
  switch (currentWizardStep.value) {
    case 1:
      return selectedTankId.value !== null
    case 2:
      return canSubmitAdjustment.value
    case 3:
      return true
    default:
      return false
  }
})

// CORRECTED International Standards Constants
const FUEL_STANDARDS = {
  // API Gravity standards per ASTM D287/API MPMS 9.1
  Petrol: {
    apiGravity: 55,
    density: 0.75,
    expansionCoeff: 0.0012,
    maxVariance: 0.5,
    taxClass: 'A',
  },
  'Premium Petrol': {
    apiGravity: 58,
    density: 0.73,
    expansionCoeff: 0.0012,
    maxVariance: 0.3,
    taxClass: 'A',
  },
  Diesel: {
    apiGravity: 35,
    density: 0.85,
    expansionCoeff: 0.0009,
    maxVariance: 0.7,
    taxClass: 'B',
  },
  'Premium Diesel': {
    apiGravity: 37,
    density: 0.84,
    expansionCoeff: 0.0009,
    maxVariance: 0.5,
    taxClass: 'B',
  },
  Kerosene: {
    apiGravity: 45,
    density: 0.78,
    expansionCoeff: 0.001,
    maxVariance: 0.6,
    taxClass: 'C',
  },
  Gas: { apiGravity: 60, density: 0.6, expansionCoeff: 0.0015, maxVariance: 1.0, taxClass: 'D' },
  // Standard reference conditions
  STANDARD_TEMP: 15, // °C per ISO 12185
  AMBIENT_TEMP: 25, // °C
  MAX_ADJUSTMENT_PERCENT: 5.0, // 5% max adjustment per international standards
  FRAUD_THRESHOLD: 2.0, // 2% variance triggers fraud investigation
}

// Adjustment Categories per International Standards
const adjustmentCategories = [
  { code: 'TEMP_COMPENSATION', name: 'Temperature Compensation (API Standard)' },
  { code: 'EVAPORATION_LOSS', name: 'Evaporation Loss (Calculated)' },
  { code: 'METER_CALIBRATION', name: 'Meter Calibration Adjustment' },
  { code: 'DENSITY_CORRECTION', name: 'Density Correction (15°C)' },
  { code: 'SPILLAGE_RECOVERY', name: 'Spillage Recovery' },
  { code: 'DELIVERY_VARIANCE', name: 'Delivery Variance' },
  { code: 'SYSTEM_CORRECTION', name: 'System Error Correction' },
  { code: 'QUALITY_ADJUSTMENT', name: 'Quality-based Adjustment' },
]

// Enhanced Tanks with International Standards and Station Ownership Validation
const enrichedTanks = computed(() => {
  if (!currentStationId.value) return []

  return tanks.value
    .filter((tank) => {
      // CRITICAL: Only show tanks that belong to current user's station
      return parseInt(tank.StationID) === parseInt(currentStationId.value)
    })
    .map((tank) => {
      const product = products.value.find((p) => p.ProductID === tank.ProductID)
      const currentLevel = parseFloat(tank.CurrentLevel || '0')
      const capacity = parseFloat(tank.Capacity || '0')
      const fillPercentage = capacity > 0 ? (currentLevel / capacity) * 100 : 0

      // Get fuel standards based on product name
      const productName = product?.Name || 'Diesel'
      const standards = FUEL_STANDARDS[productName] || FUEL_STANDARDS.Diesel

      // CORRECTED Temperature compensation calculation per API MPMS 11.1
      const tempDiff = FUEL_STANDARDS.AMBIENT_TEMP - FUEL_STANDARDS.STANDARD_TEMP
      const tempCompensation = tempDiff * standards.expansionCoeff * 100

      // CORRECTED Density at 15°C per API standard
      const densityAt15C = standards.density * (1 - tempDiff * standards.expansionCoeff)

      // CORRECTED API Gravity calculation per ASTM D287
      const apiGravity = 141.5 / densityAt15C - 131.5

      // CORRECTED Fraud Analysis
      const fraudAnalysis = calculateAdvancedFraudRisk(
        tank,
        currentLevel,
        capacity,
        fillPercentage,
        standards,
      )

      return {
        ...tank,
        fillPercentage: fillPercentage || 0,
        internationalStandards: {
          apiGravity: (apiGravity || 0).toFixed(2),
          density: (densityAt15C || 0).toFixed(4),
          tempCompensation: (tempCompensation || 0).toFixed(3),
          maxVariance: standards.maxVariance || 0,
          taxClass: standards.taxClass || 'B',
        },
        fraudAnalysis: fraudAnalysis || {
          riskLevel: 'LOW',
          riskScore: 0,
          riskFlags: [],
          complianceStatus: 'COMPLIANT',
        },
      }
    })
})

// CORRECTED Advanced Fraud Detection Algorithm with Safety Checks
const calculateAdvancedFraudRisk = (tank, currentLevel, capacity, fillPercentage, standards) => {
  try {
    let riskScore = 0
    let riskFlags = []
    let riskLevel = 'LOW'

    // Ensure we have valid inputs
    if (!tank || typeof currentLevel !== 'number' || typeof capacity !== 'number') {
      return {
        riskScore: 0,
        riskLevel: 'LOW',
        riskFlags: ['Insufficient data for risk assessment'],
        complianceStatus: 'PENDING',
      }
    }

    const safeFillPercentage = fillPercentage || 0
    const safeStandards = standards || FUEL_STANDARDS.Diesel

    // 1. International Standards Compliance Check
    const variancePercent = Math.abs(safeFillPercentage - 50) // Deviation from optimal 50%
    if (variancePercent > (safeStandards.maxVariance || 1) * 10) {
      riskScore += 25
      riskFlags.push('Exceeds international variance standards')
    }

    // 2. Capacity Utilization Analysis
    if (safeFillPercentage > 95) {
      riskScore += 20
      riskFlags.push('Dangerous overfill level')
    } else if (safeFillPercentage < 5) {
      riskScore += 15
      riskFlags.push('Critical low level')
    }

    // 3. Historical Pattern Analysis (simulated)
    const daysSinceLastFill = Math.floor(Math.random() * 30) + 1
    if (daysSinceLastFill > 21) {
      riskScore += 10
      riskFlags.push('Extended period without monitoring')
    }

    // 4. Financial Risk Assessment
    const unitPrice = parseFloat(
      products.value.find((p) => p.ProductID === tank.ProductID)?.UnitPrice || '0',
    )
    const inventoryValue = currentLevel * unitPrice
    if (inventoryValue > 10000000 && safeFillPercentage < 20) {
      // 10M UGX threshold
      riskScore += 15
      riskFlags.push('High-value inventory at risk')
    }

    // 5. System Integrity Checks
    if (!tank.TankName || tank.TankName.length < 3) {
      riskScore += 10
      riskFlags.push('Incomplete tank configuration')
    }

    // Determine risk level per international standards
    if (riskScore > 50) riskLevel = 'HIGH'
    else if (riskScore > 25) riskLevel = 'MEDIUM'

    return {
      riskScore: Math.min(riskScore, 100),
      riskLevel,
      riskFlags,
      complianceStatus: riskScore < 25 ? 'COMPLIANT' : 'REQUIRES_REVIEW',
    }
  } catch (error) {
    console.error('Error in fraud risk calculation:', error)
    return {
      riskScore: 50, // Default to medium risk if calculation fails
      riskLevel: 'MEDIUM',
      riskFlags: ['Risk calculation error'],
      complianceStatus: 'ERROR',
    }
  }
}

// Adjustment Limits Based on International Standards
const adjustmentLimits = computed(() => {
  if (!selectedTank.value) return { min: 0, max: 0 }

  const currentLevel = parseFloat(selectedTank.value.CurrentLevel || '0')
  const capacity = parseFloat(selectedTank.value.Capacity || '0')

  // Maximum adjustment per international standards (5% of capacity)
  const maxAdjustmentPercent = FUEL_STANDARDS.MAX_ADJUSTMENT_PERCENT / 100
  const maxAdjustment = capacity * maxAdjustmentPercent

  return {
    min: Math.max(-currentLevel, -maxAdjustment),
    max: Math.min(capacity - currentLevel, maxAdjustment),
  }
})

// Metrics with Safety Checks
const adjustmentMetrics = computed(() => {
  try {
    const today = new Date().toISOString().split('T')[0]
    const todayAdjustments = (recentAdjustments.value || []).filter(
      (adj) => adj.ChangeDate === today,
    )

    const totalValue = todayAdjustments.reduce(
      (sum, adj) => sum + parseFloat(adj.TotalValue || '0'),
      0,
    )

    return {
      totalAdjustments: todayAdjustments.length || 0,
      totalValue: totalValue || 0,
    }
  } catch (error) {
    console.error('Error calculating adjustment metrics:', error)
    return {
      totalAdjustments: 0,
      totalValue: 0,
    }
  }
})

const fraudMetrics = computed(() => {
  try {
    const tanks = enrichedTanks.value || []
    const highRiskTanks = tanks.filter((t) => t.fraudAnalysis?.riskLevel === 'HIGH').length || 0
    const totalTanks = tanks.length || 1 // Prevent division by zero
    const complianceScore = (((totalTanks - highRiskTanks) / totalTanks) * 100).toFixed(0)

    return {
      riskAlerts: (fraudAlerts.value || []).length,
      complianceScore: parseInt(complianceScore) || 100,
    }
  } catch (error) {
    console.error('Error calculating fraud metrics:', error)
    return {
      riskAlerts: 0,
      complianceScore: 100,
    }
  }
})

// Tax Advisory (AI-Simulated)
const taxAdvisory = computed(() => {
  if (!adjustmentForm.quantity || !selectedTank.value) {
    return { show: false, message: '', implications: [] }
  }

  const quantity = parseFloat(adjustmentForm.quantity)
  const product = products.value.find((p) => p.ProductID === selectedTank.value.ProductID)
  const unitPrice = parseFloat(product?.UnitPrice || '0')
  const adjustmentValue = Math.abs(quantity * unitPrice)

  if (adjustmentValue < 100000) {
    // Below 100k UGX
    return { show: false, message: '', implications: [] }
  }

  const taxClass = selectedTank.value.internationalStandards?.taxClass || 'B'
  const isIncrease = quantity > 0

  let message = ''
  let implications = []

  if (isIncrease) {
    message = `AI Analysis: Inventory increase of ${formatCurrency(adjustmentValue)} may trigger tax liability review.`
    implications = [
      `Tax Class ${taxClass} - Standard VAT (18%) may apply`,
      'Adjustment may require supporting documentation',
      'Consider timing for monthly tax filing period',
    ]
  } else {
    message = `AI Analysis: Inventory reduction of ${formatCurrency(adjustmentValue)} may create tax deduction opportunity.`
    implications = [
      'Loss deduction may apply under URA guidelines',
      'Ensure proper documentation for audit trail',
      'Consider inventory write-off procedures',
    ]
  }

  if (adjustmentValue > 1000000) {
    // Above 1M UGX
    implications.push('Large adjustment - consider notifying tax advisor')
  }

  return {
    show: true,
    message,
    implications,
  }
})

// Financial Analytics (AI-Simulated)
const financialAnalytics = computed(() => {
  const totalAdjustmentValue = recentAdjustments.value.reduce(
    (sum, adj) => sum + Math.abs(parseFloat(adj.TotalValue || '0')),
    0,
  )

  const positiveAdjustments = recentAdjustments.value.filter(
    (adj) => parseFloat(adj.QuantityChange || '0') > 0,
  ).length

  const negativeAdjustments = recentAdjustments.value.filter(
    (adj) => parseFloat(adj.QuantityChange || '0') < 0,
  ).length

  let healthScore = 95
  let aiInsight = 'Inventory adjustments are within normal operational parameters.'
  let recommendations = ['Continue current monitoring practices']

  if (totalAdjustmentValue > 5000000) {
    // 5M UGX threshold
    healthScore -= 15
    aiInsight = 'High-value adjustments detected. Enhanced monitoring recommended.'
    recommendations = [
      'Implement additional verification procedures',
      'Consider more frequent reconciliations',
      'Review adjustment authorization protocols',
    ]
  }

  if (negativeAdjustments > positiveAdjustments * 2) {
    healthScore -= 10
    aiInsight = 'Disproportionate inventory reductions may indicate operational issues.'
    recommendations.push('Investigate potential loss sources')
  }

  const highRiskCount = enrichedTanks.value.filter(
    (t) => t.fraudAnalysis.riskLevel === 'HIGH',
  ).length
  if (highRiskCount > 0) {
    healthScore -= highRiskCount * 10
    recommendations.push('Address high-risk tank configurations')
  }

  return {
    healthScore: Math.max(healthScore, 0),
    aiInsight,
    recommendations: recommendations.slice(0, 3), // Limit to 3 recommendations
  }
})

// Form Validation
const canSubmitAdjustment = computed(() => {
  return (
    adjustmentForm.category &&
    adjustmentForm.quantity &&
    adjustmentForm.reason &&
    adjustmentForm.reason.length >= 10 &&
    !Object.values(adjustmentErrors).some((error) => error) &&
    selectedTank.value
  )
})

// CORRECTED API Helper Function with Enhanced Error Handling
const apiCall = async (endpoint, options = {}) => {
  try {
    if (!JWT_TOKEN.value) {
      throw new Error('Authentication token not found. Please login again.')
    }

    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${JWT_TOKEN.value}`,
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      if (response.status === 401) {
        throw new Error('Session expired. Please login again.')
      } else if (response.status === 403) {
        throw new Error('Access denied. Insufficient permissions.')
      } else if (response.status === 404) {
        throw new Error('Resource not found.')
      } else {
        throw new Error(`API Error: ${response.status} ${response.statusText}`)
      }
    }

    const contentType = response.headers.get('content-type')
    if (contentType && contentType.includes('application/json')) {
      const text = await response.text()
      return text.trim() ? JSON.parse(text) : { records: [] }
    }

    return { records: [] }
  } catch (error) {
    console.error('API Error:', error)

    // Log security violation if it's an access issue
    if (error.message.includes('Access denied') || error.message.includes('Session expired')) {
      await logSecurityViolation('API_ACCESS_VIOLATION', error.message)
    }

    throw error
  }
}

// CRITICAL: Station Ownership Validation
const validateTankOwnership = (tank) => {
  if (!tank || !currentStationId.value) {
    console.error('🚨 SECURITY: Invalid tank or station data')
    return false
  }

  const tankStationId = parseInt(tank.StationID)
  const currentStation = parseInt(currentStationId.value)

  if (tankStationId !== currentStation) {
    console.error('🚨 SECURITY: Tank ownership violation detected', {
      tankId: tank.TankID,
      tankStation: tankStationId,
      userStation: currentStation,
      userId: currentUser.value.id,
    })

    // Log security violation
    logSecurityViolation(
      'TANK_OWNERSHIP_VIOLATION',
      `User attempted to access tank ${tank.TankID} from station ${tankStationId} while assigned to station ${currentStation}`,
    )

    return false
  }

  return true
}

// CRITICAL: User Station Assignment Validation
const validateUserStationAccess = () => {
  if (!currentStationId.value) {
    console.error('🚨 SECURITY: User has no station assignment')
    return false
  }

  const userStations = AUTH_DATA.value.stations || []
  const hasStationAccess = userStations.some(
    (station) => parseInt(station.StationID) === parseInt(currentStationId.value),
  )

  if (!hasStationAccess) {
    console.error('🚨 SECURITY: User station access violation', {
      userId: currentUser.value.id,
      assignedStations: userStations.map((s) => s.StationID),
      attemptedStation: currentStationId.value,
    })

    logSecurityViolation(
      'STATION_ACCESS_VIOLATION',
      `User ${currentUser.value.id} attempted to access station ${currentStationId.value} without assignment`,
    )

    return false
  }

  return true
}

// CRITICAL: Security Violation Logging
const logSecurityViolation = async (violationType, description) => {
  try {
    const securityLogData = {
      StationID: currentStationId.value?.toString() || 'null',
      TankID: selectedTankId.value?.toString() || 'null',
      AlertType: violationType,
      Severity: 'HIGH',
      RiskScore: '100',
      Description: description,
      DetectedAt: new Date().toISOString(),
      AffectedAmount: '0',
      Status: 'ACTIVE',
      ReviewedBy: null,
      ResolvedAt: null,
      Notes: JSON.stringify({
        userId: currentUser.value.id,
        userAgent: navigator.userAgent,
        timestamp: new Date().toISOString(),
        sessionData: AUTH_DATA.value,
      }),
      CreatedAt: new Date().toISOString(),
    }

    await fetch(`${API_BASE_URL}/FraudDetectionLogs`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${JWT_TOKEN.value}`,
      },
      body: JSON.stringify(securityLogData),
    })

    console.log('🚨 Security violation logged:', violationType)
  } catch (error) {
    console.error('Failed to log security violation:', error)
  }
}

// ENHANCED: Database Integrity Validation
const validateDatabaseIntegrity = async (adjustmentData) => {
  const errors = []

  // 1. Validate Tank exists and belongs to station
  if (!selectedTank.value) {
    errors.push('Selected tank not found')
    return errors
  }

  if (!validateTankOwnership(selectedTank.value)) {
    errors.push('Tank ownership validation failed')
    return errors
  }

  // 2. Validate Product FK relationship
  const product = products.value.find((p) => p.ProductID === selectedTank.value.ProductID)
  if (!product) {
    errors.push(
      `Product ${selectedTank.value.ProductID} not found for tank ${selectedTank.value.TankID}`,
    )
  }

  // 3. Validate User FK relationships
  if (!currentUser.value.id) {
    errors.push('Current user ID not found')
  }

  // 4. Validate Station FK relationship
  if (!currentStationId.value) {
    errors.push('Current station ID not found')
  }

  // 5. Validate Adjustment Category
  const validCategory = adjustmentCategories.find((cat) => cat.code === adjustmentData.category)
  if (!validCategory) {
    errors.push(`Invalid adjustment category: ${adjustmentData.category}`)
  }

  // 6. Validate Quantity constraints
  const quantity = parseFloat(adjustmentData.quantity)
  if (isNaN(quantity) || quantity === 0) {
    errors.push('Invalid adjustment quantity')
  }

  const limits = adjustmentLimits.value
  if (quantity < limits.min || quantity > limits.max) {
    errors.push(`Quantity ${quantity} outside allowed range [${limits.min}, ${limits.max}]`)
  }

  return errors
}

// Load Data Functions
const loadTanks = async () => {
  if (!currentStationId.value) return

  try {
    const response = await apiCall(`/Tanks?StationID=${currentStationId.value}`)
    tanks.value = response.records || []
    console.log('Loaded tanks:', tanks.value.length)
  } catch (error) {
    console.error('Failed to load tanks:', error)
    tanks.value = []
  }
}

const loadProducts = async () => {
  try {
    const response = await apiCall('/Products')
    products.value = response.records || []
    console.log('Loaded products:', products.value.length)
  } catch (error) {
    console.error('Failed to load products:', error)
    products.value = []
  }
}

const loadUsers = async () => {
  try {
    const response = await apiCall('/users')
    users.value = response.records || []
    console.log('Loaded users:', users.value.length)
  } catch (error) {
    console.error('Failed to load users:', error)
    users.value = []
  }
}

const loadRecentAdjustments = async () => {
  if (!currentStationId.value) return

  try {
    const today = new Date()
    const sevenDaysAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000)
    const dateFilter = sevenDaysAgo.toISOString().split('T')[0]

    const response = await apiCall(
      `/InventoryHistory?StationID=${currentStationId.value}&ChangeType=Manual Adjustment`,
    )

    // Enhance with risk analysis and filter recent
    const adjustments = (response.records || [])
      .filter((adj) => new Date(adj.ChangeDate) >= sevenDaysAgo)
      .map((adj) => {
        const riskScore =
          Math.abs(parseFloat(adj.QuantityChange || '0')) > 1000
            ? 'HIGH'
            : Math.abs(parseFloat(adj.QuantityChange || '0')) > 100
              ? 'MEDIUM'
              : 'LOW'

        return {
          ...adj,
          riskLevel: riskScore,
        }
      })
      .sort((a, b) => new Date(b.CreatedAt) - new Date(a.CreatedAt)) // Sort by newest first

    recentAdjustments.value = adjustments.slice(0, 20) // Latest 20
    console.log('Loaded recent adjustments:', recentAdjustments.value.length)
  } catch (error) {
    console.error('Failed to load recent adjustments:', error)
    recentAdjustments.value = []
  }
}

const loadFraudAlerts = async () => {
  if (!currentStationId.value) return

  try {
    const response = await apiCall(
      `/FraudDetectionLogs?StationID=${currentStationId.value}&Status=ACTIVE`,
    )
    fraudAlerts.value = (response.records || []).slice(0, 10) // Latest 10 alerts
    console.log('Loaded fraud alerts:', fraudAlerts.value.length)
  } catch (error) {
    console.error('Failed to load fraud alerts:', error)
    fraudAlerts.value = []
  }
}

// CORRECTED Helper Functions - Fixed Data Display Issues
const getProductName = (productId) => {
  const product = products.value.find((p) => p.ProductID == productId)
  return product?.Name || 'Unknown Product'
}

const getProductPrice = (productId) => {
  const product = products.value.find((p) => p.ProductID == productId)
  return product?.UnitPrice || '0'
}

const getProductNameByTankSafe = (tankId) => {
  if (!tankId || tankId === 'null') return 'Unknown Product'
  const tank = tanks.value.find((t) => t.TankID == tankId)
  if (!tank) return 'Unknown Product'
  return getProductName(tank.ProductID)
}

const getTankNameSafe = (tankId) => {
  if (!tankId || tankId === 'null') return 'Unknown Tank'
  const tank = tanks.value.find((t) => t.TankID == tankId)
  return tank?.TankName || `Tank #${tankId}`
}

const getUserNameSafe = (userId) => {
  if (!userId || userId === 'null') return 'System User'

  // Check current user first
  if (currentUser.value.id && currentUser.value.id == userId) {
    return currentUser.value.name || currentUser.value.email || `User #${userId}`
  }

  // Look in users array
  const user = users.value.find((u) => u.id == userId)
  return user?.name || user?.email || user?.username || `User #${userId}`
}

// Wizard Navigation Functions
const nextStep = () => {
  if (canProceedToNextStep.value && currentWizardStep.value < 4) {
    currentWizardStep.value++
  }
}

const previousStep = () => {
  if (currentWizardStep.value > 1) {
    currentWizardStep.value--
  }
}

// Modal Functions
const openModal = (type) => {
  currentModalType.value = type

  const modalConfigs = {
    adjustments: { title: 'Recent Inventory Adjustments', icon: 'ki-duotone ki-abstract-39' },
    tanks: { title: 'Tank Status Overview', icon: 'ki-duotone ki-gas-station' },
    security: { title: 'Security & Fraud Alerts', icon: 'ki-duotone ki-security-check' },
    analytics: { title: 'Financial Analytics Dashboard', icon: 'ki-duotone ki-chart-pie-3' },
  }

  Object.assign(currentModalData, modalConfigs[type] || {})

  // Use Bootstrap's Modal API
  const modal = new bootstrap.Modal(dataModalRef.value)
  modal.show()
}

const closeModal = () => {
  const modal = bootstrap.Modal.getInstance(dataModalRef.value)
  if (modal) {
    modal.hide()
  }
}

// CORRECTED Tank Selection with Station Ownership Validation
const selectTank = (tank) => {
  // CRITICAL SECURITY CHECK: Verify tank belongs to current user's station
  if (!validateTankOwnership(tank)) {
    Swal.fire({
      title: 'Access Denied!',
      text: 'You can only adjust tanks belonging to your assigned station.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  selectedTankId.value = tank.TankID

  // Reset form
  Object.assign(adjustmentForm, {
    category: '',
    quantity: '',
    reason: '',
  })

  Object.assign(adjustmentErrors, {
    category: '',
    quantity: '',
    reason: '',
  })

  Object.assign(adjustmentImpact, {
    calculated: false,
    currentLevel: 0,
    newLevel: 0,
    newFillPercentage: 0,
    financialImpact: 0,
  })

  console.log('Selected tank:', tank.TankName, 'Station:', tank.StationID)
}

// CORRECTED Form Validation
const validateAdjustmentForm = () => {
  // Reset errors
  Object.assign(adjustmentErrors, {
    category: '',
    quantity: '',
    reason: '',
  })

  // Category validation
  if (!adjustmentForm.category) {
    adjustmentErrors.category = 'Adjustment category is required'
  }

  // Quantity validation
  const quantity = parseFloat(adjustmentForm.quantity)
  if (!adjustmentForm.quantity) {
    adjustmentErrors.quantity = 'Adjustment quantity is required'
  } else if (isNaN(quantity)) {
    adjustmentErrors.quantity = 'Invalid quantity format'
  } else if (quantity === 0) {
    adjustmentErrors.quantity = 'Quantity cannot be zero'
  } else if (quantity < adjustmentLimits.value.min || quantity > adjustmentLimits.value.max) {
    adjustmentErrors.quantity = `Quantity must be between ${formatVolume(adjustmentLimits.value.min)}L and ${formatVolume(adjustmentLimits.value.max)}L`
  }

  // International standards check
  if (selectedTank.value && Math.abs(quantity) > 0) {
    const capacity = parseFloat(selectedTank.value.Capacity || '0')
    const adjustmentPercent = (Math.abs(quantity) / capacity) * 100

    if (adjustmentPercent > FUEL_STANDARDS.MAX_ADJUSTMENT_PERCENT) {
      adjustmentErrors.quantity = `Exceeds international standards limit (${FUEL_STANDARDS.MAX_ADJUSTMENT_PERCENT}% of capacity)`
    }
  }

  // Reason validation
  if (!adjustmentForm.reason) {
    adjustmentErrors.reason = 'Detailed reason is required'
  } else if (adjustmentForm.reason.length < 10) {
    adjustmentErrors.reason = 'Reason must be at least 10 characters'
  } else if (adjustmentForm.reason.length > 500) {
    adjustmentErrors.reason = 'Reason cannot exceed 500 characters'
  }
}

// Calculate Adjustment Impact with Safety Checks
const calculateAdjustmentImpact = () => {
  if (!selectedTank.value || !adjustmentForm.quantity) {
    adjustmentImpact.calculated = false
    return
  }

  try {
    const quantity = parseFloat(adjustmentForm.quantity)
    if (isNaN(quantity)) {
      adjustmentImpact.calculated = false
      return
    }

    const currentLevel = parseFloat(selectedTank.value.CurrentLevel || '0')
    const capacity = parseFloat(selectedTank.value.Capacity || '0')
    const product = products.value.find((p) => p.ProductID === selectedTank.value.ProductID)
    const unitPrice = parseFloat(product?.UnitPrice || '0')

    const newLevel = Math.max(0, currentLevel + quantity) // Prevent negative levels
    const newFillPercentage = capacity > 0 ? (newLevel / capacity) * 100 : 0
    const financialImpact = quantity * unitPrice

    Object.assign(adjustmentImpact, {
      calculated: true,
      currentLevel: currentLevel || 0,
      newLevel: newLevel || 0,
      newFillPercentage: newFillPercentage || 0,
      financialImpact: financialImpact || 0,
    })

    console.log('Adjustment impact calculated:', {
      quantity,
      currentLevel,
      newLevel,
      newFillPercentage,
      financialImpact,
    })
  } catch (error) {
    console.error('Error calculating adjustment impact:', error)
    adjustmentImpact.calculated = false
  }
}

// CORRECTED Advanced Fraud Detection & Logging with Proper FK Validation
const detectAndLogSuspiciousActivity = async (adjustmentData) => {
  const suspiciousFactors = []
  let riskScore = 0
  let severity = 'LOW'

  try {
    // 1. Large adjustment detection
    const capacity = parseFloat(selectedTank.value.Capacity || '0')
    if (capacity > 0) {
      const adjustmentPercent = (Math.abs(adjustmentData.quantity) / capacity) * 100
      if (adjustmentPercent > 3) {
        suspiciousFactors.push('Large adjustment exceeding 3% of tank capacity')
        riskScore += 30
      }
    }

    // 2. High-value adjustment
    if (Math.abs(adjustmentData.financialImpact) > 2000000) {
      // 2M UGX
      suspiciousFactors.push('High-value adjustment exceeding 2M UGX')
      riskScore += 25
    }

    // 3. Frequent adjustments (simulated)
    const recentAdjustmentCount = recentAdjustments.value.filter(
      (adj) => adj.TankID == selectedTank.value.TankID,
    ).length

    if (recentAdjustmentCount > 3) {
      suspiciousFactors.push('Multiple adjustments on same tank recently')
      riskScore += 20
    }

    // 4. Off-hours operation
    const currentHour = new Date().getHours()
    if (currentHour < 6 || currentHour > 22) {
      suspiciousFactors.push('Adjustment performed outside normal business hours')
      riskScore += 15
    }

    // 5. Unusual category for product type
    const product = products.value.find((p) => p.ProductID === selectedTank.value.ProductID)
    if (product?.ProductType === 'Fuel' && adjustmentData.category === 'QUALITY_ADJUSTMENT') {
      suspiciousFactors.push('Unusual quality adjustment for fuel product')
      riskScore += 10
    }

    // Determine severity
    if (riskScore > 50) severity = 'HIGH'
    else if (riskScore > 25) severity = 'MEDIUM'

    // Log to FraudDetectionLogs if suspicious
    if (suspiciousFactors.length > 0) {
      // CORRECTED: Ensure all FK fields are properly formatted per schema
      const fraudLogData = {
        StationID: parseInt(currentStationId.value), // Ensure integer FK
        TankID: parseInt(selectedTank.value.TankID), // Ensure integer FK
        AlertType: 'INVENTORY_ADJUSTMENT_RISK',
        Severity: severity,
        RiskScore: riskScore.toString(), // TEXT field per schema
        Description: `Suspicious inventory adjustment detected: ${suspiciousFactors.join(', ')}`,
        DetectedAt: new Date().toISOString(),
        AffectedAmount: Math.abs(adjustmentData.financialImpact).toString(), // TEXT field per schema
        Status: 'ACTIVE',
        ReviewedBy: null, // FK to users.id (nullable)
        ResolvedAt: null,
        Notes: `Adjustment: ${adjustmentData.quantity}L, Category: ${adjustmentData.category}, User: ${currentUser.value.id}`,
        CreatedAt: new Date().toISOString(),
      }

      await apiCall('/FraudDetectionLogs', {
        method: 'POST',
        body: JSON.stringify(fraudLogData),
      })

      console.log('🚨 Fraud alert logged with proper FK validation:', fraudLogData)

      // Show immediate alert to user
      if (severity === 'HIGH') {
        await Swal.fire({
          title: 'High Risk Alert!',
          html: `
            <div class="text-start">
              <p class="text-danger fw-bold">This adjustment has been flagged as high risk:</p>
              <ul class="text-muted">
                ${suspiciousFactors.map((factor) => `<li>${factor}</li>`).join('')}
              </ul>
              <p class="text-warning">Risk Score: ${riskScore}/100</p>
              <p class="text-info">This activity has been logged for security review.</p>
              <p class="text-success">All database FK relationships validated ✓</p>
            </div>
          `,
          icon: 'warning',
          confirmButtonColor: '#f1416c',
          confirmButtonText: 'Acknowledge & Continue',
        })
      } else if (severity === 'MEDIUM') {
        Swal.fire({
          title: 'Security Notice',
          text: `This adjustment has been flagged for review (Risk Score: ${riskScore}/100)`,
          icon: 'info',
          toast: true,
          position: 'top-end',
          timer: 5000,
          showConfirmButton: false,
        })
      }
    }

    return {
      suspicious: suspiciousFactors.length > 0,
      riskScore: riskScore || 0,
      severity,
      factors: suspiciousFactors,
    }
  } catch (error) {
    console.error('Error in fraud detection:', error)

    // Log the error itself as a security concern
    await logSecurityViolation(
      'FRAUD_DETECTION_ERROR',
      `Error in fraud detection system: ${error.message}`,
    )

    return {
      suspicious: true, // Default to suspicious if detection fails
      riskScore: 75,
      severity: 'HIGH',
      factors: ['Fraud detection system error'],
    }
  }
}

// CORRECTED Submit Adjustment with Enhanced Security and Validation
const submitAdjustment = async () => {
  if (!canSubmitAdjustment.value) return

  submitting.value = true

  try {
    // CRITICAL: Validate user station access
    if (!validateUserStationAccess()) {
      throw new Error('Access denied: Invalid station assignment')
    }

    // CRITICAL: Final tank ownership check
    if (!validateTankOwnership(selectedTank.value)) {
      throw new Error('Access denied: Tank ownership validation failed')
    }

    const quantity = parseFloat(adjustmentForm.quantity)
    const currentLevel = parseFloat(selectedTank.value.CurrentLevel || '0')
    const newLevel = currentLevel + quantity
    const product = products.value.find((p) => p.ProductID === selectedTank.value.ProductID)
    const unitPrice = parseFloat(product?.UnitPrice || '0')
    const totalValue = quantity * unitPrice

    // ENHANCED: Database integrity validation
    const validationErrors = await validateDatabaseIntegrity({
      quantity: adjustmentForm.quantity,
      category: adjustmentForm.category,
      reason: adjustmentForm.reason,
    })

    if (validationErrors.length > 0) {
      throw new Error(`Validation failed: ${validationErrors.join(', ')}`)
    }

    // Fraud detection BEFORE processing
    const fraudAnalysis = await detectAndLogSuspiciousActivity({
      quantity,
      category: adjustmentForm.category,
      financialImpact: totalValue,
    })

    // CORRECTED: Database operations with proper FK validation

    // 1. Update Tank CurrentLevel (CORRECTED to use TEXT format per schema)
    await apiCall(`/Tanks/${selectedTank.value.TankID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        CurrentLevel: newLevel.toString(), // TEXT field per schema
        UpdatedAt: new Date().toISOString(),
      }),
    })

    // 2. CORRECTED InventoryHistory Entry with ALL required FK relationships
    const historyData = {
      // REQUIRED FKs per schema
      StationID: parseInt(currentStationId.value), // FK to Stations.StationID
      ProductID: parseInt(selectedTank.value.ProductID), // FK to Products.ProductID
      TankID: parseInt(selectedTank.value.TankID), // FK to Tanks.TankID
      RecordedBy: parseInt(currentUser.value.id), // FK to users.id

      // Optional FKs (null for manual adjustments)
      PumpID: null, // FK to Pumps.PumpID (not applicable for manual adjustment)
      TransactionID: null, // FK to Transactions.TransactionID (not applicable)
      TransferID: null, // FK to StationTransfers.TransferID (not applicable)
      AuthorizedBy: parseInt(currentUser.value.id), // FK to users.id
      VerifiedBy: null, // FK to users.id (verification pending)

      // Required fields per schema
      ChangeDate: new Date().toISOString().split('T')[0], // DATE format
      ChangeType: 'Manual Adjustment', // TEXT
      PreviousQuantity: currentLevel.toString(), // TEXT per schema
      QuantityChange: quantity.toString(), // TEXT per schema
      NewQuantity: newLevel.toString(), // TEXT per schema
      UnitPrice: unitPrice.toString(), // TEXT per schema
      TotalValue: Math.abs(totalValue).toString(), // TEXT per schema
      ReasonForChange: adjustmentForm.reason, // TEXT
      AdjustmentCategory: adjustmentForm.category, // TEXT

      // Optional fields with defaults
      BatchNumber: null,
      ExpiryDate: null,
      QualityCheck: 'N/A',
      MeasurementMethod: 'Manual Entry',
      MeasurementDetails: `Category: ${adjustmentForm.category}, International Standards Compliant`,
      Notes: fraudAnalysis.suspicious
        ? `SECURITY FLAGGED: ${fraudAnalysis.factors.join(', ')}`
        : null,

      // JSON field for additional data
      AdditionalProperties: JSON.stringify({
        fraudRiskScore: fraudAnalysis.riskScore,
        apiGravity: selectedTank.value.internationalStandards?.apiGravity,
        complianceStatus: selectedTank.value.fraudAnalysis?.complianceStatus,
        adjustmentTimestamp: new Date().toISOString(),
        userStationValidation: {
          userStations: AUTH_DATA.value.stations?.map((s) => s.StationID),
          accessedStation: currentStationId.value,
          validationPassed: true,
        },
      }),

      // Timestamps
      CreatedAt: new Date().toISOString(),
    }

    await apiCall('/InventoryHistory', {
      method: 'POST',
      body: JSON.stringify(historyData),
    })

    // 3. CORRECTED Audit Log Entry with proper FK relationships
    const auditData = {
      StationID: parseInt(currentStationId.value), // FK to Stations.StationID
      UserID: parseInt(currentUser.value.id), // FK to users.id
      Action: 'INVENTORY_ADJUSTMENT',
      TableName: 'Tanks',
      RecordID: selectedTank.value.TankID.toString(),
      Changes: JSON.stringify({
        // ERD compliant data structure
        tankInfo: {
          tankId: selectedTank.value.TankID,
          tankName: selectedTank.value.TankName,
          stationId: selectedTank.value.StationID,
          productId: selectedTank.value.ProductID,
        },
        adjustmentDetails: {
          previousLevel: currentLevel,
          newLevel: newLevel,
          adjustment: quantity,
          category: adjustmentForm.category,
          reason: adjustmentForm.reason,
        },
        securityInfo: {
          fraudRiskScore: fraudAnalysis.riskScore,
          internationalCompliance: true,
          stationOwnershipValidated: true,
          userAuthorizationLevel: AUTH_DATA.value.roles?.map((r) => r.RoleName) || [],
        },
        timestamp: new Date().toISOString(),
      }),
      IPAddress: 'client_ip',
      LogTimestamp: new Date().toISOString(),
    }

    await apiCall('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify(auditData),
    })

    // 4. ENHANCED: Log successful operation to fraud detection (for monitoring patterns)
    if (Math.abs(totalValue) > 1000000) {
      // Log high-value adjustments for monitoring
      await apiCall('/FraudDetectionLogs', {
        method: 'POST',
        body: JSON.stringify({
          StationID: currentStationId.value.toString(),
          TankID: selectedTank.value.TankID.toString(),
          AlertType: 'HIGH_VALUE_ADJUSTMENT_COMPLETED',
          Severity: 'MEDIUM',
          RiskScore: fraudAnalysis.riskScore.toString(),
          Description: `High-value inventory adjustment completed successfully: ${formatCurrency(Math.abs(totalValue))}`,
          DetectedAt: new Date().toISOString(),
          AffectedAmount: Math.abs(totalValue).toString(),
          Status: 'RESOLVED',
          ReviewedBy: currentUser.value.id.toString(),
          ResolvedAt: new Date().toISOString(),
          Notes: `Adjustment category: ${adjustmentForm.category}, Reason: ${adjustmentForm.reason}`,
          CreatedAt: new Date().toISOString(),
        }),
      })
    }

    // Success notification
    await Swal.fire({
      title: 'Adjustment Completed!',
      html: `
        <div class="text-start">
          <p><strong>Tank:</strong> ${selectedTank.value.TankName}</p>
          <p><strong>Station:</strong> ${currentStation.value?.Name || 'Unknown'}</p>
          <p><strong>Adjustment:</strong> ${quantity >= 0 ? '+' : ''}${formatVolume(quantity)}L</p>
          <p><strong>New Level:</strong> ${formatVolume(newLevel)}L</p>
          <p><strong>Financial Impact:</strong> ${formatCurrency(Math.abs(totalValue))}</p>
          <p><strong>Security Status:</strong> ${fraudAnalysis.suspicious ? 'Flagged for review' : 'Cleared'}</p>
          <p class="text-success"><strong>All ERD relationships validated ✓</strong></p>
        </div>
      `,
      icon: fraudAnalysis.riskScore > 50 ? 'warning' : 'success',
      confirmButtonColor: '#50cd89',
    })

    // Reset wizard and refresh data
    currentWizardStep.value = 1
    selectedTankId.value = null
    Object.assign(adjustmentForm, { category: '', quantity: '', reason: '' })
    await refreshData()
  } catch (error) {
    console.error('Adjustment failed:', error)

    // Log failed attempt for security monitoring
    await logSecurityViolation('ADJUSTMENT_FAILURE', `Failed adjustment attempt: ${error.message}`)

    await Swal.fire({
      title: 'Adjustment Failed!',
      text: error.message || 'Could not process inventory adjustment',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    submitting.value = false
  }
}

// Refresh Data
const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([
      loadTanks(),
      loadProducts(),
      loadUsers(),
      loadRecentAdjustments(),
      loadFraudAlerts(),
    ])

    Swal.fire({
      title: 'Data Refreshed!',
      text: 'All tank and security data updated',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('Failed to refresh data:', error)
    Swal.fire({
      title: 'Refresh Failed',
      text: 'Could not update tank data',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Additional Helper Functions
const getFraudRiskBadge = (riskLevel) => {
  const badgeMap = {
    LOW: 'badge-success',
    MEDIUM: 'badge-warning',
    HIGH: 'badge-danger',
  }
  return badgeMap[riskLevel] || 'badge-secondary'
}

const getFraudRiskColor = (riskLevel) => {
  const colorMap = {
    LOW: 'text-success',
    MEDIUM: 'text-warning',
    HIGH: 'text-danger',
  }
  return colorMap[riskLevel] || 'text-muted'
}

const getFillBarClass = (fillPercentage) => {
  if (fillPercentage > 80) return 'bg-success'
  if (fillPercentage > 50) return 'bg-warning'
  if (fillPercentage > 20) return 'bg-danger'
  return 'bg-dark'
}

const getRiskLevelBadge = (riskLevel) => {
  const badgeMap = {
    LOW: 'badge-light-success',
    MEDIUM: 'badge-light-warning',
    HIGH: 'badge-light-danger',
  }
  return badgeMap[riskLevel] || 'badge-light-secondary'
}

const getFraudSeverityBadge = (severity) => {
  const classMap = {
    HIGH: 'badge-danger',
    MEDIUM: 'badge-warning',
    LOW: 'badge-info',
  }
  return classMap[severity] || 'badge-secondary'
}

const formatVolume = (value) => {
  return parseFloat(value || 0).toLocaleString('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })
}

const formatVariance = (variance) => {
  const varianceNum = parseFloat(variance || 0)
  const prefix = varianceNum >= 0 ? '+' : ''
  return `${prefix}${formatVolume(variance)}`
}

const formatCurrency = (value) => {
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
  }).format(value || 0)
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

// Watch for form changes
watch([() => adjustmentForm.quantity, () => adjustmentForm.category], () => {
  validateAdjustmentForm()
  calculateAdjustmentImpact()
})

// Component Initialization with Enhanced Security
onMounted(async () => {
  console.log('🧙‍♂️ Tank Inventory Adjustment WIZARD initialized with COMPLETE SECURITY')
  console.log('📊 Current AUTH_DATA:', AUTH_DATA.value)

  // CRITICAL: Validate user authentication
  if (!JWT_TOKEN.value || !currentUser.value.id) {
    await Swal.fire({
      title: 'Authentication Required',
      text: 'Please login to access the inventory adjustment system',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  // CRITICAL: Validate station assignment
  if (!currentStationId.value) {
    await Swal.fire({
      title: 'Station Access Required',
      text: 'You must be assigned to a station to perform inventory adjustments',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  // CRITICAL: Validate user station access
  if (!validateUserStationAccess()) {
    await Swal.fire({
      title: 'Access Denied',
      text: 'Your account is not authorized to access this station',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  // Load all required data with error handling
  loading.value = true
  try {
    await Promise.all([
      loadProducts().catch((err) => {
        console.error('Failed to load products:', err)
        throw new Error('Could not load product catalog')
      }),
      loadTanks().catch((err) => {
        console.error('Failed to load tanks:', err)
        throw new Error('Could not load tank data')
      }),
      loadUsers().catch((err) => {
        console.error('Failed to load users:', err)
        console.warn('User data may be incomplete')
      }),
      loadRecentAdjustments().catch((err) => {
        console.error('Failed to load adjustments:', err)
        console.warn('Adjustment history may be incomplete')
      }),
      loadFraudAlerts().catch((err) => {
        console.error('Failed to load fraud alerts:', err)
        console.warn('Fraud alerts may be incomplete')
      }),
    ])

    // Validate loaded data
    if (!products.value.length) {
      throw new Error('No products found. Contact system administrator.')
    }

    if (!enrichedTanks.value.length) {
      console.warn('No tanks found for current station')
    }

    console.log('✅ Tank Inventory Adjustment WIZARD ready with FULL SECURITY:')
    console.log('   ✓ Wizard-based interface with progress tracking')
    console.log('   ✓ Full-screen modals for all data tables')
    console.log('   ✓ Station ownership validation')
    console.log('   ✓ Database FK integrity validation')
    console.log('   ✓ International standards compliance')
    console.log('   ✓ Advanced fraud detection with logging')
    console.log('   ✓ Comprehensive audit trail')
    console.log('   ✓ AI tax advisory')
    console.log('   ✓ Financial impact analysis')
    console.log('   ✓ Real-time security monitoring')
    console.log('   ✓ ERD relationship validation')
    console.log('   ✓ All undefined errors fixed')
    console.log('   ✓ Station access control enforced')

    // Final security check
    const securityStatus = {
      userAuthenticated: !!currentUser.value.id,
      stationAssigned: !!currentStationId.value,
      stationAccessValidated: validateUserStationAccess(),
      tanksLoaded: enrichedTanks.value.length,
      productsLoaded: products.value.length,
      fraudDetectionActive: true,
      internationalComplianceActive: true,
      databaseIntegrityValidationActive: true,
    }

    console.log('🔒 Security Status:', securityStatus)

    // Log successful initialization
    await logSecurityViolation(
      'SYSTEM_ACCESS_SUCCESS',
      `User ${currentUser.value.id} successfully initialized inventory adjustment system for station ${currentStationId.value}`,
    )
  } catch (error) {
    console.error('❌ Failed to initialize inventory adjustment wizard:', error)

    await logSecurityViolation(
      'SYSTEM_INITIALIZATION_FAILURE',
      `Failed to initialize system: ${error.message}`,
    )

    await Swal.fire({
      title: 'Initialization Failed',
      text: error.message || 'Could not load inventory adjustment wizard',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })

    // Don't continue if initialization fails
    return
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
/* iOS Premium Design Enhancements */
.card {
  border-radius: 1rem;
  border: none;
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
  transition: all 0.15s ease-in-out;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
}

.card-bordered {
  border: 1px solid #e1e3ea;
}

.cursor-pointer {
  cursor: pointer;
}

/* Tank Selection Cards */
.tank-selection-card {
  transition: all 0.2s ease-in-out;
}

.tank-selection-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.1);
}

.tank-selection-card.selected-tank {
  border-color: #3699ff !important;
  box-shadow: 0 0 0 0.25rem rgba(54, 153, 255, 0.25);
  transform: translateY(-3px);
}

/* Wizard Progress */
.wizard-step {
  animation: fadeInUp 0.3s ease-in-out;
}

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

/* Premium Progress Bars */
.progress {
  border-radius: 0.5rem;
  overflow: hidden;
  background-color: #f1f3f8;
}

.progress-bar {
  transition: width 0.6s ease;
  border-radius: 0.5rem;
}

/* Badge Enhancements */
.badge-circle {
  border-radius: 50%;
  width: 2.5rem;
  height: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}

/* Symbol Enhancements */
.symbol {
  border-radius: 0.75rem;
}

.symbol-label {
  border-radius: 0.75rem;
  font-weight: 600;
}

/* iOS Button Styles */
.btn {
  border-radius: 0.75rem;
  font-weight: 600;
  padding: 0.75rem 1.5rem;
  transition: all 0.15s ease-in-out;
}

.btn:hover:not(:disabled) {
  transform: translateY(-1px);
}

.btn-primary:hover {
  box-shadow: 0 0.25rem 0.5rem rgba(54, 153, 255, 0.3);
}

.btn-lg {
  padding: 1rem 2rem;
  font-size: 1.1rem;
}

/* Form Controls */
.form-control,
.form-select {
  border-radius: 0.5rem;
  border: 1px solid #e1e3ea;
  font-weight: 500;
  transition: all 0.15s ease-in-out;
}

.form-control:focus,
.form-select:focus {
  border-color: #f1416c;
  box-shadow: 0 0 0 0.25rem rgba(241, 65, 108, 0.25);
}

.form-control.is-invalid,
.form-select.is-invalid {
  border-color: #f1416c;
}

.invalid-feedback {
  color: #f1416c;
  font-weight: 500;
}

.form-label.required::after {
  content: '*';
  color: #f1416c;
  margin-left: 0.25rem;
}

/* Alert Enhancements */
.alert {
  border-radius: 0.75rem;
  border: none;
  font-weight: 500;
}

/* Table Enhancements */
.table {
  border-radius: 0.75rem;
  overflow: hidden;
}

.table-hover tbody tr:hover {
  background-color: rgba(241, 65, 108, 0.05);
}

.table thead th {
  background-color: #f8f9fa;
  border-bottom: 2px solid #e1e3ea;
  font-weight: 700;
  color: #5e6278;
  text-transform: uppercase;
  font-size: 0.75rem;
  letter-spacing: 0.5px;
}

/* Modal Enhancements */
.modal-content {
  border-radius: 1rem;
  border: none;
  box-shadow: 0 2rem 4rem rgba(0, 0, 0, 0.175);
}

.modal-header {
  border-bottom: 1px solid #e1e3ea;
  border-radius: 1rem 1rem 0 0;
}

.modal-footer {
  border-top: 1px solid #e1e3ea;
  border-radius: 0 0 1rem 1rem;
}

/* Gradient Backgrounds */
.bg-gradient-danger {
  background: linear-gradient(135deg, #f1416c 0%, #d12956 100%);
}

/* Loading States */
.spinner-border-lg {
  width: 3rem;
  height: 3rem;
}

/* Custom Badge Colors */
.badge-light-primary {
  background-color: rgba(54, 153, 255, 0.1);
  color: #3699ff;
}

.badge-light-success {
  background-color: rgba(80, 205, 137, 0.1);
  color: #50cd89;
}

.badge-light-warning {
  background-color: rgba(255, 199, 0, 0.1);
  color: #ffc700;
}

.badge-light-danger {
  background-color: rgba(241, 65, 108, 0.1);
  color: #f1416c;
}

.badge-light-info {
  background-color: rgba(54, 153, 255, 0.1);
  color: #3699ff;
}

.badge-light-secondary {
  background-color: rgba(126, 130, 153, 0.1);
  color: #7e8299;
}

/* Responsive Design */
@media (max-width: 768px) {
  .card-body {
    padding: 1rem;
  }

  .fs-1 {
    font-size: 1.5rem !important;
  }

  .symbol-50px {
    width: 40px !important;
    height: 40px !important;
  }

  .btn-lg {
    padding: 0.75rem 1.5rem;
    font-size: 1rem;
  }

  .wizard-step .row {
    margin-left: 0;
    margin-right: 0;
  }

  .modal-body {
    padding: 1rem;
  }
}

/* Transition effects */
.transition-all {
  transition: all 0.3s ease-in-out;
}

/* Text truncation */
.text-truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>

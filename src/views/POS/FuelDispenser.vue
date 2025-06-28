<template>
  <!-- FUEL DISPENSING SYSTEM - IOS PREMIUM DESIGN -->
  <div
    v-if="show"
    class="fuel-dispenser-modal d-block"
    style="background: rgba(0, 0, 0, 0.7); backdrop-filter: blur(10px)"
    tabindex="-1"
  >
    <div class="modal-dialog modal-xl modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg" style="border-radius: 20px">
        <!-- PREMIUM HEADER -->
        <div class="modal-header bg-gradient-primary border-0" style="border-radius: 20px 20px 0 0">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-oil-barrel fs-1 text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div>
              <h3 class="modal-title fw-bold text-white mb-0">Fuel Dispensing System</h3>
              <p class="text-white opacity-75 fs-7 mb-0">
                {{ selectedProduct?.Name || 'Select Product' }} • Step {{ currentStep }} of 3
              </p>
            </div>
          </div>
          <button
            @click="cancelDispensing"
            class="btn btn-icon btn-light btn-sm"
            style="border-radius: 12px"
          >
            <i class="ki-duotone ki-cross fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </button>
        </div>

        <div class="modal-body p-0">
          <!-- PROGRESS INDICATOR -->
          <div class="progress-container p-4 bg-light">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div
                v-for="step in 3"
                :key="step"
                :class="[
                  'd-flex align-items-center gap-2',
                  step <= currentStep ? 'text-primary' : 'text-gray-400',
                ]"
              >
                <div
                  :class="[
                    'symbol symbol-35px symbol-circle',
                    step < currentStep
                      ? 'bg-success'
                      : step === currentStep
                        ? 'bg-primary'
                        : 'bg-gray-300',
                  ]"
                >
                  <div class="symbol-label">
                    <i v-if="step < currentStep" class="ki-duotone ki-check fs-4 text-white">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <span v-else class="fw-bold text-white fs-6">{{ step }}</span>
                  </div>
                </div>
                <span class="fw-bold fs-7">{{ getStepName(step) }}</span>
              </div>
            </div>

            <!-- PROGRESS BAR -->
            <div class="progress" style="height: 6px; border-radius: 6px">
              <div
                class="progress-bar bg-primary progress-bar-animated"
                :style="{ width: ((currentStep - 1) / 2) * 100 + '%' }"
                style="border-radius: 6px; transition: width 0.5s ease"
              ></div>
            </div>
          </div>

          <!-- STEP CONTENT -->
          <div class="step-content p-4">
            <!-- STEP 1: TANK SELECTION -->
            <div v-if="currentStep === 1" class="tank-selection">
              <div class="text-center mb-4">
                <i class="ki-duotone ki-oil-barrel fs-3x text-primary mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <h4 class="fw-bold text-gray-800 mb-2">Select Fuel Tank</h4>
                <p class="text-gray-600 fs-7">
                  Choose the tank to dispense {{ selectedProduct?.Name }} from
                </p>
              </div>

              <!-- LOADING STATE -->
              <div v-if="loadingTanks" class="text-center py-5">
                <div class="spinner-border spinner-border-lg text-primary mb-3"></div>
                <div class="fw-bold text-gray-600">Loading available tanks...</div>
              </div>

              <!-- TANKS GRID -->
              <div v-else-if="availableTanks.length > 0" class="row g-3">
                <div
                  v-for="tank in availableTanks"
                  :key="tank.TankID"
                  :class="
                    availableTanks.length === 1
                      ? 'col-12'
                      : availableTanks.length === 2
                        ? 'col-6'
                        : 'col-6 col-md-4'
                  "
                >
                  <div
                    @click="selectTank(tank)"
                    :class="[
                      'card cursor-pointer h-100 border-0 shadow-sm',
                      selectedTank?.TankID === tank.TankID
                        ? 'border-primary bg-light-primary'
                        : 'bg-white hover-elevate-up',
                    ]"
                    style="
                      border-radius: 16px;
                      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                      min-height: 180px;
                    "
                  >
                    <div
                      class="card-body p-4 text-center d-flex flex-column justify-content-between"
                    >
                      <!-- TANK ICON -->
                      <div class="mb-3">
                        <div
                          :class="[
                            'symbol symbol-60px symbol-circle mx-auto mb-3',
                            selectedTank?.TankID === tank.TankID
                              ? 'bg-primary'
                              : 'bg-light-primary',
                          ]"
                        >
                          <i
                            :class="[
                              'ki-duotone ki-oil-barrel fs-2x',
                              selectedTank?.TankID === tank.TankID ? 'text-white' : 'text-primary',
                            ]"
                          >
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </div>
                        <h6
                          :class="[
                            'fw-bold mb-1',
                            selectedTank?.TankID === tank.TankID ? 'text-primary' : 'text-gray-800',
                          ]"
                        >
                          {{ tank.TankName }}
                        </h6>
                        <div
                          :class="[
                            'fs-8',
                            selectedTank?.TankID === tank.TankID
                              ? 'text-primary opacity-75'
                              : 'text-gray-500',
                          ]"
                        >
                          Tank {{ tank.TankID }}
                        </div>
                      </div>

                      <!-- TANK DETAILS -->
                      <div class="flex-grow-1">
                        <div class="row g-2 mb-3">
                          <div class="col-6">
                            <div
                              :class="[
                                'card border-0',
                                selectedTank?.TankID === tank.TankID
                                  ? 'bg-white bg-opacity-50'
                                  : 'bg-light',
                              ]"
                            >
                              <div class="card-body p-2 text-center">
                                <div
                                  :class="[
                                    'fw-bold fs-6',
                                    selectedTank?.TankID === tank.TankID
                                      ? 'text-primary'
                                      : 'text-gray-800',
                                  ]"
                                >
                                  {{ formatStock(tank.CurrentLevel) }}L
                                </div>
                                <div
                                  :class="[
                                    'fs-9',
                                    selectedTank?.TankID === tank.TankID
                                      ? 'text-primary opacity-75'
                                      : 'text-gray-500',
                                  ]"
                                >
                                  Current
                                </div>
                              </div>
                            </div>
                          </div>
                          <div class="col-6">
                            <div
                              :class="[
                                'card border-0',
                                selectedTank?.TankID === tank.TankID
                                  ? 'bg-white bg-opacity-50'
                                  : 'bg-light',
                              ]"
                            >
                              <div class="card-body p-2 text-center">
                                <div
                                  :class="[
                                    'fw-bold fs-6',
                                    selectedTank?.TankID === tank.TankID
                                      ? 'text-primary'
                                      : 'text-gray-800',
                                  ]"
                                >
                                  {{ formatStock(tank.Capacity) }}L
                                </div>
                                <div
                                  :class="[
                                    'fs-9',
                                    selectedTank?.TankID === tank.TankID
                                      ? 'text-primary opacity-75'
                                      : 'text-gray-500',
                                  ]"
                                >
                                  Capacity
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>

                        <!-- TANK LEVEL VISUALIZATION -->
                        <div class="mb-3">
                          <div class="d-flex justify-content-between fs-9 text-gray-600 mb-1">
                            <span>Level:</span>
                            <span>{{ getTankLevelPercentage(tank) }}%</span>
                          </div>
                          <div class="progress" style="height: 12px; border-radius: 12px">
                            <div
                              class="progress-bar"
                              :class="getTankLevelProgressClass(tank)"
                              :style="{ width: getTankLevelPercentage(tank) + '%' }"
                              style="border-radius: 12px; transition: width 0.3s ease"
                            ></div>
                          </div>
                        </div>

                        <!-- TANK STATUS -->
                        <div class="mt-auto">
                          <span :class="['badge w-100', getTankStatusBadgeClass(tank)]">
                            <i :class="['ki-duotone', getTankStatusIcon(tank), 'fs-4 me-1']">
                              <span class="path1"></span>
                              <span class="path2"></span>
                            </i>
                            {{ getTankStatusText(tank) }}
                          </span>
                        </div>
                      </div>

                      <!-- SELECTION INDICATOR -->
                      <div
                        v-if="selectedTank?.TankID === tank.TankID"
                        class="position-absolute top-0 end-0 mt-3 me-3"
                      >
                        <div class="symbol symbol-25px symbol-circle bg-success">
                          <i class="ki-duotone ki-check fs-6 text-white">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- NO TANKS AVAILABLE -->
              <div v-else class="text-center py-5">
                <i class="ki-duotone ki-information fs-3x text-warning mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <h5 class="fw-bold text-warning mb-2">No Tanks Available</h5>
                <p class="text-gray-600 fs-7">
                  No tanks with {{ selectedProduct?.Name }} are currently available for dispensing
                </p>
              </div>
            </div>

            <!-- STEP 2: PUMP SELECTION -->
            <div v-if="currentStep === 2" class="pump-selection">
              <div class="text-center mb-4">
                <i class="ki-duotone ki-gas-station fs-3x text-warning mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <h4 class="fw-bold text-gray-800 mb-2">Select Fuel Pump</h4>
                <p class="text-gray-600 fs-7">
                  Choose pump connected to
                  <span class="fw-bold text-primary">{{ selectedTank?.TankName }}</span>
                </p>
              </div>

              <!-- SELECTED TANK INFO -->
              <div class="card bg-light-primary border-primary mb-4">
                <div class="card-body p-3">
                  <div class="d-flex align-items-center gap-3">
                    <div class="symbol symbol-40px symbol-circle bg-primary">
                      <i class="ki-duotone ki-oil-barrel fs-2 text-white">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </div>
                    <div class="flex-grow-1">
                      <div class="fw-bold text-primary fs-5">{{ selectedTank.TankName }}</div>
                      <div class="fs-8 text-primary opacity-75">
                        {{ formatStock(selectedTank.CurrentLevel) }}L available
                      </div>
                    </div>
                    <div class="text-primary">
                      <div class="fw-bold fs-4">{{ getTankLevelPercentage(selectedTank) }}%</div>
                      <div class="fs-9">Full</div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- LOADING PUMPS -->
              <div v-if="loadingPumps" class="text-center py-5">
                <div class="spinner-border spinner-border-lg text-warning mb-3"></div>
                <div class="fw-bold text-gray-600">Loading available pumps...</div>
              </div>

              <!-- PUMPS GRID -->
              <div v-else-if="availablePumps.length > 0" class="row g-3">
                <div
                  v-for="pump in availablePumps"
                  :key="pump.PumpID"
                  :class="
                    availablePumps.length === 1
                      ? 'col-12'
                      : availablePumps.length === 2
                        ? 'col-6'
                        : 'col-6 col-md-4'
                  "
                >
                  <div
                    @click="selectPump(pump)"
                    :class="[
                      'card cursor-pointer h-100 border-0 shadow-sm',
                      selectedPump?.PumpID === pump.PumpID
                        ? 'border-warning bg-light-warning'
                        : 'bg-white hover-elevate-up',
                    ]"
                    style="
                      border-radius: 16px;
                      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                      min-height: 160px;
                    "
                  >
                    <div
                      class="card-body p-4 text-center d-flex flex-column justify-content-between"
                    >
                      <!-- PUMP ICON -->
                      <div class="mb-3">
                        <div
                          :class="[
                            'symbol symbol-60px symbol-circle mx-auto mb-3',
                            selectedPump?.PumpID === pump.PumpID
                              ? 'bg-warning'
                              : 'bg-light-warning',
                          ]"
                        >
                          <i
                            :class="[
                              'ki-duotone ki-gas-station fs-2x',
                              selectedPump?.PumpID === pump.PumpID ? 'text-white' : 'text-warning',
                            ]"
                          >
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </div>
                        <h6
                          :class="[
                            'fw-bold mb-1',
                            selectedPump?.PumpID === pump.PumpID ? 'text-warning' : 'text-gray-800',
                          ]"
                        >
                          {{ pump.PumpName }}
                        </h6>
                        <div
                          :class="[
                            'fs-8',
                            selectedPump?.PumpID === pump.PumpID
                              ? 'text-warning opacity-75'
                              : 'text-gray-500',
                          ]"
                        >
                          Pump {{ pump.PumpID }}
                        </div>
                      </div>

                      <!-- PUMP DETAILS -->
                      <div class="flex-grow-1">
                        <div
                          :class="[
                            'card border-0 mb-3',
                            selectedPump?.PumpID === pump.PumpID
                              ? 'bg-white bg-opacity-50'
                              : 'bg-light',
                          ]"
                        >
                          <div class="card-body p-3 text-center">
                            <div
                              :class="[
                                'fw-bold fs-5',
                                selectedPump?.PumpID === pump.PumpID
                                  ? 'text-warning'
                                  : 'text-gray-800',
                              ]"
                            >
                              {{ formatStock(pump.MeterReading) }}L
                            </div>
                            <div
                              :class="[
                                'fs-9',
                                selectedPump?.PumpID === pump.PumpID
                                  ? 'text-warning opacity-75'
                                  : 'text-gray-500',
                              ]"
                            >
                              Current Reading
                            </div>
                          </div>
                        </div>

                        <!-- PUMP STATUS -->
                        <div class="mt-auto">
                          <span :class="['badge w-100', getPumpStatusBadgeClass(pump)]">
                            <i :class="['ki-duotone', getPumpStatusIcon(pump), 'fs-4 me-1']">
                              <span class="path1"></span>
                              <span class="path2"></span>
                            </i>
                            {{ pump.Status }}
                          </span>
                        </div>
                      </div>

                      <!-- SELECTION INDICATOR -->
                      <div
                        v-if="selectedPump?.PumpID === pump.PumpID"
                        class="position-absolute top-0 end-0 mt-3 me-3"
                      >
                        <div class="symbol symbol-25px symbol-circle bg-success">
                          <i class="ki-duotone ki-check fs-6 text-white">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- NO PUMPS AVAILABLE -->
              <div v-else class="text-center py-5">
                <i class="ki-duotone ki-information fs-3x text-warning mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <h5 class="fw-bold text-warning mb-2">No Pumps Available</h5>
                <p class="text-gray-600 fs-7">
                  No active pumps are connected to {{ selectedTank?.TankName }}
                </p>
              </div>
            </div>

            <!-- STEP 3: QUANTITY INPUT -->
            <div v-if="currentStep === 3" class="quantity-input">
              <div class="text-center mb-4">
                <i class="ki-duotone ki-oil fs-3x text-success mb-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <h4 class="fw-bold text-gray-800 mb-2">Enter Dispense Quantity</h4>
                <p class="text-gray-600 fs-7">Specify how many liters to dispense</p>
              </div>

              <!-- DISPENSING SETUP SUMMARY -->
              <div class="row g-3 mb-4">
                <div class="col-6">
                  <div class="card bg-light-primary border-primary">
                    <div class="card-body p-3 text-center">
                      <i class="ki-duotone ki-oil-barrel fs-2 text-primary mb-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <div class="fw-bold text-primary fs-6">{{ selectedTank.TankName }}</div>
                      <div class="fs-8 text-primary opacity-75">
                        {{ formatStock(selectedTank.CurrentLevel) }}L available
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-6">
                  <div class="card bg-light-warning border-warning">
                    <div class="card-body p-3 text-center">
                      <i class="ki-duotone ki-gas-station fs-2 text-warning mb-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      <div class="fw-bold text-warning fs-6">{{ selectedPump.PumpName }}</div>
                      <div class="fs-8 text-warning opacity-75">
                        {{ formatStock(selectedPump.MeterReading) }}L reading
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- QUANTITY INPUT -->
              <div class="quantity-input-section">
                <label class="form-label fw-bold fs-3 text-center d-block mb-4"
                  >Quantity to Dispense (Liters)</label
                >

                <div class="position-relative mb-4">
                  <input
                    v-model.number="dispenseQuantity"
                    @input="validateQuantity"
                    @focus="quantityFocused = true"
                    @blur="quantityFocused = false"
                    type="number"
                    step="0.01"
                    min="0.01"
                    :max="maxDispenseQuantity"
                    class="form-control form-control-lg text-center fw-bold"
                    :class="getQuantityInputClass"
                    :style="getQuantityInputStyle"
                    placeholder="Enter liters..."
                    :disabled="processing"
                  />

                  <!-- UNIT INDICATOR -->
                  <div class="position-absolute top-50 end-0 translate-middle-y me-4">
                    <span class="fw-bold text-gray-500 fs-4">L</span>
                  </div>
                </div>

                <!-- VALIDATION FEEDBACK -->
                <div v-if="quantityValidation.error" class="alert alert-danger mb-4">
                  <i class="ki-duotone ki-information fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  {{ quantityValidation.message }}
                </div>

                <div v-else-if="quantityValidation.warning" class="alert alert-warning mb-4">
                  <i class="ki-duotone ki-information fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  {{ quantityValidation.message }}
                </div>

                <!-- QUICK QUANTITY BUTTONS -->
                <div class="quick-quantities mb-4">
                  <div class="fs-7 text-gray-600 mb-2">Quick Select:</div>
                  <div class="row g-2">
                    <div v-for="qty in quickQuantities" :key="qty" class="col-4 col-md-2">
                      <button
                        @click="setQuickQuantity(qty)"
                        :disabled="qty > maxDispenseQuantity || processing"
                        class="btn btn-light-primary w-100 fs-7 fw-bold"
                        style="border-radius: 8px"
                      >
                        {{ qty }}L
                      </button>
                    </div>
                  </div>
                </div>

                <!-- DISPENSE CALCULATION -->
                <div
                  v-if="dispenseQuantity > 0 && !quantityValidation.error"
                  class="card bg-light-success border-success"
                >
                  <div class="card-body p-4">
                    <h6 class="fw-bold text-success mb-3">
                      <i class="ki-duotone ki-calculator fs-2 me-2">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                      Dispense Summary
                    </h6>

                    <div class="row g-3">
                      <div class="col-6">
                        <div class="d-flex justify-content-between mb-2">
                          <span class="text-gray-700">Quantity:</span>
                          <span class="fw-bold text-success">{{ dispenseQuantity }}L</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                          <span class="text-gray-700">Unit Price:</span>
                          <span class="fw-bold">{{ formatCurrency(getProductPrice()) }}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                          <span class="text-gray-700 fw-bold">Total Cost:</span>
                          <span class="fw-bold text-success fs-4">{{
                            formatCurrency(getTotalCost())
                          }}</span>
                        </div>
                      </div>
                      <div class="col-6">
                        <div class="d-flex justify-content-between mb-2">
                          <span class="text-gray-700">Tank After:</span>
                          <span class="fw-bold"
                            >{{ formatStock(selectedTank.CurrentLevel - dispenseQuantity) }}L</span
                          >
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                          <span class="text-gray-700">New Reading:</span>
                          <span class="fw-bold"
                            >{{
                              formatStock(parseFloat(selectedPump.MeterReading) + dispenseQuantity)
                            }}L</span
                          >
                        </div>
                        <div class="d-flex justify-content-between">
                          <span class="text-gray-700">Efficiency:</span>
                          <span class="fw-bold text-info">{{ getEfficiencyRating() }}</span>
                        </div>
                      </div>
                    </div>

                    <!-- SAFETY INDICATORS -->
                    <div class="separator my-3"></div>
                    <div class="d-flex gap-3">
                      <div class="d-flex align-items-center gap-2">
                        <i class="ki-duotone ki-shield-tick fs-3 text-success">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        <span class="fs-8 text-gray-600">Safety Verified</span>
                      </div>
                      <div class="d-flex align-items-center gap-2">
                        <i class="ki-duotone ki-verify fs-3 text-info">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        <span class="fs-8 text-gray-600">Data Validated</span>
                      </div>
                      <div class="d-flex align-items-center gap-2">
                        <i class="ki-duotone ki-price-tag fs-3 text-warning">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                        <span class="fs-8 text-gray-600">Price Confirmed</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- MODAL ACTIONS -->
        <div class="modal-footer border-0 p-4 bg-light" style="border-radius: 0 0 20px 20px">
          <div class="w-100 d-flex gap-3">
            <!-- BACK BUTTON -->
            <button
              v-if="currentStep > 1"
              @click="previousStep"
              :disabled="processing"
              class="btn btn-light-secondary flex-shrink-0"
              style="border-radius: 12px; min-width: 120px"
            >
              <i class="ki-duotone ki-arrow-left fs-3 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Back
            </button>

            <!-- NEXT BUTTON -->
            <button
              v-if="currentStep < 3"
              @click="nextStep"
              :disabled="!canProceedToNextStep || processing"
              class="btn btn-primary flex-grow-1"
              style="border-radius: 12px; min-height: 50px"
            >
              <span class="fw-bold fs-5">{{ getNextButtonText() }}</span>
              <i class="ki-duotone ki-arrow-right fs-3 ms-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>

            <!-- DISPENSE BUTTON -->
            <button
              v-if="currentStep === 3"
              @click="confirmDispense"
              :disabled="!canDispense || processing"
              class="btn btn-success flex-grow-1"
              :class="{ 'btn-loading': processing }"
              style="border-radius: 12px; min-height: 50px"
            >
              <div v-if="processing" class="d-flex align-items-center justify-content-center">
                <div class="spinner-border spinner-border-sm me-2"></div>
                <span class="fw-bold">Processing...</span>
              </div>
              <div v-else class="d-flex align-items-center justify-content-center">
                <i class="ki-duotone ki-check-circle fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <span class="fw-bold fs-5">Confirm Dispense</span>
              </div>
            </button>

            <!-- CANCEL BUTTON -->
            <button
              @click="cancelDispensing"
              :disabled="processing"
              class="btn btn-light-danger flex-shrink-0"
              style="border-radius: 12px; min-width: 120px"
            >
              <i class="ki-duotone ki-cross fs-3 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- VERIFICATION LOG OVERLAY -->
    <div
      v-if="showVerificationOverlay"
      class="verification-overlay position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
      style="z-index: 9999; background: rgba(0, 0, 0, 0.8)"
    >
      <div class="card border-0 shadow-lg" style="max-width: 500px; border-radius: 16px">
        <div class="card-header bg-info">
          <h6 class="fw-bold text-white mb-0">
            <i class="ki-duotone ki-verify fs-3 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            System Verification
          </h6>
        </div>
        <div class="card-body p-4">
          <div class="text-center mb-3">
            <div class="spinner-border text-info mb-3"></div>
            <div class="fw-bold text-gray-800">Verifying dispensing parameters...</div>
            <div class="fs-8 text-gray-600 mt-2">{{ verificationStatus }}</div>
          </div>

          <div class="verification-steps">
            <div
              v-for="(step, index) in verificationSteps"
              :key="index"
              class="d-flex align-items-center gap-2 mb-2"
            >
              <div
                :class="[
                  'symbol symbol-20px symbol-circle',
                  step.completed ? 'bg-success' : step.active ? 'bg-info' : 'bg-gray-300',
                ]"
              >
                <i v-if="step.completed" class="ki-duotone ki-check fs-5 text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div
                  v-else-if="step.active"
                  class="spinner-border spinner-border-sm text-white"
                ></div>
              </div>
              <span
                :class="[
                  'fs-8',
                  step.completed ? 'text-success' : step.active ? 'text-info' : 'text-gray-500',
                ]"
              >
                {{ step.label }}
              </span>
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

// ========== PROPS & EMITS ==========
const props = defineProps({
  show: {
    type: Boolean,
    default: false,
  },
  selectedProduct: {
    type: Object,
    default: null,
  },
  stationId: {
    type: Number,
    default: null,
  },
  showVerificationLog: {
    type: Boolean,
    default: false,
  },
})

const emits = defineEmits([
  'fuel-dispensed',
  'dispensing-cancelled',
  'verification-log-updated',
  'step-changed',
])

// ========== CONSTANTS ==========
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const MIN_DISPENSE_QUANTITY = 0.01
const MAX_DISPENSE_QUANTITY = 10000
const SAFETY_MARGIN_LITERS = 5

// ========== REACTIVE STATE ==========
const currentStep = ref(1)
const processing = ref(false)
const loadingTanks = ref(false)
const loadingPumps = ref(false)
const quantityFocused = ref(false)

// Dispensing Data
const selectedTank = ref(null)
const selectedPump = ref(null)
const dispenseQuantity = ref(0)
const availableTanks = ref([])
const availablePumps = ref([])

// Validation
const quantityValidation = reactive({
  error: false,
  warning: false,
  message: '',
})

// Verification System
const verificationLog = ref([])
const showVerificationOverlay = ref(false)
const verificationStatus = ref('')
const verificationSteps = ref([
  { label: 'Validating tank levels', active: false, completed: false },
  { label: 'Checking pump status', active: false, completed: false },
  { label: 'Verifying safety parameters', active: false, completed: false },
  { label: 'Calculating pricing', active: false, completed: false },
  { label: 'Creating transaction record', active: false, completed: false },
])

// ========== COMPUTED PROPERTIES ==========
const maxDispenseQuantity = computed(() => {
  if (!selectedTank.value) return MAX_DISPENSE_QUANTITY
  const available = parseFloat(selectedTank.value.CurrentLevel || 0)
  return Math.max(0, available - SAFETY_MARGIN_LITERS)
})

const quickQuantities = computed(() => {
  const max = Math.min(maxDispenseQuantity.value, 200)
  const quantities = [5, 10, 20, 50, 100, 200]
  return quantities.filter((qty) => qty <= max)
})

const canProceedToNextStep = computed(() => {
  switch (currentStep.value) {
    case 1:
      return selectedTank.value !== null
    case 2:
      return selectedPump.value !== null
    case 3:
      return dispenseQuantity.value > 0 && !quantityValidation.error
    default:
      return false
  }
})

const canDispense = computed(() => {
  return (
    currentStep.value === 3 &&
    selectedTank.value &&
    selectedPump.value &&
    dispenseQuantity.value > 0 &&
    dispenseQuantity.value <= maxDispenseQuantity.value &&
    !quantityValidation.error &&
    !processing.value
  )
})

const getQuantityInputClass = computed(() => {
  if (processing.value) return 'border-gray-300'
  if (quantityValidation.error) return 'border-danger'
  if (quantityValidation.warning) return 'border-warning'
  if (dispenseQuantity.value > 0 && !quantityValidation.error) return 'border-success'
  if (quantityFocused.value) return 'border-primary'
  return 'border-light'
})

const getQuantityInputStyle = computed(() => {
  return {
    fontSize: '2.5rem',
    height: '100px',
    borderWidth: '3px',
    borderRadius: '16px',
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
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
  return `${num.toFixed(1)}`
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

const getProductPrice = () => {
  return parseFloat(props.selectedProduct?.SellingPrice || props.selectedProduct?.UnitPrice || 0)
}

const getTotalCost = () => {
  return dispenseQuantity.value * getProductPrice()
}

const getEfficiencyRating = () => {
  const percentage = getTankLevelPercentage(selectedTank.value)
  if (percentage > 75) return 'Excellent'
  if (percentage > 50) return 'Good'
  if (percentage > 25) return 'Fair'
  return 'Low'
}

const getStepName = (step) => {
  switch (step) {
    case 1:
      return 'Select Tank'
    case 2:
      return 'Choose Pump'
    case 3:
      return 'Set Quantity'
    default:
      return `Step ${step}`
  }
}

const getNextButtonText = () => {
  switch (currentStep.value) {
    case 1:
      return selectedTank.value ? 'Select Pump' : 'Choose Tank First'
    case 2:
      return selectedPump.value ? 'Set Quantity' : 'Choose Pump First'
    default:
      return 'Next'
  }
}

// Tank Utilities
const getTankLevelPercentage = (tank) => {
  if (!tank) return 0
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

const getTankStatusBadgeClass = (tank) => {
  const level = parseFloat(tank.CurrentLevel || 0)
  if (level <= SAFETY_MARGIN_LITERS) return 'badge-danger'
  if (level <= 50) return 'badge-warning'
  return 'badge-success'
}

const getTankStatusIcon = (tank) => {
  const level = parseFloat(tank.CurrentLevel || 0)
  if (level <= SAFETY_MARGIN_LITERS) return 'ki-cross-circle'
  if (level <= 50) return 'ki-information'
  return 'ki-check-circle'
}

const getTankStatusText = (tank) => {
  const level = parseFloat(tank.CurrentLevel || 0)
  if (level <= SAFETY_MARGIN_LITERS) return 'Critical Level'
  if (level <= 50) return 'Low Level'
  return 'Good Level'
}

// Pump Utilities
const getPumpStatusBadgeClass = (pump) => {
  if (pump.Status === 'Active') return 'badge-success'
  if (pump.Status === 'Maintenance') return 'badge-warning'
  return 'badge-danger'
}

const getPumpStatusIcon = (pump) => {
  if (pump.Status === 'Active') return 'ki-check-circle'
  if (pump.Status === 'Maintenance') return 'ki-information'
  return 'ki-cross-circle'
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
    component: 'FuelDispenser',
  }

  verificationLog.value.push(logEntry)

  // Keep only last 50 entries
  if (verificationLog.value.length > 50) {
    verificationLog.value = verificationLog.value.slice(-50)
  }

  console.log(`[FUEL DISPENSER VERIFICATION ${status}] ${operation}: ${details}`, data)

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
        Action: `FUEL_DISPENSER_VERIFICATION: ${logEntry.operation}`,
        TableName: 'FuelDispenser',
        Changes: JSON.stringify({
          status: logEntry.status,
          details: logEntry.details,
          data: logEntry.data,
          timestamp: logEntry.timestamp,
        }),
        IPAddress: 'FuelDispenser-Component',
        LogTimestamp: logEntry.timestamp,
      }),
    })
  } catch (error) {
    console.error('Failed to log verification audit:', error)
  }
}

const verifyDispensingParameters = async () => {
  const verification = {
    success: true,
    errors: [],
    warnings: [],
    details: {},
  }

  try {
    showVerificationOverlay.value = true
    verificationStatus.value = 'Starting verification process...'
    logVerification(
      'DISPENSING_VERIFICATION_START',
      'SUCCESS',
      'Starting comprehensive dispensing verification',
    )

    // Step 1: Validate tank levels
    verificationSteps.value[0].active = true
    verificationStatus.value = 'Validating tank levels...'
    await new Promise((resolve) => setTimeout(resolve, 500))

    const tankVerification = await verifyTankLevel()
    if (!tankVerification.success) {
      verification.success = false
      verification.errors.push(...tankVerification.errors)
    }
    verificationSteps.value[0].active = false
    verificationSteps.value[0].completed = true

    // Step 2: Check pump status
    verificationSteps.value[1].active = true
    verificationStatus.value = 'Checking pump status...'
    await new Promise((resolve) => setTimeout(resolve, 500))

    const pumpVerification = await verifyPumpStatus()
    if (!pumpVerification.success) {
      verification.success = false
      verification.errors.push(...pumpVerification.errors)
    }
    verificationSteps.value[1].active = false
    verificationSteps.value[1].completed = true

    // Step 3: Verify safety parameters
    verificationSteps.value[2].active = true
    verificationStatus.value = 'Verifying safety parameters...'
    await new Promise((resolve) => setTimeout(resolve, 500))

    const safetyVerification = await verifySafetyParameters()
    if (!safetyVerification.success) {
      verification.success = false
      verification.errors.push(...safetyVerification.errors)
    }
    verificationSteps.value[2].active = false
    verificationSteps.value[2].completed = true

    // Step 4: Calculate pricing
    verificationSteps.value[3].active = true
    verificationStatus.value = 'Calculating pricing...'
    await new Promise((resolve) => setTimeout(resolve, 500))

    const pricingVerification = await verifyPricing()
    if (!pricingVerification.success) {
      verification.success = false
      verification.errors.push(...pricingVerification.errors)
    }
    verificationSteps.value[3].active = false
    verificationSteps.value[3].completed = true

    // Step 5: Create transaction record validation
    verificationSteps.value[4].active = true
    verificationStatus.value = 'Preparing transaction...'
    await new Promise((resolve) => setTimeout(resolve, 500))

    const transactionVerification = await validateTransactionData()
    if (!transactionVerification.success) {
      verification.success = false
      verification.errors.push(...transactionVerification.errors)
    }
    verificationSteps.value[4].active = false
    verificationSteps.value[4].completed = true

    verification.details = {
      tank: tankVerification,
      pump: pumpVerification,
      safety: safetyVerification,
      pricing: pricingVerification,
      transaction: transactionVerification,
    }

    if (verification.success) {
      logVerification(
        'DISPENSING_VERIFICATION_SUCCESS',
        'SUCCESS',
        'All dispensing parameters verified successfully',
      )
    } else {
      logVerification(
        'DISPENSING_VERIFICATION_FAILED',
        'ERROR',
        `Verification failed with ${verification.errors.length} errors`,
      )
    }

    return verification
  } catch (error) {
    verification.success = false
    verification.errors.push(`Critical verification error: ${error.message}`)
    logVerification(
      'DISPENSING_VERIFICATION_ERROR',
      'ERROR',
      `Critical verification error: ${error.message}`,
    )
    return verification
  } finally {
    showVerificationOverlay.value = false
  }
}

const verifyTankLevel = async () => {
  const verification = { success: true, errors: [], details: {} }

  try {
    // Get fresh tank data
    const actualTank = await apiCall(`/Tanks/${selectedTank.value.TankID}`)
    if (!actualTank) {
      verification.success = false
      verification.errors.push('Tank not found in database')
      return verification
    }

    const currentLevel = parseFloat(actualTank.CurrentLevel || 0)
    const expectedAfterDispense = currentLevel - dispenseQuantity.value

    if (currentLevel < dispenseQuantity.value) {
      verification.success = false
      verification.errors.push(
        `Insufficient fuel in tank. Available: ${currentLevel}L, Requested: ${dispenseQuantity.value}L`,
      )
    }

    if (expectedAfterDispense < SAFETY_MARGIN_LITERS) {
      verification.errors.push(`Tank will be below safety margin after dispense`)
    }

    verification.details = {
      actualLevel: currentLevel,
      requestedQuantity: dispenseQuantity.value,
      afterDispense: expectedAfterDispense,
    }

    return verification
  } catch (error) {
    verification.success = false
    verification.errors.push(`Tank verification error: ${error.message}`)
    return verification
  }
}

const verifyPumpStatus = async () => {
  const verification = { success: true, errors: [], details: {} }

  try {
    // Get fresh pump data
    const actualPump = await apiCall(`/Pumps/${selectedPump.value.PumpID}`)
    if (!actualPump) {
      verification.success = false
      verification.errors.push('Pump not found in database')
      return verification
    }

    if (actualPump.Status !== 'Active') {
      verification.success = false
      verification.errors.push(`Pump is ${actualPump.Status}, not available for dispensing`)
    }

    verification.details = {
      pumpStatus: actualPump.Status,
      currentReading: actualPump.MeterReading,
      newReading: parseFloat(actualPump.MeterReading) + dispenseQuantity.value,
    }

    return verification
  } catch (error) {
    verification.success = false
    verification.errors.push(`Pump verification error: ${error.message}`)
    return verification
  }
}

const verifySafetyParameters = async () => {
  const verification = { success: true, errors: [], details: {} }

  try {
    // Check quantity limits
    if (dispenseQuantity.value < MIN_DISPENSE_QUANTITY) {
      verification.success = false
      verification.errors.push(`Quantity below minimum (${MIN_DISPENSE_QUANTITY}L)`)
    }

    if (dispenseQuantity.value > MAX_DISPENSE_QUANTITY) {
      verification.success = false
      verification.errors.push(`Quantity exceeds maximum (${MAX_DISPENSE_QUANTITY}L)`)
    }

    // Check tank-pump relationship
    if (selectedPump.value.TankID !== selectedTank.value.TankID) {
      verification.success = false
      verification.errors.push('Pump is not connected to selected tank')
    }

    verification.details = {
      quantityValid:
        dispenseQuantity.value >= MIN_DISPENSE_QUANTITY &&
        dispenseQuantity.value <= MAX_DISPENSE_QUANTITY,
      tankPumpRelation: selectedPump.value.TankID === selectedTank.value.TankID,
      safetyMargin: parseFloat(selectedTank.value.CurrentLevel) - dispenseQuantity.value,
    }

    return verification
  } catch (error) {
    verification.success = false
    verification.errors.push(`Safety verification error: ${error.message}`)
    return verification
  }
}

const verifyPricing = async () => {
  const verification = { success: true, errors: [], details: {} }

  try {
    // Get fresh product pricing
    const actualProduct = await apiCall(`/Products/${props.selectedProduct.ProductID}`)
    if (!actualProduct) {
      verification.success = false
      verification.errors.push('Product not found for pricing')
      return verification
    }

    const currentPrice = parseFloat(actualProduct.SellingPrice || actualProduct.UnitPrice || 0)
    const expectedPrice = getProductPrice()

    if (Math.abs(currentPrice - expectedPrice) > 0.01) {
      verification.errors.push(
        `Price mismatch detected. Expected: ${expectedPrice}, Current: ${currentPrice}`,
      )
    }

    const totalCost = dispenseQuantity.value * currentPrice

    verification.details = {
      unitPrice: currentPrice,
      quantity: dispenseQuantity.value,
      totalCost: totalCost,
      priceVerified: Math.abs(currentPrice - expectedPrice) <= 0.01,
    }

    return verification
  } catch (error) {
    verification.success = false
    verification.errors.push(`Pricing verification error: ${error.message}`)
    return verification
  }
}

const validateTransactionData = async () => {
  const verification = { success: true, errors: [], details: {} }

  try {
    const transactionData = {
      ProductID: props.selectedProduct.ProductID,
      TankID: selectedTank.value.TankID,
      PumpID: selectedPump.value.PumpID,
      Quantity: dispenseQuantity.value,
      UnitPrice: getProductPrice(),
      TotalCost: getTotalCost(),
      timestamp: new Date().toISOString(),
    }

    // Validate all required fields are present
    const requiredFields = ['ProductID', 'TankID', 'PumpID', 'Quantity', 'UnitPrice']
    for (const field of requiredFields) {
      if (!transactionData[field]) {
        verification.success = false
        verification.errors.push(`Missing required field: ${field}`)
      }
    }

    verification.details = transactionData

    return verification
  } catch (error) {
    verification.success = false
    verification.errors.push(`Transaction validation error: ${error.message}`)
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
const loadAvailableTanks = async () => {
  try {
    if (!props.selectedProduct || !props.stationId) return

    loadingTanks.value = true
    logVerification(
      'TANKS_LOAD_START',
      'SUCCESS',
      `Loading tanks for product ${props.selectedProduct.ProductID}`,
    )

    const response = await apiCall(
      `/Tanks?StationID=${props.stationId}&ProductID=${props.selectedProduct.ProductID}`,
    )
    const allTanks = response.records || []

    availableTanks.value = allTanks
      .filter(
        (tank) =>
          tank.Status === 'Active' && parseFloat(tank.CurrentLevel || 0) > SAFETY_MARGIN_LITERS,
      )
      .sort((a, b) => parseFloat(b.CurrentLevel) - parseFloat(a.CurrentLevel))

    logVerification(
      'TANKS_LOAD_SUCCESS',
      'SUCCESS',
      `Found ${availableTanks.value.length} available tanks`,
    )
  } catch (error) {
    console.error('Error loading tanks:', error)
    logVerification('TANKS_LOAD_ERROR', 'ERROR', error.message)
    availableTanks.value = []
  } finally {
    loadingTanks.value = false
  }
}

const loadAvailablePumps = async () => {
  try {
    if (!selectedTank.value) return

    loadingPumps.value = true
    logVerification(
      'PUMPS_LOAD_START',
      'SUCCESS',
      `Loading pumps for tank ${selectedTank.value.TankID}`,
    )

    const response = await apiCall(`/Pumps?TankID=${selectedTank.value.TankID}`)
    const allPumps = response.records || []

    availablePumps.value = allPumps
      .filter((pump) => pump.Status === 'Active')
      .sort((a, b) => a.PumpName.localeCompare(b.PumpName))

    logVerification(
      'PUMPS_LOAD_SUCCESS',
      'SUCCESS',
      `Found ${availablePumps.value.length} available pumps`,
    )
  } catch (error) {
    console.error('Error loading pumps:', error)
    logVerification('PUMPS_LOAD_ERROR', 'ERROR', error.message)
    availablePumps.value = []
  } finally {
    loadingPumps.value = false
  }
}

// ========== DISPENSING WORKFLOW ==========
const selectTank = async (tank) => {
  try {
    selectedTank.value = tank
    selectedPump.value = null
    availablePumps.value = []

    logVerification('TANK_SELECTED', 'SUCCESS', `Tank selected: ${tank.TankName} (${tank.TankID})`)

    // Verify tank data
    const verification = await verifyTankLevel()
    if (!verification.success) {
      await Swal.fire({
        title: 'Tank Verification Warning',
        text: verification.errors.join('\n'),
        icon: 'warning',
        confirmButtonText: 'Continue Anyway',
      })
    }
  } catch (error) {
    console.error('Error selecting tank:', error)
    logVerification('TANK_SELECTION_ERROR', 'ERROR', error.message)
  }
}

const selectPump = async (pump) => {
  try {
    selectedPump.value = pump

    logVerification('PUMP_SELECTED', 'SUCCESS', `Pump selected: ${pump.PumpName} (${pump.PumpID})`)

    // Verify pump data
    const verification = await verifyPumpStatus()
    if (!verification.success) {
      await Swal.fire({
        title: 'Pump Verification Warning',
        text: verification.errors.join('\n'),
        icon: 'warning',
        confirmButtonText: 'Continue Anyway',
      })
    }
  } catch (error) {
    console.error('Error selecting pump:', error)
    logVerification('PUMP_SELECTION_ERROR', 'ERROR', error.message)
  }
}

const validateQuantity = () => {
  quantityValidation.error = false
  quantityValidation.warning = false
  quantityValidation.message = ''

  if (!dispenseQuantity.value || dispenseQuantity.value <= 0) {
    return
  }

  if (dispenseQuantity.value < MIN_DISPENSE_QUANTITY) {
    quantityValidation.error = true
    quantityValidation.message = `Minimum quantity is ${MIN_DISPENSE_QUANTITY}L`
    return
  }

  if (dispenseQuantity.value > maxDispenseQuantity.value) {
    quantityValidation.error = true
    quantityValidation.message = `Maximum available quantity is ${maxDispenseQuantity.value}L`
    return
  }

  if (dispenseQuantity.value > MAX_DISPENSE_QUANTITY) {
    quantityValidation.error = true
    quantityValidation.message = `Maximum allowed quantity is ${MAX_DISPENSE_QUANTITY}L`
    return
  }

  const afterDispense = parseFloat(selectedTank.value.CurrentLevel) - dispenseQuantity.value
  if (afterDispense < SAFETY_MARGIN_LITERS) {
    quantityValidation.warning = true
    quantityValidation.message = `Tank will be below safety margin (${SAFETY_MARGIN_LITERS}L) after dispensing`
  }

  logVerification('QUANTITY_VALIDATED', 'SUCCESS', `Quantity validated: ${dispenseQuantity.value}L`)
}

const setQuickQuantity = (quantity) => {
  dispenseQuantity.value = quantity
  validateQuantity()
}

const nextStep = async () => {
  try {
    if (!canProceedToNextStep.value) return

    if (currentStep.value === 1) {
      await loadAvailablePumps()
    }

    currentStep.value++

    logVerification('STEP_ADVANCED', 'SUCCESS', `Advanced to step ${currentStep.value}`)
    emits('step-changed', { step: currentStep.value, direction: 'next' })
  } catch (error) {
    console.error('Error advancing step:', error)
    logVerification('STEP_ADVANCE_ERROR', 'ERROR', error.message)
  }
}

const previousStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--

    if (currentStep.value === 1) {
      selectedPump.value = null
      availablePumps.value = []
    }

    logVerification('STEP_BACK', 'SUCCESS', `Returned to step ${currentStep.value}`)
    emits('step-changed', { step: currentStep.value, direction: 'back' })
  }
}

const confirmDispense = async () => {
  try {
    processing.value = true

    // Comprehensive verification
    const verification = await verifyDispensingParameters()

    if (!verification.success) {
      await Swal.fire({
        title: 'Dispensing Verification Failed',
        html: `
          <div class="text-start">
            <p class="text-danger mb-2">Cannot proceed with dispensing:</p>
            <ul class="text-start fs-8">
              ${verification.errors
                .slice(0, 3)
                .map((error) => `<li>${error}</li>`)
                .join('')}
            </ul>
          </div>
        `,
        icon: 'error',
        confirmButtonText: 'OK',
      })
      return
    }

    // Final confirmation
    const result = await Swal.fire({
      title: 'Confirm Fuel Dispensing',
      html: `
        <div class="text-center">
          <div class="fs-2 fw-bold text-success mb-2">${dispenseQuantity.value}L</div>
          <div class="text-gray-600 mb-2">${props.selectedProduct.Name}</div>
          <div class="fs-6 fw-bold text-primary">${formatCurrency(getTotalCost())}</div>
          <div class="fs-8 text-gray-500 mt-3">${selectedTank.value.TankName} → ${selectedPump.value.PumpName}</div>
        </div>
      `,
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Yes, Dispense',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#50cd89',
      cancelButtonColor: '#f1416c',
    })

    if (result.isConfirmed) {
      const dispensingData = {
        product: props.selectedProduct,
        tank: selectedTank.value,
        pump: selectedPump.value,
        quantity: dispenseQuantity.value,
        unitPrice: getProductPrice(),
        totalCost: getTotalCost(),
        verification: verification,
        timestamp: new Date().toISOString(),
      }

      logVerification(
        'FUEL_DISPENSED',
        'SUCCESS',
        `Fuel dispensed: ${dispenseQuantity.value}L of ${props.selectedProduct.Name}`,
      )

      emits('fuel-dispensed', dispensingData)

      await Swal.fire({
        title: 'Dispensing Confirmed!',
        text: `${dispenseQuantity.value}L of ${props.selectedProduct.Name} will be added to cart`,
        icon: 'success',
        timer: 2000,
        showConfirmButton: false,
      })

      resetDispenser()
    }
  } catch (error) {
    console.error('Error confirming dispense:', error)
    logVerification('DISPENSE_CONFIRMATION_ERROR', 'ERROR', error.message)

    await Swal.fire({
      title: 'Dispensing Error',
      text: 'Could not complete dispensing operation',
      icon: 'error',
      confirmButtonText: 'OK',
    })
  } finally {
    processing.value = false
  }
}

const cancelDispensing = async () => {
  try {
    const result = await Swal.fire({
      title: 'Cancel Dispensing?',
      text: 'All entered data will be lost',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Yes, Cancel',
      cancelButtonText: 'Continue',
      confirmButtonColor: '#f1416c',
      cancelButtonColor: '#6c757d',
    })

    if (result.isConfirmed) {
      logVerification('DISPENSING_CANCELLED', 'SUCCESS', 'Fuel dispensing cancelled by user')

      resetDispenser()
      emits('dispensing-cancelled')

      await Swal.fire({
        title: 'Dispensing Cancelled',
        icon: 'info',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    }
  } catch (error) {
    console.error('Error cancelling dispensing:', error)
    logVerification('DISPENSING_CANCEL_ERROR', 'ERROR', error.message)
  }
}

const resetDispenser = () => {
  currentStep.value = 1
  selectedTank.value = null
  selectedPump.value = null
  dispenseQuantity.value = 0
  availableTanks.value = []
  availablePumps.value = []
  quantityValidation.error = false
  quantityValidation.warning = false
  quantityValidation.message = ''

  // Reset verification steps
  verificationSteps.value.forEach((step) => {
    step.active = false
    step.completed = false
  })
}

// ========== WATCHERS ==========
watch(
  () => props.show,
  (newShow) => {
    if (newShow) {
      resetDispenser()
      loadAvailableTanks()
    }
  },
)

watch(
  () => props.selectedProduct,
  (newProduct) => {
    if (newProduct) {
      resetDispenser()
      loadAvailableTanks()
    }
  },
)

watch(
  () => dispenseQuantity.value,
  () => {
    validateQuantity()
  },
)

// ========== LIFECYCLE ==========
onMounted(async () => {
  console.log('⛽ FuelDispenser Component Mounted')

  try {
    logVerification('COMPONENT_MOUNTED', 'SUCCESS', 'FuelDispenser component initialized')

    if (props.show && props.selectedProduct) {
      await loadAvailableTanks()
    }

    logVerification('COMPONENT_READY', 'SUCCESS', 'FuelDispenser component ready for use')
  } catch (error) {
    console.error('FuelDispenser mount error:', error)
    logVerification('COMPONENT_MOUNT_ERROR', 'ERROR', error.message)
  }
})
</script>

<style scoped>
/* iOS Premium Styling */
.fuel-dispenser-modal {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1050;
}

/* Gradient Backgrounds */
.bg-gradient-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

/* Modal Enhancements */
.modal-content {
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
}

.modal-dialog {
  max-width: 900px;
}

/* Progress Bar Styling */
.progress {
  background-color: rgba(0, 0, 0, 0.1);
  border-radius: 6px;
  overflow: hidden;
}

.progress-bar {
  border-radius: 6px;
  transition: width 0.5s ease;
}

/* Symbol & Badge Styling */
.symbol {
  border-radius: 50%;
  overflow: hidden;
}

.badge {
  border-radius: 8px;
  font-weight: 600;
}

/* Loading States */
.btn-loading {
  position: relative;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
}

/* Form Enhancements */
.form-control {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.form-control:focus {
  box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.15);
}

/* Shadow Enhancements */
.shadow-sm {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
}

.shadow-lg {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12) !important;
}

/* Step Progress Styling */
.progress-container {
  border-bottom: 1px solid #e9ecef;
}

.step-content {
  min-height: 400px;
}

/* Verification Overlay */
.verification-overlay {
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

/* Typography */
.fs-9 {
  font-size: 0.75rem !important;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .modal-dialog {
    margin: 0.5rem;
    max-width: none;
  }

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

  .step-content {
    min-height: 300px;
  }
}

@media (max-width: 576px) {
  .modal-dialog {
    margin: 0.25rem;
  }

  .btn {
    padding: 0.5rem 1rem !important;
    font-size: 0.875rem !important;
  }

  .row.g-3 > * {
    padding: 0.5rem;
  }
}

/* Animation Enhancements */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card {
  animation: slideIn 0.3s ease-out;
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Z-index Management */
.position-absolute {
  z-index: 1;
}

.verification-overlay {
  z-index: 9999;
}

/* Input Styling */
input[type='number'] {
  -moz-appearance: textfield;
}

input[type='number']::-webkit-outer-spin-button,
input[type='number']::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>

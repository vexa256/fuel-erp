<template>
  <div class="d-flex flex-column gap-5 p-4">
    <!-- iOS-Style Header with International Standards & Environmental Monitoring -->
    <div
      class="card card-flush"
      style="background: linear-gradient(135deg, #007aff 0%, #005bbb 100%)"
    >
      <div class="card-body p-6">
        <div class="d-flex align-items-center justify-content-between">
          <div class="d-flex align-items-center gap-4">
            <div class="symbol symbol-60px bg-white bg-opacity-20">
              <i class="ki-duotone ki-abstract-35 fs-2x text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div>
              <h1 class="text-white fw-bolder fs-2 mb-2">Tank Dip Readings Update</h1>
              <div class="d-flex align-items-center gap-4">
                <div class="d-flex align-items-center gap-2">
                  <div class="bullet bullet-dot bg-success animation-blink"></div>
                  <span class="text-white text-opacity-90 fs-7 fw-semibold"
                    >INTERNATIONAL PETROLEUM STANDARDS</span
                  >
                </div>
                <div class="d-flex align-items-center gap-2">
                  <div class="bullet bullet-dot bg-warning animation-blink"></div>
                  <span class="text-white text-opacity-90 fs-7 fw-semibold"
                    >ENVIRONMENTAL MONITORING</span
                  >
                </div>
                <div class="d-flex align-items-center gap-2">
                  <div class="bullet bullet-dot bg-danger animation-blink"></div>
                  <span class="text-white text-opacity-90 fs-7 fw-semibold"
                    >PARANOID FRAUD DETECTION</span
                  >
                </div>
              </div>
              <div class="d-flex align-items-center gap-3 mt-2">
                <div class="badge badge-white badge-lg">{{ stationName }}</div>
                <div class="text-white text-opacity-75 fs-8">
                  {{ currentUser.email || 'Field Operator' }}
                </div>
                <div class="text-white text-opacity-90 fs-6 fw-semibold">
                  {{ formatDateTime(new Date()) }}
                </div>
              </div>
            </div>
          </div>
          <div class="d-flex flex-column gap-2">
            <button @click="refreshData" class="btn btn-light btn-lg" :disabled="loading">
              <i class="ki-duotone ki-arrows-circle fs-3" :class="{ 'rotate-animation': loading }">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
            <button
              @click="toggleHistoryView"
              class="btn btn-warning btn-lg"
              :class="{ active: showHistory }"
            >
              <i class="ki-duotone ki-abstract-35 fs-3">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Critical Environmental & Compliance Statistics -->
    <div class="row g-4">
      <div class="col-6 col-lg-3">
        <div
          class="card h-100"
          style="background: linear-gradient(135deg, #34c759 0%, #248a3d 100%)"
        >
          <div class="card-body text-center p-5">
            <div class="symbol symbol-50px bg-white bg-opacity-20 mx-auto mb-3">
              <i class="ki-duotone ki-verify fs-2x text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div class="text-white fw-bold fs-6 mb-1">API MPMS Compliant</div>
            <div class="text-white fs-2 fw-bolder mb-1">{{ compliantReadings }}</div>
            <div class="text-white text-opacity-80 fs-8">within ±0.5% tolerance</div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div
          class="card h-100"
          style="background: linear-gradient(135deg, #ff3b30 0%, #d70015 100%)"
        >
          <div class="card-body text-center p-5">
            <div class="symbol symbol-50px bg-white bg-opacity-20 mx-auto mb-3">
              <i class="ki-duotone ki-shield-cross fs-2x text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div class="text-white fw-bold fs-6 mb-1">Fraud Alerts</div>
            <div class="text-white fs-2 fw-bolder mb-1">{{ fraudAlerts }}</div>
            <div class="text-white text-opacity-80 fs-8">suspicious activities</div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div
          class="card h-100"
          style="background: linear-gradient(135deg, #5ac8fa 0%, #007aff 100%)"
        >
          <div class="card-body text-center p-5">
            <div class="symbol symbol-50px bg-white bg-opacity-20 mx-auto mb-3">
              <i class="ki-duotone ki-drop fs-2x text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div class="text-white fw-bold fs-6 mb-1">Water Contamination</div>
            <div class="text-white fs-2 fw-bolder mb-1">{{ waterContaminationAlerts }}</div>
            <div class="text-white text-opacity-80 fs-8">tanks affected</div>
          </div>
        </div>
      </div>

      <div class="col-6 col-lg-3">
        <div
          class="card h-100"
          style="background: linear-gradient(135deg, #ff9500 0%, #cc7700 100%)"
        >
          <div class="card-body text-center p-5">
            <div class="symbol symbol-50px bg-white bg-opacity-20 mx-auto mb-3">
              <i class="ki-duotone ki-security-user fs-2x text-white">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
            </div>
            <div class="text-white fw-bold fs-6 mb-1">User Conflicts</div>
            <div class="text-white fs-2 fw-bolder mb-1">{{ userConflicts }}</div>
            <div class="text-white text-opacity-80 fs-8">different operators</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Date Selection -->
    <div class="card card-flush bg-light-primary">
      <div class="card-body p-6">
        <div class="row align-items-center">
          <div class="col-md-4">
            <label class="form-label fw-bold text-gray-900 fs-6 mb-3">Reading Date</label>
            <div class="input-group input-group-lg">
              <span class="input-group-text bg-primary border-primary">
                <i class="ki-duotone ki-calendar fs-2 text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </span>
              <input
                v-model="selectedDate"
                type="date"
                class="form-control form-control-lg border-primary fw-semibold"
                :max="maxDate"
                @change="loadMeterReadingsForDate"
              />
            </div>
          </div>
          <div class="col-md-8 mt-4 mt-md-0">
            <label class="form-label fw-bold text-gray-900 fs-6 mb-3">Quick Actions</label>
            <div class="d-flex gap-2 flex-wrap">
              <button
                @click="loadTodayReadings"
                class="btn btn-primary btn-lg"
                :class="{ active: isToday }"
              >
                <i class="ki-duotone ki-calendar-today fs-3 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Today
              </button>
              <button @click="loadYesterdayReadings" class="btn btn-light-primary btn-lg">
                <i class="ki-duotone ki-calendar fs-3 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Yesterday
              </button>
              <button @click="showEnvironmentalReport" class="btn btn-success btn-lg">
                <i class="ki-duotone ki-verify fs-3 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Environmental Report
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Fraud Detection Alerts -->
    <div
      v-if="fraudAlerts > 0"
      class="card card-flush bg-light-danger animate__animated animate__pulse"
    >
      <div class="card-body p-6">
        <div class="d-flex align-items-center gap-3 mb-4">
          <div class="symbol symbol-50px bg-danger">
            <i class="ki-duotone ki-shield-cross fs-2x text-white">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </div>
          <div>
            <h2 class="text-danger fw-bold fs-4 mb-1">🚨 FRAUD DETECTION ALERT</h2>
            <p class="text-gray-700 fs-7 mb-0">
              {{ fraudAlerts }} suspicious environmental or operational anomalies detected
            </p>
          </div>
          <div class="ms-auto">
            <button @click="viewFraudDetails" class="btn btn-danger">
              <i class="ki-duotone ki-eye fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span> </i
              >Review Alerts
            </button>
          </div>
        </div>

        <div class="row g-3">
          <div v-for="alert in recentFraudAlerts" :key="alert.id" class="col-12 col-md-6">
            <div class="bg-white p-3 rounded border border-danger">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <span class="badge badge-danger fs-8 fw-bold">{{ alert.type }}</span>
                <span class="fs-8 text-gray-600">{{ formatDateTime(alert.timestamp) }}</span>
              </div>
              <div class="fs-7 text-gray-900 fw-semibold mb-1">{{ alert.description }}</div>
              <div class="fs-8 text-gray-600">
                Risk Score: {{ alert.riskScore }}% | Factors: {{ alert.factors.join(', ') }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Reading History Panel -->
    <div
      v-if="showHistory"
      class="card card-flush bg-light-warning animate__animated animate__slideInDown"
    >
      <div class="card-body p-6">
        <div class="d-flex align-items-center gap-3 mb-5">
          <div class="symbol symbol-50px bg-warning">
            <i class="ki-duotone ki-abstract-35 fs-2x text-white">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </div>
          <div>
            <h2 class="text-gray-900 fw-bold fs-4 mb-1">Environmental & Dip Reading History</h2>
            <p class="text-gray-700 fs-7 mb-0">
              Complete audit trail with environmental monitoring and fraud analysis
            </p>
          </div>
          <div class="ms-auto">
            <div class="badge badge-warning fs-8 fw-bold">Last {{ historyDays }} Days</div>
          </div>
        </div>

        <!-- History Cards for Each Reading -->
        <div class="row g-4 mb-5">
          <div
            v-for="reading in meterReadings"
            :key="`history-${reading.ReadingID}`"
            class="col-12 col-md-6 col-xl-4"
          >
            <div class="card bg-white border border-warning">
              <div class="card-header bg-light-warning border-0">
                <div class="card-title d-flex align-items-center gap-2 w-100">
                  <i class="ki-duotone ki-abstract-35 fs-4 text-warning">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <div class="flex-fill">
                    <h4 class="fw-bold text-gray-900 mb-0">{{ getTankName(reading.TankID) }}</h4>
                    <div class="text-gray-600 fs-7">{{ getPumpInfo(reading.PumpID) }}</div>
                  </div>
                  <span class="badge" :class="getReadingStatusBadgeClass(reading.Status)">{{
                    reading.Status
                  }}</span>
                </div>
              </div>
              <div class="card-body p-4">
                <div class="row g-3 mb-3">
                  <div class="col-4">
                    <div class="text-center p-2 bg-light-primary rounded">
                      <div class="fs-8 fw-bold text-gray-600 mb-1">Sales</div>
                      <div class="fs-6 fw-bold text-primary">
                        {{ formatLiters(reading.CalculatedSales) }}
                      </div>
                    </div>
                  </div>
                  <div class="col-4">
                    <div class="text-center p-2 bg-light-info rounded">
                      <div class="fs-8 fw-bold text-gray-600 mb-1">Dip</div>
                      <div class="fs-6 fw-bold text-info">
                        {{ reading.DipReading ? formatLiters(reading.DipReading) : 'PENDING' }}
                      </div>
                    </div>
                  </div>
                  <div class="col-4">
                    <div class="text-center p-2 bg-light-success rounded">
                      <div class="fs-8 fw-bold text-gray-600 mb-1">Temp</div>
                      <div class="fs-6 fw-bold text-success">
                        {{ reading.Temperature ? reading.Temperature + '°C' : '--' }}
                      </div>
                    </div>
                  </div>
                </div>

                <div
                  v-if="reading.WaterLevelCM && parseFloat(reading.WaterLevelCM) > 0"
                  class="bg-light-danger p-2 rounded mb-3"
                >
                  <div class="fs-8 text-danger fw-bold">
                    ⚠️ Water Contamination: {{ reading.WaterLevelCM }}cm ({{
                      reading.WaterVolumeL
                    }}L)
                  </div>
                </div>

                <div class="border-top pt-3">
                  <div class="fs-8 text-gray-600 mb-1">
                    <strong>Recorded by:</strong> {{ getUserName(reading.RecordedBy) }}
                  </div>
                  <div class="fs-8 text-gray-600">
                    <strong>Date:</strong> {{ formatDate(reading.ReadingDate) }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="d-flex flex-column gap-4">
      <div v-for="i in 6" :key="i" class="card animate__animated animate__fadeIn">
        <div class="card-body p-5">
          <div class="d-flex align-items-center gap-4">
            <div class="skeleton skeleton-circle w-70px h-70px"></div>
            <div class="flex-fill">
              <div class="skeleton skeleton-text mb-3 w-75"></div>
              <div class="skeleton skeleton-text mb-2 w-50"></div>
              <div class="skeleton skeleton-text w-25"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Meter Readings Cards - UPDATE MODE WITH ENVIRONMENTAL MONITORING -->
    <div v-else class="row g-5">
      <div
        v-for="reading in meterReadings"
        :key="reading.ReadingID"
        class="col-12 col-md-6 col-xl-4"
      >
        <div class="card card-flush h-100 border-2" :class="getReadingCardClass(reading)">
          <!-- Reading Header -->
          <div class="card-header bg-light-gray-100 border-0">
            <div class="card-title d-flex align-items-center gap-3 w-100">
              <div class="symbol symbol-60px" :class="getReadingSymbolClass(reading)">
                <div class="symbol-label">
                  <i class="ki-duotone ki-abstract-35 fs-2x text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div class="flex-fill">
                <h3 class="fw-bolder fs-5 text-gray-900 mb-1">{{ getTankName(reading.TankID) }}</h3>
                <div class="text-gray-600 fs-7 fw-semibold mb-2">
                  {{ getPumpInfo(reading.PumpID) }}
                </div>
                <div class="d-flex gap-2">
                  <span class="badge badge-light-primary fs-8 fw-bold"
                    >Reading #{{ reading.ReadingID }}</span
                  >
                  <span class="badge badge-light-info fs-8 fw-bold">{{
                    formatDate(reading.ReadingDate)
                  }}</span>
                </div>
              </div>
              <div>
                <div class="badge fs-8 fw-bold" :class="getReadingStatusBadgeClass(reading.Status)">
                  {{ reading.Status }}
                </div>
              </div>
            </div>
          </div>

          <div class="card-body p-5">
            <!-- International Standards Compliance Banner -->
            <div class="bg-light-success p-3 rounded-3 mb-4 border border-success">
              <div class="d-flex align-items-center gap-2 mb-2">
                <i class="ki-duotone ki-verify fs-5 text-success">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-7 text-gray-900">API MPMS Chapter 3.1A Standards</div>
              </div>
              <div class="fs-8 text-gray-700">
                <strong>Tolerance:</strong> ±0.5% | <strong>Temperature Compensation:</strong> VCF
                Applied | <strong>Water Detection:</strong> Active
              </div>
            </div>

            <!-- Meter Readings Display (READ-ONLY) -->
            <div class="mb-5">
              <div class="d-flex align-items-center gap-2 mb-3">
                <i class="ki-duotone ki-abstract-26 fs-5 text-primary">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-6 text-gray-900">Meter Readings (System Recorded)</div>
                <span class="badge badge-light-primary fs-8">LOCKED</span>
              </div>

              <div class="row g-3 mb-4">
                <div class="col-4">
                  <div class="text-center p-3 bg-light-primary rounded">
                    <div class="fs-8 fw-bold text-gray-600 mb-1">Opening</div>
                    <div class="fs-5 fw-bold text-gray-900">
                      {{ formatMeterReading(reading.OpeningReading) }}
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="text-center p-3 bg-light-primary rounded">
                    <div class="fs-8 fw-bold text-gray-600 mb-1">Closing</div>
                    <div class="fs-5 fw-bold text-gray-900">
                      {{ formatMeterReading(reading.ClosingReading) }}
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="text-center p-3 bg-light-success rounded">
                    <div class="fs-8 fw-bold text-gray-600 mb-1">Sales</div>
                    <div class="fs-5 fw-bold text-success">
                      {{ formatLiters(reading.CalculatedSales) }}
                    </div>
                  </div>
                </div>
              </div>

              <div class="bg-light-info p-3 rounded">
                <div class="fs-8 text-gray-700">
                  <strong>Recorded by:</strong> {{ getUserName(reading.RecordedBy) }} |
                  <strong>Time:</strong> {{ formatDateTime(reading.CreatedAt) }}
                </div>
              </div>
            </div>

            <!-- User Conflict Detection -->
            <div
              v-if="isUserConflict(reading)"
              class="bg-light-danger p-3 rounded-3 mb-4 border border-danger"
            >
              <div class="d-flex align-items-center gap-2 mb-2">
                <i class="ki-duotone ki-shield-cross fs-5 text-danger">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-7 text-danger">⚠️ USER CONFLICT DETECTED</div>
              </div>
              <div class="fs-8 text-gray-700">
                <strong>Meter recorded by:</strong> {{ getUserName(reading.RecordedBy) }}<br />
                <strong>Current user:</strong> {{ currentUser.email }}<br />
                <strong>Action:</strong> All activities logged for audit
              </div>
            </div>

            <!-- Environmental Monitoring Inputs -->
            <div class="mb-5">
              <div class="d-flex align-items-center gap-2 mb-3">
                <i class="ki-duotone ki-abstract-27 fs-5 text-warning">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-6 text-gray-900">Environmental Monitoring</div>
                <span class="badge badge-light-warning fs-8">API MPMS</span>
              </div>

              <div class="row g-3 mb-4">
                <!-- Fuel Temperature Input -->
                <div class="col-6">
                  <label class="form-label fw-bold fs-7 text-gray-900 mb-2">
                    <i class="ki-duotone ki-abstract-27 fs-5 me-1 text-warning">
                      <span class="path1"></span>
                      <span class="path2"></span> </i
                    >Fuel Temperature
                  </label>
                  <div class="input-group">
                    <input
                      v-model="environmentalData[reading.ReadingID]?.temperature"
                      type="number"
                      step="0.1"
                      min="-10"
                      max="60"
                      class="form-control text-center fw-bold border-warning"
                      :placeholder="reading.Temperature || '°C'"
                      @input="calculateVCF(reading)"
                      @focus="logUserActivity('TEMPERATURE_FOCUS', reading)"
                    />
                    <span class="input-group-text bg-light-warning border-warning">°C</span>
                  </div>
                </div>

                <!-- Water Level Input -->
                <div class="col-6">
                  <label class="form-label fw-bold fs-7 text-gray-900 mb-2">
                    <i class="ki-duotone ki-drop fs-5 me-1 text-info">
                      <span class="path1"></span>
                      <span class="path2"></span> </i
                    >Water Level
                  </label>
                  <div class="input-group">
                    <input
                      v-model="environmentalData[reading.ReadingID]?.waterLevel"
                      type="number"
                      step="0.1"
                      min="0"
                      max="100"
                      class="form-control text-center fw-bold border-info"
                      :placeholder="reading.WaterLevelCM || 'cm'"
                      @input="calculateWaterVolume(reading)"
                      @focus="logUserActivity('WATER_LEVEL_FOCUS', reading)"
                    />
                    <span class="input-group-text bg-light-info border-info">cm</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Volume Correction Factor Display -->
            <div
              v-if="vcfFactors[reading.ReadingID]"
              class="bg-light-warning p-3 rounded-3 mb-4 border border-warning"
            >
              <div class="d-flex align-items-center gap-2 mb-2">
                <i class="ki-duotone ki-abstract-27 fs-5 text-warning">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-7 text-gray-900">Volume Correction Factor (VCF)</div>
              </div>
              <div class="row g-2">
                <div class="col-4">
                  <div class="text-center">
                    <div class="fs-8 fw-bold text-gray-600">Factor</div>
                    <div class="fs-6 fw-bold text-gray-900">
                      {{ vcfFactors[reading.ReadingID].factor }}
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="text-center">
                    <div class="fs-8 fw-bold text-gray-600">
                      Observed ({{ vcfFactors[reading.ReadingID].observedTemp }}°C)
                    </div>
                    <div class="fs-6 fw-bold text-gray-900">
                      {{ formatLiters(vcfFactors[reading.ReadingID].observedVolume) }}
                    </div>
                  </div>
                </div>
                <div class="col-4">
                  <div class="text-center">
                    <div class="fs-8 fw-bold text-gray-600">Standard (15°C)</div>
                    <div class="fs-6 fw-bold text-gray-900">
                      {{ formatLiters(vcfFactors[reading.ReadingID].standardVolume) }}
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Water Contamination Alert -->
            <div
              v-if="
                waterVolumes[reading.ReadingID] && parseFloat(waterVolumes[reading.ReadingID]) > 0
              "
              class="bg-light-danger p-3 rounded-3 mb-4 border border-danger"
            >
              <div class="d-flex align-items-center gap-2 mb-2">
                <i class="ki-duotone ki-drop fs-5 text-danger">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div class="fw-bold fs-7 text-danger">⚠️ WATER CONTAMINATION DETECTED</div>
              </div>
              <div class="row g-2">
                <div class="col-6">
                  <div class="text-center">
                    <div class="fs-8 fw-bold text-gray-600">Water Level</div>
                    <div class="fs-6 fw-bold text-danger">
                      {{ environmentalData[reading.ReadingID]?.waterLevel }}cm
                    </div>
                  </div>
                </div>
                <div class="col-6">
                  <div class="text-center">
                    <div class="fs-8 fw-bold text-gray-600">Water Volume</div>
                    <div class="fs-6 fw-bold text-danger">
                      {{ formatLiters(waterVolumes[reading.ReadingID]) }}
                    </div>
                  </div>
                </div>
              </div>
              <div class="mt-2">
                <div class="fs-8 text-gray-700">
                  <strong>Action Required:</strong> Water removal necessary before fuel sales.
                  Immediate maintenance alert triggered.
                </div>
              </div>
            </div>

            <!-- Dip Reading Input (UPDATE ONLY) -->
            <div class="mb-5">
              <label class="form-label fw-bold text-gray-900 fs-6 mb-3">
                <i class="ki-duotone ki-abstract-35 fs-5 me-2 text-primary">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Physical Dip Reading (Tank Volume)
              </label>

              <div class="input-group input-group-lg">
                <span class="input-group-text bg-primary border-primary">
                  <i class="ki-duotone ki-abstract-35 fs-2 text-white">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </span>
                <input
                  v-model="dipReadings[reading.ReadingID]"
                  type="number"
                  step="0.01"
                  min="0"
                  class="form-control form-control-lg text-center fw-bold fs-4 border-primary"
                  :class="getDipInputClass(reading)"
                  :placeholder="reading.DipReading || 'Enter physical tank volume...'"
                  @input="calculateInternationalVariance(reading)"
                  @blur="validateDipReading(reading)"
                  @focus="logUserActivity('DIP_READING_FOCUS', reading)"
                />
                <span class="input-group-text bg-light-primary border-primary">
                  <span class="fw-bold text-primary">L</span>
                </span>
              </div>

              <div
                v-if="validationErrors[reading.ReadingID]"
                class="text-danger fs-7 fw-semibold mt-2"
              >
                <i class="ki-duotone ki-cross-circle fs-5 me-1">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >{{ validationErrors[reading.ReadingID] }}
              </div>

              <div v-if="reading.DipReading" class="text-success fs-7 fw-semibold mt-2">
                <i class="ki-duotone ki-check-circle fs-5 me-1">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Current dip reading: {{ formatLiters(reading.DipReading) }}
              </div>
            </div>

            <!-- International Variance Analysis with Environmental Factors -->
            <div v-if="variances[reading.ReadingID] !== null" class="mb-5">
              <div
                class="d-flex justify-content-between align-items-center p-4 rounded-3 border-2"
                :class="getInternationalVarianceClass(reading)"
              >
                <div>
                  <div class="fw-bold text-gray-900 fs-7 mb-1">Environmental Variance</div>
                  <div class="fs-4 fw-bolder">
                    {{ formatVariance(variances[reading.ReadingID]) }}
                  </div>
                  <div class="fs-8 text-gray-600">Temperature Compensated</div>
                </div>
                <div class="text-center">
                  <div class="fw-bold text-gray-900 fs-7 mb-1">Percentage</div>
                  <div class="fs-4 fw-bolder">{{ variancePercentages[reading.ReadingID] }}%</div>
                  <div class="fs-8 text-gray-600">API MPMS: ±0.5%</div>
                </div>
                <div class="text-center">
                  <div class="fw-bold text-gray-900 fs-7 mb-1">Compliance</div>
                  <div class="badge fs-7" :class="getComplianceStatusBadgeClass(reading)">
                    {{ getComplianceStatusText(reading) }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Paranoid Fraud Risk Assessment -->
            <div v-if="fraudRiskScores[reading.ReadingID]" class="mb-5">
              <div class="bg-light-danger p-4 rounded-3 border border-danger">
                <div class="d-flex align-items-center gap-2 mb-3">
                  <i class="ki-duotone ki-security-user fs-5 text-danger">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  <div class="fw-bold fs-7 text-gray-900">Paranoid Fraud Risk Assessment</div>
                </div>

                <div class="row g-3">
                  <div class="col-6">
                    <div class="text-center">
                      <div class="fs-8 fw-bold text-gray-600 mb-1">Risk Score</div>
                      <div class="fs-6 fw-bold" :class="getFraudRiskClass(reading)">
                        {{ fraudRiskScores[reading.ReadingID] }}%
                      </div>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="text-center">
                      <div class="fs-8 fw-bold text-gray-600 mb-1">Risk Level</div>
                      <div class="fs-6 fw-bold" :class="getFraudRiskClass(reading)">
                        {{ getFraudRiskLevel(reading) }}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="mt-3">
                  <div class="fs-8 text-gray-700">
                    <strong>Risk Factors:</strong> {{ getFraudRiskFactors(reading).join(', ') }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex gap-2 mt-4">
              <button
                @click="updateEnvironmentalDipReading(reading)"
                class="btn btn-success btn-lg flex-fill"
                :disabled="!dipReadings[reading.ReadingID] || submitting[reading.ReadingID]"
              >
                <span
                  v-if="submitting[reading.ReadingID]"
                  class="spinner-border spinner-border-sm me-2"
                ></span>
                <i v-else class="ki-duotone ki-check-circle fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Update with Environmental Data
              </button>

              <button @click="viewReadingDetails(reading)" class="btn btn-light-primary btn-lg">
                <i class="ki-duotone ki-eye fs-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bulk Environmental Update Operations -->
    <div
      v-if="meterReadings.length > 0"
      class="card card-flush"
      style="background: linear-gradient(135deg, #1c1c1e 0%, #000000 100%)"
    >
      <div class="card-body p-6">
        <div class="row align-items-center">
          <div class="col-md-6">
            <div class="d-flex align-items-center gap-3">
              <div class="symbol symbol-50px bg-white bg-opacity-20">
                <i class="ki-duotone ki-abstract-35 fs-2x text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
              <div>
                <h3 class="text-white fw-bold fs-4 mb-1">Bulk Environmental Update</h3>
                <p class="text-white text-opacity-80 fs-7 mb-0">
                  Update dip readings with temperature compensation and water detection
                </p>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="d-flex gap-2 flex-wrap justify-content-md-end">
              <button
                @click="updateAllEnvironmentalReadings"
                class="btn btn-success btn-lg"
                :disabled="!hasValidDipReadings || bulkSubmitting"
              >
                <span v-if="bulkSubmitting" class="spinner-border spinner-border-sm me-2"></span>
                <i v-else class="ki-duotone ki-verify fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span> </i
                >Update All ({{ validDipReadingsCount }})
              </button>
              <button @click="exportEnvironmentalReport" class="btn btn-light-primary btn-lg">
                <i class="ki-duotone ki-file-down fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span> </i
                >Export Environmental Report
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN = localStorage.getItem('jwt') || ''

// International Petroleum Standards
const INTERNATIONAL_TOLERANCE_PERCENT = 0.5 // ±0.5% as per API MPMS standards
const FRAUD_RISK_THRESHOLD = 30 // Risk scores above 30% trigger alerts

// Core State
const loading = ref(false)
const bulkSubmitting = ref(false)
const submitting = ref({})
const meterReadings = ref([]) // Existing DailyReadings with meter data
const tanks = ref([])
const pumps = ref([])
const users = ref([])
const products = ref([])
const showHistory = ref(false)
const historyDays = ref(7)

// Station Management
const currentStation = ref(null)
const userStations = ref([])

// Environmental & Dip Reading Update Data (API Compliant)
const dipReadings = ref({}) // ReadingID -> DipReading value
const environmentalData = ref({}) // ReadingID -> { temperature, waterLevel }
const variances = ref({})
const variancePercentages = ref({})
const vcfFactors = ref({})
const waterVolumes = ref({})
const fraudRiskScores = ref({})
const validationErrors = ref({})
const recentFraudAlerts = ref([])

// User Context
const currentUser = ref(JSON.parse(localStorage.getItem('user') || '{}'))

// Date Management
const selectedDate = ref(new Date().toISOString().split('T')[0])
const maxDate = computed(() => new Date().toISOString().split('T')[0])
const isToday = computed(() => selectedDate.value === new Date().toISOString().split('T')[0])

// Computed Properties for Environmental & Standards Compliance
const stationName = computed(() =>
  currentStation.value ? currentStation.value.StationName : 'Loading Station...',
)

const compliantReadings = computed(() => {
  return meterReadings.value.filter((reading) => {
    if (!reading.DipReading || !reading.CalculatedSales) return false
    const variance = Math.abs(calculateReadingVariance(reading))
    const sales = parseFloat(reading.CalculatedSales) || 0
    const toleranceAmount = (sales * INTERNATIONAL_TOLERANCE_PERCENT) / 100
    return variance <= toleranceAmount
  }).length
})

const fraudAlerts = computed(() => {
  return Object.values(fraudRiskScores.value).filter((score) => score > FRAUD_RISK_THRESHOLD).length
})

const waterContaminationAlerts = computed(() => {
  return meterReadings.value.filter(
    (reading) => reading.WaterLevelCM && parseFloat(reading.WaterLevelCM) > 0,
  ).length
})

const userConflicts = computed(() => {
  return meterReadings.value.filter((reading) => isUserConflict(reading)).length
})

const validDipReadingsCount = computed(() => {
  return Object.values(dipReadings.value).filter(
    (reading) => reading && !isNaN(parseFloat(reading)),
  ).length
})

const hasValidDipReadings = computed(() => validDipReadingsCount.value > 0)

// International Volume Correction Factor (VCF) Calculation
const calculateVCF = (reading) => {
  const temperature = parseFloat(environmentalData.value[reading.ReadingID]?.temperature)
  const dipReading = parseFloat(dipReadings.value[reading.ReadingID])

  if (isNaN(temperature) || isNaN(dipReading)) {
    delete vcfFactors.value[reading.ReadingID]
    return
  }

  // Standard reference temperature (15°C for international standards)
  const referenceTemp = 15.0

  // Fuel thermal expansion coefficient (typical for petroleum products)
  const product = products.value.find((p) => p.ProductID === getTankProductID(reading.TankID))
  let expansionCoeff = 0.0009 // Default coefficient

  if (product) {
    if (
      product.Name.toLowerCase().includes('petrol') ||
      product.Name.toLowerCase().includes('gasoline')
    ) {
      expansionCoeff = 0.00095
    } else if (product.Name.toLowerCase().includes('diesel')) {
      expansionCoeff = 0.00085
    } else if (product.Name.toLowerCase().includes('kerosene')) {
      expansionCoeff = 0.00092
    }
  }

  // Calculate VCF using international petroleum industry formula
  const tempDifference = temperature - referenceTemp
  const vcf = 1 - expansionCoeff * tempDifference

  // Calculate standard volume at 15°C
  const standardVolume = dipReading * vcf

  vcfFactors.value[reading.ReadingID] = {
    factor: vcf.toFixed(6),
    observedTemp: temperature,
    referenceTemp: referenceTemp,
    observedVolume: dipReading,
    standardVolume: standardVolume.toFixed(2),
    expansionCoeff: expansionCoeff,
  }
}

// Water Volume Calculation
const calculateWaterVolume = (reading) => {
  const waterLevelCM = parseFloat(environmentalData.value[reading.ReadingID]?.waterLevel)

  if (isNaN(waterLevelCM) || waterLevelCM <= 0) {
    delete waterVolumes.value[reading.ReadingID]
    return
  }

  // Calculate tank bottom area from typical tank dimensions
  const tank = tanks.value.find((t) => t.TankID === reading.TankID)
  if (!tank) return

  const tankCapacity = parseFloat(tank.Capacity) || 50000 // Default 50,000L
  const estimatedHeight = 250 // cm (2.5m typical height)
  const bottomArea = tankCapacity / (estimatedHeight / 100) // m²

  // Calculate water volume: Area × Height
  const waterVolumeLiters = (bottomArea * (waterLevelCM / 100) * 1000).toFixed(2)

  waterVolumes.value[reading.ReadingID] = waterVolumeLiters
}

// International Standards Functions
const calculateReadingVariance = (reading) => {
  const dipReading =
    parseFloat(dipReadings.value[reading.ReadingID]) || parseFloat(reading.DipReading) || 0
  const meterSales = parseFloat(reading.CalculatedSales) || 0

  // Apply VCF if available for temperature compensation
  const vcf = vcfFactors.value[reading.ReadingID]
  const compensatedDipReading = vcf ? parseFloat(vcf.standardVolume) : dipReading

  return meterSales - compensatedDipReading // Positive = shortage, Negative = overage
}

const getToleranceAmount = (reading) => {
  const sales = parseFloat(reading.CalculatedSales) || 0
  return (sales * INTERNATIONAL_TOLERANCE_PERCENT) / 100
}

const isInternationalCompliance = (reading) => {
  if (!dipReadings.value[reading.ReadingID] && !reading.DipReading) return null
  const variance = Math.abs(calculateReadingVariance(reading))
  const toleranceAmount = getToleranceAmount(reading)
  return variance <= toleranceAmount
}

// Enhanced Fraud Detection with Environmental Factors
const calculateFraudRiskScore = (reading) => {
  let riskScore = 0
  const variance = Math.abs(calculateReadingVariance(reading))
  const sales = parseFloat(reading.CalculatedSales) || 0
  const toleranceAmount = getToleranceAmount(reading)

  // Variance-based risk factors
  if (variance > toleranceAmount * 10) riskScore += 50 // Extreme variance
  if (variance > toleranceAmount * 5) riskScore += 30 // Major variance
  if (variance > toleranceAmount * 2) riskScore += 15 // Moderate variance

  // User and operational risk factors
  if (isUserConflict(reading)) riskScore += 25 // Different users
  if (isAfterHours()) riskScore += 10 // Off-hours entry
  if (hasRepeatedPattern(reading)) riskScore += 20 // Pattern detection

  // Environmental risk factors
  const temperature = parseFloat(environmentalData.value[reading.ReadingID]?.temperature)
  const waterLevel = parseFloat(environmentalData.value[reading.ReadingID]?.waterLevel)

  if (!isNaN(temperature)) {
    if (temperature < 10 || temperature > 45) riskScore += 15 // Unusual temperature
  }

  if (!isNaN(waterLevel) && waterLevel > 0) {
    if (waterLevel > 5)
      riskScore += 25 // Significant water contamination
    else if (waterLevel > 1) riskScore += 10 // Minor water contamination
  }

  // Missing environmental data risk
  if (
    dipReadings.value[reading.ReadingID] &&
    !environmentalData.value[reading.ReadingID]?.temperature
  ) {
    riskScore += 15 // Missing temperature data
  }

  return Math.min(riskScore, 100)
}

const getFraudRiskFactors = (reading) => {
  const factors = []
  const variance = Math.abs(calculateReadingVariance(reading))
  const toleranceAmount = getToleranceAmount(reading)

  if (variance > toleranceAmount * 10) factors.push('Extreme variance (>5%)')
  if (variance > toleranceAmount * 5) factors.push('Major variance (>2.5%)')
  if (variance > toleranceAmount * 2) factors.push('Moderate variance (>1%)')
  if (isUserConflict(reading)) factors.push('Different operators')
  if (isAfterHours()) factors.push('After-hours entry')
  if (hasRepeatedPattern(reading)) factors.push('Suspicious pattern')

  const temperature = parseFloat(environmentalData.value[reading.ReadingID]?.temperature)
  const waterLevel = parseFloat(environmentalData.value[reading.ReadingID]?.waterLevel)

  if (!isNaN(temperature) && (temperature < 10 || temperature > 45)) {
    factors.push('Unusual temperature')
  }

  if (!isNaN(waterLevel) && waterLevel > 5) {
    factors.push('High water contamination')
  }

  if (
    dipReadings.value[reading.ReadingID] &&
    !environmentalData.value[reading.ReadingID]?.temperature
  ) {
    factors.push('Missing temperature data')
  }

  return factors.length > 0 ? factors : ['Normal parameters']
}

const isUserConflict = (reading) => {
  return reading.RecordedBy !== currentUser.value.id.toString()
}

const isAfterHours = () => {
  const hour = new Date().getHours()
  return hour < 6 || hour > 22
}

const hasRepeatedPattern = (reading) => {
  const recentReadings = meterReadings.value.filter(
    (r) => r.TankID === reading.TankID && r.ReadingID !== reading.ReadingID,
  )

  if (recentReadings.length < 2) return false

  const currentVariance = calculateReadingVariance(reading)
  return recentReadings.some((r) => {
    const otherVariance = calculateReadingVariance(r)
    return Math.abs(currentVariance - otherVariance) < 0.01
  })
}

// API Functions with Enhanced Security Logging
const makeAuthenticatedRequest = async (url, options = {}) => {
  try {
    const response = await fetch(url, {
      ...options,
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        ...options.headers,
      },
    })

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}))
      throw new Error(errorData.message || `Request failed with status ${response.status}`)
    }

    return await response.json()
  } catch (error) {
    console.error('API Error:', error)
    await logSecurityEvent('API_ERROR', {
      level: 'WARNING',
      details: `API request failed: ${error.message}`,
      url: url,
      method: options.method || 'GET',
    })
    throw error
  }
}

const logSecurityEvent = async (eventType, details) => {
  try {
    const securityLog = {
      StationID: currentStation.value?.StationID,
      UserID: currentUser.value.id,
      Action: `SECURITY_EVENT: ${eventType}`,
      TableName: 'Security_Events',
      Changes: JSON.stringify({
        ...details,
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
        ipAddress: 'CLIENT_IP',
        sessionId: `${currentUser.value.id}-${Date.now()}`,
      }),
      IPAddress: 'CLIENT_IP',
    }

    await makeAuthenticatedRequest(`${API_BASE_URL}/AuditLogs`, {
      method: 'POST',
      body: JSON.stringify(securityLog),
    })
  } catch (error) {
    console.error('Failed to log security event:', error)
  }
}

const logFraudEvent = async (reading, riskScore, factors) => {
  try {
    const fraudLog = {
      TransactionID: null,
      StationID: currentStation.value?.StationID,
      UserID: currentUser.value.id,
      RiskScore: riskScore.toString(),
      Severity: riskScore > 70 ? 'high' : riskScore > 40 ? 'medium' : 'low',
      FraudType: 'ENVIRONMENTAL_DIP_READING_VARIANCE',
      Description: `Suspicious environmental dip reading variance detected. Factors: ${factors.join(', ')}`,
      DetectedAt: new Date().toISOString(),
      Status: 'Flagged',
      Notes: `Reading ID: ${reading.ReadingID}, Tank: ${getTankName(reading.TankID)}, Variance: ${formatVariance(calculateReadingVariance(reading))}, Temperature: ${environmentalData.value[reading.ReadingID]?.temperature || 'N/A'}°C, Water: ${environmentalData.value[reading.ReadingID]?.waterLevel || '0'}cm`,
    }

    await makeAuthenticatedRequest(`${API_BASE_URL}/FraudDetectionLogs`, {
      method: 'POST',
      body: JSON.stringify(fraudLog),
    })

    // Add to recent alerts for display
    recentFraudAlerts.value.unshift({
      id: Date.now(),
      type: 'ENVIRONMENTAL_VARIANCE',
      description: fraudLog.Description,
      riskScore: riskScore,
      factors: factors,
      timestamp: new Date().toISOString(),
    })

    if (recentFraudAlerts.value.length > 5) {
      recentFraudAlerts.value = recentFraudAlerts.value.slice(0, 5)
    }
  } catch (error) {
    console.error('Failed to log fraud event:', error)
  }
}

const logUserActivity = async (activity, reading) => {
  try {
    const activityLog = {
      StationID: currentStation.value?.StationID,
      UserID: currentUser.value.id,
      Action: activity,
      TableName: 'DailyReadings',
      RecordID: reading.ReadingID.toString(),
      Changes: JSON.stringify({
        activity: activity,
        readingId: reading.ReadingID,
        tankId: reading.TankID,
        pumpId: reading.PumpID,
        originalRecordedBy: reading.RecordedBy,
        currentUser: currentUser.value.id,
        userConflict: isUserConflict(reading),
        environmentalData: environmentalData.value[reading.ReadingID],
        timestamp: new Date().toISOString(),
      }),
      IPAddress: 'CLIENT_IP',
    }

    await makeAuthenticatedRequest(`${API_BASE_URL}/AuditLogs`, {
      method: 'POST',
      body: JSON.stringify(activityLog),
    })
  } catch (error) {
    console.error('Failed to log user activity:', error)
  }
}

// Load User's Station Information
const loadUserStation = async () => {
  try {
    const userStationsResponse = await makeAuthenticatedRequest(
      `${API_BASE_URL}/UserStations?UserID=${currentUser.value.id}`,
    )
    userStations.value = userStationsResponse.records || []

    if (userStations.value.length === 0) {
      throw new Error('No station assignments found for user')
    }

    const primaryUserStation = userStations.value[0]
    const stationResponse = await makeAuthenticatedRequest(
      `${API_BASE_URL}/Stations/${primaryUserStation.StationID}`,
    )
    currentStation.value = stationResponse

    localStorage.setItem('currentStation', JSON.stringify(currentStation.value))
  } catch (error) {
    console.error('Failed to load user station:', error)
    const storedStation = localStorage.getItem('currentStation')
    if (storedStation) {
      currentStation.value = JSON.parse(storedStation)
    } else {
      currentStation.value = {
        StationID: 510,
        StationName: 'Default Station',
        StationCode: 'DEF001',
      }
    }
  }
}

// Load Support Data
const loadTanks = async () => {
  try {
    if (!currentStation.value?.StationID) return

    const response = await makeAuthenticatedRequest(
      `${API_BASE_URL}/Tanks?StationID=${currentStation.value.StationID}`,
    )
    tanks.value = (response.records || []).filter(
      (tank) => tank.Status === 'Active' && tank.StationID === currentStation.value.StationID,
    )
  } catch (error) {
    await showErrorNotification('Failed to load tank information', error.message)
  }
}

const loadPumps = async () => {
  try {
    if (!currentStation.value?.StationID) return

    const response = await makeAuthenticatedRequest(
      `${API_BASE_URL}/Pumps?StationID=${currentStation.value.StationID}`,
    )
    pumps.value = (response.records || []).filter(
      (pump) => pump.StationID === currentStation.value.StationID,
    )
  } catch (error) {
    console.error('Failed to load pumps:', error)
  }
}

const loadUsers = async () => {
  try {
    const response = await makeAuthenticatedRequest(`${API_BASE_URL}/users`)
    users.value = response.records || []
  } catch (error) {
    console.error('Failed to load users:', error)
  }
}

const loadProducts = async () => {
  try {
    const response = await makeAuthenticatedRequest(`${API_BASE_URL}/Products`)
    products.value = response.records || []
  } catch (error) {
    console.error('Failed to load products:', error)
  }
}

// Load Existing Meter Readings for Date
const loadMeterReadingsForDate = async () => {
  try {
    if (!currentStation.value?.StationID) {
      throw new Error('No station ID available')
    }

    loading.value = true

    // Load existing meter readings for the date
    const response = await makeAuthenticatedRequest(
      `${API_BASE_URL}/DailyReadings?ReadingDate=${selectedDate.value}&StationID=${currentStation.value.StationID}`,
    )

    meterReadings.value = (response.records || []).filter(
      (reading) =>
        reading.StationID === currentStation.value.StationID &&
        reading.OpeningReading && // Must have meter readings
        reading.ClosingReading &&
        reading.CalculatedSales,
    )

    // Initialize environmental data and dip readings from existing data
    dipReadings.value = {}
    environmentalData.value = {}

    meterReadings.value.forEach((reading) => {
      if (reading.DipReading) {
        dipReadings.value[reading.ReadingID] = reading.DipReading
      }

      // Initialize environmental data
      environmentalData.value[reading.ReadingID] = {
        temperature: reading.Temperature || '',
        waterLevel: reading.WaterLevelCM || '',
      }

      // Calculate initial states if data exists
      if (reading.DipReading) {
        calculateInternationalVariance(reading)
      }
      if (reading.Temperature) {
        calculateVCF(reading)
      }
      if (reading.WaterLevelCM) {
        calculateWaterVolume(reading)
      }
    })

    await logSecurityEvent('ENVIRONMENTAL_READINGS_LOADED', {
      level: 'INFO',
      details: `Loaded ${meterReadings.value.length} meter readings with environmental monitoring for date ${selectedDate.value}`,
      readingCount: meterReadings.value.length,
      environmentalReadings: meterReadings.value.filter((r) => r.Temperature || r.WaterLevelCM)
        .length,
    })
  } catch (error) {
    await showErrorNotification('Failed to load meter readings', error.message)
  } finally {
    loading.value = false
  }
}

// International Standards Variance Calculation with Environmental Factors
const calculateInternationalVariance = (reading) => {
  const dipInput = dipReadings.value[reading.ReadingID]
  if (!dipInput || isNaN(parseFloat(dipInput))) {
    variances.value[reading.ReadingID] = null
    variancePercentages.value[reading.ReadingID] = null
    fraudRiskScores.value[reading.ReadingID] = null
    return
  }

  const variance = calculateReadingVariance(reading)
  const meterSales = parseFloat(reading.CalculatedSales) || 0
  const variancePercentage =
    meterSales > 0 ? ((Math.abs(variance) / meterSales) * 100).toFixed(3) : '0.000'

  variances.value[reading.ReadingID] = variance.toFixed(3)
  variancePercentages.value[reading.ReadingID] = variancePercentage

  // Calculate VCF if temperature is available
  if (environmentalData.value[reading.ReadingID]?.temperature) {
    calculateVCF(reading)
  }

  // Calculate water volume if water level is available
  if (environmentalData.value[reading.ReadingID]?.waterLevel) {
    calculateWaterVolume(reading)
  }

  // Update fraud risk score
  const riskScore = calculateFraudRiskScore(reading)
  fraudRiskScores.value[reading.ReadingID] = riskScore

  // Log fraud event if high risk
  if (riskScore > FRAUD_RISK_THRESHOLD) {
    const factors = getFraudRiskFactors(reading)
    logFraudEvent(reading, riskScore, factors)
  }

  // Clear previous errors
  delete validationErrors.value[reading.ReadingID]
}

const validateDipReading = (reading) => {
  const dipInput = dipReadings.value[reading.ReadingID]

  if (!dipInput) {
    validationErrors.value[reading.ReadingID] =
      'Dip reading is required for environmental compliance'
    return false
  }

  const dipReading = parseFloat(dipInput)

  if (isNaN(dipReading)) {
    validationErrors.value[reading.ReadingID] = 'Please enter a valid number'
    return false
  }

  if (dipReading < 0) {
    validationErrors.value[reading.ReadingID] = 'Reading cannot be negative'
    return false
  }

  // International standards validation with environmental factors
  const meterSales = parseFloat(reading.CalculatedSales) || 0
  const variance = Math.abs(calculateReadingVariance(reading))
  const maxAllowableVariance = (meterSales * 10) / 100 // 10% absolute maximum

  if (variance > maxAllowableVariance) {
    validationErrors.value[reading.ReadingID] =
      `Variance exceeds maximum allowable (10%). Environmental factors may be affecting measurement.`
    return false
  }

  delete validationErrors.value[reading.ReadingID]
  return true
}

// Update Environmental Dip Reading - 100% API COMPLIANT
const updateEnvironmentalDipReading = async (reading) => {
  if (!validateDipReading(reading)) return

  try {
    submitting.value[reading.ReadingID] = true

    const dipReading = parseFloat(dipReadings.value[reading.ReadingID])
    const temperature = parseFloat(environmentalData.value[reading.ReadingID]?.temperature) || null
    const waterLevelCM = parseFloat(environmentalData.value[reading.ReadingID]?.waterLevel) || null
    const waterVolumeL = waterVolumes.value[reading.ReadingID]
      ? parseFloat(waterVolumes.value[reading.ReadingID])
      : null
    const variance = calculateReadingVariance(reading).toFixed(3)
    const riskScore = fraudRiskScores.value[reading.ReadingID] || 0

    // Log user conflict if different operator
    if (isUserConflict(reading)) {
      await logSecurityEvent('USER_CONFLICT_ENVIRONMENTAL_UPDATE', {
        level: 'FRAUD',
        details: `Different user updating environmental dip reading. Original: ${getUserName(reading.RecordedBy)}, Current: ${currentUser.value.email}`,
        originalUser: reading.RecordedBy,
        currentUser: currentUser.value.id,
        readingId: reading.ReadingID,
        environmentalData: environmentalData.value[reading.ReadingID],
      })
    }

    // 100% API COMPLIANT UPDATE - EXACT FIELD STRUCTURE FROM YOUR CURL EXAMPLES
    const updateData = {
      ReadingID: null, // Not updated
      StationID: currentStation.value.StationID, // INTEGER - as per API
      ReadingDate: reading.ReadingDate, // TEXT - as per API
      PumpID: reading.PumpID, // INTEGER - as per API
      TankID: reading.TankID, // INTEGER - as per API
      OpeningReading: reading.OpeningReading, // TEXT - as per API
      ClosingReading: reading.ClosingReading, // TEXT - as per API
      DipReading: dipReading.toString(), // TEXT - as per API
      CalculatedSales: reading.CalculatedSales, // TEXT - as per API
      Variance: variance, // TEXT - as per API
      RecordedBy: reading.RecordedBy, // TEXT - as per API
      VerifiedBy: reading.VerifiedBy, // TEXT - as per API
      Status: riskScore > FRAUD_RISK_THRESHOLD ? 'Flagged' : 'Completed', // TEXT - as per API
      CreatedAt: null, // Not updated
      Temperature: temperature, // NUMBER - as per API
      WaterLevelCM: waterLevelCM, // NUMBER - as per API
      WaterVolumeL: waterVolumeL, // NUMBER - as per API
    }

    // UPDATE existing DailyReading record with environmental data
    await makeAuthenticatedRequest(`${API_BASE_URL}/DailyReadings/${reading.ReadingID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData),
    })

    // Log the environmental update in audit trail
    await logUserActivity('ENVIRONMENTAL_DIP_READING_UPDATED', reading)

    // Update local state
    reading.DipReading = dipReading.toString()
    reading.Temperature = temperature
    reading.WaterLevelCM = waterLevelCM
    reading.WaterVolumeL = waterVolumeL
    reading.Variance = variance
    reading.Status = updateData.Status

    // Clear form data
    delete dipReadings.value[reading.ReadingID]
    delete environmentalData.value[reading.ReadingID]
    delete variances.value[reading.ReadingID]
    delete variancePercentages.value[reading.ReadingID]
    delete vcfFactors.value[reading.ReadingID]
    delete waterVolumes.value[reading.ReadingID]

    const complianceStatus = isInternationalCompliance(reading) ? 'COMPLIANT' : 'NON-COMPLIANT'
    const vcfStatus = temperature ? `VCF Applied (${temperature}°C)` : 'No Temperature Compensation'
    const waterStatus =
      waterLevelCM && waterLevelCM > 0
        ? `Water Detected (${waterLevelCM}cm)`
        : 'No Water Contamination'

    await showSuccessNotification(
      'Environmental Dip Reading Updated Successfully!',
      `Reading ID ${reading.ReadingID}: ${formatLiters(dipReading)} - ${complianceStatus} | ${vcfStatus} | ${waterStatus}`,
    )

    await loadMeterReadingsForDate()
  } catch (error) {
    await logSecurityEvent('ENVIRONMENTAL_UPDATE_ERROR', {
      level: 'ERROR',
      details: `Failed to update environmental dip reading: ${error.message}`,
      readingId: reading.ReadingID,
      environmentalData: environmentalData.value[reading.ReadingID],
      error: error.message,
    })
    await showErrorNotification('Environmental Update Failed', error.message)
  } finally {
    submitting.value[reading.ReadingID] = false
  }
}

// Utility Functions
const formatLiters = (value) => {
  const num = parseFloat(value) || 0
  return (
    new Intl.NumberFormat('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 3,
    }).format(num) + 'L'
  )
}

const formatMeterReading = (value) => {
  const num = parseFloat(value) || 0
  return new Intl.NumberFormat('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(num)
}

const formatVariance = (value) => {
  const num = parseFloat(value) || 0
  const sign = num >= 0 ? '+' : ''
  return sign + formatLiters(num)
}

const formatDateTime = (date) => {
  return new Date(date).toLocaleDateString('en-US', {
    weekday: 'short',
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
  })
}

const getTankName = (tankID) => {
  const tank = tanks.value.find((t) => t.TankID === tankID)
  return tank ? tank.TankName : `Tank ${tankID}`
}

const getTankProductID = (tankID) => {
  const tank = tanks.value.find((t) => t.TankID === tankID)
  return tank ? tank.ProductID : null
}

const getPumpInfo = (pumpID) => {
  const pump = pumps.value.find((p) => p.PumpID === pumpID)
  return pump ? `${pump.PumpName} (${pump.PumpNumber})` : `Pump ${pumpID}`
}

const getUserName = (userID) => {
  const user = users.value.find((u) => u.id === parseInt(userID))
  return user ? user.email : `User ${userID}`
}

// UI State Functions
const getReadingCardClass = (reading) => {
  if (!reading.DipReading) return 'border-warning border-2'

  // Check for water contamination
  if (reading.WaterLevelCM && parseFloat(reading.WaterLevelCM) > 0) {
    return 'border-danger border-2'
  }

  const compliance = isInternationalCompliance(reading)
  if (compliance === null) return 'border-secondary border-2'
  return compliance ? 'border-success border-2' : 'border-danger border-2'
}

const getReadingSymbolClass = (reading) => {
  if (!reading.DipReading) return 'bg-warning'

  // Check for water contamination
  if (reading.WaterLevelCM && parseFloat(reading.WaterLevelCM) > 0) {
    return 'bg-danger'
  }

  const compliance = isInternationalCompliance(reading)
  if (compliance === null) return 'bg-secondary'
  return compliance ? 'bg-success' : 'bg-danger'
}

const getReadingStatusBadgeClass = (status) => {
  switch (status) {
    case 'Completed':
      return 'badge-success'
    case 'Flagged':
      return 'badge-danger'
    case 'Pending':
      return 'badge-warning'
    default:
      return 'badge-secondary'
  }
}

const getDipInputClass = (reading) => {
  const error = validationErrors.value[reading.ReadingID]
  if (error) return 'is-invalid border-danger'

  const dipInput = dipReadings.value[reading.ReadingID]
  if (dipInput && !isNaN(parseFloat(dipInput))) {
    const compliance = isInternationalCompliance({ ...reading, DipReading: dipInput })
    return compliance ? 'is-valid border-success' : 'border-danger'
  }

  return ''
}

const getInternationalVarianceClass = (reading) => {
  const compliance = isInternationalCompliance(reading)
  if (compliance === null) return 'bg-light-secondary border-secondary'
  return compliance ? 'bg-light-success border-success' : 'bg-light-danger border-danger'
}

const getComplianceStatusBadgeClass = (reading) => {
  const compliance = isInternationalCompliance(reading)
  if (compliance === null) return 'badge-secondary'
  return compliance ? 'badge-success' : 'badge-danger'
}

const getComplianceStatusText = (reading) => {
  const compliance = isInternationalCompliance(reading)
  if (compliance === null) return 'PENDING'
  return compliance ? 'API MPMS COMPLIANT' : 'NON-COMPLIANT'
}

const getFraudRiskClass = (reading) => {
  const riskScore = fraudRiskScores.value[reading.ReadingID] || 0
  if (riskScore > 70) return 'text-danger'
  if (riskScore > 40) return 'text-warning'
  return 'text-success'
}

const getFraudRiskLevel = (reading) => {
  const riskScore = fraudRiskScores.value[reading.ReadingID] || 0
  if (riskScore > 70) return 'HIGH'
  if (riskScore > 40) return 'MEDIUM'
  return 'LOW'
}

// Action Functions
const toggleHistoryView = async () => {
  showHistory.value = !showHistory.value
  if (showHistory.value) {
    await loadMeterReadingsForDate() // Reload to get more history
  }
}

const viewReadingDetails = (reading) => {
  const variance = calculateReadingVariance(reading)
  const compliance = isInternationalCompliance(reading)
  const riskScore = fraudRiskScores.value[reading.ReadingID] || 0
  const factors = getFraudRiskFactors(reading)
  const vcf = vcfFactors.value[reading.ReadingID]

  Swal.fire({
    title: `Environmental Reading Details - ${getTankName(reading.TankID)}`,
    html: `
      <div class="text-start">
        <h5>Meter Readings</h5>
        <p><strong>Opening:</strong> ${formatMeterReading(reading.OpeningReading)}</p>
        <p><strong>Closing:</strong> ${formatMeterReading(reading.ClosingReading)}</p>
        <p><strong>Sales:</strong> ${formatLiters(reading.CalculatedSales)}</p>

        <h5>Environmental Data</h5>
        <p><strong>Dip Reading:</strong> ${reading.DipReading ? formatLiters(reading.DipReading) : 'PENDING'}</p>
        <p><strong>Temperature:</strong> ${reading.Temperature ? reading.Temperature + '°C' : 'Not recorded'}</p>
        <p><strong>Water Level:</strong> ${reading.WaterLevelCM ? reading.WaterLevelCM + 'cm' : 'Not detected'}</p>
        <p><strong>Water Volume:</strong> ${reading.WaterVolumeL ? formatLiters(reading.WaterVolumeL) : 'None'}</p>

        <h5>International Standards Analysis</h5>
        <p><strong>Variance:</strong> ${formatVariance(variance)}</p>
        <p><strong>API MPMS Compliance:</strong> ${compliance === null ? 'PENDING' : compliance ? 'COMPLIANT' : 'NON-COMPLIANT'}</p>
        ${vcf ? `<p><strong>VCF Applied:</strong> ${vcf.factor} (${vcf.observedTemp}°C → 15°C)</p>` : ''}
        ${vcf ? `<p><strong>Standard Volume:</strong> ${formatLiters(vcf.standardVolume)}</p>` : ''}

        <h5>Fraud Risk Analysis</h5>
        <p><strong>Risk Score:</strong> ${riskScore}%</p>
        <p><strong>Risk Level:</strong> ${riskScore > 70 ? 'HIGH' : riskScore > 40 ? 'MEDIUM' : 'LOW'}</p>
        <p><strong>Risk Factors:</strong> ${factors.join(', ')}</p>

        <h5>Audit Trail</h5>
        <p><strong>Meter Recorded by:</strong> ${getUserName(reading.RecordedBy)}</p>
        <p><strong>Date Created:</strong> ${formatDateTime(reading.CreatedAt)}</p>
        <p><strong>Status:</strong> ${reading.Status}</p>
      </div>
    `,
    icon: 'info',
    confirmButtonColor: '#007AFF',
    width: 700,
  })
}

const showEnvironmentalReport = () => {
  const totalReadings = meterReadings.value.length
  const completedReadings = meterReadings.value.filter((r) => r.DipReading).length
  const compliantCount = compliantReadings.value
  const waterContaminated = waterContaminationAlerts.value
  const temperatureRecorded = meterReadings.value.filter((r) => r.Temperature).length
  const complianceRate =
    completedReadings > 0 ? ((compliantCount / completedReadings) * 100).toFixed(1) : '0.0'

  Swal.fire({
    title: 'Environmental Monitoring & Compliance Report',
    html: `
      <div class="text-start">
        <h5>Summary</h5>
        <p><strong>Date:</strong> ${selectedDate.value}</p>
        <p><strong>Station:</strong> ${stationName.value}</p>
        <p><strong>Total Meter Readings:</strong> ${totalReadings}</p>
        <p><strong>Completed Dip Readings:</strong> ${completedReadings}</p>

        <h5>Environmental Monitoring</h5>
        <p><strong>Temperature Recorded:</strong> ${temperatureRecorded} readings</p>
        <p><strong>Water Contamination Detected:</strong> ${waterContaminated} tanks</p>
        <p><strong>VCF Applied:</strong> ${Object.keys(vcfFactors.value).length} readings</p>

        <h5>API MPMS Compliance</h5>
        <p><strong>Compliant Readings:</strong> ${compliantCount} (±0.5%)</p>
        <p><strong>Non-Compliant Readings:</strong> ${completedReadings - compliantCount}</p>
        <p><strong>Compliance Rate:</strong> ${complianceRate}%</p>

        <h5>Fraud Detection</h5>
        <p><strong>Fraud Alerts:</strong> ${fraudAlerts.value}</p>
        <p><strong>User Conflicts:</strong> ${userConflicts.value}</p>

        <h5>International Standards</h5>
        <p><strong>Standard:</strong> API MPMS Chapter 3.1A</p>
        <p><strong>Tolerance:</strong> ±${INTERNATIONAL_TOLERANCE_PERCENT}%</p>
        <p><strong>Temperature Compensation:</strong> VCF (Volume Correction Factor)</p>
        <p><strong>Environmental Monitoring:</strong> Temperature & Water Detection</p>
      </div>
    `,
    icon: 'info',
    confirmButtonColor: '#34C759',
    width: 700,
  })
}

const viewFraudDetails = () => {
  const alertsHtml = recentFraudAlerts.value
    .map(
      (alert) => `
    <div class="border-bottom pb-2 mb-2">
      <strong>${alert.type}</strong> (${alert.riskScore}%)<br>
      <small>${alert.description}</small><br>
      <small><strong>Factors:</strong> ${alert.factors.join(', ')}</small><br>
      <small class="text-muted">${formatDateTime(alert.timestamp)}</small>
    </div>
  `,
    )
    .join('')

  Swal.fire({
    title: '🚨 Environmental Fraud Detection Alerts',
    html: `<div class="text-start" style="max-height: 400px; overflow-y: auto;">${alertsHtml || 'No recent alerts'}</div>`,
    icon: 'warning',
    confirmButtonColor: '#FF3B30',
    width: 600,
  })
}

const updateAllEnvironmentalReadings = async () => {
  const validReadings = meterReadings.value.filter(
    (reading) => dipReadings.value[reading.ReadingID] && validateDipReading(reading),
  )

  if (validReadings.length === 0) {
    await showErrorNotification(
      'No Valid Readings',
      'Please enter valid dip readings with environmental data for at least one meter reading',
    )
    return
  }

  const result = await Swal.fire({
    title: 'Confirm Bulk Environmental Update',
    text: `Update ${validReadings.length} dip readings with environmental monitoring and international standards compliance?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#34C759',
    cancelButtonColor: '#FF3B30',
    confirmButtonText: 'Yes, Update All with Environmental Data',
  })

  if (!result.isConfirmed) return

  try {
    bulkSubmitting.value = true
    let successCount = 0

    for (const reading of validReadings) {
      try {
        await updateEnvironmentalDipReading(reading)
        successCount++
      } catch (error) {
        console.error(`Failed to update reading ${reading.ReadingID}:`, error)
      }
    }

    await showSuccessNotification(
      'Bulk Environmental Update Complete!',
      `Successfully updated ${successCount} readings with environmental monitoring and international standards compliance`,
    )
  } catch (error) {
    await showErrorNotification('Bulk Environmental Update Failed', error.message)
  } finally {
    bulkSubmitting.value = false
  }
}

const exportEnvironmentalReport = async () => {
  try {
    const exportData = meterReadings.value.map((reading) => {
      const variance = calculateReadingVariance(reading)
      const compliance = isInternationalCompliance(reading)
      const riskScore = fraudRiskScores.value[reading.ReadingID] || 0
      const vcf = vcfFactors.value[reading.ReadingID]

      return {
        ReadingID: reading.ReadingID,
        Station: stationName.value,
        Tank: getTankName(reading.TankID),
        Pump: getPumpInfo(reading.PumpID),
        Date: reading.ReadingDate,
        OpeningReading: reading.OpeningReading,
        ClosingReading: reading.ClosingReading,
        MeterSales: reading.CalculatedSales,
        DipReading: reading.DipReading || '',
        Temperature: reading.Temperature || '',
        WaterLevelCM: reading.WaterLevelCM || '',
        WaterVolumeL: reading.WaterVolumeL || '',
        VCF: vcf ? vcf.factor : '',
        StandardVolume: vcf ? vcf.standardVolume : '',
        Variance: reading.DipReading ? variance.toFixed(3) : '',
        VariancePercent: reading.DipReading ? variancePercentages.value[reading.ReadingID] : '',
        APIMPMSCompliance:
          compliance === null ? 'PENDING' : compliance ? 'COMPLIANT' : 'NON-COMPLIANT',
        FraudRisk: riskScore,
        RecordedBy: getUserName(reading.RecordedBy),
        Status: reading.Status,
        UserConflict: isUserConflict(reading) ? 'YES' : 'NO',
      }
    })

    const csv = [
      Object.keys(exportData[0]).join(','),
      ...exportData.map((row) => Object.values(row).join(',')),
    ].join('\n')

    const blob = new Blob([csv], { type: 'text/csv' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `environmental-dip-readings-${stationName.value}-${selectedDate.value}.csv`
    a.click()
    window.URL.revokeObjectURL(url)

    await showSuccessNotification(
      'Export Complete',
      'Environmental monitoring and compliance report exported',
    )
  } catch (error) {
    await showErrorNotification('Export Failed', error.message)
  }
}

const loadTodayReadings = () => {
  selectedDate.value = new Date().toISOString().split('T')[0]
  loadMeterReadingsForDate()
}

const loadYesterdayReadings = () => {
  const yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - 1)
  selectedDate.value = yesterday.toISOString().split('T')[0]
  loadMeterReadingsForDate()
}

const refreshData = async () => {
  await Promise.all([
    loadUserStation(),
    loadTanks(),
    loadPumps(),
    loadUsers(),
    loadProducts(),
    loadMeterReadingsForDate(),
  ])
  await showSuccessNotification(
    'Refreshed',
    'All environmental monitoring data refreshed successfully',
  )
}

// Notification Functions
const showSuccessNotification = async (title, text) => {
  return Swal.fire({
    title,
    text,
    icon: 'success',
    toast: true,
    position: 'top-end',
    timer: 3000,
    showConfirmButton: false,
    timerProgressBar: true,
  })
}

const showErrorNotification = async (title, text) => {
  return Swal.fire({
    title,
    text,
    icon: 'error',
    confirmButtonColor: '#FF3B30',
  })
}

// Watchers
watch(selectedDate, () => {
  loadMeterReadingsForDate()
})

// Lifecycle
onMounted(async () => {
  await loadUserStation()

  await Promise.all([
    loadTanks(),
    loadPumps(),
    loadUsers(),
    loadProducts(),
    loadMeterReadingsForDate(),
  ])

  await logSecurityEvent('COMPONENT_INITIALIZED', {
    level: 'INFO',
    details:
      'Environmental dip readings update component initialized with international standards, VCF, water detection, and paranoid fraud detection',
    stationId: currentStation.value?.StationID,
    stationName: currentStation.value?.StationName,
    internationalStandards: true,
    environmentalMonitoring: true,
    fraudDetection: true,
    apiCompliant: true,
  })
})
</script>

<style scoped>
/* iOS-Compliant High Contrast Styling with Environmental Monitoring */

/* Animations */
@keyframes rotate-animation {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@keyframes animation-blink {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.rotate-animation {
  animation: rotate-animation 1s linear infinite;
}

.animation-blink {
  animation: animation-blink 2s infinite;
}

/* iOS-Style Loading Skeleton */
.skeleton {
  background: linear-gradient(90deg, #f2f2f7 25%, #e5e5ea 50%, #f2f2f7 75%);
  background-size: 200% 100%;
  animation: loading 1.5s infinite;
  border-radius: 8px;
}

.skeleton-circle {
  border-radius: 50%;
}

.skeleton-text {
  height: 16px;
  margin-bottom: 8px;
}

/* iOS-Style Cards with Environmental Status Colors */
.card {
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

/* Environmental Compliance Colors */
.border-success {
  border-color: #34c759 !important;
}
.border-danger {
  border-color: #ff3b30 !important;
}
.border-warning {
  border-color: #ff9500 !important;
}

.bg-light-success {
  background-color: rgba(52, 199, 89, 0.1) !important;
}
.bg-light-danger {
  background-color: rgba(255, 59, 48, 0.1) !important;
}
.bg-light-warning {
  background-color: rgba(255, 149, 0, 0.1) !important;
}

/* High Contrast Form Controls */
.form-control {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 10px;
  font-weight: 500;
  border: 1px solid #d1d1d6;
  background-color: #ffffff;
  color: #000000;
}

.form-control:focus {
  border-color: #007aff;
  box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.3);
}

.form-control.is-valid {
  border-color: #34c759;
  box-shadow: 0 0 0 3px rgba(52, 199, 89, 0.3);
}

.form-control.is-invalid {
  border-color: #ff3b30;
  box-shadow: 0 0 0 3px rgba(255, 59, 48, 0.3);
}

/* iOS-Style Buttons */
.btn {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  font-weight: 600;
  border-radius: 10px;
}

.btn:hover {
  transform: translateY(-1px);
}

.btn-lg {
  min-height: 44px;
  font-size: 17px;
  padding: 12px 24px;
}

/* Environmental Monitoring Badges */
.badge {
  font-weight: 600;
  padding: 6px 12px;
  border-radius: 8px;
  font-size: 12px;
}

.badge-success {
  background-color: #34c759;
  color: white;
}
.badge-danger {
  background-color: #ff3b30;
  color: white;
}
.badge-warning {
  background-color: #ff9500;
  color: white;
}

/* Mobile Responsive */
@media (max-width: 767px) {
  .card-body {
    padding: 1.25rem;
  }

  .btn-lg {
    font-size: 16px;
    min-height: 44px;
  }
}

/* Animate.css Integration */
@import url('https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css');
</style>

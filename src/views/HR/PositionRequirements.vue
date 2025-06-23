<template>
  <div class="d-flex flex-column gap-5">
    <!-- Header -->
    <div class="card card-flush bg-gradient-primary">
      <div class="card-body py-8">
        <div class="d-flex align-items-center justify-content-between">
          <div>
            <h1 class="text-white fw-bold fs-2x mb-2">Position Requirements</h1>
            <p class="text-white text-opacity-75 mb-0">
              Manage position requirements and qualifications with AI-powered analytics
            </p>
          </div>
          <button @click="showForm = true" class="btn btn-light btn-lg">
            <i class="ki-duotone ki-plus fs-2 me-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Add Requirement
          </button>
        </div>
      </div>
    </div>

    <!-- Fullscreen Modal for Forms -->
    <div
      v-if="showForm"
      class="modal fade show d-block"
      style="background: rgba(0, 0, 0, 0.5)"
      @click.self="resetForm"
    >
      <div
        class="modal-dialog modal-fullscreen-sm-down modal-lg modal-dialog-centered modal-dialog-scrollable"
      >
        <div class="modal-content">
          <!-- Modal Header -->
          <div class="modal-header bg-gradient-primary">
            <div class="d-flex align-items-center gap-3">
              <button @click="resetForm" class="btn btn-icon btn-light btn-sm">
                <i class="ki-duotone ki-cross fs-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </button>
              <div>
                <h1 class="text-white fw-bold fs-2 mb-0">
                  {{ editingRequirement ? 'Edit Requirement' : 'New Requirement' }}
                </h1>
                <p class="text-white text-opacity-75 mb-0 fs-6">
                  {{
                    editingRequirement
                      ? 'Update position requirement details'
                      : 'Add new position requirement'
                  }}
                </p>
              </div>
            </div>
          </div>

          <!-- Modal Body -->
          <div class="modal-body p-0">
            <div class="container-fluid py-5">
              <div class="row g-5">
                <div class="col-12 col-md-6">
                  <label class="required form-label fw-semibold fs-6">Position</label>
                  <select
                    v-model="formData.PositionID"
                    class="form-control form-control-lg"
                    required
                  >
                    <option value="">Select Position</option>
                    <option
                      v-for="position in positions"
                      :key="position.PositionID"
                      :value="position.PositionID"
                    >
                      {{ position.PositionTitle }}
                    </option>
                  </select>
                </div>

                <div class="col-12 col-md-6">
                  <label class="required form-label fw-semibold fs-6">Requirement Type</label>
                  <select
                    v-model="formData.RequirementType"
                    class="form-control form-control-lg"
                    required
                  >
                    <option value="">Select Type</option>
                    <option v-for="type in requirementTypes" :key="type" :value="type">
                      {{ type }}
                    </option>
                  </select>
                </div>

                <div class="col-12">
                  <label class="required form-label fw-semibold fs-6">Requirement Name</label>
                  <input
                    type="text"
                    v-model="formData.RequirementName"
                    class="form-control form-control-lg"
                    placeholder="e.g., Bachelor's Degree in Engineering"
                    required
                  />
                </div>

                <div class="col-12">
                  <label class="form-label fw-semibold fs-6">Description</label>
                  <textarea
                    v-model="formData.Description"
                    class="form-control form-control-lg"
                    rows="4"
                    placeholder="Detailed description of the requirement..."
                  ></textarea>
                </div>

                <div class="col-12">
                  <div class="form-check form-switch form-check-custom form-check-solid">
                    <input
                      type="checkbox"
                      v-model="isMandatory"
                      class="form-check-input"
                      id="mandatory"
                    />
                    <label class="form-check-label fw-semibold fs-6" for="mandatory">
                      Mandatory Requirement
                    </label>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Modal Footer -->
          <div class="modal-footer bg-light">
            <div class="d-flex gap-3 w-100">
              <button
                @click="handleSubmit"
                :disabled="loading"
                class="btn btn-primary btn-lg flex-grow-1"
              >
                <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
                <i class="ki-duotone ki-check fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                {{ editingRequirement ? 'Update Requirement' : 'Create Requirement' }}
              </button>
              <button @click="resetForm" class="btn btn-light-danger btn-lg">
                <i class="ki-duotone ki-cross fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Key Metrics -->
    <div v-if="!showForm" class="row g-3 mb-5">
      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-primary">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-primary">
                  <i class="ki-duotone ki-document text-white fs-6">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div>
                <div class="text-primary fw-bold fs-4">{{ requirements.length }}</div>
                <div class="text-muted fs-8">Total</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-success">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-success">
                  <i class="ki-duotone ki-check-circle text-white fs-6">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                </div>
              </div>
              <div>
                <div class="text-success fw-bold fs-4">{{ mandatoryCount }}</div>
                <div class="text-muted fs-8">Mandatory</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-warning">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-warning">
                  <i class="ki-duotone ki-information text-white fs-6">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </div>
              </div>
              <div>
                <div class="text-warning fw-bold fs-4">{{ optionalCount }}</div>
                <div class="text-muted fs-8">Optional</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-6 col-md-3">
        <div class="card card-flush bg-light-info">
          <div class="card-body py-4">
            <div class="d-flex align-items-center">
              <div class="symbol symbol-40px me-3">
                <div class="symbol-label bg-info">
                  <i class="ki-duotone ki-category text-white fs-6">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                    <span class="path4"></span>
                  </i>
                </div>
              </div>
              <div>
                <div class="text-info fw-bold fs-4">{{ uniqueTypes }}</div>
                <div class="text-muted fs-8">Types</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Analytics Toggle -->
    <div v-if="!showForm" class="card card-flush mb-5">
      <div class="card-header border-0 pt-6">
        <h3 class="card-title align-items-start flex-column">
          <span class="card-label fw-bold fs-3 mb-1">AI Analytics Dashboard</span>
          <span class="text-muted fs-7">Click to expand detailed charts and insights</span>
        </h3>
        <div class="card-toolbar">
          <button
            @click="showAnalytics = !showAnalytics"
            class="btn btn-sm"
            :class="showAnalytics ? 'btn-light-danger' : 'btn-light-success'"
          >
            <i
              class="ki-duotone fs-3 me-2"
              :class="showAnalytics ? 'ki-minus' : 'ki-chart-line-up'"
            >
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            {{ showAnalytics ? 'Hide Analytics' : 'Show Analytics' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Expandable Analytics Section -->
    <div v-if="!showForm && showAnalytics" class="row g-5 mb-5">
      <!-- AI Analytics Charts -->
      <div class="col-12 col-lg-8">
        <div class="card card-flush h-100">
          <div class="card-header">
            <h3 class="card-title fw-bold">
              <i class="ki-duotone ki-chart-simple text-primary fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              AI Requirements Analysis
            </h3>
          </div>
          <div class="card-body">
            <div class="mixed-widget-10-chart" style="height: 300px; position: relative">
              <canvas ref="typeChart" width="400" height="300"></canvas>
            </div>
            <div class="d-flex flex-wrap gap-2 mt-3">
              <div
                v-for="(item, index) in typeAnalytics"
                :key="item.type"
                class="d-flex align-items-center"
              >
                <div
                  class="bullet bullet-dot me-2"
                  :style="`background-color: ${chartColors[index % chartColors.length]}`"
                ></div>
                <span class="fw-semibold text-gray-600 fs-8"
                  >{{ item.type }}: {{ item.count }}</span
                >
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-12 col-lg-4">
        <div class="card card-flush h-100">
          <div class="card-header">
            <h3 class="card-title fw-bold">
              <i class="ki-duotone ki-graph-up text-success fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
                <span class="path5"></span>
                <span class="path6"></span>
              </i>
              Distribution
            </h3>
          </div>
          <div class="card-body d-flex flex-column justify-content-center">
            <div class="mixed-widget-14-chart" style="height: 180px; position: relative">
              <canvas ref="mandatoryChart" width="200" height="180"></canvas>
            </div>
            <div class="text-center mt-3">
              <div class="d-flex justify-content-between">
                <div class="d-flex align-items-center">
                  <div class="bullet bullet-dot bg-success me-2"></div>
                  <span class="fw-semibold text-gray-600 fs-8">{{ mandatoryPercentage }}%</span>
                </div>
                <div class="d-flex align-items-center">
                  <div class="bullet bullet-dot bg-warning me-2"></div>
                  <span class="fw-semibold text-gray-600 fs-8">{{ optionalPercentage }}%</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Position Requirements Heatmap -->
      <div class="col-12">
        <div class="card card-flush">
          <div class="card-header">
            <h3 class="card-title fw-bold">
              <i class="ki-duotone ki-element-11 text-info fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              AI-Powered Position Requirements Heatmap
            </h3>
            <div class="card-toolbar">
              <button @click="generateAIInsights" class="btn btn-sm btn-light-success">
                <i class="ki-duotone ki-abstract-26 fs-3 me-1">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                AI Insights
              </button>
            </div>
          </div>
          <div class="card-body">
            <div class="mixed-widget-5-chart" style="height: 250px; position: relative">
              <canvas ref="heatmapChart" width="800" height="250"></canvas>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Compact Filters -->
    <div v-if="!showForm" class="card card-flush mb-5">
      <div class="card-header border-0 py-4">
        <h3 class="card-title fs-5 fw-bold">
          <i class="ki-duotone ki-filter text-primary fs-3 me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Filters
        </h3>
        <div class="card-toolbar">
          <button @click="showFilters = !showFilters" class="btn btn-sm btn-light-primary">
            <i class="ki-duotone fs-3" :class="showFilters ? 'ki-minus' : 'ki-plus'">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </button>
        </div>
      </div>
      <div v-if="showFilters" class="card-body pt-0">
        <div class="row g-3">
          <div class="col-6 col-md-3">
            <label class="form-label fw-semibold fs-7">Position</label>
            <select
              v-model="filters.positionId"
              @change="fetchRequirements"
              class="form-control form-control-sm"
            >
              <option value="">All Positions</option>
              <option
                v-for="position in positions"
                :key="position.PositionID"
                :value="position.PositionID"
              >
                {{ position.PositionTitle }}
              </option>
            </select>
          </div>

          <div class="col-6 col-md-3">
            <label class="form-label fw-semibold fs-7">Type</label>
            <select
              v-model="filters.requirementType"
              @change="fetchRequirements"
              class="form-control form-control-sm"
            >
              <option value="">All Types</option>
              <option v-for="type in requirementTypes" :key="type" :value="type">{{ type }}</option>
            </select>
          </div>

          <div class="col-6 col-md-3">
            <label class="form-label fw-semibold fs-7">Status</label>
            <select
              v-model="filters.isMandatory"
              @change="fetchRequirements"
              class="form-control form-control-sm"
            >
              <option value="">All</option>
              <option value="1">Mandatory</option>
              <option value="0">Optional</option>
            </select>
          </div>

          <div class="col-6 col-md-3">
            <label class="form-label fw-semibold fs-7">&nbsp;</label>
            <button @click="clearFilters" class="btn btn-light-danger btn-sm w-100">
              <i class="ki-duotone ki-eraser fs-4 me-1">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              Clear
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Requirements List -->
    <div v-if="!showForm" class="card card-flush">
      <div class="card-header border-0">
        <h3 class="card-title fw-bold">
          <i class="ki-duotone ki-row-horizontal text-primary fs-2 me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Requirements List
          <span class="badge badge-light-primary ms-2">{{ requirements.length }}</span>
        </h3>
        <div class="card-toolbar">
          <button @click="generateAIInsights" class="btn btn-sm btn-light-success">
            <i class="ki-duotone ki-ai fs-2 me-1">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            AI Insights
          </button>
        </div>
      </div>
      <div class="card-body">
        <div v-if="loading" class="d-flex justify-content-center py-10">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>

        <div v-else-if="requirements.length === 0" class="text-center py-10">
          <i class="ki-duotone ki-file-deleted fs-3x text-muted mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <h3 class="text-muted">No Requirements Found</h3>
          <p class="text-muted">Click "Add Requirement" to create the first one</p>
        </div>

        <div v-else class="table-responsive">
          <table class="table align-middle table-row-dashed fs-6">
            <thead>
              <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase">
                <th>Position</th>
                <th>Type</th>
                <th>Requirement</th>
                <th>Status</th>
                <th>AI Score</th>
                <th>Created</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="requirement in requirements" :key="requirement.RequirementID">
                <td>
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-35px me-3">
                      <div class="symbol-label bg-light-primary">
                        <i class="ki-duotone ki-profile-user text-primary fs-6">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span>
                          <span class="path4"></span>
                        </i>
                      </div>
                    </div>
                    <div>
                      <div class="fw-bold">{{ getPositionName(requirement.PositionID) }}</div>
                      <div class="text-muted fs-7">ID: {{ requirement.PositionID }}</div>
                    </div>
                  </div>
                </td>
                <td>
                  <span class="badge badge-light-info">{{ requirement.RequirementType }}</span>
                </td>
                <td>
                  <div>
                    <div class="fw-semibold">{{ requirement.RequirementName }}</div>
                    <div
                      v-if="requirement.Description"
                      class="text-muted fs-7 text-truncate"
                      style="max-width: 300px"
                    >
                      {{ requirement.Description }}
                    </div>
                  </div>
                </td>
                <td>
                  <span
                    :class="`badge ${requirement.IsMandatory === '1' ? 'badge-light-success' : 'badge-light-warning'}`"
                  >
                    {{ requirement.IsMandatory === '1' ? 'Mandatory' : 'Optional' }}
                  </span>
                </td>
                <td>
                  <div class="d-flex align-items-center">
                    <div class="progress h-6px w-60px me-2">
                      <div
                        class="progress-bar bg-success"
                        :style="`width: ${getAIScore(requirement)}%`"
                      ></div>
                    </div>
                    <span class="fw-bold fs-7">{{ getAIScore(requirement) }}%</span>
                  </div>
                </td>
                <td>
                  <div class="text-muted">
                    {{ formatDate(requirement.CreatedAt) }}
                  </div>
                </td>
                <td class="text-end">
                  <div class="d-flex justify-content-end gap-2">
                    <button @click="handleEdit(requirement)" class="btn btn-sm btn-light-primary">
                      <i class="ki-duotone ki-pencil fs-5">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </button>
                    <button @click="handleDelete(requirement)" class="btn btn-sm btn-light-danger">
                      <i class="ki-duotone ki-trash fs-5">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                        <span class="path5"></span>
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
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'

const requirements = ref([])
const positions = ref([])
const loading = ref(false)
const showForm = ref(false)
const editingRequirement = ref(null)

const filters = ref({
  positionId: '',
  requirementType: '',
  isMandatory: '',
})

const formData = ref({
  PositionID: '',
  RequirementType: '',
  RequirementName: '',
  Description: '',
  IsMandatory: '1',
})

const typeChart = ref(null)
const mandatoryChart = ref(null)
const heatmapChart = ref(null)

const API_BASE_URL = 'http://localhost:4000/api/records/v1'
const JWT_TOKEN =
  localStorage.getItem('jwt') ||
  'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJzdWIiOiJkMDc1QVZVSVNCcW9HN3dvZFV0MVZ3PT0iLCJpYXQiOjE3NTAyNDc4ODgsImV4cCI6MTc1MDI1MTQ4OCwiZW1haWwiOiJhZG1pbkBsb2NhbGhvc3QiLCJjc3JmX3Rva2VuIjoiOWdWQmpzU0MzN1NBTmVhU3pCelQifQ.i-Lj_KsB-TXZ1vgsu4CPEdICamdOznhKDh42Jx7oi4F29K5voeBER5bBycrnQ0uK7-G45F-18SibATxo_F3rBQ'

const requirementTypes = [
  'Education',
  'Experience',
  'Certification',
  'Skill',
  'License',
  'Training',
  'Language',
  'Physical',
  'Security Clearance',
  'Technical',
]

const chartColors = [
  '#3B82F6',
  '#10B981',
  '#F59E0B',
  '#EF4444',
  '#8B5CF6',
  '#06B6D4',
  '#84CC16',
  '#F97316',
]

const isMandatory = computed({
  get: () => formData.value.IsMandatory === '1',
  set: (value) => (formData.value.IsMandatory = value ? '1' : '0'),
})

const mandatoryCount = computed(
  () => requirements.value.filter((r) => r.IsMandatory === '1').length,
)

const optionalCount = computed(() => requirements.value.filter((r) => r.IsMandatory === '0').length)

const uniqueTypes = computed(() => new Set(requirements.value.map((r) => r.RequirementType)).size)

const mandatoryPercentage = computed(() => {
  const total = requirements.value.length
  return total > 0 ? Math.round((mandatoryCount.value / total) * 100) : 0
})

const optionalPercentage = computed(() => {
  const total = requirements.value.length
  return total > 0 ? Math.round((optionalCount.value / total) * 100) : 0
})

const typeAnalytics = computed(() => {
  const typeCount = {}
  requirements.value.forEach((r) => {
    typeCount[r.RequirementType] = (typeCount[r.RequirementType] || 0) + 1
  })
  return Object.entries(typeCount).map(([type, count]) => ({ type, count }))
})

const fetchRequirements = async () => {
  loading.value = true
  try {
    let url = `${API_BASE_URL}/PositionRequirements`
    const params = new URLSearchParams()

    if (filters.value.positionId) params.append('PositionID', filters.value.positionId)
    if (filters.value.requirementType)
      params.append('RequirementType', filters.value.requirementType)
    if (filters.value.isMandatory) params.append('IsMandatory', filters.value.isMandatory)

    if (params.toString()) url += `?${params.toString()}`

    const response = await fetch(url, {
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) throw new Error(`Failed to fetch requirements: ${response.status}`)

    const data = await response.json()
    requirements.value = data.records || []

    await nextTick()
    drawCharts()
  } catch (error) {
    console.error('Error fetching requirements:', error)
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load position requirements',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const fetchPositions = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/Positions`, {
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) throw new Error('Failed to fetch positions')

    const data = await response.json()
    positions.value = data.records || []
  } catch (error) {
    console.error('Error fetching positions:', error)
  }
}

const handleSubmit = async () => {
  loading.value = true

  try {
    const method = editingRequirement.value ? 'PATCH' : 'POST'
    const url = editingRequirement.value
      ? `${API_BASE_URL}/PositionRequirements/${editingRequirement.value.RequirementID}`
      : `${API_BASE_URL}/PositionRequirements`

    const response = await fetch(url, {
      method,
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(formData.value),
    })

    if (!response.ok)
      throw new Error(`Failed to ${editingRequirement.value ? 'update' : 'create'} requirement`)

    Swal.fire({
      title: 'Success!',
      text: `Requirement ${editingRequirement.value ? 'updated' : 'created'} successfully`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    resetForm()
    fetchRequirements()
  } catch (error) {
    console.error('Error saving requirement:', error)
    Swal.fire({
      title: 'Error!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const handleEdit = (requirement) => {
  editingRequirement.value = requirement
  formData.value = {
    PositionID: requirement.PositionID,
    RequirementType: requirement.RequirementType,
    RequirementName: requirement.RequirementName,
    Description: requirement.Description || '',
    IsMandatory: requirement.IsMandatory,
  }
  showForm.value = true
}

const handleDelete = async (requirement) => {
  const result = await Swal.fire({
    title: 'Delete Requirement?',
    text: `This will permanently remove "${requirement.RequirementName}" requirement`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#6c757d',
    confirmButtonText: 'Yes, delete it!',
  })

  if (!result.isConfirmed) return

  loading.value = true
  try {
    const response = await fetch(
      `${API_BASE_URL}/PositionRequirements/${requirement.RequirementID}`,
      {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${JWT_TOKEN}`,
          'Content-Type': 'application/json',
        },
      },
    )

    if (!response.ok) throw new Error('Failed to delete requirement')

    Swal.fire({
      title: 'Deleted!',
      text: 'Requirement has been deleted successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    fetchRequirements()
  } catch (error) {
    console.error('Error deleting requirement:', error)
    Swal.fire({
      title: 'Error!',
      text: 'Failed to delete requirement',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  formData.value = {
    PositionID: '',
    RequirementType: '',
    RequirementName: '',
    Description: '',
    IsMandatory: '1',
  }
  editingRequirement.value = null
  showForm.value = false
}

const clearFilters = () => {
  filters.value = {
    positionId: '',
    requirementType: '',
    isMandatory: '',
  }
  fetchRequirements()
}

const getPositionName = (positionId) => {
  const position = positions.value.find((p) => p.PositionID === positionId)
  return position ? position.PositionTitle : 'Unknown Position'
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString()
}

const getAIScore = (requirement) => {
  // Simulate AI scoring based on requirement properties
  let score = 75 // Base score
  if (requirement.IsMandatory === '1') score += 15
  if (requirement.Description && requirement.Description.length > 50) score += 10
  return Math.min(Math.max(score + Math.floor(Math.random() * 10) - 5, 50), 100)
}

const generateAIInsights = () => {
  Swal.fire({
    title: 'AI Insights Generated!',
    html: `
      <div class="text-start">
        <p><strong>Key Findings:</strong></p>
        <ul>
          <li>Most positions require Education qualifications (${typeAnalytics.value.find((t) => t.type === 'Education')?.count || 0} requirements)</li>
          <li>${mandatoryPercentage.value}% of requirements are mandatory</li>
          <li>Positions with highest requirements: Station Manager, Maintenance Tech</li>
          <li>Recommended: Add more certification requirements for technical roles</li>
        </ul>
      </div>
    `,
    icon: 'info',
    confirmButtonText: 'Got it!',
    confirmButtonColor: '#009ef7',
  })
}

const drawCharts = () => {
  if (typeChart.value) drawTypeChart()
  if (mandatoryChart.value) drawMandatoryChart()
  if (heatmapChart.value) drawHeatmapChart()
}

const drawTypeChart = () => {
  const ctx = typeChart.value.getContext('2d')
  const data = typeAnalytics.value

  if (data.length === 0) return

  ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height)

  const maxValue = Math.max(...data.map((d) => d.count))
  const barWidth = (ctx.canvas.width / data.length) * 0.8
  const barSpacing = (ctx.canvas.width / data.length) * 0.2

  data.forEach((item, index) => {
    const barHeight = (item.count / maxValue) * (ctx.canvas.height - 60)
    const x = index * (barWidth + barSpacing) + barSpacing / 2
    const y = ctx.canvas.height - barHeight - 30

    ctx.fillStyle = chartColors[index % chartColors.length]
    ctx.fillRect(x, y, barWidth, barHeight)

    // Draw value on top
    ctx.fillStyle = '#333'
    ctx.font = '12px Arial'
    ctx.textAlign = 'center'
    ctx.fillText(item.count, x + barWidth / 2, y - 5)

    // Draw label at bottom
    ctx.save()
    ctx.translate(x + barWidth / 2, ctx.canvas.height - 10)
    ctx.rotate(-Math.PI / 4)
    ctx.textAlign = 'right'
    ctx.fillText(item.type, 0, 0)
    ctx.restore()
  })
}

const drawMandatoryChart = () => {
  const ctx = mandatoryChart.value.getContext('2d')
  const centerX = ctx.canvas.width / 2
  const centerY = ctx.canvas.height / 2
  const radius = Math.min(centerX, centerY) - 20

  const mandatoryAngle = (mandatoryPercentage.value / 100) * 2 * Math.PI

  // Draw mandatory slice
  ctx.beginPath()
  ctx.moveTo(centerX, centerY)
  ctx.arc(centerX, centerY, radius, 0, mandatoryAngle)
  ctx.closePath()
  ctx.fillStyle = '#10B981'
  ctx.fill()

  // Draw optional slice
  ctx.beginPath()
  ctx.moveTo(centerX, centerY)
  ctx.arc(centerX, centerY, radius, mandatoryAngle, 2 * Math.PI)
  ctx.closePath()
  ctx.fillStyle = '#F59E0B'
  ctx.fill()

  // Draw center circle
  ctx.beginPath()
  ctx.arc(centerX, centerY, radius * 0.6, 0, 2 * Math.PI)
  ctx.fillStyle = '#fff'
  ctx.fill()

  // Draw percentages
  ctx.fillStyle = '#333'
  ctx.font = 'bold 16px Arial'
  ctx.textAlign = 'center'
  ctx.fillText(`${mandatoryPercentage.value}%`, centerX, centerY - 5)
  ctx.font = '12px Arial'
  ctx.fillText('Mandatory', centerX, centerY + 15)
}

const drawHeatmapChart = () => {
  const ctx = heatmapChart.value.getContext('2d')
  const positions = ['Manager', 'Supervisor', 'Attendant', 'Cashier', 'Tech']
  const types = ['Education', 'Experience', 'Certification', 'Skill']

  const cellWidth = ctx.canvas.width / types.length
  const cellHeight = ctx.canvas.height / positions.length

  // Simulate heatmap data
  for (let i = 0; i < positions.length; i++) {
    for (let j = 0; j < types.length; j++) {
      const intensity = Math.random()
      const x = j * cellWidth
      const y = i * cellHeight

      const hue = intensity * 120 // From red (0) to green (120)
      ctx.fillStyle = `hsl(${hue}, 70%, 60%)`
      ctx.fillRect(x, y, cellWidth - 2, cellHeight - 2)

      // Draw labels
      ctx.fillStyle = '#333'
      ctx.font = '12px Arial'
      ctx.textAlign = 'center'
      if (i === 0) {
        ctx.fillText(types[j], x + cellWidth / 2, 15)
      }
      if (j === 0) {
        ctx.save()
        ctx.translate(15, y + cellHeight / 2)
        ctx.rotate(-Math.PI / 2)
        ctx.fillText(positions[i], 0, 0)
        ctx.restore()
      }
    }
  }
}

onMounted(() => {
  fetchRequirements()
  fetchPositions()
})
</script>

<style scoped>
.table-responsive {
  border-radius: 0.625rem;
}

.mixed-widget-10-chart,
.mixed-widget-14-chart,
.mixed-widget-5-chart {
  background: #f8f9fa;
  border-radius: 0.625rem;
  padding: 20px;
}

.bullet {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

.progress {
  background-color: #e1e3ea;
}
</style>

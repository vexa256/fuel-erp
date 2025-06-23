<template>
  <div class="d-flex flex-column gap-6 py-4 px-2 bg-light min-vh-100">
    <!-- HEADER + AI -->
    <div class="card card-flush border-0 shadow-sm bg-light-primary">
      <div
        class="card-body p-5 d-flex flex-column flex-md-row align-items-center justify-content-between gap-3"
      >
        <div>
          <div class="fs-1 fw-bold text-dark d-flex align-items-center mb-1">
            <i class="ki-duotone ki-medal-star fs-2hx text-primary me-3"
              ><span class="path1"></span><span class="path2"></span><span class="path3"></span
            ></i>
            Job Grades &amp; Roles Management
          </div>
          <div class="fs-5 text-gray-600 mb-2">All changes are logged with audit fields.</div>
          <div class="badge badge-light-info">
            <i class="ki-duotone ki-brain fs-2 me-2"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            <span>{{ aiAdvice }}</span>
          </div>
        </div>
        <div class="d-flex gap-2">
          <button @click="openJobGradeModal()" class="btn btn-light-primary btn-lg fw-bold">
            <i class="ki-duotone ki-plus fs-2"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            New Job Grade
          </button>
          <button @click="openRoleModal()" class="btn btn-light-warning btn-lg fw-bold">
            <i class="ki-duotone ki-plus fs-2"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            New Role
          </button>
        </div>
      </div>
    </div>

    <!-- Tabs -->
    <div class="card card-flush">
      <div class="card-header border-0 pt-4">
        <div class="nav nav-tabs nav-line-tabs nav-stretch fs-6 border-0">
          <a
            class="nav-link fw-bold"
            :class="{ active: activeTab === 'jobgrades' }"
            @click="switchTab('jobgrades')"
            role="tab"
          >
            <i class="ki-duotone ki-medal-star fs-2 me-2"
              ><span class="path1"></span><span class="path2"></span><span class="path3"></span
            ></i>
            Job Grades <span class="badge badge-light-primary ms-2">{{ jobGrades.length }}</span>
          </a>
          <a
            class="nav-link fw-bold"
            :class="{ active: activeTab === 'roles' }"
            @click="switchTab('roles')"
            role="tab"
          >
            <i class="ki-duotone ki-security-user fs-2 me-2"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            Roles <span class="badge badge-light-warning ms-2">{{ roles.length }}</span>
          </a>
        </div>
      </div>
    </div>

    <!-- JOB GRADES TAB -->
    <div v-if="activeTab === 'jobgrades'">
      <!-- Table -->
      <div class="card card-flush">
        <div class="card-header align-items-center py-5 gap-2 gap-md-5">
          <div class="card-title">
            <div class="d-flex align-items-center position-relative my-1">
              <i class="ki-duotone ki-magnifier fs-3 position-absolute ms-4"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              <input
                v-model="searchTerm"
                type="text"
                class="form-control form-control-solid w-250px ps-12"
                placeholder="Search job grades..."
              />
            </div>
          </div>
        </div>
        <div class="card-body pt-0">
          <div
            class="alert bg-light-warning border-0 py-3 px-5 mb-5 d-flex align-items-center gap-4"
          >
            <i class="ki-duotone ki-light-bulb fs-2hx text-warning"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            <span><b>AI:</b> {{ jobGradeAIAdvice }}</span>
          </div>
          <div class="table-responsive">
            <table class="table align-middle table-row-dashed fs-6 gy-4">
              <thead>
                <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                  <th>Grade Code</th>
                  <th>Grade Name</th>
                  <th>Level</th>
                  <th>Salary Range</th>
                  <th>Status</th>
                  <th class="text-end">Actions</th>
                </tr>
              </thead>
              <tbody class="fw-semibold text-gray-600">
                <tr v-for="grade in filteredJobGrades" :key="grade.GradeID">
                  <td>
                    <span class="badge badge-light-primary fw-bold">{{ grade.GradeCode }}</span>
                  </td>
                  <td class="fw-bold text-gray-800">{{ grade.GradeName }}</td>
                  <td>
                    <span class="badge badge-light-info"
                      >Level {{ getLevelText(grade.Level) }}</span
                    >
                  </td>
                  <td>
                    <span class="fw-bold"
                      >{{ toMoney(grade.MinSalary) }} - {{ toMoney(grade.MaxSalary) }}</span
                    >
                    <span class="text-muted" v-if="grade.MidSalary"
                      >Mid: {{ toMoney(grade.MidSalary) }}</span
                    >
                  </td>
                  <td>
                    <span
                      :class="
                        grade.IsActive == 1
                          ? 'badge badge-light-success'
                          : 'badge badge-light-danger'
                      "
                    >
                      {{ grade.IsActive == 1 ? 'Active' : 'Inactive' }}
                    </span>
                  </td>
                  <td class="text-end">
                    <button
                      @click="openJobGradeModal(grade)"
                      class="btn btn-icon btn-light-primary btn-sm me-2"
                    >
                      <i class="ki-duotone ki-pencil fs-5"
                        ><span class="path1"></span><span class="path2"></span
                      ></i>
                    </button>
                    <button
                      @click="deleteJobGrade(grade)"
                      class="btn btn-icon btn-light-danger btn-sm"
                    >
                      <i class="ki-duotone ki-trash fs-5"
                        ><span class="path1"></span><span class="path2"></span
                        ><span class="path3"></span
                      ></i>
                    </button>
                  </td>
                </tr>
                <tr v-if="filteredJobGrades.length === 0">
                  <td colspan="6" class="text-center text-muted py-10">
                    <i class="ki-duotone ki-search-list fs-3x text-gray-300 mb-3"
                      ><span class="path1"></span><span class="path2"></span
                      ><span class="path3"></span
                    ></i>
                    <div>No job grades found</div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- ROLES TAB -->
    <div v-if="activeTab === 'roles'">
      <div class="card card-flush">
        <div class="card-header align-items-center py-5 gap-2 gap-md-5">
          <div class="card-title">
            <div class="d-flex align-items-center position-relative my-1">
              <i class="ki-duotone ki-magnifier fs-3 position-absolute ms-4"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              <input
                v-model="searchTerm"
                type="text"
                class="form-control form-control-solid w-250px ps-12"
                placeholder="Search roles..."
              />
            </div>
          </div>
        </div>
        <div class="card-body pt-0">
          <div
            class="alert bg-light-warning border-0 py-3 px-5 mb-5 d-flex align-items-center gap-4"
          >
            <i class="ki-duotone ki-shield-check fs-2hx text-warning"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            <span><b>AI:</b> {{ roleAIAdvice }}</span>
          </div>
          <div class="table-responsive">
            <table class="table align-middle table-row-dashed fs-6 gy-4">
              <thead>
                <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                  <th>Role Name</th>
                  <th>Description</th>
                  <th>Type</th>
                  <th>Created</th>
                  <th class="text-end">Actions</th>
                </tr>
              </thead>
              <tbody class="fw-semibold text-gray-600">
                <tr v-for="role in filteredRoles" :key="role.RoleID">
                  <td class="fw-bold text-gray-800">{{ role.RoleName }}</td>
                  <td>
                    <div class="text-gray-600">{{ role.Description || 'No description' }}</div>
                  </td>
                  <td>
                    <span
                      class="badge"
                      :class="role.IsSystem == 1 ? 'badge-light-danger' : 'badge-light-primary'"
                    >
                      {{ role.IsSystem == 1 ? 'System' : 'Custom' }}
                    </span>
                  </td>
                  <td>
                    <div class="fs-7 text-gray-600">
                      {{ role.CreatedAt ? new Date(role.CreatedAt).toLocaleDateString() : '-' }}
                    </div>
                  </td>
                  <td class="text-end">
                    <button
                      @click="openRoleModal(role)"
                      class="btn btn-icon btn-light-primary btn-sm me-2"
                    >
                      <i class="ki-duotone ki-pencil fs-5"
                        ><span class="path1"></span><span class="path2"></span
                      ></i>
                    </button>
                    <button
                      @click="deleteRole(role)"
                      class="btn btn-icon btn-light-danger btn-sm"
                      :disabled="role.IsSystem == 1"
                    >
                      <i class="ki-duotone ki-trash fs-5"
                        ><span class="path1"></span><span class="path2"></span
                        ><span class="path3"></span
                      ></i>
                    </button>
                  </td>
                </tr>
                <tr v-if="filteredRoles.length === 0">
                  <td colspan="5" class="text-center text-muted py-10">
                    <i class="ki-duotone ki-search-list fs-3x text-gray-300 mb-3"
                      ><span class="path1"></span><span class="path2"></span
                      ><span class="path3"></span
                    ></i>
                    <div>No roles found</div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- JOB GRADE MODAL -->
    <div
      v-if="showJobGradeModal"
      class="modal fade show d-block"
      style="background-color: rgba(0, 0, 0, 0.5); z-index: 1060"
    >
      <div class="modal-dialog modal-dialog-centered mw-650px">
        <div class="modal-content">
          <div class="modal-header">
            <h2 class="fw-bold">{{ editingJobGrade ? 'Edit' : 'New' }} Job Grade</h2>
            <button
              @click="showJobGradeModal = false"
              class="btn btn-icon btn-sm btn-active-light-primary"
            >
              <i class="ki-duotone ki-cross fs-1"
                ><span class="path1"></span><span class="path2"></span
              ></i>
            </button>
          </div>
          <div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
            <form @submit.prevent="saveJobGrade" novalidate>
              <div class="row g-5">
                <div class="col-12 col-md-6">
                  <label class="required form-label">Grade Code</label>
                  <div class="input-group">
                    <input
                      v-model="jobGradeForm.GradeCode"
                      type="text"
                      class="form-control form-control-lg"
                      required
                      :readonly="autoCode"
                    />
                    <button
                      v-if="autoCode"
                      class="btn btn-light-success"
                      type="button"
                      @click="generateGradeCode"
                    >
                      Regenerate
                    </button>
                    <button
                      v-else
                      class="btn btn-light-primary"
                      type="button"
                      @click="generateGradeCode"
                    >
                      Auto Generate
                    </button>
                  </div>
                  <div class="form-text">
                    A unique short code (e.g. JR01, SN02). Auto-generated by system but editable.
                  </div>
                </div>
                <div class="col-12 col-md-6">
                  <label class="required form-label">Grade Name</label>
                  <input
                    v-model="jobGradeForm.GradeName"
                    type="text"
                    class="form-control form-control-lg"
                    required
                  />
                  <div class="form-text">
                    The full name of the job grade. E.g. "Senior Analyst", "Entry Technician".
                  </div>
                </div>
                <div class="col-12 col-md-6">
                  <label class="required form-label">Level</label>
                  <select v-model="jobGradeForm.Level" class="form-select form-select-lg" required>
                    <option
                      v-for="option in levelOptions"
                      :key="option.value"
                      :value="option.value"
                    >
                      {{ option.label }}
                    </option>
                  </select>
                  <div class="form-text">
                    Job level, as per international convention. <b>Entry</b>=1, <b>Junior</b>=2,
                    <b>Mid</b>=3, <b>Senior</b>=4, <b>Lead</b>=5, <b>Executive</b>=6
                  </div>
                </div>
                <div class="col-12 col-md-6">
                  <label class="form-label">Status</label>
                  <select v-model="jobGradeForm.IsActive" class="form-select form-select-lg">
                    <option value="1">Active</option>
                    <option value="0">Inactive</option>
                  </select>
                  <div class="form-text">
                    Active = grade is currently in use. Inactive = archived.
                  </div>
                </div>
                <div class="col-12 col-md-4">
                  <label class="required form-label">Min Salary</label>
                  <input
                    v-model="jobGradeForm.MinSalary"
                    type="number"
                    class="form-control form-control-lg"
                    required
                  />
                  <div class="form-text">The lowest possible salary for this grade.</div>
                </div>
                <div class="col-12 col-md-4">
                  <label class="form-label">Mid Salary</label>
                  <input
                    v-model="jobGradeForm.MidSalary"
                    type="number"
                    class="form-control form-control-lg"
                  />
                  <div class="form-text">
                    The midpoint salary for this grade (optional, used for benchmarking).
                  </div>
                </div>
                <div class="col-12 col-md-4">
                  <label class="required form-label">Max Salary</label>
                  <input
                    v-model="jobGradeForm.MaxSalary"
                    type="number"
                    class="form-control form-control-lg"
                    required
                  />
                  <div class="form-text">The highest possible salary for this grade.</div>
                </div>
                <div class="col-12">
                  <label class="form-label">Description</label>
                  <textarea
                    v-model="jobGradeForm.Description"
                    class="form-control form-control-lg"
                    rows="3"
                  ></textarea>
                  <div class="form-text">Free-form explanation of what this grade covers.</div>
                </div>
                <div class="col-12 col-md-6">
                  <label class="form-label">Created By (User)</label>
                  <select v-model="jobGradeForm.CreatedBy" class="form-select form-select-lg">
                    <option value="">Select user...</option>
                    <option v-for="user in users" :key="user.id" :value="user.id">
                      {{ user.name }}
                    </option>
                  </select>
                  <div class="form-text">
                    User who created this grade. <b>Required for audit logging.</b>
                  </div>
                </div>
                <div class="col-12 col-md-6">
                  <label class="form-label">Updated By (User)</label>
                  <select v-model="jobGradeForm.UpdatedBy" class="form-select form-select-lg">
                    <option value="">Select user...</option>
                    <option v-for="user in users" :key="user.id" :value="user.id">
                      {{ user.name }}
                    </option>
                  </select>
                  <div class="form-text">User who last updated this grade.</div>
                </div>
              </div>
            </form>
            <div class="alert bg-light-warning mt-5">
              <i class="ki-duotone ki-alert-triangle fs-2 text-warning me-3"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              <span>{{ jobGradeModalAIAdvice }}</span>
            </div>
          </div>
          <div class="modal-footer">
            <button @click="showJobGradeModal = false" class="btn btn-light me-3">Cancel</button>
            <button @click="saveJobGrade" class="btn btn-primary" :disabled="loading">
              <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
              {{ editingJobGrade ? 'Update' : 'Create' }} Grade
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ROLE MODAL -->
    <div
      v-if="showRoleModal"
      class="modal fade show d-block"
      style="background-color: rgba(0, 0, 0, 0.5); z-index: 1060"
    >
      <div class="modal-dialog modal-dialog-centered mw-650px">
        <div class="modal-content">
          <div class="modal-header">
            <h2 class="fw-bold">{{ editingRole ? 'Edit' : 'New' }} Role</h2>
            <button
              @click="showRoleModal = false"
              class="btn btn-icon btn-sm btn-active-light-primary"
            >
              <i class="ki-duotone ki-cross fs-1"
                ><span class="path1"></span><span class="path2"></span
              ></i>
            </button>
          </div>
          <div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
            <form @submit.prevent="saveRole" novalidate>
              <div class="row g-5">
                <div class="col-12">
                  <label class="required form-label">Role Name</label>
                  <input
                    v-model="roleForm.RoleName"
                    type="text"
                    class="form-control form-control-lg"
                    required
                  />
                  <div class="form-text">
                    A clear descriptive name for this role. E.g. "Supervisor", "Finance Admin".
                  </div>
                </div>
                <div class="col-12">
                  <label class="form-label">Role Type</label>
                  <select v-model="roleForm.IsSystem" class="form-select form-select-lg">
                    <option value="0">Custom Role</option>
                    <option value="1">System Role</option>
                  </select>
                  <div class="form-text">
                    System roles are essential for application operation and cannot be deleted.
                  </div>
                </div>
                <div class="col-12">
                  <label class="form-label">Description</label>
                  <textarea
                    v-model="roleForm.Description"
                    class="form-control form-control-lg"
                    rows="4"
                  ></textarea>
                  <div class="form-text">
                    Explain what this role is responsible for, and the permissions it grants.
                  </div>
                </div>
                <div class="col-12 col-md-6">
                  <label class="form-label">Created By (User)</label>
                  <select v-model="roleForm.CreatedBy" class="form-select form-select-lg">
                    <option value="">Select user...</option>
                    <option v-for="user in users" :key="user.id" :value="user.id">
                      {{ user.name }}
                    </option>
                  </select>
                  <div class="form-text">
                    User who created this role. Required for audit logging.
                  </div>
                </div>
                <div class="col-12 col-md-6">
                  <label class="form-label">Updated By (User)</label>
                  <select v-model="roleForm.UpdatedBy" class="form-select form-select-lg">
                    <option value="">Select user...</option>
                    <option v-for="user in users" :key="user.id" :value="user.id">
                      {{ user.name }}
                    </option>
                  </select>
                  <div class="form-text">User who last updated this role.</div>
                </div>
              </div>
            </form>
            <div class="alert bg-light-warning mt-5">
              <i class="ki-duotone ki-alert-triangle fs-2 text-warning me-3"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              <span>{{ roleModalAIAdvice }}</span>
            </div>
          </div>
          <div class="modal-footer">
            <button @click="showRoleModal = false" class="btn btn-light me-3">Cancel</button>
            <button @click="saveRole" class="btn btn-warning" :disabled="loading">
              <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
              {{ editingRole ? 'Update' : 'Create' }} Role
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'

// API CONFIG
const API_BASE_URL = 'http://localhost:4000/api/records/v1'
const JWT_TOKEN = localStorage.getItem('jwt') || ''

// ---- STATIC OPTIONS ----
const levelOptions = [
  { value: 1, label: 'Entry' },
  { value: 2, label: 'Junior' },
  { value: 3, label: 'Mid' },
  { value: 4, label: 'Senior' },
  { value: 5, label: 'Lead' },
  { value: 6, label: 'Executive' },
]
const getLevelText = (val) => {
  const found = levelOptions.find((l) => Number(l.value) === Number(val))
  return found ? found.label : val
}

// ---- STATE ----
const activeTab = ref('jobgrades')
const searchTerm = ref('')
const loading = ref(false)
const jobGrades = ref([])
const showJobGradeModal = ref(false)
const editingJobGrade = ref(false)
const jobGradeForm = ref(getEmptyJobGrade())
const autoCode = ref(true)
const roles = ref([])
const showRoleModal = ref(false)
const editingRole = ref(false)
const roleForm = ref(getEmptyRole())
const users = ref([])

// ---- USER FETCH ----
const fetchUsers = async () => {
  loading.value = true
  await makeRequest('/users', {}, 'Fetch Users')
    .then((res) => (users.value = res.records || []))
    .finally(() => (loading.value = false))
}

// ---- API HELPER ----
const makeRequest = async (endpoint, opts = {}, logContext = 'API') => {
  const { method = 'GET', body } = opts
  if (body) console.log(`[${logContext}] REQUEST:`, { endpoint, method, body: JSON.parse(body) })
  else console.log(`[${logContext}] REQUEST:`, { endpoint, method })
  try {
    const res = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...opts,
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        ...(opts.headers || {}),
      },
    })
    let json = {}
    try {
      json = await res.json()
    } catch {}
    console.log(`[${logContext}] RESPONSE:`, { status: res.status, data: json })
    if (!res.ok) throw new Error(json.message || res.statusText)
    return json
  } catch (e) {
    console.error(`[${logContext}] ERROR:`, e)
    Swal.fire({ title: 'API Error', text: e.message, icon: 'error', confirmButtonColor: '#f1416c' })
    throw e
  }
}

// ---- JOBGRADES ----
function getEmptyJobGrade() {
  return {
    GradeID: null,
    GradeCode: '',
    GradeName: '',
    MinSalary: '',
    MidSalary: '',
    MaxSalary: '',
    Level: 1,
    Description: '',
    IsActive: 1,
    CreatedAt: null,
    UpdatedAt: null,
    CreatedBy: '',
    UpdatedBy: '',
  }
}
const filteredJobGrades = computed(() => {
  if (!searchTerm.value) return jobGrades.value
  return jobGrades.value.filter(
    (grade) =>
      grade.GradeName?.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
      grade.GradeCode?.toLowerCase().includes(searchTerm.value.toLowerCase()),
  )
})
function openJobGradeModal(grade = null) {
  editingJobGrade.value = !!grade
  if (grade) {
    jobGradeForm.value = { ...grade }
    autoCode.value = false
  } else {
    jobGradeForm.value = getEmptyJobGrade()
    autoCode.value = true
    generateGradeCode()
  }
  showJobGradeModal.value = true
}
// Grade code auto generator
function generateGradeCode() {
  const prefix = getLevelText(jobGradeForm.value.Level || 1)
    .substring(0, 2)
    .toUpperCase()
  const random = Math.floor(100 + Math.random() * 900)
  jobGradeForm.value.GradeCode = `${prefix}${random}`
  autoCode.value = true
}
watch(
  () => jobGradeForm.value.Level,
  (val) => {
    if (autoCode.value && !editingJobGrade.value) generateGradeCode()
  },
)

// ---- CRUD JOBGRADES ----
function buildJobGradePayload(isPatch = false) {
  const now = new Date().toISOString()
  return {
    GradeID: isPatch ? jobGradeForm.value.GradeID : null,
    GradeCode: jobGradeForm.value.GradeCode || '',
    GradeName: jobGradeForm.value.GradeName || '',
    MinSalary: jobGradeForm.value.MinSalary !== '' ? jobGradeForm.value.MinSalary.toString() : '0',
    MidSalary: jobGradeForm.value.MidSalary !== '' ? jobGradeForm.value.MidSalary.toString() : '',
    MaxSalary: jobGradeForm.value.MaxSalary !== '' ? jobGradeForm.value.MaxSalary.toString() : '0',
    Level: jobGradeForm.value.Level !== '' ? jobGradeForm.value.Level.toString() : '1',
    Description: jobGradeForm.value.Description || '',
    IsActive:
      jobGradeForm.value.IsActive !== undefined && jobGradeForm.value.IsActive !== null
        ? jobGradeForm.value.IsActive.toString()
        : '1',
    CreatedAt: isPatch ? jobGradeForm.value.CreatedAt || now : now,
    UpdatedAt: now,
    CreatedBy: jobGradeForm.value.CreatedBy || '',
    UpdatedBy: jobGradeForm.value.UpdatedBy || '',
  }
}
async function fetchJobGrades() {
  loading.value = true
  await makeRequest('/JobGrades', {}, 'Fetch JobGrades')
    .then((res) => (jobGrades.value = res.records || []))
    .finally(() => (loading.value = false))
}
async function saveJobGrade() {
  // Validate required fields
  if (
    !jobGradeForm.value.GradeCode ||
    !jobGradeForm.value.GradeName ||
    jobGradeForm.value.MinSalary === '' ||
    jobGradeForm.value.MaxSalary === '' ||
    !jobGradeForm.value.Level ||
    !jobGradeForm.value.CreatedBy
  ) {
    Swal.fire({
      title: 'Validation Error!',
      text: 'All required fields must be filled, including Created By.',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }
  loading.value = true
  try {
    let endpoint, method, payload
    if (editingJobGrade.value && jobGradeForm.value.GradeID) {
      // EDIT (PATCH)
      endpoint = `/JobGrades/${jobGradeForm.value.GradeID}`
      method = 'PATCH'
      payload = buildJobGradePayload(true)
      // Remove GradeID for PATCH per Trailbase convention
      if ('GradeID' in payload) delete payload.GradeID
    } else {
      // CREATE (POST)
      endpoint = '/JobGrades'
      method = 'POST'
      payload = buildJobGradePayload(false)
      payload.GradeID = null
    }
    console.log('[JobGrade CRUD] About to', method, endpoint, 'Payload:', payload)
    await makeRequest(endpoint, { method, body: JSON.stringify(payload) }, 'Save JobGrade')
    showJobGradeModal.value = false
    await fetchJobGrades()
    Swal.fire({
      title: 'Success!',
      text: `Job grade ${editingJobGrade.value ? 'updated' : 'created'} successfully`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })
  } catch (error) {
    // Optionally log/show error
  } finally {
    loading.value = false
  }
}

async function deleteJobGrade(grade) {
  if (!grade.GradeID) return
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: `Delete job grade "${grade.GradeName}"?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
  })
  if (result.isConfirmed) {
    loading.value = true
    try {
      const endpoint = `/JobGrades/${grade.GradeID}`
      console.log('[JobGrade CRUD] DELETE', endpoint)
      await makeRequest(endpoint, { method: 'DELETE' }, 'Delete JobGrade')
      await fetchJobGrades()
      Swal.fire({
        title: 'Deleted!',
        text: 'Job grade has been deleted',
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 3000,
        showConfirmButton: false,
      })
    } catch (error) {
    } finally {
      loading.value = false
    }
  }
}
function toMoney(val) {
  return Number(val || 0).toLocaleString()
}

// ---- ROLES ----
function getEmptyRole() {
  return {
    RoleID: null,
    RoleName: '',
    Description: '',
    IsSystem: 0,
    CreatedAt: null,
    UpdatedAt: null,
    CreatedBy: '',
    UpdatedBy: '',
  }
}
const filteredRoles = computed(() => {
  if (!searchTerm.value) return roles.value
  return roles.value.filter((role) =>
    role.RoleName?.toLowerCase().includes(searchTerm.value.toLowerCase()),
  )
})
function openRoleModal(role = null) {
  editingRole.value = !!role
  roleForm.value = role ? { ...role } : getEmptyRole()
  showRoleModal.value = true
}
function buildRolePayload(isPatch = false) {
  const now = new Date().toISOString()
  return {
    RoleID: isPatch ? roleForm.value.RoleID : null,
    RoleName: roleForm.value.RoleName ?? '',
    Description: roleForm.value.Description ?? '',
    IsSystem:
      roleForm.value.IsSystem !== undefined && roleForm.value.IsSystem !== null
        ? roleForm.value.IsSystem.toString()
        : '0',
    CreatedAt: isPatch ? roleForm.value.CreatedAt || now : now,
    UpdatedAt: now,
    CreatedBy: roleForm.value.CreatedBy || '',
    UpdatedBy: roleForm.value.UpdatedBy || '',
  }
}
async function fetchRoles() {
  loading.value = true
  await makeRequest('/Roles', {}, 'Fetch Roles')
    .then((res) => (roles.value = res.records || []))
    .finally(() => (loading.value = false))
}
async function saveRole() {
  if (!roleForm.value.RoleName || !roleForm.value.CreatedBy) {
    Swal.fire({
      title: 'Validation Error!',
      text: 'Role Name and Created By are required.',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }
  loading.value = true
  try {
    let endpoint, method, payload
    if (editingRole.value && roleForm.value.RoleID) {
      endpoint = `/Roles/${roleForm.value.RoleID}`
      method = 'PATCH'
      payload = buildRolePayload(true)
    } else {
      endpoint = '/Roles'
      method = 'POST'
      payload = buildRolePayload(false)
    }
    console.log('[Role CRUD] About to', method, endpoint, 'Payload:', payload)
    await makeRequest(endpoint, { method, body: JSON.stringify(payload) }, 'Save Role')
    showRoleModal.value = false
    await fetchRoles()
    Swal.fire({
      title: 'Success!',
      text: `Role ${editingRole.value ? 'updated' : 'created'} successfully`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })
  } catch (error) {
  } finally {
    loading.value = false
  }
}
async function deleteRole(role) {
  if (!role.RoleID) return
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: `Delete role "${role.RoleName}"?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
  })
  if (result.isConfirmed) {
    loading.value = true
    try {
      const endpoint = `/Roles/${role.RoleID}`
      console.log('[Role CRUD] DELETE', endpoint)
      await makeRequest(endpoint, { method: 'DELETE' }, 'Delete Role')
      await fetchRoles()
      Swal.fire({
        title: 'Deleted!',
        text: 'Role has been deleted',
        icon: 'success',
        toast: true,
        position: 'top-end',
        timer: 3000,
        showConfirmButton: false,
      })
    } catch (error) {
    } finally {
      loading.value = false
    }
  }
}

// ---- AI ADVICE ----
const aiAdvice = computed(() => {
  if (jobGrades.value.length < 2)
    return 'Tip: Add at least 2 job grades for realistic HR analytics.'
  if (roles.value.length < 2)
    return 'Tip: Add several roles to separate system and custom responsibilities.'
  return 'Your Job Grades & Roles structure is on track.'
})
const jobGradeAIAdvice = computed(() => {
  if (jobGrades.value.some((g) => Number(g.MaxSalary) < Number(g.MinSalary)))
    return 'Some job grades have invalid salary ranges (Max < Min).'
  if (jobGrades.value.some((g) => Number(g.MinSalary) < 100))
    return 'AI: Min Salary should not be below national minimum wage.'
  return 'All job grades pass salary checks.'
})
const roleAIAdvice = computed(() => {
  if (roles.value.some((r) => !r.RoleName || r.RoleName.length < 3))
    return 'Every role must have a descriptive name (min 3 chars).'
  if (roles.value.some((r) => r.IsSystem == 1 && (!r.Description || r.Description.length < 10)))
    return 'System roles require a clear description for audit.'
  return 'All roles meet minimum requirements.'
})
const jobGradeModalAIAdvice = computed(() => {
  if (!jobGradeForm.value.GradeCode || !jobGradeForm.value.GradeName)
    return 'Grade Code and Name are required.'
  if (Number(jobGradeForm.value.MinSalary) < 100)
    return 'AI: Min salary below standard. Adjust to at least 100.'
  if (Number(jobGradeForm.value.MaxSalary) < Number(jobGradeForm.value.MinSalary))
    return 'Max salary cannot be less than min salary.'
  return 'Grade meets standards. Ready to save.'
})
const roleModalAIAdvice = computed(() => {
  if (!roleForm.value.RoleName || roleForm.value.RoleName.length < 3)
    return 'Role Name is required (min 3 chars).'
  if (
    roleForm.value.IsSystem == 1 &&
    (!roleForm.value.Description || roleForm.value.Description.length < 10)
  )
    return 'System Role needs a description (10+ chars).'
  return 'Role meets standards. Ready to save.'
})

// ---- INIT ----
onMounted(() => {
  fetchJobGrades()
  fetchRoles()
  fetchUsers()
})
const switchTab = (tab) => {
  activeTab.value = tab
  searchTerm.value = ''
}
</script>

<style scoped>
.card,
.btn,
.form-control,
.form-select {
  border-radius: 1.25rem;
}
.table > :not(caption) > * > * {
  vertical-align: middle;
}
.modal.fade.show {
  backdrop-filter: blur(4px);
}
input.form-control-lg,
textarea.form-control-lg {
  font-size: 1.12rem;
}
.badge {
  font-weight: 700;
}
</style>

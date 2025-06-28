<template>
  <div class="d-flex flex-column gap-6 py-4 px-2 bg-white min-vh-100">
    <!-- HEADER -->
    <div class="card card-flush border-0 shadow-sm bg-white">
      <div class="card-header py-4 d-flex align-items-center gap-3">
        <i class="ki-duotone ki-briefcase fs-2x text-primary"
          ><span class="path1"></span><span class="path2"></span
        ></i>
        <div>
          <div class="fs-1 fw-bold text-dark">Positions Management</div>
          <div class="fs-6 text-gray-600">Create, update, analyze and manage all positions</div>
        </div>
        <button @click="fetchAll" class="btn btn-light-success ms-auto" title="Refresh List">
          <i class="ki-duotone ki-refresh fs-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          Refresh
        </button>
        <button @click="openModal()" class="btn btn-light-primary ms-2 fw-bold">
          <i class="ki-duotone ki-plus fs-2"></i>
          New Position
        </button>
      </div>
    </div>

    <!-- SUMMARY CARDS -->
    <div class="d-flex gap-3 flex-wrap">
      <div class="card bg-light-primary rounded-3 shadow-sm flex-grow-1 min-w-150px">
        <div class="card-body d-flex align-items-center gap-2">
          <i class="ki-duotone ki-people fs-2x text-primary"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          <div>
            <div class="fs-3 fw-bold">{{ analytics.total }}</div>
            <div class="fs-7 text-gray-700">Total Positions</div>
          </div>
        </div>
      </div>
      <div class="card bg-light-success rounded-3 shadow-sm flex-grow-1 min-w-150px">
        <div class="card-body d-flex align-items-center gap-2">
          <i class="ki-duotone ki-user-check fs-2x text-success"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          <div>
            <div class="fs-3 fw-bold">{{ analytics.active }}</div>
            <div class="fs-7 text-gray-700">Active</div>
          </div>
        </div>
      </div>
      <div class="card bg-light-danger rounded-3 shadow-sm flex-grow-1 min-w-150px">
        <div class="card-body d-flex align-items-center gap-2">
          <i class="ki-duotone ki-user-x fs-2x text-danger"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          <div>
            <div class="fs-3 fw-bold">{{ analytics.inactive }}</div>
            <div class="fs-7 text-gray-700">Inactive</div>
          </div>
        </div>
      </div>
      <div class="card bg-light-warning rounded-3 shadow-sm flex-grow-1 min-w-150px">
        <div class="card-body d-flex align-items-center gap-2">
          <i class="ki-duotone ki-sitemap fs-2x text-warning"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          <div>
            <div class="fs-3 fw-bold">{{ analytics.management }}</div>
            <div class="fs-7 text-gray-700">Management</div>
          </div>
        </div>
      </div>
    </div>

    <!-- APEXCHARTS ANALYTICS -->
    <div class="card card-flush bg-white shadow-sm rounded-4 p-2">
      <div class="card-header px-2 pt-2 pb-1">
        <div class="fs-5 fw-bold text-dark">Positions Distribution (ApexCharts)</div>
      </div>
      <div class="card-body">
        <div id="positions-apexchart" style="min-height: 260px; width: 100%"></div>
      </div>
    </div>

    <div class="separator my-5"></div>

    <!-- POSITIONS TABLE -->
    <div class="card card-flush bg-white shadow-sm rounded-4">
      <div class="card-header px-2 pt-2 pb-1 d-flex align-items-center gap-2">
        <i class="ki-duotone ki-table fs-2 text-dark"></i>
        <div class="fs-5 fw-bold text-dark">Positions List</div>
        <input
          v-model="searchTerm"
          @input="filterPositions"
          class="form-control form-control-lg ms-auto w-225px"
          placeholder="Search positions..."
        />
      </div>
      <div class="card-body p-0">
        <table class="table table-row-dashed table-row-gray-300 gy-3">
          <thead>
            <tr class="fw-bold fs-7 text-gray-800">
              <th>#</th>
              <th>Code</th>
              <th>Title</th>
              <th>Department</th>
              <th>Grade</th>
              <th>Headcount</th>
              <th>Status</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(pos, idx) in filteredPositions" :key="pos.PositionID">
              <td>{{ idx + 1 }}</td>
              <td>{{ pos.PositionCode }}</td>
              <td>{{ pos.PositionTitle }}</td>
              <td>{{ getDeptName(pos.DepartmentID) }}</td>
              <td>{{ getGradeName(pos.GradeID) }}</td>
              <td>{{ pos.CurrentHeadcount }}</td>
              <td>
                <span
                  :class="[
                    'badge',
                    pos.IsActive === '1'
                      ? 'bg-light-success text-success'
                      : 'bg-light-danger text-danger',
                  ]"
                >
                  {{ pos.IsActive === '1' ? 'Active' : 'Inactive' }}
                </span>
              </td>
              <td>
                <button
                  @click="openModal(pos)"
                  class="btn btn-sm btn-icon btn-light-info"
                  title="Edit"
                >
                  <i class="ki-duotone ki-pencil fs-2"></i>
                </button>
              </td>
            </tr>
            <tr v-if="filteredPositions.length === 0">
              <td colspan="8" class="text-center py-5 text-gray-500 fs-6">No positions found</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- FULLSCREEN MODAL FORM -->
    <div
      v-if="showModal"
      class="modal fade show d-block"
      tabindex="-1"
      style="background: rgba(0, 0, 0, 0.7); z-index: 9999"
    >
      <div class="modal-dialog modal-fullscreen">
        <div class="modal-content p-5">
          <div class="d-flex align-items-center mb-4">
            <div class="fs-2 fw-bold">
              {{ formMode === 'edit' ? 'Edit Position' : 'Create Position' }}
            </div>
            <button @click="closeModal" class="btn btn-light-danger ms-auto">Close</button>
          </div>
          <form @submit.prevent="handleSubmit" class="d-flex flex-column gap-4">
            <div class="d-flex flex-wrap gap-4">
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Position Code</label>
                <input
                  v-model="form.PositionCode"
                  required
                  class="form-control form-control-lg"
                  maxlength="50"
                />
              </div>
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Position Title</label>
                <input
                  v-model="form.PositionTitle"
                  required
                  class="form-control form-control-lg"
                  maxlength="100"
                />
              </div>
            </div>
            <div class="d-flex flex-wrap gap-4">
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Department</label>
                <select v-model="form.DepartmentID" required class="form-select form-select-lg">
                  <option value="" disabled>Select</option>
                  <option
                    v-for="dept in departments"
                    :value="dept.DepartmentID"
                    :key="dept.DepartmentID"
                  >
                    {{ dept.DepartmentName }}
                  </option>
                </select>
              </div>
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Job Grade</label>
                <select v-model="form.GradeID" required class="form-select form-select-lg">
                  <option value="" disabled>Select</option>
                  <option v-for="grade in grades" :value="grade.GradeID" :key="grade.GradeID">
                    {{ grade.GradeCode }} - {{ grade.GradeName }}
                  </option>
                </select>
              </div>
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Reports To</label>
                <select v-model="form.ReportsToPositionID" class="form-select form-select-lg">
                  <option value="">(None)</option>
                  <option
                    v-for="pos in positions"
                    :value="pos.PositionID"
                    :key="'reports-to-' + pos.PositionID"
                  >
                    {{ pos.PositionTitle }}
                  </option>
                </select>
              </div>
            </div>
            <div class="d-flex flex-wrap gap-4">
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Minimum Experience (Months)</label>
                <input
                  v-model="form.MinExperience"
                  type="number"
                  min="0"
                  class="form-control form-control-lg"
                />
              </div>
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Minimum Education</label>
                <input
                  v-model="form.MinEducation"
                  class="form-control form-control-lg"
                  maxlength="100"
                />
              </div>
            </div>
            <div>
              <label class="form-label fw-bold">Position Description</label>
              <textarea
                v-model="form.PositionDescription"
                rows="2"
                class="form-control form-control-lg"
              ></textarea>
            </div>
            <div>
              <label class="form-label fw-bold">Responsibilities</label>
              <textarea
                v-model="form.Responsibilities"
                rows="2"
                class="form-control form-control-lg"
              ></textarea>
            </div>
            <div>
              <label class="form-label fw-bold">Qualifications</label>
              <textarea
                v-model="form.Qualifications"
                rows="2"
                class="form-control form-control-lg"
              ></textarea>
            </div>
            <div>
              <label class="form-label fw-bold">Skills</label>
              <textarea
                v-model="form.Skills"
                rows="2"
                class="form-control form-control-lg"
              ></textarea>
            </div>
            <div class="d-flex flex-wrap gap-4">
              <div class="form-check form-switch">
                <input
                  v-model="form.IsManagement"
                  type="checkbox"
                  class="form-check-input"
                  true-value="1"
                  false-value="0"
                />
                <label class="form-check-label fw-bold">Is Management</label>
              </div>
              <div class="form-check form-switch">
                <input
                  v-model="form.IsApprover"
                  type="checkbox"
                  class="form-check-input"
                  true-value="1"
                  false-value="0"
                />
                <label class="form-check-label fw-bold">Is Approver</label>
              </div>
            </div>
            <div class="d-flex flex-wrap gap-4">
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Headcount Limit</label>
                <input
                  v-model="form.HeadcountLimit"
                  type="number"
                  min="0"
                  class="form-control form-control-lg"
                />
              </div>
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Approval Level</label>
                <input
                  v-model="form.ApprovalLevel"
                  type="number"
                  min="0"
                  class="form-control form-control-lg"
                />
              </div>
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Active?</label>
                <select v-model="form.IsActive" required class="form-select form-select-lg">
                  <option value="1">Active</option>
                  <option value="0">Inactive</option>
                </select>
              </div>
            </div>
            <div class="d-flex flex-wrap gap-4">
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Created By</label>
                <select v-model="form.CreatedBy" required class="form-select form-select-lg">
                  <option value="" disabled>Select User</option>
                  <option v-for="user in users" :key="'created-' + user.id" :value="user.id">
                    {{ user.name }}
                  </option>
                </select>
              </div>
              <div class="flex-grow-1 min-w-180px">
                <label class="form-label fw-bold">Updated By</label>
                <select v-model="form.UpdatedBy" class="form-select form-select-lg">
                  <option value="" disabled>Select User</option>
                  <option v-for="user in users" :key="'updated-' + user.id" :value="user.id">
                    {{ user.name }}
                  </option>
                </select>
              </div>
            </div>
            <div class="d-flex gap-4">
              <button type="submit" class="btn btn-light-primary fw-bold">
                <i class="ki-duotone ki-save fs-2"></i>
                {{ formMode === 'edit' ? 'Update' : 'Create' }}
              </button>
              <button type="button" @click="closeModal" class="btn btn-light-danger fw-bold">
                Cancel
              </button>
              <button
                v-if="formMode === 'edit'"
                type="button"
                @click="deletePosition"
                class="btn btn-light-danger fw-bold ms-auto"
              >
                <i class="ki-duotone ki-trash fs-2"></i>
                Delete
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'

const API = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const AUTH =
  'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJzdWIiOiJkMDc1QVZVSVNCcW9HN3dvZFV0MVZ3PT0iLCJpYXQiOjE3NTA1NTc4MzAsImV4cCI6MTc1MDU2MTQzMCwiZW1haWwiOiJhZG1pbkBsb2NhbGhvc3QiLCJjc3JmX3Rva2VuIjoiT1dQU2RLeXgwQzVGVEkwbzFqb0gifQ.FrYiUIu59y6ZqftgpEQNX-GwAxh2USHTety2Dpt9C5j0H3GophpudsUzxfQ8wXVc_jcwGsnYo6svB90zzs0MBQ'

const positions = ref([])
const departments = ref([])
const grades = ref([])
const users = ref([])
const analytics = reactive({ total: 0, active: 0, inactive: 0, management: 0 })
const searchTerm = ref('')
const filteredPositions = ref([])

const showModal = ref(false)
const formMode = ref('create')
const form = reactive({
  PositionID: null,
  PositionCode: '',
  PositionTitle: '',
  DepartmentID: '',
  GradeID: '',
  ReportsToPositionID: '',
  MinExperience: '',
  MinEducation: '',
  PositionDescription: '',
  Responsibilities: '',
  Qualifications: '',
  Skills: '',
  IsManagement: 0,
  HeadcountLimit: '',
  CurrentHeadcount: null,
  IsApprover: 0,
  ApprovalLevel: '',
  IsActive: '1',
  CreatedBy: '',
  UpdatedBy: '',
})

onMounted(fetchAll)

async function fetchAll() {
  await Promise.all([fetchPositions(), fetchDepartments(), fetchGrades(), fetchUsers()])
  filterPositions()
  await nextTick(drawApexChart)
}
async function fetchPositions() {
  try {
    const res = await fetch(`${API}/Positions`, { headers: { Authorization: AUTH } })
    if (!res.ok) throw new Error('Failed to fetch Positions')
    const out = await res.json()
    positions.value = out.records || []
    analytics.total = positions.value.length
    analytics.active = positions.value.filter((p) => p.IsActive === '1').length
    analytics.inactive = positions.value.filter((p) => p.IsActive !== '1').length
    analytics.management = positions.value.filter((p) => p.IsManagement === '1').length
  } catch (e) {
    positions.value = []
  }
}
async function fetchDepartments() {
  try {
    const res = await fetch(`${API}/Departments`, { headers: { Authorization: AUTH } })
    if (!res.ok) throw new Error('Failed to fetch Departments')
    departments.value = (await res.json()).records || []
  } catch (e) {
    departments.value = []
  }
}
async function fetchGrades() {
  try {
    const res = await fetch(`${API}/Grades`, { headers: { Authorization: AUTH } })
    if (!res.ok) throw new Error('Failed to fetch Grades')
    grades.value = (await res.json()).records || []
  } catch (e) {
    grades.value = []
  }
}
async function fetchUsers() {
  try {
    const res = await fetch(`${API}/Users`, { headers: { Authorization: AUTH } })
    if (!res.ok) throw new Error('Failed to fetch Users')
    users.value = (await res.json()).records || []
  } catch (e) {
    users.value = []
  }
}
function filterPositions() {
  filteredPositions.value = positions.value.filter((p) => {
    const term = searchTerm.value.toLowerCase()
    return (
      p.PositionCode?.toLowerCase().includes(term) || p.PositionTitle?.toLowerCase().includes(term)
    )
  })
}
function openModal(pos = null) {
  if (pos) {
    Object.assign(form, pos)
    formMode.value = 'edit'
  } else {
    Object.assign(form, {
      PositionID: null,
      PositionCode: '',
      PositionTitle: '',
      DepartmentID: '',
      GradeID: '',
      ReportsToPositionID: '',
      MinExperience: '',
      MinEducation: '',
      PositionDescription: '',
      Responsibilities: '',
      Qualifications: '',
      Skills: '',
      IsManagement: 0,
      HeadcountLimit: '',
      CurrentHeadcount: null,
      IsApprover: 0,
      ApprovalLevel: '',
      IsActive: '1',
      CreatedBy: '',
      UpdatedBy: '',
    })
    formMode.value = 'create'
  }
  showModal.value = true
}
function closeModal() {
  showModal.value = false
}
async function handleSubmit() {
  const data = { ...form }
  if (formMode.value === 'create') {
    const res = await fetch(`${API}/Positions`, {
      method: 'POST',
      headers: { Authorization: AUTH, 'Content-Type': 'application/json' },
      body: JSON.stringify({ ...data, PositionID: null }),
    })
    if (res.ok) {
      closeModal()
      await fetchAll()
    } else alert('Failed to create position')
  } else {
    const res = await fetch(`${API}/Positions/${form.PositionID}`, {
      method: 'PATCH',
      headers: { Authorization: AUTH, 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    })
    if (res.ok) {
      closeModal()
      await fetchAll()
    } else alert('Failed to update position')
  }
}
async function deletePosition() {
  if (!form.PositionID || !confirm('Delete this position?')) return
  const res = await fetch(`${API}/Positions/${form.PositionID}`, {
    method: 'DELETE',
    headers: { Authorization: AUTH },
  })
  if (res.ok) {
    closeModal()
    await fetchAll()
  } else alert('Failed to delete position')
}
function getDeptName(id) {
  const d = departments.value.find((d) => d.DepartmentID == id)
  return d ? d.DepartmentName : ''
}
function getGradeName(id) {
  const g = grades.value.find((g) => g.GradeID == id)
  return g ? `${g.GradeCode} - ${g.GradeName}` : ''
}

function drawApexChart() {
  if (!window.ApexCharts) return
  const group = {}
  positions.value.forEach((p) => {
    const dName = getDeptName(p.DepartmentID)
    const gName = getGradeName(p.GradeID)
    if (!group[dName]) group[dName] = {}
    if (!group[dName][gName]) group[dName][gName] = 0
    group[dName][gName]++
  })
  const categories = Array.from(new Set(Object.values(group).flatMap((o) => Object.keys(o))))
  const series = Object.entries(group).map(([dept, obj]) => ({
    name: dept,
    data: categories.map((c) => obj[c] || 0),
  }))
  const options = {
    chart: { type: 'bar', height: 300, stacked: true },
    plotOptions: { bar: { horizontal: false } },
    xaxis: { categories },
    series,
    legend: { position: 'top' },
  }
  try {
    const chartEl = document.querySelector('#positions-apexchart')
    if (chartEl) {
      if (chartEl._apexcharts) chartEl._apexcharts.destroy()
      const ch = new window.ApexCharts(chartEl, options)
      ch.render()
      chartEl._apexcharts = ch
    }
  } catch (e) {}
}
</script>

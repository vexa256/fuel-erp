<template>
  <div class="d-flex flex-column gap-6 py-4 px-2 bg-light min-vh-100">
    <!-- Header with AI Advice -->
    <div class="card card-flush border-0 shadow-sm bg-light-primary">
      <div
        class="card-body p-5 d-flex flex-column flex-md-row align-items-center justify-content-between gap-3"
      >
        <div>
          <div class="fs-1 fw-bold text-dark d-flex align-items-center mb-1">
            <i class="ki-duotone ki-organization fs-2hx text-success me-3"
              ><span class="path1"></span><span class="path2"></span><span class="path3"></span
            ></i>
            Departments Management
          </div>
          <div class="fs-5 text-gray-600 mb-2">
            Manage and optimize your organizational structure.
          </div>
          <div class="badge badge-light-info">
            <i class="ki-duotone ki-brain fs-2 me-2"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            <span>{{ aiAdvice }}</span>
          </div>
        </div>
        <div>
          <button @click="openDepartmentModal()" class="btn btn-light-success btn-lg fw-bold">
            <i class="ki-duotone ki-plus fs-2"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            New Department
          </button>
        </div>
      </div>
    </div>

    <!-- Search and Stats -->
    <div class="card card-flush">
      <div class="card-header align-items-center py-4 gap-2 gap-md-5">
        <div class="card-title">
          <div class="d-flex align-items-center position-relative my-1">
            <i class="ki-duotone ki-magnifier fs-3 position-absolute ms-4"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            <input
              v-model="searchTerm"
              type="text"
              class="form-control form-control-solid w-250px ps-12"
              placeholder="Search departments by name or code..."
            />
          </div>
        </div>
        <div class="card-toolbar gap-4">
          <div class="bg-white rounded p-2 px-4 shadow-sm text-center">
            <div class="fs-3 fw-bold text-success">{{ stats.total }}</div>
            <div class="fs-8 text-gray-600">Total</div>
          </div>
          <div class="bg-white rounded p-2 px-4 shadow-sm text-center">
            <div class="fs-3 fw-bold text-primary">{{ stats.active }}</div>
            <div class="fs-8 text-gray-600">Active</div>
          </div>
          <div class="bg-white rounded p-2 px-4 shadow-sm text-center">
            <div class="fs-3 fw-bold text-warning">{{ stats.withManagers }}</div>
            <div class="fs-8 text-gray-600">With Managers</div>
          </div>
          <div class="bg-white rounded p-2 px-4 shadow-sm text-center">
            <div class="fs-3 fw-bold text-info">{{ stats.parentDepts }}</div>
            <div class="fs-8 text-gray-600">Root</div>
          </div>
        </div>
      </div>
      <!-- AI Suggestion Panel -->
      <div class="alert bg-light-info border-0 py-3 px-5 mb-0 d-flex align-items-center gap-4">
        <i class="ki-duotone ki-light-bulb fs-2hx text-info"
          ><span class="path1"></span><span class="path2"></span
        ></i>
        <div>
          <span class="fw-bold">AI Suggestion:</span>
          <span>{{ aiSuggestion }}</span>
        </div>
      </div>
    </div>

    <!-- Departments Table -->
    <div class="card card-flush">
      <div class="card-body pt-0">
        <div class="table-responsive">
          <table class="table align-middle table-row-dashed fs-6 gy-4">
            <thead>
              <tr class="text-start text-gray-500 fw-bold fs-7 text-uppercase gs-0">
                <th>Code</th>
                <th>Name</th>
                <th>Manager</th>
                <th>Parent Dept</th>
                <th>Status</th>
                <th class="text-end">Actions</th>
              </tr>
            </thead>
            <tbody class="fw-semibold text-gray-600">
              <tr v-for="dept in filteredDepartments" :key="dept.DepartmentID">
                <td>
                  <span class="badge badge-light-success fw-bold">{{ dept.DepartmentCode }}</span>
                </td>
                <td class="fw-bold text-gray-800">{{ dept.DepartmentName }}</td>
                <td>
                  <span v-if="dept.ManagerUserID">
                    <span class="badge badge-light-primary">
                      <i class="ki-duotone ki-user fs-5 me-1"
                        ><span class="path1"></span><span class="path2"></span
                      ></i>
                      {{ userName(dept.ManagerUserID) }}
                    </span>
                  </span>
                  <span v-else class="text-muted">No Manager</span>
                </td>
                <td>
                  <span v-if="dept.ParentDepartmentID" class="badge badge-light-info">
                    {{ parentName(dept.ParentDepartmentID) }}
                  </span>
                  <span v-else class="text-muted">Root</span>
                </td>
                <td>
                  <span
                    :class="
                      dept.IsActive === '1'
                        ? 'badge badge-light-success'
                        : 'badge badge-light-danger'
                    "
                  >
                    {{ dept.IsActive === '1' ? 'Active' : 'Inactive' }}
                  </span>
                </td>
                <td class="text-end">
                  <button
                    @click="openDepartmentModal(dept)"
                    class="btn btn-icon btn-light-primary btn-sm me-2"
                  >
                    <i class="ki-duotone ki-pencil fs-5"
                      ><span class="path1"></span><span class="path2"></span
                    ></i>
                  </button>
                  <button
                    @click="deleteDepartment(dept)"
                    class="btn btn-icon btn-light-danger btn-sm"
                  >
                    <i class="ki-duotone ki-trash fs-5"
                      ><span class="path1"></span><span class="path2"></span
                      ><span class="path3"></span
                    ></i>
                  </button>
                </td>
              </tr>
              <tr v-if="filteredDepartments.length === 0">
                <td colspan="6" class="text-center text-muted py-10">
                  <i class="ki-duotone ki-search-list fs-3x text-gray-300 mb-3"
                    ><span class="path1"></span><span class="path2"></span
                    ><span class="path3"></span
                  ></i>
                  <div>No departments found</div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Department Modal -->
    <div
      v-if="showModal"
      class="modal fade show d-block"
      style="background-color: rgba(0, 0, 0, 0.5); z-index: 1060"
    >
      <div class="modal-dialog modal-dialog-centered mw-650px">
        <div class="modal-content">
          <div class="modal-header">
            <h2 class="fw-bold">{{ editing ? 'Edit' : 'New' }} Department</h2>
            <button @click="showModal = false" class="btn btn-icon btn-sm btn-active-light-primary">
              <i class="ki-duotone ki-cross fs-1"
                ><span class="path1"></span><span class="path2"></span
              ></i>
            </button>
          </div>
          <div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
            <form @submit.prevent="saveDepartment" novalidate>
              <div class="row g-5">
                <div class="col-12 col-md-6">
                  <label class="required form-label">Department Code</label>
                  <input
                    v-model="form.DepartmentCode"
                    type="text"
                    class="form-control form-control-lg"
                    required
                  />
                </div>
                <div class="col-12 col-md-6">
                  <label class="required form-label">Department Name</label>
                  <input
                    v-model="form.DepartmentName"
                    type="text"
                    class="form-control form-control-lg"
                    required
                  />
                </div>
                <div class="col-12 col-md-6">
                  <label class="form-label">Parent Department</label>
                  <select v-model="form.ParentDepartmentID" class="form-select form-select-lg">
                    <option :value="null">None (Root Department)</option>
                    <option
                      v-for="dept in parentDepts"
                      :key="dept.DepartmentID"
                      :value="dept.DepartmentID"
                    >
                      {{ dept.DepartmentName }}
                    </option>
                  </select>
                </div>
                <div class="col-12 col-md-6">
                  <label class="form-label">Department Manager</label>
                  <select v-model="form.ManagerUserID" class="form-select form-select-lg">
                    <option :value="null">No Manager</option>
                    <option v-for="user in users" :key="user.id" :value="user.id">
                      {{ user.name }}
                    </option>
                  </select>
                </div>
                <div class="col-12">
                  <label class="form-label">Status</label>
                  <select v-model="form.IsActive" class="form-select form-select-lg">
                    <option value="1">Active</option>
                    <option value="0">Inactive</option>
                  </select>
                </div>
                <div class="col-12">
                  <label class="form-label">Description</label>
                  <textarea
                    v-model="form.Description"
                    class="form-control form-control-lg"
                    rows="3"
                  ></textarea>
                </div>
              </div>
            </form>
            <div class="alert bg-light-warning mt-5">
              <i class="ki-duotone ki-alert-triangle fs-2 text-warning me-3"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              <span>{{ modalAIAdvice }}</span>
            </div>
          </div>
          <div class="modal-footer">
            <button @click="showModal = false" class="btn btn-light me-3">Cancel</button>
            <button @click="saveDepartment" class="btn btn-success" :disabled="loading">
              <span v-if="loading" class="spinner-border spinner-border-sm me-2"></span>
              {{ editing ? 'Update' : 'Create' }} Department
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

// --- CONFIG ---
const API_BASE_URL = 'http://localhost:4000/api/records/v1'
const JWT_TOKEN = localStorage.getItem('jwt') || 'your-jwt-token'

// --- STATE ---
const departments = ref([])
const users = ref([])
const loading = ref(false)
const showModal = ref(false)
const editing = ref(false)
const form = ref({
  DepartmentName: '',
  DepartmentCode: '',
  ParentDepartmentID: null,
  ManagerUserID: null,
  Description: '',
  IsActive: '1',
})
const searchTerm = ref('')

// --- Aggressive AI-like Guidance ---
const aiAdvices = [
  'Assigning a manager improves responsibility and communication.',
  'Always provide clear codes and names for easier navigation and reporting.',
  'Keep the department tree shallow for agility. Too many parent-child levels can reduce speed of operations.',
  'Inactive departments cannot be assigned to new users or operations.',
  'Consider setting a manager for each department for best accountability.',
]
const aiAdvice = computed(() => aiAdvices[Math.floor(Math.random() * aiAdvices.length)])

const aiSuggestions = [
  'Most organizations function best with fewer than 5 root (parent-less) departments.',
  'Regularly review and update department managers.',
  'Frequent changes to the hierarchy may confuse staff; maintain stability when possible.',
  'Use department descriptions for internal knowledge sharing.',
  'Avoid code duplication — unique codes are critical for integrations and reporting.',
]
const aiSuggestion = computed(() => aiSuggestions[Math.floor(Math.random() * aiSuggestions.length)])

const modalAIAdvice = computed(() => {
  if (!form.value.DepartmentName || !form.value.DepartmentCode)
    return 'Fill in all required fields. Departments without a code or name cause system issues.'
  if (!form.value.ManagerUserID)
    return 'AI Note: Assigning a manager ensures accountability and efficient workflow.'
  if (form.value.IsActive === '0')
    return 'AI Warning: Inactive departments cannot be assigned new tasks. Only deactivate if you are certain.'
  return 'All looks good. Double-check before saving for audit compliance.'
})

// --- Fetchers ---
const makeRequest = async (endpoint, opts = {}) => {
  try {
    const res = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...opts,
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        ...(opts.headers || {}),
      },
    })
    if (!res.ok) throw new Error((await res.json().catch(() => ({}))).message || res.statusText)
    return await res.json()
  } catch (e) {
    Swal.fire({ title: 'API Error', text: e.message, icon: 'error', confirmButtonColor: '#f1416c' })
    throw e
  }
}
const fetchDepartments = async () => {
  loading.value = true
  try {
    departments.value = (await makeRequest('/Departments')).records || []
  } finally {
    loading.value = false
  }
}
const fetchUsers = async () => {
  loading.value = true
  try {
    users.value = (await makeRequest('/users')).records || []
  } finally {
    loading.value = false
  }
}
onMounted(() => {
  fetchDepartments()
  fetchUsers()
})

// --- CRUD ---
function openDepartmentModal(dept = null) {
  editing.value = !!dept
  if (dept) form.value = { ...dept }
  else
    form.value = {
      DepartmentName: '',
      DepartmentCode: '',
      ParentDepartmentID: null,
      ManagerUserID: null,
      Description: '',
      IsActive: '1',
    }
  showModal.value = true
}
async function saveDepartment() {
  if (!form.value.DepartmentName || !form.value.DepartmentCode) {
    Swal.fire({
      title: 'Validation Error!',
      text: 'Please fill in all required fields',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }
  loading.value = true
  try {
    if (editing.value && form.value.DepartmentID) {
      await makeRequest(`/Departments/${form.value.DepartmentID}`, {
        method: 'PATCH',
        body: JSON.stringify(form.value),
      })
    } else {
      await makeRequest('/Departments', { method: 'POST', body: JSON.stringify(form.value) })
    }
    showModal.value = false
    await fetchDepartments()
    Swal.fire({
      title: 'Success!',
      text: `Department ${editing.value ? 'updated' : 'created'} successfully`,
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
async function deleteDepartment(dept) {
  const result = await Swal.fire({
    title: 'Are you sure?',
    text: `Delete department "${dept.DepartmentName}"?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
  })
  if (result.isConfirmed) {
    loading.value = true
    try {
      await makeRequest(`/Departments/${dept.DepartmentID}`, { method: 'DELETE' })
      await fetchDepartments()
      Swal.fire({
        title: 'Deleted!',
        text: 'Department has been deleted',
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

// --- Table UI helpers ---
const filteredDepartments = computed(() => {
  if (!searchTerm.value) return departments.value
  return departments.value.filter(
    (dept) =>
      dept.DepartmentName?.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
      dept.DepartmentCode?.toLowerCase().includes(searchTerm.value.toLowerCase()),
  )
})
const stats = computed(() => ({
  total: departments.value.length,
  active: departments.value.filter((d) => d.IsActive === '1').length,
  withManagers: departments.value.filter((d) => d.ManagerUserID).length,
  parentDepts: departments.value.filter((d) => !d.ParentDepartmentID).length,
}))
const parentDepts = computed(() =>
  departments.value.filter((d) => !editing.value || d.DepartmentID !== form.value.DepartmentID),
)
function userName(userId) {
  const u = users.value.find((u) => u.id == userId)
  return u ? u.name : 'Unknown'
}
function parentName(parentId) {
  const p = departments.value.find((d) => d.DepartmentID == parentId)
  return p ? p.DepartmentName : 'Unknown'
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
.alert.bg-light-info,
.alert.bg-light-warning {
  border-radius: 1.2rem;
}
</style>

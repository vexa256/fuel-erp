<template>
  <div class="d-flex flex-column gap-5 p-5">
    <!-- Header Section -->
    <div class="card card-flush">
      <div class="card-header bg-light-primary">
        <h3 class="card-title fw-bold text-primary fs-2">
          <i class="ki-duotone ki-people fs-1 text-primary me-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
            <span class="path5"></span>
          </i>
          User Role & Station Management
        </h3>
        <div class="card-toolbar">
          <button @click="refreshData" class="btn btn-light-success btn-lg" :disabled="loading">
            <i class="ki-duotone ki-arrows-circle fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            Refresh
          </button>
        </div>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-5">
      <div class="col-12 col-md-3">
        <div class="card card-flush bg-light-success">
          <div class="card-body text-center py-8">
            <i class="ki-duotone ki-user-tick fs-2x text-success mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <div class="fw-bold fs-2 text-success">{{ totalUsers }}</div>
            <div class="fw-semibold fs-6 text-gray-600">Total Users</div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-3">
        <div class="card card-flush bg-light-warning">
          <div class="card-body text-center py-8">
            <i class="ki-duotone ki-security-user fs-2x text-warning mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <div class="fw-bold fs-2 text-warning">{{ totalRoles }}</div>
            <div class="fw-semibold fs-6 text-gray-600">Available Roles</div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-3">
        <div class="card card-flush bg-light-info">
          <div class="card-body text-center py-8">
            <i class="ki-duotone ki-shop fs-2x text-info mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
              <span class="path4"></span>
              <span class="path5"></span>
            </i>
            <div class="fw-bold fs-2 text-info">{{ totalStations }}</div>
            <div class="fw-semibold fs-6 text-gray-600">Stations</div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-3">
        <div class="card card-flush bg-light-danger">
          <div class="card-body text-center py-8">
            <i class="ki-duotone ki-chart-line-up fs-2x text-danger mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <div class="fw-bold fs-2 text-danger">{{ usersWithAssignments }}</div>
            <div class="fw-semibold fs-6 text-gray-600">Users with Assignments</div>
          </div>
        </div>
      </div>
    </div>

    <!-- User Selection -->
    <div class="card card-flush">
      <div class="card-header bg-light-info">
        <h4 class="card-title fw-bold text-info fs-3">
          <i class="ki-duotone ki-user fs-1 text-info me-2">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          Select User
        </h4>
      </div>
      <div class="card-body">
        <div class="row g-5">
          <div class="col-12">
            <label class="form-label fw-bold fs-6">Choose User to Manage</label>
            <select
              v-model="selectedUserId"
              @change="loadUserAssignments"
              class="form-select form-select-lg"
            >
              <option value="">-- Select User --</option>
              <option v-for="user in users" :key="user.id" :value="user.id">
                {{ user.name }} ({{ user.email }}) - {{ user.Role }}
              </option>
            </select>
          </div>
        </div>
      </div>
    </div>

    <div v-if="selectedUserId" class="row g-5">
      <!-- Role Management -->
      <div class="col-12 col-lg-6">
        <div class="card card-flush h-100">
          <div class="card-header bg-light-success">
            <h4 class="card-title fw-bold text-success fs-3">
              <i class="ki-duotone ki-security-user fs-1 text-success me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Role Management
            </h4>
          </div>
          <div class="card-body">
            <!-- Current Role Display -->
            <div class="mb-8">
              <label class="form-label fw-bold fs-6 text-success">Current Role Assignment</label>
              <div v-if="!currentUserRole" class="alert alert-light-warning">
                <i class="ki-duotone ki-information fs-2x text-warning me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div class="text-warning fw-semibold">No role currently assigned to this user</div>
              </div>
              <div
                v-else
                class="d-flex align-items-center justify-content-between p-4 border border-success rounded bg-light-success"
              >
                <div class="d-flex align-items-center">
                  <span class="badge badge-success fs-7 fw-bold me-3">{{
                    getRoleName(currentUserRole.RoleID)
                  }}</span>
                  <span class="text-gray-600 fs-7"
                    >Assigned: {{ formatDate(currentUserRole.AssignedDate) }}</span
                  >
                </div>
                <button @click="revokeRole" class="btn btn-light-danger btn-sm" :disabled="loading">
                  <i class="ki-duotone ki-cross fs-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Revoke
                </button>
              </div>
            </div>

            <!-- Assign New Role -->
            <div v-if="!currentUserRole">
              <label class="form-label fw-bold fs-6 text-success">Assign Role</label>
              <div class="d-flex gap-3">
                <select v-model="newRoleId" class="form-select form-select-lg">
                  <option value="">-- Select Role --</option>
                  <option v-for="role in roles" :key="role.RoleID" :value="role.RoleID">
                    {{ role.RoleName }}
                  </option>
                </select>
                <button
                  @click="assignRole"
                  :disabled="!newRoleId || loading"
                  class="btn btn-success btn-lg"
                >
                  <i class="ki-duotone ki-plus fs-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Assign
                </button>
              </div>
            </div>
            <div v-else class="alert alert-light-info">
              <i class="ki-duotone ki-information fs-2x text-info me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div class="text-info fw-semibold">
                Each user can only have one role. Revoke current role to assign a new one.
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Station Management -->
      <div class="col-12 col-lg-6">
        <div class="card card-flush h-100">
          <div class="card-header bg-light-warning">
            <h4 class="card-title fw-bold text-warning fs-3">
              <i class="ki-duotone ki-shop fs-1 text-warning me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
                <span class="path5"></span>
              </i>
              Station Assignment
            </h4>
          </div>
          <div class="card-body">
            <!-- Current Station Display -->
            <div class="mb-8">
              <label class="form-label fw-bold fs-6 text-warning">Current Station Assignment</label>
              <div v-if="!currentUserStation" class="alert alert-light-warning">
                <i class="ki-duotone ki-information fs-2x text-warning me-3">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div class="text-warning fw-semibold">
                  No station currently assigned to this user
                </div>
              </div>
              <div
                v-else
                class="d-flex align-items-center justify-content-between p-4 border border-warning rounded bg-light-warning"
              >
                <div class="d-flex flex-column">
                  <div class="d-flex align-items-center mb-2">
                    <span class="fw-bold text-gray-800 me-3">{{
                      getStationName(currentUserStation.StationID)
                    }}</span>
                    <span v-if="currentUserStation.IsPrimary === '1'" class="badge badge-primary"
                      >Primary</span
                    >
                  </div>
                  <span class="text-gray-600 fs-7">Status: {{ currentUserStation.Status }}</span>
                  <span class="text-gray-600 fs-7"
                    >Assigned: {{ formatDate(currentUserStation.AssignedDate) }}</span
                  >
                </div>
                <button
                  @click="removeStationAssignment"
                  class="btn btn-light-danger btn-sm"
                  :disabled="loading"
                >
                  <i class="ki-duotone ki-cross fs-3">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Remove
                </button>
              </div>
            </div>

            <!-- Assign New Station -->
            <div v-if="!currentUserStation">
              <label class="form-label fw-bold fs-6 text-warning">Assign Station</label>
              <div class="row g-3">
                <div class="col-12">
                  <select
                    v-model="newStationAssignment.StationID"
                    class="form-select form-select-lg"
                  >
                    <option value="">-- Select Station --</option>
                    <option
                      v-for="station in stations"
                      :key="station.StationID"
                      :value="station.StationID"
                    >
                      {{ station.StationName }} - {{ station.Location }}
                    </option>
                  </select>
                </div>
                <div class="col-6">
                  <div class="form-check form-switch">
                    <input
                      v-model="newStationAssignment.IsPrimary"
                      class="form-check-input"
                      type="checkbox"
                      id="isPrimary"
                    />
                    <label class="form-check-label fw-semibold" for="isPrimary"
                      >Primary Station</label
                    >
                  </div>
                </div>
                <div class="col-6">
                  <button
                    @click="assignStation"
                    :disabled="!newStationAssignment.StationID || loading"
                    class="btn btn-warning btn-lg w-100"
                  >
                    <i class="ki-duotone ki-plus fs-2">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    Assign
                  </button>
                </div>
              </div>
            </div>
            <div v-else class="alert alert-light-info">
              <i class="ki-duotone ki-information fs-2x text-info me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <div class="text-info fw-semibold">
                Each user can only be assigned to one station. Remove current assignment to assign a
                new one.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Assignment Summary Chart -->
    <div v-if="selectedUserId" class="card card-flush">
      <div class="card-header bg-light-primary">
        <h4 class="card-title fw-bold text-primary fs-3">
          <i class="ki-duotone ki-chart-pie-3 fs-1 text-primary me-2">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
          </i>
          Assignment Overview
        </h4>
      </div>
      <div class="card-body">
        <div class="row g-5">
          <div class="col-12 col-md-6">
            <div class="card bg-light-success">
              <div class="card-body text-center py-6">
                <h6 class="fw-bold text-success mb-3">Role Assignment Status</h6>
                <div class="d-flex justify-content-center align-items-center">
                  <div class="symbol symbol-100px symbol-circle bg-success">
                    <span class="fs-2x fw-bold text-white">{{ currentUserRole ? '1' : '0' }}</span>
                  </div>
                </div>
                <div class="mt-3 text-gray-600">
                  {{ currentUserRole ? 'Role Assigned' : 'No Role Assigned' }}
                </div>
                <div class="progress mt-3">
                  <div
                    class="progress-bar bg-success"
                    :style="`width: ${currentUserRole ? 100 : 0}%`"
                  ></div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-12 col-md-6">
            <div class="card bg-light-warning">
              <div class="card-body text-center py-6">
                <h6 class="fw-bold text-warning mb-3">Station Assignment Status</h6>
                <div class="d-flex justify-content-center align-items-center">
                  <div class="symbol symbol-100px symbol-circle bg-warning">
                    <span class="fs-2x fw-bold text-white">{{
                      currentUserStation ? '1' : '0'
                    }}</span>
                  </div>
                </div>
                <div class="mt-3 text-gray-600">
                  {{ currentUserStation ? 'Station Assigned' : 'No Station Assigned' }}
                </div>
                <div class="progress mt-3">
                  <div
                    class="progress-bar bg-warning"
                    :style="`width: ${currentUserStation ? 100 : 0}%`"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- System Summary -->
    <div class="card card-flush">
      <div class="card-header bg-light-dark">
        <h4 class="card-title fw-bold text-dark fs-3">
          <i class="ki-duotone ki-element-11 fs-1 text-dark me-2">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
          </i>
          System Assignment Summary
        </h4>
      </div>
      <div class="card-body">
        <div class="row g-5">
          <div class="col-12 col-md-4">
            <div class="text-center">
              <div class="fs-2 fw-bold text-primary">
                {{ assignmentStats.roleAssignmentPercentage }}%
              </div>
              <div class="text-gray-600">Users with Roles</div>
              <div class="progress mt-2">
                <div
                  class="progress-bar bg-primary"
                  :style="`width: ${assignmentStats.roleAssignmentPercentage}%`"
                ></div>
              </div>
            </div>
          </div>
          <div class="col-12 col-md-4">
            <div class="text-center">
              <div class="fs-2 fw-bold text-success">
                {{ assignmentStats.stationAssignmentPercentage }}%
              </div>
              <div class="text-gray-600">Users with Stations</div>
              <div class="progress mt-2">
                <div
                  class="progress-bar bg-success"
                  :style="`width: ${assignmentStats.stationAssignmentPercentage}%`"
                ></div>
              </div>
            </div>
          </div>
          <div class="col-12 col-md-4">
            <div class="text-center">
              <div class="fs-2 fw-bold text-warning">
                {{ assignmentStats.fullyAssignedPercentage }}%
              </div>
              <div class="text-gray-600">Fully Assigned Users</div>
              <div class="progress mt-2">
                <div
                  class="progress-bar bg-warning"
                  :style="`width: ${assignmentStats.fullyAssignedPercentage}%`"
                ></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import Swal from 'sweetalert2'

const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN = localStorage.getItem('jwt') || ''

const loading = ref(false)
const selectedUserId = ref('')

// Data arrays
const users = ref([])
const roles = ref([])
const stations = ref([])
const allUserRoles = ref([])
const allUserStations = ref([])

// Form data
const newRoleId = ref('')
const newStationAssignment = ref({
  StationID: '',
  IsPrimary: false,
})

// Computed properties for stats
const totalUsers = computed(() => users.value?.length || 0)
const totalRoles = computed(() => roles.value?.length || 0)
const totalStations = computed(() => stations.value?.length || 0)
const usersWithAssignments = computed(() => {
  const usersWithRoles = new Set(allUserRoles.value.map((ur) => ur.UserID))
  const usersWithStations = new Set(allUserStations.value.map((us) => us.UserID))
  const allAssigned = new Set([...usersWithRoles, ...usersWithStations])
  return allAssigned.size
})

// Current user's single role and station
const currentUserRole = computed(() => {
  return allUserRoles.value.find((ur) => ur.UserID === parseInt(selectedUserId.value)) || null
})

const currentUserStation = computed(() => {
  return allUserStations.value.find((us) => us.UserID === parseInt(selectedUserId.value)) || null
})

// Assignment statistics
const assignmentStats = computed(() => {
  const totalUsers = users.value?.length || 0
  if (totalUsers === 0) {
    return {
      roleAssignmentPercentage: 0,
      stationAssignmentPercentage: 0,
      fullyAssignedPercentage: 0,
    }
  }

  const usersWithRoles = new Set(allUserRoles.value.map((ur) => ur.UserID))
  const usersWithStations = new Set(allUserStations.value.map((us) => us.UserID))
  const fullyAssigned = [...usersWithRoles].filter((userId) => usersWithStations.has(userId))

  return {
    roleAssignmentPercentage: Math.round((usersWithRoles.size / totalUsers) * 100),
    stationAssignmentPercentage: Math.round((usersWithStations.size / totalUsers) * 100),
    fullyAssignedPercentage: Math.round((fullyAssigned.length / totalUsers) * 100),
  }
})

// API Functions
const makeApiCall = async (url, options = {}) => {
  try {
    const response = await fetch(`${API_BASE_URL}${url}`, {
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      const errorData = await response.text()
      throw new Error(`API Error: ${response.status} - ${errorData}`)
    }

    // Handle DELETE responses that may not be JSON
    if (options.method === 'DELETE') {
      const contentType = response.headers.get('content-type')
      if (contentType && contentType.includes('application/json')) {
        return await response.json()
      } else {
        return { success: true }
      }
    }

    return await response.json()
  } catch (error) {
    console.error('API Error:', error)
    throw error
  }
}

const fetchUsers = async () => {
  try {
    const data = await makeApiCall('/users')
    users.value = data.records || []
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load users',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
}

const fetchRoles = async () => {
  try {
    const data = await makeApiCall('/Roles')
    roles.value = data.records || []
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load roles',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
}

const fetchStations = async () => {
  try {
    const data = await makeApiCall('/Stations')
    stations.value = data.records || []
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to load stations',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
}

const fetchAllUserRoles = async () => {
  try {
    const data = await makeApiCall('/UserRoles')
    allUserRoles.value = data.records || []
  } catch (error) {
    console.error('Failed to load user roles:', error)
  }
}

const fetchAllUserStations = async () => {
  try {
    const data = await makeApiCall('/UserStations')
    allUserStations.value = data.records || []
  } catch (error) {
    console.error('Failed to load user stations:', error)
  }
}

const loadUserAssignments = async () => {
  // Data is already loaded in allUserRoles and allUserStations
  // The computed properties will handle filtering for the selected user
}

const assignRole = async () => {
  if (!selectedUserId.value || !newRoleId.value) return

  loading.value = true
  try {
    await makeApiCall('/UserRoles', {
      method: 'POST',
      body: JSON.stringify({
        UserID: parseInt(selectedUserId.value),
        RoleID: parseInt(newRoleId.value),
        AssignedDate: new Date().toISOString(),
        IsActive: '1',
      }),
    })

    Swal.fire({
      title: 'Success!',
      text: 'Role assigned successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    newRoleId.value = ''
    await fetchAllUserRoles()
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to assign role',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const revokeRole = async () => {
  const result = await Swal.fire({
    title: 'Confirm Revoke',
    text: 'Are you sure you want to revoke this role?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#6c757d',
    confirmButtonText: 'Yes, revoke it!',
  })

  if (!result.isConfirmed) return

  loading.value = true
  try {
    // Use the UserID to delete the role assignment
    await makeApiCall(`/UserRoles/${selectedUserId.value}`, {
      method: 'DELETE',
    })

    Swal.fire({
      title: 'Success!',
      text: 'Role revoked successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    await fetchAllUserRoles()
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to revoke role',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const assignStation = async () => {
  if (!selectedUserId.value || !newStationAssignment.value.StationID) return

  loading.value = true
  try {
    await makeApiCall('/UserStations', {
      method: 'POST',
      body: JSON.stringify({
        UserID: parseInt(selectedUserId.value),
        StationID: parseInt(newStationAssignment.value.StationID),
        IsPrimary: newStationAssignment.value.IsPrimary ? '1' : '0',
        AssignedDate: new Date().toISOString().split('T')[0],
        Status: 'Active',
      }),
    })

    Swal.fire({
      title: 'Success!',
      text: 'Station assigned successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    newStationAssignment.value = { StationID: '', IsPrimary: false }
    await fetchAllUserStations()
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to assign station',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const removeStationAssignment = async () => {
  const result = await Swal.fire({
    title: 'Confirm Removal',
    text: 'Are you sure you want to remove this station assignment?',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#6c757d',
    confirmButtonText: 'Yes, remove it!',
  })

  if (!result.isConfirmed) return

  loading.value = true
  try {
    // Use the UserID to delete the station assignment
    await makeApiCall(`/UserStations/${selectedUserId.value}`, {
      method: 'DELETE',
    })

    Swal.fire({
      title: 'Success!',
      text: 'Station assignment removed successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    await fetchAllUserStations()
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: 'Failed to remove station assignment',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([
      fetchUsers(),
      fetchRoles(),
      fetchStations(),
      fetchAllUserRoles(),
      fetchAllUserStations(),
    ])
  } finally {
    loading.value = false
  }
}

// Helper functions
const getRoleName = (roleId) => {
  const role = roles.value.find((r) => r.RoleID === roleId)
  return role ? role.RoleName : 'Unknown Role'
}

const getStationName = (stationId) => {
  const station = stations.value.find((s) => s.StationID === stationId)
  return station ? station.StationName : 'Unknown Station'
}

const formatDate = (dateString) => {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleDateString()
}

// Lifecycle
onMounted(() => {
  refreshData()
})
</script>

<style scoped>
.symbol {
  display: flex;
  align-items: center;
  justify-content: center;
}

.card {
  border: none;
  box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

.card-flush {
  border-radius: 0.75rem;
}

.form-select:focus {
  border-color: #009ef7;
  box-shadow: 0 0 0 0.25rem rgba(0, 158, 247, 0.25);
}

.btn {
  border-radius: 0.625rem;
  font-weight: 600;
}

.badge {
  border-radius: 0.5rem;
}

.progress {
  height: 8px;
  border-radius: 0.5rem;
}

.progress-bar {
  border-radius: 0.5rem;
}

.alert {
  border-radius: 0.75rem;
  border: none;
}

@media (max-width: 768px) {
  .card-body {
    padding: 1rem;
  }

  .btn-lg {
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
  }

  .fs-2x {
    font-size: 1.5rem;
  }
}
</style>

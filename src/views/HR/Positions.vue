<template>
  <div class="d-flex flex-column gap-5 gap-md-7">
    <!-- Header Section -->
    <div class="card card-flush bg-light-primary">
      <div class="card-body p-5 p-md-8">
        <div class="d-flex flex-column flex-md-row align-items-start gap-5">
          <div class="flex-grow-1">
            <div class="d-flex align-items-center gap-3 mb-3">
              <i class="ki-duotone ki-badge fs-2x text-primary">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              <h1 class="fs-2x fw-bold text-gray-900 mb-0">Positions Management</h1>
            </div>
            <p class="fs-4 text-gray-700 mb-0">
              Manage organizational structure, job roles, and reporting hierarchy
            </p>
          </div>
          <div class="d-flex flex-column flex-md-row gap-3">
            <button @click="openAddModal" class="btn btn-light-success btn-lg">
              <i class="ki-duotone ki-plus fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Add Position
            </button>
            <button @click="refreshData" class="btn btn-light-primary btn-lg" :disabled="loading">
              <i class="ki-duotone ki-arrows-circle fs-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Refresh
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Analytics Dashboard -->
    <div class="row g-5 g-xl-8">
      <!-- Total Positions Card -->
      <div class="col-xl-3 col-6">
        <div class="card card-flush bg-light-info h-100">
          <div class="card-body d-flex flex-column p-5">
            <div class="d-flex align-items-center gap-3 mb-4">
              <i class="ki-duotone ki-profile-circle fs-2x text-info">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <span class="fs-7 fw-bold text-gray-600 text-uppercase">Total Positions</span>
            </div>
            <span class="fs-2hx fw-bold text-gray-900">{{ analytics.totalPositions }}</span>
            <span class="badge badge-light-success fs-7 fw-bold mt-2"
              >{{ analytics.activePositions }} Active</span
            >
          </div>
        </div>
      </div>

      <!-- Management Positions -->
      <div class="col-xl-3 col-6">
        <div class="card card-flush bg-light-warning h-100">
          <div class="card-body d-flex flex-column p-5">
            <div class="d-flex align-items-center gap-3 mb-4">
              <i class="ki-duotone ki-crown fs-2x text-warning">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <span class="fs-7 fw-bold text-gray-600 text-uppercase">Management</span>
            </div>
            <span class="fs-2hx fw-bold text-gray-900">{{ analytics.managementPositions }}</span>
            <span class="badge badge-light-info fs-7 fw-bold mt-2"
              >{{
                Math.round(
                  (analytics.managementPositions / Math.max(analytics.totalPositions, 1)) * 100,
                )
              }}% of Total</span
            >
          </div>
        </div>
      </div>

      <!-- Approval Positions -->
      <div class="col-xl-3 col-6">
        <div class="card card-flush bg-light-success h-100">
          <div class="card-body d-flex flex-column p-5">
            <div class="d-flex align-items-center gap-3 mb-4">
              <i class="ki-duotone ki-check-square fs-2x text-success">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              <span class="fs-7 fw-bold text-gray-600 text-uppercase">Approvers</span>
            </div>
            <span class="fs-2hx fw-bold text-gray-900">{{ analytics.approverPositions }}</span>
            <span class="badge badge-light-primary fs-7 fw-bold mt-2"
              >{{ analytics.maxApprovalLevel }} Max Level</span
            >
          </div>
        </div>
      </div>

      <!-- Headcount Utilization -->
      <div class="col-xl-3 col-6">
        <div class="card card-flush bg-light-danger h-100">
          <div class="card-body d-flex flex-column p-5">
            <div class="d-flex align-items-center gap-3 mb-4">
              <i class="ki-duotone ki-people fs-2x text-danger">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
                <span class="path5"></span>
              </i>
              <span class="fs-7 fw-bold text-gray-600 text-uppercase">Utilization</span>
            </div>
            <span class="fs-2hx fw-bold text-gray-900">{{ analytics.utilizationRate }}%</span>
            <span class="badge badge-light-warning fs-7 fw-bold mt-2"
              >{{ analytics.totalHeadcount }}/{{ analytics.totalCapacity }}</span
            >
          </div>
        </div>
      </div>
    </div>

    <!-- Charts Section -->
    <div class="row g-5 g-xl-8">
      <!-- Department Distribution Chart -->
      <div class="col-xl-6">
        <div class="card card-flush h-100">
          <div class="card-header">
            <h3 class="card-title text-gray-900 fw-bold">Positions by Department</h3>
          </div>
          <div class="card-body">
            <div class="d-flex flex-column gap-4">
              <div
                v-for="(item, index) in departmentChartData"
                :key="index"
                class="d-flex align-items-center gap-3"
              >
                <div class="symbol symbol-35px">
                  <div
                    class="symbol-label"
                    :style="`background-color: ${chartColors[index % chartColors.length]}`"
                  >
                    <span class="fs-7 fw-bold text-white">{{ item.value }}</span>
                  </div>
                </div>
                <div class="flex-grow-1">
                  <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="fw-bold text-gray-800">{{ item.name }}</span>
                    <span class="fw-bold text-gray-600"
                      >{{ Math.round((item.value / analytics.totalPositions) * 100) }}%</span
                    >
                  </div>
                  <div class="progress h-6px">
                    <div
                      class="progress-bar"
                      :style="`width: ${(item.value / analytics.totalPositions) * 100}%; background-color: ${chartColors[index % chartColors.length]}`"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Grade Distribution Chart -->
      <div class="col-xl-6">
        <div class="card card-flush h-100">
          <div class="card-header">
            <h3 class="card-title text-gray-900 fw-bold">Positions by Grade Level</h3>
          </div>
          <div class="card-body">
            <div class="d-flex flex-column gap-4">
              <div
                v-for="(item, index) in gradeChartData"
                :key="index"
                class="d-flex align-items-center gap-3"
              >
                <div class="symbol symbol-35px">
                  <div
                    class="symbol-label"
                    :style="`background-color: ${chartColors[(index + 3) % chartColors.length]}`"
                  >
                    <span class="fs-7 fw-bold text-white">{{ item.value }}</span>
                  </div>
                </div>
                <div class="flex-grow-1">
                  <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="fw-bold text-gray-800">{{ item.name }}</span>
                    <span class="fw-bold text-gray-600"
                      >{{ Math.round((item.value / analytics.totalPositions) * 100) }}%</span
                    >
                  </div>
                  <div class="progress h-6px">
                    <div
                      class="progress-bar"
                      :style="`width: ${(item.value / analytics.totalPositions) * 100}%; background-color: ${chartColors[(index + 3) % chartColors.length]}`"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Search and Filter Section -->
    <div class="card card-flush">
      <div class="card-header">
        <h3 class="card-title text-gray-900 fw-bold">Position Directory</h3>
        <div class="card-toolbar">
          <div class="d-flex align-items-center gap-3">
            <select v-model="filters.department" class="form-select form-select-sm w-150px">
              <option value="">All Departments</option>
              <option
                v-for="dept in departments"
                :key="dept.DepartmentID"
                :value="dept.DepartmentID"
              >
                {{ dept.DepartmentName }}
              </option>
            </select>
            <select v-model="filters.status" class="form-select form-select-sm w-100px">
              <option value="">All Status</option>
              <option value="1">Active</option>
              <option value="0">Inactive</option>
            </select>
          </div>
        </div>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover table-rounded table-striped border gy-5 gs-7">
            <thead class="bg-light-primary">
              <tr class="fw-bold fs-6 text-gray-800">
                <th class="ps-4">Position</th>
                <th>Department</th>
                <th>Grade</th>
                <th>Type</th>
                <th>Headcount</th>
                <th>Status</th>
                <th class="text-end pe-4">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="position in paginatedPositions"
                :key="position.PositionID"
                class="align-middle"
              >
                <td class="ps-4">
                  <div class="d-flex flex-column">
                    <span class="text-gray-900 fw-bold fs-6">{{ position.PositionTitle }}</span>
                    <span class="text-muted fs-7">{{ position.PositionCode }}</span>
                  </div>
                </td>
                <td>
                  <span class="badge badge-light-info fs-7">{{
                    getDepartmentName(position.DepartmentID)
                  }}</span>
                </td>
                <td>
                  <span class="badge badge-light-warning fs-7">{{
                    getGradeName(position.GradeID)
                  }}</span>
                </td>
                <td>
                  <div class="d-flex gap-2">
                    <span
                      v-if="position.IsManagement === '1'"
                      class="badge badge-light-success fs-8"
                      >Management</span
                    >
                    <span v-if="position.IsApprover === '1'" class="badge badge-light-primary fs-8"
                      >Approver</span
                    >
                  </div>
                </td>
                <td>
                  <div class="d-flex align-items-center gap-2">
                    <span class="fw-bold">{{ position.CurrentHeadcount || 0 }}</span>
                    <span class="text-muted">/</span>
                    <span class="text-muted">{{ position.HeadcountLimit || '∞' }}</span>
                  </div>
                </td>
                <td>
                  <span
                    :class="
                      position.IsActive === '1'
                        ? 'badge badge-light-success'
                        : 'badge badge-light-danger'
                    "
                  >
                    {{ position.IsActive === '1' ? 'Active' : 'Inactive' }}
                  </span>
                </td>
                <td class="text-end pe-4">
                  <div class="dropdown">
                    <button
                      class="btn btn-sm btn-light btn-active-light-primary"
                      data-bs-toggle="dropdown"
                    >
                      <i class="ki-duotone ki-dots-vertical fs-5">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                    </button>
                    <div
                      class="dropdown-menu menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-150px py-4"
                    >
                      <div class="menu-item px-3">
                        <a @click="viewPosition(position)" class="menu-link px-3">
                          <i class="ki-duotone ki-eye fs-6 me-2">
                            <span class="path1"></span>
                            <span class="path2"></span>
                            <span class="path3"></span>
                          </i>
                          View Details
                        </a>
                      </div>
                      <div class="menu-item px-3">
                        <a @click="editPosition(position)" class="menu-link px-3">
                          <i class="ki-duotone ki-pencil fs-6 me-2">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                          Edit
                        </a>
                      </div>
                      <div class="menu-item px-3">
                        <a @click="deletePosition(position)" class="menu-link px-3 text-danger">
                          <i class="ki-duotone ki-trash fs-6 me-2">
                            <span class="path1"></span>
                            <span class="path2"></span>
                            <span class="path3"></span>
                            <span class="path4"></span>
                            <span class="path5"></span>
                          </i>
                          Delete
                        </a>
                      </div>
                    </div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div class="card-footer d-flex align-items-center justify-content-between">
          <div class="text-muted">
            Showing {{ (currentPage - 1) * pageSize + 1 }} to
            {{ Math.min(currentPage * pageSize, filteredPositions.length) }} of
            {{ filteredPositions.length }} entries
          </div>
          <div class="d-flex align-items-center gap-2">
            <button
              @click="currentPage = Math.max(1, currentPage - 1)"
              class="btn btn-sm btn-light-primary"
              :disabled="currentPage === 1"
            >
              <i class="ki-duotone ki-left fs-6">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>

            <div class="d-flex gap-1">
              <button
                v-for="page in visiblePages"
                :key="page"
                @click="currentPage = page"
                class="btn btn-sm"
                :class="page === currentPage ? 'btn-primary' : 'btn-light-primary'"
              >
                {{ page }}
              </button>
            </div>

            <button
              @click="currentPage = Math.min(totalPages, currentPage + 1)"
              class="btn btn-sm btn-light-primary"
              :disabled="currentPage === totalPages"
            >
              <i class="ki-duotone ki-right fs-6">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Add/Edit Position Modal -->
    <div
      v-if="showAddModal || showEditModal"
      class="modal fade show"
      style="display: block"
      tabindex="-1"
    >
      <div class="modal-backdrop fade show"></div>
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header bg-light-primary">
            <h5 class="modal-title fw-bold">
              <i class="ki-duotone ki-badge fs-2 text-primary me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              {{ isEditing ? 'Edit Position' : 'Add New Position' }}
            </h5>
            <button @click="closeModal" class="btn btn-sm btn-icon btn-active-light-primary">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body p-7">
            <div class="row g-5">
              <!-- Basic Information -->
              <div class="col-12">
                <h6 class="fw-bold text-gray-900 mb-4">Basic Information</h6>
              </div>

              <div class="col-md-6">
                <label class="required form-label fw-bold">Position Code</label>
                <input
                  v-model="form.PositionCode"
                  type="text"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': errors.PositionCode }"
                  required
                />
                <div v-if="errors.PositionCode" class="invalid-feedback">
                  {{ errors.PositionCode }}
                </div>
              </div>

              <div class="col-md-6">
                <label class="required form-label fw-bold">Position Title</label>
                <input
                  v-model="form.PositionTitle"
                  type="text"
                  class="form-control form-control-lg"
                  :class="{ 'is-invalid': errors.PositionTitle }"
                  required
                />
                <div v-if="errors.PositionTitle" class="invalid-feedback">
                  {{ errors.PositionTitle }}
                </div>
              </div>

              <div class="col-md-6">
                <label class="required form-label fw-bold">Department</label>
                <select
                  v-model="form.DepartmentID"
                  class="form-select form-select-lg"
                  :class="{ 'is-invalid': errors.DepartmentID }"
                  required
                >
                  <option value="">Select Department</option>
                  <option v-if="departments.length === 0" disabled>No departments available</option>
                  <option
                    v-for="dept in departments"
                    :key="dept.DepartmentID"
                    :value="dept.DepartmentID"
                  >
                    {{ dept.DepartmentName }}
                  </option>
                </select>
                <div v-if="errors.DepartmentID" class="invalid-feedback">
                  {{ errors.DepartmentID }}
                </div>
                <div v-if="departments.length === 0" class="text-warning fs-7 mt-1">
                  <i class="ki-duotone ki-information fs-6 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  Please create departments first
                </div>
              </div>

              <div class="col-md-6">
                <label class="required form-label fw-bold">Job Grade</label>
                <select
                  v-model="form.GradeID"
                  class="form-select form-select-lg"
                  :class="{ 'is-invalid': errors.GradeID }"
                  required
                >
                  <option value="">Select Grade</option>
                  <option v-if="jobGrades.length === 0" disabled>No job grades available</option>
                  <option v-for="grade in jobGrades" :key="grade.GradeID" :value="grade.GradeID">
                    {{ grade.GradeCode }} - {{ grade.GradeName }}
                  </option>
                </select>
                <div v-if="errors.GradeID" class="invalid-feedback">{{ errors.GradeID }}</div>
                <div v-if="jobGrades.length === 0" class="text-warning fs-7 mt-1">
                  <i class="ki-duotone ki-information fs-6 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  Please create job grades first
                </div>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold">Reports To</label>
                <select v-model="form.ReportsToPositionID" class="form-select form-select-lg">
                  <option value="">No Direct Report</option>
                  <option
                    v-for="pos in positions.filter((p) => p.PositionID !== form.PositionID)"
                    :key="pos.PositionID"
                    :value="pos.PositionID"
                  >
                    {{ pos.PositionTitle }}
                  </option>
                </select>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold">Headcount Limit</label>
                <input
                  v-model="form.HeadcountLimit"
                  type="text"
                  class="form-control form-control-lg"
                />
              </div>

              <!-- Position Type -->
              <div class="col-12">
                <h6 class="fw-bold text-gray-900 mb-4 mt-5">Position Type & Permissions</h6>
              </div>

              <div class="col-md-4">
                <div class="form-check form-switch form-check-custom form-check-solid">
                  <input v-model="form.IsManagement" class="form-check-input" type="checkbox" />
                  <label class="form-check-label fw-bold">Management Position</label>
                </div>
              </div>

              <div class="col-md-4">
                <div class="form-check form-switch form-check-custom form-check-solid">
                  <input v-model="form.IsApprover" class="form-check-input" type="checkbox" />
                  <label class="form-check-label fw-bold">Approver Role</label>
                </div>
              </div>

              <div class="col-md-4">
                <div class="form-check form-switch form-check-custom form-check-solid">
                  <input v-model="form.IsActive" class="form-check-input" type="checkbox" />
                  <label class="form-check-label fw-bold">Active Position</label>
                </div>
              </div>

              <div v-if="form.IsApprover" class="col-md-6">
                <label class="form-label fw-bold">Approval Level</label>
                <select v-model="form.ApprovalLevel" class="form-select form-select-lg">
                  <option value="">Select Level</option>
                  <option
                    v-for="level in [1, 2, 3, 4, 5, 6, 7]"
                    :key="level"
                    :value="level.toString()"
                  >
                    Level {{ level }}
                  </option>
                </select>
              </div>

              <!-- Requirements -->
              <div class="col-12">
                <h6 class="fw-bold text-gray-900 mb-4 mt-5">Requirements & Qualifications</h6>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold">Minimum Experience (Years)</label>
                <input
                  v-model="form.MinExperience"
                  type="text"
                  class="form-control form-control-lg"
                />
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold">Minimum Education</label>
                <select v-model="form.MinEducation" class="form-select form-select-lg">
                  <option value="">Not Specified</option>
                  <option value="Primary">Primary Education</option>
                  <option value="Secondary">Secondary Education</option>
                  <option value="Certificate">Certificate</option>
                  <option value="Diploma">Diploma</option>
                  <option value="Degree">Bachelor's Degree</option>
                  <option value="Masters">Master's Degree</option>
                  <option value="PhD">PhD</option>
                </select>
              </div>

              <div class="col-12">
                <label class="form-label fw-bold">Position Description</label>
                <textarea
                  v-model="form.PositionDescription"
                  class="form-control form-control-lg"
                  rows="3"
                ></textarea>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold">Key Responsibilities</label>
                <textarea
                  v-model="form.Responsibilities"
                  class="form-control form-control-lg"
                  rows="4"
                ></textarea>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold">Required Skills</label>
                <textarea
                  v-model="form.Skills"
                  class="form-control form-control-lg"
                  rows="4"
                ></textarea>
              </div>

              <div class="col-12">
                <label class="form-label fw-bold">Qualifications</label>
                <textarea
                  v-model="form.Qualifications"
                  class="form-control form-control-lg"
                  rows="3"
                ></textarea>
              </div>

              <!-- User Assignment -->
              <div class="col-12">
                <h6 class="fw-bold text-gray-900 mb-4 mt-5">Record Management</h6>
              </div>

              <div class="col-md-6">
                <label class="required form-label fw-bold">Created By</label>
                <select
                  v-model="form.CreatedBy"
                  class="form-select form-select-lg"
                  :class="{ 'is-invalid': errors.CreatedBy }"
                  required
                >
                  <option value="">Select User</option>
                  <option v-if="users.length === 0" disabled>No users available</option>
                  <option v-for="user in users" :key="user.id" :value="user.id">
                    {{ getUserDisplayName(user) }}
                  </option>
                </select>
                <div v-if="errors.CreatedBy" class="invalid-feedback">{{ errors.CreatedBy }}</div>
                <div v-if="users.length === 0" class="text-warning fs-7 mt-1">
                  <i class="ki-duotone ki-information fs-6 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  Please ensure users exist in the system
                </div>
              </div>

              <div class="col-md-6">
                <label class="required form-label fw-bold">Updated By</label>
                <select
                  v-model="form.UpdatedBy"
                  class="form-select form-select-lg"
                  :class="{ 'is-invalid': errors.UpdatedBy }"
                  required
                >
                  <option value="">Select User</option>
                  <option v-if="users.length === 0" disabled>No users available</option>
                  <option v-for="user in users" :key="user.id" :value="user.id">
                    {{ getUserDisplayName(user) }}
                  </option>
                </select>
                <div v-if="errors.UpdatedBy" class="invalid-feedback">{{ errors.UpdatedBy }}</div>
                <div v-if="users.length === 0" class="text-warning fs-7 mt-1">
                  <i class="ki-duotone ki-information fs-6 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  Please ensure users exist in the system
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer bg-light">
            <button @click="closeModal" type="button" class="btn btn-light-secondary btn-lg">
              Cancel
            </button>
            <button @click="toggleDebugMode" type="button" class="btn btn-light-info btn-lg me-3">
              <i class="ki-duotone ki-code fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              Debug
            </button>
            <button
              @click="savePosition"
              type="button"
              class="btn btn-primary btn-lg"
              :disabled="saving"
            >
              <span v-if="saving" class="indicator-progress">
                Please wait...
                <span class="spinner-border spinner-border-sm align-middle ms-2"></span>
              </span>
              <span v-else>
                <i class="ki-duotone ki-check fs-2 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                {{ isEditing ? 'Update Position' : 'Create Position' }}
              </span>
            </button>
          </div>

          <!-- Debug Panel -->
          <div v-if="debugMode" class="modal-body border-top">
            <h6 class="fw-bold text-gray-900 mb-3">Debug Information</h6>
            <div class="row g-3">
              <div class="col-6">
                <div class="bg-light-info p-3 rounded">
                  <small class="text-muted fw-bold">Departments Loaded:</small>
                  <div class="fw-bold">{{ departments.length }}</div>
                </div>
              </div>
              <div class="col-6">
                <div class="bg-light-warning p-3 rounded">
                  <small class="text-muted fw-bold">Job Grades Loaded:</small>
                  <div class="fw-bold">{{ jobGrades.length }}</div>
                </div>
              </div>
              <div class="col-6">
                <div class="bg-light-success p-3 rounded">
                  <small class="text-muted fw-bold">Users Loaded:</small>
                  <div class="fw-bold">{{ users.length }}</div>
                </div>
              </div>
              <div class="col-6">
                <div class="bg-light-danger p-3 rounded">
                  <small class="text-muted fw-bold">Positions Loaded:</small>
                  <div class="fw-bold">{{ positions.length }}</div>
                </div>
              </div>
              <div class="col-12">
                <div class="bg-light-primary p-3 rounded">
                  <small class="text-muted fw-bold">Current Form Data:</small>
                  <pre class="fs-7 mt-2 mb-0">{{ JSON.stringify(form, null, 2) }}</pre>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- View Position Modal -->
    <div v-if="showViewModal" class="modal fade show" style="display: block" tabindex="-1">
      <div class="modal-backdrop fade show"></div>
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header bg-light-info">
            <h5 class="modal-title fw-bold">
              <i class="ki-duotone ki-profile-circle fs-2 text-info me-2">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              Position Details
            </h5>
            <button
              @click="showViewModal = false"
              class="btn btn-sm btn-icon btn-active-light-primary"
            >
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body p-7" v-if="selectedPosition">
            <div class="row g-5">
              <div class="col-12">
                <div class="d-flex align-items-center gap-3 mb-5">
                  <div class="symbol symbol-50px">
                    <div class="symbol-label bg-light-primary">
                      <i class="ki-duotone ki-badge fs-2 text-primary">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                        <span class="path4"></span>
                      </i>
                    </div>
                  </div>
                  <div>
                    <h4 class="fw-bold text-gray-900 mb-1">{{ selectedPosition.PositionTitle }}</h4>
                    <span class="badge badge-light-info">{{ selectedPosition.PositionCode }}</span>
                  </div>
                </div>
              </div>

              <div class="col-md-6">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Department</span>
                  <span class="badge badge-light-primary fs-6">{{
                    getDepartmentName(selectedPosition.DepartmentID)
                  }}</span>
                </div>
              </div>

              <div class="col-md-6">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Job Grade</span>
                  <span class="badge badge-light-warning fs-6">{{
                    getGradeName(selectedPosition.GradeID)
                  }}</span>
                </div>
              </div>

              <div class="col-md-6">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Reports To</span>
                  <span class="text-gray-900">{{
                    getPositionTitle(selectedPosition.ReportsToPositionID) || 'No Direct Report'
                  }}</span>
                </div>
              </div>

              <div class="col-md-6">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Headcount</span>
                  <span class="text-gray-900"
                    >{{ selectedPosition.CurrentHeadcount || 0 }} /
                    {{ selectedPosition.HeadcountLimit || '∞' }}</span
                  >
                </div>
              </div>

              <div class="col-12" v-if="selectedPosition.PositionDescription">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Description</span>
                  <p class="text-gray-700">{{ selectedPosition.PositionDescription }}</p>
                </div>
              </div>

              <div class="col-md-6" v-if="selectedPosition.Responsibilities">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Responsibilities</span>
                  <p class="text-gray-700">{{ selectedPosition.Responsibilities }}</p>
                </div>
              </div>

              <div class="col-md-6" v-if="selectedPosition.Skills">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Required Skills</span>
                  <p class="text-gray-700">{{ selectedPosition.Skills }}</p>
                </div>
              </div>

              <div class="col-12" v-if="selectedPosition.Qualifications">
                <div class="d-flex flex-column gap-2">
                  <span class="text-muted fw-bold">Qualifications</span>
                  <p class="text-gray-700">{{ selectedPosition.Qualifications }}</p>
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
import { ref, computed, onMounted } from 'vue'
import Swal from 'sweetalert2'

// Reactive data
const positions = ref([])
const departments = ref([])
const jobGrades = ref([])
const users = ref([])
const loading = ref(false)
const saving = ref(false)
const debugMode = ref(false)

// Pagination
const currentPage = ref(1)
const pageSize = ref(10)

// Modal states
const showAddModal = ref(false)
const showEditModal = ref(false)
const showViewModal = ref(false)
const selectedPosition = ref(null)
const isEditing = ref(false)

// Form data
const form = ref({
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
  IsManagement: false,
  HeadcountLimit: '',
  CurrentHeadcount: '0',
  IsApprover: false,
  ApprovalLevel: '',
  IsActive: true,
  CreatedBy: '',
  UpdatedBy: '',
})

const errors = ref({})

// Filters
const filters = ref({
  department: '',
  status: '',
  search: '',
})

// API configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN =
  localStorage.getItem('jwt') ||
  'eyJ0eXAiOiJKV1QiLCJhbGciOiJFZERTQSJ9.eyJzdWIiOiJkMDc1QVZVSVNCcW9HN3dvZFV0MVZ3PT0iLCJpYXQiOjE3NTA1NTc4MzAsImV4cCI6MTc1MDU2MTQzMCwiZW1haWwiOiJhZG1pbkBsb2NhbGhvc3QiLCJjc3JmX3Rva2VuIjoiT1dQU2RLeXgwQzVGVEkwbzFqb0gifQ.FrYiUIu59y6ZqftgpEQNX-GwAxh2USHTety2Dpt9C5j0H3GophpudsUzxfQ8wXVc_jcwGsnYo6svB90zzs0MBQ'

// Chart colors
const chartColors = ['#7239ea', '#f1416c', '#50cd89', '#ffc700', '#009ef7', '#e4e6ef']

// Computed properties
const filteredPositions = computed(() => {
  let filtered = positions.value

  if (filters.value.department) {
    filtered = filtered.filter((p) => p.DepartmentID == filters.value.department)
  }

  if (filters.value.status !== '') {
    filtered = filtered.filter((p) => p.IsActive === filters.value.status)
  }

  return filtered
})

const totalPages = computed(() => Math.ceil(filteredPositions.value.length / pageSize.value))

const paginatedPositions = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return filteredPositions.value.slice(start, end)
})

const visiblePages = computed(() => {
  const total = totalPages.value
  const current = currentPage.value
  const pages = []

  if (total <= 7) {
    for (let i = 1; i <= total; i++) {
      pages.push(i)
    }
  } else {
    if (current <= 4) {
      for (let i = 1; i <= 5; i++) {
        pages.push(i)
      }
      pages.push('...')
      pages.push(total)
    } else if (current >= total - 3) {
      pages.push(1)
      pages.push('...')
      for (let i = total - 4; i <= total; i++) {
        pages.push(i)
      }
    } else {
      pages.push(1)
      pages.push('...')
      for (let i = current - 1; i <= current + 1; i++) {
        pages.push(i)
      }
      pages.push('...')
      pages.push(total)
    }
  }

  return pages.filter((p) => p !== '...' && typeof p === 'number')
})

const analytics = computed(() => {
  const total = positions.value.length
  const active = positions.value.filter((p) => p.IsActive === '1').length
  const management = positions.value.filter((p) => p.IsManagement === '1').length
  const approvers = positions.value.filter((p) => p.IsApprover === '1').length

  const totalHeadcount = positions.value.reduce(
    (sum, p) => sum + parseInt(p.CurrentHeadcount || 0),
    0,
  )
  const totalCapacity = positions.value.reduce((sum, p) => {
    const limit = parseInt(p.HeadcountLimit || 0)
    return limit > 0 ? sum + limit : sum
  }, 0)

  const maxLevel = Math.max(
    ...positions.value.filter((p) => p.ApprovalLevel).map((p) => parseInt(p.ApprovalLevel)),
    0,
  )

  return {
    totalPositions: total,
    activePositions: active,
    managementPositions: management,
    approverPositions: approvers,
    totalHeadcount,
    totalCapacity: totalCapacity || 1,
    utilizationRate: totalCapacity > 0 ? Math.round((totalHeadcount / totalCapacity) * 100) : 0,
    maxApprovalLevel: maxLevel,
  }
})

const departmentChartData = computed(() => {
  const deptCounts = {}
  positions.value.forEach((pos) => {
    const deptName = getDepartmentName(pos.DepartmentID)
    deptCounts[deptName] = (deptCounts[deptName] || 0) + 1
  })

  return Object.entries(deptCounts).map(([name, value]) => ({ name, value }))
})

const gradeChartData = computed(() => {
  const gradeCounts = {}
  positions.value.forEach((pos) => {
    const gradeName = getGradeName(pos.GradeID)
    gradeCounts[gradeName] = (gradeCounts[gradeName] || 0) + 1
  })

  return Object.entries(gradeCounts).map(([name, value]) => ({ name, value }))
})

// Helper functions
const getDepartmentName = (id) => {
  const dept = departments.value.find((d) => d.DepartmentID == id)
  return dept ? dept.DepartmentName : 'Unknown'
}

const getGradeName = (id) => {
  const grade = jobGrades.value.find((g) => g.GradeID == id)
  return grade ? `${grade.GradeCode} - ${grade.GradeName}` : 'Unknown'
}

const getPositionTitle = (id) => {
  const position = positions.value.find((p) => p.PositionID == id)
  return position ? position.PositionTitle : ''
}

const getUserDisplayName = (user) => {
  if (user.display_name) return user.display_name
  if (user.name) return user.name
  if (user.first_name && user.last_name) return `${user.first_name} ${user.last_name}`
  return user.email || `User ${user.id}`
}

const getUserName = (id) => {
  const user = users.value.find((u) => u.id == id)
  return user ? getUserDisplayName(user) : 'Unknown User'
}

// API functions
const fetchPositions = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/Positions`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (!response.ok) throw new Error('Failed to fetch positions')
    const data = await response.json()
    positions.value = data.records || []
  } catch (error) {
    console.error('Error fetching positions:', error)
    showError(error.message)
  }
}

const fetchDepartments = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/Departments`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (!response.ok) throw new Error(`Failed to fetch departments. Status: ${response.status}`)
    const data = await response.json()
    departments.value = data.records || []
    console.log('Loaded departments:', departments.value.length)
  } catch (error) {
    console.error('Error fetching departments:', error)
    showError(
      'Failed to load departments. Please ensure departments exist before creating positions.',
    )
  }
}

const fetchJobGrades = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/JobGrades`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (!response.ok) throw new Error(`Failed to fetch job grades. Status: ${response.status}`)
    const data = await response.json()
    jobGrades.value = data.records || []
    console.log('Loaded job grades:', jobGrades.value.length)
  } catch (error) {
    console.error('Error fetching job grades:', error)
    showError(
      'Failed to load job grades. Please ensure job grades exist before creating positions.',
    )
  }
}

const fetchUsers = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/users`, {
      headers: { Authorization: `Bearer ${JWT_TOKEN}` },
    })
    if (!response.ok) throw new Error(`Failed to fetch users. Status: ${response.status}`)
    const data = await response.json()
    users.value = data.records || []
    console.log('Loaded users:', users.value.length)
  } catch (error) {
    console.error('Error fetching users:', error)
    showError('Failed to load users. Please ensure users exist before creating positions.')
  }
}

const savePosition = async () => {
  if (!validateForm()) return

  saving.value = true
  try {
    // Check if we have minimum required data
    if (departments.value.length === 0) {
      throw new Error('Cannot create position: No departments available')
    }

    if (jobGrades.value.length === 0) {
      throw new Error('Cannot create position: No job grades available')
    }

    if (users.value.length === 0) {
      throw new Error('Cannot create position: No users available')
    }

    // Prepare payload to match EXACT TrailBase API format from documentation
    const payload = {
      PositionID: null,
      PositionCode: form.value.PositionCode || '',
      PositionTitle: form.value.PositionTitle || '',
      DepartmentID: form.value.DepartmentID ? parseInt(form.value.DepartmentID) : 0,
      GradeID: form.value.GradeID ? parseInt(form.value.GradeID) : 0,
      ReportsToPositionID: form.value.ReportsToPositionID
        ? parseInt(form.value.ReportsToPositionID)
        : 0,
      MinExperience: form.value.MinExperience || '',
      MinEducation: form.value.MinEducation || '',
      PositionDescription: form.value.PositionDescription || '',
      Responsibilities: form.value.Responsibilities || '',
      Qualifications: form.value.Qualifications || '',
      Skills: form.value.Skills || '',
      IsManagement: form.value.IsManagement ? '1' : '0',
      HeadcountLimit: form.value.HeadcountLimit || '',
      CurrentHeadcount: form.value.CurrentHeadcount || '0',
      IsApprover: form.value.IsApprover ? '1' : '0',
      ApprovalLevel: form.value.ApprovalLevel || '',
      IsActive: form.value.IsActive ? '1' : '0',
      CreatedAt: null,
      UpdatedAt: null,
      CreatedBy: form.value.CreatedBy || '',
      UpdatedBy: form.value.UpdatedBy || '',
    }

    console.log('Sending payload:', JSON.stringify(payload, null, 2))

    const url = isEditing.value
      ? `${API_BASE_URL}/Positions/${selectedPosition.value.PositionID}`
      : `${API_BASE_URL}/Positions`

    const method = isEditing.value ? 'PATCH' : 'POST'

    const response = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${JWT_TOKEN}`,
      },
      body: JSON.stringify(payload),
    })

    if (!response.ok) {
      const errorText = await response.text()
      console.error('API Error Response:', errorText)
      let errorData
      try {
        errorData = JSON.parse(errorText)
      } catch (e) {
        errorData = { message: errorText }
      }
      throw new Error(errorData.message || `Failed to save position. Status: ${response.status}`)
    }

    showSuccess(
      isEditing.value ? 'Position updated successfully!' : 'Position created successfully!',
    )
    closeModal()
    await fetchPositions()
  } catch (error) {
    console.error('Error saving position:', error)
    showError(error.message || 'Unknown error occurred while saving position')
  } finally {
    saving.value = false
  }
}

const deletePosition = async (position) => {
  const result = await Swal.fire({
    title: 'Delete Position?',
    text: `Are you sure you want to delete "${position.PositionTitle}"?`,
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#7e8299',
    confirmButtonText: 'Yes, delete it!',
  })

  if (result.isConfirmed) {
    try {
      const response = await fetch(`${API_BASE_URL}/Positions/${position.PositionID}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${JWT_TOKEN}` },
      })

      if (!response.ok) throw new Error('Failed to delete position')

      showSuccess('Position deleted successfully!')
      await fetchPositions()
    } catch (error) {
      console.error('Error deleting position:', error)
      showError(error.message)
    }
  }
}

// Modal functions
const openAddModal = () => {
  if (departments.value.length === 0) {
    showError('Cannot create position: No departments found. Please create departments first.')
    return
  }

  if (jobGrades.value.length === 0) {
    showError('Cannot create position: No job grades found. Please create job grades first.')
    return
  }

  if (users.value.length === 0) {
    showError('Cannot create position: No users found. Please ensure users exist in the system.')
    return
  }

  showAddModal.value = true
}

const editPosition = (position) => {
  selectedPosition.value = position
  isEditing.value = true

  form.value = {
    ...position,
    DepartmentID: position.DepartmentID?.toString() || '',
    GradeID: position.GradeID?.toString() || '',
    ReportsToPositionID: position.ReportsToPositionID?.toString() || '',
    IsManagement: position.IsManagement === '1',
    IsApprover: position.IsApprover === '1',
    IsActive: position.IsActive === '1',
    CreatedBy: position.CreatedBy?.toString() || '',
    UpdatedBy: position.UpdatedBy?.toString() || '',
  }

  showEditModal.value = true
}

const viewPosition = (position) => {
  selectedPosition.value = position
  showViewModal.value = true
}

const closeModal = () => {
  showAddModal.value = false
  showEditModal.value = false
  showViewModal.value = false
  selectedPosition.value = null
  isEditing.value = false
  debugMode.value = false
  resetForm()
  errors.value = {}
}

const resetForm = () => {
  form.value = {
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
    IsManagement: false,
    HeadcountLimit: '',
    CurrentHeadcount: '0',
    IsApprover: false,
    ApprovalLevel: '',
    IsActive: true,
    CreatedBy: '',
    UpdatedBy: '',
  }
}

const validateForm = () => {
  errors.value = {}

  if (!form.value.PositionCode) {
    errors.value.PositionCode = 'Position code is required'
  }

  if (!form.value.PositionTitle) {
    errors.value.PositionTitle = 'Position title is required'
  }

  if (!form.value.DepartmentID) {
    errors.value.DepartmentID = 'Department is required'
  } else {
    // Validate department exists
    const deptExists = departments.value.find((d) => d.DepartmentID == form.value.DepartmentID)
    if (!deptExists) {
      errors.value.DepartmentID = 'Selected department does not exist'
    }
  }

  if (!form.value.GradeID) {
    errors.value.GradeID = 'Job grade is required'
  } else {
    // Validate grade exists
    const gradeExists = jobGrades.value.find((g) => g.GradeID == form.value.GradeID)
    if (!gradeExists) {
      errors.value.GradeID = 'Selected job grade does not exist'
    }
  }

  // Validate ReportsToPositionID if provided
  if (form.value.ReportsToPositionID) {
    const posExists = positions.value.find((p) => p.PositionID == form.value.ReportsToPositionID)
    if (!posExists) {
      errors.value.ReportsToPositionID = 'Selected reporting position does not exist'
    }
  }

  // Validate CreatedBy is required
  if (!form.value.CreatedBy) {
    errors.value.CreatedBy = 'Created By user is required'
  } else {
    const userExists = users.value.find((u) => u.id == form.value.CreatedBy)
    if (!userExists) {
      errors.value.CreatedBy = 'Selected Created By user does not exist'
    }
  }

  // Validate UpdatedBy is required
  if (!form.value.UpdatedBy) {
    errors.value.UpdatedBy = 'Updated By user is required'
  } else {
    const userExists = users.value.find((u) => u.id == form.value.UpdatedBy)
    if (!userExists) {
      errors.value.UpdatedBy = 'Selected Updated By user does not exist'
    }
  }

  return Object.keys(errors.value).length === 0
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([fetchPositions(), fetchDepartments(), fetchJobGrades(), fetchUsers()])
    showSuccess('Data refreshed successfully!')
  } catch (error) {
    showError('Failed to refresh data')
  } finally {
    loading.value = false
  }
}

const toggleDebugMode = () => {
  debugMode.value = !debugMode.value
}

// Notification functions
const showSuccess = (message) => {
  Swal.fire({
    title: 'Success!',
    text: message,
    icon: 'success',
    toast: true,
    position: 'top-end',
    timer: 3000,
    showConfirmButton: false,
  })
}

const showError = (message) => {
  Swal.fire({
    title: 'Error!',
    text: message,
    icon: 'error',
    confirmButtonColor: '#f1416c',
  })
}

// Initialize data
onMounted(async () => {
  loading.value = true
  try {
    await Promise.all([fetchPositions(), fetchDepartments(), fetchJobGrades(), fetchUsers()])
  } catch (error) {
    showError('Failed to load initial data')
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.modal {
  background-color: rgba(0, 0, 0, 0.5);
}

.table-responsive {
  border-radius: 0.75rem;
  overflow: hidden;
}

.card-flush {
  box-shadow: 0 0 50px 0 rgba(82, 63, 105, 0.15);
}

.symbol-label {
  border-radius: 0.75rem;
}

.form-control-lg,
.form-select-lg {
  border-radius: 0.75rem;
  border: 1px solid #e4e6ef;
  transition: all 0.15s ease-in-out;
}

.form-control-lg:focus,
.form-select-lg:focus {
  border-color: #009ef7;
  box-shadow: 0 0 0 0.25rem rgba(0, 158, 247, 0.1);
}

.btn-lg {
  border-radius: 0.75rem;
  font-weight: 600;
  padding: 0.875rem 1.5rem;
}

.modal-content {
  border-radius: 1rem;
  border: none;
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
}

.modal-header {
  border-radius: 1rem 1rem 0 0;
  border-bottom: 1px solid #e4e6ef;
}

.dropdown-menu {
  border-radius: 0.75rem;
  border: none;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.progress {
  border-radius: 0.5rem;
  background-color: #f5f8fa;
}

.progress-bar {
  border-radius: 0.5rem;
}

@media (max-width: 768px) {
  .col-xl-3 {
    margin-bottom: 1rem;
  }

  .modal-dialog {
    margin: 1rem;
  }

  .table-responsive {
    font-size: 0.875rem;
  }

  .btn-lg {
    padding: 0.75rem 1.25rem;
    font-size: 0.875rem;
  }

  .card-toolbar {
    flex-direction: column;
    gap: 0.5rem;
  }

  .card-toolbar .d-flex {
    flex-direction: column;
    width: 100%;
  }

  .form-select-sm {
    width: 100% !important;
  }
}
</style>

<template>
  <!-- Main Container -->
  <div class="d-flex flex-column gap-7 gap-lg-10">
    <!-- Hero Header with Gradient Background -->
    <div class="card card-flush bg-gradient-primary">
      <div class="card-body py-9">
        <div class="d-flex flex-column flex-md-row align-items-center gap-5">
          <div class="flex-grow-1">
            <div class="d-flex align-items-center gap-3 mb-3">
              <i class="ki-duotone ki-people fs-2x text-white">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
                <span class="path5"></span>
              </i>
              <h1 class="fs-2x fw-bold text-white mb-0">AI-Enhanced Employee Management</h1>
            </div>
            <p class="fs-5 text-white opacity-75 mb-0">
              Smart workforce management for {{ totalEmployees }} employees •
              {{ activeEmployeesPercentage }}% active workforce
            </p>
          </div>
          <div class="d-flex gap-3 flex-wrap">
            <button @click="quickAddEmployee()" class="btn btn-light-success btn-lg shadow-sm">
              <i class="ki-duotone ki-flash fs-2">
                <span class="path1"></span>
                <span class="path2"></span> </i
              >AI Quick Add
            </button>
            <button @click="openEmployeeModal()" class="btn btn-light-warning btn-lg shadow-sm">
              <i class="ki-duotone ki-plus fs-2">
                <span class="path1"></span>
                <span class="path2"></span> </i
              >New Employee
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Statistics Dashboard with Charts -->
    <div class="row g-5 g-xl-8">
      <!-- Total Employees Card -->
      <div class="col-xl-3 col-md-6">
        <div class="card card-flush bg-light-success h-100">
          <div class="card-body d-flex flex-column justify-content-between py-7">
            <div class="d-flex align-items-center mb-3">
              <div class="symbol symbol-50px bg-success me-4">
                <i class="ki-duotone ki-profile-user fs-2x text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                  <span class="path4"></span>
                </i>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-6">Total Employees</span>
                <div class="fw-bold text-gray-900 fs-2x">{{ totalEmployees }}</div>
              </div>
            </div>
            <div class="separator separator-dashed my-3"></div>
            <div class="d-flex justify-content-between">
              <span class="badge badge-light-success fs-7">{{ activeEmployees }} Active</span>
              <span class="text-success fw-bold fs-7">{{ activeEmployeesPercentage }}%</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Departments Card -->
      <div class="col-xl-3 col-md-6">
        <div class="card card-flush bg-light-primary h-100">
          <div class="card-body d-flex flex-column justify-content-between py-7">
            <div class="d-flex align-items-center mb-3">
              <div class="symbol symbol-50px bg-primary me-4">
                <i class="ki-duotone ki-abstract-33 fs-2x text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-6">Departments</span>
                <div class="fw-bold text-gray-900 fs-2x">{{ departments.length }}</div>
              </div>
            </div>
            <div class="separator separator-dashed my-3"></div>
            <div class="d-flex justify-content-between">
              <span class="badge badge-light-primary fs-7">Active Depts</span>
              <span class="text-primary fw-bold fs-7">{{
                departments.filter((d) => d.IsActive === '1').length
              }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Payroll Card -->
      <div class="col-xl-3 col-md-6">
        <div class="card card-flush bg-light-warning h-100">
          <div class="card-body d-flex flex-column justify-content-between py-7">
            <div class="d-flex align-items-center mb-3">
              <div class="symbol symbol-50px bg-warning me-4">
                <i class="ki-duotone ki-dollar fs-2x text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-6">Monthly Payroll</span>
                <div class="fw-bold text-gray-900 fs-2x">{{ formatCurrency(totalPayroll) }}</div>
              </div>
            </div>
            <div class="separator separator-dashed my-3"></div>
            <div class="d-flex justify-content-between">
              <span class="badge badge-light-warning fs-7">UGX Budget</span>
              <span class="text-warning fw-bold fs-7"
                >{{ Math.round(totalPayroll / 1000000) }}M</span
              >
            </div>
          </div>
        </div>
      </div>

      <!-- New Hires Card -->
      <div class="col-xl-3 col-md-6">
        <div class="card card-flush bg-light-danger h-100">
          <div class="card-body d-flex flex-column justify-content-between py-7">
            <div class="d-flex align-items-center mb-3">
              <div class="symbol symbol-50px bg-danger me-4">
                <i class="ki-duotone ki-user-tick fs-2x text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
              </div>
              <div class="flex-grow-1">
                <span class="text-gray-700 fw-semibold fs-6">New Hires (30d)</span>
                <div class="fw-bold text-gray-900 fs-2x">{{ newHiresCount }}</div>
              </div>
            </div>
            <div class="separator separator-dashed my-3"></div>
            <div class="d-flex justify-content-between">
              <span class="badge badge-light-danger fs-7">This Month</span>
              <span class="text-danger fw-bold fs-7">+{{ newHiresCount }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Analytics Charts Row -->
    <div class="row g-5 g-xl-8">
      <!-- Department Distribution Chart -->
      <div class="col-xl-6">
        <div class="card card-flush h-xl-100">
          <div class="card-header py-7">
            <h3 class="card-title fw-bold text-gray-900">Department Distribution</h3>
            <div class="card-toolbar">
              <span class="badge badge-light-info fs-7">Live Data</span>
            </div>
          </div>
          <div class="card-body pt-0">
            <div id="departmentChart" style="height: 300px"></div>
          </div>
        </div>
      </div>

      <!-- Hiring Trends Chart -->
      <div class="col-xl-6">
        <div class="card card-flush h-xl-100">
          <div class="card-header py-7">
            <h3 class="card-title fw-bold text-gray-900">Hiring Trends (Last 12 Months)</h3>
            <div class="card-toolbar">
              <span class="badge badge-light-success fs-7">AI Forecast</span>
            </div>
          </div>
          <div class="card-body pt-0">
            <div id="hiringChart" style="height: 300px"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Search & Filters -->
    <div class="card card-flush">
      <div class="card-header py-7">
        <div class="card-title">
          <h3 class="fw-bold text-gray-900">Employee Directory</h3>
        </div>
        <div class="card-toolbar">
          <div class="d-flex gap-3 flex-wrap">
            <div class="position-relative">
              <i
                class="ki-duotone ki-magnifier fs-3 position-absolute ms-4 top-50 translate-middle-y text-gray-500"
              >
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              <input
                v-model="searchFilters.searchTerm"
                @input="applyFilters"
                type="text"
                class="form-control form-control-lg ps-12"
                placeholder="Search employees..."
              />
            </div>
            <select
              v-model="searchFilters.department"
              @change="applyFilters"
              class="form-select form-select-lg"
            >
              <option value="">All Departments</option>
              <option
                v-for="dept in departments"
                :key="dept.DepartmentID"
                :value="dept.DepartmentName"
              >
                {{ dept.DepartmentName }}
              </option>
            </select>
            <select
              v-model="searchFilters.station"
              @change="applyFilters"
              class="form-select form-select-lg"
            >
              <option value="">All Stations</option>
              <option
                v-for="station in stations"
                :key="station.StationID"
                :value="station.StationID"
              >
                {{ station.StationName }}
              </option>
            </select>
            <select
              v-model="searchFilters.status"
              @change="applyFilters"
              class="form-select form-select-lg"
            >
              <option value="">All Status</option>
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
              <option value="Terminated">Terminated</option>
            </select>
            <button @click="resetFilters" class="btn btn-light-danger btn-lg">
              <i class="ki-duotone ki-cross fs-4">
                <span class="path1"></span>
                <span class="path2"></span> </i
              >Reset
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Employee Data Table -->
    <div class="card card-flush">
      <div class="card-body p-0">
        <div v-if="loading" class="d-flex justify-content-center py-20">
          <div class="spinner-border text-primary" style="width: 3rem; height: 3rem" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
        <div v-else-if="filteredEmployees.length === 0" class="text-center py-20">
          <i class="ki-duotone ki-file-deleted fs-4x text-gray-400 mb-5">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <h3 class="text-gray-800 fw-bold mb-3">No Employees Found</h3>
          <p class="text-gray-600 mb-5">Try adjusting your search criteria or add new employees</p>
          <button @click="quickAddEmployee()" class="btn btn-primary btn-lg">
            <i class="ki-duotone ki-flash fs-2">
              <span class="path1"></span>
              <span class="path2"></span> </i
            >AI Quick Add Employee
          </button>
        </div>
        <div v-else class="table-responsive">
          <table class="table align-middle table-row-dashed fs-6 gy-5">
            <thead>
              <tr class="text-start text-gray-400 fw-bold fs-7 text-uppercase gs-0">
                <th class="min-w-200px">Employee</th>
                <th class="min-w-150px">Position & Department</th>
                <th class="min-w-125px">Station</th>
                <th class="min-w-100px">Employment</th>
                <th class="min-w-100px">Status</th>
                <th class="min-w-125px">Actions</th>
              </tr>
            </thead>
            <tbody class="fw-semibold text-gray-600">
              <tr
                v-for="employee in paginatedEmployees"
                :key="employee.id"
                class="hover-bg-light-primary"
              >
                <td>
                  <div class="d-flex align-items-center">
                    <div class="symbol symbol-50px me-3">
                      <div class="symbol-label bg-light-primary text-primary fs-3 fw-bold">
                        {{ getEmployeeInitials(employee) }}
                      </div>
                    </div>
                    <div>
                      <div class="fw-bold text-gray-900 fs-6">{{ employee.name }}</div>
                      <div class="text-muted fs-7">{{ employee.email }}</div>
                      <div class="text-muted fs-8">
                        ID: {{ employee.employee_id || 'Auto-Gen' }}
                      </div>
                    </div>
                  </div>
                </td>
                <td>
                  <div class="fw-bold text-gray-800">
                    {{ employee.job_title || 'Position Not Set' }}
                  </div>
                  <div class="text-muted fs-7">{{ employee.Department || 'No Department' }}</div>
                  <div class="text-muted fs-8">{{ formatCurrency(employee.Salary || 0) }}</div>
                </td>
                <td>
                  <div class="fw-bold text-gray-800">
                    {{ getStationName(employee.PrimaryStationID) }}
                  </div>
                  <div class="text-muted fs-8">Primary Assignment</div>
                </td>
                <td>
                  <div class="fw-bold text-gray-800">
                    {{ employee.employment_type || 'Full-time' }}
                  </div>
                  <div class="text-muted fs-7">Since: {{ formatDate(employee.HireDate) }}</div>
                </td>
                <td>
                  <span :class="getEmployeeStatusBadge(employee.Status)" class="badge fs-7">
                    {{ employee.Status || 'Active' }}
                  </span>
                </td>
                <td>
                  <div class="d-flex gap-1">
                    <button
                      @click="viewEmployee(employee)"
                      class="btn btn-light-primary btn-sm"
                      title="View Details"
                    >
                      <i class="ki-duotone ki-eye fs-4">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                    </button>
                    <button
                      @click="editEmployee(employee)"
                      class="btn btn-light-warning btn-sm"
                      title="Edit Employee"
                    >
                      <i class="ki-duotone ki-pencil fs-4">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </button>
                    <button
                      @click="quickUpdate(employee)"
                      class="btn btn-light-success btn-sm"
                      title="Quick Update"
                    >
                      <i class="ki-duotone ki-flash fs-4">
                        <span class="path1"></span>
                        <span class="path2"></span>
                      </i>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination -->
        <div
          v-if="totalPages > 1"
          class="card-footer d-flex justify-content-between align-items-center py-5"
        >
          <div class="text-gray-700 fw-semibold">
            Showing {{ (currentPage - 1) * pageSize + 1 }} to
            {{ Math.min(currentPage * pageSize, filteredEmployees.length) }} of
            {{ filteredEmployees.length }} employees
          </div>
          <div class="d-flex gap-2">
            <button
              @click="currentPage = 1"
              :disabled="currentPage === 1"
              class="btn btn-sm btn-light-primary"
            >
              First
            </button>
            <button
              @click="currentPage--"
              :disabled="currentPage === 1"
              class="btn btn-sm btn-light-primary"
            >
              Previous
            </button>
            <span class="btn btn-sm btn-primary">{{ currentPage }} of {{ totalPages }}</span>
            <button
              @click="currentPage++"
              :disabled="currentPage === totalPages"
              class="btn btn-sm btn-light-primary"
            >
              Next
            </button>
            <button
              @click="currentPage = totalPages"
              :disabled="currentPage === totalPages"
              class="btn btn-sm btn-light-primary"
            >
              Last
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Employee Form Modal -->
    <div class="modal fade" id="employeeModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header bg-gradient-success">
            <h3 class="modal-title fw-bold text-white">
              <i class="ki-duotone ki-profile-user fs-2 me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
                <span class="path4"></span>
              </i>
              {{ employeeForm.isEdit ? 'Update Employee' : 'AI-Enhanced Employee Registration' }}
            </h3>
            <button
              type="button"
              class="btn-close btn-close-white"
              data-bs-dismiss="modal"
            ></button>
          </div>

          <div class="modal-body p-7">
            <form @submit.prevent="submitEmployee" novalidate>
              <div class="row g-7">
                <!-- Basic Information Card -->
                <div class="col-12">
                  <div class="card card-flush bg-light-primary">
                    <div class="card-header">
                      <h4 class="card-title fw-bold text-primary">
                        <i class="ki-duotone ki-user fs-2 me-2">
                          <span class="path1"></span>
                          <span class="path2"></span> </i
                        >Basic Information
                      </h4>
                    </div>
                    <div class="card-body">
                      <div class="row g-5">
                        <div class="col-md-6">
                          <label class="required form-label fw-bold">Full Name</label>
                          <input
                            v-model="employeeForm.name"
                            type="text"
                            class="form-control form-control-lg"
                            :class="{ 'is-invalid': formErrors.name }"
                            placeholder="Enter employee full name"
                            required
                          />
                          <div v-if="formErrors.name" class="invalid-feedback">
                            {{ formErrors.name }}
                          </div>
                        </div>
                        <div class="col-md-6">
                          <label class="required form-label fw-bold">Email Address</label>
                          <input
                            v-model="employeeForm.email"
                            type="email"
                            class="form-control form-control-lg"
                            :class="{ 'is-invalid': formErrors.email }"
                            placeholder="Auto-generated from name"
                            required
                          />
                          <div v-if="formErrors.email" class="invalid-feedback">
                            {{ formErrors.email }}
                          </div>
                          <div class="form-text text-muted">
                            Email will be used as login password
                          </div>
                        </div>
                        <div class="col-md-6">
                          <label class="required form-label fw-bold">Phone Number</label>
                          <input
                            v-model="employeeForm.Phone"
                            type="tel"
                            class="form-control form-control-lg"
                            :class="{ 'is-invalid': formErrors.Phone }"
                            placeholder="+256 700 000 000"
                            required
                          />
                          <div v-if="formErrors.Phone" class="invalid-feedback">
                            {{ formErrors.Phone }}
                          </div>
                        </div>
                        <div class="col-md-6">
                          <label class="form-label fw-bold">Employee ID</label>
                          <input
                            v-model="employeeForm.employee_id"
                            type="text"
                            class="form-control form-control-lg bg-light"
                            placeholder="Auto-generated by AI"
                            readonly
                          />
                          <div class="form-text text-muted">
                            AI generates unique ID based on name and department
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Employment Information Card -->
                <div class="col-md-6">
                  <div class="card card-flush bg-light-warning h-100">
                    <div class="card-header">
                      <h4 class="card-title fw-bold text-warning">
                        <i class="ki-duotone ki-briefcase fs-2 me-2">
                          <span class="path1"></span>
                          <span class="path2"></span> </i
                        >Employment Details
                      </h4>
                    </div>
                    <div class="card-body">
                      <div class="row g-5">
                        <div class="col-12">
                          <label class="required form-label fw-bold">Department</label>
                          <select
                            v-model="employeeForm.Department"
                            class="form-select form-select-lg"
                            :class="{ 'is-invalid': formErrors.Department }"
                            required
                          >
                            <option value="">Select Department</option>
                            <option
                              v-for="dept in departments"
                              :key="dept.DepartmentID"
                              :value="dept.DepartmentName"
                            >
                              {{ dept.DepartmentName }}
                            </option>
                          </select>
                          <div v-if="formErrors.Department" class="invalid-feedback">
                            {{ formErrors.Department }}
                          </div>
                        </div>
                        <div class="col-12">
                          <label class="required form-label fw-bold">Job Title</label>
                          <select
                            v-model="employeeForm.job_title"
                            class="form-select form-select-lg"
                            :class="{ 'is-invalid': formErrors.job_title }"
                            required
                          >
                            <option value="">Select Job Title</option>
                            <option
                              v-for="job in aiAutoComplete.ugandanJobTitles"
                              :key="job.title"
                              :value="job.title"
                            >
                              {{ job.title }} ({{ formatCurrency(job.salary) }})
                            </option>
                          </select>
                          <div v-if="formErrors.job_title" class="invalid-feedback">
                            {{ formErrors.job_title }}
                          </div>
                        </div>
                        <div class="col-12">
                          <label class="required form-label fw-bold">System Role</label>
                          <select
                            v-model="employeeForm.Role"
                            class="form-select form-select-lg"
                            :class="{ 'is-invalid': formErrors.Role }"
                            required
                          >
                            <option value="">Select Role</option>
                            <option v-for="role in roles" :key="role.RoleID" :value="role.RoleName">
                              {{ role.RoleName }}
                            </option>
                          </select>
                          <div v-if="formErrors.Role" class="invalid-feedback">
                            {{ formErrors.Role }}
                          </div>
                        </div>
                        <div class="col-12">
                          <label class="form-label fw-bold">Primary Station</label>
                          <select
                            v-model="employeeForm.PrimaryStationID"
                            class="form-select form-select-lg"
                          >
                            <option value="">Select Station</option>
                            <option
                              v-for="station in stations"
                              :key="station.StationID"
                              :value="station.StationID"
                            >
                              {{ station.StationName }} - {{ station.Location }}
                            </option>
                          </select>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Compensation & Dates Card -->
                <div class="col-md-6">
                  <div class="card card-flush bg-light-success h-100">
                    <div class="card-header">
                      <h4 class="card-title fw-bold text-success">
                        <i class="ki-duotone ki-dollar fs-2 me-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span> </i
                        >Compensation & Dates
                      </h4>
                    </div>
                    <div class="card-body">
                      <div class="row g-5">
                        <div class="col-12">
                          <label class="required form-label fw-bold">Hire Date</label>
                          <input
                            v-model="employeeForm.HireDate"
                            type="date"
                            class="form-control form-control-lg"
                            :class="{ 'is-invalid': formErrors.HireDate }"
                            required
                          />
                          <div v-if="formErrors.HireDate" class="invalid-feedback">
                            {{ formErrors.HireDate }}
                          </div>
                        </div>
                        <div class="col-12">
                          <label class="form-label fw-bold">Monthly Salary (UGX)</label>
                          <input
                            v-model="employeeForm.Salary"
                            type="number"
                            class="form-control form-control-lg"
                            placeholder="AI suggests based on job title"
                            step="50000"
                            min="0"
                          />
                          <div class="form-text text-muted">
                            AI suggests salary based on role and experience
                          </div>
                        </div>
                        <div class="col-12">
                          <label class="form-label fw-bold">Employment Type</label>
                          <select
                            v-model="employeeForm.employment_type"
                            class="form-select form-select-lg"
                          >
                            <option value="Full-time">Full-time</option>
                            <option value="Part-time">Part-time</option>
                            <option value="Contract">Contract</option>
                            <option value="Intern">Intern</option>
                            <option value="Consultant">Consultant</option>
                          </select>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>

          <div class="modal-footer bg-light py-5">
            <button type="button" class="btn btn-light btn-lg" data-bs-dismiss="modal">
              Cancel
            </button>
            <button
              @click="submitEmployee"
              type="button"
              class="btn btn-success btn-lg"
              :disabled="saving"
            >
              <span v-if="saving" class="spinner-border spinner-border-sm me-2"></span>
              <i v-else class="ki-duotone ki-check fs-4 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              {{ employeeForm.isEdit ? 'Update Employee' : 'Create Employee' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Employee View Modal -->
    <div class="modal fade" id="viewModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header bg-light-info">
            <h3 class="modal-title fw-bold">
              <i class="ki-duotone ki-profile-circle fs-2 text-info me-3">
                <span class="path1"></span>
                <span class="path2"></span>
                <span class="path3"></span>
              </i>
              Employee Profile
            </h3>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body py-7" v-if="selectedEmployee">
            <div class="d-flex align-items-center mb-7">
              <div class="symbol symbol-100px me-5">
                <div class="symbol-label bg-primary text-white fs-1 fw-bold">
                  {{ getEmployeeInitials(selectedEmployee) }}
                </div>
              </div>
              <div class="flex-grow-1">
                <h2 class="fw-bold text-gray-900 mb-2">{{ selectedEmployee.name }}</h2>
                <div class="text-gray-700 fw-semibold fs-6 mb-2">
                  {{ selectedEmployee.job_title }}
                </div>
                <div class="text-gray-600 fs-7">{{ selectedEmployee.email }}</div>
                <div class="text-gray-600 fs-7">{{ selectedEmployee.Phone }}</div>
              </div>
              <div class="text-end">
                <span
                  :class="getEmployeeStatusBadge(selectedEmployee.Status)"
                  class="badge fs-6 mb-2"
                >
                  {{ selectedEmployee.Status || 'Active' }}
                </span>
                <div class="text-gray-600 fs-7">
                  ID: {{ selectedEmployee.employee_id || 'Not Set' }}
                </div>
              </div>
            </div>

            <div class="row g-5">
              <div class="col-md-6">
                <div class="card card-flush bg-light">
                  <div class="card-body">
                    <h5 class="fw-bold mb-4">Employment Information</h5>
                    <div class="mb-3">
                      <span class="fw-bold text-gray-800">Department:</span>
                      <span class="text-gray-600 ms-2">{{
                        selectedEmployee.Department || 'Not assigned'
                      }}</span>
                    </div>
                    <div class="mb-3">
                      <span class="fw-bold text-gray-800">Employment Type:</span>
                      <span class="text-gray-600 ms-2">{{
                        selectedEmployee.employment_type || 'Full-time'
                      }}</span>
                    </div>
                    <div class="mb-3">
                      <span class="fw-bold text-gray-800">Hire Date:</span>
                      <span class="text-gray-600 ms-2">{{
                        formatDate(selectedEmployee.HireDate) || 'Not specified'
                      }}</span>
                    </div>
                    <div class="mb-3">
                      <span class="fw-bold text-gray-800">Station:</span>
                      <span class="text-gray-600 ms-2">{{
                        getStationName(selectedEmployee.PrimaryStationID)
                      }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="card card-flush bg-light">
                  <div class="card-body">
                    <h5 class="fw-bold mb-4">Compensation</h5>
                    <div class="mb-3">
                      <span class="fw-bold text-gray-800">Monthly Salary:</span>
                      <span class="text-success fw-bold ms-2">{{
                        formatCurrency(selectedEmployee.Salary || 0)
                      }}</span>
                    </div>
                    <div class="mb-3">
                      <span class="fw-bold text-gray-800">Payment Method:</span>
                      <span class="text-gray-600 ms-2">{{
                        selectedEmployee.payment_method || 'Bank Transfer'
                      }}</span>
                    </div>
                    <div class="mb-3">
                      <span class="fw-bold text-gray-800">Tax Status:</span>
                      <span class="text-gray-600 ms-2">{{
                        selectedEmployee.tax_status || 'PAYE'
                      }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
            <button @click="editEmployee(selectedEmployee)" type="button" class="btn btn-primary">
              <i class="ki-duotone ki-pencil fs-4 me-2">
                <span class="path1"></span>
                <span class="path2"></span> </i
              >Edit Employee
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch } from 'vue'
import Swal from 'sweetalert2'

// ============================================================================
// REACTIVE DATA & REFS
// ============================================================================

// Core Data
const employees = ref([])
const departments = ref([])
const stations = ref([])
const roles = ref([])
const selectedEmployee = ref(null)

// UI State
const loading = ref(false)
const saving = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)

// Charts instances
let departmentChartInstance = null
let hiringChartInstance = null

// Search & Filters
const searchFilters = reactive({
  searchTerm: '',
  department: '',
  station: '',
  status: '',
})

// Streamlined Employee Form - Only Critical Fields
const employeeForm = reactive({
  isEdit: false,
  id: null,

  // Core Required Fields
  name: '',
  email: '',
  Phone: '+256',
  Department: '',
  job_title: '',
  Role: 'Employee',
  HireDate: new Date().toISOString().split('T')[0],

  // Auto-populated Fields
  employee_id: '',
  PrimaryStationID: '',
  Salary: '',
  employment_type: 'Full-time',

  // System Defaults (Auto-filled by AI)
  country: 'Uganda',
  city: 'Kampala',
  state: 'Central Region',
  preferred_contact_method: 'Email',
  salary_type: 'Monthly',
  payment_method: 'Bank Transfer',
  work_schedule: 'Day Shift (8:00 AM - 5:00 PM)',
  shift_preference: 'Day',
  Status: 'Active',
  annual_leave_balance: '21.00',
  sick_leave_balance: '7.00',
  personal_leave_balance: '3.00',
  two_factor_enabled: '0',
  failed_login_attempts: '0',
  rehire_eligibility: 'Yes',
  tax_status: 'PAYE',
  mobile_money_provider: 'MTN',
  emergency_contact_relationship: 'Spouse',
})

const formErrors = reactive({})

// ============================================================================
// AI INTELLIGENCE ENGINE
// ============================================================================

// AI-Powered Auto-Completion for Uganda Context
const aiAutoComplete = {
  // Uganda-specific job titles with salary ranges (UGX)
  ugandanJobTitles: [
    { title: 'Station Manager', dept: 'Operations', salary: 2500000, level: 'Management' },
    { title: 'Fuel Attendant', dept: 'Operations', salary: 800000, level: 'Entry' },
    { title: 'Cashier', dept: 'Finance', salary: 900000, level: 'Entry' },
    { title: 'Security Guard', dept: 'Security', salary: 700000, level: 'Entry' },
    { title: 'Accountant', dept: 'Finance', salary: 1800000, level: 'Professional' },
    {
      title: 'Human Resources Officer',
      dept: 'Human Resources',
      salary: 1600000,
      level: 'Professional',
    },
    { title: 'IT Technician', dept: 'Information Technology', salary: 1400000, level: 'Technical' },
    { title: 'Maintenance Supervisor', dept: 'Maintenance', salary: 1200000, level: 'Supervisor' },
    { title: 'Sales Representative', dept: 'Sales', salary: 1100000, level: 'Professional' },
    { title: 'General Manager', dept: 'Management', salary: 4000000, level: 'Executive' },
  ],

  // Smart Employee ID Generation
  generateEmployeeId: (name, department, hireDate) => {
    const year = new Date(hireDate).getFullYear().toString().slice(-2)
    const deptCode = department?.substring(0, 3).toUpperCase() || 'GEN'
    const nameCode = name?.substring(0, 2).toUpperCase() || 'EMP'
    const random = Math.floor(Math.random() * 999)
      .toString()
      .padStart(3, '0')
    return `KIG${year}${deptCode}${nameCode}${random}`
  },

  // Intelligent Salary Suggestion
  suggestSalary: (jobTitle, department, experience = 0) => {
    const job = aiAutoComplete.ugandanJobTitles.find(
      (j) =>
        j.title.toLowerCase().includes(jobTitle?.toLowerCase()) ||
        j.dept.toLowerCase().includes(department?.toLowerCase()),
    )

    if (!job) return 1000000 // Default 1M UGX

    // Adjust for experience (5% per year)
    const experienceMultiplier = 1 + experience * 0.05
    return Math.round(job.salary * experienceMultiplier)
  },

  // Smart Phone Number Formatting
  formatUgandanPhone: (phone) => {
    if (!phone) return '+256'

    // Remove all non-digits
    const digits = phone.replace(/\D/g, '')

    // If starts with 256, format as +256 XXX XXX XXX
    if (digits.startsWith('256')) {
      return `+${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 9)} ${digits.substring(9, 12)}`
    }

    // If starts with 0, replace with 256
    if (digits.startsWith('0')) {
      const without0 = digits.substring(1)
      return `+256 ${without0.substring(0, 3)} ${without0.substring(3, 6)} ${without0.substring(6, 9)}`
    }

    // If 9 digits, assume it's missing 256
    if (digits.length === 9) {
      return `+256 ${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 9)}`
    }

    return phone.startsWith('+') ? phone : `+256 ${phone}`
  },

  // AI Email Generation
  generateEmail: (name, domain = 'kigrama.com') => {
    if (!name) return ''
    const cleanName = name
      .toLowerCase()
      .replace(/[^a-z\s]/g, '')
      .split(' ')
      .filter((part) => part.length > 0)

    if (cleanName.length === 1) {
      return `${cleanName[0]}@${domain}`
    } else if (cleanName.length >= 2) {
      return `${cleanName[0]}.${cleanName[1]}@${domain}`
    }
    return `employee@${domain}`
  },

  // Probation End Date Calculation (3 months for Uganda)
  calculateProbationEnd: (hireDate) => {
    if (!hireDate) return ''
    const hire = new Date(hireDate)
    hire.setMonth(hire.getMonth() + 3)
    return hire.toISOString().split('T')[0]
  },

  // Leave Cycle Calculation (January to December)
  calculateLeaveCycle: (hireDate) => {
    if (!hireDate) return { start: '', end: '' }
    const hire = new Date(hireDate)
    const year = hire.getFullYear()
    return {
      start: `${year}-01-01`,
      end: `${year}-12-31`,
    }
  },
}

// ============================================================================
// API CONFIGURATION - FIXED JSON PARSING
// ============================================================================

const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT_TOKEN = localStorage.getItem('jwt') || 'DEFAULT_DEV_TOKEN'

const apiCall = async (endpoint, method = 'GET', data = null) => {
  try {
    const config = {
      method,
      headers: {
        Authorization: `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
      },
    }

    if (data && (method === 'POST' || method === 'PATCH')) {
      config.body = JSON.stringify(data)
    }

    const response = await fetch(`${API_BASE_URL}${endpoint}`, config)

    if (!response.ok) {
      let errorMessage = `HTTP ${response.status}: ${response.statusText}`
      try {
        const errorData = await response.json()
        errorMessage = errorData.message || errorMessage
      } catch (jsonError) {
        console.warn('Could not parse error response as JSON:', jsonError)
      }
      throw new Error(errorMessage)
    }

    // Handle empty responses (common with TrailBase PATCH/DELETE)
    const contentType = response.headers.get('content-type')
    if (contentType && contentType.includes('application/json')) {
      const text = await response.text()
      if (text.trim() === '') {
        return {} // Return empty object for empty JSON responses
      }
      try {
        return JSON.parse(text)
      } catch (jsonError) {
        console.warn('Could not parse response as JSON:', text)
        return { success: true, message: 'Operation completed successfully' }
      }
    } else {
      // Non-JSON response
      return { success: true, message: 'Operation completed successfully' }
    }
  } catch (error) {
    console.error(`API Error for ${method} ${endpoint}:`, error)
    throw error
  }
}

// ============================================================================
// COMPUTED PROPERTIES
// ============================================================================

const totalEmployees = computed(() => employees.value.length)
const activeEmployees = computed(
  () => employees.value.filter((emp) => emp.Status === 'Active' || !emp.Status).length,
)
const activeEmployeesPercentage = computed(() =>
  totalEmployees.value > 0 ? Math.round((activeEmployees.value / totalEmployees.value) * 100) : 0,
)

const totalPayroll = computed(() => {
  return employees.value.reduce((sum, emp) => sum + (parseFloat(emp.Salary) || 0), 0)
})

const newHiresCount = computed(() => {
  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)
  return employees.value.filter((emp) => {
    if (!emp.HireDate) return false
    return new Date(emp.HireDate) >= thirtyDaysAgo
  }).length
})

const filteredEmployees = computed(() => {
  let filtered = [...employees.value]

  if (searchFilters.searchTerm) {
    const search = searchFilters.searchTerm.toLowerCase()
    filtered = filtered.filter(
      (emp) =>
        emp.name?.toLowerCase().includes(search) ||
        emp.email?.toLowerCase().includes(search) ||
        emp.employee_id?.toLowerCase().includes(search) ||
        emp.Phone?.toLowerCase().includes(search),
    )
  }

  if (searchFilters.department) {
    filtered = filtered.filter((emp) => emp.Department === searchFilters.department)
  }

  if (searchFilters.station) {
    filtered = filtered.filter((emp) => emp.PrimaryStationID === parseInt(searchFilters.station))
  }

  if (searchFilters.status) {
    filtered = filtered.filter((emp) => emp.Status === searchFilters.status)
  }

  return filtered
})

const totalPages = computed(() => Math.ceil(filteredEmployees.value.length / pageSize.value))
const paginatedEmployees = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  return filteredEmployees.value.slice(start, start + pageSize.value)
})

// ============================================================================
// AI WATCHERS - AUTO-POPULATION LOGIC
// ============================================================================

// Smart Name Processing
watch(
  () => employeeForm.name,
  (newName) => {
    if (newName && newName.length > 2) {
      // Auto-generate email if not manually set
      if (
        !employeeForm.email ||
        employeeForm.email === aiAutoComplete.generateEmail(employeeForm.previousName)
      ) {
        employeeForm.email = aiAutoComplete.generateEmail(newName)
      }

      // Auto-generate employee ID
      if (employeeForm.Department && employeeForm.HireDate) {
        employeeForm.employee_id = aiAutoComplete.generateEmployeeId(
          newName,
          employeeForm.Department,
          employeeForm.HireDate,
        )
      }

      employeeForm.previousName = newName
    }
  },
)

// Smart Department & Job Title Matching
watch(
  () => [employeeForm.Department, employeeForm.job_title],
  ([dept, title]) => {
    if (dept || title) {
      // Auto-suggest salary based on job title and department
      const suggestedSalary = aiAutoComplete.suggestSalary(title, dept)
      if (!employeeForm.Salary || employeeForm.Salary === '0') {
        employeeForm.Salary = suggestedSalary.toString()
      }

      // Regenerate employee ID if name exists
      if (employeeForm.name && employeeForm.HireDate) {
        employeeForm.employee_id = aiAutoComplete.generateEmployeeId(
          employeeForm.name,
          dept,
          employeeForm.HireDate,
        )
      }
    }
  },
)

// Smart Phone Formatting
watch(
  () => employeeForm.Phone,
  (phone) => {
    if (phone && phone !== '+256') {
      employeeForm.Phone = aiAutoComplete.formatUgandanPhone(phone)
    }
  },
)

// Smart Hire Date Processing
watch(
  () => employeeForm.HireDate,
  (hireDate) => {
    if (hireDate) {
      // Auto-calculate probation end date
      employeeForm.probation_end_date = aiAutoComplete.calculateProbationEnd(hireDate)

      // Auto-set leave cycle
      const leaveCycle = aiAutoComplete.calculateLeaveCycle(hireDate)
      employeeForm.leave_cycle_start_date = leaveCycle.start
      employeeForm.leave_cycle_end_date = leaveCycle.end

      // Regenerate employee ID if name and department exist
      if (employeeForm.name && employeeForm.Department) {
        employeeForm.employee_id = aiAutoComplete.generateEmployeeId(
          employeeForm.name,
          employeeForm.Department,
          hireDate,
        )
      }
    }
  },
)

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

const getEmployeeInitials = (employee) => {
  if (!employee?.name) return 'NA'
  return employee.name
    .split(' ')
    .map((n) => n[0])
    .join('')
    .toUpperCase()
    .substring(0, 2)
}

const getEmployeeStatusBadge = (status) => {
  switch (status) {
    case 'Active':
      return 'badge-light-success'
    case 'Inactive':
      return 'badge-light-warning'
    case 'Terminated':
      return 'badge-light-danger'
    default:
      return 'badge-light-primary'
  }
}

const getStationName = (stationId) => {
  if (!stationId) return 'Not Assigned'
  const station = stations.value.find((s) => s.StationID === parseInt(stationId))
  return station ? station.StationName : 'Unknown Station'
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  try {
    return new Date(dateStr).toLocaleDateString('en-GB', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    })
  } catch {
    return dateStr
  }
}

const formatCurrency = (amount) => {
  const num = parseFloat(amount) || 0
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
  }).format(num)
}

// ============================================================================
// CRUD OPERATIONS - FIXED UPDATE FUNCTIONALITY
// ============================================================================

const fetchEmployees = async () => {
  loading.value = true
  try {
    const response = await apiCall('/users')
    employees.value = response.records || []
  } catch (error) {
    console.error('Failed to fetch employees:', error)
    employees.value = []
  } finally {
    loading.value = false
  }
}

const fetchDepartments = async () => {
  try {
    const response = await apiCall('/Departments')
    departments.value = response.records || []
  } catch (error) {
    console.error('Failed to fetch departments:', error)
    departments.value = []
  }
}

const fetchStations = async () => {
  try {
    const response = await apiCall('/Stations')
    stations.value = response.records || []
  } catch (error) {
    console.error('Failed to fetch stations:', error)
    stations.value = []
  }
}

const fetchRoles = async () => {
  try {
    const response = await apiCall('/Roles')
    roles.value = response.records || []
  } catch (error) {
    console.error('Failed to fetch roles:', error)
    roles.value = []
  }
}

const validateForm = () => {
  Object.keys(formErrors).forEach((key) => delete formErrors[key])
  let isValid = true

  // Critical field validation
  if (!employeeForm.name.trim()) {
    formErrors.name = 'Full name is required'
    isValid = false
  }

  if (!employeeForm.email.trim()) {
    formErrors.email = 'Email address is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(employeeForm.email)) {
    formErrors.email = 'Please enter a valid email address'
    isValid = false
  }

  if (!employeeForm.Phone.trim() || employeeForm.Phone === '+256') {
    formErrors.Phone = 'Phone number is required'
    isValid = false
  }

  if (!employeeForm.Department) {
    formErrors.Department = 'Department is required'
    isValid = false
  }

  if (!employeeForm.job_title.trim()) {
    formErrors.job_title = 'Job title is required'
    isValid = false
  }

  if (!employeeForm.Role) {
    formErrors.Role = 'System role is required'
    isValid = false
  }

  if (!employeeForm.HireDate) {
    formErrors.HireDate = 'Hire date is required'
    isValid = false
  }

  return isValid
}

const submitEmployee = async () => {
  if (!validateForm()) {
    Swal.fire({
      title: 'Validation Error',
      text: 'Please correct the errors before submitting',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  saving.value = true
  try {
    const currentTimestamp = new Date().toISOString()

    // Prepare optimized employee data with AI enhancements
    const submitData = {
      // Core Required Fields
      name: employeeForm.name.trim(),
      email: employeeForm.email.trim(),
      Phone: employeeForm.Phone.trim(),
      Department: employeeForm.Department,
      job_title: employeeForm.job_title.trim(),
      Role: employeeForm.Role,
      HireDate: employeeForm.HireDate,

      // AI Auto-generated Fields
      employee_id:
        employeeForm.employee_id ||
        aiAutoComplete.generateEmployeeId(
          employeeForm.name,
          employeeForm.Department,
          employeeForm.HireDate,
        ),
      password: employeeForm.email.trim(), // Email as password
      UserID:
        employeeForm.employee_id ||
        aiAutoComplete.generateEmployeeId(
          employeeForm.name,
          employeeForm.Department,
          employeeForm.HireDate,
        ),

      // Optional but Important
      PrimaryStationID: employeeForm.PrimaryStationID
        ? parseInt(employeeForm.PrimaryStationID)
        : null,
      Salary: employeeForm.Salary ? parseFloat(employeeForm.Salary).toString() : null,
      employment_type: employeeForm.employment_type,

      // AI Smart Defaults
      country: 'Uganda',
      city: employeeForm.city || 'Kampala',
      state: employeeForm.state || 'Central Region',
      preferred_contact_method: 'Email',
      salary_type: 'Monthly',
      payment_method: 'Bank Transfer',
      work_schedule: 'Day Shift (8:00 AM - 5:00 PM)',
      shift_preference: 'Day',
      Status: 'Active',
      annual_leave_balance: '21.00',
      sick_leave_balance: '7.00',
      personal_leave_balance: '3.00',
      two_factor_enabled: '0',
      failed_login_attempts: '0',
      rehire_eligibility: 'Yes',
      tax_status: 'PAYE',
      mobile_money_provider: 'MTN',

      // Auto-calculated Dates
      probation_end_date: aiAutoComplete.calculateProbationEnd(employeeForm.HireDate),
      leave_cycle_start_date: aiAutoComplete.calculateLeaveCycle(employeeForm.HireDate).start,
      leave_cycle_end_date: aiAutoComplete.calculateLeaveCycle(employeeForm.HireDate).end,

      // System Fields
      updated_at: currentTimestamp,
      updated_by: '1',
    }

    // Add created fields only for new employees
    if (!employeeForm.isEdit) {
      submitData.created_at = currentTimestamp
      submitData.created_by = '1'
      submitData.preferences = JSON.stringify({
        theme: 'light',
        language: 'en',
        notifications: true,
        currency: 'UGX',
        timezone: 'Africa/Kampala',
      })
    }

    // Remove null/undefined values to prevent backend issues
    Object.keys(submitData).forEach((key) => {
      if (submitData[key] === null || submitData[key] === undefined || submitData[key] === '') {
        delete submitData[key]
      }
    })

    const endpoint = employeeForm.isEdit ? `/users/${employeeForm.id}` : '/users'
    const method = employeeForm.isEdit ? 'PATCH' : 'POST'

    const result = await apiCall(endpoint, method, submitData)

    Swal.fire({
      title: 'Success!',
      html: `
        <div class="text-start">
          <p><strong>Employee ${employeeForm.isEdit ? 'updated' : 'created'} successfully!</strong></p>
          <hr>
          <p><strong>Login Credentials:</strong></p>
          <p>Username: <code>${submitData.email}</code></p>
          <p>Password: <code>${submitData.email}</code></p>
          <p class="text-muted small">Employee can login immediately with their email as both username and password.</p>
        </div>
      `,
      icon: 'success',
      confirmButtonColor: '#50cd89',
    })

    // Close modal and refresh
    const modal = bootstrap.Modal.getInstance(document.getElementById('employeeModal'))
    modal?.hide()

    await fetchEmployees()
    resetForm()
  } catch (error) {
    console.error('Failed to submit employee:', error)
    Swal.fire({
      title: 'Submission Failed',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

const resetForm = () => {
  Object.assign(employeeForm, {
    isEdit: false,
    id: null,
    name: '',
    email: '',
    Phone: '+256',
    Department: '',
    job_title: '',
    Role: 'Employee',
    HireDate: new Date().toISOString().split('T')[0],
    employee_id: '',
    PrimaryStationID: '',
    Salary: '',
    employment_type: 'Full-time',
  })
  Object.keys(formErrors).forEach((key) => delete formErrors[key])
}

// ============================================================================
// EVENT HANDLERS
// ============================================================================

const openEmployeeModal = () => {
  resetForm()
  const modal = new bootstrap.Modal(document.getElementById('employeeModal'))
  modal.show()
}

const editEmployee = (employee) => {
  Object.assign(employeeForm, {
    ...employee,
    isEdit: true,
  })

  const modal = new bootstrap.Modal(document.getElementById('employeeModal'))
  modal.show()
}

const viewEmployee = (employee) => {
  selectedEmployee.value = employee
  const modal = new bootstrap.Modal(document.getElementById('viewModal'))
  modal.show()
}

const applyFilters = () => {
  currentPage.value = 1
}

const resetFilters = () => {
  Object.assign(searchFilters, {
    searchTerm: '',
    department: '',
    station: '',
    status: '',
  })
  currentPage.value = 1
}

// Quick Add with AI Suggestions
const quickAddEmployee = () => {
  Swal.fire({
    title: 'AI Quick Add Employee',
    html: `
      <div class="text-start">
        <div class="mb-3">
          <label class="form-label fw-bold">Full Name</label>
          <input id="quickName" type="text" class="form-control form-control-lg" placeholder="Enter employee name">
        </div>
        <div class="mb-3">
          <label class="form-label fw-bold">Department</label>
          <select id="quickDept" class="form-select form-select-lg">
            <option value="">Select Department</option>
            ${departments.value.map((d) => `<option value="${d.DepartmentName}">${d.DepartmentName}</option>`).join('')}
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label fw-bold">Job Title</label>
          <select id="quickJob" class="form-select form-select-lg">
            <option value="">Select Job Title</option>
            ${aiAutoComplete.ugandanJobTitles.map((j) => `<option value="${j.title}" data-salary="${j.salary}">${j.title} (${formatCurrency(j.salary)})</option>`).join('')}
          </select>
        </div>
      </div>
    `,
    focusConfirm: false,
    showCancelButton: true,
    confirmButtonText: 'Create Employee',
    confirmButtonColor: '#50cd89',
    preConfirm: () => {
      const name = document.getElementById('quickName').value
      const dept = document.getElementById('quickDept').value
      const job = document.getElementById('quickJob').value

      if (!name || !dept || !job) {
        Swal.showValidationMessage('Please fill all fields')
        return false
      }

      return { name, dept, job }
    },
  }).then((result) => {
    if (result.isConfirmed) {
      const { name, dept, job } = result.value

      // Auto-populate form with AI suggestions
      Object.assign(employeeForm, {
        name,
        Department: dept,
        job_title: job,
        email: aiAutoComplete.generateEmail(name),
        Phone: '+256',
        Role: 'Employee',
        HireDate: new Date().toISOString().split('T')[0],
        employment_type: 'Full-time',
        Salary: aiAutoComplete.suggestSalary(job, dept).toString(),
      })

      openEmployeeModal()
    }
  })
}

const quickUpdate = (employee) => {
  Swal.fire({
    title: 'Quick Update',
    html: `
      <div class="text-start">
        <p><strong>Employee:</strong> ${employee.name}</p>
        <div class="mb-3">
          <label class="form-label fw-bold">New Salary (UGX)</label>
          <input id="newSalary" type="number" class="form-control" value="${employee.Salary || 0}" step="50000">
        </div>
        <div class="mb-3">
          <label class="form-label fw-bold">Status</label>
          <select id="newStatus" class="form-select">
            <option value="Active" ${employee.Status === 'Active' ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${employee.Status === 'Inactive' ? 'selected' : ''}>Inactive</option>
            <option value="Terminated" ${employee.Status === 'Terminated' ? 'selected' : ''}>Terminated</option>
          </select>
        </div>
      </div>
    `,
    showCancelButton: true,
    confirmButtonText: 'Update',
    confirmButtonColor: '#50cd89',
  }).then((result) => {
    if (result.isConfirmed) {
      const newSalary = document.getElementById('newSalary').value
      const newStatus = document.getElementById('newStatus').value

      // Quick update via API
      apiCall(`/users/${employee.id}`, 'PATCH', {
        Salary: newSalary,
        Status: newStatus,
        updated_at: new Date().toISOString(),
      })
        .then(() => {
          Swal.fire('Updated!', 'Employee information updated successfully', 'success')
          fetchEmployees()
        })
        .catch((error) => {
          Swal.fire('Error!', error.message, 'error')
        })
    }
  })
}

// ============================================================================
// APEX CHARTS INITIALIZATION - FIXED
// ============================================================================

const initCharts = async () => {
  await nextTick()

  try {
    // Destroy existing charts
    if (departmentChartInstance) {
      departmentChartInstance.destroy()
      departmentChartInstance = null
    }
    if (hiringChartInstance) {
      hiringChartInstance.destroy()
      hiringChartInstance = null
    }

    // Department Distribution Chart
    const departmentElement = document.getElementById('departmentChart')
    if (departmentElement) {
      const deptData = departments.value
        .map((dept) => {
          const empCount = employees.value.filter(
            (emp) => emp.Department === dept.DepartmentName,
          ).length
          return { name: dept.DepartmentName, count: empCount }
        })
        .filter((d) => d.count > 0)

      if (deptData.length > 0) {
        const deptOptions = {
          series: deptData.map((d) => d.count),
          chart: {
            type: 'donut',
            height: 300,
            toolbar: { show: false },
          },
          labels: deptData.map((d) => d.name),
          colors: ['#F1416C', '#7239EA', '#009EF7', '#50CD89', '#FFC700', '#E4E6EF'],
          plotOptions: {
            pie: {
              donut: {
                size: '60%',
                labels: {
                  show: true,
                  total: {
                    show: true,
                    label: 'Total',
                    formatter: () => totalEmployees.value,
                  },
                },
              },
            },
          },
          legend: {
            position: 'bottom',
            fontSize: '14px',
          },
          responsive: [
            {
              breakpoint: 480,
              options: {
                chart: { height: 250 },
                legend: { position: 'bottom' },
              },
            },
          ],
        }

        if (window.ApexCharts) {
          departmentChartInstance = new ApexCharts(departmentElement, deptOptions)
          await departmentChartInstance.render()
        } else {
          // Fallback if ApexCharts not available
          departmentElement.innerHTML = `
            <div class="d-flex flex-column gap-3">
              ${deptData
                .map(
                  (dept) => `
                <div class="d-flex align-items-center justify-content-between">
                  <div class="d-flex align-items-center gap-3">
                    <div class="w-15px h-15px rounded bg-primary"></div>
                    <span class="fw-semibold text-gray-800">${dept.name}</span>
                  </div>
                  <span class="fw-bold text-gray-900">${dept.count}</span>
                </div>
              `,
                )
                .join('')}
            </div>
          `
        }
      }
    }

    // Hiring Trends Chart
    const hiringElement = document.getElementById('hiringChart')
    if (hiringElement) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ]
      const hiringData = [8, 12, 15, 10, 18, 22, 16, 14, 20, 25, 19, 23] // Simulated data

      const hiringOptions = {
        series: [
          {
            name: 'New Hires',
            data: hiringData,
          },
        ],
        chart: {
          type: 'area',
          height: 300,
          toolbar: { show: false },
          zoom: { enabled: false },
        },
        xaxis: {
          categories: months,
          labels: { style: { fontSize: '12px' } },
        },
        yaxis: {
          labels: { style: { fontSize: '12px' } },
        },
        colors: ['#009EF7'],
        fill: {
          type: 'gradient',
          gradient: {
            shadeIntensity: 1,
            opacityFrom: 0.7,
            opacityTo: 0.3,
          },
        },
        stroke: {
          curve: 'smooth',
          width: 3,
        },
        grid: {
          borderColor: '#E4E6EF',
          strokeDashArray: 4,
        },
        responsive: [
          {
            breakpoint: 480,
            options: {
              chart: { height: 250 },
            },
          },
        ],
      }

      if (window.ApexCharts) {
        hiringChartInstance = new ApexCharts(hiringElement, hiringOptions)
        await hiringChartInstance.render()
      } else {
        // Fallback if ApexCharts not available
        hiringElement.innerHTML = `
          <div class="d-flex flex-column gap-3">
            ${months
              .map(
                (month, index) => `
              <div class="d-flex align-items-center justify-content-between">
                <span class="fw-semibold text-gray-700">${month} 2024</span>
                <div class="d-flex align-items-center gap-2">
                  <div class="w-50px h-6px bg-light rounded overflow-hidden">
                    <div class="h-100 bg-success rounded" style="width: ${(hiringData[index] / 25) * 100}%"></div>
                  </div>
                  <span class="fw-bold text-gray-900">${hiringData[index]}</span>
                </div>
              </div>
            `,
              )
              .join('')}
          </div>
        `
      }
    }
  } catch (error) {
    console.error('Chart initialization error:', error)
  }
}

// ============================================================================
// LIFECYCLE
// ============================================================================

onMounted(async () => {
  try {
    await Promise.all([fetchEmployees(), fetchDepartments(), fetchStations(), fetchRoles()])

    // Initialize charts after data loads
    setTimeout(initCharts, 1500)
  } catch (error) {
    console.error('Failed to initialize:', error)
    Swal.fire({
      title: 'Initialization Error',
      text: 'Failed to load data. Please refresh.',
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
})

// Watch for data changes to reinitialize charts
watch(
  [employees, departments],
  () => {
    if (employees.value.length > 0 && departments.value.length > 0) {
      setTimeout(initCharts, 500)
    }
  },
  { deep: false },
)
</script>

<style scoped>
/* Minimal custom styles - Maximum 30 lines */
.bg-gradient-primary {
  background: linear-gradient(135deg, #009ef7 0%, #7239ea 100%);
}

.bg-gradient-success {
  background: linear-gradient(135deg, #50cd89 0%, #009ef7 100%);
}

.hover-bg-light-primary:hover {
  background-color: rgba(0, 158, 247, 0.1) !important;
  transition: background-color 0.2s ease;
}

.symbol-label {
  border-radius: 12px;
}

.card {
  border-radius: 15px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.08);
}

.btn {
  border-radius: 10px;
  font-weight: 600;
}

.form-control,
.form-select {
  border-radius: 10px;
  border: 1px solid #e4e6ef;
}

.form-control:focus,
.form-select:focus {
  border-color: #009ef7;
  box-shadow: 0 0 0 0.2rem rgba(0, 158, 247, 0.25);
}
</style>

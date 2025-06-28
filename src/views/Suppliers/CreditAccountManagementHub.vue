<template>
  <div class="d-flex flex-column gap-8 p-6 bg-light rounded-4">
    <!-- Premium Helper Card with Info Modal -->
    <div
      class="card card-flush bg-light-primary shadow-lg mb-5 rounded-4 border-0 position-relative"
    >
      <div
        class="card-header border-0 py-4 px-4 d-flex align-items-center justify-content-between bg-gradient-primary rounded-top-4"
      >
        <h2
          class="card-title fw-bolder fs-1 d-flex align-items-center text-primary fw-bold gap-3 text-white"
        >
          <i class="ki-duotone ki-help-circle fs-1 t text-warning">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
          <span class="d-block text-primary fw-bold">Credit Account Workflow</span>
        </h2>
        <button
          class="btn btn-light-warning btn-icon btn-lg shadow-sm"
          @click="showCreditInfo = true"
          aria-label="More info"
          style="min-width: 44px; min-height: 44px"
        >
          <i class="ki-duotone ki-information-5 fs-2 text-warning">
            <span class="path1"></span>
            <span class="path2"></span>
          </i>
        </button>
      </div>

      <div class="card-body px-4 pt-4 pb-2 fs-5 bg-light-primary rounded-bottom-4">
        <ul class="ps-2 mb-3 fs-6">
          <li class="mb-2 d-flex align-items-start gap-2">
            <span class="badge badge-light-warning rounded-pill fw-bold fs-8 px-3 py-1 mt-1"
              >1</span
            >
            <span class="text-gray-900"
              >Select your fuel station to unlock supplier and credit features.</span
            >
          </li>
          <li class="mb-2 d-flex align-items-start gap-2">
            <span class="badge badge-light-success rounded-pill fw-bold fs-8 px-3 py-1 mt-1"
              >2</span
            >
            <span>
              Assign suppliers
              <span class="badge badge-light-warning ms-1 fs-9">Station Relationship</span> — each
              supplier must be linked to a station before credit is granted.
            </span>
          </li>
          <li class="mb-2 d-flex align-items-start gap-2">
            <span class="badge badge-light-info rounded-pill fw-bold fs-8 px-3 py-1 mt-1">3</span>
            <span>
              Create/manage
              <span class="badge badge-light-info">Credit Accounts</span>
              for assigned suppliers. Each credit account ties to one supplier and one station only.
            </span>
          </li>
          <li class="d-flex align-items-start gap-2">
            <span class="badge badge-light-primary rounded-pill fw-bold fs-8 px-3 py-1 mt-1"
              >Pro</span
            >
            <span>
              Instantly link/unlink suppliers with the
              <span class="fw-bold text-primary">Relationship Manager</span> below.<br />
              <span class="text-gray-700"
                >All changes are logged for compliance and full transparency.</span
              >
            </span>
          </li>
        </ul>
        <div class="d-flex flex-wrap gap-3 align-items-center mt-3">
          <span class="badge badge-light fs-7 text-primary px-4 py-2 rounded-pill shadow-sm">
            <i class="ki-duotone ki-touch fs-2 me-2 text-primary">
              <span class="path1"></span><span class="path2"></span>
            </i>
            Tap a supplier card for relationship & account details
          </span>
          <span class="badge badge-light-danger fs-7 px-4 py-2 rounded-pill shadow-sm">
            <i class="ki-duotone ki-alert-triangle fs-2 me-2 text-danger">
              <span class="path1"></span><span class="path2"></span>
            </i>
            One active credit account per supplier per station
          </span>
          <span class="badge badge-light-success fs-7 px-4 py-2 rounded-pill shadow-sm">
            <i class="ki-duotone ki-shield-check fs-2 me-2 text-success">
              <span class="path1"></span><span class="path2"></span>
            </i>
            Full audit trail for every action
          </span>
        </div>
      </div>

      <!-- Information Modal -->
      <div
        v-if="showCreditInfo"
        class="modal fade show d-block"
        tabindex="-1"
        style="background: rgba(0, 0, 0, 0.25); z-index: 1055"
        aria-modal="true"
        role="dialog"
      >
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content rounded-4 shadow-lg border-0 p-0 overflow-hidden">
            <div
              class="modal-header bg-light-warning rounded-top-4 py-4 px-4 d-flex align-items-center gap-3"
            >
              <i class="ki-duotone ki-credit-card fs-2 text-warning">
                <span class="path1"></span><span class="path2"></span>
              </i>
              <h5 class="modal-title fw-bold fs-2 text-warning mb-0">
                About Credit Accounts & Relationships
              </h5>
              <button
                type="button"
                class="btn-close ms-auto"
                aria-label="Close"
                style="filter: invert(0.7)"
                @click="showCreditInfo = false"
              ></button>
            </div>
            <div class="modal-body p-5 bg-white text-gray-900 fs-5">
              <div class="mb-3">
                <p>
                  <b>Credit Accounts</b> power supplier management.<br />
                  Each <span class="badge badge-light-info">Credit Account</span> links a
                  <b>Supplier</b> to a <b>Station</b> with agreed credit limits and payment terms.
                </p>
                <ul class="mb-3 ps-3">
                  <li>
                    <b>One supplier, many stations:</b> Each station can have unique credit terms
                    for the same supplier.
                  </li>
                  <li>
                    <b>Full traceability:</b> All actions are recorded for compliance and auditing.
                  </li>
                  <li>
                    <b>ERP-wide impact:</b> Managing credit accounts controls supply on credit, cash
                    flow, and risk.
                  </li>
                  <li>
                    <b>Cannot duplicate:</b> Only one active credit account per supplier per station
                    is allowed.
                  </li>
                </ul>
                <div
                  class="alert alert-light-info rounded-3 fs-6 p-3 d-flex align-items-center gap-3 mt-4"
                >
                  <i class="ki-duotone ki-information fs-2 text-info">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  <span>
                    <b>Best Practice:</b> Always link suppliers to stations before creating a credit
                    account. This enables precise control and clear supplier accountability for
                    every station.
                  </span>
                </div>
              </div>
              <button
                class="btn btn-light-primary btn-lg w-100 fw-bold rounded-pill mt-2"
                @click="showCreditInfo = false"
                style="min-height: 48px"
              >
                <i class="ki-duotone ki-check-square fs-2 me-2 text-primary">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                Got it, let's manage credit!
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 🌍 Station Picker -->
    <div class="card card-flush border-0 shadow-sm bg-light-info mb-3">
      <div class="card-header py-4">
        <h2 class="card-title fs-2 fw-bold text-primary d-flex align-items-center gap-2">
          <i class="ki-duotone ki-map-pin fs-1">
            <span class="path1"></span><span class="path2"></span>
          </i>
          Select Station
        </h2>
      </div>
      <div class="card-body">
        <select
          class="form-select form-select-lg"
          v-model="selectedStationId"
          @change="handleStationChange"
          :disabled="loadingStations"
        >
          <option value="">-- Choose a Station --</option>
          <option v-for="st in stations" :key="st.StationID" :value="st.StationID">
            {{ st.StationName }}
          </option>
        </select>
        <div v-if="!selectedStationId" class="text-danger mt-2 fs-6">
          Please select a station to begin.
        </div>
      </div>
    </div>

    <!-- 🤝 Supplier–Station Relationship Management -->
    <div v-if="selectedStationId" class="card card-flush bg-white shadow-lg mb-2">
      <div
        class="card-header py-4 d-flex flex-wrap align-items-center gap-3 justify-content-between"
      >
        <h3 class="card-title fw-bold fs-2 text-gray-800">
          <i class="ki-duotone ki-link fs-1 me-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          Station–Supplier Relationship Manager
        </h3>
        <button class="btn btn-light-primary btn-lg fw-bold" @click="showAssignModal = true">
          <i class="ki-duotone ki-plus-square fs-2 me-1"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          Assign Suppliers
        </button>
      </div>
      <div class="card-body d-flex flex-column gap-4">
        <div v-if="loadingAssignments" class="d-flex justify-content-center py-8">
          <span class="spinner-border text-primary"></span>
        </div>
        <div v-else-if="assignedSuppliers.length === 0" class="text-center fs-5 text-gray-600">
          No suppliers assigned to this station.<br />
          <span class="fs-7 text-muted"
            >Use <b>Assign Suppliers</b> to link suppliers to this station.</span
          >
        </div>
        <div v-else class="d-flex flex-wrap gap-3">
          <div
            v-for="sup in assignedSuppliers"
            :key="sup.SupplierID"
            class="card bg-light-success border-0 rounded-3 shadow-sm p-3 d-flex flex-row align-items-center justify-content-between min-w-200px flex-grow-1"
          >
            <div>
              <div class="fs-5 fw-bold text-dark d-flex align-items-center gap-1">
                <i class="ki-duotone ki-user-square fs-2 me-2"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
                {{ sup.Name }}
                <span class="badge badge-light-success ms-2">Assigned</span>
              </div>
              <div class="fs-7 text-gray-700">TIN: {{ sup.TaxIdentificationNumber || 'N/A' }}</div>
              <div class="fs-8 text-gray-500">Email: {{ sup.Email || 'N/A' }}</div>
            </div>
            <div>
              <button
                class="btn btn-outline-danger btn-icon btn-lg"
                :title="'Unassign Supplier'"
                @click="unassignSupplier(sup.SupplierID)"
              >
                <i class="ki-duotone ki-unlink fs-2"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ASSIGN SUPPLIERS MODAL -->
    <div
      v-if="showAssignModal"
      class="offcanvas offcanvas-end show bg-white"
      tabindex="-1"
      style="visibility: visible"
    >
      <div class="offcanvas-header border-bottom py-4">
        <h4 class="offcanvas-title fw-bold fs-2 text-primary">
          <i class="ki-duotone ki-link-square fs-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          Assign Suppliers to Station
        </h4>
        <button class="btn btn-light btn-icon" @click="showAssignModal = false">
          <i class="ki-duotone ki-cross fs-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
        </button>
      </div>
      <div class="offcanvas-body">
        <div v-if="loadingSuppliers" class="text-center py-5">
          <span class="spinner-border text-primary"></span>
        </div>
        <div v-else>
          <form @submit.prevent="assignSuppliers" class="d-flex flex-column gap-3">
            <label class="fw-bold fs-6 mb-1">Select suppliers to assign:</label>
            <div class="d-flex flex-column gap-2 mb-3">
              <div v-for="s in availableSuppliers" :key="s.SupplierID" class="form-check">
                <input
                  type="checkbox"
                  class="form-check-input"
                  :id="'sup-' + s.SupplierID"
                  v-model="toAssign"
                  :value="s.SupplierID"
                />
                <label class="form-check-label" :for="'sup-' + s.SupplierID"
                  >{{ s.Name }}
                  <span class="fs-8 text-gray-500 ms-1">{{
                    s.TaxIdentificationNumber
                  }}</span></label
                >
              </div>
            </div>
            <button
              class="btn btn-light-primary btn-lg fw-bold"
              :disabled="toAssign.length === 0 || submittingAssign"
            >
              <span v-if="submittingAssign" class="spinner-border spinner-border-sm me-2"></span>
              <i class="ki-duotone ki-link fs-2 me-2"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              Assign Selected
            </button>
          </form>
        </div>
      </div>
    </div>

    <!-- ANALYTICS & SUMMARY -->
    <div v-if="selectedStationId" class="d-flex flex-wrap gap-5 justify-content-center mb-2">
      <div
        class="card card-flush bg-light-primary shadow min-w-180px min-h-140px flex-grow-1 d-flex flex-column justify-content-between"
        v-for="card in summaryCards"
        :key="card.title"
      >
        <div class="card-body d-flex flex-column align-items-start gap-1">
          <div class="fw-bold fs-2 d-flex align-items-center gap-2 text-dark">
            <i :class="card.icon" class="me-2">
              <span class="path1"></span><span class="path2"></span>
              <span v-if="card.iconPaths > 2" class="path3"></span>
            </i>
            {{ card.value }}
          </div>
          <div class="fs-6 text-gray-700">{{ card.title }}</div>
        </div>
        <div class="card-footer bg-transparent pt-0">
          <span :class="card.badgeClass" class="badge fw-semibold px-4 py-2 fs-8">{{
            card.badge
          }}</span>
        </div>
      </div>
    </div>

    <!-- 💳 Credit Accounts Section -->
    <div v-if="selectedStationId" class="card card-flush bg-white shadow-lg mb-2">
      <div class="card-header align-items-center gap-4">
        <h3 class="card-title fw-bold fs-2 text-gray-800">
          <i class="ki-duotone ki-credit-card fs-1 me-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          Credit Accounts ({{ creditAccounts.length }})
        </h3>
        <button
          class="btn btn-light-success btn-lg fw-bold"
          @click="showCreate = true"
          :disabled="assignedSuppliers.length === 0"
        >
          <i class="ki-duotone ki-plus fs-2 me-1"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          New Credit Account
        </button>
      </div>
      <div class="card-body p-2 d-flex flex-column gap-5">
        <div v-if="loadingAccounts" class="d-flex justify-content-center py-8">
          <span class="spinner-border text-success"></span>
        </div>
        <div v-else-if="creditAccounts.length === 0" class="text-center fs-5 text-gray-600">
          No credit accounts for this station yet.
        </div>
        <div v-else class="d-flex flex-column gap-4">
          <div
            v-for="acc in creditAccounts"
            :key="acc.CreditAccountID"
            class="card bg-light-warning border-0 rounded-3 shadow-sm p-3 d-flex flex-row align-items-center justify-content-between"
          >
            <div>
              <div class="fs-4 fw-bold text-dark d-flex align-items-center gap-1">
                <i class="ki-duotone ki-user-square fs-2 me-2"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
                {{ acc.SupplierName }}
                <span :class="['badge', creditStatusBadge(acc.CreditStatus), 'ms-2']">{{
                  acc.CreditStatus
                }}</span>
              </div>
              <div class="fs-7 text-gray-700">
                Limit: <b>{{ money(acc.CreditLimit) }}</b> • Owing:
                <b>{{ money(acc.CurrentBalance) }}</b>
              </div>
              <div class="fs-7 text-gray-700">Terms: {{ acc.PaymentTermsDays }} days</div>
            </div>
            <div>
              <button
                class="btn btn-outline-primary btn-icon btn-lg me-1"
                @click="viewAccount(acc)"
                :title="'View Details'"
              >
                <i class="ki-duotone ki-eye fs-2"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
              </button>
              <button
                class="btn btn-outline-danger btn-icon btn-lg"
                @click="deleteAccount(acc.CreditAccountID)"
                :title="'Delete Account'"
              >
                <i class="ki-duotone ki-trash fs-2"
                  ><span class="path1"></span><span class="path2"></span
                ></i>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- CREATE/EDIT CREDIT ACCOUNT OFFCANVAS -->
    <div
      v-if="showCreate"
      class="offcanvas offcanvas-end show bg-white"
      tabindex="-1"
      style="visibility: visible"
    >
      <div class="offcanvas-header border-bottom py-4">
        <h4 class="offcanvas-title fw-bold fs-2 text-primary">
          <i class="ki-duotone ki-add-square fs-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          {{ editingAccount ? 'Edit Credit Account' : 'New Credit Account' }}
        </h4>
        <button class="btn btn-light btn-icon" @click="resetForm">
          <i class="ki-duotone ki-cross fs-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
        </button>
      </div>
      <div class="offcanvas-body">
        <form @submit.prevent="handleCreateOrUpdate" class="d-flex flex-column gap-4">
          <div>
            <label class="form-label required fw-bold fs-6">Supplier (Assigned Only)</label>
            <select v-model="form.SupplierID" required class="form-select form-select-lg">
              <option value="">-- Select Supplier --</option>
              <option v-for="s in assignedSuppliers" :key="s.SupplierID" :value="s.SupplierID">
                {{ s.Name }}
              </option>
            </select>
            <div v-if="assignedSuppliers.length === 0" class="text-danger fs-7 mt-1">
              No assigned suppliers! <br />
              <b>Assign suppliers to this station first.</b>
            </div>
          </div>
          <div>
            <label class="form-label required fw-bold fs-6">Credit Limit</label>
            <input
              type="number"
              min="0"
              step="0.01"
              v-model="form.CreditLimit"
              class="form-control form-control-lg"
              required
            />
          </div>
          <div>
            <label class="form-label fw-bold fs-6">Payment Terms (Days)</label>
            <input
              type="number"
              min="1"
              max="180"
              v-model="form.PaymentTermsDays"
              class="form-control form-control-lg"
              required
            />
          </div>
          <div class="mt-2">
            <button class="btn btn-light-success btn-lg w-100 fw-bold" :disabled="submitting">
              <span v-if="submitting" class="spinner-border spinner-border-sm me-2"></span>
              <i class="ki-duotone ki-check-square fs-2 me-2"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              {{ editingAccount ? 'Update Account' : 'Create Account' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- CREDIT ACCOUNT DETAILS -->
    <div v-if="showDetail" class="card card-flush border-0 shadow-lg bg-white mt-2">
      <div class="card-header bg-light py-4 d-flex justify-content-between align-items-center">
        <h4 class="card-title fw-bold fs-2 text-primary d-flex align-items-center gap-2">
          <i class="ki-duotone ki-file-text fs-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
          Account Details — {{ detailAccount?.SupplierName }}
        </h4>
        <button class="btn btn-light btn-icon" @click="showDetail = false">
          <i class="ki-duotone ki-cross fs-2"
            ><span class="path1"></span><span class="path2"></span
          ></i>
        </button>
      </div>
      <div class="card-body">
        <div class="row g-4 mb-2">
          <div class="col-6">
            <div class="fs-6 text-gray-700">Credit Limit</div>
            <div class="fs-4 fw-bold">{{ money(detailAccount.CreditLimit) }}</div>
          </div>
          <div class="col-6">
            <div class="fs-6 text-gray-700">Outstanding</div>
            <div class="fs-4 fw-bold">{{ money(detailAccount.CurrentBalance) }}</div>
          </div>
          <div class="col-6">
            <div class="fs-6 text-gray-700">Available Credit</div>
            <div class="fs-4 fw-bold">{{ money(detailAccount.AvailableCredit) }}</div>
          </div>
          <div class="col-6">
            <div class="fs-6 text-gray-700">Terms</div>
            <div class="fs-4 fw-bold">{{ detailAccount.PaymentTermsDays }} days</div>
          </div>
        </div>
        <div class="separator my-4"></div>
        <div>
          <h5 class="fw-bold fs-4 mb-2 text-success d-flex align-items-center">
            <i class="ki-duotone ki-timeline fs-2 me-2"
              ><span class="path1"></span><span class="path2"></span
            ></i>
            Credit Account Activity
          </h5>
          <div v-if="loadingTransactions" class="text-center py-4">
            <span class="spinner-border text-primary"></span>
          </div>
          <div v-else-if="transactions.length === 0" class="text-center fs-7 text-gray-600">
            No credit activity found.
          </div>
          <div v-else class="d-flex flex-column gap-3">
            <div
              v-for="txn in transactions"
              :key="txn.TransactionID"
              class="bg-light rounded-3 px-4 py-2 shadow-sm d-flex flex-row justify-content-between align-items-center"
            >
              <div class="fs-7">
                <b class="text-primary">{{ txn.TransactionType }}</b> <br />
                <span class="text-gray-700">{{ txn.Description }}</span>
              </div>
              <div>
                <span class="fw-bold fs-6 text-dark">{{ money(txn.Amount) }}</span>
                <div class="text-gray-600 fs-8">
                  {{ txn.CreatedAt?.slice(0, 16).replace('T', ' ') }}
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
import { ref, reactive, computed, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'
import axios from 'axios'

const API_BASE = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const jwt = localStorage.getItem('jwt') || ''
const showCreditInfo = ref(false)

const stations = ref([])
const loadingStations = ref(false)
const selectedStationId = ref('')
const assignedSuppliers = ref([])
const availableSuppliers = ref([])
const loadingSuppliers = ref(false)
const showAssignModal = ref(false)
const toAssign = ref([])
const submittingAssign = ref(false)
const loadingAssignments = ref(false)

const creditAccounts = ref([])
const loadingAccounts = ref(false)
const showCreate = ref(false)
const submitting = ref(false)
const form = reactive({
  SupplierID: '',
  CreditLimit: '',
  PaymentTermsDays: 30,
})
const editingAccount = ref(null)
const detailAccount = ref(null)
const showDetail = ref(false)
const transactions = ref([])
const loadingTransactions = ref(false)

// --- Summary KPIs
const summaryCards = computed(() => {
  const totalAccounts = creditAccounts.value.length
  const totalOwed = creditAccounts.value.reduce(
    (sum, acc) => sum + Number(acc.CurrentBalance || 0),
    0,
  )
  const totalCredit = creditAccounts.value.reduce(
    (sum, acc) => sum + Number(acc.CreditLimit || 0),
    0,
  )
  const atRisk = creditAccounts.value.filter((acc) => acc.CreditStatus !== 'Normal').length
  return [
    {
      title: 'Credit Accounts',
      value: totalAccounts,
      icon: 'ki-duotone ki-users fs-2',
      badge: totalAccounts > 0 ? 'Active' : 'None',
      badgeClass: totalAccounts > 0 ? 'badge-light-success' : 'badge-light-warning',
      iconPaths: 2,
    },
    {
      title: 'Total Owed',
      value: money(totalOwed),
      icon: 'ki-duotone ki-bank fs-2',
      badge: 'Outstanding',
      badgeClass: 'badge-light-warning',
      iconPaths: 2,
    },
    {
      title: 'Total Credit Limit',
      value: money(totalCredit),
      icon: 'ki-duotone ki-graph-up fs-2',
      badge: 'Credit Cap',
      badgeClass: 'badge-light-primary',
      iconPaths: 2,
    },
    {
      title: 'Accounts at Risk',
      value: atRisk,
      icon: 'ki-duotone ki-shield-alert fs-2',
      badge: atRisk > 0 ? 'Risk' : 'Normal',
      badgeClass: atRisk > 0 ? 'badge-light-danger' : 'badge-light-success',
      iconPaths: 2,
    },
  ]
})

const money = (val) =>
  'UGX ' + Number(val || 0).toLocaleString(undefined, { minimumFractionDigits: 2 })
const creditStatusBadge = (status) =>
  ({
    'Over Limit': 'badge-light-danger',
    'Near Limit': 'badge-light-warning',
    Normal: 'badge-light-success',
  })[status] || 'badge-light-secondary'

// ---- STATION & ASSIGNMENT HANDLERS ----
const fetchStations = async () => {
  loadingStations.value = true
  try {
    const { data } = await axios.get(`${API_BASE}/Stations`, {
      headers: { Authorization: `Bearer ${jwt}` },
    })
    stations.value = data.records || []
  } catch {
    stations.value = []
    Swal.fire({ title: 'Error!', text: 'Failed to load stations.', icon: 'error' })
  } finally {
    loadingStations.value = false
  }
}
const fetchAssignedSuppliers = async () => {
  if (!selectedStationId.value) return (assignedSuppliers.value = [])
  loadingAssignments.value = true
  try {
    const { data } = await axios.get(
      `${API_BASE}/SupplierStations?StationID=${selectedStationId.value}`,
      {
        headers: { Authorization: `Bearer ${jwt}` },
      },
    )
    const supplierIDs = (data.records || []).map((row) => row.SupplierID)
    if (supplierIDs.length === 0) {
      assignedSuppliers.value = []
      return
    }
    const { data: suppliersData } = await axios.get(
      `${API_BASE}/Suppliers?SupplierID=in.(${supplierIDs.join(',')})`,
      {
        headers: { Authorization: `Bearer ${jwt}` },
      },
    )
    assignedSuppliers.value = suppliersData.records || []
  } catch {
    assignedSuppliers.value = []
  } finally {
    loadingAssignments.value = false
  }
}
const fetchAvailableSuppliers = async () => {
  loadingSuppliers.value = true
  try {
    const { data } = await axios.get(`${API_BASE}/Suppliers`, {
      headers: { Authorization: `Bearer ${jwt}` },
    })
    // Exclude already assigned
    availableSuppliers.value = (data.records || []).filter(
      (s) => !assignedSuppliers.value.some((a) => a.SupplierID === s.SupplierID),
    )
  } catch {
    availableSuppliers.value = []
  } finally {
    loadingSuppliers.value = false
  }
}
const assignSuppliers = async () => {
  if (toAssign.value.length === 0 || !selectedStationId.value) return
  submittingAssign.value = true
  try {
    for (const supId of toAssign.value) {
      await axios.post(
        `${API_BASE}/SupplierStations`,
        {
          SupplierID: supId,
          StationID: selectedStationId.value,
        },
        { headers: { Authorization: `Bearer ${jwt}` } },
      )
      await logAudit('CREATE', 'SupplierStations', null, {
        SupplierID: supId,
        StationID: selectedStationId.value,
      })
    }
    Swal.fire({
      title: 'Assigned',
      text: 'Suppliers assigned to station.',
      icon: 'success',
      toast: true,
      timer: 2000,
      showConfirmButton: false,
      position: 'top-end',
    })
    toAssign.value = []
    showAssignModal.value = false
    await fetchAssignedSuppliers()
    await fetchAvailableSuppliers()
  } catch (e) {
    Swal.fire({
      title: 'Error',
      text: e?.response?.data?.message || 'Assignment failed',
      icon: 'error',
    })
  } finally {
    submittingAssign.value = false
  }
}
const unassignSupplier = async (supplierId) => {
  const confirm = await Swal.fire({
    title: 'Unassign Supplier?',
    text: 'This will remove the supplier from this station.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
  })
  if (!confirm.isConfirmed) return
  try {
    await axios.delete(`${API_BASE}/SupplierStations/${supplierId}`, {
      headers: { Authorization: `Bearer ${jwt}` },
      params: { StationID: selectedStationId.value },
    })
    await logAudit('DELETE', 'SupplierStations', supplierId, { StationID: selectedStationId.value })
    Swal.fire({
      title: 'Removed',
      text: 'Supplier unassigned.',
      icon: 'success',
      toast: true,
      timer: 2000,
      showConfirmButton: false,
      position: 'top-end',
    })
    await fetchAssignedSuppliers()
    await fetchAvailableSuppliers()
    await fetchCreditAccounts()
  } catch (e) {
    Swal.fire({
      title: 'Error',
      text: e?.response?.data?.message || 'Unassign failed.',
      icon: 'error',
    })
  }
}

// ---- CREDIT ACCOUNT HANDLERS ----
const fetchCreditAccounts = async () => {
  if (!selectedStationId.value) return (creditAccounts.value = [])
  loadingAccounts.value = true
  try {
    // Now fetch ALL credit accounts for this station (all assigned suppliers)
    const { data } = await axios.get(
      `${API_BASE}/SupplierCreditAccounts?StationID=${selectedStationId.value}`,
      {
        headers: { Authorization: `Bearer ${jwt}` },
      },
    )
    creditAccounts.value = data.records || []
  } catch {
    creditAccounts.value = []
    Swal.fire({ title: 'Error!', text: 'Failed to fetch credit accounts.', icon: 'error' })
  } finally {
    loadingAccounts.value = false
  }
}

const viewAccount = async (account) => {
  detailAccount.value = account
  showDetail.value = true
  fetchTransactions(account.SupplierID)
}

const fetchTransactions = async (supplierID) => {
  loadingTransactions.value = true
  try {
    const { data } = await axios.get(
      `${API_BASE}/SupplierCreditTransactions?SupplierID=${supplierID}&StationID=${selectedStationId.value}&_sort=-CreatedAt`,
      {
        headers: { Authorization: `Bearer ${jwt}` },
      },
    )
    transactions.value = data.records || []
  } catch {
    transactions.value = []
  } finally {
    loadingTransactions.value = false
  }
}
const resetForm = () => {
  showCreate.value = false
  editingAccount.value = null
  form.SupplierID = ''
  form.CreditLimit = ''
  form.PaymentTermsDays = 30
}
const handleCreateOrUpdate = async () => {
  if (!form.SupplierID || !form.CreditLimit || !selectedStationId.value) {
    Swal.fire({ title: 'Missing Fields', text: 'Please fill all required fields.', icon: 'error' })
    return
  }
  submitting.value = true
  try {
    // Before create, check if a credit account for this Supplier+Station already exists
    const exists = creditAccounts.value.find(
      (acc) => acc.SupplierID === form.SupplierID && acc.StationID == selectedStationId.value,
    )
    const payload = {
      SupplierID: form.SupplierID,
      StationID: selectedStationId.value,
      CreditLimit: form.CreditLimit,
      PaymentTermsDays: form.PaymentTermsDays,
      IsActive: '1',
    }
    if (!exists) {
      await axios.post(`${API_BASE}/SupplierCreditAccounts`, payload, {
        headers: { Authorization: `Bearer ${jwt}` },
      })
      await logAudit('CREATE', 'SupplierCreditAccounts', null, payload)
      Swal.fire({
        title: 'Success',
        text: 'Credit account created!',
        icon: 'success',
        toast: true,
        timer: 2000,
        showConfirmButton: false,
        position: 'top-end',
      })
    } else {
      // Update the existing account instead of creating a duplicate
      await axios.patch(`${API_BASE}/SupplierCreditAccounts/${exists.CreditAccountID}`, payload, {
        headers: { Authorization: `Bearer ${jwt}` },
      })
      await logAudit('UPDATE', 'SupplierCreditAccounts', exists.CreditAccountID, payload)
      Swal.fire({
        title: 'Updated',
        text: 'Credit account updated.',
        icon: 'success',
        toast: true,
        timer: 2000,
        showConfirmButton: false,
        position: 'top-end',
      })
    }
    await fetchCreditAccounts()
    resetForm()
  } catch (e) {
    Swal.fire({
      title: 'Error',
      text: e?.response?.data?.message || 'Operation failed',
      icon: 'error',
    })
  } finally {
    submitting.value = false
  }
}
const handleStationChange = () => {
  resetForm()
  showDetail.value = false
  fetchCreditAccounts()
  fetchAssignedSuppliers()
  fetchAvailableSuppliers()
}
const deleteAccount = async (accountId) => {
  const confirm = await Swal.fire({
    title: 'Delete Account?',
    text: 'Are you sure? This cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
  })
  if (!confirm.isConfirmed) return
  try {
    await axios.delete(`${API_BASE}/SupplierCreditAccounts/${accountId}`, {
      headers: { Authorization: `Bearer ${jwt}` },
    })
    await logAudit('DELETE', 'SupplierCreditAccounts', accountId, {})
    Swal.fire({
      title: 'Deleted',
      text: 'Credit account removed.',
      icon: 'success',
      toast: true,
      timer: 2000,
      showConfirmButton: false,
      position: 'top-end',
    })
    await fetchCreditAccounts()
  } catch (e) {
    Swal.fire({
      title: 'Error',
      text: e?.response?.data?.message || 'Delete failed.',
      icon: 'error',
    })
  }
}

// ---- AUDIT LOGGING ----
const logAudit = async (action, table, recordId, changes) => {
  try {
    await axios.post(
      `${API_BASE}/AuditLogs`,
      {
        StationID: selectedStationId.value,
        UserID: getUserId(),
        Action: action,
        TableName: table,
        RecordID: recordId,
        Changes: JSON.stringify(changes),
        IPAddress: '',
        LogTimestamp: new Date().toISOString(),
      },
      { headers: { Authorization: `Bearer ${jwt}` } },
    )
  } catch {}
}
const getUserId = () => {
  try {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    return user.id || null
  } catch {
    return null
  }
}

// ---- LIFECYCLE ----
onMounted(() => {
  fetchStations()
})

watch(selectedStationId, () => {
  if (selectedStationId.value) {
    fetchCreditAccounts()
    fetchAssignedSuppliers()
    fetchAvailableSuppliers()
  } else {
    creditAccounts.value = []
    assignedSuppliers.value = []
    availableSuppliers.value = []
    showDetail.value = false
  }
})
</script>

<style scoped>
.min-w-180px {
  min-width: 180px;
}
.min-h-140px {
  min-height: 140px;
}
.min-w-200px {
  min-width: 200px;
}
/* Only minor custom CSS - rest is Metronic */
</style>

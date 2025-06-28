<template>
  <div class="d-flex flex-column gap-5 p-5">
    <!-- 🚦 Station Selection Required Banner -->
    <div v-if="!selectedStation" class="alert alert-warning d-flex align-items-center">
      <i class="ki-duotone ki-warning-2 fs-1 text-warning me-3"
        ><span class="path1"></span><span class="path2"></span
      ></i>
      <div>
        <span class="fw-bold fs-5 text-warning">Select a Station to Manage Supplier Invoices</span>
        <div class="mt-1">
          <select
            v-model="selectedStation"
            class="form-select form-select-lg form-select-solid w-100 mt-2"
            @change="initStationScope"
          >
            <option value="" disabled selected>Select Station</option>
            <option v-for="station in stations" :key="station.StationID" :value="station.StationID">
              {{ station.StationName }} ({{ station.Location }})
            </option>
          </select>
        </div>
      </div>
    </div>

    <!-- 💎 Main Invoice Dashboard - Station Scoped -->
    <div v-else class="d-flex flex-column gap-7">
      <!-- Header -->
      <div class="card card-flush bg-gradient-primary">
        <div class="card-body py-5 px-4 d-flex flex-column gap-3">
          <div class="d-flex align-items-center justify-content-between">
            <div>
              <h2 class="text-white fw-bolder fs-2x mb-2">
                <i class="ki-duotone ki-bill text-white fs-2 me-2"
                  ><span class="path1"></span><span class="path2"></span><span class="path3"></span
                ></i>
                Station Invoices - {{ getStationName(selectedStation) }}
              </h2>
              <span class="badge badge-light-success fs-6">{{
                stationCredit?.CreditStatus || '...'
              }}</span>
              <div class="text-white-50 fs-6 mt-1">
                Credit Limit:
                <span class="fw-bold">UGX {{ formatAmount(stationCredit?.CreditLimit) }}</span>
                &nbsp;|&nbsp; Available:
                <span class="fw-bold">UGX {{ formatAmount(stationCredit?.AvailableCredit) }}</span>
              </div>
            </div>
            <button
              class="btn btn-light-success btn-lg px-6 py-3 fw-bold"
              @click="openInvoiceModal('new')"
            >
              <i class="ki-duotone ki-plus fs-2"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              New Invoice
            </button>
          </div>
          <div class="d-flex gap-3 mt-4">
            <div class="bg-white bg-opacity-10 rounded-3 p-4 text-center flex-fill">
              <div class="text-white fs-2hx fw-bold">{{ stats.total }}</div>
              <div class="text-white opacity-75 fs-7">Invoices</div>
            </div>
            <div class="bg-white bg-opacity-10 rounded-3 p-4 text-center flex-fill">
              <div class="text-warning fs-2hx fw-bold">{{ stats.outstanding }}</div>
              <div class="text-white opacity-75 fs-7">Outstanding</div>
            </div>
            <div class="bg-white bg-opacity-10 rounded-3 p-4 text-center flex-fill">
              <div class="text-danger fs-2hx fw-bold">{{ stats.overdue }}</div>
              <div class="text-white opacity-75 fs-7">Overdue</div>
            </div>
            <div class="bg-white bg-opacity-10 rounded-3 p-4 text-center flex-fill">
              <div class="text-success fs-2hx fw-bold">{{ stats.paid }}</div>
              <div class="text-white opacity-75 fs-7">Paid</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Controls -->
      <div class="card card-flush">
        <div class="card-header bg-light-primary">
          <div class="card-title fs-3 fw-bold text-primary">
            Invoices for <span class="fw-bolder">{{ getStationName(selectedStation) }}</span>
          </div>
          <div class="card-toolbar d-flex gap-2">
            <input
              v-model="search"
              class="form-control form-control-solid form-control-lg"
              placeholder="Search invoice number or supplier..."
              @input="filterInvoices"
            />
            <button class="btn btn-light-primary" @click="refreshAll">
              <i class="ki-duotone ki-arrows-circle fs-2"
                ><span class="path1"></span><span class="path2"></span
              ></i>
            </button>
          </div>
        </div>
        <div class="card-body p-0">
          <div v-if="loading" class="py-20 text-center">
            <div class="spinner-border text-primary"></div>
          </div>
          <div v-else>
            <div v-if="filteredInvoices.length === 0" class="text-center py-10 text-gray-500">
              <i class="ki-duotone ki-file-deleted fs-3x mb-3"
                ><span class="path1"></span><span class="path2"></span
              ></i>
              <div>No invoices found for this station</div>
            </div>
            <div v-else>
              <div class="row g-4">
                <div v-for="inv in filteredInvoices" :key="inv.id" class="col-12">
                  <div
                    class="card card-flush shadow-sm d-flex flex-row align-items-center p-4 gap-3"
                    :class="getStatusClass(inv.Status)"
                  >
                    <div class="flex-fill">
                      <div class="d-flex align-items-center gap-2">
                        <i class="ki-duotone ki-bill fs-2 text-primary"
                          ><span class="path1"></span><span class="path2"></span
                        ></i>
                        <span class="fw-bold fs-4">{{ inv.InvoiceNumber }}</span>
                        <span class="badge" :class="getStatusBadge(inv.Status)">{{
                          inv.Status
                        }}</span>
                      </div>
                      <div class="fs-7 text-gray-600 mt-1">
                        Supplier:
                        <span class="fw-bold">{{ getSupplierName(inv.SupplierID) }}</span> | Date:
                        {{ formatDate(inv.InvoiceDate) }}
                      </div>
                      <div class="fs-7 text-gray-600">
                        Due: <span :class="getDueClass(inv)">{{ formatDate(inv.DueDate) }}</span>
                      </div>
                      <div class="mt-1 d-flex gap-3 flex-wrap">
                        <span class="fs-7"
                          >Total:
                          <span class="fw-bold text-dark"
                            >UGX {{ formatAmount(inv.TotalAmount) }}</span
                          ></span
                        >
                        <span class="fs-7"
                          >Paid:
                          <span class="fw-bold text-success"
                            >UGX {{ formatAmount(inv.PaidAmount) }}</span
                          ></span
                        >
                        <span class="fs-7"
                          >Outstanding:
                          <span class="fw-bold text-danger"
                            >UGX {{ formatAmount(inv.OutstandingAmount) }}</span
                          ></span
                        >
                      </div>
                    </div>
                    <div class="d-flex flex-column gap-2">
                      <button
                        class="btn btn-light-primary btn-sm"
                        @click="openInvoiceModal('view', inv)"
                      >
                        <i class="ki-duotone ki-eye fs-2"
                          ><span class="path1"></span><span class="path2"></span
                        ></i>
                      </button>
                      <button
                        class="btn btn-light-warning btn-sm"
                        @click="openInvoiceModal('edit', inv)"
                        v-if="inv.Status !== 'Paid'"
                      >
                        <i class="ki-duotone ki-pencil fs-2"
                          ><span class="path1"></span><span class="path2"></span
                        ></i>
                      </button>
                      <button
                        class="btn btn-light-danger btn-sm"
                        @click="confirmDelete(inv)"
                        v-if="inv.Status !== 'Paid'"
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
          </div>
        </div>
      </div>

      <!-- Invoice Modal (Create, Edit, View) -->
      <div
        v-if="modalOpen"
        class="modal fade show d-block"
        tabindex="-1"
        style="background: rgba(0, 0, 0, 0.5)"
        @click.self="closeModal"
      >
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <form @submit.prevent="saveInvoice" novalidate v-if="modalMode !== 'view'">
              <div class="modal-header bg-primary">
                <h3 class="modal-title text-white fw-bold">
                  <i class="ki-duotone ki-bill text-white fs-2 me-2"
                    ><span class="path1"></span><span class="path2"></span
                  ></i>
                  {{ modalMode === 'edit' ? 'Edit Invoice' : 'Record New Invoice' }}
                </h3>
                <button class="btn btn-icon btn-light btn-sm" @click="closeModal">
                  <i class="ki-duotone ki-cross fs-2"
                    ><span class="path1"></span><span class="path2"></span
                  ></i>
                </button>
              </div>
              <div class="modal-body">
                <div class="row g-5">
                  <div class="col-12">
                    <label class="form-label required">Supplier</label>
                    <select
                      v-model="form.SupplierID"
                      class="form-select form-select-lg"
                      required
                      :disabled="modalMode === 'edit'"
                    >
                      <option value="" disabled>Select supplier</option>
                      <option
                        v-for="sup in suppliersAtStation"
                        :key="sup.SupplierID"
                        :value="sup.SupplierID"
                      >
                        {{ sup.Name }}
                      </option>
                    </select>
                    <div v-if="errors.SupplierID" class="text-danger">{{ errors.SupplierID }}</div>
                  </div>
                  <div class="col-12">
                    <label class="form-label required">Invoice Number</label>
                    <input
                      v-model="form.InvoiceNumber"
                      type="text"
                      class="form-control form-control-lg"
                      required
                    />
                    <div v-if="errors.InvoiceNumber" class="text-danger">
                      {{ errors.InvoiceNumber }}
                    </div>
                  </div>
                  <div class="col-12 col-md-6">
                    <label class="form-label required">Invoice Date</label>
                    <input
                      v-model="form.InvoiceDate"
                      type="date"
                      class="form-control form-control-lg"
                      required
                    />
                    <div v-if="errors.InvoiceDate" class="text-danger">
                      {{ errors.InvoiceDate }}
                    </div>
                  </div>
                  <div class="col-12 col-md-6">
                    <label class="form-label required">Due Date</label>
                    <input
                      v-model="form.DueDate"
                      type="date"
                      class="form-control form-control-lg"
                      required
                    />
                    <div v-if="errors.DueDate" class="text-danger">{{ errors.DueDate }}</div>
                  </div>
                  <div class="col-12">
                    <label class="form-label required">Total Amount (UGX)</label>
                    <input
                      v-model="form.TotalAmount"
                      type="number"
                      step="0.01"
                      min="0"
                      class="form-control form-control-lg"
                      required
                      @input="calcOutstanding"
                    />
                    <div v-if="errors.TotalAmount" class="text-danger">
                      {{ errors.TotalAmount }}
                    </div>
                  </div>
                  <div class="col-12">
                    <label class="form-label">Description</label>
                    <textarea
                      v-model="form.Description"
                      rows="2"
                      class="form-control form-control-lg"
                    ></textarea>
                  </div>
                  <div class="col-12" v-if="modalMode === 'edit'">
                    <label class="form-label">Paid Amount (UGX)</label>
                    <input
                      v-model="form.PaidAmount"
                      type="number"
                      step="0.01"
                      min="0"
                      :max="form.TotalAmount"
                      class="form-control form-control-lg"
                      @input="calcOutstanding"
                    />
                  </div>
                  <div class="col-12">
                    <div class="bg-light-info rounded p-4 text-center fw-bold">
                      Outstanding:
                      <span class="fs-3 text-danger"
                        >UGX {{ formatAmount(form.OutstandingAmount) }}</span
                      >
                    </div>
                  </div>
                </div>
              </div>
              <div class="modal-footer d-flex justify-content-between">
                <button class="btn btn-light" type="button" @click="closeModal">Cancel</button>
                <button class="btn btn-primary" :disabled="saving">
                  <span v-if="!saving"
                    >{{ modalMode === 'edit' ? 'Update' : 'Create' }} Invoice</span
                  >
                  <span v-else
                    >Please wait... <span class="spinner-border spinner-border-sm"></span
                  ></span>
                </button>
              </div>
            </form>

            <!-- Invoice View Modal -->
            <div v-else>
              <div class="modal-header bg-light-primary">
                <h3 class="modal-title text-primary fw-bold">
                  <i class="ki-duotone ki-bill text-primary fs-2 me-2"
                    ><span class="path1"></span><span class="path2"></span
                  ></i>
                  Invoice Details - {{ viewInvoice.InvoiceNumber }}
                </h3>
                <button class="btn btn-icon btn-light btn-sm" @click="closeModal">
                  <i class="ki-duotone ki-cross fs-2"
                    ><span class="path1"></span><span class="path2"></span
                  ></i>
                </button>
              </div>
              <div class="modal-body">
                <div class="row g-3">
                  <div class="col-12">
                    <div class="fw-bold fs-4 text-dark">
                      {{ getSupplierName(viewInvoice.SupplierID) }}
                    </div>
                    <div class="fs-7 text-gray-600">
                      Invoice Number: {{ viewInvoice.InvoiceNumber }}
                    </div>
                  </div>
                  <div class="col-6">
                    <span class="fw-semibold text-gray-700">Invoice Date:</span>
                    <span class="fs-7 text-dark">{{ formatDate(viewInvoice.InvoiceDate) }}</span>
                  </div>
                  <div class="col-6">
                    <span class="fw-semibold text-gray-700">Due Date:</span>
                    <span :class="getDueClass(viewInvoice)" class="fs-7">{{
                      formatDate(viewInvoice.DueDate)
                    }}</span>
                  </div>
                  <div class="col-6">
                    <span class="fw-semibold text-gray-700">Total:</span>
                    <span class="fs-7 text-dark"
                      >UGX {{ formatAmount(viewInvoice.TotalAmount) }}</span
                    >
                  </div>
                  <div class="col-6">
                    <span class="fw-semibold text-gray-700">Paid:</span>
                    <span class="fs-7 text-success"
                      >UGX {{ formatAmount(viewInvoice.PaidAmount) }}</span
                    >
                  </div>
                  <div class="col-12">
                    <span class="fw-semibold text-gray-700">Outstanding:</span>
                    <span class="fs-7 text-danger fw-bold"
                      >UGX {{ formatAmount(viewInvoice.OutstandingAmount) }}</span
                    >
                  </div>
                  <div class="col-12">
                    <span class="fw-semibold text-gray-700">Description:</span>
                    <span class="fs-7 text-gray-600">{{ viewInvoice.Description || '-' }}</span>
                  </div>
                  <div class="col-12">
                    <span class="fw-semibold text-gray-700">Status:</span>
                    <span class="badge" :class="getStatusBadge(viewInvoice.Status)">{{
                      viewInvoice.Status
                    }}</span>
                  </div>
                </div>
              </div>
              <div class="modal-footer d-flex justify-content-between">
                <button class="btn btn-light" @click="closeModal">Close</button>
                <button
                  class="btn btn-light-success"
                  v-if="viewInvoice.Status === 'Outstanding' || viewInvoice.Status === 'Overdue'"
                  @click="payInvoice(viewInvoice)"
                >
                  Process Payment
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Payment Modal -->
      <div
        v-if="showPayModal"
        class="modal fade show d-block"
        tabindex="-1"
        style="background: rgba(0, 0, 0, 0.5)"
        @click.self="closePayModal"
      >
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <form @submit.prevent="savePayment" novalidate>
              <div class="modal-header bg-success">
                <h3 class="modal-title text-white fw-bold">
                  <i class="ki-duotone ki-wallet text-white fs-2 me-2"
                    ><span class="path1"></span><span class="path2"></span
                  ></i>
                  Process Supplier Payment
                </h3>
                <button class="btn btn-icon btn-light btn-sm" @click="closePayModal">
                  <i class="ki-duotone ki-cross fs-2"
                    ><span class="path1"></span><span class="path2"></span
                  ></i>
                </button>
              </div>
              <div class="modal-body">
                <div class="row g-5">
                  <div class="col-12">
                    <label class="form-label required">Amount (UGX)</label>
                    <input
                      v-model="payForm.amount"
                      type="number"
                      min="1"
                      :max="payInvoiceObj.OutstandingAmount"
                      class="form-control form-control-lg"
                      required
                    />
                  </div>
                  <div class="col-12">
                    <label class="form-label required">Payment Method</label>
                    <select v-model="payForm.method" class="form-select form-select-lg" required>
                      <option value="Bank Transfer">Bank Transfer</option>
                      <option value="Cash">Cash</option>
                      <option value="Check">Check</option>
                      <option value="Mobile Money">Mobile Money</option>
                    </select>
                  </div>
                  <div class="col-12">
                    <label class="form-label">Reference (Bank/Receipt)</label>
                    <input
                      v-model="payForm.ref"
                      type="text"
                      class="form-control form-control-lg"
                      placeholder="Optional"
                    />
                  </div>
                  <div class="col-12">
                    <label class="form-label">Notes</label>
                    <textarea
                      v-model="payForm.notes"
                      rows="2"
                      class="form-control form-control-lg"
                    ></textarea>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button class="btn btn-light" type="button" @click="closePayModal">Cancel</button>
                <button class="btn btn-success" :disabled="paying">
                  <span v-if="!paying">Submit Payment</span>
                  <span v-else
                    >Please wait... <span class="spinner-border spinner-border-sm"></span
                  ></span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import Swal from 'sweetalert2'

// ==== CONSTANTS ====
const API = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const JWT = localStorage.getItem('jwt') || ''
const USER_ID = Number(localStorage.getItem('user_id')) || 4782875

// ==== STATE ====
const stations = ref([])
const suppliers = ref([])
const invoices = ref([])
const stationCredit = ref(null)
const search = ref('')
const loading = ref(false)
const selectedStation = ref('')
const modalOpen = ref(false)
const modalMode = ref('new')
const viewInvoice = ref({})
const form = ref({})
const errors = ref({})
const saving = ref(false)
const filteredInvoices = ref([])
const suppliersAtStation = ref([])
const stats = ref({ total: 0, outstanding: 0, overdue: 0, paid: 0 })
const showPayModal = ref(false)
const payInvoiceObj = ref({})
const payForm = ref({ amount: '', method: 'Bank Transfer', ref: '', notes: '' })
const paying = ref(false)

// ==== AGGRESSIVE AUDIT LOGGING ====
const logAudit = async ({
  action = '-',
  table = '-',
  record = 0,
  changes = '-',
  station = null,
  user = null,
}) => {
  const payload = {
    StationID: station || selectedStation.value || 0,
    UserID: user || USER_ID,
    Action: action || '-',
    TableName: table || '-',
    RecordID: record || 0,
    Changes: typeof changes === 'object' ? JSON.stringify(changes) : changes || '-',
    IPAddress: '-', // Optionally override with real IP
    LogTimestamp: new Date().toISOString(),
  }
  try {
    await api('/AuditLogs', { method: 'POST', body: JSON.stringify(payload) })
  } catch (err) {
    console.error('Audit log failed:', err)
  }
}

// ==== API UTILITY ====
const api = async (endpoint, opt = {}) => {
  let headers = { Authorization: `Bearer ${JWT}` }
  if (opt.method && (opt.method === 'POST' || opt.method === 'PATCH'))
    headers['Content-Type'] = 'application/json'
  let resp = await fetch(API + endpoint, { ...opt, headers })
  if (!resp.ok) {
    let msg = 'Unknown error'
    try {
      msg = (await resp.json()).message || resp.statusText
    } catch {}
    throw new Error(msg)
  }
  return await resp.json()
}

// ==== FETCH FUNCTIONS ====
const fetchStations = async () => {
  loading.value = true
  try {
    const r = await api('/Stations')
    stations.value = Array.isArray(r.records) ? r.records : []
  } catch {}
  loading.value = false
}

const fetchSuppliers = async () => {
  loading.value = true
  try {
    const r = await api('/Suppliers')
    suppliers.value = Array.isArray(r.records) ? r.records : []
  } catch {}
  loading.value = false
}

const fetchCredit = async () => {
  try {
    if (!selectedStation.value) return
    const r = await api(`/SupplierCreditAccounts?StationID=${selectedStation.value}`)
    // Defensive: always pick the first matching account for this station only
    stationCredit.value =
      Array.isArray(r.records) && r.records.length
        ? r.records.find((acct) => String(acct.StationID) === String(selectedStation.value)) ||
          r.records[0]
        : null
  } catch {}
}

const fetchInvoices = async () => {
  loading.value = true
  try {
    if (!selectedStation.value) {
      invoices.value = []
      filterInvoices()
      computeStats()
      loading.value = false
      return
    }
    // Always request invoices for this StationID only
    const r = await api(`/SupplierInvoices?StationID=${selectedStation.value}`)
    // Defensive: filter out any invoice not for this station (even if API returns bad data)
    const all = Array.isArray(r.records) ? r.records : []
    invoices.value = all.filter((inv) => String(inv.StationID) === String(selectedStation.value))
    filterInvoices()
    computeStats()
  } catch {
    invoices.value = []
    filterInvoices()
    computeStats()
  }
  loading.value = false
}

// ==== FILTER, SEARCH, AND DISPLAY HELPERS ====
const filterInvoices = () => {
  const s = search.value.toLowerCase()
  filteredInvoices.value = invoices.value.filter(
    (inv) =>
      !s ||
      String(inv.InvoiceNumber).toLowerCase().includes(s) ||
      getSupplierName(inv.SupplierID).toLowerCase().includes(s),
  )
}
const computeStats = () => {
  stats.value.total = invoices.value.length
  stats.value.outstanding = invoices.value.filter((i) => i.Status === 'Outstanding').length
  stats.value.overdue = invoices.value.filter((i) => i.Status === 'Overdue').length
  stats.value.paid = invoices.value.filter((i) => i.Status === 'Paid').length
}
const getSupplierName = (id) => {
  const sup = suppliers.value.find((s) => String(s.SupplierID) === String(id))
  return sup?.Name || 'Unknown'
}
const getStationName = (id) => {
  const st = stations.value.find((s) => String(s.StationID) === String(id))
  return st?.StationName || 'Unknown'
}
const formatAmount = (a) => Number(a || 0).toLocaleString('en-UG', { minimumFractionDigits: 2 })
const formatDate = (d) =>
  d
    ? new Date(d).toLocaleDateString('en-UG', { year: 'numeric', month: 'short', day: 'numeric' })
    : '-'
const getStatusBadge = (s) =>
  ({
    Outstanding: 'badge-light-warning',
    Overdue: 'badge-light-danger',
    Paid: 'badge-light-success',
  })[s] || 'badge-light'
const getStatusClass = (s) =>
  ({
    Outstanding: 'border-warning',
    Overdue: 'border-danger',
    Paid: 'border-success',
  })[s.Status] || 'border-light'
const getDueClass = (i) => {
  const due = new Date(i.DueDate),
    now = new Date()
  return due < now
    ? 'text-danger fw-bold'
    : (due - now) / 86400000 <= 7
      ? 'text-warning fw-bold'
      : 'text-dark'
}

// ==== MODAL LOGIC ====
const openInvoiceModal = (mode, invoice) => {
  errors.value = {}
  modalOpen.value = true
  modalMode.value = mode
  if (mode === 'view') {
    viewInvoice.value = { ...invoice }
  } else if (mode === 'edit') {
    form.value = { ...invoice }
    form.value.PaidAmount = Number(form.value.PaidAmount || 0)
    calcOutstanding()
  } else {
    form.value = {
      SupplierID: '',
      StationID: selectedStation.value,
      InvoiceNumber: '',
      InvoiceDate: '',
      DueDate: '',
      TotalAmount: '',
      PaidAmount: 0,
      OutstandingAmount: '',
      Status: 'Outstanding',
      Description: '',
      ReceivedBy: USER_ID,
    }
  }
  // Only show suppliers active at this station (and status Active)
  suppliersAtStation.value = suppliers.value.filter(
    (sup) => sup.Status === 'Active', // future: filter by station coverage if needed
  )
}
const closeModal = () => {
  modalOpen.value = false
  modalMode.value = 'new'
}
const saveInvoice = async () => {
  errors.value = {}
  if (!form.value.SupplierID) errors.value.SupplierID = 'Supplier required'
  if (!form.value.InvoiceNumber) errors.value.InvoiceNumber = 'Invoice number required'
  if (!form.value.InvoiceDate) errors.value.InvoiceDate = 'Invoice date required'
  if (!form.value.DueDate) errors.value.DueDate = 'Due date required'
  if (!form.value.TotalAmount || Number(form.value.TotalAmount) <= 0)
    errors.value.TotalAmount = 'Amount required'
  if (Object.keys(errors.value).length) return
  saving.value = true
  try {
    let payload = {
      ...form.value,
      StationID: selectedStation.value || 0,
      OutstandingAmount: Number(form.value.TotalAmount) - Number(form.value.PaidAmount || 0),
      Status: form.value.PaidAmount >= form.value.TotalAmount ? 'Paid' : 'Outstanding',
    }
    let method = modalMode.value === 'edit' ? 'PATCH' : 'POST'
    let url =
      modalMode.value === 'edit' ? `/SupplierInvoices/${form.value.id}` : `/SupplierInvoices`
    let resp = await api(url, { method, body: JSON.stringify(payload) })

    await logAudit({
      action: modalMode.value === 'edit' ? 'Edit' : 'Create',
      table: 'SupplierInvoices',
      record: resp.id || payload.InvoiceID || 0,
      changes: payload,
      station: selectedStation.value,
      user: USER_ID,
    })

    Swal.fire({
      title: 'Success!',
      text: 'Invoice saved',
      icon: 'success',
      toast: true,
      timer: 2000,
      position: 'top-end',
      showConfirmButton: false,
    })
    closeModal()
    await fetchInvoices()
    await fetchCredit()
  } catch (e) {
    Swal.fire({ title: 'Error', text: e.message, icon: 'error', confirmButtonColor: '#f1416c' })
  }
  saving.value = false
}
const calcOutstanding = () => {
  form.value.OutstandingAmount = Math.max(
    0,
    Number(form.value.TotalAmount || 0) - Number(form.value.PaidAmount || 0),
  )
}

// ==== DELETE LOGIC ====
const confirmDelete = (inv) => {
  Swal.fire({
    title: 'Delete Invoice?',
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#f1416c',
    confirmButtonText: 'Yes, delete',
    cancelButtonText: 'Cancel',
  }).then(async (r) => {
    if (!r.isConfirmed) return
    try {
      await api(`/SupplierInvoices/${inv.id}`, { method: 'DELETE' })
      await logAudit({
        action: 'Delete',
        table: 'SupplierInvoices',
        record: inv.id || inv.InvoiceID || 0,
        changes: inv,
        station: selectedStation.value,
        user: USER_ID,
      })
      Swal.fire({
        title: 'Deleted!',
        icon: 'success',
        toast: true,
        timer: 1500,
        position: 'top-end',
        showConfirmButton: false,
      })
      await fetchInvoices()
      await fetchCredit()
    } catch (e) {
      Swal.fire({
        title: 'Delete failed',
        text: e.message,
        icon: 'error',
        confirmButtonColor: '#f1416c',
      })
    }
  })
}

// ==== PAYMENT/ALLOCATION LOGIC ====
const payInvoice = (inv) => {
  showPayModal.value = true
  payInvoiceObj.value = { ...inv }
  payForm.value = { amount: inv.OutstandingAmount, method: 'Bank Transfer', ref: '', notes: '' }
}
const closePayModal = () => {
  showPayModal.value = false
}
const savePayment = async () => {
  if (!payForm.value.amount || payForm.value.amount <= 0) return
  paying.value = true
  try {
    let paymentPayload = {
      SupplierID: payInvoiceObj.value.SupplierID,
      StationID: selectedStation.value || 0,
      PaymentReference: 'PAY-' + Date.now(),
      PaymentDate: new Date().toISOString().split('T')[0],
      PaymentAmount: payForm.value.amount,
      PaymentMethod: payForm.value.method,
      BankReference: payForm.value.ref,
      Notes: payForm.value.notes,
      ProcessedBy: USER_ID,
      Status: 'Completed',
    }
    let payResp = await api('/SupplierPayments', {
      method: 'POST',
      body: JSON.stringify(paymentPayload),
    })
    let allocationPayload = {
      PaymentID: payResp.PaymentID || payResp.id || 0,
      InvoiceID: payInvoiceObj.value.InvoiceID || payInvoiceObj.value.id || 0,
      AllocatedAmount: payForm.value.amount,
      AllocationDate: new Date().toISOString().split('T')[0],
    }
    let allocResp = await api('/SupplierPaymentAllocations', {
      method: 'POST',
      body: JSON.stringify(allocationPayload),
    })

    await logAudit({
      action: 'Create',
      table: 'SupplierPayments',
      record: payResp.PaymentID || payResp.id || 0,
      changes: paymentPayload,
      station: selectedStation.value,
      user: USER_ID,
    })
    await logAudit({
      action: 'Create',
      table: 'SupplierPaymentAllocations',
      record: allocResp.AllocationID || allocResp.id || 0,
      changes: allocationPayload,
      station: selectedStation.value,
      user: USER_ID,
    })

    Swal.fire({
      title: 'Payment processed!',
      icon: 'success',
      toast: true,
      timer: 2000,
      position: 'top-end',
      showConfirmButton: false,
    })
    closePayModal()
    await fetchInvoices()
    await fetchCredit()
  } catch (e) {
    Swal.fire({
      title: 'Payment Failed',
      text: e.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  }
  paying.value = false
}

// ==== SCOPE MANAGEMENT ====
const initStationScope = async () => {
  await fetchCredit()
  await fetchSuppliers()
  await fetchInvoices()
}
const refreshAll = async () => {
  await initStationScope()
}

onMounted(async () => {
  await fetchStations()
})
watch(selectedStation, async () => {
  if (selectedStation.value) await initStationScope()
})
</script>

<style scoped>
.bg-gradient-primary {
  background: linear-gradient(135deg, #009ef7 0%, #43bfa1 100%);
}
.card.card-flush {
  border-radius: 1.5rem;
}
.card-header,
.modal-header {
  border-radius: 1.25rem 1.25rem 0 0;
}
.card-body,
.modal-body,
.modal-footer {
  border-radius: 0 0 1.25rem 1.25rem;
}
@media (max-width: 768px) {
  .modal-dialog {
    margin: 0;
    min-width: 95vw;
  }
}
</style>

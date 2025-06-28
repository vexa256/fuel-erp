<template>
  <!-- PAYMENT PROCESSING MODAL - IOS PREMIUM DESIGN -->
  <div
    v-if="show"
    class="payment-modal d-block"
    style="background: rgba(0, 0, 0, 0.7); backdrop-filter: blur(15px)"
    tabindex="-1"
  >
    <div class="modal-dialog modal-xl modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg" style="border-radius: 20px">
        <!-- PREMIUM HEADER -->
        <div class="modal-header bg-gradient-primary border-0" style="border-radius: 20px 20px 0 0">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-credit-cart fs-1 text-white">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
            <div>
              <h3 class="modal-title fw-bold text-white mb-0">Payment Processing</h3>
              <p class="text-white opacity-75 fs-7 mb-0">
                {{ cartItems.length }} items • {{ formatCurrency(totalAmount) }}
              </p>
            </div>
          </div>
          <button
            @click="cancelPayment"
            :disabled="processing"
            class="btn btn-icon btn-light btn-sm"
            style="border-radius: 12px"
          >
            <i class="ki-duotone ki-cross fs-2">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
          </button>
        </div>

        <div class="modal-body p-0">
          <!-- PAYMENT AMOUNT DISPLAY -->
          <div class="payment-summary p-4 bg-light border-bottom">
            <div class="card bg-gradient-success text-center">
              <div class="card-body p-4">
                <div class="fs-6 text-white opacity-75 mb-1">Total Amount</div>
                <div class="fw-bold text-white mb-2" style="font-size: 2.5rem">
                  {{ formatCurrency(totalAmount) }}
                </div>
                <div v-if="customer && customer.creditAccount" class="fs-7 text-white opacity-75">
                  Customer: {{ getCustomerDisplayName(customer) }}
                </div>
                <div
                  v-if="paymentMethod === 'Cash' && cashReceived > 0 && cashReceived >= totalAmount"
                  class="fs-5 text-white mt-2"
                >
                  <i class="ki-duotone ki-arrow-down fs-2 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Change: {{ formatCurrency(cashReceived - totalAmount) }}
                </div>
              </div>
            </div>
          </div>

          <!-- PAYMENT METHOD SELECTION -->
          <div class="payment-methods p-4">
            <h5 class="fw-bold text-gray-800 mb-3">Select Payment Method</h5>

            <div class="row g-3 mb-4">
              <div class="col-6 col-md-3">
                <button
                  @click="setPaymentMethod('Cash')"
                  :disabled="processing"
                  :class="[
                    'btn w-100 h-100px shadow-sm',
                    paymentMethod === 'Cash' ? 'btn-success border-success' : 'btn-light-success',
                  ]"
                  style="border-radius: 16px; transition: all 0.3s ease"
                >
                  <div class="text-center">
                    <i
                      :class="[
                        'ki-duotone ki-dollar fs-3x mb-3',
                        paymentMethod === 'Cash' ? 'text-white' : 'text-success',
                      ]"
                    >
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div
                      :class="[
                        'fw-bold fs-5',
                        paymentMethod === 'Cash' ? 'text-white' : 'text-success',
                      ]"
                    >
                      Cash
                    </div>
                    <div
                      :class="[
                        'fs-8',
                        paymentMethod === 'Cash'
                          ? 'text-white opacity-75'
                          : 'text-success opacity-75',
                      ]"
                    >
                      Physical Money
                    </div>
                  </div>
                </button>
              </div>

              <div class="col-6 col-md-3">
                <button
                  @click="setPaymentMethod('Card')"
                  :disabled="processing"
                  :class="[
                    'btn w-100 h-100px shadow-sm',
                    paymentMethod === 'Card' ? 'btn-info border-info' : 'btn-light-info',
                  ]"
                  style="border-radius: 16px; transition: all 0.3s ease"
                >
                  <div class="text-center">
                    <i
                      :class="[
                        'ki-duotone ki-credit-cart fs-3x mb-3',
                        paymentMethod === 'Card' ? 'text-white' : 'text-info',
                      ]"
                    >
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div
                      :class="[
                        'fw-bold fs-5',
                        paymentMethod === 'Card' ? 'text-white' : 'text-info',
                      ]"
                    >
                      Card
                    </div>
                    <div
                      :class="[
                        'fs-8',
                        paymentMethod === 'Card' ? 'text-white opacity-75' : 'text-info opacity-75',
                      ]"
                    >
                      Visa/Mastercard
                    </div>
                  </div>
                </button>
              </div>

              <div class="col-6 col-md-3">
                <button
                  @click="setPaymentMethod('Mobile Money')"
                  :disabled="processing"
                  :class="[
                    'btn w-100 h-100px shadow-sm',
                    paymentMethod === 'Mobile Money'
                      ? 'btn-warning border-warning'
                      : 'btn-light-warning',
                  ]"
                  style="border-radius: 16px; transition: all 0.3s ease"
                >
                  <div class="text-center">
                    <i
                      :class="[
                        'ki-duotone ki-phone fs-3x mb-3',
                        paymentMethod === 'Mobile Money' ? 'text-white' : 'text-warning',
                      ]"
                    >
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <div
                      :class="[
                        'fw-bold fs-5',
                        paymentMethod === 'Mobile Money' ? 'text-white' : 'text-warning',
                      ]"
                    >
                      Mobile Money
                    </div>
                    <div
                      :class="[
                        'fs-8',
                        paymentMethod === 'Mobile Money'
                          ? 'text-white opacity-75'
                          : 'text-warning opacity-75',
                      ]"
                    >
                      MTN/Airtel
                    </div>
                  </div>
                </button>
              </div>

              <div v-if="customer && customer.creditAccount" class="col-6 col-md-3">
                <button
                  @click="setPaymentMethod('Credit')"
                  :disabled="processing || !canUseCredit"
                  :class="[
                    'btn w-100 h-100px shadow-sm',
                    paymentMethod === 'Credit'
                      ? 'btn-primary border-primary'
                      : canUseCredit
                        ? 'btn-light-primary'
                        : 'btn-light-danger',
                  ]"
                  style="border-radius: 16px; transition: all 0.3s ease"
                >
                  <div class="text-center">
                    <i
                      :class="[
                        'ki-duotone ki-wallet fs-3x mb-3',
                        paymentMethod === 'Credit'
                          ? 'text-white'
                          : canUseCredit
                            ? 'text-primary'
                            : 'text-danger',
                      ]"
                    >
                      <span class="path1"></span>
                      <span class="path2"></span>
                      <span class="path3"></span>
                    </i>
                    <div
                      :class="[
                        'fw-bold fs-5',
                        paymentMethod === 'Credit'
                          ? 'text-white'
                          : canUseCredit
                            ? 'text-primary'
                            : 'text-danger',
                      ]"
                    >
                      Credit
                    </div>
                    <div
                      :class="[
                        'fs-8',
                        paymentMethod === 'Credit'
                          ? 'text-white opacity-75'
                          : canUseCredit
                            ? 'text-primary opacity-75'
                            : 'text-danger opacity-75',
                      ]"
                    >
                      Account Billing
                    </div>
                  </div>
                </button>
              </div>
            </div>

            <!-- CREDIT ACCOUNT INFO -->
            <div
              v-if="customer && customer.creditAccount"
              class="card bg-light-primary border-primary mb-4"
            >
              <div class="card-body p-3">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <div class="fw-bold text-primary fs-6">
                      {{ getCustomerDisplayName(customer) }}
                    </div>
                    <div class="fs-8 text-primary opacity-75">{{ customer.CustomerCode }}</div>
                  </div>
                  <div class="text-end">
                    <div class="fs-7 text-primary">Available Credit:</div>
                    <div :class="['fw-bold fs-5', canUseCredit ? 'text-success' : 'text-danger']">
                      {{ formatCurrency(customer.creditAccount.AvailableCredit) }}
                    </div>
                  </div>
                </div>
                <div v-if="!canUseCredit" class="alert alert-danger py-2 mt-2 mb-0">
                  <i class="ki-duotone ki-information fs-4 me-1">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  <small
                    >Insufficient credit. Need
                    {{
                      formatCurrency(
                        totalAmount - parseFloat(customer.creditAccount.AvailableCredit),
                      )
                    }}
                    more.</small
                  >
                </div>
              </div>
            </div>
          </div>

          <!-- PAYMENT INPUT SECTION -->
          <div class="payment-input p-4 border-top">
            <!-- CASH PAYMENT -->
            <div v-if="paymentMethod === 'Cash'" class="cash-payment">
              <h6 class="fw-bold text-gray-800 mb-3">Cash Payment</h6>

              <div class="row g-3 mb-4">
                <div class="col-md-6">
                  <label class="form-label fw-bold fs-4 mb-3">Cash Received</label>
                  <div class="position-relative">
                    <input
                      v-model.number="cashReceived"
                      @input="validateCashAmount"
                      @focus="cashFocused = true"
                      @blur="cashFocused = false"
                      type="number"
                      step="1000"
                      min="0"
                      class="form-control form-control-lg text-center fw-bold"
                      :class="getCashInputClass"
                      :style="getCashInputStyle"
                      placeholder="Enter amount..."
                      :disabled="processing"
                    />
                    <div class="position-absolute top-50 end-0 translate-middle-y me-4">
                      <span class="fw-bold text-gray-500 fs-3">UGX</span>
                    </div>
                  </div>

                  <!-- Quick Cash Buttons -->
                  <div class="row g-2 mt-3">
                    <div v-for="amount in quickCashAmounts" :key="amount" class="col-4">
                      <button
                        @click="cashReceived = amount"
                        :disabled="processing"
                        class="btn btn-light-primary w-100 fs-7 fw-bold"
                        style="border-radius: 8px"
                      >
                        {{ formatShortCurrency(amount) }}
                      </button>
                    </div>
                  </div>
                </div>

                <div class="col-md-6">
                  <!-- Cash Calculation Display -->
                  <div class="cash-calculation">
                    <div class="card border-0" :class="getCashCalculationCardClass">
                      <div class="card-body p-4 text-center">
                        <div v-if="cashReceived === 0" class="text-gray-500">
                          <i class="ki-duotone ki-calculator fs-3x mb-3">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                          <div class="fw-bold fs-5">Enter Cash Amount</div>
                          <div class="fs-8">Amount received from customer</div>
                        </div>

                        <div v-else-if="cashReceived < totalAmount" class="text-danger">
                          <i class="ki-duotone ki-information fs-3x mb-3">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                          <div class="fw-bold fs-5 mb-2">Insufficient Amount</div>
                          <div class="fs-6">Still Need:</div>
                          <div class="fw-bold fs-3">
                            {{ formatCurrency(totalAmount - cashReceived) }}
                          </div>
                        </div>

                        <div v-else class="text-success">
                          <i class="ki-duotone ki-check-circle fs-3x mb-3">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                          <div class="fw-bold fs-5 mb-2">Payment Complete</div>
                          <div class="fs-6">Change:</div>
                          <div class="fw-bold fs-3">
                            {{ formatCurrency(cashReceived - totalAmount) }}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- ELECTRONIC PAYMENT -->
            <div
              v-if="paymentMethod !== 'Cash' && paymentMethod !== 'Credit'"
              class="electronic-payment"
            >
              <h6 class="fw-bold text-gray-800 mb-3">{{ paymentMethod }} Payment</h6>

              <div class="row g-3">
                <div class="col-md-8">
                  <label class="form-label fw-bold fs-5 mb-3">{{
                    getPaymentReferenceLabel()
                  }}</label>
                  <input
                    v-model="paymentReference"
                    @focus="referenceFocused = true"
                    @blur="referenceFocused = false"
                    type="text"
                    class="form-control form-control-lg"
                    :class="getPaymentReferenceClass"
                    :style="getPaymentInputStyle"
                    :placeholder="getPaymentPlaceholder()"
                    :disabled="processing"
                    maxlength="50"
                  />

                  <div
                    v-if="paymentReference.length > 0 && paymentReference.length < 3"
                    class="mt-2 text-danger fs-7"
                  >
                    Reference must be at least 3 characters
                  </div>

                  <div v-if="paymentReference.length >= 3" class="mt-2 text-success fs-7">
                    <i class="ki-duotone ki-check fs-4 me-1">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    Valid reference format
                  </div>
                </div>

                <div class="col-md-4">
                  <div class="card bg-light-info border-info h-100">
                    <div
                      class="card-body p-3 text-center d-flex flex-column justify-content-center"
                    >
                      <i :class="['ki-duotone', getPaymentMethodIcon(), 'fs-2x text-info mb-2']">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span v-if="paymentMethod === 'Mobile Money'" class="path3"></span>
                      </i>
                      <div class="fw-bold text-info fs-5">{{ paymentMethod }}</div>
                      <div class="fs-8 text-info opacity-75">{{ formatCurrency(totalAmount) }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- CREDIT PAYMENT -->
            <div v-if="paymentMethod === 'Credit'" class="credit-payment">
              <h6 class="fw-bold text-gray-800 mb-3">Credit Account Payment</h6>

              <div class="card bg-light-success border-success">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="symbol symbol-50px symbol-circle bg-success">
                      <i class="ki-duotone ki-profile-circle fs-2 text-white">
                        <span class="path1"></span>
                        <span class="path2"></span>
                        <span class="path3"></span>
                      </i>
                    </div>
                    <div>
                      <div class="fw-bold text-success fs-5">
                        {{ getCustomerDisplayName(customer) }}
                      </div>
                      <div class="fs-7 text-success opacity-75">{{ customer.CustomerCode }}</div>
                    </div>
                  </div>

                  <div class="row g-3">
                    <div class="col-4">
                      <div class="text-center">
                        <div class="fs-7 text-success opacity-75">Current Balance</div>
                        <div class="fw-bold text-success fs-5">
                          {{ formatCurrency(customer.creditAccount.CurrentBalance) }}
                        </div>
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="text-center">
                        <div class="fs-7 text-success opacity-75">After Purchase</div>
                        <div class="fw-bold text-success fs-5">
                          {{
                            formatCurrency(
                              parseFloat(customer.creditAccount.CurrentBalance) + totalAmount,
                            )
                          }}
                        </div>
                      </div>
                    </div>
                    <div class="col-4">
                      <div class="text-center">
                        <div class="fs-7 text-success opacity-75">Remaining Credit</div>
                        <div class="fw-bold text-success fs-5">
                          {{
                            formatCurrency(
                              parseFloat(customer.creditAccount.AvailableCredit) - totalAmount,
                            )
                          }}
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="separator my-3"></div>

                  <div class="d-flex align-items-center gap-2">
                    <i class="ki-duotone ki-shield-tick fs-2 text-success">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <span class="text-success fw-bold"
                      >Credit account will be charged automatically</span
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- TRANSACTION SUMMARY -->
          <div class="transaction-summary p-4 bg-light border-top">
            <h6 class="fw-bold text-gray-800 mb-3">Transaction Summary</h6>

            <div class="row g-3">
              <div class="col-md-6">
                <div class="card border-0 bg-white">
                  <div class="card-body p-3">
                    <div class="d-flex justify-content-between mb-2">
                      <span class="text-gray-700">Items:</span>
                      <span class="fw-bold">{{ cartItems.length }}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                      <span class="text-gray-700">Subtotal:</span>
                      <span class="fw-bold">{{ formatCurrency(subtotal) }}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                      <span class="text-gray-700">Tax (18%):</span>
                      <span class="fw-bold">{{ formatCurrency(tax) }}</span>
                    </div>
                    <div class="separator my-2"></div>
                    <div class="d-flex justify-content-between">
                      <span class="fw-bold text-gray-800 fs-5">Total:</span>
                      <span class="fw-bold text-success fs-4">{{
                        formatCurrency(totalAmount)
                      }}</span>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-6">
                <div class="card border-0 bg-white">
                  <div class="card-body p-3">
                    <div class="d-flex justify-content-between mb-2">
                      <span class="text-gray-700">Payment Method:</span>
                      <span class="fw-bold">{{ paymentMethod }}</span>
                    </div>
                    <div
                      v-if="paymentMethod === 'Cash'"
                      class="d-flex justify-content-between mb-2"
                    >
                      <span class="text-gray-700">Cash Received:</span>
                      <span class="fw-bold">{{ formatCurrency(cashReceived) }}</span>
                    </div>
                    <div
                      v-if="paymentMethod === 'Cash' && cashReceived >= totalAmount"
                      class="d-flex justify-content-between mb-2"
                    >
                      <span class="text-gray-700">Change:</span>
                      <span class="fw-bold text-warning">{{
                        formatCurrency(cashReceived - totalAmount)
                      }}</span>
                    </div>
                    <div v-if="paymentReference" class="d-flex justify-content-between mb-2">
                      <span class="text-gray-700">Reference:</span>
                      <span class="fw-bold">{{ paymentReference }}</span>
                    </div>
                    <div class="d-flex justify-content-between">
                      <span class="text-gray-700">Status:</span>
                      <span :class="['fw-bold', getPaymentStatusClass()]">{{
                        getPaymentStatusText()
                      }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- MODAL ACTIONS -->
        <div class="modal-footer border-0 p-4 bg-light" style="border-radius: 0 0 20px 20px">
          <div class="w-100 d-flex gap-3">
            <!-- CANCEL BUTTON -->
            <button
              @click="cancelPayment"
              :disabled="processing"
              class="btn btn-light-secondary flex-shrink-0"
              style="border-radius: 12px; min-width: 120px"
            >
              <i class="ki-duotone ki-cross fs-3 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Cancel
            </button>

            <!-- PROCESS PAYMENT BUTTON -->
            <button
              @click="processPayment"
              :disabled="!canProcessPayment || processing"
              class="btn btn-success flex-grow-1"
              :class="{ 'btn-loading': processing }"
              style="border-radius: 12px; min-height: 60px"
            >
              <div v-if="processing" class="d-flex align-items-center justify-content-center">
                <div class="spinner-border spinner-border-sm me-2"></div>
                <span class="fw-bold fs-5">{{ processingMessage }}</span>
              </div>
              <div v-else class="d-flex align-items-center justify-content-center">
                <i class="ki-duotone ki-check-circle fs-1 me-2">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <span class="fw-bold fs-4">{{ getProcessButtonText() }}</span>
              </div>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- PROCESSING OVERLAY -->
    <div
      v-if="showProcessingOverlay"
      class="processing-overlay position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
      style="z-index: 9999; background: rgba(0, 0, 0, 0.9)"
    >
      <div
        class="card border-0 shadow-lg text-center"
        style="max-width: 500px; border-radius: 16px"
      >
        <div class="card-body p-5">
          <div class="spinner-border spinner-border-lg text-success mb-4"></div>
          <h4 class="fw-bold text-gray-800 mb-3">{{ processingMessage }}</h4>
          <p class="text-gray-600 fs-7 mb-4">{{ processingDetails }}</p>

          <!-- Processing Steps -->
          <div class="processing-steps text-start">
            <div
              v-for="(step, index) in processingSteps"
              :key="index"
              class="d-flex align-items-center gap-3 mb-2"
            >
              <div
                :class="[
                  'symbol symbol-25px symbol-circle',
                  step.completed ? 'bg-success' : step.active ? 'bg-primary' : 'bg-gray-300',
                ]"
              >
                <i v-if="step.completed" class="ki-duotone ki-check fs-5 text-white">
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
                <div
                  v-else-if="step.active"
                  class="spinner-border spinner-border-sm text-white"
                ></div>
                <span v-else class="fw-bold text-gray-500 fs-7">{{ index + 1 }}</span>
              </div>
              <span
                :class="[
                  'fs-7',
                  step.completed ? 'text-success' : step.active ? 'text-primary' : 'text-gray-500',
                ]"
              >
                {{ step.label }}
              </span>
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

// ========== PROPS & EMITS ==========
const props = defineProps({
  show: {
    type: Boolean,
    default: false,
  },
  cartItems: {
    type: Array,
    default: () => [],
  },
  customer: {
    type: Object,
    default: null,
  },
  totalAmount: {
    type: Number,
    default: 0,
  },
  stationId: {
    type: Number,
    default: null,
  },
  currentCashDrawer: {
    type: Object,
    default: null,
  },
})

const emits = defineEmits(['payment-completed', 'payment-cancelled', 'verification-log-updated'])

// ========== CONSTANTS ==========
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const MAX_CASH_AMOUNT = 50000000
const MIN_REFERENCE_LENGTH = 3
const TAX_RATE = 18

// ========== REACTIVE STATE ==========
const processing = ref(false)
const showProcessingOverlay = ref(false)
const processingMessage = ref('')
const processingDetails = ref('')

// Payment Data
const paymentMethod = ref('Cash')
const cashReceived = ref(0)
const paymentReference = ref('')
const cashFocused = ref(false)
const referenceFocused = ref(false)

// Verification System
const verificationLog = ref([])

// Processing Steps
const processingSteps = ref([
  { label: 'Validating payment details', active: false, completed: false },
  { label: 'Creating transaction record', active: false, completed: false },
  { label: 'Updating inventory levels', active: false, completed: false },
  { label: 'Processing customer account', active: false, completed: false },
  { label: 'Updating cash drawer', active: false, completed: false },
  { label: 'Generating receipt', active: false, completed: false },
])

// ========== COMPUTED PROPERTIES ==========
const subtotal = computed(() => {
  return props.cartItems.reduce((sum, item) => sum + (parseFloat(item.total) || 0), 0)
})

const tax = computed(() => {
  return subtotal.value * (TAX_RATE / 100)
})

const canUseCredit = computed(() => {
  if (!props.customer?.creditAccount) return false
  const availableCredit = parseFloat(props.customer.creditAccount.AvailableCredit || 0)
  return availableCredit >= props.totalAmount
})

const canProcessPayment = computed(() => {
  if (processing.value || props.cartItems.length === 0) return false

  switch (paymentMethod.value) {
    case 'Cash':
      return (
        cashReceived.value >= props.totalAmount &&
        cashReceived.value <= MAX_CASH_AMOUNT &&
        cashReceived.value > 0
      )
    case 'Card':
    case 'Mobile Money':
      return paymentReference.value.trim().length >= MIN_REFERENCE_LENGTH
    case 'Credit':
      return canUseCredit.value
    default:
      return false
  }
})

const quickCashAmounts = computed(() => {
  const total = props.totalAmount
  const amounts = []

  // Round up to nearest thousand
  const rounded = Math.ceil(total / 1000) * 1000
  amounts.push(rounded)

  if (total <= 10000) {
    amounts.push(5000, 10000, 20000)
  } else if (total <= 50000) {
    amounts.push(50000, 100000)
  } else {
    amounts.push(100000, 200000, 500000)
  }

  return [...new Set(amounts)].sort((a, b) => a - b).slice(0, 6)
})

const getCashInputClass = computed(() => {
  if (processing.value) return 'border-gray-300'
  if (cashReceived.value === 0) return cashFocused.value ? 'border-primary' : 'border-light'
  if (cashReceived.value >= props.totalAmount) return 'border-success'
  if (cashReceived.value < props.totalAmount) return 'border-warning'
  return 'border-light'
})

const getCashInputStyle = computed(() => {
  return {
    fontSize: '2rem',
    height: '80px',
    borderWidth: '3px',
    borderRadius: '12px',
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
  }
})

const getPaymentInputStyle = computed(() => {
  return {
    fontSize: '1.2rem',
    height: '60px',
    borderWidth: '2px',
    borderRadius: '12px',
    transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
  }
})

const getCashCalculationCardClass = computed(() => {
  if (cashReceived.value === 0) return 'bg-light border-light'
  if (cashReceived.value < props.totalAmount) return 'bg-light-danger border-danger'
  return 'bg-light-success border-success'
})

const getPaymentReferenceClass = computed(() => {
  if (processing.value) return 'border-gray-300'
  if (!paymentReference.value) return referenceFocused.value ? 'border-primary' : 'border-light'
  if (paymentReference.value.length >= MIN_REFERENCE_LENGTH) return 'border-success'
  return 'border-danger'
})

// ========== UTILITY FUNCTIONS ==========
const formatCurrency = (amount) => {
  const num = parseFloat(amount) || 0
  return new Intl.NumberFormat('en-UG', {
    style: 'currency',
    currency: 'UGX',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(num)
}

const formatShortCurrency = (amount) => {
  const num = parseFloat(amount) || 0
  if (num >= 1000000) return `${(num / 1000000).toFixed(1)}M`
  if (num >= 1000) return `${(num / 1000).toFixed(1)}K`
  return formatCurrency(num)
}

const getAuthToken = () => {
  return localStorage.getItem('kigrama_auth_token') || 'demo_token'
}

const getCurrentUser = () => {
  try {
    const userData = localStorage.getItem('kigrama_user_data')
    return userData ? JSON.parse(userData).user : { id: 1, name: 'Demo User' }
  } catch {
    return { id: 1, name: 'Demo User' }
  }
}

const getCustomerDisplayName = (customer) => {
  if (!customer) return ''
  return (
    customer.CompanyName ||
    `${customer.FirstName || ''} ${customer.LastName || ''}`.trim() ||
    customer.CustomerCode ||
    'Unknown Customer'
  )
}

const getPaymentMethodIcon = () => {
  switch (paymentMethod.value) {
    case 'Card':
      return 'ki-credit-cart'
    case 'Mobile Money':
      return 'ki-phone'
    default:
      return 'ki-wallet'
  }
}

const getPaymentReferenceLabel = () => {
  switch (paymentMethod.value) {
    case 'Card':
      return 'Card Transaction Reference'
    case 'Mobile Money':
      return 'Mobile Money Reference'
    default:
      return 'Payment Reference'
  }
}

const getPaymentPlaceholder = () => {
  switch (paymentMethod.value) {
    case 'Card':
      return 'Enter card transaction reference...'
    case 'Mobile Money':
      return 'Enter mobile money reference...'
    default:
      return 'Enter payment reference...'
  }
}

const getProcessButtonText = () => {
  switch (paymentMethod.value) {
    case 'Cash':
      return `Process Cash Payment`
    case 'Card':
      return `Process Card Payment`
    case 'Mobile Money':
      return `Process Mobile Payment`
    case 'Credit':
      return `Charge Credit Account`
    default:
      return 'Process Payment'
  }
}

const getPaymentStatusClass = () => {
  if (!canProcessPayment.value) return 'text-danger'
  return 'text-success'
}

const getPaymentStatusText = () => {
  if (!canProcessPayment.value) return 'Incomplete'
  return 'Ready'
}

// ========== VERIFICATION SYSTEM ==========
const logVerification = (operation, status, details, data = null) => {
  const logEntry = {
    timestamp: new Date().toISOString(),
    operation,
    status, // 'SUCCESS', 'WARNING', 'ERROR'
    details,
    data,
    userId: getCurrentUser().id,
    component: 'PaymentModal',
  }

  verificationLog.value.push(logEntry)

  // Keep only last 50 entries
  if (verificationLog.value.length > 50) {
    verificationLog.value = verificationLog.value.slice(-50)
  }

  console.log(`[PAYMENT VERIFICATION ${status}] ${operation}: ${details}`, data)

  // Emit to parent for global logging
  emits('verification-log-updated', logEntry)

  // Create audit log
  createVerificationAuditLog(logEntry)
}

const createVerificationAuditLog = async (logEntry) => {
  try {
    await apiCall('/AuditLogs', {
      method: 'POST',
      body: JSON.stringify({
        StationID: props.stationId,
        UserID: logEntry.userId,
        Action: `PAYMENT_VERIFICATION: ${logEntry.operation}`,
        TableName: 'PaymentModal',
        Changes: JSON.stringify({
          status: logEntry.status,
          details: logEntry.details,
          data: logEntry.data,
          timestamp: logEntry.timestamp,
        }),
        IPAddress: 'PaymentModal-Component',
        LogTimestamp: logEntry.timestamp,
      }),
    })
  } catch (error) {
    console.error('Failed to log verification audit:', error)
  }
}

// ========== API FUNCTIONS ==========
const apiCall = async (endpoint, options = {}) => {
  const controller = new AbortController()
  const timeoutId = setTimeout(() => controller.abort(), 30000)

  try {
    logVerification('API_CALL_START', 'SUCCESS', `Starting API call: ${endpoint}`)

    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      signal: controller.signal,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${getAuthToken()}`,
        ...options.headers,
      },
      ...options,
    })

    clearTimeout(timeoutId)

    if (!response.ok) {
      const errorText = await response.text().catch(() => 'Unknown error')
      logVerification(
        'API_CALL_FAILED',
        'ERROR',
        `API call failed: ${response.status} - ${errorText}`,
      )
      throw new Error(`API Error ${response.status}: ${errorText}`)
    }

    const responseText = await response.text()
    if (!responseText.trim()) {
      logVerification('API_CALL_EMPTY_RESPONSE', 'WARNING', `Empty response from ${endpoint}`)
      return { success: true }
    }

    try {
      const data = JSON.parse(responseText)
      logVerification('API_CALL_SUCCESS', 'SUCCESS', `API call successful: ${endpoint}`)
      return data
    } catch (parseError) {
      logVerification('API_CALL_PARSE_ERROR', 'ERROR', `JSON parse error: ${parseError.message}`)
      throw new Error('Invalid JSON response from server')
    }
  } catch (error) {
    clearTimeout(timeoutId)
    if (error.name === 'AbortError') {
      logVerification('API_CALL_TIMEOUT', 'ERROR', `API call timeout: ${endpoint}`)
      throw new Error('Request timeout - please try again')
    }
    logVerification('API_CALL_ERROR', 'ERROR', `API call error: ${error.message}`)
    throw error
  }
}

// ========== PAYMENT METHODS ==========
const setPaymentMethod = (method) => {
  paymentMethod.value = method

  // Reset other payment fields
  if (method !== 'Cash') {
    cashReceived.value = 0
  }
  if (method === 'Cash' || method === 'Credit') {
    paymentReference.value = ''
  }

  logVerification('PAYMENT_METHOD_CHANGED', 'SUCCESS', `Payment method changed to: ${method}`)
}

const validateCashAmount = () => {
  if (cashReceived.value > MAX_CASH_AMOUNT) {
    cashReceived.value = MAX_CASH_AMOUNT
  }
  if (cashReceived.value < 0) {
    cashReceived.value = 0
  }
}

// ========== PAYMENT PROCESSING ==========
const processPayment = async () => {
  try {
    processing.value = true
    showProcessingOverlay.value = true
    processingMessage.value = 'Processing Payment'
    processingDetails.value = 'Please wait while we process your payment...'

    logVerification(
      'PAYMENT_PROCESSING_START',
      'SUCCESS',
      `Starting payment processing: ${paymentMethod.value}`,
    )

    // Step 1: Validate payment details
    processingSteps.value[0].active = true
    processingMessage.value = 'Validating Payment'
    await new Promise((resolve) => setTimeout(resolve, 500))

    const validation = await validatePaymentDetails()
    if (!validation.success) {
      throw new Error(validation.errors.join(', '))
    }
    processingSteps.value[0].active = false
    processingSteps.value[0].completed = true

    // Step 2: Create transaction record
    processingSteps.value[1].active = true
    processingMessage.value = 'Creating Transaction'
    await new Promise((resolve) => setTimeout(resolve, 500))

    const transaction = await createTransaction()
    processingSteps.value[1].active = false
    processingSteps.value[1].completed = true

    // Step 3: Update inventory levels
    processingSteps.value[2].active = true
    processingMessage.value = 'Updating Inventory'
    await new Promise((resolve) => setTimeout(resolve, 800))

    await updateInventoryLevels(transaction.TransactionID)
    processingSteps.value[2].active = false
    processingSteps.value[2].completed = true

    // Step 4: Process customer account
    processingSteps.value[3].active = true
    processingMessage.value = 'Processing Customer Account'
    await new Promise((resolve) => setTimeout(resolve, 600))

    if (props.customer && paymentMethod.value === 'Credit') {
      await processCustomerCredit(transaction.TransactionID)
    }
    processingSteps.value[3].active = false
    processingSteps.value[3].completed = true

    // Step 5: Update cash drawer
    processingSteps.value[4].active = true
    processingMessage.value = 'Updating Cash Drawer'
    await new Promise((resolve) => setTimeout(resolve, 400))

    if (paymentMethod.value === 'Cash' && props.currentCashDrawer) {
      await updateCashDrawer()
    }
    processingSteps.value[4].active = false
    processingSteps.value[4].completed = true

    // Step 6: Generate receipt
    processingSteps.value[5].active = true
    processingMessage.value = 'Generating Receipt'
    await new Promise((resolve) => setTimeout(resolve, 600))

    const receipt = await generateReceipt(transaction)
    processingSteps.value[5].active = false
    processingSteps.value[5].completed = true

    logVerification(
      'PAYMENT_PROCESSING_SUCCESS',
      'SUCCESS',
      `Payment processed successfully: ${transaction.TransactionID}`,
    )

    // Emit completion event
    emits('payment-completed', {
      transactionId: transaction.TransactionID,
      totalAmount: props.totalAmount,
      paymentMethod: paymentMethod.value,
      cashReceived: paymentMethod.value === 'Cash' ? cashReceived.value : null,
      change: paymentMethod.value === 'Cash' ? cashReceived.value - props.totalAmount : 0,
      paymentReference: paymentReference.value,
      receipt: receipt,
      timestamp: new Date().toISOString(),
    })

    await Swal.fire({
      title: 'Payment Successful!',
      html: `
        <div class="text-center">
          <div class="fs-2 fw-bold text-success mb-2">${formatCurrency(props.totalAmount)}</div>
          <div class="text-gray-600 mb-2">${paymentMethod.value} Payment</div>
          <div class="fs-7 text-gray-500">Transaction #${transaction.TransactionID}</div>
          ${
            paymentMethod.value === 'Cash' && cashReceived.value > props.totalAmount
              ? `<div class="fs-6 fw-bold text-warning mt-2">Change: ${formatCurrency(cashReceived.value - props.totalAmount)}</div>`
              : ''
          }
        </div>
      `,
      icon: 'success',
      confirmButtonText: 'Continue',
      timer: 3000,
    })

    resetPaymentForm()
  } catch (error) {
    console.error('Payment processing error:', error)
    logVerification(
      'PAYMENT_PROCESSING_ERROR',
      'ERROR',
      `Payment processing failed: ${error.message}`,
    )

    await Swal.fire({
      title: 'Payment Failed',
      text: error.message || 'An error occurred while processing the payment',
      icon: 'error',
      confirmButtonText: 'OK',
    })
  } finally {
    processing.value = false
    showProcessingOverlay.value = false

    // Reset processing steps
    processingSteps.value.forEach((step) => {
      step.active = false
      step.completed = false
    })
  }
}

const validatePaymentDetails = async () => {
  const validation = { success: true, errors: [] }

  try {
    // Validate cart items
    if (!props.cartItems.length) {
      validation.success = false
      validation.errors.push('No items in cart')
    }

    // Validate payment method specific requirements
    switch (paymentMethod.value) {
      case 'Cash':
        if (cashReceived.value < props.totalAmount) {
          validation.success = false
          validation.errors.push('Insufficient cash received')
        }
        if (cashReceived.value > MAX_CASH_AMOUNT) {
          validation.success = false
          validation.errors.push('Cash amount exceeds maximum limit')
        }
        break

      case 'Card':
      case 'Mobile Money':
        if (paymentReference.value.trim().length < MIN_REFERENCE_LENGTH) {
          validation.success = false
          validation.errors.push('Payment reference is required')
        }
        break

      case 'Credit':
        if (!canUseCredit.value) {
          validation.success = false
          validation.errors.push('Insufficient credit available')
        }
        break
    }

    // Validate customer for credit sales
    if (paymentMethod.value === 'Credit' && !props.customer) {
      validation.success = false
      validation.errors.push('Customer is required for credit sales')
    }

    return validation
  } catch (error) {
    validation.success = false
    validation.errors.push(`Validation error: ${error.message}`)
    return validation
  }
}

const createTransaction = async () => {
  try {
    const transactionData = {
      StationID: props.stationId,
      TransactionDate: new Date().toISOString().split('T')[0],
      TransactionType: 'Sale',
      ReferenceParty: props.customer ? getCustomerDisplayName(props.customer) : 'Walk-in Customer',
      TotalAmount: props.totalAmount.toFixed(2),
      TaxAmount: tax.value.toFixed(2),
      PaymentMethod: paymentMethod.value,
      PaymentReference: paymentReference.value || `POS-${Date.now()}`,
      PaymentStatus: 'Paid',
      InvoiceNumber: generateInvoiceNumber(),
      Status: 'Completed',
      HandledBy: getCurrentUser().id,
      CustomerID: props.customer?.CustomerID || null,
      IsCreditSale: paymentMethod.value === 'Credit' ? '1' : '0',
      OutstandingAmount: paymentMethod.value === 'Credit' ? props.totalAmount.toFixed(2) : '0.00',
      Notes: `POS Sale - ${paymentMethod.value}`,
      CreatedAt: new Date().toISOString(),
      UpdatedAt: new Date().toISOString(),
    }

    const response = await apiCall('/Transactions', {
      method: 'POST',
      body: JSON.stringify(transactionData),
    })

    const transactionId = response.TransactionID || response.id

    // Create transaction items
    for (const item of props.cartItems) {
      const itemData = {
        TransactionID: transactionId,
        ProductID: item.product.ProductID,
        Quantity: item.quantity.toString(),
        UnitPrice: item.unitPrice.toFixed(2),
        SellingPrice: item.unitPrice.toFixed(2),
        TaxRate: TAX_RATE.toString(),
        Subtotal: item.total.toFixed(2),
        PumpID: item.isFuel ? item.pumpInfo.PumpID : null,
        TankID: item.isFuel ? item.tankInfo.TankID : null,
        CreatedAt: new Date().toISOString(),
      }

      await apiCall('/TransactionItems', {
        method: 'POST',
        body: JSON.stringify(itemData),
      })
    }

    return { ...transactionData, TransactionID: transactionId }
  } catch (error) {
    logVerification(
      'TRANSACTION_CREATION_ERROR',
      'ERROR',
      `Failed to create transaction: ${error.message}`,
    )
    throw error
  }
}

const updateInventoryLevels = async (transactionId) => {
  try {
    for (const item of props.cartItems) {
      if (item.isFuel) {
        // Update tank level
        const currentTank = await apiCall(`/Tanks/${item.tankInfo.TankID}`)
        const newTankLevel = Math.max(0, parseFloat(currentTank.CurrentLevel) - item.quantity)

        await apiCall(`/Tanks/${item.tankInfo.TankID}`, {
          method: 'PATCH',
          body: JSON.stringify({
            CurrentLevel: newTankLevel.toFixed(2),
            UpdatedAt: new Date().toISOString(),
          }),
        })

        // Update pump meter reading
        const currentPump = await apiCall(`/Pumps/${item.pumpInfo.PumpID}`)
        const newMeterReading = parseFloat(currentPump.MeterReading || 0) + item.quantity

        await apiCall(`/Pumps/${item.pumpInfo.PumpID}`, {
          method: 'PATCH',
          body: JSON.stringify({
            MeterReading: newMeterReading.toFixed(2),
            UpdatedAt: new Date().toISOString(),
          }),
        })
      }

      // Update station inventory
      const inventoryResponse = await apiCall(
        `/StationInventory?StationID=${props.stationId}&ProductID=${item.product.ProductID}`,
      )

      const inventory = inventoryResponse.records?.[0]
      if (inventory) {
        const currentStock = parseFloat(inventory.CurrentStock || 0)
        const newStock = Math.max(0, currentStock - item.quantity)

        await apiCall(`/StationInventory/${inventory.InventoryID}`, {
          method: 'PATCH',
          body: JSON.stringify({
            CurrentStock: newStock.toFixed(2),
            LastUpdated: new Date().toISOString(),
          }),
        })
      }

      // Create inventory history record
      await apiCall('/InventoryHistory', {
        method: 'POST',
        body: JSON.stringify({
          StationID: props.stationId,
          ProductID: item.product.ProductID,
          TankID: item.isFuel ? item.tankInfo.TankID : null,
          PumpID: item.isFuel ? item.pumpInfo.PumpID : null,
          TransactionID: transactionId,
          ChangeType: item.isFuel ? 'Fuel Sale' : 'Product Sale',
          PreviousQuantity: '0',
          QuantityChange: (-item.quantity).toString(),
          NewQuantity: '0',
          UnitPrice: item.unitPrice.toString(),
          TotalValue: item.total.toString(),
          ReasonForChange: 'POS Sale',
          RecordedBy: getCurrentUser().id,
          CreatedAt: new Date().toISOString(),
        }),
      })
    }
  } catch (error) {
    logVerification(
      'INVENTORY_UPDATE_ERROR',
      'ERROR',
      `Failed to update inventory: ${error.message}`,
    )
    throw error
  }
}

const processCustomerCredit = async (transactionId) => {
  try {
    if (!props.customer?.creditAccount) return

    const currentBalance = parseFloat(props.customer.creditAccount.CurrentBalance || 0)
    const creditLimit = parseFloat(props.customer.creditAccount.CreditLimit || 0)
    const newBalance = currentBalance + props.totalAmount
    const availableCredit = creditLimit - newBalance

    await apiCall(`/CustomerCreditAccounts/${props.customer.creditAccount.CreditAccountID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        CurrentBalance: newBalance.toFixed(2),
        AvailableCredit: availableCredit.toFixed(2),
        LastPurchaseDate: new Date().toISOString(),
        UpdatedAt: new Date().toISOString(),
      }),
    })
  } catch (error) {
    logVerification(
      'CUSTOMER_CREDIT_ERROR',
      'ERROR',
      `Failed to process customer credit: ${error.message}`,
    )
    throw error
  }
}

const updateCashDrawer = async () => {
  try {
    if (!props.currentCashDrawer || paymentMethod.value !== 'Cash') return

    const currentCashSales = parseFloat(props.currentCashDrawer.CashSales || 0)
    const newCashSales = currentCashSales + props.totalAmount
    const newExpectedCash = parseFloat(props.currentCashDrawer.OpeningBalance) + newCashSales

    await apiCall(`/CashDrawers/${props.currentCashDrawer.DrawerID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        CashSales: newCashSales.toFixed(2),
        ExpectedCash: newExpectedCash.toFixed(2),
      }),
    })
  } catch (error) {
    logVerification(
      'CASH_DRAWER_UPDATE_ERROR',
      'ERROR',
      `Failed to update cash drawer: ${error.message}`,
    )
    throw error
  }
}

const generateReceipt = async (transaction) => {
  try {
    const receipt = {
      transactionId: transaction.TransactionID,
      invoiceNumber: transaction.InvoiceNumber,
      timestamp: new Date().toISOString(),
      station: {
        name: 'Kigrama Fuel Station',
        address: 'Station Address',
        phone: 'Station Phone',
      },
      customer: props.customer
        ? {
            name: getCustomerDisplayName(props.customer),
            code: props.customer.CustomerCode,
            phone: props.customer.PhoneNumber,
          }
        : null,
      items: props.cartItems.map((item) => ({
        name: item.product.Name,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        total: item.total,
        isFuel: item.isFuel,
      })),
      payment: {
        method: paymentMethod.value,
        subtotal: subtotal.value,
        tax: tax.value,
        total: props.totalAmount,
        cashReceived: paymentMethod.value === 'Cash' ? cashReceived.value : null,
        change: paymentMethod.value === 'Cash' ? cashReceived.value - props.totalAmount : 0,
        reference: paymentReference.value,
      },
      attendant: getCurrentUser().name,
    }

    // In a real implementation, this would generate and print the receipt
    logVerification(
      'RECEIPT_GENERATED',
      'SUCCESS',
      `Receipt generated for transaction ${transaction.TransactionID}`,
    )

    return receipt
  } catch (error) {
    logVerification(
      'RECEIPT_GENERATION_ERROR',
      'ERROR',
      `Failed to generate receipt: ${error.message}`,
    )
    throw error
  }
}

const generateInvoiceNumber = () => {
  const now = new Date()
  const year = now.getFullYear().toString().slice(-2)
  const month = (now.getMonth() + 1).toString().padStart(2, '0')
  const day = now.getDate().toString().padStart(2, '0')
  const timestamp = now.getTime().toString().slice(-6)

  return `INV-${year}${month}${day}-${timestamp}`
}

// ========== UI EVENT HANDLERS ==========
const cancelPayment = async () => {
  try {
    if (processing.value) return

    const result = await Swal.fire({
      title: 'Cancel Payment?',
      text: 'This will return to the cart without processing payment',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'Yes, Cancel',
      cancelButtonText: 'Continue',
      confirmButtonColor: '#f1416c',
      cancelButtonColor: '#6c757d',
    })

    if (result.isConfirmed) {
      logVerification('PAYMENT_CANCELLED', 'SUCCESS', 'Payment cancelled by user')

      resetPaymentForm()
      emits('payment-cancelled')

      await Swal.fire({
        title: 'Payment Cancelled',
        icon: 'info',
        toast: true,
        position: 'top-end',
        timer: 2000,
        showConfirmButton: false,
      })
    }
  } catch (error) {
    console.error('Error cancelling payment:', error)
    logVerification('PAYMENT_CANCEL_ERROR', 'ERROR', error.message)
  }
}

const resetPaymentForm = () => {
  paymentMethod.value = 'Cash'
  cashReceived.value = 0
  paymentReference.value = ''
  cashFocused.value = false
  referenceFocused.value = false
}

// ========== WATCHERS ==========
watch(
  () => props.show,
  (newShow) => {
    if (newShow) {
      resetPaymentForm()
      logVerification(
        'PAYMENT_MODAL_OPENED',
        'SUCCESS',
        `Payment modal opened for ${formatCurrency(props.totalAmount)}`,
      )
    }
  },
)

// ========== LIFECYCLE ==========
onMounted(async () => {
  console.log('💳 PaymentModal Component Mounted')

  try {
    logVerification('COMPONENT_MOUNTED', 'SUCCESS', 'PaymentModal component initialized')

    logVerification('COMPONENT_READY', 'SUCCESS', 'PaymentModal component ready for use')
  } catch (error) {
    console.error('PaymentModal mount error:', error)
    logVerification('COMPONENT_MOUNT_ERROR', 'ERROR', error.message)
  }
})
</script>

<style scoped>
/* iOS Premium Styling */
.payment-modal {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1050;
}

/* Gradient Backgrounds */
.bg-gradient-primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.bg-gradient-success {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}

/* Touch Optimizations */
.btn {
  min-height: 44px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn:active {
  transform: scale(0.98);
}

/* Card Enhancements */
.card {
  border-radius: 16px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Modal Enhancements */
.modal-content {
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
}

.modal-dialog {
  max-width: 900px;
}

/* Form Enhancements */
.form-control {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.form-control:focus {
  box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.15);
}

/* Symbol & Badge Styling */
.symbol {
  border-radius: 50%;
  overflow: hidden;
}

/* Loading States */
.btn-loading {
  position: relative;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
}

/* Processing Overlay */
.processing-overlay {
  backdrop-filter: blur(15px);
  -webkit-backdrop-filter: blur(15px);
}

/* Shadow Enhancements */
.shadow-sm {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08) !important;
}

.shadow-lg {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12) !important;
}

/* Separator */
.separator {
  border-bottom: 1px solid #e9ecef;
}

/* Mobile Responsive */
@media (max-width: 768px) {
  .modal-dialog {
    margin: 0.5rem;
    max-width: none;
  }

  .card-body {
    padding: 1rem !important;
  }

  .col-md-3 {
    flex: 0 0 50%;
    max-width: 50%;
  }

  .col-md-6 {
    flex: 0 0 100%;
    max-width: 100%;
  }
}

@media (max-width: 576px) {
  .modal-dialog {
    margin: 0.25rem;
  }

  .btn {
    padding: 0.5rem 1rem !important;
    font-size: 0.875rem !important;
  }

  .h-100px {
    height: 80px !important;
  }
}

/* Animation Enhancements */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card {
  animation: slideIn 0.3s ease-out;
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Input Styling */
input[type='number'] {
  -moz-appearance: textfield;
}

input[type='number']::-webkit-outer-spin-button,
input[type='number']::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Z-index Management */
.position-fixed {
  z-index: 9999;
}
</style>

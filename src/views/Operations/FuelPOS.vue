<template>
  <!-- ENTERPRISE FUEL DISPENSING POS - 100% ERD COMPLIANT -->
  <div class="d-flex flex-column min-vh-100 bg-light">
    <!-- HEADER WITH REAL-TIME STATS -->
    <div class="card border-0 rounded-0 bg-gradient-primary shadow-sm">
      <div class="card-body px-4 py-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <div class="d-flex align-items-center gap-3">
            <div class="symbol symbol-50px symbol-circle bg-white bg-opacity-20">
              <i class="ki-duotone ki-oil-barrel fs-1 text-white">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </div>
            <div>
              <h2 class="text-white fw-bold fs-3 mb-0">Fuel Dispensing POS</h2>
              <p class="text-white opacity-75 fs-7 mb-0">
                {{ authUser.name || 'Attendant' }} • {{ currentStation.StationName || 'Station' }}
              </p>
            </div>
          </div>
          <div class="d-flex gap-2">
            <button @click="openCashDrawer" class="btn btn-light-success btn-sm">
              <i class="ki-duotone ki-dollar fs-3">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Cash Drawer
            </button>
            <button @click="refreshSystemData" class="btn btn-light-info btn-sm">
              <i class="ki-duotone ki-arrows-circle fs-3">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Refresh
            </button>
          </div>
        </div>

        <!-- LIVE DASHBOARD STATS -->
        <div class="row g-3">
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-dollar fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ formatCurrency(todayStats.revenue) }}</div>
                <div class="text-white opacity-75 fs-8">Today's Revenue</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-oil-barrel fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">
                  {{ todayStats.fuelDispensed.toFixed(0) }}L
                </div>
                <div class="text-white opacity-75 fs-8">Fuel Dispensed</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-basket fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ todayStats.transactions }}</div>
                <div class="text-white opacity-75 fs-8">Transactions</div>
              </div>
            </div>
          </div>
          <div class="col-3">
            <div class="card bg-white bg-opacity-20 border-0 text-center">
              <div class="card-body p-3">
                <i class="ki-duotone ki-profile-user fs-2x text-white mb-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="fw-bold text-white fs-6">{{ todayStats.customers }}</div>
                <div class="text-white opacity-75 fs-8">Customers</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- CUSTOMER SELECTION -->
    <div class="card border-0 shadow-sm mb-3">
      <div class="card-body p-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <h5 class="fw-bold text-gray-800 mb-0">
            <i class="ki-duotone ki-profile-user text-info fs-1 me-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            Customer Selection
          </h5>
          <button @click="resetCustomer" class="btn btn-light-danger btn-sm">
            <i class="ki-duotone ki-arrows-circle fs-4 me-1">
              <span class="path1"></span><span class="path2"></span>
            </i>
            Reset
          </button>
        </div>

        <!-- Customer Type Selection -->
        <div class="row g-3 mb-3">
          <div class="col-6">
            <button
              @click="setCustomerType('walk-in')"
              :class="[
                'btn w-100 h-60px',
                customerType === 'walk-in' ? 'btn-success' : 'btn-light-success',
              ]"
            >
              <div class="d-flex align-items-center">
                <i class="ki-duotone ki-user-tick fs-2 me-3">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="text-start">
                  <div class="fw-bold fs-6">Walk-in Customer</div>
                  <div class="fs-8 opacity-75">Cash/Card payment</div>
                </div>
              </div>
            </button>
          </div>
          <div class="col-6">
            <button
              @click="setCustomerType('credit')"
              :class="[
                'btn w-100 h-60px',
                customerType === 'credit' ? 'btn-info' : 'btn-light-info',
              ]"
            >
              <div class="d-flex align-items-center">
                <i class="ki-duotone ki-address-book fs-2 me-3">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <div class="text-start">
                  <div class="fw-bold fs-6">Credit Customer</div>
                  <div class="fs-8 opacity-75">Account billing</div>
                </div>
              </div>
            </button>
          </div>
        </div>

        <!-- Credit Customer Search -->
        <div v-if="customerType === 'credit'">
          <div class="position-relative mb-3">
            <input
              v-model="customerSearchQuery"
              @input="debounceCustomerSearch"
              type="text"
              class="form-control form-control-lg ps-5"
              :class="{ 'border-success': selectedCustomer }"
              placeholder="Search by name, phone, or customer code..."
              :disabled="loadingCustomers"
            />
            <i
              class="ki-duotone ki-magnifier position-absolute top-50 start-0 translate-middle-y ms-3 fs-3 text-gray-500"
            >
              <span class="path1"></span><span class="path2"></span>
            </i>
            <div
              v-if="loadingCustomers"
              class="position-absolute top-50 end-0 translate-middle-y me-3"
            >
              <div class="spinner-border spinner-border-sm text-primary"></div>
            </div>
          </div>

          <!-- Selected Customer Display -->
          <div v-if="selectedCustomer" class="card bg-light-success border-success mb-3">
            <div class="card-body p-3">
              <div class="d-flex align-items-center justify-content-between">
                <div>
                  <div class="fw-bold text-success fs-5">
                    {{ getCustomerDisplayName(selectedCustomer) }}
                  </div>
                  <div class="fs-7 text-success opacity-75">
                    {{ selectedCustomer.CustomerCode }} • {{ selectedCustomer.PhoneNumber }}
                  </div>
                  <div v-if="selectedCustomer.creditAccount" class="fs-7 text-success">
                    Available Credit:
                    {{ formatCurrency(selectedCustomer.creditAccount.AvailableCredit) }}
                    <span class="ms-2"
                      >Balance:
                      {{ formatCurrency(selectedCustomer.creditAccount.CurrentBalance) }}</span
                    >
                  </div>
                </div>
                <button @click="clearCustomer" class="btn btn-icon btn-light-danger btn-sm">
                  <i class="ki-duotone ki-cross fs-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                </button>
              </div>
            </div>
          </div>

          <!-- Customer Search Results -->
          <div
            v-if="customerSearchResults.length && !selectedCustomer"
            class="card border-info mb-3"
          >
            <div class="card-body p-0 max-h-250px overflow-auto">
              <div
                v-for="customer in customerSearchResults.slice(0, 5)"
                :key="customer.CustomerID"
                @click="selectCustomer(customer)"
                class="p-3 border-bottom border-light cursor-pointer hover-bg-light"
              >
                <div class="d-flex align-items-center justify-content-between">
                  <div>
                    <div class="fw-bold fs-6">{{ getCustomerDisplayName(customer) }}</div>
                    <div class="fs-8 text-gray-500">
                      {{ customer.PhoneNumber }} • {{ customer.CustomerCode }}
                    </div>
                    <div v-if="customer.creditAccount" class="fs-8 text-info">
                      Credit: {{ formatCurrency(customer.creditAccount.AvailableCredit) }}
                    </div>
                  </div>
                  <i class="ki-duotone ki-arrow-right fs-3 text-info">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- PRODUCTS GRID WITH REAL INVENTORY -->
    <div class="card border-0 shadow-sm mb-3">
      <div class="card-body p-4">
        <h5 class="fw-bold text-gray-800 mb-3">
          <i class="ki-duotone ki-oil-barrel text-primary fs-1 me-2">
            <span class="path1"></span><span class="path2"></span>
          </i>
          Products & Fuel ({{ products.length }} items)
        </h5>

        <div v-if="systemLoading" class="text-center py-5">
          <div class="spinner-border spinner-border-lg text-primary mb-3"></div>
          <div class="fw-bold text-gray-600">Loading inventory data...</div>
        </div>

        <div v-else class="row g-3">
          <div v-for="product in products" :key="product.ProductID" class="col-6 col-md-4 col-lg-3">
            <div
              @click="selectProduct(product)"
              class="card h-100 cursor-pointer position-relative shadow-sm border-0"
              :class="getProductCardClass(product)"
              style="min-height: 200px; transition: all 0.2s ease"
            >
              <!-- Out of Stock Overlay -->
              <div
                v-if="getRealStock(product) <= 0"
                class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center bg-danger bg-opacity-90 rounded z-1"
              >
                <div class="text-center text-white">
                  <i class="ki-duotone ki-information fs-2x mb-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  <div class="fw-bold">OUT OF STOCK</div>
                </div>
              </div>

              <div class="card-body p-3 text-center d-flex flex-column">
                <!-- Product Icon -->
                <div class="mb-3">
                  <i
                    :class="[
                      'ki-duotone',
                      getProductIcon(product.ProductType),
                      'fs-3x',
                      getProductIconColor(product.ProductType),
                    ]"
                  >
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                </div>

                <!-- Product Details -->
                <div class="flex-grow-1 d-flex flex-column justify-content-between">
                  <div>
                    <h6 class="fw-bold text-gray-800 mb-2 fs-6">{{ product.Name }}</h6>
                    <div class="fw-bold text-success fs-4 mb-2">
                      {{ formatCurrency(getProductPrice(product)) }}
                    </div>
                    <div class="fs-8 text-gray-500 mb-2">{{ product.ProductType }}</div>
                  </div>

                  <!-- Real Stock Information -->
                  <div class="mt-auto">
                    <div v-if="isFuelProduct(product)" class="mb-2">
                      <div class="fs-8 text-info">
                        {{ getProductTanks(product).length }} Tank(s)
                      </div>
                      <div class="fs-8 text-warning">
                        {{ getProductPumps(product).length }} Pump(s)
                      </div>
                      <div class="fs-8 text-primary">
                        Total: {{ formatVolume(getRealStock(product)) }}
                      </div>
                    </div>
                    <div v-else class="mb-2">
                      <div class="fs-8 text-info">
                        In Stock: {{ formatQuantity(getRealStock(product)) }}
                      </div>
                    </div>

                    <span :class="['badge', 'badge-sm', getStockBadgeClass(getRealStock(product))]">
                      {{ isFuelProduct(product) ? 'Fuel' : 'Stock' }}:
                      {{ formatStockDisplay(product, getRealStock(product)) }}
                    </span>
                  </div>
                </div>

                <!-- Cart Quantity Indicator -->
                <div
                  v-if="getCartQuantity(product.ProductID) > 0"
                  class="position-absolute top-0 end-0 mt-2 me-2"
                >
                  <span
                    class="badge badge-circle badge-success fs-7 fw-bold w-25px h-25px d-flex align-items-center justify-content-center"
                  >
                    {{ getCartQuantity(product.ProductID) }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- FUEL DISPENSING MODAL -->
    <div
      v-if="showFuelModal && selectedProduct"
      class="modal d-block"
      style="background: rgba(0, 0, 0, 0.7)"
      tabindex="-1"
    >
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
          <div class="modal-header bg-gradient-primary border-0">
            <h3 class="modal-title fw-bold text-white">
              <i class="ki-duotone ki-oil-barrel fs-1 me-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Fuel Dispensing: {{ selectedProduct.Name }}
            </h3>
            <button @click="closeFuelModal" class="btn btn-icon btn-light btn-sm">
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body p-4">
            <!-- Step 1: Tank Selection -->
            <div v-if="dispensingStep === 1" class="mb-4">
              <h5 class="fw-bold text-gray-800 mb-3">Select Tank</h5>
              <div class="row g-3">
                <div v-for="tank in availableTanks" :key="tank.TankID" class="col-6">
                  <div
                    @click="selectTank(tank)"
                    :class="[
                      'card cursor-pointer h-100',
                      selectedTank?.TankID === tank.TankID
                        ? 'border-primary bg-light-primary'
                        : 'border-light',
                    ]"
                  >
                    <div class="card-body p-3 text-center">
                      <i class="ki-duotone ki-oil-barrel fs-2x text-primary mb-2">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      <div class="fw-bold text-gray-800 fs-5">{{ tank.TankName }}</div>
                      <div class="fs-7 text-gray-600">
                        Capacity: {{ formatVolume(tank.Capacity) }}
                      </div>
                      <div class="fs-7 text-success">
                        Available: {{ formatVolume(tank.CurrentLevel) }}
                      </div>
                      <div class="mt-2">
                        <div class="progress" style="height: 8px">
                          <div
                            class="progress-bar bg-success"
                            :style="{
                              width:
                                Math.min(
                                  (parseFloat(tank.CurrentLevel) / parseFloat(tank.Capacity)) * 100,
                                  100,
                                ) + '%',
                            }"
                          ></div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Step 2: Pump Selection -->
            <div v-if="dispensingStep === 2 && selectedTank" class="mb-4">
              <h5 class="fw-bold text-gray-800 mb-3">
                Select Pump (Tank: {{ selectedTank.TankName }})
              </h5>
              <div class="row g-3">
                <div v-for="pump in availablePumps" :key="pump.PumpID" class="col-6">
                  <div
                    @click="selectPump(pump)"
                    :class="[
                      'card cursor-pointer h-100',
                      selectedPump?.PumpID === pump.PumpID
                        ? 'border-warning bg-light-warning'
                        : 'border-light',
                    ]"
                  >
                    <div class="card-body p-3 text-center">
                      <i class="ki-duotone ki-gas-station fs-2x text-warning mb-2">
                        <span class="path1"></span><span class="path2"></span>
                      </i>
                      <div class="fw-bold text-gray-800 fs-5">{{ pump.PumpName }}</div>
                      <div class="fs-7 text-gray-600">Meter Reading:</div>
                      <div class="fs-6 fw-bold text-warning">
                        {{ formatVolume(pump.MeterReading) }}
                      </div>
                      <div class="mt-2">
                        <span
                          :class="[
                            'badge',
                            pump.Status === 'Active' ? 'badge-success' : 'badge-danger',
                          ]"
                        >
                          {{ pump.Status }}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Step 3: Quantity Input -->
            <div v-if="dispensingStep === 3 && selectedPump" class="mb-4">
              <h5 class="fw-bold text-gray-800 mb-3">Dispense Quantity</h5>

              <!-- Tank & Pump Info Display -->
              <div class="row g-3 mb-3">
                <div class="col-6">
                  <div class="card bg-light-info">
                    <div class="card-body p-3 text-center">
                      <div class="fw-bold text-info fs-5">{{ selectedTank.TankName }}</div>
                      <div class="fs-7 text-info">
                        Available: {{ formatVolume(selectedTank.CurrentLevel) }}
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-6">
                  <div class="card bg-light-warning">
                    <div class="card-body p-3 text-center">
                      <div class="fw-bold text-warning fs-5">{{ selectedPump.PumpName }}</div>
                      <div class="fs-7 text-warning">
                        Meter: {{ formatVolume(selectedPump.MeterReading) }}
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <label class="form-label fw-bold fs-4 mb-3">Quantity to Dispense (Liters)</label>
              <input
                v-model.number="dispenseQuantity"
                @input="validateDispenseQuantity"
                type="number"
                step="0.01"
                min="0.01"
                :max="selectedTank.CurrentLevel"
                class="form-control form-control-lg text-center fw-bold"
                :class="getQuantityInputClass"
                style="font-size: 2rem; height: 80px"
                placeholder="Enter liters..."
              />

              <!-- Validation Feedback -->
              <div
                v-if="dispenseQuantity > parseFloat(selectedTank.CurrentLevel)"
                class="mt-3 alert alert-danger"
              >
                <i class="ki-duotone ki-information fs-2 me-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                Insufficient fuel. Maximum: {{ formatVolume(selectedTank.CurrentLevel) }}
              </div>

              <!-- Quick Quantity Buttons -->
              <div class="row g-2 mt-3">
                <div v-for="qty in getQuickQuantities()" :key="qty" class="col-4">
                  <button @click="dispenseQuantity = qty" class="btn btn-light-primary w-100 fs-6">
                    {{ qty }}L
                  </button>
                </div>
              </div>

              <!-- Dispense Summary -->
              <div
                v-if="
                  dispenseQuantity > 0 && dispenseQuantity <= parseFloat(selectedTank.CurrentLevel)
                "
                class="mt-4 card bg-light-success border-success"
              >
                <div class="card-body p-3">
                  <h6 class="fw-bold text-success mb-2">Dispense Summary</h6>
                  <div class="d-flex justify-content-between mb-1">
                    <span>Quantity:</span>
                    <span class="fw-bold">{{ dispenseQuantity }}L</span>
                  </div>
                  <div class="d-flex justify-content-between mb-1">
                    <span>Unit Price:</span>
                    <span class="fw-bold">{{
                      formatCurrency(getProductPrice(selectedProduct))
                    }}</span>
                  </div>
                  <div class="d-flex justify-content-between mb-2">
                    <span>Total:</span>
                    <span class="fw-bold text-success fs-4">{{
                      formatCurrency(dispenseQuantity * getProductPrice(selectedProduct))
                    }}</span>
                  </div>
                  <div class="separator my-2"></div>
                  <div class="fs-8 text-gray-600">
                    Tank after:
                    {{ formatVolume(parseFloat(selectedTank.CurrentLevel) - dispenseQuantity) }} /
                    {{ formatVolume(selectedTank.Capacity) }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Modal Actions -->
            <div class="d-flex gap-2">
              <button
                v-if="dispensingStep > 1"
                @click="previousStep"
                class="btn btn-light-secondary"
              >
                <i class="ki-duotone ki-arrow-left fs-3 me-1">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                Back
              </button>
              <button
                v-if="dispensingStep < 3"
                @click="nextStep"
                :disabled="!canProceedToNextStep"
                class="btn btn-primary flex-grow-1"
              >
                Next Step
                <i class="ki-duotone ki-arrow-right fs-3 ms-1">
                  <span class="path1"></span><span class="path2"></span>
                </i>
              </button>
              <button
                v-if="dispensingStep === 3"
                @click="confirmFuelDispense"
                :disabled="!canDispense"
                class="btn btn-success flex-grow-1"
              >
                <i class="ki-duotone ki-check-circle fs-3 me-1">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                Add to Cart
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- SHOPPING CART -->
    <div v-if="cartItems.length > 0" class="card border-0 shadow-lg mb-3">
      <div class="card-body p-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
          <h5 class="fw-bold text-gray-800 mb-0">
            <i class="ki-duotone ki-basket text-warning fs-1 me-2">
              <span class="path1"></span><span class="path2"></span>
            </i>
            Shopping Cart ({{ cartItems.length }} items)
          </h5>
          <div class="d-flex gap-2">
            <button @click="clearCart" class="btn btn-light-danger btn-sm">
              <i class="ki-duotone ki-trash fs-3 me-1">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Clear
            </button>
            <button @click="toggleCartExpanded" class="btn btn-light-primary btn-sm">
              <i :class="['ki-duotone', cartExpanded ? 'ki-up' : 'ki-down', 'fs-3']">
                <span class="path1"></span><span class="path2"></span>
              </i>
              {{ cartExpanded ? 'Collapse' : 'Expand' }}
            </button>
          </div>
        </div>

        <!-- Cart Items -->
        <div v-if="cartExpanded" class="mb-3">
          <div
            v-for="(item, index) in cartItems"
            :key="`cart-${item.product.ProductID}-${index}`"
            class="card bg-light mb-2"
          >
            <div class="card-body p-3">
              <div class="d-flex align-items-center gap-3">
                <div class="flex-grow-1">
                  <div class="fw-bold text-gray-800 fs-6 mb-1">{{ item.product.Name }}</div>
                  <div class="fs-8 text-gray-500">{{ formatCurrency(item.unitPrice) }} each</div>
                  <div v-if="item.tankInfo" class="fs-8 text-info">
                    {{ item.tankInfo.TankName }} → {{ item.pumpInfo.PumpName }}
                  </div>
                </div>

                <!-- Quantity Controls -->
                <div class="d-flex align-items-center gap-2">
                  <button
                    @click="updateCartQuantity(index, item.quantity - 1)"
                    class="btn btn-icon btn-light-danger btn-sm w-35px h-35px"
                  >
                    <i class="ki-duotone ki-minus fs-4">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                  <span class="fw-bold fs-5 text-center" style="min-width: 50px">
                    {{ item.quantity }}{{ isFuelProduct(item.product) ? 'L' : '' }}
                  </span>
                  <button
                    @click="updateCartQuantity(index, item.quantity + 1)"
                    class="btn btn-icon btn-light-primary btn-sm w-35px h-35px"
                  >
                    <i class="ki-duotone ki-plus fs-4">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                </div>

                <!-- Item Total & Remove -->
                <div class="text-end">
                  <div class="fw-bold text-success fs-5">{{ formatCurrency(item.total) }}</div>
                  <button
                    @click="removeFromCart(index)"
                    class="btn btn-icon btn-light-danger btn-xs mt-1"
                  >
                    <i class="ki-duotone ki-trash fs-5">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Cart Summary -->
        <div class="card bg-light-primary border-primary">
          <div class="card-body p-3">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="text-gray-700 fs-6">Subtotal:</span>
              <span class="fw-bold fs-6">{{ formatCurrency(cartSubtotal) }}</span>
            </div>
            <div class="d-flex justify-content-between align-items-center mb-2">
              <span class="text-gray-700 fs-6">Tax ({{ taxRate }}%):</span>
              <span class="fw-bold fs-6">{{ formatCurrency(cartTax) }}</span>
            </div>
            <div class="separator my-2"></div>
            <div class="d-flex justify-content-between align-items-center mb-3">
              <span class="fw-bold text-gray-800 fs-4">Total:</span>
              <span class="fw-bold text-success fs-3">{{ formatCurrency(cartTotal) }}</span>
            </div>

            <!-- Credit Validation Warning -->
            <div
              v-if="customerType === 'credit' && selectedCustomer && selectedCustomer.creditAccount"
              class="mb-3"
            >
              <div
                v-if="cartTotal > parseFloat(selectedCustomer.creditAccount.AvailableCredit)"
                class="alert alert-warning py-2"
              >
                <i class="ki-duotone ki-information fs-3 me-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                <small>
                  Exceeds credit by
                  {{
                    formatCurrency(
                      cartTotal - parseFloat(selectedCustomer.creditAccount.AvailableCredit),
                    )
                  }}
                </small>
              </div>
            </div>

            <!-- Checkout Button -->
            <button
              @click="openPaymentSheet"
              :disabled="!canProceedToPayment"
              class="btn btn-primary w-100 h-60px fs-4 fw-bold"
            >
              <i class="ki-duotone ki-credit-cart fs-1 me-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Proceed to Payment
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- PAYMENT MODAL -->
    <div
      v-if="showPaymentModal"
      class="modal d-block"
      style="background: rgba(0, 0, 0, 0.6)"
      tabindex="-1"
    >
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
          <div class="modal-header bg-gradient-primary border-0">
            <h3 class="modal-title fw-bold text-white">
              <i class="ki-duotone ki-credit-cart fs-1 me-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Payment Processing
            </h3>
            <button @click="closePaymentModal" class="btn btn-icon btn-light btn-sm">
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body p-4">
            <!-- Payment Amount Display -->
            <div class="card bg-light-success text-center mb-4">
              <div class="card-body p-4">
                <div class="fs-7 text-gray-600 mb-1">Total Amount</div>
                <div class="fw-bold text-success" style="font-size: 2.5rem">
                  {{ formatCurrency(cartTotal) }}
                </div>
                <div
                  v-if="customerType === 'credit' && selectedCustomer"
                  class="fs-8 text-gray-600 mt-2"
                >
                  Customer: {{ getCustomerDisplayName(selectedCustomer) }}
                </div>
              </div>
            </div>

            <!-- Payment Methods -->
            <div class="row g-3 mb-4">
              <div class="col-4">
                <button
                  @click="setPaymentMethod('Cash')"
                  :class="[
                    'btn w-100 h-100px',
                    paymentMethod === 'Cash' ? 'btn-success' : 'btn-light-success',
                  ]"
                >
                  <div class="text-center">
                    <i class="ki-duotone ki-dollar fs-3x mb-3">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    <div class="fw-bold fs-5">Cash</div>
                  </div>
                </button>
              </div>
              <div class="col-4">
                <button
                  @click="setPaymentMethod('Card')"
                  :class="[
                    'btn w-100 h-100px',
                    paymentMethod === 'Card' ? 'btn-info' : 'btn-light-info',
                  ]"
                >
                  <div class="text-center">
                    <i class="ki-duotone ki-credit-cart fs-3x mb-3">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    <div class="fw-bold fs-5">Card</div>
                  </div>
                </button>
              </div>
              <div class="col-4">
                <button
                  @click="setPaymentMethod('Mobile Money')"
                  :class="[
                    'btn w-100 h-100px',
                    paymentMethod === 'Mobile Money' ? 'btn-warning' : 'btn-light-warning',
                  ]"
                >
                  <div class="text-center">
                    <i class="ki-duotone ki-phone fs-3x mb-3">
                      <span class="path1"></span><span class="path2"></span>
                    </i>
                    <div class="fw-bold fs-5">Mobile</div>
                  </div>
                </button>
              </div>
            </div>

            <!-- Payment Method Specific UI -->
            <div v-if="paymentMethod === 'Cash'" class="mb-4">
              <label class="form-label fw-bold fs-4 mb-3">Cash Received</label>
              <input
                v-model.number="cashReceived"
                @input="validateCashAmount"
                type="number"
                step="1000"
                min="0"
                class="form-control form-control-lg text-center fw-bold"
                :class="getCashInputClass"
                style="font-size: 2rem; height: 80px"
                placeholder="Enter amount..."
              />

              <!-- Cash Feedback -->
              <div
                v-if="cashReceived >= cartTotal && cashReceived > 0"
                class="mt-3 card bg-light-success border-success"
              >
                <div class="card-body p-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <span class="text-success fw-bold fs-5">Change:</span>
                    <span class="text-success fw-bold fs-3">{{
                      formatCurrency(cashReceived - cartTotal)
                    }}</span>
                  </div>
                </div>
              </div>

              <div
                v-if="cashReceived > 0 && cashReceived < cartTotal"
                class="mt-3 card bg-light-danger border-danger"
              >
                <div class="card-body p-3">
                  <div class="d-flex justify-content-between align-items-center">
                    <span class="text-danger fw-bold fs-5">Still Need:</span>
                    <span class="text-danger fw-bold fs-3">{{
                      formatCurrency(cartTotal - cashReceived)
                    }}</span>
                  </div>
                </div>
              </div>

              <!-- Quick Cash Buttons -->
              <div class="row g-2 mt-3">
                <div v-for="amount in getQuickCashAmounts()" :key="amount" class="col-4">
                  <button @click="cashReceived = amount" class="btn btn-light-primary w-100 fs-6">
                    {{ formatShortCurrency(amount) }}
                  </button>
                </div>
              </div>
            </div>

            <div v-if="paymentMethod !== 'Cash'" class="mb-4">
              <label class="form-label fw-bold fs-4 mb-3">Payment Reference</label>
              <input
                v-model="paymentReference"
                type="text"
                class="form-control form-control-lg"
                :class="getPaymentReferenceClass"
                style="height: 80px; font-size: 1.2rem"
                :placeholder="getPaymentPlaceholder()"
                maxlength="50"
              />
              <div
                v-if="paymentReference.length > 0 && paymentReference.length < 3"
                class="mt-2 text-danger fs-7"
              >
                Reference must be at least 3 characters
              </div>
            </div>

            <!-- Complete Sale Button -->
            <button
              @click="processSale"
              :disabled="!canProcessSale || processing"
              class="btn btn-primary w-100 fw-bold"
              style="height: 80px; font-size: 1.5rem"
            >
              <div v-if="processing" class="d-flex align-items-center justify-content-center">
                <div class="spinner-border spinner-border-sm me-2"></div>
                Processing Sale...
              </div>
              <div v-else class="d-flex align-items-center justify-content-center">
                <i class="ki-duotone ki-check-circle fs-1 me-2">
                  <span class="path1"></span><span class="path2"></span>
                </i>
                Complete Sale
              </div>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- CASH DRAWER MODAL -->
    <div
      v-if="showCashDrawerModal"
      class="modal d-block"
      style="background: rgba(0, 0, 0, 0.6)"
      tabindex="-1"
    >
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
          <div class="modal-header bg-gradient-success border-0">
            <h3 class="modal-title fw-bold text-white">
              <i class="ki-duotone ki-dollar fs-1 me-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
              Cash Drawer Management
            </h3>
            <button @click="closeCashDrawer" class="btn btn-icon btn-light btn-sm">
              <i class="ki-duotone ki-cross fs-2">
                <span class="path1"></span><span class="path2"></span>
              </i>
            </button>
          </div>
          <div class="modal-body p-4">
            <!-- Current Drawer Status -->
            <div v-if="currentCashDrawer" class="card bg-light-success border-success mb-4">
              <div class="card-body p-3">
                <h6 class="fw-bold text-success mb-2">Current Shift Drawer</h6>
                <div class="row g-3">
                  <div class="col-6">
                    <div class="d-flex justify-content-between">
                      <span>Opening:</span>
                      <span class="fw-bold">{{
                        formatCurrency(currentCashDrawer.OpeningBalance)
                      }}</span>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="d-flex justify-content-between">
                      <span>Cash Sales:</span>
                      <span class="fw-bold">{{ formatCurrency(currentCashDrawer.CashSales) }}</span>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="d-flex justify-content-between">
                      <span>Expected:</span>
                      <span class="fw-bold">{{ formatCurrency(getExpectedCash()) }}</span>
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="d-flex justify-content-between">
                      <span>Status:</span>
                      <span
                        :class="[
                          'fw-bold',
                          currentCashDrawer.Status === 'Open' ? 'text-success' : 'text-danger',
                        ]"
                      >
                        {{ currentCashDrawer.Status }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Drawer Actions -->
            <div class="row g-3">
              <div
                v-if="!currentCashDrawer || currentCashDrawer.Status === 'Closed'"
                class="col-12"
              >
                <button @click="openNewDrawer" class="btn btn-success w-100 h-60px fs-4">
                  <i class="ki-duotone ki-plus fs-1 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Open New Cash Drawer
                </button>
              </div>
              <div v-if="currentCashDrawer && currentCashDrawer.Status === 'Open'" class="col-6">
                <button @click="closeDrawer" class="btn btn-danger w-100 h-60px fs-5">
                  <i class="ki-duotone ki-lock fs-1 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Close Drawer
                </button>
              </div>
              <div v-if="currentCashDrawer && currentCashDrawer.Status === 'Open'" class="col-6">
                <button @click="reconcileDrawer" class="btn btn-warning w-100 h-60px fs-5">
                  <i class="ki-duotone ki-calculator fs-1 me-2">
                    <span class="path1"></span><span class="path2"></span>
                  </i>
                  Reconcile
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'

// ===== CONSTANTS =====
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'
const TAX_RATE = 18 // Default tax rate percentage

// ===== AUTHENTICATION STATE =====
const authUser = ref({})
const authToken = ref('')
const currentStation = ref({})
const userStations = ref([])
const userRoles = ref([])
const userPermissions = ref([])

// ===== SYSTEM LOADING STATE =====
const systemLoading = ref(false)
const loadingCustomers = ref(false)
const processing = ref(false)

// ===== CORE DATA STRUCTURES =====
const products = ref([])
const tanks = ref([])
const pumps = ref([])
const stationInventory = ref(new Map()) // ProductID -> CurrentStock
const customers = ref([])

// ===== UI STATE =====
const showFuelModal = ref(false)
const showPaymentModal = ref(false)
const showCashDrawerModal = ref(false)
const cartExpanded = ref(true)

// ===== CUSTOMER STATE =====
const customerType = ref('walk-in') // 'walk-in' or 'credit'
const selectedCustomer = ref(null)
const customerSearchQuery = ref('')
const customerSearchResults = ref([])
let customerSearchTimeout = null

// ===== FUEL DISPENSING STATE =====
const selectedProduct = ref(null)
const selectedTank = ref(null)
const selectedPump = ref(null)
const dispensingStep = ref(1)
const dispenseQuantity = ref(0)
const availableTanks = ref([])
const availablePumps = ref([])

// ===== CART STATE =====
const cartItems = ref([])
const taxRate = ref(TAX_RATE)

// ===== PAYMENT STATE =====
const paymentMethod = ref('Cash')
const cashReceived = ref(0)
const paymentReference = ref('')

// ===== CASH DRAWER STATE =====
const currentCashDrawer = ref(null)

// ===== DASHBOARD STATS =====
const todayStats = reactive({
  transactions: 0,
  revenue: 0,
  customers: 0,
  fuelDispensed: 0,
})

// ===== COMPUTED PROPERTIES =====
const cartSubtotal = computed(() => {
  return cartItems.value.reduce((sum, item) => sum + parseFloat(item.total || 0), 0)
})

const cartTax = computed(() => {
  return cartSubtotal.value * (taxRate.value / 100)
})

const cartTotal = computed(() => {
  return cartSubtotal.value + cartTax.value
})

const canProceedToPayment = computed(() => {
  // CRITICAL: No transactions without open cash drawer
  if (!currentCashDrawer.value || currentCashDrawer.value.Status !== 'Open') {
    return false
  }

  if (!cartItems.value.length) return false

  if (customerType.value === 'credit') {
    if (!selectedCustomer.value) return false
    if (selectedCustomer.value.creditAccount) {
      const availableCredit = parseFloat(selectedCustomer.value.creditAccount.AvailableCredit || 0)
      return cartTotal.value <= availableCredit
    }
    return false
  }

  return true
})

const canProcessSale = computed(() => {
  if (!cartItems.value.length || processing.value) return false

  if (customerType.value === 'credit' && !selectedCustomer.value) return false

  switch (paymentMethod.value) {
    case 'Cash':
      return cashReceived.value >= cartTotal.value && cashReceived.value > 0
    case 'Card':
    case 'Mobile Money':
      return paymentReference.value.trim().length >= 3
    default:
      return false
  }
})

const canProceedToNextStep = computed(() => {
  switch (dispensingStep.value) {
    case 1:
      return selectedTank.value !== null
    case 2:
      return selectedPump.value !== null
    default:
      return false
  }
})

const canDispense = computed(() => {
  return (
    dispenseQuantity.value > 0 &&
    dispenseQuantity.value <= parseFloat(selectedTank.value?.CurrentLevel || 0) &&
    selectedTank.value &&
    selectedPump.value
  )
})

const getQuantityInputClass = computed(() => {
  if (dispenseQuantity.value === 0) return ''
  if (dispenseQuantity.value > parseFloat(selectedTank.value?.CurrentLevel || 0))
    return 'border-danger'
  return 'border-success'
})

const getCashInputClass = computed(() => {
  if (cashReceived.value === 0) return ''
  if (cashReceived.value >= cartTotal.value) return 'border-success'
  if (cashReceived.value < cartTotal.value) return 'border-warning'
  return ''
})

const getPaymentReferenceClass = computed(() => {
  if (!paymentReference.value) return ''
  if (paymentReference.value.length >= 3) return 'border-success'
  return 'border-danger'
})

// ===== AUTHENTICATION FUNCTIONS =====
const loadAuthData = () => {
  try {
    const authData = localStorage.getItem('kigrama_user_data')
    const token = localStorage.getItem('kigrama_auth_token')

    if (!authData || !token) {
      throw new Error('No authentication data found')
    }

    const parsedData = JSON.parse(authData)
    authUser.value = parsedData.user || {}
    authToken.value = token
    userStations.value = parsedData.stations || []
    userRoles.value = parsedData.roles || []
    userPermissions.value = parsedData.permissions || []

    // Set current station (use first assigned station)
    if (userStations.value.length > 0) {
      currentStation.value =
        userStations.value.find((s) => s.IsPrimary === '1') || userStations.value[0]
    }

    console.log('✅ Auth data loaded:', {
      user: authUser.value.name,
      station: currentStation.value.StationName,
      roles: userRoles.value.length,
      permissions: userPermissions.value.length,
    })

    return true
  } catch (error) {
    console.error('❌ Failed to load auth data:', error)
    return false
  }
}

const getAuthHeaders = () => {
  return {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${authToken.value}`,
  }
}

// ===== API FUNCTIONS =====
const apiCall = async (endpoint, options = {}) => {
  try {
    console.log(`🌐 API Call: ${options.method || 'GET'} ${endpoint}`)

    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      headers: getAuthHeaders(),
      ...options,
    })

    if (!response.ok) {
      const errorText = await response.text().catch(() => 'Unknown error')
      console.error(`❌ API Error ${response.status}:`, errorText)
      throw new Error(`API Error: ${response.status} ${response.statusText} - ${errorText}`)
    }

    const text = await response.text()
    console.log(`📄 Raw response:`, text.substring(0, 200) + (text.length > 200 ? '...' : ''))

    if (!text.trim()) {
      console.log('✅ Empty response (success)')
      return { success: true }
    }

    const parsed = JSON.parse(text)
    console.log(`✅ Parsed response:`, parsed)
    return parsed
  } catch (error) {
    console.error(`❌ API call failed for ${endpoint}:`, error)
    throw error
  }
}

// ===== PRODUCT CLASSIFICATION FUNCTIONS =====
const isFuelProduct = (product) => {
  if (!product?.ProductType) return false
  const type = product.ProductType.toLowerCase()
  return (
    type === 'fuel' ||
    type.includes('petrol') ||
    type.includes('diesel') ||
    type.includes('gasoline') ||
    type.includes('kerosene')
  )
}

const getProductIcon = (productType) => {
  if (!productType) return 'ki-cube-2'
  const type = productType.toLowerCase()
  if (type.includes('fuel') || type.includes('petrol') || type.includes('diesel'))
    return 'ki-oil-barrel'
  if (type.includes('lubricant') || type.includes('oil')) return 'ki-oil'
  if (type.includes('gas') || type.includes('lpg')) return 'ki-gas-station'
  if (type.includes('service')) return 'ki-wrench'
  return 'ki-cube-2'
}

const getProductIconColor = (productType) => {
  if (!productType) return 'text-gray-400'
  const type = productType.toLowerCase()
  if (type.includes('fuel') || type.includes('petrol') || type.includes('diesel'))
    return 'text-success'
  if (type.includes('lubricant') || type.includes('oil')) return 'text-info'
  if (type.includes('gas') || type.includes('lpg')) return 'text-warning'
  if (type.includes('service')) return 'text-primary'
  return 'text-gray-400'
}

const getProductPrice = (product) => {
  return parseFloat(product.SellingPrice || product.UnitPrice || 0)
}

// ===== STOCK CALCULATION FUNCTIONS (FIXED) =====
const getRealStock = (product) => {
  if (isFuelProduct(product)) {
    // For fuel products: sum all tank levels for this product at current station
    const productTanks = tanks.value.filter(
      (tank) =>
        tank.ProductID === product.ProductID &&
        tank.StationID === currentStation.value.StationID &&
        tank.Status === 'Active',
    )
    return productTanks.reduce((sum, tank) => sum + parseFloat(tank.CurrentLevel || 0), 0)
  } else {
    // For non-fuel products: use station inventory
    return parseFloat(stationInventory.value.get(product.ProductID) || 0)
  }
}

const getProductTanks = (product) => {
  return tanks.value.filter(
    (tank) =>
      tank.ProductID === product.ProductID &&
      tank.StationID === currentStation.value.StationID &&
      tank.Status === 'Active',
  )
}

const getProductPumps = (product) => {
  const productTanks = getProductTanks(product)
  const tankIds = productTanks.map((tank) => tank.TankID)
  return pumps.value.filter((pump) => tankIds.includes(pump.TankID) && pump.Status === 'Active')
}

const getStockBadgeClass = (stock) => {
  const level = parseFloat(stock) || 0
  if (level <= 0) return 'badge-danger'
  if (level <= 100) return 'badge-warning'
  if (level <= 500) return 'badge-info'
  return 'badge-success'
}

const getProductCardClass = (product) => {
  const stock = getRealStock(product)
  const inCart = getCartQuantity(product.ProductID) > 0

  if (stock <= 0) {
    return 'border-danger bg-light-danger'
  } else if (inCart) {
    return 'border-primary bg-light-primary'
  } else {
    return 'bg-white hover-elevate-up'
  }
}

const formatStockDisplay = (product, stock) => {
  if (isFuelProduct(product)) {
    return formatVolume(stock)
  } else {
    return formatQuantity(stock)
  }
}

// ===== DATA LOADING FUNCTIONS (FIXED) =====
const loadProducts = async () => {
  try {
    const response = await apiCall('/Products')
    const allProducts = response.records || []

    // Filter active products with valid pricing
    products.value = allProducts
      .filter(
        (product) =>
          product.Status === 'Active' &&
          product.Name &&
          product.ProductType &&
          (parseFloat(product.UnitPrice) > 0 || parseFloat(product.SellingPrice) > 0),
      )
      .sort((a, b) => a.Name.localeCompare(b.Name))

    console.log(`✅ Loaded ${products.value.length} products`)
  } catch (error) {
    console.error('❌ Failed to load products:', error)
    throw error
  }
}

const loadTanksAndPumps = async () => {
  try {
    // Load tanks for current station only
    const tanksResponse = await apiCall(`/Tanks?StationID=${currentStation.value.StationID}`)
    tanks.value = (tanksResponse.records || []).filter(
      (tank) => tank.StationID === currentStation.value.StationID && tank.Status === 'Active',
    )

    // Load pumps for current station only
    const pumpsResponse = await apiCall(`/Pumps?StationID=${currentStation.value.StationID}`)
    pumps.value = (pumpsResponse.records || []).filter(
      (pump) => pump.StationID === currentStation.value.StationID && pump.Status === 'Active',
    )

    console.log(`✅ Loaded ${tanks.value.length} tanks and ${pumps.value.length} pumps`)
  } catch (error) {
    console.error('❌ Failed to load tanks and pumps:', error)
    throw error
  }
}

const loadStationInventory = async () => {
  try {
    const response = await apiCall(`/StationInventory?StationID=${currentStation.value.StationID}`)
    const inventory = response.records || []

    // Build inventory map for quick lookup
    stationInventory.value.clear()
    inventory.forEach((item) => {
      if (item.StationID === currentStation.value.StationID) {
        stationInventory.value.set(item.ProductID, parseFloat(item.CurrentStock || 0))
      }
    })

    console.log(`✅ Loaded inventory for ${inventory.length} products`)
  } catch (error) {
    console.error('❌ Failed to load station inventory:', error)
    throw error
  }
}

const loadTodayStats = async () => {
  try {
    const today = new Date().toISOString().split('T')[0]
    const response = await apiCall(
      `/Transactions?StationID=${currentStation.value.StationID}&TransactionDate=${today}&Status=Completed`,
    )

    const transactions = response.records || []

    todayStats.transactions = transactions.length
    todayStats.revenue = transactions.reduce((sum, tx) => sum + parseFloat(tx.TotalAmount || 0), 0)
    todayStats.customers = new Set(transactions.map((tx) => tx.CustomerID).filter(Boolean)).size

    // Calculate fuel dispensed today
    let fuelDispensed = 0
    for (const tx of transactions) {
      try {
        const itemsResponse = await apiCall(`/TransactionItems?TransactionID=${tx.TransactionID}`)
        const items = itemsResponse.records || []
        fuelDispensed += items
          .filter((item) => item.TankID) // Fuel items have TankID
          .reduce((sum, item) => sum + parseFloat(item.Quantity || 0), 0)
      } catch (error) {
        // Continue with other transactions if one fails
      }
    }
    todayStats.fuelDispensed = fuelDispensed

    console.log('✅ Today stats loaded:', todayStats)
  } catch (error) {
    console.error('❌ Failed to load today stats:', error)
  }
}

const loadCurrentCashDrawer = async () => {
  try {
    const today = new Date().toISOString().split('T')[0]
    const response = await apiCall(
      `/CashDrawers?StationID=${currentStation.value.StationID}&ShiftDate=${today}&Status=Open`,
    )

    const drawers = response.records || []

    // Find drawer for current attendant or any open drawer
    currentCashDrawer.value =
      drawers.find(
        (drawer) => drawer.AttendantID === authUser.value.id || drawer.Status === 'Open',
      ) || null

    console.log('✅ Current cash drawer:', currentCashDrawer.value?.DrawerID || 'None')
  } catch (error) {
    console.error('❌ Failed to load cash drawer:', error)
  }
}

// ===== CUSTOMER FUNCTIONS =====
const setCustomerType = (type) => {
  customerType.value = type
  if (type === 'walk-in') {
    selectedCustomer.value = null
    customerSearchQuery.value = ''
    customerSearchResults.value = []
  }
}

const resetCustomer = () => {
  setCustomerType('walk-in')
}

const clearCustomer = () => {
  selectedCustomer.value = null
  customerSearchQuery.value = ''
  customerSearchResults.value = []
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

const debounceCustomerSearch = () => {
  if (customerSearchTimeout) {
    clearTimeout(customerSearchTimeout)
  }

  customerSearchTimeout = setTimeout(() => {
    searchCustomers()
  }, 500)
}

const searchCustomers = async () => {
  try {
    const query = customerSearchQuery.value.trim()
    if (!query || query.length < 2) {
      customerSearchResults.value = []
      return
    }

    loadingCustomers.value = true

    const response = await apiCall('/Customers')
    const allCustomers = response.records || []

    customerSearchResults.value = allCustomers
      .filter((customer) => {
        const searchFields = [
          customer.CompanyName,
          customer.FirstName,
          customer.LastName,
          customer.PhoneNumber,
          customer.CustomerCode,
          customer.Email,
        ]
          .filter(Boolean)
          .join(' ')
          .toLowerCase()

        return searchFields.includes(query.toLowerCase())
      })
      .slice(0, 10)

    // Load credit account info for each customer
    for (const customer of customerSearchResults.value) {
      try {
        const creditResponse = await apiCall(
          `/CustomerCreditAccounts?CustomerID=${customer.CustomerID}`,
        )
        const creditAccounts = creditResponse.records || []
        customer.creditAccount = creditAccounts.find(
          (acc) => acc.StationID === currentStation.value.StationID || acc.StationID === null,
        )
      } catch (error) {
        customer.creditAccount = null
      }
    }
  } catch (error) {
    console.error('❌ Customer search failed:', error)
  } finally {
    loadingCustomers.value = false
  }
}

const selectCustomer = (customer) => {
  selectedCustomer.value = customer
  customerSearchResults.value = []
  customerSearchQuery.value = getCustomerDisplayName(customer)
}

// ===== PRODUCT SELECTION & FUEL DISPENSING =====
const selectProduct = (product) => {
  if (getRealStock(product) <= 0) {
    Swal.fire({
      title: 'Out of Stock',
      text: `${product.Name} is currently out of stock`,
      icon: 'warning',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
    return
  }

  if (isFuelProduct(product)) {
    openFuelModal(product)
  } else {
    addNonFuelToCart(product)
  }
}

const openFuelModal = (product) => {
  selectedProduct.value = product
  availableTanks.value = getProductTanks(product).filter(
    (tank) => parseFloat(tank.CurrentLevel) > 0,
  )

  if (availableTanks.value.length === 0) {
    Swal.fire({
      title: 'No Available Tanks',
      text: `No tanks with ${product.Name} are currently available`,
      icon: 'warning',
    })
    return
  }

  // Reset modal state
  selectedTank.value = null
  selectedPump.value = null
  dispensingStep.value = 1
  dispenseQuantity.value = 0
  availablePumps.value = []

  showFuelModal.value = true
}

const closeFuelModal = () => {
  showFuelModal.value = false
  selectedProduct.value = null
  selectedTank.value = null
  selectedPump.value = null
  dispensingStep.value = 1
  dispenseQuantity.value = 0
  availableTanks.value = []
  availablePumps.value = []
}

const selectTank = (tank) => {
  selectedTank.value = tank
  selectedPump.value = null
  availablePumps.value = pumps.value.filter(
    (pump) => pump.TankID === tank.TankID && pump.Status === 'Active',
  )
}

const selectPump = (pump) => {
  selectedPump.value = pump
}

const nextStep = () => {
  if (dispensingStep.value < 3) {
    dispensingStep.value++
  }
}

const previousStep = () => {
  if (dispensingStep.value > 1) {
    dispensingStep.value--
  }
}

const validateDispenseQuantity = () => {
  const maxQty = selectedTank.value ? parseFloat(selectedTank.value.CurrentLevel) : 0
  if (dispenseQuantity.value > maxQty) {
    dispenseQuantity.value = maxQty
  }
  if (dispenseQuantity.value < 0) {
    dispenseQuantity.value = 0
  }
}

const getQuickQuantities = () => {
  const maxQty = selectedTank.value ? parseFloat(selectedTank.value.CurrentLevel) : 0
  const suggestions = [5, 10, 20, 50, 100, 200]
  return suggestions.filter((qty) => qty <= maxQty).slice(0, 6)
}

const confirmFuelDispense = () => {
  if (!canDispense.value) return

  const unitPrice = getProductPrice(selectedProduct.value)
  const total = dispenseQuantity.value * unitPrice

  cartItems.value.push({
    product: { ...selectedProduct.value },
    quantity: dispenseQuantity.value,
    unitPrice,
    total,
    tankInfo: { ...selectedTank.value },
    pumpInfo: { ...selectedPump.value },
    isFuel: true,
  })

  Swal.fire({
    title: 'Added to Cart',
    text: `${dispenseQuantity.value}L of ${selectedProduct.value.Name} added`,
    icon: 'success',
    toast: true,
    position: 'top-end',
    timer: 2000,
    showConfirmButton: false,
  })

  closeFuelModal()
}

const addNonFuelToCart = (product) => {
  const existingIndex = cartItems.value.findIndex(
    (item) => item.product.ProductID === product.ProductID && !item.isFuel,
  )

  if (existingIndex >= 0) {
    const currentQty = cartItems.value[existingIndex].quantity
    const maxQty = getRealStock(product)
    const newQty = Math.min(currentQty + 1, maxQty)

    if (newQty > currentQty) {
      updateCartQuantity(existingIndex, newQty)
    }
  } else {
    const unitPrice = getProductPrice(product)
    const quantity = 1
    const total = unitPrice * quantity

    cartItems.value.push({
      product: { ...product },
      quantity,
      unitPrice,
      total,
      isFuel: false,
    })
  }
}

// ===== CART FUNCTIONS =====
const getCartQuantity = (productId) => {
  const item = cartItems.value.find((item) => item.product.ProductID === productId)
  return item ? item.quantity : 0
}

const updateCartQuantity = (index, newQuantity) => {
  if (index < 0 || index >= cartItems.value.length) return

  const item = cartItems.value[index]
  const maxQty = isFuelProduct(item.product)
    ? item.tankInfo
      ? parseFloat(item.tankInfo.CurrentLevel)
      : 0
    : getRealStock(item.product)

  const validQty = Math.max(0, Math.min(newQuantity, maxQty))

  if (validQty <= 0) {
    removeFromCart(index)
    return
  }

  item.quantity = validQty
  item.total = item.unitPrice * validQty
}

const removeFromCart = (index) => {
  if (index >= 0 && index < cartItems.value.length) {
    cartItems.value.splice(index, 1)

    if (cartItems.value.length === 0) {
      cartExpanded.value = false
      showPaymentModal.value = false
    }
  }
}

const clearCart = async () => {
  if (cartItems.value.length === 0) return

  const result = await Swal.fire({
    title: 'Clear Cart?',
    text: `Remove all ${cartItems.value.length} items from cart?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, Clear',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#6c757d',
  })

  if (result.isConfirmed) {
    cartItems.value = []
    cartExpanded.value = false
    showPaymentModal.value = false

    Swal.fire({
      title: 'Cart Cleared',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 1500,
      showConfirmButton: false,
    })
  }
}

const toggleCartExpanded = () => {
  cartExpanded.value = !cartExpanded.value
}

// ===== PAYMENT FUNCTIONS =====
const openPaymentSheet = () => {
  if (cartItems.value.length === 0) return
  showPaymentModal.value = true
}

const closePaymentModal = () => {
  showPaymentModal.value = false
  paymentMethod.value = 'Cash'
  cashReceived.value = 0
  paymentReference.value = ''
}

const setPaymentMethod = (method) => {
  paymentMethod.value = method

  if (method === 'Cash') {
    paymentReference.value = ''
    cashReceived.value = 0
  } else {
    cashReceived.value = 0
    paymentReference.value = ''
  }
}

const getPaymentPlaceholder = () => {
  switch (paymentMethod.value) {
    case 'Card':
      return 'Enter card transaction reference'
    case 'Mobile Money':
      return 'Enter mobile money reference'
    default:
      return 'Enter reference number'
  }
}

const validateCashAmount = () => {
  if (cashReceived.value < 0) {
    cashReceived.value = 0
  }
}

const getQuickCashAmounts = () => {
  const total = cartTotal.value
  const amounts = []

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
}

// ===== TRANSACTION PROCESSING (FIXED) =====
const processSale = async () => {
  processing.value = true
  let transactionId = null

  try {
    console.log('🚀 Starting sale processing...')
    console.log('📊 Sale summary:', {
      items: cartItems.value.length,
      subtotal: cartSubtotal.value,
      tax: cartTax.value,
      total: cartTotal.value,
      customer: customerType.value,
      payment: paymentMethod.value,
      station: currentStation.value.StationID,
      user: authUser.value.id,
    })

    // Step 1: Validate inventory availability
    console.log('🔍 Validating inventory availability...')
    for (const item of cartItems.value) {
      if (item.isFuel) {
        const tankLevel = parseFloat(item.tankInfo.CurrentLevel)
        if (item.quantity > tankLevel) {
          throw new Error(
            `Insufficient fuel in ${item.tankInfo.TankName}. Need: ${item.quantity}L, Available: ${tankLevel}L`,
          )
        }
        console.log(`✅ Fuel validation: ${item.product.Name} - ${item.quantity}L <= ${tankLevel}L`)
      } else {
        const currentStock = getRealStock(item.product)
        if (item.quantity > currentStock) {
          throw new Error(
            `Insufficient stock for ${item.product.Name}. Need: ${item.quantity}, Available: ${currentStock}`,
          )
        }
        console.log(
          `✅ Stock validation: ${item.product.Name} - ${item.quantity} <= ${currentStock}`,
        )
      }
    }

    // Step 2: Validate customer credit if applicable
    if (customerType.value === 'credit' && selectedCustomer.value) {
      console.log('💳 Validating customer credit...')
      if (selectedCustomer.value.creditAccount) {
        const availableCredit = parseFloat(
          selectedCustomer.value.creditAccount.AvailableCredit || 0,
        )
        if (cartTotal.value > availableCredit) {
          throw new Error(
            `Insufficient credit. Need: ${formatCurrency(cartTotal.value)}, Available: ${formatCurrency(availableCredit)}`,
          )
        }
        console.log(
          `✅ Credit validation: ${formatCurrency(cartTotal.value)} <= ${formatCurrency(availableCredit)}`,
        )
      } else {
        throw new Error(
          `Customer ${getCustomerDisplayName(selectedCustomer.value)} has no credit account`,
        )
      }
    }

    // Step 3: Create main transaction
    console.log('📝 Creating main transaction...')
    const transactionData = {
      StationID: currentStation.value.StationID,
      TransactionDate: new Date().toISOString(),
      TransactionType: 'Sale',
      ReferenceParty: selectedCustomer.value
        ? getCustomerDisplayName(selectedCustomer.value)
        : 'Walk-in Customer',
      TotalAmount: cartTotal.value.toFixed(2),
      TaxAmount: cartTax.value.toFixed(2),
      PaymentMethod: paymentMethod.value,
      PaymentReference: paymentReference.value || `POS-${Date.now()}`,
      PaymentStatus: 'Paid',
      InvoiceNumber: generateInvoiceNumber(),
      Status: 'Completed',
      HandledBy: authUser.value.id,
      CustomerID: selectedCustomer.value?.CustomerID || null,
      IsCreditSale: customerType.value === 'credit' ? '1' : '0',
      OutstandingAmount: customerType.value === 'credit' ? cartTotal.value.toFixed(2) : '0.00',
      Notes: `POS Sale - ${paymentMethod.value}`,
      CreatedAt: new Date().toISOString(),
      UpdatedAt: new Date().toISOString(),
    }

    console.log('📤 Transaction data to send:', transactionData)

    const transactionResponse = await apiCall('/Transactions', {
      method: 'POST',
      body: JSON.stringify(transactionData),
    })

    // TrailBase returns new record IDs in 'ids' array
    transactionId =
      transactionResponse.ids?.[0] || transactionResponse.TransactionID || transactionResponse.id

    console.log('🔍 Transaction response:', transactionResponse)
    console.log('🔍 Extracted transaction ID:', transactionId)

    if (!transactionId) {
      console.error('❌ Failed to extract transaction ID from response:', transactionResponse)
      throw new Error('Failed to create transaction - no ID returned from server')
    }

    // Step 4: Create transaction items
    console.log('🛒 Creating transaction items...')
    for (const [index, item] of cartItems.value.entries()) {
      const itemData = {
        TransactionID: transactionId,
        ProductID: item.product.ProductID,
        Quantity: item.quantity.toString(),
        UnitPrice: item.unitPrice.toFixed(2),
        SellingPrice: item.unitPrice.toFixed(2),
        TaxRate: taxRate.value.toString(),
        Subtotal: item.total.toFixed(2),
        PumpID: item.isFuel ? item.pumpInfo.PumpID : null,
        TankID: item.isFuel ? item.tankInfo.TankID : null,
        CreatedAt: new Date().toISOString(),
      }

      console.log(`📦 Creating item ${index + 1}/${cartItems.value.length}:`, itemData)

      const itemResponse = await apiCall('/TransactionItems', {
        method: 'POST',
        body: JSON.stringify(itemData),
      })

      console.log(`✅ Item ${index + 1} created:`, itemResponse)
    }

    // Step 5: Update inventory levels
    console.log('📦 Updating inventory levels...')
    await updateInventoryLevels(cartItems.value, transactionId)

    // Step 6: Update cash drawer if cash payment
    if (paymentMethod.value === 'Cash' && currentCashDrawer.value) {
      console.log('💰 Updating cash drawer...')
      await updateCashDrawer(cartTotal.value)
    }

    // Step 7: Process customer credit if applicable
    if (customerType.value === 'credit' && selectedCustomer.value) {
      console.log('💳 Processing customer credit...')
      await processCustomerCredit(selectedCustomer.value, cartTotal.value)
    }

    // Success!
    await Swal.fire({
      title: 'Sale Completed!',
      html: `
        <div class="text-center">
          <div class="fs-2 fw-bold text-success mb-2">${formatCurrency(cartTotal.value)}</div>
          <div class="text-gray-600 mb-2">${paymentMethod.value} Payment</div>
          <div class="fs-8 text-gray-500">Transaction #${transactionId}</div>
        </div>
      `,
      icon: 'success',
      confirmButtonText: 'Continue',
      timer: 3000,
    })

    // Reset everything
    cartItems.value = []
    cartExpanded.value = false
    closePaymentModal()
    resetCustomer()

    // Refresh data
    await refreshSystemData()
  } catch (error) {
    console.error('❌ Sale processing failed:', error)

    await Swal.fire({
      title: 'Sale Failed',
      text: error.message || 'An error occurred while processing the sale',
      icon: 'error',
    })

    // Rollback transaction if created
    if (transactionId) {
      console.log('🔄 Rolling back transaction:', transactionId)
      try {
        await apiCall(`/Transactions/${transactionId}`, {
          method: 'PATCH',
          body: JSON.stringify({
            Status: 'Cancelled',
            Notes: `Transaction cancelled due to error: ${error.message}`,
            UpdatedAt: new Date().toISOString(),
          }),
        })
        console.log('✅ Transaction rolled back successfully')
      } catch (rollbackError) {
        console.error('❌ Failed to rollback transaction:', rollbackError)
      }
    }
  } finally {
    processing.value = false
  }
}

const updateInventoryLevels = async (cartItems, transactionId) => {
  console.log('🔄 Starting inventory updates for transaction:', transactionId)

  for (const [index, item] of cartItems.entries()) {
    try {
      console.log(`📦 Updating item ${index + 1}/${cartItems.length}:`, {
        product: item.product.Name,
        quantity: item.quantity,
        isFuel: item.isFuel,
      })

      if (item.isFuel) {
        console.log('⛽ Updating fuel systems...')

        // Update tank level
        const newTankLevel = Math.max(0, parseFloat(item.tankInfo.CurrentLevel) - item.quantity)
        console.log(
          `🛢️ Tank ${item.tankInfo.TankName}: ${item.tankInfo.CurrentLevel}L → ${newTankLevel}L`,
        )

        await apiCall(`/Tanks/${item.tankInfo.TankID}`, {
          method: 'PATCH',
          body: JSON.stringify({
            CurrentLevel: newTankLevel.toFixed(2),
            UpdatedAt: new Date().toISOString(),
          }),
        })

        // Update pump meter reading
        const newMeterReading = parseFloat(item.pumpInfo.MeterReading || 0) + item.quantity
        console.log(
          `⛽ Pump ${item.pumpInfo.PumpName}: ${item.pumpInfo.MeterReading}L → ${newMeterReading}L`,
        )

        await apiCall(`/Pumps/${item.pumpInfo.PumpID}`, {
          method: 'PATCH',
          body: JSON.stringify({
            MeterReading: newMeterReading.toFixed(2),
            UpdatedAt: new Date().toISOString(),
          }),
        })
      }

      // Update station inventory (for both fuel and non-fuel)
      console.log('📊 Updating station inventory...')
      const inventoryResponse = await apiCall(
        `/StationInventory?StationID=${currentStation.value.StationID}&ProductID=${item.product.ProductID}`,
      )

      const inventory = inventoryResponse.records?.[0]
      if (inventory) {
        const currentStock = parseFloat(inventory.CurrentStock || 0)
        const newStock = Math.max(0, currentStock - item.quantity)
        console.log(`📦 Inventory ${item.product.Name}: ${currentStock} → ${newStock}`)

        await apiCall(`/StationInventory/${inventory.InventoryID}`, {
          method: 'PATCH',
          body: JSON.stringify({
            CurrentStock: newStock.toFixed(2),
            LastUpdated: new Date().toISOString(),
          }),
        })
      } else {
        console.warn(`⚠️ No inventory record found for product ${item.product.ProductID}`)
      }

      // Create inventory history record
      console.log('📋 Creating inventory history...')
      const historyResponse = await apiCall('/InventoryHistory', {
        method: 'POST',
        body: JSON.stringify({
          StationID: currentStation.value.StationID,
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
          RecordedBy: authUser.value.id,
          CreatedAt: new Date().toISOString(),
        }),
      })

      console.log(`✅ Item ${index + 1} inventory updated successfully`)
    } catch (error) {
      console.error(
        `❌ Failed to update inventory for item ${index + 1} (${item.product.Name}):`,
        error,
      )
      throw new Error(`Inventory update failed for ${item.product.Name}: ${error.message}`)
    }
  }

  console.log('✅ All inventory updates completed successfully')
}

const updateCashDrawer = async (amount) => {
  try {
    if (!currentCashDrawer.value) return

    const currentCashSales = parseFloat(currentCashDrawer.value.CashSales || 0)
    const newCashSales = currentCashSales + amount
    const newExpectedCash = parseFloat(currentCashDrawer.value.OpeningBalance) + newCashSales

    await apiCall(`/CashDrawers/${currentCashDrawer.value.DrawerID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        CashSales: newCashSales.toFixed(2),
        ExpectedCash: newExpectedCash.toFixed(2),
      }),
    })

    // Update local reference
    currentCashDrawer.value.CashSales = newCashSales.toFixed(2)
    currentCashDrawer.value.ExpectedCash = newExpectedCash.toFixed(2)
  } catch (error) {
    console.error('❌ Failed to update cash drawer:', error)
  }
}

const processCustomerCredit = async (customer, amount) => {
  try {
    if (!customer.creditAccount) return

    const currentBalance = parseFloat(customer.creditAccount.CurrentBalance || 0)
    const creditLimit = parseFloat(customer.creditAccount.CreditLimit || 0)
    const newBalance = currentBalance + amount
    const availableCredit = creditLimit - newBalance

    await apiCall(`/CustomerCreditAccounts/${customer.creditAccount.CreditAccountID}`, {
      method: 'PATCH',
      body: JSON.stringify({
        CurrentBalance: newBalance.toFixed(2),
        AvailableCredit: availableCredit.toFixed(2),
        LastPurchaseDate: new Date().toISOString(),
        UpdatedAt: new Date().toISOString(),
      }),
    })

    // Update local customer reference
    customer.creditAccount.CurrentBalance = newBalance.toFixed(2)
    customer.creditAccount.AvailableCredit = availableCredit.toFixed(2)
  } catch (error) {
    console.error('❌ Failed to process customer credit:', error)
  }
}

const generateInvoiceNumber = () => {
  const now = new Date()
  const year = now.getFullYear().toString().slice(-2)
  const month = (now.getMonth() + 1).toString().padStart(2, '0')
  const day = now.getDate().toString().padStart(2, '0')
  const timestamp = now.getTime().toString().slice(-6)

  return `INV-${currentStation.value.StationID}-${year}${month}${day}-${timestamp}`
}

// ===== CASH DRAWER FUNCTIONS (FIXED) =====
const openCashDrawer = () => {
  showCashDrawerModal.value = true
}

const closeCashDrawer = () => {
  showCashDrawerModal.value = false
}

const getExpectedCash = () => {
  if (!currentCashDrawer.value) return 0
  return (
    parseFloat(currentCashDrawer.value.OpeningBalance || 0) +
    parseFloat(currentCashDrawer.value.CashSales || 0)
  )
}

const openNewDrawer = async () => {
  try {
    const { value: openingBalance } = await Swal.fire({
      title: 'Open Cash Drawer',
      input: 'number',
      inputLabel: 'Opening Balance (UGX)',
      inputValue: 100000,
      inputValidator: (value) => {
        if (!value || value < 0) {
          return 'Please enter a valid opening balance'
        }
      },
    })

    if (openingBalance) {
      const drawerData = {
        StationID: currentStation.value.StationID,
        ShiftDate: new Date().toISOString().split('T')[0],
        ShiftType: getShiftType(),
        AttendantID: authUser.value.id,
        OpeningBalance: parseFloat(openingBalance).toFixed(2),
        ClosingBalance: '0.00',
        ExpectedCash: parseFloat(openingBalance).toFixed(2),
        ActualCash: '0.00',
        Variance: '0.00',
        CashSales: '0.00',
        CashPayouts: '0.00',
        Status: 'Open',
        OpenedBy: authUser.value.id,
        OpenedAt: new Date().toISOString(),
        CreatedAt: new Date().toISOString(),
      }

      const response = await apiCall('/CashDrawers', {
        method: 'POST',
        body: JSON.stringify(drawerData),
      })

      // TrailBase returns new record IDs in 'ids' array
      const drawerId = response.ids?.[0] || response.DrawerID || response.id

      console.log('🔍 Cash drawer response:', response)
      console.log('🔍 Extracted drawer ID:', drawerId)

      if (!drawerId) {
        console.error('❌ Failed to extract drawer ID from response:', response)
        throw new Error('Failed to create cash drawer - no ID returned from server')
      }

      currentCashDrawer.value = {
        ...drawerData,
        DrawerID: drawerId,
      }

      await Swal.fire({
        title: 'Cash Drawer Opened',
        text: `Opening balance: ${formatCurrency(openingBalance)}`,
        icon: 'success',
      })
    }
  } catch (error) {
    console.error('❌ Failed to open cash drawer:', error)
    await Swal.fire({
      title: 'Error',
      text: 'Failed to open cash drawer',
      icon: 'error',
    })
  }
}

const closeDrawer = async () => {
  try {
    const { value: actualCash } = await Swal.fire({
      title: 'Close Cash Drawer',
      input: 'number',
      inputLabel: 'Actual Cash Count (UGX)',
      inputValue: getExpectedCash(),
      inputValidator: (value) => {
        if (!value || value < 0) {
          return 'Please enter the actual cash count'
        }
      },
    })

    if (actualCash) {
      const expectedCash = getExpectedCash()
      const variance = parseFloat(actualCash) - expectedCash

      await apiCall(`/CashDrawers/${currentCashDrawer.value.DrawerID}`, {
        method: 'PATCH',
        body: JSON.stringify({
          ClosingBalance: parseFloat(actualCash).toFixed(2),
          ActualCash: parseFloat(actualCash).toFixed(2),
          Variance: variance.toFixed(2),
          Status: 'Closed',
          ClosedBy: authUser.value.id,
          ClosedAt: new Date().toISOString(),
        }),
      })

      currentCashDrawer.value.Status = 'Closed'

      await Swal.fire({
        title: 'Cash Drawer Closed',
        html: `
          <div>Expected: ${formatCurrency(expectedCash)}</div>
          <div>Actual: ${formatCurrency(actualCash)}</div>
          <div>Variance: ${formatCurrency(variance)}</div>
        `,
        icon: variance === 0 ? 'success' : 'warning',
      })
    }
  } catch (error) {
    console.error('❌ Failed to close cash drawer:', error)
    await Swal.fire({
      title: 'Error',
      text: 'Failed to close cash drawer',
      icon: 'error',
    })
  }
}

const reconcileDrawer = async () => {
  await Swal.fire({
    title: 'Cash Reconciliation',
    text: 'Reconciliation feature coming soon',
    icon: 'info',
  })
}

const getShiftType = () => {
  const hour = new Date().getHours()
  if (hour >= 6 && hour < 14) return 'Morning'
  if (hour >= 14 && hour < 22) return 'Afternoon'
  return 'Night'
}

// ===== UTILITY FUNCTIONS =====
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

const formatVolume = (volume) => {
  const num = parseFloat(volume) || 0
  if (num >= 1000) return `${(num / 1000).toFixed(1)}kL`
  return `${num.toFixed(0)}L`
}

const formatQuantity = (quantity) => {
  const num = parseFloat(quantity) || 0
  if (num >= 1000) return `${(num / 1000).toFixed(1)}k`
  return `${num.toFixed(0)}`
}

// ===== SYSTEM REFRESH =====
const refreshSystemData = async () => {
  try {
    systemLoading.value = true

    await Swal.fire({
      title: 'Refreshing...',
      text: 'Updating system data',
      icon: 'info',
      toast: true,
      position: 'top-end',
      timer: 1000,
      showConfirmButton: false,
    })

    await Promise.all([
      loadProducts(),
      loadTanksAndPumps(),
      loadStationInventory(),
      loadTodayStats(),
      loadCurrentCashDrawer(),
    ])

    await Swal.fire({
      title: 'Data Refreshed',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    console.error('❌ Data refresh failed:', error)
    await Swal.fire({
      title: 'Refresh Failed',
      text: 'Could not refresh system data',
      icon: 'error',
    })
  } finally {
    systemLoading.value = false
  }
}

// ===== INITIALIZATION =====
const initializePOS = async () => {
  try {
    systemLoading.value = true

    // Load authentication data
    if (!loadAuthData()) {
      throw new Error('Authentication failed')
    }

    // Load all system data
    await Promise.all([
      loadProducts(),
      loadTanksAndPumps(),
      loadStationInventory(),
      loadTodayStats(),
      loadCurrentCashDrawer(),
    ])

    await Swal.fire({
      title: 'POS System Ready',
      text: `Welcome ${authUser.value.name}! Connected to ${currentStation.value.StationName}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    console.log('✅ POS System initialized successfully')
  } catch (error) {
    console.error('❌ POS initialization failed:', error)

    await Swal.fire({
      title: 'Initialization Failed',
      text: error.message || 'Unable to initialize POS system',
      icon: 'error',
      confirmButtonText: 'Login Again',
    })

    // Redirect to login
    window.location.href = '/login'
  } finally {
    systemLoading.value = false
  }
}

// ===== LIFECYCLE =====
onMounted(async () => {
  console.log('🚀 Bulletproof Fuel Dispensing POS System Loading...')
  await initializePOS()
})
</script>

<style scoped>
/* iOS-style smooth scrolling */
* {
  -webkit-overflow-scrolling: touch;
  scroll-behavior: smooth;
}

/* Smooth transitions */
.btn,
.card,
.form-control {
  transition: all 0.2s ease-in-out;
}

/* Touch feedback */
.cursor-pointer:active {
  transform: scale(0.98);
}

.btn:active {
  transform: scale(0.95);
}

/* Card hover effects */
.hover-elevate-up:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
}

/* Gradient backgrounds */
.bg-gradient-primary {
  background: linear-gradient(135deg, #3699ff 0%, #1bc5bd 100%);
}

.bg-gradient-success {
  background: linear-gradient(135deg, #1bc5bd 0%, #50cd89 100%);
}

/* Touch-friendly sizes */
.btn {
  min-height: 44px;
}

.form-control {
  min-height: 44px;
}

/* Badge styling */
.badge-circle {
  border-radius: 50%;
}

/* iOS-style separators */
.separator {
  border-bottom: 1px solid #e9ecef;
}

/* Modal backdrop blur */
.modal {
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

/* Progress bar styling */
.progress {
  background-color: rgba(0, 0, 0, 0.1);
  border-radius: 4px;
}

.progress-bar {
  border-radius: 4px;
}

/* Utility classes */
.max-h-250px {
  max-height: 250px;
}

.w-25px {
  width: 25px;
}
.h-25px {
  height: 25px;
}
.w-35px {
  width: 35px;
}
.h-35px {
  height: 35px;
}
.h-60px {
  height: 60px;
}
.h-80px {
  height: 80px;
}
.h-100px {
  height: 100px;
}

/* Z-index management */
.z-1 {
  z-index: 1;
}

/* Custom hover states */
.hover-bg-light:hover {
  background-color: #f8f9fa !important;
}

/* Loading animation enhancement */
.spinner-border {
  animation: spinner-border 0.75s linear infinite;
}

/* Alert styling */
.alert {
  border-radius: 8px;
  border: 1px solid;
}

/* Responsive text sizing */
@media (max-width: 768px) {
  .fs-3x {
    font-size: 2.5rem !important;
  }
  .fs-2x {
    font-size: 2rem !important;
  }
}
</style>

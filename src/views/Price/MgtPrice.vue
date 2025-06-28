<template>
  <div class="d-flex flex-column gap-5">
    <!--begin::Toolbar-->
    <div class="toolbar mb-5 mb-lg-7">
      <div class="container-xxl d-flex flex-stack flex-wrap">
        <div class="page-title d-flex flex-column me-3">
          <h1 class="d-flex text-dark fw-bold my-1 fs-3">Pricing Management</h1>
          <ul class="breadcrumb breadcrumb-dot fw-semibold text-gray-600 fs-7">
            <li class="breadcrumb-item text-gray-600">Management</li>
            <li class="breadcrumb-item text-gray-600">Products</li>
            <li class="breadcrumb-item text-gray-500">Pricing</li>
          </ul>
        </div>
        <div class="d-flex align-items-center gap-2">
          <button @click="refreshData" :disabled="loading" class="btn btn-sm btn-light-primary">
            <i class="ki-duotone ki-arrows-loop fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            {{ loading ? 'Loading...' : 'Refresh' }}
          </button>
          <button @click="openBulkPricingModal" class="btn btn-sm btn-primary">
            <i class="ki-duotone ki-price-tag fs-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            Bulk Pricing
          </button>
        </div>
      </div>
    </div>
    <!--end::Toolbar-->

    <!--begin::Analytics Cards-->
    <div class="row g-5 g-xl-8">
      <!--begin::Revenue Card-->
      <div class="col-xl-3">
        <div
          class="card card-xl-stretch mb-xl-8"
          style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)"
        >
          <div class="card-body text-center">
            <i class="ki-duotone ki-dollar fs-3x text-white mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <div class="text-white fw-bold fs-2hx">{{ formatCurrency(totalRevenue) }}</div>
            <div class="text-white opacity-75 fw-semibold fs-7">Total Revenue</div>
          </div>
        </div>
      </div>
      <!--end::Revenue Card-->

      <!--begin::Products Card-->
      <div class="col-xl-3">
        <div
          class="card card-xl-stretch mb-xl-8"
          style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%)"
        >
          <div class="card-body text-center">
            <i class="ki-duotone ki-package fs-3x text-white mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <div class="text-white fw-bold fs-2hx">{{ totalProducts }}</div>
            <div class="text-white opacity-75 fw-semibold fs-7">Total Products</div>
          </div>
        </div>
      </div>
      <!--end::Products Card-->

      <!--begin::Average Margin Card-->
      <div class="col-xl-3">
        <div
          class="card card-xl-stretch mb-xl-8"
          style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)"
        >
          <div class="card-body text-center">
            <i class="ki-duotone ki-chart-pie-4 fs-3x text-white mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
              <span class="path3"></span>
            </i>
            <div class="text-white fw-bold fs-2hx">{{ averageMargin.toFixed(1) }}%</div>
            <div class="text-white opacity-75 fw-semibold fs-7">Average Margin</div>
          </div>
        </div>
      </div>
      <!--end::Average Margin Card-->

      <!--begin::Tax Rate Card-->
      <div class="col-xl-3">
        <div
          class="card card-xl-stretch mb-xl-8"
          style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)"
        >
          <div class="card-body text-center">
            <i class="ki-duotone ki-percentage fs-3x text-white mb-3">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <div class="text-white fw-bold fs-2hx">{{ averageTaxRate.toFixed(1) }}%</div>
            <div class="text-white opacity-75 fw-semibold fs-7">Average Tax Rate</div>
          </div>
        </div>
      </div>
      <!--end::Tax Rate Card-->
    </div>
    <!--end::Analytics Cards-->

    <!--begin::Charts Row-->
    <div class="row g-5 g-xl-8">
      <!--begin::Revenue Chart-->
      <div class="col-xl-6">
        <div class="card card-xl-stretch mb-xl-8">
          <div class="card-header border-0 pt-5">
            <h3 class="card-title align-items-start flex-column">
              <span class="card-label fw-bold fs-3 mb-1">Revenue by Category</span>
              <span class="text-muted fw-semibold fs-7">Current month performance</span>
            </h3>
          </div>
          <div class="card-body">
            <canvas ref="revenueChart" style="height: 300px"></canvas>
          </div>
        </div>
      </div>
      <!--end::Revenue Chart-->

      <!--begin::Margin Chart-->
      <div class="col-xl-6">
        <div class="card card-xl-stretch mb-xl-8">
          <div class="card-header border-0 pt-5">
            <h3 class="card-title align-items-start flex-column">
              <span class="card-label fw-bold fs-3 mb-1">Profit Margins</span>
              <span class="text-muted fw-semibold fs-7">By product category</span>
            </h3>
          </div>
          <div class="card-body">
            <canvas ref="marginChart" style="height: 300px"></canvas>
          </div>
        </div>
      </div>
      <!--end::Margin Chart-->
    </div>
    <!--end::Charts Row-->

    <!--begin::Products Table-->
    <div class="card">
      <!--begin::Card header-->
      <div class="card-header border-0 pt-6">
        <div class="card-title">
          <div class="d-flex align-items-center position-relative my-1">
            <i class="ki-duotone ki-magnifier fs-3 position-absolute ms-5">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <input
              type="text"
              v-model="searchTerm"
              class="form-control form-control-solid w-250px ps-13"
              placeholder="Search products..."
            />
          </div>
        </div>
        <div class="card-toolbar">
          <div class="d-flex justify-content-end align-items-center gap-3">
            <!--begin::Filter-->
            <div class="d-flex align-items-center gap-2">
              <select v-model="selectedCategory" class="form-select form-select-solid w-150px">
                <option value="">All Categories</option>
                <option v-for="category in productCategories" :key="category" :value="category">
                  {{ category }}
                </option>
              </select>
              <select v-model="selectedStatus" class="form-select form-select-solid w-150px">
                <option value="">All Status</option>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
              </select>
            </div>
            <!--end::Filter-->
          </div>
        </div>
      </div>
      <!--end::Card header-->

      <!--begin::Card body-->
      <div class="card-body py-4">
        <!--begin::Mobile View-->
        <div class="d-block d-lg-none">
          <div
            v-for="product in paginatedProducts"
            :key="product.ProductID"
            class="card border mb-3"
          >
            <div class="card-body p-4">
              <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                  <h6 class="fw-bold text-dark mb-1">{{ product.Name }}</h6>
                  <span class="badge" :class="getCategoryBadgeClass(product.ProductType)">
                    {{ product.ProductType }}
                  </span>
                </div>
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
                  <div class="dropdown-menu menu menu-sub menu-sub-dropdown w-200px">
                    <div class="menu-item px-3">
                      <a @click="editProduct(product)" class="menu-link px-3">
                        <i class="ki-duotone ki-pencil fs-6 me-2">
                          <span class="path1"></span>
                          <span class="path2"></span> </i
                        >Edit Pricing
                      </a>
                    </div>
                    <div class="menu-item px-3">
                      <a @click="viewProductDetails(product)" class="menu-link px-3">
                        <i class="ki-duotone ki-eye fs-6 me-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span> </i
                        >View Details
                      </a>
                    </div>
                    <div class="menu-item px-3">
                      <a @click="viewPriceHistory(product)" class="menu-link px-3">
                        <i class="ki-duotone ki-chart-line fs-6 me-2">
                          <span class="path1"></span>
                          <span class="path2"></span>
                          <span class="path3"></span> </i
                        >Price History
                      </a>
                    </div>
                  </div>
                </div>
              </div>

              <div class="row g-2 mb-3">
                <div class="col-6">
                  <div class="text-gray-600 fs-8">Unit Price</div>
                  <div class="fw-bold text-dark">{{ formatCurrency(product.UnitPrice) }}</div>
                </div>
                <div class="col-6">
                  <div class="text-gray-600 fs-8">Selling Price</div>
                  <div class="fw-bold text-primary">{{ formatCurrency(product.SellingPrice) }}</div>
                </div>
                <div class="col-6">
                  <div class="text-gray-600 fs-8">Margin</div>
                  <div :class="getMarginClass(calculateMargin(product))">
                    {{ calculateMargin(product).toFixed(1) }}%
                  </div>
                </div>
                <div class="col-6">
                  <div class="text-gray-600 fs-8">Tax Rate</div>
                  <div class="fw-bold text-info">{{ product.TaxRate }}%</div>
                </div>
              </div>

              <div class="d-flex justify-content-between align-items-center">
                <span :class="getStatusClass(product.Status)">{{ product.Status }}</span>
                <button @click="editProduct(product)" class="btn btn-sm btn-primary">
                  <i class="ki-duotone ki-pencil fs-4">
                    <span class="path1"></span>
                    <span class="path2"></span> </i
                  >Edit
                </button>
              </div>
            </div>
          </div>
        </div>
        <!--end::Mobile View-->

        <!--begin::Desktop Table-->
        <div class="d-none d-lg-block">
          <div class="table-responsive">
            <table class="table align-middle table-row-dashed fs-6 gy-5">
              <thead>
                <tr class="text-start text-muted fw-bold fs-7 text-uppercase gs-0">
                  <th class="min-w-200px">Product</th>
                  <th class="min-w-100px text-end">Unit Price</th>
                  <th class="min-w-100px text-end">Selling Price</th>
                  <th class="min-w-100px text-end">Margin</th>
                  <th class="min-w-100px text-end">Tax Rate</th>
                  <th class="min-w-100px text-center">Status</th>
                  <th class="text-end min-w-100px">Actions</th>
                </tr>
              </thead>
              <tbody class="text-gray-600 fw-semibold">
                <tr v-for="product in paginatedProducts" :key="product.ProductID">
                  <td>
                    <div class="d-flex align-items-center">
                      <div class="symbol symbol-50px me-5">
                        <span
                          class="symbol-label"
                          :class="getCategoryBadgeClass(product.ProductType)"
                        >
                          <i :class="getProductIcon(product.ProductType)">
                            <span class="path1"></span>
                            <span class="path2"></span>
                          </i>
                        </span>
                      </div>
                      <div class="d-flex justify-content-start flex-column">
                        <span class="text-dark fw-bold text-hover-primary fs-6">{{
                          product.Name
                        }}</span>
                        <span class="text-muted fw-semibold text-muted d-block fs-7">{{
                          product.ProductType
                        }}</span>
                      </div>
                    </div>
                  </td>
                  <td class="text-end">
                    <span class="fw-bold">{{ formatCurrency(product.UnitPrice) }}</span>
                  </td>
                  <td class="text-end">
                    <span class="text-primary fw-bold">{{
                      formatCurrency(product.SellingPrice)
                    }}</span>
                  </td>
                  <td class="text-end">
                    <span :class="getMarginClass(calculateMargin(product))">
                      {{ calculateMargin(product).toFixed(1) }}%
                    </span>
                  </td>
                  <td class="text-end">
                    <span class="badge badge-light-info">{{ product.TaxRate }}%</span>
                  </td>
                  <td class="text-center">
                    <span :class="getStatusClass(product.Status)">{{ product.Status }}</span>
                  </td>
                  <td class="text-end">
                    <div class="dropdown">
                      <button
                        class="btn btn-light btn-active-light-primary btn-sm"
                        data-bs-toggle="dropdown"
                      >
                        Actions
                        <i class="ki-duotone ki-down fs-5 m-0">
                          <span class="path1"></span>
                          <span class="path2"></span>
                        </i>
                      </button>
                      <div
                        class="dropdown-menu menu menu-sub menu-sub-dropdown menu-column menu-rounded menu-gray-600 menu-state-bg-light-primary fw-semibold fs-7 w-200px py-4"
                      >
                        <div class="menu-item px-3">
                          <a @click="editProduct(product)" class="menu-link px-3">
                            <i class="ki-duotone ki-pencil fs-6 me-2">
                              <span class="path1"></span>
                              <span class="path2"></span> </i
                            >Edit Pricing
                          </a>
                        </div>
                        <div class="menu-item px-3">
                          <a @click="viewProductDetails(product)" class="menu-link px-3">
                            <i class="ki-duotone ki-eye fs-6 me-2">
                              <span class="path1"></span>
                              <span class="path2"></span>
                              <span class="path3"></span> </i
                            >View Details
                          </a>
                        </div>
                        <div class="menu-item px-3">
                          <a @click="viewPriceHistory(product)" class="menu-link px-3">
                            <i class="ki-duotone ki-chart-line fs-6 me-2">
                              <span class="path1"></span>
                              <span class="path2"></span>
                              <span class="path3"></span> </i
                            >Price History
                          </a>
                        </div>
                        <div class="separator my-2"></div>
                        <div class="menu-item px-3">
                          <a @click="duplicateProduct(product)" class="menu-link px-3">
                            <i class="ki-duotone ki-copy fs-6 me-2">
                              <span class="path1"></span>
                              <span class="path2"></span> </i
                            >Duplicate
                          </a>
                        </div>
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <!--end::Desktop Table-->

        <!--begin::Pagination-->
        <div class="d-flex flex-stack flex-wrap pt-10">
          <div class="fs-6 fw-semibold text-gray-700">
            Showing {{ (currentPage - 1) * itemsPerPage + 1 }} to
            {{ Math.min(currentPage * itemsPerPage, filteredProducts.length) }} of
            {{ filteredProducts.length }} entries
          </div>
          <ul class="pagination">
            <li class="page-item" :class="{ disabled: currentPage === 1 }">
              <a @click="currentPage = Math.max(1, currentPage - 1)" class="page-link">
                <i class="previous"></i>
              </a>
            </li>
            <li
              v-for="page in visiblePages"
              :key="page"
              class="page-item"
              :class="{ active: page === currentPage }"
            >
              <a @click="currentPage = page" class="page-link">{{ page }}</a>
            </li>
            <li class="page-item" :class="{ disabled: currentPage === totalPages }">
              <a @click="currentPage = Math.min(totalPages, currentPage + 1)" class="page-link">
                <i class="next"></i>
              </a>
            </li>
          </ul>
        </div>
        <!--end::Pagination-->
      </div>
      <!--end::Card body-->
    </div>
    <!--end::Products Table-->

    <!--begin::Edit Product Modal-->
    <div class="modal fade" id="kt_modal_edit_product" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered mw-650px">
        <div class="modal-content">
          <div class="modal-header">
            <h2 class="fw-bold">Edit Product Pricing</h2>
            <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
          </div>
          <div class="modal-body py-10 px-lg-17">
            <div class="scroll-y me-n7 pe-7" style="max-height: 400px">
              <!--begin::Product Info-->
              <div class="fv-row mb-7">
                <label class="fw-semibold fs-6 mb-2">Product Name</label>
                <input
                  type="text"
                  v-model="editForm.Name"
                  class="form-control form-control-solid mb-3 mb-lg-0"
                  readonly
                />
              </div>
              <!--end::Product Info-->

              <!--begin::Current Pricing-->
              <div class="row g-5 mb-7">
                <div class="col-6">
                  <label class="required fw-semibold fs-6 mb-2">Unit Price</label>
                  <input
                    type="number"
                    v-model.number="editForm.UnitPrice"
                    class="form-control form-control-solid"
                    :class="{ 'is-invalid': formErrors.UnitPrice }"
                    step="0.01"
                    min="0"
                    required
                  />
                  <div v-if="formErrors.UnitPrice" class="invalid-feedback">
                    {{ formErrors.UnitPrice }}
                  </div>
                </div>
                <div class="col-6">
                  <label class="required fw-semibold fs-6 mb-2">Selling Price</label>
                  <input
                    type="number"
                    v-model.number="editForm.SellingPrice"
                    class="form-control form-control-solid"
                    :class="{ 'is-invalid': formErrors.SellingPrice }"
                    step="0.01"
                    min="0"
                    required
                  />
                  <div v-if="formErrors.SellingPrice" class="invalid-feedback">
                    {{ formErrors.SellingPrice }}
                  </div>
                </div>
              </div>
              <!--end::Current Pricing-->

              <!--begin::Additional Fields-->
              <div class="row g-5 mb-7">
                <div class="col-6">
                  <label class="fw-semibold fs-6 mb-2">Tax Rate (%)</label>
                  <input
                    type="number"
                    v-model.number="editForm.TaxRate"
                    class="form-control form-control-solid"
                    step="0.01"
                    min="0"
                    max="100"
                  />
                </div>
                <div class="col-6">
                  <label class="fw-semibold fs-6 mb-2">Reorder Level</label>
                  <input
                    type="number"
                    v-model.number="editForm.ReorderLevel"
                    class="form-control form-control-solid"
                    min="0"
                  />
                </div>
              </div>
              <!--end::Additional Fields-->

              <!--begin::Status-->
              <div class="fv-row mb-7">
                <label class="fw-semibold fs-6 mb-2">Status</label>
                <select v-model="editForm.Status" class="form-select form-select-solid">
                  <option value="Active">Active</option>
                  <option value="Inactive">Inactive</option>
                </select>
              </div>
              <!--end::Status-->

              <!--begin::Margin Preview-->
              <div class="alert alert-primary d-flex align-items-center p-5">
                <i class="ki-duotone ki-shield-tick fs-2hx text-primary me-4">
                  <span class="path1"></span>
                  <span class="path2"></span>
                  <span class="path3"></span>
                </i>
                <div class="d-flex flex-column">
                  <h4 class="mb-1 text-dark">Profit Margin Preview</h4>
                  <span class="fs-6"
                    >Calculated margin:
                    <strong :class="getMarginClass(calculatedMargin)"
                      >{{ calculatedMargin.toFixed(2) }}%</strong
                    ></span
                  >
                </div>
              </div>
              <!--end::Margin Preview-->
            </div>
          </div>
          <div class="modal-footer flex-center">
            <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">Cancel</button>
            <button @click="saveProduct" class="btn btn-primary" :disabled="saving">
              <span v-if="saving" class="spinner-border spinner-border-sm me-2"></span>
              {{ saving ? 'Saving...' : 'Save Changes' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <!--end::Edit Product Modal-->

    <!--begin::Product Details Modal-->
    <div class="modal fade" id="kt_modal_product_details" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered mw-750px">
        <div class="modal-content">
          <div class="modal-header">
            <h2 class="fw-bold">Product Details</h2>
            <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
          </div>
          <div class="modal-body">
            <div v-if="selectedProduct" class="d-flex flex-column gap-5">
              <!--begin::Product Header-->
              <div class="d-flex align-items-center">
                <div class="symbol symbol-75px me-5">
                  <span
                    class="symbol-label"
                    :class="getCategoryBadgeClass(selectedProduct.ProductType)"
                  >
                    <i :class="getProductIcon(selectedProduct.ProductType)">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                  </span>
                </div>
                <div class="flex-grow-1">
                  <h3 class="text-dark fw-bold mb-1">{{ selectedProduct.Name }}</h3>
                  <div class="text-muted fw-semibold">
                    {{ selectedProduct.Description || 'No description available' }}
                  </div>
                </div>
                <span :class="getStatusClass(selectedProduct.Status)">{{
                  selectedProduct.Status
                }}</span>
              </div>
              <!--end::Product Header-->

              <!--begin::Pricing Info-->
              <div class="card bg-light-primary">
                <div class="card-body p-5">
                  <div class="row g-5">
                    <div class="col-6 col-md-3">
                      <div class="text-gray-600 fs-7">Unit Price</div>
                      <div class="fw-bold fs-4">
                        {{ formatCurrency(selectedProduct.UnitPrice) }}
                      </div>
                    </div>
                    <div class="col-6 col-md-3">
                      <div class="text-gray-600 fs-7">Selling Price</div>
                      <div class="fw-bold fs-4 text-primary">
                        {{ formatCurrency(selectedProduct.SellingPrice) }}
                      </div>
                    </div>
                    <div class="col-6 col-md-3">
                      <div class="text-gray-600 fs-7">Profit Margin</div>
                      <div
                        class="fw-bold fs-4"
                        :class="getMarginTextClass(calculateMargin(selectedProduct))"
                      >
                        {{ calculateMargin(selectedProduct).toFixed(1) }}%
                      </div>
                    </div>
                    <div class="col-6 col-md-3">
                      <div class="text-gray-600 fs-7">Tax Rate</div>
                      <div class="fw-bold fs-4 text-info">{{ selectedProduct.TaxRate }}%</div>
                    </div>
                  </div>
                </div>
              </div>
              <!--end::Pricing Info-->

              <!--begin::Additional Details-->
              <div class="row g-5">
                <div class="col-md-6">
                  <div class="card h-100">
                    <div class="card-header">
                      <h5 class="card-title">Product Information</h5>
                    </div>
                    <div class="card-body">
                      <div class="table-responsive">
                        <table class="table table-borderless">
                          <tr>
                            <td class="text-gray-600 fw-semibold">Product Type:</td>
                            <td class="text-dark fw-bold">{{ selectedProduct.ProductType }}</td>
                          </tr>
                          <tr>
                            <td class="text-gray-600 fw-semibold">Reorder Level:</td>
                            <td class="text-dark fw-bold">
                              {{ selectedProduct.ReorderLevel || 'Not set' }}
                            </td>
                          </tr>
                          <tr>
                            <td class="text-gray-600 fw-semibold">Created:</td>
                            <td class="text-dark fw-bold">
                              {{ formatDate(selectedProduct.CreatedAt) }}
                            </td>
                          </tr>
                          <tr>
                            <td class="text-gray-600 fw-semibold">Updated:</td>
                            <td class="text-dark fw-bold">
                              {{ formatDate(selectedProduct.UpdatedAt) }}
                            </td>
                          </tr>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="card h-100">
                    <div class="card-header">
                      <h5 class="card-title">Inventory Summary</h5>
                    </div>
                    <div class="card-body">
                      <div v-if="selectedProductInventory.length > 0">
                        <div
                          v-for="inventory in selectedProductInventory"
                          :key="inventory.InventoryID"
                          class="d-flex justify-content-between align-items-center mb-3"
                        >
                          <span class="text-gray-600">{{
                            getStationName(inventory.StationID)
                          }}</span>
                          <span class="fw-bold">{{ inventory.CurrentStock || 0 }} units</span>
                        </div>
                      </div>
                      <div v-else class="text-center text-muted">No inventory data available</div>
                    </div>
                  </div>
                </div>
              </div>
              <!--end::Additional Details-->
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
            <button
              @click="editProduct(selectedProduct)"
              class="btn btn-primary"
              data-bs-dismiss="modal"
            >
              <i class="ki-duotone ki-pencil fs-3">
                <span class="path1"></span>
                <span class="path2"></span> </i
              >Edit Pricing
            </button>
          </div>
        </div>
      </div>
    </div>
    <!--end::Product Details Modal-->

    <!--begin::Bulk Pricing Modal-->
    <div class="modal fade" id="kt_modal_bulk_pricing" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered mw-750px">
        <div class="modal-content">
          <div class="modal-header">
            <h2 class="fw-bold">Bulk Pricing Update</h2>
            <div class="btn btn-icon btn-sm btn-active-icon-primary" data-bs-dismiss="modal">
              <i class="ki-duotone ki-cross fs-1">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
          </div>
          <div class="modal-body">
            <div class="row g-5">
              <div class="col-12">
                <div
                  class="notice d-flex bg-light-warning rounded border-warning border border-dashed p-6"
                >
                  <i class="ki-duotone ki-information fs-2tx text-warning me-4">
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                  <div class="d-flex flex-stack flex-grow-1">
                    <div class="fw-semibold">
                      <h4 class="text-gray-900 fw-bold">Bulk Pricing Update</h4>
                      <div class="fs-6 text-gray-700">
                        Apply percentage changes to multiple products at once. Changes will require
                        approval for amounts above your authorization limit.
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-6">
                <label class="required fw-semibold fs-6 mb-2">Product Category</label>
                <select v-model="bulkForm.category" class="form-select form-select-solid">
                  <option value="">Select Category</option>
                  <option v-for="category in productCategories" :key="category" :value="category">
                    {{ category }}
                  </option>
                </select>
              </div>

              <div class="col-md-6">
                <label class="required fw-semibold fs-6 mb-2">Adjustment Type</label>
                <select v-model="bulkForm.adjustmentType" class="form-select form-select-solid">
                  <option value="percentage">Percentage Change</option>
                  <option value="fixed">Fixed Amount</option>
                </select>
              </div>

              <div class="col-md-6">
                <label class="required fw-semibold fs-6 mb-2">
                  {{ bulkForm.adjustmentType === 'percentage' ? 'Percentage (%)' : 'Amount (UGX)' }}
                </label>
                <input
                  type="number"
                  v-model.number="bulkForm.adjustmentValue"
                  class="form-control form-control-solid"
                  :step="bulkForm.adjustmentType === 'percentage' ? '0.01' : '1'"
                  required
                />
              </div>

              <div class="col-md-6">
                <label class="required fw-semibold fs-6 mb-2">Price Field</label>
                <select v-model="bulkForm.priceField" class="form-select form-select-solid">
                  <option value="SellingPrice">Selling Price</option>
                  <option value="UnitPrice">Unit Price</option>
                </select>
              </div>

              <div class="col-12">
                <label class="fw-semibold fs-6 mb-2">Justification</label>
                <textarea
                  v-model="bulkForm.justification"
                  class="form-control form-control-solid"
                  rows="3"
                  placeholder="Provide justification for this pricing change..."
                ></textarea>
              </div>

              <!--begin::Preview-->
              <div v-if="bulkPreview.length > 0" class="col-12">
                <div class="card bg-light-info">
                  <div class="card-header">
                    <h5 class="card-title">Preview Changes ({{ bulkPreview.length }} products)</h5>
                  </div>
                  <div class="card-body" style="max-height: 200px; overflow-y: auto">
                    <div
                      v-for="preview in bulkPreview.slice(0, 5)"
                      :key="preview.ProductID"
                      class="d-flex justify-content-between align-items-center mb-2"
                    >
                      <span class="fw-bold">{{ preview.Name }}</span>
                      <span>
                        {{ formatCurrency(preview.currentPrice) }} →
                        <span class="text-primary fw-bold">{{
                          formatCurrency(preview.newPrice)
                        }}</span>
                      </span>
                    </div>
                    <div v-if="bulkPreview.length > 5" class="text-muted text-center">
                      ... and {{ bulkPreview.length - 5 }} more products
                    </div>
                  </div>
                </div>
              </div>
              <!--end::Preview-->
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light me-3" data-bs-dismiss="modal">Cancel</button>
            <button @click="generateBulkPreview" type="button" class="btn btn-info me-3">
              Preview Changes
            </button>
            <button
              @click="applyBulkPricing"
              class="btn btn-primary"
              :disabled="bulkSaving || bulkPreview.length === 0"
            >
              <span v-if="bulkSaving" class="spinner-border spinner-border-sm me-2"></span>
              {{ bulkSaving ? 'Applying...' : 'Apply Changes' }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <!--end::Bulk Pricing Modal-->
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import Swal from 'sweetalert2'

// Reactive data
const products = ref([])
const stationInventory = ref([])
const stations = ref([])
const loading = ref(false)
const saving = ref(false)
const bulkSaving = ref(false)
const searchTerm = ref('')
const selectedCategory = ref('')
const selectedStatus = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(10)
const selectedProduct = ref(null)
const selectedProductInventory = ref([])

// Charts
const revenueChart = ref(null)
const marginChart = ref(null)
let revenueChartInstance = null
let marginChartInstance = null

// Forms
const editForm = ref({
  ProductID: null,
  Name: '',
  UnitPrice: 0,
  SellingPrice: 0,
  TaxRate: 0,
  ReorderLevel: 0,
  Status: 'Active',
})

const bulkForm = ref({
  category: '',
  adjustmentType: 'percentage',
  adjustmentValue: 0,
  priceField: 'SellingPrice',
  justification: '',
})

const bulkPreview = ref([])
const formErrors = ref({})

// API Functions
const getAuthHeaders = () => {
  try {
    const token = localStorage.getItem('jwt')
    return {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
    }
  } catch (error) {
    console.warn('Failed to get JWT token:', error)
    return {
      'Content-Type': 'application/json',
    }
  }
}

const apiRequest = async (endpoint, options = {}) => {
  try {
    const response = await fetch(
      `https://backend.cloudfuelstationmis.com/api/records/v1${endpoint}`,
      {
        headers: getAuthHeaders(),
        ...options,
      },
    )

    if (!response.ok) {
      let errorMessage = `HTTP ${response.status}: ${response.statusText}`
      try {
        const errorData = await response.json()
        if (errorData.message) {
          errorMessage = errorData.message
        }
      } catch (e) {
        // If error response is not JSON, use status text
      }
      throw new Error(errorMessage)
    }

    // Check if response has content
    const contentLength = response.headers.get('Content-Length')
    const contentType = response.headers.get('Content-Type')

    if (contentLength === '0' || !contentType?.includes('application/json')) {
      return {} // Return empty object for successful requests with no JSON content
    }

    const text = await response.text()
    if (!text) {
      return {} // Return empty object if no content
    }

    try {
      return JSON.parse(text)
    } catch (jsonError) {
      console.warn('Response is not valid JSON:', text)
      return {} // Return empty object if JSON parsing fails
    }
  } catch (error) {
    console.error('API Request failed:', error)
    throw error
  }
}

// Data fetching
const fetchProducts = async () => {
  try {
    const data = await apiRequest('/Products')
    const recordsArray = data?.records || data || []

    if (!Array.isArray(recordsArray)) {
      console.warn('Unexpected response format:', data)
      products.value = []
      return
    }

    products.value = recordsArray.map((product) => ({
      ...product,
      UnitPrice: parseFloat(product.UnitPrice) || 0,
      SellingPrice: parseFloat(product.SellingPrice) || parseFloat(product.UnitPrice) || 0,
      TaxRate: parseFloat(product.TaxRate) || 0,
      ReorderLevel: parseFloat(product.ReorderLevel) || 0,
    }))
  } catch (error) {
    console.error('Failed to fetch products:', error)
    products.value = []
    throw new Error(`Failed to fetch products: ${error.message}`)
  }
}

const fetchStationInventory = async () => {
  try {
    const data = await apiRequest('/StationInventory')
    const recordsArray = data?.records || data || []
    stationInventory.value = Array.isArray(recordsArray) ? recordsArray : []
  } catch (error) {
    console.error('Failed to fetch inventory:', error)
    stationInventory.value = []
  }
}

const fetchStations = async () => {
  try {
    const data = await apiRequest('/Stations')
    const recordsArray = data?.records || data || []
    stations.value = Array.isArray(recordsArray) ? recordsArray : []
  } catch (error) {
    console.error('Failed to fetch stations:', error)
    stations.value = []
  }
}

const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([fetchProducts(), fetchStationInventory(), fetchStations()])

    await nextTick()
    await initCharts()

    Swal.fire({
      title: 'Success!',
      text: 'Data refreshed successfully',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    loading.value = false
  }
}

// Computed properties
const totalProducts = computed(() => products.value.length)

const totalRevenue = computed(() => {
  return products.value.reduce((sum, product) => {
    const inventory = stationInventory.value.filter((inv) => inv.ProductID === product.ProductID)
    const totalStock = inventory.reduce(
      (stock, inv) => stock + (parseFloat(inv.CurrentStock) || 0),
      0,
    )
    return sum + totalStock * product.SellingPrice
  }, 0)
})

const averageMargin = computed(() => {
  if (products.value.length === 0) return 0
  const totalMargin = products.value.reduce((sum, product) => sum + calculateMargin(product), 0)
  return totalMargin / products.value.length
})

const averageTaxRate = computed(() => {
  if (products.value.length === 0) return 0
  const totalTax = products.value.reduce((sum, product) => sum + product.TaxRate, 0)
  return totalTax / products.value.length
})

const productCategories = computed(() => {
  return [...new Set(products.value.map((p) => p.ProductType))].sort()
})

const filteredProducts = computed(() => {
  return products.value.filter((product) => {
    const matchesSearch =
      !searchTerm.value ||
      product.Name.toLowerCase().includes(searchTerm.value.toLowerCase()) ||
      product.ProductType.toLowerCase().includes(searchTerm.value.toLowerCase())

    const matchesCategory =
      !selectedCategory.value || product.ProductType === selectedCategory.value
    const matchesStatus = !selectedStatus.value || product.Status === selectedStatus.value

    return matchesSearch && matchesCategory && matchesStatus
  })
})

const totalPages = computed(() => Math.ceil(filteredProducts.value.length / itemsPerPage.value))

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredProducts.value.slice(start, end)
})

const visiblePages = computed(() => {
  const pages = []
  const maxVisible = 5
  let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  let end = Math.min(totalPages.value, start + maxVisible - 1)

  if (end - start < maxVisible - 1) {
    start = Math.max(1, end - maxVisible + 1)
  }

  for (let i = start; i <= end; i++) {
    pages.push(i)
  }

  return pages
})

const calculatedMargin = computed(() => {
  if (!editForm.value.UnitPrice || !editForm.value.SellingPrice) return 0
  return calculateMargin(editForm.value)
})

// Utility functions
const calculateMargin = (product) => {
  const unitPrice = parseFloat(product.UnitPrice) || 0
  const sellingPrice = parseFloat(product.SellingPrice) || 0
  if (sellingPrice === 0) return 0
  return ((sellingPrice - unitPrice) / sellingPrice) * 100
}

const formatCurrency = (value) => {
  const val = parseFloat(value) || 0
  return `UGX ${val.toLocaleString('en-US', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  })}`
}

const formatDate = (dateString) => {
  if (!dateString) return 'N/A'
  try {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    })
  } catch {
    return 'Invalid Date'
  }
}

const getStatusClass = (status) => {
  return status === 'Active'
    ? 'badge badge-light-success fs-8 fw-bold'
    : 'badge badge-light-danger fs-8 fw-bold'
}

const getMarginClass = (margin) => {
  if (margin >= 20) return 'text-success fw-bold'
  if (margin >= 10) return 'text-warning fw-bold'
  return 'text-danger fw-bold'
}

const getMarginTextClass = (margin) => {
  if (margin >= 20) return 'text-success'
  if (margin >= 10) return 'text-warning'
  return 'text-danger'
}

const getCategoryBadgeClass = (category) => {
  const classes = {
    Fuel: 'bg-light-primary text-primary',
    Lubricant: 'bg-light-warning text-warning',
    Gas: 'bg-light-success text-success',
    Other: 'bg-light-info text-info',
  }
  return classes[category] || 'bg-light-secondary text-secondary'
}

const getProductIcon = (category) => {
  const icons = {
    Fuel: 'ki-duotone ki-oil-barrel fs-2',
    Lubricant: 'ki-duotone ki-drop fs-2',
    Gas: 'ki-duotone ki-gas-station fs-2',
    Other: 'ki-duotone ki-element-11 fs-2',
  }
  return icons[category] || 'ki-duotone ki-element-11 fs-2'
}

const getStationName = (stationId) => {
  const station = stations.value.find((s) => s.StationID === stationId)
  return station ? station.StationName : `Station ${stationId}`
}

// Modal functions
const editProduct = (product) => {
  editForm.value = { ...product }
  formErrors.value = {}

  try {
    const modalElement = document.getElementById('kt_modal_edit_product')
    if (modalElement && window.bootstrap?.Modal) {
      const modal = new window.bootstrap.Modal(modalElement)
      modal.show()
    } else {
      console.error('Modal element or Bootstrap not found')
    }
  } catch (error) {
    console.error('Failed to open edit modal:', error)
  }
}

const viewProductDetails = async (product) => {
  selectedProduct.value = product
  selectedProductInventory.value = stationInventory.value.filter(
    (inv) => inv.ProductID === product.ProductID,
  )

  try {
    const modalElement = document.getElementById('kt_modal_product_details')
    if (modalElement && window.bootstrap?.Modal) {
      const modal = new window.bootstrap.Modal(modalElement)
      modal.show()
    } else {
      console.error('Modal element or Bootstrap not found')
    }
  } catch (error) {
    console.error('Failed to open details modal:', error)
  }
}

const viewPriceHistory = (product) => {
  Swal.fire({
    title: 'Price History',
    text: `Price history for ${product.Name} will be implemented with audit logs from the database.`,
    icon: 'info',
    confirmButtonColor: '#009EF7',
  })
}

const duplicateProduct = (product) => {
  Swal.fire({
    title: 'Duplicate Product',
    text: `Product duplication for ${product.Name} will create a new record in the Products table.`,
    icon: 'info',
    confirmButtonColor: '#009EF7',
  })
}

const openBulkPricingModal = () => {
  bulkForm.value = {
    category: '',
    adjustmentType: 'percentage',
    adjustmentValue: 0,
    priceField: 'SellingPrice',
    justification: '',
  }
  bulkPreview.value = []

  try {
    const modalElement = document.getElementById('kt_modal_bulk_pricing')
    if (modalElement && window.bootstrap?.Modal) {
      const modal = new window.bootstrap.Modal(modalElement)
      modal.show()
    } else {
      console.error('Modal element or Bootstrap not found')
    }
  } catch (error) {
    console.error('Failed to open bulk pricing modal:', error)
  }
}

const generateBulkPreview = () => {
  if (!bulkForm.value.category || !bulkForm.value.adjustmentValue) {
    Swal.fire({
      title: 'Missing Information',
      text: 'Please select a category and enter an adjustment value.',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  const categoryProducts = products.value.filter((p) => p.ProductType === bulkForm.value.category)

  bulkPreview.value = categoryProducts.map((product) => {
    const currentPrice = product[bulkForm.value.priceField]
    let newPrice

    if (bulkForm.value.adjustmentType === 'percentage') {
      newPrice = currentPrice * (1 + bulkForm.value.adjustmentValue / 100)
    } else {
      newPrice = currentPrice + bulkForm.value.adjustmentValue
    }

    return {
      ...product,
      currentPrice,
      newPrice: Math.max(0, newPrice),
    }
  })
}

const applyBulkPricing = async () => {
  if (bulkPreview.value.length === 0) {
    Swal.fire({
      title: 'No Changes',
      text: 'Please generate a preview first.',
      icon: 'warning',
      confirmButtonColor: '#f1416c',
    })
    return
  }

  const result = await Swal.fire({
    title: 'Confirm Bulk Update',
    text: `This will update ${bulkPreview.value.length} products. Continue?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonColor: '#009EF7',
    cancelButtonColor: '#f1416c',
    confirmButtonText: 'Yes, update prices',
  })

  if (!result.isConfirmed) return

  bulkSaving.value = true

  try {
    let successCount = 0
    let errorCount = 0

    // Update products one by one
    for (const preview of bulkPreview.value) {
      try {
        const updateData = {
          [bulkForm.value.priceField]: preview.newPrice.toString(),
          UpdatedAt: new Date().toISOString(),
        }

        await apiRequest(`/Products/${preview.ProductID}`, {
          method: 'PATCH',
          body: JSON.stringify(updateData),
        })

        // Update local data
        const productIndex = products.value.findIndex((p) => p.ProductID === preview.ProductID)
        if (productIndex !== -1) {
          products.value[productIndex] = {
            ...products.value[productIndex],
            [bulkForm.value.priceField]: preview.newPrice,
          }
        }

        successCount++
      } catch (error) {
        console.error(`Failed to update product ${preview.ProductID}:`, error)
        errorCount++
      }
    }

    if (successCount > 0) {
      Swal.fire({
        title: 'Bulk Update Complete!',
        text: `${successCount} products updated successfully.${errorCount > 0 ? ` ${errorCount} failed.` : ''}`,
        icon: successCount > errorCount ? 'success' : 'warning',
        confirmButtonColor: '#50CD89',
      })
    } else {
      Swal.fire({
        title: 'Update Failed!',
        text: 'No products were updated successfully.',
        icon: 'error',
        confirmButtonColor: '#f1416c',
      })
    }

    // Close modal
    const modal = window.bootstrap.Modal.getInstance(
      document.getElementById('kt_modal_bulk_pricing'),
    )
    if (modal) modal.hide()
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    bulkSaving.value = false
  }
}

const validateForm = () => {
  formErrors.value = {}

  if (!editForm.value.UnitPrice || editForm.value.UnitPrice <= 0) {
    formErrors.value.UnitPrice = 'Unit price must be greater than 0'
  }

  if (!editForm.value.SellingPrice || editForm.value.SellingPrice <= 0) {
    formErrors.value.SellingPrice = 'Selling price must be greater than 0'
  }

  if (editForm.value.SellingPrice < editForm.value.UnitPrice) {
    formErrors.value.SellingPrice = 'Selling price cannot be less than unit price'
  }

  return Object.keys(formErrors.value).length === 0
}

const saveProduct = async () => {
  if (!validateForm()) return

  saving.value = true

  try {
    const updateData = {
      UnitPrice: editForm.value.UnitPrice.toString(),
      SellingPrice: editForm.value.SellingPrice.toString(),
      TaxRate: editForm.value.TaxRate.toString(),
      ReorderLevel: editForm.value.ReorderLevel?.toString() || '0',
      Status: editForm.value.Status,
      UpdatedAt: new Date().toISOString(),
    }

    const response = await apiRequest(`/Products/${editForm.value.ProductID}`, {
      method: 'PATCH',
      body: JSON.stringify(updateData),
    })

    // Update local product data
    const productIndex = products.value.findIndex((p) => p.ProductID === editForm.value.ProductID)
    if (productIndex !== -1) {
      products.value[productIndex] = { ...products.value[productIndex], ...updateData }
    }

    Swal.fire({
      title: 'Success!',
      text: 'Product updated successfully.',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
    })

    // Close modal
    const modal = window.bootstrap.Modal.getInstance(
      document.getElementById('kt_modal_edit_product'),
    )
    if (modal) modal.hide()
  } catch (error) {
    Swal.fire({
      title: 'Error!',
      text: error.message,
      icon: 'error',
      confirmButtonColor: '#f1416c',
    })
  } finally {
    saving.value = false
  }
}

// Chart functions
const initCharts = async () => {
  // Wait for DOM and Chart.js
  await nextTick()

  // Load Chart.js if not available
  if (typeof window !== 'undefined' && !window.Chart) {
    try {
      await new Promise((resolve, reject) => {
        const script = document.createElement('script')
        script.src = 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js'
        script.onload = resolve
        script.onerror = reject
        document.head.appendChild(script)
      })
    } catch (error) {
      console.error('Failed to load Chart.js:', error)
      return
    }
  }

  // Destroy existing charts
  if (revenueChartInstance) {
    revenueChartInstance.destroy()
    revenueChartInstance = null
  }
  if (marginChartInstance) {
    marginChartInstance.destroy()
    marginChartInstance = null
  }

  // Wait for next tick after loading Chart.js
  await nextTick()

  if (typeof window !== 'undefined' && window.Chart && revenueChart.value && marginChart.value) {
    try {
      initRevenueChart()
      initMarginChart()
    } catch (error) {
      console.error('Error initializing charts:', error)
    }
  }
}

const initRevenueChart = () => {
  if (!revenueChart.value || !window.Chart) return

  try {
    const ctx = revenueChart.value.getContext('2d')

    // Calculate revenue by category
    const categoryRevenue = {}
    productCategories.value.forEach((category) => {
      const categoryProducts = products.value.filter((p) => p.ProductType === category)
      categoryRevenue[category] = categoryProducts.reduce((sum, product) => {
        const inventory = stationInventory.value.filter(
          (inv) => inv.ProductID === product.ProductID,
        )
        const totalStock = inventory.reduce(
          (stock, inv) => stock + (parseFloat(inv.CurrentStock) || 0),
          0,
        )
        return sum + totalStock * product.SellingPrice
      }, 0)
    })

    revenueChartInstance = new window.Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: Object.keys(categoryRevenue),
        datasets: [
          {
            data: Object.values(categoryRevenue),
            backgroundColor: ['#009EF7', '#F1416C', '#50CD89', '#FFC700', '#7239EA'],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              usePointStyle: true,
              padding: 20,
            },
          },
        },
      },
    })
  } catch (error) {
    console.error('Error creating revenue chart:', error)
  }
}

const initMarginChart = () => {
  if (!marginChart.value || !window.Chart) return

  try {
    const ctx = marginChart.value.getContext('2d')

    // Calculate average margin by category
    const categoryMargins = productCategories.value.map((category) => {
      const categoryProducts = products.value.filter((p) => p.ProductType === category)
      if (categoryProducts.length === 0) return 0

      const totalMargin = categoryProducts.reduce(
        (sum, product) => sum + calculateMargin(product),
        0,
      )
      return totalMargin / categoryProducts.length
    })

    marginChartInstance = new window.Chart(ctx, {
      type: 'bar',
      data: {
        labels: productCategories.value,
        datasets: [
          {
            label: 'Average Margin (%)',
            data: categoryMargins,
            backgroundColor: '#009EF7',
            borderColor: '#009EF7',
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false,
          },
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function (value) {
                return value + '%'
              },
            },
          },
        },
      },
    })
  } catch (error) {
    console.error('Error creating margin chart:', error)
  }
}

// Watchers
watch([searchTerm, selectedCategory, selectedStatus], () => {
  currentPage.value = 1
})

// Lifecycle
onMounted(async () => {
  await refreshData()
})
</script>

<style scoped>
.table th {
  background-color: #f9f9f9;
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.85rem;
  letter-spacing: 0.1em;
  padding: 1rem 0.75rem;
}

.chart-container {
  position: relative;
  height: 300px;
}

.symbol-label {
  display: flex;
  align-items: center;
  justify-content: center;
}

@media (max-width: 768px) {
  .modal-dialog {
    margin: 1rem;
    max-width: calc(100% - 2rem);
  }

  .toolbar .container-xxl {
    flex-direction: column;
    gap: 1rem;
  }

  .page-title {
    text-align: center;
  }
}
</style>

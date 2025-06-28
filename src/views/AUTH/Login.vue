<template>
  <!-- Full Screen Login Modal Overlay - Covers Everything -->
  <div
    v-show="showLoginModal"
    class="login-modal-overlay position-fixed top-0 start-0 w-100 h-100 d-flex flex-column"
    id="kt_login_modal"
  >
    <!-- Gradient Background -->
    <div class="position-absolute top-0 start-0 w-100 h-100 bg-gradient-primary opacity-90"></div>
    <div class="position-absolute top-0 start-0 w-100 h-100 bg-light-primary opacity-15"></div>

    <!-- Login Container -->
    <div class="d-flex flex-column flex-center flex-column-fluid position-relative">
      <!-- Main Login Card -->
      <div
        class="card card-flush shadow-lg w-100 mx-5 mx-lg-0"
        style="max-width: 500px; border-radius: 20px"
      >
        <!-- Header Section -->
        <div
          class="card-header bg-primary d-flex flex-column align-items-center py-10"
          style="border-radius: 20px 20px 0 0"
        >
          <!-- Logo Icon -->
          <div class="symbol symbol-80px mb-5">
            <div class="symbol-label bg-light-primary">
              <i class="ki-duotone ki-oil fs-1 text-primary">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
            </div>
          </div>

          <!-- Brand Text -->
          <h1 class="text-white fw-bolder fs-2x mb-2">Cloud Fuel ERP</h1>
          <p class="text-white opacity-75 fs-5 mb-0">Advanced Cloud Fuel Station Management</p>
        </div>

        <!-- Login Form Body -->
        <div class="card-body p-10">
          <!-- Welcome Message -->
          <div class="text-center mb-8">
            <h2 class="text-gray-900 fw-bolder fs-2 mb-3">Welcome Back!</h2>
            <p class="text-gray-600 fs-6">Sign in to access your dashboard</p>
          </div>

          <!-- Login Form -->
          <form @submit.prevent="handleLogin" novalidate class="form w-100">
            <!-- Email Field -->
            <div class="mb-6">
              <label class="form-label fw-semibold text-gray-900 fs-6 required"
                >Email Address</label
              >
              <div class="position-relative">
                <input
                  v-model="loginForm.email"
                  type="email"
                  class="form-control form-control-lg form-control-solid"
                  :class="{ 'is-invalid': errors.email }"
                  placeholder="Enter your email"
                  autocomplete="email"
                  required
                />
                <i
                  class="ki-duotone ki-sms position-absolute top-50 end-0 translate-middle-y me-3 fs-2 text-gray-500"
                >
                  <span class="path1"></span>
                  <span class="path2"></span>
                </i>
              </div>
              <div v-if="errors.email" class="invalid-feedback d-block">
                {{ errors.email }}
              </div>
            </div>

            <!-- Password Field -->
            <div class="mb-6">
              <label class="form-label fw-semibold text-gray-900 fs-6 required">Password</label>
              <div class="position-relative">
                <input
                  v-model="loginForm.password"
                  :type="showPassword ? 'text' : 'password'"
                  class="form-control form-control-lg form-control-solid"
                  :class="{ 'is-invalid': errors.password }"
                  placeholder="Enter your password"
                  autocomplete="current-password"
                  required
                />
                <button
                  type="button"
                  @click="togglePassword"
                  class="btn btn-sm btn-icon position-absolute top-50 end-0 translate-middle-y me-3"
                >
                  <i
                    class="ki-duotone fs-2 text-gray-500"
                    :class="showPassword ? 'ki-eye-slash' : 'ki-eye'"
                  >
                    <span class="path1"></span>
                    <span class="path2"></span>
                    <span class="path3"></span>
                  </i>
                </button>
              </div>
              <div v-if="errors.password" class="invalid-feedback d-block">
                {{ errors.password }}
              </div>
            </div>

            <!-- Remember Me -->
            <div class="d-flex flex-stack flex-wrap gap-3 mb-8">
              <div class="form-check form-check-sm form-check-custom form-check-solid">
                <input
                  v-model="loginForm.rememberMe"
                  class="form-check-input"
                  type="checkbox"
                  id="rememberMe"
                />
                <label class="form-check-label text-gray-700 fs-6" for="rememberMe">
                  Remember me
                </label>
              </div>

              <button type="button" class="link-primary fs-6 fw-bold text-decoration-none">
                Forgot Password?
              </button>
            </div>

            <!-- Login Button -->
            <div class="d-grid">
              <button
                type="submit"
                class="btn btn-lg btn-primary fw-bolder"
                :class="{ disabled: loading }"
                :disabled="loading"
              >
                <span v-if="!loading">
                  <i class="ki-duotone ki-entrance-right fs-2 me-2">
                    <span class="path1"></span>
                    <span class="path2"></span>
                  </i>
                  Sign In
                </span>
                <span v-else class="d-flex align-items-center">
                  <span class="spinner-border spinner-border-sm me-2"></span>
                  Signing in...
                </span>
              </button>
            </div>
          </form>

          <!-- Security Notice -->
          <div class="text-center mt-8">
            <div class="badge badge-light-success py-3 px-4">
              <i class="ki-duotone ki-security-check fs-5 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Secure Enterprise Login
            </div>
          </div>
        </div>

        <!-- Footer -->
        <div
          class="card-footer bg-light-primary text-center py-5"
          style="border-radius: 0 0 20px 20px"
        >
          <p class="text-gray-600 fs-7 mb-2">© 2025 Kigrama Fuel Station Management System</p>
          <p class="text-gray-500 fs-8 mb-0">Powered by TrailBase & Vue.js</p>
        </div>
      </div>

      <!-- System Status Indicator -->
      <div class="position-fixed bottom-0 end-0 m-5">
        <div
          class="badge badge-circle badge-lg"
          :class="systemStatus.online ? 'badge-success' : 'badge-danger'"
        >
          <i class="ki-duotone ki-wifi fs-3">
            <span class="path1"></span>
            <span class="path2"></span>
            <span class="path3"></span>
            <span class="path4"></span>
            <span class="path5"></span>
          </i>
        </div>
      </div>
    </div>
  </div>

  <!-- Main App Content (Hidden until authenticated) -->
  <div v-show="isAuthenticated" class="main-app-content">
    <div class="d-flex flex-column min-vh-100 bg-light">
      <!-- Success Header -->
      <div class="bg-success text-white text-center py-8">
        <h1 class="text-white fw-bolder fs-1 mb-2">🎉 Login Successful!</h1>
        <p class="text-white opacity-75 fs-4">Welcome to Kigrama Fuel Station Management System</p>
      </div>

      <!-- Content Area -->
      <div class="flex-grow-1 d-flex flex-center">
        <div class="card shadow-lg w-100 mx-5" style="max-width: 600px">
          <div class="card-body text-center p-10">
            <i class="ki-duotone ki-check-circle fs-3x text-success mb-5">
              <span class="path1"></span>
              <span class="path2"></span>
            </i>
            <h3 class="text-gray-900 fw-bolder fs-2 mb-5">Authentication Complete</h3>
            <p class="text-gray-600 fs-5 mb-8">
              The full-screen login modal has been successfully hidden.<br />
              Your main application content would appear here.
            </p>

            <div class="row g-5">
              <div class="col-6">
                <div class="card card-flush bg-light-primary">
                  <div class="card-body text-center py-5">
                    <i class="ki-duotone ki-user fs-2x text-primary mb-3">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <h6 class="text-gray-900 fw-bold">User Data</h6>
                    <p class="text-gray-600 fs-7">Complete profile loaded</p>
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="card card-flush bg-light-success">
                  <div class="card-body text-center py-5">
                    <i class="ki-duotone ki-security-check fs-2x text-success mb-3">
                      <span class="path1"></span>
                      <span class="path2"></span>
                    </i>
                    <h6 class="text-gray-900 fw-bold">Permissions</h6>
                    <p class="text-gray-600 fs-7">Access rights verified</p>
                  </div>
                </div>
              </div>
            </div>

            <button @click="logout" class="btn btn-light-danger btn-lg mt-8">
              <i class="ki-duotone ki-exit-right fs-2 me-2">
                <span class="path1"></span>
                <span class="path2"></span>
              </i>
              Test Logout (Show Modal Again)
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import Swal from 'sweetalert2'

// API Configuration
const API_BASE_URL = 'https://backend.cloudfuelstationmis.com/api/records/v1'

// Reactive State - FORCE MODAL TO SHOW
const loading = ref(false)
const showPassword = ref(false)
const systemStatus = ref({ online: true })
const isAuthenticated = ref(false) // MUST start as false
const showLoginModal = ref(true) // MUST start as true

// Form Data
const loginForm = reactive({
  email: '',
  password: '',
  rememberMe: false,
})

// Form Errors
const errors = reactive({
  email: '',
  password: '',
})

// Auth Data Storage
const AUTH_DATA = ref({
  user: null,
  roles: [],
  permissions: [],
  stations: [],
  positions: [],
  token: null,
  loginTime: null,
  sessionData: {},
})

// Force Modal Display Function
const forceShowModal = () => {
  isAuthenticated.value = false
  showLoginModal.value = true
  document.body.style.overflow = 'scroll'

  // Double-check in next tick
  nextTick(() => {
    if (!showLoginModal.value) {
      showLoginModal.value = true
    }
  })
}

// Toggle Password Visibility
const togglePassword = () => {
  showPassword.value = !showPassword.value
}

// Form Validation
const validateForm = () => {
  errors.email = ''
  errors.password = ''

  let isValid = true

  if (!loginForm.email) {
    errors.email = 'Email is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(loginForm.email)) {
    errors.email = 'Please enter a valid email address'
    isValid = false
  }

  if (!loginForm.password) {
    errors.password = 'Password is required'
    isValid = false
  } else if (loginForm.password.length < 6) {
    errors.password = 'Password must be at least 6 characters'
    isValid = false
  }

  return isValid
}

// Direct Password Authentication
const authenticateUser = async (email, password) => {
  try {
    // Get all users and find the matching email
    const usersResponse = await fetch(`${API_BASE_URL}/users`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    })

    if (!usersResponse.ok) {
      throw new Error('Unable to connect to authentication service')
    }

    const usersData = await usersResponse.json()
    const user = usersData.records?.find((u) => u.email === email)

    if (!user) {
      throw new Error('Invalid email or password')
    }

    // Direct password comparison - no encryption/hashing
    if (user.password !== password) {
      throw new Error('Invalid email or password')
    }

    return user
  } catch (error) {
    console.error('Authentication error:', error)
    throw error
  }
}

// Fetch User Roles
const fetchUserRoles = async (userId) => {
  try {
    const response = await fetch(`${API_BASE_URL}/UserRoles?UserID=${userId}`)
    if (response.ok) {
      const data = await response.json()
      return data.records || []
    }
    return []
  } catch (error) {
    console.error('Error fetching user roles:', error)
    return []
  }
}

// Fetch Role Details
const fetchRoleDetails = async (roleIds) => {
  try {
    const rolePromises = roleIds.map((roleId) =>
      fetch(`${API_BASE_URL}/Roles/${roleId}`)
        .then((res) => (res.ok ? res.json() : null))
        .catch(() => null),
    )

    const roleResults = await Promise.all(rolePromises)
    return roleResults.filter((role) => role !== null)
  } catch (error) {
    console.error('Error fetching role details:', error)
    return []
  }
}

// Fetch User Permissions
const fetchUserPermissions = async (roleIds) => {
  try {
    const permissionPromises = roleIds.map(async (roleId) => {
      const rolePermResponse = await fetch(`${API_BASE_URL}/RolePermissions?RoleID=${roleId}`)
      if (rolePermResponse.ok) {
        const rolePermData = await rolePermResponse.json()
        return rolePermData.records || []
      }
      return []
    })

    const allRolePermissions = await Promise.all(permissionPromises)
    const flatPermissions = allRolePermissions.flat()
    const uniquePermissionIds = [...new Set(flatPermissions.map((p) => p.PermissionID))]

    const permissionDetails = await Promise.all(
      uniquePermissionIds.map((permId) =>
        fetch(`${API_BASE_URL}/Permissions/${permId}`)
          .then((res) => (res.ok ? res.json() : null))
          .catch(() => null),
      ),
    )

    return permissionDetails.filter((perm) => perm !== null)
  } catch (error) {
    console.error('Error fetching permissions:', error)
    return []
  }
}

// Fetch User Stations
const fetchUserStations = async (userId) => {
  try {
    const response = await fetch(`${API_BASE_URL}/UserStations?UserID=${userId}`)
    if (response.ok) {
      const data = await response.json()
      const userStations = data.records || []

      // Fetch station details
      const stationDetails = await Promise.all(
        userStations.map(async (us) => {
          const stationResponse = await fetch(`${API_BASE_URL}/Stations/${us.StationID}`)
          if (stationResponse.ok) {
            const station = await stationResponse.json()
            return { ...station, ...us }
          }
          return us
        }),
      )

      return stationDetails
    }
    return []
  } catch (error) {
    console.error('Error fetching user stations:', error)
    return []
  }
}

// Fetch User Positions
const fetchUserPositions = async (userId) => {
  try {
    const response = await fetch(`${API_BASE_URL}/UserPositions?UserID=${userId}`)
    if (response.ok) {
      const data = await response.json()
      const userPositions = data.records || []

      // Fetch position details
      const positionDetails = await Promise.all(
        userPositions.map(async (up) => {
          const positionResponse = await fetch(`${API_BASE_URL}/Positions/${up.PositionID}`)
          if (positionResponse.ok) {
            const position = await positionResponse.json()
            return { ...position, ...up }
          }
          return up
        }),
      )

      return positionDetails
    }
    return []
  } catch (error) {
    console.error('Error fetching user positions:', error)
    return []
  }
}

// Generate JWT Token (Simulated)
const generateToken = (user) => {
  const header = btoa(JSON.stringify({ typ: 'JWT', alg: 'HS256' }))
  const payload = btoa(
    JSON.stringify({
      sub: user.id,
      email: user.email,
      name: user.name,
      role: user.Role,
      iat: Math.floor(Date.now() / 1000),
      exp: Math.floor(Date.now() / 1000) + 24 * 60 * 60, // 24 hours
    }),
  )
  const signature = btoa('simulated_signature_for_demo')

  return `${header}.${payload}.${signature}`
}

// Main Login Handler
const handleLogin = async () => {
  if (!validateForm()) {
    return
  }

  loading.value = true

  try {
    // Step 1: Authenticate User
    const user = await authenticateUser(loginForm.email, loginForm.password)

    // Step 2: Fetch User Roles
    const userRoles = await fetchUserRoles(user.id)
    const roleIds = userRoles.map((ur) => ur.RoleID)

    // Step 3: Fetch Role Details
    const roles = await fetchRoleDetails(roleIds)

    // Step 4: Fetch User Permissions
    const permissions = await fetchUserPermissions(roleIds)

    // Step 5: Fetch User Stations
    const stations = await fetchUserStations(user.id)

    // Step 6: Fetch User Positions
    const positions = await fetchUserPositions(user.id)

    // Step 7: Generate Token
    const token = generateToken(user)

    // Step 8: Compile AUTH_DATA
    AUTH_DATA.value = {
      user: user,
      roles: roles,
      permissions: permissions,
      stations: stations,
      positions: positions,
      token: token,
      loginTime: new Date().toISOString(),
      sessionData: {
        loginMethod: 'email_password',
        rememberMe: loginForm.rememberMe,
        userAgent: navigator.userAgent,
        ipAddress: 'client_ip_placeholder',
        deviceInfo: {
          platform: navigator.platform,
          language: navigator.language,
          screen: `${screen.width}x${screen.height}`,
          timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        },
      },
    }

    // Step 9: Store in localStorage if remember me is checked
    // Always store login for SPA, clear on logout
    localStorage.setItem('kigrama_auth_token', token)
    localStorage.setItem('kigrama_user_data', JSON.stringify(AUTH_DATA.value))

    // Step 10: Console log all auth data
    console.log('🔐 KIGRAMA AUTHENTICATION SUCCESSFUL')
    console.log('👤 User Data:', AUTH_DATA.value.user)
    console.log('🎭 User Roles:', AUTH_DATA.value.roles)
    console.log('🔑 User Permissions:', AUTH_DATA.value.permissions)
    console.log('🏢 User Stations:', AUTH_DATA.value.stations)
    console.log('💼 User Positions:', AUTH_DATA.value.positions)
    console.log('🎫 Auth Token:', AUTH_DATA.value.token)
    console.log('📊 Complete AUTH_DATA:', AUTH_DATA.value)

    // Step 11: Success notification
    await Swal.fire({
      title: 'Welcome Back!',
      text: `Successfully logged in as ${user.name || user.email}`,
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 3000,
      showConfirmButton: false,
      background: '#f8f9fa',
      color: '#1e1e2d',
    })

    // Step 12: Hide modal and mark as authenticated
    isAuthenticated.value = true
    showLoginModal.value = false

    // Step 13: Restore body scroll
    document.body.style.overflow = 'auto'

    // Step 14: Navigate to dashboard (simulated)
    setTimeout(() => {
      console.log('🚀 User authenticated - Modal hidden, ready for app content')
      // Emit event or call parent method to show main app
      window.location.href = '/'
    }, 500)
  } catch (error) {
    console.error('Login error:', error)

    await Swal.fire({
      title: 'Login Failed!',
      text: error.message || 'An error occurred during login',
      icon: 'error',
      confirmButtonColor: '#f1416c',
      background: '#fff',
      color: '#1e1e2d',
    })
  } finally {
    loading.value = false
  }
}

// Check System Status
const checkSystemStatus = async () => {
  try {
    const response = await fetch(`${API_BASE_URL}/users?limit=1`)
    systemStatus.value.online = response.ok
  } catch (error) {
    systemStatus.value.online = false
  }
}

// Logout Function (for testing modal)
const logout = async () => {
  const result = await Swal.fire({
    title: 'Logout Confirmation',
    text: 'Are you sure you want to logout?',
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, Logout',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#f1416c',
    cancelButtonColor: '#3699ff',
  })

  if (result.isConfirmed) {
    // Clear auth data
    AUTH_DATA.value = {
      user: null,
      roles: [],
      permissions: [],
      stations: [],
      positions: [],
      token: null,
      loginTime: null,
      sessionData: {},
    }

    // Clear localStorage
    localStorage.removeItem('kigrama_auth_token')
    localStorage.removeItem('kigrama_user_data')

    // Reset form
    loginForm.email = ''
    loginForm.password = ''
    loginForm.rememberMe = false

    // Force show modal again
    forceShowModal()

    await Swal.fire({
      title: 'Logged Out',
      text: 'You have been successfully logged out',
      icon: 'success',
      toast: true,
      position: 'top-end',
      timer: 2000,
      showConfirmButton: false,
    })

    console.log('🚪 User logged out - Modal shown again')
  }
}

// Initialize Component - GUARANTEED MODAL DISPLAY
onMounted(async () => {
  console.log('🔄 Login Modal Component Mounted - FORCING DISPLAY')

  // FORCE MODAL TO SHOW - NO EXCEPTIONS
  forceShowModal()

  // Double-check system status
  await checkSystemStatus()

  // Clear any potential auto-login interference
  // DO NOT AUTO-LOGIN - Always show modal first
  console.log('✅ Login Modal FORCED to display - No auto-login interference')

  // Additional safeguard - ensure modal stays visible
  setTimeout(() => {
    if (!showLoginModal.value) {
      console.warn('⚠️ Modal was hidden - FORCING back to visible')
      forceShowModal()
    }
  }, 100)

  // Final safety check
  nextTick(() => {
    if (!showLoginModal.value || isAuthenticated.value) {
      console.warn('⚠️ Modal state compromised - FORCING correct state')
      forceShowModal()
    }
    console.log('🎯 Modal Display Status:', {
      showLoginModal: showLoginModal.value,
      isAuthenticated: isAuthenticated.value,
      bodyOverflow: document.body.style.overflow,
    })
  })
})

// Export forced show function for external use if needed
defineExpose({
  forceShowModal,
  showLoginModal,
  isAuthenticated,
})
</script>

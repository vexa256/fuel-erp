// import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')


window.SERVER_URL = " https://backend.cloudfuelstationmis.com/";


// Self-Executing Authentication Logic for main.js
// Just paste this code directly into your main.js file

// (function () {
//   'use strict'

//   console.log('🛡️ Kigrama Authentication Monitor Starting...')

//   // Authentication Configuration
//   const AUTH_CONFIG = {
//     TOKEN_KEY: 'kigrama_auth_token',
//     USER_DATA_KEY: 'kigrama_user_data',
//     CHECK_INTERVAL: 300000, // 5 minutes
//     SESSION_LIMIT: 24 // hours
//   }

//   let sessionTimer = null

//   // Check if user is logged in - matches your login component
//   function isUserLoggedIn() {
//     const token = localStorage.getItem(AUTH_CONFIG.TOKEN_KEY)
//     const userData = localStorage.getItem(AUTH_CONFIG.USER_DATA_KEY)

//     if (!token || !userData) {
//       console.log('🚨 No authentication credentials found')
//       return false
//     }

//     try {
//       const authData = JSON.parse(userData)

//       // Validate AUTH_DATA structure (same as your login component)
//       if (!authData.user || !authData.user.id || !authData.user.email) {
//         console.log('🚨 Invalid AUTH_DATA structure detected')
//         clearAuthData()
//         return false
//       }

//       // Check JWT token expiration
//       if (isTokenExpired(token)) {
//         console.log('🚨 JWT token has expired')
//         clearAuthData()
//         return false
//       }

//       // Check session age (24 hour maximum)
//       if (isSessionExpired(authData.loginTime)) {
//         console.log('🚨 Session has expired (24+ hours)')
//         clearAuthData()
//         return false
//       }

//       console.log('✅ User authentication valid:', authData.user.name || authData.user.email)
//       return true
//     } catch (error) {
//       console.error('🚨 Authentication validation error:', error)
//       clearAuthData()
//       return false
//     }
//   }

//   // Check if JWT token is expired
//   function isTokenExpired(token) {
//     try {
//       const payload = JSON.parse(atob(token.split('.')[1]))
//       const currentTime = Math.floor(Date.now() / 1000)
//       return payload.exp && payload.exp < currentTime
//     } catch (error) {
//       console.error('🚨 Token validation error:', error)
//       return true
//     }
//   }

//   // Check if session is older than 24 hours
//   function isSessionExpired(loginTime) {
//     if (!loginTime) return true

//     const loginDate = new Date(loginTime)
//     const currentDate = new Date()
//     const hoursDifference = (currentDate - loginDate) / (1000 * 60 * 60)

//     return hoursDifference > AUTH_CONFIG.SESSION_LIMIT
//   }

//   // Clear authentication data
//   function clearAuthData() {
//     localStorage.removeItem(AUTH_CONFIG.TOKEN_KEY)
//     localStorage.removeItem(AUTH_CONFIG.USER_DATA_KEY)
//     stopSessionMonitoring()
//     console.log('🧹 Authentication data cleared')
//   }

//   // Force logout with notification
//   async function forceLogout(reason = 'Your session has expired') {
//     clearAuthData()

//     // Import SweetAlert2 dynamically if available
//     try {
//       const Swal = (await import('sweetalert2')).default

//       await Swal.fire({
//         title: 'Session Expired',
//         text: reason,
//         icon: 'warning',
//         confirmButtonText: 'Login Again',
//         confirmButtonColor: '#3699ff',
//         allowOutsideClick: false,
//         allowEscapeKey: false,
//         heightAuto: false
//       })
//     } catch (error) {
//       console.log('SweetAlert2 not available, using standard alert')
//       alert(`${reason}\n\nPlease login again.`)
//     }

//     // Redirect to login page
//     console.log('🚪 Redirecting to login page...')
//     window.location.href = '/auth/login'
//   }

//   // Check and redirect if not logged in
//   function checkAndRedirect() {
//     if (!isUserLoggedIn()) {
//       console.log('🚨 User not authenticated - redirecting to login')

//       // Only redirect if not already on login page
//       if (window.location.pathname !== '/auth/login') {
//         window.location.href = '/auth/login'
//       }
//       return false
//     }
//     return true
//   }

//   // Start continuous session monitoring
//   function startSessionMonitoring() {
//     // Clear any existing timer
//     if (sessionTimer) {
//       clearInterval(sessionTimer)
//     }

//     // Monitor every 5 minutes
//     sessionTimer = setInterval(() => {
//       console.log('🔍 Performing authentication check...')

//       if (!isUserLoggedIn()) {
//         console.log('🚨 Authentication check failed')
//         forceLogout('Session validation failed')
//       } else {
//         console.log('✅ Authentication check passed')
//       }
//     }, AUTH_CONFIG.CHECK_INTERVAL)

//     console.log('🔄 Continuous session monitoring active')
//   }

//   // Stop session monitoring
//   function stopSessionMonitoring() {
//     if (sessionTimer) {
//       clearInterval(sessionTimer)
//       sessionTimer = null
//       console.log('⏹️ Session monitoring stopped')
//     }
//   }

//   // Initialize authentication checking
//   function initializeAuth() {
//     console.log('🚀 Initializing authentication system...')

//     // Initial authentication check
//     const isLoggedIn = isUserLoggedIn()

//     if (!isLoggedIn) {
//       console.log('🚨 No valid authentication found')

//       // Only redirect if not on login page
//       if (window.location.pathname !== '/auth/login') {
//         console.log('🔄 Redirecting to login page...')
//         window.location.href = '/auth/login'
//         return
//       }
//     } else {
//       console.log('✅ Valid authentication found')

//       // Start monitoring for authenticated users
//       startSessionMonitoring()

//       // Redirect away from login if already authenticated
//       if (window.location.pathname === '/auth/login') {
//         console.log('✅ User authenticated - redirecting from login page')
//         window.location.href = '/'
//         return
//       }
//     }
//   }

//   // Page visibility change handler
//   function handleVisibilityChange() {
//     if (!document.hidden && window.location.pathname !== '/auth/login') {
//       console.log('🔍 Page became visible - checking authentication...')
//       checkAndRedirect()
//     }
//   }

//   // Global error handler for authentication errors
//   function handleGlobalErrors(event) {
//     const error = event.reason || event.error
//     if (error?.message?.includes('401') ||
//       error?.message?.includes('Unauthorized') ||
//       error?.status === 401) {
//       console.log('🚨 Global authentication error detected')
//       forceLogout('Authentication error occurred')
//     }
//   }

//   // Setup event listeners
//   function setupEventListeners() {
//     // Page visibility monitoring
//     document.addEventListener('visibilitychange', handleVisibilityChange)

//     // Global error handling
//     window.addEventListener('unhandledrejection', handleGlobalErrors)
//     window.addEventListener('error', handleGlobalErrors)

//     // Storage change monitoring (logout from another tab)
//     window.addEventListener('storage', (e) => {
//       if (e.key === AUTH_CONFIG.TOKEN_KEY && !e.newValue) {
//         console.log('🚨 Authentication cleared in another tab')
//         clearAuthData()
//         window.location.href = '/auth/login'
//       }
//     })

//     console.log('👂 Authentication event listeners active')
//   }

//   // DOM ready initialization
//   function onDOMReady() {
//     initializeAuth()
//     setupEventListeners()
//     console.log('🛡️ Kigrama Authentication Monitor Active')
//   }

//   // Start authentication monitoring when DOM is ready
//   if (document.readyState === 'loading') {
//     document.addEventListener('DOMContentLoaded', onDOMReady)
//   } else {
//     onDOMReady()
//   }

//   // Cleanup on page unload
//   window.addEventListener('beforeunload', () => {
//     stopSessionMonitoring()
//   })

// })()

<template>
  <div>
    <div class="mb-8">
      <h2 class="text-2xl font-bold text-gray-900">Dashboard</h2>
      <p class="mt-1 text-sm text-gray-500">
        Selamat datang kembali, {{ user?.name }}
        <span v-if="user?.role === 'dinas'" class="block mt-1 text-primary-600 font-medium">
          {{ namaDinas }}
        </span>
      </p>
    </div>

    <!-- Stats for Dinas -->
    <div v-if="user?.role === 'dinas'" class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
      <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-blue-50 text-blue-600">
            <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-500">Total Usulan</p>
            <p class="text-2xl font-bold text-gray-900">{{ stats.total }}</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-yellow-50 text-yellow-600">
            <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-500">Menunggu</p>
            <p class="text-2xl font-bold text-gray-900">{{ stats.diajukan }}</p>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-orange-50 text-orange-600">
            <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-500">Revisi</p>
            <p class="text-2xl font-bold text-gray-900">{{ stats.draft }}</p>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-green-50 text-green-600">
            <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-500">Diterima</p>
            <p class="text-2xl font-bold text-gray-900">{{ stats.diterima }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Pengusulan -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
        <h3 class="text-lg font-semibold text-gray-900">Daftar Pengusulan</h3>
        <router-link 
          v-if="user?.role === 'dinas'"
          to="/dashboard/pengusulan/create" 
          class="text-sm font-medium text-primary-600 hover:text-primary-700"
        >
          + Buat Baru
        </router-link>
      </div>

      <div class="p-6">
        <div v-if="loading" class="flex justify-center py-8">
          <svg class="animate-spin h-8 w-8 text-primary-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>

        <div v-else-if="recentPengusulan.length === 0" class="text-center py-12">
          <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gray-100 mb-4">
            <svg class="h-10 w-10 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
            </svg>
          </div>
          <p class="text-base font-semibold text-gray-900">Belum ada pengusulan</p>
          <p class="mt-2 text-sm text-gray-500">Mulai dengan membuat pengusulan baru</p>
          <router-link
            v-if="user?.role === 'dinas'"
            to="/dashboard/pengusulan/create"
            class="mt-6 inline-block btn btn-primary"
          >
            Buat Pengusulan Baru
          </router-link>
        </div>
        
        <div v-else class="divide-y divide-gray-100">
          <div
            v-for="item in recentPengusulan"
            :key="item.id"
            class="py-5 first:pt-0 hover:bg-gray-50 -mx-6 px-6 cursor-pointer transition-all duration-200 group"
            @click="$router.push(`/dashboard/pengusulan/${item.id}`)"
          >
            <div class="flex items-start justify-between">
              <div class="flex-1 min-w-0">
                <div class="flex items-center space-x-3 mb-3">
                  <h4 class="text-lg font-bold text-gray-900 line-clamp-2 group-hover:text-primary-600 transition-colors">
                    {{ item.judul_perbub }}
                  </h4>
                  <span 
                    :class="getStatusBadgeClass(item.status)"
                    class="badge flex-shrink-0"
                  >
                    {{ getStatusLabel(item.status) }}
                  </span>
                </div>
                <div class="flex flex-wrap items-center gap-5 text-sm text-gray-600">
                  <div class="flex items-center">
                    <svg class="h-4 w-4 mr-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                    <span class="font-semibold">Nomor:</span>
                    <span class="ml-1.5">{{ item.nomor_surat }}</span>
                  </div>
                  <div class="flex items-center">
                    <svg class="h-4 w-4 mr-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
                    </svg>
                    <span class="font-semibold">Dinas:</span>
                    <span class="ml-1.5 text-gray-900 font-bold">{{ item.dinas?.name || 'Tidak diketahui' }}</span>
                  </div>
                  <div class="flex items-center">
                    <svg class="h-4 w-4 mr-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                    </svg>
                    <span class="font-semibold">Tanggal:</span>
                    <span class="ml-1.5">{{ formatDate(item.tanggal_surat) }}</span>
                  </div>
                </div>
              </div>
              <div class="flex flex-col items-center ml-4 space-y-2">
                <svg class="h-5 w-5 text-gray-400 group-hover:text-primary-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Pagination Controls -->
        <div v-if="recentPengusulan.length > 0" class="px-6 py-4 border-t border-gray-100 flex items-center justify-between">
          <div class="text-sm text-gray-700">
            Menampilkan <span class="font-medium">{{ paginationFrom }}</span> - <span class="font-medium">{{ paginationTo }}</span> dari <span class="font-medium">{{ pagination.total }}</span> data
          </div>
          <div class="flex items-center space-x-2">
            <button
              @click="goToPage(1)"
              :disabled="pagination.currentPage === 1"
              class="px-3 py-1 text-sm border rounded-md disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
            >
              &laquo;
            </button>
            <button
              @click="goToPage(pagination.currentPage - 1)"
              :disabled="pagination.currentPage === 1"
              class="px-3 py-1 text-sm border rounded-md disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
            >
              &lt;
            </button>
            
            <template v-for="page in visiblePages" :key="page">
              <button
                v-if="page !== '...'"
                @click="goToPage(page)"
                :class="[
                  'px-3 py-1 text-sm border rounded-md',
                  pagination.currentPage === page 
                    ? 'bg-primary-600 text-white border-primary-600' 
                    : 'hover:bg-gray-100'
                ]"
              >
                {{ page }}
              </button>
              <span v-else class="px-2 text-gray-500">...</span>
            </template>

            <button
              @click="goToPage(pagination.currentPage + 1)"
              :disabled="pagination.currentPage === pagination.lastPage"
              class="px-3 py-1 text-sm border rounded-md disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
            >
              &gt;
            </button>
            <button
              @click="goToPage(pagination.lastPage)"
              :disabled="pagination.currentPage === pagination.lastPage"
              class="px-3 py-1 text-sm border rounded-md disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
            >
              &raquo;
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { usePengusulanStore } from '../stores/pengusulan'
import { useAuthStore } from '../stores/auth'
import { useAdminStore } from '../stores/admin'
import api from '../services/api'

const pengusulanStore = usePengusulanStore()
const authStore = useAuthStore()
const adminStore = useAdminStore()

const loading = ref(false)
const recentPengusulan = ref([])
const dinasData = ref(null)
const pagination = ref({
  currentPage: 1,
  lastPage: 1,
  total: 0,
  perPage: 10
})

const user = computed(() => authStore.user)

const namaDinas = computed(() => {
  if (user.value?.role === 'dinas') {
    // Cek dari user.dinas langsung
    if (user.value?.dinas) {
      return user.value.dinas.nama_dinas || user.value.dinas.name || ''
    }
    // Cek dari dinasData yang di-fetch terpisah
    if (dinasData.value) {
      return dinasData.value.nama_dinas || dinasData.value.name || ''
    }
  }
  return ''
})

const paginationFrom = computed(() => {
  if (pagination.value.total === 0) return 0
  return (pagination.value.currentPage - 1) * pagination.value.perPage + 1
})

const paginationTo = computed(() => {
  const to = pagination.value.currentPage * pagination.value.perPage
  return to > pagination.value.total ? pagination.value.total : to
})

const visiblePages = computed(() => {
  const current = pagination.value.currentPage
  const last = pagination.value.lastPage
  const pages = []
  
  if (last <= 7) {
    for (let i = 1; i <= last; i++) {
      pages.push(i)
    }
  } else {
    if (current <= 3) {
      pages.push(1, 2, 3, 4, '...', last)
    } else if (current >= last - 2) {
      pages.push(1, '...', last - 3, last - 2, last - 1, last)
    } else {
      pages.push(1, '...', current - 1, current, current + 1, '...', last)
    }
  }
  
  return pages
})

// Fetch dinas data jika user punya dinas_id tapi belum ada relasi dinas
async function loadDinasData() {
  if (user.value?.role === 'dinas' && user.value?.dinas_id && !user.value?.dinas) {
    try {
      // Coba endpoint public dulu
      let response
      try {
        response = await api.get(`/api/dinas/${user.value.dinas_id}`)
      } catch (e) {
        // Jika gagal, coba endpoint admin
        response = await api.get(`/admin/dinas/${user.value.dinas_id}`)
      }
      if (response.data) {
        dinasData.value = response.data.data || response.data
      }
    } catch (error) {
      console.error('Error loading dinas data:', error)
      // Coba fetch semua dinas dan cari yang sesuai
      try {
        const allDinas = await api.get('/api/dinas')
        const dinasList = allDinas.data.data || allDinas.data || []
        const foundDinas = Array.isArray(dinasList) 
          ? dinasList.find(d => d.id === user.value.dinas_id)
          : null
        if (foundDinas) {
          dinasData.value = foundDinas
        }
      } catch (e) {
        console.error('Error loading all dinas:', e)
      }
    }
  }
}

// Watch user changes
watch(() => user.value, (newUser) => {
  if (newUser?.role === 'dinas') {
    loadDinasData()
  }
}, { immediate: true })

const stats = computed(() => {
  const total = recentPengusulan.value.length
  // Stats should ideally come from backend or be calculated from all data, 
  // currently just showing sample if data is paginated
  // This is a limitation to be improved later by fetching specific stats endpoint
  return { 
    total: pagination.value.total || 0, 
    draft: 0, // Placeholder
    diajukan: 0, // Placeholder 
    diterima: 0 // Placeholder
  }
})

function getStatusBadgeClass(status) {
  const classes = {
    draft: 'badge-draft',
    diajukan: 'badge-diajukan',
    revisi: 'badge-revisi',
    diterima: 'badge-diterima',
    ditolak: 'badge-ditolak'
  }
  return classes[status] || 'badge-draft'
}

function getStatusLabel(status) {
  const labels = {
    draft: 'Draft',
    diajukan: 'Diajukan',
    revisi: 'Revisi',
    diterima: 'Diterima',
    ditolak: 'Ditolak'
  }
  return labels[status] || status
}

function formatDate(date) {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

async function loadPengusulan(page = 1) {
  loading.value = true
  try {
    const response = await pengusulanStore.fetchPengusulan({ page, per_page: 10 })
    if (response.data) {
      recentPengusulan.value = Array.isArray(response.data) ? response.data : []
      // Update pagination info from Laravel response
      pagination.value = {
        currentPage: response.current_page || 1,
        lastPage: response.last_page || 1,
        total: response.total || 0,
        perPage: response.per_page || 10
      }
    } else if (Array.isArray(response)) {
      recentPengusulan.value = response
    } else {
      recentPengusulan.value = []
    }
  } catch (error) {
    console.error('Error loading pengusulan:', error)
    recentPengusulan.value = []
  } finally {
    loading.value = false
  }
}

function goToPage(page) {
  if (page >= 1 && page <= pagination.value.lastPage && page !== pagination.value.currentPage) {
    loadPengusulan(page)
  }
}

onMounted(async () => {
  // Ensure user data is loaded
  if (authStore.isAuthenticated && !authStore.user) {
    await authStore.fetchUser()
  }
  
  // Load dinas data if needed
  await loadDinasData()
  
  // Initial load
  await loadPengusulan()
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>

<template>
  <div>
    <!-- Page Header -->
    <div class="mb-8 flex flex-col sm:flex-row sm:items-center sm:justify-between">
      <div class="mb-4 sm:mb-0">
        <h1 class="text-3xl font-bold text-gray-900">Kelola Pengguna</h1>
        <p class="mt-2 text-sm text-gray-600">Tambah dan kelola pengguna sistem</p>
      </div>
      <button @click="openModal()" class="btn btn-primary inline-flex items-center">
        <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
        </svg>
        Tambah User
      </button>
    </div>

    <!-- Search Box -->
    <div class="mb-4 flex flex-col sm:flex-row gap-3">
      <div class="flex-1">
        <input
          v-model="searchQuery"
          @input="handleSearch"
          type="text"
          placeholder="🔍 Cari nama atau email pengguna..."
          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
        />
      </div>
      <button 
        v-if="searchQuery"
        @click="clearSearch"
        class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-lg text-gray-700"
      >
        Hapus
      </button>
    </div>

    <!-- Info Bar -->
    <div class="mb-3 text-sm text-gray-600">
      Menampilkan <strong>{{ startIndex }}</strong> - <strong>{{ endIndex }}</strong> 
      dari <strong>{{ totalUsers }}</strong> pengguna
    </div>

    <!-- Users Table -->
    <div class="card">
      <div class="card-body p-0">
        <div v-if="loading" class="text-center py-12">
          <div class="inline-block animate-spin rounded-full h-10 w-10 border-4 border-primary-600 border-t-transparent"></div>
          <p class="mt-4 text-sm text-gray-500">Memuat data...</p>
        </div>
        <div v-else class="overflow-x-auto">
          <table class="table">
            <thead>
              <tr>
                <th>Nama</th>
                <th>Email</th>
                <th>Role</th>
                <th>Dinas</th>
                <th>Status</th>
                <th class="text-right">Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="users.length === 0">
                <td colspan="6" class="text-center py-8 text-gray-500">
                  {{ searchQuery ? 'Tidak ada pengguna yang cocok dengan pencarian' : 'Belum ada data pengguna' }}
                </td>
              </tr>
              <tr v-for="user in users" :key="user.id">
                <td>
                  <div class="text-sm font-semibold text-gray-900">{{ user.name }}</div>
                </td>
                <td>
                  <div class="text-sm text-gray-600">{{ user.email }}</div>
                </td>
                <td>
                  <span class="badge" :class="{
                    'badge-diterima': user.role === 'admin',
                    'badge-diajukan': user.role === 'dinas',
                    'badge-revisi': user.role === 'bagian_hukum' || user.role === 'verifikator'
                  }">
                    {{ user.role?.replace('_', ' ') }}
                  </span>
                </td>
                <td>
                  <div class="text-sm text-gray-600">{{ user.dinas?.nama_dinas || '-' }}</div>
                </td>
                <td>
                  <span class="badge" :class="{
                    'badge-diterima': user.is_active,
                    'badge-ditolak': !user.is_active
                  }">
                    {{ user.is_active ? 'Aktif' : 'Nonaktif' }}
                  </span>
                </td>
                <td class="text-right">
                  <div class="flex items-center justify-end space-x-2">
                    <button
                      @click="toggleUserStatus(user)"
                      class="text-sm font-medium px-3 py-1 rounded"
                      :class="user.is_active 
                        ? 'text-amber-600 hover:text-amber-700 bg-amber-50 hover:bg-amber-100' 
                        : 'text-emerald-600 hover:text-emerald-700 bg-emerald-50 hover:bg-emerald-100'"
                    >
                      {{ user.is_active ? 'Nonaktifkan' : 'Aktifkan' }}
                    </button>
                    <button
                      @click="editUser(user)"
                      class="text-primary-600 hover:text-primary-700 font-medium text-sm"
                    >
                      Edit
                    </button>
                    <button
                      @click="deleteUser(user.id)"
                      class="text-rose-600 hover:text-rose-700 font-medium text-sm"
                    >
                      Hapus
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Pagination Controls -->
        <div v-if="lastPage > 1" class="px-6 py-4 bg-gray-50 border-t border-gray-200 flex flex-col sm:flex-row items-center justify-between gap-4">
          <!-- Left: Page Info -->
          <div class="text-sm text-gray-700">
            Halaman <strong>{{ currentPage }}</strong> dari <strong>{{ lastPage }}</strong>
          </div>

          <!-- Right: Pagination Buttons -->
          <div class="flex flex-wrap gap-2 justify-center">
            <!-- First Page -->
            <button
              @click="goToPage(1)"
              :disabled="currentPage === 1"
              class="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed text-sm"
              title="Halaman Pertama"
            >
              «
            </button>

            <!-- Previous -->
            <button
              @click="goToPage(currentPage - 1)"
              :disabled="currentPage === 1"
              class="px-4 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed text-sm"
            >
              ← Prev
            </button>

            <!-- Page Numbers -->
            <template v-for="page in pageNumbers" :key="page">
              <button
                v-if="page !== '...'"
                @click="goToPage(page)"
                :class="[
                  'px-3 py-1 border rounded-lg text-sm transition-colors',
                  page === currentPage 
                    ? 'bg-primary-600 text-white border-primary-600' 
                    : 'border-gray-300 hover:bg-gray-100'
                ]"
              >
                {{ page }}
              </button>
              <span v-else class="px-2 py-1 text-gray-400">...</span>
            </template>

            <!-- Next -->
            <button
              @click="goToPage(currentPage + 1)"
              :disabled="currentPage === lastPage"
              class="px-4 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed text-sm"
            >
              Next →
            </button>

            <!-- Last Page -->
            <button
              @click="goToPage(lastPage)"
              :disabled="currentPage === lastPage"
              class="px-3 py-1 border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed text-sm"
              title="Halaman Terakhir"
            >
              »
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div
      v-if="showModal"
      class="fixed inset-0 bg-gray-900 bg-opacity-50 overflow-y-auto h-full w-full z-50 flex items-center justify-center p-4"
      @click.self="closeModal"
    >
      <div class="relative bg-white rounded-xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
        <div class="card-header">
          <h3 class="text-lg font-semibold text-gray-900">
            {{ editingUser ? 'Edit Pengguna' : 'Tambah Pengguna' }}
          </h3>
        </div>
        <form @submit.prevent="saveUser" class="card-body space-y-4">
          <div>
            <label class="form-label">Nama *</label>
            <input v-model="form.name" type="text" class="form-input" required />
          </div>
          <div>
            <label class="form-label">Email *</label>
            <input v-model="form.email" type="email" class="form-input" required />
          </div>
          <div>
            <label class="form-label">Password {{ editingUser ? '(kosongkan jika tidak diubah)' : '*' }}</label>
            <input v-model="form.password" type="password" class="form-input" :required="!editingUser" />
          </div>
          <div>
            <label class="form-label">Role *</label>
            <select v-model="form.role" class="form-select" required>
              <option value="dinas">Dinas</option>
              <option value="bagian_hukum">Bagian Hukum</option>
              <option value="verifikator">Verifikator</option>
              <option value="admin">Admin</option>
            </select>
          </div>
          <div>
            <label class="form-label">Dinas</label>
            <select v-model="form.dinas_id" class="form-select">
              <option value="">Pilih Dinas (Opsional)</option>
              <option v-for="dinas in allDinas" :key="dinas.id" :value="dinas.id">
                {{ dinas.nama_dinas }}
              </option>
            </select>
            <small class="text-gray-500 text-xs mt-1 block">Pilih dinas jika role adalah "Dinas"</small>
          </div>
          <div>
            <label class="form-label">Unit Kerja</label>
            <input v-model="form.unit_kerja" type="text" class="form-input" />
          </div>
          <div class="flex justify-end space-x-3 pt-4 border-t border-gray-200">
            <button type="button" @click="closeModal" class="btn btn-secondary">
              Batal
            </button>
            <button type="submit" class="btn btn-primary">
              Simpan
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAdminStore } from '../../stores/admin'

const adminStore = useAdminStore()

const users = ref([])
const allDinas = ref([])
const showModal = ref(false)
const editingUser = ref(null)
const loading = ref(false)

// Pagination state
const currentPage = ref(1)
const lastPage = ref(1)
const perPage = ref(10)
const totalUsers = ref(0)

// Search state
const searchQuery = ref('')
let searchTimeout = null

const form = ref({
  name: '',
  email: '',
  password: '',
  role: 'dinas',
  dinas_id: '',
  unit_kerja: ''
})

// Computed properties for pagination info
const startIndex = computed(() => {
  return users.value.length > 0 ? (currentPage.value - 1) * perPage.value + 1 : 0
})

const endIndex = computed(() => {
  return Math.min(currentPage.value * perPage.value, totalUsers.value)
})

const pageNumbers = computed(() => {
  const pages = []
  const delta = 2 // Show 2 pages before and after current
  
  for (let i = 1; i <= lastPage.value; i++) {
    if (
      i === 1 || // First page
      i === lastPage.value || // Last page
      (i >= currentPage.value - delta && i <= currentPage.value + delta) // Near current
    ) {
      pages.push(i)
    } else if (pages[pages.length - 1] !== '...') {
      pages.push('...')
    }
  }
  
  return pages
})

async function loadUsers(page = 1) {
  loading.value = true
  try {
    const params = { page }
    
    if (searchQuery.value) {
      params.search = searchQuery.value
    }
    
    const response = await adminStore.fetchUsers(params)
    
    // Update users data
    users.value = response.data || []
    
    // Update pagination meta
    if (response.meta) {
      currentPage.value = response.meta.current_page
      lastPage.value = response.meta.last_page
      totalUsers.value = response.meta.total
      perPage.value = response.meta.per_page
    } else {
      // Fallback if no pagination meta
      currentPage.value = 1
      lastPage.value = 1
      totalUsers.value = users.value.length
    }
  } catch (error) {
    console.error('Error loading users:', error)
    alert('Gagal memuat data users')
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  // Debounce search - wait 500ms after user stops typing
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    currentPage.value = 1 // Reset to first page
    loadUsers(1)
  }, 500)
}

function clearSearch() {
  searchQuery.value = ''
  currentPage.value = 1
  loadUsers(1)
}

function goToPage(page) {
  if (page >= 1 && page <= lastPage.value && page !== currentPage.value) {
    loadUsers(page)
    // Scroll to top of page smoothly
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

async function loadDinas() {
  try {
    await adminStore.fetchDinas()
    allDinas.value = adminStore.dinas.data || adminStore.dinas
  } catch (error) {
    console.error('Error loading dinas:', error)
  }
}

function openModal(user = null) {
  editingUser.value = user
  if (user) {
    form.value = {
      name: user.name,
      email: user.email,
      password: '',
      role: user.role,
      dinas_id: user.dinas_id || '',
      unit_kerja: user.unit_kerja || ''
    }
  } else {
    form.value = {
      name: '',
      email: '',
      password: '',
      role: 'dinas',
      dinas_id: '',
      unit_kerja: ''
    }
  }
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  editingUser.value = null
  form.value = {
    name: '',
    email: '',
    password: '',
    role: 'dinas',
    dinas_id: '',
    unit_kerja: ''
  }
}

function editUser(user) {
  openModal(user)
}

async function saveUser() {
  try {
    const data = { ...form.value }
    
    if (data.dinas_id === '') {
      data.dinas_id = null
    }
    
    if (editingUser.value && !data.password) {
      delete data.password
    }
    
    if (editingUser.value) {
      await adminStore.updateUser(editingUser.value.id, data)
    } else {
      await adminStore.createUser(data)
    }
    closeModal()
    await loadUsers(currentPage.value) // Reload current page
  } catch (error) {
    console.error('Error saving user:', error)
    let errorMessage = 'Gagal menyimpan user'
    
    if (error.response?.data?.message) {
      errorMessage = error.response.data.message
    } else if (error.response?.data?.errors) {
      const errors = error.response.data.errors
      const errorList = Object.entries(errors).map(([field, messages]) => {
        return `${field}: ${Array.isArray(messages) ? messages.join(', ') : messages}`
      }).join('\n')
      errorMessage = 'Validasi gagal:\n' + errorList
    } else if (error.message) {
      errorMessage = error.message
    }
    
    alert(errorMessage)
  }
}

async function toggleUserStatus(user) {
  if (confirm(`Yakin ingin ${user.is_active ? 'menonaktifkan' : 'mengaktifkan'} akun ${user.name}?`)) {
    try {
      await adminStore.toggleUserStatus(user.id)
      await loadUsers(currentPage.value) // Reload current page
    } catch (error) {
      console.error('Error toggling user status:', error)
      alert('Gagal mengubah status user')
    }
  }
}

async function deleteUser(id) {
  if (!confirm('Apakah Anda yakin ingin menghapus user ini?')) return
  
  try {
    await adminStore.deleteUser(id)
    
    // If current page becomes empty after delete, go to previous page
    if (users.value.length === 1 && currentPage.value > 1) {
      await loadUsers(currentPage.value - 1)
    } else {
      await loadUsers(currentPage.value)
    }
  } catch (error) {
    console.error('Error deleting user:', error)
    alert('Gagal menghapus user')
  }
}

onMounted(() => {
  loadUsers()
  loadDinas()
})
</script>


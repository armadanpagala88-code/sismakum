<template>
  <div class="p-6">
    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-blue-100">
            <svg class="h-8 w-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600">Menunggu Verifikasi</p>
            <p class="text-2xl font-semibold text-gray-900">{{ stats.diajukan || 0 }}</p>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-yellow-100">
            <svg class="h-8 w-8 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600">Perlu Revisi</p>
            <p class="text-2xl font-semibold text-gray-900">{{ stats.revisi || 0 }}</p>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow p-6">
        <div class="flex items-center">
          <div class="p-3 rounded-full bg-green-100">
            <svg class="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="ml-4">
            <p class="text-sm font-medium text-gray-600">Diterima</p>
            <p class="text-2xl font-semibold text-gray-900">{{ stats.diterima || 0 }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Usulan List -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-200">
        <h2 class="text-lg font-medium text-gray-900">Daftar Usulan</h2>
      </div>
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Judul</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Dinas</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tanggal</th>
              <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="item in pengusulan" :key="item.id">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">{{ item.judul_perbub }}</div>
                <div class="text-sm text-gray-500">{{ item.nomor_surat }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ item.dinas?.name || '-' }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span
                  :class="getStatusClass(item.status)"
                  class="px-2 inline-flex items-center text-xs leading-5 font-semibold rounded-full"
                >
                  <span v-if="item.status === 'selesai'" class="mr-1">✓</span>
                  {{ getStatusLabel(item.status) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ formatDate(item.tanggal_surat) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-3">
                <router-link
                  :to="`/dashboard/verifikator/pengusulan/${item.id}`"
                  class="text-blue-600 hover:text-blue-900"
                >
                  Review
                </router-link>
                <button
                  @click="confirmDelete(item)"
                  class="text-red-600 hover:text-red-900"
                >
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination Controls -->
      <div class="px-6 py-4 border-t border-gray-200 flex items-center justify-between">
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
                  ? 'bg-blue-600 text-white border-blue-600' 
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
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { usePengusulanStore } from '../stores/pengusulan'

const pengusulanStore = usePengusulanStore()
const pengusulan = ref([])
const stats = ref({})
const pagination = ref({
  currentPage: 1,
  lastPage: 1,
  total: 0,
  perPage: 10
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

function getStatusClass(status) {
  const classes = {
    draft: 'bg-gray-100 text-gray-800',
    diajukan: 'bg-blue-100 text-blue-800',
    revisi: 'bg-yellow-100 text-yellow-800',
    diterima: 'bg-green-100 text-green-800',
    selesai: 'bg-green-500 text-white',
    ditolak: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

function getStatusLabel(status) {
  const labels = {
    draft: 'Draft',
    diajukan: 'Diajukan',
    revisi: 'Revisi',
    diterima: 'Diterima',
    selesai: 'Selesai',
    ditolak: 'Ditolak'
  }
  return labels[status] || status
}

function formatDate(date) {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('id-ID')
}

async function loadPengusulan(page = 1) {
  try {
    const response = await pengusulanStore.fetchPengusulan({ page })
    pengusulan.value = response.data || []
    
    // Update pagination info from Laravel response
    pagination.value = {
      currentPage: response.current_page || 1,
      lastPage: response.last_page || 1,
      total: response.total || 0,
      perPage: response.per_page || 10
    }
    
    // Calculate stats from current page data (or fetch separately if needed)
    stats.value = {
      diajukan: pengusulan.value.filter(p => p.status === 'diajukan').length,
      revisi: pengusulan.value.filter(p => p.status === 'revisi').length,
      diterima: pengusulan.value.filter(p => p.status === 'diterima').length
    }
  } catch (error) {
    console.error('Error loading pengusulan:', error)
  }
}

function goToPage(page) {
  if (page >= 1 && page <= pagination.value.lastPage && page !== pagination.value.currentPage) {
    loadPengusulan(page)
  }
}

async function confirmDelete(item) {
  const confirmed = confirm(`Apakah Anda yakin ingin menghapus usulan "${item.judul_perbub}"? Tindakan ini tidak dapat dibatalkan.`)
  if (confirmed) {
    try {
      await pengusulanStore.deletePengusulan(item.id)
      alert('Usulan berhasil dihapus')
      await loadPengusulan(pagination.value.currentPage)
    } catch (error) {
      console.error('Error deleting pengusulan:', error)
      alert(error.response?.data?.message || 'Gagal menghapus usulan')
    }
  }
}

function printData() {
  const printWindow = window.open('', '_blank')
  const today = new Date().toLocaleDateString('id-ID', { year: 'numeric', month: 'long', day: 'numeric' })
  
  const tableRows = pengusulan.value.map((item, index) => `
    <tr>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">${paginationFrom.value + index}</td>
      <td style="border: 1px solid #ddd; padding: 8px;">${item.judul_perbub || '-'}</td>
      <td style="border: 1px solid #ddd; padding: 8px;">${item.nomor_surat || '-'}</td>
      <td style="border: 1px solid #ddd; padding: 8px;">${item.dinas?.name || '-'}</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">${getStatusLabel(item.status)}</td>
      <td style="border: 1px solid #ddd; padding: 8px; text-align: center;">${formatDate(item.tanggal_surat)}</td>
    </tr>
  `).join('')
  
  printWindow.document.write(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Daftar Usulan PERBUB - ${today}</title>
      <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h1 { text-align: center; font-size: 18px; margin-bottom: 5px; }
        h2 { text-align: center; font-size: 14px; font-weight: normal; margin-bottom: 20px; color: #666; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #f5f5f5; border: 1px solid #ddd; padding: 10px; font-size: 12px; }
        td { font-size: 11px; }
        .header-info { text-align: center; margin-bottom: 20px; }
        .stats { display: flex; justify-content: center; gap: 30px; margin-bottom: 20px; }
        .stat-item { text-align: center; padding: 10px; background: #f9f9f9; border-radius: 5px; }
        .footer { margin-top: 30px; text-align: right; font-size: 12px; }
        @media print { body { margin: 0; } }
      </style>
    </head>
    <body>
      <div class="header-info">
        <h1>DAFTAR USULAN PERBUB</h1>
        <h2>Kabupaten Konawe - Tanggal Cetak: ${today}</h2>
      </div>
      
      <div class="stats">
        <div class="stat-item"><strong>${stats.value.diajukan || 0}</strong><br/>Menunggu Verifikasi</div>
        <div class="stat-item"><strong>${stats.value.revisi || 0}</strong><br/>Perlu Revisi</div>
        <div class="stat-item"><strong>${stats.value.diterima || 0}</strong><br/>Diterima</div>
      </div>
      
      <table>
        <thead>
          <tr>
            <th style="width: 40px;">No</th>
            <th>Judul PERBUB</th>
            <th style="width: 120px;">No. Surat</th>
            <th style="width: 150px;">Dinas</th>
            <th style="width: 100px;">Status</th>
            <th style="width: 120px;">Tanggal</th>
          </tr>
        </thead>
        <tbody>
          ${tableRows}
        </tbody>
      </table>
      
      <div class="footer">
        <p>Halaman ${pagination.value.currentPage} dari ${pagination.value.lastPage} - Total: ${pagination.value.total} usulan</p>
      </div>
      
      <scr` + `ipt>
        window.onload = function() { window.print(); }
      </scr` + `ipt>
    </bo` + `dy>
    </ht` + `ml>
  `)
  printWindow.document.close()
}

onMounted(() => {
  loadPengusulan()
})
</script>

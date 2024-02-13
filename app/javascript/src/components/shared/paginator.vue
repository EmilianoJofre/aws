<template>
  <div>
    <div class="flex justify-center mb-2 text-center text-vl-gray">
      {{ $t('message.paginator.currentPage', { currentPage, totalPages }) }}
    </div>
    <div class="flex justify-center">
      <button
        class="px-1 py-1 mr-1 font-semibold"
        :class="[onFirstPage ? 'text-vl-gray-lightest' : 'text-vl-blue']"
      >
        <inline-svg
          @click="goPreviousPage()"
          class="fill-current"
          :src="require('assets/images/icons/chevron-left.svg')"
        />
      </button>
      <div
        v-for="key in totalPages"
        :key="key"
        class="px-2 py-1 mr-1 font-semibold border rounded border-vl-blue text-vl-blue"
        :class="{ 'bg-vl-blue-light' : key === currentPage }"
        @click="$emit('page-changed', key)"
      >
        {{ key }}
      </div>
      <button
        class="px-1 py-1 mr-1 font-semibold"
        :class="[onLastPage ? 'text-vl-gray-lightest' : 'text-vl-blue']"
      >
        <inline-svg
          @click="goNextPage()"
          class="fill-current"
          :src="require('assets/images/icons/chevron-right.svg')"
        />
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    currentPage: { type: Number, required: true },
    totalPages: { type: Number, required: true },
  },
  computed: {
    onFirstPage() {
      return this.currentPage === 1;
    },
    onLastPage() {
      return this.currentPage === this.totalPages;
    },
  },
  methods: {
    goPreviousPage() {
      if (!this.onFirstPage) {
        this.$emit('page-changed', this.currentPage - 1);
      }
    },
    goNextPage() {
      if (!this.onLastPage) {
        this.$emit('page-changed', this.currentPage + 1);
      }
    },
  },
};
</script>

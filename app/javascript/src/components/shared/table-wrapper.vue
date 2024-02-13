<template>
  <div
    class="mt-8"
    :class="[heightClass, !fullTable && 'overflow-y-auto']"
  >
    <custom-table
      class=""
      v-bind="$props"
      v-on="$listeners"
    />
    <div
      class="flex items-center justify-center h-16 text-center text-vl text-vl-gray"
      v-if="tableData.length === 0"
    >
      <p>
        {{ emptyMessage }}
      </p>
    </div>
  </div>
</template>

<script>
import CustomTable from '../table.vue';

export default {
  components: { CustomTable },
  props: {
    currency: { type: String, default: 'CLP' },
    emptyMessage: { type: String, required: true },
    fullColumnValue: { type: String, default: '' },
    fullTable: { type: Boolean, default: false },
    hasFullColumn: { type: Boolean, default: false },
    headers: { type: Array, required: true },
    heightClass: { type: String, default: 'small-table' },
    lastRowTotal: { type: Boolean, default: false },
    showEdit: { type: Boolean, default: false },
    showHeaders: { type: Boolean, default: true },
    showView: { type: Boolean, default: false },
    tableData: { type: Array, required: true },
    withCheckbox: { type: Boolean, default: false },
    withSort: { type: Boolean, default: true },
  },

};
</script>

<style lang="scss" scoped>
  
  .small-table {
    max-height: 16rem;
  }
</style>

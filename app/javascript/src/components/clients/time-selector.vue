<template>
  <div class="flex flex-row justify-center space-x-2 lg:space-x-16">
    <button
      v-for="(option, index) in options"
      :key="index"
      class="text-sm font-bold focus:outline-none lg:text-base"
      @click="emitSelectedTab(option)"
      :class="option.name === selectedTab ? 'border-b border-vl-blue text-vl-blue' : 'text-vl-gray'"
      v-tooltip="{
        classes: 'bg-vl-gray text-white rounded bg-opacity-90 shadow-xl max-w-md whitespace-pre-line px-4 py-2',
        content: option.tooltip,
      }"
    >
      {{ option.name }}
    </button>
    <info-tooltip
      class="text-vl-gray-200"
      :text="tooltipText"
    />
  </div>
</template>

<script>
export default {
  props: {
    options: { type: Array, required: true },
    lastUpdated: { type: String, required: true },
    selectedTab: { type: String, required: true },
    infoChart: { type: String, required: true},
  },
  computed: {
    tooltipText() {
      return `${this.infoChart}`;
    },
    filteredLastUpdated() {
      if (this.lastUpdated) {
        return this.$options.filters.date(this.lastUpdated.replace(' UTC | camelizeKeys', ''));
      }

      return 'sin registro';
    },
  },
  methods: {
    emitSelectedTab(option) {
      if (option.name !== this.selectedTab) this.$emit('selected-time-tab', option);
    },
  },
};
</script>

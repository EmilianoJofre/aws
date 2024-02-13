<template>
  <div>
    <div class="flex flex-col items-center mx-4">
      <div class="flex p-1 mb-4 rounded bg-vl-gray-100">
        <button
          v-for="(tab) in tabs"
          :key="tab.key"
          class="px-4 py-1 rounded-sm focus:outline-none"
          :class="[selectedTabKey === tab.key ? 'text-vl-blue bg-white' : 'bg-vl-gray-100']"
          @click="changeTab(tab.key)"
        >
          {{ $t(`message.metrics.${tab.name}`) }}
        </button>
      </div>
      <select
        name="select"
        v-model="selectedAssetId"
        class="p-1 mb-4 font-bold border rounded border-vl-blue text-vl-blue"
      >
        <option
          v-for="asset in assets"
          :key="asset.id"
          :value="asset.id"
        >
          {{ asset.assetId }}
        </option>
      </select>
      <info-card
        v-if="selectedTabKey === 0 || (selectedTabKey === 1 && !loadingConcentration)"
        class="w-full mb-2"
        :content="infoTabContent"
      />
      <loading v-else />
    </div>
  </div>
</template>

<script>
import CurrencySelector from '../shared/curreny-selector';
import InfoCard from '../shared/info-card.vue';

export default {
  components: { CurrencySelector, InfoCard },
  props: {
    assets: { type: Array, required: true },
    concentrationData: { type: Array, required: true },
    concentrationHeaders: { type: Array, required: true },
    loadingConcentration: { type: Boolean, required: true },
    performanceHeaders: { type: Array, required: true },
    relationId: { type: Number, required: true },
    tabs: { type: Array, required: true },
    selectedTabKey: { type: Number, required: true },
  },
  data() {
    return {
      selectedAssetId: this.assets[0].id,
    };
  },
  methods: {
    changeTab(key) {
      this.$emit('change-tab', key);
    },
    dataText(header) {
      if (header.filter && header.filter !== 'text-limit') {
        return this.$options.filters[header.filter](this.selectedAsset[header.title], this.currency);
      }

      return this.selectedAsset[header.title];
    },
  },
  computed: {
    infoTabContent() {
      return this.selectedHeaders.map((header) => ({
        class: header.title === 'assetId' ? 'text-vl-blue' : 'text-vl-gray',
        title: this.$t(`message.tableHeaders.${header.title}`),
        content: this.dataText(header),
      }));
    },
    selectedAsset() {
      if (this.selectedTabKey === 0) {
        return this.assets.find((asset) => asset.id === this.selectedAssetId);
      } else if (this.selectedTabKey === 1) {
        return this.concentrationData.find((asset) => asset.id === this.selectedAssetId);
      }

      return {};
    },
    selectedHeaders() {
      if (this.selectedTabKey === 0) {
        return this.performanceHeaders;
      } else if (this.selectedTabKey === 1) {
        return this.concentrationHeaders;
      }

      return [];
    },
  },
};
</script>

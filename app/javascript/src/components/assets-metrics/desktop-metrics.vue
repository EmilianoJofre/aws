<template>
  <div>
    <div class="flex text-lg font-medium py-6 mt-6 lg:border-t lg:border-gray-300">
      <div class="mr-4">
        <button
          v-for="(tab) in tabs"
          :key="tab.key"
          class="px-8 py-4 text-sm border-t border-l border-r outline-none focus:outline-none"
          :class="[selectedTabKey === tab.key ? '' : 'bg-vl-gray-100']"
          @click="changeTab(tab.key)"
        >
          <span
            class="border-b-2 pb-0.5"
            :class="[selectedTabKey === tab.key ? 'text-vl-blue border-vl-blue' : 'text-vl-gray border-vl-gray-100']"
          >
            {{ $t(`message.metrics.${tab.name}`) }}
          </span>
        </button>
      </div>
      <concentration-filters
        v-if="selectedTabKey === 1"
        :concentration-sub-sectors="concentrationSubSectors"
        :investment-assets="investmentAssets"
        @sub-sector-change="(payload) => filterChange('sub-sector-change', payload)"
        @type-change="(payload) => filterChange('type-change', payload)"
      />
    </div>
    <custom-table
      v-if="selectedTabKey === 0"
      class="flex justify-center border-b-2 border-vl-value text-vl-gray-400"
      :headers="performanceHeaders"
      :table-data="assets"
      :no-has-hover="false"
    />
    <div
      v-if="selectedTabKey === 1"
    >
      <loading v-if="loadingConcentration" />
      <custom-table
        v-else
        class="flex justify-center border-b-2 border-vl-value text-vl-gray-400"
        :currency="currency"
        :headers="concentrationHeaders"
        :table-data="concentrationData"
        :no-has-hover="false"
        :last-row-total-by-currency="true"
        last-row-total-by-currency-class="last bg-vl-gray-value-50 text-vl-blue"
      />
      <custom-table
        class="investments text-vl-gray-400"
        :currency="currency"
        :headers="concentrationHeaders"
        :table-data="[totalValues]"
        :has-full-column="false"
        :full-column-value="`Total (${currency})`"
        :show-headers="false"
        last-row-total
        :no-has-hover="false"
        :last-row-total-by-currency="true"
        last-row-total-by-currency-class="last bg-vl-gray-value-50 text-vl-blue"
      />
    </div>
  </div>
</template>

<script>
import ConcentrationFilters from './concentration-filters.vue';
import CustomTable from '../table.vue';
import CurrencySelector from '../shared/curreny-selector';

export default {
  components: { ConcentrationFilters, CustomTable, CurrencySelector },
  props: {
    assets: { type: Array, required: true },
    concentrationData: { type: Array, required: true },
    concentrationHeaders: { type: Array, required: true },
    concentrationSubSectors: { type: Array, required: true },
    currency: { type: String, required: true },
    investmentAssets: { type: Array, required: true },
    loadingConcentration: { type: Boolean, required: true },
    performanceHeaders: { type: Array, required: true },
    relationId: { type: Number, required: true },
    tabs: { type: Array, required: true },
    selectedTabKey: { type: Number, required: true },
  },
  methods: {
    changeTab(key) {
      this.$emit('change-tab', key);
    },
    filterChange(event, payload) {
      this.$emit(event, payload);
    },
  },
  computed: {
    totalValues() {
      const name = 'Total Cuenta'
      const etfPatrimony = this.concentrationData.reduce(
        (accumulator, element) => accumulator + element.etfPatrimony, 0,
      );
      const relativeWeight = this.concentrationData.reduce(
        (accumulator, element) => accumulator + element.relativeWeight, 0,
      );
      const annualCost = this.concentrationData.reduce(
        (accumulator, element) => accumulator + element.annualCost, 0,
      );
      const profitabilityWeigthedSum = this.concentrationData.reduce(
        (accumulator, element) => accumulator + (element.etfPatrimony * element.profitability), 0,
      );

      const assetQuotaAveragePriceWeightedSum = this.concentrationData.reduce(
        (accumulator, element) => accumulator + (element.etfPatrimony * element.assetQuotaAveragePrice), 0,
      );

      const averageAnnualCost = annualCost / etfPatrimony;

      const profitability = profitabilityWeigthedSum / etfPatrimony;

      const assetQuotaAveragePrice = assetQuotaAveragePriceWeightedSum / etfPatrimony;

      return { name, etfPatrimony, assetQuotaAveragePrice, relativeWeight, profitability, averageAnnualCost, annualCost };
    },
  },
};
</script>

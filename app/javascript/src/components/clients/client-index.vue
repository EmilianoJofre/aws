<template>
  <div>
    <client-balances
      v-if="selectedTab === 0 && selectedSubTab === ''"
      :accounts="accountsInvestmentInstruments"
      :is-demo="isDemo"
      :relation-id="relationId"
      :show-wallet="showWallet"
      :dollar="dollar"
      :euro="euro"
      :uf="uf"
      :last-updated="lastUpdated"
      :next-chart-update="nextChartUpdate"
    />
     <client-real-estate-balances
      v-if="selectedTab === 1 && selectedSubTab === ''"
      :accounts="accountsRealEstates"
      :is-demo="isDemo"
      :relation-id="relationId"
      :show-wallet="showWallet"
      :dollar="dollar"
      :euro="euro"
      :uf="uf"
      :last-updated="lastUpdated"
      :next-chart-update="nextChartUpdate"
    />
    <client-pension-funds
      v-if="selectedSubTab === '' && selectedTab === 3"
      :accounts="accountsPensionFunds"
      :is-demo="isDemo"
      :relation-id="relationId"
      :show-wallet="showWallet"
      :dollar="dollar"
      :euro="euro"
      :uf="uf"
      :last-updated="lastUpdated"
      :next-chart-update="nextChartUpdate"
    />
    <relation-report
      v-if="selectedSubTab === 5"
      :is-demo="isDemo"
      :relation-id="relationId"
      :accounts="accountsInvestmentInstruments"
    />
    <relation-report-pension-funds
      v-if="selectedSubTab === 6"
      :is-demo="isDemo"
      :relation-id="relationId"
      :accounts="accountsPensionFunds"
    />
    <relation-report-real-estate
      v-if="selectedSubTab === 8"
      :is-demo="isDemo"
      :relation-id="relationId"
      :accounts="accountsRealEstates"
    />
    <assets-metrics
      v-if="selectedTab === 2 && selectedSubTab === ''"
      :assets="assets"
      :dollar-price="dollar"
      :euro-price="euro"
      :is-demo="isDemo"
      :relation-id="relationId"
    />
    <relation-documents
      v-if="selectedTab === 7 && selectedSubTab === ''"
      :document-type-options="documentTypeOptions"
      :is-demo="isDemo"
      :relation-id="relationId"
      :relation-view="true"
      full-table
      with-checkbox
    />
  </div>
</template>
<script>
import ClientBalances from './client-balances.vue';
import ClientPensionFunds from './client-pension-funds.vue';
import ClientRealEstateBalances from './client-real-estate-balances.vue'
import RelationDocuments from '../relations/relation-documents.vue';
import RelationReport from '../reports/relation-report.vue';
import RelationReportPensionFunds from '../reports/relation-report-pension-funds.vue';
import RelationReportRealEstate from '../reports/relation-report-real-estate.vue';
import AssetsMetrics from '../assets-metrics/assets-metrics.vue';

export default {
  components: { ClientBalances, ClientRealEstateBalances, RelationDocuments, RelationReport, AssetsMetrics, ClientPensionFunds, RelationReportPensionFunds, RelationReportRealEstate },
  props: {
    accounts: { type: Array, required: true },
    accountsPensionFunds: { type: Array, required: true },
    accountsRealEstates: { type: Array, required: true },
    accountsInvestmentInstruments: { type: Array, required: true },
    assets: { type: Array, required: true },
    documentTypeOptions: { type: Array, default: () => [] },
    dollar: { type: Number, required: true },
    euro: { type: Number, required: true },
    uf: { type: Number, required: true },
    relationId: { type: Number, required: true },
    showWallet: { type: Boolean, required: true },
    isDemo: { type: Boolean, default: false },
    lastUpdated: { type: String, required: true },
    nextChartUpdate: { type: String, required: true },
  },
  mounted() {
    this.$store.dispatch('setSelectedRelationId', { id: this.relationId, isDemo: this.isDemo });
  },
  computed: {
    selectedTab() {
      return this.$store.state.navbar.selectedTabIndex;
    },
    selectedSubTab() {
      return this.$store.state.navbar.selectedSubTabIndex;
    },
  },
};
</script>

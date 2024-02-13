<template>
  <div class="mt-8">
    <div class="flex mt-1 -mb-4">
      <p class="text-lg font-bold text-vl-blue">
        Fondos de Pensiones
      </p>
      <button
        @click="showAssetsModal"
        class="focus:outline-none"
      >
        <img
          :src="require('../../../assets/images/icons/addNew.svg')"
          class="h-4 mt-1 ml-2 cursor-pointer"
          v-if="selectedSubAccountId"
        >
      </button>
    </div>
    <table-wrapper
      :with-checkbox="true"
      :currency="currency"
      :empty-message="$t('message.memberships.selectSubAccount')"
      :headers="headers"
      :table-data="memberships"
      @row-clicked="showMovementsModal"
      class="border-b-2 border-vl-value text-vl-gray-400"
    />
    <notifications group="suggest-asset" />
  </div>
</template>
<script>
import pensionFundsCreateModal from './pension-funds-assets-create-modal.vue';
import pensionFundsMovementsModal from './pension-funds-movements-modal.vue';
import TableWrapper from './shared/table-wrapper.vue';

export default {
  data() {
    return {
      headers: [
        { title: 'name', tooltip: true, tooltipCols: ['name'] },
        { title: 'assetId' },
        { title: 'quotasBalance', filter: 'quantity' },
        { title: 'quotaAveragePrice', filter: 'currency' },
        { title: 'amountInvestedBalance', headerTooltip: 'amountInvestedBalanceTooltip', filter: 'integerCurrency' },
        { title: 'updatedQuotaAveragePrice', filter: 'currency' },
        { title: 'amountUpdatedBalance', filter: 'integerCurrency' },
        { title: 'incomesBalance', filter: 'integerCurrency', showAll:true },
        { title: 'incomesPercentage', filter: 'percent', showAll:true },
        { title: 'relativeWeight', headerTooltip: 'relativeWeightInvesmentsToolTip', filter: 'percent', showAll:true },
      ],
    };
  },
  props: {
    isDemo: { type: Boolean, default: false },
    allInvestmentAssets: {
      type: Array,
      required: true,
    },
    investmentAssetsTypes: {
      type: Array,
      required: true,
    },
  },
  components: { TableWrapper },
  computed: {
    memberships() {
      return this.$store.getters.nomalizedPensionFunds;
    },
    selectedSubAccountId() {
      return this.$store.state.subAccounts.selectedSubAccountId;
    },
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    selectedPensionFundId: {
      get() {
        return this.$store.state.pensionFunds.selectedPensionFundId;
      },
      set(id) {
        this.$store.dispatch('setSelectedPensionFundId', id);
      },
    },
  },
  methods: {
    showAssetsModal() {
      this.$modal.show(pensionFundsCreateModal,
        { investmentAssets: this.allInvestmentAssets.filter(asset => asset.currency === this.currency) },
        { height: 'auto', width: '363px' },
      );
    },
    showMovementsModal(id) {
      this.selectedPensionFundId = id;
      this.$modal.show(pensionFundsMovementsModal,
        { membershipType: 'normal' },
        { height: 'auto', styles: { 'max-height': '500px' } },
        { 'before-close': this.beforeClose },
      );
    },
    beforeClose() {
      this.$store.dispatch('getPensionFunds');
    },
  },
  beforeMount() {
    this.$store.dispatch('setInvestmentAssetsTypes', this.investmentAssetsTypes);
  },
};
</script>

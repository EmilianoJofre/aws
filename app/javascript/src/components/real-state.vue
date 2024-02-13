<template>
  <div class="mt-8">
    <div class="flex mt-1 -mb-4">
      <p class="text-lg font-bold text-vl-blue">
        Bienes Raíces
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
      :show-edit="true"
      @row-clicked="showMovementsModal"
      class="border-b-2 border-vl-value text-vl-gray-400"
      @edit-clicked="editSelectedRealEstate"
    />
    <div class="text-right">
      <button
          @click="showAssetsModalButton"
          class="focus:outline-none"
        >
        <p class="pt-3 font-semibold underline text-sm3 roboto text-vl-blue-600">+ Agregar valorización externa</p>
        </button>
    </div>
    <notifications group="suggest-asset" />
  </div>
</template>
<script>
import realEstateCreateModal from './real-estate-assets-create-modal.vue';
import realEstateCreateModalButton from './real-estate-assets-create-modal-button.vue'
import realEstateMovementsModal from './real-estate-movements-modal.vue';
import TableWrapper from './shared/table-wrapper.vue';

export default {
  data() {
    return {
      headers: [
        { titles: ['nameRe', 'role'], title: 'nameRe', tooltip: true, tooltipCols: ['nameRe', 'role'], columnWidth:'110' },
        { title: 'assetDestination', columnWidth:'110' },
        { title: 'comune', columnWidth:'85' },
        { title: 'area', headerTooltip: 'area', columnWidth:'85' },
        { title: 'areaAveragePrice', headerTooltip: 'amountInvestedBalanceTooltip', filter: 'currency', fontStyle:'font-roboto', columnWidth:'112' },
        { title: 'amountInvestedBalanceRe', filter: 'currency', fontStyle:'font-roboto', columnWidth: '110' },
        { title: 'fiscalAppraise', filter: 'currency', fontStyle:'font-roboto', columnWidth: '95' },
        { titles: ['vlValorization', 'vlValorizationDate'], title: 'vlValorization', multiFilters: ['currency', 'date'], fontStyle:'font-roboto', columnWidth:'110' },
        { titles: ['externalValuation', 'externalValorizationDate', 'externalValorizationName'], title:'externalValuation', fontStyle:'font-roboto', multiFilters: ['currency', 'date', 'currency'], columnWidth:'110' },
        { titles: ['incomesBalanceRe', 'incomesPercentageRe'], title:'incomesBalanceAndPercentage', multiFilters: ['integerCurrency', 'percent'], tooltipCols: ['incomesBalance', 'incomesPercentage'], fontStyle:'font-roboto', columnWidth: '110', showAll: true, withColor: true },
        { title: 'relativeWeightRe', headerTooltip: 'relativeWeightInvesmentsToolTip', filter: 'percent', columnWidth:'55', showAll: true },
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
    communes: {
      type: Array,
      required: true,
    }
  },
  components: { TableWrapper },
  computed: {
    memberships() {
      return this.$store.getters.nomalizedRealEstate;
    },
    selectedSubAccountId() {
      return this.$store.state.subAccounts.selectedSubAccountId;
    },
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    selectedRealEstatesId: {
      get() {
        return this.$store.state.realEstate.selectedRealEstatesId;
      },
      set(id) {
        this.$store.dispatch('setSelectedRealEstatesId', id);
      },
    },
    realEstates() {
      return this.$store.state.realEstate.realEstates;
    },
  },
  methods: {
    findRealEstateById(id) {
      return this.realEstates.find((realEstate) => realEstate.id === Number(id));
    },
    showAssetsModal() {
      this.$modal.show(realEstateCreateModal,
        { 
          investmentAssets: this.allInvestmentAssets.filter(asset => asset.currency === this.currency),
          communes: this.communes
        },
        { height: 'auto', width: '363px' },
      );
    },
    editSelectedRealEstate(id) {
       this.$modal.show(realEstateCreateModal,
        { 
          investmentAssets: this.allInvestmentAssets.filter(asset => asset.currency === this.currency),
          communes: this.communes,
          action: 'edit',
          realEstate: this.findRealEstateById(id)
        },
        { height: 'auto', width: '363px' },
      );
    },
    showAssetsModalButton() {
      this.$modal.show(realEstateCreateModalButton,
        { 
          investmentAssets: this.allInvestmentAssets.filter(asset => asset.currency === this.currency),
          communes: this.communes
        },
        { height: 'auto', width: '363px' },
      );
    },
    showMovementsModal(id) {
      this.selectedRealEstatesId = id;
      this.$modal.show(realEstateMovementsModal,
        { membershipType: 'normal' },
        { height: 'auto', styles: { 'max-height': '500px' } },
        { 'before-close': this.beforeClose },
      );
    },
    beforeClose() {
      this.$store.dispatch('getRealEstate');
    },
  },
  beforeMount() {
    this.$store.dispatch('setInvestmentAssetsTypes', this.investmentAssetsTypes);
  },
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap');
  .roboto {
    font-family: 'Roboto', sans-serif;
  }
</style>
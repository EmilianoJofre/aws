<template>
  <div class="mt-8">
    <div class="flex mt-1 -mb-4">
      <p class="text-lg font-bold  text-vl-blue">
        Instrumentos Personalizados
      </p>
      <button
        @click="showCreateAssetModal"
        class="focus:outline-none"
      >
        <img
          :src="require('../../../assets/images/icons/addNew.svg')"
          class="h-4 mt-1 ml-2 cursor-pointer"
          v-if="selectedSubAccountId"
        >
      </button>
    </div>
    <div class="mt-8 overflow-y-auto h-36">
      <custom-table
        :with-checkbox="true"
        :currency="currency"
        :headers="headers"
        :table-data="customMemberships"
        @row-clicked="showMovementsModal"
        :class="`${customMemberships.length === 0 ? '' : 'border-b-2 border-vl-value'}`"
      />
      <div
        class="flex content-center justify-center border-b-2 border-vl-value text-vl-gray-400"
        v-if="customMemberships.length === 0"
      >
        <p class="my-5 text-center text-vl">
          {{ $t('message.memberships.selectSubAccount') }}
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import customAssetCreateModal from './custom-asset-create-modal.vue';
import membershipMovementsModal from './membership-movements-modal.vue';
import CustomTable from './table.vue';

export default {
  data() {
    return {
      headers: [
        { title: 'name', tooltip: true, tooltipCols: ['name'] },
        { title: 'quotasBalance', filter: 'number' },
        { title: 'quotaAveragePrice', filter: 'quantity' },
        { title: 'amountInvestedBalance', headerTooltip: 'amountInvestedBalanceTooltip', filter: 'integerCurrency' },
        { title: 'updatedQuotaAveragePrice', filter: 'currency' },
        { title: 'amountUpdatedBalance', filter: 'integerCurrency' },
        { title: 'incomesBalance', filter: 'integerCurrency', showAll:true },
        { title: 'incomesPercentage', filter: 'percent', showAll:true},
        { title: 'relativeWeight', headerTooltip: 'relativeWeightInvesmentsToolTip', filter: 'percent', showAll:true },
      ],
    };
  },
  computed: {
    selectedSubAccountId() {
      return this.$store.state.subAccounts.selectedSubAccountId;
    },
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    customMemberships() {
      return this.$store.getters.nomalizedCustomMemberships;
    },
    selectedMembershipId: {
      get() {
        return this.$store.state.membership.selectedMembershipId;
      },
      set(id) {
        this.$store.dispatch('setSelectedMembershipId', id);
      },
    },
  },
  components: {
    CustomTable,
  },
  methods: {
    showCreateAssetModal() {
      this.$modal.show(customAssetCreateModal,
        { },
        { height: 'auto', width: '363px' },
      );
    },
    showMovementsModal(id) {
      this.selectedMembershipId = id;
      this.$modal.show(membershipMovementsModal,
        { membershipType: 'custom', updateable: true },
        { height: 'auto' },
        { 'before-close': this.beforeClose },
      );
    },
    beforeClose() {
      this.$store.dispatch('getCustomMemberships');
    },
  },
};
</script>

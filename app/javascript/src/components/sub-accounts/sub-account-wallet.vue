<template>
  <div class="mt-8">
    <loading v-if="loading" />
    <span v-if="error">{{ error }}</span>
    <div
      v-else
      class="grid w-full h-full grid-cols-2 gap-x-16"
    >
      <div>
        <div class="flex mt-1 -mb-4">
          <p class="text-lg font-bold text-vl-blue">
            {{ $t('message.walletMovements.type.deposit') }}
          </p>
          <button class="focus:outline-none">
            <img
              :src="require('../../../../assets/images/icons/addNew.svg')"
              class="h-4 mt-1 ml-2 cursor-pointer"
              @click="openCreateModal('deposit')"
              v-if="selectedSubAccountId"
            >
          </button>
        </div>
        <table-wrapper
          :currency="currency"
          :empty-message="$t('message.walletMovements.selectSubAccount.deposit')"
          :headers="headers"
          :table-data="deposits"
          :show-edit="true"
          @edit-clicked="(id) => editSelectedMovement(id, 'deposit')"
          class="border-b-2 border-vl-value text-vl-gray-400"
        />
      </div>
      <div>
        <div class="flex mt-1 -mb-4">
          <p class="text-lg font-bold text-vl-blue">
            {{ $t('message.walletMovements.type.withdraw') }}
          </p>
          <button class="focus:outline-none">
            <img
              :src="require('../../../../assets/images/icons/addNew.svg')"
              class="h-4 mt-1 ml-2 cursor-pointer"
              @click="openCreateModal('withdraw')"
              v-if="selectedSubAccountId"
            >
          </button>
        </div>
        <table-wrapper
          :currency="currency"
          :empty-message="$t('message.walletMovements.selectSubAccount.withdrawal')"
          :headers="headers"
          :table-data="withdrawals"
          :show-edit="true"
          @edit-clicked="(id) => editSelectedMovement(id, 'withdraw')"
          class="border-b-2 border-vl-value text-vl-gray-400"
        />
      </div>
    </div>
  </div>
</template>

<script>
import TableWrapper from '../shared/table-wrapper.vue';
import WalletCreateMovementModal from './wallet-create-movement-modal.vue';

export default {
  components: { TableWrapper },
  data() {
    return {
      error: null,
      headers: [
        { title: 'date', filter: 'date' },
        { title: 'amount', filter: 'currency' },
        { title: 'comment', tooltip: true, tooltipCols: ['comment'] },
      ],
    };
  },
  methods: {
    openModal(action, movementType, movementId = null) {
      this.$modal.show(WalletCreateMovementModal,
        {
          movementType,
          subAccountId: this.selectedSubAccountId,
          action,
          movement: this.findMovementById(movementId, movementType),
        },
        { height: 'auto', width: '363px' },
        { closed: () => this.$store.dispatch('getWalletMovements') },
      );
    },
    openCreateModal(movementType) {
      this.openModal('create', movementType);
    },
    editSelectedMovement(id, movementType) {
      this.openModal('edit', movementType, id);
    },
    findMovementById(id, movementType) {
      if (movementType === 'deposit') return this.deposits.find((deposit) => deposit.id === id);

      return this.withdrawals.find((withdrawal) => withdrawal.id === id);
    },
  },
  computed: {
    selectedSubAccountId() {
      return this.$store.state.subAccounts.selectedSubAccountId;
    },
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    deposits() {
      return this.$store.state.wallet.deposits;
    },
    withdrawals() {
      return this.$store.state.wallet.withdrawals;
    },
    loading() {
      return this.$store.state.wallet.loading;
    },
  },
};
</script>

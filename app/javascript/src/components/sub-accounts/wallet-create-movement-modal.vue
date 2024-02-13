<template>
  <modal
    @confirm-clicked="postAction"
    @close="$emit('close')"
    @delete-clicked="deleteAction"
    :action-text="$t(`message.walletMovements.type.${movementType}`)"
    :confirm-text="$t(`message.walletMovements.actions.${action === 'edit' ? 'edit' : movementType}`)"
    :delete-text="action === 'edit' ? $t('message.walletMovements.actions.delete') : null"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="container">
        <div class="flex flex-col items-center justify-center">
          <div>
            <p class="pb-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.amount') }}</p>
            <input
              type="number"
              class="px-2 -ml-1 inputStyle fontFamily"
              min="1"
              v-model="data.amount"
            >
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.date') }}</p>
            <input
              type="date"
              class="px-2 -ml-1 inputStyle fontFamily"
              min="1"
              v-model="data.date"
            >
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2 pb-8">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.comment') }}</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              placeholder="Agrega un comentario"
              v-model="data.comment"
            >
          </div>
        </div>
      </div>
    </template>
  </modal>
</template>

<script>
import Modal from '../shared/modal.vue';
import WalletMovementsApi from '../../api/wallet-movements';

export default {
  components: { Modal },
  props: {
    action: { type: String, default: 'create' },
    movement: { type: Object, default: () => ({}) },
    movementType: { type: String, required: true },
    subAccountId: { type: Number, required: true },
  },
  data() {
    return {
      data: {
        amount: this.movement.amount || 0,
        comment: this.movement.comment || '',
        // eslint-disable-next-line no-magic-numbers
        date: this.movement.date || (new Date()).toISOString().slice(0, 10),
      },
      deleteCounter: 0,
      error: null,
      loading: false,
    };
  },
  methods: {
    postAction() {
      this.loading = true;
      if (this.action === 'create') {
        this.postCall(this.subAccountId, this.data)
          .then(() => {
            this.error = null;
            this.$emit('close');
          })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      } else if (this.action === 'edit') {
        this.editCall(this.subAccountId, this.movement.id, this.data)
          .then(() => {
            this.error = null;
            this.$emit('close');
          })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      }
    },
    deleteAction() {
      if (this.deleteCounter++ === 0) {
        this.error = this.$t('message.walletMovements.actions.confirm.delete');
      } else {
        this.deleteCounter = 0;
        this.loading = true;
        this.deleteCall(this.subAccountId, this.movement.id)
          .then(() => {
            this.error = null;
            this.$store.dispatch('getWalletMovements');
            this.$emit('close');
          })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      }
    },
  },
  computed: {
    postCall() {
      if (this.movementType === 'deposit') {
        return WalletMovementsApi.createWalletDeposit;
      }

      return WalletMovementsApi.createWalletWithdrawal;
    },
    editCall() {
      if (this.movementType === 'deposit') {
        return WalletMovementsApi.editWalletDeposit;
      }

      return WalletMovementsApi.editWalletWithdrawal;
    },
    deleteCall() {
      if (this.movementType === 'deposit') {
        return WalletMovementsApi.deleteWalletDeposit;
      }

      return WalletMovementsApi.deleteWalletWithdrawal;
    },
  },
};
</script>

<style scoped>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');
  .inputStyle {
    width: 300px;
    height: 45px;
    border: 1px solid #C2C7CF;
    border-radius: 5px;
  }
  .fontFamily {
    font-family: 'Inter', sans-serif;
  }
  .container {
    width: 363px;
    height: auto;
  }
</style>
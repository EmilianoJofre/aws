<template>
  <modal
    @confirm-clicked="clickAction"
    @close="$emit('close')"
    @delete-clicked="deleteAction"
    :action-text="$t(`message.moneyMovements.actions.create.${movementType}`)"
    :confirm-text="$t(`message.moneyMovements.actions.${action}.${movementType}`)"
    :delete-text="action === 'edit' ? $t('message.moneyMovements.actions.delete') : null"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="grid grid-cols-2 mx-6 mb-4 gap-x-4 gap-y-4">
        <div>
          <p>{{ $t('message.tableHeaders.quotasBalance') }}</p>
          <input
            @keypress="preventNumericInput($event)"
            type="number"
            class="w-full p-1 border border-gray-400 rounded quantity-action"
            min="1"
            v-model="data.quotas"
          >
        </div>
        <div>
          <p>{{ $t('message.tableHeaders.averagePrice') }}</p>
          <input
            type="number"
            class="w-full p-1 border border-gray-400 rounded"
            min="-99999999999999"
            v-model="data.averagePrice"
          >
        </div>
        <div class="col-span-2 mx-auto">
          <p>{{ $t('message.tableHeaders.date') }}</p>
          <input
            type="date"
            class="w-full p-1 border border-gray-400 rounded"
            v-model="data.date"
            :max="today"
          >
        </div>
      </div>
    </template>
  </modal>
</template>
<script>
import Modal from './shared/modal.vue';
import MoneyMovementsApi from '../api/money-movements';

export default {
  components: { Modal },
  props: {
    action: { type: String, default: 'create' },
    movementType: { type: String, required: true },
    selectedId: { type: Number, required: true },
    moneyMovement: { type: Object, default: () => ({ attributes: {} }) },
  },
  data() {
    const averagePrice = this.moneyMovement.attributes.averagePrice || 0;
    // eslint-disable-next-line no-magic-numbers
    const today = (new Date()).toISOString().slice(0, 10);
    // eslint-disable-next-line no-magic-numbers
    const date = this.moneyMovement.attributes.date ? this.moneyMovement.attributes.date.slice(0, 10) : today;
    const quotas = this.moneyMovement.attributes.quotas || 0;

    return {
      today,
      deleteCounter: 0,
      data: {
        quotas,
        averagePrice,
        date,
      },
      loading: false,
      error: null,
    };
  },
  computed: {
    selectedMembershipId() {
      return this.$store.state.memberships.selectedMembershipId;
    },
  },
  methods: {
    clickAction() {
      this.loading = true;
      if (this.action === 'create') {
        this.postMoneyMovement();
      } else if (this.action === 'edit') {
        this.editMoneyMovement();
      }
    },
    deleteAction() {
      if (this.deleteCounter++ === 0) {
        this.error = this.$t('message.moneyMovements.actions.confirm.delete');
      } else {
        this.deleteCounter = 0;
        this.loading = true;
        MoneyMovementsApi.destroyMoneyMovement(this.selectedId, this.moneyMovement)
          .then(() => {
            this.error = null;
            this.$emit('close');
          })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      }
    },
    editMoneyMovement() {
      const params = { ...this.data, ...{ movementType: this.movementType } };
      MoneyMovementsApi.editMoneyMovement(this.moneyMovement, params)
        .then(() => {
          this.error = null;
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    postMoneyMovement() {
      const params = { ...this.data, ...{ movementType: this.movementType } };
      MoneyMovementsApi.createMoneyMovement(this.selectedId, params)
        .then(() => {
          this.error = null;
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    preventNumericInput($event) {
      var keyCode = ($event.keyCode ? $event.keyCode : $event.which);
      if (!((keyCode > 47 && keyCode < 58) || (keyCode === 188 || keyCode === 44 || $event.key === ','))) $event.preventDefault();
    }
  },
};
</script>

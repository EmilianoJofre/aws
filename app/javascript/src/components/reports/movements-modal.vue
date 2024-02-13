<template>
  <div class="lg:h-64">
    <img
      :src="require('assets/images/icons/close.svg')"
      class="mt-2 ml-auto mr-2 cursor-pointer"
      @click="$emit('close')"
    >
    <loading v-if="loading" />
    <div
      v-else
      class="grid h-full grid-cols-1 px-8 pt-4 pb-8 overflow-y-scroll gap-x-4 lg:grid-cols-2"
    >
      <div class="h-full overflow-y-scroll">
        <p class="font-bold text-primary">
          {{ $t('message.walletMovements.type.deposits') }}
        </p>
        <p v-if="!deposits.length">
          {{ $t('message.walletMovements.type.noMonthDeposits') }}
        </p>
        <div
          v-for="(deposit, key) in deposits"
          class="p-2 mb-4 border rounded border-vl-gray bg-vl-gray-lightest"
          :key="key"
        >
          <p><span class="mr-2 underline">Fecha:</span>{{ deposit.date | dateTime }}</p>
          <p><span class="mr-2 underline">Monto:</span>{{ deposit.amount | currency }}</p>
          <p>
            <span class="mr-2 underline">Comentario:</span>
            {{ deposit.comment }}
          </p>
        </div>
      </div>
      <div class="h-full lg:overflow-y-scroll">
        <p class="font-bold text-primary">
          {{ $t('message.walletMovements.type.withdrawals') }}
        </p>
        <p v-if="!withdrawals.length">
          {{ $t('message.walletMovements.type.noMonthWithdrawals') }}
        </p>
        <div
          v-for="(withdrawal, key) in withdrawals"
          class="p-2 border rounded border-vl-gray bg-vl-gray-lightest"
          :key="key"
        >
          <p><span class="mr-2 underline">Fecha:</span>{{ withdrawal.date | dateTime }}</p>
          <p><span class="mr-2 underline">Monto:</span>{{ withdrawal.amount | currency }}</p>
          <p>
            <span class="mr-2 underline">Comentario:</span>
            {{ withdrawal.comment }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import WalletMovementsApi from '../../api/wallet-movements';

export default {
  props: {
    month: { type: Date, required: true },
    relationId: { type: Number, required: true },
  },
  data() {
    return {
      deposits: [],
      loading: false,
      withdrawals: [],
    };
  },
  mounted() {
    this.loading = true;
    this.getMovements();
  },
  methods: {
    getMovements() {
      WalletMovementsApi.getWalletMonthDeposits(this.relationId, { month: this.month })
        .then((response) => { this.deposits = response.walletDeposits; })
        .finally(() => { this.loading = false; });

      WalletMovementsApi.getWalletMonthWithdrawals(this.relationId, { month: this.month })
        .then((response) => { this.withdrawals = response.walletWithdrawals; })
        .finally(() => { this.loading = false; });
    },
  },
};
</script>

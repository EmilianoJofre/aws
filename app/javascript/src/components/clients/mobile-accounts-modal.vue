<template>
  <div class="fixed inset-0 z-30 pt-10 overflow-y-auto bg-white text-vl-blue lg:hidden">
    <div class="flex flex-row justify-between px-4 py-4 mb-6 border-b text-vl-blue border-secondary">
      <button
        class="font-semibold focus:outline-none"
        @click="cancel"
      >
        {{ $t('message.clientBalances.accounts.cancel') }}
      </button>
      <button
        class="font-semibold focus:outline-none"
        :class="{ 'text-vl-gray-light': noAccountSelected }"
        :disabled="noAccountSelected"
        @click="save"
      >
        {{ $t('message.clientBalances.accounts.save') }}
      </button>
    </div>
    <div class="text-xl font-bold text-center text-vl-blue">
      {{ $t('message.clientBalances.accounts.selectTitle') }}
    </div>
    <accounts-selector
      v-on="$listeners"
      :accounts="accounts"
      :banks="banks"
      :selected-accounts="selectedAccounts"
      :selected-banks="selectedBanks"
      @update="updateAccountsToSelect"
    />
  </div>
</template>
<script>
import AccountsSelector from './accounts-selector.vue';

export default {
  components: {
    AccountsSelector,
  },
  props: {
    accounts: { type: Array, required: true },
    banks: { type: Object, required: true },
    selectedAccounts: { type: Array, required: true },
    selectedBanks: { type: Array, required: true },
  },
  data() {
    return {
      accountsToSelect: this.selectedAccounts,
    };
  },
  computed: {
    noAccountSelected() {
      return this.accountsToSelect.length === 0;
    },
  },
  methods: {
    cancel() {
      this.$emit('cancel');
    },
    save() {
      this.$emit('save', this.accountsToSelect);
    },
    updateAccountsToSelect(accountsToSelect) {
      this.accountsToSelect = accountsToSelect;
    },
  },
};
</script>

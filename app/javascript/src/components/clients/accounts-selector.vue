<template>
  <div>
    <div class="flex flex-row justify-center my-4 space-x-1 text-sm lg:space-x-4 lg:justify-start">
      <vl-multiselect
        :items="banks"
        :selected-items="banksToSelect"
        :title="$t('message.clientBalances.multiselectBanks.banks')"
        :special-subtitle="specialSubtitle"
        class="mb-3"
        @update="changeSelectedBanks"
        @update-all="changeAllBanks"
      />
      <icon-btn
        icon-classes="w-6 fill-current text-vl-gray-200 fill-current"
        icon-name="check"
        text-classes="normal-case text-vl-gray underline"
        :text="$t('message.clientBalances.accounts.selectAll')"
        @click="selectAllAccounts"
      />
      <icon-btn
        icon-classes="w-6 fill-current text-vl-gray-200 fill-current"
        icon-name="close"
        text-classes="normal-case text-vl-gray underline"
        :text="$t('message.clientBalances.accounts.clear')"
        @click="accountsToSelect = []"
      />
    </div>
    <div class="flex flex-row flex-wrap justify-center my-4 ml-3 lg:justify-start lg:ml-0">
      <span
        v-for="(account) in accounts"
        :key="account.id"
      >
        <div
          class="flex flex-col h-12 px-6 py-2 mb-3 mr-3 leading-none text-center rounded-md justify-evenly"
          :class="balanceSelectedClasses(account.id)"
          @click="changeSelectedAccounts(account.id)"
        >
          <p class="text-sm cursor-pointer">{{ account.name }}</p>
          <p class="text-sm cursor-pointer lg:text-xs">{{ account.bank.name }}</p>
        </div>
      </span>
    </div>
  </div>
</template>
<script>

export default {
  props: {
    accounts: { type: Array, required: true },
    banks: { type: Object, required: true },
    selectedAccounts: { type: Array, required: true },
    selectedBanks: { type: Array, required: true },
  },
  data() {
    return {
      accountsToSelect: this.selectedAccounts,
      banksToSelect: this.selectedBanks,
    };
  },
  mounted() {
    this.selectAllAccounts();
  },
  computed: {
    specialSubtitle() {
      if (this.accountsToSelect.length > 1) {
        const associatedBanks = this.accounts.filter(account => this.accountsToSelect.includes(account.id))
          .map(account => account.bank.id);

        return new Set(associatedBanks).size > 1;
      }

      return false;
    },
  },
  methods: {
    balanceSelectedClasses(key) {
      const selectedClass = 'bg-vl-blue text-white';
      const notSelectedClass = 'bg-vl-blue-light text-vl-blue cursor-pointer';

      return this.accountsToSelect.includes(key) ? selectedClass : notSelectedClass;
    },
    changeAllBanks() {
      const allBanks = Object.keys(this.banks).map((key) => Number(key));
      if (this.banksToSelect.length === allBanks.length) {
        this.banksToSelect = [];
      } else {
        this.banksToSelect = allBanks;
      }
      this.updateSelectedAccounts();
    },
    changeSelectedAccounts(id) {
      this.changeSelection('accountsToSelect', id);
    },
    changeSelectedBanks(id) {
      this.changeSelection('banksToSelect', id);
      this.updateSelectedAccounts();
    },
    changeSelection(array, id) {
      if (this[array].includes(id)) {
        this[array] = this[array].filter(element => element !== id);
      } else {
        this[array].push(id);
      }
    },
    selectAllAccounts() {
      this.accountsToSelect = this.accounts.map((account) => account.id);
    },
    updateSelectedAccounts() {
      this.accountsToSelect = [];
      this.accounts.forEach((account) => {
        if (this.banksToSelect.includes(account.bank.id)) {
          this.accountsToSelect.push(account.id);
        }
      });
    },
    updateSelectedBanks() {
      this.banksToSelect = Object.keys(this.banks).map(Number);
      this.accounts.forEach((account) => {
        if (!this.accountsToSelect.includes(account.id)) {
          this.banksToSelect = this.banksToSelect.filter(element => element !== account.bank.id);
        }
      });
    },
  },
  watch: {
    accountsToSelect() {
      this.updateSelectedBanks();
      this.$emit('update', this.accountsToSelect);
    },
  },
};
</script>

<template>
  <div class="mt-8">
    <div class="flex mt-1 -mb-4">
      <p class="text-lg font-bold text-vl-blue">
        Subcuentas
      </p>
      <button
        @click="showModal"
        class="focus:outline-none"
      >
        <img
          :src="require('../../../assets/images/icons/addNew.svg')"
          class="h-4 mt-1 ml-2 cursor-pointer"
          v-if="selectedAccountId && selectedType !== ''"
        >
      </button>
    </div>
    <table-wrapper
      :empty-message="$t('message.subAccounts.selectAccount')"
      :headers="headers"
      :table-data="subAccounts"
      @row-clicked="setSelectedSubAccountId"
      :show-edit="true"
      @edit-clicked="editSelectedSubAccount"
      class="border-b-2 border-vl-value text-vl-gray-400"
    />
  </div>
</template>
<script>
import subAccountsModal from './sub-accounts-create-modal.vue';
import TableWrapper from './shared/table-wrapper.vue';

export default {
  props: {
    isDemo: { type: Boolean, default: false },
    currencies: { type: Array, required: true },
    propertiesTypes: { type: Array, required: true },
  },
  components: { TableWrapper },
  methods: {
    findSubAccountById(id) {
      return this.subAccounts.find((subAccount) => subAccount.id === Number(id));
    },
    showModal() {
      this.$modal.show(subAccountsModal,
        { 
          currencies: this.currencies, 
          propertiesTypes: this.propertiesTypes
        },
        { height: 'auto', width: '363px' },
      );
    },
    editSelectedSubAccount(id) {
      this.$modal.show(subAccountsModal,
        { currencies: this.currencies, subAccount: this.findSubAccountById(id), action: 'edit' },
        { height: 'auto', width: '363px' },
      );
    },
    setSelectedSubAccountId(id) {
      this.$store.dispatch('setSelectedSubAccountId', { id, isDemo: this.isDemo });
      this.$emit('sub-account-selected');
    },
  },
  computed: {
    subAccounts() {
      return this.$store.state.subAccounts.subAccounts;
    },
    selectedAccountId() {
      return this.$store.state.accounts.selectedAccountId;
    },
    selectedType() {
      return this.$store.state.relations.selectedActiveTypeSelector;
    },
    headers() {
      return [
        { title: `${this.selectedType  === 'real_estate' ? 'propertyType' : 'subAccountId'}` },
        { title: 'currency' }, 
      ]
    },
    selectedSubAccountId: {
      get() {
        return this.$store.state.subAccounts.selectedSubAccountId;
      },
      set(id) {
        this.$store.dispatch('setSelectedSubAccountId', { id, isDemo: this.isDemo });
      },
    },
  },
};
</script>

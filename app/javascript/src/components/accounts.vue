<template>
  <div class="mt-8">
    <div class="flex mt-1 -mb-4">
      <p class="text-lg font-bold text-vl-blue">
        Cuentas
      </p>
      <button
        @click="showModal"
        class="focus:outline-none"
      >
        <img
          :src="require('../../../assets/images/icons/addNew.svg')"
          class="h-4 mt-1 ml-2 cursor-pointer"
          v-if="selectedRelationId && selectedType !== ''"
        >
      </button>
    </div>
    <table-wrapper
      :headers="headers"
      :table-data="formatAccounts"
      :show-edit="true"
      @row-clicked="setSelectedAccountId"
      @edit-clicked="editSelectedAccount"
      :empty-message="$t('message.accounts.selectRelation')"
      class="border-b-2 border-vl-value text-vl-gray-400"
    />
  </div>
</template>
<script>
import accountsModal from './accounts-create-modal.vue';
import TableWrapper from './shared/table-wrapper.vue';

export default {
  props: {
    isDemo: { type: Boolean, default: false },
    banks: {
      type: Array,
      required: true,
    },
  },

  components: { TableWrapper },
  methods: {
    findAccountById(id) {
      return this.accounts.find((account) => account.id === Number(id));
    },
    showModal() {
      this.$modal.show(accountsModal,
        { banks: this.banks },
        { height: 'auto', width: '363px' },
      );
    },
    editSelectedAccount(id) {
      this.$modal.show(accountsModal,
        { banks: this.banks, account: this.findAccountById(id), action: 'edit' },
        { height: 'auto', width: '363px' },
      );
    },
    setSelectedAccountId(id) {
      this.$store.dispatch('setSelectedAccountId', { id, isDemo: this.isDemo });
    },
  },
  computed: {
    accounts() {
      return this.$store.state.accounts.accounts;
    },
    selectedRelationId() {
      return this.$store.state.relations.selectedRelationId;
    },
    selectedType() {
      return this.$store.state.relations.selectedActiveTypeSelector;
    },
    formatAccounts() {
      return this.$store.state.accounts.accounts.map(account => (
        {
          id: account.id,
          name: account.name,
          rut: account.rut,
          email: account.email,
          bank: account.bank.name,
        }
      ));
    },
    headers() {
      return [
        { title: 'name' },
        { title: 'rut' },
        { title: 'email' },
        { title: 'bank' },
      ].filter(header => this.selectedType  === 'real_estate' ? header.title !== 'bank' : header)
    },
    selectedAccountId: {
      get() {
        return this.$store.state.accounts.selectedAccountId;
      },
      set(id) {
        this.$store.dispatch('setSelectedAccountId', { id, isDemo: this.isDemo });
      },
    },
  },
};
</script>

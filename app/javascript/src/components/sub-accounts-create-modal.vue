<template>
  <modal
    @confirm-clicked="clickAction"
    @close="$emit('close')"
    @delete-clicked="deleteAction"
    :action-text="$t(`message.subAccounts.actions.${action}`)"
    :confirm-text="$t(`message.subAccounts.actions.confirm.${action}`)"
    :delete-text="action === 'edit' ? $t('message.subAccounts.actions.delete') : null"
    :error="error"
    :loading="loading"
    :classes="modal-override"
  >
    <template #input>
      <div class="container">
        <div class="flex flex-col items-center justify-center" 
        v-if="selectedType !== 'real_estate'">
          <div>
            <p class="pb-2 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.subAccountId') }}</p>
            <input
              v-model="data['subAccountId']"
              type="text"
              class="px-2 inputStyle fontFamily"
              placeholder="Ingrese el Nombre"
            >
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2" 
        v-if="selectedType === 'real_estate'">
          <div>
            <p class="py-2 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.propertyType') }}</p>
            <v-select
              :options="propertiesTypes"
              :clearable="false"
              v-model="data['subAccountId']"
              :append-to-body="true"
              class="currency"
            />
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2 pb-8">
          <div>
            <p class="py-2 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.currency') }}</p>
            <v-select
              :options="currencies"
              :clearable="false"
              v-model="data['currency']"
              :append-to-body="true"
              class="currency"
              placeholder="Seleccione la Moneda"
            />
          </div>
        </div>
      </div>
    </template>
  </modal>
</template>
<script>
import { decamelizeKeys } from 'humps';
import Modal from './shared/modal.vue';
import SubAccountsApi from '../api/sub-accounts';

export default {
  components: { Modal },
  props: {
    currencies: { type: Array, required: true },
    propertiesTypes: { type: Array, required: true },
    subAccount: { type: Object, default: () => ({ }) },
    action: { type: String, default: 'create' },
  },
  data() {
    return {
      data: {
        subAccountId: this.subAccount.subAccountId || '',
        currency: this.subAccount.currency || '',
        id: this.subAccount.id,
      },
      deleteCounter: 0,
      error: null,
      loading: false,
    };
  },
  computed: {
    selectedAccountId() {
      return this.$store.state.accounts.selectedAccountId;
    },
    selectedType() {
      return this.$store.state.relations.selectedActiveTypeSelector;
    },
  },
  methods: {
    deleteAction() {
      if (this.deleteCounter++ === 0) {
        this.error = this.$t('message.subAccounts.actions.confirm.delete');
      } else {
        this.deleteCounter = 0;
        this.loading = true;
        SubAccountsApi.deleteSubAccount(this.selectedAccountId, this.data)
          .then(() => {
            this.error = null;
            this.$store.dispatch('getSubAccounts');
            this.$emit('close');
          })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      }
    },
    postSubAccount() {
      const params = decamelizeKeys(this.data);
      SubAccountsApi.createSubAccount(this.selectedAccountId, params)
        .then((response) => {
          this.$store.dispatch('addSubAccount', response.subAccount);
          this.error = null;
          this.$emit('close');
        })
        .catch((error) => { this.error = error; });
    },
    editSubAccount() {
      SubAccountsApi.editSubAccount(this.selectedAccountId, this.data)
        .then(() => {
          this.error = null;
          this.$store.dispatch('getSubAccounts');
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    clickAction() {
      this.loading = true;
      if (this.action === 'create') {
        this.postSubAccount();
      } else if (this.action === 'edit') {
        this.editSubAccount();
      }
    },
  },
};
</script>
<style scoped lang="scss">
  @import 'vue-select/src/scss/vue-select.scss';
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');
  .inputStyle {
    width: 300px;
    height: 45px;
    border: 1px solid #C2C7CF;
    border-radius: 5px;
  }
  .currency {
    width: 300px;
    height: 45px;
  }
  .fontFamily {
    font-family: 'Inter', sans-serif;
  }
  .container {
    width: 363px;
    height: auto;
  }
 
</style>

<style>
  .vm--modal {
    border-radius: 6px !important
  }
  .vs__dropdown-toggle {
    width: 300px;
    height: 45px;
    border: 1px solid #C2C7CF;
    border-radius: 5px;
  }
</style>
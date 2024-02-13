<template>
  <modal
    @confirm-clicked="clickAction"
    @close="$emit('close')"
    @delete-clicked="deleteAction"
    :action-text="$t(`message.accounts.actions.${action}`)"
    :confirm-text="$t(`message.accounts.actions.confirm.${action}`)"
    :delete-text="action === 'edit' ? $t('message.accounts.actions.delete') : null"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="container">
        <div class="flex flex-col items-center justify-center">
          <div>
            <p class="pb-2 -ml-1 text-sm font-medium text-black fontFamily">{{ $t('message.tableHeaders.nameOrEnterprise') }}</p>
            <input
              v-model="data['name']"
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              placeholder="Nombre"
            >
          </div>
          <div class="flex flex-col items-center justify-center mt-2">
            <div>
              <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.rut') }}</p>
              <input
                v-model="data['rut']"
                type="text"
                class="px-2 -ml-1 inputStyle fontFamily"
                placeholder="11111111-1"
              >
            </div>
          </div>
        </div>
        <div :class="`flex flex-col items-center justify-center mt-2`">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.email') }}</p>
            <input
              v-model="data['email']"
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              placeholder="mail@dominio.com"
            >
          </div>

          <div class="flex flex-col items-center justify-center mt-2" v-if="selectedType !== 'real_estate'">
            <div>
              <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.bank') }}</p>
              <v-select
                :options="banks"
                :clearable="false"
                :reduce="bank => bank.id"
                v-model="data['bankId']"
                :append-to-body="true"
                class="-ml-1 bankStyle"
                :disabled="selectedType === 'real_estate'"
                label="label"
              />
            </div>
          </div>

          <div class="flex flex-col items-center justify-center mt-2 pb-8">
            <div>
              <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.accountType') }}</p>
              <input
                v-model="parsedSelectedType"
                type="text"
                class="px-2 -ml-1 inputStyle fontFamily"
                disabled
              >
            </div>
          </div>
        </div>
      </div>
    </template>
  </modal>
</template>
<script>
import { decamelizeKeys } from 'humps';
import AccountsApi from '../api/accounts';
import Modal from './shared/modal.vue';

export default {
  components: { Modal },
  props: {
    banks: { type: Array, required: true },
    account: { type: Object, default: () => ({ bank: {} }) },
    action: { type: String, default: 'create' },
  },
  data() {
    return {
      deleteCounter: 0,
      error: null,
      loading: false,
    };
  },
  computed: {
    selectedRelationId() {
      return this.$store.state.relations.selectedRelationId;
    },
    selectedType() {
      return this.$store.state.relations.selectedActiveTypeSelector;
    },
    parsedSelectedType() {
      const options = [ 
        {name: 'investment', parsedName: 'Inversiones'},
        {name: 'pension_fund', parsedName: 'Fondo de Pensiones'}, 
        {name: 'real_estate', parsedName: 'Bienes raíces'} 
      ]

      return options.find(option => option.name === this.selectedType).parsedName
    },
    data() {
      return {
        name: this.account.name || '',
        rut: this.account.rut || '',
        email: this.account.email || '',
        bankId: this.account.bank.id && `${this.selectedType === 'real_estate' ? this.banks.find(bank => bank.label === 'Sin Institución').id : ''}`,
        accountType: this.selectedType,
        id: this.account.id,
      }
    },
  },
  methods: {
    deleteAction() {
      if (this.deleteCounter++ === 0) {
        this.error = this.$t('message.accounts.actions.confirm.delete');
      } else {
        this.deleteCounter = 0;
        this.loading = true;
        AccountsApi.deleteAccount(this.selectedRelationId, this.data)
          .then(() => {
            this.error = null;
            this.$store.dispatch('getAccounts');
            this.$emit('close');
          })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      }
    },
    postAccount() {
      const params = decamelizeKeys(this.data);
      AccountsApi.createAccount(this.selectedRelationId, params)
        .then((response) => {
          this.$store.dispatch('addAccount', response.account);
          this.error = null;
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    editAccount() {
      AccountsApi.editAccount(this.selectedRelationId, this.data)
        .then(() => {
          this.error = null;
          this.$store.dispatch('getAccounts');
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    clickAction() {
      this.loading = true;
      if (this.action === 'create') {
        this.postAccount();
      } else if (this.action === 'edit') {
        this.editAccount();
      }
    },
  },
};
</script>
<style lang="scss">
  @import 'vue-select/src/scss/vue-select.scss';
</style>

<style scoped>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');
  .inputStyle {
    width: 300px;
    height: 45px;
    border: 1px solid #C2C7CF;
    border-radius: 5px;
  }
  .bankStyle {
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

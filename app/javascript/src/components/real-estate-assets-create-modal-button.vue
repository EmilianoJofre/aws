<template>
  <modal
    @confirm-clicked="postRealEstate"
    @close="$emit('close')"
    :action-text="$t('message.realEstateAssets.create.addExternal')"
    :confirm-text="$t('message.realEstateAssets.create.add')"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="container">
         <div class="flex flex-col items-center justify-center">
          <div>
            <p class="pb-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.realEstateAssets.role') }}</p>
            <v-select
              :options="roles"
              :clearable="false"
              :reduce="asset => asset.role"
              v-model="data['role']"
              :append-to-body="true"
              class="-ml-1 selectStyle"
              placeholder="Rol"
              label="role"
            />
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.realEstateAssets.investedBalance') }}</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              v-model="data['valorization']"
              placeholder="$ Monto"
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
              v-model="data['date']"
            >
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2 pb-8">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.realEstateAssets.institution') }}</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              v-model="data['valuer_name']"
              placeholder="Instituciones"
            >
          </div>
        </div>
      </div>
    </template>
  </modal>
</template>
<script>
import { decamelizeKeys } from 'humps';
import RealEstateApi from '../api/real-estate';
import Modal from './shared/modal.vue';
import SubAccountsApi from '../api/sub-accounts';
import investmentAssetsSuggestModal from './investment-assets-suggest-modal.vue';

export default {
  components: { Modal },
  props: {
    investmentAssets: { type: Array, required: true },
    communes: { type: Array, required: true },
  },
  data() {
    return {
      data: {
        valorization: '',
        role: '',
        date: null,
        valuer_name:''
      },
      error: null,
      loading: false,
      roles: []
    };
  },
  computed: {
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    selectedRelationId() {
      return this.$store.state.relations.selectedRelationId;
    },
    selectedSubAccountId() {
      return this.$store.state.subAccounts.selectedSubAccountId;
    },
  },
  methods: {
    postRealEstate() {
      this.loading = true;
      const params = decamelizeKeys(this.data);
      SubAccountsApi.searchMembership(this.selectedSubAccountId, params)
        .then((response) => {
            RealEstateApi.createExternalValorization(this.selectedSubAccountId, params)
              .then(() => {
                this.$store.dispatch('getRealEstate');
                this.error = null;
                this.$emit('close');
              })
              .catch((error) => { this.error = error; })
              .finally(() => { this.loading = false; });
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    showModal() {
      this.$modal.show(investmentAssetsSuggestModal,
        {},
        { height: 'auto' },
      );
    },
  },
  mounted() {
    RealEstateApi.getRoles(this.selectedSubAccountId).then((res) => this.roles = res.roles)
  }
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
  .selectStyle {
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
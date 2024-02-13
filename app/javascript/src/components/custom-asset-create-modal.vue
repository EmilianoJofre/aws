<template>
  <modal
    @confirm-clicked="postCustomAsset"
    @close="$emit('close')"
    :action-text="$t('message.investmentAssets.create.new')"
    :confirm-text="$t('message.investmentAssets.create.create')"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="container">
        <div class="flex flex-col items-center justify-center">
          <div>
            <p class="pb-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">Nombre</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              v-model="data.name"
              placeholder="Nombre de Instrumento"
            >
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">Tipo</p>
            <v-select
              :options="investmentAssetsTypes"
              :clearable="false"
              :reduce="assetType => assetType.id"
              v-model="data.assetType"
              :append-to-body="true"
              class="-ml-1 selectStyle"
              placeholder="Seleccione el Tipo"
            />
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2 pb-8">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.currency') }}</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              disabled
              v-model="currency"
            >
          </div>
         </div>
      </div>
    </template>
  </modal>
</template>
<script>
import { decamelizeKeys } from 'humps';
import InvestmentAssetApi from '../api/investment-assets';
import SubAccountsApi from '../api/sub-accounts';
import MembershipsApi from '../api/memberships';
import Modal from './shared/modal.vue';

export default {
  components: { Modal },
  data() {
    return {
      data: {
        name: '',
        assetType: '',
      },
      error: null,
      loading: false,
    };
  },
  computed: {
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    investmentAssetsTypes() {
      return this.$store.state.investmentAssets.investmentAssetsTypes;
    },
    selectedSubAccountId() {
      return this.$store.state.subAccounts.selectedSubAccountId;
    },
  },
  methods: {
    postCustomAsset() {
      this.loading = true;
      const params = decamelizeKeys({ ...this.data, ...{ currency: this.currency } });
      SubAccountsApi.searchMembership(this.selectedSubAccountId, params)
        .then((response) => {
          if (response.membership) {
            MembershipsApi.enableMembership(response.membership.id)
              .then((enableResponse) => {
                this.$store.dispatch('addCustomMembership', enableResponse.membership);
                this.error = null;
                this.$emit('close');
              })
              .catch((error) => { this.error = error; })
              .finally(() => { this.loading = false; });
          } else {
            InvestmentAssetApi.createCustomAsset(this.selectedSubAccountId, params)
              .then((createResponse) => {
                this.$store.dispatch('addCustomMembership', createResponse.membership);
                this.error = null;
                this.$emit('close');
              })
              .catch((error) => { this.error = error; })
              .finally(() => { this.loading = false; });
          }
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
  },
};
</script>
<style lang="scss" scoped>
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
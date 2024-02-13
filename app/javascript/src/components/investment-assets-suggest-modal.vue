<template>
  <modal
    @confirm-clicked="postInvestmentAsset"
    @close="$emit('close')"
    :action-text="$t('message.investmentAssets.create.new')"
    :confirm-text="$t('message.investmentAssets.create.suggest')"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="flex mb-4">
        <div class="w-1/2 ml-6 mr-2">
          <p>{{ $t('message.tableHeaders.name') }}</p>
          <input
            placeholder="SPDR S&P 500 ETF Trust"
            type="text"
            class="w-full p-1 border border-gray-400 rounded"
            v-model="data.name"
          >
        </div>
        <div class="w-1/2 ml-2 mr-6">
          <p>{{ $t('message.tableHeaders.ticker') }}</p>
          <input
            placeholder="SYP"
            type="text"
            class="w-full p-1 border border-gray-400 rounded"
            v-model="data.assetId"
          >
        </div>
      </div>
      <div class="flex mb-4">
        <div class="w-1/2 ml-6 mr-2">
          <p>{{ $t('message.tableHeaders.type') }}</p>
          <v-select
            :options="investmentAssetsTypes"
            :clearable="false"
            :reduce="assetType => assetType.id"
            v-model="data.assetType"
            :append-to-body="true"
          />
        </div>
        <div class="w-1/2 ml-2 mr-6">
          <p>{{ $t('message.tableHeaders.currency') }}</p>
          <input
            type="text"
            class="w-full p-1 border border-gray-400 rounded"
            disabled
            v-model="currency"
          >
        </div>
      </div>
    </template>
  </modal>
</template>
<script>
import { decamelizeKeys } from 'humps';
import InvestmentAssetApi from '../api/investment-assets';
import Modal from './shared/modal.vue';

export default {
  components: { Modal },
  data() {
    return {
      data: {
        assetId: '',
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
  },
  methods: {
    postInvestmentAsset() {
      this.loading = true;
      const params = decamelizeKeys({ ...this.data, ...{ currency: this.currency } });
      InvestmentAssetApi.createInvestmentAsset(params)
        .then(() => {
          this.error = null;
          this.notify();
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    notify() {
      this.$notify({
        group: 'suggest-asset',
        title: 'Instrumento sugerido',
        text: `${this.data.name}[${this.data.assetId}] fue sugerido, tardará unos minutos en estar disponible.`,
      });
    },
  },
};
</script>
<style lang="scss">
  @import 'vue-select/src/scss/vue-select.scss';
</style>

<template>
  <modal
    @confirm-clicked="createPriceChange"
    @close="$emit('close')"
    :action-text="$t('message.priceChange.new')"
    :confirm-text="$t('message.priceChange.update')"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="mx-4">
        <input
          type="number"
          class="w-full p-1 border border-gray-400 rounded"
          min="1"
          v-model="data.value"
        >
      </div>
    </template>
  </modal>
</template>
<script>
import { decamelizeKeys } from 'humps';
import Modal from './shared/modal.vue';
import PriceChangesApi from '../api/price-changes';

export default {
  components: { Modal },
  data() {
    return {
      data: {
        value: 0,
      },
      error: null,
      loading: false,
    };
  },
  computed: {
    selectedInvestmentAssetId() {
      return this.$store.getters.selectedCustomInvestmentAssetId;
    },
  },
  methods: {
    createPriceChange() {
      this.loading = true;
      const params = decamelizeKeys(this.data);
      PriceChangesApi.createPriceChange(this.selectedInvestmentAssetId, params)
        .then(() => {
          this.error = null;
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
  },
};
</script>

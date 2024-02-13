<template>
  <modal
    @confirm-clicked="postMembership"
    @close="$emit('close')"
    :action-text="$t('message.investmentAssets.create.add')"
    :confirm-text="$t('message.investmentAssets.create.add')"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="container">
        <div class="flex flex-col items-center justify-center">
          <div>
            <p class="pb-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.investmentAssets.ticker') }}</p>
            <v-select
              :options="investmentAssets"
              :clearable="false"
              :reduce="asset => asset.id"
              v-model="data['investmentAssetId']"
              :append-to-body="true"
              class="-ml-1 selectStyle"
            />
            <a
              class="text-xs font-medium text-black cursor-pointer fontFamily hover:underline"
              @click="showModal"
            >
              {{ $t('message.investmentAssets.notFound') }}
            </a>
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
              placeholder="Seleccione el Instrumento"
            >
          </div>
        </div>
      </div>
    </template>
  </modal>
</template>
<script>
import { decamelizeKeys } from 'humps';
import PensionFundsApi from '../api/pension-funds';
import Modal from './shared/modal.vue';
import SubAccountsApi from '../api/sub-accounts';
import investmentAssetsSuggestModal from './investment-assets-suggest-modal.vue';

export default {
  components: { Modal },
  props: {
    investmentAssets: { type: Array, required: true },
  },
  data() {
    return {
      data: {
        investmentAssetId: '',
      },
      error: null,
      loading: false,
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
    postMembership() {
      this.loading = true;
      const params = decamelizeKeys(this.data);
      SubAccountsApi.searchMembership(this.selectedSubAccountId, params)
        .then((response) => {
          if (response.membership) {
            PensionFundsApi.enablePensionFunds(response.membership.id)
              .then(() => {
                this.$store.dispatch('getPensionFunds');
                this.error = null;
                this.$emit('close');
              })
              .catch((error) => { this.error = error; })
              .finally(() => { this.loading = false; });
          } else {
            PensionFundsApi.createPensionFunds(this.selectedSubAccountId, params)
              .then(() => {
                this.$store.dispatch('getPensionFunds');
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
    showModal() {
      this.$modal.show(investmentAssetsSuggestModal,
        {},
        { height: 'auto' },
      );
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
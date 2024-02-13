<template>
  <modal
    @confirm-clicked="clickAction"
    @close="$emit('close')"
    :action-text="$t(`message.realEstates.actions.${action}`)"
    :confirm-text="$t(`message.realEstates.actions.${action}`)"
    :error="error"
    :loading="loading"
  >
    <template #input>
      <div class="container">
         <div class="flex flex-col items-center justify-center">
          <div>
            <p class="pb-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.realEstateAssets.name') }}</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              v-model="data['name']"
              placeholder="Nombre"
            >
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.realEstateAssets.role') }}</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              v-model="data['role']"
              placeholder="Rol"
            >
          </div>
        </div>
        <div class="flex flex-col items-center justify-center mt-2">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.realEstateAssets.comune') }}</p>
            <v-select
              :options="communes"
              :clearable="false"
              :reduce="asset => asset.code_sii"
              v-model="data['commune']"
              :append-to-body="true"
              class="-ml-1 selectStyle"
              placeholder="Comunas"
              label="name"
            />
          </div>
        </div>
        <div class="flex flex-col items-center justify-center pb-8 mt-2">
          <div>
            <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.realEstateAssets.investedBalance') }}</p>
            <input
              type="text"
              class="px-2 -ml-1 inputStyle fontFamily"
              v-model="data['total_inversion']"
              placeholder="$ Monto"
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
import investmentAssetsSuggestModal from './investment-assets-suggest-modal.vue';

export default {
  components: { Modal },
  props: {
    investmentAssets: { type: Array, required: true },
    communes: { type: Array, required: true },
    action: { type: String, default: 'create' },
    realEstate: { type: Object, default: () => ({ }) },
  },
  data() {
    return {
      data: {
        commune: this.findCommuneCode() || '',
        role: this.realEstate.role || '',
        total_inversion: this.realEstate.totalInversion || null,
        name: this.realEstate.name || ''
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
    clickAction() {
      this.loading = true;
      if (this.action === 'create') {
        this.postRealEstate();
      } else if (this.action === 'edit') {
        this.editRealEstate();
      }
    },
    findCommuneCode() {
      if(this.realEstate.hasOwnProperty('commune')) return this.communes.find(commune => commune.name === this.realEstate.commune).code_sii
    },
    postRealEstate() {
      const params = decamelizeKeys(this.data);

      RealEstateApi.createRealEstate(this.selectedSubAccountId, params)
        .then(() => {
          this.$store.dispatch('getRealEstate');
          this.error = null;
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    editRealEstate() {
      const params = decamelizeKeys(this.data);

      RealEstateApi.updateRealEstate(this.selectedSubAccountId, params, this.realEstate.realEstateId)
        .then(() => {
          this.$store.dispatch('getRealEstate');
          this.error = null;
          this.$emit('close');
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
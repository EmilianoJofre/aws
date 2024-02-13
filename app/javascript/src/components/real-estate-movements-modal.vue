<template>
  <modal
    @close="$emit('close')"
    :action-text="$t('message.moneyMovements.name')"
    confirm-text=""
    :loading="loading"
    :error="error"
  >
    <template #input>
      <div class="h-48 mx-4 overflow-y-auto">
        <table class="w-full text-left py-2">
          <thead>
            <tr class="sticky fontFamily text-vl-gray-400 justify-between">
              <th class="sticky top-0 pl-4 font-medium bg-white">
                {{ $t('message.tableHeaders.valuationType') }}
              </th>
              <th class="sticky top-0 pl-4 font-medium bg-white">
                {{ $t('message.tableHeaders.valuationName') }}
              </th>
              <th class="sticky top-0 pl-4 font-medium bg-white">
                {{ $t('message.tableHeaders.valuation') }}
              </th>
              <th class="sticky top-0 pl-4 font-medium bg-white">
                {{ $t('message.tableHeaders.date') }}
              </th>
              <th />
            </tr>
          </thead>
          <tbody>
            <tr
              class="fontFamily text-vl-gray-400"
              v-for="(movement, index) in movements"
              :key="index"
            >
              <td class="p-2 pl-4 font-normal">
                {{ $t(`message.tableHeaders.${movement.typeValuer}`) }}
              </td>
              <td class="p-2 pl-4 font-normal">
                {{ movement.valuer }}
              </td>
              <td class="p-2 pl-4 font-normal">
                {{ movement.value | currency(currency) }}
              </td>
              <td class="p-2 pl-4 font-normal">
                {{ movement.priceChangedAt | dateTime }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>
    <template #buttons>
      <div class="flex justify-around mx-4">
        <!-- <btn
          class="mr-2"
          @click="createMovement('purchase')"
          :text="$t('message.moneyMovements.actions.create.purchase')"
        />
        <btn
          class="mr-2"
          @click="createMovement('sale')"
          :text="$t('message.moneyMovements.actions.create.sale')"
        />
        <btn
          class="mr-2"
          v-if="updateable"
          @click="createPriceChange"
          :text="$t('message.moneyMovements.actions.create.update')"
        />
        <btn
          variant="cancel"
          @click="liquidateMembership"
          :text="$t('message.moneyMovements.actions.create.liquidate')"
        /> -->
      </div>
    </template>
  </modal>
</template>
<script>
import RealEstateApi from '../api/real-estate';
import Modal from './shared/modal.vue';
import moneyMovementCreateModal from './money-movement-create-modal.vue';
import priceChangeCreateModal from './price-change-create-modal.vue';

export default {
  components: { Modal },
  props: {
    membershipType: { type: String, required: true },
    updateable: { type: Boolean, required: false },
  },
  data() {
    return {
      error: null,
      loading: false,
    };
  },
  computed: {
    membership() {
      return this.$store.getters.selectedRealEstate(this.membershipType);
    },
    movements() {
      return this.membership.priceChanges;
    },
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    selectedRealEstatesId() {
      return this.$store.state.realEstate.selectedRealEstatesId
    }
  },
  methods: {
    createMovement(type) {
      this.$modal.show(moneyMovementCreateModal,
        { movementType: type, selectedId: this.selectedRealEstatesId },
        { height: 'auto' },
        { 'before-close': this.beforeClose },
      );
    },
    editMovement(moneyMovement) {
      this.$modal.show(moneyMovementCreateModal,
        {
          action: 'edit',
          movementType: moneyMovement.attributes.movementType,
          moneyMovement,
        },
        { height: 'auto' },
        { 'before-close': this.beforeClose },
      );
    },
    createPriceChange() {
      this.$modal.show(priceChangeCreateModal,
        { },
        { height: 'auto', width: 300 },
      );
    },
    beforeClose() {
      if (this.membershipType === 'normal') {
        this.$store.dispatch('getRealEstate');
      } else if (this.membershipType === 'custom') {
        this.$store.dispatch('getCustomRealEstate');
      }
    },
    liquidateMembership() {
      this.loading = true;
      RealEstateApi.liquidateRealEstate(this.membership)
        .then(() => this.$emit('close'))
        .catch((e) => { this.error = e; })
        .finally(() => { this.loading = false; });
    },
  },
};
</script>

<style scoped lang="scss">
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');
  .fontFamily {
    font-family: 'Inter', sans-serif;
  }
</style>
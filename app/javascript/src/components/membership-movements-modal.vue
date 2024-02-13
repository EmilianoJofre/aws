<template>
  <modal
    @close="$emit('close')"
    :action-text="$t('message.moneyMovements.name')"
    confirm-text=""
    :loading="loading"
    :error="error"
  >
    <template #input>
      <div class="h-64 mx-4 overflow-y-auto">
        <table class="w-full text-left border">
          <thead>
            <tr class="sticky text-vl-gray">
              <th class="sticky top-0 w-1/6 p-2 pl-4 font-light bg-white border-t">
                {{ $t('message.tableHeaders.quotasBalance') }}
              </th>
              <th class="sticky top-0 w-1/6 p-2 pl-4 font-light bg-white border-t">
                {{ $t('message.tableHeaders.averagePrice') }}
              </th>
              <th class="sticky top-0 w-1/6 p-2 pl-4 font-light bg-white border-t">
                {{ $t('message.tableHeaders.amount') }}
              </th>
              <th class="sticky top-0 w-1/6 p-2 pl-4 font-light bg-white border-t">
                {{ $t('message.tableHeaders.type') }}
              </th>
              <th class="sticky top-0 w-1/6 p-2 pl-4 font-light bg-white border-t">
                {{ $t('message.tableHeaders.date') }}
              </th>
              <th class="sticky top-0 w-1/6 p-2 pl-4 font-light bg-white border-t">
                {{ $t('message.tableHeaders.edit') }}
              </th>
              <th />
            </tr>
          </thead>
          <tbody>
            <tr
              class="text-vl-gray hover:bg-gray-300"
              v-for="(movement, index) in movements"
              :key="index"
              :class="movement.attributes.movementType === 'sale' ? 'bg-red-300' : 'bg-green-300'"
            >
              <td class="p-2 pl-4 font-light">
                {{ movement.attributes.quotas | quantity('USD') }}
              </td>
              <td class="p-2 pl-4 font-light">
                {{ movement.attributes.averagePrice | currency(currency) }}
              </td>
              <td class="p-2 pl-4 font-light">
                {{ movement.attributes.amount | currency(currency) }}
              </td>
              <td class="p-2 pl-4 font-light">
                {{ $t(`message.moneyMovements.type.${movement.attributes.movementType}`) }}
              </td>
              <td class="p-2 pl-4 font-light">
                {{ movement.attributes.date | dateTime }}
              </td>
              <td class="p-2 pl-4 font-light">
                <inline-svg
                  @click="editMovement(movement)"
                  class="fill-current text-primary"
                  :src="require('assets/images/icons/edit.svg')"
                />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>
    <template #buttons>
      <div class="flex justify-around mx-4">
        <btn
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
        />
      </div>
    </template>
  </modal>
</template>
<script>
import MembershipApi from '../api/memberships';
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
      return this.$store.getters.selectedMembership(this.membershipType);
    },
    movements() {
      return this.membership.moneyMovements;
    },
    currency() {
      return this.$store.getters.selectedSubAccountCurrency;
    },
    selectedMembershipId() {
      return this.$store.state.memberships.selectedMembershipId;
    },
  },
  methods: {
    createMovement(type) {
      this.$modal.show(moneyMovementCreateModal,
        { movementType: type, selectedId: this.selectedMembershipId },
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
        this.$store.dispatch('getMemberships');
      } else if (this.membershipType === 'custom') {
        this.$store.dispatch('getCustomMemberships');
      }
    },
    liquidateMembership() {
      this.loading = true;
      MembershipApi.liquidateMembership(this.membership)
        .then(() => this.$emit('close'))
        .catch((e) => { this.error = e; })
        .finally(() => { this.loading = false; });
    },
  },
};
</script>

<template>
  <div class="mt-8">
    <div class="flex flex-col-reverse items-center justify-between mb-4 lg:flex-row">
      <h1 class="text-lg font-bold text-center lg:text-left lg:text-2xl text-vl-blue">
        {{ $t('message.titles.movementsHistory', { relationName }) }}
      </h1>
      <btn
        class="mx-16 uppercase lg:mx-0"
        :text="$t('message.metrics.backToBalance')"
        :href="`/relations/${relationId}`"
        variant="secondary"
      />
    </div>
    <paginator
      class="mb-4 lg:hidden"
      :current-page="currentPage"
      :total-pages="totalPages"
      @page-changed="changePage"
    />
    <div v-if="!loading">
      <info-card
        v-for="(movement, index) in formattedData"
        :key="index"
        class="mx-2 mb-4 lg:hidden"
        :content="generateMovementContent(movement)"
      />
      <custom-table
        :show-edit="this.$store.getters.isUser"
        class="hidden mb-8 lg:block"
        :headers="headers"
        :table-data="formattedData"
        @edit-clicked="editMovement"
      />
    </div>
    <loading
      v-if="loading"
      class="h-24"
    />
    <paginator
      :current-page="currentPage"
      :total-pages="totalPages"
      @page-changed="changePage"
    />
  </div>
</template>

<script>
import CustomTable from '../table.vue';
import InfoCard from '../shared/info-card.vue';
import Loading from '../shared/loading.vue';
import MoneyMovementCreateModal from '../money-movement-create-modal.vue';
import Paginator from '../shared/paginator.vue';
import RelationsApi from '../../api/relations';

export default {
  components: { CustomTable, InfoCard, Loading, Paginator },
  props: {
    relationId: { type: Number, required: true },
    relationName: { type: String, required: true },
  },
  data() {
    return {
      currentPage: 1,
      error: null,
      headers: [
        { title: 'assetId', tooltip: true, tooltipCols: ['assetId'] },
        { title: 'movementType' },
        { title: 'quotasBalance', filter: 'number' },
        { title: 'averagePrice', filter: 'currency' },
        { title: 'amount', filter: 'number' },
        { title: 'date', filter: 'date' },
        { title: 'account', tooltip: true, tooltipCols: ['account'] },
      ],
      loading: false,
      moneyMovements: null,
      movementsPerPage: null,
      totalMovements: null,
    };
  },
  beforeMount() {
    this.getMoneyMovements();
  },
  computed: {
    cardHeaders() {
      return this.headers.filter((header) => header.title !== 'assetId');
    },
    formattedData() {
      if (!this.moneyMovements) return [];

      return this.moneyMovements.map((moneyMovement) => ({
        ...moneyMovement,
        account: this.generateAccountName(moneyMovement),
        movementType: this.$t(`message.moneyMovements.type.${moneyMovement.movementType}`),
        quotasBalance: moneyMovement.quotas,
      }));
    },
    totalPages() {
      return Math.ceil(this.totalMovements / this.movementsPerPage) || 1;
    },
  },
  methods: {
    changePage(newPage) {
      this.currentPage = newPage;
      this.getMoneyMovements();
    },
    editMovement(movementId) {
      const moneyMovement = this.findMoneyMovementById(movementId);
      this.$modal.show(MoneyMovementCreateModal,
        {
          action: 'edit',
          movementType: moneyMovement.movementType,
          moneyMovement: { id: moneyMovement.id, attributes: moneyMovement },
        },
        { height: 'auto' },
        { 'before-close': this.getMoneyMovements },
      );
    },
    findMoneyMovementById(movementId) {
      if (!this.moneyMovements) return null;

      return this.moneyMovements.find((moneyMovement) => moneyMovement.id === movementId);
    },
    generateAccountName({ account, subAccount }) {
      return `${account.name} - ${account.bank.name} - ${subAccount.subAccountId}`;
    },
    generateMovementContent(movement) {
      const movementInfo = this.cardHeaders.map((header) => ({
        class: 'text-sm text-vl-gray',
        title: this.$t(`message.tableHeaders.${header.title}`),
        content: (
          header.filter ?
            this.$options.filters[header.filter](movement[header.title]) :
            movement[header.title]
        ),
      }));

      return [
        {
          class: 'text-vl-blue',
          title: movement.assetId,
        },
        ...movementInfo,
      ];
    },
    getMoneyMovements() {
      this.loading = true;
      RelationsApi.getMoneyMovements(this.relationId, this.currentPage)
        .then(({ headers, moneyMovements }) => {
          this.error = null;
          this.moneyMovements = moneyMovements;
          this.movementsPerPage = Number(headers['x-per-page']);
          this.totalMovements = Number(headers['x-total']);
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
  },
};
</script>

<template>
  <modal
    @close="$emit('close')"
    :action-text="$t('message.clientBalances.chart.deleteDotsModal.action')"
    confirm-text=""
    :loading="loading"
    :error="error"
  >
    <template #input>
      <p class="mb-8 text-center whitespace-pre-line">
        {{ $t('message.clientBalances.chart.deleteDotsModal.deleteDotsConfirmation', { dots: deleteDotsText }) }}
      </p>
    </template>
    <template
      #buttons
      v-if="!loading"
    >
      <div class="flex justify-around mx-4">
        <btn
          @click="deleteDots"
          variant="red"
          :text="$t('message.clientBalances.chart.deleteDotsModal.delete')"
        />
        <btn
          @click="$emit('close')"
          :text="$t('message.clientBalances.chart.deleteDotsModal.cancel')"
        />
      </div>
    </template>
  </modal>
</template>
<script>
import Modal from '../shared/modal.vue';
import RelationHistoryApi from '../../api/relation-history';

export default {
  components: { Modal },
  props: {
    currentHistoryId: { type: Number, required: true },
    datesToDelete: { type: Array, required: true },
  },
  data() {
    return {
      error: null,
      loading: false,
    };
  },
  methods: {
    deleteDots() {
      this.loading = true;
      RelationHistoryApi.deleteDates(this.currentHistoryId, this.datesToDelete)
        .then(() => this.$emit('close'))
        .catch((error) => {
          this.error = error;
          this.notify({
            title: this.$t('message.clientBalances.chart.deleteDotsModal.errorTitle'),
            text: this.$t('message.clientBalances.chart.deleteDotsModal.errorText'),
            type: 'warn',
          });
        })
        .finally(() => { this.loading = false; });
    },
  },
  computed: {
    deleteDotsText() {
      return this.datesToDelete.map((date) => this.$options.filters.date(date)).join('\n');
    },
  },
};
</script>

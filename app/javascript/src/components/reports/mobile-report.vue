<template>
  <div class="mx-4">
    <pill-selector
      v-if="!!accounts.length"
      class="mb-4"
      :title="selectedAccount.name"
      :sub-title="selectedAccount.bank"
      @move-selected="moveSelectedAccount"
    />
    <div
      v-else
      class="mb-4 text-center text-vl-gray"
    >
      {{ $t('message.reports.noAccounts') }}
    </div>
    <pill-selector
      v-if="!!subAccounts.length"
      class="mb-4"
      :title="selectedSubAccount.subAccountId"
      :sub-title="selectedSubAccount.currency"
      @move-selected="moveSelectedSubAccount"
    />
    <div
      v-else
      class="mb-4 text-center text-vl-gray"
    >
      {{ $t('message.reports.selectAccount') }}
    </div>
    <info-card
      v-for="(report, index) in accumulatedReports"
      :key="index"
      class="mb-4"
      :content="generateContent(report)"
    />
    <loading v-if="loading" />
    <div
      v-if="!!monthlyReports.length"
    >
      <info-card
        v-for="(monthReport, index) in monthlyReports"
        :key="index"
        class="mb-4"
        @click="selectMonth(monthReport.id)"
        :content="generateMonthContent(monthReport)"
      />
    </div>
    <div
      v-else
      class="mb-4 text-center text-vl-gray"
    >
      {{ $t('message.reports.monthlyReportError') }}
    </div>
  </div>
</template>

<script>
import Loading from '../shared/loading.vue';
import PillSelector from '../shared/pill-selector.vue';
import InfoCard from '../shared/info-card.vue';

export default {
  components: { InfoCard, PillSelector, Loading },
  data() {
    const accumulatedHeaders = [
      { name: 'profitAbsolute', filter: 'currency' },
      { name: 'profitRelative', filter: 'percent' },
      { name: 'endCapital', filter: 'currency' },
    ];

    return {
      accumulatedHeaders,
      reportsHeaders: [
        { name: 'initialCapital', filter: 'currency' },
        { name: 'deposits', filter: 'currency' },
        { name: 'withdrawals', filter: 'currency' },
        ...accumulatedHeaders,
      ],
      selectedAccountIndex: null,
      selectedSubAccountIndex: null,
    };
  },
  props: {
    accounts: { type: Array, required: true },
    currentYear: { type: Number, required: true },
    currentYearReport: { type: Object, required: true },
    headers: { type: Object, required: true },
    lastYear: { type: Number, required: true },
    lastYearReport: { type: Object, required: true },
    loading: { type: Boolean, required: true },
    monthlyReports: { type: Array, required: true },
    relationId: { type: Number, required: true },
    subAccounts: { type: Array, required: true },
  },
  methods: {
    moveSelectedAccount(direction) {
      if (this.selectedAccountIndex === null) this.selectedAccountIndex = 0;
      else {
        const accountsLength = this.accounts.length;
        this.selectedAccountIndex += (direction + accountsLength);
        this.selectedAccountIndex %= accountsLength;
      }
      this.selectAccount(this.selectedAccount.id);
    },
    moveSelectedSubAccount(direction) {
      if (this.selectedSubAccountIndex === null) this.selectedSubAccountIndex = 0;
      else {
        const subAccountsLength = this.subAccounts.length;
        this.selectedSubAccountIndex += (direction + subAccountsLength);
        this.selectedSubAccountIndex %= subAccountsLength;
      }
      this.selectSubAccount(this.selectedSubAccount.id);
    },
    accumulatedText(year) {
      return year === this.lastYear ? 'yearSummary' : 'yearAccumulated';
    },
    selectAccount(accountId) {
      this.$emit('account-selected', accountId);
    },
    selectSubAccount(subAccountId) {
      this.$emit('sub-account-selected', subAccountId);
    },
    selectMonth(month) {
      this.$emit('month-clicked', month);
    },
    generateContent(report) {
      const reportInfo = this.accumulatedHeaders.map((header) => ({
        class: 'text-sm text-vl-gray',
        title: this.$t(`message.tableHeaders.${header.name}`),
        content: this.$options.filters[header.filter](report[header.name], this.selectedSubAccount.currency),
      }));

      return [
        {
          class: 'text-vl-blue',
          title: this.$t(`message.reports.${this.accumulatedText(report.year)}`, { year: report.year }),
        },
        ...reportInfo,
      ];
    },
    generateMonthContent(monthReport) {
      const monthInfo = this.reportsHeaders.map((header) => ({
        class: 'text-sm text-vl-gray',
        title: this.$t(`message.tableHeaders.${header.name}`),
        content: this.$options.filters[header.filter](monthReport[header.name], this.selectedSubAccount.currency),
      }));

      return [
        {
          class: 'text-vl-blue',
          title: monthReport.month,
        },
        ...monthInfo,
      ];
    },
  },
  computed: {
    accumulatedReports() {
      return [
        { year: this.lastYear, ...this.lastYearReport },
        { year: this.currentYear, ...this.currentYearReport },
      ];
    },
    selectedAccount() {
      if (this.selectedAccountIndex === null) {
        return { name: 'Seleccione cuenta', bank: '' };
      }

      return this.accounts[this.selectedAccountIndex];
    },
    selectedSubAccount() {
      if (this.selectedSubAccountIndex === null) {
        return { subAccountId: 'Seleccione sub cuenta', currency: '' };
      }

      return this.subAccounts[this.selectedSubAccountIndex];
    },
  },
};
</script>

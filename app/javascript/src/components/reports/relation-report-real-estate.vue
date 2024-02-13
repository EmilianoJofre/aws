<template>
  <div>
    <relation-title-bar
      :is-demo="isDemo"
      title="Reporte Bienes Raíces"
    />
    <desktop-report
      :relation-id="relationId"
      class="hidden lg:block"
      :accounts="formatAccounts"
      :currency="currency"
      :current-year="currentYear"
      :current-year-report="currentYearReport"
      :sub-accounts="subAccounts"
      :headers="headers"
      :last-year="lastYear"
      :last-year-report="lastYearReport"
      :loading="loading"
      :monthly-reports="formatMonthlyReports"
      @account-selected="accountSelected"
      @sub-account-selected="subAccountSelected"
      @month-clicked="openMovementsModal"
    />
    <mobile-report
      :relation-id="relationId"
      class="lg:hidden"
      :accounts="formatAccounts"
      :current-year="currentYear"
      :current-year-report="currentYearReport"
      :sub-accounts="subAccounts"
      :headers="headers"
      :last-year="lastYear"
      :last-year-report="lastYearReport"
      :loading="loading"
      :monthly-reports="formatMonthlyReports"
      @account-selected="accountSelected"
      @sub-account-selected="subAccountSelected"
      @month-clicked="openMovementsModal"
    />
  </div>
</template>

<script>
import AccountsApi from '../../api/accounts';
import SubAccountsApi from '../../api/sub-accounts';
import ReportsApi from '../../api/reports';

import DesktopReport from './desktop-report.vue';
import MobileReport from './mobile-report.vue';
import MovementsModal from './movements-modal.vue';
import RelationTitleBar from '../shared/relation-title-bar.vue';

export default {
  components: { DesktopReport, MobileReport, RelationTitleBar },
  props: {
    isDemo: { type: Boolean, default: false },
    relationId: { type: Number, required: true },
    accounts: { type: Array, required: true },
  },
  data() {
    return {
      currency: 'CLP',
      headers: {
        accounts: [
          { title: 'name' },
          { title: 'rut' },
          { title: 'email' },
        ],
        accumulated: [
          { title: 'profitAbsolute', filter: 'currency' },
          { title: 'profitRelative', filter: 'percent' },
          { title: 'endCapital', filter: 'currency' },
        ],
        subAccounts: [
          { title: 'subAccountId' },
          { title: 'currency' },
        ],
        report: [
          { title: 'month' },
          { title: 'initialCapital', filter: 'currency' },
          { title: 'deposits', filter: 'currency' },
          { title: 'withdrawals', filter: 'currency' },
          { title: 'profitAbsolute', filter: 'currency' },
          { title: 'profitRelative', filter: 'percent' },
          { title: 'endCapital', filter: 'currency' },
        ],
      },
      loading: false,
      reports: {},
      subAccounts: [],
    };
  },
  methods: {
    accountSelected(subAccountId) {
      this.reports = {};
      SubAccountsApi.getSubAccounts(subAccountId, this.isDemo)
        .then((response) => { this.subAccounts = response.subAccounts; });
    },
    subAccountSelected(subAccountId) {
      this.currency = this.subAccounts.find(subAccount => subAccount.id === subAccountId).currency;
      this.loading = true;
      ReportsApi.getReport(subAccountId)
        .then((response) => {
          // eslint-disable-next-line no-unused-vars
          this.reports = (({ headers, ...data }) => data)(response);
        })
        .finally(() => { this.loading = false; });
    },
    openMovementsModal(month) {
      const currentMonth = new Date(this.currentYear, month - 1);

      this.$modal.show(MovementsModal,
        { month: currentMonth, relationId: this.relationId },
        { height: this.modalHeight, width: this.modalWidth },
      );
    },
  },
  computed: {
    accumulatedReports() {
      return this.reports.accumulated;
    },
    monthlyReportsKeys() {
      return Object.keys(this.reports).filter((report) => !['accumulated', 'data'].includes(report));
    },
    formatAccounts() {
      return this.accounts.map(account => (
        {
          id: account.id,
          name: account.name,
          rut: account.rut,
          email: account.email,
          bank: account.bank.name,
        }
      ));
    },
    formatMonthlyReports() {
      return this.monthlyReportsKeys.map(key => ({
        id: key,
        month: this.$t(`message.months.${key}`),
        initialCapital: this.reports[key].initialCapital,
        endCapital: this.reports[key].endCapital,
        deposits: this.reports[key].deposits,
        withdrawals: this.reports[key].withdrawals,
        profitAbsolute: this.reports[key].profitAbsolute,
        profitRelative: this.reports[key].profitRelative,
      }));
    },
    lastYear() {
      return new Date().getFullYear() - 1;
    },
    lastYearReport() {
      return this.accumulatedReports ? this.accumulatedReports.last : {};
    },
    currentYear() {
      return new Date().getFullYear();
    },
    currentYearReport() {
      return this.accumulatedReports ? this.accumulatedReports.current : {};
    },
    modalWidth() {
      // eslint-disable-next-line no-magic-numbers
      return window.innerWidth > 600 ? '600px' : '80%';
    },
    modalHeight() {
      // eslint-disable-next-line no-magic-numbers
      return window.innerWidth > 600 ? 'auto' : '80%';
    },
  },
};
</script>

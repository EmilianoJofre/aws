<template>
  <div>
    <mobile-accounts-modal
      v-show="showModal"
      :accounts="accounts"
      :banks="banks"
      :selected-accounts="selectedAccounts"
      :selected-banks="selectedBanks"
      v-bind="$attrs"
      @cancel="showModal = false"
      @save="saveSelection"
    />
    <div>
      <relation-title-bar
        class="mb-6"
        :is-demo="isDemo"
        :title="$t('message.titles.pensionFunds')"
      />
      <div class="flex flex-col w-full lg:border-t lg:border-gray-300 lg:block">
        <div class="flex flex-row justify-between mx-6 mb-8 text-center lg:hidden">
          <div class="w-12 mr-2" />
          <p class="col-span-3 text-vl-blue">
            {{ selectedCountNotice() }}
          </p>
          <icon-btn
            icon-classes="flex-shrink-0 mr-1 w-4 fill-current text-vl-gray-200 fill-current"
            icon-name="edit"
            text-classes="normal-case text-vl-gray"
            :text="$t('message.clientBalances.accounts.edit')"
            @click="showModal = true"
          />
        </div>
        <div
          class="mb-8 lg:hidden"
        >
          <div
            class="flex flex-row gap-3 px-2 overflow-x-scroll whitespace-no-wrap no-scrollbar lg:hidden"
            :class="justifyAccounts"
          >
            <span
              v-for="(account, key) in filteredAccounts"
              :key="key"
            >
              <div
                class="flex flex-col h-12 px-6 py-2 text-center rounded-md justify-evenly"
                :class="balanceSelectedClasses(account.id)"
              >
                <p class="text-sm">{{ account.name }}</p>
                <p class="text-sm">{{ account.bank.name }}</p>
              </div>
            </span>
          </div>
        </div>
        <div
          class="hidden lg:flex"
        >
          <accounts-selector
            :accounts="accounts"
            :banks="banks"
            :selected-accounts="selectedAccounts"
            :selected-banks="selectedBanks"
            @update="updateSelectedAccounts"
          />
        </div>

        <div class="flex flex-col items-center justify-center mb-4 lg:justify-between lg:flex-row">
          <info-text
            class="mb-4 lg:mb-0"
            :info-tooltip="tooltipText"
            :title="$t('message.clientBalances.consolidatedCapitalPensionFunds.name')"
            placement="right-start"
          >
            <template #information>
              <p
                v-if="someBalanceIsSelected && !loadingHistory"
                class="text-xl font-bold lg:text-3xl text-vl-blue"
              >
                {{ currentBalance() | currency(currency) }}
              </p>
              <p
                v-else
                class="text-xl font-bold lg:text-3xl text-vl-blue"
              >
                {{ '-' }}
              </p>
            </template>
          </info-text>
          <div
            class="flex flex-col items-center lg:flex-row"
            v-if="showWallet && someBalanceIsSelected"
          >
            <info-text
              class="mb-4 lg:mb-0"
              :info-tooltip="$t('message.clientBalances.totalDeposits.info')"
              :title="$t('message.clientBalances.totalDeposits.name')"
            >
              <template #information>
                <p
                  v-if="!loadingHistory"
                  class="text-lg text-vl-gray"
                >
                  {{ currentWallet() | currency(currency) }}
                </p>
              </template>
            </info-text>
            <info-text
              class="mb-4 lg:mb-0"
              :info-tooltip="$t('message.clientBalances.difference.info')"
              :title="$t('message.clientBalances.difference.name')"
            >
              <template #information>
                <div
                  v-if="!loadingHistory"
                  class="flex items-center"
                >
                  <p class="mr-2 text-lg text-vl-gray">
                    {{ profit.absolute > 0 ? '+' : '' }} {{ profit.absolute | currency(currency) }}
                  </p>
                  <inline-svg
                    class="fill-current"
                    :class="outcomeTextClasses(profit.absolute)"
                    :src="require('assets/images/icons/triangle-up.svg')"
                  />
                </div>
              </template>
            </info-text>
          </div>
        </div>

        <div
          v-if="someBalanceIsSelected"
        >
          <div class="max-w-full px-4 py-2 mb-4 border lg:mb-0 lg:px-8 lg:py-4 border-secondary">
            <div class="flex flex-col items-center justify-center lg:flex-row lg:justify-between">
              <icon-btn
                @click="confirmDotsDelete"
                :class="{ 'invisible' : !(Object.keys(datesToDelete).length && isUser) }"
                icon-classes="text-vl-red fill-current"
                icon-name="delete"
                text-classes="text-vl-red"
                :text="$t('message.clientBalances.chart.deleteDots')"
              />
              <div
                class="flex flex-row items-center lg:hidden"
              >
                <time-selector
                  @selected-time-tab="changeTimeTab"
                  :selected-tab="selectedTimeTab"
                  :options="timeSelectorOptions"
                  :last-updated="lastUpdated"
                  :info-chart="$t('message.clientBalances.chart.infoPension')"
                />
                <info-tooltip
                  v-if="isUser"
                  @click="updateChart"
                  classes="w-8 h-8 cursor-pointer text-vl-gray"
                  icon-name="update"
                  :text="$t('message.clientBalances.chart.nextUpdate', { time: nextChartUpdateInTime })"
                />
              </div>
              <time-selector
                class="hidden mr-2 lg:flex"
                @selected-time-tab="changeTimeTab"
                :selected-tab="selectedTimeTab"
                :options="timeSelectorOptions"
                :last-updated="lastUpdated"
                :info-chart="$t('message.clientBalances.chart.infoPension')"
              />
              <info-tooltip
                class="hidden lg:block"
                v-if="isUser"
                @click="updateChart"
                classes="w-8 h-8 ml-32 cursor-pointer text-vl-gray"
                icon-name="update"
                :text="$t('message.clientBalances.chart.nextUpdate', { time: nextChartUpdateInTime })"
              />
            </div>
            <balances-chart
              v-if="showBalancesChart"
              :balances="balancesData"
              :dates-to-delete="datesToDelete"
              :wallets="walletsData"
              :currency="currency"
              :height="chartHeight"
              :options="chartOptions"
              @point-clicked="selectPoint"
            />
            <p
              v-else-if="historyLoadFailed"
              class="my-8 text-lg text-center text-vl-yellow lg:text-2xl"
            >
              {{ $t('message.clientBalances.chart.loadingHistory') }}
            </p>
            <loading v-else />
          </div>
        </div>
        <div
          v-else
          class="max-w-full px-4 py-2 mb-4 border lg:mb-0 lg:px-8 lg:py-4 border-secondary"
        >
          <div class="flex flex-col items-center my-12 space-y-4">
            <img
              class="h-48"
              :src="require('../../../../assets/images/no-plot.png')"
            >
            <p
              class="text-base text-center text-vl-gray"
            >
              {{ $t('message.clientBalances.chart.noCharts') }}
            </p>
          </div>
        </div>
        <client-investments
          v-if="!loadingHistory"
          :account-ids="accountIds"
          :is-demo="isDemo"
          :relation-id="relationId"
          :selected-accounts="selectedAccounts"
          :dollar-price="dollar"
          :euro-price="euro"
          :uf-price="uf"
          :selected-currency="currency"
        />
      </div>
      <footer>
        <section class="section-footer">
          <div class="line"></div>
          <article class="relative info-footer">
            <span class="mr-2 span">{{ $t('message.footer.powered_by') }}</span> <span><img :src="require('assets/images/icons/vl-footer-icon.svg')"/></span> <span>{{ $t('message.footer.vl_name') }}</span>
          </article>

          <!-- <article class="redirection-info">
            <span class="span">{{ $t('message.footer.see_previous_version') }} </span><a class="a" href="https://ng.valuelist.cl/login" target="_blank">{{ $t('message.footer.click_here') }}</a>
          </article> -->
        </section>
      </footer>
    </div>
  </div>
</template>

<script>
import { camelize } from 'humps';
import BalancesChart from './balances-chart.vue';
import ClientInvestments from './client-investments.vue';
import DotDeleteModal from './dot-delete-modal.vue';
import CurrencySelector from '../shared/curreny-selector';
import InfoText from '../shared/info-text.vue';
import TimeSelector from './time-selector.vue';
import RelationsApi from '../../api/relations';
import RelationTitleBar from '../shared/relation-title-bar.vue';
import MobileAccountsModal from './mobile-accounts-modal.vue';
import AccountsSelector from './accounts-selector.vue';

// eslint-disable-next-line no-magic-numbers
const LG_WIDTH = 1024;

export default {
  props: {
    accounts: { type: Array, required: true },
    dollar: { type: Number, required: true },
    euro: { type: Number, required: true },
    uf: { type: Number, required: true },
    relationId: { type: Number, required: true },
    showWallet: { type: Boolean, required: true },
    isDemo: { type: Boolean, default: false },
    lastUpdated: { type: String, required: true },
    nextChartUpdate: { type: String, required: true },
  },
  data() {
    return {
      datesToDelete: {},
      historyBalances: {
        'ORIGEN': null,
        'MTD': null,
        '1M': null,
        '3M': null,
        '6M': null,
        'YTD': null,
        '1Y': null,
        '5Y': null,
      },
      historyLoadFailed: false,
      loadingHistory: true,
      wallets: {
        'ORIGEN': null,
        'MTD': null,
        '1M': null,
        '3M': null,
        '6M': null,
        'YTD': null,
        '1Y': null,
        '5Y': null,
      },
      selectedAccounts: [],
      selectedBanks: [],
      selectedTimeTab: 'ORIGEN',
      showModal: false,
      timeSelectorOptions: [
        { name: 'ORIGEN', window: 'origin' },
        { name: 'MTD', window: 'mtd', tooltip: this.$t('message.clientBalances.chart.timeWindows.mtd') },
        { name: '1M', window: '1m', tooltip: this.$t('message.clientBalances.chart.timeWindows.1m') },
        { name: '3M', window: '3m', tooltip: this.$t('message.clientBalances.chart.timeWindows.3m') },
        { name: '6M', window: '6m', tooltip: this.$t('message.clientBalances.chart.timeWindows.6m') },
        { name: 'YTD', window: 'ytd', tooltip: this.$t('message.clientBalances.chart.timeWindows.ytd') },
        { name: '1Y', window: '1y', tooltip: this.$t('message.clientBalances.chart.timeWindows.1y') },
        { name: '5Y', window: '5y', tooltip: this.$t('message.clientBalances.chart.timeWindows.5y') },
      ],
      updateClicked: false,
    };
  },
  components: {
    BalancesChart,
    ClientInvestments,
    CurrencySelector,
    TimeSelector,
    InfoText,
    RelationTitleBar,
    MobileAccountsModal,
    AccountsSelector,
  },
  computed: {
    currency() {
      return this.$store.state.currency.currency;
    },
    accountIds() {
      return this.accounts.map((account) => account.id);
    },
    historyBalancesWithoutId() {
      const balances = {};
     
      Object.entries(this.historyBalances).forEach(([key, value]) => {
        if (value) balances[key] = { ...this.removeIdFromObject(value) };
        if (key === 'ORIGEN' && value) {
          const allValuesByOrigin = Object.values(value).filter(specificValue => typeof specificValue === 'object')
          let objWithBalances = {
            "CLP": allValuesByOrigin[allValuesByOrigin.length -1].all?.balance?.cLP,
            "USD": allValuesByOrigin[allValuesByOrigin.length -1].all?.balance?.uSD,
            "EUR": allValuesByOrigin[allValuesByOrigin.length -1].all?.balance?.eUR,
            "UF": allValuesByOrigin[allValuesByOrigin.length -1].all?.balance?.uF,
          }

          this.$store.dispatch('getAllBalanceByCurrency', objWithBalances);
        } 
      });

      return balances;
    },
    walletsWithoutId() {
      const wallets = {};
      Object.entries(this.wallets).forEach(([key, value]) => {
        if (value) wallets[key] = { ...this.removeIdFromObject(value) };
      });

      return wallets;
    },
    balancesData() {
      return this.updatedHistoryBalances[this.selectedTimeTab];
    },
    banks() {
      return this.accounts.reduce((object, account) => ({ ...object, [account.bank.id]: account.bank.name }), {});
    },
    chartOptions() {
      if (window.innerWidth > LG_WIDTH) return {};

      return {
        layout: { padding: 24 },
        scales: {
          xAxes: [{ ticks: { maxTicksLimit: 5, fontSize: 8 } }],
          yAxes: [{ ticks: { maxTicksLimit: 10, fontSize: 8 } }],
        },
      };
    },
    chartHeight() {
      // eslint-disable-next-line no-magic-numbers
      return window.innerWidth > LG_WIDTH ? 100 : 300;
    },
    currentHistoryId() {
      return this.historyBalances[this.selectedTimeTab].id;
    },
    nextChartUpdateInTime() {
      const dateObject = new Date(this.nextChartUpdate);
      const hours = dateObject.getHours();
      // eslint-disable-next-line no-magic-numbers
      const minutes = String(dateObject.getMinutes()).padStart(2, '0');

      return `${hours}:${minutes} hrs`;
    },
    isUser() {
      return this.$store.getters.isUser;
    },
    justifyAccounts() {
      return (Object.keys(this.filteredAccounts).length > 1) ? 'justify-start' : 'justify-center';
    },
    lastDate() {
      const keys = Object.keys(this.walletsWithoutId[this.tabs[0]]);

      return keys[keys.length - 1];
    },
    filteredAccounts() {
      return this.accounts.filter((account) => this.selectedAccounts.includes(account.id));
    },
    showBalancesChart() {
      if (!this.historyBalancesWithoutId[this.selectedTimeTab] || this.loadingHistory) return false;

      return this.showWallet ? !!this.walletsWithoutId[this.selectedTimeTab] : true;
    },
    someBalanceIsSelected() {
      this.$store.dispatch('setUserSelectedAccounts', this.selectedAccounts);

      return this.selectedAccounts.length !== 0;
    },
    tabs() {
      return this.timeSelectorOptions.map((tab) => tab.name);
    },
    updatedHistoryBalances() {
      const updatedHistoryBalances = {};
      this.tabs.forEach((tab) => {
        updatedHistoryBalances[tab] = this.historyBalancesWithoutId[tab];
      });

      return updatedHistoryBalances;
    },
    updatedWallets() {
      const updatedWallets = {};
      this.tabs.forEach((tab) => {
        updatedWallets[tab] = {
          ...this.walletsWithoutId[tab],
        };
      });

      return updatedWallets;
    },
    profit() {
      const currentBalance = this.currentBalance();
      const currentWallet = this.currentWallet();

      return {
        absolute: currentBalance - currentWallet,
        relative: currentBalance / currentWallet,
      };
    },
    walletsData() {
      return this.showWallet ? this.updatedWallets[this.selectedTimeTab] : {};
    },
    tooltipText() {
      return `${this.$t('message.clientBalances.consolidatedCapitalPensionFunds.info', { date: this.filteredLastUpdated })}`;
    },
    filteredLastUpdated() {
      return this.$options.filters.date(this.lastUpdated.replace(' UTC | camelizeKeys', ''));
    },
  },
  methods: {
    beforeClose() {
      const currentTab = this.timeSelectorOptions.find((option) => option.name === this.selectedTimeTab);
      this.resetDatesToDelete();
      this.getChartHistory(currentTab);
    },
    changeTimeTab(tab) {
      this.$store.dispatch('setUserSelectedTimeTab', tab.window)
      this.selectedTimeTab = tab.name;
      this.resetDatesToDelete();
    },
    confirmDotsDelete() {
      this.$modal.show(DotDeleteModal,
        {
          currentHistoryId: this.currentHistoryId,
          datesToDelete: Object.values(this.datesToDelete),
        },
        { height: 'auto' },
        { 'before-close': this.beforeClose },
      );
    },
    currentBalance() {
      this.$store.dispatch('getConsolidatedCapital', this.historyBalances[this.selectedTimeTab][this.lastDate].selected.balance[camelize(this.currency)]);
      return this.historyBalances[this.selectedTimeTab][this.lastDate].selected.balance[camelize(this.currency)];
    },
    currentWallet() {
      return this.wallets[this.selectedTimeTab][this.lastDate].selected[camelize(this.currency)];
    },
    getChartHistory(tab, accountIds) {
      RelationsApi.getChartHistory(this.relationId, accountIds, tab.window)
        .then(({ relationHistory }) => {
          const { id, balances, wallet } = relationHistory;
          this.historyBalances[tab.name] = { id, ...balances };
          this.wallets[tab.name] = { id, ...wallet };
          this.historyLoadFailed = false;
        })
        .catch(() => {
          this.historyLoadFailed = true;
        })
        .finally(() => {
          this.loadingHistory = false;
        });
    },
    balanceSelectedClasses(id) {
      const selectedClass = 'bg-vl-blue text-white';
      const notSelectedClass = 'bg-vl-blue-light text-vl-blue cursor-pointer';

      return this.selectedAccounts.includes(id) ? selectedClass : notSelectedClass;
    },
    notify(options) {
      this.$notify({
        group: 'app-notification',
        ...options,
      });
    },
    outcomeTextClasses(outcome) {
      if (outcome > 0) return 'text-vl-green';
      if (outcome < 0) return 'text-vl-red';

      return 'text-primary';
    },
    removeIdFromObject(object) {
      // eslint-disable-next-line no-unused-vars
      const { id, ...data } = object;
      return data;
    },
    resetDatesToDelete() {
      this.datesToDelete = {};
    },
    saveSelection(selectedAccounts) {
      this.showModal = false;
      this.selectedAccounts = selectedAccounts;
      this.$store.dispatch('setUserSelectedAccounts', selectedAccounts);
    },
    selectedCountNotice() {
      const number = this.selectedAccounts.length;

      if (number > 0) {
        if (number === 1) return this.$t('message.clientBalances.accounts.selectedOne');

        return this.$t('message.clientBalances.accounts.selectedNumber', { number });
      }

      return this.$t('message.clientBalances.accounts.selectedNone');
    },
    selectPoint(dataIndex) {
      if (!this.isUser) return;

      if (this.datesToDelete[dataIndex]) {
        this.$delete(this.datesToDelete, dataIndex);
      } else {
        this.$set(this.datesToDelete, dataIndex, Object.keys(this.balancesData)[dataIndex]);
      }
    },
    updateChart() {
      if (this.updateClicked) {
        this.notify({
          title: 'Gráfico procesándose',
          text: `El gráfico está siendo procesado, espere unos minutos y recargue
               la página para ver la versión actualizada.`,
        });
      } else {
        RelationsApi.updateCharts(this.relationId)
          .then(() => {
            this.updateClicked = true;
            this.notify({
              title: 'Gráfico procesándose',
              text: `El gráfico está siendo procesado, espere unos minutos y recargue
               la página para ver la versión actualizada.`,
            });
          })
          .catch(() => this.notify({
            title: 'Error en la solicitud',
            text: `No se pudo actualizar el gráfico en este momento.
                   Por favor, intente más tarde.`,
            type: 'warn',
          }));
      }
    },
    updateSelectedAccounts(selectedAccounts) {
      this.selectedAccounts = selectedAccounts;
      this.$store.dispatch('setUserSelectedAccounts', selectedAccounts);
    },
  },
  watch: {
    selectedAccounts() {
      if (this.selectedAccounts.length !== 0) {
        this.timeSelectorOptions.forEach((option) => this.getChartHistory(option, this.selectedAccounts));
      }
    },
  },
};
</script>

<style scoped>
 footer{
  margin-top: 30px;
}

.section-footer{
  color: #A6ADB9;
  text-align: center;
}

.info-footer{
  display: flex;
  padding-top: 15px;
  font-size: 16px;
  justify-content: center;
}

.vl-icon{
  width: 19px;
  height: 19px;
  margin-bottom: 1px;
}

.redirection-info{
  font-size: 14px;
}

.line{
  border-top: 2px solid #DFE1E5;
}

.span, .a{
  vertical-align: middle;
  color: #A6ADB9;
}
</style>
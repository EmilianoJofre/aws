<template>
  <div class="w-full">
    <btn
      variant='alternative'
      class="w-1/2 mx-auto mb-4 lg:hidden"
      text="Ver Historial de Movimientos"
      :href="`/relations/${relationId}/money_movements`"
    />
    <info-tabs
      class="lg:hidden"
      :accounts="formattedAccounts || []"
      :headers="headers"
      :dollar-price="dollarPrice"
      :euro-price="euroPrice"
      :uf-price="ufPrice"
      :loading="loading"
    />
    <div class="hidden lg:block">
      <div class="flex items-center justify-between">
        <h1 class="mt-10 -mb-4 text-lg font-bold text-vl-blue">
          Cuentas de Inversión
        </h1>
        <div class="flex">
          <btn
            variant='alternative'
            text="Ver Historial de Movimientos"
            :href="`/relations/${relationId}/money_movements`"
          />
        </div>
      </div>
      <!-- Detalle inversiones -->
      <span
        v-for="(account, key) in accounts"
        :key="key"
      >
        <div v-if="isAccountSelected(account.id)">
          <div class="flex pt-4 mt-6">
            <p class="mt-4 text-base font-bold text-vl-gray-650">
              {{ `${account.name}` }}
            </p>
            <p class="mt-4 text-base font-normal text-vl-gray">
              {{ `/${account.bank.name}` }}
            </p>
          </div>
          <span
            v-for="(subAccount, index) in account.subAccounts"
            :key="subAccount.subAccountId"
          >
            <div class="mb-4">
              <div class="flex mt-8 mb-2 text-sm font-semibold uppercase h-14">
                <p class="pl-2 border-l-4 border-vl-blue text-vl-gray-650">
                  {{ `${subAccount.subAccountId} ` }}
                </p>
                <p class="pl-2 text-vl-blue">
                  {{ `(${subAccount.currency})` }}
                </p>
              </div>
            </div>
            <custom-table
                :class="index === 0 ? 'mt-8' : '-mt-px'"
                :currency="subAccount.currency"
                :headers="headers"
                :table-data="formatSubAccountMemberships(subAccount.memberships)"
                :has-full-column="false"
                :full-column-value="`${subAccount.subAccountId} (${subAccount.currency})`"
                last-row-total
                :no-has-hover="false"
            />
          </span>
          <custom-table
            class="mt-6 font-bold border-t-2 border-vl-value"
            :currency="selectedCurrency"
            :headers="headers"
            :table-data="accountFinalRow(account)"
            :has-full-column="false"
            :full-column-value="`Total Cuenta`"
            :show-headers="false"
            last-row-total
            :last-row-total-by-currency="true"
            last-row-total-by-currency-class="bg-vl-gray-value-50 text-vl-blue"
            :no-has-hover="false"
          />
        </div>
      </span>
      <!-- Fin detalle inversiones -->
      <loading v-if="loading" />
    </div>
  </div>
</template>
<script>
import RelationsApi from '../../api/relations';
import CustomTable from '../table.vue';
import InfoTabs from '../info-tabs';
import getTotalValues from '../../helpers/investments-helpers';
import { camelize } from 'humps';

export default {
  props: {
    accountIds: { type: Array, required: true },
    isDemo: { type: Boolean, required: true },
    relationId: { type: Number, required: true },
    selectedAccounts: { type: Array, required: true },
    selectedCurrency: { type: String, required: true },
    dollarPrice: { type: Number, required: true },
    euroPrice: { type: Number, required: true },
    ufPrice: { type: Number, required: true },
  },
  components: {
    CustomTable,
    InfoTabs,
  },
  data() {
    return {
      headers: [
        { titles: ['assetId', 'name'], title: 'name', tooltip: true, tooltipCols: ['assetId', 'name'], columnWidth:'285' },
        { title: 'assetType', hasHighlight: true, columnWidth:'130' },
        { title: 'quotasBalance', filter: 'number', columnWidth:'90' },
        { title: 'quotaAveragePrice', headerTooltip: 'quotaAveragePriceTooltip', filter: 'currency', columnWidth:'125', fontStyle:'font-roboto' },
        { title: 'amountInvestedBalance', headerTooltip: 'amountInvestedBalanceTooltip', filter: 'integerCurrency', columnWidth:'175', fontStyle:'font-roboto' },
        { title: 'updatedQuotaAveragePrice', filter: 'currency', columnWidth: '120', fontStyle:'font-roboto' },
        { title: 'amountUpdatedBalance', filter: 'integerCurrency', fontStyle:'font-roboto' },
        { titles: ['incomesBalance', 'incomesPercentage'], title:'incomesBalanceAndPercentage', multiFilters: ['integerCurrency', 'percent'], tooltipCols: ['incomesBalance', 'incomesPercentage'], fontStyle:'font-roboto', withColor: true, columnWidth:'150', showAll:true },
        { title: 'relativeWeight', headerTooltip: 'relativeWeightInvesmentsToolTip', filter: 'percent', columnWidth:'80', showAll:true },
      ],
      accounts: {},
      loading: true,
    };
  },
  mounted() {
    const requests = this.accountIds.map((accountId) => (
      this.getRelationInvestments(accountId)
    ));
    Promise.all(requests).then(() => (this.loading = false));
  },
  methods: {
    async getRelationInvestments(accountId) {
      await RelationsApi.getInvestments(this.relationId, accountId, this.isDemo)
        .then((response) => {
          const account = response.accounts[0];
          this.$set(this.accounts, account.id, account);
        })
        .catch((error) => (this.error = error));
    },
    formatSubAccountMemberships(memberships) {
      const rows = this.formatMemberships(memberships);
      
      return rows.length > 0 ? [...rows, ...this.finalRow(rows, 'Total')] : rows;
    },
    isAccountSelected(id) {
      return this.selectedAccounts.includes(id);
    },
    accountFinalRow(account) {
      const memberships = account.subAccounts.map(subAccount => (
        this.subAccountToSelectedCurrency(subAccount)
      )).flat(1);
      const rows = this.formatMemberships(memberships);
      return this.finalRow(rows, 'Total Cuenta');
    },
    formatMemberships(memberships) {
      const { totalAmountUpdated } = getTotalValues(memberships);

      return memberships.map(membership => (
        {
          name: membership.investmentAsset.name,
          assetId: membership.investmentAsset.assetId,
          assetType: this.$t(`message.investmentAssets.${camelize(membership.investmentAsset.assetType)}`),
          quotasBalance: membership.quotasBalance,
          quotaAveragePrice: membership.quotaAveragePrice,
          amountInvestedBalance: membership.amountInvestedBalance,
          updatedQuotaAveragePrice: membership.updatedQuotaAveragePrice,
          amountUpdatedBalance: membership.amountUpdatedBalance,
          incomesBalance: membership.incomesBalance,
          incomesPercentage: this.calculateIncomesPercentage(membership),
          relativeWeight: membership.amountUpdatedBalance / totalAmountUpdated,
        }
      ));
    },
    calculateIncomesPercentage(membership) {
      if (membership.quotaAveragePrice === 0) return 0;

      return membership.updatedQuotaAveragePrice / membership.quotaAveragePrice - 1;
    },
    finalRow(rows, rowName) {
      const { sumprod, totalAmountInvested, totalAmountUpdated, totalRelativeWeight } = getTotalValues(rows);

      return [
        {
          name: rowName,
          quotasBalance: '',
          quotaAveragePrice: '',
          amountInvestedBalance: totalAmountInvested,
          updatedQuotaAveragePrice: '',
          amountUpdatedBalance: totalAmountUpdated,
          incomesBalance: totalAmountUpdated - totalAmountInvested,
          incomesPercentage: sumprod / totalAmountInvested,
          relativeWeight: totalRelativeWeight,
        },
      ];
    },
    subAccountToSelectedCurrency(subAccount) {
      if (subAccount.currency === this.selectedCurrency) {
        return subAccount.memberships;
      }

      return this.membershipsToSelectedCurrency(subAccount.memberships, subAccount.currency);
    },
    membershipsToSelectedCurrency(memberships, currentCurrency) {
      const availablesCurrenciesExchanges = [
        {name:'CLP', action: (value) => this.transformMembershipToClp(value,currentCurrency)},
        {name:'USD', action: (value) => this.transformMembershipToDollar(value,currentCurrency)},
        {name:'EUR', action: (value) => this.transformMembershipToEuro(value,currentCurrency)},
        {name:'UF', action: (value) => this.transformMembershipToUF(value,currentCurrency)},
      ]

      const findedCurrency = availablesCurrenciesExchanges.find(currency => currency.name === this.selectedCurrency)
        return memberships.map(membership => (
          findedCurrency.action({ ...membership })
        ));
    },
    transformMembershipToClp(membership, currency) {
      if(currency === 'EUR') {
        membership.amountInvestedBalance *= this.euroPrice;
        membership.amountUpdatedBalance *= this.euroPrice;
      }

      if(currency === 'USD') {
        membership.amountInvestedBalance *= this.dollarPrice;
        membership.amountUpdatedBalance *= this.dollarPrice;
      }

      if(currency === 'UF') {
        membership.amountInvestedBalance *= this.ufPrice;
        membership.amountUpdatedBalance *= this.ufPrice;
      }
      
      return membership;
    },
    transformMembershipToDollar(membership, currency) {
      if(currency === 'EUR') {
        membership.amountInvestedBalance = membership.amountInvestedBalance * this.euroPrice / this.dollarPrice;
        membership.amountUpdatedBalance = membership.amountUpdatedBalance * this.euroPrice / this.dollarPrice;
      }

      if(currency === 'CLP') {
        membership.amountInvestedBalance /= this.dollarPrice;
        membership.amountUpdatedBalance /= this.dollarPrice;
      }

      if(currency === 'UF') {
        membership.amountInvestedBalance = membership.amountInvestedBalance * this.ufPrice / this.dollarPrice;
        membership.amountUpdatedBalance = membership.amountUpdatedBalance * this.ufPrice / this.dollarPrice;
      }

      return membership;
    },
    transformMembershipToEuro(membership, currency) {
      if(currency === 'USD') {
        membership.amountInvestedBalance = membership.amountInvestedBalance * this.dollarPrice / this.euroPrice;
        membership.amountUpdatedBalance = membership.amountUpdatedBalance * this.dollarPrice / this.euroPrice;
      }

      if(currency === 'CLP') {
        membership.amountInvestedBalance /= this.euroPrice;
        membership.amountUpdatedBalance /= this.euroPrice;
      }

      if(currency === 'UF') {
        membership.amountInvestedBalance = membership.amountInvestedBalance * this.ufPrice / this.euroPrice;
        membership.amountUpdatedBalance = membership.amountUpdatedBalance * this.ufPrice / this.euroPrice;
      }

      return membership;
    },
    transformMembershipToUF(membership, currency) {
      if(currency === 'USD') {
        membership.amountInvestedBalance = membership.amountInvestedBalance * this.dollarPrice / this.ufPrice;
        membership.amountUpdatedBalance = membership.amountUpdatedBalance * this.dollarPrice / this.ufPrice;
      }

      if(currency === 'EUR') {
        membership.amountInvestedBalance = membership.amountInvestedBalance * this.euroPrice / this.ufPrice;
        membership.amountUpdatedBalance = membership.amountUpdatedBalance * this.euroPrice / this.ufPrice;
      }

      if(currency === 'CLP') {
        membership.amountInvestedBalance /= this.ufPrice;
        membership.amountUpdatedBalance /= this.ufPrice;
      }

      return membership;
    },
  },
  computed: {
    formattedAccounts() {
      if (Object.keys(this.accounts).length !== 0) {
        return Object.values(this.accounts).map((account) => ({
          ...account,
          subAccounts: account.subAccounts.map((subAccount) => ({
            ...subAccount,
            memberships: this.formatMemberships(subAccount.memberships),
          })),
        }));
      }

      return null;
    },
    getRelationUserName() {
      return this.$store.state.user.relationUserName;
    }
  },
};
</script>

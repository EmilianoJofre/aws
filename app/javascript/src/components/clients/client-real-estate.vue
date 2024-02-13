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
          Cuentas de Bienes Raíces
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
import InfoTabs from '../info-tabs-real-estate';
import getTotalValues from '../../helpers/real-estate-helpers';
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
        { titles: ['nameRe', 'role'], title: 'nameRe', tooltip: true, tooltipCols: ['nameRe', 'role'], columnWidth:'110' },
        { title: 'assetDestination', columnWidth:'110' },
        { title: 'comune', columnWidth:'85' },
        { title: 'area', headerTooltip: 'area', columnWidth:'85' },
        { title: 'areaAveragePrice', headerTooltip: 'amountInvestedBalanceTooltip', filter: 'currency', fontStyle:'font-roboto', columnWidth:'112' },
        { title: 'amountInvestedBalanceRe', filter: 'currency', fontStyle:'font-roboto', columnWidth: '110' },
        { title: 'fiscalAppraise', filter: 'currency', fontStyle:'font-roboto', columnWidth: '95' },
        { titles: ['vlValorization', 'vlValorizationDate'], title: 'vlValorization', multiFilters: ['currency', 'date'], fontStyle:'font-roboto', columnWidth:'110' },
        { titles: ['externalValuation', 'externalValorizationDate', 'externalValorizationName'], title:'externalValuation', fontStyle:'font-roboto', multiFilters: ['currency', 'date', 'date'], columnWidth:'110' },
        { titles: ['incomesBalanceRe', 'incomesPercentageRe'], title:'incomesBalanceAndPercentage', multiFilters: ['integerCurrency', 'percent'], tooltipCols: ['incomesBalance', 'incomesPercentage'], fontStyle:'font-roboto', columnWidth: '110', withColor: true, showAll: true },
        { title: 'relativeWeightRe', headerTooltip: 'relativeWeightInvesmentsToolTip', filter: 'percent', columnWidth:'55', showAll: true },
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
      await RelationsApi.getInvestmentsRealEstate(this.relationId, accountId, this.isDemo)
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
      const { totalAmountInvested } = getTotalValues(memberships);

      return memberships.map(membership => (
        {
          id: membership.id,
          role: membership.role,
          nameRe: membership.name,
          comune: membership.commune,
          assetDestination: membership.assetDestination,
          area: membership.area,
          areaAveragePrice: membership.costM2,
          fiscalAppraise: membership.fiscalAppraisal,
          amountInvestedBalanceRe: membership.totalInversion,
          vlValorization: membership.vlValorization,
          vlValorizationDate: membership.vlValorizationDate,
          externalValorizationDate: membership.externalValorizationDate,
          externalValorizationName: membership.externalValorizationName,
          externalValuation: membership.externalValorization,
          incomesBalanceRe: membership.externalValorization ? membership.externalValorization - membership.totalInversion : membership.vlValorization ? membership.vlValorization - membership.totalInversion : null,
          incomesPercentageRe: membership.areaAveragePrice === 0 ? 0 : 
          membership.externalValorization ? membership.externalValorization / membership.totalInversion - 1 : 
          membership.vlValorization ? membership.vlValorization / membership.totalInversion - 1: 
          null,
          relativeWeightRe: membership.totalInversion / totalAmountInvested,
          mainCurrency: membership.investmentAsset.currency 
        }
      ));
    },
    finalRow(rows, rowName) {
      const { totalAmountInvested, totalAmountUpdated, totalRelativeWeight, totalExternalAmountUpdated, totalPercentUpdated } = getTotalValues(rows);

      return [
        {
          nameRe: rowName,
          assetDestination: '',
          comune: '',
          area: '',
          areaAveragePrice:'',
          amountInvestedBalanceRe: totalAmountInvested,
          fiscalAppraise: '',
          vlValorization: '',
          vlValorizationDate: '',
          externalValorizationName: '',
          externalValorizationDate: '',
          externalValuation: totalExternalAmountUpdated,
          incomesBalanceRe: totalAmountUpdated,
          incomesPercentageRe: totalPercentUpdated,
          relativeWeightRe: totalRelativeWeight,
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
        membership.externalValorization *= this.euroPrice;
        membership.vlValorization *= this.euroPrice;
        membership.totalInversion *= this.euroPrice;
      }

      if(currency === 'USD') {
        membership.externalValorization *= this.dollarPrice;
        membership.vlValorization *= this.dollarPrice;
        membership.totalInversion *= this.dollarPrice;
      }

      if(currency === 'UF') {
        membership.externalValorization *= this.ufPrice;
        membership.vlValorization *= this.ufPrice;
        membership.totalInversion *= this.ufPrice;
      }
      
      return membership;
    },
    transformMembershipToDollar(membership, currency) {
      if(currency === 'EUR') {
        membership.externalValorization = membership.externalValorization * this.euroPrice / this.dollarPrice;
        membership.vlValorization = membership.vlValorization * this.euroPrice / this.dollarPrice;
        membership.totalInversion = membership.totalInversion * this.euroPrice / this.dollarPrice;
      }

      if(currency === 'CLP') {
        membership.externalValorization /= this.dollarPrice;
        membership.vlValorization /= this.dollarPrice;
        membership.totalInversion /= this.dollarPrice;
      }

      if(currency === 'UF') {
        membership.externalValorization = membership.externalValorization * this.ufPrice / this.dollarPrice;
        membership.vlValorization = membership.vlValorization * this.ufPrice / this.dollarPrice;
        membership.totalInversion = membership.totalInversion * this.ufPrice / this.dollarPrice;
      }

      return membership;
    },
    transformMembershipToEuro(membership, currency) {
      if(currency === 'USD') {
        membership.externalValorization = membership.externalValorization * this.dollarPrice / this.euroPrice;
        membership.vlValorization = membership.vlValorization * this.dollarPrice / this.euroPrice;
        membership.totalInversion = membership.totalInversion * this.dollarPrice / this.euroPrice;
      }

      if(currency === 'CLP') {
        membership.externalValorization /= this.euroPrice;
        membership.vlValorization /= this.euroPrice;
        membership.totalInversion /= this.euroPrice;
      }

      if(currency === 'UF') {
        membership.externalValorization = membership.externalValorization * this.ufPrice / this.euroPrice;
        membership.vlValorization = membership.vlValorization * this.ufPrice / this.euroPrice;
        membership.totalInversion = membership.totalInversion * this.ufPrice / this.euroPrice;
      }

      return membership;
    },
    transformMembershipToUF(membership, currency) {
      if(currency === 'USD') {
        membership.externalValorization = membership.externalValorization * this.dollarPrice / this.ufPrice;
        membership.vlValorization = membership.vlValorization * this.dollarPrice / this.ufPrice;
        membership.totalInversion = membership.totalInversion * this.dollarPrice / this.ufPrice;
      }

      if(currency === 'EUR') {
        membership.externalValorization = membership.externalValorization * this.euroPrice / this.ufPrice;
        membership.vlValorization = membership.vlValorization * this.euroPrice / this.ufPrice;
        membership.totalInversion = membership.totalInversion * this.euroPrice / this.ufPrice;
      }

      if(currency === 'CLP') {
        membership.externalValorization /= this.ufPrice;
        membership.vlValorization /= this.ufPrice;
        membership.totalInversion /= this.ufPrice;
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


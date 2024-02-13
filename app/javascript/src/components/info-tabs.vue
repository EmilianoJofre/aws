<template>
  <div>
    <mobile-membership
      v-if="selectedMembershipId"
      class="fixed inset-0 z-10"
      :membership="selectedMembershipInfo"
      :headers="headers"
      :headers-order="headersOrder"
      @close-membership-view="closeMembershipView"
    />

    <div class="grid w-full grid-cols-3 place-items-center">
      <span
        v-for="(value, key) in tabs"
        :key="key"
        class="w-full text-center"
        :class="key === selectedTab ?
          'border-vl-blue border-b-2 text-primary' :
          'border-secondary border-b text-vl-gray'"
        @click="changeTab(key)"
      >
        {{ value }}
      </span>
    </div>
    <div
      ref="columnSelector"
      class="flex py-5 mx-1 overflow-x-scroll border-b border-secondary no-scrollbar"
    >
      <vl-button
        class="focus:outline-none"
        v-for="(header, key) in tabHeaders"
        :key="key"
        :label="$t(`message.tableHeaders.${header.title}`)"
        :selected="header.title === selectedColumn"
        @click="selectedColumn = header.title"
      />
    </div>
    <div>
      <div
        v-if="cardAccounts.length > 0"
        class="px-6 pt-5"
      >
        <vl-mobile-card
          v-for="(account, key) in cardAccounts"
          :key="key"
          class="mb-2"
          :title="setTitle(account)"
          :sub-title="setSubTitle(account)"
          :description="setDescription(account)"
          @click="selectCard(account)"
          :selected="setSelected(account)"
          :text="setText(account)"
          :filter="selectedColumnFilter"
          :currency="cardCurrency(account)"
          :border-color="setTextColor(account)"
          :text-color="setTextColor(account)"
          :text-background="setTextBackground(account)"
        />
      </div>
      <loading v-if="loading" />
    </div>
  </div>
</template>

<script>
import MobileMembership from './clients/mobile-membership';
import VlMobileCard from './shared/vl-mobile-card';
import VlButton from './shared/vl-button';
import getTotalValues from '../helpers/investments-helpers';

export default {
  components: { VlMobileCard, VlButton, MobileMembership },
  data() {
    return {
      tabs: {
        accounts: 'Cuentas',
        subAccounts: 'Portafolios',
        memberships: 'Instrumentos',
      },
      accumulatedHeaders: [
        'amountInvestedBalance',
        'amountUpdatedBalance',
        'incomesBalance',
        'incomesPercentage',
      ],
      headersOrder: {
        amountUpdatedBalance: 0,
        amountInvestedBalance: 1,
        incomesBalance: 2,
        incomesPercentage: 3,
        relativeWeight: 4,
        updatedQuotaAveragePrice: 5,
        quotaAveragePrice: 6,
        quotasBalance: 7,
      },
      selectedAccount: 'all',
      selectedTab: 'accounts',
      selectedColumn: 'amountUpdatedBalance',
      selectedMembershipId: null,
      selectedSubAccountId: null,
    };
  },
  props: {
    dollarPrice: {
      type: Number,
      required: true,
    },
    euroPrice: {
      type: Number,
      required: true,
    },
    ufPrice: {
      type: Number,
      required: true,
    },
    accounts: {
      type: Array,
      required: true,
    },
    headers: {
      type: Array,
      required: true,
    },
    loading: {
      type: Boolean,
      required: true,
    },
  },
  methods: {
    closeMembershipView() {
      this.selectedMembershipId = null;
    },
    changeTab(key) {
      this.selectedTab = key;
      if (key === 'accounts') {
        this.selectedAccount = 'all';
        this.selectedSubAccountId = null;
      }
      this.selectedColumn = 'amountUpdatedBalance';
      this.$refs.columnSelector.scrollTo(0, 0);
    },
    cardCurrency(account) {

      if (this.selectedTab === 'accounts') return this.$store.state.currency.currency;

      else if (this.selectedTab === 'subAccounts') return account.currency;
      
      return this.parentSubAccount(account.parentSubAccountId).currency;
    },
    selectCard(account) {
      if (this.selectedTab === 'accounts') {
        this.selectedAccount = account.id.toString();
        this.changeTab('subAccounts');
      } else if (this.selectedTab === 'subAccounts') {
        this.selectedSubAccountId = account.id;
        this.changeTab('memberships');
      } else {
        this.selectedMembershipId = account.assetId;
      }
    },
    parentAccount(parentAccountId) {
      return this.normalizedAccounts.find((account) => account.id === parentAccountId);
    },
    parentSubAccount(parentSubAccountId) {
      return this.normalizedSubAccounts.find((subAccount) => subAccount.id === parentSubAccountId);
    },
    setTitle(account) {
      if (this.selectedTab === 'accounts') return account.name;
      else if (this.selectedTab === 'subAccounts') return account.subAccountId;

      return account.assetId;
    },
    setSubTitle(account) {
      if (this.selectedTab === 'accounts') return account.rut;
      else if (this.selectedTab === 'subAccounts') return this.parentAccount(account.parentAccountId).bank.name;

      return account.name;
    },
    setDescription(account) {
      if (this.selectedTab === 'accounts') return account.bank.name;
      if (this.selectedTab === 'subAccounts') return null;

      return this.parentSubAccount(account.parentSubAccountId).subAccountId.toString();
    },
    setText(account) {
      if (this.selectedTab === 'accounts') return this.reduceColumn(account).toString();

      if (this.selectedTab === 'subAccounts') {
        return this.reduceMembershipsByColumn(account, this.selectedColumn).toString();
      }

      return (account[this.selectedColumn] || 0).toString();
    },
    setTextColor(account) {
      if (this.selectedColumn === 'incomesBalance' || this.selectedColumn === 'incomesPercentage') {
        const cardTextAsNumber = parseFloat(this.setText(account));
        if (cardTextAsNumber > 0) return 'vl-green';
        if (cardTextAsNumber < 0) return 'vl-red';
      }

      return 'vl-blue';
    },
    setTextBackground(account) {
      const textColor = this.setTextColor(account);

      return `${textColor}-light`;
    },
    setSelected(account) {
      if (this.selectedTab === 'accounts') return account.id.toString() === this.selectedAccount;
      if (this.selectedTab === 'subAccounts') return account.id === this.selectedSubAccountId;

      return false;
    },
    reduceColumn(account) {
      const subAccounts = this.subAccountsByAccountId(account.id);
      if (this.selectedColumn === 'incomesPercentage') {
        const totalAmountInvested = subAccounts.reduce((acc, curr) =>
          acc + this.reduceMembershipsByColumn(curr, 'amountInvestedBalance'), 0,
        );

        const weightedPercentageSum = subAccounts.reduce((acc, curr) =>
          acc +
          this.reduceMembershipsByColumn(curr, 'amountInvestedBalance') *
          this.reduceMembershipsByColumn(curr, 'incomesPercentage'), 0,
        );

        return weightedPercentageSum / totalAmountInvested;
      }

      return subAccounts.reduce(
        (acc, curr) => acc + this.reduceMembershipsByColumn(curr, this.selectedColumn), 0,
      );
    },
    reduceMembershipsByColumn(subAccount, column) {
      const memberships = this.membershipsBySubAccountId(subAccount.id);
      const { sumprod, totalAmountInvested, totalAmountUpdated } = getTotalValues(memberships);
      if (column === 'incomesPercentage') {

        return sumprod / totalAmountInvested;
      } else if (column === 'incomesBalance') {

        return this.convertCurrency(totalAmountUpdated - totalAmountInvested, subAccount.currency);
      }

      return this.convertCurrency(
        memberships.reduce((acc, curr) => acc + (Number(curr[column]) || 0), 0),
        subAccount.currency,
      );
    },
    convertCurrency(amount, currency) {

      if(this.selectedTab === 'accounts') { 
        if(this.$store.state.currency.currency !== currency) {
          if(currency === 'CLP') {
            if(this.$store.state.currency.currency === 'EUR') return this.transformValueToEuro(amount, currency);

            if(this.$store.state.currency.currency === 'UF') return this.transformValueToUf(amount, currency);

            return this.transformValueToDollar(amount, currency);
          }
          if(currency === 'USD') {
            if(this.$store.state.currency.currency === 'EUR') return this.transformValueToEuro(amount, currency);

            if(this.$store.state.currency.currency === 'UF') return this.transformValueToUf(amount, currency);

            return this.transformValueToClp(amount, currency);
          }
          if(currency === 'EUR') {
            if(this.$store.state.currency.currency === 'CLP') return this.transformValueToClp(amount, currency);

            if(this.$store.state.currency.currency === 'UF') return this.transformValueToUf(amount, currency);

            return this.transformValueToDollar(amount, currency);
          }
          if(currency === 'UF') {
            if(this.$store.state.currency.currency === 'CLP') return this.transformValueToClp(amount, currency);

            if(this.$store.state.currency.currency === 'EUR') return this.transformValueToEuro(amount, currency);

            return this.transformValueToDollar(amount, currency);
          }

          if(this.$store.state.currency.currency === 'EUR') return this.transformValueToEuro(amount, currency);

          if(this.$store.state.currency.currency === 'UF') return this.transformValueToUf(amount, currency);

          if(this.$store.state.currency.currency === 'USD') return this.transformValueToDollar(amount, currency);
          
          return this.transformValueToClp(amount, currency);
        } 
      };
      
      return amount;
    },
    transformValueToDollar(value, currency) {
      if(currency === 'CLP') value /= this.dollarPrice;
      if(currency === 'EUR') value = value * this.euroPrice / this.dollarPrice;
      if(currency === 'UF') value = value * this.ufPrice / this.dollarPrice;

      return value;
    },
    transformValueToEuro(value, currency) {
      if(currency === 'CLP') value /= this.euroPrice;
      if(currency === 'USD') value = value * this.dollarPrice / this.euroPrice;
      if(currency === 'UF') value = value * this.ufPrice / this.euroPrice;

      return value;
    },
    transformValueToUf(value, currency) {
      if(currency === 'CLP') value /= this.ufPrice;
      if(currency === 'USD') value = value * this.dollarPrice / this.ufPrice;
      if(currency === 'EUR') value = value * this.euroPrice / this.ufPrice;

      return value;
    },
    transformValueToClp(value, currency) {
      if(currency === 'UF') value *= this.ufPrice;
      if(currency === 'USD') value *= this.dollarPrice;
      if(currency === 'EUR') value *= this.euroPrice;

      return value;
    },
    normalizeSubAccounts(account) {
      return account.subAccounts.map((subAccount) => ({
        ...subAccount,
        parentAccountId: account.id,
        memberships: subAccount.memberships.map((memb) => memb.assetId),
      }));
    },
    normalizeMemberships(account) {
      return account.subAccounts.flatMap((subAccount) =>
        subAccount.memberships.map((memb) => ({
          ...memb,
          parentSubAccountId: subAccount.id,
          parentAccountId: account.id,
        })),
      );
    },
    subAccountsByAccountId(accountId) {
      return this.normalizedSubAccounts.filter((subAcc) => subAcc.parentAccountId === accountId);
    },
    membershipsBySubAccountId(subAccountId) {
      return this.normalizedMemberships.filter((memb) => memb.parentSubAccountId === subAccountId);
    },
  },
  computed: {
    cardAccounts() {
      if (this.selectedTab === 'accounts') return this.normalizedAccounts;
      else if (this.selectedTab === 'subAccounts') {
        return this.selectedAccount === 'all' ?
          this.normalizedSubAccounts :
          this.subAccountsByAccountId(Number(this.selectedAccount));
      }

      return this.membershipsCards;
    },
    membershipsCards() {
      if (this.selectedAccount === 'all') {
        return this.selectedSubAccountId === null ?
          this.normalizedMemberships :
          this.membershipsBySubAccountId(this.selectedSubAccountId);
      }

      return this.selectedSubAccountId === null ?
        this.membershipsBySelectedAccount :
        this.membershipsBySubAccountId(this.selectedSubAccountId);
    },
    membershipsBySelectedAccount() {
      return this.normalizedMemberships.filter(((membership) => (
        membership.parentAccountId === Number(this.selectedAccount)
      )));
    },
    selectedColumnFilter() {
      return this.headers.find((header) => header.title === this.selectedColumn).filter;
    },
    tabHeaders() {
      return this.headers.filter((header) => {
        if (this.selectedTab === 'memberships') return header.title !== 'assetId';

        return this.accumulatedHeaders.includes(header.title);
      }).sort((a, b) => (this.headersOrder[a.title] - this.headersOrder[b.title]));
    },
    normalizedAccounts() {
      return this.accounts.map((account) => ({
        ...account,
        subAccounts: account.subAccounts.map((subAccount) => subAccount.id),
      }));
    },
    normalizedSubAccounts() {
      return this.accounts.flatMap((account) => this.normalizeSubAccounts(account));
    },
    normalizedMemberships() {
      return this.accounts.flatMap((account) => this.normalizeMemberships(account));
    },
    selectedMembershipInfo() {
      const selectedMembership = this.normalizedMemberships.find(memb => memb.assetId === this.selectedMembershipId);

      return {
        ...selectedMembership,
        bank: this.parentAccount(selectedMembership.parentAccountId).bank,
        subAccountName: this.parentSubAccount(selectedMembership.parentSubAccountId).subAccountId,
        currency: this.parentSubAccount(selectedMembership.parentSubAccountId).currency,
      };
    },
  },
};
</script>

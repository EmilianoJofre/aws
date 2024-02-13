<template>
  <div>
    <div class="relative flex justify-center mb-8">
      <h1 class="text-xl font-bold text-center text-vl-blue">
        Bienvenido {{ userName }}
      </h1>
      <btn
        class="absolute right-0 ml-auto uppercase"
        :text="isDemo ? 'Terminar demo' : 'Comenzar demo'"
        :href="`/relations${isDemo ? '' : '?demo=true'}`"
      />
    </div>
    <relations
      @relation-selected="relationSelected"
      :is-demo="isDemo"
    />
    <type-active-selector
      @relation-selected="relationSelected"
      :is-demo="isDemo"
    />
    <div
      class="grid grid-cols-12 gap-4"
      ref="accountsDiv"
    >
      <accounts
        class="col-span-8"
        :banks="banks"
        :is-demo="isDemo"
      />
      <sub-accounts
        class="col-span-4"
        :currencies="currencies"
        :is-demo="isDemo"
        :properties-types="realEstateIdentifiers"
      />
    </div>
    <sub-account-wallet
      ref="wallet"
      :is-demo="isDemo"
      v-if="ifIsInvestments || selectedType === ''"
    />
    <memberships
      :all-investment-assets="investmentInstrumentsInvestmentAssets"
      :investment-assets-types="investmentAssetsTypes"
      :is-demo="isDemo"
      v-if="ifIsInvestments || selectedType === ''"
    />
    <pension-funds
      :all-investment-assets="pensionFundsInvestmentAssets"
      :investment-assets-types="investmentAssetsTypes"
      :is-demo="isDemo"
      v-if="ifIsPensionFunds || selectedType === ''"
    />
    <real-state 
      :all-investment-assets="pensionFundsInvestmentAssets"
      :investment-assets-types="investmentAssetsTypes"
      :is-demo="isDemo"
      v-if="ifIsRealEstate || selectedType === ''"
      :communes="communes"
    />
    <custom-memberships class="mb-8" v-if="ifIsInvestments || selectedType === ''"/>
    <relation-documents
      :document-type-options="documentTypeOptions"
      with-checkbox
      :is-demo="isDemo"
    />
  </div>
</template>

<script>
import Accounts from './accounts';
import CustomMemberships from './custom-memberships';
import Memberships from './memberships';
import PensionFunds from './pension-funds';
import RealState from './real-state';
import Relations from './relations';
import RelationDocuments from './relations/relation-documents';
import SubAccounts from './sub-accounts';
import SubAccountWallet from './sub-accounts/sub-account-wallet';
import TypeActiveSelector from './type-active-selector';

export default {
  components: {
    Accounts,
    CustomMemberships,
    Memberships,
    Relations,
    RelationDocuments,
    SubAccounts,
    SubAccountWallet,
    TypeActiveSelector,
    PensionFunds,
    RealState
  },
  props: {
    currencies: { type: Array, required: true },
    documentTypeOptions: { type: Array, required: true },
    allInvestmentAssets: { type: Array, required: true },
    investmentAssetsTypes: { type: Array, required: true },
    isDemo: { type: Boolean, default: false },
    isUser: { type: Boolean, default: false },
    userName: { type: String, required: true },
    investmentInstrumentsInvestmentAssets: { type: Array, required: true },
    pensionFundsInvestmentAssets: { type: Array, required: true },
    communes: { type: Array, required: true },
    realEstatesInvestmentAssets: { type: Array, required: true },
    realEstateIdentifiers: { type: Array, required: true },
    banks: { type: Array, required: true },
  },
  methods: {
    relationSelected() {
      window.scroll({
        top: this.$refs.accountsDiv.getBoundingClientRect().height,
        behavior: 'smooth',
      });
    },
  },
  computed: {
    selectedType() {
      return this.$store.state.relations.selectedActiveTypeSelector;
    },
    ifIsPensionFunds() {
      return this.selectedType === 'pension_fund';
    },
    ifIsInvestments() {
      return this.selectedType === 'investment';
    },
    ifIsRealEstate() {
      return this.selectedType === 'real_estate';
    }
  },
};
</script>

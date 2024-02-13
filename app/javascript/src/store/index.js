import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex';
import VuexPersist from 'vuex-persist';

import accounts from './accounts';
import investmentAssets from './investment-assets';
import memberships from './memberships';
import pensionFunds from './pension-funds';
import realEstate from './real-estate';
import navbar from './navbar';
import relations from './relations';
import relationFiles from './relation-files';
import subAccounts from './sub-accounts';
import user from './user';
import wallet from './wallet';
import currency from './currency';
import balances from './balances';

Vue.use(Vuex);

const vuexSessionStorage = new VuexPersist({
  key: 'vuex',
  storage: window.sessionStorage,
  reducer: (state) => ({
    navbar: {
      selectedTabIndex: state.navbar.selectedTabIndex,
    },
    currency: {
      currency: state.currency.currency
    },
    balances: {
      consolidatedCapital: state.balances.consolidatedCapital
    }
  }),
});

const vuexLocalStorage = new VuexPersist({
  key: 'vuex',
  storage: window.localStorage,
  reducer: (state) => ({
    user: {
      userType: state.user.userType,
    },
  }),
});

const store = new Vuex.Store({
  modules: {
    accounts,
    investmentAssets,
    memberships,
    navbar,
    relations,
    relationFiles,
    subAccounts,
    user,
    wallet,
    currency,
    balances,
    pensionFunds,
    realEstate
  },
  plugins: [vuexSessionStorage.plugin, vuexLocalStorage.plugin],
});

export default store;

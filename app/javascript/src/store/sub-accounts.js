import SubAccountsApi from '../api/sub-accounts';

const initialState = {
  subAccounts: [],
  selectedSubAccountId: null,
};

export const mutations = {
  setSubAccounts(state, payload) {
    state.subAccounts = payload;
  },
  addSubAccount(state, payload) {
    state.subAccounts.push(payload);
  },
  setSelectedSubAccountId(state, payload) {
    state.selectedSubAccountId = payload;
  },
};

export const actions = {
  getSubAccounts({ commit, rootState, dispatch }, isDemo) {
    return SubAccountsApi.getSubAccounts(
      rootState.accounts.selectedAccountId, isDemo,
    )
      .then(({ subAccounts }) => {
        commit('setSubAccounts', subAccounts);
        commit('setSelectedSubAccountId', null);
        dispatch('resetMemberships');
      });
  },
  addSubAccount({ commit }, payload) {
    commit('addSubAccount', payload);
  },
  setSelectedSubAccountId({ commit, dispatch }, payload) {
    commit('setSelectedSubAccountId', payload.id);
    dispatch('getMemberships', payload.isDemo);
    dispatch('getCustomMemberships', payload.isDemo);
    dispatch('getWalletMovements');
    dispatch('getRealEstate', payload.isDemo);
    dispatch('getPensionFunds', payload.isDemo);
  },
  resetSubAccounts({ commit, dispatch }) {
    commit('setSubAccounts', []);
    dispatch('resetMemberships');
  },
};

export const getters = {
  selectedSubAccountCurrency(state) {
    if (state.selectedSubAccountId) {

      if(state.subAccounts.length === 0) return 'CLP'

      return state.subAccounts.find(subAccount => subAccount.id === state.selectedSubAccountId).currency;
    }

    return 'CLP';
  },
};

export default {
  state: { ...initialState },
  actions,
  mutations,
  getters,
};

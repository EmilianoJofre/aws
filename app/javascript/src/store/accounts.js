import AccountsApi from '../api/accounts';

const initialState = {
  accounts: [],
  selectedAccountId: null,
};

export const mutations = {
  setAccounts(state, payload) {
    state.accounts = payload;
  },
  addAccount(state, payload) {
    state.accounts.push(payload);
  },
  setSelectedAccountId(state, payload) {
    state.selectedAccountId = payload;
  },
};

export const getters = {
  relationBanks: (state) => {
    const normalizedBanks = {};
    const allBanks = state.accounts.map((acc) => acc.bank);
    allBanks.forEach((bank) => {
      if (!normalizedBanks[bank.id]) {
        normalizedBanks[bank.id] = bank;
      }
    });

    return normalizedBanks;
  },
};

export const actions = {
  getAccounts({ commit, rootState, dispatch }, isDemo) {
    return AccountsApi.getAccounts(rootState.relations.selectedRelationId, isDemo)
      .then(({ accounts }) => {
        commit('setAccounts', accounts);
        commit('setSelectedAccountId', null, isDemo);
        dispatch('resetSubAccounts');
      });
  },
  getAccountsByType({ commit, rootState, dispatch }, isDemo) {
    return AccountsApi.getAccountsByType(rootState.relations.selectedRelationId, rootState.relations.selectedActiveTypeSelector, isDemo)
      .then(({ accounts }) => {
        commit('setAccounts', accounts);
        commit('setSelectedAccountId', null, isDemo);
        dispatch('resetSubAccounts');
      });
  },
  addAccount({ commit }, payload) {
    commit('addAccount', payload);
  },
  setSelectedAccountId({ commit, dispatch }, payload) {
    commit('setSelectedAccountId', payload.id);
    dispatch('getSubAccounts', payload.isDemo);
  },
};

export default {
  state: { ...initialState },
  actions,
  mutations,
  getters,
};

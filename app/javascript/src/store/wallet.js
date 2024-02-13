import WalletMovementsApi from '../api/wallet-movements';

const initialState = {
  deposits: [],
  loading: false,
  withdrawals: [],
};

export const mutations = {
  setDeposits(state, payload) {
    state.deposits = payload;
  },
  setWithdrawals(state, payload) {
    state.withdrawals = payload;
  },
  setLoading(state, payload) {
    state.loading = payload;
  },
};

export const actions = {
  getWalletMovements({ commit, rootState }) {
    commit('setLoading', true);

    WalletMovementsApi.getWalletDeposits(
      rootState.subAccounts.selectedSubAccountId,
    )
      .then(({ walletDeposits }) => { commit('setDeposits', walletDeposits); })
      .finally(() => { commit('setLoading', false); });
    WalletMovementsApi.getWalletWithdrawals(
      rootState.subAccounts.selectedSubAccountId,
    )
      .then(({ walletWithdrawals }) => { commit('setWithdrawals', walletWithdrawals); })
      .finally(() => { commit('setLoading', false); });
  },
};

export const getters = {
};

export default {
  state: { ...initialState },
  actions,
  mutations,
  getters,
};

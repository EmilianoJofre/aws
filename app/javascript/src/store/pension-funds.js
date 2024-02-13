import PensionFundsApi from '../api/pension-funds';

const initialState = {
  pensionFunds: [],
  customPensionFunds: [],
  selectedPensionFundId: null,
};

export const mutations = {
  setPensionFunds(state, payload) {
    state.pensionFunds = payload;
  },
  setCustomPensionFunds(state, payload) {
    state.customPensionFunds = payload;
  },
  setSelectedPensionFundsId(state, payload) {
    state.selectedPensionFundId = payload;
  },
  addCustomPensionFunds(state, payload) {
    state.customPensionFunds.push(payload);
  },
};

export const actions = {
  getPensionFunds({ commit, rootState }, isDemo) {
    return PensionFundsApi.getPensionFunds(
      rootState.subAccounts.selectedSubAccountId, isDemo,
    )
      .then(({ pensionFunds }) => {
        commit('setPensionFunds', pensionFunds);
      });
  },
  getCustomPensionFunds({ commit, rootState }, isDemo) {
    return PensionFundsApi.getCustomPensionFunds(
      rootState.subAccounts.selectedSubAccountId, isDemo,
    )
      .then(({ pensionFunds }) => {
        commit('setCustomPensionFunds', pensionFunds);
      });
  },
  resetPensionFunds({ commit }) {
    commit('setPensionFunds', []);
    commit('setCustomPensionFunds', []);
  },
  setSelectedPensionFundId({ commit }, payload) {
    commit('setSelectedPensionFundsId', payload);
  },
  addCustomPensionFund({ commit }, payload) {
    commit('addCustomPensionFunds', payload);
  },
  liquidateSelectedPensionFund({ state }) {
    return PensionFundsApi.liquidateMembership(state.selectedPensionFundId);
  },
};

export const getters = {
  selectedPensionFund: (state) => (type) => {
    if (type === 'custom') {
      return state.customPensionFunds.find(pensionFund => pensionFund.id === state.selectedPensionFundId);
    }

    return state.pensionFunds.find(pensionFund => pensionFund.id === state.selectedPensionFundId);
  },
  nomalizedCustomPensionFunds(state, getter) {
    return state.customPensionFunds.map(pensionFund => (
      {
        id: pensionFund.id,
        name: pensionFund.investmentAsset.name,
        quotasBalance: pensionFund.quotasBalance,
        quotaAveragePrice: pensionFund.quotaAveragePrice,
        amountInvestedBalance: pensionFund.amountInvestedBalance,
        updatedQuotaAveragePrice: pensionFund.updatedQuotaAveragePrice,
        amountUpdatedBalance: pensionFund.amountUpdatedBalance,
        incomesBalance: pensionFund.incomesBalance,
        incomesPercentage: (
          pensionFund.updatedQuotaAveragePrice / pensionFund.quotaAveragePrice - 1
        ),
        relativeWeight: pensionFund.amountUpdatedBalance / getter.aggregatedAmountUpdatedBalance,
      }
    ));
  },
  nomalizedPensionFunds(state, getter) {
    return state.pensionFunds.map(pensionFund => (
      {
        id: pensionFund.id,
        name: pensionFund.investmentAsset.name,
        assetId: pensionFund.investmentAsset.assetId,
        quotasBalance: pensionFund.quotasBalance,
        quotaAveragePrice: pensionFund.quotaAveragePrice,
        amountInvestedBalance: pensionFund.amountInvestedBalance,
        updatedQuotaAveragePrice: pensionFund.updatedQuotaAveragePrice,
        amountUpdatedBalance: pensionFund.amountUpdatedBalance,
        incomesBalance: pensionFund.incomesBalance,
        incomesPercentage: (
          pensionFund.updatedQuotaAveragePrice / pensionFund.quotaAveragePrice - 1
        ),
        relativeWeight: pensionFund.amountUpdatedBalance / getter.aggregatedAmountUpdatedBalance,
      }
    ));
  },
};

export default {
  state: { ...initialState },
  actions,
  mutations,
  getters,
};

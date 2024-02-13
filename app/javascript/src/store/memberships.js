import MembershipsApi from '../api/memberships';

const initialState = {
  memberships: [],
  customMemberships: [],
  selectedMembershipId: null,
};

export const mutations = {
  setMemberships(state, payload) {
    state.memberships = payload;
  },
  setCustomMemberships(state, payload) {
    state.customMemberships = payload;
  },
  setSelectedMembershipId(state, payload) {
    state.selectedMembershipId = payload;
  },
  addCustomMembership(state, payload) {
    state.customMemberships.push(payload);
  },
};

export const actions = {
  getMemberships({ commit, rootState }, isDemo) {
    return MembershipsApi.getMemberships(
      rootState.subAccounts.selectedSubAccountId, isDemo,
    )
      .then(({ memberships }) => {
        commit('setMemberships', memberships);
      });
  },
  getCustomMemberships({ commit, rootState }, isDemo) {
    return MembershipsApi.getCustomMemberships(
      rootState.subAccounts.selectedSubAccountId, isDemo,
    )
      .then(({ memberships }) => {
        commit('setCustomMemberships', memberships);
      });
  },
  resetMemberships({ commit }) {
    commit('setMemberships', []);
    commit('setCustomMemberships', []);
  },
  setSelectedMembershipId({ commit }, payload) {
    commit('setSelectedMembershipId', payload);
  },
  addCustomMembership({ commit }, payload) {
    commit('addCustomMembership', payload);
  },
  liquidateSelectedMembership({ state }) {
    return MembershipsApi.liquidateMembership(state.selectedMembershipId);
  },
};

export const getters = {
  aggregatedAmountUpdatedBalance: (state) => {
    const allMemberships = [...state.memberships, ...state.customMemberships];

    return allMemberships.reduce((acc, curr) => acc + Number(curr.amountUpdatedBalance), 0);
  },
  selectedMembership: (state) => (type) => {
    if (type === 'custom') {
      return state.customMemberships.find(membership => membership.id === state.selectedMembershipId);
    }

    return state.memberships.find(membership => membership.id === state.selectedMembershipId);
  },
  selectedCustomInvestmentAssetId(state) {
    return state.customMemberships.find(membership => membership.id === state.selectedMembershipId).investmentAsset.id;
  },
  nomalizedCustomMemberships(state, getter) {
    return state.customMemberships.map(membership => (
      {
        id: membership.id,
        name: membership.investmentAsset.name,
        quotasBalance: membership.quotasBalance,
        quotaAveragePrice: membership.quotaAveragePrice,
        amountInvestedBalance: membership.amountInvestedBalance,
        updatedQuotaAveragePrice: membership.updatedQuotaAveragePrice,
        amountUpdatedBalance: membership.amountUpdatedBalance,
        incomesBalance: membership.incomesBalance,
        incomesPercentage: (
          membership.updatedQuotaAveragePrice / membership.quotaAveragePrice - 1
        ),
        relativeWeight: membership.amountUpdatedBalance / getter.aggregatedAmountUpdatedBalance,
      }
    ));
  },
  nomalizedMemberships(state, getter) {
    return state.memberships.map(membership => (
      {
        id: membership.id,
        name: membership.investmentAsset.name,
        assetId: membership.investmentAsset.assetId,
        quotasBalance: membership.quotasBalance,
        quotaAveragePrice: membership.quotaAveragePrice,
        amountInvestedBalance: membership.amountInvestedBalance,
        updatedQuotaAveragePrice: membership.updatedQuotaAveragePrice,
        amountUpdatedBalance: membership.amountUpdatedBalance,
        incomesBalance: membership.incomesBalance,
        incomesPercentage: (
          membership.updatedQuotaAveragePrice / membership.quotaAveragePrice - 1
        ),
        relativeWeight: membership.amountUpdatedBalance / getter.aggregatedAmountUpdatedBalance,
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

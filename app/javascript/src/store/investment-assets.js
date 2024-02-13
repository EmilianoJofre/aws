const initialState = {
  investmentAssets: [],
  investmentAssetsTypes: [],
};

export const mutations = {
  setInvestmentAssets(state, payload) {
    state.investmentAssets = payload;
  },
  setInvestmentAssetsTypes(state, payload) {
    state.investmentAssetsTypes = payload;
  },
};

export const actions = {
  setInvestmentAssetsTypes({ commit }, investmentAssetsTypes) {
    commit('setInvestmentAssetsTypes', investmentAssetsTypes);
  },
};

export default {
  state: { ...initialState },
  actions,
  mutations,
};

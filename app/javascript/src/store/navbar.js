const initialState = {
  selectedTabIndex: 0,
  selectedSubTabIndex: '',
};

export const mutations = {
  setSelectedTabIndex(state, payload) {
    state.selectedTabIndex = payload;
  },
  setSelectedSubTabIndex(state, payload) {
    state.selectedSubTabIndex = payload;
  },
};

export const actions = {
  setSelectedTab({ commit }, index) {
    commit('setSelectedTabIndex', index);
  },
  setSelectedSubTab({ commit }, index) {
    commit('setSelectedSubTabIndex', index);
  },
};

export default {
  state: { ...initialState },
  actions,
  mutations,
};

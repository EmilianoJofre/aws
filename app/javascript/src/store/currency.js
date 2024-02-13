const initialState = {
    currency: 'CLP',
  };
  
  export const mutations = {
    setSelectedCurrency(state, payload) {
      state.currency = payload;
    },
  };
  
  export const actions = {
    onChangeCurrency({ commit }, selectedCurrency) {
      commit('setSelectedCurrency', selectedCurrency);
    },
  };
  
  export default {
    state: { ...initialState },
    actions,
    mutations,
  };
  
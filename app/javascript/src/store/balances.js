const initialState = {
    consolidatedCapital: '-',
    allBalanceByCurrency: {},
    lastUpdatedDate: ''
  };
  
  export const mutations = {
    setConsolidatedCapital(state, payload) {
      state.consolidatedCapital = payload;
    },

    setAllBalanceByCurrency(state, payload) {
      state.allBalanceByCurrency = payload
    },
    setLastUpdatedDate(state, payload) {
      state.lastUpdatedDate = payload
    }
  };
  
  export const actions = {
    getConsolidatedCapital({ commit }, currentConsolidatedCapital) {
      commit('setConsolidatedCapital', currentConsolidatedCapital);
    },

    getAllBalanceByCurrency({ commit }, currentBalanceByCurrency) {
      commit('setAllBalanceByCurrency', currentBalanceByCurrency);
    },
    
    getLastUpdatedDate({ commit }, currentLastUpdatedDate) {
      commit('setLastUpdatedDate', currentLastUpdatedDate);
    }, 
  };
  
  export default {
    state: { ...initialState },
    actions,
    mutations,
  };
  
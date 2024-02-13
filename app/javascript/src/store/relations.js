import RelationsApi from '../api/relations';

const initialState = {
  relations: [],
  loading: false,
  selectedRelationId: null,
  selectedTimeTab: 'origin',
  selectedAccounts: [],
  selectedOption: {},
  selectedActiveTypeSelector: ''
};

export const mutations = {
  setLoading(state, payload) {
    state.loading = payload;
  },
  setRelations(state, payload) {
    state.relations = [...payload];
  },
  addRelation(state, payload) {
    state.relations.push(payload);
  },
  setSelectedRelationId(state, payload) {
    state.selectedRelationId = payload;
  },
  setSelectedTimeTab(state, payload) {
    state.selectedTimeTab = payload;
  },
  setSelectedAccounts(state, payload) {
    state.selectedAccounts = payload;
  },
  setSelectedOption(state, payload) {
    state.selectedOption = payload;
  },
  setSelectedActiveTypeSelector(state, payload) {
    state.selectedActiveTypeSelector = payload;
  },
};

export const actions = {
  getRelations({ commit }, isDemo) {
    commit('setLoading', true);

    return RelationsApi.getRelations(isDemo)
      .then(({ relations }) => {
        commit('setRelations', relations);
      })
      .finally(() => {
        commit('setLoading', false);
      });
  },
  addRelation({ commit }, payload) {
    commit('addRelation', payload);
  },
  setSelectedRelationId({ commit, dispatch }, payload) {
    commit('setSelectedRelationId', payload.id);

    if(!payload.isSelectedType) {
      dispatch('getAccounts', payload.isDemo);
    } else {
      dispatch('getAccountsByType', payload.isDemo);
    }
    dispatch('getRelationFiles', payload.isDemo);
  },
  setUserSelectedTimeTab({ commit }, selectedTimeTab ) {
    commit('setSelectedTimeTab', selectedTimeTab);
  },
  setUserSelectedAccounts({ commit }, selectedAccounts ) {
    commit('setSelectedAccounts', selectedAccounts);
  },
  setSelectedOptions({ commit }, selectedOption ) {
    commit('setSelectedOption', selectedOption);
  },
  setSelectedActiveType({ commit }, selectedOption ) {
    commit('setSelectedActiveTypeSelector', selectedOption);
  },
};

export default {
  state: { ...initialState },
  actions,
  mutations,
};

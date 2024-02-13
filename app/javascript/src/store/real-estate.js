import RealEstateApi from '../api/real-estate';

const initialState = {
  realEstates: [],
  customRealEstates: [],
  selectedRealEstatesId: null,
};

export const mutations = {
  setRealEstate(state, payload) {
    state.realEstates = payload;
  },
  setCustomRealEstate(state, payload) {
    state.customRealEstates = payload;
  },
  setSelectedRealEstatesId(state, payload) {
    state.selectedRealEstatesId = payload;
  },
  addCustomRealEstate(state, payload) {
    state.customRealEstates.push(payload);
  },
};

export const actions = {
  getRealEstate({ commit, rootState }, isDemo) {
    return RealEstateApi.getRealEstate(
      rootState.subAccounts.selectedSubAccountId, isDemo,
    )
      .then(({ realEstates }) => {
        commit('setRealEstate', realEstates);
      });
  },
  getCustomRealEstate({ commit, rootState }, isDemo) {
    return RealEstateApi.getCustomRealEstate(
      rootState.subAccounts.selectedSubAccountId, isDemo,
    )
      .then(({ realEstates }) => {
        commit('setCustomRealEstate', realEstates);
      });
  },
  resetRealEstate({ commit }) {
    commit('setRealEstate', []);
    commit('setCustomRealEstate', []);
  },
  setSelectedRealEstatesId({ commit }, payload) {
    commit('setSelectedRealEstatesId', payload);
  },
  addCustomRealEstate({ commit }, payload) {
    commit('addCustomRealEstate', payload);
  },
  liquidateSelectedRealEstate({ state }) {
    return RealEstateApi.liquidateMembership(state.selectedRealEstatesId);
  },
};

export const getters = {
  selectedRealEstate: (state) => (type) => {
    if (type === 'custom') {
      return state.customRealEstates.find(realEstates => realEstates.id === state.selectedRealEstatesId);
    }

    return state.realEstates.find(realEstates => realEstates.id === state.selectedRealEstatesId);
  },
  nomalizedCustomRealEstate(state, getter) {
    return state.customRealEstates.map(realEstates => (
      {
        id: realEstates.id,
        role: realEstates.role,
        nameRe: realEstates.name,
        comune: realEstates.commune,
        assetDestination: realEstates.assetDestination,
        area: realEstates.area,
        areaAveragePrice: realEstates.costM2,
        fiscalAppraise: realEstates.fiscalAppraisal,
        amountInvestedBalanceRe: realEstates.totalInversion,
        incomesBalanceRe: realEstates.externalValorization ? realEstates.externalValorization - realEstates.totalInversion : realEstates.vlValorization ? realEstates.vlValorization - realEstates.totalInversion : null,
        vlValorization: realEstates.vlValorization,
        vlValorizationDate: realEstates.vlValorizationDate,
        externalValuation: realEstates.externalValorization,
        externalValorizationDate: realEstates.externalValorizationDate,
        externalValorizationName: realEstates.externalValorizationName,
        incomesPercentageRe: realEstates.areaAveragePrice === 0 ? 0 : 
          realEstates.externalValorization ? realEstates.externalValorization / realEstates.totalInversion - 1 : 
          realEstates.vlValorization ? realEstates.vlValorization / realEstates.totalInversion - 1: 
          null,
        relativeWeightRe: realEstates.totalInversion / getter.calculateTotalValuesInvestments,
      }
    ));
  },
  nomalizedRealEstate(state, getter) {
    return state.realEstates.map(realEstates => (
      {
        id: realEstates.id,
        role: realEstates.role,
        nameRe: realEstates.name,
        comune: realEstates.commune,
        assetDestination: realEstates.assetDestination,
        area: realEstates.area,
        areaAveragePrice: realEstates.costM2,
        fiscalAppraise: realEstates.fiscalAppraisal,
        amountInvestedBalanceRe: realEstates.totalInversion,
        incomesBalanceRe: realEstates.externalValorization ? realEstates.externalValorization - realEstates.totalInversion : realEstates.vlValorization ? realEstates.vlValorization - realEstates.totalInversion : null,
        vlValorization: realEstates.vlValorization,
        vlValorizationDate: realEstates.vlValorizationDate,
        externalValuation: realEstates.externalValorization,
        externalValorizationDate: realEstates.externalValorizationDate,
        externalValorizationName: realEstates.externalValorizationName,
        incomesPercentageRe: realEstates.areaAveragePrice === 0 ? 0 : 
          realEstates.externalValorization ? realEstates.externalValorization / realEstates.totalInversion - 1 : 
          realEstates.vlValorization ? realEstates.vlValorization / realEstates.totalInversion - 1: 
          null,
        relativeWeightRe: realEstates.totalInversion / getter.calculateTotalValuesInvestments,
      }
    ));
  },
  calculateTotalValuesInvestments(state) {
    return state.realEstates.reduce((val, membership) =>
      val + (parseFloat(membership.totalInversion || 0)),
    0) || 0;
  },
  
};

export default {
  state: { ...initialState },
  actions,
  mutations,
  getters,
};

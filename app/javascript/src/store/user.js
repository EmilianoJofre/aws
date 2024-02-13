const initialState = {
  userType: null,
  relationUserName: '',
};

const actions = {
  setUser({ commit }, { userType }) {
    commit('setUserType', userType);
  },
  setRelationName({ commit }, relationName ) {
    commit('setRelationUserName', relationName);
  },
};

const mutations = {
  setUserType(state, payload) {
    state.userType = payload;
  },
  setRelationUserName(state, payload) {
    state.relationUserName = payload;
  },
};

const getters = {
  isUser(state) {
    return state.userType === 'user';
  },
  isUserSet(state) {
    return !!state.userType;
  },
};

export default {
  state: { ...initialState },
  actions,
  mutations,
  getters,
};

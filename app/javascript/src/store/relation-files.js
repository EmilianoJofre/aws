import RelationFilesApi from '../api/relation-files';

const initialState = {
  files: [],
  filename: "",
  fileSize: 1000000,
  isFinished: false,
  isOpenNackbar: false,
};

export const mutations = {
  setFiles(state, payload) {
    state.files = payload;
  },
  setFilename(state, payload) {
    state.filename = payload;
  },
  verifyIsFinished(state, payload) {
    state.isFinished = payload
  },
  validateIfIsOpenNackbar(state, payload) {
    state.isOpenNackbar = payload
  }
};

export const actions = {
  getRelationFiles({ commit, rootState }, isDemo) {
    return RelationFilesApi.getFiles(rootState.relations.selectedRelationId, isDemo)
      .then(({ relationFiles }) => { commit('setFiles', relationFiles); });
  },
  setFileName({ commit }, filename) {
    commit('setFilename', filename);
  },
  validateDownload({ commit }, isFinished) {
    commit('verifyIsFinished', isFinished);
  },
  isOpenNackBar({ commit }, isOpen) {
    commit('validateIfIsOpenNackbar', isOpen);
  }
};

export default {
  state: { ...initialState },
  actions,
  mutations,
};

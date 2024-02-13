import api from './index';

const basePath = '/api/v1/relation_histories';

export default {
  deleteDates(relationHistoryId, datesToRemove) {
    return api({
      method: 'patch',
      url: `${basePath}/${relationHistoryId}`,
      params: { datesToRemove },
    });
  },
};

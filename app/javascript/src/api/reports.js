import api from './index';

function basePath(subAccountId) {
  return `/api/v1/sub_accounts/${subAccountId}/report`;
}

export default {
  getReport(subAccountId) {
    return api({
      method: 'get',
      url: basePath(subAccountId),
    });
  },
};

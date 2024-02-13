import api from './index';

function basePath(relationId) {
  return `/api/v1/relations/${relationId}/accounts`;
}

export default {
  getAccounts(relationId, isDemo = false) {
    return api({
      method: 'get',
      url: basePath(relationId),
      params: { isDemo },
    });
  },
  getAccountsByType(relationId, assetType, isDemo = false) {
    return api({
      method: 'get',
      url: `${basePath(relationId)}/asset_type/${assetType}`,
      params: { isDemo },
    });
  },
  createAccount(relationId, account) {
    return api({
      method: 'post',
      url: basePath(relationId),
      data: account,
    });
  },
  editAccount(relationId, account) {
    return api({
      method: 'patch',
      url: `${basePath(relationId)}/${account.id}`,
      data: account,
    });
  },
  deleteAccount(relationId, account) {
    return api({
      method: 'delete',
      url: `${basePath(relationId)}/${account.id}`,
    });
  },
};

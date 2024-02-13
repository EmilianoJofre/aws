import api from './index';

function basePath(accountId) {
  return `/api/v1/accounts/${accountId}/sub_accounts`;
}

export default {
  getSubAccounts(accountId, isDemo = false) {
    return api({
      method: 'get',
      url: basePath(accountId),
      params: { isDemo },
    });
  },
  createSubAccount(accountId, subAccount) {
    return api({
      method: 'post',
      url: basePath(accountId),
      data: subAccount,
    });
  },
  editSubAccount(accountId, subAccount) {
    return api({
      method: 'patch',
      url: `${basePath(accountId)}/${subAccount.id}`,
      data: subAccount,
    });
  },
  deleteSubAccount(accountId, subAccount) {
    return api({
      method: 'delete',
      url: `${basePath(accountId)}/${subAccount.id}`,
    });
  },
  searchMembership(subAccountId, asset) {
    return api({
      method: 'get',
      url: `/api/v1/sub_accounts/${subAccountId}/membership`,
      params: asset,
    });
  },
};

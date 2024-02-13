import api from './index';

function basePath(subAccountId) {
  return `/api/v1/sub_accounts/${subAccountId}/pension_funds`;
}

export default {
  getPensionFunds(subAccountId, isDemo = false) {
    return api({
      method: 'get',
      url: basePath(subAccountId),
      params: { isDemo },
    });
  },
  createPensionFunds(subAccountId, membership) {
    return api({
      method: 'post',
      url: basePath(subAccountId),
      data: membership,
    });
  },
  getCustomPensionFunds(subAccountId, isDemo = false) {
    return api({
      method: 'get',
      url: `/api/v1/sub_accounts/${subAccountId}/custom_memberships`,
      params: { isDemo },
    });
  },
  hidePensionFunds(membership) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membership.id}`,
      params: { hidden: true },
    });
  },
  enablePensionFunds(membershipId) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membershipId}/enable`,
    });
  },
  liquidatePensionFunds(membership) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membership.id}/liquidate`,
    });
  },
};

import api from './index';

function basePath(subAccountId) {
  return `/api/v1/sub_accounts/${subAccountId}/memberships`;
}

export default {
  getMemberships(subAccountId, isDemo = false) {
    return api({
      method: 'get',
      url: basePath(subAccountId),
      params: { isDemo },
    });
  },
  createMembership(subAccountId, membership) {
    return api({
      method: 'post',
      url: basePath(subAccountId),
      data: membership,
    });
  },
  getCustomMemberships(subAccountId, isDemo = false) {
    return api({
      method: 'get',
      url: `/api/v1/sub_accounts/${subAccountId}/custom_memberships`,
      params: { isDemo },
    });
  },
  hideMembership(membership) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membership.id}`,
      params: { hidden: true },
    });
  },
  enableMembership(membershipId) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membershipId}/enable`,
    });
  },
  liquidateMembership(membership) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membership.id}/liquidate`,
    });
  },
};

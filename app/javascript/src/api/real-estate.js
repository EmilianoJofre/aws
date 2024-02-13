import api from './index';

function basePath(subAccountId) {
  return `/api/v1/sub_accounts/${subAccountId}/real_estates`;
}

export default {
  getRealEstate(subAccountId, isDemo = false) {
    return api({
      method: 'get',
      url: basePath(subAccountId),
      params: { isDemo },
    });
  },
  createRealEstate(subAccountId, membership) {
    return api({
      method: 'post',
      url: basePath(subAccountId),
      data: membership,
    });
  },
  updateRealEstate(subAccountId, membership, realEstateId) {
    return api({
      method: 'patch',
      url: `${basePath(subAccountId)}/${realEstateId}`,
      data: membership,
    });
  },
  createExternalValorization(subAccountId, membership) {
    return api({
      method: 'post',
      url: `${basePath(subAccountId)}/update_external_valorization`,
      data: membership,
    });
  },
  getRoles(subAccountId, isDemo = false) {
    return api({
      method: 'get',
      url: `/api/v1/sub_accounts/${subAccountId}/roles`,
      params: { isDemo },
    });
  },
  getCustomRealEstate(subAccountId, isDemo = false) {
    return api({
      method: 'get',
      url: `/api/v1/sub_accounts/${subAccountId}/custom_memberships`,
      params: { isDemo },
    });
  },
  hideRealEstate(membership) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membership.id}`,
      params: { hidden: true },
    });
  },
  enableRealEstate(membershipId) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membershipId}/enable`,
    });
  },
  liquidateRealEstate(membership) {
    return api({
      method: 'patch',
      url: `/api/v1/memberships/${membership.id}/liquidate`,
    });
  },
};

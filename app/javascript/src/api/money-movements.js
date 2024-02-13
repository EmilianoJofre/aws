import api from './index';

function basePath(membershipId) {
  return `/api/v1/memberships/${membershipId}/money_movements`;
}

export default {
  createMoneyMovement(membershipId, moneyMovement) {
    return api({
      method: 'post',
      url: basePath(membershipId),
      data: moneyMovement,
    });
  },
  editMoneyMovement(oldMoneyMovement, newMoneyMovement) {
    return api({
      method: 'PATCH',
      url: `/api/v1/money_movements/${oldMoneyMovement.id}`,
      data: newMoneyMovement,
    });
  },
  destroyMoneyMovement(membershipId, moneyMovement) {
    return api({
      method: 'DELETE',
      url: `${basePath(membershipId)}/${moneyMovement.id}`,
    });
  },
};

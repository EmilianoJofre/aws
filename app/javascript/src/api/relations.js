import api from './index';

const basePath = '/api/v1/relations';

export default {
  getRelations(isDemo = false) {
    return api({
      method: 'get',
      url: basePath,
      params: { isDemo },
    });
  },
  createRelation(relation) {
    return api({
      method: 'post',
      url: basePath,
      data: relation,
    });
  },
  editRelation(relation) {
    return api({
      method: 'patch',
      url: `${basePath}/${relation.id}`,
      data: relation,
    });
  },
  deleteRelation(relation) {
    return api({
      method: 'delete',
      url: `${basePath}/${relation.id}`,
    });
  },
  getInvestments(relationId, accountId, isDemo = false) {
    return api({
      method: 'get',
      url: `${basePath}/${relationId}/investments?id=${accountId}`,
      params: { isDemo },
    });
  },
  getInvestmentsRealEstate(relationId, accountId, isDemo = false) {
    return api({
      method: 'get',
      url: `${basePath}/${relationId}/investments_with_real_estate?id=${accountId}`,
      params: { isDemo },
    });
  },
  getChartHistory(relationId, accountIds, timeWindow) {
    const queryIds = `?ids[]=${accountIds.join('&ids[]=')}`;

    return api({
      method: 'get',
      url: `${basePath}/${relationId}/chart_history${queryIds}&window=${timeWindow}`,
    });
  },
  getHistoryBalances(relationId, fromDate) {
    return api({
      method: 'get',
      url: `${basePath}/${relationId}/history_balances?from=${fromDate}`,
    });
  },
  getWalletBalances(relationId, fromDate) {
    return api({
      method: 'get',
      url: `${basePath}/${relationId}/wallet_balances?from=${fromDate}`,
    });
  },
  updateCharts(relationId) {
    return api({
      method: 'put',
      url: `${basePath}/${relationId}/queue_chart_update`,
    });
  },
  // eslint-disable-next-line no-magic-numbers
  getMoneyMovements(relationId, pageNumber = 1, pageSize = 10) {
    return api({
      method: 'get',
      url: `${basePath}/${relationId}/money_movements?page[number]=${pageNumber}&page[size]=${pageSize}`,
    });
  },
};

import api from './index';

function basePath() {
  return '/api/v1/investment_assets';
}

export default {
  createInvestmentAsset(asset) {
    return api({
      method: 'post',
      url: basePath(),
      data: asset,
    });
  },
  createCustomAsset(subAccountId, asset) {
    return api({
      method: 'post',
      url: `/api/v1/sub_accounts/${subAccountId}/custom_asset`,
      data: asset,
    });
  },
  getInvestmentAssets(relationId, isDemo = false) {
    return api({
      method: 'get',
      url: basePath(),
      params: { relationId, isDemo },
    });
  },
};

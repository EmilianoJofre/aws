import api from './index';

function basePath(assetId) {
  return `/api/v1/investment_assets/${assetId}/price_changes`;
}

export default {
  createPriceChange(assetId, priceChange) {
    return api({
      method: 'post',
      url: basePath(assetId),
      data: priceChange,
    });
  },
};

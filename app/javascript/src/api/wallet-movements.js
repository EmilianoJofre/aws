import api from './index';

function basePath(subAccountId) {
  return `/api/v1/sub_accounts/${subAccountId}`;
}

export default {
  createWalletDeposit(subAccountId, data) {
    return api({
      method: 'post',
      url: `${basePath(subAccountId)}/wallet_deposits`,
      data,
    });
  },
  editWalletDeposit(subAccountId, walletDepositId, data) {
    return api({
      method: 'patch',
      url: `${basePath(subAccountId)}/wallet_deposits/${walletDepositId}`,
      data,
    });
  },
  getWalletDeposits(subAccountId) {
    return api({
      method: 'get',
      url: `${basePath(subAccountId)}/wallet_deposits`,
    });
  },
  createWalletWithdrawal(subAccountId, data) {
    return api({
      method: 'post',
      url: `${basePath(subAccountId)}/wallet_withdrawals`,
      data,
    });
  },
  editWalletWithdrawal(subAccountId, walletWithdrawalId, data) {
    return api({
      method: 'patch',
      url: `${basePath(subAccountId)}/wallet_withdrawals/${walletWithdrawalId}`,
      data,
    });
  },
  getWalletWithdrawals(subAccountId) {
    return api({
      method: 'get',
      url: `${basePath(subAccountId)}/wallet_withdrawals`,
    });
  },
  getWalletMonthWithdrawals(subAccountId, params) {
    return api({
      method: 'get',
      url: `${basePath(subAccountId)}/month_withdrawals`,
      params,
    });
  },
  getWalletMonthDeposits(subAccountId, params) {
    return api({
      method: 'get',
      url: `${basePath(subAccountId)}/month_deposits`,
      params,
    });
  },
  deleteWalletDeposit(subAccountId, walletDepositId) {
    return api({
      method: 'delete',
      url: `${basePath(subAccountId)}/wallet_deposits/${walletDepositId}`,
    });
  },
  deleteWalletWithdrawal(subAccountId, walletWithdrawalId) {
    return api({
      method: 'delete',
      url: `${basePath(subAccountId)}/wallet_withdrawals/${walletWithdrawalId}`,
    });
  },
};

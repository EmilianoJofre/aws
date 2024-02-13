export default function getTotalValues(memberships) {
  const sumprod = memberships.reduce((val, membership) => val + (
    (membership.amountInvestedBalanceRe || 0) * (membership.incomesPercentageRe || 0)
  ), 0);
  const totalAmountInvested = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.totalInversion || 0)),
  0) || 0;
  const totalAmountUpdated = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.externalValuation ? membership.externalValuation - membership.amountInvestedBalanceRe : membership.vlValorization ? membership.vlValorization - membership.amountInvestedBalanceRe : null || 0)),
  0) || 0;
  const totalRelativeWeight = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.relativeWeightRe || 0)),
  0) || 0;
  const totalExternalAmountUpdated = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.externalValuation || 0)),
  0) || 0;
  const totalSumAmountInvested = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.amountInvestedBalanceRe || 0)),
  0) || 0;
  const totalSumEarnings = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.incomesBalanceRe || 0)),
  0) || 0;

  const totalPercentUpdated = totalSumEarnings / totalSumAmountInvested
    
  return { sumprod, totalAmountInvested, totalAmountUpdated, totalRelativeWeight, totalExternalAmountUpdated, totalPercentUpdated };
}


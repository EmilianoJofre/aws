export default function getTotalValues(memberships) {
  const sumprod = memberships.reduce((val, membership) => val + (
    (membership.amountInvestedBalance || 0) * (membership.incomesPercentage || 0)
  ), 0);
  const totalAmountInvested = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.amountInvestedBalance || 0)),
  0) || 0;
  const totalAmountUpdated = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.amountUpdatedBalance || 0)),
  0) || 0;
  const totalRelativeWeight = memberships.reduce((val, membership) =>
    val + (parseFloat(membership.relativeWeight || 0)),
  0) || 0;

  return { sumprod, totalAmountInvested, totalAmountUpdated, totalRelativeWeight };
}

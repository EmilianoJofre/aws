
function formattersTypes(currency) {
  const formatters = {
    'CLP': 'es-CL',
    'USD': 'en-US',
    'EUR': 'de-DE',
    'UF': 'de-DE',
  }
  
  return formatters[currency]
}

export default function currencyFormatter(currency, minDigits, maxDigits) {
  if(currency === 'UF') return new Intl.NumberFormat(formattersTypes(currency), {
    currencyDisplay: 'symbol',
    useGrouping: true,
    minimumFractionDigits: minDigits,
    maximumFractionDigits: maxDigits,
  });

  return new Intl.NumberFormat(formattersTypes(currency), {
    style: 'currency',
    currency: !currency ? 'CLP' : currency,
    currencyDisplay: 'symbol',
    useGrouping: true,
    minimumFractionDigits: minDigits,
    maximumFractionDigits: maxDigits,
  });
}


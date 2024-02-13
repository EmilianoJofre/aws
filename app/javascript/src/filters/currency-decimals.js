import currencyFormatter from './currency-formatter';

const tenMillions = 10000000;
const oneMillion = 1000000;

export default function currency(value, currentCurrency, maxDigits) {
  if (value === undefined || value === null) return '-';
  else if (Math.abs(value) > tenMillions) {
    return `${currentCurrency === 'EUR' || currentCurrency === 'UF' ? '' : currentCurrency}${currencyFormatter(currentCurrency, 1, maxDigits).format(value / oneMillion)} M ${currentCurrency === 'UF' ? currentCurrency : ''}`;
  }

  return `${currentCurrency === 'EUR' || currentCurrency === 'UF' ? '' : currentCurrency}${currencyFormatter(currentCurrency, 1, maxDigits).format(value)} ${currentCurrency === 'UF' ? currentCurrency : ''} `;
}
import quantityFormatter from './quantity-formatter';

export default function quantity(value, currentCurrency) {
    if (value === undefined || value === null) return '-';

    return `${quantityFormatter('USD', 1, 1).format(value)}`;
  }
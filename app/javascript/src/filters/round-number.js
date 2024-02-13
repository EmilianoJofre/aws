import NumberFormatter from './number-formatter';

export default function number(value) {
  if (value === undefined || value === null) return '-';

  return new NumberFormatter(0, 1).format(value);
}

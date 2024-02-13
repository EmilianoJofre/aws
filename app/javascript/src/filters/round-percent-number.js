import NumberFormatter from './number-formatter';

export default function percentNumber(value) {
  return new NumberFormatter(0, 2).format(value || 0) + ' %';
}

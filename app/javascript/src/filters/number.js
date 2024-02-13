import NumberFormatter from './number-formatter';

export default function number(value) {
  return new NumberFormatter(1).format(value);
}

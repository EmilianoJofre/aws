import dateFormatter from './date-formatter';

export default function dateTime(value) {
  if (value) {
    return dateFormatter(value).format('DD/MM/YYYY - HH:mm');
  }

  return value;
}

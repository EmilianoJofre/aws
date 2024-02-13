import dateFormatter from './date-formatter';

export default function dateTime(value) {
  if (value) {
    if(dateFormatter(value).format('DD-MM-YYYY') === 'Invalid date') return value
    
    return dateFormatter(value).format('DD-MM-YYYY');
  }

  return value;
}

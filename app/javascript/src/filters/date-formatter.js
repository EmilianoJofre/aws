import moment from 'moment';

export default function dateFormatter(value) {
  return moment.utc(String(value));
}

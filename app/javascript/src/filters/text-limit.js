const STR_LIMIT = 10;

export default function textLimit(value, limit = STR_LIMIT) {
  if (value && value.length > limit) {
    return `${value.substring(0, limit)}...`;
  }

  return value;
}

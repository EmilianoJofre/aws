export default function currency(minDigits, maxDigits) {
  return new Intl.NumberFormat('es-CL', {
    minimumFractionDigits: minDigits,
    maximumFractionDigits: maxDigits,
  });
}

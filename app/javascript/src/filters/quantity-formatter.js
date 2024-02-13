export default function quantityFormatter(currency, minDigits, maxDigits) {
    return new Intl.NumberFormat('es-CL', {
      currency: currency ,
      useGrouping: true,
      minimumFractionDigits: minDigits,
      maximumFractionDigits: maxDigits,
    });
  }
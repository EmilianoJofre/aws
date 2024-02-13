export default function percent(value) {
  const formatter = new Intl.NumberFormat('es-CL', {
    style: 'percent',
    minimumFractionDigits: 1,
    maximumFractionDigits: 2,
  });

  return `${formatter.format(value || 0)}`;
}
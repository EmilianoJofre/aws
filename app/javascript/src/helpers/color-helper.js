export default function hexToRgb(hexColor) {
  if (!hexColor) return null;

  const hexRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
  const hexCode = hexColor.replace(hexRegex, (_, r, g, b) => r + r + g + g + b + b);
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hexCode);

  if (!result) return null;

  const [, r, g, b] = result;

  return {
    r: parseInt(r, 16),
    g: parseInt(g, 16),
    b: parseInt(b, 16),
  };
}

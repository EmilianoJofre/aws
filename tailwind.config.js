/* eslint-disable no-undef */
const plugin = require('tailwindcss/plugin');

module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#1c1733',
        secondary: '#e2e2e2',
        background: '#fff',
        vl: {
          blue: '#4f52ff',
          'blue-light': '#eaeaff',
          'blue-gray': '#d3d3ff',
          'blue-purple': '#3F42CC',
          'background-blue': '#EAEAFD',
          'blue-500': '#2E31D0',
          'blue-600': '#5052F6',
          gray: '#818181',
          'gray-value-50':'#E1E2FF',
          'gray-50':'#F4F5F7',
          'gray-75':'#DFE1E5',
          'gray-100': '#f4f4f4',
          'value': '#AAABFF',
          'gray-200': '#c0c0c0',
          'gray-300': '#8B93A2',
          'gray-400': '#6D778A',
          'gray-500': '#535F77',
          'gray-650': '#293755',
          'gray-light': '#c4c4c4',
          'gray-lightest': '#f9f9f9',
          'gray-transparent':'#E2E8F0',
          'gray-lighting': '#f3f3f3',
          green: '#62a838',
          'green-light': '#f5ffe9',
          red: '#fc4347',
          'red-light': '#ffebeb',
          yellow: '#f9cf1c',
          'green-success': '#62E1A5',
        },
      },
      backgroundOpacity: {
        '90': '0.9',
      },
      borderColor: {
        primary: '#1c1733',
      },
      fontFamily: {
        'sans': ['Roboto', 'sans-serif'],
        'roboto': ['Roboto Mono', 'monospace'],
      },
      textColor: {
        primary: '#1C1833',
      },
      fontSize: {
        xs: ['9.33px', '11px'],
        xs2: ['10px', '10px'],
        vl: ['11px', '12.36px'],
        vl2: ['11px', '13.91px'],
        sm: ['14px', '20px'],
        sm2: ['12px', '12px'],
        sm3: ['12px', '14px'],
        base: ['16px', '24px'],
        lgOriginal: ['18px', '21px'],
        lg: ['20px', '28px'],
        xl: ['26px', '32px'],
      },
      spacing: {
        '8.5': '2.125rem',
      },
    },
  },
  variants: {},
  plugins: [
    plugin(({ addUtilities }) => {
      addUtilities({
        '.no-scrollbar::-webkit-scrollbar': {
          'display': 'none',
        },
        '.no-scrollbar': {
          '-ms-overflow-style': 'none',
          'scrollbar-width': 'none',
        },
      });
    }),
  ],
  purge: {
    enabled: process.env.NODE_ENV === 'production',
    options: {
      whitelist: [
        'text-vl-green', 'bg-vl-green-light', 'text-vl-red', 'bg-vl-red-light', 'border-vl-green', 'border-vl-red',
      ],
    },
    content: [
      './app/**/*.html',
      './app/**/*.vue',
      './app/**/*.js',
      './app/**/*.erb',
    ],
  },
};

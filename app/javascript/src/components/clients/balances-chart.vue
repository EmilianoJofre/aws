<template>
  <div>
    <line-chart
      class="mt-4"
      :height="height"
      :chart-data="chartData"
      :options="{
        ...options,
        tooltips: {
          custom: (tooltip) => {
            if (!tooltip) return;
            tooltip.displayColors = false;
          },
          callbacks: {
            title: (data) => formatXTick(data[0].label),
            label: (data) => formatYTick(data.yLabel),
          },
          backgroundColor: 'rgb(129, 129, 129, 0.9)'
        },
        legend: { display: false },
        onClick: (_, item) => dotClick(item),
        scales: {
          ...scalesOptions,
          yAxes: [{
            position: 'right', ticks: { callback: (value, ..._) => formatYTick(value), ...yAxesTicksOptions }
          }],
          xAxes: [{
            ticks: { callback: (value, ..._) => formatXTick(value) }
          }],
        },
      }"
    />
  </div>
</template>
<script>
import { camelize } from 'humps';
import resolveConfig from 'tailwindcss/resolveConfig';
import tailwindConfig from '../../../../../tailwind.config';
import LineChart from '../../charts/line-chart.js';
import hexToRgb from '../../helpers/color-helper';

export default {
  props: {
    balances: { type: Object, required: true },
    datesToDelete: { type: Object, required: true },
    wallets: { type: Object, required: true },
    currency: { type: String, required: true },
    height: { type: Number, default: 100 },
    options: { type: Object, default: () => ({}) },
  },
  components: { LineChart },
  data() {
    const { theme } = resolveConfig(tailwindConfig);
    const vlBlue = theme.backgroundColor.vl.blue;
    const vlBlueLight = theme.backgroundColor.vl['blue-light'];
    const vlRed = theme.backgroundColor.vl.red;
    const vlYellow = theme.backgroundColor.vl.yellow;
    const yellowRgb = hexToRgb(vlYellow);
    const blueLightRgb = hexToRgb(vlBlueLight);
    const rgbaYellow = `rgba(${yellowRgb.r}, ${yellowRgb.g}, ${yellowRgb.b}, 0.75)`;
    const rgbaBlueLight = `rgba(${blueLightRgb.r}, ${blueLightRgb.g}, ${blueLightRgb.b}, 0.75)`;

    return {
      rgbaYellow,
      rgbaBlueLight,
      vlBlue,
      vlRed,
      vlYellow,
    };
  },
  computed: {
    accountData() {
      return Object.values(this.balances).map((date) =>
        date.selected.balance[camelize(this.currency)],
      );
    },
    walletData() {
      return Object.values(this.wallets).map((date) =>
        date.selected[camelize(this.currency)],
      );
    },
    chartData() {
      return {
        labels: Object.keys(this.balances),
        datasets: [
          {
            label: this.label,
            data: this.accountData,
            borderColor: this.vlBlue,
            backgroundColor: this.rgbaBlueLight,
            pointBorderColor: this.dotsColors,
            pointBackgroundColor: this.dotsColors,
          },
          {
            label: this.label,
            data: this.walletData,
            borderColor: this.vlYellow,
            backgroundColor: this.rgbaYellow,
          },
        ],
      };
    },
    dotsColors() {
      return this.accountData.map((_, index) => {
        if (this.datesToDelete[index]) return this.vlRed;

        return this.vlBlue;
      });
    },
    label() {
      if (this.balances.length) {
        return Object.values(this.balances)[0].selected.name;
      }

      return '';
    },
    scalesOptions() {
      return this.options.scales || {};
    },
    yAxesTicksOptions() {
      return this.scalesOptions.yAxes ? this.scalesOptions.yAxes[0].ticks : {};
    },
  },
  methods: {
    formatXTick(value) {
      return this.$options.filters.date(value);
    },
    formatYTick(value) {
      return this.$options.filters.currency(value, this.currency);
    },
    dotClick(item) {
      if (!!item[0]) {
        // eslint-disable-next-line no-underscore-dangle
        const dataIndex = item[0]._index;
        this.$emit('point-clicked', dataIndex);
      }
    },
  },
};
</script>

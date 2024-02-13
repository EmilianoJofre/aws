import Vue from 'vue/dist/vue.esm';
import VModal from 'vue-js-modal';
import VueI18n from 'vue-i18n';
import vSelect from 'vue-select';
import Notifications from 'vue-notification';
import VTooltip from 'v-tooltip';
import Textra from 'vue-textra'
import { InlineSvgPlugin } from 'vue-inline-svg';
import { camelizeKeys } from 'humps';
import { ValidationProvider, ValidationObserver } from 'vee-validate';
import { rutInputDirective } from 'vue-dni';
import '../css/application.css';
import Loading from '../src/components/shared/loading.vue';
import Btn from '../src/components/shared/btn.vue';
import IconBtn from '../src/components/shared/icon-btn.vue';
import InfoTooltip from '../src/components/shared/info-tooltip.vue';
import VlInput from '../src/components/shared/vl-input.vue';
import VlSwitch from '../src/components/shared/vl-switch.vue';
import VlMultiselect from '../src/components/shared/vl-multiselect.vue';
import navbar from '../src/components/navbar.vue';
import AssetsMetrics from '../src/components/assets-metrics/assets-metrics.vue';
import MoneyMovementsIndex from '../src/components/relation-movements/money-movements-index.vue';
import relationsIndex from '../src/components/relations-index.vue';
import RelationReport from '../src/components/reports/relation-report.vue';
import clientIndex from '../src/components/clients/client-index.vue';
import store from '../src/store/index';
import date from '../src/filters/date';
import dateTime from '../src/filters/date-time';
import currency from '../src/filters/currency';
import currencyDecimals from '../src/filters/currency-decimals';
import quantity from '../src/filters/quantity';
import integerCurrency from '../src/filters/integer-currency';
import number from '../src/filters/number';
import roundNumber from '../src/filters/round-number';
import roundPercentNumber from '../src/filters/round-percent-number';
import percent from '../src/filters/percent';
import textLimit from '../src/filters/text-limit';
import Locales from '../locales/locales.js';
import topbar from '../src/components/topbar.vue';
import snackbar from '../src/components/nackbar-download.vue';
import progressbar from '../src/components/shared/progresive-bar.vue';
import '../config/vee-validate';

if(process.env.NODE_ENV !== 'production') Vue.config.devtools = true;
Vue.component('VSelect', vSelect);
Vue.component('ValidationProvider', ValidationProvider);
Vue.component('ValidationObserver', ValidationObserver);
Vue.component('AssetsMetrics', AssetsMetrics);
Vue.component('MoneyMovementsIndex', MoneyMovementsIndex);
Vue.component('Btn', Btn);
Vue.component('IconBtn', IconBtn);
Vue.component('Loading', Loading);
Vue.component('InfoTooltip', InfoTooltip);
Vue.component('VlInput', VlInput);
Vue.component('VlSwitch', VlSwitch);
Vue.component('VlMultiselect', VlMultiselect);
Vue.component('RelationReport', RelationReport);

Vue.use(VModal, { dynamic: true });
Vue.use(Notifications);
Vue.use(VueI18n);
Vue.use(VTooltip);
Vue.use(InlineSvgPlugin);
Vue.use(Textra);

Vue.directive('rut', rutInputDirective);

Vue.filter('date', date);
Vue.filter('dateTime', dateTime);
Vue.filter('currency', currency);
Vue.filter('currencyDecimals', currencyDecimals);
Vue.filter('quantity', quantity);
Vue.filter('integerCurrency', integerCurrency);
Vue.filter('number', number);
Vue.filter('roundNumber', roundNumber);
Vue.filter('roundPercentNumber', roundPercentNumber);
Vue.filter('percent', percent);
Vue.filter('text-limit', textLimit);
Vue.filter('camelizeKeys', camelizeKeys);

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#vue-app',
    components: {
      navbar,
      relationsIndex,
      clientIndex,
      topbar,
      snackbar,
      progressbar
    },
    store,
    i18n: new VueI18n({
      locale: 'es',
      messages: Locales.messages,
    }),
  });

  return app;
});

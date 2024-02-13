<template>
  <div v-if="relationView" class="fixed z-40 w-full py-px border-b bg-vl-blue-light text-primary">
    <notifications
      group="app-notification"
    />
    <div class="mx-2 sm:mx-4">
      <div
        class="flex items-center justify-between w-full h-full lg:grid lg:place-items-center"
        :class="[relationView ? 'grid-cols-7' : 'grid-cols-2']"
      >
        <p class="font-semibold text-sm2 sm:text-base font-sm text-vl-blue"> {{screenSize ? initialLastname : userName }} </p>
        
        <textra 
          v-if="relationView" 
          :data="getDataForTextra" 
          :timer="5" 
          :infinite='true' 
          filter="left-right" 
        />

        <div
          v-if="relationView"
          class="self-end hidden col-span-5 space-x-8 sm:flex lg:self-center lg:flex"
        >
          <div v-for="(coin, index) in currenciesData" :key="index" :class='`text-sm text-center uppercase hidden lg:justify-end lg:flex text-vl-blue ${coin.name === currency ? "condition-text" : ""}`'>
            {{coin.name}}: <p class="pl-2 font-semibold">{{coin.modifiedPrice | currencyDecimals(currency, getMaxDigits(coin.name))}} </p>
          </div>
          <div class="text-sm text-center uppercase lg:justify-end lg:flex text-vl-blue ">
            Consolidado activos total: <p class="pl-2 font-semibold"> {{allBalanceByCurrency | currency(currency)}} </p>
            <info-tooltip
              class="self-end hidden w-5 h-5 ml-2 text-vl-blue lg:self-center lg:flex"
              :text="tooltipText"
              placement="bottom"
            />
          </div>
        </div>
        <div class="flex flex-col items-center my-1 text-right sm:mr-2 justify-self-end">
          <currency-selector
            @change-currency="onChangeCurrency"
          />
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import CurrencySelector from './shared/curreny-selector.vue';

  export default {
    props: {
      relationView: { type: Boolean, default: false },
      userType: { type: String, required: true },
      userName: { type: String, required: true },
      initialLastname: { type: String, required: true },
      dollarPrice: { type: String, required: true },
      euroPrice: { type: String, required: true },
      ufPrice: { type: String, required: true },
    },
    data() {
      return {
        selectedCurrency: this.$store.state.currency.currency,
        screenSize: screen.width < 352,
        currenciesData: [
          {name:'USD', price:this.dollarPrice},
          {name:'EUR', price:this.euroPrice},
          {name:'CLP', price:this.dollarPrice},
          {name:'UF', price:this.ufPrice},
        ],
      };
    },
    components: {
      CurrencySelector,
    },
    computed: {
      currency() {
        return this.$store.state.currency.currency;
      },
      allBalanceByCurrency() {
        return this.$store.state.balances.allBalanceByCurrency[this.$store.state.currency.currency];
      },
      getDataForTextra() {
        return this.dataTextra()
      },
      tooltipText() {
        return `${this.$t('message.clientBalances.consolidatedCapital.info', { date: this.filteredLastUpdated })}`;
      },
      filteredLastUpdated() {
        return this.$options.filters.date(this.getLastUpdatedDate.replace(' UTC | camelizeKeys', ''));
      },
      getLastUpdatedDate() {
        return this.$store.state.balances.lastUpdatedDate;
      },
    },
    methods: {
      onChangeCurrency(selectedCurrency) {
        this.dataForTextra = []
        this.dataTextra()
        this.modifyPropertyCurrenciesData(selectedCurrency)
        this.$store.dispatch('onChangeCurrency', selectedCurrency);
      },
      transformCurrency(value, currency) {
        return this.$options.filters.currencyDecimals(value, this.currency, this.getMaxDigits(currency))
      },
      transformValueByCurrency(firstValue, secondValue) {
        return secondValue / firstValue 
      },
      findSelectedCurrencyPrice(selectedCurrency) {
        return this.currenciesData.find(coin => coin.name === selectedCurrency).price
      },
      modifyPropertyCurrenciesData(selectedCurrency) {
        if(selectedCurrency === 'CLP') return this.currenciesData.map(coin => coin.modifiedPrice = coin.price)

        return this.currenciesData.map(coin => coin.modifiedPrice = coin.name !== 'CLP' ?
          this.transformValueByCurrency(this.findSelectedCurrencyPrice(selectedCurrency), coin.price) :
          this.transformValueByCurrency(coin.price, 1)
        )
      },
      getMaxDigits(currentCurrency) {
        if((this.currency === 'USD' || this.currency === 'EUR') && currentCurrency === 'CLP') return 4
        if(this.currency === 'UF' && (currentCurrency === 'EUR' || currentCurrency === 'USD')) return 3
        if(this.currency === 'UF' && currentCurrency === 'CLP') return 6
        if(this.currency === 'UF' && currentCurrency !== 'CLP') return 3

        return 2
      },
      dataTextra() {
        let data = [{name: 'total', value: `C. ACTIVOS TOTAL: <strong>${this.transformCurrency(this.allBalanceByCurrency, this.currency)}</strong>`}]
        let filteredData = []

        for(let i = 0; i < this.currenciesData.length; i++) {
          data.push({name: this.currenciesData[i].name, value:`${this.currenciesData[i].name}: <strong>${this.transformCurrency(this.currenciesData[i].modifiedPrice, this.currenciesData[i].name)}</strong>`})
        }

        filteredData = data.filter(singleData => singleData.name !== this.currency).map(singleData => singleData.value)

        return filteredData
      }
    },
    mounted() {
      this.$store.dispatch('setUser', { userType: this.userType });
      this.$store.dispatch('setRelationName', this.userName);
      this.modifyPropertyCurrenciesData(this.currency);
      this.dataTextra()
    },
  };
</script>

<style lang="scss">
  .mainTextra {
    font-size: 9px;
    color: #4f52ff;
  }
  .condition-text {
    display: none !important;
  }
  @media (min-width: 400px) {
    .mainTextra {
      font-size: 12px;
    }
  }
  @media (min-width: 640px) {
    .textra {
      display: none !important;
    }
  }
  .vue-notification {
    @apply bg-vl-blue-light border-vl-blue text-vl-blue;

    &.warn {
      @apply bg-vl-red-light border-vl-red text-vl-red;
    }
  }
</style>

<template>
  <div>
    <relation-title-bar
      :is-demo="isDemo"
      :title="$t('message.metrics.metrics')"
    />
    <desktop-metrics
      v-if="!loadingConcentration"
      class="hidden lg:block"
      :assets="formattedConcentrationData"
      :concentration-data="filteredConcentrationData"
      :concentration-headers="concentrationHeaders"
      :concentration-sub-sectors="concentrationSubSectors"
      :currency="currency"
      :investment-assets="investmentAssets"
      :loading-concentration="loadingConcentration"
      :performance-headers="performanceHeaders"
      :relation-id="relationId"
      :tabs="tabs"
      :selected-tab-key="selectedTabKey"
      @change-tab="changeTab"
      @sub-sector-change="(filter) => filters.subSector = filter"
      @type-change="(filter) => filters.type = filter"
    />
    <mobile-metrics
      v-if="!loadingConcentration"
      class="lg:hidden"
      :assets="formattedConcentrationData"
      :concentration-data="formattedConcentrationData"
      :concentration-headers="concentrationHeaders"
      :currency="currency"
      :loading-concentration="loadingConcentration"
      :performance-headers="performanceHeaders"
      :relation-id="relationId"
      :tabs="tabs"
      :selected-tab-key="selectedTabKey"
      @change-tab="changeTab"
    />
    <footer>
      <section class="section-footer">
        <div class="line"></div>
        <article class="relative info-footer">
          <span class="mr-2 span">{{ $t('message.footer.powered_by') }}</span> <span><img :src="require('assets/images/icons/vl-footer-icon.svg')"/></span> <span>{{ $t('message.footer.vl_name') }}</span>
        </article>

        <!-- <article class="redirection-info">
          <span class="span">{{ $t('message.footer.see_previous_version') }} </span><a class="a" href="https://ng.valuelist.cl/login" target="_blank">{{ $t('message.footer.click_here') }}</a>
        </article> -->
      </section>
    </footer>
    <loading v-if="loadingConcentration" />
  </div>
</template>

<script>
import { camelize } from 'humps';
import DesktopMetrics from './desktop-metrics.vue';
import InvestmentAssetApi from '../../api/investment-assets';
import MobileMetrics from './mobile-metrics.vue';
import RelationTitleBar from '../shared/relation-title-bar.vue';

export default {
  components: { DesktopMetrics, MobileMetrics, RelationTitleBar },
  props: {
    dollarPrice: { type: Number, required: true },
    euroPrice: { type: Number, required: true },
    isDemo: { type: Boolean, default: false },
    relationId: { type: Number, required: true },
  },
  data() {
    return {
      concentrationData: [],
      concentrationHeaders: [
        { titles: ['assetId', 'name'], title: 'name', tooltip: true, tooltipCols: ['assetId', 'name'], columnWidth: '145' },
        { title: 'currency', columnWidth: '90' },
        { title: 'assetType', hasHighlight:true, columnWidth: '135' },
        { title: 'subSector', columnWidth: '135' },
        { title: 'etfPatrimony', columnWidth: '115', filter: 'integerCurrency', fontStyle:'font-roboto' },
        { title: 'assetQuotaAveragePrice', columnWidth: '115',
          headerTooltip: 'assetQuotaAveragePriceToolTip', filter: 'currency', fontStyle:'font-roboto' },
        { title: 'relativeWeight', columnWidth: '90', headerTooltip: 'relativeWeightToolTip', filter: 'percent' },
        { title: 'profitability', columnWidth: '95', headerTooltip: 'profitabilityToolTip', filter: 'percent' },
        { title: 'averageAnnualCost', columnWidth: '120',
          headerTooltip: 'averageAnnualCostToolTip', filter: 'percent' },
        { title: 'annualCost', columnWidth: '115', headerTooltip: 'annualCostToolTip', filter: 'integerCurrency', fontStyle:'font-roboto' },
      ],
      filters: {
        subSector: '',
        type: '',
      },
      investmentAssets: ['alternativeAsset', 'fixedIncome', 'variableIncome', 'pensionFund'],
      loadingConcentration: true,
      performanceHeaders: [
        { title: 'assetId' },
        { title: 'name', tooltip: true, tooltipCols: ['name'] },
        { title: 'mtd', headerTooltip: 'mtdToolTip', filter: 'roundPercentNumber' },
        { title: 'qtd', headerTooltip: 'qtdToolTip', filter: 'roundPercentNumber' },
        { title: 'ytd', headerTooltip: 'ytdToolTip', filter: 'roundPercentNumber' },
        { title: 'y1', headerTooltip: 'y1ToolTip', filter: 'roundPercentNumber' },
        { title: 'y3', headerTooltip: 'y3ToolTip', filter: 'roundPercentNumber' },
        { title: 'y5', headerTooltip: 'y5ToolTip', filter: 'roundPercentNumber' },
        { title: 'recoveryLevel', headerTooltip: 'recoveryLevelTooltip', filter: 'roundPercentNumber' },
        { title: 'relativeWeight', columnWidth: '90', headerTooltip: 'relativeWeightToolTip', filter: 'percent' },
      ],
      selectedTabKey: 0,
      tabs: [
        { name: 'performance', key: 0 },
        { name: 'concentration', key: 1 },
      ],
    };
  },
  mounted() {
    InvestmentAssetApi.getInvestmentAssets(this.relationId, this.isDemo)
      .then(({ investmentAssets }) => { this.concentrationData = investmentAssets; })
      .finally(() => { this.loadingConcentration = false; });
  },
  methods: {
    changeTab(key) {
      this.selectedTabKey = key;
    },
    columnCurrency(asset, column, currency) {
      if (this.dollarPrice === 0) return 0;
      switch (currency) {
      case asset.currency:
        return asset[column];
      case 'USD':
        return asset[column] / this.dollarPrice;
      case 'EUR':
        return asset[column] / this.euroPrice;
      default:
        return asset[column] * this.dollarPrice;
      }
    },
  },
  computed: {
    currency() {
      return this.$store.state.currency.currency;
    },
    concentrationSubSectors() {
      const subSectors = this.concentrationData.map((element) => element.subSector).filter((element) => !!element);

      return [... new Set(subSectors)];
    },
    filteredConcentrationData() {
      return this.formattedConcentrationData.filter((element) => (
        element.assetTypeKey.includes(this.filters.type) && element.subSector.includes(this.filters.subSector)
      ));
    },
    formattedConcentrationData() {
      return this.concentrationData.map((element) => ({
        ...element,
        etfPatrimony: this.columnCurrency(element, 'etfPatrimony', this.currency),
        assetType: this.$t(`message.investmentAssets.${camelize(element.assetType)}`),
        relativeWeight: this.usdTotal ? this.columnCurrency(element, 'etfPatrimony', 'USD') / this.usdTotal : 0,
        assetTypeKey: camelize(element.assetType),
        subSector: element.subSector || '-',
        assetQuotaAveragePrice: this.columnCurrency(element, 'assetQuotaAveragePrice', this.currency),
        // eslint-disable-next-line no-magic-numbers
        averageAnnualCost: element.averageAnnualCost / 100,
        // eslint-disable-next-line no-magic-numbers
        annualCost: (this.columnCurrency(element, 'etfPatrimony', this.currency) * element.averageAnnualCost) / 100,
      }));
    },
    usdTotal() {
      return this.concentrationData.reduce(
        (accumulator, element) => accumulator + this.columnCurrency(element, 'etfPatrimony', 'USD'), 0,
      );
    },
  },
};
</script>

<style scoped>
 footer{
  margin-top: 30px;
}

.section-footer{
  color: #A6ADB9;
  text-align: center;
}

.info-footer{
  display: flex;
  padding-top: 15px;
  font-size: 16px;
  justify-content: center;
}

.vl-icon{
  width: 19px;
  height: 19px;
  margin-bottom: 1px;
}

.redirection-info{
  font-size: 14px;
}

.line{
  border-top: 2px solid #DFE1E5;
}

.span, .a{
  vertical-align: middle;
  color: #A6ADB9;
}
</style>
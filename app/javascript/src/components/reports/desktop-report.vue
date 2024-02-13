<template>
  <div>
    <div class="flex items-center justify-between pt-6 mt-6 mb-4 lg:border-t lg:border-gray-300">
      <p class="self-end text-lg font-bold text-vl-blue">
        {{ $tc('message.entities.account', 2) }}
      </p>
    </div>
    <div class="overflow-y-auto text-vl-gray-400">
      <custom-table
        :class="`${accounts.length === 0 ? '' : 'border-b-2 border-vl-value'}`"
        class=""
        :headers="headers.accounts"
        :table-data="accounts"
        @row-clicked="accountSelected"
      />
      <div
        class="flex items-center justify-center mb-4 border-b-2 min-h text-vl border-vl-value text-vl-gray-400"
        v-if="!accounts.length"
      >
        {{ $t('message.reports.noAccounts') }}
      </div>
    </div>

    <p class="pt-4 mb-4 text-lg font-bold text-vl-blue">
      {{ $tc('message.entities.subAccount', 2) }}
    </p>
    <div class="overflow-y-auto text-vl-gray-400">
      <custom-table
        :class="`${subAccounts.length === 0 ? '' : 'border-b-2 border-vl-value'}`"
        :headers="headers.subAccounts"
        :table-data="subAccounts"
        @row-clicked="subAccountSelected"
      />
      <div
        class="flex items-center justify-center mb-4 border-b-2 min-h text-vl border-vl-value text-vl-gray-400"
        v-if="!subAccounts.length"
      >
        {{ $t('message.reports.selectAccount') }}
      </div>
    </div>

    <div class="grid grid-cols-2 mt-4 mb-6 gap-x-24">
      <div class="">
        <p class="mb-2 text-lg font-bold text-vl-blue">
          {{ $t('message.reports.yearSummary', { year: lastYear }) }}
        </p>
        <custom-table
          :currency="currency"
          :headers="headers.accumulated"
          :table-data="[lastYearReport]"
          class="border-b-2 text-vl-gray-400 border-vl-value min-h2"
        />
      </div>
      <div class="">
        <p class="mb-2 text-lg font-bold text-vl-blue">
          {{ $t('message.reports.yearAccumulated', { year: currentYear }) }}
        </p>
        <custom-table
          :currency="currency"
          :headers="headers.accumulated"
          :table-data="[currentYearReport]"
          class="border-b-2 text-vl-gray-400 border-vl-value min-h2"
        />
      </div>
    </div>
    <div>
      <p class="pt-2 mb-2 text-lg font-bold text-vl-blue">
        {{ $t('message.reports.monthlyReport') }}
      </p>
      <loading v-if="loading" />
      <custom-table
        v-else
        :currency="currency"
        :headers="headers.report"
        :table-data="monthlyReports"
        @row-clicked="selectMonth"
        class="border-b-2 text-vl-gray-400 border-vl-value min-h3" 
      />
    </div>
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
  </div>
</template>

<script>
import CustomTable from '../table.vue';

export default {
  components: { CustomTable },
  props: {
    accounts: { type: Array, required: true },
    currency: { type: String, required: true },
    currentYear: { type: Number, required: true },
    currentYearReport: { type: Object, required: true },
    headers: { type: Object, required: true },
    lastYear: { type: Number, required: true },
    lastYearReport: { type: Object, required: true },
    loading: { type: Boolean, required: true },
    monthlyReports: { type: Array, required: true },
    relationId: { type: Number, required: true },
    subAccounts: { type: Array, required: true },
  },
  methods: {
    accountSelected(accountId) {
      this.$emit('account-selected', accountId);
    },
    subAccountSelected(subAccountId) {
      this.$emit('sub-account-selected', subAccountId);
    },
    selectMonth(month) {
      this.$emit('month-clicked', month);
    },
  },
};
</script>

<style scoped>
  .min-h {
    min-height: 90px;
    height: 90px;
  }
  .min-h2 {
    min-height: 80px;
    height: 80px;
  }
  .min-h3 {
    min-height: 80px;
  }
</style>

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
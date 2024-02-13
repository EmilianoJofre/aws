<template>
  <div class="w-screen min-h-screen pb-12 overflow-auto bg-white">
    <div class="p-4">
      <inline-svg
        class="w-8 h-8 mr-2 transform -rotate-90 fill-current text-vl-gray"
        :src="require('../../../../assets/images/icons/triangle.svg')"
        @click="$emit('close-membership-view')"
      />
    </div>
    <div class="flex border-t border-b border-vl-gray-light">
      <div class="w-5 mr-5 bg-vl-yellow" />
      <div class="py-4">
        <p class="font-bold text-primary">
          {{ membership.assetId }}
        </p>
        <p class="mb-5 text-primary">
          {{ membership.name }}
        </p>
        <p class="text-vl-gray">
          {{ membership.bank.name }}
        </p>
        <p class="text-vl-gray">
          {{ membership.subAccountName }}
        </p>
      </div>
    </div>
    <div class="grid grid-cols-1 px-6 py-3 gap-y-3 bg-vl-gray-lightest">
      <div
        v-for="(header, key) in cardTitles"
        :key="key"
      >
        <vl-mobile-card
          :title="$t(`message.tableHeaders.${header.title}`)"
          variant="membershipCard"
          :sub-title="setSubTitle(header)"
          :filter="header.filter"
          :currency="membership.currency"
          :text-color="setTextColor(header)"
          :text-background="setTextBackground(header)"
        />
      </div>
    </div>
  </div>
</template>

<script>
import VlMobileCard from '../shared/vl-mobile-card';

export default {
  components: { VlMobileCard },
  props: {
    membership: { type: Object, required: true },
    headers: { type: Array, required: true },
    headersOrder: { type: Object, required: true },
  },
  methods: {
    setSubTitle(header) {
      return (this.membership[header.title] || 0).toString();
    },
    setTextColor(header) {
      if (header.title === 'incomesBalance' || header.title === 'incomesPercentage') {
        const cardTextAsNumber = parseFloat(this.setSubTitle(header));
        if (cardTextAsNumber > 0) return 'vl-green';
        if (cardTextAsNumber < 0) return 'vl-red';
      }

      return 'primary';
    },
    setTextBackground(header) {
      const textColor = this.setTextColor(header);
      if (textColor !== 'primary') return `${textColor}-light`;

      return 'vl-gray-lightest';
    },
  },
  computed: {
    cardTitles() {
      return this.headers.filter(header => header.title !== 'assetId')
        .sort((a, b) => (this.headersOrder[a.title] - this.headersOrder[b.title]));
    },
  },
};
</script>

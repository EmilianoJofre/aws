<template>
  <div>
    <div
      class="fixed inset-0"
      :class="{ 'hidden': hidden }"
      @click="toggleSelector"
    />
    <span class="px-1 ml-5 bg-white text-xs2 text-vl-gray-200">
      {{ title }}
    </span>
    <button
      class="flex flex-row items-center justify-between w-32 px-3 py-2 -mt-2 text-center border rounded h-8.5 focus:outline-none border-vl-gray-200"
      @click="toggleSelector"
    >
      <p class="text-sm truncate text-vl-gray">
        {{ selectedSubtitle }}
      </p>
      <inline-svg
        class="flex-shrink-0 w-5 h-5 transform fill-current text-vl-gray-200"
        :class="[hidden ? 'rotate-90' : '-rotate-90']"
        :src="require('../../../../assets/images/icons/chevron-right.svg')"
      />
    </button>

    <div
      class="absolute z-50 text-sm text-vl-gray"
      :class="{ 'hidden': hidden }"
    >
      <div
        class="flex flex-col py-2 mt-2 bg-white border rounded border-secondary"
      >
        <span class="flex flex-row items-center px-3 py-2 text-vl-gray">
          <input
            type="checkbox"
            class="w-4 h-4 mr-2"
            :checked="allItemsSelected"
            @change="$emit('update-all')"
          >
          <p class="whitespace-no-wrap">
            {{ $t('message.multiselect.all') }}
          </p>
        </span>
        <span
          v-for="(item, key) in items"
          :key="key"
          class="flex flex-row items-center px-3 py-2 text-vl-gray"
        >
          <input
            type="checkbox"
            class="w-4 h-4 mr-2"
            :checked="checkboxState(key)"
            @change="$emit('update', Number(key))"
          >
          <p class="whitespace-no-wrap">
            {{ item }}
          </p>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    items: { type: Object, required: true },
    selectedItems: { type: Array, default: () => ([]) },
    title: { type: String, default: '' },
    specialSubtitle: { type: Boolean, default: false },
  },
  data() {
    return {
      hidden: true,
    };
  },
  computed: {
    allItemsSelected() {
      return this.selectedItems.length === Object.keys(this.items).length;
    },
    selectedSubtitle() {
      const { length } = this.selectedItems;
      if (length) {
        if (this.allItemsSelected) {
          return this.$t('message.multiselect.all');
        }
        if (length === 1 && !this.specialSubtitle) {
          return this.items[this.selectedItems[0]];
        }
      }

      return '-';
    },
  },
  methods: {
    checkboxState(key) {
      return this.selectedItems.includes(Number(key));
    },
    toggleSelector() {
      this.hidden = !this.hidden;
    },
  },
};
</script>

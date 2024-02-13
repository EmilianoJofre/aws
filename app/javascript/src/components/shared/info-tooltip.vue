<template>
  <div>
    <inline-svg
      v-on="$listeners"
      class="fill-current focus:outline-none"
      :class="classes"
      :src="require(`assets/images/icons/${iconName}.svg`)"
      v-tooltip="{
        content: text,
        classes: tooltipClasses,
        placement: placement,
      }"
    />
  </div>
</template>

<script>
export default {
  props: {
    classes: { type: String, default: '' },
    iconName: { type: String, default: 'info' },
    tooltipType: { type: String, default: 'table' },
    text: { type: String, required: true },
    placement: { type: String, default: 'right-end' },
  },
  computed: {
    tooltipClasses() {
      const base = 'bg-vl-gray z-50 text-white rounded bg-opacity-90 shadow-xl max-w-md whitespace-pre-line';
      const padding = { table: 'px-6 py-2', form: 'px-4 py-3 mx-2' };

      return [base, padding[this.tooltipType]];
    },
  },
};
</script>
<style lang="scss" scoped>
  svg.fill-current.focus\:outline-none.has-tooltip {
    padding-bottom: 3px;
  }
</style>
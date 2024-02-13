<template>
  <component
    :is="tag"
    class="flex items-center justify-center text-center focus:outline-none focus:shadow-outline"
    :class="variantClasses"
    v-on="$listeners"
    :disabled="disabled"
  >
    <span>
      {{ text }}
    </span>
  </component>
</template>

<script>
export default {
  props: {
    text: { type: String, required: true },
    variant: { type: String, default: 'primary' },
    disabled: { type: Boolean, default: false },
  },
  computed: {
    tag() {
      return this.$attrs.href ? 'a' : 'button';
    },
    variantClasses() {
      if (this.disabled) {
        return 'mb-4 width text-sm font-semibold text-white bg-vl-gray-75 border border-vl-gray-75 rounded-md';
      }
      switch (this.variant) {
      case 'primary':
        return 'text-white text-sm lg:text-base px-2 py-1 tracking-widest rounded-lg bg-vl-blue hover:bg-white hover:text-vl-blue border-2 border-vl-blue';
      case 'secondary':
        return 'text-vl-blue text-sm lg:text-base px-2 py-1 tracking-widest rounded-lg border-2 border-vl-blue hover:bg-vl-blue hover:text-white';
      case 'cancel':
        return 'text-vl-red text-sm lg:text-base px-2 py-1 tracking-widest rounded-lg border-2 border-vl-red hover:bg-vl-red hover:text-white';
      case 'red':
        return 'text-white text-sm lg:text-base px-2 py-1 tracking-widest rounded-lg bg-vl-red hover:bg-white hover:text-vl-red border-2 border-vl-red';
      case 'alternative':
        return 'h-9 text-sm mt-12 mb-1 px-3 py-2 text-vl-gray tracking-tight bg-vl-white hover:bg-white hover:text-vl-blue hover:border-vl-blue border border-vl-gray-transparent rounded';
      case 'addAccount':
        return ' mb-4 width text-sm font-semibold duration-500 text-white bg-vl-blue hover:bg-vl-blue-500 border border-vl-blue rounded-md';
      case 'deleteAccount':
        return 'mb-4 width text-sm font-semibold duration-500 text-vl-red hover:bg-vl-blue-500 border border-vl-red rounded-md hover:bg-vl-red hover:text-white';
      default:
        return '';
      }
    },
  },
};
</script>

<style scoped>
  .width {
    width: 300px;
    height: 45px;
  }
</style>

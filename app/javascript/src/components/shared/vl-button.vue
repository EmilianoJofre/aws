<template>
  <button
    class="px-4 py-2 mr-3 whitespace-no-wrap rounded-xl text-md"
    :class="selected ? 'text-white bg-vl-yellow' : 'bg-vl-gray-lightest text-vl-gray'"
    v-on="$listeners"
    v-bind="$attrs"
  >
    {{ label }}
  </button>
</template>

<script>
export default {
  props: {
    label: {
      type: String,
      required: true,
    },
    selected: {
      type: Boolean,
      default: false,
    },
  },
};
</script>

<template>
  <inline-svg
    :src="require(`../../../../assets/images/icons/loading.svg`)"
    :class="{'h-16 w-16' : isSmall}"
  />
</template>

<script>
export default {
  props: {
    isSmall: { type: Boolean, default: false },
  },
};
</script>

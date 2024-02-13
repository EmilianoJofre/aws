<template>
  <div class="flex items-center justify-center w-full lg:hidden">
    <inline-svg
      class="fill-current text-vl-blue"
      :src="require('../../../../assets/images/icons/chevron-left.svg')"
      @click="moveSelected(-1)"
    />
    <div class="p-2 text-sm text-center rounded bg-vl-blue-light text-vl-blue">
      <p>
        {{ title }}
      </p>
      <p>
        {{ subTitle }}
      </p>
    </div>
    <inline-svg
      class="fill-current text-vl-blue"
      :src="require('../../../../assets/images/icons/chevron-right.svg')"
      @click="moveSelected(1)"
    />
  </div>
</template>

<script>
export default {
  props: {
    title: { type: String, required: true },
    subTitle: { type: String, required: true },
  },
  methods: {
    moveSelected(direction) {
      this.$emit('move-selected', direction);
    },
  },
};
</script>

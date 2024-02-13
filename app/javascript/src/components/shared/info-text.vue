<template>
  <div class="flex flex-col items-center lg:items-start lg:mr-12">
    <div class="flex">
      <p class="mr-2 uppercase text-vl-gray">
        {{ title }}
      </p>
      <info-tooltip
        class="mr-2 text-vl-gray-200"
        :text="infoTooltip"
        :placement="placement"
      />
    </div>
    <slot name="information" />
  </div>
</template>

<script>
export default {
  props: {
    infoTooltip: { type: String, required: true },
    title: { type: String, required: true },
    placement: { type: String, default: 'right-end' },
  },
};
</script>

<template>
  <div>
    <div
      v-if="variant === 'tabCard'"
      class="flex justify-between w-full bg-white border-t border-b border-r rounded-md"
      :class="[selected ? 'bg-vl-gray-light' : '', `border-${borderColor}`]"
      @click="$emit('click')"
    >
      <div
        class="w-1/2 max-w-2xl px-2 py-4 border-l-8 rounded-md"
        :class="`border-${borderColor}`"
      >
        <p :class="`text-${borderColor}`">
          {{ title }}
        </p>
        <p class="truncate text-vl-gray">
          {{ subTitle }}
        </p>
        <p
          v-if="description"
          class="text-vl-gray"
        >
          {{ description }}
        </p>
      </div>
      <span
        v-if="text"
        class="flex items-center justify-between h-8 px-4 mt-3 mr-2 rounded"
        :class="`bg-${textBackground}`"
      >
        <inline-svg
          v-if="icon.length"
          :class="`text-${iconColor}`"
          class="h-4 mr-2 fill-current"
          :src="require(`../../../../assets/images/icons/${icon}`)"
        />
        <p :class="`text-${textColor}`">
          {{ $options.filters[filter](text, currency) }}
        </p>
      </span>
    </div>
    <div
      v-else
      class="flex justify-between p-6 bg-white border rounded-lg border-vl-gray-light text-primary"
    >
      <p class="font-bold">
        {{ title }}
      </p>
      <p :class="`text-${textColor} bg-${textBackground} px-3 py-1 rounded`">
        {{ $options.filters[filter](subTitle, currency) }}
      </p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true,
    },
    subTitle: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      default: '',
    },
    borderColor: {
      type: String,
      default: 'primary',
    },
    text: {
      type: String,
      default: '',
    },
    filter: {
      type: String,
      default: '',
    },
    currency: {
      type: String,
      default: 'CLP',
    },
    textBackground: {
      type: String,
      default: 'vl-gray-lightest',
    },
    textColor: {
      type: String,
      default: 'primary',
    },
    selected: {
      type: Boolean,
      default: false,
    },
    icon: {
      type: String,
      default: '',
    },
    iconColor: {
      type: String,
      default: '',
    },
    variant: {
      type: String,
      default: 'tabCard',
    },
  },
};
</script>

<template>
  <validation-provider
    :name="name"
    :rules="rules"
    v-slot="{ errors }"
  >
    <input
      :value="value"
      type="text"
      v-bind="$attrs"
      v-on="eventListeners"
      class="px-2 -ml-1 inputStyle"
      :class="{
        'border-gray-400 focus:border-vl-blue': errors.length == 0,
        'border-red-500 focus:border-red-600': errors.length > 0,
      }"
      :placeholder="$t(`message.placeholders.${name}`)"
    >
    <p
      v-if="errors.length > 0"
      class="mt-1 text-xs text-red-500 cursor-text"
    >
      {{ $t(`message.${getErrors(errors)}`) }}
    </p>
  </validation-provider>
</template>

<script>

export default {
  props: {
    name: { type: String, required: true },
    value: { type: String, required: true },
    rules: { type: String, default: '' },
  },
  computed: {
    eventListeners() {
      return {
        ...this.$listeners,
        input: event => this.$emit('input', event.target.value),
      };
    },
  },
  methods: {
    getErrors(errors) {
      return Array.isArray(errors[0]) ? [`errors.${errors[0][0]}`] : `errors.${errors[0]}`;
    },
  },
};
</script>

<style scoped>
  @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');
  .inputStyle {
    width: 300px;
    height: 45px;
    border: 1px solid #C2C7CF;
    border-radius: 5px;
  }
  .selectStyle {
    width: 300px;
    height: 45px;
  }
  .fontFamily {
    font-family: 'Inter', sans-serif;
  }
  .container {
    width: 363px;
    height: auto;
  }
</style>
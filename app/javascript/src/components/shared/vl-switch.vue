<template>
  <div class="flex items-center justify-between -ml-12">
    <input
      :id="id"
      type="checkbox"
      class="items-center justify-center hidden"
      :value="value"
      @input="event => this.$emit('input', !value)"
    >
    <label
      id="contenedor"
      :for="id"
      class="items-center inline-block w-12 p-1 transition-colors duration-300 ease-in-out rounded-full shadow-inner cursor-pointer container-switch"
      :class="value ? 'bg-vl-value' : 'bg-vl-gray-75'"
    />
    <label
      id="switch1"
      :for="id"
      class="absolute transition-transform duration-300 ease-in-out rounded-full shadow cursor-pointer switch-ball bg-vl-blue"
      :class="{ 'transform translate-x-6': value }"
    />
  </div>
</template>

<script>
export default {
  props: {
    id: { type: Number, required: true },
    value: { type: Boolean, required: true },
  },
};
</script>
<style scoped>
  .container-switch {
    height: 23px;
  }
  .switch-ball {
    margin: 3px;
    width: 18px;
    height: 18px;
  }
</style>




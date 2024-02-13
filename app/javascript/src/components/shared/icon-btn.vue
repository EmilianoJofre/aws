<template>
  <button
    v-on="$listeners"
    class='flex items-center icn-btn focus:outline-none'
    :class="[btnClasses, btnFocus, btnHover]"
  >
    <inline-svg
      v-if="iconName"
      :class="[iconClasses]"
      :src="require(`assets/images/icons/${iconName}.svg`)"
    />
    <p
      class="font-medium text-sm underline uppercase whitespace-nowrap"
      :class="[textClasses, btnFocus, widthText]"
      :id="idPdf"
    >
      {{ text }}
    </p>
  </button>
</template>

<script>
export default {
  props: {
    iconClasses: { type: String, default: '' },
    iconName: { type: String, default: null },
    textClasses: { type: String, default: '' },
    text: { type: String, required: true },
    btnClasses: { type: String, default: '' },
    btnFocus: {type: String, default: 'focus:bg-vl-gray-lightest'},
    btnHover: {type: String, default: ''},
    widthText: {type: String, default: 'w-full'},
    idPdf: {type: String, default: 'btn-icon'}
  },
};
</script>

<style lang="scss">
  .icn-btn {
    -webkit-tap-highlight-color: rgba(0,0,0,0);
  }
</style>

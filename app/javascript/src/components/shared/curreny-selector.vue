<template>
  <div class="relative">
    <div 
      class="flex items-center justify-between w-20 h-8 p-1 border rounded-md cursor-pointer bg-vl-blue-gray border-vl-blue"
      :class="isOpenOptions ? 'dropdownTopbarSelector' : ''"
      @click="onClickSelect"
    >
      <div 
        class="ml-1 font-semibold text-vl-blue currency-name"
      >
        {{ currency }}
      </div>
      <div 
        class="flex items-center justify-center w-5 h-5 rounded-md bg-vl-blue"
      > 
        <inline-svg
          class="w-3 h-3 text-white cursor-pointer fill-current "
          :class="isOpenOptions ? 'arrowDown' : ''"
          :src="require('assets/images/icons/ArrowDown.svg')"
        />
      </div>
    </div>
    <transition name="fade"> 
      <div v-if="isOpenOptions" class="absolute"> 
        <div  
          v-for="(option, index) in options" 
          :key="index" 
          :class='`${option.value === currency ? "border-vl-blue bg-vl-blue-gray" : "border-vl-gray-lighting cursor-pointer hover:bg-vl-gray-lighting "} flex items-center justify-start w-20 h-8 font-semibold bg-white border rounded-md text-vl-blue currency-name z-100 `'
          @click="onSelectOption(option.value)"
        > 
          <div class="ml-2">{{ option.name }}</div>
        </div>
      </div>
    </transition>
  </div>
</template>
<script> 
  export default {
    data() {
      return {
        options: [
          { name: 'CLP', value: 'CLP' },
          { name: 'USD', value: 'USD' },
          { name: 'EUR', value: 'EUR' },
          { name: 'UF', value: 'UF' },
        ],
        isOpenOptions: false
      };
    },
    computed: {
      currency() {
        return this.$store.state.currency.currency;
      },
    },
    methods: {
      onClickSelect() {
        this.isOpenOptions = !this.isOpenOptions
      },
      onSelectOption(value) {
        this.$emit('change-currency', value)
        this.onClickSelect()
      },
    }
  }
</script>
<style scoped>
  .currency-name {
    font-size: 12px;
    line-height: 16px;
  }
  .arrowDown {
      transition: all 0.4s ease-out;
      -moz-transition: all 0.4s ease-out;
      -ms-transition: all 0.4s ease-out;
      -o-transition: all 0.4s ease-out;
      -webkit-transition: all 0.4s ease-out;
  }
  .dropdownTopbarSelector .arrowDown {
      transform: rotate(180deg);
      -moz-transform: rotate(180deg);
      -ms-transform: rotate(180deg);
      -o-transform: rotate(180deg);
      -webkit-transform: rotate(180deg);
  }
  .fade-enter-active, .fade-leave-active {
    transition: opacity .4s;
  }
  .fade-enter, .fade-leave-to {
    opacity: 0;
  }
</style>

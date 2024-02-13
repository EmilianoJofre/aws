<template>
  <div
    class="flex items-center"
  >
    <div class="relative mr-5">
      <span class="absolute px-1 ml-5 -mt-1 bg-white text-xs2 text-vl-gray-200 font-normal">
          Tipo de activo
        </span>
      <div 
        class="items-center w-40 z-50 flex flex-row h-8 px-3 text-sm truncate border rounded appearance-none border-vl-gray-200 text-vl-gray focus:outline-none"
        :class="isOpenOptions ? 'dropdownTopbarSelector' : ''"
        @click="onClickSelect"
      >
        <div>
          {{ optionSelected === '' ? 'Todos' : $t(`message.investmentAssets.${optionSelected}`) }}
        </div>
        <div 
          class="flex items-center justify-center"
        > 
          <inline-svg
            class="absolute top-0 right-0 z-50 flex-shrink-0 w-5 h-5 mt-2 mr-3 transform rotate-90 fill-current text-vl-gray-200"
            :src="require('../../../../assets/images/icons/chevron-right.svg')"
          />
        </div>
      </div>
      <transition> 
        <div v-if="isOpenOptions" class="absolute bg-white z-50"> 
          <div  
            v-for="(option, index) in investmentAssets" 
            :key="index" 
            :class='`${option === optionSelected ? "selectedOption border-vl-blue bg-vl-blue-gray" : "text-vl-gray border-vl-gray-lighting cursor-pointer hover:bg-vl-gray-lighting"} items-center w-40 z-50 hover:bg-vl-gray-lighting hover:text-vl-blue flex flex-row h-8 text-sm truncate bg-white border rounded appearance-none border-vl-gray-lighting focus:outline-none`'
            @click="onSelectOption(option)"
          > 
            <div class="capitalize ml-2">{{ $t(`message.investmentAssets.${option}`) }}</div>
          </div>
        </div>
      </transition>
   </div>

    <div class="relative mr-5">
      <span class="absolute px-1 ml-5 -mt-1 bg-white text-xs2 text-vl-gray-200 font-normal">
        Subsector
      </span>
      <div 
        class="items-center w-48 z-50 flex flex-row h-8 px-3 text-sm truncate border rounded appearance-none border-vl-gray-200 text-vl-gray focus:outline-none"
        :class="isOpenOptionsRight ? 'dropdownTopbarSelector' : ''"
        @click="onClickSelectRight"
      >
        <div>
          {{ optionSelectedRight === '' ? 'Todos' : optionSelectedRight }}
        </div>
        <div 
          class="flex items-center justify-center"
        > 
          <inline-svg
            class="absolute top-0 right-0 z-50 flex-shrink-0 w-5 h-5 mt-2 mr-3 transform rotate-90 fill-current text-vl-gray-200"
            :src="require('../../../../assets/images/icons/chevron-right.svg')"
          />
        </div>
      </div>
      <transition> 
        <div v-if="isOpenOptionsRight" class="absolute bg-white z-50"> 
          <div  
            v-for="(option, index) in concentrationSubSectors" 
            :key="index" 
            :class='`${option === optionSelectedRight ? "selectedOption border-vl-blue bg-vl-blue-gray" : "text-vl-gray border-vl-gray-lighting cursor-pointer hover:bg-vl-gray-lighting"} items-center w-40 z-50 hover:bg-vl-gray-lighting hover:text-vl-blue flex flex-row h-8 text-sm truncate bg-white border rounded appearance-none border-vl-gray-lighting focus:outline-none`'
            @click="onSelectOptionRight(option)"
          > 
            <div class="capitalize ml-2">{{ option }}</div>
          </div>
        </div>
      </transition>
   </div>
  </div>
</template>

<script>
import investmentAssets from '../../api/investment-assets';

export default {
  props: {
    concentrationSubSectors: { type: Array, required: true },
    investmentAssets: { type: Array, required: true },
  },
  data() {
    return {
      optionSelected: '',
      isOpenOptions: false,
      optionSelectedRight: '',
      isOpenOptionsRight: false,
      filters: {
        type: '',
        subSector: '',
      },
    };
  },
  methods: {
    filterChange(event, payload) {
      this.$emit(event, payload);
    },
    onClickSelect() {
      this.isOpenOptions = !this.isOpenOptions
    },
    onSelectOption(value) {
      this.optionSelected = value
      this.filterChange('type-change', value === 'all' ? '' : value)
      this.onClickSelect()
    },
    filterChangeRight(event, payload) {
      this.$emit(event, payload);
    },
    onClickSelectRight () {
      this.isOpenOptionsRight = !this.isOpenOptionsRight
    },
    onSelectOptionRight(value) {
      this.optionSelectedRight = value
      this.filterChangeRight('sub-sector-change', value === 'Todos' ? '' : value)
      this.onClickSelectRight()
    },
  },
  mounted() {
    this.investmentAssets.unshift('all');
    this.concentrationSubSectors.unshift('Todos');
  },
};
</script>

<style scoped>
  .selectedOption {
    color: #4f52ff !important;
  }
</style>

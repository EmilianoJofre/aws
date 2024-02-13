<template>
  <div>
    <div class="flex mt-6">
      <p class="my-1 text-lg font-bold text-vl-blue">
        Activos
      </p>
    </div>
    <div class="flex justify-between">
      <icon-btn
        v-for="option in options"
        :key="option.index"
        :icon-classes="`w-6 fill-current ml-2 ${option.type === selectedBtnOption ? 'selected-option' : ''}`"
        :icon-name="option.icon"
        text-classes="normal-case no-underline w-1 ml-3"
        :text="option.name"
        :btn-classes="`p-1 type-active ${option.spaceClass} ${option.isHidden} text-vl-gray-400 mt-4 border-solid border rounded ${option.type === selectedBtnOption ? 'selected-option border-vl-blue bg-white hover-btn' : ''}`"
        btn-focus=""
        @click="onSelectOption(option.type)"
        width-text="w-auto"
        btn-hover="hover:text-vl-blue hover:border-vl-blue hover:bg-vl-background-blue hover-btn"
      />
    </div>
  </div>
</template>
<script>

import iconBtn from './shared/icon-btn.vue';

export default {
  components: { iconBtn },
  data() {
    return {
      options: [
        { index:'1', name: 'Inversiones', icon:'money', spaceClass: '', type: 'investment', isHidden: '' },
        { index:'2', name: 'Fondos de Pensiones', icon:'wallet', spaceClass: 'ml-4', type: 'pension_fund', isHidden: '' },
        { index:'3', name: 'Bienes Raíces', icon:'properties', spaceClass: 'ml-4', type: 'real_estate', isHidden: '' },
        { index:'4', name: 'Vehículos', icon:'vehicle', spaceClass: 'ml-4', type: 'vehicles', isHidden: 'invisible' },
      ],
    };
  },
  methods: {
    onSelectOption(type) {
      if(this.selectedBtnOption === type) {
        this.$store.dispatch('setSelectedActiveType', "");
        this.$store.dispatch('getAccounts');
      } else {
        this.$store.dispatch('setSelectedActiveType', type)
        this.$store.dispatch('getAccountsByType');
      }
      
    }
  },
  computed: {
    selectedBtnOption() {
      return this.$store.state.relations.selectedActiveTypeSelector;
    },
  }
};
</script>

<style>
  .type-active{
    width: 267px;
    height: 45px;
  }
  @media (min-width: 1280px) {
    .type-active {
      width: 300px;
    }
  }
  .selected-option {
    color: #5052F6 !important;
  }
  .hover-btn {
    transition: 0.2s linear 0.2s;
    font-weight: 500;
  }
</style>
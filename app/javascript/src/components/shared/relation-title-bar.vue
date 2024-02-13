<template>
  <div class="flex flex-col-reverse items-center w-full mt-8 mb-2 lg:justify-between lg:flex-row lg:space-y-0">
    <div class="flex items-center">
      <h1 class="text-xl font-bold text-center text-vl-blue lg:text-left">
        {{ title }}
      </h1>
    </div>
    <div class="relative"> 
      <diV class="flex "> 
        <icon-btn
          v-if="isUser"
          icon-classes="w-6 text-vl-gray-200 fill-current"
          icon-name="chevron-left"
          text-classes="normal-case text-vl-gray no-underline"
          text="Ver Relaciones"
          btn-classes="border-solid border mr-2 p-1 rounded"
          @click="goBackToRelations"
        />
        <div class="relative" v-if="validateIfIsValidToExport">
          <icon-btn
            icon-classes="w-6 text-vl-gray-200 fill-current"
            icon-name="file-download"
            text-classes="normal-case text-vl-gray no-underline"
            text="Exportar"
            btn-classes="border-solid border mx-4 p-1 rounded"
            @click="toggleOptions"
          />
          <div
            v-if="isOpenOptions && options"
            class="absolute p-1 mx-4 bg-white border border-solid rounded container-options"
          >
            <icon-btn
              v-for="option in options"
              :key="option.index"
              icon-classes="w-6 text-vl-gray fill-current"
              :icon-name="option.icon"
              text-classes="normal-case text-vl-gray no-underline"
              :text="option.name"
              btn-classes="p-1 btn-export-option"
              @click="modalAction(option)"
              btn-focus="focus:text-vl-blue"
            />
          </div>
        </div>
      </div>
    </div>
    <info-options-modal 
      v-if="isOpenModal"
      v-show="isOpenModal"
      @close="modalAction"
      :on-execute-action="toggleOptions"
      :is-demo="isDemo"
    />
  </div>
</template>

<script>
import iconBtn from './icon-btn.vue';
import infoOptionsModal from '../info-options-modal.vue';
import NackbarDownload from '../nackbar-download.vue';

export default {
  components: { iconBtn, infoOptionsModal, NackbarDownload },
  props: {
    isDemo: { type: Boolean, default: false },
    title: { type: String, required: true },
  },
  data() {
    return {
      isOpenOptions: false,
      options: [
        { index: 0, name: 'Exportar PDF', icon: 'pdf2' },
        { index: 1, name: 'Exportar Excel', icon: 'excel' }
      ],
      isOpenModal: false,
      selectedOption: {}
    };
  },
  computed: {
    isUser() {
      return this.$store.getters.isUser;
    },
    selectedRelationId() {
      return this.$store.state.relations.selectedRelationId;
    },
    isOpenNackbar() {
      return this.$store.state.relationFiles.isOpenNackbar;
    },
    selectedTabIndex() {
      return this.$store.state.navbar.selectedTabIndex;
    },
    selectedSubTab() {
      return this.$store.state.navbar.selectedSubTabIndex;
    },
    validateIfIsValidToExport() {
      return this.selectedTabIndex === 0 || this.selectedTabIndex === 1 || this.selectedTabIndex === 3
    },
  },
  methods: {
    goBackToRelations() {
      window.location.href = `/relations${this.isDemo ? '?demo=true' : ''}`
    },
    toggleOptions() {
      this.isOpenOptions = !this.isOpenOptions;
    },
    modalAction(option) {
      this.$store.dispatch('setSelectedOptions', option);

      this.isOpenModal = !this.isOpenModal
      this.selectedOption = option
    },
  }
};
</script>
<style lang="scss">
  .container-options {
    width: 142px;
    margin-left: -12px;    
    margin-top: 8px;
  }
  .btn-export-option {
    width: 132px;
    margin-left: 4px;
  }
</style>

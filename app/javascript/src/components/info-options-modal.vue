<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
      <div class="rounded-lg modal"
        role="dialog"
        aria-labelledby="modalTitle"
        aria-describedby="modalDescription"
      >
        <section
          class="flex justify-center text-sm font-semibold title-modal"
          id="modalTitle"
        >
          {{title}}
        </section>
        <section
          class="relative font-normal text-center body-text"
          id="modalDescription"
        >
          <slot name="body">
            Esta acción exportará los datos según el rango de fechas, moneda y cuentas seleccionadas <strong class="font-semibold">¿Deseas continuar?</strong>
          </slot>
        </section>
        <footer class="flex justify-end footer-modal">
          <icon-btn
            icon-classes="w-6 text-vl-gray-200"
            text-classes="normal-case text-vl-gray-light no-underline text-sm	"
            text="Cancelar"
            btn-classes="border-solid border mr-3 py-2 rounded-lg btn-cancel"
            @click="close"
          />
          <icon-btn
            icon-classes="w-6 text-vl-gray-200"
            text-classes="normal-case text-white no-underline text-sm	font-medium"
            :text="title"
            btn-classes="border-solid border py-2 rounded-lg bg-vl-blue btn-export"
            @click="exportData"
            btn-focus="focus:bg-vl-blue-purple"
            id-pdf="on-action-download-click"
          />
        </footer>
      </div>
    </div>
  </transition>
</template>
<script>
  import iconBtn from './shared/icon-btn.vue';
  import RelationFilesApi from '../api/relation-files';
  
  export default {
    components: { iconBtn },
    props: {
      onExecuteAction: {type: Function,  default: () => null },
      isDemo: { type: Boolean, default: false },
    },
    data () {
      return {
        width: 86,
        fullWidth: 'width:86%'
      }
    },
    name: 'Modal',
    methods: {
      close() {
        this.$emit('close');
      },
      exportData() {
        this.$store.dispatch('isOpenNackBar', true);
        const { endpoint, ids, fileName, tableSelected, currency, relationId, validateIfIsDemo, assetvalue, name } = this.exportDataEndpoint;
        this.$store.dispatch('setFileName', fileName);
        if (endpoint) {
          endpoint(relationId, ids, tableSelected, currency, validateIfIsDemo, assetvalue, name).then((response) => {
            const { data, data: { type } } = response;
            if(response) {
              this.$store.dispatch('validateDownload', true);
              const url = window.URL.createObjectURL(new Blob([data], { type }));
              const link = document.createElement('a');
              link.href = url;
              link.download = fileName;
              link.click();
            }
          });
          this.$emit('close');
          this.onExecuteAction();
        }
      },
      formatBytes(bytes, decimals = 2) {
        if (bytes === 0) return '0 Bytes';

        const k = 1024;
        const dm = decimals < 0 ? 0 : decimals;
        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

        const i = Math.floor(Math.log(bytes) / Math.log(k));

        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
      }
    },
    computed: {
      exportDataEndpoint() {
        const { icon } = this.$store.state.relations.selectedOption;
        const validateExtension = icon === 'pdf2'
        const endpointName = validateExtension ? 'get_pdf' : 'get_xls'
        const assetType = this.$store.state.navbar.selectedTabIndex === 1 ? 'real_estate' : this.$store.state.navbar.selectedTabIndex === 0 ? 'investment' : this.$store.state.navbar.selectedTabIndex === 3 ? 'pension_fund' : 'others'
        return {
          endpoint: RelationFilesApi.downloadFiles,
          relationId: this.$store.state.relations.selectedRelationId,
          ids: this.$store.state.relations.selectedAccounts,
          tableSelected: this.$store.state.relations.selectedTimeTab,
          currency: this.$store.state.currency.currency,
          fileName: `${assetType === 'real_estate' ? "Reporte_Bienes_Raíces" : assetType === 'pension_fund' ? "Reporte_Pensiones" : "Reporte_Inversiones" }_${new Date().toLocaleDateString('en-GB')}.${validateExtension ? 'pdf' : 'xls'}`,
          validateIfIsDemo: this.isDemo,
          assetvalue: assetType,
          name: endpointName,
          
        };
      },
      isFinishedDownload() {
        return this.$store.state.relationFiles.isFinished;
      },
      title() {
        return this.$store.state.relations.selectedOption.name
      }
    },
  };
</script>
<style lang="scss">
  .modal-backdrop {
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: rgba(0, 0, 0, 0.3);
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .modal {
    background: #FFFFFF;
    overflow-x: auto;
    display: flex;
    flex-direction: column;
    width: 408px;
    height: 175px;
    margin: 0 50px 0 50px;
  }

  .btn-close {
    position: absolute;
    top: 0;
    right: 0;
    border: none;
    font-size: 20px;
    padding: 10px;
    cursor: pointer;
    font-weight: bold;
    color: #4AAE9B;
    background: transparent;
  }

  .btn-green {
    color: white;
    background: #4AAE9B;
    border: 1px solid #4AAE9B;
    border-radius: 2px;
  }

  .modal-fade-enter,
  .modal-fade-leave-to {
    opacity: 0;
  }

  .modal-fade-enter-active,
  .modal-fade-leave-active {
    transition: opacity .5s ease;
  }
  .body-text {
    font-size: 12px;
    line-height: 18px;
    margin-top: 13px;
    margin-right: 28px;
    margin-left: 28px;
  }
  .title-modal {
    margin-top: 1.5rem;
  }
  .footer-modal {
    margin-top: 24px;
    margin-right: 1em;
    margin-bottom: 1em;
  }
  .btn-cancel {
    height: 36px;
    width: 87px;
  }
  .btn-export {
    height: 36px;
    width: 126px;
  }
</style>

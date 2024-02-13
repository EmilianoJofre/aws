<template>
  <div class="px-4 mt-8 lg:px-0">
    <relation-title-bar
      v-if="relationView"
      :is-demo="isDemo"
      title="Documentos"
      class="mb-6"
      @add="showModal('create')"
    />
    <div
      v-if="!relationView"
      class="flex justify-center mb-8 lg:justify-start"
    >
      <p
        class="mt-1 -mb-4 text-lg font-bold text-vl-blue"
      >
        {{ $t('message.documentFiles.documents') }}
      </p>
      <button
        v-if="isUser"
        class="pt-1 focus:outline-none"
      >
        <img
          v-if="selectedRelationId"
          :src="require('assets/images/icons/addNew.svg')"
          class="hidden h-4 mt-2 ml-2 cursor-pointer lg:block"
          @click="showModal('create')"
        >
      </button>
    </div>
    <div class="flex items-center pt-6 mt-2 lg:border-t lg:border-gray-300">
      <div class="flex px-2 py-1 mr-4 border rounded border-vl-gray-200">
        <input
          type="text"
          v-model="searchField"
          class="focus:outline-none text-vl-gray"
          placeholder="Buscar documento"
        >
        <inline-svg
          :src="require('assets/images/icons/search.svg')"
          class="w-4 fill-current text-vl-gray-200"
        />
      </div>
      <button
        v-if="selectedFilesIds.length"
        class="items-center hidden lg:flex"
        @click="downloadFiles"
      >
        <inline-svg
          class="mr-2 fill-current text-vl-gray-200"
          :src="require('assets/images/icons/file-download.svg')"
        />
        <p class="font-light underline text-vl-gray-400">
          {{ $t('message.documentFiles.download') }}
        </p>
      </button>
    </div>
    <table-wrapper
      class="hidden overflow-y-auto border-b-2 lg:block text-vl-gray-400 border-vl-value"
      :empty-message="$t('message.documentFiles.selectRelation')"
      :full-table="fullTable"
      :headers="headers"
      height-class="long-table"
      :table-data="filteredFiles"
      :show-edit="isUser"
      :with-checkbox="withCheckbox"
      with-sort
      @edit-clicked="(fileId) => showModal('edit', fileId)"
      @checkboxes-updated="updateCheckboxes"
      @row-clicked="openPreview"
    />
    <div class="lg:hidden">
      <info-card
        v-for="file in filteredFiles"
        :key="file.id"
        class="w-full mb-2"
        :content="generateCardContent(file)"
        :pill="{
          class: 'bg-vl-blue-light text-vl-blue',
          content: $options.filters['date'](file.date),
        }"
        @click="openPreview(file.id)"
      />
    </div>
    <footer>
      <section class="section-footer">
        <div class="line"></div>
        <article class="relative info-footer">
          <span class="mr-2 span">{{ $t('message.footer.powered_by') }}</span> <span><img :src="require('assets/images/icons/vl-footer-icon.svg')"/></span> <span>{{ $t('message.footer.vl_name') }}</span>
        </article>

        <!-- <article class="redirection-info">
          <span class="span">{{ $t('message.footer.see_previous_version') }} </span><a class="a" href="https://ng.valuelist.cl/login" target="_blank">{{ $t('message.footer.click_here') }}</a>
        </article> -->
      </section>
    </footer>
  </div>
</template>

<script>
import CreateDocumentModal from './create-document-modal.vue';
import TableWrapper from '../shared/table-wrapper.vue';
import InfoCard from '../shared/info-card.vue';
import RelationFilesApi from '../../api/relation-files';
import RelationTitleBar from '../shared/relation-title-bar.vue';

export default {
  components: { TableWrapper, InfoCard, RelationTitleBar },
  props: {
    documentTypeOptions: { type: Array, default: () => [] },
    fullTable: { type: Boolean, default: false },
    isDemo: { type: Boolean, default: false },
    relationView: { type: Boolean, default: false },
    withCheckbox: { type: Boolean, default: false },
  },
  data() {
    return {
      headers: [
        { title: 'documentName', tooltip: true, tooltipCols: ['documentName'] },
        { title: 'documentType' },
        { title: 'account', tooltip: true, tooltipCols: ['account'] },
        { title: 'institution', tooltip: true, tooltipCols: ['institution'] },
        { title: 'subAccount', tooltip: true, tooltipCols: ['subAccount'] },
        { title: 'date', filter: 'date' },
      ],
      searchField: '',
      selectedFilesIds: [],
    };
  },
  computed: {
    downloadFilesEndpoint() {
      if (this.selectedFilesIds.length === 1) {
        const id = this.selectedFilesIds[0];

        return {
          endpoint: RelationFilesApi.download,
          ids: id,
          fileName: this.normalizedFiles[id].name,
        };
      } else if (this.selectedFilesIds.length) {
        return {
          endpoint: RelationFilesApi.downloadMultiple,
          ids: this.selectedFilesIds,
          fileName: 'documents.zip',
        };
      }

      return {};
    },
    files() {
      return this.$store.state.relationFiles.files;
    },
    filteredFiles() {
      return this.formattedFiles.filter(this.matchSearchField);
    },
    formattedFiles() {
      return this.files.map((file) => ({
        ...file,
        account: file.account ? file.account.name : 'Todas',
        documentName: file.name,
        documentType: this.normalizedTypeOptions[file.documentType],
        institution: file.bank ? file.bank.name : '-',
        subAccount: file.subAccount ? file.subAccount.subAccountId : 'Todas',
      }));
    },
    isUser() {
      return this.$store.getters.isUser;
    },
    normalizedFiles() {
      const files = {};
      this.files.forEach((file) => {
        files[file.id] = file;
      });

      return files;
    },
    normalizedTypeOptions() {
      const options = {};
      this.documentTypeOptions.forEach(([value, key]) => {
        options[key] = value;
      });

      return options;
    },
    selectedRelationId() {
      return this.$store.state.relations.selectedRelationId;
    },
  },
  methods: {
    beforeClose() {
      this.$store.dispatch('getRelationFiles', this.isDemo);
    },
    downloadFiles() {
      const { endpoint, ids, fileName } = this.downloadFilesEndpoint;
      if (endpoint) {
        endpoint(ids).then((response) => {
          const { data, data: { type } } = response;
          const url = window.URL.createObjectURL(new Blob([data], { type }));
          const link = document.createElement('a');
          link.href = url;
          link.download = fileName;
          link.click();
        });
      }
    },
    generateCardContent(file) {
      return this.headers.reduce((cardContent, header) => {
        if (header.title === 'date') return cardContent;
        const documentName = header.title === 'documentName';

        return [...cardContent, {
          title: documentName ? '' : this.$t(`message.tableHeaders.${header.title}`),
          content: file[header.title],
          class: documentName ? 'text-vl-blue' : 'text-vl-gray',
        }];
      }, []);
    },
    matchSearchField(file) {
      return this.headers.some(({ title }) => {
        if (file[title]) {
          return file[title].toLowerCase().includes(this.searchField.toLowerCase());
        }

        return false;
      });
    },
    openPreview(id) {
      const file = this.normalizedFiles[id];
      window.open(file.fileUrl, '_blank');
    },
    setModalProps(action, relationFile) {
      const props = {
        action,
        documentTypeOptions: this.documentTypeOptions,
        selectedRelationId: this.selectedRelationId,
      };
      if (relationFile) props.relationFile = relationFile;

      return props;
    },
    showModal(action, relationFileId = null) {
      const relationFile = this.files.find((file) => file.id === relationFileId);
      const props = this.setModalProps(action, relationFile);
      this.$modal.show(CreateDocumentModal,
        { ...props },
        { height: 'auto' },
        { 'before-close': this.beforeClose },
      );
    },
    updateCheckboxes(ids) {
      this.selectedFilesIds = ids;
    },
  },
};
</script>

<style lang="scss" scoped>
::placeholder {
  @apply text-vl-gray-200 font-light
}
</style>

<style scoped>
 footer{
  margin-top: 30px;
}

.section-footer{
  color: #A6ADB9;
  text-align: center;
}

.info-footer{
  display: flex;
  padding-top: 15px;
  font-size: 16px;
  justify-content: center;
}

.vl-icon{
  width: 19px;
  height: 19px;
  margin-bottom: 1px;
}

.redirection-info{
  font-size: 14px;
}

.line{
  border-top: 2px solid #DFE1E5;
}

.span, .a{
  vertical-align: middle;
  color: #A6ADB9;
}
</style>

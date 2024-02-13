<template>
  <modal
    @confirm-clicked="confirmAction"
    @close="$emit('close')"
    @delete-clicked="deleteAction"
    :action-text="$t(`message.documentFiles.${action}`)"
    :delete-text="action === 'edit' ? $t('message.documentFiles.confirm.delete') : null"
    :confirm-text="$t(`message.documentFiles.confirm.${action}`)"
    :error="errorMessage"
    :loading="loading"
  >
    <template #input>
      <div
        class="flex flex-col items-center justify-between p-4 mx-6 mb-10 border border-dashed rounded"
        :class="[fileName ? 'border-vl-blue bg-white' : 'border-vl-gray-200 bg-vl-gray-100']"
      >
        <div
          v-if="fileName"
          class="flex items-center h-16"
          @click.stop="openPreview"
        >
          <inline-svg
            class="w-6 h-6 mr-2 fill-current text-vl-blue"
            :src="require(`assets/images/icons/${selectedFileType}.svg`)"
          />
          <p class="text-vl-gray">
            {{ fileName }}
          </p>
        </div>
        <div
          v-else
          class="flex flex-col items-center h-16"
        >
          <inline-svg
            class="mb-2 fill-current text-vl-gray-200"
            :src="require('assets/images/icons/file-upload.svg')"
          />
          <h3 class="mb-2 text-vl-gray">
            {{ $t('message.documentFiles.add.description') }}
          </h3>
        </div>
        <label
          for="file-input"
          class="flex items-center justify-center px-2 py-1 -mb-8 text-sm tracking-widest text-center uppercase bg-white border-2 rounded-lg cursor-pointer lg:text-base text-vl-blue border-vl-blue hover:bg-vl-blue hover:text-white"
        >
          {{ $t(`message.documentFiles.add.${ fileName ? 'edit' : 'button' }`) }}
        </label>
        <input
          @change="selectFile"
          type="file"
          class="hidden"
          accept="image/jpeg,image/png,application/pdf,image/jpg"
          ref="profilePicture"
          id="file-input"
        >
      </div>
      <div class="grid grid-cols-2 mx-6 mb-4 gap-x-4 gap-y-4">
        <div>
          <p>{{ $t('message.tableHeaders.documentName') }}</p>
          <input
            v-model="fileData.name.value"
            type="text"
            class="w-full p-1 border border-gray-400 rounded focus:outline-none"
            min="1"
          >
        </div>
        <div>
          <p>{{ $t('message.tableHeaders.documentType') }}</p>
          <select
            class="w-full p-1 border border-gray-400 rounded focus:outline-none"
            v-model="fileData.type.value"
          >
            <option
              v-for="([text, value]) in documentTypeOptions"
              :key="value"
              :value="value"
            >
              {{ text }}
            </option>
          </select>
        </div>
        <div>
          <p>{{ $t('message.tableHeaders.account') }}</p>
          <select
            class="w-full p-1 border border-gray-400 rounded focus:outline-none"
            v-model="fileData.accountId.value"
            @change="selectAccount"
          >
            <option
              v-for="(account, index) in relationAccounts"
              :key="index"
              :value="account.id"
            >
              {{ account.name }} - {{ account.bank.name }}
            </option>
          </select>
        </div>
        <div>
          <p>{{ $t('message.tableHeaders.institution') }}</p>
          <select
            class="w-full p-1 border border-gray-400 rounded focus:outline-none"
            v-model="fileData.bankId.value"
          >
            <option
              v-for="(bank, key) in filteredBanks"
              :key="key"
              :value="bank.id"
            >
              {{ bank.name }}
            </option>
          </select>
        </div>
        <div>
          <p>{{ $t('message.tableHeaders.subAccount') }}</p>
          <select
            class="w-full p-1 border border-gray-400 rounded focus:outline-none"
            v-model="fileData.subAccountId.value"
          >
            <option
              v-for="subAccount in subAccounts"
              :key="subAccount.id"
              :value="subAccount.id"
            >
              {{ subAccount.subAccountId }}
            </option>
          </select>
        </div>
        <div>
          <p>{{ $t('message.tableHeaders.date') }}</p>
          <input
            v-model="fileData.date.value"
            type="date"
            class="w-full p-1 border border-gray-400 rounded focus:outline-none"
            :max="today"
          >
        </div>
      </div>
    </template>
  </modal>
</template>
<script>
import Modal from '../shared/modal.vue';
import RelationFilesApi from '../../api/relation-files';

export default {
  components: { Modal },
  props: {
    action: { type: String, default: 'create' },
    documentTypeOptions: { type: Array, required: true },
    relationFile: { type: Object, default: () => ({}) },
    selectedRelationId: { type: Number, required: true },
  },
  data() {
    // eslint-disable-next-line no-magic-numbers
    const today = (new Date()).toISOString().slice(0, 10);
    let { account, bank, subAccount } = this.relationFile;
    
    account = account || {};
    bank = bank || {};
    subAccount = subAccount || {};

    return {
      deleteCounter: 0,
      documentType: null,
      error: null,
      name: null,
      fileData: {
        accountId: { value: account.id, name: 'account_id' },
        bankId: { value: bank.id, name: 'bank_id' },
        date: { value: this.relationFile.date, name: 'date' },
        name: { value: this.relationFile.name, name: 'name' },
        subAccountId: { value: subAccount.id, name: 'sub_account_id' },
        type: { value: this.relationFile.documentType, name: 'document_type' },
      },
      loading: false,
      selectedFile: { name: this.relationFile.fileName, url: this.relationFile.fileUrl },
      today,
    };
  },
  mounted() {
    const { accountId: { value } } = this.fileData;
    if (value) {
      this.$store.dispatch('setSelectedAccountId', value);
    }
  },
  computed: {
    errorMessage() {
      if (!this.fileUploadable) return this.$t('message.documentFiles.error');

      return this.error;
    },
    fileUploadable() {
      return this.fileData.name.value && this.fileName;
    },
    fileName() {
      if (this.selectedFile) {
        return this.selectedFile.name;
      }

      return null;
    },
    filteredBanks() {
      if (this.selectedAccount) {
        return { [this.selectedAccount.bank.id]: this.relationBanks[this.selectedAccount.bank.id] };
      }

      return this.relationBanks;
    },
    relationAccounts() {
      return this.$store.state.accounts.accounts;
    },
    relationBanks() {
      return this.$store.getters.relationBanks;
    },
    subAccounts() {
      return this.$store.state.subAccounts.subAccounts;
    },
    selectedAccount() {
      return this.relationAccounts.find((acc) => acc.id === this.fileData.accountId.value);
    },
    selectedFileType() {
      return this.fileName.split('.').pop() === 'pdf' ? 'pdf' : 'image';
    },
    selectedAccountId() {
      return this.$store.state.accounts.selectedAccountId
    }
  },
  methods: {
    confirmAction() {
      if (this.action === 'create' && this.fileUploadable) {
        this.postDocument();
      } else if (this.action === 'edit' && this.fileUploadable) {
        this.updateDocument();
      }
    },
    createForm() {
      const form = new FormData();
      if (this.relationFile.fileName !== this.fileName) form.append('file', this.selectedFile);
      Object.entries(this.fileData).forEach(([, { value, name }]) => {
        if (value) form.append(name, value);
      });

      return form;
    },
    deleteAction() {
      if (this.deleteCounter++ === 0) {
        this.error = this.$t('message.documentFiles.confirmDelete');
      } else {
        this.deleteCounter = 0;
        this.loading = true;
        RelationFilesApi.destroyFile(this.relationFile.id)
          .then(() => { this.$emit('close'); })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      }
    },
    openPreview() {
      window.open(this.selectedFile.url, '_blank');
    },
    selectAccount() {
      this.$store.dispatch('setSelectedAccountId', {id: this.selectedAccount.id});
      this.fileData.bankId.value = this.selectedAccount.bank.id;
    },
    postDocument() {
      this.loading = true;
      RelationFilesApi.createRelationFile(this.selectedRelationId, this.createForm())
        .then(() => { this.$emit('close'); })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    selectFile() {
      if (this.$refs.profilePicture.files.length) {
        this.selectedFile = this.$refs.profilePicture.files[0];
        this.selectedFile.url = URL.createObjectURL(this.selectedFile);
      }
    },
    updateDocument() {
      this.loading = true;
      RelationFilesApi.updateFile(this.relationFile.id, this.createForm())
        .then(() => { this.$emit('close'); })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
  },
};
</script>

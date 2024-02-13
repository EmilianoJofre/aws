<template>
  <validation-observer
    v-slot="{ invalid }"
  >
    <modal
      @confirm-clicked="clickAction"
      @close="$emit('close')"
      @delete-clicked="deleteAction"
      :action-text="$t(`message.relations.actions.${action}`)"
      :confirm-text="$t(`message.relations.actions.confirm.${action}`)"
      :confirm-disabled="invalid"
      :delete-text="action === 'edit' ? $t('message.relations.actions.delete') : null"
      :error="error"
      :loading="loading"
    >
      <template #input>
        <div class="container">
          <div class="flex flex-col items-center justify-center">
            <div>
              <p class="pb-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.name') }}</p>
              <vl-input
                name="firstName"
                v-model="data['firstName']"
                rules="required"
              />
            </div>
          </div>
          <div class="flex flex-col items-center justify-center mt-2">
            <div>
              <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.lastName') }}</p>
              <vl-input
                name="lastName"
                v-model="data['lastName']"
                rules="required"
              />
            </div>
          </div>
          <div class="flex flex-col items-center justify-center mt-2">
            <div>
              <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.rut') }}</p>
              <validation-provider
                name="rut"
                :rules="['required', 'customAlphanumericRut']"
                v-slot="{ errors }"
              >
                <input
                  v-model="data['rut']"
                  type="text"
                  class="px-2 -ml-1 inputStyle"
                  :class="{
                    'border-gray-400 focus:border-vl-blue': errors.length == 0,
                    'border-red-500 focus:border-red-600': errors.length > 0,
                  }"
                  :placeholder="$t(`message.placeholders.rut`)"
                  v-alphanumeric-rut
                >
              </validation-provider>
            </div>
          </div>
          <div class="flex flex-col items-center justify-center mt-2">
            <div>
              <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">{{ $t('message.tableHeaders.phone') }}</p>
              <vl-input
                name="phone"
                v-model="data['phone']"
              />
            </div>
          </div>
          <div class="flex flex-col items-center justify-center pb-8 mt-2">
            <div>
              <p class="py-2 -ml-1 text-sm font-medium text-black capitalize fontFamily">
                {{ $t('message.tableHeaders.email') }}
              </p>
              <vl-input
                name="email"
                v-model="data['email']"
              />
            </div>
          </div>
        </div>
      </template>
    </modal>
  </validation-observer>
</template>

<script>
import { decamelizeKeys } from 'humps';
import RelationsApi from '../api/relations';
import Modal from './shared/modal.vue';
import VlInput from '../components/shared/vl-input.vue';

export default {
  components: { VlInput, Modal },
  props: {
    relation: { type: Object, default: () => ({}) },
    action: { type: String, default: 'create' },
  },
  data() {
    return {
      data: {
        firstName: this.relation.firstName || '',
        lastName: this.relation.lastName || '',
        rut: this.relation.rut || '',
        phone: this.relation.phone || '',
        email: this.relation.email || '',
        id: this.relation.id,
      },
      deleteCounter: 0,
      error: null,
      loading: false,
    };
  },
  created() {
    this.$validator.extend('customAlphanumericRut', {
      getMessage: () => {
        return this.$t('message.errors.customAlphanumericRut');
      },
      validate: (value) => {
        const alphanumericRutRegex = /^[a-zA-Z0-9]+$/;
        return alphanumericRutRegex.test(value);
      },
    });
  },
  methods: {
    deleteAction() {
      if (this.deleteCounter++ === 0) {
        this.error = this.$t('message.relations.actions.confirm.delete');
      } else {
        this.deleteCounter = 0;
        this.loading = true;
        RelationsApi.deleteRelation(this.data)
          .then(() => {
            this.error = null;
            this.$store.dispatch('getRelations');
            this.$emit('close');
          })
          .catch((error) => { this.error = error; })
          .finally(() => { this.loading = false; });
      }
    },
    postRelation() {
      const params = decamelizeKeys(this.data);
      RelationsApi.createRelation(params)
        .then((response) => {
          this.$store.dispatch('addRelation', response.relation);
          this.error = null;
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    editRelation() {
      RelationsApi.editRelation(this.data)
        .then(() => {
          this.error = null;
          this.$store.dispatch('getRelations');
          this.$emit('close');
        })
        .catch((error) => { this.error = error; })
        .finally(() => { this.loading = false; });
    },
    clickAction() {
      this.loading = true;
      if (this.action === 'create') {
        this.postRelation();
      } else if (this.action === 'edit') {
        this.editRelation();
      }
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

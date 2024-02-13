<template>
  <div>
    <div class="flex">
      <p class="mt-1 text-lg font-bold text-vl-blue">
        Mis relaciones
      </p>
      <button
        @click="showModal"
        class="focus:outline-none pt-1"
      >
        <img
          :src="require('../../../assets/images/icons/addNew.svg')"
          class="h-4 mt-1 ml-2 cursor-pointer"
        >
      </button>
    </div>
    <table class="justify-between w-full mt-4 text-left border-b-2 border-vl-value">
      <tr class="font-medium border-t-2 border-b-2 border-vl-value text-vl-gray-400">
        <th
          v-for="(header, index) in headers"
          :key="index"
          class="p-2 pl-2 font-medium"
        >
          <div class="flex items-center justify-between pl-5 text-left uppercase text-vl">
            <span
              v-if="header.title"
            >
              {{ $t(`message.tableHeaders.${header.title}`) }}
            </span>
            <div
              v-if="header.title && sortedRelations.length"
              class="flex flex-col items-center mr-1"
            >
              <inline-svg
                @click="toggleSort({ direction: 1, header})"
                class="font-black mb-1 w-2 h-1.5 cursor-pointer fill-current"
                :class="[criteriaIsSelected(1, header.title) ? 'text-vl-gray-650' : 'text-vl-gray-400']"
                :src="require('assets/images/icons/ArrowUp.svg')"
              />
              <inline-svg
                @click="toggleSort({ direction: -1, header})"
                class="font-black w-2 h-1.5 cursor-pointer fill-current"
                :class="[criteriaIsSelected(-1, header.title) ? 'text-vl-gray-650' : 'text-vl-gray-400']"
                :src="require('assets/images/icons/ArrowDown.svg')"
              />
            </div>
          </div>
        </th>
        <th class="justify-between w-40 p-2 font-medium text-left uppercase text-vl">
          {{ $t('message.tableHeaders.showDeposits') }}
        </th>
        <th class="justify-between w-24 p-2 font-medium text-center uppercase text-vl">
          {{ $t('message.tableHeaders.show') }}
        </th>
        <th class="justify-between w-24 p-2 font-medium text-center uppercase text-vl">
          {{ $t('message.tableHeaders.edit') }}
        </th>
      </tr>
      <tr
        class=" text-vl-gray hover:bg-vl-blue-light"
        v-for="(relation, key) in sortedRelations"
        :key="key"
        @click="selectRelation(relation)"
        :class="selectedRelationId === relation.id ? 'bg-vl-blue-light' : 'cursor-pointer'"
      >
        <td
          v-for="(header, index) in headers"
          :key="index"
          class="py-2 pl-2 text-vl font-norml"
          :style="'width: '+ header.columnWidth + 'px'"
        >
          <span class="ml-5 truncate">
            {{ relation[header.title] }}
          </span>
        </td>
        <td class="flex justify-center p-2 pl-4 font-light">
          <a @click.stop>
            <vl-switch
              :id="relation.id"
              :value="relation.showWallet"
              @input="(value) => editShowWallet(relation, value)"
            />
          </a>
        </td>
        <td class="items-center font-light">
          <a :href="`/relations/${relation.id}${isDemo ? '?demo=true' : ''}`">
            <inline-svg
              class="ml-10 fill-current text-vl-gray-300 hover:text-vl-blue"
              :src="require('assets/images/icons/view.svg')"
            />
          </a>
        </td>
        <td class="p-2 pl-4 font-light">
          <inline-svg
            class="ml-6 transform fill-current text-vl-gray-300 hover:text-vl-blue"
            :src="require('assets/images/icons/edit2.svg')"
            @click.stop="editRelation(relation)"
          />
        </td>
      </tr>
    </table>
  </div>
</template>
<script>
import RelationsApi from '../api/relations';
import relationsModal from './relations-create-modal.vue';

export default {
  props: {
    isDemo: { type: Boolean, default: false },
  },
  beforeMount() {
    this.$store.dispatch('getRelations', this.isDemo);
  },
  methods: {
    criteriaIsSelected(dir, title) {
      const { direction, header } = this.sortCriteria;

      return direction === dir && header === title;
    },
    editRelation(relation) {
      this.$modal.show(relationsModal, { relation, action: 'edit' }, {
        height: 'auto', width: '363px',
      });
    },
    editShowWallet(relation, newValue) {
      RelationsApi.editRelation({ id: relation.id, showWallet: newValue })
        .then(() => this.$store.dispatch('getRelations', this.isDemo));
    },
    showModal() {
      this.$modal.show(relationsModal, {}, {
        height: 'auto', width: '363px',
      });
    },
    selectRelation(relation) {
      this.selectedRelationId = relation.id;
      this.$emit('relation-selected');
    },
    toggleSort(criteria) {
      this.sortCriteria = criteria;
    },
  },
  computed: {
    relations() {
      return this.$store.state.relations.relations;
    },
    selectedRelationId: {
      get() {
        return this.$store.state.relations.selectedRelationId;
      },
      set(id) {
        if(this.getSelectedRelationId) {
          this.$store.dispatch('setSelectedRelationId', { id, isDemo: this.isDemo, isSelectedType: this.getSelectedActiveType });
        } else {
          this.$store.dispatch('setSelectedRelationId', { id, isDemo: this.isDemo });
        }
        this.$store.dispatch('setSelectedActiveType', "");
      },
    },
    sortedRelations() {
      const sortedRelations = [...this.relations];
      const { header, direction } = this.sortCriteria;
      sortedRelations.sort((a, b) => (
        a[header] && a[header].localeCompare(b[header], 'es', { sensitivity: 'base' }) * direction),
      );

      return sortedRelations;
    },
    getSelectedRelationId() {
      return this.$store.state.relations.selectedRelationId;
    },
    getSelectedActiveType() {
      return this.$store.state.relations.selectedActiveTypeSelector;
    },
  },
  data() {
    return {
      sortCriteria: {},
      headers: [
        { title: 'firstName', columnWidth: '160' },
        { title: 'lastName', columnWidth: '160' },
        { title: 'rut', columnWidth: '120' },
        { title: 'email', columnWidth: '200' },
        { title: 'phone', columnWidth: '160'},
      ],
    };
  },
};
</script>

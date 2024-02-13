<template>
  <div>
    <table class="justify-between w-full table-fixed tableMin text-vl-gray-400 min-h borderlistos">
      <thead class="">
        <tr
          v-if="showHeaders"
          class="text-vl-gray-400 "
        >
          <th
            v-if="withCheckbox"
            class="sticky top-0 z-10 w-8 uppercase bg-white border-t-2 border-b-2 text-vl border-vl-value borderlistos"
          >
            <input
              v-model="allCheckboxSelected"
              @change="toggleAllCheckboxSelected"
              type="checkbox"
              class="w-full px-2 border-secondary focus:outline-none"
            >
          </th>
          <th
            v-for="(header, index) in finalHeaders"
            :key="index"
            class="sticky top-0 py-2 font-medium bg-white border-t-2 border-b-2 border-vl-value"
            :style="`width: ${header.columnWidth}px`"
            > <!--Relations-->
            <div class="flex items-center justify-between text-left">
              <span
                class="pl-2 uppercase text-vl"
                v-if="header.title"
                v-tooltip.top="{
                  content: header.headerTooltip ? $t(`message.tableHeaders.${header.headerTooltip}`) : '',
                  classes: ['bg-vl-gray text-white px-6 bg-opacity-90 py-2 mb-2 rounded shadow-lg max-w-xs z-20']
                }"
              >
                {{ $t(`message.tableHeaders.${header.title}`) }}
              </span>
              <div
                v-if="header.title && withSort && sortedData.length"
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
          <th
            v-if="showView"
            class="sticky top-0 w-16 bg-white"
          >
            <span class="font-normal">
              D/R
            </span>
          </th>
          <th
            v-if="showEdit"
            class="sticky top-0 z-10 w-16 font-medium uppercase bg-white border-t-2 border-b-2 text-vl border-vl-value borderlistos"
          >
            Editar
          </th>
        </tr>
      </thead>
      <tr
        class='`break-words text-vl text-vl-gray-400`'
        v-for="(row, key) in sortedData"
        :key="key"
        @click="rowClicked(row.id, key)"
        :class="[
          (noHasHover === false ? '' : 'hover:bg-vl-blue-light'),
          ((noHasHover && selectedRow === key) ? 'bg-vl-blue-light' : ''),
          (validatedSelectedCheckboxesId(row.id) ? 'bg-vl-blue-light' : '')
        ]"
      >
        <td v-if="withCheckbox">
          <input
            @click="onClickCheckbox(row.id)"
            @click.stop
            @change="$emit('checkboxes-updated', selectedCheckboxRowIds)"
            v-model="rowCheckboxes[row.id]"
            type="checkbox"
            class="w-full px-2 border-secondary focus:outline-none"
          >
        </td>
        <td
          class="py-2 pl-2 tracking-wide"
          v-for="(header, index) in headers"
          :class='` ${(key === sortedData.length - 1) && lastRowTotal ? ` text-vl font-bold border-b-2 border-vl-value ${lastRowTotalByCurrency ? `${lastRowTotalByCurrencyClass}` : `bg-vl-gray-50`}` : ``} `'
          :style="'width: '+ header.columnWidth + 'px'"
          :key="index"
          v-tooltip.right-end="{
            content: header.tooltip ? tooltipText(row, header) : '',
            classes: ['bg-vl-gray text-white px-6 bg-opacity-90 py-2 rounded shadow-xl max-w-xs z-20']
          }"
        >
          <span
            v-if="(header.filter && row[header.title] !== '-') || (header.multiFilters && header.titles)"
            v-html="rowTextWithFilter(row, header)"
          >
          </span>
          <span
            v-else
            class="w-full"
          >
            <p v-html="rowText(row, header)"/>
          </span>
          
        </td>
        <td
          v-if="showView"
          @click.stop="viewClicked(row.id)"
        >
          <inline-svg
            class="cursor-pointer fill-current text-vl-gray-300 hover:text-vl-blue"
            :src="require('assets/images/icons/view.svg')"
          />
        </td>
        <td
          v-if="showEdit"
          @click.stop="editClicked(row.id)"
        >
          <inline-svg
            class="cursor-pointer fill-current text-vl-gray-300 hover:text-vl-blue ml-4"
            :src="require('assets/images/icons/edit2.svg')"
          />
        </td>
      </tr>
    </table>
  </div>
</template>
<script>
import Vue from 'vue/dist/vue.esm';

const NUMERIC_FILTERS = [
  'currency',
  'integerCurrency',
  'percent',
  'roundNumber',
  'quantity',
  'roundPercentNumber',
];

export default {
  props: {
    currency: { type: String, default: 'CLP' },
    showHeaders: { type: Boolean, default: true },
    hasFullColumn: { type: Boolean, default: false },
    fullColumnValue: { type: String, default: '' },
    headers: { type: Array, required: true },
    tableData: { type: Array, required: true },
    showView: { type: Boolean, default: false },
    showEdit: { type: Boolean, default: false },
    withCheckbox: { type: Boolean, default: false },
    withSort: { type: Boolean, default: true },
    lastRowTotal: { type: Boolean, default: false },
    lastRowTotalByCurrency: { type: Boolean, default: false },
    lastRowTotalByCurrencyClass: { type: String, default: '' },
    lastRowTotalClass: { type: String, default: '' },
    noHasHover: { type: Boolean, default: true },
  },
  data() {
    return {
      allCheckboxSelected: false,
      rowCheckboxes: this.generateRowCheckboxes(),
      selectedRow: null,
      sortCriteria: { header: {} },
    };
  },
  methods: {
    criteriaIsSelected(dir, title) {
      const { direction, header } = this.sortCriteria;

      return direction === dir && header.title === title;
    },
    toggleAllCheckboxSelected() {
      this.rowCheckboxes = this.generateRowCheckboxes(this.allCheckboxSelected);
      this.$emit('checkboxes-updated', this.selectedCheckboxRowIds);
    },
    onClickCheckbox(id) {
      this.$emit('checkboxes-updated', this.selectedCheckboxRowIds);
    },
    format(value, filter) {
      return Vue.filter(filter)(value);
    },
    generateRowCheckboxes(value = false) {
      const rowCheckboxes = {};
      this.tableData.forEach((row) => {
        rowCheckboxes[row.id] = value;
      });
      return rowCheckboxes;
    },
    viewClicked(id) {
      this.$emit('view-clicked', id);
    },
    editClicked(id) {
      this.$emit('edit-clicked', id);
    },
    rowClicked(id, key) {
      this.$emit('row-clicked', id);
      this.selectedRow = key;
    },
    tooltipText(row, header) {
      if (!header.tooltipCols) return row[header.title];
      const textArray = header.tooltipCols.map((column) => row[column]);

      return textArray.join(' - ');
    },
    rowText(row, header) {
      if (row[header.title] === '' || !row[header.title]) return ''
      if (header.hasHighlight) return (
            `
              <div class="py-1 mx-2 overflow-hidden font-normal text-center capitalize text-vl text-vl-gray-400 rounded-3xl bg-vl-gray-value-50"> 
                ${row[header.title]}
              </div>
            `
          );

      if (!header.titles) return row[header.title];
     
      const textArray = header.titles.map((column) => row[column]);

      return `
        ${textArray.map((text, index) => {
          if (!text || text === '-') return '';          
          return (
            `
              <div id=${index} class=${index === 0 || text === 'Total' || text === 'Total Cuenta' ? 
                `${index === 0 && text !== 'Total' && text !== 'Total Cuenta' ? 
                'text-vl font-medium' : 'uppercase font-bold'} text-vl text-vl-gray-400` : 
                'text-xs truncate font-normal text-vl-gray-400'}
              > 
                ${text}
              </div>
            `
          );
        }).join('')}
      `;
    },
    rowTextWithFilter(row, header) {
      if ((!row[header.title] || row[header.title] === '') && !header.showAll) return ''
      if (header.fontStyle && !header.titles && !header.multiFilters) return `<div class="${header.fontStyle}"> ${this.$options.filters[header.filter](row[header.title], this.currency)} </div>`
      if (!header.titles && !header.multiFilters) return this.$options.filters[header.filter](row[header.title], this.currency);

      const textArray = header.titles.map((column) => row[column]);

      return `
        ${textArray.map((text, index) => {   
          if (!text || text === 0) {
            return (
              `
                <div id=${index} class="${index === 0 ? `${header.fontStyle}` : ''}">
                  ${this.$options.filters[header.multiFilters[index]](text, this.currency)}
                </div>
              `
            );
          }
          if(header.withColor) {
            return (
              `
                <div id=${index} class="${text > 0 ? 'text-vl text-vl-green' : 'text-vl text-vl-red'} ${index === 0 ? `text-vl2 font-medium ${header.fontStyle}` : 'text-xs font-normal'} ${row.name === 'Total' || row.name === 'Total Cuenta' ? 'last' : ''} ">
                  ${this.$options.filters[header.multiFilters[index]](index === 0 && text < 0 ? this.convertToPositiveNumber(text) : text, this.currency)}
                </div>
              `
            );
          }

          return (
            `
              <div id=${index} class="${text > 0 ? 'text-vl ' : 'text-vl '} ${index === 0 ? `text-vl2 font-medium ${header.fontStyle}` : 'text-xs font-normal'} ${row.name === 'Total' || row.name === 'Total Cuenta' ? 'last' : ''} ">
                ${this.$options.filters[header.multiFilters[index]](index === 0 && text < 0 ? this.convertToPositiveNumber(text) : text, this.currency)}
              </div>
            `
            
          );
        }).join('')}
      `;
    },
    convertToPositiveNumber(value) {
      return Math.abs(value)
    },
    toggleSort(criteria) {
      this.sortCriteria = criteria;
    },
    customSort(filter, title, direction) {
      return function (a, b) {
        const valueA = a[title];
        const valueB = b[title];
      
        if (NUMERIC_FILTERS.includes(filter)) {
          return ((valueA) - (valueB) || parseFloat(valueA) - parseFloat(valueB)) * direction;
        }
        return valueA && valueA.localeCompare(valueB, 'es', { sensitivity: 'base' }) * direction;
      };
    },
    validatedSelectedCheckboxesId(id) {
      return !!this.selectedCheckboxRowIds.find(checkboxId => checkboxId == id)
    },
  },
  computed: {
     sortedData() {
      const sortedData = this.lastRowTotal ? this.tableData.slice(0, -1) : [...this.tableData];
      const { header: { filter, title, multiFilters, titles }, direction } = this.sortCriteria;

      sortedData.sort(this.customSort(multiFilters ? multiFilters[0] : filter, multiFilters && titles ? titles[0] : title, direction));
      return this.lastRowTotal ? [...sortedData, this.tableData[this.tableData.length - 1]] : sortedData;
    },
    selectedCheckboxRowIds() {
      const trueValues = Object.entries(this.rowCheckboxes).filter(([, value]) => value);
      return trueValues.map(([key]) => key);
    },
    finalHeaders() {
      return this.hasFullColumn ? ['', ...this.headers] : this.headers;
    },
  },
};
</script>
<style lang="scss">
  @import url('https://fonts.googleapis.com/css2?family=Roboto+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;1,100;1,200;1,300;1,400;1,500;1,600;1,700&display=swap');
  .first-row:hover td:not(:first-child) {
    @apply bg-secondary;
  }
  .last {
    font-weight: bold !important;;
  };
</style>

<style scoped>
  @media (min-width: 1000px) {
    .tableMin {
      table-layout: auto;
    }
  }
</style>

<style scoped>
  .min-h {
    min-height: 40px;
  }
  .borderlistos {
    border-collapse: separate;
    border-spacing: 0;
  }
</style>
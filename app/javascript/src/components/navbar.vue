<template>
  <div
    class="pt-12 pb-2 border-b text-primary"
    :class="[
      relationView ? 'isGeneralRelationView' : 'isNotGeneralRelationView',
    ]"
  >
    <notifications group="app-notification" />
    <div
      class="mx-4"
      :class="[relationView ? 'isRelationView' : 'isNotRelationView']"
    >
      <div
        class="flex justify-between w-full h-full lg:grid lg:place-items-center"
        :class="[relationView ? 'grid-cols-7' : 'grid-cols-2']"
      >
        <a
          href="/"
          :class="[relationView ? 'justify-self-end' : 'justify-self-start']"
          @click="selectTab(0)"
        >
          <img
            :src="require('../../../assets/images/logo-valuelist.png')"
            class="h-8 my-1"
          />
        </a>
        <div
          v-if="relationView"
          class="self-end hidden w-full col-span-5 md:block md:w-auto lg:flex"
          id="mobile-menu"
        >
          <ul
            class="flex flex-col mt-4 md:flex-row md:mt-0 md:text-sm md:font-light"
          >
            <li class="relative" v-for="tab in tabs" :key="tab.index">
              <button
                v-if="tab.options"
                @click="toggleSubMenu(tab.index)"
                id="dropdownNavbarLink"
                data-dropdown-toggle="dropdownNavbar"
                class="flex items-center hover:hovered-option mx-2 mt-2 mb-2.5 px-2 py-1 justify-between w-full duration-200 font-normal border-b-4 border-vl-blue hover:bg-gray-50 md:hover:bg-vl-blue-light md:hover:text-vl-blue md:w-auto dark:text-gray-400 dark:hover:text-white dark:focus:text-white dark:border-gray-700 dark:hover:bg-gray-700 md:dark:hover:bg-transparent focus:outline-none"
                :class="[
                  selectedSubTab !== '' && parentIndexSelected === tab.index
                    ? 'text-vl-blue rounded-t'
                    : 'border-opacity-0 text-vl-gray font-light rounded',
                  selectedSubMenuOption === tab.index
                    ? 'dropdownNavbarLink'
                    : '',
                ]"
              >
                {{ tab.name }}
                <svg
                  class="w-4 h-4 ml-1"
                  :class="[
                    selectedSubMenuOption === tab.index ? 'arrowDown' : '',
                  ]"
                  id="arrowDown"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    fill-rule="evenodd"
                    d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                    clip-rule="evenodd"
                  />
                </svg>
              </button>
              <!-- Dropdown menu -->
              <div
                v-if="tab.options && selectedSubMenuOption === tab.index"
                id="dropdownNavbar"
                class="absolute z-10 list-none bg-white divide-y divide-gray-100 rounded shadow arrowDown list-options w-44 dark:bg-gray-700 dark:divide-gray-600"
              >
                <div class="py-1" aria-labelledby="dropdownLargeButton">
                  <li v-for="option in tab.options" :key="option.index">
                    <a
                      href="javascript:void(0)"
                      @click="selectSubTab(option.index, tab.index)"
                      class="block px-3 py-2 pb-2 font-light text-vl-gray hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-400 dark:hover:text-white"
                      >{{ option.name }}</a
                    >
                  </li>
                </div>
              </div>
              <a
                v-if="!tab.options"
                @click="selectTab(tab.index)"
                href="javascript:void(0)"
                class="block mx-2 mt-2 mb-2.5 px-2 py-1 hover:hovered-option font-normal border-b-4 border-vl-blue hover:text-vl-blue hover:bg-vl-blue-light md:hover:bg-vl-blue-light duration-200 md:hover:text-vl-blue dark:text-gray-400 dark:hover:text-white dark:border-gray-700 dark:hover:bg-gray-700 md:dark:hover:bg-transparent focus:outline-none"
                :class="[
                  tab.index === selectedTab
                    ? 'text-vl-blue rounded-t'
                    : 'border-opacity-0 text-vl-gray font-light rounded',
                ]"
              >
                {{ tab.name }}
              </a>
            </li>
          </ul>
        </div>
        <div
          class="flex flex-col items-center my-1 mr-2 text-right justify-self-end"
        >
          <a
            class="hidden p-2 text-white rounded-full cursor-pointer bg-vl-blue lg:block"
            @click="toggleDropdown"
          >
            {{ userInitials }}
          </a>
          <inline-svg
            class="h-8 cursor-pointer fill-current text-vl-blue lg:hidden"
            :class="{ fixed: showDropdown }"
            :src="
              require(`assets/images/icons/${
                showDropdown ? 'close' : 'burger-menu'
              }.svg`)
            "
            @click="toggleDropdown"
          />
          <inline-svg
            v-if="showDropdown"
            class="absolute z-10 hidden mt-10 fill-current text-vl-blue lg:block"
            :src="require('assets/images/icons/triangle.svg')"
          />
          <div
            v-if="showDropdown"
            class="fixed inset-y-0 left-0 z-20 flex flex-col justify-between w-5/6 h-full py-16 pl-4 text-left lg:absolute lg:left-auto lg:inset-y-auto lg:justify-start lg:w-auto lg:h-auto bg-vl-blue lg:p-0 lg:right-0 lg:mt-12 lg:ml-1 lg:mr-8 lg:bg-white lg:border-t-8 lg:shadow-xl lg:border-vl-blue"
          >
            <div
              class="flex flex-col lg:hidden"
              v-if="relationView || userType === 'relation'"
            >
              <button
                v-for="tab in tabs"
                :key="tab.index"
                class="py-2 text-lg text-left text-white lg:px-4 lg:text-base lg:text-gray-600 lg:border-b lg:hover:bg-vl-blue-light"
                @click="selectTab(tab.index)"
              >
                {{ tab.name }}
              </button>
            </div>
            <div v-else>
              <button
                class="w-full py-2 text-lg text-left text-white lg:px-4 lg:text-base lg:text-gray-600 lg:border-b lg:hover:bg-vl-blue-light"
                @click="goToRoot"
              >
                Ver relaciones
              </button>
            </div>
            <div class="flex flex-col justify-end h-full justify-self-end">
              <a
                class="py-2 text-white lg:px-4 lg:text-gray-600 lg:border-b lg:hover:bg-vl-blue-light"
                :href="`/sessions/${userType}/change_password`"
              >
                Cambiar contraseña
              </a>
              <a
                class="py-2 text-white lg:px-4 lg:text-gray-600 lg:hover:bg-vl-blue-light"
                :href="`/${userType}s/sign_out`"
              >
                Cerrar sesión
              </a>
            </div>
          </div>
        </div>
        <div
          v-if="showDropdown"
          @click="toggleDropdown()"
          class="fixed inset-0 z-10 w-full h-full cursor-default"
        />
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: {
    relationView: { type: Boolean, default: false },
    userType: { type: String, required: true },
    userInitials: { type: String, required: true },
  },
  data() {
    return {
      showDropdown: false,
      tabs: [
        { index: 0, name: "Inversiones" },
        { index: 3, name: this.$t("message.titles.pensionFunds") },
        { index: 1, name: this.$t("Bienes Raíces") },
        { index: 2, name: "Desempeño Instrumentos" },
        {
          index: 4,
          name: "Reportes",
          options: [
            { name: "Reporte Inversiones", index: 5 },
            { name: "Reporte Fondos de Pensiones", index: 6 },
            { name: "Reporte Bienes Raíces", index: 8 },
          ],
          action: this.selectTab,
        },
        { index: 7, name: this.$t("message.titles.documents") },
      ],
      selectedSubMenuOption: "",
      parentIndexSelected: 0,
    };
  },
  computed: {
    selectedTab() {
      return this.$store.state.navbar.selectedTabIndex;
    },
    selectedSubTab() {
      return this.$store.state.navbar.selectedSubTabIndex;
    },
  },
  methods: {
    goToRoot() {
      window.open("/", "_self");
    },
    selectTab(index) {
      this.$store.dispatch("setSelectedTab", index);
      this.$store.dispatch("setSelectedSubTab", "");

      this.selectedSubMenuOption = "";

      if (this.relationView) {
        this.showDropdown = false;
      } else {
        this.goToRoot();
      }
    },
    selectSubTab(subIndex, index) {
      this.$store.dispatch("setSelectedSubTab", subIndex);
      this.$store.dispatch("setSelectedTab", "");
      this.selectedSubMenuOption = "";
      this.parentIndexSelected = index;

      if (this.relationView) {
        this.showDropdown = false;
      } else {
        this.goToRoot();
      }
    },
    toggleDropdown() {
      this.showDropdown = !this.showDropdown;
    },
    toggleSubMenu(index) {
      if (this.selectedSubMenuOption === index) {
        this.selectedSubMenuOption = "";
      } else {
        this.selectedSubMenuOption = index;
      }
    },
  },
  mounted() {
    this.$store.dispatch("setUser", { userType: this.userType });
    this.$store.dispatch("setSelectedTab", 0);
  },
};
</script>

<style lang="scss">
.vue-notification {
  @apply bg-vl-blue-light border-vl-blue text-vl-blue;

  &.warn {
    @apply bg-vl-red-light border-vl-red text-vl-red;
  }
}
@media (min-width: 640px) {
  .isRelationView {
    margin-left: 2.5rem /* 40px */;
    margin-right: 2.5rem /* 40px */;
  }
  .isNotRelationView {
    margin-left: 1rem /* 16px */;
    margin-right: 1rem /* 16px */;
  }
  .isGeneralRelationView {
    padding-top: 4rem /* 64px */;
  }
  .isNotGeneralRelationView {
    padding-top: 0.5rem /* 8px */;
  }
}
.list-options {
  font-size: 12px;
  line-height: 14px;
  width: 190px;
}
.hovered-option {
  border-radius: 4px !important;
}
.arrowDown {
  transition: all 0.8s ease-out;
  -moz-transition: all 0.8s ease-out;
  -ms-transition: all 0.8s ease-out;
  -o-transition: all 0.8s ease-out;
  -webkit-transition: all 0.8s ease-out;
}
.dropdownNavbarLink .arrowDown {
  transform: rotate(180deg);
  -moz-transform: rotate(180deg);
  -ms-transform: rotate(180deg);
  -o-transform: rotate(180deg);
  -webkit-transform: rotate(180deg);
}
</style>

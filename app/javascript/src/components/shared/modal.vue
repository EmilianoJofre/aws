<template>
  <div class="container text-sm font-light text-vl-gray">
    <div class="flex">
      <div class="my-4 ml-8 font-semibold capitalize text-lgOriginal text-vl-blue">
        <p>{{ actionText }}</p>
      </div>
      <div class="flex ml-auto mr-5">
        <button
          @click="$emit('close')"
          class="focus:outline-none"
        >
          <inline-svg
            :src="require('../../../../assets/images/icons/close.svg')"
            class="h-6 m-2 my-2 cursor-pointer fill-current"
          />
        </button>
      </div>
    </div>
    <div>
      <slot name="input" />
      <loading
        is-small
        v-if="loading"
      />
      <p
        v-if="error"
        class="mb-4 text-center whitespace-pre-line"
      >
        {{ error }}
      </p>
      <div
        v-if="!$slots.buttons && !loading"
        class="flex flex-col items-center justify-center self-end mb-4"
      >
        <div class="flex">
          <inline-svg
            :src="require('../../../../assets/images/icons/addAccount.svg')"
            class="h-3 w-3 margin-left absolute cursor-pointer fill-current"
          />
          <btn
            @click="$emit('confirm-clicked')"
            variant="addAccount"
            :text="confirmText"
            :disabled="confirmDisabled"
          />
        </div>
        <btn
          v-if="deleteText"
          @click="$emit('delete-clicked')"
          variant="deleteAccount"
          :text="deleteText"
          class="mt-2"
        />
      </div>
      <div class="mb-4">
        <slot name="buttons" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    actionText: { type: String, required: true },
    confirmText: { type: String, required: true },
    confirmDisabled: { type: Boolean, default: false },
    deleteText: { type: String, default: null },
    error: { type: String, default: null },
    loading: { type: Boolean, required: true },
  },
};
</script>
<style scoped>
  .container { 
    margin-top: 7px;
  }
  .margin-left {
    margin-left: 105px;
    margin-top:16.5px;
  }
</style>
<template>
  <div
    @click="$emit('click')"
    class="flex justify-between px-2 py-4 border border-l-8 rounded-md border-vl-blue"
  >
    <div>
      <p
        v-for="(element, index) in content"
        :key="index"
        :class="element.class"
      >
        <span
          v-if="element.title"
          class="font-bold"
        >
          {{ element.title }}:
        </span> {{ element.content }}
      </p>
    </div>
    <div
      v-if="pill && pill.content"
      class="flex-shrink-0"
    >
      <p
        class="px-2 py-1 rounded"
        :class="pill.class"
      >
        {{ pill.content }}
      </p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    content: { type: Array, required: true },
    pill: { type: Object, default: () => {} },
  },
};
</script>

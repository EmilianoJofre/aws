import Vue from 'vue/dist/vue.esm';

document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('wrapper') !== null) {
    return new Vue({
      el: '#wrapper',
    });
  }

  return null;
});

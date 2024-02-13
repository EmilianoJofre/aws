<template>
  <div class="text-center">
    <div class="bg-black rounded-md opacity-90 snackbar" >
      <div class="container">
        <div class="font-semibold container-title-btn">
          {{ text }}
          <button
            class="justify-end p-0 btn-close"
            @click="onClose"
          >
            <inline-svg
              class="fill-current "
              :src="require(`assets/images/icons/close.svg`)"
            />
          </button>
        </div>
        <div class="weigth-file">
          Tamaño - {{formatBytes(randomNumber)}}
        </div>
        <progress-bar v-if="!isFinishedDownload" :value="100" bar-class="bg-info"/>
        <div v-if="isFinishedDownload" class="successfull-download text-vl-green-success">Descarga exitosa</div>
      </div>
    </div>
  </div>
</template>

<script>
  import progressBar from './shared/progresive-bar.vue';

  export default {
    components: {
      progressBar
    },
    name: "Snackbar",
    data() {
      return {
        randomNumber: this.getRandomArbitrary(800000,2600000)
      };
    },
    beforeDestroy() {
      this.onClose()
    },
    methods: {
      formatBytes(bytes, decimals = 2) {
        if (bytes === 0) return '0 Bytes';

        const k = 1024;
        const dm = decimals < 0 ? 0 : decimals;
        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

        const i = Math.floor(Math.log(bytes) / Math.log(k));

        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
      },
      getRandomArbitrary(min, max) {
        return Math.random() * (max - min);
      },
      onClose() {
        this.$store.dispatch('isOpenNackBar', false);
        this.$store.dispatch('setFileName', "");
        this.$store.dispatch('validateDownload', false);
      }
    },
    computed: {
      snackbar() {
        return this.$store.state.relationFiles.isOpenNackbar;
      },
      text() {
        return this.$store.state.relationFiles.filename;
      },
      isFinishedDownload() {
        return this.$store.state.relationFiles.isFinished;
      }
    },
    mounted() {
      setTimeout(() => {
        this.onClose()
      }, 10000);
    },
  }
</script>
<style lang="sass">
  .container-title-btn {
    margin-top: -2px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 14px;
  }
  .weigth-file {
    font-size: 12px;
    text-align: initial;
    margin: 4px 0;
  }
  .successfull-download {
    font-size: 12px;
    margin-bottom: 2px;
    text-align: initial;
  }
  .snackbar {
    width: 378px;
    height: 83px;
    position: fixed;
    bottom: 30px;
    right: 32px;
    z-index: 200;
    background-color: rgba(0,0,0,0.7);
    color: white;

    .container {
      margin: 14px;
    }
  }
  .btn-close {
    color: rgba(226, 226, 226, 0.32);;
  }
</style>
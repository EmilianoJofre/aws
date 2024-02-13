<template>
    <div
        class="progressbar"
    >
        <div
        :class="barClass"
        :style="barStyle"
        class="progressbar-bar"
        >
            <slot/>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'progress-bar',
        props: {
        value: {
            type: Number,
            default: 0
        },
        barClass: {
            type: String,
            default: ''
        },
        origin: {
            type: String,
            default: 'left'
        },
        scale: {
            type: String,
            default: 'X',
            validator: v => ['X', 'Y'].includes(v)
        }
        },
        data() {
            return {
                ready: false
            }
        },
        computed: {
            barStyle() {
                if (!this.ready) {
                return {
                    transform: `scale${this.scale}(0)`
                }
                }

                return {
                transform: `scale${this.scale}(${this.value * 0.01})`,
                transformOrigin: `${this.origin}`
                }
            }
        },
        mounted() {
            setTimeout(() => { this.ready = true }, 0)
        },
    }
</script>

<style lang="scss">
    .progressbar {
        height: 8px;
        background-color: white;
        width: 92%;
        border-radius: 20px;
    }
    .progressbar-bar {
        height: 100%;
        background-color: #4f52ff;
        transition: transform 3s ease;
        border-radius: 20px;
    }
    .bg-info {
        background-color: #4f52ff;
    }
</style>
<template>
    
</template>

<script>

export default {
    data() {
        return {
            points: [],
            has_points: false
        }
    },

    mounted() {
        const point_list = JSON.parse(this.$el.dataset.points);
        
    }
}

</script>
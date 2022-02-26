var faithfulapp = new Vue({
  el: '#faithfulapp',
  data: {
    data: faithful,
    layout: {
      title: "histogram of waiting times",
      xaxis: {title: {text: "waiting time to next eruption (in mins)"}},
      yaxis: {title: {text: "Frequency"}}},
    config: { responsive: true },
    bins: 30
  },
  computed: {
    series: function() {
      return [{
        x: this.data,
        type: 'histogram',
        nbinsx: this.bins
      }];
    }
  },
  watch: {
    series: function() {
      this.updatePlot()
    }
  },
  mounted: function() {
    this.updatePlot()
  },
  methods: {
    updatePlot: function() {
      Plotly.newPlot('plot', this.series, this.layout, this.config)
    }
  },
  components: {
    'vueSlider': window[ 'vue-slider-component' ],
  }
});
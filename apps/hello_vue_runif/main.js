const server = "http://localhost:3002";

var faithfulapp = new Vue({
  el: '#runifapp',
  data: {
    data: [],
    layout: {
      title: "distribution of random uniform numbers",
      xaxis: {title: {text: "x"}}
    },
    config: { responsive: true },
    nobs: null
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
    nobs: function() {
      const self = this

      axios
        .get(`${server}/rand?n=${self.nobs}`)
        .then(function (response) {
          self.data = response.data
        })
        .catch(function (error) {
          console.log(error)
        })
    },
    data: function() {
      Plotly.newPlot('plot', this.series, this.layout, this.config)
    }
  },
  mounted: function() {
    const self = this
    self.nobs = 1000
  },
  components: {
    'vueSlider': window[ 'vue-slider-component' ],
  }
});
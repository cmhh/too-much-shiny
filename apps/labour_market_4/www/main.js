const server = "http://localhost:3001";

Vue.component('v-select', VueSelect.VueSelect);
var app = new Vue({
  el: "#labmktapp",
  data: {
    subjects: [],
    selectedSubject: {},
    groups: [],
    selectedGroup: {},
    series: [],
    selectedSeries: [],
    values: [],
    layout: {
      xaxis: {title: {text: "date"}},
      legend: {orientation: "h", yanchor: "bottom", y: -0.25},
      margin: {t: 0}
    },
    config: { responsive: true }
  },
  mounted: function() {
    const self = this
    axios
      .get(`${server}/subjects`)
      .then(function (response) {
        self.subjects = response.data.map(x => {
          let obj = {}
          obj["code"] = x.subject_code
          obj["label"] = `${x.subject_code} - ${x.subject_description}`
          return obj
        })
        self.selectedSubject = self.subjects[0]
        self.selectedGroup = {}
        self.selectedSeries = []
      })
      .catch(function (error) {
        console.log(error)
      })
  },
  computed: {
    trace: function() {
      const refs = this.values
        .map(x => {return x.series_reference})
        .filter((v,i,a) => a.indexOf(v) == i)

      res = refs.map(ref => {
        const sub = this.values.filter(x => x.series_reference == ref)
        const xs = sub.map(x => {return x.period})
        const ys = sub.map(x => {return x.data_value})
        obj = {}
        obj["type"] = "scatter"
        obj["mode"] = "lines"
        obj["name"] = ref
        obj["x"] = xs
        obj["y"] = ys
        return obj
      })

      return res
    }
  },
  watch: {
    selectedSubject: function() {
      const self = this
      const url = `${server}/groups/${self.selectedSubject["code"]}`
      axios
        .get(url)
        .then(function(response) {
          data = response.data.map(x => {
            obj = {}
            obj["code"] = x.group_code
            obj["label"] = x.group_description
            return obj
          })
          self.groups = data
          self.selectedGroup = data[0]
        })
        .catch(function (error) {
          console.log(error)
        })
    },
    selectedGroup: function() {
      const self = this
      axios
        .get(`${server}/series/${self.selectedSubject["code"]}/${self.selectedGroup["code"]}`)
        .then(function (response) {
          self.series = response.data.map(x => {
            obj = {}
            obj["code"] = x.series_reference
            obj["label"] = x.series_reference + " - " + self.titles(x)
            return obj
          })
          self.selectedSeries = []
        })
        .catch(function (error) {
          console.log(error)
        })
    },
    selectedSeries: function() {
      const self = this
      if (self.selectedSeries.length == 0) {
        self.values = []
      } else {
        const refQuery = self.selectedSeries.map(x => {
          return `seriesReference=${x.code}`
        }).join('&')

        const url = `${server}/values/${self.selectedSubject["code"]}/` +
          `${self.selectedGroup["code"]}?${refQuery}`

        axios
          .get(url)
          .then(function(response) {
            self.values = response.data
          })
          .catch(function (error) {
            console.log(error)
          })
      }
    },
    trace: function() {
      if (this.trace.length == 0) {
        this.hidePlot()
      } else {
        this.unhidePlot()
      }
      this.updatePlot()
    }
  },
  methods: {
    titles: function(s) {
      var res = s.series_title_1
      if (s.series_title_2 != "") res = res + ", " + s.series_title_2
      if (s.series_title_3 != "") res = res + ", " + s.series_title_3
      if (s.series_title_4 != "") res = res + ", " + s.series_title_4
      if (s.series_title_5 != "") res = res + ", " + s.series_title_5
      return res
    },
    hidePlot: function() {
      document.getElementById("labmktplot").style.display = "none"
    },
    unhidePlot: function() {
      document.getElementById("labmktplot").style.display = "block"
    },
    updatePlot: function() {
      Plotly.newPlot('labmktplot', this.trace, this.layout, this.config)
    }
  }
})
import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);


export default class extends Controller {
  static targets = ["points", "value"]
  static values = {
    labels: Array,
    points: Array,
    values: Array
  }

  pointsChart = null
  valueChart = null

  connect() {
    if (this.pointsChart)
      this.pointsChart.destroy()
    if (this.valueChart)
      this.valueChart.destroy()
    this.initPointsChart()
    this.initValueChart()
  }

  disconnect() {
    if (this.pointsChart)
      this.pointsChart.destroy()
    if (this.valueChart)
      this.valueChart.destroy()
  }

  initPointsChart() {
    new Chart(this.pointsTarget, {
      type: 'line',
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: 'Total Points',
          data: this.pointsValue,
          borderColor: 'rgba(75, 192, 192, 1)',
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          fill: true,
        }]
      },
      options: {
        responsive: true,
        scales: {
          x: {
            title: {
              display: true,
              text: 'Gameweek'
            }
          },
          y: {
            title: {
              display: true,
              text: 'Points'
            }
          }
        }
      }
    })
  }

  initValueChart() {
    const adjustedValues = this.valuesValue.map(value => value / 10)
    new Chart(this.valueTarget, {
      type: 'line',
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: 'Value',
          data: adjustedValues,
          borderColor: 'rgba(153, 102, 255, 1)',
          backgroundColor: 'rgba(153, 102, 255, 0.2)',
          fill: true,
        }]
      },
      options: {
        responsive: true,
        scales: {
          x: {
            title: {
              display: true,
              text: 'Gameweek'
            }
          },
          y: {
            title: {
              display: true,
              text: 'Value'
            },
            ticks: {
              stepSize: 0.1,
              callback: function (value) {
                return value.toFixed(1);
              }
            }
          }
        }
      }
    })
  }
}

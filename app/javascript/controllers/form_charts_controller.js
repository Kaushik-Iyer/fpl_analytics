import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);
export default class extends Controller {
  static targets = ["points", "value"]
  static values = {
    topScorers: Array,
    priceRisers: Array,
    gameweeks: Array,
    selectedPosition: String,
    selectedTeam: String
  }

  filter(event) {
    const positionSelect = this.element.querySelector('select[data-action="change->form-charts#filter"]:nth-child(1)')
    const teamSelect = this.element.querySelector('select[data-action="change->form-charts#filter"]:nth-child(2)')

    const position = positionSelect.value
    const team = teamSelect.value

    const url = new URL(window.location.href)

    fetch(`/players/in_form_players?position_id=${position}&team_id=${team}`, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
      .then(response => response.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  connect() {
    this.initPointsChart()
    this.initValueChart()
  }

  initPointsChart() {
    const ctx = this.pointsTarget.getContext('2d')

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.gameweeksValue,
        datasets: this.topScorersValue.map((player, index) => ({
          label: player.web_name,
          data: player.points_history,
          borderColor: this.getColor(index),
          backgroundColor: this.getColor(index, 0.1),
          borderWidth: 2,
          tension: 0.1,
          fill: true,
          spanGaps: true
        }))
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top',
            labels: {
              boxWidth: 12,
              padding: 15,
              usePointStyle: true,
              font: {
                size: 11
              }
            }
          }
        },
        scales: {
          y: {
            title: {
              display: true,
              text: 'Points',
              font: {
                size: 11
              }
            },
            grid: {
              color: 'rgba(0,0,0,0.05)'
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        }
      }
    })
  }

  initValueChart() {
    const ctx = this.valueTarget.getContext('2d')

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.gameweeksValue,
        datasets: this.priceRisersValue.map((player, index) => ({
          label: player.web_name,
          data: player.value_history,
          borderColor: this.getColor(index),
          backgroundColor: this.getColor(index, 0.1),
          borderWidth: 2,
          tension: 0.1,
          fill: true,
          spanGaps: true
        }))
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'top',
            labels: {
              boxWidth: 12,
              padding: 15,
              usePointStyle: true,
              font: {
                size: 11
              }
            }
          }
        },
        scales: {
          y: {
            title: {
              display: true,
              text: 'Value',
              font: {
                size: 11
              }
            },
            grid: {
              color: 'rgba(0,0,0,0.05)'
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        }
      }
    })
  }

  getColor(index, alpha = 1) {
    const colors = [
      `rgba(59, 130, 246, ${alpha})`,   // Blue
      `rgba(16, 185, 129, ${alpha})`,   // Green
      `rgba(239, 68, 68, ${alpha})`,    // Red
      `rgba(245, 158, 11, ${alpha})`,   // Amber
      `rgba(139, 92, 246, ${alpha})`    // Purple
    ]
    return colors[index % colors.length]
  }
}


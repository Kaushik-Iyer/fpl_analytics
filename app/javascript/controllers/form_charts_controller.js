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
          fill: false,
          spanGaps: true // Edge case: if a player misses a gameweek, the line will be broken
        }))
      },
      options: {
        responsive: true,
        scales: {
          y: {
            title: { display: true, text: 'Points' }
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
          data: player.value_history, // Access the data directly
          borderColor: this.getColor(index),
          fill: false,
          spanGaps: true
        }))
      },
      options: {
        responsive: true,
        scales: {
          y: {
            title: { display: true, text: 'Value' }
          }
        }
      }
    })
  }

  getColor(index) {
    const colors = [
      'rgb(75, 192, 192)',
      'rgb(153, 102, 255)',
      'rgb(255, 99, 132)'
    ]
    return colors[index % colors.length]
  }
}
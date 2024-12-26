import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.results = []
  }

  search() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.resultsTarget.innerHTML = ''
      return
    }

    fetch(`/players/search?query=${query}`)
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
      })
  }

  select(event) {
    const playerId = event.currentTarget.dataset.playerId
    fetch(`/players/performance?id=${playerId}`)
      .then(response => response.text())
      .then(html => {
        document.getElementById('player_performance').innerHTML = html
        document.getElementById('price_chart').innerHTML = html
      })

    this.resultsTarget.innerHTML = ''
    this.inputTarget.value = ''
  }
}

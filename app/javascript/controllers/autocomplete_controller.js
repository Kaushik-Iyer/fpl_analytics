import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.results = []
    this.selectedIndex = -1

    // Add CSS for highlighting the selected entry
    const style = document.createElement('style')
    style.innerHTML = `
      .bg-gray-200 {
        background-color: #e2e8f0; /* Tailwind CSS gray-200 color */
      }
    `
    document.head.appendChild(style)
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
        this.results = Array.from(this.resultsTarget.children)
        this.selectedIndex = -1
      })
  }

  select(event) {
    const playerId = event.currentTarget.dataset.playerId
    this.fetchPlayerPerformance(playerId)
  }

  fetchPlayerPerformance(playerId) {
    fetch(`/players/performance?id=${playerId}`)
      .then(response => response.text())
      .then(html => {
        document.getElementById('player_performance').innerHTML = html
        document.getElementById('price_chart').innerHTML = html
      })

    // Clear the input field and hide the results dropdown
    this.inputTarget.value = ''
    this.resultsTarget.innerHTML = ''
  }

  navigate(event) {
    if (event.key === "Tab") {
      event.preventDefault()
      this.selectedIndex = (this.selectedIndex + 1) % this.results.length
      this.updateSelection()
    } else if (event.key === "Enter") {
      event.preventDefault()
      if (this.selectedIndex >= 0) {
        const selectedElement = this.results[this.selectedIndex]
        const playerId = selectedElement.dataset.playerId
        this.fetchPlayerPerformance(playerId)
      }
    }
  }

  updateSelection() {
    this.results.forEach((result, index) => {
      if (index === this.selectedIndex) {
        result.classList.add("bg-gray-200")
      } else {
        result.classList.remove("bg-gray-200")
      }
    })
  }
}
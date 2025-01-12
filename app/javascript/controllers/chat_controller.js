import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "response", "toggle", "window"]

    toggleChat() {
        this.windowTarget.classList.toggle("hidden")
    }

    connect() {
        // Called when the controller is connected to the DOM
    }

    async submit(event) {
        event.preventDefault()
        const userQuery = this.inputTarget.value

        try {
            const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
            const response = await fetch("/chat/respond", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": csrfToken
                },
                body: JSON.stringify({ query: userQuery })
            })

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`)
            }

            const data = await response.json()
            this.responseTarget.textContent = data.response || data.error || "No response."
        } catch (error) {
            this.responseTarget.textContent = `Error: ${error.message}`
        }
    }
}
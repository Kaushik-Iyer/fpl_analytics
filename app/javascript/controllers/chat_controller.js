import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "response", "toggle", "window"]

    clearChat() {
        this.responseTarget.innerHTML = ''
        this.chatHistory = []
    }

    connect() {
        this.chatHistory = []
    }

    async submit(event) {
        event.preventDefault()
        const userQuery = this.inputTarget.value

        // Add user message to chat
        this.addMessageToChat('user', userQuery)
        this.inputTarget.value = ''

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
            // Add bot response to chat
            this.addMessageToChat('bot', data.response)
        } catch (error) {
            this.addMessageToChat('bot', `Error: ${error.message}`)
        }
    }

    addMessageToChat(sender, message) {
        const messageDiv = document.createElement('div')
        messageDiv.className = `mb-4 ${sender === 'user' ? 'text-right' : 'text-left'}`

        const bubble = document.createElement('div')
        bubble.className = `inline-block p-2 rounded-lg ${sender === 'user'
            ? 'bg-blue-600 text-white'
            : 'bg-gray-200 text-gray-800'
            }`
        bubble.textContent = message

        messageDiv.appendChild(bubble)
        this.responseTarget.appendChild(messageDiv)

        // Scroll to bottom
        this.responseTarget.scrollTop = this.responseTarget.scrollHeight
    }

    toggleChat() {
        this.windowTarget.classList.toggle("hidden")
    }
}
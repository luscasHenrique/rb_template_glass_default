import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 3000 } }

  connect() {
    setTimeout(() => {
      this.remove()
    }, this.timeoutValue)
  }

  remove() {
    this.element.style.opacity = '0'
    setTimeout(() => this.element.remove(), 300) // Aguarda a transição do CSS
  }
}
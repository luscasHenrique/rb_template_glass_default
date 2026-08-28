import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "buttonText", "dropdown"]

  toggle(event) {
    event.preventDefault()
    this.dropdownTarget.classList.toggle("hidden")
  }

  select(event) {
    const value = event.currentTarget.dataset.value
    const text = event.currentTarget.dataset.text

    this.inputTarget.value = value
    this.buttonTextTarget.textContent = text
    this.dropdownTarget.classList.add("hidden")
  }

  // Fecha o select se clicar fora dele
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.add("hidden")
    }
  }
}
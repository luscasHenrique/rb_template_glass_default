import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "buttonText", "dropdown", "option", "chevron"]

  toggle(event) {
    event.preventDefault()
    this.dropdownTarget.classList.toggle("hidden")
    if (this.hasChevronTarget) {
      this.chevronTarget.classList.toggle("rotate-180")
    }
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
  
  close() {
    this.dropdownTarget.classList.add("hidden")
    if (this.hasChevronTarget) {
      this.chevronTarget.classList.remove("rotate-180")
    }
  }

  select(event) {
    const currentOption = event.currentTarget
    const value = currentOption.dataset.value
    const text = currentOption.dataset.text

    // 1. Atualiza o banco (hidden input) e a UI (botão)
    this.inputTarget.value = value
    this.buttonTextTarget.textContent = text

    // 2. Remove o "check" de todas as opções
    this.optionTargets.forEach(opt => opt.dataset.selected = "false")

    // 3. Adiciona o "check" apenas na opção clicada
    currentOption.dataset.selected = "true"

    // 4. Fecha o menu
    this.close()
  }
}
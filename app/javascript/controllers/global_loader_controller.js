import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Faz o bind (vínculo) dos métodos para podermos removê-los no disconnect
    this.showBound = this.show.bind(this)
    this.hideBound = this.hide.bind(this)

    // Escuta os eventos globais do Rails Turbo (Navegação e Formulários)
    document.addEventListener("turbo:click", this.showBound)
    document.addEventListener("turbo:submit-start", this.showBound)
    
    // Oculta quando a requisição termina ou a página carrega
    document.addEventListener("turbo:load", this.hideBound)
    document.addEventListener("turbo:submit-end", this.hideBound)
  }

  disconnect() {
    // Boa prática: limpa os listeners se o componente for destruído (Evita memory leaks)
    document.removeEventListener("turbo:click", this.showBound)
    document.removeEventListener("turbo:submit-start", this.showBound)
    document.removeEventListener("turbo:load", this.hideBound)
    document.removeEventListener("turbo:submit-end", this.hideBound)
  }

  show() {
    this.element.classList.remove("hidden")
  }

  hide() {
    this.element.classList.add("hidden")
  }
}
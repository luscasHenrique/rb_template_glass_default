import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 1. Abre o modal na API nativa do HTML5
    this.element.showModal()
    
    // 2. Remove a invisibilidade para fazer o fade-in suave
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0")
    })
  }

  close(event) {
    if (event) {
      event.preventDefault()
    }
    
    // 1. Adiciona a invisibilidade para fazer o fade-out
    this.element.classList.add("opacity-0")
    
    // 2. Aguarda a animação do CSS (200ms) para remover do DOM
    setTimeout(() => {
      this.element.close()
      
      const frame = this.element.closest("turbo-frame")
      if (frame) {
        frame.src = ""
        frame.innerHTML = "" // Limpa o rastro para evitar conflitos de cache
      }
    }, 200) 
  }
}
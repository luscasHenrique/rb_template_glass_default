import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Se o cookie já existir, oculta o banner imediatamente
    if (document.cookie.includes("cookie_consent=true")) {
      this.element.remove()
    }
  }

  accept() {
    // Salva o aceite por 1 ano (31536000 segundos)
    document.cookie = "cookie_consent=true; path=/; max-age=31536000"
    
    // Efeito de transição suave antes de remover do DOM
    this.element.style.opacity = "0"
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
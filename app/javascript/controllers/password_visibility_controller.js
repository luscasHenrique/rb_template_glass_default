import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Define os alvos (targets) que mapeamos no HTML e no Ruby
  static targets = ["input", "iconOpen", "iconClosed"]

  toggle() {
    // Alterna o tipo de input e a visibilidade dos ícones
    if (this.inputTarget.type === "password") {
      this.inputTarget.type = "text"
      this.iconClosedTarget.classList.add("hidden")
      this.iconOpenTarget.classList.remove("hidden")
    } else {
      this.inputTarget.type = "password"
      this.iconClosedTarget.classList.remove("hidden")
      this.iconOpenTarget.classList.add("hidden")
    }
  }
}
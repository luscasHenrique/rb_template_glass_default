import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Define os alvos que o JS vai procurar no HTML
  static targets = ["masterCheckbox", "rowCheckbox"]

  connect() {
    // Pode ser usado no futuro para inicializar estado
  }

  // Ação disparada ao clicar no checkbox do cabeçalho
  toggleAll(event) {
    const isChecked = event.target.checked
    
    this.rowCheckboxTargets.forEach((checkbox) => {
      checkbox.checked = isChecked
    })
  }

  // Opcional: Se desmarcarmos uma linha, desmarca o cabeçalho master automaticamente
  checkRow() {
    const allChecked = this.rowCheckboxTargets.every(c => c.checked)
    if (this.hasMasterCheckboxTarget) {
      this.masterCheckboxTarget.checked = allChecked
    }
  }
}
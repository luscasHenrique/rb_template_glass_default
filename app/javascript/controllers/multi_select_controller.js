// app/javascript/controllers/multi_select_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hiddenSelect", "tagContainer", "placeholder", "dropdown", "chevron", "searchInput", "option", "tagTemplate"]

  connect() {
    this.syncUI()
  }

  toggle(event) {
    // Evita fechar/abrir se o usuário clicou em uma tag ou botão interno da caixa de disparo
    if (event.target.closest('button')) return
    if (this.dropdownTarget.contains(event.target)) return
    
    this.dropdownTarget.classList.toggle("hidden")
    this.dropdownTarget.classList.toggle("flex")
    this.chevronTarget.classList.toggle("rotate-180")
    
    if (!this.dropdownTarget.classList.contains("hidden")) {
      this.searchInputTarget.focus()
    }
  }

  close() {
    this.dropdownTarget.classList.add("hidden")
    this.dropdownTarget.classList.remove("flex")
    this.chevronTarget.classList.remove("rotate-180")
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  filter() {
    const term = this.searchInputTarget.value.toLowerCase()
    this.optionTargets.forEach(option => {
      const text = option.dataset.text.toLowerCase()
      option.style.display = text.includes(term) ? "flex" : "none"
    })
  }

  select(event) {
    const optionEl = event.currentTarget
    const value = optionEl.dataset.value
    
    // Busca a <option> real dentro do select invisível do Rails e inverte o estado
    const nativeOptions = Array.from(this.hiddenSelectTarget.options)
    const nativeOption = nativeOptions.find(opt => opt.value === value)
    
    if (nativeOption) {
      nativeOption.selected = !nativeOption.selected
      this.syncUI()
    }
  }

  remove(event) {
    event.stopPropagation()
    const tag = event.target.closest('span')
    const value = tag.dataset.value
    
    const nativeOption = Array.from(this.hiddenSelectTarget.options).find(opt => opt.value === value)
    if (nativeOption) {
      nativeOption.selected = false
      this.syncUI()
    }
  }

  clear(event) {
    event.stopPropagation()
    Array.from(this.hiddenSelectTarget.options).forEach(opt => opt.selected = false)
    this.searchInputTarget.value = ""
    this.filter() // Reseta a lista
    this.syncUI()
  }

  syncUI() {
    this.tagContainerTarget.innerHTML = ""
    let hasSelection = false

    Array.from(this.hiddenSelectTarget.options).forEach(opt => {
      const optionEl = this.optionTargets.find(el => el.dataset.value === opt.value)
      
      if (opt.selected) {
        hasSelection = true
        if (optionEl) optionEl.dataset.selected = "true"
        
        // Injeta o HTML da Tag usando o template do componente Ruby
        let tagHtml = this.tagTemplateTarget.innerHTML
        tagHtml = tagHtml.replace("VALUE_PLACEHOLDER", opt.value).replace("TEXT_PLACEHOLDER", opt.text)
        this.tagContainerTarget.insertAdjacentHTML('beforeend', tagHtml)
      } else {
        if (optionEl) optionEl.dataset.selected = "false"
      }
    })

    this.placeholderTarget.style.display = hasSelection ? "none" : "block"
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 1. Adicionado navContainer na lista de targets
  static targets = ["aside", "text", "footerText", "toggleIcon", "tooltip", "centerWrapper", "backdrop", "navContainer"]

  // ==========================================
  // LÓGICA MOBILE (Deslizamento suave)
  // ==========================================
  toggleMobile() {
    const isClosed = this.asideTarget.classList.contains("-translate-x-[120%]")

    if (isClosed) {
      // Remove a translação off-screen (traz para a tela suavemente)
      this.asideTarget.classList.remove("-translate-x-[120%]")
      
      // Anima o fundo escuro (backdrop)
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.remove("opacity-0", "pointer-events-none")
        this.backdropTarget.classList.add("opacity-100", "pointer-events-auto")
      }
    } else {
      this.closeMobile()
    }
  }

  closeMobile() {
    // Garante que só afeta o mobile
    if (window.innerWidth < 768) {
      // Devolve a barra para fora da tela suavemente
      this.asideTarget.classList.add("-translate-x-[120%]")
      
      // Oculta o fundo escuro
      if (this.hasBackdropTarget) {
        this.backdropTarget.classList.remove("opacity-100", "pointer-events-auto")
        this.backdropTarget.classList.add("opacity-0", "pointer-events-none")
      }
    }
  }

  // ==========================================
  // LÓGICA DESKTOP (Recolher/Expandir)
  // ==========================================
  toggle() {
    const isCollapsed = this.asideTarget.classList.contains("w-20")
    if (isCollapsed) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  toggleSubmenu(event) {
    if (this.asideTarget.classList.contains("w-20")) {
      this.expand()
    }

    const button = event.currentTarget
    const submenu = button.nextElementSibling
    const chevron = button.querySelector('.submenu-chevron')

    submenu.classList.toggle("hidden")
    if (chevron) chevron.classList.toggle("rotate-180")
  }

  expand() {
    this.asideTarget.classList.remove("w-20")
    this.asideTarget.classList.add("w-64")
    
    if (this.hasToggleIconTarget) this.toggleIconTarget.classList.remove("rotate-180")

    this.textTargets.forEach(el => el.classList.remove("hidden"))
    this.footerTextTargets.forEach(el => el.classList.remove("hidden"))
    this.tooltipTargets.forEach(el => el.classList.add("hidden"))
    
    this.centerWrapperTargets.forEach(el => el.classList.remove("justify-center"))

    // ARQUITETURA LIMPA: Devolve a rolagem vertical quando o menu expande
    if (this.hasNavContainerTarget) {
      this.navContainerTarget.classList.add("overflow-y-auto")
    }
  }

  collapse() {
    this.asideTarget.classList.remove("w-64")
    this.asideTarget.classList.add("w-20")
    
    if (this.hasToggleIconTarget) this.toggleIconTarget.classList.add("rotate-180")

    this.textTargets.forEach(el => el.classList.add("hidden"))
    this.footerTextTargets.forEach(el => el.classList.add("hidden"))
    this.tooltipTargets.forEach(el => el.classList.remove("hidden"))

    this.centerWrapperTargets.forEach(el => el.classList.add("justify-center"))

    // ARQUITETURA LIMPA: Remove a rolagem para libertar os tooltips e matar o scroll horizontal
    if (this.hasNavContainerTarget) {
      this.navContainerTarget.classList.remove("overflow-y-auto")
    }

    const openSubmenus = this.asideTarget.querySelectorAll('.submenu-list:not(.hidden)')
    openSubmenus.forEach(submenu => {
      submenu.classList.add("hidden")
      const button = submenu.previousElementSibling
      if (button) {
        const chevron = button.querySelector('.submenu-chevron')
        if (chevron) chevron.classList.remove("rotate-180")
      }
    })
  }
}
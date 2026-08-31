import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

// =========================================================================
// HOTWIRE / TURBO FIXES: Sincronização do Global Loading Component
// =========================================================================

// Força o fim dos estados de carregamento global quando um Turbo Frame finaliza
document.addEventListener("turbo:frame-load", () => {
  document.dispatchEvent(new Event("turbo:load"));
});

// Força o fim do carregamento em caso de falhas na requisição (ex: 404, 500)
document.addEventListener("turbo:frame-missing", () => {
  document.dispatchEvent(new Event("turbo:load"));
});
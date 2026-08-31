class CookieConsentsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def create
    active_policy = CookiePolicy.current
    return head :ok unless active_policy

    # 1. Trilha de Auditoria
    CookieConsent.create!(
      user: current_user,
      session_hash: session.id.to_s,
      ip_address: request.remote_ip,
      analytics_accepted: params[:type] == 'all',
      marketing_accepted: params[:type] == 'all',
      necessary_accepted: true
    )

    # 2. O PULO DO GATO: O cookie passa a assinar a versão ativa (ex: "v1")
    cookies.permanent[:cookie_consent] = active_policy.version

    respond_to do |format|
      format.turbo_stream
    end
  end
end
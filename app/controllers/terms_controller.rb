class TermsController < ApplicationController
  # Ignora a trava global de Pundit e de Termos, senão geraria um loop infinito
  skip_before_action :check_term_acceptance
  skip_after_action :verify_authorized

  def pending
    @term = PolicyTerm.find_by(active: true)
    
    # Se não existir termo no sistema ou o usuário já aceitou, manda pra Home
    if @term.nil? || current_user.accepted_current_term?
      redirect_to root_path
    end
  end

  def accept
    @term = PolicyTerm.find_by(active: true)
    
    if @term
      # Assinatura Digital: Grava o ID, Data/Hora exata e o IP da máquina
      UserAgreement.create!(
        user: current_user, 
        policy_term: @term, 
        ip_address: request.remote_ip, 
        accepted_at: Time.current
      )
      flash[:success] = "Termos de Uso e Políticas aceitos com sucesso. Bem-vindo!"
      redirect_to root_path
    else
      flash[:danger] = "Erro interno: Nenhum termo ativo encontrado."
      redirect_to root_path
    end
  end

  def decline
    # Ação drástica e segura: O usuário não concorda, deslogamos ele do sistema.
    sign_out current_user
    flash[:warning] = "Você precisa aceitar as Políticas da Empresa para acessar a plataforma."
    redirect_to new_user_session_path
  end
end
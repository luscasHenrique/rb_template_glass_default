module Admin
  class PolicyTermsController < ApplicationController
    before_action :set_policy_term, only: [:show, :activate, :edit, :update, :destroy, :confirm_destroy]

    def index
      authorize [:admin, PolicyTerm]
      @policy_terms = PolicyTerm.order(created_at: :desc)
    end

    def show
      authorize [:admin, @policy_term]
      @agreements = @policy_term.user_agreements.includes(:user).order(accepted_at: :desc)
      @agreements = @agreements.joins(:user).where('users.email ILIKE ?', "%#{params[:search]}%") if params[:search].present?
    end

    def new
      @policy_term = PolicyTerm.new
      authorize [:admin, @policy_term]
    end

    def create
      @policy_term = PolicyTerm.new(policy_term_params)
      authorize [:admin, @policy_term]
      @policy_term.active = false 

      if @policy_term.save
        flash[:success] = "Termo cadastrado com sucesso. Revise e ative quando estiver pronto."
        redirect_to admin_policy_terms_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, @policy_term]
      redirect_to admin_policy_terms_path, warning: "Termos ativos não podem ser editados." if @policy_term.active?
    end

    def update
      authorize [:admin, @policy_term]
      return redirect_to admin_policy_terms_path, warning: "Termos ativos não podem ser editados." if @policy_term.active?

      if @policy_term.update(policy_term_params)
        flash[:success] = "Rascunho do termo atualizado com sucesso."
        redirect_to admin_policy_terms_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize [:admin, @policy_term]
      if @policy_term.active?
        flash[:danger] = "Não é possível excluir um termo em vigor."
      else
        @policy_term.destroy
        flash[:success] = "Rascunho excluído com sucesso."
      end
      redirect_to admin_policy_terms_path
    end

    def activate
      authorize [:admin, @policy_term]
      if @policy_term.update(active: true)
        flash[:success] = "Termo versão #{@policy_term.document_version} ATIVADO! O bloqueio global está valendo."
      end
      redirect_to admin_policy_terms_path
    end

    def confirm_destroy
      authorize [:admin, @policy_term]
      
      # Trava de segurança UX: Se for ativo, nem abre o modal, recarrega a página com erro
      if @policy_term.active?
        redirect_to admin_policy_terms_path, warning: "Termos em vigor não podem ser excluídos." 
      end
    end

    private

    def set_policy_term
      @policy_term = PolicyTerm.find(params[:id])
    end

    def policy_term_params
      params.require(:policy_term).permit(:document_version, :content)
    end
  end
end
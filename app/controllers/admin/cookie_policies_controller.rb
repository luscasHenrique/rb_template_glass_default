module Admin
  class CookiePoliciesController < ApplicationController
    before_action :set_cookie_policy, only: [:activate, :edit, :update, :destroy, :confirm_destroy]

    def index
      authorize [:admin, CookiePolicy]
      @cookie_policies = CookiePolicy.order(created_at: :desc)
    end

    def new
      @cookie_policy = CookiePolicy.new
      authorize [:admin, @cookie_policy]
    end

    def create
      @cookie_policy = CookiePolicy.new(cookie_policy_params)
      authorize [:admin, @cookie_policy]
      
      if @cookie_policy.save
        flash[:success] = "Política de Cookies cadastrada com sucesso. Revise e ative quando estiver pronto."
        redirect_to admin_cookie_policies_path
      else
        # ARQUITETURA LIMPA: Mapeamento do Unhappy Path para o Toast Global
        flash.now[:danger] = "Não foi possível salvar: #{@cookie_policy.errors.full_messages.to_sentence}."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, @cookie_policy]
      redirect_to admin_cookie_policies_path, warning: "Políticas ativas não podem ser editadas." if @cookie_policy.active?
    end

    def update
      authorize [:admin, @cookie_policy]
      return redirect_to admin_cookie_policies_path, warning: "Políticas ativas não podem ser editadas." if @cookie_policy.active?

      if @cookie_policy.update(cookie_policy_params)
        flash[:success] = "Rascunho da Política atualizado com sucesso."
        redirect_to admin_cookie_policies_path
      else
        # ARQUITETURA LIMPA: Feedback visual de erro na edição
        flash.now[:danger] = "Não foi possível atualizar: #{@cookie_policy.errors.full_messages.to_sentence}."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize [:admin, @cookie_policy]
      if @cookie_policy.active?
        flash[:danger] = "Não é possível excluir uma política em vigor."
      else
        @cookie_policy.destroy
        flash[:success] = "Rascunho excluído com sucesso."
      end
      redirect_to admin_cookie_policies_path
    end

    def activate
      authorize [:admin, @cookie_policy]
      if @cookie_policy.update(active: true)
        flash[:success] = "Política de Cookies (Versão #{@cookie_policy.version}) ATIVADA! O banner será atualizado para os usuários."
      end
      redirect_to admin_cookie_policies_path
    end

    def confirm_destroy
      authorize [:admin, @cookie_policy]
      if @cookie_policy.active?
        redirect_to admin_cookie_policies_path, warning: "Políticas em vigor não podem ser excluídas." 
      end
    end

    private

    def set_cookie_policy
      @cookie_policy = CookiePolicy.find(params[:id])
    end

    def cookie_policy_params
      params.require(:cookie_policy).permit(:version, :content)
    end
  end
end
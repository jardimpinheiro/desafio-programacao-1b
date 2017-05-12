class VendasController < ApplicationController

  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  def index
    @vendas = Venda.all
  end

  def nova_importacao
  end

  def importar

    importacao = ImportacaoVendasService.new(params[:txt])

    if importacao.importar_vendas
      redirect_to root_url, notice: t('importacao_com_sucesso', 
                                      numero_vendas: importacao.numero_vendas, 
                                      receita: formatar_valor(importacao.receita_bruta))
    else
      @venda = importacao.venda
      renderiza_erros(importacao.mensagem_de_erro)
    end

  end

  private

    def renderiza_erros(mensagem)
      flash.now[:notice] = mensagem
      render :nova_importacao, status: :bad_request
    end
end

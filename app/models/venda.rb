class Venda < ActiveRecord::Base

  validates_length_of :comprador, :descricao, :endereco, :fornecedor, :minimum => 1, :maximum => 255

  validates :preco_unitario, :quantidade, presence: true, numericality: { greater_than: 0 }

end

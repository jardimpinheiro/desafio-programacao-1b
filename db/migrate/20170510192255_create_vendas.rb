class CreateVendas < ActiveRecord::Migration
  def change
    create_table :vendas do |t|
      t.string :comprador, null: false, limit: 255
      t.text :descricao, null: false, limit: 255
      t.decimal :preco_unitario, precision: 8, scale: 2, null: false
      t.integer :quantidade, null: false
      t.string :endereco, null: false, limit: 255
      t.string :fornecedor, null: false, limit: 255

      t.timestamps null: false
    end
  end
end

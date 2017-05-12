Rails.application.routes.draw do
  
  root 'vendas#index'
  get  'importar' => 'vendas#nova_importacao'
  post 'importar' => 'vendas#importar'

end

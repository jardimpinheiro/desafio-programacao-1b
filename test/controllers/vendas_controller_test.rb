require 'test_helper'

class VendasControllerTest < ActionController::TestCase

  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  test "GET /" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vendas)
  end

  test "GET /importar" do
    get :nova_importacao
    assert_response :success
  end

  test "POST /importar -> deve importar 4 registros de vendas" do

    assert_difference('Venda.count', 4) do
      post :importar, txt: fixture_file_upload('files/dados.txt', 'text/txt')
    end
    
    assert_redirected_to root_url

    expected_numero_vendas = 4
    expected_receita_bruta = 95.0
    
    assert_equal  I18n.t('importacao_com_sucesso', 
                    numero_vendas: expected_numero_vendas, 
                    receita: formatar_valor(expected_receita_bruta)), 
                  flash[:notice]
  end

  test "POST /importar -> deve importar 5232 registros de vendas" do

    assert_difference('Venda.count', 5232) do
      post :importar, txt: fixture_file_upload('files/dados-5232-registros.txt', 'text/txt')
    end
    
    assert_redirected_to root_url

    expected_numero_vendas = 5232
    expected_receita_bruta = 124260.0
    
    assert_equal  I18n.t('importacao_com_sucesso', 
                    numero_vendas: expected_numero_vendas, 
                    receita: formatar_valor(expected_receita_bruta)), 
                  flash[:notice]

  end

  test "POST /importar -> deve requerer arquivo não nulo" do

    assert_no_difference 'Venda.count', I18n.t('arquivo_invalido') do
      post :importar, txt: nil
    end

  end

  test "POST /importar -> deve requerer um arquivo txt" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/rails.png', 'image/png')
      assert_response :bad_request
      assert_equal flash[:notice], I18n.t('arquivo_invalido')
    end

  end

  test "POST /importar -> deve requerer o cabeçalho e pelo menos uma linha com dados no arquivo" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-somente-cabecalho.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('arquivo_invalido'), flash[:notice]
    end

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-vazio.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('arquivo_invalido'), flash[:notice]
    end

  end  

  test "POST /importar -> deve haver dados completos nas seis colunas" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha5.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 5), flash[:notice]
    end

  end

  test "POST /importar -> deve requerer comprador e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha2-comprador-invalido.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 2), flash[:notice]
      assert_message assigns(:venda), :comprador, I18n.t("errors.messages.too_short.one")
    end

  end

  test "POST /importar -> deve restringir tamanho máximo de comprador e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha2-comprador-texto-grande.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 2), flash[:notice]
      assert_message assigns(:venda), :comprador, I18n.t("errors.messages.too_long.other", count: 255)
    end

  end

  test "POST /importar -> deve requerer descrição e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha3-descricao-invalida.txt', 'text/txt')
      assert_message assigns(:venda), :descricao, I18n.t("errors.messages.too_short.one")
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 3), flash[:notice]
    end

  end

  test "POST /importar -> deve restringir tamanho máximo de descricao e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha2-descricao-texto-grande.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 2), flash[:notice]
      assert_message assigns(:venda), :descricao, I18n.t("errors.messages.too_long.other", count: 255)
    end

  end

  test "POST /importar -> deve requerer endereço e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha4-endereco-invalido.txt', 'text/txt')
      assert_message assigns(:venda), :endereco, I18n.t("errors.messages.too_short.one")
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 4), flash[:notice]
    end

  end

  test "POST /importar -> deve restringir tamanho máximo de endereco e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha2-endereco-texto-grande.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 2), flash[:notice]
      assert_message assigns(:venda), :endereco, I18n.t("errors.messages.too_long.other", count: 255)
    end

  end

  test "POST /importar -> deve requerer fornecedor e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha5-fornecedor-invalido.txt', 'text/txt')
      assert_message assigns(:venda), :fornecedor, I18n.t("errors.messages.too_short.one")
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 5), flash[:notice]
    end

  end

  test "POST /importar -> deve restringir tamanho máximo de fornecedor e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha2-fornecedor-texto-grande.txt', 'text/txt')
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 2), flash[:notice]
      assert_message assigns(:venda), :fornecedor, I18n.t("errors.messages.too_long.other", count: 255)
    end

  end

  test "POST /importar -> deve requerer preço unitário e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha2-preco-invalido.txt', 'text/txt')
      assert_message assigns(:venda), :preco_unitario, I18n.t("errors.messages.blank")
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 2), flash[:notice]
    end

  end

  test "POST /importar -> deve requerer preço unitário maior que zero e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha3-preco-menor-igual-zero.txt', 'text/txt')
      assert_message assigns(:venda), :preco_unitario, I18n.t("errors.messages.greater_than", count: 0)
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 3), flash[:notice]
    end

  end

  test "POST /importar -> deve requerer quantidade e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha3-quantidade-invalida.txt', 'text/txt')
      assert_message assigns(:venda), :quantidade, I18n.t("errors.messages.blank")
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 3), flash[:notice]
    end

  end

  test "POST /importar -> deve requerer quantidade maior que zero e informar a linha" do

    assert_no_difference 'Venda.count' do
      post :importar, txt: fixture_file_upload('files/dados-invalidos-linha4-quantidade-menor-igual-zero.txt', 'text/txt')
      assert_message assigns(:venda), :quantidade, I18n.t("errors.messages.greater_than", count: 0)
      assert_response :bad_request
      assert_equal I18n.t('linha_invalida', numero: 4), flash[:notice]      
    end

  end

end
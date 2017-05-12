require 'test_helper'

class VendaTest < ActiveSupport::TestCase
  
  BIG_TEXT = "text" * 70

  def setup
      @v = Venda.new  comprador: "Snake Plissken", descricao: "R$20 Sneakers for R$5", 
              preco_unitario: 5.0, quantidade: 4, endereco: "123 Fake St  Sneaker",
              fornecedor: "Store Emporium"
  end
      
  test "deve salvar venda" do
    assert @v.save, "venda não pôde ser salva"
  end

  test "deve requerer comprador e validar tamanho máximo" do
    assert_field_validate_message @v, :comprador, nil, I18n.t("errors.messages.too_short.one")
    assert_field_validate_message @v, :comprador, "", I18n.t("errors.messages.too_short.one")  
  end

  test "deve restringir tamanho máximo de comprador" do
    assert_field_validate_message @v, :comprador, BIG_TEXT, I18n.t("errors.messages.too_long.other", count: 255)
  end

  test "deve requerer descrição" do
    assert_field_validate_message @v, :descricao, nil, I18n.t("errors.messages.too_short.one")
    assert_field_validate_message @v, :descricao, "", I18n.t("errors.messages.too_short.one")
  end

  test "deve restringir tamanho máximo de descrição" do
    assert_field_validate_message @v, :descricao, BIG_TEXT, I18n.t("errors.messages.too_long.other", count: 255)
  end

  test "deve requerer preço unitário" do
    assert_field_validate_message @v, :preco_unitario, nil, I18n.t("errors.messages.blank")
  end

  test "deve requerer preço unitário maior que zero" do
    assert_field_validate_message @v, :preco_unitario, -1.20, I18n.t("errors.messages.greater_than", count: 0)
  end

  test "deve requerer numeral em preço unitário" do
    assert_field_validate_message @v, :preco_unitario, "string", I18n.t("errors.messages.not_a_number")
  end

  test "deve requerer quantidade" do
    assert_field_validate_message @v, :quantidade, nil, I18n.t("errors.messages.blank")
  end

  test "deve requerer quantidade maior que zero" do
    assert_field_validate_message @v, :quantidade, -5, I18n.t("errors.messages.greater_than", count: 0)
  end

  test "deve requerer numeral em quantidade" do
    assert_field_validate_message @v, :quantidade, "string", I18n.t("errors.messages.not_a_number")
  end

  test "deve requerer endereço" do
    assert_field_validate_message @v, :endereco, nil, I18n.t("errors.messages.too_short.one")
    assert_field_validate_message @v, :endereco, "", I18n.t("errors.messages.too_short.one")
  end

  test "deve restringir tamanho máximo de endereço" do
    assert_field_validate_message @v, :endereco, BIG_TEXT, I18n.t("errors.messages.too_long.other", count: 255)
  end

  test "deve requerer fornecedor" do
    assert_field_validate_message @v, :fornecedor, nil, I18n.t("errors.messages.too_short.one")
    assert_field_validate_message @v, :fornecedor, "", I18n.t("errors.messages.too_short.one")
  end

  test "deve restringir tamanho máximo de fornecedor" do
    assert_field_validate_message @v, :fornecedor, BIG_TEXT, I18n.t("errors.messages.too_long.other", count: 255)
  end
end

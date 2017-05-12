ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Verifica validação de campo e mensagem de erro ao salvar registro
  # Params: registro (model), o campo (atributo), o valor do atributo a ser testado e a mensagem de erro
  # que deverá ser lançada
  def assert_field_validate_message(record, field, value, message)
      assert_field_value record, field, value
      assert_key_error record, field
      assert_message record, field, message
  end

  def assert_message(record, field, message)
      has_message = false
      record.errors[field].each do |msg|
          if msg == message
              has_message = true
              break
          end
      end
      assert has_message, "não possui a mensagem de erro pela chave informada"
  end

  # Verifica validação do campo
  def assert_field_value(record, field, value)
      record[field] = value
      assert_not record.save, "salvou quando não deveria"
  end

  # Verifica se contém erro para a chave
  def assert_key_error(record, key)
      has_key_error = record.errors.has_key? key
      assert has_key_error, "não possui a chave do atributo na lista de erros"
  end
    
end

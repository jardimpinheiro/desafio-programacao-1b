module ApplicationHelper
  def formatar_valor(number)
    number_to_currency number,
      unit: "R$",
      separator: ",",
      delimiter: "."
  end
end

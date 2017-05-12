class ImportacaoVendasService

  attr_reader :mensagem_de_erro, :venda, :numero_vendas, :receita_bruta

  def initialize(arquivo)
    @arquivo = arquivo
    @mensagem_de_erro = nil
    @venda = nil
    @numero_vendas = nil
    @receita_bruta = 0
  end

  def importar_vendas

    begin
      
      # arquivo não pode ser nulo
      if @arquivo.nil?
        @mensagem_de_erro = I18n.t('arquivo_invalido')
        return false
      end

      @arquivo = @arquivo.tempfile

      # valida extensão do arquivo
      if not File.extname(@arquivo.path).start_with? ".txt"
        @mensagem_de_erro = I18n.t('arquivo_invalido')
        return false
      end

      linhas = File.readlines(@arquivo)

      # deve haver o cabeçalho e pelo menos uma linha com dados
      if linhas.length < 2
        @mensagem_de_erro = I18n.t('arquivo_invalido')
        return false
      end 

      # remove o cabeçalho
      linhas.shift.chomp

      vendas = []

      linhas.each_with_index do |linha, indice|

        flash_message = I18n.t('linha_invalida', numero: indice + 2)

        # separa os dados
        dados = linha.split("\t", 6)

        # dados devem estar completos
        if dados.length != 6
          @mensagem_de_erro = flash_message
          return false
        end

        v = Venda.new

        [ :comprador, 
          :descricao, 
          :preco_unitario, 
          :quantidade, 
          :endereco, 
          :fornecedor
        ].each_with_index do |attr, i|
          v[attr] = dados[i]        
        end

        # valida venda
        if not v.valid?
          @venda = v
          @mensagem_de_erro = flash_message
          return false
        end

        # adiciona no array para inserção em massa
        vendas << v

        # incrementa o totalizador de receita bruta
        @receita_bruta += v.preco_unitario * v.quantidade

      end

      # invoca a inserção em massa no banco de dados
      Venda.import vendas    

      # total de vendas importadas
      @numero_vendas = linhas.length      
      return true

    rescue => erro
      puts erro   
      @mensagem_de_erro = I18n.t('erro_generico')
      return false      
    end

  end

end
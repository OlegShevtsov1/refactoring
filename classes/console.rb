class Console
  include AccountHelper
  include CardHelper
  include MoneyHelper

  ACCOUNT_MENU = { SC: 'show_cards', CC: 'create_card', DC: 'destroy_card',
                   PM: 'put_money', WM: 'withdraw_money', SM: 'send_money',
                   DA: 'destroy_account', exit: 'exit' }.freeze

  def initialize
    @account = Account.new
    @card = Card.new
  end

  def run
    main_menu
  end

  def main_menu
    message('console.main_menu')
    case gets.chomp
    when 'create'
      account_create
    when 'load'
      account_load
    else
      exit
    end
  end

  def account_menu
    loop do
      message('console.account_menu', name: @current_account.name)
      begin
        method = ACCOUNT_MENU.fetch(gets.chomp.to_sym)
        send(method)
      rescue KeyError
        message('console.errors.wrong_command')
      end
    end
  end

  private

  def message(type, params = {})
    puts I18n.t(type, **params)
  end
end

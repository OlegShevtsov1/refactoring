class Console
  include ConsoleHelper

  AUTHORIZATION_COMMANDS = {
    create: 'create',
    load: 'load'
  }.freeze

  MENU_COMMANDS = {
    'SC' => :show_cards,
    'CC' => :create_card,
    'DC' => :destroy_card,
    'PM' => :put_money,
    'WM' => :withdraw_money,
    'SM' => :send_money,
    'DA' => :destroy_account,
    'exit' => :exit
  }.freeze

  def console
    @account_manager = AccountManager.new
    put_message(:authorization_message)
    case input
    when AUTHORIZATION_COMMANDS[:create] then create
    when AUTHORIZATION_COMMANDS[:load] then load
    else exit
    end
  end

  def create
    @current_account = @account_manager.create_account
    main_menu
  end

  def load
    return create_the_first_account if Account.accounts.empty?

    @current_account = @account_manager.load_account
    main_menu
  end

  def create_the_first_account
    put_message(:first_account_message)
    input == YES_COMMAND ? create : console
  end

  def main_menu
    @card_manager = CardManager.new(@current_account)
    @transaction_manager = TransactionManager.new(@current_account)
    loop do
      put_message(:main_menu_message, name: @current_account.name)
      command = MENU_COMMANDS[input]
      command.nil? ? put_message(:invalid_command_message) : send(command)
      break if command == :exit
    end
  end

  def show_cards
    return put_message(:no_active_cards_message) if @current_account.cards.empty?

    @current_account.cards.each { |card| put_message(:card, number: card.number, type: card.type) }
  end

  def create_card
    @card_manager.create_card
  end

  def destroy_card
    @card_manager.destroy_card
  end

  def withdraw_money
    @transaction_manager.withdraw_money
  end

  def put_money
    @transaction_manager.put_money
  end

  def send_money
    @transaction_manager.send_money
  end

  def destroy_account
    @account_manager.destroy_account(@current_account)
    exit
  end

  def accounts
    Account.accounts
  end
end

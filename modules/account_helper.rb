module AccountHelper
  def create
    loop do
      @current_account = Account.new(name: name_input, age: age_input, login: login_input, password: password_input)
      @current_account.validate
      break if @current_account.errors.empty?

      @current_account.errors.each { |error| puts error }
    end
    @current_account.create
    console
  end

  def load
    return create_the_first_account if @account.accounts.none?

    loop do
      @current_account = Account.new(login: login_input, password: password_input).load
      @current_account ? break : message('account.errors.user_not_exists')
    end
    main_menu
  end

  def destroy_account
    message('account.destroy_account')
    @current_account.destroy if gets.chomp == 'y'
  end

  private

  def name_input
    message('account.registration.name')
    gets.chomp
  end

  def age_input
    message('account.registration.age')
    gets.chomp
  end

  def login_input
    message('account.registration.login')
    gets.chomp
  end

  def password_input
    message('account.registration.password')
    gets.chomp
  end

  def create_the_first_account
    message('account.first')
    case gets.chomp
    when 'y'
      create
    end
  end
end

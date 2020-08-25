class AccountValidator
  LOGIN = (4..20).freeze
  AGE_RANGE = (23..90).freeze
  PASSWORD = (6..30).freeze

  attr_reader :errors

  def initialize(account)
    @account = account
    @errors = []
  end

  def valid?
    validate_name
    validate_age
    validate_login
    validate_login_exists
    validate_password
    @errors.empty?
  end

  private

  def validate_name
    return if @account.name.empty? || @account.name[0].upcase == @account.name[0]

    @errors << { error: :invalid_name_message, params: {} }
  end

  def validate_age
    return if @account.age.between?(AGE_RANGE.first, AGE_RANGE.last)

    hash = { error: :invalid_age_message,
             params: { first_age: AGE_RANGE.first, last_age: AGE_RANGE.last } }
    @errors << hash
  end

  def validate_login
    @errors << { error: :empty_login_message, params: {} } if @account.login.empty?
    @errors << { error: :short_login_message, params: { login: LOGIN.first } } if @account.login.length < LOGIN.first
    @errors << { error: :long_login_message, params: { login: LOGIN.last } } if @account.login.length > LOGIN.last
  end

  def validate_login_exists
    return unless account_exist?(@account.login)

    @errors << { error: :account_already_exist_message, params: {} }
  end

  def validate_password
    @errors << { error: :empty_password_message, params: {} } if @account.password.empty?
    @errors << { error: :short_password_message, params: { password: PASSWORD.first } } if @account.password.length < 6
    @errors << { error: :long_password_message, params: { password: PASSWORD.last } } if @account.password.length > 30
  end

  def account_exist?(login)
    Account.accounts.map(&:login).include?(login)
  end
end

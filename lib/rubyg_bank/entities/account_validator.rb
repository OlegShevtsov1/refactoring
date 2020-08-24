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
    @errors << :invalid_name_message if @account.name.empty? || @account.name[0].upcase != @account.name[0]
  end

  def validate_age
    @errors << :invalid_age_message unless @account.age.between?(AGE_RANGE.first, AGE_RANGE.last)
  end

  def validate_login
    @errors << :empty_login_message if @account.login.empty?
    @errors << :short_login_message if @account.login.length < LOGIN.first
    @errors << :long_login_message if @account.login.length > LOGIN.last
  end

  def validate_login_exists
    @errors << :account_already_exist_message if account_exist?(@account.login)
  end

  def validate_password
    @errors << :empty_password_message if @account.password.empty?
    @errors << :short_password_message if @account.password.length < PASSWORD.first
    @errors << :long_password_message if @account.password.length > PASSWORD.last
  end

  def account_exist?(login)
    Account.accounts.map(&:login).include?(login)
  end
end

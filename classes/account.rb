class Account
  include Uploader

  LOGIN_LENGTH_RANGE = (4..20).freeze
  AGE_RANGE = (23..90).freeze
  PASSWORD_LENGTH_RANGE = (6..30).freeze

  attr_reader :name, :age, :login, :password, :cards, :errors

  def initialize(name: nil, age: nil, login: nil, password: nil, cards: [])
    @name = name
    @age = age
    @login = login
    @password = password
    @cards = cards
    @errors = []
  end

  def create
    save(accounts << self)
  end

  def load
    find_account
  end

  def destroy
    accounts_list = accounts
    accounts_list.delete_if { |obj| obj.login == login }
    save(accounts_list)
  end

  def validate
    validate_name
    validate_age
    validate_login
    validate_login_exist
    validate_password
  end

  def accounts
    loads.nil? ? [] : loads
  end

  def save_card(card)
    @cards << card
    save_changes
  end

  def destroy_card(answer)
    cards.delete_at(answer&.to_i.to_i - 1)
    save_changes
  end

  def save_changes
    destroy
    create
  end

  private

  def validate_name
    @errors << I18n.t('account.errors.name.present') if @name == '' || @name[0] != @name[0].upcase
  end

  def validate_age
    @errors << I18n.t('account.errors.age.present') unless AGE_RANGE.include? @age.to_i
  end

  def validate_login
    @errors << I18n.t('account.errors.login.present') if @login == ''
    @errors << I18n.t('account.errors.login.longer') if @login.length < LOGIN_LENGTH_RANGE.first
    @errors << I18n.t('account.errors.login.shorter') if @login.length > LOGIN_LENGTH_RANGE.last
  end

  def validate_login_exist
    return if loads.nil?

    @errors << I18n.t('account.errors.login.exists') if loads.map(&:login).include? @login
  end

  def validate_password
    @errors << I18n.t('account.errors.password.present') if @password == ''
    @errors << I18n.t('account.errors.password.longer') if @password.length < PASSWORD_LENGTH_RANGE.first
    @errors << I18n.t('account.errors.password.shorter') if @password.length > PASSWORD_LENGTH_RANGE.last
  end

  def find_account
    loads.find { |account| account.login == @login && account.password == @password }
  end
end

require 'yaml'
require 'pry'
require 'i18n'
require 'rugged'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']

require_relative 'modules/account_helper'
require_relative 'modules/money_helper'
require_relative 'modules/uploader'
require_relative 'classes/card'
require_relative 'modules/card_helper'
require_relative 'classes/usual_card'
require_relative 'classes/capitalist_card'
require_relative 'classes/virtual_card'
require_relative 'classes/account'
require_relative 'classes/console'

RSpec.describe Console do
  before do
    stub_const('HELLO_PHRASES', [
                 'Hello, we are RubyG bank!',
                 '- If you want to create account - press `create`',
                 '- If you want to load account - press `load`',
                 '- If you want to exit - press `exit`'
               ])

    stub_const('MAIN_OPERATIONS_TEXTS',
               ['If you want to:',
                '- show all cards - press SC',
                '- create card - press CC',
                '- destroy card - press DC',
                '- put money on card - press PM',
                '- withdraw money on card - press WM',
                '- send money to another card  - press SM',
                '- destroy account - press `DA`',
                '- exit from account - press `exit`'])
  end

  let(:current_subject) { described_class.new }
  let(:current_account) { Account.new }

  describe '#console' do
    context 'when correct method calling' do
      after do
        current_subject.console
      end

      before do
        allow(current_subject).to receive_message_chain(:gets, :chomp)
        allow(current_subject).to receive(:message)
      end

      it 'create account if input is create' do
        allow(current_subject).to receive_message_chain(:gets, :chomp) { 'create' }
        expect(current_subject).to receive(:create)
      end

      it 'load account if input is load' do
        allow(current_subject).to receive_message_chain(:gets, :chomp) { 'load' }
        expect(current_subject).to receive(:load)
      end

      it 'leave app if input is exit or some another word' do
        allow(current_subject).to receive_message_chain(:gets, :chomp) { 'another' }
        expect(current_subject).to receive(:exit)
      end
    end

    context 'with correct output' do
      it do
        allow(current_subject).to receive_message_chain(:gets, :chomp) { 'test' }
        allow(current_subject).to receive(:exit)
        expect(current_subject).to receive(:puts).with(HELLO_PHRASES)
        current_subject.console
      end
    end
  end

  describe '#main_menu' do
    let(:name) { 'John' }
    let(:commands) do
      {
        'SC' => :show_cards,
        'CC' => :create_card,
        'DC' => :destroy_card,
        'PM' => :put_money,
        'WM' => :withdraw_money,
        'SM' => :send_money,
        'DA' => :destroy_account,
        'exit' => :exit
      }
    end

    context 'with correct outout' do
      it do
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
        allow(current_subject).to receive(:show_cards)
        current_subject.instance_variable_set(:@current_account, instance_double('Account', name: name))
        expect { current_subject.send(:main_menu) }.to output(/Welcome, #{name}/).to_stdout
        MAIN_OPERATIONS_TEXTS.each do |text|
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return('SC', 'exit')
          expect { current_subject.send(:main_menu) }.to output(/#{text}/).to_stdout
        end
      end
    end

    context 'when commands used' do
      let(:undefined_command) { 'undefined' }

      it 'calls specific methods on predefined commands' do
        current_subject.instance_variable_set(:@current_account, instance_double('Account', name: name))
        allow(current_subject).to receive(:puts)
        allow(current_subject).to receive(:exit)

        commands.each do |command, method_name|
          expect(current_subject).to receive(method_name)
          allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(command, 'exit')
          current_subject.send(:main_menu)
        end
      end

      it 'outputs incorrect message on undefined command' do
        current_subject.instance_variable_set(:@current_account, instance_double('Account', name: name))
        expect(current_subject).to receive(:exit)
        allow(current_subject).to receive(undefined_command)
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(undefined_command, 'exit')
        expect { current_subject.send(:main_menu) }.to output(/#{ERROR_PHRASES[:wrong_command]}/).to_stdout
      end
    end
  end

  describe '#create' do
    let(:success_name_input) { 'Denis' }
    let(:success_age_input) { '72' }
    let(:success_login_input) { 'Denis' }
    let(:success_password_input) { 'Denis1993' }
    let(:success_inputs) { [success_name_input, success_age_input, success_login_input, success_password_input] }

    context 'with success result' do
      before do
        allow(current_subject).to receive(:puts)
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*success_inputs)
        allow(current_subject).to receive(:main_menu)
        allow(current_account).to receive(:accounts).and_return([])
        stub_const('Storage::FILE_PATH', OVERRIDABLE_FILENAME)
      end

      after do
        File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
      end

      it 'with correct outout' do
        allow(File).to receive(:open)
        ASK_PHRASES.values.each { |phrase| expect(current_subject).to receive(:puts).with(phrase) }
        ACCOUNT_VALIDATION_PHRASES.values.map(&:values).each do |phrase|
          expect(current_subject).not_to receive(:puts).with(phrase)
        end
        expect(current_subject).to receive(:loop).and_yield
        current_subject.send(:create)
      end
    end

    context 'with errors' do
      before do
        all_inputs = current_inputs + success_inputs
        allow(File).to receive(:open)
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*all_inputs)
        allow(current_subject).to receive(:main_menu)
        allow(current_account).to receive(:accounts).and_return([])
        stub_const('Storage::FILE_PATH', OVERRIDABLE_FILENAME)
      end

      context 'with name errors' do
        context 'without small letter' do
          let(:error_input) { 'some_test_name' }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:name][:first_letter] }
          let(:current_inputs) { [error_input, success_age_input, success_login_input, success_password_input] }

          it 'without small letter' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end
      end

      context 'with login errors' do
        let(:current_inputs) { [success_name_input, success_age_input, error_input, success_password_input] }

        context 'when present' do
          let(:error_input) { '' }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:login][:present] }

          it 'when present' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end

        context 'when longer' do
          let(:error_input) { 'E' * 3 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:login][:longer] }

          it 'when longer' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end

        context 'when shorter' do
          let(:error_input) { 'E' * 21 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:login][:shorter] }

          it 'when shorter' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end

        context 'when exists' do
          let(:error_input) { 'Denis1345' }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:login][:exists] }
          let(:console) do
            instance_double('Console', name: error_input, age: 72, login: error_input, password: 'Denis1993')
          end

          before do
            allow(current_account).to receive(:accounts_list).and_return([console])
            stub_const('Storage::FILE_PATH', OVERRIDABLE_FILENAME)
          end

          after do
            File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
          end

          it 'when exists' do
            current_account.create(console)
            current_account.create(console)
            expect(current_account.instance_variable_get(:@errors).first).to eq(nil)
          end
        end
      end

      context 'with age errors' do
        let(:current_inputs) { [success_name_input, error_input, success_login_input, success_password_input] }
        let(:error) { ACCOUNT_VALIDATION_PHRASES[:age][:length] }

        context 'with length minimum' do
          let(:error_input) { '22' }

          it 'with length minimum' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end

        context 'with length maximum' do
          let(:error_input) { '91' }

          it 'with length maximum' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end
      end

      context 'with password errors' do
        let(:current_inputs) { [success_name_input, success_age_input, success_login_input, error_input] }

        context 'when absent' do
          let(:error_input) { '' }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:password][:present] }

          it 'when absent' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end

        context 'when longer' do
          let(:error_input) { 'E' * 5 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:password][:longer] }

          it 'when longer' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end

        context 'when shorter' do
          let(:error_input) { 'E' * 31 }
          let(:error) { ACCOUNT_VALIDATION_PHRASES[:password][:shorter] }

          it 'when shorter' do
            expect(current_subject).to receive(:loop).and_yield
            expect { current_subject.send(:create) }.to output(/#{error}/).to_stdout
          end
        end
      end
    end
  end

  describe '#load' do
    context 'without active accounts' do
      it do
        expect(current_subject).to receive(:accounts).and_return([])
        expect(current_subject).to receive(:create_the_first_account).and_return([])
        current_subject.send(:load)
      end
    end

    context 'with active accounts' do
      let(:login) { 'Johnny' }
      let(:password) { 'johnny1' }
      let(:console) { instance_double('Console', name: 'Johnny', age: 43, login: login, password: password) }

      before do
        allow(current_subject).to receive_message_chain(:gets, :chomp).and_return(*all_inputs)
        stub_const('Storage::FILE_PATH', OVERRIDABLE_FILENAME)
        current_account.create(console)
        current_subject.instance_variable_set(:@current_account, current_account)
      end

      after do
        File.delete(OVERRIDABLE_FILENAME) if File.exist?(OVERRIDABLE_FILENAME)
      end

      context 'with correct outout' do
        let(:all_inputs) { [login, password] }

        it do
          [ASK_PHRASES[:login], ASK_PHRASES[:password]].each do |phrase|
            expect(current_subject).to receive(:puts).with(phrase)
          end
          current_subject.send(:login_input)
        end
      end

      context 'when account exists' do
        let(:all_inputs) { [login, password] }

        it do
          expect(current_subject).to receive(:main_menu)
          expect(current_subject).to receive(:loop).and_yield
          expect { current_subject.send(:load) }.not_to output(/#{ERROR_PHRASES[:user_not_exists]}/).to_stdout
        end
      end

      context 'when account doesn\t exists' do
        let(:all_inputs) { ['test', 'test', login, password] }

        it do
          expect(current_subject).to receive(:main_menu)
          expect(current_subject).to receive(:loop).and_yield
          expect { current_subject.send(:load) }.to output(/#{ERROR_PHRASES[:user_not_exists]}/).to_stdout
        end
      end
    end
  end
end

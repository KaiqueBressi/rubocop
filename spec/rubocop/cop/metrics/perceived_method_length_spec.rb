# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Metrics::PerceivedMethodLength, :config do
  subject(:cop) { described_class.new(config) }

  let(:cop_config) { { 'Max' => 1 } }

  context 'when method is an instance method' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        def m
            ^ Method has too many statements. [2/1]
           if a
              [
                 1,
                 2,
                 3,
                 4
              ]
           end
        end
      RUBY
    end
  end
end

# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Rails::FallbackWithPresence do
  subject(:cop) { described_class.new }

  before do
    inspect_source(cop, source)
  end

  context 'with `obj.present? ? obj : something`' do
    let(:source) { <<-END }
      obj.present? ? obj : something
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message)
        .to eq('Use `presence` as `obj.presence || something`.')
      expect(cop.highlights).to eq(['obj.present? ? obj : something'])
    end
  end

  context 'with `obj.present? ? something : obj`' do
    let(:source) { <<-END }
      obj.present? ? something : obj
    END

    it 'does nothing' do
      expect(cop.offenses).to be_empty
    end
  end

  context 'with `foo.bar.present? ? foo.bar : something`' do
    let(:source) { <<-END }
      foo.bar.present? ? foo.bar : something
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message)
        .to eq('Use `presence` as `foo.bar.presence || something`.')
      expect(cop.highlights).to eq(['foo.bar.present? ? foo.bar : something'])
    end
  end

  context 'with `present? ? self : something`' do
    let(:source) { <<-END }
      present? ? self : something
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message)
        .to eq('Use `presence` as `presence || something`.')
      expect(cop.highlights).to eq(['present? ? self : something'])
    end
  end

  context 'with `... elsif obj.present?; obj; else; something; end`' do
    let(:source) { <<-END }
      foo = if some_condition
              something
            elsif obj.present?
              obj
            else
              anything
            end
    END

    it 'accepts since it reads better' do
      expect(cop.offenses).to be_empty
    end
  end
end

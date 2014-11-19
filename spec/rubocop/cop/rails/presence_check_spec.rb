# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Rails::PresenceCheck do
  subject(:cop) { described_class.new }

  before do
    inspect_source(cop, source)
  end

  context 'with `obj.nil? || obj.empty?`' do
    let(:source) { <<-END }
      obj.nil? || obj.empty?
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message)
        .to eq('Use `obj.blank?`.')
      expect(cop.highlights).to eq(['obj.nil? || obj.empty?'])
    end
  end

  context 'with `!obj || obj.empty?`' do
    let(:source) { <<-END }
      !obj || obj.empty?
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message)
        .to eq('Use `obj.blank?`.')
      expect(cop.highlights).to eq(['!obj || obj.empty?'])
    end
  end

  context 'with `!obj.nil? && !obj.empty?`' do
    let(:source) { <<-END }
      !obj.nil? && !obj.empty?
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message)
        .to eq('Use `obj.present?`.')
      expect(cop.highlights).to eq(['!obj.nil? && !obj.empty?'])
    end
  end

  context 'with `obj && !obj.empty?`' do
    let(:source) { <<-END }
      obj && !obj.empty?
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message)
        .to eq('Use `obj.present?`.')
      expect(cop.highlights).to eq(['obj && !obj.empty?'])
    end
  end

  context 'with `!obj.blank?`' do
    let(:source) { <<-END }
      !obj.blank?
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message).to eq('Use `obj.present?`.')
      expect(cop.highlights).to eq(['!obj.blank?'])
    end
  end

  context 'with `!obj.present?`' do
    let(:source) { <<-END }
      !obj.present?
    END

    it 'registers an offense' do
      expect(cop.offenses.size).to eq(1)
      expect(cop.offenses.first.message).to eq('Use `obj.blank?`.')
      expect(cop.highlights).to eq(['!obj.present?'])
    end
  end
end

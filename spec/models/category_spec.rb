require 'rails_helper'

RSpec.describe Category, type: :model do


  context 'when category code is less that six letters' do
    let!(:category) { build(:category, code: '12345') }

    it 'is valid' do
      expect(category).to be_valid
    end
  end

  context 'when category code is more that six letters' do
    let!(:category) { build(:category, code: '1234567') }

    it 'is not valid' do
      expect(category).not_to be_valid
    end
  end
end
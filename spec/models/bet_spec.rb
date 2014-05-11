require 'spec_helper'

describe Bet do

  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:match_bets) }
    it { should have_many(:question_bets) }
  end

  context 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:points) }
    it { should validate_numericality_of(:points).only_integer.is_greater_than_or_equal_to(0) }
  end

end

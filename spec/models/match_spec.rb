require 'spec_helper'

describe Match do

  context 'associations' do
    it { should belong_to(:team_a).class_name('Team') }
    it { should belong_to(:team_b).class_name('Team') }
    it { should have_many(:match_bets) }
  end

  context 'validations' do
    it { should validate_presence_of(:number) }
    it { should validate_uniqueness_of(:number) }

    it { should validate_presence_of(:round) }
    it { should ensure_inclusion_of(:round).in_array(Match::ROUNDS) }

    it { should ensure_inclusion_of(:group).in_array(Match::GROUPS) }

    it { should validate_presence_of(:played_at) }

    it { should validate_presence_of(:played_on) }
    it { should ensure_inclusion_of(:played_on).in_array(Match::VENUES.keys) }

    it { should validate_numericality_of(:goals_a).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:goals_b).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:penalty_goals_a).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:penalty_goals_b).only_integer.is_greater_than_or_equal_to(0) }

    it 'ensures both teams are not the same', locale: :pt do
      team = create(:team)

      match = Match.new(team_a_id: team.id, team_b_id: team.id)
      expect(match).to_not be_valid
      expect(match.errors.get(:team_b_id)).to eq(['não pode ser o mesmo que o outro'])

      match = build(:match, team_a: team, team_b: team)
      expect(match).to_not be_valid
      expect(match.errors.get(:team_b_id)).to eq(['não pode ser o mesmo que o outro'])
    end

    it 'ensures both teams are from the same group as the match', locale: :pt do
      team1 = create(:team, group: 'A')
      team2 = create(:other_team, group: 'B')

      match = Match.new(group: 'A', team_a_id: team1.id, team_b_id: team2.id)
      expect(match).to_not be_valid
      expect(match.errors.get(:group)).to eq(['não é o mesmo dos times'])

      match = build(:match, group: 'C', team_a: team1, team_b: team2)
      expect(match).to_not be_valid
      expect(match.errors.get(:group)).to eq(['não é o mesmo dos times'])

      match = build(:match, group: nil, team_a: team1, team_b: team2)
      expect(match).to be_valid
    end
  end

end

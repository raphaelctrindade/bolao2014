require 'spec_helper'

describe Question do

  context 'associations' do
    it { should have_many(:question_bets) }
  end

  context 'validations' do
    it { should validate_presence_of(:body_en) }
    it { should validate_uniqueness_of(:body_en).case_insensitive }

    it { should validate_presence_of(:body_pt) }
    it { should validate_uniqueness_of(:body_pt).case_insensitive }

    it { should validate_presence_of(:played_at) }

    it { should validate_presence_of(:answer_type,) }
    it { should ensure_inclusion_of(:answer_type).in_array(Question::ANSWER_TYPES) }

    it 'validates that the answer must be a valid Team id when the answer_type is `team`', locale: :pt do
      team = create(:team)
      question = build(:team_question, answer: '42')

      expect(question).to_not be_valid
      expect(question.errors.get(:answer)).to eql(['não é válido'])

      question.answer = team.id.to_s
      expect(question).to be_valid
    end
    it 'validates that the answer must be a valid Player id when the answer_type is `player`' do
      player = create(:field_player)
      question = build(:player_question, answer: '42')

      expect(question).to_not be_valid
      expect(question.errors.get(:answer)).to eql(['não é válido'])

      question.answer = player.id.to_s
      expect(question).to be_valid
    end
    it 'validates that the answer must be a true or false when the answer_type is `boolean`', locale: :en do
      question = build(:boolean_question, answer: 'opa')

      expect(question).to_not be_valid
      expect(question.errors.get(:answer)).to eql(['is invalid'])

      question.answer = 'true'
      expect(question).to be_valid
    end
  end

  describe '#body' do
    subject { build(:team_question, body_en: 'Foo', body_pt: 'Fú') }
    it 'returns the :pt body', locale: :pt do
      expect(subject.body).to eql('Fú')
    end
    it 'returns the :en body', locale: :en do
      expect(subject.body).to eql('Foo')
    end
  end

  describe '#answer_object' do
    let(:team) { create(:team) }
    let(:player) { create(:field_player) }
    it 'returns nil without an answer set' do
      expect(subject.answer_object).to be_nil
    end
    context 'with team type question' do
      subject { build(:team_question, answer: team.id.to_s) }
      it 'returns the Team object' do
        expect(subject.answer_object).to eql(team)
      end
    end
    context 'with player type question' do
      subject { build(:player_question, answer: player.id.to_s) }
      it 'returns the Team object' do
        expect(subject.answer_object).to eql(player)
      end
    end
    context 'with boolean type question' do
      subject { build(:boolean_question, answer: 'false') }
      it 'returns the Team object' do
        expect(subject.answer_object).to be_false
      end
    end
  end

end
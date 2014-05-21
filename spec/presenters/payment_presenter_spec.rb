require 'spec_helper'

describe PaymentPresenter do
  let(:bet) { create(:bet) }
  let(:payment) do
    build(:paid_payment,
      bet: bet,
      id: 49,
      created_at: '2014-06-12 17:00:00 -0300'.to_time,
      updated_at: '2014-06-13 17:00:00 -0300'.to_time
    )
  end
  subject { described_class.new(payment) }

  its(:to_key) { should eql([49]) }
  its(:to_param) { should eql('49') }
  its(:created_at) { should eql('2014-06-12 17:00:00 -0300'.to_time) }
  its(:updated_at) { should eql('2014-06-13 17:00:00 -0300'.to_time) }

  it 'wraps associated bet in a presenter' do
    expect(subject.bet).to be_an_instance_of(BetPresenter)
    expect(subject.bet.send(:subject)).to eq(bet)
  end

end

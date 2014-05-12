require 'spec_helper'

describe BetsController do

  # GET /bet
  describe '#show' do
    context 'when not logged in' do
      it 'redirects to login' do
        get :show
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to_not be_blank
      end
    end
    context 'when logged in' do
      let(:user) { build(:user, bet: build(:bet)) }
      before(:each) { login_user(user) }
      it 'returns http success' do
        get :show
        expect(response).to be_success
      end
      it 'renders the correct template' do
        get :show
        expect(response).to render_template('show')
      end
      it "assigns the logged user's bet" do
        get :show
        expect(assigns(:bet)).to eql(user.bet)
      end
      it 'assigns all bettable matches, in order, wrapped in presenter' do
        matches = [mock_model(Match)]
        matches_presenters = [double(MatchPresenter)]
        Match.should_receive(:all_bettables_in_order).and_return(matches)
        MatchPresenter.should_receive(:map).with(matches).and_return(matches_presenters)
        get :show
        expect(assigns(:_matches)).to eql(matches)
        expect(assigns(:matches)).to eql(matches_presenters)
      end
      it 'assigns all bettable questions, in order' do
        questions = [mock_model(Question)]
        Question.should_receive(:all_bettables_in_order).and_return(questions)
        get :show
        expect(assigns(:questions)).to eql(questions)
      end
    end
  end

end

class MatchBetPresenter < Presenter

  expose :to_key, :to_param,
    :goals_a,
    :goals_b,
    :penalty_winner,
    :penalty_winner_id,
    :points,
    :created_at,
    :updated_at,
    :scored_at,
    :match_id,
    :bet_id

  # TODO spec
  def css_id
    "match_bets_#{@subject.id}"
  end

  # TODO spec
  def form_id
    return if @subject.match.blank?
    if @subject.match.drawable?
      'match_bet_form'
    else
      'no_draw_match_bet_form'
    end
  end

  def one_line_summary
    summary = "#{@subject.match.team_a.name} #{@subject.goals_a} x #{@subject.goals_b} #{@subject.match.team_b.name}"
    if @subject.penalty_winner_id.present?
      summary << ", #{t('match_bet_presenter.with_winner_by_penaltys', team_name: @subject.penalty_winner.name)}"
    end
    summary
  end

  # TODO spec
  def goals_a_if_locked
    goals_if_locked(:a)
  end

  # TODO spec
  def goals_b_if_locked
    goals_if_locked(:b)
  end

  # TODO spec
  def penalty_winner_if_locked
    if @subject.match.locked? && @subject.penalty_winner.present?
      html = '<br />'
      html << h.content_tag(:span, t('match_bet_presenter.with_winner_by_penaltys', team_name: @subject.penalty_winner.name), class: 'team-name penalty-winner')
      html.html_safe
    end
  end

  def goals_a_or_blank
    goals_or_blank(:a)
  end

  def goals_b_or_blank
    goals_or_blank(:b)
  end

  def bet
    @bet_presenter ||= BetPresenter.new(@subject.bet) if @subject.bet
  end

  def match
    @match_presenter ||= MatchPresenter.new(@subject.match) if @subject.match
  end

  # TODO spec
  def teams_options_for_select
    team_a = @subject.match.team_a
    team_b = @subject.match.team_b
    h.options_for_select(
      {team_a.name => team_a.id, team_b.name => team_b.id},
      @subject.penalty_winner_id
    )
  end

  # TODO spec
  def penalty_winner_select_visible?
    @subject.goals_a.present? &&
      @subject.goals_b.present? &&
      @subject.goals_a == @subject.goals_b
  end

  # TODO spec
  def points_with_explanation
    if @subject.scored?
      # TODO explain the points on the tooltip
      tooltip_span(@subject.points.to_s, points_explanation, 'points known')
    else
      tooltip_span('?', t('match_bet_presenter.will_show_when_match_scored'), 'points unknown')
    end.html_safe
  end

  private

  def tooltip_span(text, title, extra_css_class=nil)
    h.content_tag(:span, text, 'data-tooltip' => true, 'class' => "has-tip #{extra_css_class}", 'title' => title)
  end

  def points_explanation
    # TODO explain the points on the tooltip
    I18n.t('common.soon')
  end

  def goals_or_blank(letter)
    goals = @subject.send("goals_#{letter}")
    goals.blank? ? 'N/A' : goals.to_s
  end

  def goals_if_locked(letter)
    if @subject.match.locked?
      goals_or_blank(letter)
    else
      h.content_tag(:span, '?', 'data-tooltip' => true, 'class' => 'has-tip', 'title' => t('match_bet_presenter.will_show_when_match_locked'))
    end
  end

end

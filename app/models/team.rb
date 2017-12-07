# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :event

  validates :name, presence: true

  def match_count
    Match.where(team: self).where.not(team_points: nil).count + Match.where(opponent: self).where.not(opponent_points: nil).count
  end

  def rank
    event.teams.where('points > ?', points).count + 1
  end

  def aggregate_points
    p1 = Match.where(team: self).sum(:team_points)
    p2 = Match.where(opponent: self).sum(:opponent_points)
    update!(points: p1 + p2)
  end

  def result(qualifier)
    case qualifier.matches.where(team: self).first.points
    when 0 then 'Lose'
    when 1 then 'Draw'
    when 3 then 'Win'
    else ''
    end
  end
end

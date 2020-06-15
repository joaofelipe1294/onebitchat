class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user
  validates_presence_of :team, :user
  validates_uniqueness_of :user_id, :scope => :team_id
  before_validation :set_confirmation_status
  after_create :send_confirmation_mail
  enum confirmation_status: {
    open: 0,
    confirmed: 1
  }

  private

    def set_confirmation_status
      self.confirmation_status = :open unless self.confirmation_status
    end

    def send_confirmation_mail
      TeamUserMailer.invite(self).deliver_now!
    end

end

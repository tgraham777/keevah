class LoanRequestsContributor < ActiveRecord::Base
  belongs_to :loan_request
  belongs_to :user

  def self.lender_contribution(user_id, loan_request)
    Rails.cache.fetch("lender-contribution") do
      where(user_id: user_id, loan_request_id: loan_request.id)
    end
  end

  def self.newest_contribution
    first.updated_at.strftime("%B %d, %Y")
  end
end

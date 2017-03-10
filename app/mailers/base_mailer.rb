class BaseMailer < ActionMailer::Base

  after_action :update_delivery_method

  private

  def update_delivery_method
    return unless Rails.env.development? && mail.to[0] == 'andy@r210.com'
    self.delivery_method = :mailgun_dm
  end
end

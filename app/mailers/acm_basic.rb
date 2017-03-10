class AcmBasic < BaseMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.basic.signup.subject
  #
  def signup
    @greeting = 'Hi'
    mail to: 'andy@r210.com', from: 'test@r210.com'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.basic.invoice.subject
  #
  def invoice
    @greeting = 'Hi'
    mail to: 'andy@r210.com', from: 'test@r210.com'
  end
end

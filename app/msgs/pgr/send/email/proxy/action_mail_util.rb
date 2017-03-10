module ActionMailUtil
  def with_delivery_method(method)
    old_method = ActionMailer::Base.delivery_method
    ActionMailer::Base.delivery_method = method
    yield
    ActionMailer::Base.delivery_method = old_method
  end
end
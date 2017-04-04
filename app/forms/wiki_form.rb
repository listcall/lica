class WikiForm
  include ActiveModel::Model

  attr_accessor :name, :format, :comment, :content, :label

end
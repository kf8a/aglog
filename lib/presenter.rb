class Presenter
  extend Forwardable

  def initialize(params)
    params.each_pair { |attribute, value| self.send :"#{attribute}=", value } unless params.nil?
  end
end

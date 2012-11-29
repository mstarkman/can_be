module CanBe
  class Railtie < Rails::Railtie
    initializer 'can_be.model_additions' do
      ActiveSupport.on_load :active_record do
        include CanBe::ModelExtensions
      end
    end
  end
end

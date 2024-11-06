# frozen_string_literal: true

# Esta clase gestiona el perfil de un usuario.
# Puede almacenar configuraciones, estadísticas u otros datos relevantes
# sobre el progreso y las preferencias del usuario.
class Profile < ActiveRecord::Base
  belongs_to :user
end

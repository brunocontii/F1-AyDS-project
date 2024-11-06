# frozen_string_literal: true

# Esta clase representa los modos de juego disponibles.
# Almacena información sobre los distintos tipos de juego,
# como modos progressive o por free, que afectan la dinámica del juego.
class Gamemode < ActiveRecord::Base
  has_and_belongs_to_many :user
  has_and_belongs_to_many :answer
end

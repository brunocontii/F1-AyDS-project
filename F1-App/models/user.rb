# frozen_string_literal: true

require 'bcrypt'

# Esta clase representa un usuario en la aplicación.
# Almacena y gestiona información relacionada con el usuario,
# como su nombre, correo electrónico y estadísticas de juego.
class User < ActiveRecord::Base
  has_one :profile
  has_and_belongs_to_many :gamemode
  has_many :answer

  REGENERATION_INTERVAL = 60.seconds
  def regenerate_life_if_needed
    return unless last_life_lost_at

    lives_to_regenerate = calculate_lives_to_regenerate

    if cant_life < 3 && lives_to_regenerate.positive?
      new_life_count = [cant_life + lives_to_regenerate, 3].min
      update(cant_life: new_life_count)

      update_lives(new_life_count)
    end

    return unless cant_life == 3

    update(last_life_lost_at: nil)
  end

  def calculate_lives_to_regenerate
    ((Time.now - last_life_lost_at) / REGENERATION_INTERVAL).floor
  end

  def update_lives(new_life_count)
    if new_life_count < 3
      update(last_life_lost_at: Time.now - (Time.now - last_life_lost_at) % REGENERATION_INTERVAL)
    else
      update(last_life_lost_at: nil)
    end
  end

  def can_play?
    regenerate_life_if_needed
    cant_life.positive?
  end

  def password=(new_password)
    self.password_digest = BCrypt::Password.create(new_password)
  end

  def authenticate(password)
    BCrypt::Password.new(password_digest) == password
  end
end

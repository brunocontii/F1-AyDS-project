require 'bcrypt'

class User < ActiveRecord::Base
    has_one :profile
    has_and_belongs_to_many :gamemode
    has_many :answer

    REGENERATION_INTERVAL = 60.seconds
    def regenerate_life_if_needed
        return unless last_life_lost_at

        # Calcular el numero de vidas que pueden regenerarse
        lives_to_regenerate = ((Time.now - last_life_lost_at) / REGENERATION_INTERVAL).floor

        if cant_life < 3 && lives_to_regenerate > 0
            # Regenerar vidas sin exceder el maximo de 3
            new_life_count = [cant_life + lives_to_regenerate, 3].min
            update(cant_life: new_life_count)

            # Actualizar el tiempo de la ultima perdida de vida si todavia hay vidas por regenerar
            if new_life_count < 3
                update(last_life_lost_at: Time.now - (Time.now - last_life_lost_at) % REGENERATION_INTERVAL)
            else
                update(last_life_lost_at: nil)
            end
        end

        if cant_life == 3
            update(last_life_lost_at: nil)
        end

    end

    def can_play?
        regenerate_life_if_needed
        cant_life > 0
    end

    def password=(new_password)
        self.password_digest = BCrypt::Password.create(new_password)
    end

    def authenticate(password)
        BCrypt::Password.new(self.password_digest) == password
    end

end

class Free < Gamemode
    validates :name_level, inclusion: { in: %w(easy normal difficult impossible)}
end
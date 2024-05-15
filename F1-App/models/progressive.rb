class Progressive < Gamemode
    validates :name_theme, inclusion: { in: %w(circuit team career pilot)}
end
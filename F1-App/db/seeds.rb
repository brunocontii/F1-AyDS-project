users = [
    { username: 'Jon Doe', password: 'jondoe', cant_life: 3, cant_coins: 0},
    { username: 'Bruno', password: 'messi', cant_life: 2, cant_coins: 999},
    { username: 'Juan', password: 'mbappe', cant_life: 3, cant_coins: 500},
]

users.each do |u|
    User.create(u)
end

profiles = [
    {name: 'juan', lastName: 'cru', description: 'f1 lover', age: 22},
    {name: 'bruno', lastName: 'cti', description: '@brunnoconti attractive boy', age: 21},
]

profiles.each do |u|
    Profile.create(u)
end

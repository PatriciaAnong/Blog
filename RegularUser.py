_author_ = 'panong'

use Gryffindor

db.createUser({
    user: "Harry",
    pwd: "Hogwarts4ever",
    roles: ["readWrite"]
})

import pymongo

_author_ = 'panong'

uri = "mongodb://Harry:Hogwarts4ever@192.142.32.100/gryffindor"
client = pymongo.MongoClient(uri)
database = client['gryffindor']
collection = database['SortingHat']


def record():
        wizards = collection.find({})
        for person in wizards:
            print ("Are you afraid of what you'll hear?\nYour Animagus is a {}, {}".format(person['Animagus'],person['Member']))

record()


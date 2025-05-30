from motor.motor_asyncio import AsyncIOMotorClient

MONGO_DETAILS = "mongodb://localhost:27017"

client = AsyncIOMotorClient(MONGO_DETAILS)
database = client.recipe_app

user_collection = database.get_collection("users")
recipe_collection = database.get_collection("recipes")

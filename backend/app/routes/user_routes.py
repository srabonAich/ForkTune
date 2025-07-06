from fastapi import APIRouter
from app.database import user_collection

router = APIRouter()

@router.get("/users")
async def get_users():
    users = []
    async for user in user_collection.find():
        user["_id"] = str(user["_id"])
        users.append(user)
    return users

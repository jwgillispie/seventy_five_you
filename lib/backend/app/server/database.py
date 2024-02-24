from beanie import init_beanie
import motor.motor_asyncio

from server.models.user_model import User
from server.models.challenge_model import Challenge
from server.models.day_model import Day

async def init_db():
    client = motor.motor_asyncio.AsyncIOMotorClient("mongodb+srv://jozman:k7HdZpXuTUonbQoC@systemstest.tchgppx.mongodb.net/seventy_five_hard?retryWrites=true&w=majority")
    await init_beanie(database=client.seventy_five_hard, document_models=[User, Day, Challenge])

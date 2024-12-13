from beanie import init_beanie
import motor.motor_asyncio

from server.models.user_model import User
from server.models.challenge_model import Challenge
from server.models.day_model import Day
from server.models.diet_model import Diet
from server.models.water_model import Water
from server.models.alcohol_model import Alcohol
from server.models.ten_pages_model import TenPages
from server.models.inside_workout_model import InsideWorkout
from server.models.outside_workout_model import OutsideWorkout
from server.models.reminder_model import Reminder

async def init_db():
    client = motor.motor_asyncio.AsyncIOMotorClient("mongodb+srv://issey:Dghjuyt22@systemstest.tchgppx.mongodb.net/?retryWrites=true&w=majority&appName=systemsTest")
    await init_beanie(database=client.seventy_five_hard, document_models=[User, Reminder, Day, Challenge, Diet, InsideWorkout, OutsideWorkout, Water, Alcohol, TenPages])

# mongodb+srv://issey:Dghjuyt22@systemstest.tchgppx.mongodb.net/?retryWrites=true&w=majority&appName=systemsTest
# mongodb+srv://jozman:k7HdZpXuTUonbQoC@systemstest.tchgppx.mongodb.net/seventy_five_hard?retryWrites=true&w=majority


# mongodb+srv://giordano:5PoszeBn2ihyIhir@systemstest.tchgppx.mongodb.net/?retryWrites=true&w=majority&appName=systemsTes

# mongodb+srv://issey:Dghjuyt22@systemstest.tchgppx.mongodb.net/?retryWrites=true&w=majority&appName=systemsTest
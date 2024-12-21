from beanie import Document
from pydantic import EmailStr
from typing import List, Optional
from beanie import PydanticObjectId

# possible new structure in DB Google doc
class OutsideWorkout(Document):
    class Settings:
        collection = "OutsideWorkout"
    day_id: PydanticObjectId # Reference to the Day collection
    description : str  # Description of the workout
    thoughts: str  # Thoughts on the workout
    completed: bool
   


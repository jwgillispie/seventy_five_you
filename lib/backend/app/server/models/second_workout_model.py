from beanie import Document
from typing import List, Optional
from beanie import PydanticObjectId

class SecondWorkout(Document):
    class Settings:
        collection = "SecondWorkout"
    day_id: PydanticObjectId # Reference to the Day collection
    description : str  # Description of the workout
    thoughts: str  # Thoughts on the workout
    completed: bool
    




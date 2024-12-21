from beanie import Document
from typing import List, Optional
from beanie import PydanticObjectId
from pydantic import BaseModel, Field

# class OtherMeasures(BaseModel):
#     mental_clarity_level: Optional[int] = None  # Percentage (0 to 100)
#     energy_level: Optional[int] = None          # Percentage (0 to 100)
#     sleep_quality: Optional[int] = None         # Percentage (0 to 100)
#     money_saved: Optional[int or float] = None 

class Alcohol(Document):
    class Settings:
        collection = "Alcohol"
    day_id: PydanticObjectId # Reference to the Day collection
    difficulty: int
    completed: bool
    # other_measures: Optional[OtherMeasures] = None # Nested model for additional measures

    

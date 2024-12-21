from beanie import Document
from typing import List, Optional
from beanie import PydanticObjectId

class Diet(Document):
    class Settings:
        collection = "Diet"
    day_id: PydanticObjectId # Reference to the Day collection
    # breakfast : Optional[List[str]] = None # List of breakfast entries  
    breakfast : List[str] # List of breakfast entries  
    lunch : List[str]  # List of lunch entries
    dinner : List[str]  # List of dinner entries
    snacks : List[str]  # List of snack entries
    # completed: bool = False
    completed: bool



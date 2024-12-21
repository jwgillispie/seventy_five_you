from beanie import Document
from typing import List, Optional
from beanie import PydanticObjectId

class Water(Document):
    class Settings:
        collection = "Water"
    day_id: PydanticObjectId # Reference to the Day collection
    pee_count: int
    amount_finished: int
    completed: bool




# OLD VERSION (12/19)
# from beanie import Document
# from pydantic import EmailStr
# from typing import List, Optional
# from datetime import datetime
# class Water(Document):
#     class Settings:
#         name = "Water"
#     date : str  # Date of the day
#     firebase_uid : str
#     completed: bool 
#     peeCount: int
#     completed: bool
#     ouncesDrunk: int

    

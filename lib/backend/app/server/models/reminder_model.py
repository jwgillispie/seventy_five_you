from beanie import Document
from typing import List, Optional
from beanie import PydanticObjectId


class Reminder(Document):
    class Settings:
        collection = "Reminder"
    user_id : PydanticObjectId # Reference to the User collection
    user_reminder : List[str] # List of user reminders
    

    

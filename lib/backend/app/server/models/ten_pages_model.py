from beanie import Document
from typing import List, Optional
from beanie import PydanticObjectId


class TenPages(Document):
    class Settings:
        name = "TenPages"
    day_id: PydanticObjectId # Reference to the Day collection
    book_title: str
    pages_read: int
    summary: str
    completed: bool
    

# OLD VERSION (12/19)
# from beanie import Document
# from pydantic import EmailStr
# from typing import List, Optional
# from datetime import datetime

# class TenPages(Document):
#     class Settings:
#         name = "TenPages"
#     date : str  # Date of the day
#     firebase_uid : str
#     completed: bool
#     summary: str
#     bookTitle: str
#     completed: bool
#     pagesRead: int








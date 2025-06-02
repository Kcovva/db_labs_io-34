from pydantic import BaseModel
from typing import Optional, List

class ContentBase(BaseModel):
    uploader_id: int
    title: str
    category: str
    url: str

class ContentCreate(ContentBase):
    pass

class Content(ContentBase):
    id: int

    class Config:
        orm_mode = True

class LabelBase(BaseModel):
    text: str

class LabelCreate(LabelBase):
    pass

class Label(LabelBase):
    id: int

    class Config:
        orm_mode = True

class AnalyzeInput(BaseModel):
    text: str

class AnalyzeOutput(BaseModel):
    hashtags: List[str]

from fastapi import APIRouter, HTTPException
from models import (
    get_all_content, create_content, get_content_labels,
    get_content_by_id, update_content_text, delete_content,
    get_label_by_text, link_labels_to_content, create_label_if_not_exists
)
from schemas import Content, ContentCreate, Label
from analyze import analyze_text, AnalyzeInput
import re

router = APIRouter()


@router.get("/", response_model=list[Content])
def list_content():
    return get_all_content()


@router.post("/", status_code=201)
def add_content(item: ContentCreate):
    content_id = create_content(item)
    return {"id": content_id, "message": "Content created"}


@router.get("/{content_id}/", response_model=Content)
def get_content(content_id: int):
    content = get_content_by_id(content_id)
    if content is None:
        raise HTTPException(status_code=404, detail="Content not found")
    return content


@router.put("/{content_id}/")
def update_content(content_id: int, item: ContentCreate):
    if not update_content_text(content_id, item):
        raise HTTPException(status_code=404, detail="Content not found")
    return {"message": "Content updated"}


@router.delete("/{content_id}/")
def remove_content(content_id: int):
    if not delete_content(content_id):
        raise HTTPException(status_code=404, detail="Content not found")
    return {"message": "Content deleted"}


@router.get("/{content_id}/labels/", response_model=list[Label])
def content_labels(content_id: int):
    return get_content_labels(content_id)


@router.post("/{content_id}/analyze/")
async def analyze_content(content_id: int):
    content = get_content_by_id(content_id)
    if not content:
        raise HTTPException(status_code=404, detail="Content not found")
    
    hashtags = analyze_text(AnalyzeInput(text=content["title"] + " " + content["category"] + " " + content["url"]))
    
    label_ids = []
    labels = []

    for tag_text in hashtags:
        label = get_label_by_text(tag_text)
        if label:
            label_ids.append(label["id"])
            labels.append(label["text"])

    link_labels_to_content(content_id, label_ids)

    return {"message": "Labels linked", "tags": labels}

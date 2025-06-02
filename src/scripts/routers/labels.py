from fastapi import APIRouter, HTTPException
from models import (
    get_all_labels, get_label_by_id, create_label,
    update_label, delete_label
)
from schemas import Label, LabelCreate

router = APIRouter()


@router.get("/", response_model=list[Label])
def list_labels():
    return get_all_labels()


@router.get("/{label_id}/", response_model=Label)
def get_label(label_id: int):
    label = get_label_by_id(label_id)
    if label is None:
        raise HTTPException(status_code=404, detail="Label not found")
    return label


@router.post("/", status_code=201)
def add_label(label: LabelCreate):
    create_label(label)
    return {"message": "Label added"}


@router.put("/{label_id}/")
def update_label_text(label_id: int, label: LabelCreate):
    if not update_label(label_id, label):
        raise HTTPException(status_code=404, detail="Label not found")
    return {"message": "Label updated"}


@router.delete("/{label_id}/")
def remove_label(label_id: int):
    if not delete_label(label_id):
        raise HTTPException(status_code=404, detail="Label not found")
    return {"message": "Label deleted"}

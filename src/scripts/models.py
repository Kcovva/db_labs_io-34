from db import get_connection

def get_all_content():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Content")
    result = cursor.fetchall()
    conn.close()
    return result

def create_content(data):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO Content (uploader_id, title, category, url) VALUES (%s, %s, %s, %s)",
        (data.uploader_id, data.title, data.category, data.url)
    )
    content_id = cursor.lastrowid
    conn.commit()
    conn.close()
    return content_id

def get_content_by_id(content_id: int):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Content WHERE id = %s", (content_id,))
    result = cursor.fetchone()
    conn.close()
    return result

def update_content_text(content_id: int, data):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE Content SET uploader_id = %s, title = %s, category = %s, url = %s WHERE id = %s",
        (data.uploader_id, data.title, data.category, data.url, content_id)
    )
    conn.commit()
    affected = cursor.rowcount
    conn.close()
    return affected > 0

def delete_content(content_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM Content WHERE id = %s", (content_id,))
    conn.commit()
    affected = cursor.rowcount
    conn.close()
    return affected > 0

def get_content_labels(content_id: int):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT Label.* FROM Label
        JOIN ContentLabel ON Label.id = ContentLabel.Label_id
        WHERE ContentLabel.Content_id = %s
    """, (content_id,))
    result = cursor.fetchall()
    conn.close()
    return result

def get_all_labels():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Label")
    result = cursor.fetchall()
    conn.close()
    return result

def get_label_by_id(label_id: int):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Label WHERE id = %s", (label_id,))
    result = cursor.fetchone()
    conn.close()
    return result

def get_label_by_text(text: str):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Label WHERE text = %s", (text,))
    result = cursor.fetchone()
    conn.close()
    return result

def create_label(data):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Label (text) VALUES (%s)", (data.text,))
    conn.commit()
    conn.close()

def update_label(label_id: int, label_data):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE Label SET text = %s WHERE id = %s", (label_data.text, label_id))
    conn.commit()
    affected = cursor.rowcount
    conn.close()
    return affected > 0

def delete_label(label_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM ContentLabel WHERE Label_id = %s", (label_id,))
    cursor.execute("DELETE FROM Label WHERE id = %s", (label_id,))
    conn.commit()
    affected = cursor.rowcount
    conn.close()
    return affected > 0

def create_label_if_not_exists(text: str) -> int:
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM Label WHERE text = %s", (text,))
    row = cursor.fetchone()
    if row:
        return row[0]
    cursor.execute("INSERT INTO Label (text) VALUES (%s)", (text,))
    conn.commit()
    return cursor.lastrowid

def link_labels_to_content(content_id: int, label_ids: list[int]):
    conn = get_connection()
    cursor = conn.cursor()
    for label_id in label_ids:
        cursor.execute(
            "INSERT IGNORE INTO ContentLabel (Content_id, Label_id) VALUES (%s, %s)",
            (content_id, label_id)
        )
    conn.commit()
    conn.close()

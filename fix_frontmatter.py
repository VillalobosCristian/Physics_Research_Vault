#!/usr/bin/env python3
"""
Fix frontmatter in Obsidian vault files.
- Strip # from tags
- Ensure status, topic, project fields exist
- Auto-assign topic based on folder path
- Add literature-note tag for Reading-Notes files
- Auto-assign project for Projects subfolders
"""

import os
import re
from pathlib import Path

BASE_PATH = Path("/sessions/vibrant-festive-heisenberg/mnt/Physics_Research_Vault")

def extract_frontmatter(content):
    """Extract frontmatter between --- markers."""
    if not content.startswith("---"):
        return None, content

    # Find the second --- marker
    lines = content.split("\n")
    end_idx = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end_idx = i
            break

    if end_idx is None:
        return None, content

    frontmatter_text = "\n".join(lines[1:end_idx])
    body = "\n".join(lines[end_idx + 1:])
    return frontmatter_text, body

def parse_frontmatter(fm_text):
    """Parse frontmatter into a dict-like structure."""
    lines = fm_text.split("\n")
    fields = {}
    current_field = None
    current_value = []

    for line in lines:
        # Check if this is a key: value line
        if line and not line.startswith(" ") and not line.startswith("\t") and ":" in line:
            # Save previous field
            if current_field:
                fields[current_field] = "\n".join(current_value).strip()

            # Parse new field
            parts = line.split(":", 1)
            current_field = parts[0].strip()
            value = parts[1].strip() if len(parts) > 1 else ""
            current_value = [value]
        elif current_field and line:
            # Continuation of previous field (for lists)
            current_value.append(line)

    # Save last field
    if current_field:
        fields[current_field] = "\n".join(current_value).strip()

    return fields

def rebuild_frontmatter(fields):
    """Rebuild frontmatter from dict."""
    lines = []

    # Define order for common fields
    field_order = ["title", "date", "status", "tags", "topic", "project"]

    # Add fields in order
    for field in field_order:
        if field in fields:
            value = fields[field]
            if value:
                lines.append(f"{field}: {value}")
            else:
                lines.append(f"{field}:")

    # Add any remaining fields not in the order
    for field in sorted(fields.keys()):
        if field not in field_order and fields[field]:
            lines.append(f"{field}: {fields[field]}")

    return "\n".join(lines)

def extract_tags_from_text(tags_text):
    """Extract tag list from frontmatter tags field."""
    if not tags_text:
        return []

    tags = []
    for line in tags_text.split("\n"):
        line = line.strip()
        if line.startswith("- "):
            tag = line[2:].strip()
            tags.append(tag)
        elif line and not line.startswith("#"):
            # Handle inline tags
            tags.append(line)

    return tags

def format_tags(tags):
    """Format tags list for frontmatter."""
    if not tags:
        return ""

    # Remove duplicates while preserving order
    seen = set()
    unique_tags = []
    for tag in tags:
        if tag not in seen:
            unique_tags.append(tag)
            seen.add(tag)

    if not unique_tags:
        return ""

    return "\n" + "\n".join(f"- {tag}" for tag in unique_tags)

def extract_list_from_text(list_text):
    """Extract list items from frontmatter list field."""
    if not list_text:
        return []

    items = []
    for line in list_text.split("\n"):
        line = line.strip()
        if line.startswith("- "):
            item = line[2:].strip()
            items.append(item)

    return items

def format_list(items):
    """Format list for frontmatter."""
    if not items:
        return ""

    return "\n" + "\n".join(f"- {item}" for item in items)

def get_topic_from_path(file_path):
    """Determine topic from file path."""
    path_str = str(file_path)

    topics = []
    if "Membrane-Physics" in path_str:
        topics.append("membrane-physics")
    if "Differential-Geometry" in path_str:
        topics.append("differential-geometry")
    if "Statistical-Mechanics" in path_str:
        topics.append("statistical-mechanics")
    if "Experimental-Methods" in path_str:
        topics.append("experimental-methods")

    return topics

def get_project_from_path(file_path):
    """Determine project from file path."""
    path_str = str(file_path)

    # Check if file is in Projects directory
    if "/Projects/" in path_str:
        # Extract project folder name (first subdirectory under Projects)
        parts = path_str.split("/Projects/")
        if len(parts) > 1:
            subpath = parts[1]
            project_folder = subpath.split("/")[0]
            return [project_folder]

    return []

def fix_file(file_path):
    """Fix frontmatter in a single file. Returns True if modified."""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return False

    # Check if file has frontmatter
    if not content.startswith("---"):
        return False

    fm_text, body = extract_frontmatter(content)
    if fm_text is None:
        return False

    # Parse frontmatter
    fields = parse_frontmatter(fm_text)

    # Process tags: strip # prefix
    if "tags" in fields and fields["tags"]:
        tags = extract_tags_from_text(fields["tags"])
        # Strip # from tags
        tags = [tag.lstrip("#") for tag in tags]

        # Add literature-note tag if in Reading-Notes
        if "Reading-Notes" in str(file_path):
            if "literature-note" not in tags:
                tags.append("literature-note")

        fields["tags"] = format_tags(tags)
    else:
        # Initialize empty tags
        fields["tags"] = ""

    # Ensure status field exists
    if "status" not in fields or not fields.get("status", "").strip():
        fields["status"] = "active"

    # Process topic
    existing_topics = []
    if "topic" in fields and fields["topic"]:
        existing_topics = extract_list_from_text(fields["topic"])

    # Add topics from folder path
    path_topics = get_topic_from_path(file_path)
    for topic in path_topics:
        if topic not in existing_topics:
            existing_topics.append(topic)

    fields["topic"] = format_list(existing_topics)

    # Process project
    existing_projects = []
    if "project" in fields and fields["project"]:
        existing_projects = extract_list_from_text(fields["project"])

    # Add projects from folder path
    path_projects = get_project_from_path(file_path)
    for project in path_projects:
        if project not in existing_projects:
            existing_projects.append(project)

    fields["project"] = format_list(existing_projects)

    # Rebuild frontmatter
    new_fm = rebuild_frontmatter(fields)
    new_content = f"---\n{new_fm}\n---\n{body}"

    # Check if content changed
    if new_content == content:
        return False

    # Write updated content
    try:
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(new_content)
        return True
    except Exception as e:
        print(f"Error writing {file_path}: {e}")
        return False

def main():
    """Scan and fix all markdown files."""
    fixed_count = 0
    scanned_count = 0

    # Directories to scan
    scan_dirs = [
        BASE_PATH / "Resources",
        BASE_PATH / "Projects"
    ]

    for scan_dir in scan_dirs:
        if not scan_dir.exists():
            print(f"Directory not found: {scan_dir}")
            continue

        # Walk through all markdown files
        for root, dirs, files in os.walk(scan_dir):
            for file in sorted(files):
                # Skip .excalidraw.md files
                if file.endswith(".excalidraw.md"):
                    continue

                if file.endswith(".md"):
                    file_path = Path(root) / file
                    scanned_count += 1

                    if fix_file(file_path):
                        fixed_count += 1
                        print(f"✓ Fixed: {file_path.relative_to(BASE_PATH)}")

    print(f"\n{'='*60}")
    print(f"Total files scanned: {scanned_count}")
    print(f"Files modified: {fixed_count}")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()

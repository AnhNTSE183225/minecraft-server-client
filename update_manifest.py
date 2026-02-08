import os
import hashlib

# Directories to track
TRACK_DIRS = ["mods", "resourcepacks", "plugins"]
MANIFEST_FILE = "server_manifest.txt"

def get_file_hash(filepath):
    """Calculates short hash to track version changes."""
    hasher = hashlib.md5()
    with open(filepath, 'rb') as f:
        buf = f.read(65536)
        while len(buf) > 0:
            hasher.update(buf)
            buf = f.read(65536)
    return hasher.hexdigest()[:8] # First 8 chars is enough for versioning

def generate_manifest():
    lines = []
    for directory in TRACK_DIRS:
        if not os.path.exists(directory):
            continue
            
        lines.append(f"--- {directory} ---")
        files = sorted([f for f in os.listdir(directory) if f.endswith(('.jar', '.zip'))])
        
        for file in files:
            path = os.path.join(directory, file)
            file_hash = get_file_hash(path)
            lines.append(f"{file_hash} | {file}")
        lines.append("") # Empty line for spacing

    with open(MANIFEST_FILE, "w") as f:
        f.write("\n".join(lines))
    print(f"Updated {MANIFEST_FILE}")

if __name__ == "__main__":
    generate_manifest()
import os

def get_folder_size(path):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(path):
        for file in filenames:
            file_path = os.path.join(dirpath, file)
            if os.path.isfile(file_path):
                total_size += os.stat(file_path).st_size
    return total_size

def analyze_disk_usage(path):
    if not os.path.isdir(path):
        print("Invalid directory path.")
        return

    print(f"\nDisk Usage Report for: {path}\n")
    for item in os.listdir(path):
        item_path = os.path.join(path, item)
        if os.path.isdir(item_path):
            size_bytes = get_folder_size(item_path)
            size_mb = round(size_bytes / (1024 * 1024), 2)
            print(f"{item:<30} {size_mb:>10} MB")

# Example usage
analyze_disk_usage(r".")
import os

def organize_directory(path):
    if not os.path.isdir(path):
        print("Invalid directory path.")
        return

    for file in os.listdir(path):
        file_path = os.path.join(path, file)

        if os.path.isfile(file_path):
            ext = os.path.splitext(file)[1][1:]  
            target_folder = os.path.join(path, ext.upper())  

            os.makedirs(target_folder, exist_ok=True)
            new_path = os.path.join(target_folder, file)
            os.rename(file_path, new_path)

    print("Files organized successfully!")

# Example usage
organize_directory(r".")
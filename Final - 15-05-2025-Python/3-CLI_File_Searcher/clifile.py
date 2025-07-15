import os

def search_files(root_folder, search_term):
    matches = []
    for dirpath, dirnames, filenames in os.walk(root_folder):
        for filename in filenames:
            if search_term.lower() in filename.lower():
                full_path = os.path.join(dirpath, filename)
                matches.append(full_path)

    if matches:
        print(f"\n🔍 Found {len(matches)} matches for '{search_term}':\n")
        for match in matches:
            print(match)
    else:
        print(f"\n❌ No files found with '{search_term}' in {root_folder}")

# Example usage
search_files(r".", ".pdf")
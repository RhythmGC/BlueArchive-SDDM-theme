import os
import re
import urllib.request
import json

def fetch_data(url):
    req = urllib.request.Request(url)
    req.add_header("Accept", "application/vnd.github.v3+json")
    
    token = os.getenv("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"token {token}")
        
    try:
        with urllib.request.urlopen(req) as response:
            if response.status == 200:
                return json.loads(response.read().decode("utf-8"))
    except Exception as e:
        print(f"Failed to fetch {url}: {e}")
    return []

def generate_avatar_grid(users):
    if not users:
        return "<p align=\"left\">No stargazers or forkers yet. Be the first!</p>"
    
    html = "<p align=\"left\">\n"
    # We display up to 40 avatars
    for user in users[:40]:
        username = user.get("login")
        avatar_url = user.get("avatar_url")
        html += f'  <a href="https://github.com/{username}"><img src="{avatar_url}" width="40" height="40" style="border-radius: 50%; margin: 3px;" alt="{username}"/></a>\n'
    html += "</p>"
    return html

def main():
    repo = "RhythmGC/BlueArchive-SDDM-theme"
    
    # Fetch stargazers
    stargazers = fetch_data(f"https://api.github.com/repos/{repo}/stargazers")
    stargazers_html = generate_avatar_grid(stargazers)
    
    # Fetch forks
    forks_data = fetch_data(f"https://api.github.com/repos/{repo}/forks")
    forkers = [f["owner"] for f in forks_data if "owner" in f]
    forkers_html = generate_avatar_grid(forkers)
    
    # Read README
    readme_path = "README.md"
    if not os.path.exists(readme_path):
        readme_path = "../README.md"
        
    with open(readme_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Replace stargazers
    stargazers_pattern = r"(<!-- stargazers_start -->)(.*?)(<!-- stargazers_end -->)"
    content = re.sub(stargazers_pattern, f"\\1\n{stargazers_html}\n\\3", content, flags=re.DOTALL)
    
    # Replace forks
    forks_pattern = r"(<!-- forks_start -->)(.*?)(<!-- forks_end -->)"
    content = re.sub(forks_pattern, f"\\1\n{forkers_html}\n\\3", content, flags=re.DOTALL)
    
    # Write back
    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(content)

if __name__ == "__main__":
    main()

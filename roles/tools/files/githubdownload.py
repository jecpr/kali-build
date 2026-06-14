#!/usr/bin/env python3
# GitHub release downloader (based on Ippsec's script)

import argparse
import gzip
import json
import os
import re
import shutil
import sys
import tarfile
import urllib.request
import zipfile


def get_latest_release(repo):
    url = f"https://api.github.com/repos/{repo}/releases/latest"
    req = urllib.request.Request(url)
    req.add_header("Accept", "application/vnd.github.v3+json")
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode())


def download_asset(url, dest_dir):
    filename = url.split("/")[-1]
    dest_path = os.path.join(dest_dir, filename)
    print(f"Downloading {filename}...")
    urllib.request.urlretrieve(url, dest_path)
    return dest_path


def extract(filepath, dest_dir):
    if tarfile.is_tarfile(filepath):
        with tarfile.open(filepath) as tar:
            tar.extractall(dest_dir)
        os.remove(filepath)
    elif zipfile.is_zipfile(filepath):
        with zipfile.ZipFile(filepath) as zf:
            zf.extractall(dest_dir)
        os.remove(filepath)
    elif filepath.endswith(".gz"):
        out_path = filepath[:-3]
        with gzip.open(filepath, "rb") as f_in:
            with open(out_path, "wb") as f_out:
                shutil.copyfileobj(f_in, f_out)
        os.remove(filepath)
        os.chmod(out_path, 0o755)


def main():
    parser = argparse.ArgumentParser(description="Download latest GitHub release assets")
    parser.add_argument("repo", help="GitHub repo (owner/name)")
    parser.add_argument("pattern", help="Regex pattern to match asset names")
    parser.add_argument("-o", "--output", default=".", help="Output directory")
    args = parser.parse_args()

    os.makedirs(args.output, exist_ok=True)

    try:
        release = get_latest_release(args.repo)
    except Exception as e:
        print(f"Error fetching release for {args.repo}: {e}", file=sys.stderr)
        sys.exit(1)

    pattern = re.compile(args.pattern, re.IGNORECASE)
    matched = [a for a in release.get("assets", []) if pattern.search(a["name"])]

    if not matched:
        print(f"No assets matching '{args.pattern}' in {args.repo}", file=sys.stderr)
        sys.exit(1)

    for asset in matched:
        filepath = download_asset(asset["browser_download_url"], args.output)
        extract(filepath, args.output)

    print(f"Done: {len(matched)} asset(s) to {args.output}")


if __name__ == "__main__":
    main()

import argparse
import subprocess
import sys
from pathlib import Path

def run(cmd):
    print(f"\n$ {' '.join(cmd)}")
    subprocess.check_call(cmd)

if __name__ == "__main__":
    try:
        parser = argparse.ArgumentParser(description="Destroy Terraform stacks.")
        group = parser.add_mutually_exclusive_group()
        group.add_argument("--rg-only", action="store_true", help="Destroy only the resource group stack")
        group.add_argument("--databricks-only", action="store_true", help="Destroy only the Databricks stack")
        group.add_argument("--compute-only", action="store_true", help="Destroy only the Databricks compute stack")
        group.add_argument("--notebooks-only", action="store_true", help="Destroy only the notebooks stack")
        group.add_argument("--jobs-only", action="store_true", help="Destroy only the jobs stack")
        args = parser.parse_args()

        repo_root = Path(__file__).resolve().parent.parent
        rg_dir = repo_root / "terraform" / "01_resource_group"
        dbx_dir = repo_root / "terraform" / "02_databricks"
        compute_dir = repo_root / "terraform" / "03_databricks_compute"
        notebooks_dir = repo_root / "terraform" / "04_notebooks"
        jobs_dir = repo_root / "terraform" / "05_jobs"
        if args.rg_only:
            tf_dirs = [rg_dir]
        elif args.databricks_only:
            tf_dirs = [dbx_dir]
        elif args.compute_only:
            tf_dirs = [compute_dir]
        elif args.notebooks_only:
            tf_dirs = [notebooks_dir]
        elif args.jobs_only:
            tf_dirs = [jobs_dir]
        else:
            tf_dirs = [jobs_dir, notebooks_dir, compute_dir, dbx_dir, rg_dir]
        for tf_dir in tf_dirs:
            if not tf_dir.exists():
                raise FileNotFoundError(f"Missing Terraform dir: {tf_dir}")
            run(["terraform", f"-chdir={tf_dir}", "destroy", "-auto-approve"])
    except subprocess.CalledProcessError as exc:
        print(f"Command failed: {exc}")
        sys.exit(exc.returncode)

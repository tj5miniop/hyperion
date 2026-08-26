import time
import questionary
import os
import subprocess

def check_kernel_versioning():
    # Prompt user for kernel variant
    q_choice = questionary.select(
        "Which Kernel Variant would you like? - TODO - STANDARD KERNEL WILL ALSO SHOW OGC MODULES",
        choices=["OGC", "STANDARD"]
    ).ask()
    
    # Set kernel based on selection
    kernel = "ogc" if q_choice == "OGC" else "standard"
    
    print("This automatically assumes you want Fedora 44")
    fedora_version = "44"
    
    # Prompt user for kernel version
    kernel_version = questionary.select(
        "Which Kernel Version do you want?",
        choices=["7.0", "7.1", "7.2"]
    ).ask()
    
    # Build the command string
    cmd = (
        "skopeo list-tags docker://ghcr.io/ublue-os/akmods | "
        "jq -r '.Tags[]' | "
        f"grep {kernel} | "
        f"grep {fedora_version} | "
        f"grep {kernel_version}"
    )
    
    # Execute the command
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, check=True)
        print("Available tags matching your criteria:")
        print(result.stdout.strip())
    except subprocess.CalledProcessError as e:
        print(f"Command failed: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

def intro():
    print("Hello there! - this utility will help detect which kernel versions are available for your image")
    time.sleep(1)
    print("By the way, this tool will be repurposed and moved to a new repository when a suitable version is made")

if __name__ == "__main__":
    intro()
    check_kernel_versioning()